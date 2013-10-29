require 'minitest_helper'

feature "Saves an impression", js: true do
  scenario "tests" do
    visit "/"

    page.must_have_content "Homepage"
  end
end

