from flask import Blueprint, render_template, abort, current_app, redirect
from jinja2 import TemplateNotFound
from flask.ext.login import login_user, logout_user, current_user, login_required
from flask.ext.restful import Api, Resource, reqparse, fields, marshal_with
from functools import wraps

from app import db, models, app, helper

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

@member_app.route('/issue')
@member_required
def showIssues():
    try:
        issues = models.Task.query.filter_by(level=1).all()
        return render_template('issue_list.html', member=current_user.member,
            issues=issues)
    except TemplateNotFound:
        abort(404)

@member_app.route('/milestone')
@member_required
def showMilestones():
    try:
        milestones = models.Task.query.filter_by(level=0).all()
        return render_template('milestone_list.html', member=current_user.member,
            milestones=milestones)
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

simple_task_fields = {
    'id': fields.Integer,
    'local_id': fields.Integer,
    'level': fields.Integer,
    'status': fields.Integer,
    'priority': fields.Integer,
    'progress': fields.Float,
    'name': fields.String,
    'description': fields.String
}

class Task(Resource):

    taskParser = reqparse.RequestParser()
    taskParser.add_argument('name', type=str, required=True,
        help='Name is required')
    taskParser.add_argument('description', type=str, default='')
    taskParser.add_argument('level', type=int, default=1)
    taskParser.add_argument('parent', type=int, default=[], action='append')

    @member_required
    @marshal_with(simple_task_fields)
    def post(self):
        args = self.taskParser.parse_args()
        task = models.Task(args['level'], args['name'], args['description'],
            current_user.member)
        if args['parent'] != []:
            for parent_id in args['parent']:
                parent = models.Task.query.get(parent_id)
                if parent:
                    task.parents.append(parent)
        db.session.add(task)
        db.session.commit()
        return task

    taskModifyParser = reqparse.RequestParser()
    taskModifyParser.add_argument('name', type=str, default='')
    taskModifyParser.add_argument('description', type=str, default='')
    taskModifyParser.add_argument('level', type=int, default=-1)
    taskModifyParser.add_argument('priority', type=int, default=-1)
    taskModifyParser.add_argument('status', type=int, default=-1)
    taskModifyParser.add_argument('deadline', type=int, default=0)
    taskModifyParser.add_argument('parent[]', type=int, default=[-1],
            action='append', dest='parent')
    taskModifyParser.add_argument('children[]', type=int, default=[-1],
            action='append', dest='children')
    taskModifyParser.add_argument('contributor[]', type=int, default=[-1],
            action='append', dest='contributor')


    @member_required
    @marshal_with(simple_task_fields)
    def put(self, taskID):
        task = models.Task.query.get(taskID)
        if not task:
            return None, 404

        if current_user.member != task.creator and not current_user.member in task.contributors:
            return None, 403

        comment_text = ''

        args = self.taskModifyParser.parse_args()
        if args['name'] != '':
            task.name = args['name']
            comment_text += 'Name changed: %s<br>' % task.name
        if args['description'] != '':
            task.description = args['description']
            comment_text += 'Description changed:<p>%s</p>' % task.description

        if args['level'] != -1:
            pass
        if args['priority'] != -1:
            pass
        if args['status'] != -1:
            pass
        if args['deadline'] != 0:
            pass

        if args['parent'] != [-1]:
            original_list = [task.id for task in task.parents]
            add, sub = helper.list_diff(original_list, args['parent'])
            deleted_tasks = ['#%d %s'%(task.local_id, task.name)
                for task in task.parents if task.id in sub]
            task.parents = [task for task in task.parents if not task.id in sub]

            if deleted_tasks != []:
                comment_text += 'Deleted parents:<br>%s<br>' % (', '.join(deleted_tasks))

            new_tasks = []
            for taskID in add:
                parent = models.Task.query.get(taskID)
                if parent:
                    task.parents.append(parent)
                    new_tasks.append('#%d %s'%(parent.local_id, parent.name))

            if new_tasks != []:
                comment_text += 'New parents:<br>%s<br>' % (', '.join(new_tasks))

        if args['children'] != [-1]:
            original_list = [task.id for task in task.children]
            add, sub = helper.list_diff(original_list, args['children'])
            deleted_tasks = ['#%d %s'%(task.local_id, task.name)
                for task in task.children if task.id in sub]
            task.children = [task for task in task.children if not task.id in sub]

            if deleted_tasks != []:
                comment_text += 'Deleted children:<br>%s<br>' % (', '.join(deleted_tasks))

            new_tasks = []
            for taskID in add:
                child = models.Task.query.get(taskID)
                if child:
                    task.children.append(child)
                    new_tasks.append('#%d %s'%(child.local_id, child.name))

            if new_tasks != []:
                comment_text += 'New children:<br>%s<br>' % (', '.join(new_tasks))


        if args['contributor'] != [-1]:
            original_list = [member.id for member in task.contributors]
            original_list.append(task.creator.id)
            add, sub = helper.list_diff(original_list, args['contributor'])

            deleted_contributors = ['%s'%member.user.nickname
                for member in task.contributors if member.id in sub]
            task.contributors = [member for member in task.contributors if not member.id in sub]

            if deleted_contributors != []:
                comment_text += 'Dropped contributors:<br>%s<br>' % (', '.join(deleted_contributors))

            new_contributors = []
            for memberID in add:
                member = models.Member.query.get(memberID)
                if member:
                    task.contributors.append(member)
                    new_contributors.append('%s'%member.user.nickname)

            if new_contributors != []:
                comment_text += 'New contributors:<br>%s<br>' % (', '.join(new_contributors))

        if comment_text != '':
            comment_text = '<blockquote>%s</blockquote>' % comment_text
            modify_comment = models.TaskComment('Task modified', comment_text, 1, current_user.member, task)
            db.session.add(modify_comment)
        db.session.commit()
        return task

    @member_required
    def get(self, taskID):
        task = models.Task.query.get(taskID)
        if task:
            return str(task)
        return {}

api.add_resource(Task, '/api/task', '/api/task/<int:taskID>')


class Issue(Resource):
    @member_required
    @marshal_with(simple_task_fields)
    def get(self):
        issues = models.Task.query.filter_by(level=1).all()
        return issues

api.add_resource(Issue, '/api/issue')

class Milestone(Resource):
    @member_required
    @marshal_with(simple_task_fields)
    def get(self):
        milestones = models.Task.query.filter_by(level=0).all()
        return milestones

    @member_required
    def post(self):
        return None, 501

api.add_resource(Milestone, '/api/milestone')

class TaskComment(Resource):

    issueParser = reqparse.RequestParser()
    issueParser.add_argument('title', type=str, required=True,
        help='Title is required')
    issueParser.add_argument('body', type=str, default='')
    issueParser.add_argument('task_id', type=int, default=-1)

    @member_required
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
        return str(task_comment)

    @member_required
    def get(self, commentID):
        task_comment = models.TaskComment.query.get(commentID)
        if task_comment:
            return str(task_comment)
        return {}

api.add_resource(TaskComment, '/api/task_comment',
    '/api/task_comment/<int:commentID>')

user_fields = {
    'nickname': fields.String,
    'username': fields.String,
    'email': fields.String
}

member_fields = {
    'id': fields.Integer,
    'cycle': fields.Integer,
    'stem_dept': fields.String,
    'dept': fields.String,
    'cv': fields.String,
    'comment': fields.String,
    'img': fields.String,
    'cover': fields.String,
    'addr': fields.String,
    'phone': fields.String,
    'birthday': fields.String,
    'user': fields.Nested(user_fields),
    'social' :fields.String
}

class Member(Resource):
    @member_required
    @marshal_with(member_fields)
    def get(self, memberID):
        member = models.Member.query.get(memberID)
        if not member:
            return None, 404

        return member

api.add_resource(Member, '/api/member/<int:memberID>')