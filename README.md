pebblepoint server
==================

Node.js server for Mac OS X that allows Pebble to control PowerPoint, via AppleScript.

Requirements
------------
- Mac OS X, for AppleScript
- Microsoft PowerPoint
- [Node.js](http://nodejs.org)
- A Pebble watch, with PebblePoint installed

Installation
------------
Open a terminal and run:

`npm install -g pebblepoint-server`

After install, you may need to rehash your path or open a new terminal to get the executable in your PATH.

Running the Server
------------------
Open a terminal and run:

`pebblepoint-server`

The server will run and open a browser window with the IP and PORT info for configuring your watch.

By default, the server runs on port 7325 (which is PEBL on a phone keypad). Port can be overridden at server start if you have a conflict on the default one:

`PORT=60654 pebblepoint-server`

Configuring your Pebble
-----------------------
When the server runs, an instruction page is launched in your default browser to show what IP and PORT you need to use. This also acts a simple smoketest to let you know you're ready to go.
