import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["date", "time"]

  connect() {
    if (this.hasDateTarget) {
      this.loadSlots()
    }
  }

  loadSlots() {
    const selectedDate = this.dateTarget.value
    if (!selectedDate || !this.hasTimeTarget) return

    fetch(`/booking_slots?date=${encodeURIComponent(selectedDate)}`, {
      headers: { "Accept": "application/json" }
    })
      .then((response) => response.json())
      .then((data) => {
        this.timeTarget.innerHTML = ""

        if (!data.slots || data.slots.length === 0) {
          this.timeTarget.innerHTML = '<option value="">No slots available</option>'
          return
        }

        data.slots.forEach((slot) => {
          const option = document.createElement("option")
          option.value = slot.value
          option.textContent = slot.label
          this.timeTarget.appendChild(option)
        })
      })
      .catch(() => {
        this.timeTarget.innerHTML = '<option value="">Unable to load slots</option>'
      })
  }
}
