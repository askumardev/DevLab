// Import and register all Stimulus controllers
import { Application } from "@hotwired/stimulus"
import {
  HelloController,
  SectionController,
  ExperienceController,
  LocationController,
  NestedDocumentsController,
  RatingController,
  CalendarController
} from "../stimulus/index"

const application = Application.start()

// Register Stimulus components
application.register("hello", HelloController)
application.register("section", SectionController)
application.register("experience", ExperienceController)
application.register("location", LocationController)
application.register("nested-documents", NestedDocumentsController)
application.register("rating", RatingController)
application.register("calendar", CalendarController)

export { application }
