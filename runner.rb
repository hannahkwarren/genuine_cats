# frozen_string_literal: true
require './lib/genuine_cats'

obj1 = '{ "msg": "hello world" }'
obj2 = '{ "msg": "Genuine Cats is the coolest team name ever." }'

encoder1 = Encoder.new(obj1)
encoder2 = Encoder.new(obj2)

p encoder1.generate_encoded
p encoder2.generate_encoded
