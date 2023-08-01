require 'rails_helper'

RSpec.describe 'User Index Page', type: :feature do
  before :each do
    @user = User.create(name: 'Jawad',
                        photo: 'https://drive.google.com/file/d/1OgXPAMMaFb1GIC6nHrjR07qUTbMESZsC/view?usp=sharing',
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

  describe 'User show page' do
    before(:each) { visit user_path(id: @user.id) }

    it 'has a container element that has a class named info' do
      expect(page).to have_css('.info')
    end

    it "displays the user's profile picture" do
      expect(page.has_xpath?("//img[@src = '#{@user.photo}' ]"))
    end

    it "displays the user's username" do
      expect(page).to have_content(@user.name)
      expect(page).to have_link(@user.name, href: user_path(id: @user.id))
    end

    it "shows the user's bio" do
      expect(page).to have_content('Bio')
      expect(page).to have_content(@user.bio)
    end

    it 'shows the first 3 posts of the user' do
      @user.recent_posts.each do |post|
        expect(page).to have_content(post.text)
      end
    end

    it 'has a button to view all user posts' do
      expect(page).to have_link('Show All', href: user_posts_path(user_id: @user.id))
    end

    it 'displays the recent posts of the user' do
      expect(page).to have_content(@post1.title)
      expect(page).to have_content(@post1.text)
      expect(page).to have_content('Comments: 5')
      expect(page).to have_content('Likes: 10')

      expect(page).to have_content(@post2.title)
      expect(page).to have_content(@post2.text)
      expect(page).to have_content('Comments: 2')
      expect(page).to have_content('Likes: 20')
    end

    it 'has links to view individual posts' do
      click_link(@post2.title)
      expect(page).to have_current_path(user_post_path(@user, @post2))
    end

    it 'redirects to open all posts of a user' do
      click_link('Show All')
      expect(page).to have_current_path(user_posts_path(@user))
    end
  end
end

describe 'post page' do
  before(:each) do
    @user = User.create(
      name: 'Jawad',
      bio: 'BCS',
      photo: 'https://drive.google.com/file/d/1OgXPAMMaFb1GIC6nHrjR07qUTbMESZsC/view?usp=sharing'
    )
    @post1 = Post.create(title: 'First Post', text: 'This is my first post', author_id: @user.id)
    @post2 = Post.create(title: 'Second Post', text: 'This is my second post', author_id: @user.id)
    @post3 = Post.create(title: 'Third Post', text: 'This is my third post', author_id: @user.id)
    @comment = Comment.create(text: 'First comment', author_id: @user.id, post_id: @post1.id)
    Like.create(author_id: @user.id, post_id: @post1.id)
    @posts = [@post1, @post2, @post3]
    visit(user_posts_path(@user.id))
  end

  it "shows user's profile picture" do
    expect(page).to have_css('img[src*="https://drive.google.com/file/d/1OgXPAMMaFb1GIC6nHrjR07qUTbMESZsC/view?usp=sharing"]')
  end

  it 'post title' do
    expect(page).to have_content 'First Post'
  end

  it 'likes count show' do
    expect(page).to have_content 'Likes: 1'
  end

  it 'shows the comment count for each post' do
    expect(page).to have_content('Comments: 1', count: 1)
  end

  it 'shows the users username' do
    expect(page).to have_content('Jawad')
  end

  it 'shows the total number of posts for each user' do
    User.all.each do |user|
      expect(page).to have_content("Total number of posts are: #{user.posts.count}")
    end
  end

  it 'shows posts title with correct link text' do
    @posts.each do |post|
      expect(page).to have_link(post.title, href: user_post_path(post.author, post))
    end
  end

  it 'shows some of the posts body' do
    expect(page).to have_content 'This is my first post'
  end

  it 'shows the first comment on a post' do
    expect(page).to have_content(@comment.text)
  end

  it 'shows a section for pagination' do
    expect(page).to have_content('Pagination')
  end

  it 'when user clicks on a post, it redirects to that post show page' do
    click_link @post1.title
    expect(page).to have_current_path user_post_path(@post1.author_id, @post1)
  end
end
end
