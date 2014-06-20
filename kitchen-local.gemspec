# encoding: utf-8

$:.unshift File.expand_path('../lib', __FILE__)
require 'kitchen/local/version'

Gem::Specification.new do |s|
  s.name          = "kitchen-local"
  s.version       = Kitchen::Local::VERSION
  s.authors       = ["Ian Schenck"]
  s.email         = ["ian.schenck@gmail.com"]
  s.homepage      = "https://github.com/ianschenck/kitchen-local"
  s.summary       = "driver for test-kitchen for running on the local machine"
  candidates = Dir.glob("{lib}/**/*") +  ['README.md', 'LICENSE.txt', 'kitchen-local.gemspec']
  s.files = candidates.sort
  s.platform      = Gem::Platform::RUBY
  s.require_paths = ['lib']
  s.rubyforge_project = '[none]'
  s.description = <<-EOF
== DESCRIPTION:

local driver for test-kitchen for running directly against the current, local machine

== FEATURES:

ssh driver for test-kitchen for any running server with an ip address

EOF

end
