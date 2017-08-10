require 'net/http'
require 'uri'
require 'json'

module Templarbit
  mattr_accessor :api_key do
    ENV["TB_API_KEY"]
  end

  mattr_accessor :property_id do
    ENV["TB_PROPERTY_ID"]
  end

  mattr_accessor :poll_interval do
    ENV["TB_POLL_INTERVAL"] || 15
  end

  mattr_accessor :api_url do
    ENV["TB_API_URL"] || "https://api.templarbit.com/v1"
  end

  class API
    attr_reader :csp, :csp_report_only
    attr_accessor :called

    def initialize
      @csp = nil
      @csp_report_only = nil
      @called = false
    end

    def return_if_missing_config
      if Templarbit.api_key.nil?
        Rails.logger.warn "Templarbit: Missing api key"
        return
      end

      if Templarbit.property_id.nil?
        Rails.logger.warn "Templarbit: Missing property_id"
        return
      end
    end

    def call_api
      called = true
      return_if_missing_config

      Thread.new do
        loop do
          # poll templarbit API for Content-Security-Policy
          r = Net::HTTP.post URI(Templarbit.api_url + "/csp"),
            {"property_id" => Templarbit.property_id,
             "token" => Templarbit.api_key}.to_json,
             "Content-Type" => "application/json"

          if r.code == "401"
            Rails.logger.warn "Templarbit: Invalid api_token and/or property_id"

          elsif r.code != "200"
            Rails.logger.warn "Templarbit: Fetch failed, status code #{r.code}"

          else
            begin
              body = JSON.parse(r.body)

              if body["error"]
                Rails.logger.warn "Templarbit: #{body['error']}"

              elsif !body["csp"] && !body["csp_report_only"]
                Rails.logger.warn "Templarbit: Fetch successful, but Content-Security-Policy was empty"

              else
                @csp = body["csp"]
                @csp_report_only = body["csp_report_only"]
              end

            rescue => e
              Rails.logger.warn "Templarbit: Failed to parse API JSON response: #{e}"
            end
          end
          sleep Templarbit.poll_interval.to_i
        end
      end

    end
  end

  class Middleware
    attr_reader :api

    def initialize(app)
      @app = app
      @api = Templarbit::API.new
    end

    def call(env)
      dup.call! env # make thread safe
    end

    def call!(env)
      resp = @app.call(env)
      @api.called ? nil : @api.call_api

      if @api.csp
        resp[1]["Content-Security-Policy"] = @api.csp
      end

      if @api.csp_report_only
        resp[1]["Content-Security-Policy-Report-Only"] = @api.csp_report_only
      end

      return resp
    end
  end

  class Railtie < Rails::Railtie
    initializer "templarbit.configure_rails_initialization" do |app|
      app.middleware.use Templarbit::Middleware
    end
  end
end
