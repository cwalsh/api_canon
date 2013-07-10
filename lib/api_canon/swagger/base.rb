module ApiCanon
  module Swagger
    class Base < ActiveModel::Serializer

      self.root = false
      attributes :api_version => :apiVersion
      attributes :swagger_version => :swaggerVersion
      attributes :base_path => :basePath
      attributes :apis

      def api_version
        object.try(:version) || object.collect { |key, val| val.version }.uniq.to_sentence
      end

      def swagger_version
        1.1
      end

      def base_path
        defined?(api_canon_base_url) ? api_canon_base_url : api_canon_test_url.sub(api_canon_test_path,'/')
      end

    end
  end
end
