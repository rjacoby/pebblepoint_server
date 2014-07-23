module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-download-atom-shell');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-commands');
  grunt.loadNpmTasks('grunt-contrib-copy');

  atomDownloadRoot = 'binaries/Atom.app';
  atomRenamedRoot = 'binaries/PebblePointServer.app';
  destRoot = atomRenamedRoot + '/Contents/Resources/app/';

  grunt.registerTask('build', ['coffee', 'command', 'copy']);
  grunt.registerTask('download-atom-and-build', ['download-atom-shell', 'build']);
  grunt.registerTask('default', ['download-atom-and-build']);

  grunt.initConfig({
    'download-atom-shell': {
      version: '0.14.0',
      outputDir: 'binaries'
    },

    coffee: {
      compile: {
        files: {
          'app.js': 'app.coffee',
          'routes/index.js': 'routes/index.coffee'
        }
      }
    },

    copy: {
      buildfiles: {
        files: [
          {
            expand: true,
            cwd: '.',
            src: [
              'app.js',
              'LICENSE-MIT',
              'main.js',
              'package.json',
              'views/*.ejs',
              'routes/index.js'
            ],
            dest: destRoot
          }
        ]
      }
    },
    command : {
      run_cmd: {
        cmd  : 'cp -r ' + atomDownloadRoot + '/* ' + atomRenamedRoot
      }
    }
  });
};
