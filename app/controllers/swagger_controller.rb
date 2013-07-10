module ApiCanon
  class SwaggerController < ActionController::Base

    # TODO: Not sure about this
    def set_headers
      if request.headers["HTTP_ORIGIN"]
        headers['Access-Control-Allow-Origin'] = request.headers["HTTP_ORIGIN"]
        headers['Access-Control-Expose-Headers'] = 'ETag'
        headers['Access-Control-Allow-Methods'] = 'GET, POST, PATCH, PUT, DELETE, OPTIONS, HEAD'
        headers['Access-Control-Allow-Headers'] = '*,x-requested-with,Content-Type,If-Modified-Since,If-None-Match,Auth-User-Token'
        headers['Access-Control-Max-Age'] = '86400'
        headers['Access-Control-Allow-Credentials'] = 'true'
      end
    end

    def index
      set_headers
      api_docs = ::ApiCanon::DocumentationStore.docos
      render json: api_docs, serializer: ApiCanon::Swagger::ResourceListing
    end

    def show
      set_headers
      api_doc = ::ApiCanon::DocumentationStore.fetch params[:id]
      if api_doc
        render json: api_doc, serializer: ApiCanon::Swagger::ApiDeclaration
      else
        head :not_found
      end
    end

  end
end