import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML
    const unique = new Date().getTime()
    const escaped = content.replace(/new_section/g, unique)
    this.containerTarget.insertAdjacentHTML('beforeend', escaped)
  }

  remove(event) {
    event.preventDefault()
    const el = event.currentTarget.closest('.nested-fields')
    if (!el) return

    const destroyField = el.querySelector('input[name*="[_destroy]"]')
    if (destroyField) {
      // mark for destruction and hide
      destroyField.value = '1'
      el.style.display = 'none'
    } else {
      // just remove newly added fields
      el.remove()
    }
  }
}
