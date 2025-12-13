File upload (Document)
======================

This repository originally implemented a lightweight filesystem-based `Document` upload (files under `public/uploads`). The app has been migrated to support Rails' Active Storage for attachment management while keeping the legacy filesystem fields for backward compatibility during migration.

What changed (high level)
- `Document` now has an Active Storage attachment `uploaded_file` (see `app/models/document.rb`).
- `DocumentUploader` now attaches uploaded files via Active Storage and updates the `Document` metadata columns (`original_filename`, `content_type`, `file_size`).
- Legacy filesystem fields (`file`, `folder`) are still preserved so existing files continue to work; new uploads prefer Active Storage.

Why Active Storage?
- Built-in support for service-backed storage (local, S3, GCS, etc.)
- Signed URLs, direct uploads from the browser, variants (images), and background processing integration

Developer steps — enable Active Storage
-------------------------------------

1) Install Active Storage (if not already installed)

```bash
docker-compose run --rm web bin/rails active_storage:install
docker-compose run --rm web bin/rails db:migrate
```

This creates the Active Storage tables (`active_storage_blobs`, `active_storage_attachments`) and runs pending migrations.

2) If you currently have existing `Document` records with `article_id` and `file`/`folder` pointing to files under `public/uploads`, you can backfill them into Active Storage gradually. Example backfill (run from Rails console or a Rake task):

```ruby
# attach existing public file to Active Storage for a single document
doc = Document.find(1)
if doc.file_path && File.exist?(doc.file_path)
	file = File.open(doc.file_path, 'rb')
	doc.uploaded_file.attach(io: file, filename: doc.original_filename || File.basename(doc.file_path), content_type: doc.content_type)
	file.close
	# optionally remove the old file after verifying attachment
end

# to backfill many documents (careful, do in batches)
Document.find_each do |doc|
	next if doc.uploaded_file.attached?
	next unless doc.file_path && File.exist?(doc.file_path)
	File.open(doc.file_path, 'rb') do |f|
		doc.uploaded_file.attach(io: f, filename: doc.original_filename || File.basename(doc.file_path), content_type: doc.content_type)
	end
end
```

3) Update environment config (optional)

- Configure `config/storage.yml` and set `config.active_storage.service` in each environment. This repo's `config/environments/development.rb` already sets `config.active_storage.service = :local`.

Using the Active Storage attachment in views and controllers
----------------------------------------------------------

- In the codebase, prefer `document.uploaded_file` when handling file content.
- To generate a URL for the attached file in views, use Rails helper `url_for(document.uploaded_file)` or `rails_blob_path(document.uploaded_file, disposition: "attachment")`.
- For image previews use `image_tag document.uploaded_file.variant(resize_to_limit: [800, 600])` (requires ImageProcessing gem and appropriate processor configured).

Controller & uploader notes
---------------------------

- `app/services/document_uploader.rb` now creates a `Document` DB record and attaches the uploaded file via Active Storage. If attaching fails, the record is rolled back.
- `replace` purges the existing Active Storage attachment (if present) and attaches the new file; legacy filesystem files are removed when replaced.

Backward compatibility
----------------------

- Existing records that reference files in `public/uploads` continue to work. The `Document` model's helper methods prefer Active Storage attachment (if present) and fall back to constructing URLs from the legacy `file` and `folder` fields.
- After you verify Active Storage behavior and finish backfilling, you may remove the `file` and `folder` columns and any code that references them.

Security, performance and production guidance
--------------------------------------------

- Keep server-side validations for size and allowed MIME types (this repo's `DocumentUploader` still performs those checks).
- Consider enabling direct uploads from the browser using Active Storage's direct upload support to avoid sending large files through your Rails web dynos.
- Use a cloud storage service (S3, GCS) for production for durability and to integrate CDNs.
- For protected files, generate signed URLs rather than serving files from `public/`.

Commands & verification
-----------------------

Install & migrate Active Storage:

```bash
docker-compose run --rm web bin/rails active_storage:install
docker-compose run --rm web bin/rails db:migrate
```

Check attachment availability in a container console:

```bash
docker-compose exec web rails runner "puts Document.first&.uploaded_file&.attached?"
```

Backfill a single file (example):

```bash
docker-compose exec web rails runner "doc=Document.find(1); File.open(doc.file_path,'rb'){|f| doc.uploaded_file.attach(io:f, filename:doc.original_filename)}"
```

When done
---------

If you choose to remove the legacy filesystem implementation after backfilling, create a migration to drop the `file` and `folder` columns and clean up any references.

Questions or next steps
-----------------------

I can:

- Add a one-off Rake task to backfill `public/uploads` files into Active Storage in safe batches.
- Convert view helpers to use `url_for`/`rails_blob_path` consistently and add direct upload UI (Dropzone or Rails UJS direct uploads).
- Add tests covering the new Active Storage flows.

Tell me which of the above you want next and I'll implement it.

