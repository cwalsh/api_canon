require 'spec_helper'
describe ApiCanon::DocumentedAction do

  let(:document) {ApiCanon::DocumentedAction.new :index}
  let(:description) {'ID is the unique identifier of the object'}
  subject { document }
  its(:action_name) { should == :index }
  it "Should document the 'format' param by default" do
    expect(document.params[:format]).to be_a ApiCanon::DocumentedParam
    expect(document.params[:format].example_values). to eq [:json, :xml]
    expect(document.params[:format].default).to eq :json
  end
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
