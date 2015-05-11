# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready', ->

  if $('.add-delivery-address-header').length > 0
    handler = Gmaps.build('Google')
    handler.buildMap({provider: {zoom: 17}, internal: {id: 'geolocation'}}, ->
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition((position)->
          marker = handler.addMarker({
            lat: position.coords.latitude,
            lng: position.coords.longitude
          });
          handler.map.centerOn(marker);
        );
    )