require 'rake'

OPTION_OUTPUT_TYPE_GUI = 0
OPTION_OUTPUT_TYPE_CONSOLE = 1
OPTION_OUTPUT_TYPE_STATIC_LIB = 2 
OPTION_OUTPUT_TYPE_DYNAMIC_LIB = 3
OPTION_OUTPUT_TYPE_COMMANDS_ONLY = 4
OPTION_OUTPUT_TYPE_NATIVE = 5

class CodeBlocks::Compiler
	include Rake::DSL

	attr_accessor :compiler	
	attr_accessor :flags
	attr_accessor :output_path

	def initialize(compiler = "gcc",linker = "gcc",flags = "",output_path = "obj")
		@compiler = compiler
		@linker = linker
		@flags = flags.join(" ")
		@output_path = output_path
	end

	def BuildFiles(units)
		units.each{ |unit|	BuildFile unit}	
	end

	def BuildFile(unit)
		mkdir_p "#{@output_path}\\" + unit.split("\\")[0..-1].join("\\"), :verbose => false
		sh "#{@compiler} #{@flags} -c #{unit} -o #{output_path}#{unit}.o"
	end

	def link(headers,units,linkerOptions,linkType)
		case linkType
		when OPTION_OUTPUT_TYPE_STATIC_LIB
			linkLibrary headers, units, linkerOptions
		when OPTION_OUTPUT_TYPE_CONSOLE
			linkExecutable headers, units, linkerOptions
		end
	end

	def linkLibrary(headers, units, flags)
		objs = units.map{ |unit| "#{@output_path}#{unit}.o" }.join(" ") 
		sh "#{@linker} rvs #{flags.join(" ")} #{headers.join(" ")} #{units} -o bin\\test.a"
	end

	def linkExecutable(headers, units, flags)
		objs = units.map{ |unit| "#{@output_path}#{unit}.o" }.join(" ") 
		sh "#{@linker} #{flags.join(" ")} -o bin\\test.exe  #{objs}"
	end
end