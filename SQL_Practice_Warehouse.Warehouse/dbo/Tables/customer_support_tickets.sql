CREATE TABLE [dbo].[customer_support_tickets] (

	[ticket_id] int NOT NULL, 
	[customer_id] int NULL, 
	[created_date] date NULL, 
	[resolved_date] date NULL, 
	[ticket_category] varchar(50) NULL, 
	[priority] varchar(20) NULL, 
	[ticket_status] varchar(30) NULL
);