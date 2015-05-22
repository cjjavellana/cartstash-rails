# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->

  $('.change-password-link').on 'click', ->
    $('.change-password-dialog #error_explanation').remove()
    $('.change-password-dialog').modal('toggle')
    
  if $('#birthdate').length > 0
    $('#birthdate').datepicker()
