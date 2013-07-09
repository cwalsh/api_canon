module ApiCanon
  module Swagger
    class ApiDeclaration < ApiCanon::Swagger::Base

      def apis
        object.documented_actions.collect { |action| Api.new(action) }
      end

      class Api < ActiveModel::Serializer
        self.root = false
        attributes :path
        attributes :description
        attributes :operations

        # TODO FIXME THIS WILL BREAK STUFF!!!!!!
        # should be EG: "path": "/pet/{petId}.{format}"
        def path
          "#{url_for(
            :controller => "/#{object.controller_name}",
            :action => object.action_name,
            :only_path => true
          )}.{format}"
        end

        def operations
          [ Operation.new(object) ]
        end


        class Operation < ActiveModel::Serializer
          self.root = false

          attributes :http_method => :httpMethod,
            :error_responses => :errorResponses
            #:response_class => :responseClass
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

          # def response_class
          #   object.controller_name.singularize.titlecase
          # end

          def parameters
            object.params.collect do |name, param|
              # Reject format because its not a real param :)
              Parameter.new param unless name == :format
            end.compact
          end


          class Parameter < ActiveModel::Serializer
            self.root = false
            attributes :param_type => :paramType,
              :type => :dataType,
              :allowable_values => :allowableValues,
              :allow_multiple => :allowMultiple

            attributes :name, :description, :required

            def param_type
              # TODO: Tighten this up.
              if object.name == 'id'
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

          end

        end
      end

    end
  end
end