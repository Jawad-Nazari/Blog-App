require 'rails_helper'

RSpec.describe 'User Index Page', type: :feature do
  before :each do
    @user = User.create(name: 'Jawad',
                        photo: 'https://drive.google.com/file/jawad.png',
                        bio: 'BCS', posts_counter: 15)
    @post = Post.create(title: 'Physics', text: 'This is not my first post', comments_counter: 10, likes_counter: 10,
                        author: @user)
    @post1 = @user.posts.create(title: 'Post 1', text: 'Text for post 1', comments_counter: 5, likes_counter: 10)
    visit user_path(@user)
    @post2 = @user.posts.create(title: 'Post 2', text: 'Text for post 2', comments_counter: 2, likes_counter: 20)
    visit user_path(@user)
  end

  describe 'User index page' do
    before(:each) { visit users_path }

    it 'applies the correct CSS styles' do
      visit users_path
    end

    it 'the main container has the main class' do
      expect(page).to have_css('.main')
    end

    it 'display the title of the user who has a title class' do
      expect(page).to have_css('.title')
    end

    it 'displays the username of each user' do
      User.all.each do |user|
        expect(page).to have_content(user.name)
      end
    end

    it 'displays the photos of each user' do
      User.all.each do |user|
        expect(page.has_xpath?("//img[@src = '#{user.photo}' ]"))
      end
    end

    it 'shows the number of posts of each user' do
      User.all.each do |user|
        expect(page).to have_content("Total number of posts are: #{user.posts_counter}")
      end
    end

    it "is redirected to that user's show page" do
      click_link(@user.name)
      expect(page).to have_current_path(user_path(@user.id))
    end
  end
end
