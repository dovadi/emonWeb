var editInput;

function showProcessor(element, show) {
  if(editInput == undefined){
    if(show){
      $('#processor_table_' + element.id).show();
    } else {
      $('.processor_table').hide();
    };
  };
};

function toggleEditProcessor(element){
  if(editInput != undefined){
    setEditState(editInput, false);
    editInput = undefined;
  } else {  
    setEditState(element, true);
    editInput = element;
  };
}

function setEditState(element, edit){
  if(edit){
    $(element).addClass('edited');
    $($('#processor_table_' + element.id + ' table')[0]).addClass('edited');
    $($('#processor_table_' + element.id +' h4.processor_table_title')).hide();
    $($('#processor_table_' + element.id +' h4.edit_processor_table_title')).show();
  } else {
    $(element).removeClass('edited');

    $.each($('input.argument'),function(index, element) {$(element).val('')});
    rows = $('#processor_' + element.id + ' table .processor_row');
    if (rows.length > 1){
      rows.slice(1, rows.length).remove();
    };

    $($('#processor_table_' + element.id + ' table')[0]).removeClass('edited');
    $($('#processor_table_' + element.id +' h4.processor_table_title')).show();
    $($('#processor_table_' + element.id +' h4.edit_processor_table_title')).hide();
  };
};

function addProcessorRow(element) {
  var row   = $(element).closest('tr').first();
  var clone = $(row).clone();
  var id    = parseInt($(clone.children()[0]).text()) + 1;

  $(clone).attr('id', id);
  $(clone.children()[0]).html(id);
  $(clone.children()[1]).contents().attr('name', 'processor_' + id);
  $(clone.children()[2]).contents().attr('name', 'argument_' + id);
  $(clone.children()[2]).contents().val('')
  $(clone.children()[3]).contents().bind('click', function() { addProcessorRow(this) });

  $(row.children()[3]).html('');
  $(clone).insertAfter(row);
};

function postProcessorData(event, element){
  id = element.id.match(/\d+$/)[0];
  form = $('#processor_form_input_' + id);
  $.ajax({
    url: '/api/v1/inputs/' + id,
    type: 'POST',
    data: form.serialize(),
    success: function(response) {
      $('tr#input_' + id).click()
      $('#processor_table_input_' + id).hide(500);
    },
    datatype: 'js'
  });
};

function disableEnterKey(e)
{
  var key = (window.event) ? event.keyCode : e.which;
  return (key != 13);
}

$(function() {
  $('.addProcessorRow').bind('click', function() { addProcessorRow(this) });
  $('tr.input').bind('mouseenter', function(){showProcessor(this, true)});
  $('tr.input').bind('mouseleave', function(){showProcessor(this, false)});
  $('tr.input').bind('click', function(){toggleEditProcessor(this)});
  $('a.cancel').bind('click', function(){toggleEditProcessor(this)});
  $('a.control').bind('click', function(e) {postProcessorData(e, this)});
  $('input').bind('keypress', function(e) {return disableEnterKey(e)});
});