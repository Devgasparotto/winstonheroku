# -*- encoding: utf-8 -*-
# stub: safe_shell 1.1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "safe_shell"
  s.version = "1.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Envato", "Ian Leitch", "Pete Yandell"]
  s.date = "2017-06-26"
  s.description = "Execute shell commands and get the resulting output, but without the security problems of Ruby\u{2019}s backtick operator."
  s.email = ["pete@notahat.com"]
  s.extra_rdoc_files = ["LICENSE", "README.md"]
  s.files = ["LICENSE", "README.md"]
  s.homepage = "http://github.com/envato/safe_shell"
  s.licenses = ["MIT"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.5.1"
  s.summary = "Safely execute shell commands and get their output."

  s.installed_by_version = "2.5.1" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
