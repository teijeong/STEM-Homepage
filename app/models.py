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
    posts = db.relationship('Post', backref='author', lazy='joined')
    session = db.Column(db.BigInteger)
    cycle = db.Column(db.Integer)

    def __init__(self, username, password, nickname, cycle, email):
        self.username = username
        self.password = password
        self.email = email
        self.nickname = nickname
        self.cycle = cycle
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
        self. timestamp = datetime.datetime.now()
        self.hitCount = 0
        self.commentCount = 0

    def __repr__(self):
        return '<Post %r>' % (self.body)

class Board(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(80), unique=True)
    description = db.Column(db.String(200))
    posts = db.relationship('Post', backref='board', lazy='joined')

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