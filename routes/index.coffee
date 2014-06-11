express = require("express")
router = express.Router()
applescript = require("applescript")
os = require("os")
networkInterfaces = os.networkInterfaces()

# Navigation functions
goToSlide = (direction) ->
  script = """
    tell application "Microsoft PowerPoint"
      go to #{direction} slide (slide show view of slide show window 1)
    end tell
  """
  applescript.execString script, (err, rtn) ->
    # Something went wrong!
    console.log err  if err
    return

publicIP = () ->
  ips = []
  for interfaceName, inetList of networkInterfaces
    for inet in inetList
      # Not using a hash b/c we care about order as our priority.
      if !inet["internal"] && inet["family"].match(/IPv4/i)
        ips.push [interfaceName, inet["address"]]

  return ips

# GET home page.
router.get "/", (req, res) ->
  preferredIP = publicIP()[0][1]
  port = global.app.get("port")
  res.render "index",
    preferredIP: "#{preferredIP}:#{port}"
  # res.json({
  #   success: true,
  #   text: "Enter #{req.protocol}://#{preferredIP}/} into your prefs",
  #   ifconfig: publicIP()
  # })
  return

# GET to a slide direction
router.post "/go/:direction", (req, res) ->
  direction = req.params.direction
  if direction in ['next', 'previous', 'first', 'last']
    goToSlide(direction)
    res.json({success: true, pageNumber: direction})
    return
  else
    console.error("Invalid parameter: #{direction}")
    res.send(400, 'Invalid parameters')

module.exports = router
