USE Company;
GO

CREATE VIEW OrderView AS
SELECT o.InvoiceNumber AS order_id,									--InvoiceNumber column in Orders table selected as order_id
	   o.CustomerNumber AS customer_id,								--CustomerNumber column in Orders table selected as customer_id
	   o.Date_Time AS order_date,									--Date_Time column in Orders table selected as order_date
	   ba.AddressNumber AS billing_addr_id,							--AddressNumber column in Address table selected as billing_addr_id
	   de.AddressNumber AS delivery_addr_id,						--AddressNumber column in Address table selected as delevery_addr_id
	   CONCAT(c.FirstName,' ',c.LastName) AS customer_name,			--Join FirstName and LastName columns in Customer table and selected as customer_name
	   o.BillingAddress AS billing_address,							--BillingAddress column in Order table selected as billing_address
	   o.DeliveryAddress AS delivery_address						--DeliveryAddress column in Order table selected as delevery_address

FROM
	Orders o                                                 --Order table containg details of each order

JOIN
	Customer c ON o.CustomerNumber=c.CustomerNumber		     --Join with Customer table to get customer details

JOIN
	Address ba ON o.BillingAddress = ba.Address				 --Join with Address table to get Billing address

JOIN
	Address de ON o.DeliveryAddress = de.Address;			 --Join with Address table to get Delivery address


GO

SELECT * FROM OrderView;


CREATE VIEW ItemView AS
SELECT 
    i.ItemNumber AS item_id,								-- ItemNumber column in Item table selected as item_id
    i.ItemName AS item_name,								-- ItemName column in Item table selected as item_name
    i.Description AS description,							-- Description column in Item table selected as description
    i.Price AS price,										-- Price column in Item table selected as price
    i.Cost AS cost,											-- Cost column in Item table selected as cost
	i.Stock AS stock,										-- Stock column in Item table selected as stock
	i.primary_supplier_id AS primary_supplier_id,			-- primary_supplier_id column in Item table is selected 
	i.secondary_supplier_id AS secondary_supplier_id,		-- secondary_supplier_id column in Item table is selected
    (i.Price - i.Cost) AS profit,							-- Get the difference of Price and Cost tables in Item table as Profit
    CONCAT(s1.BusinessName, ' (', s1.PhoneNumber, ', ', s1.Website, ')') AS primary_supplier_details,   -- Join BusinessName, PhoneNumber and Website columns in Supplier table and selected as primary_supplier_datail
    CASE 
        WHEN s2.BusinessName IS NOT NULL                                                -- If a secondary supplier is available
        THEN CONCAT(s2.BusinessName, ' (', s2.PhoneNumber, ', ', s2.Website, ')')		-- Join BusinessName, PhoneNumber and Website columns in Supplier table 
        ELSE 'N/A'																		-- If there is no secondary supplier
    END AS secondary_supplier_details
FROM 
    Item i
JOIN 
    Supplier s1 ON i.primary_supplier_id = s1.SupplierNumber     --Join with supplier table to get SupplierNumber of the primary suplier
LEFT JOIN 
    Supplier s2 ON i.secondary_supplier_id =s2.SupplierNumber	 -- Join with supplier table to get SupplierNumber of the Secondary suplier

GO


-- To view the contents of the created view
SELECT * FROM ItemView;