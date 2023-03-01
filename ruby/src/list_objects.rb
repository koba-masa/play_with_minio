require './src/base'
require './src/models/s3/client'

class ListObjects < Base
  def execute
    [
      '',
      'sample/',
      'sample',
      '/sample/',
      '/sample',
    ].each do |prefix|
      output(list_objects_v2(prefix))
    end
  end

  def list_objects_v2(prefix)
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

if __FILE__ == $0
  environment = ARGV.size.zero? ? 'test' : ARGV[0]
  ListObjects.new(environment).execute
end
