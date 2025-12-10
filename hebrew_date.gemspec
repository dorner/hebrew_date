Gem::Specification.new do |s|
  s.name         = 'hebrew_date'
  s.require_paths = %w(. lib)
  s.version      = '1.1.0'
  s.date         = '2025-12-10'
  s.summary      = 'Hebrew/Jewish dates, times, and holidays.'
  s.description  = <<-EOF
   hebrew_date is a library designed to provide information about the Jewish
   calendar. This includes dates, holidays, and parsha of the week.

EOF
  s.authors      = ['Daniel Orner']
  s.email        = 'dmorner@gmail.com'
  s.files        = `git ls-files`.split($/)
  s.homepage     = 'https://github.com/dorner/hebrew_date'
  s.license       = 'MIT'
  s.required_ruby_version = '>= 2.7.0'

  s.add_development_dependency 'yard', '~> 0.9.37'
  s.add_development_dependency 'rspec', '~> 3.13'

end
