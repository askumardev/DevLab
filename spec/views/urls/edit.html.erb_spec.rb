require 'rails_helper'

RSpec.describe "urls/edit", type: :view do
  let(:url) {
    Url.create!(
      original_url: "MyString",
      short_code: "MyString"
    )
  }

  before(:each) do
    assign(:url, url)
  end

  it "renders the edit url form" do
    render

    assert_select "form[action=?][method=?]", url_path(url), "post" do

      assert_select "input[name=?]", "url[original_url]"

      assert_select "input[name=?]", "url[short_code]"
    end
  end
end
