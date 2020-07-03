# -*- encoding: utf-8 -*-
# stub: babosa 1.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "babosa".freeze
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Norman Clarke".freeze]
  s.date = "2019-09-23"
  s.description = "    A library for creating slugs. Babosa an extraction and improvement of the\n    string code from FriendlyId, intended to help developers create similar\n    libraries or plugins.\n".freeze
  s.email = "norman@njclarke.com".freeze
  s.homepage = "http://github.com/norman/babosa".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0".freeze)
  s.rubygems_version = "2.5.2".freeze
  s.summary = "A library for creating slugs.".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<activesupport>.freeze, [">= 3.2.0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 3.7.0"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<unicode>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activesupport>.freeze, [">= 3.2.0"])
      s.add_dependency(%q<rspec>.freeze, [">= 3.7.0"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<unicode>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 3.2.0"])
    s.add_dependency(%q<rspec>.freeze, [">= 3.7.0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<unicode>.freeze, [">= 0"])
  end
end
