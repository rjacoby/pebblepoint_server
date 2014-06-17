express = require("express")
router = express.Router()
applescript = require("applescript")

# Navigation functions
goToSlide = (direction) ->
  script = """
    tell application "Microsoft PowerPoint"
    	set slideWindow to slide show window 1 of active presentation
    	tell active presentation
    		set theSlideCount to count slides
    	end tell
      set currentSlideNumber to slide index of slide of (slide show view of slideWindow)
    	go to #{direction} slide (slide show view of slide show window 1)
    	{currentSlideNumber, theSlideCount}
    end tell
  """
  applescript.execString script, (err, rtn) ->
    retHash = {success: false}
    if err
      console.log err
    else
      retHash["success"] = true
      if (Array.isArray(rtn))
        retHash["slideIndex"] = rtn[0]
        retHash["slideTotal"] = rtn[1]
    return retHash



# GET home page.
router.get "/", (req, res) ->
  ips = global.app.get("ipFunc")()
  preferredIP = ips.splice(0,1)[0][1]
  port = global.app.get("port")
  res.render "index",
    preferredIP: preferredIP,
    port: port,
    otherIPs: ips
  return

# GET to a slide direction
router.post "/go/:direction", (req, res) ->
  direction = req.params.direction
  if direction in ['next', 'previous', 'first', 'last']
    pptResult = goToSlide(direction)
    res.json(pptResult)
    return
  else
    console.error("Invalid parameter: #{direction}")
    res.send(400, 'Invalid parameters')

module.exports = router
