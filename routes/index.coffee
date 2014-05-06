express = require("express")
router = express.Router()
applescript = require("applescript")

# GET home page.
router.get "/", (req, res) ->
  res.render "index",
    title: "PowerPoint Server"

  return

# GET next slide.
router.get "/next", (req, res) ->
  script = "tell application \"Microsoft PowerPoint\" to go to next slide (slide show view of slide show window 1)"
  applescript.execString script, (err, rtn) ->

    # Something went wrong!
    console.log err  if err
    return

  res.render "index",
    title: "PowerPoint Server NEXT SLIDE"

  return

module.exports = router
