from app import app
from app import db, models, admin, lm
from flask.ext.admin.contrib.sqla import ModelView
from sqlalchemy import func
from flask.ext.login import login_user, logout_user, current_user, login_required
from flask.ext.admin import BaseView

admin_users = ['wwee3631']

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

class HistoryView(AuthModelView):
    def __init__(self, session, **kwargs):
        super(HistoryView, self).__init__(models.Post, session, **kwargs)
    def get_query(self):
        return super(HistoryView, self).get_query().filter(models.Post.board_id == 3)

    def get_count_query(self):
        return super(HistoryView, self).get_count_query().filter(models.Post.board_id == 3)

def adminUsers():


    return render_template('admin_views/user.html', items=items)



admin.add_view(UserView(db.session))
admin.add_view(AuthModelView(models.Member, db.session))
admin.add_view(AuthModelView(models.Board, db.session))
admin.add_view(PostView(db.session, name='Post'))
admin.add_view(HistoryView(db.session, name='History', endpoint='History'))

admin.init_app(app)