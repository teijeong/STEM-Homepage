from app import models, db
from app.models import ObjectType
from app.models import NotificationAction as Verb
import re

def Push(sender, receivers, target, verb, message):
    type_parser = re.compile('models\.(\w*)')
    try:
        target_type = type_parser.findall(str(type(target)))[0]
    except IndexError:
        print("Invalid Object type")
    target_type = ObjectType[target_type]

    for receiver in receivers:
        noti = models.Notification(sender=sender,receiver=receiver,
            object_type=target_type,object_id=target.id,
            verb=verb,message=message)
        db.session.add(noti)
    db.session.commit()
