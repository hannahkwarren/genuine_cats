# 🔐 Technical Assessment - Splunk

## The assignment:

* Given a JSON object...
* Generate a base64 encoded string AND an MD5 HMAC signature using `'splunk'` as the secret key.
* Create and return a new JSON object with the encoded hashes.

Example output provided with this assignment:
```
{
  "base64": "aGVsbG8gd29ybGQK",
  "md5": "5eb63bbbe01eeed093cb22bb8f5acdc3",
  "msg": "hello world"
}
```

The method I wrote, `generate_encoded`, returns two encoded strings (hashes) along with the original message value. I encapsulated this code in a class called Encoder.
</br>
</br>

## How to run the program:

Clone this repo and navigate to the repo's directory locally in a Terminal window. You'll need Ruby to be installed, at least v 2.4.0.

Navigate to the splunk directory and run the runner file I've provided with two JSON objects,
`ruby runner.rb`

Or, verify functionality by running my tests via `rspec spec/genuine_cats_spec.rb`.

</br>

## My implementation:

I used a total of three ruby modules,  included using require statements:
['json'](https://ruby-doc.org/stdlib-3.0.2/libdoc/json/rdoc/JSON.html), ['base64'](https://ruby-doc.org/stdlib-3.1.2/libdoc/base64/rdoc/Base64.html), and ['openssl'](https://ruby-doc.org/stdlib-3.1.0/libdoc/openssl/rdoc/OpenSSL.html).

My `generate_encoded()` method uses a helper method `valid_json` to verify the provided object is parseable and return a message to the terminal if there's a problem with the JSON input.
It then leverages the parsed hash value in:

* `Base64.strict_encode64(msg)` - strict_encode64 encodes messages without adding line feeds.
* `OpenSSL::HMAC.hexdigest('MD5', key, msg)` - allows computation of Hash-based Message Authentication Code, using the MD5 digest algorithm.
</br>
</br>


## ⚠️ NOTE!
There are differences between the example output hash values provided for this exercise and the hash values produced by my method! Here's why:

1. The **example output base64 message actually includes a new line character at the end**. This makes the final hash character a "K":

```Ruby
Base64.strict_decode64("aGVsbG8gd29ybGQK")
$> "hello world\n"

# versus...

Base64.strict_encode64("hello world")
$> "aGVsbG8gd29ybGQ="
```
I assumed this was an error, so I provided the JSON object message with no newline character at the end.
</br>
</br>

2. The **example MD5 algorithm output did not seem to align with the instructions.** It is only possible to generate the provided string *without a `secret_key` variable*.

I proved this out using two separate OpenSSL functions. First, [OpenSSL::Digest](https://ruby-doc.org/stdlib-3.1.0/libdoc/openssl/rdoc/OpenSSL/Digest.html):
```Ruby
# see md5_keyless method
## create MD5 Digest object
md5 = OpenSSL::Digest.new('MD5')

# parse the message
msg_hash = JSON.parse(@message, symbolize_names: true)

# generate a hexdigest using the string input
## does not support a secret_key argument
md5.hexdigest('hello world')
$>"5eb63bbbe01eeed093cb22bb8f5acdc3"
# ^^ exact match with example output
```

To leverage the secret_key in creating my HMAC, I instead used the [OpenSSL::HMAC module](https://ruby-doc.org/stdlib-3.1.0/libdoc/openssl/rdoc/OpenSSL/HMAC.html):
```Ruby
key = 'splunk'
OpenSSL::HMAC.hexdigest('MD5', key, 'hello world')
$> "74c0fe543c831a67203674738ed88a5d"

```

</br>
</br>

### Don't reveal your secrets!
Hopefully it goes without saying, but in a real application you would not include your `secret_key` in plain text. It should instead be an environment variable.

### Exception handling:

The valid_json? method will rescue from any JSON parsing errors and print the error to console. I'm aware it's slightly repetitive in that I'm doing JSON.parse twice, but seemed better to do this way for separation of concerns.










