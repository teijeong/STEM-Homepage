from flask import Blueprint, render_template, abort
from jinja2 import TemplateNotFound

from app import models

member_app = Blueprint('member_app', __name__,
                        template_folder='templates/memberapp')

@member_app.route('/')
def show():
    try:
        return render_template('starter.html', member=models.Member.query.all()[0])
    except TemplateNotFound:
        abort(404)