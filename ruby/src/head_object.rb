require './src/base'
require './src/models/s3/client'

class HeadObject < Base
  def execute
    [
      'not_exist.txt',
      'sample/file2.txt',
      'sample',
    ].each do |key|
      puts "Key: #{key}"
      head_object(key)
    rescue => e
      puts "   Error: #{e}"
    end
  end

  def head_object(key)
    client.head_object(
      {
        bucket: Settings.aws.s3.bucket,
        key: key,
      }
    )
  end
end

if __FILE__ == $0
  environment = ARGV.size.zero? ? 'test' : ARGV[0]
  HeadObject.new(environment).execute
end
