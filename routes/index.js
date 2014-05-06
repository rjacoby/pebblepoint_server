var express = require('express');
var router = express.Router();
var applescript = require("applescript");

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'PowerPoint Server' });
});

/* GET next slide. */
router.get('/next', function(req, res) {
  var script = "tell application \"Microsoft PowerPoint\" to go to next slide (slide show view of slide show window 1)";

  applescript.execString(script, function(err, rtn) {
    if (err) {
      // Something went wrong!
      console.log(err);
    }
  });
  res.render('index', { title: 'PowerPoint Server NEXT SLIDE' });
});

module.exports = router;
