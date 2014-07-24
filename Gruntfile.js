module.exports = function(grunt) {
  grunt.loadNpmTasks('grunt-download-atom-shell');
  grunt.loadNpmTasks('grunt-contrib-coffee');
  grunt.loadNpmTasks('grunt-exec');
  grunt.loadNpmTasks('grunt-contrib-copy');
  grunt.loadNpmTasks('grunt-contrib-clean');

  binDir = 'binaries';
  atomDistrRoot = binDir + '/Atom.app';
  appName = 'PebblePointServer.app';
  appRoot = binDir + '/' + appName;
  appContents = appRoot + '/Contents/';
  destRoot = appContents + 'Resources/app/';

  grunt.registerTask('build', ['coffee', 'exec:copy_atom_files', 'copy', 'exec:npm_install_bin']);
  grunt.registerTask('download-atom-and-build', ['download-atom-shell', 'build']);
  grunt.registerTask('default', ['download-atom-and-build']);

  grunt.initConfig({
    'download-atom-shell': {
      version: '0.14.0',
      outputDir: binDir
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
          },
          {
            expand: true,
            cwd: 'osx_contents',
            src: ['Info.plist'],
            dest: appContents
          }
        ]
      }
    },
    exec: {
      copy_atom_files: {
        cmd: 'ditto ' + atomDistrRoot + ' ' + appRoot
      },
      npm_install_bin: {
        cmd: 'cd ' + destRoot +  '&& npm install --production'
      }
    },
    clean: {
      build: {
        force: true,
        src:[appRoot]
      },
      framework:{
        force: true,
        src: [binDir]
      }
    }
  });
};
