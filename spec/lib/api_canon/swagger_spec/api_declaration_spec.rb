require 'spec_helper'
describe ApiCanon::Swagger::ApiDeclaration do

  let(:documented_action) {
    documented_action = ApiCanon::DocumentedAction.new('action_name', 'controller_name')
    documented_action.describe 'description'
    documented_action.response_code '404', 'reason'
    documented_action.param 'name', :description => 'description', :type => 'string', :values => (1..10)
    documented_action
  }
  let(:data) {
    double :documented_actions => [ documented_action ], :version => 'master'
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
          "path" => "url_for.{format}",
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
                  "allowableValues" => {"max"=>10, "min"=>1, "valueType"=>"RANGE"},
                  "allowMultiple" => false,
                  "name" => "name",
                  "description" => 'description',
                  "required" => false
                }
              ],
              "summary" => 'description'
            }
          ]
        }
      ]
    }.to_json)
  end

  describe ApiCanon::Swagger::ApiDeclaration::Api do
    subject { ApiCanon::Swagger::ApiDeclaration::Api.new(documented_action) }

    describe '#url_params' do
      it 'should return params with placeholder values' do
        documented_action.param 'id', :type => 'string'
        subject.url_params['id'].should eql("{id}")
      end
    end
  end
end
