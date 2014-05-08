console.log('PebblePoint running');

simply.fullscreen(true);

// simply.settingsUrl = "http://dl.dropboxusercontent.com/u/115264/pebble/ppt/config.html";

var sendPptCmd = function(cmd) {
  ajax({ url: 'http://ppt-server.dev.calm.ly/go/' + cmd }, function(data){
    simply.body('Went to: ' + cmd);
  });
};

simply.on('singleClick', function(e) {
  console.log(util2.format('single clicked $button!', e));
  switch (e.button)
  {
    case 'down':
      sendPptCmd('next');
      simply.vibe('short');
      break;
    case 'up':
      sendPptCmd('previous');
      simply.vibe('short');
      break;
    default:
      simply.body('nada!');
  }
});

simply.on('longClick', function(e) {
  console.log(util2.format('long clicked $button!', e));
  switch (e.button)
  {
    case 'down':
      sendPptCmd('last');
      simply.vibe('double');
      break;
    case 'up':
      sendPptCmd('first');
      simply.vibe('double');
      break;
    default:
      simply.body('nada!');
  }

});

simply.setText({
  title: 'PebblePoint',
  body: 'Press down and up to move thru your slides',
}, true);
