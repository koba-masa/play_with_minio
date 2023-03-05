class AwsCredential
  def self.credentials
    @credentials ||= Aws::Credentials.new(
      Settings.aws.credential.access_key_id,
      Settings.aws.credential.secret_access_key
    )
  end
end
