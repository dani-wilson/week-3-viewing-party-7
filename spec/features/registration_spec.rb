require 'rails_helper'

RSpec.describe "User Registration" do
  it 'can create a user with a name and unique email' do
    visit register_path

    fill_in :user_name, with: 'User One'
    fill_in :user_email, with:'user1@example.com'
    click_button 'Create New User'

    expect(current_path).to eq(user_path(User.last.id))
    expect(page).to have_content("User One's Dashboard")
  end 

  it 'does not create a user if email isnt unique' do 
    User.create(name: 'User One', email: 'notunique@example.com')

    visit register_path
    
    fill_in :user_name, with: 'User Two'
    fill_in :user_email, with:'notunique@example.com'
    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Email has already been taken")
  end
  # As a visitor 
  # When I visit `/register`
  # I see a form to fill in my name, email, password, and password confirmation.
  # When I fill in that form with my name, email, and matching passwords,
  # I'm taken to my dashboard page `/users/:id`
  it "can fill in name, email, password, and password confirmation on the form" do
    User.create(name: "Lulu11", email: "lulu11@test.com")
  end
end
