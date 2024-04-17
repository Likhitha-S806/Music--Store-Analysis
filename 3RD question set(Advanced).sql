
/* QUESTION  Set 3 - Advance */

/* Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent */
WITH best_selling_artist AS (
	SELECT artist.artist_id, artist.name AS artist_name, 
    SUM(invoice_line.unit_price*invoice_line.quantity) AS Total_Sales
	FROM invoice_line
	JOIN track ON track.track_id = invoice_line.track_id
	JOIN album ON album.album_id = track.album_id
	JOIN artist ON artist.artist_id = album.artist_id
	GROUP BY 1,2
	ORDER BY 3 DESC
	LIMIT 1
)
SELECT c.customer_id, c.first_name, c.last_name, bsa.artist_name, 
SUM(il.unit_price*il.quantity) AS Total_Spent
FROM invoice i
JOIN customer c ON c.customer_id = i.customer_id
JOIN invoice_line il ON il.invoice_id = i.invoice_id
JOIN track t ON t.track_id = il.track_id
JOIN album alb ON alb.album_id = t.album_id
JOIN best_selling_artist bsa ON bsa.artist_id = alb.artist_id
GROUP BY 1,2,3,4
ORDER BY 5 DESC;


/* Q2: We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */

WITH most_popular_genre AS (
SELECT customer.country AS Country, COUNT(invoice_line.quantity) AS Purchases, 
genre.genre_id AS Genre_ID, genre.name AS Genre_Name, 
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS Row_No 
FROM customer
JOIN invoice ON invoice.customer_id = invoice.invoice_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id = track.genre_id
GROUP BY Country, genre. genre_id, genre. name
ORDER BY Country, Purchases DESC
)
SELECT Country, Purchases, Genre_id, Genre_Name
FROM most_popular_genre WHERE Row_No <= 1;


WITH most_popular_genre AS(
SELECT customer.country AS Country, COUNT(invoice_line.quantity) AS Purchases, 
genre.genre_id AS Genre_ID, genre.name AS Genre_Name,
ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) as Row_No
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
JOIN invoice_line ON invoice_line.invoice_id = invoice.invoice_id
JOIN track ON track.track_id = invoice_line.track_id
JOIN genre ON genre.genre_id= track.genre_id
GROUP BY Country, genre.genre_id, genre.name
ORDER BY Country, Purchases DESC
)
SELECT Country, Purchases, Genre_ID, Genre_Name
FROM most_popular_genre WHERE Row_No <=1; 

/* Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */


WITH Customter_with_country AS 
(
SELECT customer.customer_id, customer.first_name, customer.last_name, 
invoice.billing_country AS Country, SUM(invoice.total) AS total_spent,
ROW_NUMBER() OVER(PARTITION BY invoice.billing_country ORDER BY SUM(invoice.total) DESC) AS Row_No 
FROM customer
JOIN invoice ON invoice.customer_id = customer.customer_id
GROUP BY 1,2,3,4
ORDER BY 4 ASC ,5 DESC
)
SELECT*FROM Customter_with_country 
WHERE Row_No <= 1;