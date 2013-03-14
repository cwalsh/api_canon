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

  class DocumentedParam
    attr_accessor :name, :values, :type, :default, :default, :description, :example_values
    attr_writer :multiple
    def multiple?
      !!@multiple
    end
    def initialize(name, opts={})
      @name = name
      opts.each {|k,v| self.send("#{k}=", v) }
    end
    def form_values
      values.presence || example_values.presence
    end
    def to_field(f)
      if type == :array
        f.select name, form_values, {:selected => default, :include_blank => true}, {:multiple => multiple?}
      elsif type == :boolean
        f.select name, [true,false], {:selected => default, :include_blank => true}
      else
        f.text_field name, :value => default
      end
    end
    def example_values_field(f)
      if example_values.is_a?(Array)
        if type != :array
          f.select :example_value, example_values, :selected => default, :include_blank => true
        end
      else
        example_values.presence || values.presence || ""
      end
    end
  end
end
