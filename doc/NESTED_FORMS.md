Nested Forms (Article → Sections)
================================

This project includes a simple nested-form implementation using Stimulus to add/remove `Section` entries on the `Article` form.

What was added
- `Section` model and migration: `db/migrate/20251213000000_create_sections.rb` and `app/models/section.rb`
- `Article` updated to `has_many :sections` and accepts nested attributes
- `app/views/articles/_form.html.erb` updated with nested section fields and a hidden template
- Stimulus controller: `app/javascript/controllers/nested_form_controller.js`

How it works
- The form renders existing `sections` and a hidden template used by Stimulus to insert new section blocks.
- The Stimulus controller replaces the placeholder index `new_section` with a unique timestamp and appends the block.
- Removing an existing section sets the `_destroy` hidden field (so Rails will remove it on save). Removing a newly-added section removes the DOM node.

Developer steps to enable and use
1. Run the migration to create the `sections` table:

```bash
docker-compose run --rm web bin/rails db:migrate
```

Or, without Docker:

```bash
bin/rails db:migrate
```

2. Start the app and open the Article form (New or Edit): the Sections fieldset shows existing sections and an "Add Section" button.

3. Add or remove sections in the UI and submit the form. The controller will permit nested attributes and persist changes.

Notes and next steps
- The migration, model and controller changes are minimal; feel free to add validation rules on `Section` as needed.
- You may want to add client-side styling for `.nested-fields` and improve UX (drag-to-reorder, position handling).
