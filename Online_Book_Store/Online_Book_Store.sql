CREATE DATABASE Online_Book_Store;

CREATE TABLE Books(
Books_ID SERIAL PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(100),
Genre VARCHAR(50),
Published_Year INT,
Price NUMERIC(10,2),
Stock INT
);

CREATE TABLE Customers(
Customer_ID SERIAL PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone VARCHAR(15),
City VARCHAR(50),
Country VARCHAR(150)
);

CREATE TABLE Orders(
Order_ID SERIAL PRIMARY KEY,
Customer_ID INT REFERENCES Customers(Customer_ID),
Book_ID INT REFERENCES Books(BookS_ID),
Order_Date DATE,
Quantity INT,
Total_Amount NUMERIC(10,2)
);

SELECT * FROM BOOKS;
SELECT * FROM CUSTOMERS;
SELECT * FROM ORDERS;


COPY BOOKS(Books_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'C:\Program Files\PostgreSQL\17\Books.csv'
CSV HEADER;

COPY CUSTOMERS(Customer_ID, Name, Email, Phone, City, Country)
FROM 'C:\Program Files\PostgreSQL\17\Customers.csv'
CSV HEADER;

COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'C:\Program Files\PostgreSQL\17\Orders.csv'
CSV HEADER;


--1) Retrive all books in the "Fiction" genre:
		SELECT * FROM Books
		WHERE Genre ='Fiction';

--2) Find books published after the year 1950:
		SELECT * FROM Books
		WHERE Published_Year>1950;

--3) List all customers from Canada:
		SELECT * FROM CUSTOMERS
		WHERE Country ='Canada';

--4) Show orders placed in November 2023:
		SELECT * FROM ORDERS
		WHERE Order_Date 
		BETWEEN '2023-11-01' AND '2023-11-30';

--5) Retrive the total stock of books available:
		SELECT SUM(Stock) AS Total_STOCK FROM Books;

--6) Find the details of the most expensive books:
		SELECT * FROM Books
		ORDER BY Price DESC
		LIMIT 1;

--7) Show all customers who ordered more than 1 quantity of a book:
		SELECT * FROM Orders
		WHERE Quantity>1;
		
--8) Retrive all orders where the total amount exceeds $20:
		SELECT * FROM Orders
		WHERE Total_Amount>20;

--9) List all the genres available in the Books table:
		SELECT DISTINCT Genre FROM Books;

--10) Find the book with the lowest stock:
		SELECT * FROM Books
		ORDER BY Stock ASC
		LIMIT 1;

--11) Calculate the total revenue generated from all orders:
		SELECT  SUM (Total_Amount) 
		AS Total_Revenue
		FROM Orders;


--Advance Question--

--1) Retrive the total number of books sold for each genre:
		SELECT b.genre,SUM (o.quantity) AS Total_Books_Sold
		FROM Orders o
		JOIN Books b
		ON b.books_id=o.book_id
		GROUP BY b.Genre;

--2)Find the average price of books in the "Fantasy" genre:
		SELECT AVG(Price) AS Avg_Price FROM Books
		WHERE GENRE ='Fantasy';

--3) List Customesrs who have placed at least 2 orders:
		SELECT o.customer_id, c.name,COUNT(o.order_id)AS Order_More_than_one
		FROM Orders o
		JOIN Customers c
		ON c.customer_id=o.customer_id
		GROUP BY o.customer_id,c.name
		HAVING count(o.order_id)>1;

--4) Find the most frequently ordered books:
			SELECT Book_id, count(order_id) AS Order_Count
			FROM Orders
			GROUP BY book_id
			ORDER BY Order_Count DESC
			LIMIT 1;

--5) Show the top 3 most expensive books of 'Fantasy' Genre:
		Select * FROM books
		WHERE Genre='Fantasy'
		ORDER BY price DESC
		LIMIT 3;

--6) Retrive the total quantity of books sold by each author:
		SELECT b.author, SUM (o.quantity) AS Total_Sold_By_Each
		FROM Books b
		JOIN Orders o
		ON b.books_id=o.book_id
		GROUP BY b.author;

--7) List the cities where customers who spent over $30 are located:
		SELECT Distinct c.city,o.total_amount  AS City_Spend_over_30
		FROM orders o
		JOIN customers c
		ON o.customer_id=c.customer_id
		WHERE o.total_amount>30;

--8) Find the customer who spent the most on orders:
		SELECT c.customer_id, c.name, SUM(o.total_amount) AS Total_spend
		FROM Customers c
		JOIN Orders o
		ON c.customer_id=o.customer_id
		GROUP BY c.customer_id, c.name
		ORDER BY Total_spend DESC
		LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:
		SELECT b.books_id, b.title,b.stock,  
		COALESCE(SUM(o.quantity),0)  AS Order_quantity, 
		b.stock-  COALESCE(SUM(o.quantity),0) AS Stock_Remaining		
		FROM Books b
		LEFT JOIN Orders o
		ON b.books_id=o.book_id
		GROUP BY b.books_id
		ORDER BY b.books_id;


