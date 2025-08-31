--A.Data Retrieval & Filtering
--1. Retrieve all details of every book in the inventory.
	select * from books;
--2. List the name, author, and price of each book available.

	select title,author,price
	from books;
--3. Display the titles of books that are considered expensive according to
--company standards (above a certain price threshold).

	select title,price
	from books 
	where price > 50;
--4. Identify books that are currently out of stock.

	select title 
	from books
	where stock = 0;
	
--5. Find the top 10 most expensive books in the catalog.

	select title,price
	from books
	order by price desc
	limit 10;
--6. Retrieve the five oldest books based on their publication year.

	select title,publication_year
	from books
	order by publication_year
	limit 5;
--7. Find books that have not yet been rated by customers.

	select title , rating
	from books
	where rating is null
--8. Show books where the publisher’s information is available.

	select title,publisher
	from books
	WHERE Publisher IS NOT NULL;

--B.Working with Operators
--1. Display each book’s title, its listed price, and the price after applying a 10%
--tax.
	select title,price,
    price*1.10 AS price_tax
	from books;
--2. Identify books with a high page count but still priced affordably.

	select title,pages,price
	from books
	where price < 30
	order by pages desc;
--3. Find books whose rating is different from the highest possible score.

	SELECT *
	FROM Books
	WHERE Rating < (SELECT MAX(Rating) FROM Books);
--4. Retrieve books that are either not in English or are offered in a digital format.
	
	select title,language,format
	from books
	where language <> 'English' OR format = 'eBook';
--C.Pattern Matching & Range Filtering
--1. List books whose titles include a certain keyword, regardless of case.
	SELECT 
    title
	FROM Books
	WHERE title ILIKE '%sky';
--2. Identify authors whose last names start with a specific two-letter prefix.
--Bookstore Inventory Management – SQL Fundamentals Case Study 2
	select title,author
	from books
	where author ILIKE '%Ma%'
--3. Find all books that fall under a selected set of genres.
	SELECT title,genre
	from books
	where genre = 'Biography';
--4. Retrieve books whose prices are within a specified range.
	select title,PRICE
	from books
	where price BETWEEN 30 AND 50
	ORDER BY price desc;
--5. List books published outside of a given year range.
	SELECT title,publication_year
	FROM books
	WHERE publication_year BETWEEN 2001 AND 2025
	ORDER BY publication_year DESC;

--D.Identifying Unique Values
--1. Provide a list of all unique genres available in the catalog.
	Select DISTINCT genre
	from books;
--2. Determine how many unique authors are represented in the database.
	select DISTINCT author
	from books;
--E.Aggregate Calculations
--1. Calculate the total number of books in the inventory.
	select sum(stock) as total_no_of_books
	from books
--2. Determine the average book price.
	select avg(price) as avg_price
	from books;
--3. Find the highest and lowest page counts among all books.
	select MIN(pages) as min_page,MAX(pages) as max_page
	from books;
--4. Calculate the average customer rating for all rated books.
	select avg(rating)
	from books;
--5. Compute the total value of the current stock, based on price and quantity
--available.
	SELECT 
    SUM(price * stock) AS total_stock_value
	FROM Books;
--F.Categorising with CASE
--1. Categorize books into price bands such as “Budget”, “Standard”, or “Premium”
--based on pricing rules.
	select price,
		CASE 
		 WHEN price BETWEEN 50 AND 60 THEN 'Premium' 
		 WHEN price BETWEEN 30 AND 50 THEN 'Standard'
		else 
			'Budget'
		END
	from books;	
		
--2. Classify books as “Out of Stock”, “Low Stock”, or “In Stock” based on available
--quantity.
	SELECT title,
	CASE
		when stock > 50 THEN 'In Stock'
		WHEN stock BETWEEN 1 AND 50 THEN 'Low Stock'
		ELSE 
			'Out of Stock'
		END	as Stock_detail
	FROM books;		
--3. Group books into “Classic”, “Old”, “Recent”, or “New” categories depending on
--publication year.

	SELECT title,
	CASE 
		WHEN publication_year > 2020 THEN 'New'
		WHEN publication_year BETWEEN 2000 AND 2020 THEN 'Recent'
		WHEN publication_year BETWEEN 1900 AND 2000 THEN 'Old'
		ELSE
			 'Classic'
		END	
	From books;	
--G.Applying Built-in Functions
--1. For a set of books, display the title, the author in uppercase, the title length,
--the first three characters of the ISBN, and a combined label containing the
--author and title.
	SELECT title,
		LENGTH(title),
		UPPER(author),
		LEFT(ISBN,3),
		CONCAT(author,' ',title)
	From books;	
--Bookstore Inventory Management – SQL Fundamentals Case Study 3
--2. Show the rounded, ceiling, and floor values of book prices along with the year
--the book was added to the catalog.

	SELECT 
    title,
    price,
    ROUND(price, 0)   AS rounded_price,
    CEILING(price)    AS ceiling_price,
    FLOOR(price)      AS floor_price,
    DATE_PART('year', date_added::date) AS year_added
FROM books;
--3. Replace missing ratings with zero and missing publisher names with
--“Unknown” for display purposes.
	 select coalesce(rating,0) as new_rating,coalesce(publisher,'Unknown')as unknown_publisher
	 from books;
--H.Combining Results with UNION
--1. Merge the list of all books in the two selected genres without duplicates.
	SELECT title, author, genre
	FROM books
	WHERE genre = 'Self-Help'

	UNION

	SELECT title, author, genre
	FROM books
	WHERE genre = 'Sci-Fi';
--2. Merge the list of all books in the two selected genres while retaining
--duplicates.
	SELECT title, author, genre
	FROM books
	WHERE genre = 'Self-Help'

	UNION ALL

	SELECT title, author, genre
	FROM books
	WHERE genre = 'Sci-Fi';
--3. Combine books that are priced very low with books that have very high stock
--levels.
	select title, author, price, stock
	from books
	where price < 10
	UNION
	select title, author, price, stock
	from books
	where stock > 100
--4. Merge recent publications with books that have exceptionally high customer
--ratings.
	SELECT title, author,publication_year , rating, 'Recent Publication' AS category
	FROM books
	WHERE publication_year >= 2020

	UNION

	SELECT title, author, publication_year, rating, 'High Rating' AS category
	FROM books
	WHERE rating >= 4.8;
--5. Merge lists of very low-priced and very high-priced books, then show the
--most expensive results from the combined list.


--I.Mixed Practical Queries
--1. List the top five longest books written in English.
	SELECT title,LENGTH(title) as len_title
	from books
	group by title
	having LENGTH(title)>5
	order by len_title
	limit 5;
--2. Find books with particularly long titles, based on character count.
	select title,
	length(title) as title_length
	from books
	WHERE LENGTH(title) > 20   -- threshold for "long" title
	ORDER BY title_length DESC;
--3. Identify books where the ISBN ends with a specific digit.
	select title,isbn
	from books
	where ISBN ILIKE '%5';
--4. Retrieve books added to the catalog in the most recent two years.
	Select title 
	from books
	where publication_year >2023;
--5. Apply a discount to all Romance genre books and show the adjusted price.
	select title,genre,price,
	price*(1-0.10) as discount_price
	from books
	where genre = 'Romance';
	