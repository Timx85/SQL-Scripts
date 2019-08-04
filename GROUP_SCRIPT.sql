set @pk1 ='';
set @rn1 =0;
set @val =0;

SELECT  AdviseurNummer,
        denseRank
FROM
(
  SELECT  AdviseurNummer,
          @rn1 := if(@pk1=AdviseurNummer, @rn1,@rn1+1) as denseRank,
          @val := if(@pk1=AdviseurNummer, 1,@val+1) as value,
          @pk1 := AdviseurNummer
  FROM
  (
    SELECT  AdviseurNummer            
    from cmpNavInputData
    where cmpDataId = 16
    ORDER BY AdviseurNummer
) A
) B  
ORDER BY `B`.`denseRank`  ASC
