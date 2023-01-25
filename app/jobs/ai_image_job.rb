class AiImageJob < ApplicationJob
  queue_as :default

  def perform(ai_request_params, api_key, resolution)
    # Do something later
    connection = Faraday.new(url: 'https://api.openai.com')

    response = connection.post do |req|
      req.url '/v1/images/generations'
      req.headers['Content-Type'] = 'application/json'
      req.headers['Authorization'] = "Bearer #{api_key}"
      req.body = {
        prompt: ai_request_params[:prompt],
        size: resolution,
        n: 1
      }.to_json
    end

    json_response = JSON.parse(response.body)
    generated_image = json_response['data'].first['url']
    # generated_image = 'https://picsum.photos/1024/1024'

    uuid = ai_request_params[:uuid]
    Turbo::StreamsChannel.broadcast_update_to("channel_#{uuid}",
                                              target: 'ai_output_image',
                                              partial: 'ai/output_image',
                                              locals: { generated_image: })
  end
end
