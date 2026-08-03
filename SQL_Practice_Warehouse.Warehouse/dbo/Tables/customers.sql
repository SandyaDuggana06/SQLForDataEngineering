CREATE TABLE [dbo].[customers] (

	[customer_id] int NOT NULL, 
	[customer_name] varchar(100) NOT NULL, 
	[email] varchar(150) NULL, 
	[country] varchar(50) NULL, 
	[city] varchar(100) NULL, 
	[signup_date] date NULL, 
	[customer_segment] varchar(30) NULL, 
	[referral_customer_id] int NULL
);