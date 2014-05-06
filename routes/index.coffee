express = require("express")
router = express.Router()
applescript = require("applescript")

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

# GET home page.
router.get "/", (req, res) ->
  res.render "index",
    title: "PowerPoint Server"

  return

# GET to a slide direction
router.get "/go/:direction", (req, res) ->
  direction = req.params.direction
  if direction in ['next', 'previous', 'first', 'last']
    goToSlide(direction)
    res.render "index",
      title: "PowerPoint Server #{direction} SLIDE"
    return
  else
    console.error("Invalid parameter: #{direction}")
    res.send(400, 'Invalid parameters');

module.exports = router
