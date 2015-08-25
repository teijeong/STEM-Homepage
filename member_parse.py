from app import db, models
import uuid
from datetime import datetime

fin = open('members.csv', 'r')
lst = [data.split(',') for data in fin.read().split('\n')]

departments = models.Department.query.all()
dept_dict = dict()

for dept in departments:
    dept_dict[dept.name[0:2]] = dept

cnt = 0
for person in lst:
    cnt += 1
    user = models.User.query.filter_by(nickname=person[1])
    if user.count() > 0:
        print (person[1] + " EXIST")
        continue
    if not person[3]:
        person[3] = 'stem_member_%d@stemsnu.com' % cnt
    user = models.User('stem_member_%d' % cnt,
                       str(uuid.uuid4()), person[1], person[3])
    member = models.Member(user)
    member.cycle = int(person[0][0])
    member.phone = person[2]
    member.department = dept_dict[person[6][0:2]]
    if person[4]:
        member.birthday = datetime.strptime(person[4], '%Y. %m. %d').date()
    else:
        member.birthday = datetime(1970, 1, 1).date()

    print(user, end=', ')
    print(member.department, end=', ')
    print(member.birthday)
    db.session.add(user)
    db.session.add(member)

db.session.commit()
