Make sure the following are installed:

- Docker
- Docker Compose
- Git

Verify installation:

```bash
docker --version
docker-compose --version
```

---
### Docker Commands
First Time Setup (New Environment)

If you are running the project for the first time:
```bash
docker-compose build
docker-compose up -d
docker-compose run --rm web bundle install
docker-compose run --rm web rails db:drop db:create db:migrate db:seed
```
---
### Already Configured Application

If the application is already built and configured:

Start containers:
```bash
docker-compose up
```
Run in background:
```bash
docker-compose up -d
```
Visit the application:
```bash
http://localhost:3000
```
To attach a debugger
```bash
docker attach myapp-web-1
```
Restart just the web service (no rebuild):
```bash
docker-compose restart web
```
Watch logs (tail web):
```bash
docker-compose logs -f web
```
Stop containers:
```bash
docker-compose down
```
Rebuild containers:
```bash
docker-compose build
```
Rebuild only the web service:
```bash
docker-compose build web
```


---