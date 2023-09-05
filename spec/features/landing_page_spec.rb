require 'rails_helper'

RSpec.describe 'Landing Page' do
  before :each do 
    user1 = User.create(name: "User One", email: "user1@test.com")
    user2 = User.create(name: "User Two", email: "user2@test.com")
    visit '/'
  end 

  it 'has a header' do
    expect(page).to have_content('Viewing Party Lite')
  end

  it 'has links/buttons that link to correct pages' do 
    click_button "Create New User"
    
    expect(current_path).to eq(register_path) 
    
    visit '/'
    click_link "Home"

    expect(current_path).to eq(root_path)
  end 

  it 'lists out existing users' do 
    
    user1 = User.create(name: "User One", email: "user1@test.com", password: 'rats', password_confirmation: 'rats')
    user2 = User.create(name: "User Two", email: "user2@test.com", password: 'socks', password_confirmation: 'socks')
    
    visit '/'
    
    expect(page).to have_content('Existing Users:')

    within('.existing-users') do 
      expect(page).to have_content(user1.email)
      expect(page).to have_content(user2.email)
    end     
  end 

  it "can login as a registered user" do
    user = User.create!(name: 'dani', email: 'dani@test.com', password: 'password', password_confirmation: 'password')

    visit '/'

    expect(page).to have_link("Log In")
    click_link "Log In"
    expect(current_path).to eq(login_path)

    fill_in :name, with: "dani"
    fill_in :email, with: "dani@test.com"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password"
    click_on "Log In"

    expect(current_path).to eq(user_path(user.id))
    expect(page).to have_content("Welcome, dani")
  end
  
  it "will not allow incorrect or partial credentials" do
    user = User.create!(name: 'dani', email: 'dani@test.com', password: 'password', password_confirmation: 'password')

    visit login_path

    fill_in :name, with: "dani"
    fill_in :email, with: "dani1@test.com"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password"
    click_on "Log In"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Invalid credentials")

    fill_in :name, with: "dani"
    fill_in :email, with: "dani@test.com"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "passwords"
    click_on "Log In"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Invalid credentials")

    fill_in :email, with: "dani@test.com"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "passwords"
    click_on "Log In"

    expect(current_path).to eq(login_path)
    expect(page).to have_content("Invalid credentials")
  end
end
