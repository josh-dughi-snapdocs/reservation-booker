require "application_system_test_case"

class PropertiesTest < ApplicationSystemTestCase
  setup do
    @property = properties(:one)
  end

  test "visiting the index" do
    visit properties_url
    assert_selector "h1", text: "Properties"
  end

  test "creating a Property" do
    visit properties_url
    click_on "New Property"

    fill_in "Address line 1", with: @property.address_line_1
    fill_in "Address line 2", with: @property.address_line_2
    fill_in "City", with: @property.city
    fill_in "Description", with: @property.description
    fill_in "Postal code", with: @property.postal_code
    fill_in "State", with: @property.state
    click_on "Create Property"

    assert_text "Property was successfully created"
    click_on "Back"
  end

  test "updating a Property" do
    visit properties_url
    click_on "Edit", match: :first

    fill_in "Address line 1", with: @property.address_line_1
    fill_in "Address line 2", with: @property.address_line_2
    fill_in "City", with: @property.city
    fill_in "Description", with: @property.description
    fill_in "Postal code", with: @property.postal_code
    fill_in "State", with: @property.state
    click_on "Update Property"

    assert_text "Property was successfully updated"
    click_on "Back"
  end

  test "destroying a Property" do
    visit properties_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Property was successfully destroyed"
  end
end
