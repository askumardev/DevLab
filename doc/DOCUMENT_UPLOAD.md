File upload (Document)
======================

This adds a simple `Document` resource for uploading files to `public/uploads`, supporting images, PDFs and generic files. The implementation is intentionally lightweight and filesystem-based so it's easy to inspect and understand; see the "Production notes" section for recommended improvements.

Quick usage

1. Run migrations:

```bash
docker-compose run --rm web bin/rails db:migrate
```

2. Open the UI: `http://localhost:3000/documents/new` and upload a file. Files are classified by MIME type and stored under `public/uploads/images`, `public/uploads/pdfs`, or `public/uploads/files`.

3. Files are stored under `public/uploads/<folder>` (images/pdfs/files) with a randomized safe filename. The original filename and MIME type are saved in the `documents` table; the UI shows a preview for images and download links for other files.

Implementation details — how the upload works (step by step)
---------------------------------------------------------

- The browser form uses `multipart/form-data` (Rails helper: `form_with ..., html: { multipart: true }`). This tells the browser and Rack to transmit file bytes alongside form fields.
- When the form is submitted, Rack parses the multipart request and provides an `ActionDispatch::Http::UploadedFile` (or similar) object in `params[:document][:file]`.
- In the controller (`DocumentsController#create`) we accept the regular form parameters (`document_params`) and separately handle the uploaded file object. The uploaded object exposes attributes and methods such as:
	- `original_filename` — the client-side filename
	- `content_type` — the MIME type reported by the client/agent
	- `read` / `tempfile` — access to the file bytes
	- `size` — file size in bytes (may be provided by Rack)
- The controller classifies the uploaded file into a folder (images/pdfs/files) using the `content_type` (MIME type). This is a convenience for organization and basic UI rules (image preview vs. download link).
- A safe storage filename is generated on the server using `SecureRandom.hex(10)` + original extension. This avoids collisions and avoids using user-supplied filenames directly on disk (which can be unsafe).
- The controller writes the uploaded bytes to `public/uploads/<folder>/<safe_filename>` using `File.open(..., 'wb')`.
- The `Document` model stores the generated filename (`file`), the `original_filename`, `content_type`, `file_size`, and `folder` so the app can present metadata and construct a URL (e.g. `/uploads/images/abc123.png`).
- After saving the model record, the uploaded file is immediately available via the static file server because files under `public/` are served directly by Rails (in development) or by the web server (in production).
- Deleting a `Document` triggers controller logic to remove the file from disk (if present) and then deletes the DB record.

Key concepts used
-----------------

- multipart/form-data: HTTP encoding for forms that include files. Required for file transfer from browser to server.
- Rack & ActionDispatch uploaded file object: abstraction that represents the uploaded file and exposes metadata and content.
- Server-side filename generation: avoid using user-supplied filenames directly to prevent path traversal, collisions, or encoding issues.
- Metadata storage: keep `original_filename`, `content_type`, `file_size` and `folder` in the DB so the UI can display friendly names and sizes while the stored filename is safe and opaque.
- Serving from `public/`: files placed under `public/` are served statically; this is simple but may not be appropriate for all production needs.

Security and robustness notes
-----------------------------

- Validate file size: enforce a maximum upload size (e.g. 10-50 MB) both at the web server and in application logic to avoid denial-of-service by huge uploads.
- Validate file types: do not rely solely on `content_type` reported by the browser. When security is important, validate file contents (magic bytes / signatures) to ensure the file is actually what it claims to be.
- Sanitize metadata: never use `original_filename` for a filesystem path. Store it only as a text field for display.
- Scan uploads: in production, run virus/malware scanning (e.g. ClamAV or a cloud provider feature) on user-submitted files.
- Access control: authenticate & authorize who can upload and download files. Public files under `public/` are accessible to anyone with the URL — if files must be protected, use a controlled download endpoint or signed URLs.
- Avoid arbitrary overwrite: generating randomized safe filenames prevents collisions and overwriting existing files.
- Use background jobs for large files: for long-running processing (transcoding, virus scan, thumbnailing), hand off work to background workers so web requests remain fast.

Production recommendations
------------------------

- Use ActiveStorage (built into Rails) or a cloud object store (S3, GCS) for durability, scalability, signed URLs, and built-in direct upload support.
- If storing files locally in production, ensure your server's `public/uploads` is on durable storage and replicated/backuped.
- Serve heavy static assets via a CDN for performance.
- Restrict executable file types and use container-level or OS-level protections if users can upload arbitrary files.

Developer steps & testing
-------------------------

- Run migrations:

```bash
docker-compose run --rm web bin/rails db:migrate
```

- Start the app and upload a file via the UI:

```bash
docker-compose up
# then open http://localhost:3000/documents/new
```

- Create a sample via Rails runner (non-interactive):

```bash
docker-compose run --rm web bin/rails runner "Document.create!(name: 'Seed doc')"
```

Final notes
-----------

This implementation is intentionally simple and readable. For production-grade file handling (secure access, permanence, scale, direct uploads, CDN, and virus scanning) prefer `ActiveStorage` or an object storage service. If you'd like, I can convert this implementation to ActiveStorage and wire direct uploads and signed URLs.

