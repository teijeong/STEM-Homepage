from app import app
from app import db, models, admin, lm
from flask.ext.admin.contrib.sqla import ModelView
from sqlalchemy import func
from flask.ext.login import login_user, logout_user, current_user, login_required
from flask.ext.admin import BaseView, expose
from flask_admin import form
from flask_wtf import Form
from wtforms import StringField, DateField, BooleanField
from wtforms.validators import DataRequired, ValidationError
import datetime

admin_users = ['wwee3631', 'stem_admin']

class AuthView(BaseView):
    @login_required
    def is_accessible(self):
        return current_user.username in admin_users

class AuthModelView(ModelView):
    @login_required
    def is_accessible(self):
        return current_user.username in admin_users

class UserView(AuthModelView):
    column_list = ('username', 'nickname', 'email', 'member')
    def __init__(self, session, **kwargs):
        super(UserView, self).__init__(models.User, session, **kwargs)
    
class PostView(AuthModelView):
    def __init__(self, session, **kwargs):
        super(PostView, self).__init__(models.Post, session, **kwargs)
    def get_query(self):
        return super(PostView, self).get_query().filter(models.Post.board_id != 3)

    def get_count_query(self):
        return super(PostView, self).get_count_query().filter(models.Post.board_id != 3)

class HistoryForm(Form):
    start = DateField('Start', validators=[DataRequired()],
        widget=form.DatePickerWidget())
    one_day = BooleanField('One-day event')
    end = DateField('End', widget=form.DatePickerWidget())
    description = StringField('description', validators=[DataRequired()])

    def validate_end(form, field):
        if not form.one_day.data:
            if form.start.data > field.data:
                raise ValidationError('Start date should be earlier than end date')


class HistoryView(AuthModelView):
    form = HistoryForm
    def __init__(self, session, **kwargs):
        super(HistoryView, self).__init__(models.Post, session, **kwargs)
    def get_query(self):
        return super(HistoryView, self).get_query().filter(models.Post.board_id == 3)

    def get_count_query(self):
        return super(HistoryView, self).get_count_query().filter(models.Post.board_id == 3)

    def create_model(self, form):
        """
            Create model from form.
            :param form:
                Form instance
        """
        try:
            end = None
            if not form.one_day.data:
                end = form.end.data
            model = models.Post.historyPost(form.description.data,
                form.start.data, end)
            self.session.add(model)
            self._on_model_change(form, model, True)
            self.session.commit()
        except Exception as ex:
            if not self.handle_view_exception(ex):
                flash(gettext('Failed to create record. %(error)s', error=str(ex)), 'error')
                log.exception('Failed to create record.')

            self.session.rollback()

            return False
        else:
            self.after_model_change(form, model, True)

        return True


class HistoryListView(AuthView):
    @expose('/')
    def index(self):
        items = db.session.query(models.Post).filter(models.Post.board_id == 3).\
            order_by(models.Post.timestamp.desc()).all()
        for post in items:
            post.period = post.timestamp.strftime('%y.%m.%d')
            if post.body and post.body != '':
                endDate = datetime.datetime.utcfromtimestamp(float(post.body))
                post.period = post.period + ' ~ ' + endDate.strftime('%y.%m.%d')
        return self.render('admin_views/history.html', items=items)



def adminUsers():


    return render_template('admin_views/user.html', items=items)



admin.add_view(UserView(db.session))
admin.add_view(AuthModelView(models.Member, db.session))
admin.add_view(AuthModelView(models.Board, db.session))
admin.add_view(PostView(db.session, name='Post'))
admin.add_view(HistoryView(db.session, name='History', endpoint='History'))
admin.add_view(HistoryListView(name='HistoryList', endpoint='history-list'))
admin.init_app(app)