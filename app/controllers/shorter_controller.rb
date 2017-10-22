class ShorterController < ApplicationController

  def index

  end

  def shorter  
    url = shorter_params[:url]
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

end
