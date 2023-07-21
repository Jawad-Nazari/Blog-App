require_relative '../rails_helper'

RSpec.describe User, type: :model do
  subject { User.new(name: 'Jawad', photo: 'https://drive.google.com/file/d/1OgXPAMMaFb1GIC6nHrjR07qUTbMESZsC/view?usp=sharing', bio: 'BCS') }

  before { subject.save }

  it 'user successfully created' do
    expect(subject).to be_valid
  end

  it 'name can not be blank' do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it 'name should not be too short' do
    subject.name = 'a'
    expect(subject).to_not be_valid
  end

  it 'name should not be too long' do
    subject.name = 'a' * 35
    expect(subject).to_not be_valid
  end

  it 'name should be b/w 3 and 30 words' do
    subject.name = 'a' * 6
    expect(subject).to be_valid
  end

  it 'name should have valid value' do
    expect(subject.name).to eql 'Jawad'
  end

  it 'photo should have valid value' do
    expect(subject.photo).to eql 'https://drive.google.com/file/d/1OgXPAMMaFb1GIC6nHrjR07qUTbMESZsC/view?usp=sharing'
  end

  it 'bio should have vaid value' do
    expect(subject.bio).to eql 'BCS'
  end

  it 'posts_counter must not be less than 1' do
    subject.posts_counter = -1
    expect(subject).to_not be_valid
  end

  it 'should have posts counter greater than or euqal to 0' do
    subject.posts_counter = 0
    expect(subject).to be_valid
  end

  it 'should return 3 recent posts' do
    expect(subject.recent_posts).to eq(subject.posts.order(created_at: :desc).limit(3))
  end
end
