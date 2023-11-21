# frozen_string_literal: false

require 'spec_helper'

describe ArticlesController, type: :controller do
  fixtures :articles, :impressions, :posts, :widgets

  render_views

  it 'makes the impressionable_hash available' do
    get :index
    expect(response.body).to include('false')
  end

  it 'logs an impression with a message' do
    get 'index'

    latest_impression = Article.first.impressions.last

    expect(Impression.all.size).to eq 12

    expect(latest_impression.message).to eq 'this is a test article impression'
    expect(latest_impression.controller_name).to eq 'articles'
    expect(latest_impression.action_name).to eq 'index'
  end

  it 'logs an impression without a message' do
    get :show, params: { id: 1 }

    latest_impression = Article.first.impressions.last

    expect(Impression.all.size).to eq 12

    expect(latest_impression.message).to eq nil
    expect(latest_impression.controller_name).to eq 'articles'
    expect(latest_impression.action_name).to eq 'show'
  end

  it 'logs the user_id if user is authenticated (@current_user before_action method)' do
    session[:user_id] = 123
    get :show, params: { id: 1 }

    expect(Article.first.impressions.last.user_id).to eq 123
  end

  it 'does not log the user_id if user is authenticated' do
    get :show, params: { id: 1 }

    expect(Article.first.impressions.last.user_id).to eq nil
  end

  it 'logs the request_hash, ip_address, referrer and session_hash' do
    get :show, params: { id: 1 }

    impression = Impression.last

    expect(impression.request_hash.size).to eq 64
    expect(impression.ip_address).to eq '0.0.0.0'
    expect(impression.session_hash.size).to eq 32
    expect(impression.referrer).to eq nil
  end

  # Capybara has change the way it works
  # We need to pass :type options in order to make include helper methods
  # see https://github.com/jnicklas/capybara#using-capybara-with-rspec
  it 'logs the referrer when you click a link', type: :feature do
    default_url_options[:host] = "test.host"

    visit article_url(Article.first)
    click_link 'Same Page'
    expect(Impression.last.referrer).to eq 'http://test.host/articles/1'
  end

  it 'logs request with params (checked = true)' do
    get :show, params: { id: 1, checked: true }

    impression = Impression.last

    expect(impression.params).to eq({ 'checked' => "true" })
    expect(impression.request_hash.size).to eq 64
    expect(impression.ip_address).to eq '0.0.0.0'
    expect(impression.session_hash.size).to eq 32
    expect(impression.referrer).to eq nil
  end

  it 'logs request with params: {}' do
    get 'index'

    impression = Impression.last

    expect(impression.params).to eq({})
    expect(impression.request_hash.size).to eq 64
    expect(impression.ip_address).to eq '0.0.0.0'
    expect(impression.session_hash.size).to eq 32
    expect(impression.referrer).to eq nil
  end

  describe 'when filtering params' do
    before do
      @_filtered_params = Rails.application.config.filter_parameters
      Rails.application.config.filter_parameters = [:password]
    end

    after do
      Rails.application.config.filter_parameters = @_filtered_params
    end

    it 'values should not be recorded' do
      get 'index', params: { password: 'best-password-ever' }
      expect(Impression.last.params).to eq('password' => '[FILTERED]')
    end
  end
end
