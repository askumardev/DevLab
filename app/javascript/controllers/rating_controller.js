import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "star", "value"]

  connect() {
    this.currentScore = parseFloat(this.inputTarget.value) || 0
    this.updateStars(this.currentScore)
    this.updateDisplay(this.currentScore)
  }

  setRating(event) {
    event.preventDefault()
    const score = this.ratingFromEvent(event)
    this.currentScore = score
    this.inputTarget.value = score.toFixed(1)
    this.updateStars(score)
    this.updateDisplay(score)
  }

  preview(event) {
    const score = this.ratingFromEvent(event)
    this.updateStars(score)
    this.updateDisplay(score)
  }

  clearPreview() {
    this.updateStars(this.currentScore)
    this.updateDisplay(this.currentScore)
  }

  ratingFromEvent(event) {
    const starValue = Number(event.currentTarget.dataset.ratingValue)
    const rect = event.currentTarget.getBoundingClientRect()
    const position = event.clientX - rect.left
    const half = position < rect.width / 2 ? 0.5 : 1
    return Number((starValue - (half === 0.5 ? 0.5 : 0)).toFixed(1))
  }

  updateStars(score) {
    this.starTargets.forEach((element) => {
      const starValue = Number(element.dataset.ratingValue)
      element.classList.toggle("full", score >= starValue)
      element.classList.toggle("half", score >= starValue - 0.5 && score < starValue)
      element.classList.toggle("empty", score < starValue - 0.5)
    })
  }

  updateDisplay(score) {
    if (this.hasValueTarget) {
      this.valueTarget.textContent = score > 0 ? score.toFixed(1) : "0.0"
    }
  }
}
