$ ->
  $('.add2cart').on 'ajax:success', (e, data, status, xhr) ->
    $('#' + data.sku).html(data.qty)
    $('.amount-summary').html(data.total)
    return
  return
return
