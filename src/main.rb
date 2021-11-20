class Base
  def initialize
    ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
    require 'bundler/setup'
    Bundler.require(*[:default, :development])
    Config.load_and_set_settings(File.expand_path('../../config/settings.yml', __FILE__))
  end
end

class Main < Base

  def upload
    File.open('/dev/null', 'w') do | data |
      data.print('Hello, world.')
      s3_client.put_object(
        {
          bucket: bucket_name,
          key: Settings.main.upload_object_key,
          body: data
        }
      )
    end
  end

  def bucket_name
    Settings.aws.s3.bucket
  end

  def s3_client
    @s3_client ||=Aws::S3::Client.new(client_options)
  end

  def client_options
    {
      credentials: Aws::Credentials.new(
        Settings.aws.credential.access_key_id,
        Settings.aws.credential.secret_access_key
      ),
      region: Settings.aws.s3.region,
      force_path_style: true,
      endpoint: ENV['AWS_ENDPOINT']
    }
  end
end

Main.new.upload
