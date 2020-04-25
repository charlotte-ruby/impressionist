# frozen_string_literal: true

require 'spec_helper'
require 'impressionist/rails_toggle'

describe Impressionist::RailsToggle do
  let(:toggle) { described_class.new }

  context 'when using rails < 4' do
    it 'will be included' do
      stub_const('::Rails::VERSION::MAJOR', 3)

      expect(toggle).to be_should_include
    end

    it 'will not be included when strong parameters is defined' do
      stub_const('::Rails::VERSION::MAJOR', 3)
      stub_const('StrongParameters', Module.new)

      expect(toggle).not_to be_should_include
    end
  end

  context 'when using rails >= 4' do
    it 'will not be included' do
      stub_const('::Rails::VERSION::MAJOR', 4)

      expect(toggle).not_to be_should_include
    end
  end
end
