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

  # it 'lists out existing users' do 
    
  #   user1 = User.create(name: "User One", email: "user1@test.com", password: 'rats', password_confirmation: 'rats')
  #   user2 = User.create(name: "User Two", email: "user2@test.com", password: 'socks', password_confirmation: 'socks')
    
  #   visit '/'
    
  #   expect(page).to have_content('Existing Users:')

  #   within('.existing-users') do 
  #     expect(page).to have_content(user1.email)
  #     expect(page).to have_content(user2.email)
  #   end     
  # end 

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

  it "does not display a link to log in or create account as a logged in user" do
    user = User.create!(name: 'dani', email: 'dani@test.com', password: 'password', password_confirmation: 'password')

    visit login_path
    fill_in :name, with: "dani"
    fill_in :email, with: "dani@test.com"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password"
    click_on "Log In"
    
    click_on "Home"
    expect(current_path).to eq(root_path)
    expect(page).to have_link("Log Out")
    expect(page).to_not have_link("Log In")
    expect(page).to_not have_link("Create New User")
  end

  it "when I click the Log Out link, I am redirected to the landing page where I see the option to Log In" do
    user = User.create!(name: 'dani', email: 'dani@test.com', password: 'password', password_confirmation: 'password')

    visit login_path

    fill_in :name, with: "dani"
    fill_in :email, with: "dani@test.com"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password"
    click_on "Log In"

    visit root_path

    expect(page).to have_link("Log Out")
    expect(page).to_not have_link("Log In")
    expect(page).to_not have_link("Create New User")

    click_link "Log Out"

    expect(current_path).to eq(root_path)
    expect(page).to_not have_link("Log Out")
    expect(page).to have_link("Log In")
    expect(page).to have_button("Create New User")
  end
  
  it "does not display existing users as a visitor" do
    user = User.create!(name: 'dani', email: 'dani@test.com', password: 'password', password_confirmation: 'password')

    visit root_path

    expect(page).to_not have_content('dani@test.com')
  end
  
  it "does not contain a link to existing users' show pages" do
    user = User.create!(name: 'dani', email: 'dani@test.com', password: 'password', password_confirmation: 'password')
    user2 = User.create!(name: 'meg', email: 'meg@test.com', password: 'password1', password_confirmation: 'password1')

    visit login_path

    fill_in :name, with: "dani"
    fill_in :email, with: "dani@test.com"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password"
    click_on "Log In"

    visit root_path

    expect(page).to have_content("Existing Users")
    expect(page).to_not have_link("meg@test.com")
    expect(page).to have_content("meg@test.com")
    expect(page).to have_content("dani@test.com")
  end

  it "cannot access the dashboard as a visitor" do
    user = User.create!(name: 'dani', email: 'dani@test.com', password: 'password', password_confirmation: 'password')

    visit root_path

    expect(page).to have_link("View My Dashboard")
    click_link("View My Dashboard")
    expect(current_path).to eq(root_path)
    expect(page).to have_content("Please login or register to view your dashboard.")
  end
end
