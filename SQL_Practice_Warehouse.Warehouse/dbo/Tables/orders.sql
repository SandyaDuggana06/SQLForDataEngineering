CREATE TABLE [dbo].[orders] (

	[order_id] int NOT NULL, 
	[customer_id] int NULL, 
	[employee_id] int NULL, 
	[order_date] date NULL, 
	[order_status] varchar(30) NULL, 
	[shipping_country] varchar(50) NULL, 
	[shipping_cost] decimal(12,2) NULL, 
	[discount_amount] decimal(12,2) NULL
);