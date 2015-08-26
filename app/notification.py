from app import models, db
from app.models import ObjectType
from app.models import NotificationAction as Verb
import re
from datetime import datetime, timedelta
from collections import defaultdict


def Push(sender, receivers, target, verb, message=""):
    for receiver in receivers:
        if receiver == sender:
            continue
        noti = models.Notification(sender, receiver,
                                   target, verb, message)
        db.session.add(noti)
    db.session.commit()


def Generate(member):
    limit = datetime.now() - timedelta(days=7)
    query = models.Notification.query
    notifications = query.filter_by(receiver=member) \
                         .filter(models.Notification.timestamp > limit).all()

    descriptions = []
    member_set = set()
    task_time = defaultdict(int)
    task_members = defaultdict(set)
    task_comment_time = defaultdict(int)
    task_comment_members = defaultdict(set)

    for noti in notifications:
        if noti.object_type == ObjectType.Member:
            if noti.object_id in member_set:
                continue
            member_set |= {noti.object_id}
            link = "/stem/people/%d" % noti.sender.id
            descriptions.append(
                NotificationDescription(
                    '[%d]기 %s 님의 정보가 수정되었습니다.' %
                    (noti.sender.cycle, noti.sender.user.nickname),
                    noti.timestamp, link, 'fa-user'))
        elif noti.object_type == ObjectType.Task:
            if task_time[noti.object_id] < noti.timestamp.timestamp():
                task_time[noti.object_id] = noti.timestamp.timestamp()
            task_members[noti.object_id] |= {noti.sender}
        elif noti.object_type == ObjectType.TaskComment:
            comment = models.TaskComment.query.get(noti.object_id)
            if not comment:
                continue
            if task_comment_time[comment.task.id] < noti.timestamp.timestamp():
                task_comment_time[comment.task.id] = noti.timestamp.timestamp()
            task_comment_members[comment.task.id] |= {noti.sender}

    for k, members in task_members.items():
        message = ", ".join(["[%d기] %s" % (m.cycle, m.user.nickname)
                            for m in list(members)[0:2]]) + '님'
        if (len(members) > 2):
            message += '외 %d명' % (len(members)-2)
        task = models.Task.query.get(k)
        if task:
            message += '이 [%s] 업무를 수정했습니다.' % task.to_string()
        else:
            continue
        link = "/stem/task/%d" % task.id
        descriptions.append(
            NotificationDescription(message, task_time[k], link, 'fa-gear'))

    for k, members in task_comment_members.items():
        message = ", ".join(["[%d기] %s" % (m.cycle, m.user.name)
                            for m in list(members)[0:2]]) + '님'
        if (len(members) > 2):
            message += '외 %d명' % (len(members)-2)
        task = models.Task.query.get(k)
        if task:
            message += '이 [%s] 업무에 댓글을 달았습니다.' % task.to_string()
        else:
            continue
        link = "/stem/task/%d" % task.id
        descriptions.append(
            NotificationDescription(message, task_time[k], link,
                                    'fa-comments'))
    return sorted(descriptions, key=lambda noti: -noti.timestamp)


class NotificationDescription:
    icon = ''
    message = ''
    link = ''

    def __init__(self, message, timestamp=datetime.now(), link='', icon=''):
        self.icon = icon
        self.message = message
        self.link = link
        if type(timestamp) == float:
            self.timestamp = timestamp
        else:
            self.timestamp = timestamp.timestamp()

    def __repr__(self):
        return self.message
