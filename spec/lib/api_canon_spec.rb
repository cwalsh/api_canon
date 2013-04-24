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
    context "without a current controller doc" do
      it "creates and stores a new ApiCanon::Document and adds the documented action" do
        ApiCanon::Document.should_receive(:new).with('fake', 'fake').and_return(api_document)
        ApiCanon::DocumentationStore.instance.should_receive(:store).with(api_document)
        api_document.should_receive :add_action
        fake_controller.send(:document_method, :index, &(Proc.new {}))
      end
    end
    context "with a current controller doc" do
      before(:each) do
        fake_controller.send(:document_controller, &(Proc.new {}))
      end
      it "adds a documented action to the current controller doc" do
        expect {
          fake_controller.send(:document_method, :index, &(Proc.new {}))
        }.to change {
          ApiCanon::DocumentationStore.fetch('fake').documented_actions.count
        }.by(1)
      end
    end
  end

end
