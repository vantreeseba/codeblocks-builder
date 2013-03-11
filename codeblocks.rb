include Rake::DSL

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
	## Actually Build functions
	#####################################

	def buildWorkspace(workspace_name)				
		projects = getProjects(workspace_name)		
		
		projects.each { |project| buildProject project }			
	end

	def linkWorkspace(workspace_name)			
		projects = getProjects(workspace_name)		
		
		projects.each { |project| linkProject project }		
	end
	
	def buildProject(project)		
		units = getProjectUnits(project)						
		options = buildCompilerOptions(project).join(" ");
					
		units.each{ |unit|			
			mkdir_p "obj\\" + unit.split("\\")[0..-2].join("\\"), :verbose => false			
			sh "g++ #{options} -c #{unit} -o obj\\#{unit}.o" 
		}	
	end
	
	def linkProject(project)
		units = getProjectUnits(project).map{ |unit|
			"obj\\#{unit}.o"
		}.join(" ")		
		
		options = buildLinkerOptions(project).join(" ");
			
		sh "g++ -s #{options} #{units}"
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
		return "-o #{optionNode.attr("output")}.exe" unless optionNode.attr("output") == nil
	end

	#####################################
	## Project Functions
	#####################################

	def getProjects(workspace_file_name)	
		workspace_xml = getXML(workspace_file_name)
		
		projects = workspace_xml.css("Project")
		project_files = projects.map { |proj| proj.attr("filename")}
		
		return project_files
	end

	def getProjectHeaders(project_file_name)
		project_xml = getXML(project_file_name)
		
		units = project_xml.css("Unit")
		unit_files = units.map { |unit| unit.attr("filename") }.select { |unit| unit.include? ".hpp" }
		
		return unit_files
	end

	def getProjectUnits(project_file_name)
		project_xml = getXML(project_file_name)
		
		units = project_xml.css("Unit")
		unit_files = units.map { |unit| unit.attr("filename") }.select { |unit| unit.include? ".cpp" }
		
		return unit_files
	end

	#####################################
	## Util Functions
	#####################################

	def getXML(fileName)
		xml_file = File.open fileName
		xml_node = Nokogiri::XML(xml_file)
		xml_file.close
		return xml_node
	end
end

CodeBlocks = CodeBlocksImpl.new