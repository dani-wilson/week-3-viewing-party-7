require 'rails_helper'

RSpec.describe "User Registration" do
  it 'can create a user with a name and unique email' do
    visit register_path

    fill_in :user_name, with: 'User One'
    fill_in :user_email, with:'user1@example.com'
    fill_in :user_password, with: 'password'
    fill_in :user_password_confirmation, with: 'password'
    click_button 'Create New User'

    expect(current_path).to eq(user_path(User.last.id))
    expect(page).to have_content("User One's Dashboard")
  end 

  it 'does not create a user if email isnt unique' do 
    User.create(name: 'User One', email: 'notunique@example.com', password: 'password', password_confirmation: 'password')

    visit register_path
    
    fill_in :user_name, with: 'User Two'
    fill_in :user_email, with:'notunique@example.com'
    fill_in :user_password, with: 'password'
    fill_in :user_password_confirmation, with: 'password'
    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Email has already been taken")
  end
  
  it "can fill in name, email, password, and password confirmation on the form" do
    visit register_path

    fill_in :user_name, with: 'Lulu'
    fill_in :user_email, with: 'lulu11@test.com'
    fill_in :user_password, with: 'password123'
    fill_in :user_password_confirmation, with: 'password123'
    click_button 'Create New User'

    expect(current_path).to eq(user_path(User.last.id))
    expect(User.last).to_not have_attribute(:password)
    expect(User.last.password_digest).to_not eq('password123')
  end

  it "will not allow blank fields" do
    visit register_path

    fill_in :user_name, with: "dani"
    fill_in :user_password, with: "password"
    fill_in :user_password_confirmation, with: "password"
    click_button "Create New User"

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Email can't be blank")

    fill_in :user_email, with: "dani@test.com"
    fill_in :user_password, with: "password"
    fill_in :user_password_confirmation, with: "password"
    click_button "Create New User"

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Name can't be blank")

    fill_in :user_name, with: "dani"
    fill_in :user_email, with: "dani@test.com"
    fill_in :user_password, with: "password"
    click_button "Create New User"

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Password confirmation doesn't match Password")

    fill_in :user_name, with: "dani"
    fill_in :user_email, with: "dani@test.com"
    fill_in :user_password, with: "password"
    fill_in :user_password_confirmation, with: "llamas"
    click_button "Create New User"

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Password confirmation doesn't match Password")
  end
end
