module ApiCanon
  class DocumentedAction
    include ActiveModel::Serialization
    attr_reader :params, :response_codes, :description, :action_name,
      :controller_name, :http_method
    def initialize(action_name, controller_name)
      @action_name = action_name
      @controller_name = controller_name
      @params={}
      # TODO: This should check routes to see if params[:format] is expected
      @params[:format] = DocumentedParam.new :format, self,
        :default => :json, :example_values => [:json, :xml], :type => :string,
        :description => "The requested format of the response."

      # This is based of the rails defaults.
      @http_method = case action_name.to_s
        when "create"  then "POST"
        when "update"  then "PUT"
        when "destroy" then "DELETE"
        else "GET"
      end

      @response_codes={}
    end
    # The param method describes and gives examples for the parameters your
    # API action can take.
    # @see ApiCanon::DocumentedParam
    # @see ApiCanon::ClassMethods#document_method
    # @param param_name [Symbol] The name of the parameter, i.e. the param_name
    # bit in params[param_name]
    # @param options [Hash] This is where you describe the given parameter.
    # Valid keys are:
    #
    # * default: The default value to fill in for this parameter
    # * example_values: Example values to show. Use when the input is unconstrained.
    # * values: Valid values to use. Use when the input is constrained.
    # * type: The expected type of the value(s) of this param, e.g. :string
    # * description: A friendly description of what this parameter does or is used for.
    # * multiple: Can this parameter be used multiple times? I.e. Array values.
    #
    # ##Examples:
    #
    # ```ruby
    # document_method :index do
    #   param :hierarchy_level, :values => 1..4, :type => :integer, :default => 1, :description => "Maximum depth to include child categories"
    #   param :category_codes, :type => :array, :multiple => true, :example_values => Category.online.enabled.super_categories.all(:limit => 5, :select => :code).map(&:code), :description => "Return only categories for the given category codes", :default => 'mens-fashion-accessories'
    # end
    # ```
    #
    def param(param_name, options={})
      @params[param_name] = DocumentedParam.new param_name, self, options
    end
    # The response_code method will be used as a DSL method in the
    # document_method block to describe what you mean when your action returns
    # the given response code.  It currently does nothing.
    # @see ApiCanon::ClassMethods#document_method
    # @param code [Integer] The response code to document, e.g. 200, 404 etc.
    # @param desc [String] Description of what the response code means in your
    #   case, e.g. a 422 might mean the user entered input that failed validation.
    # ##Examples:
    #
    # ```ruby
    # document_method :index do
    #   response_code 200, "Everything worked"
    #   response_code 404, "Either the requested product or category could not be found"
    # end
    # ```
    def response_code(code, desc="")
      @response_codes[code] = desc
    end
    # The describe method is used as a DSL method in the document_method block,
    # Use it to describe your API action.
    # @see ApiCanon::ClassMethods#document_method
    # @param desc [String] The text to appear at the top of the action block in
    # the generated API documentation page.
    #
    # ##Examples:
    #
    # ```ruby
    # document_method :index do
    #   describe "This action returns a filtered tree of categories based on the parameters given in the request."
    # end
    # ```
    #
    def describe(desc)
      @description = desc
    end
  end
end
