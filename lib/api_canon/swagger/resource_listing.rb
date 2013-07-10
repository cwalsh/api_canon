module ApiCanon
  module Swagger
    class ResourceListing < ApiCanon::Swagger::Base

      def apis
        object.collect do |endpoint, data|
          {
            :path => api_canon_swagger_doc_path(endpoint),
            :description => data.description
          }
        end
      end

    end
  end
end