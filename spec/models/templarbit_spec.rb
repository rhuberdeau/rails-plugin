require "rails_helper"

module Templarbit
  describe Middleware do
    let(:rack) { Middleware.new(app) }
    let(:app)  { Proc.new { |env| ['200', {'Content-Type' => 'text/html'}, ['A barebones rack app.']]} }

    before(:each) do
      allow(Thread).to receive(:new).and_yield
      allow_any_instance_of(Templarbit::API).to receive(:loop).and_yield
    end

    context "when there are no errors" do
      it "csp_report is populated" do
        VCR.use_cassette("success") do
          response = rack.call({})
          expect(rack.api.csp_report_only).to eq("default-src 'self'; script-src 'self'; object-src 'self'; base-uri 'none'; report-uri https://logs.templarbit.com/csp/#{ENV['PROPERTY_ID']}/reports;")
        end
      end

      it "csp is populated" do
        VCR.use_cassette("success") do
          response = rack.call({})
          expect(rack.api.csp).to eq(nil)
        end
      end
    end

    context "when there is anything but a 200 response" do
      before do
        ENV["API_KEY"] = "foo"
      end

      it "csp_report is not populated" do
        VCR.use_cassette("401") do
          response = rack.call({})
          expect(rack.api.csp_report_only).to be_nil
        end
      end

      it "csp is not populated" do
        VCR.use_cassette("401") do
          response = rack.call({})
          expect(rack.api.csp).to be_nil
        end
      end
    end
  end
end
