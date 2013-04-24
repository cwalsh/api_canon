require 'api_canon/routes'
require 'api_canon/version'
require 'api_canon/app'
require 'api_canon/document'
require 'api_canon/documented_action'
require 'api_canon/documented_param'
require 'api_canon/documentation_store'

module ApiCanon

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      append_view_path File.join(File.dirname(__FILE__),'api_canon','app','views')
      require 'api_canon/app/helpers/api_canon_view_helper'
      helper ApiCanon::ApiCanonViewHelper
    end
  end

  def api_canon_docs
    @api_doc = DocumentationStore.fetch controller_path
    respond_to do |format|
      format.html { render 'api_canon/api_canon', :layout => 'layouts/api_canon' }
    end
  end

  def index
    if params[:format].blank? || params[:format] == 'html'
      api_canon_docs
    else
      super
    end
  end

  module ClassMethods
  protected
    def document_controller(opts={}, &block)
      document = DocumentationStore.fetch controller_path
      document ||= Document.new controller_path, controller_name, opts
      document.instance_eval &block
      DocumentationStore.store document
    end
    def document_method(method_name,&block)
      document = DocumentationStore.fetch controller_path
      document ||= Document.new controller_path, controller_name
      documented_action = ApiCanon::DocumentedAction.new method_name
      documented_action.instance_eval &block
      document.add_action documented_action
      DocumentationStore.store document
    end
  end


end
