require 'spec_helper'
describe ApiCanon::Swagger::ResourceListing do

  let(:data) {
    {
      :controller => mock(
        :description => 'description'
      )
    }
  }
  subject { ApiCanon::Swagger::ResourceListing }


  it 'should render the swagger resource listing' do
    subject.any_instance.stub :api_canon_base_url => 'root_url'
    subject.any_instance.stub :swagger_path => 'swagger_path'

    JSON.parse(subject.new(data).to_json).should eql({
      "apiVersion" => "master",
      "basePath" => 'root_url',
      "swaggerVersion" => 1.1,
      "apis" => [{"path"=>"swagger_path", "description"=>"description"}]
    })
  end

end

