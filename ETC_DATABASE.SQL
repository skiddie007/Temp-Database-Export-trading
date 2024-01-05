-- Create the database
CREATE DATABASE ExportTradingCompany;

-- Use the created database
USE ExportTradingCompany;

-- Create tables
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(255) NOT NULL,
    ContactPerson VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(255)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(255) NOT NULL,
    Description TEXT,
    UnitPrice DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE NOT NULL,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(255) NOT NULL,
    ContactPerson VARCHAR(100),
    Phone VARCHAR(15),
    Email VARCHAR(255)
);

CREATE TABLE Invoices (
    InvoiceID INT PRIMARY KEY,
    InvoiceDate DATE NOT NULL,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

CREATE TABLE InvoiceDetails (
    InvoiceDetailID INT PRIMARY KEY,
    InvoiceID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (InvoiceID) REFERENCES Invoices(InvoiceID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Create a balance sheet table
CREATE TABLE BalanceSheet (
    BalanceSheetID INT PRIMARY KEY,
    Date DATE NOT NULL,
    Asset DECIMAL(15, 2),
    Liability DECIMAL(15, 2),
    Equity DECIMAL(15, 2)
);

-- Create triggers to update the balance sheet when transactions occur
-- (You may need to customize these triggers based on your specific business logic)

-- Trigger to update balance sheet when an invoice is created
CREATE TRIGGER UpdateBalanceSheet_OnInvoice
AFTER INSERT ON Invoices
FOR EACH ROW
BEGIN
    INSERT INTO BalanceSheet (Date, Asset, Liability, Equity)
    VALUES (NEW.InvoiceDate, 0, 0, 0);
END;

-- Trigger to update balance sheet when an order is placed
CREATE TRIGGER UpdateBalanceSheet_OnOrder
AFTER INSERT ON Orders
FOR EACH ROW
BEGIN
    INSERT INTO BalanceSheet (Date, Asset, Liability, Equity)
    VALUES (NEW.OrderDate, 0, 0, 0);
END;

-- Trigger to update balance sheet when a payment is received
CREATE TRIGGER UpdateBalanceSheet_OnPayment
AFTER INSERT ON Payments
FOR EACH ROW
BEGIN
    UPDATE BalanceSheet
    SET Asset = Asset + NEW.Amount
    WHERE Date = NEW.PaymentDate;
END;
