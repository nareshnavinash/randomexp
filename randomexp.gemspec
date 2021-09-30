# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "randomexp/version"

Gem::Specification.new do |s|
  s.name        = "randomexp"
  s.version     = Randomexp::VERSION
  s.authors     = ["Naresh Sekar"]
  s.email       = ["nareshnavinash@gmail.com"]
  s.homepage    = "http://github.com/nareshnavinash/randomexp"
  s.summary     = %q{Library for generating random strings.}
  s.description = %q{Library for generating random strings from regular expressions.}

  s.rubyforge_project = "randomexp"

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.require_paths    = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
