import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel"]

  toggle(event) {
    const index = event.currentTarget.dataset.index
    const panel = this.panelTargets.find((el) => el.dataset.index === index)
    if (!panel) return

    panel.classList.toggle("hidden")
  }
}
