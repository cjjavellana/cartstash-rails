$(document).on 'page:change', ->
  $('.add2cart').on 'ajax:success', (e, data, status, xhr) ->
    $('#' + data.sku).html(data.qty)
    $('.amount-summary').html(data.total)
    return

  $('.order-summary button').popover({
    trigger: 'manual',
    title: 'Order Summary',
    placement: 'bottom'
  })

  $('.order-summary').on 'click', ->
    $('.order-summary').popover('toggle')

  $(document).on 'mouseup', (e) ->
    container = $('.popover')
    if !container.is(e.target) and container.has(e.target).length == 0
      container.hide()

  updatePurchaseOrderCallbacks.add (data)->
    $('div#' + data.sku).html(data.qty);

  return
return
