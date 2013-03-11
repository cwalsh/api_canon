module ApiCanon

  def self.included(base)
    base.extend(ClassMethods)
    include_view_paths
  end

  # TODO: This should happen at load time, not at include time
  def self.include_view_paths
    view_path = File.join(File.dirname(__FILE__),'api_canon','app','views')
    ActionController::Base.append_view_path(view_path) unless ActionController::Base.view_paths.include? view_path
  end

  class Documentor < Struct.new(:controller_name, :action_name)
    attr_reader :params, :response_codes, :description
    def initialize(controller_name, action_name)
      super
      @params={}
      @response_codes={}
    end
    def param(param_name, options={})
      @params[param_name] = options
    end
    def response_code(code, options={})
      @response_codes[code] = options
    end
    def describe(desc)
      @description = desc
    end
  end

  # Replace this at the earliest possible opportunity
  # with something that stores stuff in Redis or something
  class DocumentationStore
    include Singleton
    def store cont_doco
      @docos ||= {}
      @docos[cont_doco[:controller_name]] ||= {}
      @docos[cont_doco[:controller_name]][cont_doco[:action_name]] = cont_doco
    end
    def docos
      @docos
    end
    def self.fetch controller_name
      self.instance.docos[controller_name]
    end
  end

  module ClassMethods
  protected
    def document_method(method_name,&block)
      @documentor = Documentor.new controller_name, method_name
      @documentor.instance_eval &block
      DocumentationStore.instance.store @documentor
      alias_method :"old_#{method_name}", method_name
      define_method method_name do
        if params[:format] == 'html'
          respond_to do |format|
            format.html do
              @docs = DocumentationStore.fetch controller_name
              render 'api_canon/api_canon'
            end
          end
        else
          self.send("old_#{method_name}")
        end
      end
    end
  end


end
