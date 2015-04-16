# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "keyup", ".item-qty", ->
  text_box = $(this)
  sku = $(this).attr('sku')
  qty = $(this).val()

  delay(->
    if isNumber(qty)
      $.ajax
        url: '/shop/updatecart'
        type: 'POST'
        data:
          sku: sku
          qty: qty
        success: (data, status, response) ->
          # data is the object that contains all info returned
        error: ->
          # an error has occurred
      return
    else
      # highlight the box
      text_box.css
        'border': '1px solid #ff0000'
      return

  , 300)
  return