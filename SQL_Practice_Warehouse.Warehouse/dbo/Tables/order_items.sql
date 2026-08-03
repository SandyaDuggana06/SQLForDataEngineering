CREATE TABLE [dbo].[order_items] (

	[order_item_id] int NOT NULL, 
	[order_id] int NULL, 
	[product_id] int NULL, 
	[quantity] int NULL, 
	[unit_price] decimal(12,2) NULL
);