class WelcomeController < ApplicationController
  def index
    redis = Redis.new(url: ENV['REDIS_URL'])

    begin
      @redis_connection = redis.ping == 'PONG'
    rescue => exception
      @redis_connection = false
    end

    @master_key_env = ENV['RAILS_MASTER_KEY'].present?
    @master_key_file = master_key_file
    @ssl_on = request.ssl?

    @db = false

    begin
    ActiveRecord::Base.establish_connection # Establishes connection
    ActiveRecord::Base.connection # Calls connection object
    rescue
      @db = false
    end

    @db = ActiveRecord::Base.connected?

    @all_done = @redis_connection && @ssl_on && @master_key_file && @db

    respond_to do |format|
      format.html
      format.json {
        render json: {
          redis_connection: @redis_connection,
          master_key_env: @master_key_env,
          master_key_file: @master_key_file,
          ssl_on: @ssl_on
        }
      }
    end
  end

  private

  def master_key_file
    path = File.join(Rails.root, "config", "master.key.example")
    return File.file?(path)
  end
end