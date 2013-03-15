#require File.expand_path("../lib/newgem/version", __FILE__)

Gem::Specification.new do |s|
  s.name        	= 'codeblocks-builder'
  s.version     	= '0.0.1'
  s.date        	= '2013-03-11'
  s.summary     	= "Code::Blocks Build System"
  s.description 	= "A reimplementation of the code blocks build system in ruby, so that CI servers can build from .cbp and .workspace files on the console through rake."
  s.authors     	= ["Ben Van Treese"]
  s.email       	= 'vantreeseba@gmail.com'
  s.files       	= Dir["lib/**/*.rb", "LICENSE", "*.md"]
  s.homepage      = 'http://codeblocks-builder.dropecho.com'
  
  #Depends
  s.add_runtime_dependency "nokogiri",["= 1.5.0"]
end