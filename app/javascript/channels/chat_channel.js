// import consumer from "channels/consumer"

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
    // This runs whenever a message is broadcasted
    const chatBox = document.getElementById("chat-box")
    const messageElement = document.createElement("p")
    messageElement.textContent = data.message
    chatBox.appendChild(messageElement)
  },

  sendMessage(message) {
    this.perform("send_message", { message: message })
  }
})

// Expose function to window so we can call it from input
window.sendChatMessage = (message) => {
  chatChannel.sendMessage(message)
}
