from flask import Blueprint, render_template
from flask.ext.restful import Resource, reqparse, fields, marshal_with

api = Blueprint('api', __name__)


class Members(Resource):
    def get(self):
