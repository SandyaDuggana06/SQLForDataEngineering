CREATE TABLE [dbo].[products] (

	[product_id] int NOT NULL, 
	[product_name] varchar(150) NOT NULL, 
	[category_id] int NULL, 
	[unit_price] decimal(12,2) NULL, 
	[cost_price] decimal(12,2) NULL, 
	[stock_quantity] int NULL, 
	[supplier_name] varchar(100) NULL, 
	[is_active] varchar(10) NULL
);