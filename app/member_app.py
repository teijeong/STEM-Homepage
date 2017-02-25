import os
import pytz
import uuid

from flask import Blueprint, render_template, abort, current_app, redirect, \
    request, url_for
from jinja2 import TemplateNotFound
from flask.ext.login import login_user, logout_user, current_user, \
    login_required
from flask.ext.restful import Api, Resource, reqparse, fields, marshal_with
from functools import wraps

from .forms import ModifyMemberForm, ModifyStemDeptOnly

from werkzeug import secure_filename

from sqlalchemy import or_, and_, not_
from sqlalchemy.sql.expression import func
from datetime import datetime, timedelta

from app import db, models, app, helper, notification


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
    member = current_user.member
    
#    task_levels = [0, 1, 2]
#    task_lists = []
#
#    for level in task_levels:
#        task_lists.append(
#            models.Task.query
#            .filter(or_(models.Task.contributors.contains(member),
#                        models.Task.creator == member))
#            .filter(models.Task.status != 3)
#            .filter_by(level=level).all())
#    task_lists[2] = [t for t in task_lists[2] if t.parents]

    mem = models.Member
    issues = models.Task.query.get(0).children[::-1][0:3]
    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        return render_template(
            'dashboard.html', member=current_user.member,
            nav_id=1,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(),
            manager=manager, recruitcycle=recruitcycle, issues=issues,mem=mem)
    except TemplateNotFound:
        abort(404)

@member_app.route('/mms/completion_state')
@member_required
def CompletionState():

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        return render_template('memberapp/mms/completion_state.html', member=current_user.member, notifications=notification.Generate(current_user.member), nav_id=2, boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)

@member_app.route('/mms/active', methods=['GET', 'POST'])
@member_required
def ActiveApply():

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    form = ModifyMemberForm()
    departments = models.Department.query.all()
    stem_departments = models.StemDepartment.query.filter(or_(models.StemDepartment.id==1, models.StemDepartment.id==3, models.StemDepartment.id==4)).all()

    request = models.Activeapply.query.first()

    try:
        if form.validate_on_submit():
            return render_template('memberapp/mms/active_apply.html', member=current_user.member, notifications=notification.Generate(current_user.member), nav_id=2, boards=models.Tag.query.filter_by(special=1).all(), manager=manager, form=form, departments=departments, stem_departments=stem_departments, is_active=request.is_active, message='신청이 완료되었습니다.')
        return render_template('memberapp/mms/active_apply.html', member=current_user.member, notifications=notification.Generate(current_user.member), nav_id=2, boards=models.Tag.query.filter_by(special=1).all(), manager=manager, form=form, departments=departments, stem_departments=stem_departments, is_active=request.is_active)
    except TemplateNotFound:
        abort(404)

@member_app.route('/mms/active/activation', methods=['GET', 'POST'])
@member_required
def ActiveActivation():
    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    if current_user.member in manager:
        if 'is_active' in request.form:
            isactive = models.Activeapply.query.all()
            newval = models.Activeapply(is_active=1)
            for i in isactive:
                db.session.delete(i)
            db.session.add(newval)
            db.session.commit()
        else:
            isactive = models.Activeapply.query.all()
            newval = models.Activeapply(is_active=0)
            for i in isactive:
                db.session.delete(i)
            db.session.add(newval)
            db.session.commit()
        return redirect(url_for('.ActiveApply'))
    return abort(403)

@member_app.route('/mms/completion_criterion')
@member_required
def MgmtCompletionCriterion():

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    if not current_user.member in manager:
        abort(404)

    try:
        return render_template('memberapp/mms/mgmt_completion_criterion.html', member=current_user.member, notifications=notification.Generate(current_user.member), nav_id=2, boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)

@member_app.route('/mms/mgmt/completion_record')
@member_required
def MgmtCompletionRecord():

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    if not current_user.member in manager:
        abort(404)

    try:
        return render_template('memberapp/mms/mgmt_completion_record.html', member=current_user.member, notifications=notification.Generate(current_user.member), nav_id=2, boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)

@member_app.route('/mms/mgmt/active_registration', methods=['GET', 'POST'])
@member_required
def MgmtActiveRegistration():

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    form = ModifyStemDeptOnly()

    if not current_user.member in manager:
        abort(404)

    try:
        if form.is_submitted():
            if form.memberid.data == -1:
                users = models.Member.query.filter(or_(models.Member.stem_dept_id==1,models.Member.stem_dept_id==3,models.Member.stem_dept_id==4)).all()
                for user in users :
                    user.stem_dept_id = form.stem_department.data
                    db.session.add(user)
                db.session.commit()
            else:
                user = models.Member.query.filter(models.Member.id == form.memberid.data).first_or_404()
                user.stem_dept_id = form.stem_department.data
                db.session.add(user)
                db.session.commit()
            return render_template('memberapp/mms/mgmt_registration.html', member=current_user.member, notifications=notification.Generate(current_user.member), nav_id=2, boards=models.Tag.query.filter_by(special=1).all(), form=form, manager=manager)
        return render_template('memberapp/mms/mgmt_registration.html', member=current_user.member, notifications=notification.Generate(current_user.member), nav_id=2, boards=models.Tag.query.filter_by(special=1).all(), form=form, manager=manager)
    except TemplateNotFound:
        abort(404)

@member_app.route('/people/_<int:cycle>')
@member_required
def showPeople(cycle):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        return render_template(
            'memberapp/people.html', member=current_user.member, nav_id=3,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), cycle=cycle, manager=manager)
    except TemplateNotFound:
        abort(404)


@member_app.route('/people/<int:id>')
@member_required
def showMember(id):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        mem = models.Member.query.get(id)
        if not mem:
            abort(404)
        return render_template(
            'memberapp/profile.html', member=current_user.member,
            profile_member=mem, nav_id=3, cycle=mem.cycle,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)

@member_app.route('/people/u_<int:id>')
@member_required
def showMemberbyUserID(id):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        mem = models.Member.query.filter_by(user_id=id).first()
        if not mem:
            abort(404)
        memberid = str(mem.id)
        return redirect('stem/people/' + memberid )

    except TemplateNotFound:
        abort(404)

@member_app.route('/calendar')
@member_required
def showCalendar():

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        return render_template(
            'calendar.html', member=current_user.member, nav_id=4,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)

@member_app.route('/suggestion')
@member_required
def gotoSuggestionPage1():
    return redirect(url_for('.showSuggestion', page = 1))

@member_app.route('/suggestion/<int:page>')
@member_required
def showSuggestion(page):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    totalSuggestion = len(models.Task.query.get(0).children[::-1]) - 1
    end = totalSuggestion - 10 * (page - 1) + 1
    start = totalSuggestion - 10 * page + 1
    maxpage = round(totalSuggestion / 10 + 0.5)

    if start < 1 :
        start = 1
    if end < 1 :
        abort(404)

    issues = models.Task.query.get(0).children[start:end:][::-1]

    try:
        mem = models.Member
        return render_template(
            'suggestion.html',
            member=current_user.member, nav_id=5,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), mem=mem, manager=manager, issues=issues, maxpage = maxpage, page=page, totalSuggestion=totalSuggestion)
    except TemplateNotFound:
        abort(404)

@member_app.route('/task/<int:id>')
@member_required
def showTask(id):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        task = models.Task.query.get(id)
        if not task:
            abort(404)
        if task.level == 0:
            return render_template(
                'milestone.html', member=current_user.member,
                milestone=task, task=task, nav_id=5,
                notifications=notification.Generate(current_user.member),
                boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
        if task.level == 1:
            return render_template(
                'issue.html', member=current_user.member,
                issue=task, task=task, nav_id=6,
                notifications=notification.Generate(current_user.member),
                boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
        if task.level == 2:
            return render_template(
                'subtask.html', member=current_user.member,
                task=task, nav_id=6,
                notifications=notification.Generate(current_user.member),
                boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)


@member_app.route('/milestone/<int:id>')
@member_required
def showMilestone(id):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        milestone = models.Task.query.get(id)
        if milestone and milestone.level == 0:
            return render_template(
                'milestone.html',
                member=current_user.member,
                milestone=milestone, task=milestone, nav_id=5,
                notifications=notification.Generate(current_user.member),
                boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
        else:
            abort(404)
    except TemplateNotFound:
        abort(404)


@member_app.route('/issue/<int:id>')
@member_required
def showIssue(id):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        issue = models.Task.query.get(id)
        if issue and issue.level == 1:
            return render_template(
                'issue.html', member=current_user.member,
                issue=issue, task=issue, nav_id=6,
                notifications=notification.Generate(current_user.member),
                boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
        else:
            abort(404)
    except TemplateNotFound:
            abort(404)


@member_app.route('/subtask/<int:id>')
@member_required
def showSubtask(id):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        task = models.Task.query.get(id)
        if task and task.level == 2:
            return render_template(
                'subtask.html', member=current_user.member,
                task=task, nav_id=6,
                notifications=notification.Generate(current_user.member),
                boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
        else:
            abort(404)
    except TemplateNotFound:
            abort(404)

"""
@member_app.route('/issue')
@member_required
def showIssues():

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        issues = models.Task.query.filter_by(level=1).all()
        return render_template(
            'issue_list.html', member=current_user.member,
            issues=issues, nav_id=5,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)


@member_app.route('/milestone')
@member_required
def showMilestones():

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        milestones = models.Task.query.filter_by(level=0).all()
        return render_template('milestone_list.html',
                                member=current_user.member,
                                milestones=milestones, nav_id=4,
                                notifications=notification.Generate(
                                   current_user.member),
                                boards=models.Tag.query
                                    .filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)


@member_app.route('/tag')
@member_required
def showTagList():

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        tags = models.Tag.query.all()
        return render_template(
            'tag_list.html', member=current_user.member, nav_id=7, tags=tags,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)


@member_app.route('/tag/<int:id>')
@member_required
def showTag(id):
    try:
        tag = models.Tag.query.get(id)
        if not tag:
            abort(404)

        return render_template(
            'tag.html', member=current_user.member, nav_id=7, tag=tag,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)
"""

@member_app.route('/board')
@member_required
def showBoardList():

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        tags = models.Tag.query.filter_by(special=1).all()
        return render_template(
            'board_list.html',
            member=current_user.member, nav_id=6, tags=tags,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)


@member_app.route('/board/<int:tag_id>')
@member_required
def showBoard(tag_id):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        tag = models.Tag.query.get(tag_id)
        
        if not tag:
            abort(404)

        posts = tag.posts

        return render_template(
            'post_list.html', member=current_user.member, nav_id=6,
            tag=tag, posts=posts,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)

@member_app.route('/board/<int:tag_id>_<int:page>')
@member_required
def showPage(tag_id,page):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        tag = models.Tag.query.get(tag_id)
        if not tag:
            abort(404)

        pagination = tag.posts.query.filter(3)

        return render_template(
            'post_list.html', member=current_user.member, nav_id=6,
            tag=tag, posts=posts,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)


@member_app.route('/board/<int:tag_id>/<int:post_id>')
@member_required
def showPost(tag_id, post_id):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        tag = models.Tag.query.get(tag_id)
        post = models.Post.query.get(post_id)

        if not post in tag.posts:
            abort(404)

        if not (tag and post):
            abort(404)

        post.hitCount = post.hitCount + 1
        db.session.commit()

        return render_template(
            'post_view.html', member=current_user.member, nav_id=6,
            tag=tag, post=post,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)

@member_app.route('/board/<int:tag_id>/<int:post_id>/modify')
@member_required
def modifyPost(tag_id, post_id):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        tag = models.Tag.query.get(tag_id)
        post = models.Post.query.get(post_id)

        if not (tag and post):
            abort(404)
        if post.author != current_user:
            abort(403)

        return render_template(
            'post_modify.html', member=current_user.member, nav_id=6,
            tag=tag, post=post,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), manager=manager)
    except TemplateNotFound:
        abort(404)

@member_app.route('/board/<int:tag_id>/<int:post_id>/delete')
@member_required
def deletePost(tag_id, post_id):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        tag = models.Tag.query.get(tag_id)
        post = models.Post.query.get(post_id)
        if not (tag and post):
            abort(404)
        if post.author != current_user:
            abort(403)

        db.session.delete(post)
        db.session.commit()

        return redirect(url_for('.showBoard', tag_id=tag_id))
    except TemplateNotFound:
        abort(404)

@member_app.route('/board/<int:tag_id>/write')
@member_required
def writePost(tag_id):

    recruitcycle = db.session.query(func.max(models.Member.cycle).label("cycle")).first().cycle
    manager = models.Member.query.filter(or_(models.Member.cycle==recruitcycle, models.Member.cycle==recruitcycle-1)).filter(or_(models.Member.stem_dept_id==5,models.Member.stem_dept_id==6)).all()

    try:
        tag = models.Tag.query.get(tag_id)
        if not tag:
            abort(404)
        if not tag.special==1:
            abort(404)

        return render_template(
            'post_write.html',
            member=current_user.member, nav_id=6, tag=tag,
            notifications=notification.Generate(current_user.member),
            boards=models.Tag.query.filter_by(special=1).all(), manager=manager)

    except TemplateNotFound:
        abort(404)


class Post(Resource):
    postParser = reqparse.RequestParser()
    postParser.add_argument('title', type=str, required=True,
                               help='Title is required')
    postParser.add_argument('body', type=str, default='')
    postParser.add_argument('tag_id', type=int, default=-1)
    postParser.add_argument('redirect', type=str, default='')

    @member_required
    def post(self):
        args = self.postParser.parse_args()
        tag = models.Tag.query.get(args['tag_id'])
        if not tag:
            abort(404)
        post = models.Post(0, args['title'], args['body'],
                            current_user.id)
        db.session.add(post)

        tags = helper.get_tags(post.body)
        post.tags.append(tag)

        for tag in tags:
            tag_data = models.Tag.query.filter_by(title=tag).first()
            if tag_data:
                post.tags.append(tag_data)
            else:
                tag_data = models.Tag(tag)
                post.tags.append(tag_data)
                db.session.add(tag_data)

        files = request.files.getlist("files")

        file_uploaded = False

        for file in files:
            if helper.process_file(file, post):
                file_uploaded = True

        db.session.commit()
        if (args['redirect']):
            notification.Push(current_user.member, models.Member.query.all(),
                            post, models.NotificationAction.create)
            return redirect(args['redirect'])

        notification.Push(current_user.member, models.Member.query.all(),
                        post, models.NotificationAction.create)
        return str(post)

    @member_required
    def put(self, post_id):
        args = self.postParser.parse_args()
        tag = models.Tag.query.get(args['tag_id'])
        post = models.Post.query.get(post_id)
        if not (tag and post):
            abort(404)

        tags = helper.get_tags(post.body)
        post.title = args['title']
        post.body = args['body']

        for tag in tags:
            tag_data = models.Tag.query.filter_by(title=tag).first()
            if not tag_data:
                tag_data = models.Tag(tag)
                db.session.add(tag_data)
            if not tag_data in post.tags:
                post.tags.append(tag_data)

        files = request.files.getlist("files")

        file_uploaded = False

        for file in files:
            if helper.process_file(file, post):
                file_uploaded = True

        db.session.commit()
        notification.Push(current_user.member, models.Member.query.all(),
                        post, models.NotificationAction.update)
        if (args['redirect']):
            return redirect(args['redirect'])

        return str(post)

    @member_required
    def get(self, post_id):
        post = models.Post.query.get(post_id)
        if post:
            return str(post)
        return {}


api.add_resource(Post, '/api/post',
                 '/api/post/<int:post_id>')


simple_task_fields = {
    'id': fields.Integer,
    'local_id': fields.Integer,
    'level': fields.Integer,
    'status': fields.Integer,
    'priority': fields.Integer,
    'progress': fields.Float,
    'name': fields.String,
    'description': fields.String,
    'deadline': fields.DateTime,
    'timestamp': fields.DateTime
}


class Task(Resource):
    taskParser = reqparse.RequestParser()
    taskParser.add_argument('name', type=str, required=True,
                            help='Name is required')
    taskParser.add_argument('description', type=str, default='')
    taskParser.add_argument('level', type=int, default=1)
    taskParser.add_argument('priority', type=int, default=1)
    taskParser.add_argument('status', type=int, default=0)
    taskParser.add_argument('contributor_auto', type=bool, default=False)
    taskParser.add_argument('deadline', type=int, default=0)
    taskParser.add_argument('parents[]', type=int, default=[],
                            action='append', dest='parents')
    taskParser.add_argument('children[]', type=int, default=[],
                            action='append', dest='children')
    taskParser.add_argument('contributors[]', type=int, default=[],
                            action='append', dest='contributors')

    @member_required
    @marshal_with(simple_task_fields)
    def post(self):
        args = self.taskParser.parse_args()
        args['parents'] = list(set(args['parents']))
        args['children'] = list(set(args['children']))
        args['contributors'] = \
            list(set(args['contributors']) - {current_user.member.id})
        parent = None

        if len(args['parents']) > 0:
            parent = models.Task.query.get(args['parents'][0])

        deadline = datetime.fromtimestamp(args['deadline'])
        task = models.Task(args['level'], args['name'], args['description'],
                           current_user.member, args['priority'], False,
                           deadline, parent, None, args['status'])

        comment_text = '%r<br>' % task

        db.session.add(task)
        db.session.commit()

        tags = helper.get_tags(task.description)

        for tag in tags:
            tag_data = models.Tag.query.filter_by(title=tag).first()
            if tag_data:
                task.tags.append(tag_data)
            else:
                tag_data = models.Tag(tag)
                task.tags.append(tag_data)
                db.session.add(tag_data)
'''
        priority_text = ['[시간날 때]', '[보통]', '[중요함]', '[급함]']
        comment_text += '중요도: %s, ' % priority_text[task.priority]

        status_text = ['[진행 중]', '[완료]', '[보관됨]', '[제외됨]']
        comment_text += '상태: %s<br>' % status_text[task.status]

        comment_text += '마감일: %s<br>' % \
                        task.deadline.strftime('%Y.%m.%d %H:%M')

        if args['parents'] != []:
            new_tasks = ['#%d %s' % (task.parents[0].local_id,
                                     task.parents[0].name)]

            for parent_id in args['parents'][1:]:
                parent = models.Task.query. \
                    filter_by(level=(task.level-1)). \
                    filter_by(local_id=parent_id).first()

                if parent:
                    task.parents.append(parent)
                    parent.update_progress(True)
                    new_tasks.append('#%d %s' % (parent.local_id, parent.name))

            if new_tasks != []:
                if task.level == 1:
                    new_tasks = ['M%s' % s for s in new_tasks]
                comment_text += '상위 업무:<br>%s<br>' % (', '.join(new_tasks))

        if args['children'] != []:
            new_tasks = []
            for child_id in args['children']:
                child = models.Task.query. \
                    filter_by(level=(task.level+1)). \
                    filter_by(local_id=child_id).first()

                if child:
                    task.children.append(child)
                    new_tasks.append('#%d %s' % (child.local_id, child.name))

            if new_tasks != []:
                comment_text += '하위 업무:<br>%s<br>' % (', '.join(new_tasks))

        if args['contributors'] != []:
            new_contributors = [task.creator.user.nickname]
            for memberID in args['contributors']:
                member = models.Member.query.get(memberID)
                if member:
                    task.contributors.append(member)
                    new_contributors.append('%s' % member.user.nickname)

            if new_contributors != []:
                comment_text += '참여자:<br>%s<br>' % \
                                (', '.join(new_contributors))

        if args['contributor_auto']:
            members = set()
            for task in task.parents:
                members |= set([mem.id for mem in task.contributors])
                members |= {task.creator.id}
            for task in task.children:
                members |= set([mem.id for mem in task.contributors])
                members |= {task.creator.id}
            members -= set([mem.id for mem in task.contributors])

            new_contributors = []
            for memberID in members:
                member = models.Member.query.get(memberID)
                if member:
                    task.contributors.append(member)
                    new_contributors.append('%s' % member.user.nickname)

            if new_contributors != []:
                comment_text += '자동 추가된 참여자:<br>%s<br>' % \
                                (', '.join(new_contributors))

        if comment_text != '':
            comment_text = '<blockquote>%s</blockquote>' % comment_text
            modify_comment = models.TaskComment('새 업무가 생성되었습니다.',
                                                comment_text, 1,
                                                current_user.member, task)
            db.session.add(modify_comment)
        db.session.commit()
        return task

    taskModifyParser = reqparse.RequestParser()
    taskModifyParser.add_argument('name', type=str, default='')
    taskModifyParser.add_argument('description', type=str, default='')
    taskModifyParser.add_argument('level', type=int, default=-1)
    taskModifyParser.add_argument('priority', type=int, default=-1)
    taskModifyParser.add_argument('status', type=int, default=-1)
    taskModifyParser.add_argument('progress', type=int, default=-1)
    taskModifyParser.add_argument('deadline', type=int, default=0)
    taskModifyParser.add_argument('parents[]', type=int, default=[-1],
                                  action='append', dest='parents')
    taskModifyParser.add_argument('children[]', type=int, default=[-1],
                                  action='append', dest='children')
    taskModifyParser.add_argument('contributor[]', type=int, default=[-1],
                                  action='append', dest='contributor')

    @member_required
    @marshal_with(simple_task_fields)
    def put(self, taskID, args=None):
        task = models.Task.query.get(taskID)
        if not task:
            return None, 404

        comment_text = ''

        # For non-request updates...
        if not args:
            if current_user.member != task.creator and \
               not current_user.member in task.contributors:
                return None, 403
            args = self.taskModifyParser.parse_args()

        if args['name'] != '':
            task.name = args['name']
            comment_text += '이름이 변경되었습니다: %s<br>' % task.name

        if args['description'] != '':
            task.description = args['description']
            comment_text += '설명이 변경되었습니다:<p>%s</p>' % task.description

            tags = helper.get_tags(task.description)

            for tag in tags:
                tag_data = models.Tag.query.filter_by(title=tag).first()
                if not tag_data:
                    tag_data = models.Tag(tag)
                    db.session.add(tag_data)
                if not tag_data in task.tags:
                    task.tags.append(tag_data)

        if args['level'] != -1:
            pass
        if args['progress'] != -1 and task.progress != args['progress']:
            task.progress = args['progress']
            comment_text += '진행도가 %d%%로 변경되었습니다.' % task.progress
            task.update_progress(True)

        if args['priority'] != -1 and args['priority'] != task.priority:
            task.priority = args['priority']
            priority_text = ['[시간날 때]로',
                             '[보통]으로',
                             '[중요함]으로',
                             '[급함]으로']
            comment_text += '중요도가 %s 변경되었습니다.' % priority_text[task.priority]

        if args['status'] != -1 and args['status'] != task.status:
            status_text = ['[진행 중]으로',
                           '[완료]로',
                           '[보관됨]으로',
                           '[제외됨]으로']
            task.status = args['status']
            comment_text += '상태가 %s 변경되었습니다.' % \
                            status_text[task.status]

        if args['deadline'] != 0:
            if args['deadline'] != int(task.deadline.timestamp()):
                task.deadline = datetime.fromtimestamp(args['deadline'])
                comment_text += '마감일이 변경되었습니다: %s' % \
                                task.deadline.strftime('%Y.%m.%d %H:%M')

        if args['parents'] != [-1]:
            original_list = [task.id for task in task.parents]
            add, sub = helper.list_diff(original_list, args['parents'])
            deleted_tasks = ['#%d %s' % (task.local_id, task.name)
                             for task in task.parents if task.id in sub]
            task.parents = [task for task in task.parents
                            if not task.id in sub]

            if deleted_tasks != []:
                comment_text += '제외된 상위 업무:<br>%s<br>' % \
                                (', '.join(deleted_tasks))

            new_tasks = []
            for taskID in add:
                parent = models.Task.query.get(taskID)
                if parent:
                    task.parents.append(parent)
                    parent.update_progress(True)
                    new_tasks.append('#%d %s' % (parent.local_id, parent.name))

            if new_tasks != []:
                comment_text += '추가된 상위 업무:<br>%s<br>' % (', '.join(new_tasks))

        if args['children'] != [-1]:
            original_list = [task.id for task in task.children]
            add, sub = helper.list_diff(original_list, args['children'])
            deleted_tasks = ['#%d %s' % (task.local_id, task.name)
                             for task in task.children if task.id in sub]
            task.children = [task for task in task.children
                             if not task.id in sub]

            if deleted_tasks != []:
                comment_text += '제거된 하위 업무:<br>%s<br>' % \
                                (', '.join(deleted_tasks))

            if task.level == 1:
                for taskID in sub:
                    child = models.Task.query.get(taskID)
                    if child:
                        child.status = 3
                db.session.commit()

            new_tasks = []
            for taskID in add:
                child = models.Task.query.get(taskID)
                if child:
                    task.children.append(child)
                    new_tasks.append('#%d %s' % (child.local_id, child.name))

            if new_tasks != []:
                comment_text += '새 하위 업무:<br>%s<br>' % (', '.join(new_tasks))

        if args['contributor'] != [-1]:
            original_list = [member.id for member in task.contributors]
            original_list.append(task.creator.id)
            add, sub = helper.list_diff(original_list, args['contributor'])
            print ((original_list, args['contributor']))
            print ((add, sub))
            deleted_contributors = ['%s' % member.user.nickname
                                    for member in task.contributors
                                    if member.id in sub]
            task.contributors = [member for member in task.contributors
                                 if not member.id in sub]

            if deleted_contributors != []:
                comment_text += '제외된 참여자:<br>%s<br>' % \
                                (', '.join(deleted_contributors))

            new_contributors = []
            for memberID in add:
                member = models.Member.query.get(memberID)
                if member:
                    task.contributors.append(member)
                    new_contributors.append('%s' % member.user.nickname)

            if new_contributors != []:
                comment_text += '새 참여자:<br>%s<br>' % \
                                (', '.join(new_contributors))

        if comment_text != '':
            comment_text = '<blockquote>%s</blockquote>' % comment_text
            modify_comment = models.TaskComment('내용이 변경되었습니다.',
                                                comment_text, 1, current_user.member,
                                                task)
            db.session.add(modify_comment)
        db.session.commit()

        notification.Push(current_user.member, task.all_contributors(), task,
                          models.NotificationAction.update)
        return task

    @member_required
    @marshal_with(simple_task_fields)
    def get(self, taskID):
        task = models.Task.query.get(taskID)
        if task:
            return task
        return {}
'''
api.add_resource(Task, '/api/task', '/api/task/<int:taskID>')

class DeleteTask(Resource):

    taskParser = reqparse.RequestParser()
    taskParser.add_argument('id', type=int, default=0)

    @member_required
    def post(self):
        args = self.taskParser.parse_args()
        post = models.Task.query.filter_by(id=args['id']).first_or_404()
        if current_user.member.id != post.creator_id:
            return "Not Allowed", 403

        db.session.delete(post)
        db.session.commit()
        return "Success", 200

api.add_resource(DeleteTask, '/api/task/delete')

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
    commentParser = reqparse.RequestParser()
    commentParser.add_argument('title', type=str, required=True,
                               help='Title is required')
    commentParser.add_argument('body', type=str, default='')
    commentParser.add_argument('task_id', type=int, default=-1)
    commentParser.add_argument('redirect', type=str, default='')

    @member_required
    def post(self):
        args = self.commentParser.parse_args()
        task = models.Task.query.get(args['task_id'])
        if not task:
            abort(404)
        task_comment = models.TaskComment(args['title'], args['body'],
                                          0, current_user.member, task)
        db.session.add(task_comment)

        tags = helper.get_tags(task_comment.body)

        for tag in tags:
            tag_data = models.Tag.query.filter_by(title=tag).first()
            if tag_data:
                task_comment.tags.append(tag_data)
            else:
                tag_data = models.Tag(tag)
                task_comment.tags.append(tag_data)
                db.session.add(tag_data)

        files = request.files.getlist("files")

        file_uploaded = False

        for file in files:
            if helper.process_file(file, task_comment):
                file_uploaded = True

        if file_uploaded:
            task_comment.comment_type = 3

        db.session.commit()
        if (args['redirect']):
            notification.Push(current_user.member, task.all_contributors(),
                              task_comment, models.NotificationAction.create)
            return redirect(args['redirect'])

        notification.Push(current_user.member, task.all_contributors(),
                          task_comment, models.NotificationAction.create)
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
    'social': fields.String
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


class Event(Resource):
    class DateFormat(fields.Raw):
        def format(self, date):
            return date.timestamp() * 1000

    event_fields = {
        'id': fields.Integer,
        'title': fields.String(attribute='name'),
        'start': DateFormat(attribute='deadline'),
        'url': fields.String,
        'color': fields.String
    }

    dateParser = reqparse.RequestParser()
    dateParser.add_argument('start', type=str, default='')
    dateParser.add_argument('end', type=str)
    dateParser.add_argument('level', type=int, default=-1)

    @member_required
    @marshal_with(event_fields)
    def get(self):
        args = self.dateParser.parse_args()
        if args['start'] == '':
            return models.Task.query.all()
        start = datetime.strptime(args['start'], '%Y-%m-%d')
        end = datetime.strptime(args['end'], '%Y-%m-%d')

        events = models.Task.query.filter(
            and_(models.Task.deadline >= start,
                 models.Task.deadline < end)).filter(
            not_(and_(models.Task.level == 2,
                      ~models.Task.parents.any()))).filter_by(status=0)
        if args['level'] >= 0:
            events = events.filter_by(level=args['level'])
        events = events.all()
        task_type = ['milestone', 'issue', 'subtask']
        task_color = ['#00c0ef', '#00a65a', '#f39c12', '#dd4b39']
        for event in events:
            event.url = "/stem/%s/%d" % (task_type[event.level], event.id)
            event.color = task_color[event.priority]
            event.name = "[%s] %s" % (event.repr_id(), event.name)

        return events

api.add_resource(Event, '/api/deadlines')