require 'pry' rescue nil
require 'api_canon/routes'
require 'api_canon/version'
require 'api_canon/app'
require 'api_canon/document'
require 'api_canon/documentation_store'

module ApiCanon

  def self.included(base)
    base.extend(ClassMethods)
    include_view_paths
    create_index_method(base)
  end

  # TODO: This should happen at load time, not at include time
  def self.include_view_paths
    view_path = File.join(File.dirname(__FILE__),'api_canon','app','views')
    ActionController::Base.append_view_path(view_path) unless ActionController::Base.view_paths.include? view_path
  end

  def self.create_index_method(base)
    base.class_eval do
      require 'api_canon/app/helpers/api_canon_view_helper'
      helper ApiCanon::ApiCanonViewHelper
      alias_method :old_index, :index
      def index
        if params[:format] == 'html'
          @docs = DocumentationStore.fetch controller_name
          respond_to do |format|
            format.html { render 'api_canon/api_canon', :layout => 'layouts/api_canon' }
          end
        else
          old_index
        end
      end
    end
  end

  module ClassMethods
  protected
    def document_method(method_name,&block)
      @document = Document.new controller_path, controller_name, method_name
      @document.instance_eval &block
      DocumentationStore.instance.store @document
    end
  end


end
