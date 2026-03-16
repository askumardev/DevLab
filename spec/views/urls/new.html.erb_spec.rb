require 'rails_helper'

RSpec.describe "urls/new", type: :view do
  before(:each) do
    assign(:url, Url.new(
      original_url: "MyString",
      short_code: "MyString"
    ))
  end

  it "renders new url form" do
    render

    assert_select "form[action=?][method=?]", urls_path, "post" do

      assert_select "input[name=?]", "url[original_url]"

      assert_select "input[name=?]", "url[short_code]"
    end
  end
end
