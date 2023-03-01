require 'config'
require 'aws-sdk-s3'

class ListObject
  DEFAULT_CONFIG_FILE = 'config/settings.yml'

  def initialize(config_file)
    if config_file.nil? || config_file.empty?
      config_file = DEFAULT_CONFIG_FILE
   end

   file_path = File.expand_path(config_file, Dir.pwd)
   unless File.exist?(file_path) || File.file?(file_path)
    raise StandardError("File is not found. : #{file_path}")
   end

    Config.load_and_set_settings(file_path)
  end

  def execute
    output(list)
    output(list('sample/'))
    output(list('sample'))
    output(list('/sample/'))
    output(list('/sample'))
  end

  def client
    @client ||= Aws::S3::Client.new(client_options)
  end

  def client_options
    options = {
      credentials: Aws::Credentials.new(
        Settings.aws.credential.access_key_id,
        Settings.aws.credential.secret_access_key
      ),
      region: Settings.aws.s3.region,
    }
    options = options.merge({force_path_style: true, endpoint: Settings.aws.s3.endpoint}) \
        unless Settings.aws.s3.endpoint.nil? || Settings.aws.s3.endpoint.empty?
    options
  end

  def list(prefix='')
    client.list_objects_v2(
      {
        bucket: Settings.aws.s3.bucket,
        prefix: prefix,
      }
    )
  end

  def output(results)
    puts "Prefix: #{results.prefix}"
    if results.contents.size.zero?
      puts "  Object matched with prefix is not exists."
      return
    end
    results.contents.each do | content |
      puts "  key: #{content.key}"
    end
  end
end

lo = ListObject.new(ARGV[0])
lo.execute
