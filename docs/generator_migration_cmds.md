
### Database Commands

Run migrations:
```bash
docker-compose run --rm web rails db:migrate
```
Seed database:
```bash
docker-compose run --rm web rails db:seed
```
Reset database:
```bash
docker-compose run --rm web rails db:reset
```
Drop and recreate database:
```bash
docker-compose run --rm web rails db:drop db:create db:migrate db:seed
```

---

### Rails Generators

Generate model:
```bash
docker-compose run --rm web rails g pages
docker-compose run --rm web rails generate model Location state:string district:string pincode:string
```
Other generators:
```bash
rails generate model Student
rails generate controller Student
rails g migration add_passing_year_in_student_degrees
rails g serializer TodoList
rails g mailer bookings booking_confirmation
```
Run migrations:
```bash
rails db:migrate
```
---

### Useful Rails Commands

Open Rails console:
```bash
docker-compose exec web rails console
```
Show routes:
```bash
docker-compose run --rm web rails routes
```
Filter routes:
```bash
docker-compose run --rm web rails routes | grep chat
```
---