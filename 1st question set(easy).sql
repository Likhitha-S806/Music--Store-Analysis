/* QUESTIONS Set 1 ( EASY) */

/*Q1: Who is the senior most employee based on job title?  */
SELECT * FROM employee
ORDER BY levels DESC
limit 1

 /* Q2: Which countries have the most Invoices? */
 SELECT COUNT(*) AS C, billing_country
 FROM invoice
 group by billing_country
 order by C DESC
 
 /* Q3: What are top 3 values of total invoice?  */ 
 SELECT total FROM invoice
 order by total DESC
 limit 3
 
 /*Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals. */

SELECT SUM(total) AS total_invoice, billing_city
FROM invoice
group by billing_city
order by total_invoice desc

/* Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
SELECT customer.customer_id, customer.first_name,customer.last_name, SUM(invoice.total) as total
FROM customer
JOIN invoice ON customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total
limit 1

