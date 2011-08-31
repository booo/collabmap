pg = require "pg"
express = require "express"
io = require "socket.io"
rbytes = require "rbytes"

app = express.createServer()

app.set "view engine", "jade"

app.use express.static __dirname + "/static"

app.use app.router

conStr = "pg://postgres:testing@localhost/collabmap"

app.get "/", (req, res, next) ->
  id = (rbytes.randomBytes 16).toHex()
  pg.connect conStr, (error, client) ->
    if error then next error
    else
      client.query "INSERT INTO maps(id) VALUES($1);", [id], (error, result) ->
        if error then next JSON.stringify error
        else
          console.log result
          res.redirect "/" + id

loadMap = (req, res, next) ->
  console.log req.params.id
  pg.connect conStr, (error, client) ->
    if error then next error
    else
      client.query "SELECT * FROM maps WHERE id = $1;", [req.params.id], (error, result) ->
        if error then next error
        else if result.rows[0]
          req.map = result.rows[0]
          console.log req.map
          next()
        else
          console.log result
          console.log "No map with id found"
          res.writeHead 404
          res.end "No map with id found"

app.get "/:id", loadMap, (req, res) ->
  res.render "index", { layout: false, title: req.map.id }


app.listen 1337

io = io.listen 1338

io.sockets.on "connection", (socket) ->
  socket.on "join", (mapId) ->
    pg.connect conStr, (error, client) ->
      if error then console.log error
      else
        client.query "SELECT ST_X(geom) AS lon, ST_Y(geom) AS lat FROM geoms WHERE map_id = $1;", [mapId], (error, result) ->
          if error then console.log error
          else
            for row in result.rows
              socket.emit "point created for " + mapId, { lon: row.lon, lat: row.lat }

    socket.on "point created for " + mapId, (position) ->
      console.log position
      #save new point in database
      pg.connect conStr, (error, client) ->
        if error then console.log error
        else
          client.query "INSERT INTO geoms(map_id, geom) VALUES($1, $2);", [mapId, "SRID=4326;POINT(#{position.lon} #{position.lat})"], (error, result) ->
            if error then console.log error
            else console.log result
      socket.broadcast.emit "point created for " + mapId, position

