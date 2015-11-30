# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec feature)

## Uncomment to clear the screen before every task
# clearing :on

## Guard internally checks for changes in the Guardfile and exits.
## If you want Guard to automatically start up again, run guard in a
## shell loop, e.g.:
##
##  $ while bundle exec guard; do echo "Restarting Guard..."; done
##
## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), the you will want to move the Guardfile
## to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

# Note: The cmd option is now required due to the increasing number of ways
#       rspec may be run, below are examples of the most common uses.
#  * bundler: 'bundle exec rspec'
#  * bundler binstubs: 'bin/rspec'
#  * spring: 'bin/rspec' (This will use spring if running and you have
#                          installed the spring binstubs per the docs)
#  * zeus: 'zeus rspec' (requires the server to be started separately)
#  * 'just' rspec: 'rspec'
scope :group => :unit

group :unit do
  guard :rubocop do
    watch(%r{/.+\.rb$/})
    watch(%r{/(?:.+\/)?\.rubocop\.yml$/}) { |m| File.dirname(m[0]) }
  end

  guard :rspec, :cmd => 'chef exec rspec --fail-fast', :all_on_start => false do
    watch(%r{/^libraries\/(.+)\.rb$/})
    watch(%r{/^spec\/(.+)_spec\.rb$/}) { 'spec' }
    watch(%r{/^(attributes)\/(.+)\.rb$/}) { 'spec' }
    watch(%r{/^(recipes)\/(.+)\.rb$/}) { 'spec' }
    watch(%r{/^recipes\/common\.rb$/}) { 'spec' }
    watch('spec/spec_helper.rb') { 'spec' }
    watch(%r{/^(.+)erb$/}) { 'spec' }
  end
end
