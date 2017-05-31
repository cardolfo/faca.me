class ShorterController < ApplicationController

  def index

  end

  def shorter
    url = shorter_params[:url]
    redis = Redis.new
    sid = redis.incr("urls._id").to_s(36)
    @id = sid.to_s(36)
  end

  def shorter_params
    params.require(:shorter).permit(:url)
  end

end
