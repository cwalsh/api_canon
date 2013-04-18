module ApiCanon
  class Document < Struct.new(:controller_path, :controller_name, :action_name)
    attr_reader :params, :response_codes, :description
    def initialize(controller_path, controller_name, action_name)
      super
      @params={}
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
