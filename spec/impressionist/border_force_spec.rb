require 'spec_helper'
require 'impressionist/border_force'

describe Impressionist::BorderForce do
  let!(:fake_model) { FakeModel.new }
  let!(:ip_address) { { ip_address: "127.0.0.1" } }
  let!(:payload) { [ "inst_name", Time.now, Time.now, :unique_id, { action: "/test", format: "html", class_name: fake_model } ] }
  let!(:border_force) { Impressionist::BorderForce.new( payload ) }

  describe "Constantise model" do

    context "String" do
      it "returns constant" do
        bf = Impressionist::BorderForce.new( [ { class_name: "FakeModel" } ] )
        bf.model.should eq FakeModel
      end
    end

    context "Non string" do
      it "returns object" do
        bf = Impressionist::BorderForce.new( [ { class_name: FakeModel } ] )
        bf.model.should eq FakeModel
      end
    end
  end

  describe "Unique impression" do

    context "No unique filters passed in" do
      it "does not do anything" do
        Impressionist::BorderForce.new([ { unique: [], class_name: fake_model }.merge(ip_address) ]).unique?
      end
    end


    context "Does not exist" do
      it "uses unique symbol to check impression existence" do
        fake_model.should_receive(:impression_exist?).with(ip_address)
        Impressionist::BorderForce.new([ { unique: [ :ip_address ], class_name: fake_model }.merge(ip_address) ]).unique?
      end

      it "uses multiple unique symbols to check impression existence" do
        unique_id                     = { unique_id: "323232322" }
        ip_address_and_request_hash   = ip_address.merge({ request_hash: unique_id[:unique_id] })

        fake_model.should_receive(:impression_exist?).with(ip_address_and_request_hash)

        params = [ { unique: [ :ip_address, :request_hash ], class_name: fake_model }.merge(ip_address).merge(unique_id) ]

        Impressionist::BorderForce.new(params).unique?
      end
    end

    context "Exists" do
      it "has an impression with ip_address" do
        fake_model.should_receive(:impression_exist?).with(ip_address).and_return(false)
        bf = Impressionist::BorderForce.new([ { unique: [ :ip_address ], class_name: fake_model }.merge(ip_address) ])
        bf.unique?.should be_true
      end
    end
  end

  context "Validating uniqueness of impressions" do
    it "builds a new hash containing values of unique options" do
      ip_address = { ip_address: "127.0.0.1" }
      bf = Impressionist::BorderForce.new([ { unique: [ :ip_address ], class_name: fake_model }.merge(ip_address) ])
      bf.get_unique_hash.should eq ip_address
    end

    it "builds a new hash containing multiple values of unique options" do
      values = { ip_address: "127.0.0.1", unique: [ :ip_address, :request_hash ], class_name: fake_model, unique_id:"3232323232kjkdjkds" }
      bf = Impressionist::BorderForce.new([ values ])
      bf.get_unique_hash[:ip_address].should eq "127.0.0.1"
      bf.get_unique_hash[:request_hash].should eq values[:unique_id]
    end

    it "builds a new hash containing value of unique options with nil value if unique does not exist" do
      bf = Impressionist::BorderForce.new([ { unique: [ :nope ] } ])
      bf.get_unique_hash[:nope].should be_nil
    end
  end

  describe "Saving impressions" do

    context "Valid user agent" do
      it "saves an impression with no unique filters" do
        user_agent = { user_agent: :valid }
        params = user_agent.merge(ip_address)
        fake_model.stub(:impression_exist?).and_return(false)
        fake_model.should_receive(:save_impression).with(params)

        payload = ["inst_name", Time.now, Time.now, :unique_id, { unique: [], class_name: fake_model }.merge(params) ]

        bf = Impressionist::BorderForce.new( payload, FakeUserAgentChecker )
        bf.call
      end

      it "saves an impression with ip_address as unique filter" do
        user_agent = { user_agent: :valid }
        params = user_agent.merge(ip_address)
        fake_model.stub(:impression_exist?).and_return(false)
        fake_model.should_receive(:save_impression).with(params)

        payload = ["inst_name", Time.now, Time.now, :unique_id, { unique: [ :ip_address ], class_name: fake_model }.merge(params) ]

        bf = Impressionist::BorderForce.new(payload, FakeUserAgentChecker)
        bf.call
      end

      context "impression is not unique" do
        it "does not save an impression" do
          fake_model.should_not_receive(:save_impression)
          fake_model.should_receive(:impression_exist?).and_return(true)

          user_agent = { user_agent: :valid }
          params = user_agent.merge(ip_address)
          payload = ["inst_name", Time.now, Time.now, :unique_id, { unique: [ :ip_address ], class_name: fake_model }.merge(params) ]

          bf = Impressionist::BorderForce.new(payload, FakeUserAgentChecker)
          bf.call
        end
      end

      it "saves an impression with all required params" do
        params = {
          user_id: 1, controller_name: "TestsController", action_name: "index", view_name: "index.html.erb",
          request_hash: "32323", ip_address: "127.0.0.1", message: "My msg", referrer: "Referrer", format: "format",
          user_agent: :valid, impressionable_type: "Test", impressionable_id: 1, extra: "comes here :)"
        }

        fake_model.stub(:impression_exist?).and_return(false)
        fake_model.should_receive(:save_impression).with(params)
        payload = ["inst_name", Time.now, Time.now, :unique_id, { unique: [ :ip_address ], class_name: fake_model }.merge(params) ]

        bf = Impressionist::BorderForce.new(payload, FakeUserAgentChecker)
        bf.call
      end

    end
    context "Not valid user agent" do
      it "does not save an impression" do
        fake_model.should_not_receive(:save_impression)

        user_agent = { user_agent: :not_valid }
        params = user_agent.merge(ip_address)
        payload = ["inst_name", Time.now, Time.now, :unique_id, { unique: [ :ip_address ], class_name: fake_model }.merge(params) ]

        bf = Impressionist::BorderForce.new(payload, FakeUserAgentChecker)
        bf.call
      end
    end

  end
end
