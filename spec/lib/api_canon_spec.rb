require 'spec_helper'

describe ApiCanon do
  let(:fake_controller) do
    class FakeController < ActionController::Base
      include ApiCanon
    end
  end
  describe 'including' do
    context :class_methods do
      subject {fake_controller}
      its(:methods) { should include(:document_method)}
    end
    context :instance_methods do
      subject {fake_controller.new}
      its(:methods) { should include(:api_canon_docs)}
      its(:methods) { should include(:index)}
    end
  end

  describe "document_method" do
    let(:api_document) { mock :api_document }
    it "creates and stores a new ApiCanon::Document" do
      ApiCanon::Document.should_receive(:new).with('fake', 'fake', :index).and_return(api_document)
      ApiCanon::DocumentationStore.instance.should_receive(:store).with(api_document)
      fake_controller.send(:document_method, :index, &(Proc.new {}))
    end
  end

end
