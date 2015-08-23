#-*-coding: utf-8 -*-
from app import app, api, db, models, lm
from flask import render_template, Response, redirect, url_for, request, abort
from flask.ext.restful import Resource, reqparse, fields, marshal_with
from flask.ext.login import login_user, logout_user, current_user, login_required, AnonymousUserMixin
from .forms import LoginForm, RegisterForm, ModifyForm, ModifyMemberForm
from sqlalchemy import and_
import datetime
from app.helper import process_file
import pytz

class AnymousUser(AnonymousUserMixin):
    def __init__(self):
        super().__init__()
        self.member = None

lm.anonymous_user = AnymousUser

@lm.user_loader
def load_user(id):
    return models.User.query.get(int(id))

@app.route('/')
def main():
    bannerRec = db.session.query(models.Banner).all()

    board_ids = [1,2,4]
    if current_user.member:
        board_ids.append(5)
    boardRec = list()
    boards = list()

    for bid in board_ids:
        board = models.Board.query.get(bid)
        if not board:
            continue
        boards.append(board)
        boardRec.append(
            db.session.query(models.Post).filter_by(
                board_id=bid).order_by(models.Post.timestamp.desc()).limit(5).all())


    for rec in boardRec:
        for post in rec:
            now = datetime.datetime.utcnow()
            post.date = post.timestamp.strftime('%m.%d')
            if now - post.timestamp < datetime.timedelta(days=3):
                post.new = True

    return render_template('main.html',
        bannerRec=bannerRec, boardRec=boardRec, boards=boards,
        form=LoginForm())

@app.route('/sub/<string:sub>')
def showSub(sub):
    mNum = sub[0]
    sNum = sub[2]
    if mNum == '5':
        return showBoard(sub, 1)
    elif mNum == '2' and sNum == '5':
        year = datetime.date.today().year
        return redirect('/sub/2-5/%d' % year)
    return render_template('sub' + mNum + '_' + sNum + '.html',
        mNum=int(mNum), sNum=int(sNum), form=LoginForm())

@app.route('/sub/<string:sub>/<int:page>')
def showBoard(sub, page):
    mNum = sub[0]
    sNum = sub[2]

    if mNum == '5':
        # member board
        if sNum == '5' and not current_user.member:
            abort(404)
        pagenation = models.Post.query.filter_by(
            board_id=int(sNum)).order_by(
            models.Post.timestamp.desc()).paginate(
            page, per_page=10)
        board = models.Board.query.get(int(sNum))

        if not board:
            abort(404)
        
        return render_template('sub' + mNum + '.html',
                page=page,totalpage=pagenation.pages,
                posts=pagenation.items, board=board,
                mNum=int(mNum), sNum=int(sNum),
                form=LoginForm())

    elif mNum == '2' and sNum == '5':
        return showHistory(sub, page)

    return showSub(sub)

def showHistory(sub, page):
    mNum = sub[0]
    sNum = sub[2]

    year = datetime.date.today().year
    yearRec = [n for n in range(2010, datetime.date.today().year + 1)]
    if not page in yearRec:
        page = year
    start = datetime.datetime(page, 1, 1, tzinfo = pytz.utc)
    end = datetime.datetime(page, 12, 31, tzinfo = pytz.utc)
    allRec = db.session.query(models.Post).filter(
        and_(models.Post.timestamp.between(start, end),
            models.Post.board_id == 3
            )).order_by(models.Post.timestamp).all()

    for post in allRec:
        post.period = post.timestamp.strftime('%m.%d')
        if post.body and post.body != '':
            endDate = datetime.datetime.utcfromtimestamp(float(post.body))
            post.period = post.period + ' ~ ' + endDate.strftime('%m.%d')

    return render_template('sub2_5.html',
        mNum=int(mNum), sNum=int(sNum), form=LoginForm(),
        years=yearRec, page=page, history=allRec)

@app.route('/post/<int:id>/view')
def viewPost(id):
    post = models.Post.query.get(id)
    if not post:
        return abort(404)
    if post.board_id == 5 and not current_user.member:
        return abort(404)
    post.hitCount = post.hitCount + 1
    board = models.Board.query.get(post.board_id)
    db.session.commit()
    prev = models.Post.query.filter(
        and_(models.Post.id < id, models.Post.board_id == post.board_id)). \
        order_by(models.Post.timestamp.desc()).first()
    next = models.Post.query.filter(
        and_(models.Post.id > id, models.Post.board_id == post.board_id)). \
        order_by(models.Post.timestamp.asc()).first()
    return render_template('sub5.html', mNum=5, sNum=post.board_id,
        mode='view', post=post, board=board, prev=prev, next=next,
        form=LoginForm())



@app.route('/post/<int:id>/reply')
def replyPost(id):
    board = {}
    post = models.Post.query.get(id)
    if not post:
        return abort(404)
    if post.board_id == 5 and not current_user.member:
        return abort(404)
    return render_template('sub5.html',mNum=5, sNum=post.board_id,
        board=board, mode='reply', post=post,
        form=LoginForm())

@app.route('/login', methods=['GET','POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        login_user(form.user)
        if current_user.member:
            if current_user.member.cycle:
                return redirect('/stem')
            else:
                return redirect('/member/modify')
        return redirect(form.next.data)

    return render_template('member/login.html', form=form)

@app.route('/member/register', methods=['GET', 'POST'])
def register():
    form = RegisterForm()
    if form.validate_on_submit():
        login_user(form.user)
        return redirect('/')
    else:
        return render_template('member/register.html', form=form)



@app.route('/member/modify', methods=['GET', 'POST'])
@login_required
def modify():
    if current_user.member:
        form = ModifyMemberForm()
        if form.validate_on_submit():
            return form.redirect()
        departments = models.Department.query.all()
        stem_departments = models.StemDepartment.query.all()
        return render_template('member/modify.html', form=form,
            departments=departments, stem_departments=stem_departments)
    else:
        form = ModifyForm()
        if form.validate_on_submit():
            return form.redirect('/')
        return render_template('member/modify.html', form=form)

@app.route('/logout')
def logout():
    form = LoginForm()
    logout_user()
    return redirect('/')

@app.errorhandler(401)
def unauthorized(e):
    return redirect('/login')

@app.errorhandler(403)
def forbidden(e):
    return render_template('403.html', form=LoginForm()), 403

@app.errorhandler(404)
def unauthorized(e):
    return render_template('404.html', form=LoginForm()), 404

class WritePost(Resource):
    @login_required
    def get(self):
        boardParser = reqparse.RequestParser()
        boardParser.add_argument('board', type=int, required=True)

        args = boardParser.parse_args()
        board = models.Board.query.get(args['board'])
        if not board:
            return abort(400)
        if board.id == 5 and not current_user.member:
            return abort(400)

        return Response(
            render_template('sub5.html',
                mNum=5, sNum=args['board'], mode='write', board=board,
                form=LoginForm()),
            mimetype='text/html')
 
    @login_required
    def post(self):
        postParser = reqparse.RequestParser()
        postParser.add_argument('title', type=str)
        postParser.add_argument('body', type=str)
        postParser.add_argument('boardID', type=int)
        postParser.add_argument('level', type=int)

        args = postParser.parse_args()
        board = models.Board.query.get(args['boardID'])
        if not board:
            return abort(400)
        if board.id == 5 and not current_user.member:
            return abort(403)

        print (args)


        post = models.Post(
            args['level'], args['title'], args['body'], current_user.id, args['boardID'])
        db.session.add(post)

        files = request.files.getlist("files")

        for file in files:
            process_file(file, post)

        db.session.commit()
        return redirect('/sub/5-%d'%args['boardID'])

class ModifyPost(Resource):
    @login_required
    def get(self, id):
        post = models.Post.query.get(id)

        if not post:
            return abort(404)

        if post.board_id == 5 and not current_user.member:
            return abort(403)

        if current_user.id != post.user_id:
            return Response(
                render_template('sub5.html', mNum=5, sNum=post.board_id,
                    mode='view', post=post,
                    board=models.Board.query.get(post.board_id),
                    form=LoginForm()),
                mimetype='text/html')

        return Response(
            render_template('sub5.html', mNum=5, sNum=post.board_id,
                mode='modify', post=post,
                board=models.Board.query.get(post.board_id),
                form=LoginForm()),
            mimetype='text/html')

    @login_required
    def post(self, id):
        postParser = reqparse.RequestParser()
        postParser.add_argument('title', type=str)
        postParser.add_argument('body', type=str)

        args = postParser.parse_args()
        post = models.Post.query.get(id)

        if not post:
            return abort(404)
            
        if post.board_id == 5 and not current_user.member:
            return abort(403)

        if current_user.id != post.user_id:
            return Response(
                render_template('sub5_%d.html' % post.board_id, mNum=5, sNum=post.board_id,
                    mode='view', post=post,
                    board=models.Board.query.get(post.board_id),
                    form=LoginForm()),
                mimetype='text/html')

        post.title = args['title']
        post.body = args['body']
        db.session.commit()

        return Response(
            render_template('sub5.html', mNum=5, sNum=post.board_id,
                mode='view', post=post,
                board=models.Board.query.get(post.board_id),
                form=LoginForm()),
            mimetype='text/html')

class DeletePost(Resource):
    @login_required
    def post(self, id):
        post = models.Post.query.get(id)
        if current_user.id != post.user_id:
            return "Not Allowed", 403

        db.session.delete(post)
        db.session.commit()
        return "Success", 200

user_fields = {
    'nickname': fields.String,
    'username': fields.String,
    'email': fields.String
}

comment_fields = {
    'id': fields.Integer,
    'author': fields.Nested(user_fields),
    'body': fields.String,
    'timestamp': fields.DateTime
}

class Comment(Resource):

    @marshal_with(comment_fields)
    def get(self, commentID):
        comment = models.Comment.query.get(commentID)
        if comment:
            return comment
        return None, 404

    @login_required
    @marshal_with(comment_fields)
    def post(self):
        commentParser = reqparse.RequestParser()
        commentParser.add_argument('body', type=str)
        commentParser.add_argument('userID', type=int)
        commentParser.add_argument('postID', type=int)

        args = commentParser.parse_args()
        post = models.Post.query.get(args['postID'])
        if not post:
            return None, 404
        comment = models.Comment(
            args['body'], args['userID'], args['postID'])

        db.session.add(comment)
        db.session.commit()

        return comment, 201

    @login_required
    def delete(self, id):
        comment = models.Comment.query.get(id)
        if comment:
            if current_user == comment.author:
                comment.remove()
                return True, 200
            else:
                return False, 401
        else:
            return None, 404

class IdCheck(Resource):
    def post(self):
        idparser = reqparse.RequestParser()
        idparser.add_argument('userid', type=str)

        args = idparser.parse_args()
        user = models.User.query.filter_by(username=args['userid']).first()
        if user is not None:
            return {'duplicate':True}
        else:
            return {'duplicate':False}

member_fields = {
    'id': fields.Integer,
    'cycle': fields.Integer,
    'stem_dept': fields.String,
    'dept': fields.String,
    'cv': fields.String,
    'comment': fields.String,
    'img': fields.String,
    'cover': fields.String,
    'addr': fields.String,
    'phone': fields.String,
    'birthday': fields.String,
    'user': fields.Nested(user_fields),
    'social' :fields.String
}

restricted_user_fields = {
    'nickname': fields.String
}

restricted_member_fields = {
    'id': fields.Integer,
    'cycle': fields.Integer,
    'stem_dept': fields.String,
    'dept': fields.String,
    'cv': fields.String,
    'img': fields.String,
    'cover': fields.String,
    'user': fields.Nested(restricted_user_fields)
}

class Members(Resource):
    @marshal_with(member_fields)
    def full_get(self, people):
        return people

    @marshal_with(restricted_member_fields)
    def restricted_get(self, people):
        return people

    def get(self):
        people = db.session.query(models.Member). \
            join(models.Member.user).filter(models.Member.cycle != 0). \
            order_by(models.Member.cycle.desc()). \
            order_by(models.User.nickname).all()
        for person in people:
            if person.stem_department:
                person.stem_dept = person.stem_department.name
            if person.department:
                person.dept = person.department.name

        if not current_user.is_anonymous() and current_user.member:
            return self.full_get(people)
        return self.restricted_get(people)

api.add_resource(Members, '/people')
api.add_resource(WritePost, '/post/write')
api.add_resource(ModifyPost, '/post/<int:id>/modify')
api.add_resource(DeletePost, '/post/<int:id>/delete')
api.add_resource(Comment, '/post/comment', '/post/comment/<int:id>')
api.add_resource(IdCheck, '/member/register/idcheck')
