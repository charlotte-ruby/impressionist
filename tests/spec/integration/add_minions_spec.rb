require 'minitest_helper'
require 'impressionist/minion'

BooksController     = Class.new
CommentsController  = Class.new
StuartsController   = Class.new
Steven              = Class.new
HooksController     = Class.new
OthersController    = Class.new

describe "Adding impressions ( minions ) to Controllers" do

  parallelize_me!

  # Rationale for adding minions to controllers
  Impressionist::Minion::MinionCreator.banana_potato do
    add(:books, :destroy)
    add(:comments, :index)
    add(:stuarts, :index, :show, :edit, :mine, class_name: Steven)
    add(:hooks, hook: :around)
    add(:others, :mine, :their, :__all__, hook: :around)
  end

  it "must add a minion to books controller" do
    BooksController.must_respond_to :impressionable
    BooksController.impressionable[:actions].must_equal [ :destroy ]
  end

  it "must add a minion to comments controller " do
    CommentsController.must_respond_to :impressionable
    CommentsController.impressionable[:actions].must_equal [ :index ]
  end

  it "must add a minion to stuarts controller" do
    StuartsController.must_respond_to :impressionable
    StuartsController.impressionable[:class_name].must_equal Steven
  end

  it "adds minion with all actions and a different hook" do
    HooksController.impressionable[:actions].size.must_equal 7
    HooksController.impressionable[:hook].must_equal :around
  end

  it "adds minion with all actions plus other actions using flag :__all__" do
    OthersController.impressionable[:actions].size.must_equal 9
  end

end
