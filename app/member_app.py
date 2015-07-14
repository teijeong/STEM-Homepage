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
        milestone = models.Task.query.get(id)
        if milestone and milestone.level == 0:
            return render_template('milestone.html',
                member=current_user.member,
                milestone=milestone)
        else:
            abort(404)
    except TemplateNotFound:
        abort(404)

@member_app.route('/issue/<int:id>')
@member_required
def showIssue(id):
    try:
        issue = models.Task.query.get(id)
        if issue and issue.level == 1:
            return render_template('issue.html', member=current_user.member,
                issue=issue)
        else:
            abort(404)
    except TemplateNotFound:
            abort(404)

@member_app.route('/suggestion')
@member_required
def showSuggestion():
    try:
        return render_template('suggestion.html',
            milestone=models.Task.query.get(0),
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
        issue = models.Task(1, args['name'], args['description'],
            current_user.member)
        if args['milestone'] >= 0:
            milestone = models.Task.query.get(args['milestone'])
            if milestone:
                issue.parents.append(milestone)
        db.session.add(issue)
        db.session.commit()
        return issue

    @member_required
    def get(self, issueID):
        issue = models.Task.query.get(issueID)
        if issue:
            return str(issue)
        return {}

api.add_resource(Issue, '/api/issue', '/api/issue/<int:issueID>')

class TaskComment(Resource):

    issueParser = reqparse.RequestParser()
    issueParser.add_argument('title', type=str, required=True,
        help='Title is required')
    issueParser.add_argument('body', type=str, default='')
    issueParser.add_argument('task_id', type=int, default=-1)

    @member_required
    @marshal_with(simple_issue_fields)
    def post(self):
        args = self.issueParser.parse_args()
        print(args)
        task = models.Task.query.get(args['task_id'])
        if not task:
            abort(404)
        task_comment = models.TaskComment(args['title'], args['body'],
            0, current_user.member, task)
        db.session.add(task_comment)
        db.session.commit()
        return task_comment

    @member_required
    def get(self, commentID):
        task_comment = models.TaskComment.query.get(commentID)
        if task_comment:
            return str(task_comment)
        return {}

api.add_resource(TaskComment, '/api/task_comment',
    '/api/task_comment/<int:commentID>')
