require_relative '../rails_helper'

RSpec.describe Like, type: :model do
  let(:user) { User.new(name: 'Jawad', photo: 'https://drive.google.com/file/d/1OgXPAMMaFb1GIC6nHrjR07qUTbMESZsC/view?usp=sharing', bio: 'BCS', posts_counter: 0) }
  let(:post) do
    Post.new(title: 'Best Ruby on Rails Practices', text: 'A grate article regarding Ruby on Rails',
             author: user, comments_counter: 0, likes_counter: 0)
  end
  subject { Like.new(author: user, post:) }

  before { subject.save }

  it 'is valid when all attributes are present and correct' do
    expect(subject).to be_valid
  end

  it 'is not valid when author is missing' do
    subject.author = nil
    expect(subject).to_not be_valid
  end

  it 'is not valid when associated post is missing' do
    subject.post = nil
    expect(subject).to_not be_valid
  end

  it 'increments the likes_counter of the associated post by 1 after saving' do
    expect { subject.save }.to change { post.reload.likes_counter }.by(1)
  end
end
