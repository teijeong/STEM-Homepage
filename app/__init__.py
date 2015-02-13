#-*-coding: utf-8 -*-
from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://be3278fbbccac7:64de4292@us-cdbr-iron-east-01.cleardb.net/heroku_60fb971363678a5'
db = SQLAlchemy(app)

from app import views, models