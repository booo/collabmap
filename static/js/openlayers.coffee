@init = ->
  map = new OpenLayers.Map "map"
  markers = new OpenLayers.Layer.Markers "Markers"
  map.addLayer markers

  socket = io.connect "http://localhost:1338"
  socket.emit "join", title

  socket.on "point created for " + title, (position) ->
    marker = new OpenLayers.Marker position
    markers.addMarker marker

  map.events.register "click", map, (event) ->
    position = map.getLonLatFromViewPortPx event.xy
    console.log position
    marker = new OpenLayers.Marker position
    markers.addMarker marker
    socket.emit "point created for " + title, position

  mapnik = new OpenLayers.Layer.OSM()

  map.addLayer mapnik

  map.zoomToMaxExtent()
