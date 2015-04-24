$(document).ready(()->
  textField = $('.swatch-field--url').each((i, e)->
    $uploader = $('<input type="file" data-text-field="' + e.id  + '" class="' + $(e).attr('class') + '">').change((ev)->
      file = ev.currentTarget.files[0]

      urlAPI = if (typeof URL != "undefined") then URL else (if (typeof webkitURL != "undefined") then webkitURL else null)

      # Handle one upload at a time
      if /image/.test(file.type)
        onFileUpload(urlAPI.createObjectURL(file));

        upload($(this), file, (data)->
            console.log('success!', data)
            if data && data.file && data.file.url
              $('#' + this.data().textField).val(data.file.url)
          , ()->
            console.log('error!', arguments)
        );
    ).hide();

    $preview = $('<img class="swatch-field--preview">').hide()
    $uploadNew = $('<input type="button" value="Remove">').click(()->
      # $(this).parent().remove();
    )
    $preview.after($uploadNew)

    urlValue = $(e).val();
    if urlValue == ''
      $uploader.show()
    else
      $preview.attr('src', urlValue).show();

    $(e).attr('type', 'hidden').after($uploader).after($preview)
  )

  $('.enable-swatch-toggle').change(()->
    self = $(this)

    fields = $(self.data().fields)
    if this.checked
      if this.value == 'none'
        fields.attr('disabled', '')
      else
        fields.attr('disabled', '').filter('[type="' + this.value + '"]').removeAttr('disabled')
  ).change()

  onFileUpload = (url)->
    $('body').append($('<img>', { src: url }))

  upload = (context, file, success, error)->
    uid  = [(new Date()).getTime(), 'raw'].join('-')
    data = new FormData()

    data.append('attachment[name]', file.name)
    data.append('attachment[file]', file)
    data.append('attachment[uid]', uid)

    callbackSuccess = (data)->
      console.log('Upload callback called')

      if typeof(success) == 'function'
        success.apply(context, arguments);

    callbackError = (jqXHR, status, errorThrown)->
      console.log('Upload callback error called')

      if typeof(error) == 'function'
        error.call(context, status)

    xhr = $.ajax({
      url: config.uploadUrl
      data: data
      cache: false
      contentType: false
      processData: false
      dataType: 'json'
      type: 'POST'
    })

    xhr.done(callbackSuccess).fail(callbackError)

  config = {
    uploadUrl: '/admin/attachments'
  }

  TabGroupOption = (selector)->
    if typeof selector == 'string'
      return new TabGroupOption($(selector))
    else if 1 < selector.length
      return selector.each((i, e)->
        new TabGroupOption($(e))
      )

    this.getTab = (obj)->
      $('label[for="' + obj.attr('id') + '"]')

    this.obj = selector
    this.tab = this.getTab(this.obj)
    this.allTabOptions = $('[name="' + this.obj.attr('name') + '"]')

    this.clearTabStates = ()->
      this.allTabOptions.each(((i, e)->
        $me = $(e)
        tab = this.getTab($me)
        tab.removeClass('is-active')
        $me.next().find('input').attr('disabled', 'disabled')
      ).bind(this))

    # # TODO: find better name
    # this.clearTabContentStates = ()->
    #   tab.toggleClass('is-active', isActive)



    this.obj.change(((ev)->
      el = ev.target
      if el.checked
        # set others as not active
        this.clearTabStates()
        this.tab.toggleClass('is-active', el.checked)
        $(el).next().find('input').removeAttr('disabled')
      ).bind(this)
    ).change()

    this.obj

  g = new TabGroupOption('.tab-group--option')
  console.log g
)
