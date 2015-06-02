from flask import Blueprint, render_template, abort, current_app, redirect
from jinja2 import TemplateNotFound
from flask.ext.login import login_user, logout_user, current_user, login_required
from flask.ext.restful import Api, Resource, reqparse, fields, marshal_with
from functools import wraps

from app import db, models, app

member_app = Blueprint('member_app', __name__,
                        template_folder='templates/memberapp')
api = Api(member_app)

def member_required(func):
    @wraps(func)
    @login_required
    def decorated_view(*args, **kwargs):
        if not current_user.member:
            return redirect('/')
        return func(*args, **kwargs)
    return decorated_view


@member_app.route('/')
@member_required
def main():
    try:
        return render_template('starter.html', member=current_user.member)
    except TemplateNotFound:
        abort(404)

@member_app.route('/people')
@member_required
def showPeople():
    try:
        return render_template('memberapp/people.html', member=current_user.member)
    except TemplateNotFound:
        abort(404)

@member_app.route('/milestone/<int:id>')
@member_required
def showMilestone(id):
    try:
        return render_template('milestone.html', member=current_user.member)
    except TemplateNotFound:
        abort(404)

@member_app.route('/issue/<int:id>')
@member_required
def showIssue(id):
    try:
        return render_template('issue.html', member=current_user.member)
    except TemplateNotFound:
        abort(404)

@member_app.route('/suggestion')
@member_required
def showSuggestion():
    try:
        return render_template('suggestion.html',
            milestone=models.Milestone.query.get(0),
            member=current_user.member)
    except TemplateNotFound:
        abort(404)

simple_issue_fields = {
    'id': fields.Integer,
    'name': fields.String,
    'description': fields.String
}

class Issue(Resource):

    issueParser = reqparse.RequestParser()
    issueParser.add_argument('name', type=str, required=True,
        help='Name is required')
    issueParser.add_argument('description', type=str, default='')
    issueParser.add_argument('milestone', type=int, default=-1)

    @member_required
    @marshal_with(simple_issue_fields)
    def post(self):
        args = self.issueParser.parse_args()
        issue = models.Issue(args['name'], args['description'],
            current_user.member)
        if args['milestone'] >= 0:
            milestone = models.Milestone.query.get(args['milestone'])
            if milestone:
                issue.milestones.append(milestone)
        db.session.add(issue)
        db.session.commit()
        return issue

    @member_required
    def get(self, issueID):
        issue = models.Issue.query.get(issueID)
        if issue:
            return str(issue)
        return {}

api.add_resource(Issue, '/api/issue', '/api/issue/<int:issueID>')