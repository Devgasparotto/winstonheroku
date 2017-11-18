# -*- encoding: utf-8 -*-
# stub: pdf-forms 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "pdf-forms"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Kr\u{e4}mer"]
  s.date = "2016-08-30"
  s.description = "A Ruby frontend to the pdftk binary, including FDF and XFDF creation. Just pass your template and a hash of data to fill in."
  s.email = ["jk@jkraemer.net"]
  s.homepage = "http://github.com/jkraemer/pdf-forms"
  s.licenses = ["MIT"]
  s.rubyforge_project = "pdf-forms"
  s.rubygems_version = "2.5.1"
  s.summary = "Fill out PDF forms with pdftk (http://www.accesspdf.com/pdftk/)."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cliver>, ["~> 0.3.2"])
      s.add_runtime_dependency(%q<safe_shell>, ["< 2.0", ">= 1.0.3"])
      s.add_development_dependency(%q<bundler>, ["~> 1.7"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
    else
      s.add_dependency(%q<cliver>, ["~> 0.3.2"])
      s.add_dependency(%q<safe_shell>, ["< 2.0", ">= 1.0.3"])
      s.add_dependency(%q<bundler>, ["~> 1.7"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<cliver>, ["~> 0.3.2"])
    s.add_dependency(%q<safe_shell>, ["< 2.0", ">= 1.0.3"])
    s.add_dependency(%q<bundler>, ["~> 1.7"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
  end
end
