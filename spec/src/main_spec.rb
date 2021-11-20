require "./src/main"

RSpec.describe ::Main do
  let(:described_instance) { described_class.new }
  describe 'initialize' do
    it 'クラスが生成可能なこと' do
      expect(described_instance.class).to eq ::Main
    end
  end

  describe 'upload' do
    let(:upload_file_key) { Settings.main.upload_object_key }
    let(:object_option) { { bucket: Settings.aws.s3.bucket, key: upload_file_key } }
    let(:client) do
      client = Aws::S3::Client.new(
        {
          credentials: Aws::Credentials.new(
            Settings.aws.credential.access_key_id,
            Settings.aws.credential.secret_access_key
          ),
          region: Settings.aws.s3.region,
          force_path_style: true,
          endpoint: ENV['AWS_ENDPOINT']
        }
      )
    end
    before(:each) do
      client.delete_object(object_option)
    end

    it 'S3にファイルをアップロードする' do
      described_instance.upload
      expect do
        client.get_object(object_option)
      end.not_to raise_error
    end
  end

  describe 'bucket_name' do
    it 'バケット名(test.bucket)を返却する' do
      expect(described_instance.bucket_name).to eq 'test.bucket'
    end
  end

  describe 'client_options' do
    let(:options) { described_instance.client_options }

    it 'credentialsに認証情報(AWS::Credentials)を設定する' do
      expect(options).to include(:credentials)
      expect(options[:credentials].class).to eq Aws::Credentials
    end

    it '認証情報にAWS_ACCESS_KEY_IDを設定する' do
      expect(options[:credentials].access_key_id).to eq Settings.aws.credential.access_key_id
    end

    it '認証情報にAWS_SECRET_ACCESS_KEYを設定する' do
      expect(options[:credentials].secret_access_key).to eq Settings.aws.credential.secret_access_key
    end

    it 'regionを設定する' do
      expect(options).to include(:region)
      expect(options[:region]).to eq Settings.aws.s3.region
    end

    it 'force_path_styleにtrueを設定する' do
      expect(options).to include(:force_path_style)
      expect(options[:force_path_style]).to eq true
    end

    it 'endpointを設定する' do
      expect(options).to include(:endpoint)
      expect(options[:endpoint]).to eq ENV['AWS_ENDPOINT']
    end
  end

  describe 'client' do
    let(:s3_client) { described_instance.s3_client }
    it 'S3用のClientを作成する' do
      expect(s3_client.class).to eq Aws::S3::Client
    end
  end
end
