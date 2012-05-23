# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "live_ensure/version"

Gem::Specification.new do |s|
  s.name        = "live_ensure"
  s.version     = LiveEnsure::VERSION
  s.authors     = ["Steve Thompson"]
  s.email       = ["me@stevedev.com"]
  s.homepage    = "http://www.inspirestudios.ca"
  s.summary     = %q{Live Ensure API for Ruby}
  s.description = %q{Library for interfacing with Live Ensure's Two Factor Auth}

  s.rubyforge_project = "live_ensure"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rake", "~> 0.9.2.2"
  s.add_development_dependency "rspec", "~> 2.10"
  s.add_runtime_dependency "patron", "~> 0.4"
  s.add_runtime_dependency "activesupport", "~> 3.2.3"
end
