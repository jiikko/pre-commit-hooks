#!/usr/bin/env ruby
# frozen_string_literal: true

require "open3"

def under_git_control?(migration_version)
  shell = "git ls-files --error-unmatch db/migrate/#{migration_version}*.rb"
  _stdout, _stderr, status = Open3.capture3(shell)
  status.exitstatus.zero?
end

file_path = ARGV[0]

unless file_path == "db/schema.rb"
  warn "This script only works with db/schema.rb"
  return
end

schema_body = File.read(file_path)
matched = schema_body.match(/ActiveRecord::Schema\[[^\]]+\].define\(version: ([\d_]+)\) do/)

unless matched
  warn "Could not find migration version in db/schema.rb"
  return
end

migration_version = matched[1].gsub("_", "")

if under_git_control?(migration_version)
  exit 0
else
  exit 1
end
