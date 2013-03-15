require 'test/unit'
require 'codeblocks-builder'

class CodeBlocks_Workspace_Tests < Test::Unit::TestCase
  def setup
    @builder = CodeBlocks.new "example/example.workspace"
    @workspace = @builder.workspace
  end

  def test_workspace_name_set_on_init
    assert_equal "example/example.workspace", @workspace.name
  end

  def test_workspace_path_set_on_init
    assert_equal "example/", @workspace.path
  end

  def test_workspace_get_project_names_should_return_list_of_project_names
    assert_equal ["example/example.cbp"], @workspace.projectNames
  end

  def test_workspace_get_projects_should_return_list_of_projects
    assert_equal 1, @workspace.projects.length
  end
end