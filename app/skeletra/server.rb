class Skeletra
  class Server < Sinatra::Base
    register Sinatra::AssetPipeline

    helpers Sinatra::Jsonp, Skeletra::WorkHelpers

    get '/' do
      @queued = Skeletra.work.queue.size
      @pooled = Skeletra.work.pool.size
      haml :index
    end

    get '/tick' do
      in_background do
        tock = SecureRandom.hex(8)
        30.times do
          Skeletra.logger.info("Tock! #{tock}")
          sleep 1
        end
      end
      redirect back
    end
  end
end
