BEGIN


DECLARE counter INT;
DECLARE loopEnd INT;
DECLARE tempBatchId INT;

SET counter = 1;

-- Set BatchID's to NULL 

	SET @sql_clean = concat('UPDATE ',TABLE_NAME,' set batchId = null where cmpDataId=', CMPDATA_ID);
	PREPARE stmt FROM @sql_clean;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;


-- Get total number of rows
	SET @sql_select = concat('SELECT count(id) INTO @total FROM ',TABLE_NAME,' where cmpDataId=', CMPDATA_ID);
	PREPARE stmt FROM @sql_select;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;

SET loopEnd = CEIL(@total / BATCH_SIZE);

update_loop: LOOP

	IF counter > loopEnd THEN
      LEAVE update_loop;
    END IF;

	SET @sql_update = concat('UPDATE ',TABLE_NAME,' set batchId = ', counter, ' where batchId is null and cmpDataId=', CMPDATA_ID, ' limit ', BATCH_SIZE);
	PREPARE stmt FROM @sql_update;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
	
	SET counter = counter + 1;
END LOOP;

END