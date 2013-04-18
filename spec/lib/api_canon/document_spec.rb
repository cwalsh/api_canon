require 'spec_helper'
describe ApiCanon::Document do

  let(:document) {ApiCanon::Document.new 'path/fake', 'fake', :index}
  let(:description) {'ID is the unique identifier of the object'}
  subject { document }
  its(:controller_path) { should == 'path/fake' }
  its(:controller_name) { should == 'fake' }
  its(:action_name) { should == :index }
  describe :param do
    it "documents the named param" do
      document.param :id, :default => 1, :description => description, :type => :integer
      expect(document.params[:id]).to be_a ApiCanon::DocumentedParam
      expect(document.params[:id].default).to eq 1
      expect(document.params[:id].description).to eq description
    end
  end
  describe :response_code do
    it "describes the response codes the user can expect to see" do
      document.response_code 200
      pending "Need to create objects to deal with this similarly to DocumentedParam"
    end
  end
  describe :description do
    let(:description) {"This action lists a bunch of things"}
    it "describes what the controller action is for" do
      document.describe description
      expect(document.description).to eq description
    end
  end

end
