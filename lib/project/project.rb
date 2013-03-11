require 'rake'
include Rake::DSL

class Project
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
			
		sh "ar rvs #{options} #{units}"
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
end