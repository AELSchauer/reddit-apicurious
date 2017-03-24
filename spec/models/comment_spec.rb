require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'returns attributed read only variables' do
    level_1 = { "id" => "aaa111", "depth" => 1, "body" => "Level 1", "author" => "Aardvark", "score" => 3, "replies" => "" }

    comment = Comment.new(level_1)

    expect(comment.author).to eq(level_1["author"])
    expect(comment.depth).to eq(level_1["depth"])
    expect(comment.id).to eq(level_1["id"])
    expect(comment.score ).to eq(level_1["score"])
  end

  it 'comments are nested' do
    level_3 = { "id" => "ccc333", "depth" => 3, "body" => "Level 3", "author" => "Cat", "score" => 1, "replies" => "" }
    level_2 = { "id" => "bbb222", "depth" => 2, "body" => "Level 2", "author" => "Bird", "score" => 2, "replies" => { "data" => { "children" => [{ "kind" => "t1", "data" => level_3}] } } }
    level_1 = { "id" => "aaa111", "depth" => 1, "body" => "Level 1", "author" => "Aardvark", "score" => 3, "replies" => { "data" => { "children" => [{ "kind" => "t1", "data" => level_2}] } } }

    top_comment = Comment.create_tree([{"data" => level_1}]).first

    expect(top_comment.body).to eq(level_1["body"])
    expect(top_comment.replies.first.class).to eq(Comment)
    expect(top_comment.replies.first.body).to eq(level_2["body"])
    expect(top_comment.replies.first.replies.first.class).to eq(Comment)
    expect(top_comment.replies.first.replies.first.body).to eq(level_3["body"])
  end

  describe '#has_replies?' do
    it 'returns true if it has a reply' do
      level_2 = { "id" => "bbb222", "depth" => 2, "body" => "Level 2", "author" => "Bird", "score" => 2, "replies" => "" }
      level_1 = { "id" => "aaa111", "depth" => 1, "body" => "Level 1", "author" => "Aardvark", "score" => 3, "replies" => { "data" => { "children" => [{ "kind" => "t1", "data" => level_2}] } } }

      comment = Comment.new(level_1)

      expect(comment.has_replies?).to eq(true)
    end

    it 'returns false if it doesnt have a reply' do
      level_1 = { "id" => "aaa111", "depth" => 1, "body" => "Level 1", "author" => "Aardvark", "score" => 3, "replies" => "" }

      comment = Comment.new(level_1)

      expect(comment.has_replies?).to eq(false)
    end
  end

  describe '#children' do
    it 'returns the array of children hashes' do
      level_2 = { "id" => "bbb222", "depth" => 2, "body" => "Level 2", "author" => "Bird", "score" => 2, "replies" => "" }
      level_1 = { "id" => "aaa111", "depth" => 1, "body" => "Level 1", "author" => "Aardvark", "score" => 3, "replies" => { "data" => { "children" => [{ "kind" => "t1", "data" => level_2}] } } }

      comment = Comment.new(level_1)

      expect(comment.children).to eq([{"kind" => "t1", "data" => level_2}])
    end
  end

  describe '#children_visible?' do
    it 'returns true if the children are full comments' do
      level_2 = { "id" => "bbb222", "depth" => 2, "body" => "Level 2", "author" => "Bird", "score" => 2, "replies" => "" }
      level_1 = { "id" => "aaa111", "depth" => 1, "body" => "Level 1", "author" => "Aardvark", "score" => 3, "replies" => { "data" => { "children" => [{ "kind" => "t1", "data" => level_2}] } } }

      comment = Comment.new(level_1)

      expect(comment.children_visible?).to eq(true)
    end

    it 'returns false if the children are more comments' do
      level_2 = { "body" => "" }
      level_1 = { "id" => "aaa111", "depth" => 1, "body" => "Level 1", "author" => "Aardvark", "score" => 3, "replies" => { "data" => { "children" => [{ "kind" => "more", "data" => level_2}] } } }

      comment = Comment.new(level_1)

      expect(comment.children_visible?).to eq(false)
    end
  end

  describe '#body' do
    it 'returns the body if not nil' do
      level_1 = { "id" => "aaa111", "depth" => 1, "body" => "Level 1", "author" => "Aardvark", "score" => 3, "replies" => "" }

      comment = Comment.new(level_1)

      expect(comment.body).to eq(level_1["body"])
    end

    it 'returns an empty string if the body is nil' do
      level_1 = { "id" => "aaa111" }

      comment = Comment.new(level_1)

      expect(comment.body).to eq("")
    end
  end

  describe '#empty' do
    it 'always returns false' do
      comment = Comment.new({})

      expect(comment.empty?).to eq(false)
    end
  end
end

