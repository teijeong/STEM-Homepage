#-*- coding: utf-8 -*-

from flask.ext.wtf import Form
from wtforms import IntegerField, TextField, PasswordField, validators
from app import models, db

class LoginForm(Form):
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

class RegisterForm(Form):
    name = TextField('Name')
    userid = TextField('ID')
    passwd = PasswordField('PW')
    cycle = IntegerField('Cycle')
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

        user = models.User(self.userid.data, self.passwd.data,
            self.name.data, self.cycle.data, self.email.data)
        db.session.add(user)
        db.session.commit()

        self.user = user
        return True
