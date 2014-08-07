# Rainforest::Integrations

Integrate [Rainforest QA]( https://www.rainforestqa.com/ ) with 3rd party services.

## Installation

Add this line to your application's Gemfile:

    gem 'rainforest-integrations'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rainforest-integrations

## Usage

### Testing your integrations

We provide a CLI tool to send an event to your integration.

```bash
./bin/test_rainforest_integration -o hipchat_room=Developers -o hipchat_token=my_token hipchat
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/rainforest-integrations/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
