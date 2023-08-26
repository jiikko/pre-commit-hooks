# frozen_string_literal: true

require_relative "pre_commit_fake_gem/version"
require_relative "pre_commit_fake_gem/missing_migration_file_service"
require_relative "pre_commit_fake_gem/outdated_schema_service"

module PreCommitFakeGem
  class Error < StandardError; end

  def self.under_git_control?(migration_file)
    shell = "git ls-files --error-unmatch #{migration_file}"
    _stdout, _stderr, status = Open3.capture3(shell)
    status.exitstatus.zero?
  end

  # @return [NilClass, String]
  def self.extract_migration_version(schema_body)
    matched = schema_body.match(/ActiveRecord::Schema\[[^\]]+\].define\(version: ([\d_]+)\) do/)
    return matched && matched[1].gsub("_", "")
  end
end
