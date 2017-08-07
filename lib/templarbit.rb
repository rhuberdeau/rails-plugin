require 'net/http'
require 'uri'
require 'json'

module Templarbit
  def self.api_key=(value)
    @@api_key = value
  end

  def self.property_id=(value)
    @@property_id = value
  end

  @@poll_interval = 15.seconds
  @@api_url = "https://api.templarbit.com/v1"

  private 
 
  def self.api_key
    @@api_key
  end

  def self.property_id
    @@property_id
  end

  def self.poll_interval
    @@poll_interval
  end

  def self.api_url
    @@api_url
  end


  class API
    attr_reader :csp, :csp_report_only

    def initialize
      @csp = ""
      @csp_report_only = ""

      # start worker thread
      Thread.new do
        loop do

          if Rails.env.test?
            @csp = "test"
            @csp_report_only = "test_report_only"
            break
          end

          # poll templarbit API for Content-Security-Policy
          r = Net::HTTP.post URI(Templarbit.api_url), 
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

              if !body["error"].blank?
                Rails.logger.warn "Templarbit: #{body['error']}"

              elsif body["csp"].blank? && body["csp_report_only"].blank?
                Rails.logger.warn "Templarbit: Fetch successful, but Content-Security-Policy was empty"

              else
                @csp = body["csp"]
                @csp_report_only = body["csp_report_only"]
              end

            rescue => e
              Rails.logger.warn "Templarbit: Failed to parse API JSON response: #{e}"
            end
          end

          # wait and then poll again
          sleep Templarbit.poll_interval 
        end
      end
    end
  end

  class Middleware
    def initialize(app)
      @app = app
      @api = Templarbit::API.new
    end

    def call(env)
      dup.call! env # make thread safe
    end

    def call!(env)
      resp = @app.call(env)

      unless @api.csp.blank? 
        resp[1]["Content-Security-Policy"] = @api.csp 
      end

      unless @api.csp_report_only.blank? 
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
