class Workspace
	def buildWorkspace(workspace_name)				
		projects = getProjects(workspace_name)		
		
		projects.each { |project| buildProject project }			
	end
	
	def linkWorkspace(workspace_name)			
		projects = getProjects(workspace_name)		
		
		projects.each { |project| linkProject project }		
	end
	
	def getProjects(workspace_file_name)	
		workspace_xml = getXML(workspace_file_name)
		
		projects = workspace_xml.css("Project")
		project_files = projects.map { |proj| proj.attr("filename")}
		
		return project_files
	end
end