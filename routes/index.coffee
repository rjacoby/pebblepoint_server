express = require("express")
router = express.Router()
applescript = require("applescript")

# This AppleScript is really the core of the whole shebang.
command_script = (command) -> """
  tell application "Microsoft PowerPoint"
  	set slideWindow to slide show window 1 of active presentation
  	tell active presentation
  		set theSlideCount to count slides
    end tell
    set currentSlideNumber to slide index of slide of (slide show view of slideWindow)
    if (("#{command}" = "next") and (currentSlideNumber < theSlideCount)) or (("#{command}" = "previous") and currentSlideNumber > 1) or ("#{command}" = "first") or ("#{command}" = "last")then
      go to #{command} slide (slide show view of slide show window 1)
      set currentSlideNumber to slide index of slide of (slide show view of slideWindow)
    end if
  	{currentSlideNumber, theSlideCount}
  end tell
"""

ppt_status_script = -> """
  tell application "Microsoft PowerPoint"
    if it is running then
      return true
    else
      return false
    end if
  end tell
"""

# GET home page.
router.get "/", (req, res) ->
  ips = global.app.get("ipFunc")()
  preferredIP = ips.splice(0,1)[0][1]
  port = global.app.get("port")
  applescript.execString ppt_status_script(), (err, rtn) ->
    console.log rtn
    res.render "index",
      preferredIP: preferredIP,
      port: port,
      otherIPs: ips,
      powerPointStatus: rtn
  return

# POST to go to a slide
router.post "/go/:command", (req, res) ->
  command = req.params.command
  if command in ['next', 'previous', 'first', 'last']
    pptResult = {success: false}
    applescript.execString command_script(command), (err, rtn) ->
      if err
        console.log "Could not control PowerPoint with AppleScript:", err.message
        if err.message.match(/1728/)
          pptResult["errorMessage"] = "Check that presentation is playing"
        else
          pptResult["errorMessage"] = err.message
      else
        pptResult["success"] = true
        if (Array.isArray(rtn))
          pptResult["slideIndex"] = rtn[0]
          pptResult["slideTotal"] = rtn[1]
      # Had to put the JSON building inside the AppleScript call b/c the
      # library we're using uses a 'spawn' call and so we end up async
      # and without shared scope
      res.json(pptResult)
  else
    console.error("Invalid parameter: #{command}")
    res.send(400, 'Invalid parameters')

module.exports = router
