require 'rails_helper'

RSpec.describe 'Movies Index Page' do
  before do 
    @user1 = User.create(name: "User One", email: "user1@test.com", password: 'password', password_confirmation: 'password')
    i = 1
    20.times do 
      Movie.create(title: "Movie #{i} Title", rating: rand(1..10), description: "This is a description about Movie #{i}")
      i+=1
    end 
  end 

  it 'shows all movies' do 
    visit login_path

    fill_in :name, with: "User One"
    fill_in :email, with: "user1@test.com"
    fill_in :password, with: "password"
    fill_in :password_confirmation, with: "password"
    click_on "Log In"

    visit "users/#{@user1.id}"

    click_button "Find Top Rated Movies"

    expect(current_path).to eq("/users/#{@user1.id}/movies")

    expect(page).to have_content("Top Rated Movies")
    
    movie_1 = Movie.first

    click_link(movie_1.title)

    expect(current_path).to eq("/users/#{@user1.id}/movies/#{movie_1.id}")

    expect(page).to have_content(movie_1.title)
    expect(page).to have_content(movie_1.description)
    expect(page).to have_content(movie_1.rating)
  end 
  # As a visitor
  # If I go to a movies show page 
  # And click the button to create a viewing party
  # I'm redirected to the movies show page, and a message appears to let me know I must be logged in or registered to create a movie party. 
  #this user story is confusing because you must be logged in to get to the dashboard, and you can't access the movie show page without having access to the dashboard, so......?????
  # it "does not allow creation of a viewing party unless the user is logged in" do
  #   movie_1 = Movie.first

  #   visit "users/#{@user1.id}/movies/#{movie_1.id}"

  #   expect(current_path).to eq(root_path)
  #   expect(page).to have_content("You must be logged in to view this page.")
  # end
end