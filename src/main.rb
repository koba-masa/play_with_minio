class Base
  def initialize
    #p __FILE__
    ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)
    #p ENV['BUNDLE_GEMFILE']
    require 'bundler' if File.exist?(ENV['BUNDLE_GEMFILE'])
    Bundler.require(*[:default, :development])
    #p File.expand_path('../../config/settings.yml', __FILE__)
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
