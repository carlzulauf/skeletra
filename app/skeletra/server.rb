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

    get '/ping' do
      pong = SecureRandom.hex(8)
      schedule.add every: 5 do
        Skeletra.logger.info("Pong! #{pong}")
      end
      redirect back
    end

    get '/schedule/clear' do
      schedule.clear
      redirect back
    end

    get '/work/clear' do
      work.queue.clear
      work.pool.each{|worker| worker.kill }
      work.pool.clear
      redirect back
    end
  end
end
