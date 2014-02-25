require 'spec_helper'
require 'impressionist/minion'

describe "Adding impressions ( minions ) to Controllers" do

  # Rationale for adding minions to controllers
  Impressionist::Minion::MinionCreator.banana_potato do
    add(:books, :destroy)
    add(:comments, :index)
    add(:stuarts, :index, :show, :edit, :mine, class_name: Steven)
    add(:hooks, hook: :around)
    add(:others, :mine, :their, :__all__, hook: :around)
  end

  it "must add a minion to books controller" do
    BooksController.impressionable[:actions].should eq [ :destroy ]
  end

  it "must add a minion to comments controller " do
    CommentsController.impressionable[:actions].should eq [ :index ]
  end

  it "must add a minion to stuarts controller" do
    StuartsController.impressionable[:class_name].should eq Steven
  end

  it "adds minion with all actions and a different hook" do
    HooksController.impressionable[:hook].should eq :around
  end

  it "adds minion with all actions plus other actions using flag :__all__" do
    OthersController.impressionable[:actions].size.should eq 9
  end

end
