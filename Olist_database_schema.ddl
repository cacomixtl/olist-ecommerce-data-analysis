
-- Schema for the Olist E-commerce Database

-- Table for olist_customers_dataset.csv
CREATE TABLE customers (
    customer_id TEXT PRIMARY KEY, -- Unique identifier for the customer entry (one per order)
    customer_unique_id TEXT,      -- Unique identifier for the actual customer (can have multiple orders)
    customer_zip_code_prefix INTEGER,
    customer_city TEXT,
    customer_state TEXT
);

-- Table for olist_geolocation_dataset.csv
-- Note: No primary key defined here as zip code prefixes can have multiple lat/lng entries.
-- Consider creating a separate mapping table with unique zip prefixes if needed later.
CREATE TABLE geolocation (
    geolocation_zip_code_prefix INTEGER,
    geolocation_lat REAL,
    geolocation_lng REAL,
    geolocation_city TEXT,
    geolocation_state TEXT
);

-- Table for olist_sellers_dataset.csv
CREATE TABLE sellers (
    seller_id TEXT PRIMARY KEY, -- Unique identifier for the seller
    seller_zip_code_prefix INTEGER,
    seller_city TEXT,
    seller_state TEXT
);

-- Table for product_category_name_translation.csv
CREATE TABLE product_name_translation (
    product_category_name TEXT PRIMARY KEY, -- Product category name in Portuguese
    product_category_name_english TEXT      -- Product category name translated to English
);

-- Table for olist_products_dataset.csv
CREATE TABLE products (
    product_id TEXT PRIMARY KEY, -- Unique identifier for the product
    product_category_name TEXT,
    product_name_lenght INTEGER,
    product_description_lenght INTEGER,
    product_photos_qty INTEGER,
    product_weight_g INTEGER,
    product_length_cm INTEGER, -- Corrected typo from lenght to length
    product_height_cm INTEGER,
    product_width_cm INTEGER,
    FOREIGN KEY (product_category_name) REFERENCES product_name_translation (product_category_name) -- Links to translation table
);

-- Table for olist_orders_dataset.csv
CREATE TABLE orders (
    order_id TEXT PRIMARY KEY, -- Unique identifier for the order
    customer_id TEXT,          -- Links to the specific customer entry for this order
    order_status TEXT,
    order_purchase_timestamp TEXT,
    order_approved_at TEXT,
    order_delivered_carrier_date TEXT,
    order_delivered_customer_date TEXT, -- Corrected typo from delivery to delivered
    order_estimated_delivery_date TEXT, -- Added '_date' for clarity and consistency
    FOREIGN KEY (customer_id) REFERENCES customers (customer_id) -- Links to customers table
);

-- Table for olist_order_items_dataset.csv
CREATE TABLE order_items (
    order_id TEXT,          -- Links to the specific order
    order_item_id INTEGER,  -- Sequence number for item within the order (1, 2, 3...)
    product_id TEXT,        -- Links to the specific product
    seller_id TEXT,         -- Links to the specific seller
    shipping_limit_date TEXT,
    price REAL,             -- Price of this single item
    freight_value REAL,     -- Freight value for this single item
    PRIMARY KEY (order_id, order_item_id), -- Composite key: order_id + item_id uniquely identifies the row
    FOREIGN KEY (order_id) REFERENCES orders (order_id),
    FOREIGN KEY (product_id) REFERENCES products (product_id),
    FOREIGN KEY (seller_id) REFERENCES sellers (seller_id) -- Links to sellers table
);

-- Table for olist_order_payments_dataset.csv
CREATE TABLE order_payments (
    order_id TEXT,              -- Links to the specific order
    payment_sequential INTEGER, -- Sequence number for payment method within the order (if multiple methods used)
    payment_type TEXT,
    payment_installments INTEGER, -- Number of installments for credit card payments
    payment_value REAL,         -- Value of this specific payment transaction
    PRIMARY KEY (order_id, payment_sequential), -- Composite key: order_id + sequence uniquely identifies the row
    FOREIGN KEY (order_id) REFERENCES orders (order_id) -- Links to orders table
);

-- Table for olist_order_reviews_dataset.csv
CREATE TABLE order_reviews (
    review_id TEXT PRIMARY KEY, -- Unique identifier for the review itself (though sometimes composite keys on order_id are used)
    order_id TEXT,              -- Links to the specific order being reviewed
    review_score INTEGER,       -- Score from 1 to 5
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TEXT,
    review_answer_timestamp TEXT,
    FOREIGN KEY (order_id) REFERENCES orders (order_id) -- Links to orders table
);

