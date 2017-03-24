require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#from_reddit' do
    it 'creates a user by username' do
      user = User.from_reddit({"name" => "example1"}, "abc123")

      new_user = User.find(user.id)

      expect(new_user.uid).to eq("example1")
      expect(new_user.token).to eq("abc123")
      expect(new_user.provider).to eq("reddit")
    end

    it 'finds a user by username' do
      user1 = User.from_reddit({"name" => "example1"}, "abc123")
      user2 = User.from_reddit({"name" => "example1"}, "abc123")

      expect(user1.id).to eq(user2.id)
    end

    it 'updates a users token' do
      user1 = User.from_reddit({"name" => "example1"}, "abc123")
      user2 = User.from_reddit({"name" => "example1"}, "xyz890")

      expect(user1.id).to eq(user2.id)
      expect(user1.uid).to eq(user2.uid)
      expect(User.find(user1.id).token).to eq("xyz890")
      expect(User.find(user1.id).token).to_not eq("abc123")
    end
  end

  describe '#reddit_api' do
    it 'returns an instance of the RedditRequestService' do
      user = User.from_reddit({"name" => "example1"}, "abc123")
      request = user.reddit_api

      expect(request.class).to eq(RedditRequestService)
    end
  end
end
