debug = require("debug")("ppt-server")
express = require("express")
path = require("path")
logger = require("morgan")
cookieParser = require("cookie-parser")
bodyParser = require("body-parser")
routes = require("./routes/index")
os = require("os")
app = express()

# For launching the view
sys = require('sys')
exec = require('child_process').exec

global.app = app

app.set "port", process.env.PORT or 7325

publicIPList = () ->
  ips = []
  for interfaceName, inetList of os.networkInterfaces()
    for inet in inetList
      # Not using a hash b/c we care about order as our priority.
      if !inet["internal"] && inet["family"].match(/IPv4/i) && !interfaceName.match(/bridge/i)
        ips.push [interfaceName, inet["address"]]
  return ips

app.set "ipFunc", publicIPList

# view engine setup
app.set "views", path.join(__dirname, "views")
app.set "view engine", "ejs"
app.use logger("dev")
app.use bodyParser.json()
app.use bodyParser.urlencoded()
app.use cookieParser()
app.use express.static(path.join(__dirname, "public"))
app.use "/", routes

#/ catch 404 and forwarding to error handler
app.use (req, res, next) ->
  err = new Error("Not Found")
  err.status = 404
  next err
  return


#/ error handlers

# development error handler
# will print stacktrace
if app.get("env") is "development"
  app.use (err, req, res, next) ->
    res.status err.status or 500
    res.render "error",
      message: err.message
      error: err

    return


# production error handler
# no stacktraces leaked to users
app.use (err, req, res, next) ->
  res.status err.status or 500
  res.render "error",
    message: err.message
    error: {}

  return

server = app.listen(app.get("port"), ->
  preferredIP = publicIPList().splice(0,1)[0][1]
  serverUrl = "http://" + preferredIP + ":" + server.address().port
  console.log "PebblePoint server listening on " + serverUrl
  exec "open #{serverUrl}"

  return
)
