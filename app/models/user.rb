class User < ApplicationRecord
  def self.request(token, sublink)
    headers = {Authorization: "bearer #{token}", "User-Agent": "apicurious by aelschauer"}
    HTTParty.get("https://oauth.reddit.com/#{sublink}", headers: headers)
  end

  def self.from_reddit(data, token)
    user = User.find_or_create_by(uid: data["name"], provider: 'reddit')
    user.update(token: token)
    user
  end
end
