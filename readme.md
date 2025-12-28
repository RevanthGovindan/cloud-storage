# Cloud Backup Storage - Complete Setup Guide

Welcome! This is a fully functional cloud storage application with user authentication and MySQL support.

## 🚀 Quick Start (5 minutes)

### Step 1: Activate Virtual Environment
```bash
source storage/bin/activate
```

### Step 2: Install Dependencies (if not already installed)
```bash
pip install -r cloud_storage/requirements.txt
```

### Step 3: Run Migrations
Using SQLite (recommended for quick testing):
```bash
cd cloud_storage
export USE_SQLITE=1
python manage.py migrate
```

### Step 4: Create Admin User (Optional)
```bash
python manage.py createsuperuser
# Username: admin
# Email: admin@example.com
# Password: (choose one)
```

### Step 5: Start the Server
```bash
python manage.py runserver
```

### Step 6: Access the Application
- **Main App**: http://localhost:8000
- **Admin Panel**: http://localhost:8000/admin (if you created a superuser)

## 🌐 Features

### User Management
- ✅ User registration with validation
- ✅ Secure login/logout
- ✅ Password protection
- ✅ User profiles

### File Management
- 📤 Upload files to cloud storage
- 📥 Download uploaded files
- 🗑️ Delete files (soft delete)
- 📊 View file metadata (size, upload date)

### Security
- 🔐 CSRF protection
- 🔑 Session-based authentication
- 👤 User isolation (only see your files)
- 🔒 Password validation

## 🐳 Using MySQL with Docker

### Step 1: Start MySQL
```bash
docker compose up -d mysql
```

### Step 2: Wait for MySQL to be Ready
```bash
# This will show when MySQL is ready
docker compose logs mysql | grep "ready for connections"
```

### Step 3: Update Environment
```bash
cd cloud_storage
export USE_SQLITE=0
```

Or edit `.env` file and set `USE_SQLITE=0`

### Step 4: Run Migrations
```bash
python manage.py migrate
```

### Step 5: Start Server
```bash
python manage.py runserver
```

## 📁 Project Structure

```
/Users/revanthg/workspace/storage/
├── storage/                    # Python virtual environment
├── cloud_storage/              # Django project
│   ├── cloud_storage/          # Project settings
│   │   ├── settings.py        # Django configuration
│   │   ├── urls.py            # Main URL routing
│   │   └── wsgi.py            # WSGI config
│   ├── login/                  # Authentication app
│   │   ├── models.py          # User, UserProfile, File models
│   │   ├── views.py           # Login, Register, Dashboard views
│   │   ├── urls.py            # App URL routing
│   │   └── templates/         # HTML templates
│   │       ├── login.html     # Login page
│   │       ├── register.html  # Registration page
│   │       ├── dashboard.html # File management dashboard
│   │       └── myfirst.html   # Welcome page
│   ├── media/                 # Uploaded files storage
│   ├── manage.py              # Django CLI
│   ├── requirements.txt       # Python dependencies
│   ├── .env                   # Environment variables
│   └── SETUP_GUIDE.md        # Detailed documentation
├── docker-compose.yaml        # MySQL Docker configuration
└── run.sh                     # Quick start helper script
```

## 🔧 Common Commands

### Django Management
```bash
# Create migrations for model changes
python manage.py makemigrations

# Apply migrations to database
python manage.py migrate

# Create admin superuser
python manage.py createsuperuser

# Access Django interactive shell
python manage.py shell

# Run tests
python manage.py test

# Collect static files
python manage.py collectstatic
```

### Docker MySQL
```bash
# Start MySQL container
docker compose up -d mysql

# Stop MySQL container
docker compose down

# View MySQL logs
docker compose logs mysql

# Access MySQL command line
docker exec -it mysql-db mysql -u appuser -papppassword

# Reset database (delete all data)
docker compose down -v
docker compose up -d mysql
```

## 🐛 Troubleshooting

### "No database available" error
Make sure to run migrations first:
```bash
export USE_SQLITE=1  # or USE_SQLITE=0 for MySQL
python manage.py migrate
```

### "Port 3306 already in use"
MySQL container might already be running:
```bash
docker ps  # See running containers
docker stop mysql-db
```

### "Template not found" error
Make sure you're in the correct directory:
```bash
cd cloud_storage
```

### Database connection refused
MySQL container might not be running:
```bash
docker compose up -d mysql
docker compose logs mysql
```

### ModuleNotFoundError
Reinstall dependencies:
```bash
pip install -r cloud_storage/requirements.txt
```

## 🎯 Next Steps

1. ✅ Activate virtual environment
2. ✅ Install dependencies
3. ✅ Run migrations
4. ✅ Start the server
5. ✅ Register a new user at http://localhost:8000/register/
6. ✅ Login with your account
7. ✅ Upload and manage files
8. ✅ (Optional) Check admin panel at http://localhost:8000/admin

## 💡 Tips

- Keep the virtual environment activated when working
- Always run Django commands from the `cloud_storage/` directory
- Check `.env` file for database credentials
- Use `docker compose logs` for debugging container issues
- Use `python manage.py shell` for testing Django models

## 🚨 Important Notes

⚠️ **Development Only**: This setup is for development and learning.

For production deployment:
1. Change SECRET_KEY in settings.py
2. Set DEBUG = False
3. Implement proper database backups
4. Use HTTPS/SSL encryption
5. Add rate limiting for authentication
6. Implement proper logging
7. Use a production web server (Gunicorn, etc.)
8. Add monitoring and alerting

## 📚 Detailed Documentation

For complete setup, configuration, and API documentation, see:
- [SETUP_GUIDE.md](cloud_storage/SETUP_GUIDE.md)

This includes:
- Complete installation instructions
- Environment variable configuration
- API endpoint documentation
- Performance optimization tips
- Security recommendations
- Troubleshooting guide
- Future enhancement ideas

## 🏗️ Architecture

**Backend**: Django 6.0 with Python 3.13
**Database**: MySQL 8.0 (or SQLite for development)
**Frontend**: HTML5 + CSS3
**Authentication**: Django built-in auth system
**File Storage**: Django FileField with local storage

## 📊 Database Schema

**Users** (Django built-in)
- username, email, password, first_name, last_name

**UserProfile** (Custom)
- user (OneToOne with User)
- storage_used (for tracking quota)

**Files** (Custom)
- owner (ForeignKey to User)
- name, file (FileField)
- size, uploaded_at
- is_deleted (soft delete flag)

## ❓ Quick FAQ

**Q: Can I use PostgreSQL instead?**
A: Yes, update DATABASE config in settings.py

**Q: Where are uploaded files stored?**
A: In `cloud_storage/media/uploads/` directory

**Q: Can I increase file upload size limit?**
A: Add to settings.py: `FILE_UPLOAD_MAX_MEMORY_SIZE = 52428800`

**Q: How do I reset the database?**
A: Delete db.sqlite3 and run migrations again

**Q: Can I deploy to production?**
A: Yes, but follow the production notes above

---

**Happy Cloud Storing!** ☁️

For questions, check SETUP_GUIDE.md or review the code comments.
6) to create a app
python manage.py startapp helloworld