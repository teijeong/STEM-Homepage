#-*-coding: utf-8 -*-
from app import db
import datetime
from sqlalchemy_utils import PasswordType
from sqlalchemy.ext.declarative import declarative_base
import math
import pytz

timezone = pytz.timezone('Asia/Seoul')

class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(64), unique=True)
    password = db.Column(PasswordType(
        schemes=['pbkdf2_sha512', 'md5_crypt'], deprecated=['md5_crypt']))
    nickname = db.Column(db.Unicode(64), index=True)
    email = db.Column(db.String(120), index=True, unique=True)
    posts = db.relationship('Post', backref='author', lazy='dynamic')
    comments = db.relationship('Comment', backref='author', lazy='dynamic')
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
    owned_task = db.relationship('Task', backref='creator', lazy='dynamic')
    task_comments = db.relationship('TaskComment', backref='member',lazy='joined')

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

    def editable(self, task):
        if isinstance(task, Task):
            return (self in task.contributors) or (self == task.creator)
        else:
            return False

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
    comments = db.relationship('Comment', backref='post', lazy='joined')

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


class Comment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    body = db.Column(db.Unicode(512))
    timestamp = db.Column(db.DateTime)
    user_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    post_id = db.Column(db.Integer, db.ForeignKey('post.id'))

    def __init__(self, body='', userid=0, postid=0):
        self.body = body
        self.user_id = userid
        self.post_id = postid
        self.timestamp = datetime.datetime.now()
        post = Post.query.get(postid)
        if post:
            post.commentCount += 1
            db.session.commit()

    def __repr__(self):
        return '<Comment %r of Post %r>' % (self.id, self.post_id)

    def remove(self):
        if self.post:
            self.post.commentCount -= 1
        db.session.delete(self)
        db.session.commit()

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


task_task_table = db.Table('task_task_table',
    db.Column('parent_id', db.Integer, db.ForeignKey('task.id')),
    db.Column('child_id', db.Integer, db.ForeignKey('task.id'))
)

task_member_table = db.Table('task_users',
    db.Column('task_id', db.Integer, db.ForeignKey('task.id')),
    db.Column('member_id', db.Integer, db.ForeignKey('member.id'))
)
task_tag_table = db.Table('task_tags',
    db.Column('task_id', db.Integer, db.ForeignKey('task.id')),
    db.Column('tag_id', db.Integer, db.ForeignKey('tag.id'))
)


class Task(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    local_id = db.Column(db.Integer)

    name = db.Column(db.Unicode(256))
    description = db.Column(db.Unicode(2048))

    progress = db.Column(db.Integer)
    # 0:trivial, 1:normal, 2:important, 3:blocker
    priority = db.Column(db.Integer)
    secret = db.Column(db.Boolean)
    # 0:opened, 1:closed, 2:archived, 3:inactive(not shown in main)
    status = db.Column(db.Integer)

    # 0:milestone, 1:issue, 2:subtask
    level = db.Column(db.Integer)
    children = db.relationship('Task', secondary=task_task_table,
        primaryjoin=id==task_task_table.c.parent_id,
        secondaryjoin=id==task_task_table.c.child_id,
        backref="parents")

    timestamp = db.Column(db.DateTime)
    deadline = db.Column(db.DateTime)

    comments = db.relationship('TaskComment', backref='task', lazy='dynamic')
    contributors = db.relationship('Member', secondary=task_member_table,
        backref=db.backref('issues', lazy='dynamic'))
    creator_id = db.Column(db.Integer, db.ForeignKey('member.id'))

    def __init__(self, level = 0, name='', description='',
        creator = None, priority = 2, secret = False,
        deadline = None, parent = None, children = [], status = 0):

        self.level = level
        self.name = name
        self.description = description

        self.progress = 0
        self.creator = creator

        self.priority = priority
        self.secret = secret
        self.timestamp = datetime.datetime.now()
        self.deadline = deadline or \
            (datetime.datetime.now() + datetime.timedelta(days=7))
        self.status = status

        if parent:
            self.level = parent.level + 1;
            self.parents.append(parent)

        if self.level == 0 or self.level == 1:
            recent_task = Task.query.filter_by(level=level). \
                order_by(Task.local_id.desc()).first()
            self.local_id = (recent_task.local_id or 0) + 1

        if self.level == 2:
            if parent:
                subtasks = sorted(parent.children,
                    key=lambda task: task.local_id, reverse=True)
                if len(subtasks) > 0:
                    self.local_id = subtasks[0].local_id + 1
                else:
                    self.local_id = 1

    def add_parent(self, parent):
        if len(self.parents) != 0:
            if self.parents[0].level != parent.level:
                return
        else:
            self.level = parent.level + 1
        self.parents.append(parent)

    def filter_children(self, status):
        return [c for c in self.children if c.status == status]

    def cascade_up(self, func, *args, **kwargs):
        func(self, *args, **kwargs)
        for parent in self.parents:
            if self.level > parent.level:
                parent.cascade_up(func, *args, **kwargs)

    def cascade_down(self, func):
        func(self, *args, **kwargs)
        for child in self.children:
            if self.level < child.level:
                child.cascade_down(func, *args, **kwargs)

    def update_progress(self, initial=False):    
        if not initial:
            if not self.children:
                self.progress = 0
                return

            sum = 0;
            for child_task in self.children:
                sum += child_task.progress
            self.progress = math.ceil(sum / len(self.children))

        for parent_task in self.parents:
            parent_task.update_progress()

    def __repr__(self):
        if self.level == 0:
            return '<M#%r %r>' % (self.local_id, self.name)
        elif self.level == 1:
            return '<#%r %r>' % (self.local_id, self.name)
        elif self.level == 2:
            if self.parent:
                return '<#%r-%r %r>' % (self.parents[0].local_id, self.local_id, self.name)
            else:
                return '<#?-%r %r>' % (self.parents[0].local_id, self.local_id, self.name)
        else:
            return '<?#%r %r>' % (self.id, self.name)



comment_tag_table = db.Table('comment_tags',
    db.Column('comment_id', db.Integer, db.ForeignKey('task_comment.id')),
    db.Column('tag_id', db.Integer, db.ForeignKey('tag.id'))
)


class TaskComment(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.Unicode(256))
    body = db.Column(db.Unicode(2048))
    timestamp = db.Column(db.DateTime)
    comment_type = db.Column(db.Integer)

    member_id = db.Column(db.Integer, db.ForeignKey('member.id'))
    task_id = db.Column(db.Integer, db.ForeignKey('task.id'))

    def __init__(self, title='', body='', comment_type=0,
        member=None, task=None):

        self.title = title
        self.body = body
        self.member = member
        self.task = task
        self.comment_type = comment_type
        self.timestamp = datetime.datetime.now()

    def __repr__(self):
        return '<Comment %r for Task #%r>' % (self.id, self.task_id)

class Tag(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.Unicode(64))

    def __init__(self, title=''):
        self.title = title

    def __repr__(self):
        return '<Tag %r>' % self.title
