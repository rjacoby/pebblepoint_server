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

# GET next slide.
router.get "/next", (req, res) ->
  goToSlide('next')
    
  res.render "index",
    title: "PowerPoint Server NEXT SLIDE"

  return

module.exports = router
