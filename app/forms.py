#-*- coding: utf-8 -*-

import os
from flask.ext.wtf import Form
from wtforms import IntegerField, TextField, PasswordField, HiddenField, validators
from flask_wtf.file import FileField, FileAllowed
from app import app, models, db
from flask.ext.login import current_user
from datetime import datetime
from werkzeug import secure_filename
from urllib.parse import urlparse, urljoin
from flask import redirect, url_for, request

def is_safe_url(target):
    ref_url = urlparse(request.host_url)
    test_url = urlparse(urljoin(request.host_url, target))
    return test_url.scheme in ('http', 'https') and \
           ref_url.netloc == test_url.netloc

def get_redirect_target():
    for target in request.values.get('next'), request.referrer:
        if not target:
            continue
        if is_safe_url(target):
            return target

def redirect_back(endpoint, **values):
    target = request.form['next']
    if not target or not is_safe_url(target):
        target = url_for(endpoint, **values)
    return redirect(target)

class RedirectForm(Form):
    next = HiddenField()

    def __init__(self, *args, **kwargs):
        Form.__init__(self, *args, **kwargs)
        if not self.next.data:
            self.next.data = get_redirect_target() or ''

    def redirect(self, endpoint='main', **values):
        if is_safe_url(self.next.data):
            return redirect(self.next.data)
        target = get_redirect_target()
        return redirect(target or url_for(endpoint, **values))

class LoginForm(RedirectForm):
    userid = TextField('ID')
    passwd = PasswordField('PW')
    next = TextField('next')
    user = None

    def validate(self):
        rv = Form.validate(self)
        if not rv:
            return False

        user = models.User.query.filter_by(username=self.userid.data).first()
        if user is None:
            self.userid.errors.append('Unknown user')
            return False
        if user.password != self.passwd.data:
            self.passwd.errors.append('Incorrect password')
            return False

        if self.next.data == "":
            self.next.data = "/"
        self.user = user
        return True

class RegisterForm(RedirectForm):
    name = TextField('Name')
    userid = TextField('ID')
    passwd = PasswordField('PW')
    email = TextField('E-mail')
    user = None

    def validate(self):
        rv = Form.validate(self)
        if not rv:
            return False

        user = models.User.query.filter_by(username=self.userid.data).first()
        if user is not None:
            self.userid.errors.append('Duplicate')
            return False

        member = None
        user = models.User.query.filter_by(email=self.email.data).first()
        if (user and user.username[0:11] == 'stem_member' and \
            user.member and user.nickname==self.name.data):
            member = user.member
            user.member = None
            db.session.delete(user)
            db.session.commit()
        elif user:
            self.userid.errors.append('Duplicate')
            return False
        
        user = models.User(self.userid.data, self.passwd.data,
            self.name.data, self.email.data)
        if member:
            user.member = member


        db.session.add(user)
        db.session.commit()

        self.user = user
        return True

class ModifyForm(RedirectForm):
    passwd = PasswordField('PW')
    email = TextField('E-mail')
    user = current_user

    def validate(self):
        rv = Form.validate(self)
        if not rv:
            return False

        if self.user.password != self.passwd_original.data:
            return False

        if self.passwd.data != '':
            self.user.passwd = self.passwd.data
        if self.email.data != '':
            self.user.email = self.email.data
        db.session.commit()
        return True


class ModifyMemberForm(ModifyForm):
    cell = TextField('Cell Phone')
    birthday = TextField('Birthday')
    cycle = IntegerField('Cycle')
    addr = TextField('Address')
    photo = FileField('Photo',
        validators=[FileAllowed(['png', 'jpg', 'gif'], 'PNG/JPG/GIF file only')])
    cover = FileField('Cover',
        validators=[FileAllowed(['png', 'jpg', 'gif'], 'PNG/JPG/GIF file only')])
    department = IntegerField('Department')
    stem_department = IntegerField('STEM_Department')
    cv = TextField('CV')
    passwd_original = PasswordField('PW-original')
    comment = TextField('Comment')
    social = TextField('Social Network')

    def validate(self):
        rv = ModifyForm.validate(self)
        if not rv:
            return False

        if self.cell.data != '':
            self.user.member.phone = self.cell.data
        if self.birthday.data != '':
            self.user.member.birthday = datetime.strptime(self.birthday.data, '%Y-%m-%d').date()

        if self.photo.data.filename != '':
            ext = self.photo.data.filename.rsplit('.',1)[1]
            filename = 'profile/%d.' % self.user.id + ext
            file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            self.photo.data.save(file_path)
            self.user.member.img = filename

        if self.cover.data.filename != '':
            ext = self.cover.data.filename.rsplit('.',1)[1]
            filename = 'cover/%d.' % self.user.id + ext
            file_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            self.cover.data.save(file_path)
            self.user.member.cover = filename

        if self.cycle.data != '':
            self.user.member.cycle = self.cycle.data
        if self.addr.data != '':
            self.user.member.addr = self.addr.data
        if self.cv.data != '':
            self.user.member.cv = self.cv.data
        if self.comment.data != '':
            self.user.member.comment = self.comment.data
        if self.social.data != '':
            if self.social.data[0:4] != 'http':
                self.social.data = 'http://' + self.social.data
            self.user.member.social = self.social.data

        self.user.member.dept_id = self.department.data
        self.user.member.stem_dept_id = self.stem_department.data

        db.session.commit()

        return True