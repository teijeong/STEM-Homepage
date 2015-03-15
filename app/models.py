#-*-coding: utf-8 -*-
from app import db
import datetime
from sqlalchemy_utils import PasswordType

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.Integer)
    password = db.Column(PasswordType(
        schemes=['pbkdf2_sha512', 'md5_crypt'], deprecated=['md5_crypt']))
    nickname = db.Column(db.String(64), index=True, unique=True)
    email = db.Column(db.String(120), index=True, unique=True)
    posts = db.relationship('Post', backref='author', lazy='dynamic')
    session = db.Column(db.BigInteger)
    member = db.relationship('Member', uselist=False, backref='user', lazy='joined')

    def __init__(self, username, password, nickname, email):
        self.username = username
        self.password = password
        self.email = email
        self.nickname = nickname
        self.session = 0

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
    comment = db.Column(db.String(500))
    cv = db.Column(db.String(500))
    phone = db.Column(db.String(20))
    birthday = db.Column(db.Date)
    img = db.Column(db.String(256))

    def __init__(self, user):
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
    name = db.Column(db.String(100))
    shortName = db.Column(db.String(10))
    members =  db.relationship('Member', backref='department', lazy='dynamic')

class StemDepartment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(40))
    members =  db.relationship('Member', backref='stem_department', lazy='dynamic')

class Post(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    level = db.Column(db.Integer)
    title = db.Column(db.String(160))
    body = db.Column(db.String(2000))
    hitCount = db.Column(db.Integer)
    commentCount = db.Column(db.Integer)
    timestamp = db.Column(db.DateTime)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    board_id = db.Column(db.Integer, db.ForeignKey('board.id'))
    files = db.relationship('File', backref='post', lazy='joined')

    def __init__(self, level, title, body, userid, boardid):
        self.level = level
        self.title = title
        self.body = body
        self.user_id = userid
        self.board_id = boardid
        self.timestamp = datetime.datetime.now()
        self.hitCount = 0
        self.commentCount = 0

    def __repr__(self):
        return '<Post %r>' % (self.body)

class Board(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True)
    description = db.Column(db.String(200))
    posts = db.relationship('Post', backref='board', lazy='dynamic')

    def __init__(self, name, description):
        self.name = name
        self.description = description

class File(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(256))
    link = db.Column(db.String(1024))
    post_id = db.Column(db.Integer, db.ForeignKey('post.id'))

    def __init__(self, name, link, post):
        self.name = name
        self.link = link
        self.post = post