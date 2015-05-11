# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'page:change', ->
  handler = Gmaps.build('Google')
  handler.buildMap({ internal: { id: 'geolocation' } }, ->
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(displayOnMap) 
  )

  displayOnMap = (position) ->
    console.log(position.coords.latitude + ',' + position.coords.longitude)
    
    marker = handler.addMarker({
      lat: position.coords.latitude,
      long: position.coords.longitude,
    })

    handler.map.centerOn(marker)

return