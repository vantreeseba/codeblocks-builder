require 'xml/ProjectXmlParser.rb'
require 'compiler/compiler.rb'

class CodeBlocks::Project
	attr_accessor :name
	attr_accessor :xml
	attr_accessor :compiler
	attr_accessor :units

	def initialize(name,target = "Debug")
		@name = name
		@target = target

		@xml = CodeBlocks::ProjectXmlParser.new name,target				

		@compiler = CodeBlocks::Compiler.new "g++","g++",@xml.compilerFlags,@xml.objectOutput
	end

	def build()										
		@compiler.BuildFiles @xml.unitNames
		@compiler.link  @xml.headerNames, @xml.unitNames, @xml.linkerFlags, OPTION_OUTPUT_TYPE_CONSOLE
	end

	def link()
	end	
end