Gem::Specification.new do |spec|
  spec.name        = "scripts2pkg"
  spec.version     = "0.1.0"
  spec.authors     = ["funterminal"]
  spec.email       = ["calestialashley@gmail.com]

  spec.summary     = "A tool to convert Python/Ruby scripts into Debian packages for Termux and Debian systems"
  spec.description = "This gem allows you to package Python or Ruby scripts as Debian packages for Termux or Debian."
  spec.homepage    = "https://github.com/funterminal/scripts2pkg.git"
  spec.license     = "MIT"

  spec.files       = Dir["lib/**/*", "bin/**/*", "README.md"]
  spec.bindir      = "bin"
  spec.executables = ["scripts2pkg"]

  spec.add_dependency "thor"
end
