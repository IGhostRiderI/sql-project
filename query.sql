USE Company;

SELECT ItemNumber, ItemName, (Price - Cost) AS Profit                                        --select ItemNumber, ItemName and difference of Price and Cost as Profit from Item table
FROM Item
WHERE (Price - Cost) >= 20 AND (ItemName LIKE '%portable%' OR ITEMNAME LIKE '%compact%')     --The profit should be more than $20 and ItemName should consist the words 'portable' and 'compact'
ORDER BY Profit DESC;																		 --Order in descending order of the profit column

SELECT 
	i.ItemNumber,																				-- Select ItemNumber column from Item table
	i.ItemName,																					-- Select ItemName column from Item table
	i.Stock,																				    -- Select Stock column from Item table
	CONCAT(s.BusinessName, ' (', s.PhoneNumber, ', ', s.Website, ')') AS Primary_Supplier	    -- Join BusinessName, PoneNumber and Website columns in Supplier table and selected as Primary_supplier

FROM Item i

LEFT JOIN
		OrderItem o ON i.ItemNumber = o.ItemNumber												-- Join with OrderItem table 
JOIN
	Supplier s ON i.primary_supplier_id = s.SupplierNumber										-- Join with Supplier table to get primary supplier details

WHERE
	o.ItemNumber IS NULL																		-- If ItemNumber in Order table is NULL

ORDER BY
		i.Stock DESC;																			-- Order by descending order of the Stock column in Item table


SELECT 
	CONCAT( COUNT(cus.CustomerNumber),' customer(s) interested in the ', UPPER(c.CategoryName), ' Category.') AS interest_level      -- Join the number of CustomerNumber in CustomerCategory table with CatergoryName in Customer table in uppercase slected as interest_level

FROM
	Category c

LEFT JOIN
		CustomerCategory cus ON c.CategoryID = cus.CategoryID     -- Join CustomerCategory to get CustomerNumber

GROUP BY
		c.CategoryID, c.CategoryName

ORDER BY
		COUNT(cus.CustomerNumber) DESC, 
		c.CategoryName ASC;					--Order by the descending order of the count of CustomerNumber in CustomerCategory and followed by ascending order of CategoryName on Customer table 


SELECT
		YEAR(Date_Time) AS year,						-- select Date_Time column as year from orders table
		DATENAME(month, Date_Time) AS month,			-- Get the month from Date_Time and select as month
		COUNT(InvoiceNumber) AS number_of_orders		-- Get the count of InvoiceNumber in Orders table as number_of_orders

FROM
	Orders

GROUP BY
		Year(Date_Time),
		MONTH(Date_Time),
		DATENAME(month, Date_Time)

ORDER BY
		YEAR(Date_Time),
		MONTH(Date_Time);								-- Order by Year and followed by the month



WITH ReferralCounts AS (                                     -- Select customer number, full name and count of referrals for each customer
    SELECT 
        c.CustomerNumber AS customer_id,
        CONCAT(c.FirstName, ' ', c.LastName) AS full_name,
        COUNT(ref.CustomerNumber) AS referred_count
    FROM 
        Customer c
    JOIN 
        Customer ref ON c.CustomerNumber = ref.Referral
    GROUP BY 
        c.CustomerNumber, c.FirstName, c.LastName
)
SELECT TOP 3 *
FROM ReferralCounts
ORDER BY referred_count DESC;

GO



SELECT 
	  c.CustomerNumber AS customer_id,							-- Select CustomerNumber column from Customer table as customer_id
	  CONCAT(c.FirstName, ' ', c.LastName) AS customer_name,	-- Join FirstName and LastName from Customer table as customer_name
	  COALESCE(SUM(oi.Quantity), 0) AS items_ordered			-- Get the sum of Quanity in Order Item table and return 0 to Null values and select as items_ordered

FROM
	Customer c

LEFT JOIN
	Orders o ON c.CustomerNumber = o.CustomerNumber             -- Join Order table

LEFT JOIN
	OrderItem oi ON o.InvoiceNumber = oi.InvoiceNumber			-- OrderItem table to get the Quanity

GROUP BY
		c.CustomerNumber, c.FirstName, c.LastName

ORDER BY
		items_ordered DESC;										-- Order by the descending of the items_ordered column




SELECT
    c.CategoryID AS category_id,													-- select CategoryID in Customer table as category_id
    c.CategoryName AS category_name,												-- select CategoryName in Customer table as category_name
    COUNT(i.ItemNumber) AS number_of_items,											-- Get the count of ItemNumber from Item table as number_of_items
    MIN(i.Cost) AS cheapest_item,													-- GET the minimum cost  in Item table as Cheapest_item
    MAX(i.Cost) AS most_expensive_item,												-- GET the maximum cost  in Item table as most_expensive_item
    ROUND(AVG(i.Price - i.Cost), 2) AS average_item_profit,							-- Get the average of the profit from Item table to the nearesr second decimal as average_item_profit
    COUNT(DISTINCT cc.CustomerNumber) AS interested_customers						-- Count CustomerNumber in CustomerCategory and get 0 to NULL values as interested_customers
FROM category c

-- Using OUTER JOIN to ensure categories with no items or customers are included
FULL OUTER JOIN ItemCategory ic ON c.CategoryID = ic.CategoryID						-- Join ItemCategory tabe
FULL OUTER JOIN Item i ON ic.ItemNumber = i.ItemNumber								-- Join Item table to get ItemNumber, Cost and Price
FULL OUTER JOIN CustomerCategory cc ON c.CategoryID = cc.CategoryID					-- Join CustomerCategory to get CustomerNumber

GROUP BY
    c.CategoryID, c.CategoryName

ORDER BY
    number_of_items DESC, category_name�ASC;										-- Order by number_of_items in descending order and followed by asceding order of category_name



SELECT
		c.CustomerNumber AS customer_id,										-- 
		CONCAT( c.FirstName, ' ', c.LastName) AS customer_name,
		COUNT(DISTINCT o.InvoiceNumber) AS orders_placed,
		COALESCE(ROUND(SUM(oi.Quantity * i.Price), 0), 0) AS total_spent

FROM
	Customer c

LEFT JOIN
		Orders o ON c.CustomerNumber = o.CustomerNumber

LEFT JOIN
		OrderItem oi ON o.InvoiceNumber = oi.InvoiceNumber

LEFT JOIN
		Item i ON oi.ItemNumber = i.ItemNumber

GROUP BY
		c.CustomerNumber, c.FirstName, c.LastName

ORDER BY
		total_spent DESC;



SELECT
    c.CustomerNumber AS customer_id,
    CONCAT(c.FirstName, ' ', c.LastName) AS customer_name,
    COUNT(DISTINCT o.InvoiceNumber) AS orders_placed,
    COALESCE(ROUND(SUM(oi.Quantity * i.Price), 0), 0) AS total_spent
FROM Customer c

-- Using OUTER JOIN to include customers who have not placed any orders
FULL OUTER JOIN Orders o ON c.CustomerNumber = o.CustomerNumber
FULL OUTER JOIN OrderItem oi ON o.InvoiceNumber = oi.InvoiceNumber
FULL OUTER JOIN Item i ON oi.ItemNumber = i.ItemNumber

GROUP BY
    c.CustomerNumber, c.FirstName, c.LastName

ORDER BY
    total_spent�DESC;


WITH OrderItemCounts AS (
    -- Calculate the total number of items for each order
    SELECT 
        oi.InvoiceNumber AS order_id,        -- Order ID from OrderItem table
        SUM(oi.Quantity) AS total_items      -- Total number of items in each order
    FROM 
        OrderItem oi
    GROUP BY 
        oi.InvoiceNumber                     -- Group by order ID to sum items per order
),
TotalAndCount AS (
    -- Calculate the total number of items across all orders and count the total number of orders
    SELECT 
        SUM(total_items) AS total_items_all_orders,    -- Sum of all items across all orders
        COUNT(*) AS total_orders                       -- Count of total number of orders
    FROM 
        OrderItemCounts                                -- Use the previous CTE to calculate totals
)
-- Select orders that contain more items than the average number of items per order
SELECT 
    o.InvoiceNumber AS order_id,                       -- Order ID from Orders table
    o.DeliveryAddress AS delivery_address,             -- Delivery address for the order
    CAST(o.Date_Time AS DATE) AS order_date,           -- Extract only the date from the order timestamp
    oic.total_items                                    -- Total number of items in this order
FROM 
    Orders o
JOIN 
    OrderItemCounts oic ON o.InvoiceNumber = oic.order_id   -- Join Orders with the OrderItemCounts CTE
CROSS JOIN 
    TotalAndCount tc                                       -- Cross join to compare with the overall average
WHERE 
    oic.total_items > (tc.total_items_all_orders / tc.total_orders)  -- Only select orders with more items than average
ORDER BY 
    oic.total_items DESC;                                  -- Order results by total number of items in descending order

GO