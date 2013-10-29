require 'minitest_helper'
require 'impressionist/minion/methods.rb'

class Dummy
  include Impressionist::Minion::Methods

  # Helper methods, test ^-O vim
  attr_writer :name, :options, :actions

  # Make private methods public
  # to test them
  public( :controller, :get_constant,
          :add_impressionable_method,
          :generate_hash, :options,
          :reset_parameters! )
end

# Mock classes
PostsController   = Class.new
Posts             = Class.new
Cache             = Class.new
Different         = Class.new
DifferentCache    = Class.new
Stuart            = Class.new
StuartController  = Class.new

module Impressionist

  ImpressionsCache = Class.new

  describe Minion::Methods do
      parallelize_me!

      let(:m)     { Dummy.new }
      let(:posts) { PostsController }

      it "must safe_constantize a class" do
        m.get_constant("PostsController").
          must_equal PostsController
      end

      it "must get a controller class" do
        m.name = :posts
        m.controller.must_equal PostsController
      end

      it "must add impressionable method to a given entity" do
        m.name    = :posts
        m.add_impressionable_method

        posts.must_respond_to :impressionable
      end

      it "must add after_filter" do
        ::HummersController = Class.new
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
                        column_name: :mine })

        m.generate_hash.must_equal m.options
      end

      it "must have unique false as  default" do
        m.generate_hash[:unique].must_equal false
      end

      it "must set a different class" do
        m.options = { class_name: Different }
        m.generate_hash[:class_name].must_equal Different
      end

      it "must have a default cache_class" do
        m.generate_hash[:cache_class].
          must_equal Impressionist::ImpressionsCache
      end

      it "must set a different cache_class" do
        m.options = { cache_class: DifferentCache }
        m.generate_hash[:cache_class].must_equal DifferentCache
      end

      it "must set unique" do
        m.options = { unique: true }
        m.generate_hash[:unique].must_equal :ip_address
      end

      it "must have counter_cache turned off as default" do
        m.generate_hash[:counter_cache].must_equal false
      end

      it "must set counter_cache" do
        m.options = { counter_cache: true }
        m.generate_hash[:counter_cache].must_equal true
      end

      it "must set a different column name" do
        m.options = { column_name: 'different' }
        m.generate_hash[:column_name].must_equal 'different'
      end

      it "must set a different column_name passing a symbol" do
        m.options = { column_name: :different }
        m.generate_hash[:column_name].must_equal :different
      end

      describe "Adding a minion to a given entity" do

        let(:creator) { Dummy.new }
        let(:steven)  { StuartController }

        before { creator.add(:stuart, :index, :edit) }

        it "must be able to add a minion" do
          creator.must_respond_to :add
        end

        it "must have created a minion" do
          steven.must_respond_to :impressionable
        end

        it "must have a name" do
          steven.impressionable[:name].must_equal :stuart
        end

        it "must have some actions" do
          steven.impressionable[:actions].must_equal [:index, :edit]
        end

        it "must have class_name the same as its name" do
          steven.impressionable[:class_name].must_equal Stuart
        end

        it "must include Instrumentation" do
          steven.must_include Minion::Instrumentation
        end

        it "must set_impressionist_instrumentation" do
          ::TomsController = Class.new
          Dummy.new.add(:toms, :index)

          ::TomsController.stub(:set_impressionist_instrumentation, true) do
            ::TomsController.set_impressionist_instrumentation.
              must_be_true
          end

        end

      end

      describe "Reseting parameters" do
        let(:rat) { Dummy.new }

        it "must be able to reset parameters" do
          rat.must_respond_to :reset_parameters!
        end

        it "must reset_parameters" do
          rat.name    = :test
          rat.options = { options: :here }
          rat.actions = [:index, :show]

          rat.reset_parameters!

          rat.name.must_equal ""
          rat.options.must_equal Hash.new
          rat.actions.must_equal []
        end

        it "must reset parameters after minion is created" do
          rat.add(:posts, :index, :show, { options: :here })
          rat.name.must_equal ""
          rat.actions.must_equal []
          rat.options.must_equal Hash.new
        end
      end

  end
end
