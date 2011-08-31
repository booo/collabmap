//do this in coffeescript too!!!
function init() {
    var map = new OpenLayers.Map("map");

    var markers = new OpenLayers.Layer.Markers("Markers");
    map.addLayer(markers);

    var socket = io.connect("http://localhost:1338");
    socket.emit("join", title);

    socket.on("point created for " + title, function(position) {
        var marker = new OpenLayers.Marker(position);
        markers.addMarker(marker);
    });
    map.events.register("click", map, function(event){
        var position = map.getLonLatFromViewPortPx(event.xy);
        console.log(position);
        var marker = new OpenLayers.Marker(position);
        markers.addMarker(marker);
        socket.emit("point created for " + title, position);
    });


    var mapnik = new OpenLayers.Layer.OSM();

    map.addLayer(mapnik);
    map.zoomToMaxExtent();

}

