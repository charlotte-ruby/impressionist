require 'spec_helper'

module Impressionist

  ImpressionsCache = Class.new

  describe Minion::Methods do

      let(:m)     { Dummy.new.tap { |d| d.actions = [] } }
      let(:posts) { PostsController }

      it "must safe_constantize a class" do
        m.get_constant("PostsController").
          should eq PostsController
      end

      it "must get a controller class" do
        m.name = :posts
        m.controller.should eq PostsController
      end

      it "must add impressionable method to a given entity" do
        m.name    = :posts
        m.add_impressionable_method

        posts.should respond_to :impressionable
      end

      it "must add after_filter" do

        m.name = :hummers
        m.add_impressionable_method
      end

      it "must generate_hash" do
        m.name    = :posts
        m.actions = [:index]
        m.options = ({  name: :posts,
                        actions: [:index],
                        unique: :ip_address,
                        counter_cache: true,
                        class_name: Posts,
                        cache_class: Cache,
                        column_name: :mine,
                        hook: "after"
                        })

        m.generate_hash.should eq m.options
      end

      it "must have unique false as  default" do
        m.generate_hash[:unique].should eq false
      end

      it "must set a different class" do
        m.options = { class_name: Different }
        m.generate_hash[:class_name].should eq Different
      end

      it "must have a default cache_class" do
        m.generate_hash[:cache_class].
          should eq Impressionist::ImpressionsCache
      end

      it "must set a different cache_class" do
        m.options = { cache_class: DifferentCache }
        m.generate_hash[:cache_class].should eq DifferentCache
      end

      it "must set unique" do
        m.options = { unique: true }
        m.generate_hash[:unique].should eq :ip_address
      end

      it "must have counter_cache turned off as default" do
        m.generate_hash[:counter_cache].should eq false
      end

      it "must set counter_cache" do
        m.options = { counter_cache: true }
        m.generate_hash[:counter_cache].should eq true
      end

      it "must set a different column name" do
        m.options = { column_name: 'different' }
        m.generate_hash[:column_name].should eq 'different'
      end

      it "must set a different column_name" do
        m.options = { column_name: :different }
        m.generate_hash[:column_name].should eq :different
      end

      it "has a default hook" do
        m.generate_hash[:hook].should eq "before"
      end

      it "sets a different hook" do
        m.options = { hook: :after }
        m.generate_hash[:hook].should eq :after
      end

      it "adds minions to all actions when nil is passed" do
        m.generate_hash[:actions].should eq [ :index, :show, :edit, :new, :create, :update, :delete ]
      end

      it "adds minions to all actions plus other actions when :__all__ is present" do
        m.actions = [ :my_own_action, :__all__ ]
        m.generate_hash[:actions].size.should eq 8
      end

      describe "Adding a minion to a given entity" do

        let(:creator) { Dummy.new }
        let(:stuart)  { StuartController }

        before { creator.add(:stuart, :index, :edit) }

        it "must have a name" do
          stuart.impressionable[:name].should eq :stuart
        end

        it "must have some actions" do
          stuart.impressionable[:actions].should eq [:index, :edit]
        end

        it "must have class_name the same as its name" do
          stuart.impressionable[:class_name].should eq Stuart
        end

        it "must include Instrumentation" do
          stuart.should include Minion::Instrumentation
        end

        it "must set_impressionist_instrumentation" do
          ::TomsController = Class.new
          ::TomsController.should_receive(:set_impressionist_instrumentation)

          Dummy.new.add(:toms, :index)
        end

      end

      describe "Reseting parameters" do
        let(:rat) { Dummy.new }

        it "must reset_parameters" do
          rat.name    = :test
          rat.options = { options: :here }
          rat.actions = [:index, :show]

          rat.reset_parameters!

          rat.name.should eq ""
          rat.options.should eq Hash.new
          rat.actions.should eq []
        end

        it "must reset parameters after minion is created" do
          rat.add(:posts, :index, :show, { options: :here })
          rat.name.should eq ""
          rat.actions.should eq []
          rat.options.should eq Hash.new
        end
      end

  end
end
