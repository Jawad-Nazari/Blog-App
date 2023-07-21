require 'rails_helper'

RSpec.describe Post, type: :model do
  subject do
    @user = User.create(name: 'Jawad', photo: 'https://drive.google.com/file/d/1OgXPAMMaFb1GIC6nHrjR07qUTbMESZsC/view?usp=sharing',
                        bio: 'BCS', posts_counter: 10)
    @post = Post.create(title: 'Ruby', text: 'I love your post',
                        comments_counter: 10, likes_counter: 10, author: @user)
  end

  before { subject.save }

  it 'created successful' do
    expect(subject).to be_valid
  end

  it 'title can not be blank' do
    subject.title = nil
    expect(subject).to_not be_valid
  end

  it 'title should not be too short' do
    subject.title = 'a'
    expect(subject).to_not be_valid
  end

  it 'title should not be too long' do
    subject.title = 'a' * 260
    expect(subject).to_not be_valid
  end

  it 'title should be b/w 3 and 250 words' do
    subject.title = 'a' * 6
    expect(subject).to be_valid
  end

  it 'title should not be empty' do
    subject.title = ' '
    expect(subject).to_not be_valid
  end

  it 'title should have valid value' do
    expect(subject.title).to eql 'Ruby'
  end

  it 'text should be present' do
    subject.text = nil
    expect(subject).to_not be_valid
  end

  it 'text should have a valid value' do
    expect(subject.text).to eql 'I love your post'
  end

  it 'comments_counter must be integer' do
    subject.comments_counter = 15
    expect(subject).to be_valid
  end

  it 'comments_counter should have valid value' do
    subject.comments_counter = 10.05
    expect(subject).to_not be_valid
  end

  it 'comments_counter must not be equal to zero' do
    subject.comments_counter = -1
    expect(subject).to_not be_valid
  end

  it 'likes_counter must be integer' do
    subject.likes_counter = 11
    expect(subject).to be_valid
  end

  it 'likes_counter should have valid value' do
    subject.likes_counter = 10.07
    expect(subject).to_not be_valid
  end

  it 'likes_counter must not be equal to zero' do
    subject.likes_counter = -1
    expect(subject).to_not be_valid
  end

  it 'should return 5 recent comments' do
    expect(subject.recent_comments).to eq(subject.comments.order(created_at: :desc).limit(5))
  end
end
