CREATE TABLE [dbo].[employees] (

	[employee_id] int NOT NULL, 
	[employee_name] varchar(100) NOT NULL, 
	[department] varchar(50) NULL, 
	[job_title] varchar(100) NULL, 
	[manager_id] int NULL, 
	[hire_date] date NULL, 
	[salary] decimal(12,2) NULL
);