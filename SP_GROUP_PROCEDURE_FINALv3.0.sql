BEGIN

declare v_adviseur varchar(100);
declare tmpAdviseur varchar(100);
declare v_clientNo int;
DECLARE done int;
DECLARE counter int;

declare cur1 cursor for 
        SELECT  *            
    from cmpTmpTable;
declare continue handler for not found set done=1;
                
                SET @v = concat('CREATE OR REPLACE VIEW cmpTmpTable as SELECT distinct ', COLUMN_NAME, ' FROM ',TABLE_NAME,' WHERE cmpDataId = "',CMPDATA_ID,'" order by ', COLUMN_NAME);
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
                
			SET counter = counter + 1;
                                
            SET @sql_update = concat('UPDATE ',TABLE_NAME,' set batchId = ', counter, ' where cmpDataId=', CMPDATA_ID, ' AND ', COLUMN_NAME, '= ?');
            PREPARE stmt FROM @sql_update;
                                
            SET @v_adviseur = v_adviseur;
            EXECUTE stmt USING @v_adviseur;
            DEALLOCATE PREPARE stmt;
                                
    end loop igmLoop;
    close cur1;
END
