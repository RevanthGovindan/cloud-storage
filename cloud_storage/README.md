# Cloud Storage (Django)

This project is a minimal Google-Drive-like prototype built with Django. It provides session-based login, a simple UI and APIs to list, upload and delete files. Files are stored on disk under `MEDIA_ROOT` and referenced via a `File` model.

Quick setup (skip if you won't run migrations here):

1. Create a virtual environment and activate it:

```bash
python3 -m venv .venv
source .venv/bin/activate
```

2. Install dependencies:

```bash
pip install -r requirements.txt
```

3. (Optional) Use MySQL: update `cloud_storage/settings.py` DATABASES sample and install `mysqlclient`.

4. Run migrations and create superuser (NOT executed for you per request):

```bash
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
```

5. Run server:

```bash
python manage.py runserver
```

Media files
- User uploads are saved under `MEDIA_ROOT/uploads/`. Ensure `MEDIA_ROOT` exists or create it:

```bash
mkdir -p media/uploads
```

APIs
- `POST /api/login/` — form login (session cookie)
- `GET /api/files/` — list files (requires session cookie)
- `POST /api/files/upload/` — upload file (multipart form `file`)
- `POST /api/files/<id>/delete/` — delete file (owner only)

UI
- `GET /login/` — login page
- `GET /dashboard/` — dashboard with upload form and file list

Notes
- Session-based auth is used. If you want token/JWT APIs for external clients, I can add Django REST Framework and token auth.
- I did not run migrations or start the server per your request.