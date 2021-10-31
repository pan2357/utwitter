require "application_system_test_case"

class LikingsTest < ApplicationSystemTestCase
  # test "visiting the index" do
  #   visit likings_url
  #
  #   assert_selector "h1", text: "Likings"
  # end

  test "login success" do
    
    # login as u1
    visit main_url
    fill_in "Email", with: users(:u1).email
    fill_in "Password", with: "testpassword"
    click_on "Login"

    # visit u2 then follow u2 then go back to feed
    visit profile_url("TestingLike")
    click_on "Follow"
    click_on "Feed"

    # check if number of like really increase
    assert_selector "a.like_lister", text: "Like : 0"
    click_on "Like"
    click_on "TestingLike"
    assert_selector "a.like_lister", text: "Like : 1"

    # check if u1 is listed as one of users who liked the post
    find(".like_lister").click
    assert_link "John"

  end

end
