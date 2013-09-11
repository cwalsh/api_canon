module ApiCanon
  module Routes
    def self.draw(map, options={})
      route_opts = {:as => 'api_canon_test',
        :controller => 'api_canon/api_canon', :action => 'test', :via => [:post]
      }.merge options
      if Rails.version.starts_with?('2')
        map.api_canon_test 'api_canon/test', route_opts
      else
        map.match 'api_canon/test', route_opts
      end

      # TODO: make :path => 'swagger-doc' customisable
      map.resources :path => 'swagger-doc',
        :controller => 'api_canon/swagger',
        :only => [:index, :show],
        :constraints => { :id => /.+/ },
        :as => :api_canon_swagger_doc
    end
  end
end
