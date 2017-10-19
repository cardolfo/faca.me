class ShorterController < ApplicationController

  def index

  end

  def shorter
    @url = Url.new
    @url.initialize(:url_path => shorter_params[:url])
    puts @url.path
    if @url.valid?
      hashUrl = Digest::MD5.hexdigest(url)
      redis = Redis.new
      unless redis.keys("urls:#{hashUrl}:*").first
        id = redis.incr("urls._id").to_s(36)
        key = "urls:#{hashUrl}:#{id}"
        redis.set(key, url)
      else
        key = redis.keys("urls:#{hashUrl}:*").first
      end
      arrayKey = key.split(':')
      id = arrayKey[2]
      @shortUrl = "http://faca.me/#{id}"
    else
      @error_message = t('app.messages.not_valid_url')
    end

  end

  def redirect
    id = params[:id]
    redis = Redis.new
    key = redis.keys("urls:*:#{id}").first
    url = redis.get(key)
    puts id
    if id == "shorter"
      redirect_to "/"
    else
      redirect_to url
    end
  end

  def shorter_params
    params.require(:shorter).permit(:path)
  end

  private

  def valid_url?(uri)
      uri = URI.parse(uri)
    rescue URI::InvalidURIError
      false
  end

end
