Gem::Specification.new do |s|
  s.name         = 'hebrew_date'
  s.require_paths = %w(. lib)
  s.version      = '1.0.1'
  s.date         = '2014-01-09'
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

#  s.add_dependency 'ruby-sun-times'
  s.add_development_dependency 'yard'
  s.add_development_dependency 'rspec'

end