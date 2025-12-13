import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML
    const unique = new Date().getTime()
    const escaped = content.replace(/new_document/g, unique)
    this.containerTarget.insertAdjacentHTML('beforeend', escaped)
  }

  remove(event) {
    event.preventDefault()
    const el = event.currentTarget.closest('.nested-doc') || event.currentTarget.closest('.existing-doc')
    if (!el) return

    // If it's an existing doc row, mark removal by setting the hidden input value
    const removeInput = el.querySelector('input[name="article[remove_document_ids][]"]')
    const existingIdInput = el.querySelector('input[name="article[existing_document_ids][]"]')
    if (removeInput && existingIdInput) {
      removeInput.value = existingIdInput.value
      el.style.display = 'none'
      return
    }

    // else just remove newly added node
    el.remove()
  }
}
