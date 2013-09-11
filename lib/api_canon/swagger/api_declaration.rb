module ApiCanon
  module Swagger
    class ApiDeclaration < ApiCanon::Swagger::Base

      attributes :models

      def apis
        object.documented_actions.collect { |action| Api.new(action) }
      end

      def models
        object.documented_models
      end

      class Api < ActiveModel::Serializer
        self.root = false
        attributes :path
        attributes :description
        attributes :operations

        def path
          url = URI.unescape url_for(url_params)

          # This is required because we dont know if the params are
          # path params or query params, this way we dont care.
          url.split('?').first
        end

        def url_params
          url_params = {
            :controller => object.controller_path,
            :action => object.action_name,
            :only_path => true
          }

          object.params.keys.each do |name|
            url_params[name] = "{#{name}}"
          end

          url_params
        end

        def operations
          [ Operation.new(object) ]
        end


        class Operation < ActiveModel::Serializer
          self.root = false

          attributes :http_method => :httpMethod,
            :error_responses => :errorResponses,
            :response_model_name => :responseClass
          attributes :nickname, :parameters, :summary

          def nickname
            [
              Rails.application.class.parent_name,
              object.controller_name,
              object.action_name,
              http_method
            ].join('-').downcase
          end

          def summary
            object.description
          end

          def error_responses
            object.response_codes.collect do |code, reason|
              { :code => code, :reason => reason }
            end
          end

          def parameters
            object.params.collect do |name, param|
              # Reject format because its not a real param :)
              Parameter.new param unless name == :format
            end.compact
          end


          class Parameter < ActiveModel::Serializer
            self.root = false
            attributes :param_type => :paramType,
              :data_type => :dataType,
              :default => :defaultValue,
              :allowable_values => :allowableValues,
              :allow_multiple => :allowMultiple

            attributes :name, :description, :required

            def param_type
              if object.param_type.present?
                object.param_type
              elsif object.name.to_s == 'id'
                "path"
              elsif %(POST PUT).include?(object.http_method)
                "form"
              else
                "query"
              end
            end

            def required
              !!object.required
            end

            def allowable_values
              if object.values.class == Range
                {
                  :max => object.values.max,
                  :min => object.values.min,
                  :valueType => "RANGE"
                }
              elsif object.values.class == Array
                {
                  :values => object.values,
                  :valueType => "LIST"
                }
              end
            end

            def allow_multiple
              object.multiple?
            end

            def data_type
              object.type
            end

          end

        end
      end

    end
  end
end
