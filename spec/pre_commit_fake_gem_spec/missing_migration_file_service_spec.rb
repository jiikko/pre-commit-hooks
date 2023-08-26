require "spec_helper"

RSpec.describe PreCommitFakeGem::MissingMigrationFileService do
  describe "#execute" do
    subject { service.execute }

    let(:service) { described_class.new(file_paths) }

    context "when file is not db/schema.rb" do
      let(:file_paths) { ["config/hoge"] }

      it "raises NotSupportedFileError" do
        expect { subject }.to raise_error(described_class::NotSupportedFileError)
      end
    end

    context "when file is db/schema.rb" do
      let(:file_paths) { ["db/schema.rb"] }

      context 'when version is not found' do
        before do
          allow(service).to receive(:read_file) { '' }
        end

        it "raises NotSupportedFileError" do
          expect { subject }.to raise_error(described_class::NotFoundMigrationVersion)
        end
      end

      context 'when version is found' do
        before do
          allow(service).to receive(:read_file)
          allow(PreCommitFakeGem).to receive(:extract_migration_version) { '202_00101000000' }
        end

        context 'when migration file is not under git control' do
          it "raises GitUncontrolledFileError" do
            expect(PreCommitFakeGem).to receive(:under_git_control?).with("db/migrate/202_00101000000*.rb") { false }
            expect { subject }.to raise_error(described_class::GitUncontrolledFileError)
          end
        end

        context 'when migration file is under git control' do
          it "does not raise GitUncontrolledFileError" do
            expect(PreCommitFakeGem).to receive(:under_git_control?).with("db/migrate/202_00101000000*.rb") { true }
            expect { subject }.not_to raise_error
          end
        end
      end
    end
  end
end
