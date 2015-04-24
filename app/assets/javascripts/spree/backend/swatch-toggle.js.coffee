$(document).ready(()->

  Uploader = (selector)->
    if typeof(selector) == 'string'
      return new Uploader($(selector))

    if 1 < selector.length
      return selector.each((i, e)->
        new Uploader($(e))
      )

    this.config = {
      uploadUrl: '/admin/attachments'
    }

    this.obj = selector
    this.value = null
    this.uploader = $('<input type="file">')
    this.uploaderContainer = $('<label class="file-uploader"><div class="file-uploader--container">Upload File</div></label>').append(this.uploader)
    this.image = $('<img class="no-image">')
    this.removeButton = $('<button class="preview--remove">remove</button>')
    this.previewContainer = $('<div class="preview-container is-empty">')
      .append(this.image).append(this.removeButton)


    this.doUpload = (context, file, success, error)->
      # this just returns a random image
      # window.setTimeout(()->
      #   success.apply(context, [{ file: { url: 'http://api.adorable.io/avatars/30/' + (new Date).getTime() + '.png' }}])
      # , 1000)
      uid  = [(new Date()).getTime(), 'raw'].join('-')
      data = new FormData()

      data.append('attachment[name]', file.name)
      data.append('attachment[file]', file)
      data.append('attachment[uid]', uid)

      callbackSuccess = (data)->
        if typeof(success) == 'function'
          success.apply(context, arguments);

      callbackError = (jqXHR, status, errorThrown)->
        if typeof(error) == 'function'
          error.call(context, status)

      xhr = $.ajax({
        url: this.config.uploadUrl
        data: data
        cache: false
        contentType: false
        processData: false
        dataType: 'json'
        type: 'POST'
      })

      xhr.done(callbackSuccess).fail(callbackError)


    this.setValue = (val)->
      this.value = val
      this.obj.val(val)
      this.image.attr('src', val)
      if val != ''
        this.uploaderContainer.hide()
        this.previewContainer.removeClass('is-empty')
      else
        this.uploaderContainer.show()
        this.previewContainer.addClass('is-empty')

    this.clearValue = ()->
      this.setValue('')
      this.uploaderContainer.show()

    this.init = ()->
      this.obj.after(this.previewContainer).after(this.uploaderContainer)

      this.uploader.change(((ev)->
        file = ev.currentTarget.files[0]

        urlAPI = if (typeof URL != "undefined") then URL else (if (typeof webkitURL != "undefined") then webkitURL else null)

        # Handle one upload at a time
        if /image/.test(file.type)
          this.setValue(urlAPI.createObjectURL(file));

          this.doUpload(this, file, ((data)->
            this.setValue(data.file.url)
          ).bind(this))

      ).bind(this))

      this.setValue(this.obj.val())

      this.removeButton.click(((ev)->
        this.clearValue()
        ev.preventDefault()
        false
      ).bind(this))

    this.init()

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


  new Uploader('.swatch-field--text_field')
  new TabGroupOption('.tab-group--option')
)
