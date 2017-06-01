class ShorterController < ApplicationController

  def index

  end

  def shorter
    url = shorter_params[:url]
    redis = Redis.new
    id = redis.incr("urls._id").to_s(36)
    hashUrl = Digest::MD5.hexdigest(url)
    key = "urls:#{hash}:#{id}"
    unless redis.keys("urls:#{hashUrl}:*").first
      redis.set(key, url)
    end
    @key = redis.keys("urls:*:#{id}").first
    @url = redis.get(key) if key

  end

  def shorter_params
    params.require(:shorter).permit(:url)
  end

end
