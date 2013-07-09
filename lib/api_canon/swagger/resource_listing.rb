module ApiCanon
  module Swagger
    class ResourceListing < ApiCanon::Swagger::Base

      def apis
        object.collect do |endpoint, data|
          {
            :path => swagger_path(endpoint),
            :description => data.description
          }
        end
      end

    end
  end
end