# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready', ->
  markers = []

  CartStashGmapHelper =
    clearMapMarkers: (markers) ->
      for marker in markers
        marker.setMap(null)

      markers = []

  if $('.add-delivery-address-header').length > 0
    handler = Gmaps.build('Google')
    handler.buildMap({provider: {zoom: 17}, internal: {id: 'geolocation'}}, ->
      if navigator.geolocation
        navigator.geolocation.getCurrentPosition((position)->
          handler.map.centerOn({lat: position.coords.latitude, lng: position.coords.longitude});
        );

      # event handlers
      google.maps.event.addListener(handler.getMap(), 'click',(e) ->
          CartStashGmapHelper.clearMapMarkers(markers)

          marker = new google.maps.Marker({
            position: e.latLng,
            map: handler.getMap()
          })

          markers.push(marker)

          return
      )
    )

