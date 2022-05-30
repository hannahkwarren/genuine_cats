# frozen_string_literal: true
# splunk/genuine_cats.rb

require 'json'
require 'base64'
require 'openssl'
require 'pry'

class Encoder
  attr_reader :message

  def initialize(json_object)
    @message = json_object
  end

  # helper method for json validation
  def valid_json?(string)
    JSON.parse(string)
    true
  rescue JSON::ParserError
    false
  end

  def generate_encoded
    if valid_json?(@message)
      msg_hash = JSON.parse(@message, symbolize_names: true)

      # in a real system, should be an ENV_variable:
      key = 'splunk'

      encoded_hash = {  "base64": Base64.strict_encode64(msg_hash[:msg]),
                        "md5": OpenSSL::HMAC.hexdigest('MD5', key, msg_hash[:msg]),
                        "msg": msg_hash[:msg] }

      JSON.generate(encoded_hash)
    else
      'Invalid JSON, please try again.'
    end
  end

  # function to get the instructions' example output, with no custom key
  def md5_keyless
    md5 = OpenSSL::Digest.new('MD5')
    msg_hash = JSON.parse(@message, symbolize_names: true)
    md5.hexdigest(msg_hash[:msg])
  end
end
