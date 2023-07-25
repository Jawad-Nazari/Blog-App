require 'rails_helper'

RSpec.describe User, type: :request do
  describe 'users controller' do
    it 'should render the users index' do
      get users_path
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('users/index')
      expect(response.body).to include('This is index.html page to show all users')
    end

    it 'should render the user show' do
      get '/users/:id'
      expect(response).to have_http_status(:ok)
      expect(response).to render_template('users/show')
      expect(response.body).to include('This is show page for a particular user')
    end
  end
end