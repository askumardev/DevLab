import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["state", "output"]

  loadDistricts() {
    const state = this.stateTarget.value

    if (!state) {
      this.outputTarget.value = ""
      return
    }

    fetch(`/locations?state=${encodeURIComponent(state)}`, {
      headers: { "Accept": "application/json" }
    })
      .then(response => response.json())
      .then(locations => {
        this.outputTarget.value = locations.join("\n")
      })
      .catch(error => console.error(error))
  }
}
