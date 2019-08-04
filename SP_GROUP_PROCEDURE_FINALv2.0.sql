BEGIN

declare v_adviseur varchar(100);
declare tmpAdviseur varchar(100);
DECLARE cmpTmpTable varchar(100);
declare v_clientNo int;
DECLARE done int;
DECLARE counter int;

declare cur1 cursor for 
        SELECT  *            
    from cmpTmpTable
    ORDER BY AdviseurNummer;
declare continue handler for not found set done=1;
	
	SET cmpTmpTable := concat('cmpTmpTable ',CMPDATA_ID); 
	SET @v = concat('CREATE OR REPLACE VIEW ', cmpTmpTable,' as SELECT DISTINCT ', COLUMN_NAME, ' FROM ',TABLE_NAME,' WHERE cmpDataId = "',CMPDATA_ID,'" order by ', COLUMN_NAME);
    PREPARE stm FROM @v;
    EXECUTE stm;
    DEALLOCATE PREPARE stm;
	
    set done = 0;
	SET counter = 0;
	SET tmpAdviseur = '';
    open cur1;
    igmLoop: loop
        fetch cur1 into v_adviseur;
        if done = 1 then leave igmLoop; end if;
	
		IF tmpAdviseur <> v_adviseur THEN
			SET tmpAdviseur = v_adviseur;
			SET counter = counter + 1;
			
			SET @sql_update = concat('UPDATE ',TABLE_NAME,' set batchId = ', counter, ' where cmpDataId=', CMPDATA_ID, ' AND batchId is null AND AdviseurNummer=', v_adviseur);
			PREPARE stmt FROM @sql_update;
			EXECUTE stmt;
			DEALLOCATE PREPARE stmt;
		END IF;
		
    end loop igmLoop;
    close cur1;
END
