#-*-coding: utf-8 -*-
from app import db
import datetime
from sqlalchemy_utils import PasswordType

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), unique=True)
    password = db.Column(PasswordType(
        schemes=['pbkdf2_sha512', 'md5_crypt'], deprecated=['md5_crypt']))
    nickname = db.Column(db.Unicode(64), index=True)
    email = db.Column(db.String(120), index=True, unique=True)
    posts = db.relationship('Post', backref='author', lazy='dynamic')
    member = db.relationship('Member', uselist=False, backref='user', lazy='joined')

    def __init__(self, username='', password='123456', nickname='', email=''):
        self.username = username
        self.password = password
        self.email = email
        self.nickname = nickname
        self.member = None

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
    cover = db.Column(db.Unicode(256))
    addr = db.Column(db.Unicode(512))
    social = db.Column(db.Unicode(256))
    owned_milestone = db.relationship('Milestone', backref='creator', lazy='dynamic')
    owned_issue = db.relationship('Issue', backref='creator', lazy='dynamic')
    owned_subtask = db.relationship('Subtask', backref='creator', lazy='dynamic')

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
        self.birthday = datetime.date(1994, 1, 1)
        self.img = ""
        self.cover = ""
        self.addr = ""
        self.social = ""

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
        if self.board_id == 3:
            return '<History %r>' % self.title
        return '<Post %r>' % self.title

    @classmethod
    def historyPost(self, title, startDate, endDate = None):
        post = Post(0, title, '', None, 3)
        timezero = datetime.time(tzinfo=datetime.timezone.utc)
        post.timestamp = datetime.datetime.combine(startDate, timezero)
        if endDate and endDate != startDate:
            endtime = datetime.datetime.combine(endDate, timezero)
            post.body = str(endtime.timestamp())

        return post

class Board(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Unicode(80), unique=True)
    description = db.Column(db.Unicode(200))
    posts = db.relationship('Post', backref='board', lazy='dynamic')

    def __init__(self, name='', description=''):
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

    def __init__(self, name='', link='', post=None):
        self.name = name
        self.link = link
        self.post = post

class Banner(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    src = db.Column(db.Unicode(512))
    href = db.Column(db.Unicode(512))
    description = db.Column(db.Unicode(1024))

    def __repr__(self):
        return '<Banner %r -> %r>' % (self.description, self.href)

    def __init__(self, src='', href='', description=''):
        self.src = src
        self.href = href
        self.description = description

milestone_issue_table = db.Table('issues',
    db.Column('milestone_id', db.Integer, db.ForeignKey('milestone.id')),
    db.Column('issue_id', db.Integer, db.ForeignKey('issue.id'))
)

milestone_member_table = db.Table('milestone_users',
    db.Column('milestone_id', db.Integer, db.ForeignKey('milestone.id')),
    db.Column('member_id', db.Integer, db.ForeignKey('member.id'))
)


issue_member_table = db.Table('issue_users',
    db.Column('issue_id', db.Integer, db.ForeignKey('issue.id')),
    db.Column('member_id', db.Integer, db.ForeignKey('member.id'))
)


subtask_member_table = db.Table('subtask_users',
    db.Column('subtask_id', db.Integer, db.ForeignKey('subtask.id')),
    db.Column('member_id', db.Integer, db.ForeignKey('member.id'))
)

class Milestone(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Unicode(256))
    description = db.Column(db.Unicode(2048))
    issues = db.relationship('Issue', secondary=milestone_issue_table,
        backref=db.backref('milestones', lazy='dynamic'))
    contributors = db.relationship('Member', secondary=milestone_member_table,
        backref=db.backref('milestones', lazy='dynamic'))
    progress = db.Column(db.Integer)
    creator_id = db.Column(db.Integer, db.ForeignKey('member.id'))

    def __init__(self, name='', description='', creator=None):
        self.name = name
        self.description = description
        self.progress = 0
        self.creator = creator

    def __repr__(self):
        return '<M#%r %r / %r%%>' % (self.id, self.name, self.progress / 100.0)

class Issue(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Unicode(256))
    description = db.Column(db.Unicode(2048))
    subtasks = db.relationship('Subtask', backref='issue', lazy='dynamic')
    progress = db.Column(db.Integer)
    comments = db.relationship('IssueComment', backref='issue', lazy='dynamic')
    contributors = db.relationship('Member', secondary=issue_member_table,
        backref=db.backref('issues', lazy='dynamic'))
    creator_id = db.Column(db.Integer, db.ForeignKey('member.id'))

    def __init__(self, name='', description='', creator=None):
        self.name = name
        self.description = description
        self.progress = 0
        self.creator = creator

    def __repr__(self):
        return '<#%r %r / %r%%>' % (self.id, self.name, self.progress / 100.0)

class Subtask(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.Unicode(256))
    description = db.Column(db.Unicode(2048))
    issue_id = db.Column(db.Integer, db.ForeignKey('issue.id'))
    progress = db.Column(db.Integer)
    contributors = db.relationship('Member', secondary=subtask_member_table,
        backref=db.backref('subtasks', lazy='dynamic'))
    creator_id = db.Column(db.Integer, db.ForeignKey('member.id'))

    def __init__(self, name='', description='', issue=None, creator=None):
        self.name = name
        self.description = description
        self.issue = issue
        self.progress = 0
        self.creator = creator

    def __repr__(self):
        return '<Subtask #%r-%r / %r%%>' % (self.issue_id, self.id, self.progress / 100.0)

comment_tag_table = db.Table('comment_tags',
    db.Column('comment_id', db.Integer, db.ForeignKey('issue_comment.id')),
    db.Column('tag_id', db.Integer, db.ForeignKey('tag.id'))
)

class IssueComment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.Unicode(256))
    body = db.Column(db.Unicode(2048))
    timestamp = db.Column(db.DateTime)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    issue_id = db.Column(db.Integer, db.ForeignKey('issue.id'))
    tags = db.relationship('Tag', secondary=comment_tag_table,
        backref=db.backref('comments', lazy='dynamic'))

    def __init__(self, title='', body='', userid=0, boardid=0):
        self.title = title
        self.body = body
        self.user_id = userid
        self.board_id = boardid
        self.timestamp = datetime.datetime.now()

    def __repr__(self):
        return '<Comment %r for Issue #%r>' % (self.id, self.issue_id)

class Tag(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.Unicode(64))

    def __init__(self, title=''):
        self.title = title

    def __repr__(self):
        return '<Tag %r>' % self.title
