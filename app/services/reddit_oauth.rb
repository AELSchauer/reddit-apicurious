class RedditOauth

  def initialize(params)
    @code          = params[:code]
    @state         = params[:state]
    @client_id     = ENV['client_id']
    @client_secret = ENV['client_secret']
    @redirect_uri  = ENV['redirect_uri']
  end

  def token
    response = HTTParty.post("https://www.reddit.com/api/v1/access_token",
      :body => {
        :state => @state,
        :redirect_uri => @redirect_uri,
        :code => @code,
        :grant_type => 'authorization_code',
      },
      :basic_auth=> {
        username: @client_id,
        password: @client_secret
      }
    )
    @token = JSON.parse(response.body)["access_token"]
  end

  def data
    headers = {Authorization: "bearer #{@token}", "User-Agent": "apicurious by aelschauer"}
    HTTParty.get("https://oauth.reddit.com/api/v1/me", headers: headers)
  end
end