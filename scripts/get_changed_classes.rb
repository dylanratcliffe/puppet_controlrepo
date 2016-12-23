#! env ruby

files = `git --no-pager diff --name-only HEAD HEAD~1`.split("\n")
classes = []

files.each do |file|
  # if the changed file is a manifest
  if file =~ /\.pp$/
    segments = file.split('/')
    # Get the name of the module
    mod = segments[segments.index('manifests') - 1]
    # Delete everything up to & including manifests
    segments = segments - segments[0..segments.index('manifests')]
    # Get the final section
    final = segments.last.chomp('.pp')
    # Delete it
    segments.delete(segments.last)
    # Get anything taht is left
    intermediary = segments
    classes << [mod,intermediary,final].flatten.join('::')
  end
end

puts classes
