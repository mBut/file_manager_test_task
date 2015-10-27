class FileManagerPage
  constructor: ->
    if $('#file-manager').length > 0
      @$scope = $('#file-manager')
      @$new_file_form = $('form#new_file_uploader', @$scope)
      @bind()

  bind: ->
    @$scope.dropzone
      method: 'post'
      url: @$new_file_form.attr('action')
      previewTemplate : '<div style="display:none"></div>'
      sending: (file, xhr, formData) ->
        $.ajax
          type: 'POST'
          url: '/file_manager/file_upload_credentials'
          dataType: 'json'
          async: false
          success: (data) ->
            $.each data, (k, v) ->
              formData.append(k, v)
      success: (file, serverResponse, event) ->
        key = $(serverResponse).find('Key').text()
        window.location = "#{window.location.pathname}/file_uploaded?key=#{key}"

    @$new_file_form.on 'change', =>
      @$new_file_form.submit()

    $("#upload-file-btn", @$scope).on 'click', =>
      $("input[type='file']", @$new_file_form).trigger('click')

    $('.draggable-file', @$scope).draggable
      containment: @$scope
      helper: (e) ->
        $el = $(e.currentTarget)

        fileName = $el.find('.file-name > span').text()
        $("<div/>")
          .addClass 'panel panel-default'
          .css
            padding: '10px'
          .text fileName

    $('.folder', @$scope).droppable
      drop: (e, ui) ->
        $folder = $(this)
        $el = $(ui.draggable)

        $.ajax
          method: 'POST'
          url: $('a:first-child', $folder).attr('href') + '/move_object'
          data:
            object:
              type: $el.data('type')
              id: $el.data('id')
          success: ->
            $el.remove()


$(document).ready -> new FileManagerPage
$(document).on 'page:load', -> new FileManagerPage
