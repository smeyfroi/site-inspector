require 'spec_helper'

describe SiteInspector::Endpoint::Content do

  subject do
    body = <<-eos
      <!DOCTYPE html>
      <html>
        <body>
          <h1>Some page</h1>
        </body>
      </html>
    eos

    stub_request(:get, "http://example.com/").
      to_return(:status => 200, :body => body )
    endpoint = SiteInspector::Endpoint.new("http://example.com")
    SiteInspector::Endpoint::Content.new(endpoint)
  end

  it "returns the doc" do
    expect(subject.document.class).to eql(Nokogiri::HTML::Document)
    expect(subject.document.css("h1").text).to eql("Some page")
  end

  it "returns the body" do
    expect(subject.body).to match("<h1>Some page</h1>")
  end

  it "returns the doctype" do
    expect(subject.doctype).to eql("html")
  end

  it "knows when robots.txt exists" do
    stub_request(:get, "http://example.com/robots.txt").
      to_return(:status => 200)
    expect(subject.robots_txt?).to eql(true)
  end

  it "knows when robots.txt doesn't exist" do
    stub_request(:get, "http://example.com/robots.txt").
      to_return(:status => 404)
    expect(subject.robots_txt?).to eql(false)
  end

  it "knows when sitemap.xml exists" do
    stub_request(:get, "http://example.com/sitemap.xml").
      to_return(:status => 200)
    expect(subject.sitemap_xml?).to eql(true)
  end

  it "knows when sitemap.xml exists" do
    stub_request(:get, "http://example.com/sitemap.xml").
      to_return(:status => 404)
    expect(subject.sitemap_xml?).to eql(false)
  end
end