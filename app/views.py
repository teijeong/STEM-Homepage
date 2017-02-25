#-*-coding: utf-8 -*-
from app import app, api, db, models, lm, mail
from flask import render_template, Response, redirect, url_for, request, abort, flash
from flask.ext.restful import Resource, reqparse, fields, marshal_with
from flask.ext.login import login_user, logout_user, current_user, \
    login_required, AnonymousUserMixin
from flask.ext.mobility.decorators import mobile_template, mobilized
from flask.ext.mail import Mail, Message
from .forms import LoginForm, RegisterForm, ModifyForm, ModifyMemberForm, \
    ResetForm, ResetPassword, FindIDForm, SearchForm, ts
from sqlalchemy import and_
import datetime
from app.helper import process_file
import pytz

admin_users = ['wwee3631', 'stem_admin']

class AnonymousUser(AnonymousUserMixin):
    def __init__(self):
        super().__init__()
        self.member = None

def send_email(to, subject, template, **kwargs):
	msg = Message(
		   subject,
		    sender=app.config['MAIL_DEFAULT_SENDER'],
		    recipients=[to])
	msg.html = template
	mail.send(msg)

lm.anonymous_user = AnonymousUser

@lm.user_loader
def load_user(id):
    return models.User.query.get(int(id))

@app.route('/')
@mobile_template('/{mobile/}main.html')
def main(template):
    bannerRec = db.session.query(models.Banner).order_by(models.Banner.id.desc()).all()

    board_ids = [1, 2, 4]

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
            db.session.query(models.Post)
                      .filter_by(board_id=bid)
                      .order_by(models.Post.timestamp.desc())
                      .limit(5).all())

    for rec in boardRec:
        for post in rec:
            now = datetime.datetime.utcnow()
            post.date = post.timestamp.strftime('%m.%d')
            if now - post.timestamp < datetime.timedelta(days=3):
                post.new = True

    return render_template(template,
                           bannerRec=bannerRec,
                           boardRec=boardRec,
                           boards=boards,
                           form=LoginForm())

@app.route('/reset', methods=["GET", "POST"])
def reset():
    form = ResetForm()
    if form.validate_on_submit():
        user = models.User.query.filter_by(email=form.email.data).first()
        if user is not None:
	        if (form.username.data == user.username) and (form.nickname.data == user.nickname):
		        subject = "Password reset requested"

		        token = ts.dumps(user.email, salt='recover-key')

		        recover_url = url_for(
		            'reset_with_token',
		            token=token,
		            _external=True)

		        html = render_template(
		            'member/recover.html',
		            recover_url=recover_url)

		        send_email(user.email, subject, html)

		        return render_template('reset_finish.html')
	        else:
	        	flash('해당하는 회원 정보가 존재하지 않습니다.')
	        	return redirect('/reset')
        else:
        	flash('해당하는 회원 정보가 존재하지 않습니다.')
        	return redirect('/reset')
    return render_template('reset.html', form=form)

@app.route('/findID', methods=["GET", "POST"])
def findid():
    form = FindIDForm()
    if form.validate_on_submit():
        user = models.User.query.filter_by(email=form.email.data).first()
        if user is not None:
	        if (form.nickname.data == user.nickname):
		        return render_template('findID_result.html', user=user)
	        else:
	        	flash('해당하는 회원 정보가 존재하지 않습니다.')
	        	return redirect('/findID')
        else:
        	flash('해당하는 회원 정보가 존재하지 않습니다.')
        	return redirect('/findID')    	
    return render_template('findID.html', form=form)

@app.route('/reset/<token>', methods=["GET", "POST"])
def reset_with_token(token):
    try:
        email = ts.loads(token, salt="recover-key", max_age=3600)
    except:
        abort(404)

    form = ResetPassword()

    if form.validate_on_submit():
        user = models.User.query.filter_by(email=email).first_or_404()

        user.password = form.password.data

        db.session.add(user)
        db.session.commit()

        return render_template('reset_finish.html')

    return render_template('reset_with_token.html', form=form, token=token)

@app.route('/m_login', methods=['GET', 'POST'])
def moblogin():
    form = LoginForm()
    if form.validate_on_submit():
        login_user(form.user)
        if current_user.member:
            if current_user.member.cycle:
                return redirect('/stem')
            else:
                return redirect('/member/modify')
        else:
            return redirect('/')

    return render_template('/member/mlogin.html', form=form)

@app.route('/vm_confirm')
def vmConfirm():
    key = request.args.get('key')
    if not key:
        abort(404)
    if not current_user.member:
        return render_template('vm.html', form=LoginForm())
    return render_template('vm_confirm.html', form=LoginForm(), key=key)

@app.route('/apply')
def stemApply():
    fout = open('apply_log.log', 'a+')
    fout.write('Page viewed on ' + datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S') + '\n')
    if datetime.datetime.now() < datetime.datetime(2016,3,10):
        display = 1
    else:
        display = 2
    fout.close()
    return render_template('apply.html', form=LoginForm(), display=display)

@app.route('/sub/<string:sub>')
def showSub(sub):
    mNum = sub[0]
    sNum = sub[2]
    if mNum == '5':
        return redirect('/sub/' + sub + '/1') # showBoard(sub, 1)
    elif mNum == '2' and sNum == '5':
        year = datetime.date.today().year
        return redirect('/sub/2-5/%d' % year)
    if request.MOBILE == False:
        return render_template('sub' + mNum + '_' + sNum + '.html',
                               mNum=int(mNum),
                               sNum=int(sNum),
                               form=LoginForm())
    else:
        return render_template('mobile/sub' + mNum + '_' + sNum + '.html',
                               mNum=int(mNum),
                               sNum=int(sNum),
                               form=LoginForm())

@app.route('/sub/<string:sub>/<int:page>', methods=['GET', 'POST'])
def showBoard(sub, page):
    mNum = sub[0]
    sNum = sub[2]
    searchform = SearchForm()
    if mNum == '5':
        # member board
        if sNum == '5' and not current_user.member:
            abort(404)

        if sNum == '3':
            abort(404)

        pagenation = models.Post.query.filter_by(
            board_id=int(sNum)).order_by(models.Post.timestamp.desc()) \
                               .paginate(page, per_page=10)

        if not searchform.searchstr.data == '':
            if searchform.search.data == 'title':
                pagenation = models.Post.query.filter(
                    and_(models.Post.board_id == int(sNum), models.Post.title.contains(searchform.searchstr.data))) \
                    .order_by(models.Post.timestamp.desc()).paginate(page, per_page=10)
            if searchform.search.data == 'writer':
                user_id = models.User.query.filter(models.User.nickname == searchform.searchstr.data).first()
                if not user_id is None:
                    user_id = user_id.id
                else:
                    user_id = '-1'
                pagenation = models.Post.query.filter(
                    and_(models.Post.board_id == int(sNum), models.Post.user_id == user_id)) \
                    .order_by(models.Post.timestamp.desc()).paginate(page, per_page=10)
            if searchform.search.data == 'content':
                pagenation = models.Post.query.filter(
                    and_(models.Post.board_id == int(sNum), models.Post.body.contains(searchform.searchstr.data))) \
                    .order_by(models.Post.timestamp.desc()).paginate(page, per_page=10)

        board = models.Board.query.get(int(sNum))

        if not board:
            abort(404)

        if request.MOBILE == False:
            return render_template('sub' + mNum + '.html',
                                   page=page, totalpage=pagenation.pages,
                                   posts=pagenation.items, board=board,
                                   mNum=int(mNum), sNum=int(sNum),
                                   form=LoginForm(), searchform=searchform)
        else:
            return render_template('/mobile/sub' + mNum + '.html',
                                   page=page, totalpage=pagenation.pages,
                                   posts=pagenation.items, board=board,
                                   mNum=int(mNum), sNum=int(sNum),
                                   form=LoginForm(), searchform=searchform)

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
    start = datetime.datetime(page, 1, 1, tzinfo=pytz.utc)
    end = datetime.datetime(page, 12, 31, tzinfo=pytz.utc)
    allRec = db.session.query(models.Post) \
                       .filter(and_(models.Post.timestamp.between(start, end),
                               models.Post.board_id == 3)) \
                       .order_by(models.Post.timestamp).all()

    for post in allRec:
        post.period = post.timestamp.strftime('%m.%d')
        if post.body and post.body != '':
            endDate = datetime.datetime.utcfromtimestamp(float(post.body))
            post.period = post.period + ' ~ ' + endDate.strftime('%m.%d')

    if request.MOBILE == False:
        return render_template('sub2_5.html',
                               mNum=int(mNum), sNum=int(sNum), form=LoginForm(),
                               years=yearRec, page=page, history=allRec)
    else:
        return render_template('mobile/sub2_5.html',
                               mNum=int(mNum), sNum=int(sNum), form=LoginForm(),
                               years=yearRec, page=page, history=allRec)


@app.route('/post/<int:id>')
@app.route('/post/<int:id>/view')
def viewPost(id):
    post = models.Post.query.get(id)
    if not post or not post.board:
        return abort(404)
    if post.board_id == 5 and not current_user.member:
        return abort(404)
    if post.level == 2:
        if current_user.is_anonymous():
            return abort(403)
        elif not ((current_user.id == post.user_id) or (current_user.username in admin_users)):
            return abort(403)
    post.hitCount = post.hitCount + 1
    board = models.Board.query.get(post.board_id)
    db.session.commit()
    prev = models.Post.query.filter(
        and_(models.Post.id < id, models.Post.board_id == post.board_id)). \
        order_by(models.Post.timestamp.desc()).first()
    next = models.Post.query.filter(
        and_(models.Post.id > id, models.Post.board_id == post.board_id)). \
        order_by(models.Post.timestamp.asc()).first()

    if request.MOBILE == False:
        return render_template('sub5.html', mNum=5, sNum=post.board_id,
                               mode='view', post=post, board=board, prev=prev,
                               next=next, form=LoginForm())
    else:
        return render_template('mobile/sub5.html', mNum=5, sNum=post.board_id,
                               mode='view', post=post, board=board, prev=prev,
                               next=next, form=LoginForm())

#Not implemented: block for security reason
"""
@app.route('/post/<int:id>/reply')
def replyPost(id):
    board = {}
    post = models.Post.query.get(id)
    if not post:
        return abort(404)
    if post.board_id == 5 and not current_user.member:
        return abort(404)
    return render_template('sub5.html', mNum=5, sNum=post.board_id,
                           board=board, mode='reply', post=post,
                           form=LoginForm())
"""

@app.route('/login', methods=['GET', 'POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        login_user(form.user)
        if current_user.member:
            if current_user.member.cycle:
                return redirect('/stem')
            else:
                return redirect('/member/modify')
        return redirect('/')

    return render_template('member/login.html', form=form)


@app.route('/member/register', methods=['GET', 'POST'])
def register():
    if not current_user.is_anonymous():
        return abort(403)

    registerform = RegisterForm()
    form = LoginForm()
    if registerform.validate_on_submit():
        login_user(registerform.user)
        return redirect('/')
    else:
        if request.MOBILE == False:
            return render_template('member/register.html', registerform=form,
                form=form)
        else:
            return render_template('mobile/member/register.html', registerform=form,
                form=form)


@app.route('/member/modify', methods=['GET', 'POST'])
@mobile_template('/{mobile/}member/modify.html')
@login_required
def modify(template):
    if current_user.member:
        form = ModifyMemberForm()
        departments = models.Department.query.all()
        stem_departments = models.StemDepartment.query.all()
        if form.validate_on_submit():
            return render_template(
                template, form=form,
                departments=departments, stem_departments=stem_departments,
                message='수정이 완료되었습니다.')
        return render_template(
            template, form=form,
            departments=departments,
            stem_departments=stem_departments)
    else:
        form = ModifyForm()
        if form.validate_on_submit():
            return render_template(
                template, form=form,
                message='수정이 완료되었습니다.')
        return render_template(template, form=form)

@app.route('/stem/')
def stem():
	pass

@app.route('/logout')
def logout():
    form = LoginForm()
    u = request.referrer
    host = request.host
    if (u == ('http://' + host + url_for('stem'))) or (u ==('https://' + host + url_for('stem'))):
        logout_user()
        return redirect('/m_login')
    else:
        logout_user()
        return redirect('/')




@app.errorhandler(401)
def unauthorized(e):
    return redirect('/login')


@app.errorhandler(403)
def forbidden(e):
    return render_template('403.html', form=LoginForm()), 403


@app.errorhandler(404)
def not_found(e):
    return render_template('404.html', form=LoginForm()), 404

@app.route('/notfound')
def not_found2():
    return render_template('404.html', form=LoginForm()), 404



class WritePost(Resource):
    @login_required
    def get(self):
        boardParser = reqparse.RequestParser()
        boardParser.add_argument('board', type=int, required=True)
        args = boardParser.parse_args()
        board = models.Board.query.get(args['board'])
        if not board:
            return abort(404)
        if board.id == 1 and not current_user.username in admin_users:
            return abort(403)
        if board.id == 3:
            return abort(403)
        if board.id == 5 and not current_user.member:
            return abort(403)

        if request.MOBILE == False:
            return Response(
                render_template('sub5.html', mNum=5, sNum=args['board'],
                                mode='write', board=board, form=LoginForm()),
                mimetype='text/html')
        else:
            return Response(
                render_template('mobile/sub5.html', mNum=5, sNum=args['board'],
                                mode='write', board=board, form=LoginForm()),
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
            return abort(404)
        if board.id == 5 and not current_user.member:
            return abort(403)

#        print (args)

        post = models.Post(
            args['level'], args['title'], args['body'], current_user.id,#
            args['boardID'])
        db.session.add(post)

        files = request.files.getlist("files")

        for file in files:
            process_file(file, post)

        db.session.commit()

        return redirect('/sub/5-%d' % args['boardID'])


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
                render_template('403.html', form=LoginForm()),
                mimetype='text/html', status=403)

        if request.MOBILE == False:
            return Response(
                render_template('sub5.html', mNum=5, sNum=post.board_id,
                                mode='modify', post=post,
                                board=models.Board.query.get(post.board_id),
                                form=LoginForm()),
                mimetype='text/html')
        else:
            return Response(
                render_template('mobile/sub5.html', mNum=5, sNum=post.board_id,
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
                render_template('sub5_%d.html' % post.board_id, mNum=5,
                                sNum=post.board_id, mode='view', post=post,
                                board=models.Board.query.get(post.board_id),
                                form=LoginForm()),
                mimetype='text/html')

        post.title = args['title']
        post.body = args['body']

        files = request.files.getlist("files")

        for file in files:
            process_file(file, post)

        db.session.commit()

        if request.MOBILE == False:
            return Response(
                render_template('sub5.html', mNum=5, sNum=post.board_id,
                                mode='view', post=post,
                                board=models.Board.query.get(post.board_id),
                                form=LoginForm()),
                mimetype='text/html')
        else:
            return Response(
                render_template('mobile/sub5.html', mNum=5, sNum=post.board_id,
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
            return {'duplicate': True}
        else:
            return {'duplicate': False}

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
    'social': fields.String
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
        people = db.session.query(models.Member) \
                           .join(models.Member.user) \
                           .filter(models.Member.cycle != 0) \
                           .order_by(models.Member.cycle.desc()) \
                           .order_by(models.User.nickname).all()

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
