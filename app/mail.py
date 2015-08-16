import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email.utils import COMMASPACE, formatdate
from email import encoders
import os

from app.models import User, Member

def sendMail(to, subject, text, html=False, files=[],server="localhost",
    sender='stem_admin@aws.stemsnu.com'):
    if type(to) != list:
        to = [to]
        to = list(map(lambda user: "%s <%s>"%(user.nickname, user.email), to))
    if type(files) != list:
        files = [files]

    msg = MIMEMultipart()
    msg['From'] = sender
    msg['To'] = COMMASPACE.join(to)
    msg['Date'] = formatdate(localtime=True)
    msg['Subject'] = subject

    if html:
        msg.attach( MIMEText(text, 'html') )
    else:
        msg.attach( MIMEText(text) )

    for file in files:
        part = MIMEBase('application', "octet-stream")
        part.set_payload( open(file,"rb").read() )
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="%s"'
                       % os.path.basename(file))
        msg.attach(part)

    smtp = smtplib.SMTP(server)
    smtp.sendmail(sender, to, msg.as_string() )
    smtp.close()

