require 'spec_helper'
describe ApiCanon::Swagger::ApiDeclaration do

  let(:data) {
    documented_actions = ApiCanon::DocumentedAction.new('action_name', 'controller_name')
    documented_actions.describe 'description'
    documented_actions.response_code '404', 'reason'
    documented_actions.param 'name', :description => 'description', :type => 'string', :values => (1..10)
    mock :documented_actions => [ documented_actions ]
  }
  subject { ApiCanon::Swagger::ApiDeclaration }


  it 'should render the swagger api declaration' do
    subject.any_instance.stub :root_url => 'root_url'
    subject.any_instance.stub :swagger_path => 'swagger_path'
    ApiCanon::Swagger::ApiDeclaration::Api.any_instance.stub :url_for => 'url_for'

    JSON.parse(subject.new(data).to_json).should eql({
      "apiVersion" => "master",
      "basePath" => 'root_url',
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
                  "allowableValues"=>{"max"=>10, "min"=>1, "valueType"=>"RANGE"},
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
    })
  end

end
