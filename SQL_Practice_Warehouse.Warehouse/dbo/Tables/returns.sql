CREATE TABLE [dbo].[returns] (

	[return_id] int NOT NULL, 
	[order_id] int NULL, 
	[product_id] int NULL, 
	[return_date] date NULL, 
	[return_reason] varchar(100) NULL, 
	[refund_amount] decimal(12,2) NULL
);