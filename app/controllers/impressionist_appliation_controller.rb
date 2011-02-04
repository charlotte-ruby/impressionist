require 'digest/sha2'

class ApplicationController < ActionController::Base
  before_filter :impressionist_app_filter

  def self.impressionist(opts={})
    before_filter { |c| c.impressionist_subapp_filter opts[:actions] }
  end
    
  def impressionist(obj,message=nil)
    unless bypass
      if obj.respond_to?("impressionable?")
        obj.impressions.create(message: message,
                               request_hash: @impressionist_hash,
                               ip_address: request.remote_ip,
                               user_id: user_id)
      else
        raise "#{obj.class.to_s} is not impressionable!"
      end
    end
  end

  def impressionist_app_filter
    @impressionist_hash = Digest::SHA2.hexdigest(Time.now.to_f.to_s+rand(10000).to_s)
  end

  def impressionist_subapp_filter(actions=nil)
    unless bypass
      actions.collect!{|a|a.to_s} unless actions.blank?
      if actions.blank? or actions.include?(action_name)
        Impression.create(controller_name: controller_name,
                          action_name: action_name,
                          user_id: user_id,
                          request_hash: @request_hash,
                          request_hash: @impressionist_hash,
                          ip_address: request.remote_ip,
                          impressionable_type: controller_name.singularize.camelize,
                          impressionable_id: params[:id])
      end
    end
  end
    
  private
  def bypass
    Impressionist::Bots::WILD_CARDS.each do |wild_card|
      return true if request.user_agent.downcase.include? wild_card
    end
    Impressionist::Bots::LIST.include? request.user_agent
  end
    
  def user_id
    @current_user ? @current_user.id : nil
  end
end