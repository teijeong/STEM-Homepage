/** Task Manager Specification
  * Supported Functions
  *   Milestone:
  *     View: Child(Issue)
  *     Modify: Child
  *   Issue:
  *     View: Parent(Milestone), Child(Subtask)
  *     Modify: Parent, Child
  *   Subtask:
  *     View: Parent(Issue)
  *     Modify: Progress
  *   Common:
  *     View: Comment, Deadline, Status, Priority,
  *             Title, Description, Creator, Contributor, Progress
  *     Modify: Deadline, Status, Priority,
  *             Title, Description, Creator, Contributor
  *     Add: Comment
  *   Codes that can be stored here:
  *     Common Functions
  *     If generallization applies, other functions
  *   Implemented by other parts:
  *     Subtask add on Issue: implemented by jinja macro
  */

//python None resolution
var None = undefined;

var Task = function(id, local_id, name, stat, priority, level, progress) {
  this.id = id;
  this.local_id = local_id;
  this.name = name;
  this.status = stat;
  this.priority = priority;
  this.level = level;
  this.progress = progress;
  this.repr = function(parent) {
    switch (this.level) {
      case 0:
        return "M#" + this.local_id;
      break;
      case 1:
        return "#" + this.local_id
      break;
      case 2:
        if (!parent) parent = {local_id:"?"};
        return "#" + parent.local_id + "-" + this.local_id;
      break;
      default:
        return "?#" + this.local_id;
    }
  }
};

var Member = function(id, name, creator) {
    this.id = id;
    this.name = name;
    this.creator = creator || false;
};


var TaskManager = function(level, task, parents, children, contributors) {
  if (level === undefined) level = 0;


  var manager = this;
  this.parents = parents;
  this.children = children;
  this.contributors = contributors;

  var priority_color = ['bg-aqua','bg-green','bg-yellow','bg-red'];
  var priority_text = ['시간날 때','보통','중요','급함'];
  var status_color = ['bg-aqua','bg-green','bg-gray','bg-black'];
  var status_text = ['진행중','완료','보관됨','제외됨'];

  var task_category = ['milestone', 'issue', 'subtask'];
  var task_category_kr = ['마일스톤', '일거리', '세부 업무'];
  var kr_postfix_sbj = ['이', '가', '가'];
  var kr_postfix_obj = ['을', '를', '를'];

  /* Status, Priority Select Control */
  this.init_select = 2;
  $(".box-tools .select-wrapper select").change(function(event) {
    var label_width = [0,16,26,36,46,50];
    var w = label_width[$("option:selected", this).text().length];
    var i = $(this).val();
    $(this).css("width", w + "px");
    if ($(this).hasClass("select-priority")) {
      $(this).parent().removeClass(priority_color.join(' '));
      $(this).parent().addClass(priority_color[i]);
      if (manager.init_select > 0) {
        manager.init_select--;
        return;
      }
      $.ajax({
        url: "/stem/api/task/" + task.id,
        type: "PUT",
        data: {
          priority: Number(i)
        }, error: function(data) {
          alert("중요도를 업데이트하는 중 문제가 발생했습니다.\n다시 시도해주세요.")
        }
      });
    } else {
      $(this).parent().removeClass(status_color.join(' '));
      $(this).parent().addClass(status_color[i]);
      if (manager.init_select > 0) {
        manager.init_select--;
        return;
      }
      $.ajax({
        url: "/stem/api/task/" + task.id,
        type: "PUT",
        data: {
          status: Number(i)
        }, error: function(data) {
          alert("상태를 업데이트하는 중 문제가 발생했습니다.\n다시 시도해주세요.")
        }
      });
    }
  });

  $(".box-tools .select-priority").val(task.priority || 0);
  $(".box-tools .select-status").val(task.status || 0);
  $(".box-tools .select-wrapper select").change();

  /* End Status, Priority Select Control */

  CKEDITOR.disableAutoInline = true;



/* Deadline Control */
  this.dtpicker = undefined;

  $("#edit-deadline").click(function() {
    $('#dtpicker input').datetimepicker({
      locale:'ko',
      defaultDate: moment.unix(task.deadline)
    }).focus();
    dtpicker = $('#dtpicker input').data('DateTimePicker');
  });

  $("#dtpicker input").focusout(function() {
    if(dtpicker.destroyed) return;
    dtpicker.destroyed = true;
    var date = dtpicker.date();
    $("#deadline").text(date.format("YYYY.MM.DD HH:mm"));
    dtpicker.destroy();
    $.ajax({
      url: "/stem/api/task/" + task.id,
      type: "PUT",
      data: {
        deadline: date.unix()
      },
      error :function() {
        alert("마감일 업데이트 중 오류가 발생했습니다.");
      }
    });
  });
  /* End Deadline Control */

  /* Comment Control */
  var comment_editor = CKEDITOR.replace('comment-body',
    {toolbarGroups:[
      { name: 'clipboard',   groups: ['undo' ] },
      { name: 'links' },
      { name: 'insert' },
      { name: 'forms' },
      { name: 'tools' },
      { name: 'others' },
      '/',
      { name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
      { name: 'paragraph',   groups: [ 'list', 'indent', 'blocks', 'align' ] },
      { name: 'styles' },
      { name: 'colors' }]
    });

  /* End Comment Control */

/* Task and Contributor (Modal) Control */

/**** Maintained by each files 

var updated = false;
var old_tasks, old_contributors, old_parent, old_html;
*/
this.old_children = [];
this.old_parents = [];
this.old_html = [];
this.old_contributors = [];
this.updated = false;

manager.selectors = {
  children: {
    modal: "#modal-manage-children",
    show: "#manage-children-open",
    confirm: "#modal-manage-children-confirm",
    cancel: "#modal-manage-children-cancel",
    table: "#table-children",
    list: "#modal-child-list",
    data: ["#task-opened","#task-closed","#task-archived"],
    name: "#task-name",
    description: "#task-description",
    add: "#create-child"
  },
  parents: {
    modal: "#modal-manage-parents",
    show: "#manage-parents-open",
    confirm: "#modal-manage-parents-confirm",
    cancel: "#modal-manage-parents-cancel",
    table: "#table-parents",
    data: ["#parents"],
    remove_control: ".task-badge .command-elem",
    source: "#parents",
    clone: "#modal-parent-list"
  },
  contributors: {
    modal: "#modal-manage-contributors",
    show: "#manage-contributors-open",
    confirm: "#modal-manage-contributors-confirm",
    cancel: "#modal-manage-contributors-cancel",
    table: "#table-members",
    data: ["#contributors"],
    remove_control: ".member-badge .command-elem",
    source: "#contributors",
    clone: "#modal-contributor-list"  
  }
}

function task_box(task_, parent) {
  var html = 
    "<div class='col-md-4 col-sm-6 col-xs-12 task-box' data-task-id='" + task_.id + "'>" +
    "<a href='/stem/task_/" + task_.id + "'>" +
    "<div class='info-box " +
      (task_.status===0?priority_color[task_.priority]:status_color[task_.status]) +
      "'>" +
      "<span class='info-box-icon'><i class='fa fa-exclamation'></i></span>" +
      "<div class='info-box-content'>" +
        "<span class='info-box-number'>" + task_.repr(task) + "</span>" +
        "<span class='info-box-text'>" + task_.name + "</span>" +
      "<div class='progress'>" +
        "<div class='progress-bar' style='width:" + task_.progress + "%'></div>" +
      "</div>" +
    "<span class='progress-description'>" +
    task_.progress + "% 완료" +
  "</span></div></div></a></div>";
  return html;
}

function task_label(task_) {
  var html =
    '<span class="label bg-aqua task-badge"' +
    ' data-task-id=\'' + task_.id + '\'>' + task_.repr(task) + ' ' + task_.name +
    '<i class="fa fa-times command-elem"></i>' +
    '</span>';
  return html;
}

function member_label(member) {
  var html = '<span class="label label-primary member-badge"' +
    ' data-member-id=\'' + member.id + '\'>' + member.name +
    '<i class="fa fa-times command-elem"></i>' +
    '</span>';
  return html;
}

this.createTask = function(name, description, success, error, notChild) {
  $("#child-name").val("");
  child_editor.setData("");
  $.ajax({
    url: "/stem/api/task",
    type: "POST",
    data: {
        name: name,
        description: description,
        level: level + 1,
        parents: notchild?[]:[task.id],
        priority: 0
    },
    success: success,
    error: error
  });
};

this.getTask = function(task_id, success, error) {
  $.ajax({
    url: "/stem/api/task/" + task_id,
    type: "GET",
    success: success,
    error: error
  });
};

this.addChild = function(taskID) {
  manager.getTask(taskID, function(child) {
    child = new Task(child.id, child.local_id, child.name,
      child.status, child.priority, child.level, child.progress);

    manager.children.push(child);

    var controller = manager.selectors.children;

    var label = $(task_label(child)).click(function() { manager.removeTask(child.id, "child"); });
    $(controller.data[child.status]).append(task_box(child, task));
    $(controller.list).append(label);
  });
};

this.updateChild = function() {
  $.ajax({
    url:"/stem/api/task/" + task.id,
    type:"PUT",
    data: {
      children: manager.children.map(function(task) {return task.id;})
    },
    error: function() {
      alert("하위 업무를 업데이트하는중 오류가 발생했습니다.");
    }
  });
}

this.removeTask = function(taskID, type) {
  taskID = Number(taskID);
  if (type === "child") {
    manager.children = manager.children.filter(function(task) {return task.id !== taskID;});
  } else if (type === "parent"){
    manager.parents = manager.parents.filter(function(task) {return task.id !== taskID;});
  } else return;
  var task = $(".task-box[data-task-id='"+taskID+"']");
  task.remove();
  task = $(".task-badge[data-task-id='"+taskID+"']");
  task.remove();
}

this.updateParent = function() {
  $.ajax({
    url:"/stem/api/task/" + task.id,
    type:"PUT",
    data: {
      parents: manager.parents.map(function(task) {return task.id;})
    },
    error: function() {
      alert("상위 업무를 업데이트하는중 오류가 발생했습니다.");
    }
  });
}

this.addParent = function(taskID) {
  taskID = Number(taskID);
  if (manager.parents.find(function(t) {return t.id === taskID;})) {
    alert("already exists.");
    return;
  }
  manager.getTask(taskID,
    function(parent) {
      parent = new Task(parent.id, parent.local_id, parent.name,
        parent.status, parent.priority, parent.level, parent.progress);

      var label = $(task_label(parent)).click(function(){manager.removeTask(parent.id,"parent");});
      var controller = manager.selectors.parents;
      parents.push(parent);
      $(controller.source).append(label);
      $(controller.clone).append(label.clone());
    });
}

//Child task management
if (level == 0 || level == 1) {
  function openChildModal() {
    var controller = manager.selectors.children;
    manager.updated = false;
    manager.old_children = manager.children.slice();
    manager.old_html = controller.data.map(function(sel) {return $(sel).html();});

    $(controller.modal).trigger('openModal');
  }

  function closeChildModalUpdate() {
    var controller = manager.selectors.children;
    manager.updateChild();
    manager.updated = true;
    $(controller.modal).trigger('closeModal');
  }

  function closeChildModal() {
    var controller = manager.selectors.children;
    if (!manager.updated) {
      manager.children = manager.old_children.slice();
      controller.data.map(function(sel,i) {$(sel).html(manager.old_html[i])});
    }
  }

  var controller = manager.selectors.children;
  $(controller.modal).easyModal({onClose: closeChildModal});
  $(controller.show).click(openChildModal)
  $(controller.cancel).click(function() {
    var controller = manager.selectors.children;
    $(controller.modal).trigger('closeModal');
  });
  $(controller.confirm).click(closeChildModalUpdate);
}
// Parent task management
if (level == 1) {

  function openParentModal() {
    var controller = manager.selectors.parents;
    manager.updated = false;
    manager.old_parents = manager.parents.slice();
    manager.old_html = controller.data.map(function(sel) {return $(sel).html();});
    $(controller.clone).html($(controller.source).html());
    $(controller.remove_control).css("display","inline");
    $(controller.modal).trigger('openModal');

    $(controller.clone + " .command-elem").off('click');
    $(controller.clone + " .command-elem").each(function(i, elem) {
      $(elem).click(function() {
        manager.removeTask($(this).parent().attr('data-task-id'),"parent");
      })
    });
  }

  function closeParentModalUpdate() {
    var controller = manager.selectors.parents;
    manager.updateParent();
    manager.updated = true;
    $(controller.modal).trigger('closeModal');
  }

  function closeParentModal() {
    var controller = manager.selectors.parents;
    if (!manager.updated) {
      manager.parents = manager.old_parents.slice();
      controller.data.map(function(sel,i) {$(sel).html(manager.old_html[i]);});
    }
    $(controller.remove_control).css("display","none");
  }

  var controller = manager.selectors.parents;

  $(controller.modal).easyModal({onClose: closeParentModal});
  $(controller.show).click(openParentModal)
  $(controller.cancel).click(function() {
    var controller = manager.selectors.parents;
    $(controller.modal).trigger('closeModal');
  });
  $(controller.confirm).click(closeParentModalUpdate);
}

{
  this.addContributor = function(memberID) {
    memberID = Number(memberID);
    if (manager.contributors.find(function(m) {return m.id === memberID;})) {
      alert("already exists.");
      return;
    }
    $.ajax({
      url: "/stem/api/member/" + memberID,
      type: "GET",
      success: function(member) {
        member = new Member(member.id, member.user.nickname);
        var controller = manager.selectors.contributors;
        var label = $(member_label(member)).click(function(){manager.removeContributor(member.id);});
        manager.contributors.push(member);
        $(controller.source).append(label);
        $(controller.clone).append(label.clone());
      }
    });
  }

  this.updateContributor = function() {
    $.ajax({
      url:"/stem/api/task/" + task.id,
      type:"PUT",
      data: {
        contributor: manager.contributors.map(function(mem) {return mem.id;})
      },
      error: function() {
        alert("참여자를 업데이트하는 중 오류가 발생했습니다.");
      }
    });
  }

  this.removeContributor = function(memberID) {
    memberID = Number(memberID);
    var controller = manager.selectors.contributors;
    member = $(".member-badge[data-member-id='"+memberID+"']");
    member.remove();
    manager.contributors = manager.contributors.filter(function(m) { return m.id !== memberID;});
  }

  function openContributorModal() {
    var controller = manager.selectors.contributors;
    manager.updated = false;
    manager.old_contributors = manager.contributors.slice();
    manager.old_html = $(controller.source).html();
    $(controller.clone).html($(controller.source).html());
    $(controller.remove_control).css("display","inline");
    $(controller.modal).trigger('openModal');

    $(".member-badge .command-elem").off('click');
    $(".member-badge .command-elem").each(function(i, elem) {
      $(elem).click(function() {
        manager.removeContributor($(this).parent().attr('data-member-id'));
      })
    });
  }

  function closeContributorModalUpdate() {
    var controller = manager.selectors.contributors;
    manager.updateContributor();
    manager.updated = true;
    $(controller.modal).trigger('closeModal');
  }

  function closeContributorModal() {
    var controller = manager.selectors.contributors;
    if (!manager.updated) {
      manager.contributors = manager.old_contributors.slice();
      $(controller.source).html(manager.old_html);
    }
    $(controller.remove_control).css("display","none");
  }

  var controller = manager.selectors.contributors;
  $(controller.modal).easyModal({onClose: closeContributorModal});
  $(controller.show).click(openContributorModal)
  $(controller.cancel).click(function() {
    var controller = manager.selectors.contributors;
    $(controller.modal).trigger('closeModal');
  });
  $(controller.confirm).click(closeContributorModalUpdate);
}

var member_table = $(manager.selectors.contributors.table).DataTable({
    ajax: {
      url: "/people",
      dataSrc: ""
    },
    processing: true,
    columns: [
      {data:"cycle"},
      {data:"user.nickname"},
      {data:"stem_dept"},
      {data:"id"}
    ],
    columnDefs: [
      {targets:[3],
        render: function(data, type, row) {
          return "<button class='add btn btn-primary btn-xs' " +
            "data-member-id='" + data + "'>추가</button>";
        }
      }
    ],
    drawCallback: function() {
      $(".add", this).off('click');
      $(".add", this).each(function() {
        $(this).click(function() {
          manager.addContributor($(this).attr('data-member-id'));
        });
      });
    }
});

if (level == 0) {
  var child_table = $(manager.selectors.children.table).DataTable({
    ajax: {
      url: "/stem/api/issue",
      dataSrc: ""
    },
    processing: true,
    columns: [
      {data:"local_id"},
      {data:"name"},
      {data:"id"}
    ],
    columnDefs: [
      {targets:[2],
        render: function(data, type, row) {
          return "<button class='add btn btn-primary btn-xs' " +
            "data-task-id='" + data + "'>추가</button>";
        }
      }
    ],
    drawCallback: function() {
      $(".add", this).off('click');
      $(".add", this).each(function() {
        $(this).click(function() {
          manager.addChild($(this).attr('data-task-id'));
        });
      });
    }
  });
}
if (level == 1) {
  var parent_table = $(manager.selectors.parents.table).DataTable({
    ajax: {
      url: "/stem/api/milestone",
      dataSrc: ""
    },
    processing: true,
    columns: [
      {data:"local_id"},
      {data:"name"},
      {data:"id"}
    ],
    columnDefs: [
      {targets:[2],
        render: function(data, type, row) {
          return "<button class='add btn btn-primary btn-xs' " +
            "data-task-id='" + data + "'>추가</button>";
        }
      }
    ],
    drawCallback: function() {
      $(".add", this).off('click');
      $(".add", this).each(function() {
        $(this).click(function() {
          manager.addParent($(this).attr('data-task-id'));
        });
      });
    }
  });
}
/* End Task and Contributor (Modal) Control */

/* Task Name and Description Control */
var task_txt = '';

function modifyName() {
    $("#task-name").attr("contenteditable", true);
    $("#task-name").focus();
    txt = $("#task-name").text();
}

$("#task-name-modify").click(modifyName);

$("#task-name").focusout(function(event) {
    if ($(this).attr("contenteditable") === "false") return;
    $(this).attr("contenteditable", false);
    var new_txt = $("#task-name").text();

    if (new_txt !== task_txt) {
      $.ajax({
        url:"/stem/api/task/" + task.id,
        type:"PUT",
        data: {
          name: $("#task-name").text()
        },
        error: function() {
          alert("Request failed. Please try again.");
          $(this).attr("contenteditable", true);
        },
        success: function() {
          task_txt = new_txt;
        }
      });
    }
});

$("#task-name").keydown(function(event) {
    if (event.which == 13) {
      $(this).focusout();
    }
});

var description;
var editor;


$("#task-description-modify").click(modifyDescription);

function destroyEditor(confirm) {
  if (!confirm || !editor.checkDirty()) {
    $("#task-description").html(description);
  } else {
    $.ajax({
      url:"/stem/api/task/" + task.id,
      type: "PUT",
      data: {
        description: editor.getData()
      },
      success: function(data) {

      },
      error: function(data) {

      }
    });
  }
  editor.destroy();
  $("#task-description").attr("contenteditable",false);
  $(".editor-control").remove();
}

function modifyDescription() {
  description = $("#task-description").html();
  $("#task-description").attr("contenteditable", true);
  editor = CKEDITOR.inline("task-description");
  var cancel_btn = $("<button type='button' style='margin-right:5px;' class='editor-control btn btn-danger pull-right'>Cancel</button>")
    .click(function() {destroyEditor(false);});
  var confirm_btn = $("<button type='button'class='editor-control btn btn-primary pull-right'>Done</button>")
    .click(function() {destroyEditor(true);});

  $("#task-description").after(cancel_btn);
  $("#task-description").after(confirm_btn);
  $("#task-description").focus();
}

if (level === 0 || level === 1)
  $(manager.selectors.children.list + " .command-elem").each(function(i, elem) {
    $(elem).click(function() {
      manager.removeTask($(this).parent().attr('data-task-id'),"child");
    })
  });
if (level === 1) {
  $(manager.selectors.parents.source + " .command-elem").each(function(i, elem) {
    $(elem).click(function() {
      manager.removeTask($(this).parent().attr('data-task-id'),"parent");
    })
  });
  $(manager.selectors.parents.clone + " .command-elem").each(function(i, elem) {
    $(elem).click(function() {
      manager.removeTask($(this).parent().attr('data-task-id'),"parent");
    })
  });
}

/* End Task Name and Description Control */

/* Progress Control */

this.old_val = task.progress;
this.slider_val = task.progress;
$(".slider").css("display","none");

$("#edit-progress").click(function() {
  $(".slider").slider().css("display","default");
  $(".progress").css("display","none");
  $("#progress-control").css("display","block");
  $(".slider").slider({
    min: 0,
    max: 100,
    step: 1,
    value: task.progress,
    tooltip:'hide',
    id: 'green'
  });
  $(".slider").on("slide", function(evt) {
    manager.slider_val = evt.value;
    $(".progress-text").text(manager.slider_val);
  });
});

$("#progress-cancel").click(function() {
  $(".progress").css("display","block");
  $(".slider").css("display","none");
  $("#progress-control").css("display","none");
  $(".progress-text").text(manager.old_val);
});

$("#progress-confirm").click(function() {
  $.ajax({
    url: "/stem/api/task/" + task.id,
    type: "PUT",
    data: {
      progress: manager.slider_val
    },
    success: function() {
      $(".progress .progress-bar").css("width", manager.slider_val + "%");
      $(".progress-text").text(manager.slider_val);
      $("#progress-control").css("display","none");
      $(".progress").css("display","block");
      $(".slider").css("display","none");
      manager.old_val = manager.slider_val;
    },
    error: function() {
      alert("진행도를 업데이트하는 중 오류가 발생했습니다.")
    }
  });
});
/* End Progress Control */
}
