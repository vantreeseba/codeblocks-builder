require 'Nokogiri'
require './codeblocks.rb'


desc "Build workspace"
task :default => [:clean,:build,:link]

task :build do
	CodeBlocks.buildWorkspace "test.workspace"
end

desc "Link workspace"
task :link do
	CodeBlocks.linkWorkspace "test.workspace"
end

task :clean do
	rm_rf "obj", :verbose => false
	rm_rf "bin", :verbose => false
	
	mkdir "obj", :verbose => false
	mkdir "bin", :verbose => false
end
