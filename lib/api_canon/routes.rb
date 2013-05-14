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
    end
  end
end
