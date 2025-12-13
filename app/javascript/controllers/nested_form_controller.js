import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "template"]
  static values = { articleId: String }

  add(event) {
    event.preventDefault()
    const content = this.templateTarget.innerHTML
    const unique = new Date().getTime()
    const escaped = content.replace(/new_section/g, unique)
    this.containerTarget.insertAdjacentHTML('beforeend', escaped)
  }

  remove(event) {
    event.preventDefault()
    if (!confirm("Are you sure you want to delete this section?")) return

    const el = event.currentTarget.closest('.nested-fields')
    if (!el) return

    const idField = el.querySelector('input[name*="id"]')
    if (idField && idField.value) {
      // existing section, delete via AJAX
      const articleId = this.articleIdValue
      const sectionId = idField.value
      const url = `/articles/${articleId}/sections/${sectionId}`
      const token = document.querySelector('meta[name="csrf-token"]').content

      fetch(url, {
        method: 'DELETE',
        headers: {
          'X-CSRF-Token': token,
          'Content-Type': 'application/json'
        }
      }).then(response => {
        if (response.ok) {
          el.remove()
        }
      })
    } else {
      // new section, just remove
      el.remove()
    }
  }
}
