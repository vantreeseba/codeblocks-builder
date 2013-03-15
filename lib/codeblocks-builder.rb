class CodeBlocks
	attr_accessor :build_os
	attr_accessor :target
	attr_accessor :workspace

	def initialize(workspace_name=nil)
		@build_os = ENV['os']
		@target = getBuildTarget()		

		if workspace_name == nil
			workspace_name = Dir.glob("*.workspace").first
			puts "No workspace specified, using #{workspace_name}"
		end

		@workspace = Workspace.new workspace_name
	end
	
	def getBuildTarget()
		case @build_os
		when "Windows_NT"
			return "Win32"
		end
	end	

	def Build()
		@workspace.build
	end
end

require 'workspace/workspace.rb'