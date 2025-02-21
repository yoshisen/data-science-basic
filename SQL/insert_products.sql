
CREATE TABLE IF NOT EXISTS products (
    product_id INT,
    product_name VARCHAR(255),
    category VARCHAR(255)
);

INSERT INTO products (product_id, product_name, category) VALUES
(1, 'Product B', 'Category Y'),
(2, 'Product C', 'Category Z'),
(3, 'Product D', 'Category X'),
(4, 'Product E', 'Category Y'),
(5, 'Product F', 'Category Z'),
(6, 'Product G', 'Category X'),
(7, 'Product H', 'Category Y'),
(8, 'Product I', 'Category Z'),
(9, 'Product J', 'Category X'),
(10, 'Product K', 'Category Y');
