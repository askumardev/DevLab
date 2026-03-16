require 'rails_helper'

RSpec.describe "urls/index", type: :view do
  before(:each) do
    assign(:urls, [
      Url.create!(
        original_url: "Original Url",
        short_code: "Short Code"
      ),
      Url.create!(
        original_url: "Original Url",
        short_code: "Short Code"
      )
    ])
  end

  it "renders a list of urls" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Original Url".to_s), count: 2
    assert_select cell_selector, text: Regexp.new("Short Code".to_s), count: 2
  end
end
