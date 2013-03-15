require 'test/unit'
require 'codeblocks-builder'

class CodeBlocks_Project_Tests < Test::Unit::TestCase
  def setup
    @builder = CodeBlocks.new "example/example.workspace"
    @project = @builder.workspace.projects.first
  end

  def test_project_name_set_on_init
    assert_equal "example/example.cbp", @project.name
  end

  def test_getUnitNames_returns_list_of_files_to_build
    assert_equal ["src/main.cpp"], @project.xml.unitNames
  end

  def test_getHeaderNames_returns_list_of_files_to_build
    assert_equal ["include/example.hpp"], @project.xml.headerNames
  end

  def test_get_compiler_flags_should_return_list_of_flags
    assert_equal ["-Wall", "-Iinclude", "-g"], @project.xml.compilerFlags
  end

  def test_get_object_output_dir_should_return_correct_dir
    assert_equal "obj/", @project.xml.objectOutput
  end

end