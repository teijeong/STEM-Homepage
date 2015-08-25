from mongoengine import *
from pymongo import MongoClient
import pymongo


connect(
    'heroku_app32258670',
    username='heroku_app32258670',
    password='5hcl5oso685va7pcpo8e9ku1f5',
    host='mongodb://ds061360.mongolab.com:61360/heroku_app32258670')


class Departments(Document):
    _id = IntField(required=True)
    name = StringField(required=True)


class MajorDepartment(Document):
    _id = IntField(required=True)
    name = StringField(required=True)
    abbr = StringField()


class People(Document):
    _id = IntField(required=True)
    name = StringField(required=True)
    department = ListField(ReferenceField(Departments))
    major = ReferenceField(MajorDepartment)
