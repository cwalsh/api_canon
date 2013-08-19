require 'spec_helper'
describe ApiCanon::DocumentedParam do
  let(:example_values) { [:json, :xml] }
  let(:doc_opts) do
    {:type => 'string', :default => :json, :example_values => example_values}
  end
  let(:fake_form) { double :form }
  let(:doco_prefix) { 'foo' }
  let(:documented_param) {ApiCanon::DocumentedParam.new :format, self, doc_opts}
  subject { documented_param }
  its(:name) { should eq :format }
  its(:type) { should eq 'string' }
  its(:default) { should eq :json }
  its(:form_values) { should eq example_values }
  its(:multiple?) { should eq false }
  describe :to_field do
    context "string-type params" do
      it "Creates a text field" do
        fake_form.should_receive :text_field
        documented_param.to_field fake_form, doco_prefix
      end
    end
    context "array-type params" do
      before(:each) {documented_param.type = :array}
      it "Creates a select field" do
        fake_form.should_receive(:select).with :format, [:json, :xml], hash_including({:include_blank => true}), hash_including({:id => 'foo_format'})
        documented_param.to_field fake_form, doco_prefix
      end
    end
    context "boolean-type params" do
      before(:each) {documented_param.type = :boolean}
      it "Creates a select field with true and false values" do
        fake_form.should_receive(:select).with :format, [true, false], hash_including({:include_blank => true}), hash_including({:id => 'foo_format'})
        documented_param.to_field fake_form, doco_prefix
      end
    end
  end
  describe :example_values_field do
    context "array of example values" do
      it "Creates a select field" do
        documented_param.should_receive(:select_tag)
        documented_param.example_values_field fake_form, doco_prefix
      end
      it "does nothing with array-value fields" do
        documented_param.type = :array
        expect(documented_param.example_values_field(fake_form, doco_prefix)).to eq nil
      end
      it "returns the example values otherwise" do
        documented_param.example_values = 'foo'
        expect(documented_param.example_values_field(fake_form, doco_prefix)).to eq 'foo'
      end
    end
  end
end
