class Skeletra
  class Config
    include Singleton

    # Additional application level configuration attributes can be added here
    #
    #     attr_accessor :paths, :patterns, :secret, :shuffle
    #
    attr_reader :root, :logger

    def initialize
      # setup defaults
      @logger = Logger.new(STDOUT)
    end

    def root=(path)
      @root = path
      @root.send(:extend, Root)
    end

    # Embues the root directory string with a join method
    #
    #     File.join(Skeletra.root, "assets")
    #
    # Becomes:
    #
    #     Skeletra.root.join("assets")
    #
    module Root
      def join(*args)
        File.join(self, *args)
      end
    end
  end
end
