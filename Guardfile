# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exist?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

guard(:minitest,
      all_on_start: false, # run all tests in group on startup, default: true
      all_after_pass: true, # run all tests in group after changed specs pass, default: false
      # cli: '--test --verbose', # pass arbitrary Minitest CLI arguments, default: ''
      test_folders: ['tests'], # specify an array of paths that contain test files, default: %w[test spec]
      include: [], # specify an array of include paths to the command that runs the tests
      test_file_patterns: %w[*_test.rb], # specify an array of patterns that test files must match in order to be run, default: %w[*_test.rb test_*.rb *_spec.rb]
      spring: "bundle exec rails test", # enable spring support, default: false
      zeus: false, # enable zeus support; default: false
      drb: false, # enable DRb support, default: false
      env: {}, # specify some environment variables to be set when the test command is invoked, default: {}
      all_env: {}, # specify additional environment variables to be set when all tests are being run, default: false
      autorun: true # require 'minitest/autorun' automatically, default: true
) do

  # with Minitest::Unit
  watch(%r{^test/(.*)\/?(.*)_test\.rb$})
  watch(%r{^app/(.+)\.rb$}) { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/application_controller\.rb$}) { 'test/controllers' }
  watch(%r{^app/(controllers|models)/.+\.rb$}) { 'test/integration' }
  watch(%r{^test/test_helper\.rb$}) { 'test' }
end
