module ApiCanon
  class ApiCanonController < ActionController::Base
    def test
      response = {:methods => matching_methods, :params => sanitized(params[:doco])}
      #TODO: Put routes in here, too.
      matching_methods.each do |m|
        response[:curl] ||= {}
        response[:urls] ||= {}
        if m == :get
          response[:curl][m] = as_curl(api_request_url)
          response[:urls][m] = api_request_url
        else
          response[:curl][m] = as_curl(api_request_url_for_non_get_requests, m, non_url_parameters_for_request_generation)
          response[:urls][m] = api_request_url_for_non_get_requests
        end
      end
      render :json => response
    end

  private

    def routes
      Rails.version.starts_with?('2') ? ActionController::Routing::Routes.routes : Rails.application.routes.routes
    end

    def matching_routes
      routes.select do |r|
        r.requirements[:controller] == requested_controller_path.to_s &&
          r.requirements[:action] == api_document.action_name.to_s
      end
    end

    def as_curl(url, method=:get, params={})
      case method
      when :get
        %{curl "#{url}"}
      when :post
        %{curl "#{url}" "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" --data "#{params.to_query}"}
      when :put
        %{curl "#{url}" "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -X PUT --data "#{params.to_query}"}
      when :delete
        %{curl "#{url}" "Content-Type: application/x-www-form-urlencoded; charset=UTF-8" -X DELETE --data "#{params.to_query}"}
      else
        "PATCH, HEAD, OPTIONS, TRACE, CONNECT are not implemented"
      end
    end

    def matching_methods
      #TODO: ApiDocument should define what methods it accepts, and fall back to route generation
      if Rails.version.starts_with?('2')
        matching_routes.map {|r| r.conditions[:method]}.uniq
      else
        matching_routes.map {|r| %w(GET PUT POST DELETE).select {|m| r.verb =~ m}}.flatten.uniq.map(&:downcase).map(&:to_sym)
      end
    end

    def api_document
      doco = ApiCanon::DocumentationStore.fetch(requested_controller_path)
      doco.documented_actions.detect {|da| da.action_name.to_s == params[:doco][:action_name] }
    end

    def requested_controller_path
      params[:doco][:controller_path]
    end

    def parameters_for_request_generation
      sanitized(params[:doco]).merge({:controller => "/#{requested_controller_path}", :action => api_document.action_name})
    end

    def non_url_parameters_for_request_generation
      parameters_for_request_generation.reject {|k,v| url_param_keys.include?(k)}
    end

    def url_param_keys
      if Rails.version.starts_with?('2')
        matching_routes.inject(Set.new()) {|set,r| set += r.significant_keys.map(&:to_s) }
      else
        matching_routes.inject(Set.new()) {|set,r| set += r.segment_keys.map(&:to_s) }
      end
    end

    def url_parameters_for_request_generation
      parameters_for_request_generation.slice *url_param_keys
    end

    def api_request_url_for_non_get_requests
      unless Rails.version.starts_with?('2')
        self.class.send(:include, Rails.application.routes.url_helpers)
      end
      url_for url_parameters_for_request_generation
    end

    def api_request_url
      unless Rails.version.starts_with?('2')
        self.class.send(:include, Rails.application.routes.url_helpers)
      end
      url_for parameters_for_request_generation
    end

    def sanitized(doco_params)
      sanitized = doco_params.dup
      sanitized.delete_if {|k,v| %w(controller controller_path action controller_name action_name).include?(k.to_s) }
      sanitized.each {|k,v| v.reject!(&:blank?) if v.is_a? Array}
      sanitized.delete_if {|k,v| v.blank? }
      sanitized
    end
  end
end
