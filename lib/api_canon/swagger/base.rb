module ApiCanon
  module Swagger
    class Base < ActiveModel::Serializer

      self.root = false
      attributes :api_version => :apiVersion
      attributes :swagger_version => :swaggerVersion
      attributes :base_path => :basePath
      attributes :apis

      def api_version
        # TODO: this should not be hardcoded
        'master'
      end

      def swagger_version
        1.1
      end

      def base_path
        # TODO: Is there a better way?
        root_url
      end

    end
  end
end