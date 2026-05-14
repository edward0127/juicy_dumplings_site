import { Controller } from "@hotwired/stimulus"

const TOUR_STEPS = [
  {
    eyebrow: "Welcome",
    title: "Welcome to the Juicy Dumplings admin",
    body: "Manage the menu, orders, bookings, opening hours, and shop details shown on the website."
  },
  {
    eyebrow: "Dashboard",
    title: "Check the day at a glance",
    body: "Use the dashboard to quickly check today's orders, bookings, and recent customer activity."
  },
  {
    eyebrow: "Menu Items",
    title: "Keep dishes up to date",
    body: "Update dish names, prices, descriptions, photos, and availability. These appear on the public menu and order pages."
  },
  {
    eyebrow: "Categories",
    title: "Organise the menu",
    body: "Group dishes into sections so customers can browse easily."
  },
  {
    eyebrow: "Hours",
    title: "Set when the shop is open",
    body: "Update the opening hours customers see on the website. These also help shape booking and pickup times."
  },
  {
    eyebrow: "Orders",
    title: "Review pickup orders",
    body: "Customer pickup orders submitted through the website appear here for staff to review."
  },
  {
    eyebrow: "Bookings",
    title: "Review table requests",
    body: "Table booking requests appear here with the customer's name, phone, date, time, and guest count."
  },
  {
    eyebrow: "Settings",
    title: "Update shop details",
    body: "Update phone, email, owner notification email, price range, booking limits, and other shop details."
  },
  {
    eyebrow: "Finish",
    title: "You can come back to the guide anytime",
    body: "Use the Show guide button for a quick reminder about the admin page you are using."
  }
]

const PAGE_GUIDES = {
  dashboard: {
    eyebrow: "Dashboard",
    title: "Service Dashboard",
    body: "This page gives you a quick overview of orders and bookings."
  },
  "menu-items": {
    eyebrow: "Menu Items",
    title: "Menu Items",
    body: "This page controls the dishes shown on the public menu and order pages. Update names, prices, descriptions, photos, and availability here."
  },
  categories: {
    eyebrow: "Categories",
    title: "Categories",
    body: "Use categories to group dishes, such as dumplings, set meals, sides, and drinks."
  },
  hours: {
    eyebrow: "Hours",
    title: "Opening Hours",
    body: "These opening hours appear on the public site and help customers know when you are open."
  },
  orders: {
    eyebrow: "Orders",
    title: "Orders",
    body: "Customer pickup orders submitted from the website appear here."
  },
  bookings: {
    eyebrow: "Bookings",
    title: "Bookings",
    body: "Table booking requests appear here. Check the customer name, phone, date, time, and guest count."
  },
  settings: {
    eyebrow: "Settings",
    title: "Business Settings",
    body: "These shop details power the public site, emails, booking limits, and customer-facing information."
  },
  admin: {
    eyebrow: "Admin",
    title: "Admin Guide",
    body: "Use this area to manage the restaurant details and customer activity shown on the website."
  }
}

export default class extends Controller {
  static targets = [
    "modal",
    "eyebrow",
    "title",
    "body",
    "count",
    "dots",
    "closeButton",
    "skipButton",
    "backButton",
    "nextButton",
    "finishButton"
  ]

  static values = {
    page: String,
    storageKey: String
  }

  connect() {
    this.mode = "tour"
    this.steps = TOUR_STEPS
    this.stepIndex = 0
    this.previouslyFocusedElement = null

    if (this.shouldAutoOpen()) {
      window.setTimeout(() => this.openTour(), 250)
    }
  }

  openPageGuide() {
    const guide = PAGE_GUIDES[this.pageValue] || PAGE_GUIDES.admin

    this.mode = "page"
    this.steps = [guide]
    this.stepIndex = 0
    this.show()
  }

  openTour() {
    this.mode = "tour"
    this.steps = TOUR_STEPS
    this.stepIndex = 0
    this.show()
  }

  next() {
    if (this.stepIndex >= this.steps.length - 1) {
      this.finish()
      return
    }

    this.stepIndex += 1
    this.render()
  }

  back() {
    if (this.stepIndex === 0) return

    this.stepIndex -= 1
    this.render()
  }

  finish() {
    if (this.mode === "tour") this.markSeen()

    this.hide()
  }

  skip() {
    if (this.mode === "tour") this.markSeen()

    this.hide()
  }

  close() {
    if (!this.isOpen()) return
    if (this.mode === "tour") this.markSeen()

    this.hide()
  }

  show() {
    this.previouslyFocusedElement = document.activeElement
    this.render()
    this.modalTarget.classList.remove("hidden")
    this.element.classList.add("overflow-hidden")
    this.closeButtonTarget.focus()
  }

  hide() {
    this.modalTarget.classList.add("hidden")
    this.element.classList.remove("overflow-hidden")

    if (this.previouslyFocusedElement?.focus) {
      this.previouslyFocusedElement.focus()
    }
  }

  render() {
    const step = this.steps[this.stepIndex]
    const total = this.steps.length
    const isLastStep = this.stepIndex === total - 1
    const isPageGuide = this.mode === "page"

    this.eyebrowTarget.textContent = step.eyebrow
    this.titleTarget.textContent = step.title
    this.bodyTarget.textContent = step.body
    this.countTarget.textContent = total > 1 ? `Step ${this.stepIndex + 1} of ${total}` : ""

    this.renderDots(total)

    this.skipButtonTarget.classList.toggle("hidden", isPageGuide)
    this.backButtonTarget.classList.toggle("hidden", total === 1)
    this.backButtonTarget.disabled = this.stepIndex === 0
    this.backButtonTarget.classList.toggle("opacity-50", this.stepIndex === 0)
    this.backButtonTarget.classList.toggle("cursor-not-allowed", this.stepIndex === 0)

    this.nextButtonTarget.classList.toggle("hidden", isLastStep)
    this.finishButtonTarget.classList.toggle("hidden", !isLastStep)
    this.finishButtonTarget.textContent = isPageGuide ? "Done" : "Finish"
  }

  renderDots(total) {
    this.dotsTarget.innerHTML = ""

    if (total === 1) return

    this.steps.forEach((_, index) => {
      const dot = document.createElement("span")
      dot.className = index === this.stepIndex ? "admin-tour__dot admin-tour__dot--active" : "admin-tour__dot"
      this.dotsTarget.appendChild(dot)
    })
  }

  shouldAutoOpen() {
    return this.pageValue === "dashboard" && !this.hasSeenTour()
  }

  hasSeenTour() {
    try {
      return window.localStorage.getItem(this.storageKeyValue) === "true"
    } catch (_error) {
      return true
    }
  }

  markSeen() {
    try {
      window.localStorage.setItem(this.storageKeyValue, "true")
    } catch (_error) {
      // Ignore storage failures so the admin remains usable in private or locked-down browsers.
    }
  }

  isOpen() {
    return !this.modalTarget.classList.contains("hidden")
  }
}
