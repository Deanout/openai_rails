class PagesController < ApplicationController
  before_action :set_api_key, only: [:ai_request]
  require 'securerandom'
  def home
    @uuid = SecureRandom.uuid
  end

  def ai_request
    AiRequestJob.perform_later(ai_request_params, @api_key)
  end

  private

  def ai_request_params
    params.require(:ai_request).permit(:prompt, :ai_model, :uuid)
  end

  def set_api_key
    @api_key = Rails.application.credentials.openai[:api_key]
  end
end
