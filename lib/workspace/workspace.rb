require 'xml/xml.rb'
require 'project/project.rb'

class CodeBlocks::Workspace
	attr_accessor :path
	attr_accessor :name
	attr_accessor :xml

	def initialize(name)		
		@name = name
		
		@xml = CodeBlocks::XmlParser.getXML @name		
	end

	def build()						
		projects.each { |project| project.build }			
	end
	
	def link()					
		projects.each { |project| project.link }		
	end
	
	def projectNames
		@xml.css("Project").map { |proj| @path + proj.attr("filename")}
	end

	def projects
		projectNames.map { |name| CodeBlocks::Project.new name }
	end
end