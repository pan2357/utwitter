require "application_system_test_case"

class LoginsTest < ApplicationSystemTestCase

  test "login success" do
    visit main_url

    fill_in "Email", with: users(:u1).email
    fill_in "Password", with: "testpassword"
    click_on "Login"
    assert_text "Feed"
  end

  test "wrong email" do
    visit main_url

    fill_in "Email", with: "smith"
    fill_in "Password", with: "testpassword"
    click_on "Login"
    assert_text "Email or Password incorrect"
  end

  test "wrong password" do
    visit main_url

    fill_in "Email", with: users(:u1).email
    fill_in "Password", with: "abcxxx"
    click_on "Login"
    assert_text "Email or Password incorrect"
  end

  test "wrong email and password" do
    visit main_url

    fill_in "Email", with: "asdf"
    fill_in "Password", with: "kj;asfk"
    click_on "Login"
    assert_text "Email or Password incorrect"
  end

end
