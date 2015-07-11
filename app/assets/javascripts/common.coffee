$(document).on "page:change", ->
  $('[data-toggle="tooltip"]').tooltip()

  $(document).on "click", "a[datapopup]", (e) ->
    window.open($(this).attr('href'), "Popup", "width=512px,height=800px" )
    e.preventDefault()


this.isNumber = isNumber = (value) ->
  numberPattern = /^\d{1,3}(\.\d{1,2})?$/
  numberPattern.test(value)


this.delay = delay = do ->
  timer = 0
  (callback, ms) ->
    clearTimeout(timer)
    timer = setTimeout(callback, ms)
    return

