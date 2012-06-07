window.DefineProcessors = class DefineProcessors
  constructor: ->
    @editInput = undefined

  showProcessor: (element, show) ->
    if @editInput == undefined
      if(show)
        ($ '#processor_table_' + element.id).show()
      else
        ($ '.processor_table').hide()

  toggleEditProcessor: (element) ->
    if @editInput != undefined
      @setEditState(@editInput, false)
      @editInput = undefined
    else
      @setEditState(element, true)
      @editInput = element

  setEditState: (element, edit) ->
    if edit
      $(element).addClass('edited')
      $($('#processor_table_' + element.id + ' table')[0]).addClass('edited')
      $($('#processor_table_' + element.id + ' h4.processor_table_title')).hide()
      $($('#processor_table_' + element.id + ' h4.edit_processor_table_title')).show()
    else
      $(element).removeClass('edited')

      $.each(($ 'input.argument'), (index, element) -> $(element).val(''))
      rows = ($ '#processor_' + element.id + ' table .processor_row')
      
      rows.slice(1, rows.length).remove() if rows.length > 1   

      $($('#processor_table_' + element.id + ' table')[0]).removeClass('edited')
      $($('#processor_table_' + element.id + ' h4.processor_table_title')).show()
      $($('#processor_table_' + element.id + ' h4.edit_processor_table_title')).hide()

  addProcessorRow: (element) ->
    row   = $(element).closest('tr').first()
    clone = $(row).clone()
    id    = parseInt($(clone.children()[0]).text()) + 1

    self = @

    $(clone).attr('id', id)
    $(clone.children()[0]).html(id)
    $(clone.children()[1]).contents().attr('name', 'processor_' + id)
    $(clone.children()[2]).contents().attr('name', 'argument_' + id)
    $(clone.children()[2]).contents().val('')
    $(clone.children()[3]).contents().bind 'click', -> self.addProcessorRow(this)

    $(row.children()[3]).html('')
    $(clone).insertAfter(row)

  postProcessorData: (event, element) ->
    id = element.id.match(/\d+$/)[0]
    form = ($ '#processor_form_input_' + id)
    $.ajax
      url: '/api/v1/inputs/' + id,
      type: 'POST',
      data: form.serialize(),
      success: (response) ->
        ($ 'tr#input_' + id).click()
        ($ '#processor_table_input_' + id).hide(500)
      datatype: 'js'

  bindEvents: ->
    self = @
    ($ '.addProcessorRow').bind 'click', ->self.addProcessorRow(this)
    ($ 'tr.input').bind 'mouseenter', -> self.showProcessor(this, true)
    ($ 'tr.input').bind 'mouseleave', -> self.showProcessor(this, false)
    ($ 'tr.input').bind 'click', -> self.toggleEditProcessor(this)
    ($ 'a.cancel').bind 'click', -> self.toggleEditProcessor(this)
    ($ 'a.control').bind 'click', (e) -> self.postProcessorData(e, this)

jQuery -> 
  defineProcessors = new DefineProcessors
  defineProcessors.bindEvents()