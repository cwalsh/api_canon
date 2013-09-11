module ApiCanon
  class DocumentedParam
    include ActiveModel::Serialization
    attr_accessor :name, :values, :type, :param_type, :default, :description, :example_values, :required, :description, :documented_action
    attr_writer :multiple
    delegate :http_method, :to => :documented_action
    include ActionView::Helpers
    def values_for_example
      example_values || values || ""
    end
    def multiple?
      !!@multiple
    end
    def initialize(name, documented_action, opts={})
      @name = name
      @documented_action = documented_action
      opts.each {|k,v| self.send("#{k}=", v) }
    end
    def form_values
      values.presence || example_values.presence
    end
    def to_field(f, doco_prefix)
      # TODO: This doco_prefix thing sucks. Get rid of it.
      if type == :array
        if form_values.nil?
          raise ArgumentError.new(':values or :example_values must be supplied for :array type params')
        end
        f.select name, form_values, {:selected => default, :include_blank => true}, {:multiple => multiple?, :class => 'input-block-level', :id => "#{doco_prefix}_#{name}"}
      elsif type == :boolean
        f.select name, [true,false], {:selected => default, :include_blank => true}, :class => 'input-block-level', :id => "#{doco_prefix}_#{name}"
      else
        f.text_field name, :value => default, :class => 'input-block-level', :id => "#{doco_prefix}_#{name}"
      end
    end
    def example_values_field(f, doco_prefix)
      if values_for_example.is_a?(Array)
        if type != :array
          select_tag :example_value, options_for_select([""] + values_for_example, default), :class => 'input-block-level',
            :onchange => "jQuery('##{doco_prefix}_#{name}').val(this.value)", :id => "#{doco_prefix}_#{name}_example"
        end
      else
        values_for_example
      end
    end
  end
end
