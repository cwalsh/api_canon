require 'spec_helper'
describe ApiCanon::Swagger::ApiDeclaration do

  let(:documented_action) {
    documented_action = ApiCanon::DocumentedAction.new('action_name', 'controller_path', 'controller_name')
    documented_action.describe 'description'
    documented_action.response_class 'Thing'
    documented_action.response_code '404', 'reason'
    documented_action.param 'name', :description => 'description', :type => 'string', :default => 'test', :values => (1..10)
    documented_action
  }
  let(:documented_model) {
    documented_model = ApiCanon::DocumentedModel.new('Thing')
    documented_model.property :foo, :type => :string, :required => true
    documented_model
  }
  let(:documented_models) {
    { 'Thing' => documented_model }
  }
  let(:data) {
    double :documented_actions => [ documented_action ], :documented_models => documented_models, :version => 'master'
  }
  subject { described_class.new(data) }

  it 'should render the swagger api declaration' do
    described_class.any_instance.stub :api_canon_test_url => 'http://example.com/api_canon/test'
    described_class.any_instance.stub :api_canon_test_path => '/api_canon/test'
    described_class.any_instance.stub :swagger_path => 'swagger_path'
    ApiCanon::Swagger::ApiDeclaration::Api.any_instance.stub :url_for => 'url_for'

    subject.to_json.should be_json_eql({
      "apiVersion" => "master",
      "basePath" => 'http://example.com/',
      "swaggerVersion" => 1.1,
      "apis" => [
        {
          "path" => "url_for",
          "description" => 'description',
          "operations" => [
            {
              "httpMethod" => "GET",
              "errorResponses" => [{"code" => "404", "reason" => "reason"}],
              "nickname" => "combustion-controller_name-action_name-get",
              "parameters" => [
                {
                  "paramType" => "query",
                  "dataType" => "string",
                  "defaultValue" => "test",
                  "allowableValues" => {"max" => 10, "min" => 1, "valueType" => "RANGE"},
                  "allowMultiple" => false,
                  "name" => "name",
                  "description" => 'description',
                  "required" => false
                }
              ],
              "responseClass" => 'Thing',
              "summary" => 'description'
            }
          ]
        }
      ],
      "models" => {
        "Thing" => {
          "id" => "Thing",
          "properties" => {
            "foo" => {
              "type" => "string",
              "required" => true
            }
          }
        }
      }
    }.to_json)
  end

  describe '::Api' do
    subject { ApiCanon::Swagger::ApiDeclaration::Api.new(documented_action) }

    describe '#url_params' do
      it 'should return params with placeholder values' do
        documented_action.param 'id', :type => 'string'
        subject.url_params['id'].should eql("{id}")
      end
    end

    describe '::Parameter' do
      subject { ApiCanon::Swagger::ApiDeclaration::Api::Operation::Parameter.new(param) }

      describe '#param_type' do

        describe 'with param_type path' do
          let(:param) { double :param_type => 'path' }

          it 'should return path' do
            subject.param_type.should eql('path')
          end
        end

        describe 'with name id' do
          let(:param) { double :param_type => nil, :name => 'id' }

          it 'should return path' do
            subject.param_type.should eql('path')
          end
        end

        describe 'with POST http_method' do
          let(:param) { double :param_type => nil, :name => 'name', :http_method => 'POST' }

          it 'should return path' do
            subject.param_type.should eql('form')
          end
        end

        describe 'with GET http_method' do
          let(:param) { double :param_type => nil, :name => 'name', :http_method => 'GET' }

          it 'should return query' do
            subject.param_type.should eql('query')
          end
        end
      end
    end
  end
end
