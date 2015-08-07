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
  */


var TaskManager = function(level) {
  if (level === undefined) level = 0;

  //python None resolution
  var None = undefined;

  var priority_color = ['bg-aqua','bg-green','bg-yellow','bg-red'];
  var priority_text = ['시간날 때','보통','중요','급함'];
  var status_color = ['bg-aqua','bg-green','bg-gray','bg-black'];
  var status_text = ['진행중','완료','보관됨','제외됨'];

  /* Status, Priority Select Control */
  var init_select = 2;
  $(".select-wrapper select").change(function(event) {
    var label_width = [0,16,26,36,46,50];
    var w = label_width[$("option:selected", this).text().length];
    var i = $(this).val();
    $(this).css("width", w + "px");
    if ($(this).hasClass("select-priority")) {
      $(this).parent().removeClass(priority_color.join(' '));
      $(this).parent().addClass(priority_color[i]);
      if (init_select > 0) {
        init_select--;
        return;
      }
      $.ajax({
        url: "/stem/api/task/{{task.id}}",
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
      if (init_select > 0) {
        init_select--;
        return;
      }
      $.ajax({
        url: "/stem/api/task/{{task.id}}",
        type: "PUT",
        data: {
          status: Number(i)
        }, error: function(data) {
          alert("상태를 업데이트하는 중 문제가 발생했습니다.\n다시 시도해주세요.")
        }
      });
    }
  });

  $(".select-priority").val({{task.priority}} || 0);
  $(".select-status").val({{task.status}} || 0);
  $(".select-wrapper select").change();

  /* End Status, Priority Select Control */

  CKEDITOR.disableAutoInline = true;

  /* Modal Control */
  $("#add-child").easyModal({onClose: closeTaskModal});
  $("#add-contributor").easyModal({onClose: closeMemberModal});
  $("#add-parent").easyModal({onClose: closeParentModal});

  $("#member-close").click(function() {
    $("#add-contributor").trigger('closeModal');
  });
  $("#child-close").click(function() {
    $("#add-child").trigger('closeModal');
  });
  $("#parent-close").click(function() {
    $("#add-parent").trigger('closeModal');
  });

  $('#child-description').attr('contenteditable',true);

  var child_editor = CKEDITOR.replace('child-description',
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

  function openMemberModal() {
    updated = false;
    old_contributors = contributors.slice();
    old_html = $("#contributors").html();
    $("#modal-contributors").html($("#contributors").html());
    $(".contributor-badge .command-elem").css("display","inline");
    $("#add-contributor").trigger('openModal');
  }

  function closeMemberModalUpdate() {
    updateContributor();
    updated = true;
    $("#add-contributor").trigger('closeModal');
  }

  function closeMemberModal() {
    if (!updated) {
      contributors = old_contributors.slice();
      $("#contributors").html(old_html);
    }
    $(".contributor-badge .command-elem").css("display","none");
  }

  function openParentModal() {
    updated = false;
    old_parents = parents.slice();
    old_html = $("#parents").html();
    $("#modal-parents").html($("#parents").html());
    $(".task-badge .command-elem").css("display","inline");
    $("#add-parent").trigger('openModal');
  }

  function closeParentModalUpdate() {
    updateParent();
    updated = true;
    $("#add-parent").trigger('closeModal');
  }

  function closeParentModal() {
    if (!updated) {
      parents = old_parents.slice();
      $("#parents").html(old_html);
    }
    $(".task-badge .command-elem").css("display","none");
  }

  function openTaskModal() {
    updated = false;
    old_tasks = tasks.slice();
    old_html = [$("#task-opened").html(), $("#task-closed").html(),
      $("#task-archived").html(), $("#modal-tasks").html()];
    $("#add-task").trigger('openModal');
  }

  function closeTaskModalUpdate() {
    updateTask();
    updated = true;
    $("#add-task").trigger('closeModal');
  }

  function closeTaskModal() {
    if (!updated) {
      tasks = old_tasks.slice();
      var task_pane = [$("#task-opened"), $("#task-closed"),
        $("#task-archived"), $("#modal-tasks")];
      for (var i in task_pane) task_pane[i].html(old_html[i]);
    }
  }

}


/* End Modal Control */



/* Deadline Control */
var dtpicker;

$("#edit-deadline").click(function() {
  $('#dtpicker input').datetimepicker({
    locale:'ko',
    defaultDate: moment.unix({{task.deadline.timestamp()}})
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
    url: "/stem/api/task/{{task.id}}",
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

function addComment(taskID) {
  var title = $("#comment-title").val();
  var body = $("#comment-body").val();
  if (title === "") return;
  $("#comment-title").val("");
  $("#comment-body").val("");
  $.ajax({
    url: "/stem/api/task_comment",
    type:"POST",
    data: {
      title: title,
      body: body,
      task_id: taskID
    },
    success: function(data) {
      location.reload();
    }
  });
}
/* End Comment Control */

/* Task and Contributor (Modal) Control */
var updated = false;
var old_tasks, old_contributors, old_parent, old_html;

var Task = function(id, local_id, name, stat, priority) {
    this.id = id;
    this.local_id = local_id;
    this.name = name;
    this.stat = stat;
    this.priority = priority;
};

var Member = function(id, name, creator) {
    this.id = id;
    this.name = name;
    this.creator = creator || false;
};

var parents = [
    {% for task in task.parents %}
    new Task({{task.id}}, {{task.local_id}}, "{{task.name}}",
        {{task.status}}, {{task.priority}}){% if not loop.last %}, {% endif %}
    {% endfor %}
];

var tasks = [
    {% for task in task.children %}
    new Task({{task.id}}, {{task.local_id}}, "{{task.name}}",
        {{task.status}}, {{task.priority}}){% if not loop.last %}, {% endif %}
    {% endfor %}
];

var contributors = [
    {% for member in task.contributors %}
    new Member({{member.id}}, "{{member.user.nickname}}"),
    {% endfor %}
    new Member({{task.creator.id}}, "{{task.creator.user.nickname}}", true)
];


function addTask() {
  var box_color = ['bg-red','bg-yellow','bg-green','bg-aqua'];
  var box_color2 = ['bg-red','bg-green','bg-gray', 'bg-black'];
  var task_pane = [$("#task-opened"), $("#task-closed"), $("#task-archived")];
  var name = $("#child-name").val();
  var description = child_editor.getData();
  $("#child-name").val("");
  child_editor.setData("");
  $.ajax({
    url: "/stem/api/task",
    type: "POST",
    data: {
        name: name,
        description: description,
        level: 2,
        parent: {{task.id}},
        priority: 0
    },
    success: function(task) {

      var taskbox_html =
        "<div class='col-md-4 col-sm-6 col-xs-12 task-box' data-task-id='" + task.id + "'>" +
          "<a href='/stem/child/" + task.id + "'>" +
          "<div class='info-box " + (task.status===0?box_color[task.priority]:box_color2[task.status]) + "'>" +
            "<span class='info-box-icon'><i class='fa fa-wrench'></i></span>" +
            "<div class='info-box-content'>" +
              "<span class='info-box-number'>#{{task.local_id}}-" + task.local_id +
              "</span>" +
              "<span class='info-box-text'>" + task.name + "</span>" +
            "<div class='progress'>" +
              "<div class='progress-bar' style='width:" + task.progress + "%'></div>" +
            "</div>" +
          "<span class='progress-description'>" +
          task.progress + "% 완료" +
        "</span></div></div></a></div>";

      var html =
        '<span class="label label-primary task-badge"' +
        ' data-task-id=\'' + task.id + '\'>#' + task.id + " " + task.name +
        '<i class="fa fa-times command-elem" onclick="removeTask(' +
          task.id + ')"></i>' +
        '</span>';
      tasks.push(new Task(task.id, task.local_id, task.name, task.status, task.priority));
      task_pane[task.status].append(taskbox_html);
      $("#modal-tasks").append(html);
      closeTaskModalUpdate();
    },
    error: function() {
      alert("세부 업무를 추가하는 중 오류가 발생했습니다.");
      $("#child-name").val(name);
      child_editor.setData(description);
    }
  });
}


function removeTask(taskID) {
  var task = $(".task-box[data-task-id='"+taskID+"']");
  task.remove();
  task = $(".task-badge[data-task-id='"+taskID+"']");
  task.remove();
  tasks = tasks.filter(function(task) {return task.id !== taskID;});
}

function updateTask() {
  $.ajax({
    url:"/stem/api/task/" + {{task.id}},
    type:"PUT",
    data: {
      children: tasks.map(function(task) {return task.id;})
    },
    error: function() {
      alert("Error occured while updating children");
    }
  });
}
function addParent(taskID) {
    if (parents.find(function(t) {return t.id === taskID;})) {
      alert("already exists.");
      return;
    }
    $.ajax({
      url: "/stem/api/task/" + taskID,
      type: "GET",
      success: function(task) {
        var html = '<span class="label label-info task-badge"' +
          ' data-task-id=\'' + task.id + '\'><small>[M#' +
          task.local_id + '</small> ' + task.name +
          '<i class="fa fa-times command-elem" onclick="removeParent(' +
            task.id + ')"></i>' +
          '</span>';
        $("#parents").append(html);
        parents.push(new Task(task.id, task.local_id, task.name, task.status, task.priority));
        $("#modal-parents").html($("#parents").html());
      }
    });
}

function updateParent() {
  $.ajax({
    url:"/stem/api/task/{{task.id}}",
    type:"PUT",
    data: {
      parent: parents.map(function(task) {return task.id;})
    },
    error: function() {
      alert("마일스톤을 업데이트하는 중 오류가 발생했습니다.");
    }
  });
}

function removeParent(taskID) {
  task = $(".task-badge[data-task-id='"+taskID+"']");
  task.remove();
  $("#modal-parents").html($("#parents").html());
  parents = parents.filter(function(t) { return t.id !== taskID;});
}

function addContributor(memberID) {
    if (contributors.find(function(m) {return m.id === memberID;})) {
      alert("already exists.");
      return;
    }
    $.ajax({
      url: "/stem/api/member/" + memberID,
      type: "GET",
      success: function(member) {
        var html = '<span class="label label-primary contributor-badge"' +
          ' data-member-id=\'' + member.id + '\'>' + member.user.nickname +
          '<i class="fa fa-times command-elem" onclick="removeContributor(' +
            member.id + ')"></i>' +
          '</span>';
        $("#contributors").append(html);
        contributors.push(new Member(member.id, member.user.nickname));
        $("#modal-contributors").html($("#contributors").html());
      }
    });
}

function updateContributor() {
  $.ajax({
    url:"/stem/api/task/{{task.id}}",
    type:"PUT",
    data: {
      contributor: contributors.map(function(mem) {return mem.id;})
    },
    error: function() {
      alert("Error occured while updating contributors");
    }
  });
}

function removeContributor(memberID) {
  member = $(".contributor-badge[data-member-id='"+memberID+"']");
  member.remove();
  $("#modal-contributors").html($("#contributors").html());
  contributors = contributors.filter(function(m) { return m.id !== memberID;});
}

var member_table = $('#members').DataTable({
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
                return "<button class='btn btn-primary btn-xs' " +
                "onclick='addContributor(" + data + ")'>Add</button>";
            }
        }
    ]
});

var child_table = $('#children').DataTable({
    ajax: {
      url: "/stem/api/subtask/{{task.id}}",
      dataSrc: ""
    },
    processing: true,
    columns: [
        {data:"local_id"},
        {data:"name"},
        {data:"id"}
        ],
    columnDefs: [
        {targets:[0],
          render: function(data, type, row) {
            return "{{task.local_id}}" + data;
          }
        },
        {targets:[2],
            render: function(data, type, row) {
                return "<button class='btn btn-primary btn-xs' onclick='addTask(" +
                    data + ")'>Add</button>";
            }
        }
    ]
});

var parent_table = $('#table-parents').DataTable({
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
                return "<button type='button' class='btn btn-primary btn-xs' onclick='addParent(" +
                    data + ")'>Add</button>";
            }
        }
    ]
});
/* End Task and Contributor (Modal) Control */

/* Task Name and Description Control */
var task_txt = '';

function modifyName() {
    $("#task-name").attr("contenteditable", true);
    $("#task-name").focus();
    txt = $("#task-name").text();
}

$("#task-name").focusout(function(event) {
    if ($(this).attr("contenteditable") === "false") return;
    $(this).attr("contenteditable", false);
    var new_txt = $("#task-name").text();

    if (new_txt !== task_txt) {
      $.ajax({
        url:"/stem/api/task/{{task.id}}",
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

function modifyDescription() {
  description = $("#task-description").html();
  $("#task-description").attr("contenteditable", true);
  editor = CKEDITOR.inline("task-description");
  $("#task-description").after("<button type='button' style='margin-right:5px;' class='editor-control btn btn-danger pull-right' onclick='destroyEditor(false)'>Cancel</button>");
  $("#task-description").after("<button type='button' class='editor-control btn btn-primary pull-right' onclick='destroyEditor(true)'>Done</button>");
  $("#task-description").focus();
}

function destroyEditor(confirm) {
  if (!confirm || !editor.checkDirty()) {
    $("#task-description").html(description);
  } else {
    $.ajax({
      url:"/stem/api/task/{{task.id}}",
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

/* End Task Name and Description Control */