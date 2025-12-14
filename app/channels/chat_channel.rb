class ChatChannel < ApplicationCable::Channel
  def subscribed
    # Stream from "chat_channel"
    stream_from "chat_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  # This method will be called from JS
  def send_message(data)
    message = data['message']
     ActionCable.server.broadcast("chat_channel", { message: message })
  end
end
