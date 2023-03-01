require "./src/models/s3/client"

module S3
  RSpec.describe Client do
    let(:instance) { described_class.new }

    describe 'client' do
      it 'Aws::S3::Clientのインスタンスが返却されること' do
        expect(instance.client.instance_of?(Aws::S3::Client)).to be_truthy
      end
    end

    describe 'options' do
      context '設定ファイル内にaws.s3.endpointが定義されている場合' do
        it 'endpointが設定されていること' do
          expect(instance.options).to include(:endpoint)
        end
      end

      context '設定ファイル内にaws.s3.endpointが定義されていない場合' do
        xit 'endpointが設定されていないこと' do
          expect(described_class.new.options).not_to include(:endpoint)
        end
      end
    end
  end
end
