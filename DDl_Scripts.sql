CREATE SCHEMA milkyway;
SET search_path TO milkyway;

CREATE TABLE Product ( 
    Product_ID INT PRIMARY KEY, 
    Product_name VARCHAR(40), 
    Mfg_date DATE, 
    Price INT, 
    Exp_date DATE 
); 

CREATE TABLE Material ( 
    Material_ID INT PRIMARY KEY, 
    Supplier_ID INT, 
    Material_name VARCHAR(30) 
); 

CREATE TABLE Inventory ( 
    Inventory_ID INT PRIMARY KEY, 
    Product_ID INT, 
    Quantity_data INT, 
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID) 
);

CREATE TABLE Made_Of ( 
    Product_ID INT,  
    Category VARCHAR(50),
	Material_ID INT,
    PRIMARY KEY (Product_ID, Material_ID), 
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID), 
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID) 
);

CREATE TABLE Retailer ( 
    Retailer_ID INT PRIMARY KEY, 
    Retailer_name VARCHAR(30), 
    Area INT, 
    Retailer_Contact_info BIGINT 
);

CREATE TABLE Retailer_Payment ( 
    Retailer_pay_ID INT PRIMARY KEY, 
    Received_amount INT, 
    Method VARCHAR(30), 
    Pay_date DATE 
); 

CREATE TABLE Retail_Orders ( 
    Retail_order_ID INT PRIMARY KEY, 
    Retailer_ID INT, 
    Retail_Order_date DATE, 
    Retailer_pay_ID INT, 
    FOREIGN KEY (Retailer_ID) REFERENCES Retailer(Retailer_ID), 
    FOREIGN KEY (Retailer_pay_ID) REFERENCES Retailer_Payment(Retailer_pay_ID)     
);

CREATE TABLE Retail_Order_Details ( 
    Retail_order_ID INT, 
    Product_ID INT, 
    Quantity_Ordered INT, 
    Selling_Price INT, 
    PRIMARY KEY (Retail_order_ID, Product_ID), 
    FOREIGN KEY (Retail_order_ID) REFERENCES Retail_Orders(Retail_order_ID), 
    FOREIGN KEY (Product_ID) REFERENCES Product(Product_ID) 
);

CREATE TABLE Supplier ( 
    Supplier_ID INT PRIMARY KEY, 
    Supplier_name VARCHAR(30), 
    Supplier_contact BIGINT 
);

CREATE TABLE Supplier_Payment ( 
    Supplier_pay_ID INT PRIMARY KEY, 
    Paid_amount INT, 
    Paid_date DATE 
); 

CREATE TABLE Supply_Order ( 
    Supply_order_ID INT PRIMARY KEY, 
    Supplier_ID INT, 
    Supply_order_date DATE, 
    Supplier_pay_ID INT, 
    FOREIGN KEY (Supplier_ID) REFERENCES Supplier(Supplier_ID), 
    FOREIGN KEY (Supplier_pay_ID) REFERENCES Supplier_Payment(Supplier_pay_ID) 
); 

CREATE TABLE Supply_Order_Detail ( 
    Supply_order_ID INT, 
    Material_ID INT, 
    Quantity INT, 
    Cost_price INT, 
    PRIMARY KEY (Supply_order_ID, Material_ID), 
    FOREIGN KEY (Supply_order_ID) REFERENCES Supply_Order(Supply_order_ID), 
    FOREIGN KEY (Material_ID) REFERENCES Material(Material_ID) 
);