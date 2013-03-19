module ApiCanon
  class ApiCanonController < ApplicationController
    def test
      render :json => {:url => api_request_url}
    end

  private
    def api_request_url
      test_params = params[:doco]
      doco = ApiCanon::DocumentationStore.fetch(test_params[:controller_name])[test_params[:action_name].to_sym]
      url_for sanitised(test_params).merge({:controller => doco.controller_path, :action => doco.action_name})
    end

    def sanitised(test_params)
      sanitized = test_params.dup
      sanitized.delete_if {|k,v| %w(controller controller_path action controller_name action_name).include?(k.to_s) }
      sanitized.delete_if {|k,v| v.blank? }
      sanitized
    end
  end
end
