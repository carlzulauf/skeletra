class Skeletra
  class Server < Sinatra::Base
    register Sinatra::AssetPipeline

    helpers Sinatra::Jsonp, Skeletra::WorkHelpers

    get '/' do
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
      haml :index
    end
  end
end
