[![Build Status](https://travis-ci.org/templarbit/rails-plugin.svg?branch=master)](https://travis-ci.org/templarbit/rails-plugin)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'templarbit'
```

And then execute:

```bash
$ bundle
```

Create `config/initializers/templarbit.rb` with the following content (you can find your API Key and Property ID on the Templarbit settings page):

```ruby
Rails.configuration.templarbit = {
  :api_key     => ENV['TB_API_KEY'],
  :property_id => ENV['TB_PROPERTY_ID']
}

Templarbit.api_key = Rails.configuration.templarbit[:api_key]
Templarbit.property_id = Rails.configuration.templarbit[:property_id]
```

