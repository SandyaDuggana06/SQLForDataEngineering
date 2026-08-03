CREATE TABLE [dbo].[payments] (

	[payment_id] int NOT NULL, 
	[order_id] int NULL, 
	[payment_date] date NULL, 
	[payment_method] varchar(30) NULL, 
	[payment_status] varchar(30) NULL, 
	[amount] decimal(12,2) NULL
);