module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-download-atom-shell');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-contrib-copy');

  destRoot = 'binaries/Atom.app/Contents/Resources/app/';

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
    }
  });
};
