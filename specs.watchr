#-*- ruby -*-

# Run me with:
#   $ watchr specs.watchr

# --------------------------------------------------
# Rules
# --------------------------------------------------
watch('^spec/.*_spec\.rb')          { |m| ruby  m[0] }
watch('^lib/(.*)\.rb')              { |m| ruby "spec/#{m[1]}_spec.rb" }
watch('^spec/spec_helper\.rb')      { ruby tests }

# --------------------------------------------------
# Signal Handling
# --------------------------------------------------
Signal.trap('QUIT') { ruby tests  } # Ctrl-\
Signal.trap('INT' ) { abort("\n") } # Ctrl-C

# --------------------------------------------------
# Helpers
# --------------------------------------------------
def ruby(*paths)
  run "rspec #{gem_opt} -I.:lib:.:tests/spec -e'%w( #{paths.flatten.join(' ')} ).each {|p| require p }'"
end

def tests
  Dir['spec/**/*_spec.rb'] - ['spec/spec_helper.rb']
end

def run( cmd )
  puts   cmd
  system cmd
end

def gem_opt
  defined?(Gem) ? "-rubygems" : ""
end
