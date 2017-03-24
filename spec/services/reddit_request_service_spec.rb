require 'rails_helper'

describe RedditRequestService do
  attr_reader :request

  before(:each) do
    @request = RedditRequestService.new(ENV['dummy_token'])
  end

  describe '#user_info' do
    it 'finds all the basic info for a user' do
      VCR.use_cassette("services/user_info") do
        user = @request.user_info("aelschauer")

        expect(user["link_karma"]).to eq(1)
        expect(user["comment_karma"]).to eq(0)
        expect(user["name"]).to eq("aelschauer")
        expect(user["id"]).to eq("16azbf")
      end
    end
  end

  describe '#user_trophies' do
    it 'finds all the trophies for a user' do
      VCR.use_cassette("services/user_trophies") do
        user_trophies = @request.user_trophies("aelschauer")

        trophy_img = "https://s3.amazonaws.com/redditstatic/award/verified_email-40.png"
        expect(user_trophies["Verified Email"]).to eq(trophy_img)
      end
    end
  end

  describe '#user_subreddit_subscriptions' do
    it 'finds a list of all the users subreddits subscriptions' do
      VCR.use_cassette("services/user_subreddit_subscriptions") do
        user_subscriptions = @request.user_subreddit_subscriptions

        subscriptions = ["AMA", "APICurious", "aww", "redditdev", "Showerthoughts"]
        user_subscriptions.each_with_index do |user_subscription, i|
          expect(user_subscription["data"]["display_name"]).to eq(subscriptions[i])
        end
      end
    end
  end

  describe '#subreddit_info' do
    it 'finds the basic info for a subreddit' do
      VCR.use_cassette("services/subreddit_info") do
        subreddit_info = @request.subreddit_info("APICurious")

        expect(subreddit_info["display_name"]).to eq("APICurious")
        expect(subreddit_info["url"]).to eq("/r/APICurious/")
        expect(subreddit_info["subscribers"]).to eq(6)
        expect(subreddit_info["id"]).to eq("3gwrr")
      end
    end
  end

  describe '#subreddit_rules' do
    it 'finds the list of rules for a subreddit' do
      VCR.use_cassette("services/subreddit_rules") do
        subreddit_rules = @request.subreddit_rules("aww")

        rules = ["1. No \"sad\" content", "2. No captioned Pictures",
          "3. No asking for upvotes", "4. No harassment",
          "5. Posts must link to sites on our approved list",
          "6. No NSFW content", "7. No asking for donations or adoptions",
          "8. No bots", "9. No lying about ownership", "10. No social media"
        ]

        subreddit_rules.each_with_index do |subreddit_rule, i|
          expect(subreddit_rule["short_name"]).to eq(rules[i])
        end
      end
    end
  end

  describe '#subreddit_moderators' do
    it 'finds a list of moderators for a subreddit' do
      VCR.use_cassette("services/subreddit_moderators") do
        moderators = @request.subreddit_moderators("APICurious")

        expect(moderators[0]["name"]).to eq("demonlampshade")
      end
    end
  end

  describe '#subreddit_posts' do
    it 'finds the posts for a subreddit of a specified type (e.g. hot, top)' do
      VCR.use_cassette("services/subreddit_posts") do
        subreddit_posts = @request.subreddit_posts("APICurious", "hot")

        posts = [
          { "title" => "Obama's Elf", "author" => "aelschauer"},
          { "title" => "Where it all started....", "author" => "aelschauer" },
          { "title" => "Where to find whether a transit service like the mha of new york, ttc of toronto or the stm of montreal have api relating to the buying or recharging of the cards?", "author" => "purav1" },
          { "title" => "Testing to see upvotes appear in karma api endpoint", "author" => "api_curious_test" },
          { "title" => "APIs ??? How to they work?", "author" => "api_curious_test" },
          { "title" => "Bone Zone", "author" => "apicurious_tester" },
        ]
        subreddit_posts.each_with_index do |subreddit_post, i|
          expect(subreddit_post["data"]["title"]).to eq(posts[i]["title"])
          expect(subreddit_post["data"]["author"]).to eq(posts[i]["author"])
        end
      end
    end
  end

  describe '#post_info' do
    it 'finds the info for a post' do
      VCR.use_cassette("services/post_info") do
        post_info = @request.post_info("APICurious", "576eqn")

        post = {
          "title" => "Bone Zone",
          "url" => "http://www.cnn.com/2016/10/10/politics/debate-ken-bone-staring-man-trnd/",
          "author" => "apicurious_tester",
          "num_comments" => 1
        }

        expect(post_info["title"]).to eq(post["title"])
        expect(post_info["url"]).to eq(post["url"])
        expect(post_info["author"]).to eq(post["author"])
        expect(post_info["num_comments"]).to eq(post["num_comments"])
      end
    end
  end

  describe '#post_comments' do
    it 'finds the comments for a post' do
      VCR.use_cassette("services/post_comments") do
        post_comments = @request.post_comments("APICurious", "576eqn")

        expect(post_comments.count).to eq(1)
        expect(post_comments[0]["data"]["body"]).to eq("Get in the Zone, the Bone Zone!")
        expect(post_comments[0]["data"]["id"]).to eq("d8pbnmm")
        expect(post_comments[0]["data"]["author"]).to eq("api_curious_test")
        expect(post_comments[0]["data"]["replies"]).to eq("")
        expect(post_comments[0]["data"]["depth"]).to eq(0)
      end
    end
  end
end