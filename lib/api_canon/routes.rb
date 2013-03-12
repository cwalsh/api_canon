module ApiCanon::Routes

  def self.draw(map, options={})
    route_opts = {:controller => 'api_canon/api_canon', :action => 'test'}.merge options
    map.api_canon_test 'api_canon/test', route_opts
  end

end
