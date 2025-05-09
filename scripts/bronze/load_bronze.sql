
/*
===============================================================================
Stored Procedure: Load Bronze Layer (Source -> Bronze)
===============================================================================
Script Purpose:
    This stored procedure loads data into the 'bronze' schema from external CSV files. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses the `BULK INSERT` command to load data from csv Files to bronze tables.

Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC bronze.load_bronze;
===============================================================================
*/
Create or ALTER   procedure [bronze].[load_bronze] as 
begin
	declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	begin try
		set @batch_start_time = getdate();
	
		print '===============================================';
		print 'Loading Bronze Layer';
		print '===============================================';

		print '-----------------------------------------------';
		print 'Loading CRM Tables';
		print '-----------------------------------------------';
		set @start_time = GETDATE(); 
		TRuncate table bronze.crm_cust_info;
		BULK INSERT bronze.crm_cust_info
		from 'C:\Users\hp\Downloads\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		with (
		  firstrow = 2,
		  fieldterminator = ',',
		  tablock
		);
		set @end_time = GETDATE();

		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'Seconds';

		print '---------------------------------------------------';

		set @start_time = GETDATE();

		Truncate table bronze.crm_prd_info;
		BULK INSERT bronze.crm_prd_info
		from 'C:\Users\hp\Downloads\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		with(
		  firstrow = 2,
		  fieldterminator = ',',
		  tablock
		);

		set @end_time = GETDATE();

		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'Seconds';

		print '-------------------------------------------------------';

		set @start_time = GETDATE();

		truncate table bronze.crm_sales_details;
		Bulk insert bronze.crm_sales_details
		from 'C:\Users\hp\Downloads\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		with(
			  firstrow = 2,
			  fieldterminator = ',',
			  tablock
		);

		set @end_time = GETDATE();

		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'Seconds';


		print '-----------------------------------------------';
		print 'Loading CRM Tables';
		print '-----------------------------------------------';

		set @start_time = GETDATE();

		truncate table bronze.erp_cust_az12;
		Bulk insert bronze.erp_cust_az12
		from 'C:\Users\hp\Downloads\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		with(
			  firstrow = 2,
			  fieldterminator = ',',
			  tablock
		);

		set @end_time = getdate();

		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'Seconds';


		print '-------------------------------------------------------------';

		set @start_time = GETDATE();

		truncate table bronze.erp_loc_a101;
		Bulk insert bronze.erp_loc_a101
		from 'C:\Users\hp\Downloads\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		with(
			  firstrow = 2,
			  fieldterminator = ',',
			  tablock
		);

		set @end_time = GETDATE();

		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'Seconds';


		print '--------------------------------------------------------------';

		set @start_time = GETDATE();

		truncate table bronze.erp_px_cat_g1v2;
		Bulk insert bronze.erp_px_cat_g1v2
		from 'C:\Users\hp\Downloads\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		with(
			  firstrow = 2,
			  fieldterminator = ',',
			  tablock
		);

		set @end_time = GETDATE();

		print '>> Load Duration: ' + cast(datediff(second, @start_time, @end_time) as nvarchar) + 'Seconds';

		set @batch_end_time = getdate();
		
		
		print '===============================================================';
		print 'Loading Bronze Layer is Completed';
		print 'Total Load Duration: ' + cast(datediff(second, @batch_start_time, @batch_end_time) as nvarchar) + 'seconds';
		print '=================================================================';

	end try
	begin catch
		print '====================================================';
		print 'ERROR OCCCURED DUIRNG LOADING LAYER'
		print 'Error Message' + Error_message();
		print 'Error Message number' + cast(error_number() as nvarchar);
		print 'Error Message state' + cast(error_state() as varchar);
	end catch
end

EXEC bronze.load_bronze;

