console.log('PebblePoint running');

simply.fullscreen(true);

// simply.settingsUrl = "http://dl.dropboxusercontent.com/u/115264/pebble/ppt/config.html";

var sendPptCmd = function(cmd) {
  ajax({ method: 'post', url: 'http://ppt-server.dev.calm.ly/go/' + cmd,
         type: 'json'}, function(data){
      console.log(data);
      console.log(data.success);
      if (data.success){
        console.log('succeeded');
        simply.body('Went to: ' + data.pageNumber);
      } else {
        simply.body('FAILED to navigate!');
      }
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
