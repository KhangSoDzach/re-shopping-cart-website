-- Sample data for Shopping Cart Application
-- This file runs automatically when Spring Boot starts (sql.init.mode=always)

-- Insert users if not exists
INSERT IGNORE INTO users (id, name) VALUES (1, 'Nguyen Van A');

-- Insert products if not exists
INSERT IGNORE INTO products (id, name, image_url, price) VALUES
(1, 'Ốp điện thoại', 'op-dien-thoai.jpg', 155000),
(2, 'Sạc điện thoại', 'cong-chuyen-usb.jpg', 150000);

-- Insert cart for user if not exists
INSERT IGNORE INTO carts (id, user_id) VALUES (1, 1);

-- Insert cart items if not exists
INSERT IGNORE INTO cart_items (id, cart_id, product_id, quantity) VALUES
(1, 1, 1, 4),
(2, 1, 2, 1);
