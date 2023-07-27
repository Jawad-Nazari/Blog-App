require 'rails_helper'

RSpec.describe Post, type: :request do
  describe 'post controller' do
    it 'should render the post index' do
      get '/users/3/posts'

      expect(response).to have_http_status(:ok)
      expect(response).to render_template('posts/index')
      expect(response.body).to include('This is to show all post')
    end

    it 'should render the post show' do
      get '/users/2/posts/5'

      expect(response).to have_http_status(:ok)
      expect(response).to render_template('posts/show')
      expect(response.body).to include('This is to show a particular post')
    end
  end
end
