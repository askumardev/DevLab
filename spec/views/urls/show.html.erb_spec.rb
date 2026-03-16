require 'rails_helper'

RSpec.describe "urls/show", type: :view do
  before(:each) do
    assign(:url, Url.create!(
      original_url: "Original Url",
      short_code: "Short Code"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Original Url/)
    expect(rendered).to match(/Short Code/)
  end
end
