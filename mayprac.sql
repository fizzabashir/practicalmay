create database pract;
use  pract;
-- Creating all tables
CREATE TABLE Medicines (
    medicine_id INT PRIMARY KEY,
    name varchar(100),
    manufacturer varchar(100),
    price DECIMAL(10, 2),
    quantity_in_stock INT
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    name varchar(100),
    email varchar(100),
    phone varchar(15)
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    medicine_id INT,
    quantity INT,
    total_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicines(medicine_id)
);
-- ok now insertion in all tables
Insert into Medicines (medicine_id, name, manufacturer, price, quantity_in_stock)
Values
(1, 'Disprin', 'tab.', 1.50, 100),
       (2, 'Panadol', 'tablet', 2.00, 150),
       (3, 'Paracetamol', 'Med', 1.20, 200);


Insert into  Customers (customer_id, name, email, phone)
VALUES 
(1, 'fizza', 'fiz@gmail.com', '1356355550'),
       (2, 'Sara', 'sara@gmail.com', '45235666621'),
       (3, 'Mira', 'mira@gmail.com', '453333441'),
       (4, 'Alishba', 'alislsa@gmail.com', '5666555621'),
       (5, 'Rabiya', 'rabia@gmail.com', '4534444621');

Insert into  Orders (order_id, customer_id, order_date)
VALUES
(1, 1, '2024-09-02'),
(2, 1, '2024-05-25'),
(3, 1, '2024-02-05'),
(4, 1, '2024-05-25'),
(5, 2, '2024-02-20');


Insert into Order_Details (order_detail_id, order_id, medicine_id, quantity, total_price)
VALUES (1, 1, 1, 10, 15.00),
       (2, 1, 2, 5, 10.00),
       (3, 2, 3, 20, 24.00);
-- Query 1:
CREATE VIEW MedicinesInStock
AS SELECT name, price FROM Medicines
WHERE quantity_in_stock > 0;
-- Query 2: 
SELECT c.name, c.email FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_date > '2024-01-01';

-- Query 3: 
SELECT o.order_id, SUM(od.total_price) AS total_order_price
FROM Orders o
JOIN Order_Details od ON o.order_id = od.order_id
GROUP BY o.order_id;
-- Query 4: 
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name;

-- Query 5: 
CREATE TRIGGER UpdateMedicineInStock
ON Order_Details
AFTER INSERT
AS
BEGIN
 Update Medicines
    SET quantity_in_stock = quantity_in_stock - (SELECT quantity FROM inserted WHERE medicine_id = Medicines.medicine_id)
    WHERE medicine_id IN (SELECT medicine_id FROM inserted);
END;

-- Query 6: 
SELECT COUNT(*)
FROM (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(order_id) > 5
) AS frequent_customers;
