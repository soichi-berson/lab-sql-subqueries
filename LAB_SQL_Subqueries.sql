-- Lab | SQL Subqueries

USE sakila;

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.


SELECT COUNT(DISTINCT i.inventory_id) FROM inventory AS i
LEFT JOIN film AS f
ON i.film_id = f.film_id
WHERE f.title = "Hunchback Impossible";      --  answer : 6 --

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
SELECT * FROM film AS f
WHERE f.length >= (SELECT AVG(length) FROM film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip". 

SELECT first_name, last_name FROM actor
WHERE actor_id in (SELECT actor_id FROM film_actor As f_a
JOIN film AS f
ON f_a.film_id = f.film_id
WHERE f.title = "Alone Trip");

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films.
SELECT * FROM film AS f
WHERE f.title in (SELECT f.title FROM film AS f
LEFT JOIN film_category As f_c
On f.film_id = f_c.film_id
LEFT JOIN category As c
ON c.category_id = f_c.category_id
WHERE c.name = 'family');



-- 5 Retrieve the name and email of customers from Canada using both subqueries and joins. 
-- To use joins, you will need to identify the relevant tables and their primary and foreign keys.

SELECT sub1.first_name, sub1.last_name, sub1.email 
FROM (SELECT c.first_name, c.last_name, c.email, co.country FROM customer As c
JOIN address As a
ON c.address_id = a.address_id
JOIN city AS ci
ON a.city_id = ci.city_id
JOIN country AS co
ON ci.country_id = co.country_id) AS sub1
WHERE sub1.country = 'Canada';


-- 6. Determine which films were starred by the most prolific actor in the Sakila database.
--  A prolific actor is defined as the actor who has acted in the most number of films. First, you will need 
-- to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

SELECT f.title FROM film AS f
JOIN film_actor AS f_a
ON f.film_id = f_a.film_id
JOIN (SELECT f_a.actor_id, COUNT(f_a.film_id) AS 'the_number_of_films' FROM film_actor AS f_a
GROUP BY f_a.actor_id 
ORDER BY COUNT(f_a.film_id) DESC) AS sub1
ON f_a.actor_id = sub1.actor_id
GROUP BY f.film_id
ORDER BY sum(sub1.the_number_of_films) DESC
LIMIT 1;     -- LAMBS CINCINATTI--

-- 7 Find the films rented by the most profitable customer in the Sakila database. 
-- You can use the customer and payment tables to find the most profitable customer, i.e., 
-- the customer who has made the largest sum of payments.

SELECT f.title
FROM film AS f
JOIN inventory AS i 
ON f.film_id = i.film_id
JOIN rental AS r 
ON i.inventory_id = r.inventory_id
JOIN payment p 
ON r.rental_id = p.rental_id
WHERE p.customer_id = (
    SELECT customer_id
    FROM payment
    GROUP BY customer_id
    ORDER BY SUM(amount) DESC
    LIMIT 1
);


-- 8 Retrieve the client_id and the total_amount_spent of those clients who spent more than 
-- the average of the total_amount spent by each client. You can use subqueries to accomplish this.

SELECT * FROM (
SELECT customer_id AS 'client _id', sum(amount) AS total_amount_spent
FROM payment
GROUP BY customer_id
) AS sub1
Where sub1.total_amount_spent > ( SELECT 
AVG(amount) FROM payment);


