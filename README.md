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

```
Templarbit.api_key = ENV['TB_API_KEY']
Templarbit.property_id = ENV['TB_PROPERTY_ID']
```

In addition you can control the API end point and polling interval with the following environment variables:

```
ENV['TB_API_URL']
ENV['TB_POLL_INTERVAL']
```
