import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

  static targets = ["joining", "exit", "output"]

  calculate() {

    const joiningDate = new Date(this.joiningTarget.value)
    const exitDate = new Date(this.exitTarget.value)

    if (!this.joiningTarget.value ||
        !this.exitTarget.value ||
        joiningDate > exitDate) {

      this.outputTarget.innerHTML =
        "Please enter valid dates"
      return
    }

    let start = new Date(joiningDate)
    let end = new Date(exitDate)

    let years = end.getFullYear() - start.getFullYear()
    let months = end.getMonth() - start.getMonth()
    let days = end.getDate() - start.getDate()

    if (days < 0) {
      months--
      const prevMonth =
        new Date(end.getFullYear(), end.getMonth(), 0)
      days += prevMonth.getDate()
    }

    if (months < 0) {
      years--
      months += 12
    }

    const totalMonths =
      (end.getFullYear() - start.getFullYear()) * 12 +
      (end.getMonth() - start.getMonth())

    this.outputTarget.innerHTML =
      `Total Months: ${totalMonths} months <br>
       Experience: ${years} Years ${months} Months ${days} Days`
  }
}
