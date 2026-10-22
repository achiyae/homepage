require_relative "test_helper"
require "yaml"

class WorkflowTest < Minitest::Test
  WF = YAML.safe_load(File.read(File.join(ROOT, ".github", "workflows", "pages.yml")), aliases: true)

  def test_no_top_level_concurrency
    refute WF.key?("concurrency")
  end

  def test_deploy_group_never_cancels
    c = WF["jobs"]["deploy"]["concurrency"]
    assert_equal "pages-deploy", c["group"]
    assert_equal false, c["cancel-in-progress"]
  end

  def test_build_group_is_per_ref
    assert_includes WF["jobs"]["build"]["concurrency"]["group"], "github.ref"
  end
end
