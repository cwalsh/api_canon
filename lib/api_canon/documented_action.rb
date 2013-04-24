module ApiCanon
  class DocumentedAction
    attr_reader :params, :response_codes, :description, :action_name
    def initialize(action_name)
      @action_name = action_name
      @params={}
      # TODO: This should check routes to see if params[:format] is expected
      @params[:format] = DocumentedParam.new :format,
        :default => :json, :example_values => [:json, :xml], :type => :string,
        :description => "The requested format of the response."
      @response_codes={}
    end
    def param(param_name, options={})
      @params[param_name] = DocumentedParam.new param_name, options
    end
    def response_code(code, options={})
      @response_codes[code] = options
    end
    def describe(desc)
      @description = desc
    end
  end
end
