module PreCommitFakeGem
  class MissingMigrationFileService
    class NotSupportedFileError < StandardError; end
    class NotFoundMigrationVersion < StandardError; end
    class GitUncontrolledFileError < StandardError; end

    # @param [String] file_path
    def initialize(file_paths)
      schema_path = file_paths.detect { |file_path| file_path == "db/schema.rb" }
      raise NotSupportedFileError unless schema_path
      @schema_path = schema_path
    end

    # @return [void]
    def execute
      migration_version = PreCommitFakeGem.extract_migration_version(read_file)
      raise NotFoundMigrationVersion unless migration_version

      migration_file = "db/migrate/#{migration_version}*.rb"
      raise GitUncontrolledFileError unless(PreCommitFakeGem.under_git_control?(migration_file))
    end

    private

    # @return [String]
    def read_file
      File.read(@schema_path)
    end
  end
end
