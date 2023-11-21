# frozen_string_literal: false

require 'spec_helper'
require 'impressionist/setup_association'
require 'impressionist/rails_toggle'

describe Impressionist::SetupAssociation do
  let(:mock) { double }
  let(:setup_association) { described_class.new(mock) }

  it 'will include when togglable' do
    allow(mock).to receive(:attr_accessible).and_return(true)
    allow(setup_association).to receive(:toggle).and_return(true)

    expect(setup_association).to be_include_attr_acc
  end

  it 'will not include if it is not togglable' do
    allow(setup_association).to receive(:toggle).and_return(false)
    expect(setup_association).not_to be_include_attr_acc
  end

  context 'when using rails >= 5' do
    it 'sets belongs_to' do
      stub_const('::Rails::VERSION::MAJOR', 5)

      expect(mock).to receive(:belongs_to).twice.with(
        :impressionable, { polymorphic: true, optional: true }
      ).and_return(true)

      expect(setup_association.define_belongs_to).to be_truthy
      expect(setup_association.set).to be_falsy
    end
  end

  context 'when using rails < 5' do
    it 'sets belongs_to' do
      stub_const('::Rails::VERSION::MAJOR', 4)

      expect(mock).to receive(:belongs_to).twice.with(
        :impressionable, { polymorphic: true }
      ).and_return(true)

      expect(setup_association.define_belongs_to).to be_truthy
      expect(setup_association.set).to be_falsy
    end
  end
end
