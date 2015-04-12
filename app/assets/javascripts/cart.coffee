# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on "change", ".item-qty", ->
  $.ajax
    url: '/shop/add2cart'
    type: 'POST'
    data:
      sku: $(this).attr('sku')
      qty: $(this).val()
    success: (data, status, response) ->
      # data is the object that contains all info returned
    error: ->
      # Hard error