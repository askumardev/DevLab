import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
// app/javascript/stimulus/controllers/calendar_controller.js

export default class extends Controller {
  connect() {
    console.log("Calendar controller connected")
  }

  // 👉 Open modal for NEW appointment (empty fields)
  openModal(event) {
    console.log("openModal called", event)
    const date = event.currentTarget.dataset.date

    const modal = document.getElementById("modal")
    const modalTitle = document.getElementById("modal-title")
    const form = document.getElementById("appointment-form")
    const submitBtn = document.getElementById("appointment-submit")
    const deleteBtn = document.getElementById("delete-appointment-btn")

    modal.classList.remove("hidden")
    modalTitle.textContent = "Book Appointment"

    // Configure form for NEW appointment
    form.action = "/appointments"
    form.method = "post"
    submitBtn.value = "Save"

    // Clear all fields
    document.getElementById("appointment-id").value = ""
    document.getElementById("appointment-title").value = ""
    document.getElementById("appointment-start-time").value = date + "T09:00"
    document.getElementById("appointment-end-time").value = ""

    // Hide delete button for new appointments
    deleteBtn.style.display = "none"

    console.log("New appointment modal opened")
  }

  // 👉 Open modal for EDIT appointment (populate fields)
  openAppointmentModal(event) {
    event.stopPropagation()

    const data = event.currentTarget.dataset
    console.log("Opening appointment modal with data:", data)

    const modal = document.getElementById("modal")
    const modalTitle = document.getElementById("modal-title")
    const form = document.getElementById("appointment-form")
    const submitBtn = document.getElementById("appointment-submit")
    const deleteBtn = document.getElementById("delete-appointment-btn")

    if (!modal || !modalTitle || !form) {
      console.error("Modal elements not found")
      return
    }

    modal.classList.remove("hidden")
    modalTitle.textContent = "Edit Appointment"

    // Configure form for EDIT appointment
    form.action = `/appointments/${data.appointmentId}`
    form.method = "post" // Rails handles method override with _method
    submitBtn.value = "Update"

    // Use setTimeout to ensure DOM is ready
    setTimeout(() => {
      // Populate form fields
      document.getElementById("appointment-id").value = data.appointmentId || ""
      document.getElementById("appointment-title").value = data.appointmentTitle || ""
      document.getElementById("appointment-start-time").value = data.appointmentStart || ""
      document.getElementById("appointment-end-time").value = data.appointmentEnd || ""

      // Show delete button for existing appointments
      deleteBtn.style.display = "inline-block"
      deleteBtn.setAttribute("formaction", `/appointments/${data.appointmentId}`)

      console.log("Edit appointment modal populated")
    }, 10)
  }

  // 👉 Close modal (FIXED)
  closeModal(event) {
    const modal = document.getElementById("modal")

    // Close only if clicking backdrop OR close button
    if (!event || event.target === modal || event.target.closest(".close-btn")) {
      modal.classList.add("hidden")
    }
  }

  // Prevent bubbling
  stopPropagation(event) {
    event.stopPropagation()
  }
}