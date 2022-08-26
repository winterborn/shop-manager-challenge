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