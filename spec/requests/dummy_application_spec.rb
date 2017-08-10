require "rails_helper"

RSpec.describe "Dummy app", :type => :request do
  describe "#hello" do
    before(:each) do
      allow(Thread).to receive(:new).and_yield
      allow_any_instance_of(Templarbit::API).to receive(:loop).and_yield
    end

    it "uses the templarbit gem" do
      VCR.use_cassette("request") do
        header_string ="default-src 'self'; script-src 'self'; object-src 'self'; base-uri 'none'; report-uri https://logs.templarbit.com/csp/example_property_id/reports;"

        get '/hello'
        expect(response).to have_http_status(200)
        expect(response.headers["Content-Security-Policy-Report-Only"]).to eq(header_string)
      end
    end
  end
end
