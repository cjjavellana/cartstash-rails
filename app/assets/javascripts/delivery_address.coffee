$(document).on 'ready', ->

  # Manage delivery address specific javascripts
  if $('.add-delivery-address-header').length > 0
    markers = []

    CartStashGmapHelper =
      clearMapMarkers: (markers) ->
        for marker in markers
          marker.setMap(null)

        markers = []

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

          $('#delivery_address_location_coords').val("#{e.latLng.lat()}, #{e.latLng.lng()}")
          return
      )
    )

    $('#same_recipient').on 'click', ->
      console.log "same as logged in user"
