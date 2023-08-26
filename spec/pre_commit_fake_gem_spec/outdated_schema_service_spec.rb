# frozen_string_literal: true

require "spec_helper"

RSpec.describe PreCommitFakeGem::OutdatedSchemaService do
  describe "#execute" do
    subject { service.execute }

    let(:service) { described_class.new(file_paths) }

    context "db/schema.rb is not outdated" do
      let(:file_paths) { ["db/migrate/20200101000000_create_users.rb", "db/migrate/20200101000001_create_hoge.rb"] }

      before do
        allow(service).to receive(:read_schema_body) do
          <<~BODY
            ActiveRecord::Schema[7.0].define(version: 2020_0101_000001) do
              create_table "demo_devices", charset: "utf8mb4", force: :cascade do |t|
          BODY
        end
      end

      it "does nto raise OutdatedSchemaError" do
        expect { subject }.not_to raise_error
      end
    end

    context "db/schema.rb is outdated" do
      let(:file_paths) { ["db/migrate/20200101000000_create_users.rb", "db/migrate/20200101000001_create_hoge.rb"] }

      before do
        allow(service).to receive(:read_schema_body) do
          <<~BODY
            ActiveRecord::Schema[7.0].define(version: 2022_08_26_075626) do
              create_table "demo_devices", charset: "utf8mb4", force: :cascade do |t|
          BODY
        end
      end

      it "raises OutdatedSchemaError" do
        expect { subject }.to raise_error(described_class::OutdatedSchemaError)
      end
    end
  end
end
