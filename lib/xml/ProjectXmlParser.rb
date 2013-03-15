require 'xml/xml.rb'

def CodeBlocks::mapFlags(optionNode)
	return optionNode.attr("option") unless optionNode.attr("option") == nil
	return "-I#{optionNode.attr("directory")}" unless optionNode.attr("directory") == nil		
end

class CodeBlocks::TargetXmlParser
	def initialize(project_xml,target)
		@xml = project_xml.css("Target[title=#{target}]")
	end

	def objectOutput
		@xml.css("Option[object_output]").map{ |option| option.attr("object_output") }.first
	end

	def compilerFlags
		@xml.css("Compiler>Add").map{ |option| CodeBlocks::mapFlags option }
	end

	def linkerFlags
		@xml.css("Linker>Add").map{ |option| CodeBlocks::mapFlags option }
	end	
end

class CodeBlocks::ProjectXmlParser
	def initialize(name,target)
		@xml = CodeBlocks::XmlParser.getXML name
		@path = (name.split("\/")[0..-2].join("\/") + "\/")
		if (@path[0] == '/') 
			@path[0] = '' 
		end
		@target_xml = CodeBlocks::TargetXmlParser.new @xml,target
	end
	
	def unitNames				
		@xml.css("Unit").map { |unit| @path + unit.attr("filename") }.select { |unit| unit.include? ".cpp" }	
	end

	def headerNames		
		@xml.css("Unit").map { |unit| @path + unit.attr("filename") }.select { |unit| unit.include? ".hpp" }		
	end	

	def objectOutput
		@target_xml.objectOutput
	end

	def compilerFlags
		flags = @xml.css("Project>Compiler>Add").map { |option| CodeBlocks::mapFlags option  }		
		flags += @target_xml.compilerFlags

		flags
	end
	
	def linkerFlags
		@target_xml.linkerFlags
	end	
end