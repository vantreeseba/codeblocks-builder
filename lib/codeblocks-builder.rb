require 'rake'
include Rake::DSL

OPTION_OUTPUT_TYPE_GUI = 0
OPTION_OUTPUT_TYPE_CONSOLE = 1
OPTION_OUTPUT_TYPE_STATIC_LIB = 2 
OPTION_OUTPUT_TYPE_DYNAMIC_LIB = 3
OPTION_OUTPUT_TYPE_COMMANDS_ONLY = 4
OPTION_OUTPUT_TYPE_NATIVE = 5

class CodeBlocksImpl	
	attr_accessor :build_os
	attr_accessor :target
	
	
	def initialize()
		@build_os = ENV['os']
		@target = getBuildTarget()		
	end
	
	def getBuildTarget()
		case @build_os
		when "Windows_NT"
			return "Win32"
		end
	end

	#####################################
	## Compiler Options Functions
	#####################################

	def buildTargetCompilerOptions(project_file_name)
		project_xml = getXML(project_file_name)
		
		actual_target = project_xml.css("VirtualTargets>Add[alias=#{@target}]").attr("targets").to_str[0..-2]
		
		puts "Building: #{@target} #{actual_target}\n\n"
		
		target_node = project_xml.css("Target[title=#{actual_target}]>Compiler>Add")
		target_node += project_xml.css("Target[title=#{actual_target}]>Option")
			
		return target_node.map{ |option| mapCompilerOptions option }
	end

	def buildCompilerOptions(project_file_name)
		project_xml = getXML(project_file_name)		
		
		compiler_option_nodes = project_xml.css("Project>Compiler>Add")
		compiler_options = compiler_option_nodes.map { |option| mapCompilerOptions option  }
		
		target_options =  buildTargetCompilerOptions project_file_name
		
		return compiler_options + target_options
	end
	
	def buildLinkerOptions(project_file_name)
		project_xml = getXML(project_file_name)		
		actual_target = project_xml.css("VirtualTargets>Add[alias=#{@target}]").attr("targets").to_str[0..-2]		 
		
		puts "Linking: #{@target} #{actual_target}\n\n"
		
		options_node = project_xml.css("Target[title=#{actual_target}]>Linker>Add")		
		options_node += project_xml.css("Target[title=#{actual_target}]>Option")				
				
		return linker_options = options_node.map { |option| mapLinkerOptions option  }
	end

	def mapCompilerOptions(optionNode)
		return optionNode.attr("option") unless optionNode.attr("option") == nil
		return "-I#{optionNode.attr("directory")}" unless optionNode.attr("directory") == nil		
	end
	
	def mapLinkerOptions(optionNode)
		return "#{optionNode.attr("output")}.a" unless optionNode.attr("output") == nil
	end

	#####################################
	## Project Functions
	#####################################



	#####################################
	## Util Functions
	#####################################

	
end

CodeBlocks = CodeBlocksImpl.new
