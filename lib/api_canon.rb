require 'rails'
require 'active_model'
require 'active_model/serializer'

module ApiCanon

  class Engine < ::Rails::Engine
    # isolate_namespace ApiCanon

    initializer "api_canon.initialization" do
      require 'api_canon/routes'
      require 'api_canon/version'
      require 'api_canon/app'
      require 'api_canon/document'
      require 'api_canon/documented_action'
      require 'api_canon/documented_param'
      require 'api_canon/documentation_store'
      require 'api_canon/swagger/base'
      require 'api_canon/swagger/api_declaration'
      require 'api_canon/swagger/resource_listing'
      require 'controllers/swagger_controller'
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      append_view_path File.join(File.dirname(__FILE__),'..','app','views')
      require 'helpers/api_canon/api_canon_view_helper'
      helper ApiCanon::ApiCanonViewHelper
    end
  end

  def api_canon_docs
    @api_doc = DocumentationStore.fetch controller_path
    respond_to do |format|
      format.html { render 'api_canon/api_canon', :layout => 'layouts/api_canon' }
    end
  end

  # When this module is included, your index method is overwritten with this one,
  # which renders the ApiCanon documentation if params[:format] is html, and defaults
  # to the existing method otherwise.
  def index
    if request.format.html?
      api_canon_docs
    else
      super
    end
  end

  module ClassMethods
    # document_controller is used to describe your controller as a whole (Your API endpoint)
    #
    # == Example:
    #   document_controller as: 'Awesome Things' do
    #     describe "Here you can see all the awesome things, and get more details about the awesome things you're interested in."
    #   end
    #
    # @param opts [Hash] Optional, current options are:
    #     'as' - An optional override for the controller name which defaults to controller_name.titleize
    # @param block [&block] Begins the controller documentation DSL
    # @see ApiCanon::Document#describe
    def document_controller(opts={}, &block)
      document = DocumentationStore.fetch controller_path
      document ||= Document.new controller_path, controller_name, opts
      document.instance_eval &block if block_given?
      DocumentationStore.store document
    end

    # document_method is used to describe the actions in your controller (your API actions)
    #
    # Example:
    #   document_method :index do
    #     describe "Gives you a list of awesome things!"
    #     param :foo, type: 'String', default: 'bar', example_values: Foo.limit(5).pluck(:name), description: 'foo is the type of awesome required'
    #     param :filter_level, type: 'Integer', default: 1, values: [1,2,3,4], description: 'filter_level can only be 1, 2, 3 or 4'
    #   end
    #
    # @param method_name [Symbol] The method to be documented
    # @param block [block] Begins the action documentation DSL
    # @see ApiCanon::DocumentedAction#describe
    # @see ApiCanon::DocumentedAction#param
    # @see ApiCanon::DocumentedAction#response_code
    def document_method(method_name,&block)
      document = DocumentationStore.fetch controller_path
      document ||= Document.new controller_path, controller_name
      documented_action = ApiCanon::DocumentedAction.new method_name, controller_name
      documented_action.instance_eval &block if block_given?
      document.add_action documented_action
      DocumentationStore.store document
    end
  end


end
