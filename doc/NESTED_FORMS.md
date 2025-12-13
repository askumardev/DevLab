Nested Forms (Article → Sections)
================================

This project includes a simple nested-form implementation using Stimulus to add/remove `Section` entries on the `Article` form.

What was added
- `Section` model and migration: `db/migrate/20251213000000_create_sections.rb` and `app/models/section.rb`
- `Article` updated to `has_many :sections` and accepts nested attributes
- `app/views/articles/_form.html.erb` updated with nested section fields and a hidden template
- `SectionsController` for handling AJAX deletion: `app/controllers/sections_controller.rb`
- Stimulus controller: `app/javascript/controllers/section_controller.js`

How it works
- The form renders existing `sections` and a hidden template used by Stimulus to insert new section blocks.
- **Addition Process:**
  1. User clicks the "+" button in the "Add section" area.
  2. The Stimulus `section_controller`'s `add` method is triggered via `data-action="click->section#add"`.
  3. The method retrieves the hidden template HTML from `data-section-target="template"`.
  4. It replaces the placeholder `new_section` with a unique timestamp to ensure unique field names.
  5. The modified HTML is inserted into the container (`data-section-target="container"`), adding a new section form block to the page.
- **Deletion Process:**
  1. User clicks the "×" button next to a section.
  2. The Stimulus `section_controller`'s `remove` method is triggered via `data-action="click->section#remove"`.
  3. A confirmation dialog appears: "Are you sure you want to delete this section?"
  4. If the user cancels, the process stops.
  5. If confirmed:
     - For existing sections (those with an ID): An AJAX DELETE request is sent to `/articles/:article_id/sections/:section_id` with CSRF token.
     - The server deletes the section record from the database.
     - Upon successful response, the section element is removed from the DOM.
     - For new sections (no ID): The element is simply removed from the DOM without any server request.

**AJAX Call Details for Section Deletion:**
- **Trigger:** When deleting an existing section, the JavaScript constructs the URL using the `articleId` value (from `data-section-article-id-value`) and the section's ID (from the hidden input field).
- **Request:** A `fetch` API call is made with:
  - Method: `DELETE`
  - URL: `/articles/{articleId}/sections/{sectionId}`
  - Headers: Includes `X-CSRF-Token` (retrieved from the `<meta name="csrf-token">` tag in the HTML head) and `Content-Type: application/json`.
- **Server Response:** The `SectionsController#destroy` action finds the section by ID, calls `@section.destroy`, and returns a `204 No Content` status.
- **Client Handling:** If the response is OK (status 200-299), the section's DOM element is removed. No error handling is implemented for failed requests in the current code.
- **Purpose:** This allows immediate deletion without requiring a form submission, providing a better user experience.
- The Stimulus controller uses targets for `container` (where sections are listed) and `template` (the hidden new section template), and a value for `articleId` to construct URLs.


Notes and next steps
- The migration, model and controller changes are minimal; feel free to add validation rules on `Section` as needed.
- You may want to add client-side styling for `.nested-fields` and improve UX (drag-to-reorder, position handling).
