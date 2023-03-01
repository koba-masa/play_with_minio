module S3
  class Client
    def client
      @client ||= Aws::S3::Client.new(options)
    end

    def options
      options = {
        credentials: Aws::Credentials.new(
          Settings.aws.credential.access_key_id,
          Settings.aws.credential.secret_access_key
        ),
        region: Settings.aws.s3.region,
      }

      unless Settings.aws.s3.endpoint.nil? && Settings.aws.s3.endpoint.empty?
        options = options.merge(
          {
            force_path_style: true,
            endpoint: Settings.aws.s3.endpoint
          }
        )
      end

      options
    end

  end
end