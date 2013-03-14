require 'pry'
require 'api_canon/routes'
require 'api_canon/version'
require 'api_canon/app'
require 'api_canon/document'
require 'api_canon/documentation_store'

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

  module ClassMethods
  protected
    def document_method(method_name,&block)
      @document = Document.new controller_path, controller_name, method_name
      @document.instance_eval &block
      DocumentationStore.instance.store @document
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
