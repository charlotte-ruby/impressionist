# frozen_string_literal: true

require 'spec_helper'
require 'impressionist/rails_toggle'

describe Impressionist do
  describe Impressionist::RailsToggle do
    let(:toggle) { Impressionist::RailsToggle.new }

    context 'when using rails < 4' do
      it 'will be included' do
        stub_const('::Rails::VERSION::MAJOR', 3)

        expect(toggle.should_include?).to be_truthy
      end

      it 'will not be included when strong parameters is defined' do
        stub_const('::Rails::VERSION::MAJOR', 3)
        stub_const('StrongParameters', Module.new)

        expect(toggle.should_include?).to be_falsy
      end
    end

    context 'when using rails >= 4' do
      it 'will not be included' do
        stub_const('::Rails::VERSION::MAJOR', 4)

        expect(toggle.should_include?).to be_falsy
      end
    end
  end
end
