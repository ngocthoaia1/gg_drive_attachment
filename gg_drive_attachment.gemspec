$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "gg_drive_attachment/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "gg_drive_attachment"
  spec.version     = GgDriveAttachment::VERSION
  spec.authors     = ["Ngoc Thoai Nguyen"]
  spec.email       = ["ngocthoaia1@gmail.com"]
  spec.homepage    = "https://github.com/ngocthoaia1"
  spec.summary     = "Summary of GgDriveAttachment."
  spec.description = "Description of GgDriveAttachment."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.4", ">= 5.2.4.2"
  spec.add_dependency "google_drive"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-rails"
end
