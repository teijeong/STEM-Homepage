#-*- coding:utf-8 -*-
from app import db
from app import models

user = models.User('user', '1234', 'nickname', 1, 'user@stem.kr')
board1 = models.Board('Notice', 'notice')
board1.id = 1
board2 = models.Board('Q&A', 'questions and answers')
board2.id = 2

db.create_all()
db.session.add(user)
db.session.add(board1)
db.session.add(board2)
db.session.commit()
