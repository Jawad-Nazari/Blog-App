# spec/views/user_posts_index_spec.rb

require 'rails_helper'

RSpec.describe 'Post Index', type: :system do
  describe 'post page' do
    before(:each) do
      @user = User.create(
        name: 'Jawad',
        bio: 'BCS',
        photo: 'https://drive.google.com/file/jawad.png'
      )
      @post = @user.posts.create(title: 'Post #', text: 'This is my first post')
      @comment = Comment.create(text: 'First comment', author_id: @user.id, post_id: @post.id)
      Like.create(author_id: @user.id, post_id: @post.id)

      visit(user_posts_path(@user.id))
    end

    it "shows user's profile picture" do
      expect(page).to have_css('img[src*="https://drive.google.com/file/jawad.png"]')
    end
    it 'shows the users username' do
      expect(page).to have_content('Jawad')
    end

    it 'shows number of posts by user' do
      expect(page).to have_content('Total number of posts are: 1')
    end

    it 'shows posts title' do
      expect(page).to have_content('Post #')
    end

    it 'shows some of the posts body' do
      expect(page).to have_content 'This is my first post'
    end

    it 'shows the first comment on a post' do
      expect(page).to have_content 'First comment'
    end

    it 'shows how many comments a post has.' do
      expect(page).to have_content('Comments: 1')
    end

    it 'shows how many likes a post has.' do
      expect(page).to have_content('Likes: 1')
    end

    it 'shows a section for pagination if there are more posts than fit on the view' do
      expect(page).to have_content('Pagination')
    end

    it 'when user clicks on a post, it redirects to that posts show page' do
      click_link 'Post #'
      expect(page).to have_current_path user_post_path(@post.author_id, @post)
    end
  end
end
