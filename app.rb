require "rack/utils"

module Scegratoo
  class App < Rack::File
    def initialize(root = 'public/index.html', headers={}, default_mime = 'text/plain')
      super(root, headers, default_mime)
    end

    def serving env
      @path = @root
      super env
    end

    def call env
      env["PATH_INFO"] = ''
      super env
    end
  end
end
