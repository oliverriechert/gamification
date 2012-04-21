# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gamification/version"

Gem::Specification.new do |s|
  s.name        = "gamification"
  s.version     = Gamification::VERSION
  s.authors     = ["Pierre-Louis Gottfrois"]
  s.email       = ["pierrelouis.gottfrois@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Provide a simple gamification process for you application.}
  s.description = %q{Reward with points and badges your users. Unlock and add custom achievements easily.}

  s.rubyforge_project = "gamification"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
