class FileManagerPage
  constructor: ->
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

$(document).ready ->
  new FileManagerPage if $('#file-manager').length > 0
