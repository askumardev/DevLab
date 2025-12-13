import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "name", "output" ]

  connect() {
    // By default show nothing
    this.outputTarget.textContent = ""
  }

  greet() {
    const name = this.nameTarget.value.trim();
    if (name.length === 0) {
      this.outputTarget.textContent = "Hello, World!";
      
    } else {
      this.outputTarget.textContent = `Hello, ${name}!`;
    }
  }
}