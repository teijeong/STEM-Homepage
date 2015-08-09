from app import app, db, models
from werkzeug import secure_filename
import uuid, os
import re

# returns tuple (add, sub)
# add: elements that are added to target
# sub: elements that are removed from original 
def list_diff(original, target):
	original = set(original)
	target = set(target)
	return (list(target-original), list(original-target))


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in app.config['ALLOWED_EXTENSIONS']

def process_file(file, parent):
    if not file:
        return False
    filename = secure_filename(file.filename)
    if not allowed_file(filename):
        return False
    extension = ''
    if '.' in filename:
        extension = filename.rsplit('.',1)[1]

    save_name = str(uuid.uuid4()).replace('-','') + '.%s' % extension
    file_data = models.File(filename, save_name, parent)
    db.session.add(file_data)

    file.save(os.path.join(app.config['UPLOAD_FOLDER'], save_name))

    return file_data

def get_tags(text):
    html = re.compile('<.*?>')
    tag = re.compile('#\w+')
    reject = re.compile('#\d+')
    words = re.split("\s+",html.sub(' ', text))
    print(words)
    tags = []
    for word in words:
        if not word:
            continue
        match = tag.match(word)
        if match and not reject.match(word):
            tags.append(match.group(0)[1:].lower())
    return tags
