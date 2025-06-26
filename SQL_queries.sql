-- 1. List of all available products
SELECT * FROM Product;

-- 2. Details of specific product (e.g., by ID)
SELECT Product_name, Exp_date, Price 
FROM Product 
WHERE Product_ID = 40101;

-- 3. Stock levels of all products
SELECT P.Product_name, I.Quantity_data 
FROM Inventory I 
JOIN Product P ON I.Product_ID = P.Product_ID;

-- 4. List of all retailers (with payment details)
SELECT R.Retailer_ID, R.Retailer_name, RP.Received_amount, RP.Method, RP.Pay_date 
FROM Retailer R
JOIN Retail_Orders RO ON R.Retailer_ID = RO.Retailer_ID
JOIN Retailer_Payment RP ON RO.Retailer_pay_ID = RP.Retailer_pay_ID;

-- 5. List of products purchased by each retailer
SELECT R.Retailer_name, P.Product_name, ROD.Quantity_Ordered 
FROM Retailer R
JOIN Retail_Orders RO ON R.Retailer_ID = RO.Retailer_ID
JOIN Retail_Order_Details ROD ON RO.Retail_order_ID = ROD.Retail_order_ID
JOIN Product P ON ROD.Product_ID = P.Product_ID;

-- 6. List of all retailers who purchased a specific product
SELECT DISTINCT R.Retailer_name 
FROM Retailer R
JOIN Retail_Orders RO ON R.Retailer_ID = RO.Retailer_ID
JOIN Retail_Order_Details ROD ON RO.Retail_order_ID = ROD.Retail_order_ID
WHERE ROD.Product_ID = 40101;

-- 7. List of revenue generated through retailers (rank wise)
SELECT R.Retailer_name, SUM(ROD.Quantity_Ordered * ROD.Selling_Price) AS Revenue 
FROM Retailer R
JOIN Retail_Orders RO ON R.Retailer_ID = RO.Retailer_ID
JOIN Retail_Order_Details ROD ON RO.Retail_order_ID = ROD.Retail_order_ID
GROUP BY R.Retailer_name
ORDER BY Revenue DESC;

-- 8. Increase the price of all dairy products by x%
UPDATE Product
SET Price = Price * 1.10;  -- Replace 1.10 with 1 + (x/100)

-- 9. Total sales of each product
SELECT P.Product_name, SUM(ROD.Quantity_Ordered) AS Total_Sales
FROM Product P
JOIN Retail_Order_Details ROD ON P.Product_ID = ROD.Product_ID
GROUP BY P.Product_name;

-- 10. Products with highest/lowest profit ratio
-- [Placeholder – profit data needs to be estimated based on costs and prices]

-- 11. List products by expiry date ascending
SELECT * FROM Product
ORDER BY Exp_date ASC;

-- 12. Retailers who placed more than ‘x’ orders in the previous month
SELECT R.Retailer_name, COUNT(*) AS Order_Count
FROM Retailer R
JOIN Retail_Orders RO ON R.Retailer_ID = RO.Retailer_ID
WHERE RO.Retail_Order_date BETWEEN '2025-03-01' AND '2025-03-31'
GROUP BY R.Retailer_name
HAVING COUNT(*) > 2;  -- Replace 2 with 'x'

-- 13. Quantity of expired products
SELECT P.Product_name, I.Quantity_data
FROM Product P
JOIN Inventory I ON P.Product_ID = I.Product_ID
WHERE P.Exp_date < CURRENT_DATE;

-- 14. Total number of orders per month
SELECT DATE_TRUNC('month', Retail_Order_date) AS Month, COUNT(*) AS Total_Orders
FROM Retail_Orders
GROUP BY Month
ORDER BY Month;

-- 15. Average selling price per product
SELECT P.Product_name, AVG(ROD.Selling_Price) AS Avg_Selling_Price
FROM Product P
JOIN Retail_Order_Details ROD ON P.Product_ID = ROD.Product_ID
GROUP BY P.Product_name;

-- 16. Products never ordered
SELECT P.Product_name
FROM Product P
WHERE NOT EXISTS (
    SELECT 1 FROM Retail_Order_Details ROD WHERE ROD.Product_ID = P.Product_ID
);

-- 17. Suppliers who have not been paid yet
SELECT S.Supplier_name
FROM Supplier S
LEFT JOIN Material M ON S.Supplier_ID = M.Supplier_ID
LEFT JOIN Supply_Order_Detail SOD ON M.Material_ID = SOD.Material_ID
LEFT JOIN Supply_Order SO ON SOD.Supply_order_ID = SO.Supply_order_ID
LEFT JOIN Supplier_Payment SP ON SO.Supplier_pay_ID = SP.Supplier_pay_ID
WHERE SP.Supplier_pay_ID IS NULL;

-- 18. Retailers who haven't made any orders
SELECT R.Retailer_name
FROM Retailer R
LEFT JOIN Retail_Orders RO ON R.Retailer_ID = RO.Retailer_ID
WHERE RO.Retail_order_ID IS NULL;

-- 19. Most used material in manufacturing
SELECT M.Material_name, COUNT(*) AS Usage_Count
FROM Made_Of MO
JOIN Material M ON MO.Material_ID = M.Material_ID
GROUP BY M.Material_name
ORDER BY Usage_Count DESC
LIMIT 1;

-- 20. Average order value per retailer
SELECT R.Retailer_name, AVG(ROD.Quantity_Ordered * ROD.Selling_Price) AS Avg_Order_Value
FROM Retailer R
JOIN Retail_Orders RO ON R.Retailer_ID = RO.Retailer_ID
JOIN Retail_Order_Details ROD ON RO.Retail_order_ID = ROD.Retail_order_ID
GROUP BY R.Retailer_name;

-- 21. Number of products made using each material
SELECT M.Material_name, COUNT(DISTINCT MO.Product_ID) AS Product_Count
FROM Made_Of MO
JOIN Material M ON MO.Material_ID = M.Material_ID
GROUP BY M.Material_name;

-- 22. Inventory value (stock × product price)
SELECT P.Product_name, (I.Quantity_data * P.Price) AS Inventory_Value
FROM Inventory I
JOIN Product P ON I.Product_ID = P.Product_ID;

-- 23. Products expiring in next 30 days
SELECT Product_name, Exp_date
FROM Product
WHERE Exp_date BETWEEN '2025-04-13' AND '2025-05-13';

-- 24. Total payments received from each retailer
SELECT R.Retailer_name, SUM(RP.Received_amount) AS Total_Received
FROM Retailer R
JOIN Retail_Orders RO ON R.Retailer_ID = RO.Retailer_ID
JOIN Retailer_Payment RP ON RO.Retailer_pay_ID = RP.Retailer_pay_ID
GROUP BY R.Retailer_name;

-- 25. Payment methods used by retailers
SELECT Method, COUNT(*) AS Usage_Count
FROM Retailer_Payment
GROUP BY Method;

-- 26. Supplier with most diverse material types
SELECT S.Supplier_name, COUNT(DISTINCT M.Material_name) AS Material_Types
FROM Supplier S
JOIN Material M ON S.Supplier_ID = M.Supplier_ID
GROUP BY S.Supplier_name
ORDER BY Material_Types DESC
LIMIT 1;

-- 27. Most ordered product (by quantity)
SELECT P.Product_name, SUM(ROD.Quantity_Ordered) AS Total_Ordered
FROM Product P
JOIN Retail_Order_Details ROD ON P.Product_ID = ROD.Product_ID
GROUP BY P.Product_name
ORDER BY Total_Ordered DESC
LIMIT 1;

-- 28. Average quantity ordered per product
SELECT P.Product_name, AVG(ROD.Quantity_Ordered) AS Avg_Quantity
FROM Product P
JOIN Retail_Order_Details ROD ON P.Product_ID = ROD.Product_ID
GROUP BY P.Product_name;

-- 29. Total cost of materials supplied by each supplier
SELECT S.Supplier_name, SUM(SOD.Quantity * SOD.Cost_price) AS Total_Cost
FROM Supplier S
JOIN Material M ON S.Supplier_ID = M.Supplier_ID
JOIN Supply_Order_Detail SOD ON M.Material_ID = SOD.Material_ID
GROUP BY S.Supplier_name;

-- 30. Products with no stock left in inventory
SELECT P.Product_name
FROM Product P
JOIN Inventory I ON P.Product_ID = I.Product_ID
WHERE I.Quantity_data = 0;
