Items Model and Repository Classes Design Recipe

_Copy this recipe template to design and implement Model and Repository classes for a database table._

## 1. Design and create the Table

If the table is already created in the database, you can skip this step.

Otherwise, [follow this recipe to design and create the SQL schema for your table](./single_table_design_recipe_template.md).

_In this template, we'll use an example table `students`_

```
# EXAMPLE

Table: students

Columns:
id | name | cohort_name
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_items.sql)

-- Write your SQL seed here.

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE items, orders, items_orders RESTART IDENTITY;

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO items (name, unit_price, quantity) VALUES ('Xbox', '499.00', '6');
INSERT INTO items (name, unit_price, quantity) VALUES ('PS5', '599.00', '4');
INSERT INTO items (name, unit_price, quantity) VALUES ('MacBook Pro', '1800.00', '12');
INSERT INTO items (name, unit_price, quantity) VALUES ('Wireless Headphones', '50.00', '38');

INSERT INTO orders (customer_name, order_date) VALUES ('Phil', '2022.08.26');
INSERT INTO orders (customer_name, order_date) VALUES ('Kat', '2022.08.12');

INSERT INTO items_orders (item_id, order_id) VALUES ('1', '1');
INSERT INTO items_orders (item_id, order_id) VALUES ('2', '2');
INSERT INTO items_orders (item_id, order_id) VALUES ('4', '1');
INSERT INTO items_orders (item_id, order_id) VALUES ('3', '2');


```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_{table_name}.sql

```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)
class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)

class Post
  # Replace the attributes by your own columns.
  attr_accessor :id, :title, :content, :number_of_views, :user_account_id
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

_You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed._

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: posts

# Repository class
# (in lib/post_repository.rb)

class PostRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, content, number_of_views, user_account_id FROM posts;
    # Returns an array of Post objects.
  end

  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, number_of_views, user_account_id FROM posts WHERE id = $1;
    # Returns a single Post object.
  end

  # Insert a new post record
  # Takes a Post object in argument
  def create(post)
    # Executes the SQL query:
    # INSERT INTO posts (title, content, number_of_views, user_account_id) VALUES ($1, $2, $3, $4);
    # Does not need to return anything as only creates record
  end

  # Deletes an post record
  # Given its id
  def delete(id)
    # Executes the SQL query:
    # DELETE FROM posts WHERE id = $1;
    # Does not need to return anything as only deletes record
  end

  # Updates an post record
  # Takes an Post object with updated fields
  def update(post)
    # Executes SQL query:
    # UPDATE posts SET title = $1, content = $2, number_of_views = $3, user_account_id = $4 WHERE id = $5;
    # Returns nothing as only updates record
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all posts
repo = PostRepository.new
posts = repo.all

posts.length # =>  3

posts[0].id # =>  1
posts[0].title # =>  'First Day'
posts[0].content # =>  'Welcome to...'
posts[0].number_of_views # =>  '12'
posts[0].user_account_id # =>  '1'

# 2
# Get a single user account based on given id
repo = PostRepository.new
post = repo.find(1)

post.id # =>  1
post.title # =>  'First Day'
post.content # =>  'Welcome to...'
post.number_of_views # =>  '12'
post.user_account_id # =>  '1'

post = repo.find(2)

post.id # =>  2
post.title # =>  'Try this recipe'
post.content # =>  'You will need'
post.number_of_views # =>  '43'
post.user_account_id # =>  '1'

post = repo.find(3)

post.id # =>  3
post.title # =>  'Enemies Everywhere!'
post.content # =>  'Grab your sword and shield...'
post.number_of_views # =>  '99'
post.user_account_id # =>  '2'

# 3
# Create a new post
# Creation of new post:
repo = PostRepository.new
post = Post.new

post.title # => 'Amazing New Post!'
post.content # => 'Check out this incredible...'
post.number_of_views # =>  '1028'
post.user_account_id # =>  '2'

repo.create(post) # => nil

# Checking of new post:
posts = repo.all

last_post = posts.last
last_post.title # => 'Amazing New Post!'
last_post.content # => 'Check out this incredible...'
last_post.number_of_views # =>  '1028'
last_post.user_account_id # =>  '2'

# 4
# Delete a single post
repo = PostRepository.new
id_to_delete = 1

repo.delete(id_to_delete)

all_posts = repo.all
all_posts.length # => 1
all_posts.first.id # => '2'

# 5
# Update a post
repo = PostRepository.new
post = repo.find(3)

post.title = "Final Boss Fight"
post.content = "We have come so far..."
post.number_of_views = 9000
post.user_account_id = 2

repo.update(post)

updated_post = repo.find(3)
expect(updated_post.title).to eq "Final Boss Fight"
expect(updated_post.content).to eq "We have come so far..."
expect(updated_post.number_of_views).to eq 9000
expect(updated_post.user_account_id).to eq 2
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/post_repository_spec.rb

def reset_posts_table
  seed_sql = File.read("spec/seeds_posts.sql")
  connection = PG.connect({ host: "127.0.0.1", dbname: "posts" })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) { reset_posts_table }

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
