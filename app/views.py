#-*-coding: utf-8 -*-
from app import app
from flask import render_template

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
        post = {'id':1,'title':'test','level':2,'commentCount':2,
            'isSecret':True,'isNew':True,'date':'2014-02-20','viewCount':4,
            'author':{'name':'Fred'}}
        return render_template('sub' + mNum + '_' + sNum + '.html',page=4,totalpage=15,posts=[post],Session={'useridx':1}, mNum=int(mNum), sNum=int(sNum))
    return render_template('sub' + mNum + '_' + sNum + '.html', Session={'useridx':1}, mNum=int(mNum), sNum=int(sNum))

@app.route('/test')
def test():
    lst = []
    for i in range(10):
        lst.append({'number':i, 'name': 'Item ' + str(i*3)})
    return render_template('test_one.html', items=lst)
"""
@app.route('/static/<path:path>')
def send_file(path):
    return send_from_directory('./static', path)
"""