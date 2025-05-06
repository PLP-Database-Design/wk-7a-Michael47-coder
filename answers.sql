--QUESTION 1

-- First, convert your products to a JSON array by replacing commas
WITH ProductSplit AS (
  SELECT 
    OrderID,
    CustomerName,
    JSON_ARRAYAGG(TRIM(value)) AS ProductList
  FROM (
    SELECT
      OrderID,
      CustomerName,
      TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(Products, ',', numbers.n), ',', -1)) AS value
    FROM 
      ProductDetail
    JOIN (
      SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
    ) AS numbers
    ON CHAR_LENGTH(Products) - CHAR_LENGTH(REPLACE(Products, ',', '')) >= numbers.n - 1
  ) AS split_values
  GROUP BY OrderID, CustomerName
)

-- Then, extract individual products
SELECT 
  pd.OrderID,
  pd.CustomerName,
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(pd.Products, ',', numbers.n), ',', -1)) AS Product
FROM 
  ProductDetail pd
JOIN (
  SELECT 1 AS n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5
) AS numbers
ON CHAR_LENGTH(pd.Products) - CHAR_LENGTH(REPLACE(pd.Products, ',', '')) >= numbers.n - 1;



-- QUESTION 2.

-- Step 1: Create the Orders table (stores OrderID and CustomerName)
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

-- Step 2: Create the OrderItems table (stores Product and Quantity per order)
CREATE TABLE OrderItems (
    OrderID INT,
    Product VARCHAR(100),
    Quantity INT,
    PRIMARY KEY (OrderID, Product),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);

-- Step 3: Insert data into Orders table
INSERT INTO Orders (OrderID, CustomerName) VALUES
(101, 'John Doe'),
(102, 'Jane Smith'),
(103, 'Emily Clark');

-- Step 4: Insert data into OrderItems table
INSERT INTO OrderItems (OrderID, Product, Quantity) VALUES
(101, 'Laptop', 2),
(101, 'Mouse', 1),
(102, 'Tablet', 3),
(102, 'Keyboard', 1),
(102, 'Mouse', 2),
(103, 'Phone', 1);


--END--