Puppet::Functions.create_function(:'deployments::generate') do
  dispatch :generate do
    param 'Hash', :data
    param 'String[1]', :secret
  end

  def generate(data, secret)
    require 'jwt'

    # Remove quotes to work around CDPE-3903
    # secret.gsub!(/"/, '')

    JWT.encode(data, secret)
  end
end
