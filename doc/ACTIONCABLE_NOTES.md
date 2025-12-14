# ActionCable in Rails 7 – Step by Step Guide

ActionCable is the Rails framework for **real-time communication** using WebSockets. It allows you to push updates from the server to the client instantly.

---

## 1️⃣ Add Dependencies

Rails 7 comes with ActionCable included. Ensure you have **Redis** if you plan to use it in production:

```ruby
# Gemfile
gem 'redis', '~> 4.0'
```

Run:

```bash
bundle install
```

---

## 2️⃣ Generate a Channel

```bash
rails generate channel Chat
```

This creates:

* `app/channels/chat_channel.rb` — Ruby class for server-side logic.
* `app/javascript/channels/chat_channel.js` — JS subscription for client-side.

---

## 3️⃣ Define Server-Side Logic

`app/channels/chat_channel.rb`:

```ruby
class ChatChannel < ApplicationCable::Channel
  def subscribed
    # Stream from a specific channel
    stream_from "chat_channel"
  end

  def unsubscribed
    # Clean up when the user disconnects
  end

  # Called from JS
  def send_message(data)
    message = data['message']
    ActionCable.server.broadcast("chat_channel", { message: message })
  end
end
```

Key points:

* `stream_from` subscribes the user to a broadcast stream.
* `send_message` receives data from the client and broadcasts to all subscribers.

---

## 4️⃣ Connect Client-Side JS

`app/javascript/channels/chat_channel.js`:

```javascript
import { createConsumer } from "@rails/actioncable"

const consumer = createConsumer()

const chatChannel = consumer.subscriptions.create("ChatChannel", {
  connected() {
    console.log("Connected to ChatChannel!")
  },

  disconnected() {
    console.log("Disconnected from ChatChannel.")
  },

  received(data) {
    const chatBox = document.getElementById("chat-box")
    const messageElement = document.createElement("p")
    messageElement.textContent = data.message
    chatBox.appendChild(messageElement)
  },

  sendMessage(message) {
    this.perform("send_message", { message: message })
  }
})

window.sendChatMessage = (message) => {
  chatChannel.sendMessage(message)
}
```

---

## 5️⃣ Create a View

Example: `app/views/chats/room.html.erb`:

```erb
<h1>Chat Room</h1>

<div id="chat-box" style="border: 1px solid #ccc; height: 300px; overflow-y: scroll; padding: 10px;">
</div>

<input type="text" id="chat-input" placeholder="Type your message..." />
<button onclick="sendMessage()">Send</button>

<script>
  function sendMessage() {
    const input = document.getElementById("chat-input")
    const message = input.value
    if(message.trim() === "") return
    window.sendChatMessage(message)
    input.value = ""
  }
</script>
```

---

## 6️⃣ Add Route

In `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  root "home#index"
  get "chat_room", to: "chats#room"
  mount ActionCable.server => '/cable'
end
```

---

## 7️⃣ Ensure JS is Loaded

In `app/javascript/application.js`:

```javascript
import "./channels/chat_channel"
```

---

## 8️⃣ Test It

1. Start Rails server:

```bash
bin/rails server
```

2. Open two browser tabs at:

```
http://localhost:3000/chat_room
```

3. Typing a message in one tab will appear **instantly** in the other.

---

## 9️⃣ Notes / Best Practices

* **Stream names** can be dynamic (e.g., `stream_from "chat_#{room_id}"`) for multiple rooms.
* **Use Redis** in production for scalability.
* Always **sanitize inputs** to prevent XSS.
* You can broadcast **hashes or JSON**, not just plain strings.
* `perform` method in JS calls server-side methods defined in the channel.

---

## 10️⃣ References

* [Rails Guides – Action Cable](https://guides.rubyonrails.org/action_cable_overview.html)
* [RailsCasts #406 – ActionCable](http://railscasts.com/episodes/406-action-cable)
