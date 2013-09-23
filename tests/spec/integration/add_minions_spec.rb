require 'minitest_helper'
require 'impressionist/minion'

BooksController     = Class.new
CommentsController  = Class.new
StuartsController   = Class.new
Steven              = Class.new

describe "Adding impressions ( minions ) to Controllers" do

  Impressionist::Minion::MinionCreator.banana_potato do
    add(:books, :destroy)
    add(:comments, :index)
    add(:stuarts, :index, :show, :edit, :mine, class_name: Steven)
  end

  it "must add a minion to books controller" do
    BooksController.must_respond_to :impressionable
  end

  it "must add a minion to comments controller " do
    CommentsController.must_respond_to :impressionable
  end

  it "must add a minion to stuarts controller" do
    StuartsController.must_respond_to :impressionable
    StuartsController.impressionable[:class_name].must_equal Steven
  end

end
