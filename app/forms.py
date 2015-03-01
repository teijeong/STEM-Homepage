#-*- coding: utf-8 -*-

from flask.ext.wtf import Form
from wtforms import BooleanField, TextField, PasswordField, validators
from app import models

class LoginForm(Form):
    userid = TextField('ID')
    passwd = PasswordField('PW')
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

        self.user = user
        return True