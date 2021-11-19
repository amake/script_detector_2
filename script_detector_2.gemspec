# frozen_string_literal: true

require_relative 'lib/script_detector_2/version'

Gem::Specification.new do |spec|
  spec.name          = 'script_detector_2'
  spec.version       = ScriptDetector2::VERSION
  spec.authors       = ['Aaron Madlon-Kay']
  spec.email         = ['aaron@madlon-kay.com']

  spec.summary       = <<~MSG.chomp
    Improved utility library for determining if string is Traditional Chinese, Simplified Chinese, Japanese or Korean
  MSG
  spec.homepage      = 'https://github.com/amake/script_detector_2'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/amake/script_detector_2.git'
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubyzip'
  spec.add_development_dependency 'solargraph'
end
