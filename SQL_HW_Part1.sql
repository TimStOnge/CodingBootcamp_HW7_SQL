-- SQL HW
-- Tim St. Onge



-- PART 1 ----------------------------------------------------------
USE sakila;

-- 1a Display the first and last names of all actors from the table actor.
SELECT
	first_name AS "First Name",
    last_name AS "Last Name"
FROM
	actor;


-- 1b Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name.
SELECT
	CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS "Actor Name"
FROM
	actor;
    
    
-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only
-- the first name, "Joe." What is one query would you use to obtain this information?
SELECT
	actor_id AS "Actor ID",
    first_name AS "First Name",
    last_name AS "Last Name"
FROM actor
WHERE first_name = "Joe";


-- 2b. Find all actors whose last name contain the letters GEN:
SELECT
	first_name AS "First Name",
    last_name AS "Last Name"
FROM actor
WHERE last_name LIKE '%GEN%';
    
    
-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
SELECT
	first_name AS "First Name",
    last_name AS "Last Name"
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;


-- 2d. Using IN, display the country_id and country columns of the following countries:
-- Afghanistan, Bangladesh, and China:
SELECT
	country_id AS "Country ID",
    country AS "Country"
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');


-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a
-- description, so create a column in the table actor named description and use the data type BLOB
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD description BLOB;


-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort.
-- Delete the description column.
ALTER TABLE actor
DROP description;


-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT
	last_name AS "Last Name",
    count(last_name) AS "Count of Last Name"
FROM
	actor
    GROUP BY last_name;
    
    
-- 4b. List last names of actors and the number of actors who have that last name,
-- but only for names that are shared by at least two actors
SELECT
	last_name AS "Last Name",
    count(last_name) AS "Count of Last Name"
FROM
	actor
GROUP BY last_name
HAVING count(last_name) > 1;


-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS.
-- Write a query to fix the record.
UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO"
AND last_name = "WILLIAMS";

SELECT * FROM actor WHERE first_name = "GROUCHO";


-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name
-- after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO";

SELECT * FROM actor WHERE first_name = "GROUCHO";


-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
-- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
CREATE SCHEMA address;


-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member.
-- Use the tables staff and address:
SELECT
	s.first_name,
    s.last_name,
    a.address
FROM
	address a
	INNER JOIN staff s
  ON s.address_id = a.address_id;
  
  
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005.
-- Use tables staff and payment.
SELECT
	s.first_name AS "First Name",
	s.last_name AS "Last Name",
    sum(p.amount) AS "Total Amount ($)"
FROM
	payment p
	INNER JOIN staff s
  ON s.staff_id = p.staff_id
  WHERE payment_date >= '2005-08-01' AND payment_date < '2008-09-01'
  GROUP BY s.staff_id;


-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film.
-- Use inner join.
SELECT
	f.title  AS "Title",
    count(fa.actor_id) AS "Number of Actors"
FROM
	film_actor fa
	INNER JOIN film f
    ON fa.film_id = f.film_id
    GROUP By f.title;
    
    
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
-- find id where title is hunchback, then link to inventory and find count of that id
SELECT
    Count(i.film_id) AS "Number of Copies"
FROM
	inventory i
WHERE
	i.film_id =
(
SELECT film_id
FROM film f
WHERE title = "Hunchback Impossible");


-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- List the customers alphabetically by last name:
SELECT
	c.first_name AS "First Name",
    c.last_name AS "Last Name",
    SUM(p.amount) AS "Total Paid ($)"
FROM customer c
INNER JOIN payment p
  ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;


-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT
	f.title AS "Movie Title"
FROM
	film f
WHERE
	f.title IN
	(SELECT f.title
	FROM film f
	WHERE f.title LIKE 'K%' OR f.title LIKE 'Q%')
    AND
    f.language_id = (SELECT l.language_id FROM language l WHERE l.name = "English");
    
    
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT
	a.first_name AS "First Name",
    a.last_name AS "Last Name"
FROM actor a
WHERE a.actor_id IN
(SELECT fa.actor_id
FROM film_actor fa
WHERE fa.film_id =
(SELECT f.film_id
FROM film f
WHERE f.title = "ALONE TRIP"));


-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and
-- email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT
	c.first_name AS "First Name",
    c.last_name AS "Last Name",
    c.email AS "Email Address"
FROM
	customer c
	INNER JOIN address a
  ON c.address_id = a.address_id
  INNER JOIN city ci
  ON a.city_id = ci.city_id
  INNER JOIN country co
  ON ci.country_id = co.country_id
  WHERE country = "Canada";
  
  
-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as family films.
SELECT
	f.title AS "Film Title"
FROM film f
	INNER JOIN film_category fc
  ON f.film_id = fc.film_id
  INNER JOIN category ca
  ON fc.category_id = ca.category_id
  WHERE ca.name = "Family";
  
  
-- 7e. Display the most frequently rented movies in descending order.
SELECT
	f.title AS "Film Title",
	COUNT(r.rental_id) AS "Number of Rents"
FROM film f
  INNER JOIN inventory i
  ON f.film_id = i.film_id
  INNER JOIN rental r
  ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC;


-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT
	store.store_id AS "Store ID",
    SUM(p.amount) AS "Total Business ($)"
	FROM store
    INNER JOIN staff
    ON store.store_id = staff.store_id
  INNER JOIN payment p
  ON staff.staff_id = p.staff_id
    GROUP BY store.store_id;


-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id AS "Store ID",
ci.city AS "City",
co.country AS "Country"
FROM store s
  INNER JOIN address a
  ON s.address_id = a.address_id
  INNER JOIN city ci
  ON a.city_id = ci.city_id
  INNER JOIN country co
  ON ci.country_id = co.country_id;


-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT 
	c.name AS "Category",
    SUM(p.amount)
   -- AS "TOTAL"
FROM category c
  INNER JOIN film_category fc
  ON c.category_id = fc.category_id
  INNER JOIN inventory i
  ON fc.film_id = i.film_id
  INNER JOIN rental r
  ON i.inventory_id = r.inventory_id
  INNER JOIN payment p
  ON r.rental_id = p.rental_id
  GROUP BY c.name
  ORDER BY SUM(p.amount) DESC limit 5;


-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres
-- by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h,
-- you can substitute another query to create a view.
CREATE VIEW top_five_genres AS
SELECT 
	c.name AS "Category",
    SUM(p.amount)
FROM category c
  INNER JOIN film_category fc
  ON c.category_id = fc.category_id
  INNER JOIN inventory i
  ON fc.film_id = i.film_id
  INNER JOIN rental r
  ON i.inventory_id = r.inventory_id
  INNER JOIN payment p
  ON r.rental_id = p.rental_id
  GROUP BY c.name
  ORDER BY SUM(p.amount) DESC limit 5;
  
  
-- 8b. How would you display the view that you created in 8a?  
SELECT * FROM top_five_genres;


-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;



