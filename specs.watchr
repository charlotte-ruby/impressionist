#-*- ruby -*-

# Run me with:
#   $ watchr specs.watchr

# --------------------------------------------------
# Rules
# --------------------------------------------------
watch('^tests/spec/.*_spec\.rb')          { |m| ruby  m[0] }
watch('^lib/(.*)\.rb')                    { |m| ruby "tests/spec/#{m[1]}_spec.rb" }
watch('^tests/spec/minitest_helper\.rb')  { ruby tests }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
Signal.trap('QUIT') { ruby tests  } # Ctrl-\
Signal.trap('INT' ) { abort("\n") } # Ctrl-C

# --------------------------------------------------
# Helpers
# --------------------------------------------------
def ruby(*paths)
  run "ruby #{gem_opt} -I.:lib:.:tests/spec -e'%w( #{paths.flatten.join(' ')} ).each {|p| require p }'"
end

def tests
  Dir['tests/spec/**/*_spec.rb'] - ['tests/spec/minitest_helper.rb']
end

def run( cmd )
  puts   cmd
  system cmd
end

def gem_opt
  defined?(Gem) ? "-rubygems" : ""
end
