require 'test/unit'
require 'codeblocks-builder'

class CodeBlocks_Builder_Tests < Test::Unit::TestCase
  def setup
    @builder = CodeBlocks.new "example/example.workspace"
  end

  def test_build_os_gets_set_on_init
    assert_equal "Windows_NT", @builder.build_os 
  end

  def test_target_gets_set_on_init
    assert_equal "Win32", @builder.target 
  end

  def test_workspace_should_be_built
    assert_not_nil @builder.workspace
  end
end