# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{sequel_revisioned}
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jacob Dunphy"]
  s.date = %q{2009-01-19}
  s.description = %q{Sequel plugin designed to maintain a revision history of an object.  Sequel_revisioned will create a revision table and model specific to the class that calls `is :revisioned`.  It's set up this way to allow multiple tables to maintain revisions without interfering with each other.}
  s.email = ["jacob.dunphy@gmail.com"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "lib/sequel_revisioned.rb", "lib/sequel_revisioned/sequel_revisioned.rb"]
  s.has_rdoc = true
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{sequel_revisioned}
  s.rubygems_version = %q{1.3.0}
  s.summary = %q{Sequel plugin designed to maintain a revision history of an object}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sequel>, [">= 2.9.0"])
      s.add_development_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_development_dependency(%q<hoe>, [">= 1.8.0"])
    else
      s.add_dependency(%q<sequel>, [">= 2.9.0"])
      s.add_dependency(%q<newgem>, [">= 1.2.3"])
      s.add_dependency(%q<hoe>, [">= 1.8.0"])
    end
  else
    s.add_dependency(%q<sequel>, [">= 2.9.0"])
    s.add_dependency(%q<newgem>, [">= 1.2.3"])
    s.add_dependency(%q<hoe>, [">= 1.8.0"])
  end
end
