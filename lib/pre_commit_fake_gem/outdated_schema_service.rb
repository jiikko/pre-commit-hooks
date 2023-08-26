module PreCommitFakeGem
  class OutdatedSchemaService
    class NotFoundMigrationVersion < StandardError; end
    class OutdatedSchemaError < StandardError; end

    # @param [Array<String>] file_paths
    def initialize(file_paths)
      version_regexp = /db\/migrate\/(\d+)_/
      @version = file_paths.max_by {|path| path.match(version_regexp)[1].to_i }.match(version_regexp)[1]
      raise NotFoundMigrationVersion if(@version.nil?)
    end

    # @return [void]
    def execute
      raise OutdatedSchemaError unless(@version == PreCommitFakeGem.extract_migration_version(read_schema_body))
    end

    private

    # @return [String]
    def read_schema_body
      File.read("db/schema.rb")
    end
  end
end
