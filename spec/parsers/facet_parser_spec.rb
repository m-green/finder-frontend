require 'spec_helper'

describe FacetParser do
  context "with a select facet hash" do
    let(:facet_hash) { {
      "type" => "select",
      "name" => "Case type",
      "key" => "case_type",
      "value" => "market-investigations",
      "allowed_values" => [
        { "label" => "Airport price control reviews", "value" => "airport-price-control-reviews" },
        { "label" => "Market investigations",         "value" => "market-investigations" },
        { "label" => "Remittals",                     "value" => "remittals" }
      ],
      "include_blank" => "All case types"
    } }
    subject { FacetParser.parse(facet_hash) }

    specify { subject.should be_a SelectFacet }
    specify { subject.name.should == "Case type" }
    specify { subject.key.should == "case_type" }
    specify { subject.value.should == "market-investigations" }
    specify { subject.include_blank.should == "All case types" }

    it "should build a list of allowed values" do
      subject.allowed_values[0].label.should == "Airport price control reviews"
      subject.allowed_values[0].value.should == "airport-price-control-reviews"
      subject.allowed_values[2].label.should == "Remittals"
      subject.allowed_values[2].value.should == "remittals"
    end
  end
end