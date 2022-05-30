# splunk/spec/genuine_cats_spec.rb

require 'rspec'
require './lib/genuine_cats'

RSpec.describe Encoder do
  describe '.generate_encoded' do
    before(:each) do
      @obj1 = '{ "msg": "hello world" }'
      @encoder1 = Encoder.new(@obj1)
      @results1 = @encoder1.generate_encoded

      @obj2 = '{ "msg": "Genuine Cats is the coolest team name ever." }'
      @encoder2 = Encoder.new(@obj2)
      @results2 = @encoder2.generate_encoded
    end

    it 'happy path - creates json' do
      expect(@results1).to be_a(String)
    end

    it 'happy path - json has expected structure' do
      parsed_result = JSON.parse(@results1, symbolize_names: true)
      expect(parsed_result).to have_key(:base64)
      expect(parsed_result[:base64]).to eq('aGVsbG8gd29ybGQ=')
      expect(parsed_result).to have_key(:md5)
      expect(parsed_result[:md5]).to eq('1c97f387c96135895db247dceaad2878')
      expect(parsed_result).to have_key(:msg)
      expect(parsed_result[:msg]).to eq('hello world')
    end

    it 'happy path - another example message' do
      parsed_result = JSON.parse(@results2, symbolize_names: true)
      expect(parsed_result).to have_key(:base64)
      expect(parsed_result[:base64]).to eq('R2VudWluZSBDYXRzIGlzIHRoZSBjb29sZXN0IHRlYW0gbmFtZSBldmVyLg==')
      expect(parsed_result).to have_key(:md5)
      expect(parsed_result[:md5]).to eq('cd201321a0402bfc525ff6c05743feaa')
      expect(parsed_result).to have_key(:msg)
      expect(parsed_result[:msg]).to eq('Genuine Cats is the coolest team name ever.')
    end

    it 'sad path - bad JSON input' do
      encoder3 = Encoder.new('faulty_msg: Nope.')
      results3 = encoder3.generate_encoded

      expect(results3).to eq('Invalid JSON, please try again.')
    end
  end

  describe '.md5_keyless' do
    it 'for reference, MD5 encryption without a secret key' do
      hello_world = '{ "msg": "hello world" }'
      encoder4 = Encoder.new(hello_world)
      results4 = encoder4.md5_keyless

      expect(results4).to eq('5eb63bbbe01eeed093cb22bb8f5acdc3')
    end
  end
end
