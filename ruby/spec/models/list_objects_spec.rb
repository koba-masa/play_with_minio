require "./src/list_objects"
require "./src/models/s3/client"

RSpec.describe ListObjects do
  let(:s3_client) { S3::Client.new.client }
  let(:test_bucket) { 'sample.bucket' }

  describe 'list_objects_v2' do
    let(:upload_file) { File.read("spec/fixtures/list_objects/file.txt") }
    let(:files) do
      [
        'test/list_objects/file1.txt',
        'test/list_objects/file2.txt',
        'test/list_objects/file3.txt',
      ]
    end

    before do
      files.each do |file|
        s3_client.put_object({bucket: test_bucket, key: file, body: upload_file})
      end
    end

    after do
      files.each do |file|
        s3_client.delete_object({bucket: test_bucket, key: file})
      end
    end

    it do
      response = described_class.new('test').list_objects_v2('test/list_objects/')

      expect(response.contents.map(&:key)).to match_array(files)
    end
  end
end
