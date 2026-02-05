-- Create Database
CREATE DATABASE OnlineBooksStore;

-- Switch to the database

-- Create Tables
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
	Book_ID SERIAL PRIMARY KEY,
	Title VARCHAR(100),
	Author VARCHAR(100),
	Genre VARCHAR(50),
	Published_Year INT,
	Price NUMERIC(10,2),
	Stock INT
);

DROP TABLE IF EXISTS Customers;
CREATE TABLE Customers (
	Customer_ID SERIAL PRIMARY KEY,
	Name VARCHAR(100),
	Phone VARCHAR(15),
	City VARCHAR(50),
	Country VARCHAR(150)
);

--Adding New Column Email.
ALTER TABLE Customers
ADD COLUMN Email VARCHAR(100);

-- Deleting this table first to delete the uppper tables because it takes fkey form them.
DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders(
	Order_ID SERIAL PRIMARY KEY,
	Customer_ID INT REFERENCES Customers(Customer_ID),
	Book_ID INT REFERENCES Books(Book_ID),
	Order_Date DATE,
	Quantity INT,
	Total_Amount NUMERIC(10,2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- Import Data into Books Table
COPY Books(Book_ID, Title, Author, Genre, Published_Year, Price, Stock)
FROM 'D:/SQL/Project/Books.csv'
CSV HEADER;

-- Import Data into Customers Table
COPY Customers(Customer_ID, Name, Email, Phone, City, Country)
FROM 'D:\SQL\Project\Customers.csv'
CSV HEADER;

-- Import Data into Orders Table
COPY Orders(Order_ID, Customer_ID, Book_ID, Order_Date, Quantity, Total_Amount)
FROM 'D:\SQL\Project\Orders.csv'
CSV HEADER;

                /* BASIC QUERIES*/
-- 1) Retrive all books in the "Fiction" genre:

SELECT * FROM Books
WHERE Genre = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books
WHERE published_year > '1950';

-- 3) List all the customers from the Canada:
SELECT * FROM Customers
WHERE country = 'Canada';

-- 4) Retrive the total stock of books available:
SELECT SUM(stock) AS Total_stock
FROM Books;

-- 5) Find the details of the most expensive book:
SELECT * FROM Books
ORDER BY price DESC 
LIMIT 1;

-- 6) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders
WHERE quantity > 1;

-- 8) Retrive all orders where the total ammount exceeds $20:
SELECT * FROM Orders
WHERE total_amount>20;

-- 9) List all the genre available in the Books table:
SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books
ORDER BY stock 
LIMIT 5;

-- 11) Calculate the total revenue generated from all orders:

SELECT SUM (total_amount) AS Total_revenue
FROM Orders;


				/* ADVANCE QUERIES*/

-- 1) Retrive the total number of books sold for each genre:

SELECT * FROM Orders;

SELECT b.genre, SUM(Quantity) AS Total_b_sold --(Aggrigate function)
FROM Orders o
JOIN Books b ON o.book_id = b.book_id
GROUP BY b.genre; -- clause

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT AVG(price) AS Avg_price
FROM Books
WHERE genre = 'Fantasy';

-- 3) List customers who have placed at least 2 orders:

SELECT o.Customer_ID, c.Name, COUNT(o.Order_ID) AS ORDER_COUNT
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY o.Customer_ID, c.Name--(repeted customer_id)
HAVING COUNT(Order_ID) >=2; -- Aggrigate Formula condition

-- 4) Find the most frequently ordered books:

SELECT o.Book_ID, b.Title, COUNT(o.Order_ID) AS ORDER_COUNT
FROM Orders o
JOIN Books b ON
o.Book_ID = b.Book_ID
GROUP BY o.Book_ID, b.Title
ORDER BY ORDER_COUNT DESC
LIMIT 5;

-- 5) Show the top 3 most expensive books of 'Fantasy' genre:

SELECT * FROM Books
WHERE Genre = 'Fantasy'
ORDER BY Price DESC
LIMIT 3;



-- 6) Retrive the total quantity of books sold by each author:

SELECT b.Author, SUM(o.Quantity) AS Total_Books_sold
FROM Orders o
JOIN Books b ON o.Book_ID = b.Book_ID
GROUP BY b.Author;

-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.City, Total_Amount
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
WHERE o.Total_Amount > 30
ORDER BY Total_Amount DESC;

-- 8) Find the customer who spent the most on orders:

SELECT c.Customer_ID, c.Name, SUM(o.Total_Amount) AS Total_Spent
FROM Orders o
JOIN Customers c ON o.Customer_ID = c.Customer_ID
GROUP BY c.Customer_ID, c.Name
ORDER BY Total_Spent DESC
LIMIT 5;


-- 9) Calculate the stock remaining after fulfilling all orders:

SELECT b.Book_ID, b.Title, b.Stock, COALESCE(SUM(o.Quantity),0) AS Order_Quantity,
 b.Stock - COALESCE(SUM(o.Quantity),0) AS Remaining_Quantity
FROM Books b
LEFT JOIN 
Orders o ON b.Book_ID = o.Book_ID
GROUP BY b.Book_ID
ORDER BY b.Book_ID;








