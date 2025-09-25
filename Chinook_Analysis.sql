USE chinook;
-- Objective Question 1 
-- Does any table have missing values or duplicates? 
SELECT * FROM album;
SELECT * FROM artist;
SELECT * FROM customer;
SELECT * FROM employee;
SELECT * FROM genre;
SELECT * FROM invoice;
SELECT * FROM invoice_line; 
SELECT * FROM media_type; 
SELECT * FROM playlist; 
SELECT * FROM playlist_track; 
SELECT * FROM track; 

-- verifying the album table's missing values : 
SELECT * FROM album 
WHERE album_id IS NULL 
OR title IS NULL 
OR artist_id IS NULL; -- no missing values found 

-- verifying for duplicate values : 
SELECT 
  album_id, 
  title, 
  artist_id, 
  COUNT(*) AS totsl_count 
FROM album 
GROUP BY album_id, title, artist_id 
HAVING COUNT(*) > 1; -- no duplicate values found 

-- Verifying for missing values in artist : 
SELECT * FROM artist WHERE artist_id IS NULL 
OR name IS NULL; -- no missing values found 

-- verifying for duplicate values : 
SELECT 
  artist_id, 
  name,
  COUNT(*) AS total_count 
FROM artist 
GROUP BY artist_id, name 
HAVING COUNT(*) > 1; -- no duplicate values found

-- Verifying for missing values in customer : 
SELECT * FROM customer
WHERE customer_id IS NULL
OR first_name IS NULL
OR last_name IS NULL
OR company IS NULL
OR address IS NULL
OR city IS NULL
OR state IS NULL
OR country IS NULL
OR postal_code IS NULL
OR phone IS NULL
OR fax IS NULL
OR email IS NULL
OR support_rep_id IS NULL; -- missing values found 

-- Verifying for duplicate values : 
SELECT *, 
 COUNT(*) AS total_count 
FROM customer 
GROUP BY customer_id, email 
HAVING COUNT(*) > 1;   -- no duplicate values found 

-- Verifying missing values for employee :
SELECT * FROM employee
WHERE employee_id IS NULL
OR last_name IS NULL
OR first_name IS NULL
OR title IS NULL
OR reports_to IS NULL
OR birthdate IS NULL
OR hire_date IS NULL
OR address IS NULL
OR city IS NULL
OR state IS NULL
OR country IS NULL
OR postal_code IS NULL
OR phone IS NULL
OR fax IS NULL
OR email IS NULL;   -- missing values found 

-- Verifying for duplicate values : 
SELECT *, 
 COUNT(*) AS total_count 
FROM employee 
GROUP BY employee_id, email 
HAVING COUNT(*) > 1;   -- no duplicate values found 

-- Verifying missing values for genre : 
SELECT * FROM genre WHERE genre_id IS NULL OR name IS NULL;  -- no missing values found 
-- Verifying for duplicate values : 
SELECT *, 
 COUNT(*) AS total_genre_count 
FROM genre 
GROUP BY genre_id, name 
HAVING COUNT(*) > 1;   -- no duplicate values found 

-- Verifying missing values for invoice : 
SELECT * FROM invoice 
WHERE invoice_id IS NULL 
OR customer_id IS NULL 
OR invoice_date IS NULL 
OR billing_address IS NULL 
OR billing_city IS NULL 
OR billing_state IS NULL 
OR billing_country IS NULL 
OR billing_postal_code IS NULL 
OR total IS NULL;   -- no missing values found 

-- Verifying for duplicate values : 
SELECT *, 
 COUNT(*) AS total_count FROM invoice 
GROUP BY customer_id, invoice_id 
HAVING COUNT(*) > 1;   -- no duplicate values found 

-- Verifying missing values for invoice_line : 
SELECT * FROM invoice_line WHERE invoice_line_id IS NULL 
OR invoice_id IS NULL OR track_id IS NULL OR unit_price IS NULL OR quantity IS NULL;   -- no missing values found 

-- Verifying for duplicate values : 
SELECT *, COUNT(*) AS total_count FROM invoice_line 
GROUP BY invoice_line_id 
HAVING COUNT(*) > 1;   -- no duplicate values found

-- Verifying missing values for media_type : 
SELECT * FROM media_type WHERE media_type_id IS NULL OR name IS NULL;  -- no missing values found 
-- Verifying for duplicate values : 
SELECT *, COUNT(*) AS total_count FROM media_type 
GROUP BY media_type_id, name 
HAVING COUNT(*) > 1;  -- no duplicate values found 

-- Verifying missing values for playlist : 
SELECT * FROM playlist WHERE playlist_id IS NULL OR name IS NULL;  -- no missing values found 
-- Verifying for duplicate values : 
SELECT *, 
 COUNT(*) AS total_count FROM playlist 
GROUP BY playlist_id, name 
HAVING COUNT(*) > 1;    -- no duplicate values found

-- Verifying missing values for playlist_track : 
SELECT * FROM playlist_track WHERE playlist_id IS NULL OR track_id IS NULL;  -- no missing values found 
-- Verifying for duplicate values : 
SELECT *, COUNT(*) AS total_count FROM playlist_track 
GROUP BY playlist_id, track_id 
HAVING COUNT(*) > 1;   -- no duplicate values found

-- Verifying missing values for track : 
SELECT * FROM track
WHERE track_id is null
OR name IS NULL
OR album_id IS NULL
OR media_type_id IS NULL
OR genre_id IS NULL
OR composer IS NULL
OR milliseconds IS NULL
OR bytes IS NULL
OR unit_price IS NULL;  -- missing values found 

-- Verifying for duplicate values : 
SELECT *, COUNT(*) AS total_count FROM track 
GROUP BY track_id, unit_price 
HAVING COUNT(*) > 1;   -- no duplicate values found 

-- Handling Missing Values : 
SET SQL_SAFE_UPDATES = 0;
UPDATE customer SET company = 'Unknown' WHERE company IS NULL;  
UPDATE customer SET state = 'None' WHERE state IS NULL; 
UPDATE customer SET phone = '+0 000 000 0000' WHERE phone IS NULL;
UPDATE customer SET fax = '+0 000 000 0000' WHERE fax IS NULL;
UPDATE customer SET postal_code = '0' WHERE postal_code IS NULL;
UPDATE employee SET reports_to ='0' WHERE reports_to IS NULL;
UPDATE track SET composer = 'Unknown' WHERE composer IS NULL;

-- Objective Question 2 
-- Find the top-selling tracks and top artist in the USA and identify their most famous genres.  
-- Query to break down both volume and revenue wise
SELECT 
    t.name AS top_selling_track,
    ar.name AS top_artist,
    g.name AS top_genre,
    SUM(il.quantity) AS total_copies_sold,            
    SUM(il.quantity * il.unit_price) AS total_revenue 
FROM invoice_line il
JOIN track t ON il.track_id = t.track_id
JOIN album a ON t.album_id = a.album_id
JOIN artist ar ON a.artist_id = ar.artist_id
JOIN genre g ON t.genre_id = g.genre_id
JOIN invoice i ON il.invoice_id = i.invoice_id
WHERE i.billing_country = 'USA'
GROUP BY t.track_id, t.name, ar.name, g.name
ORDER BY total_revenue DESC   
LIMIT 10;

-- Objective Question 3 
-- What is the customer demographic breakdown (age, gender, location) of Chinook's customer base? 
-- Query to break down customers country wise: 
SELECT 
    country,
    COUNT(*) AS total_customers
FROM customer
GROUP BY country
ORDER BY total_customers DESC; 

-- Query to break down customers city wise:
SELECT 
    country,
    city,
    COUNT(*) AS total_customers
FROM customer
GROUP BY country, city
ORDER BY total_customers DESC; 

-- Objective Question 4 
-- Calculate the total revenue and number of invoices for each country, state, and city:
SELECT 
    billing_country AS country,
    billing_state AS state,
    billing_city AS city,
    COUNT(invoice_id) AS number_of_invoices,
    SUM(total) AS total_revenue
FROM invoice
GROUP BY billing_country, billing_state, billing_city
ORDER BY total_revenue DESC;

-- Objective Question 5
-- Find the top 5 customers by total revenue in each country 
WITH cte1 AS (
    SELECT 
        c.country,
        c.first_name,
        c.last_name,
        SUM(t.unit_price * il.quantity) AS total_revenue
    FROM customer c
    INNER JOIN invoice i ON i.customer_id = c.customer_id
    INNER JOIN invoice_line il ON il.invoice_id = i.invoice_id
    INNER JOIN track t ON t.track_id = il.track_id
    GROUP BY c.country, c.first_name, c.last_name
),
cte2 AS (
    SELECT 
        country,
        first_name,
        last_name,
        total_revenue,
        RANK() OVER (PARTITION BY country ORDER BY total_revenue DESC) AS rnk
    FROM cte1
)
SELECT 
    country,
    concat(first_name, ' ', last_name) as customer_name,
    total_revenue
FROM cte2
WHERE rnk <= 5
ORDER BY country, rnk;

-- Objective Question 6
-- Identify the top-selling track for each customer 
WITH cus_track_rank AS (
    SELECT 
        t.track_id,
        t.name AS track_name,
        c.customer_id,
        CONCAT(c.first_name, " ", c.last_name) AS customer_name,
        SUM(il.quantity) AS total_quantity,
        ROW_NUMBER() OVER(PARTITION BY c.customer_id ORDER BY SUM(il.quantity) DESC) AS row_rnk
    FROM track t
    JOIN invoice_line AS il 
    ON t.track_id = il.track_id
    JOIN invoice AS i 
    ON il.invoice_id = i.invoice_id
    JOIN customer AS c 
    ON i.customer_id = c.customer_id
    GROUP BY c.customer_id, customer_name, t.track_id, t.name
)
SELECT customer_id, customer_name, track_id, track_name, total_quantity
FROM cus_track_rank
WHERE row_rnk = 1
ORDER BY total_quantity desc;

-- Objective Question 7 
-- Are there any patterns or trends in customer purchasing behavior 
-- (e.g., frequency of purchases, preferred payment methods, average order value)?
-- Query for calculating Frequency of Purchase 
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(i.invoice_id) AS total_orders
FROM customer c
LEFT JOIN invoice i ON c.customer_id = i.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY total_orders DESC; 

-- Query for calculating Average Order Value 
SELECT 
    c.customer_id,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
    COUNT(i.invoice_id) AS total_orders,
    ROUND(SUM(i.total),2) AS total_spent,
    ROUND(AVG(i.total),2) AS avg_order_value
FROM customer AS c
JOIN invoice AS i 
ON c.customer_id = i.customer_id
GROUP BY c.customer_id, customer_name
ORDER BY avg_order_value DESC;

-- Objective Question 8 
-- What is the customer churn rate? 
-- Query for calculating Customer Churn Rate :
WITH last_purchase AS (
    SELECT 
        customer_id, 
        MAX(invoice_date) AS last_order_date
    FROM invoice
    GROUP BY customer_id
),
churned_customers AS (
    SELECT 
        COUNT(customer_id) AS churned_count
    FROM last_purchase
    WHERE last_order_date < DATE_SUB('2020-12-30', INTERVAL 6 MONTH)
),
total_customers AS (
    SELECT COUNT(DISTINCT customer_id) AS total_count FROM customer
)
SELECT 
    (c.churned_count / t.total_count) * 100 AS churn_rate
FROM churned_customers c, total_customers t;
    
-- Objective Question 9 
-- Calculate the percentage of total sales contributed by each genre in the USA and identify the best-selling genres and artists. 
    WITH genre_sales AS (
    SELECT 
        g.name AS genre_name,
        SUM(il.unit_price * il.quantity) AS genre_revenue
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    WHERE i.billing_country = 'USA'
    GROUP BY g.name
),
artist_sales AS (
    SELECT 
        ar.name AS artist_name,
        g.name AS genre_name,
        SUM(il.unit_price * il.quantity) AS artist_revenue
    FROM invoice i
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN album al ON t.album_id = al.album_id
    JOIN artist ar ON al.artist_id = ar.artist_id
    JOIN genre g ON t.genre_id = g.genre_id
    WHERE i.billing_country = 'USA'
    GROUP BY ar.name, g.name
)
SELECT 
    gs.genre_name,
    ROUND(gs.genre_revenue * 100 / (SELECT SUM(genre_revenue) FROM genre_sales), 2) AS genre_percentage,
    (SELECT artist_name 
     FROM artist_sales a 
     WHERE a.genre_name = gs.genre_name 
     ORDER BY a.artist_revenue DESC 
     LIMIT 1) AS top_artist
FROM genre_sales gs
ORDER BY genre_percentage DESC;

-- Objective Question 10 
-- Find customers who have purchased tracks from at least 3 different genres
WITH customer_genres AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        COUNT(DISTINCT g.genre_id) AS genre_count
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN genre g ON t.genre_id = g.genre_id
    GROUP BY c.customer_id, customer_name
)
SELECT 
    customer_id,
    customer_name,
    genre_count
FROM customer_genres
WHERE genre_count >= 3
ORDER BY genre_count DESC;

-- Objective Question 11 
-- Rank genres based on their sales performance in the USA
SELECT 
    g.name AS genre_name,
    SUM(il.unit_price * il.quantity) AS total_sales,
    RANK() OVER (ORDER BY SUM(il.unit_price * il.quantity) DESC) AS sales_rank
FROM invoice i
JOIN invoice_line il ON i.invoice_id = il.invoice_id
JOIN track t ON il.track_id = t.track_id
JOIN genre g ON t.genre_id = g.genre_id
WHERE i.billing_country = 'USA'
GROUP BY g.name
ORDER BY total_sales DESC;

-- Objective Question 12 
-- Identify customers who have not made a purchase in the last 3 months
WITH inactive_customers AS (
    SELECT 
        c.customer_id,
        c.first_name,
        c.last_name,
        MAX(i.invoice_date) AS last_purchase_date,
        SUM(i.total) AS total_revenue
    FROM customer c
    LEFT JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
    HAVING MAX(i.invoice_date) < DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
)

SELECT *
FROM inactive_customers;

-- Subjective Question 1 
-- Recommend the three albums from the new record label that should be prioritised for advertising 
-- and promotion in the USA based on genre sales analysis. 
WITH RecommendedAlbums AS (
    SELECT
        al.title AS album_name,
        a.name AS artist_name,
        g.name AS genre_name,
        SUM(il.unit_price * il.quantity) AS total_sales,
        SUM(il.quantity) AS total_quantity,
        DENSE_RANK() OVER(ORDER BY SUM(il.unit_price * il.quantity) DESC) AS sales_rank
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    JOIN track t ON il.track_id = t.track_id
    JOIN album al ON t.album_id = al.album_id
    JOIN artist a ON al.artist_id = a.artist_id
    JOIN genre g ON t.genre_id = g.genre_id
    WHERE c.country = 'USA'
    GROUP BY al.title, a.name, g.name
)
SELECT *
FROM RecommendedAlbums
WHERE sales_rank <= 3
ORDER BY total_sales DESC;

-- Subjective Question 2 
-- Determine the top-selling genres in countries other than the USA and identify any commonalities or differences.
SELECT
    i.billing_country,
    g.name AS genre_name,
    SUM(il.unit_price*il.quantity) AS total_sales
FROM invoice_line il
JOIN track t ON t.track_id = il.track_id
JOIN genre g ON g.genre_id = t.genre_id
JOIN invoice i ON i.invoice_id = il.invoice_id
WHERE i.billing_country != 'USA'
GROUP BY i.billing_country, g.name
ORDER BY i.billing_country, total_sales DESC;

-- Subjective Question 3 
-- Customer Purchasing Behavior Analysis: 
-- How do the purchasing habits (frequency, basket size, spending amount) of long-term customers differ 
-- from those of new customers? What insights can these patterns provide about customer loyalty and retention strategies? 
WITH CustomerMetrics AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        MIN(DATE(i.invoice_date)) AS first_purchase_date,
        MAX(DATE(i.invoice_date)) AS last_purchase_date,
        COUNT(DISTINCT i.invoice_id) AS purchase_frequency,
        ROUND(AVG(il.quantity), 0) AS avg_basket_size,
        ROUND(AVG(i.total), 2) AS avg_spending_amount,
        DATEDIFF(MAX(i.invoice_date), MIN(i.invoice_date)) AS tenure_days,
        CASE 
            WHEN DATEDIFF(MAX(i.invoice_date), MIN(i.invoice_date)) > 1000 THEN 'Long Term'
            ELSE 'New'
        END AS customer_type
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    GROUP BY c.customer_id, customer_name
)
SELECT *
FROM CustomerMetrics
ORDER BY customer_id;

-- Subjective Question 4 
-- Product Affinity Analysis: Which music genres, artists, or albums are frequently purchased together by customers? 
-- How can this information guide product recommendations and cross-selling initiatives? 
-- Genre Co-Purchases
SELECT 
    g1.name AS genre_1, 
    g2.name AS genre_2, 
    COUNT(*) AS times_bought_together
FROM invoice_line AS il1
JOIN invoice_line AS il2 
ON il1.invoice_id = il2.invoice_id 
AND il1.track_id <> il2.track_id
JOIN track AS t1 
ON il1.track_id = t1.track_id
JOIN track AS t2 
ON il2.track_id = t2.track_id
JOIN genre AS g1 
ON t1.genre_id = g1.genre_id
JOIN genre AS g2 
ON t2.genre_id = g2.genre_id
GROUP BY genre_1, genre_2
ORDER BY times_bought_together DESC
LIMIT 10;
-- Artist Co-Purchases 
SELECT 
    ar1.name AS artist_1, 
    ar2.name AS artist_2, 
    COUNT(*) AS times_bought_together
FROM invoice_line AS il1
JOIN invoice_line AS il2 
ON il1.invoice_id = il2.invoice_id 
AND il1.track_id <> il2.track_id
JOIN track AS t1 
ON il1.track_id = t1.track_id
JOIN track AS t2 
ON il2.track_id = t2.track_id
JOIN album AS al1 
ON t1.album_id = al1.album_id
JOIN album AS al2 
ON t2.album_id = al2.album_id
JOIN artist AS ar1 
ON al1.artist_id = ar1.artist_id
JOIN artist AS ar2 
ON al2.artist_id = ar2.artist_id
GROUP BY artist_1, artist_2
ORDER BY times_bought_together DESC
LIMIT 10;
-- Album Co-Purchases  
SELECT 
    al1.title AS album_1, 
    al2.title AS album_2, 
    COUNT(*) AS times_bought_together
FROM invoice_line AS il1
JOIN invoice_line AS il2 
ON il1.invoice_id = il2.invoice_id 
AND il1.track_id <> il2.track_id
JOIN track AS t1 
ON il1.track_id = t1.track_id
JOIN track AS t2 
ON il2.track_id = t2.track_id
JOIN album AS al1 
ON t1.album_id = al1.album_id
JOIN album AS al2 
ON t2.album_id = al2.album_id
GROUP BY album_1, album_2
ORDER BY times_bought_together DESC
LIMIT 10;

-- Subjective Question 5 
-- Regional Market Analysis: Do customer purchasing behaviors and churn rates vary across different geographic regions or store locations? 
-- How might these correlate with local demographic or economic factors? 
WITH last_purchase AS (
    SELECT 
        customer_id,
        billing_country AS region,
        MAX(invoice_date) AS last_order_date
    FROM invoice
    GROUP BY customer_id, billing_country
),
dataset_end AS (
    SELECT MAX(invoice_date) AS max_date FROM invoice
)
SELECT 
    l.region, 
    COUNT(DISTINCT l.customer_id) AS total_customers,
    SUM(CASE WHEN l.last_order_date < DATE_SUB(d.max_date, INTERVAL 6 MONTH) THEN 1 ELSE 0 END) AS churned_customers,
    ROUND(
        SUM(CASE WHEN l.last_order_date < DATE_SUB(d.max_date, INTERVAL 6 MONTH) THEN 1 ELSE 0 END) * 100.0 
        / COUNT(DISTINCT l.customer_id), 
    2) AS churn_rate
FROM last_purchase l
CROSS JOIN dataset_end d
GROUP BY l.region
ORDER BY churned_customers DESC; 

-- Subjective Question 6 
-- Customer Risk Profiling: Based on customer profiles (age, gender, location, purchase history), 
-- which customer segments are more likely to churn or pose a higher risk of reduced spending? 
-- What factors contribute to this risk? 
WITH customer_summary AS (
    SELECT 
        c.customer_id,
        c.country,
        COUNT(i.invoice_id) AS total_orders,
        SUM(il.unit_price * il.quantity) AS total_spent,
        MAX(i.invoice_date) AS last_purchase_date,
        DATEDIFF(CURRENT_DATE, MAX(i.invoice_date)) AS days_since_last_purchase
    FROM customer c
    LEFT JOIN invoice i ON c.customer_id = i.customer_id
    LEFT JOIN invoice_line il ON i.invoice_id = il.invoice_id
    GROUP BY c.customer_id, c.country
),
customer_risk AS (
    SELECT 
        customer_id,
        country,
        total_orders,
        total_spent,
        last_purchase_date,
        days_since_last_purchase,
        CASE
            WHEN days_since_last_purchase > 180 THEN 'High Risk'
            WHEN days_since_last_purchase BETWEEN 90 AND 180 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS churn_risk,
        CASE
            WHEN total_spent < 100 THEN 'Low Value'
            WHEN total_spent BETWEEN 100 AND 500 THEN 'Medium Value'
            ELSE 'High Value'
        END AS value_segment
    FROM customer_summary
)
SELECT *
FROM customer_risk
ORDER BY churn_risk DESC, total_spent ASC;

-- Subjective Question 7 
-- Customer Lifetime Value Modeling: How can you leverage customer data (tenure, purchase history, engagement) 
-- to predict the lifetime value of different customer segments? 
-- This could inform targeted marketing and loyalty program strategies. 
-- Can you observe any common characteristics or purchase patterns among customers who have stopped purchasing? 
WITH CustomerMetrics AS (
    SELECT
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        c.country,
        MIN(i.invoice_date) AS first_purchase_date,
        MAX(i.invoice_date) AS last_purchase_date,
        DATEDIFF(MAX(i.invoice_date), MIN(i.invoice_date)) + 1 AS tenure_days,
        COUNT(i.invoice_id) AS purchase_frequency,
        SUM(i.total) AS total_spent,
        ROUND(SUM(i.total) / COUNT(i.invoice_id), 2) AS avg_order_value,
        DATEDIFF(CURRENT_DATE, MAX(i.invoice_date)) AS days_since_last_purchase
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name, c.country
)
SELECT
    customer_id,
    customer_name,
    country,
    tenure_days,
    purchase_frequency,
    total_spent,
    avg_order_value,
    days_since_last_purchase,
    CASE 
        WHEN days_since_last_purchase > 180 THEN 'Churned'
        WHEN days_since_last_purchase > 30 THEN 'At-Risk'
        ELSE 'Active'
    END AS customer_status,       -- Churn segmentation 
    ROUND((total_spent / tenure_days) * 365, 2) AS estimated_clv_1year,
    ROUND(total_spent / tenure_days, 2) AS revenue_per_day     -- Basic CLV estimation
FROM CustomerMetrics
ORDER BY days_since_last_purchase DESC; 

-- Subjective Question 10 
-- How can you alter the "Albums" table to add a new column named "ReleaseYear" of type INTEGER to store the release year of each album? 
ALTER TABLE album
ADD COLUMN release_year INT(4);

-- Subjective Question 11 
-- Chinook is interested in understanding the purchasing behavior of customers based on their geographical location. 
-- They want to know the average total amount spent by customers from each country, 
-- along with the number of customers and the average number of tracks purchased per customer. 
-- Write an SQL query to provide this information.
WITH CustomerPurchases AS (
    SELECT
        c.customer_id,
        c.country,
        SUM(i.total) AS total_spent,
        SUM(il.quantity) AS total_tracks
    FROM customer c
    JOIN invoice i ON c.customer_id = i.customer_id
    JOIN invoice_line il ON i.invoice_id = il.invoice_id
    GROUP BY c.customer_id, c.country
)

SELECT
    country,
    COUNT(customer_id) AS num_customers,
    ROUND(AVG(total_spent), 2) AS avg_total_spent,
    ROUND(AVG(total_tracks), 2) AS avg_tracks_per_customer
FROM CustomerPurchases
GROUP BY country
ORDER BY avg_total_spent DESC; 














	