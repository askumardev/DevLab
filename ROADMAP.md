DevLab Roadmap

* ✅ Basic Rails setup
* ✅ Manual authentication
* ⬜ Notes with Hotwire
* ⬜ File uploads
* ⬜ Chat with ActionCable
* ⬜ API mode
* ⬜ JWT auth
* ⬜ Admin panel
* ⬜ AI Features
* ⬜ AWS Deployment

## Stimulus Learning Roadmap

If you're new to Stimulus, here's a step-by-step guide to get started and build practical skills. Stimulus is a JavaScript framework for adding interactivity to HTML without complex state management.

### 1. Understand the Basics
- Read the [official Stimulus documentation](https://stimulus.hotwired.dev/) to grasp controllers, targets, actions, and values.
- Learn how Stimulus connects to your HTML via `data-controller`, `data-target`, `data-action`, and `data-*-value` attributes.
- Explore the [Stimulus Handbook](https://stimulus-use.github.io/stimulus-use/) for advanced patterns.

### 2. Set Up Your Environment
- Ensure Stimulus is installed in your Rails app (it's included by default in Rails 7+ with Hotwire).
- Check your `app/javascript/controllers/` directory and the `index.js` file for auto-loading.

### 3. Practice with Simple Controllers
- **Toggle Visibility:** Create a controller that shows/hides an element on button click (e.g., a collapsible FAQ section).
- **Counter:** Build a counter that increments/decrements a number with buttons, updating the display.
- **Form Validation:** Add real-time validation feedback to a form field (e.g., check email format as user types).

### 4. Work with Targets and Actions
- **Dynamic Lists:** Implement add/remove functionality for list items (like the sections in this project).
- **Modal Dialogs:** Create a modal that opens/closes with buttons, handling focus and accessibility.
- **Tabs Interface:** Build tabbed content where clicking a tab shows the corresponding panel.

### 5. Use Values and Events
- **Search Filter:** Add a search input that filters a list of items as you type, using values to store the query.
- **Progress Bar:** Create a progress bar that updates based on user actions or time, using values for current progress.
- **Auto-Save Form:** Implement auto-saving for a form, debouncing input events to save periodically.

### 6. Integrate with Rails and AJAX
- **AJAX Requests:** Practice making fetch calls within controllers (as in the section deletion example).
- **Dynamic Content Loading:** Load content from the server without full page reloads (e.g., infinite scroll or lazy loading).
- **Real-Time Updates:** Combine with ActionCable for live updates, like notifications or chat.

### 7. Advanced Topics
- Learn about [StimulusReflex](https://docs.stimulusreflex.com/) for server-driven interactions.
- Explore [Stimulus Use](https://stimulus-use.github.io/stimulus-use/) for reusable behaviors like debouncing or intersection observers.
- Study accessibility best practices in Stimulus controllers.

### Practice Suggestions in This Project
- **Enhance the Section Controller:** Add drag-and-drop reordering for sections using a library like SortableJS integrated with Stimulus.
- **Add a Character Counter:** To the article body or section content fields, showing remaining characters.
- **Implement a Preview Mode:** Toggle between edit and preview views for articles, rendering Markdown on the client-side.
- **Create a Notification System:** Show flash messages or toasts using Stimulus for user feedback on actions.

By following this roadmap and implementing these suggestions, you'll gain hands-on experience with Stimulus and improve the DevLab app along the way!
