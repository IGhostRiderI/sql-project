IF DB_ID ('Company') IS NOT NULL 
	BEGIN 
			Print 'Database exists - Dropping.';

			USE master;
			ALTER DATABASE Company SET SINGLE_USER WITH ROLLBACK
IMMEDIATE;
			DROP DATABASE Company;
	END
GO

PRINT 'Creating Database.';
CREATE DATABASE Company;
GO 

USE Company;
GO



CREATE TABLE Customer(
CustomerNumber INT NOT NULL PRIMARY KEY IDENTITY,
FirstName VARCHAR(10) NOT NULL,
LastName VARCHAR(10) NOT NULL,
Email VARCHAR(20) NOT NULL,
Password VARCHAR(20) NOT NULL,
NewsChoice VARCHAR(50) NOT NULL,
Referral INT FOREIGN KEY REFERENCES Customer(CustomerNumber)
					);

CREATE TABLE Orders(
InvoiceNumber INT NOT NULL PRIMARY KEY IDENTITY,
CustomerNumber INT NOT NULL FOREIGN KEY REFERENCES Customer(CustomerNumber),
Date_Time DATETIME NOT NULL,
DeliveryAddress VARCHAR(200) NOT NULL,
BillingAddress VARCHAR(200) NOT NULL
				);

CREATE TABLE Address(
AddressNumber INT NOT NULL PRIMARY KEY IDENTITY,
Address VARCHAR(200) NOT NULL,
CustomerNumber INT NOT NULL FOREIGN KEY REFERENCES Customer(CustomerNumber)
					);

CREATE TABLE Category(
CategoryID INT NOT NULL PRIMARY KEY IDENTITY,
CategoryName VARCHAR(10) NOT NULL
					);

CREATE TABLE Item(
ItemNumber INT NOT NULL PRIMARY KEY IDENTITY,
ItemName VARCHAR(10) NOT NULL,
Description VARCHAR(50) NOT NULL,
Price MONEY NOT NULL,
Cost MONEY NOT NULL,
Stock SMALLINT NOT NULL
				);

CREATE TABLE Supplier(
SupplierNumber INT NOT NULL PRIMARY KEY IDENTITY,
SupType VARCHAR(10) ,
BusinessName VARCHAR(20) NOT NULL,
PhoneNumber VARCHAR(20) NOT NULL,
Website VARCHAR(50) 
					);

CREATE TABLE CustomerCategory(
CustomerNumber INT NOT NULL FOREIGN KEY REFERENCES Customer(CustomerNumber),
CategoryID INT NOT NULL FOREIGN KEY REFERENCES Category(CategoryID)
PRIMARY KEY (CustomerNumber, CategoryID)
							);

CREATE TABLE ItemCategory(
ItemNumber INT NOT NULL FOREIGN KEY REFERENCES Item(ItemNumber),
CategoryID INT NOT NULL FOREIGN KEY REFERENCES Category(CategoryID)
PRIMARY KEY (ItemNumber, CategoryID)
							);

CREATE TABLE OrderItem(
InvoiceNumber INT NOT NULL FOREIGN KEY REFERENCES Orders(InvoiceNumber),
ItemNumber INT NOT NULL FOREIGN KEY REFERENCES Item(ItemNumber),
Quantity INT NOT NULL
PRIMARY KEY (InvoiceNumber, ItemNumber)
					  );

--Increase upto 20 characters of VARCHAR in BusinessName column in Supplier table
Alter TABLE Supplier
ALTER COLUMN BusinessName VARCHAR(20) NOT NULL;

--Delete SupType column from Supplier table
Alter TABLE Supplier
DROP COLUMN SupType;

INSERT INTO Supplier (BusinessName, PhoneNumber, Website)
VALUES	('Techsupply Co.', '+61 08 9201 5475', 'http://www.techsupplyco.com'),		-- Supplier 1
		('Gadget World',   '+61 06 7544 4512', 'http://buy.gadgetworld.com.au/'),	-- Supplier 2
		('ElectroGoods',   '+86 258 765 4321', 'http://www.electrogoods.com'),		-- Supplier 3
		('Deal Express',   '+86 591 613 8356', 'http://dealexpress.com.cn/');		-- Supplier 4


--Increase upto 50 characters of VARCHAR in ItemName column in Item table
Alter TABLE Item
ALTER COLUMN ItemName VARCHAR(50);

--Increase upto 200 characters of VARCHAR in Description column in Item table
Alter TABLE Item
ALTER COLUMN Description VARCHAR(200);

--Add new column to the Item table
Alter TABLE Item
ADD primary_supplier_id INT FOREIGN KEY REFERENCES Supplier(SupplierNumber) NOT NULL;

--Add new column to the Item table
Alter TABLE Item
ADD secondary_supplier_id INT FOREIGN KEY REFERENCES Supplier(SupplierNumber);

INSERT INTO Item (ItemName, Description, Price, Cost, Stock, primary_supplier_id, secondary_supplier_id) 
VALUES	('Ergonomic Wireless Mouse', 'A sleek, ergonomic mouse with a comfortable grip and precise tracking, complete with a USB receiver.', 29.99, 12.00, 100, 1, 2),						-- Item 1
		('RGB Mechanical Keyboard', 'A mechanical keyboard featuring customizable RGB backlighting and durable key switches for a premium typing experience.', 79.99, 43.00, 50, 2, 1),		-- Item 2
		('27-Inch HD Monitor', 'A stunning 27-inch Full HD monitor with vibrant colors and crisp visuals, perfect for both work and play.', 199.99, 150.00, 75, 3, 4),						-- Item 3
		('Adjustable Aluminum Laptop Stand', 'A lightweight and sturdy laptop stand that improves posture and cooling, adjustable to various angles.', 49.99, 30.00, 20, 4, NULL),			-- Item 4
		('Noise Cancelling Over-Ear Headphones', 'Wireless over-ear headphones with advanced noise cancellation technology, delivering immersive sound quality.', 149.99, 80.00, 10, 1, 3),	-- Item 5
		('Portable Charger with Fast Charging', 'A compact 10000mAh power bank with fast charging capabilities to keep your devices powered on the go.', 39.99, 20.00, 150, 2, 4),			-- Item 6
		('Portable Bluetooth Speaker', 'A small yet powerful Bluetooth speaker that delivers deep bass and clear sound, perfect for any occasion.', 59.99, 35.00, 200, 3, 2),				-- Item 7
		('Smart Fitness Tracker Smartwatch', 'A sleek smartwatch with fitness tracking, heart rate monitoring, and smart notifications to keep you connected.', 129.99, 90.00, 120, 4, 3),	-- Item 8
		('1TB USB 3.0 External Hard Drive', 'A high-speed external hard drive with 1TB of storage, ideal for backing up and transferring large files.', 79.99, 50.00, 90, 1, 4),			-- Item 9
		('1080p HD Webcam with Microphone', 'A high-definition webcam with a built-in microphone, perfect for video calls and streaming.', 49.99, 25.00, 80, 2, NULL),						-- Item 10
		('6-in-1 USB-C Hub with HDMI', 'A versatile USB-C hub with multiple ports, including HDMI and Ethernet, to expand your laptop’s connectivity.', 69.99, 40.00, 60, 3, NULL),			-- Item 11
		('High Precision Gaming Mouse', 'A high-performance gaming mouse with adjustable DPI settings and RGB lighting for an enhanced gaming experience.', 59.99, 35.00, 30, 4, NULL),		-- Item 12
		('Adjustable Tablet Stand', 'A durable tablet stand that can be adjusted to various viewing angles, making it perfect for desk use.', 29.99, 15.00, 40, 1, 3),						-- Item 13
		('Fast Wireless Charging Pad', 'A sleek and fast wireless charger that quickly powers up your Qi-compatible devices.', 39.99, 25.00, 70, 2, 3),										-- Item 14
		('WiFi-Enabled Smart LED Light Bulb', 'A smart LED light bulb that can be controlled via WiFi, offering a range of colors and brightness levels.', 19.99, 14.00, 110, 3, 1),		-- Item 15
		('Noise Isolating In-Ear Earbuds', 'Compact in-ear earbuds with excellent noise isolation and superior sound quality.', 29.99, 15.00, 55, 4, 2),									-- Item 16
		('Water-Resistant Laptop Backpack', 'A stylish and water-resistant laptop backpack with multiple compartments to keep your belongings organized.', 69.99, 45.00, 65, 1, 4),			-- Item 17
		('Compact Wireless Keyboard with Touchpad', 'A slim and portable wireless keyboard with an integrated touchpad, perfect for on-the-go use.', 49.99, 15.00, 85, 2, NULL),			-- Item 18
		('WiFi-Enabled Smart Plug', 'A smart plug that allows you to control your appliances remotely via a smartphone app or voice commands.', 24.99, 15.00, 95, 3, NULL),					-- Item 19
		('Wireless Bluetooth Headset with Mic', 'A comfortable wireless headset with a built-in microphone, offering clear audio for calls and music.', 79.99, 30.00, 25, 4, NULL);			-- Item 20

--Increase upto 30 characters of VARCHAR in CategoryName column in Category table
Alter TABLE Category
ALTER COLUMN CategoryName VARCHAR(30) NOT NULL;

INSERT INTO Category (CategoryName) 
VALUES	('Computers & Accessories'),	-- Category 1
		('Mobile & Tablets'),			-- Category 2
		('Audio & Headphones'),			-- Category 3
		('Home & Office'),				-- Category 4
		('Gaming'),						-- Category 5
		('Optical Media');				-- Category 6 (empty category)


INSERT INTO ItemCategory (ItemNumber, CategoryID)
VALUES	(1, 1),						-- Ergonomic Wireless Mouse - Computers & Accessories
		(2, 1),						-- RGB Mechanical Keyboard - Computers & Accessories
		(3, 1),						-- 27-Inch HD Monitor - Computers & Accessories
		(4, 1),						-- Adjustable Aluminum Laptop Stand - Computers & Accessories
		(5, 3), (5, 4),				-- Noise Cancelling Over-Ear Headphones - Audio & Headphones, Home & Office
		(6, 2), (6, 4),				-- Portable Charger with Fast Charging - Mobile & Tablets, Home & Office
		(7, 3), (7, 4),				-- Portable Bluetooth Speaker - Audio & Headphones, Home & Office
		(8, 2),						-- Smart Fitness Tracker Smartwatch - Mobile & Tablets
		(9, 1),						-- 1TB USB 3.0 External Hard Drive - Computers & Accessories
		(10, 1),					-- 1080p HD Webcam with Microphone - Computers & Accessories
		(11, 1),					-- 6-in-1 USB-C Hub with HDMI - Computers & Accessories
		(12, 1), (12, 5),			-- High Precision Gaming Mouse - Computers & Accessories, Gaming
		(13, 1), (13, 2),			-- Adjustable Tablet Stand - Computers & Accessories, Mobile & Tablets
		(14, 2),					-- Fast Wireless Charging Pad - Mobile & Tablets
		(15, 4),					-- WiFi-Enabled Smart LED Light Bulb - Home & Office
		(16, 3), (16, 2),			-- Noise Isolating In-Ear Earbuds - Audio & Headphones, Mobile & Tablets
		(17, 4), (17, 2),			-- Water-Resistant Laptop Backpack - Home & Office, Mobile & Tablets
		(18, 1),					-- Compact Wireless Keyboard with Touchpad - Computers & Accessories
		(19, 4),					-- WiFi-Enabled Smart Plug - Home & Office
		(20, 3), (20, 2), (20, 5);	-- Wireless Bluetooth Headset with Mic - Audio & Headphones, Mobile & Tablets, Gaming


SELECT * FROM Customer;
SELECT * FROM Orders;
SELECT * FROM Address;
SELECT * FROM Category;
SELECT * FROM Item;
SELECT * FROM Supplier;
SELECT * FROM CustomerCategory;
SELECT * FROM ItemCategory;
SELECT * FROM OrderItem;

-- Write your INSERT statements for the remaining tables here

Alter TABLE Customer
ALTER COLUMN NewsChoice VARCHAR(1) NOT NULL;

ALTER TABLE Customer 
ADD CONSTRAINT CHK_NewsChoice CHECK (NewsChoice IN ('Y', 'N'));

ALTER TABLE Customer
ADD DEFAULT 'Y' FOR NewsChoice;

INSERT INTO Customer (FirstName, LastName, Email, Password, NewsChoice, Referral)
VALUES	('John', 'Griffin', 'John@yahoomail.com', 'John.1994','Y', NULL),		-- Customer 1
		('Harry', 'Brook', 'HarryB@gmail.com', 'EdubuRy.4040', 'N', 1),			-- Customer 2
		('Joe', 'Wilson', 'Joe.Wilson@gmail.com','Wil,Joe234', 'N', NULL),		-- Customer 3
		('Tom', 'Cooper', 'Coopertom@gmail.com', 'TomCooper,2005', 'Y', 3),		-- Customer 4
		('Jimmy', 'Donaldson', 'JimmyDon@gmail.com', 'Jimmy12Don', 'Y', 2);		-- Customer 5



INSERT INTO CustomerCategory (CustomerNumber, CategoryID)
VALUES	(1, 4),						-- John Grifin - Home & Office
		(2, 2),						-- Harry Brook - Mobile & Tablets
		(2, 5),						-- Harry Brook - Gaming
		(3, 5),						-- Joe Wilson - Gaming
		(4, 1), 					-- Tom Cooper - Computers & Accessories
		(4, 5), 					-- Tom Cooper - Gaming
		(5, 3); 					-- Jimmy Donaldson - Audio & Headphones

INSERT INTO Orders ( CustomerNumber, Date_Time, DeliveryAddress, BillingAddress)
VALUES ( 2, '2023-02-13', '123 Victoria Street, Melbourne, VIC 3000', '34 Riverbank Drive, Parramatta, NSW 2150'),  --Harry Brook
	   ( 3, '2023-04-03', '45 George Street, Sydney, NSW 2000', '89 Maple Crescent, Hobart, TAS 7000'),			  --Joe Wilson
	   ( 5, '2024-01-21', '78 Elizabeth Road, Brisbane, QLD 4000', '16 Coral Street, Cairns, QLD 4870'),            --Jimmy Donaldson
	   ( 1, '2024-04-07', '12 Smith Avenue, Perth, WA 6000', '22 Oceanview Avenue, Darwin, NT 0800'),               --John Griffin
	   ( 4, '2024-08-01', '5 King Street, Adelaide, SA 5000', '5 King Street, Adelaide, SA 5000');                  --Tom Cooper

INSERT INTO Address (Address, CustomerNumber)
VALUES	('12 Smith Avenue, Perth, WA 6000',1),              --John Griffin
		('34 Riverbank Drive, Parramatta, NSW 2150',2),     --Harry Brook
		('123 Victoria Street, Melbourne, VIC 3000',2),     --Harry Brook
		('89 Maple Crescent, Hobart, TAS 7000',3),          --Joe Wilson
		('45 George Street, Sydney, NSW 2000',3),           --Joe Wilson
		('16 Coral Street, Cairns, QLD 4870',5),            --Jimmy Donaldson
		('5 King Street, Adelaide, SA 5000',4),             --Tom Cooper
		('78 Elizabeth Road, Brisbane, QLD 4000',5),        --Jimmy Donaldson
		('22 Oceanview Avenue, Darwin, NT 0800',1);         --John Griffin
		
INSERT INTO OrderItem (InvoiceNumber, ItemNumber, Quantity)
VALUES  (1,18,4),
		(2,5,3),
		(3,10,5),
		(4,20,6),
		(5,19,2); 