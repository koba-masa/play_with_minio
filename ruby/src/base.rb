require 'bundler/setup'

class Base
  def initialize(environment)
    Bundler.require(*[:default, :development])
    config = File.expand_path("../config/#{environment}.yml", __dir__)
    raise StandardError.new("File is not found.: #{config}") unless File.exist?(config)
    Config.load_and_set_settings(config)
  end

  def client
    @client ||= ::S3::Client.new.client
  end
end
