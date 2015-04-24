#-*-coding: utf-8 -*-
from app import db
import datetime
from sqlalchemy_utils import PasswordType

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64))
    password = db.Column(PasswordType(
        schemes=['pbkdf2_sha512', 'md5_crypt'], deprecated=['md5_crypt']))
    nickname = db.Column(db.Unicode(64), index=True, unique=True)
    email = db.Column(db.String(120), index=True, unique=True)
    posts = db.relationship('Post', backref='author', lazy='dynamic')
    member = db.relationship('Member', uselist=False, backref='user', lazy='joined')

    def __init__(self, username='', password='123456', nickname='', email=''):
        self.username = username
        self.password = password
        self.email = email
        self.nickname = nickname

    def __repr__(self):
        return '<User %r>' % self.nickname

    def is_authenticated(self):
        return True

    def is_active(self):
        return True

    def is_anonymous(self):
        return False

    def get_id(self):
        try:
            return unicode(self.id)
        except NameError:
            return str(self.id)

class Member(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    cycle = db.Column(db.Integer)
    dept_id = db.Column(db.Integer, db.ForeignKey('department.id'))
    stem_dept_id = db.Column(db.Integer, db.ForeignKey('stem_department.id'))
    comment = db.Column(db.Unicode(500))
    cv = db.Column(db.Unicode(500))
    phone = db.Column(db.String(20))
    birthday = db.Column(db.Date)
    img = db.Column(db.Unicode(256))

    def __repr__(self):
        return '<Member %d>' % self.id

    def __init__(self, user=None):
        self.user = user
        self.cycle = 0
        self.dept_id = None
        self.stem_dept_id = None
        self.comment = ""
        self.cv = ""
        self.phone = ""
        self.birthday = datetime.date(1993, 1, 1)
        self.img = ""

class Department(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Unicode(100))
    shortName = db.Column(db.Unicode(10))
    members =  db.relationship('Member', backref='department', lazy='dynamic')

    def __repr__(self):
        return '<D %r>' % self.name

class StemDepartment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Unicode(40))
    members =  db.relationship('Member', backref='stem_department', lazy='dynamic')

    def __repr__(self):
        return '<SD %r>' % self.name

class Post(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    level = db.Column(db.Integer)
    title = db.Column(db.Unicode(160))
    body = db.Column(db.Unicode(2000))
    hitCount = db.Column(db.Integer)
    commentCount = db.Column(db.Integer)
    timestamp = db.Column(db.DateTime)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    board_id = db.Column(db.Integer, db.ForeignKey('board.id'))
    files = db.relationship('File', backref='post', lazy='joined')

    def __init__(self, level=0, title='', body='', userid=0, boardid=0):
        self.level = level
        self.title = title
        self.body = body
        self.user_id = userid
        self.board_id = boardid
        self.timestamp = datetime.datetime.now()
        self.hitCount = 0
        self.commentCount = 0

    def __repr__(self):
        if board_id == 3:
            return '<History %r>' % self.title
        return '<Post %r>' % self.title

    @classmethod
    def historyPost(self, title, startDate, endDate = None):
        post = Post(0, title, '', None, 3)
        timezero = datetime.time(tzinfo=datetime.timezone.utc)
        post.timestamp = datetime.datetime.combine(startDate, timezero)
        if (endDate):
            endtime = datetime.datetime.combine(endDate, timezero)
            post.body = str(endtime.timestamp())

        return post

    def __repr__(self):
        return '<Post %r>' % (self.body)

class Board(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Unicode(80), unique=True)
    description = db.Column(db.Unicode(200))
    posts = db.relationship('Post', backref='board', lazy='dynamic')

    def __init__(self, name, description):
        self.name = name
        self.description = description

    def __repr__(self):
        return '<Board %r>' % self.name

class File(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Unicode(256))
    link = db.Column(db.Unicode(1024))
    post_id = db.Column(db.Integer, db.ForeignKey('post.id'))

    def __repr__(self):
        return '<File %r>' % self.name

    def __init__(self, name, link, post):
        self.name = name
        self.link = link
        self.post = post