#-*-coding: utf-8 -*-
from app import app, api, db, models, lm
from flask import render_template, Response, redirect, url_for
from flask.ext.restful import Resource, reqparse, fields, marshal_with
from flask.ext.login import login_user, logout_user, current_user, login_required
from .forms import LoginForm, RegisterForm
import datetime


@lm.user_loader
def load_user(id):
    return models.User.query.get(int(id))

@app.route('/')
def main():
    #DB dummy
    bannerRec1 = [
        {'image':'main_img.gif'}, 
        {'image':'1.jpg'}, 
        {'image':'2.jpg'}, 
        {'image':u'교육기부박람회1.JPG'}]
    boardRec1 = [
        {'idx':42,'title':'TEST1','date':'2014-01-31','new':True},
        {'idx':43,'title':'TEST2','date':'2014-01-28','new':False},
        {'idx':44,'title':'TEST3','date':'2014-01-20','new':False},
        {'idx':45,'title':'TEST4','date':'2014-01-19','new':False},
        {'idx':46,'title':'TEST5','date':'2014-01-17','new':False}]
    boardRec2 = [
        {'idx':42,'title':'QnA1','date':'2014-01-31','new':True},
        {'idx':43,'title':'QnA2','date':'2014-01-30','new':True},
        {'idx':44,'title':'QnA3','date':'2014-01-20','new':False},
        {'idx':45,'title':'QnA4','date':'2014-01-19','new':False},
        {'idx':46,'title':'QnA5','date':'2014-01-17','new':False}]
    return render_template('main.html', bannerRec1=bannerRec1, boardRec1=boardRec1, boardRec2=boardRec2) 




@app.route('/sub/<string:sub>')
def showSub(sub):
    mNum = sub[0]
    sNum = sub[2]
    if mNum == '5':
        return showBoard(sub, 1)
    if mNum == '3':
        return redirect('/sub/3-1/1')
    return render_template('sub' + mNum + '_' + sNum + '.html',
        mNum=int(mNum), sNum=int(sNum), form=LoginForm())

@app.route('/sub/<string:sub>/<int:page>')
def showBoard(sub, page):
    mNum = sub[0]
    sNum = sub[2]

    if mNum == '5':
        pagenation = models.Post.query.filter_by(
            board_id=int(sNum)).order_by(
            models.Post.timestamp.desc()).paginate(
            page, per_page=10)

        
        return render_template('sub' + mNum + '_' + sNum + '.html',
                page=page,totalpage=pagenation.pages,
                posts=pagenation.items,
                mNum=int(mNum), sNum=int(sNum),
                form=LoginForm())

    elif mNum == '3':
        return showPeople(sub, page)

    return showSub(sub)

def showPeople(sub, page):
    mNum = sub[0]
    sNum = sub[2]

    yearRec = models.User.query.with_entities(models.User.cycle).distinct().all()
    yearRec = sorted([y[0] for y in yearRec])
    if not page in yearRec:
        page = yearRec[0]
    allRec = models.User.query.filter_by(cycle=page)
    return render_template('sub3_1.html',
        mNum=int(mNum), sNum=int(sNum), form=LoginForm(),
        yearRec=yearRec, allRec=allRec)

@app.route('/post/<int:id>/view')
def viewPost(id):
    post = models.Post.query.get(id)
    post.hitCount = post.hitCount + 1
    db.session.commit()
    return render_template('sub5_2.html',mNum=5, sNum=2,
        mode='view', post=post,
        form=LoginForm())

@app.route('/post/<int:id>/modify')
def modifyPost(id):
    board = {}
    user = {'id':1, 'name':'Fred'}
    post = {'id':32, 'title': 'test', 'name':'test', 'board':board, 'author':user, 'body':'test','date':'2015-02-14'}
    return render_template('sub5_2.html',mNum=5, sNum=2,
        mode='modify', post=post,
        form=LoginForm())

@app.route('/post/<int:id>/reply')
def replyPost(id):
    board = {}
    user = {'id':1, 'name':'Fred'}
    post = {'id':32, 'title': 'test', 'name':'test', 'board':board, 'author':user, 'body':'test','date':'2015-02-14'}
    return render_template('sub5_2.html',mNum=5, sNum=2,
        board=board, mode='reply', post=post,
        form=LoginForm())

@app.route('/login', methods=['GET','POST'])
def login():
    form = LoginForm()
    if form.validate_on_submit():
        login_user(form.user)
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

@app.route('/logout')
def logout():
    form = LoginForm()
    logout_user()
    return redirect('/')

class WritePost(Resource):
    def get(self):
        boardParser = reqparse.RequestParser()
        boardParser.add_argument('board', type=int, required=True)

        args = boardParser.parse_args()
        board = models.Board.query.get(args['board'])
        user = models.User.query.get(1)
        return Response(
            render_template('sub5_%d.html' % args['board'],
                mNum=5, sNum=args['board'], mode='write', board=board,
                form=LoginForm()),
            mimetype='text/html')
    
    def post(self):
        postParser = reqparse.RequestParser()
        postParser.add_argument('title', type=str)
        postParser.add_argument('body', type=str)
        postParser.add_argument('userID', type=int)
        postParser.add_argument('boardID', type=int)
        postParser.add_argument('level', type=int)

        args = postParser.parse_args()
        post = models.Post(
            args['level'], args['title'], args['body'], args['userID'], args['boardID'])
        db.session.add(post)
        db.session.commit()
        return Response(
            render_template('sub5_%d.html' % args['boardID'],
                mNum=5, sNum=args['boardID'],
                form=LoginForm()),
            mimetype='text/html')

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

api.add_resource(WritePost, '/post/write')
api.add_resource(IdCheck, '/member/register/idcheck')