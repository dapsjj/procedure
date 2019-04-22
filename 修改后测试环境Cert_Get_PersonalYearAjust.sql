USE [dbEmployee]
GO

/****** Object:  StoredProcedure [dbo].[Cert_Get_PersonalYearAjust]    Script Date: 2019/04/20 12:54:58 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--***********************************************************************  
--CREATEBY: liubaoshan  
--CREATEDATE:2015/10/09  
--MODIFYBY:宋家軍
--MODIFYDATE:2019/04/22(変更内容:令和年号の調整)
--REMARKS:年末調整２次から個人源泉徴収票・ 証明書用
--exec Cert_Get_PersonalYearAjust 1129,1,1129,1  
--***********************************************************************  
  
ALTER                                                           PROC [dbo].[Cert_Get_PersonalYearAjust]  
@AdminID VARCHAR(50)          --登録者コード  
,@EmployeeOrder tinyint           --社員順　１：昇順　2.降順  
,@LoginCD  VARCHAR(50)        --トラボウズのログイン者コード  
,@PageFlag tinyint                   --PageFlag = 1 トラボウズから PageFlag = 2 印刷画面から  
  
AS  
  
  
DECLARE @AdjustYear INT  
SELECT @AdjustYear = isnull(min(AdjustYear ),2014)  
FROM dbYearAjust.dbo.TaxPrintEmployeeInfo  
WHERE AdminID = @AdminID  



/*SELECT @AdjustYear = AdjustYear   
FROM dbo.mstYearAdjust  
WHERE Yearflag = 1  
*/  

DECLARE @SQL1 VARCHAR(8000)  
DECLARE @SQL2 VARCHAR(8000)  
DECLARE @SQL3 VARCHAR(8000)  
DECLARE @SQL4 VARCHAR(8000)  
DECLARE @SQL5 VARCHAR(8000)  
DECLARE @SQL6 VARCHAR(8000)  
DECLARE @SQL7 VARCHAR(8000)  
DECLARE @SQL8 VARCHAR(8000)  
DECLARE @SQL9 VARCHAR(8000)  
DECLARE @SQL10 VARCHAR(8000)  
DECLARE @SQL11 VARCHAR(8000)  
DECLARE @SQL12 VARCHAR(8000)  
DECLARE @YearStart VARCHAR(10)  

--DECLARE @SQL VARCHAR(8000)
DECLARE @PrintRange  tinyint   --印刷範囲を選択　1:個人毎に　2:所属毎に　3:市町村毎に  
DECLARE @EmpDivision  tinyint --全て=1, 特別徴(社員、契約社員)=2 , 普通徴(AS)=3, 退職者の徴収(退職者)=4  
SELECT TOP 1  @EmpDivision=EmployeeDivision ,@PrintRange = PrintRange FROM  dbYearAjust.dbo.TaxPrintEmployeeInfo  WHERE AdminID = @AdminID  
-- 20101230 2011になると、22年の源泉の計算が間違うになるのため  
--　GetDate()は2010年の固定日'2010/12/01'に変わる  
SELECT  @YearStart =  convert(varchar(4),@AdjustYear) + '/01/01'  

-- 一．基本情報  
--SET @SQL1 =  'SELECT  10085270 2015/09/22 UPDATE
--SET @SQL1 =  'SELECT (SELECT TOP 1 Name FROM dbEmployee.dbo.CertificateYearMonth WHERE ID =  1) AS 年月日  10061820 20161221 update
SET @SQL1 =  'SELECT ISNULL((SELECT TOP 1 Name FROM dbEmployee.dbo.CertificateYearMonth WHERE ID = '+ CONVERT(varchar,@AdjustYear)+'  ),'''' )AS 年月日
           ,ME.Employee_division
           ,OME.住民票郵便番号1 +''-'' + OME.住民票郵便番号2  AS ''郵便番号''  
 ,OME.住民票住所1+ case  when OME.住民票住所2=''-'' then '''' else OME.住民票住所2 end    AS ''住所''  
 --,OME.コード AS ''受給者番号''  
           ,Replace(space(8-len(OME.コード)),'' '',''0'')+CAST(OME.コード AS nvarchar(18))  AS ''受給者番号''  
 ,OME.氏名ｶﾅ AS ''フリガナ''  
 ,OME.氏名 AS ''役職名'''    
-- 二．給与・賞与欄  
  
SET @SQL2 = ',''給料・賞与'' AS ''給料・賞与''  
 ,OYAA.合計課税総額 AS ''合計課税総額''  
 ,OYAA.所得控除後金額 AS ''所得控除後金額''  
 ,OYAA.所得控除額合計 AS ''所得控除額合計''  
 ,CASE WHEN ( (OYAA.年度 = 2010 and OYAA.税額表区分 = 2) or (OYAA.年度 >= 2011 and OYAA.対象者区分 = 0)  ) THEN OYAA.合計徴収済税額 ELSE OYAA.差引年税額 END AS ''差引年税額'''  
 --,OYAA.DifYearTax AS ''差引年税額'''   
-- 三．扶養控除欄  
  
SET @SQL3 = ',CASE WHEN OME.対象者区分=1 AND OME.配偶者控除区分 = 1  
  THEN ''＊''  
  ELSE ''''  
  END AS ''控除対象配偶者の有''  
 ,CASE WHEN OME.対象者区分=1 AND OME.配偶者控除区分 = 0  
  THEN ''＊''  
  ELSE ''''  
  END AS ''控除対象配偶者の無''  
 ,CASE WHEN OME.対象者区分=1 AND OME.配偶者控除区分 = 2  
  THEN ''＊''  
  ELSE ''''  
  END AS ''控除対象配偶者の老人''  
  
  ,CASE WHEN OME.対象者区分=1 then OYAA.配特別控除額 else 0 end  AS ''配特別控除額''  
 ,CASE WHEN OME.対象者区分=1 then OME.特定扶養親族 else 0 end           AS ''扶養親族の数特定の人''  
 ,CASE WHEN OME.対象者区分=1 then OME.同居老親等 else 0 end AS ''扶養親族の数老人の内''  
 ,CASE WHEN OME.対象者区分=1 then OME.老人扶養親族数+OME.同居老親等 else 0 end AS ''扶養親族の数老人の人''  
 ,CASE WHEN OME.対象者区分=1 then OME.一般扶養親族 else 0 end AS ''扶養親族の数その他の人''  
 ,CASE WHEN OME.対象者区分=1 then OME.同居特別障害者 else 0 end AS ''障害者の数特定の内''  
 ,CASE WHEN OME.対象者区分=1 then OME.特別障害者 else 0 end AS ''障害者の数特定の人''  
 ,CASE WHEN OME.対象者区分=1 then OME.一般障害者 else 0 end AS ''障害者の数その他の人''  
  
 ,OYAA.合計社保控除額 AS ''合計社保控除額''   
 ,OYAA.合計生保控除 AS ''合計生保控除''--生命保険料の控除額  
--20101022  
-- ,OYAA.EarthquakeInsDeduct AS ''地震険料の控除額''  
           ,OYAA.合計地震控除 AS ''合計地震控除''--地震険料の控除額  
 ,OYAA.住宅特別控除  AS ''住宅借入金等特別控除の額''  
 ,OYAA.配偶者合計所得 AS ''配偶者の合計所得''  
 ,OYAA.個人年金調整  AS ''個人年金保険料の金額''  
 ,OYAA.長期損保調整  AS ''旧長期損害保険の金額''   
--10025763 201209 add  
 ,OYAA.介護医療調整 AS ''介護医療保険料''  
 ,OYAA.新個人年金調整 AS ''新個人年金保険料''  
 ,OYAA.新生保支払調整 AS ''新生命保険料''  
 ,OYAA.生保支払調整 AS ''旧生命保険料''  
 '   
  
-- 四．摘要欄  
SET @SQL4 = ',OYAB.摘要1            AS ''摘要1''  
                    ,ISNULL(OYAB.摘要2,'''') + ''   '' + ISNULL(OYAB.摘要3,'''')+ ''   '' + ISNULL(OYAB.摘要4,'''')    AS ''摘要3'''  
                    -- ,OYAB.Abstract2            AS ''摘要2''  
                    -- ,OYAB.Abstract3            AS ''摘要3''  
                    -- ,CONVERT(VARCHAR(100),OYAB.Abstract2) + ''　'' + CONVERT(VARCHAR(100),OYAB.Abstract3) AS ''摘要3'''--OBIC_YearAbstract  


--2019/04/22 10113982 宋家軍 抹消 begin
/*
--五．特別処置欄  
                      --,CASE WHEN DATEDIFF( YEAR, CONVERT(DATETIME,OME.生年月日), GETDATE() ) < 18  
SET @SQL5 = ',CASE WHEN DATEDIFF(DAY, (CONVERT(VARCHAR(4),(YEAR(''2012/12/01'') - 19))+ ''/01/03''),OME.生年月日) > 0   
  THEN ''＊''  
  ELSE ''''  
  END   AS ''未成年者''  
 ,CASE WHEN ( (OYAA.年度 = 2010 and OYAA.税額表区分 = 2) or (OYAA.年度 >= 2011 and OYAA.税額表区分 = 1) )  
                      THEN ''＊''  
                      ELSE ''''  
                      END                            AS ''乙欄''  
-- ,CASE WHEN ( OME.本人障害者 = 1 AND OME.本人特別障害者 = 1 )  
 ,CASE WHEN ( OME.対象者区分=1 and OME.本人特別障害者 = 1 )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''本人が障害者の特別''  
-- ,CASE WHEN ( OME.DisabilityFlag = 1 AND OME.SpecialDisabilityFlag = 0 )  
 ,CASE WHEN (  OME.対象者区分=1 and OME.本人障害者 = 1 )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''本人が障害者のその他''  
--20101022  
--  ,CASE WHEN ( OME.WidowFlag = 1 AND OME.SpecialWidowFlag = 0 )  
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人寡婦 = 1)  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''寡婦の一般''  
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人寡婦 = 2 )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''寡婦の特別''  
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人寡婦 = 3 )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''寡夫''  
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人勤労学生 = 1 )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''勤労学生''  
--  ,''''    AS ''死亡退職''  
--  ,''''    AS ''災害者''  
--  ,''''    AS ''外国人''  
  
 ,CASE WHEN ( OME.休職退職区分 = 0 AND OME.入社年月日 >= ''' + @YearStart + ''' and (OME.退職年月日 = '''' or OME.退職年月日 is null) )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''就職''  
 ,CASE WHEN (  (( OME.休職退職区分 = 2 and OME.年度=2010)  or(OME.退職年月日 <> '''' and OME.年度 >= 2011))  AND OME.入社年月日 <> ''''  )   
  THEN ''＊''  
  ELSE ''''  
  END   AS ''退職''  
 ,CASE WHEN ( OME.休職退職区分 = 0 AND OME.入社年月日 >= ''' + @YearStart + ''' and (OME.退職年月日 = '''' or OME.退職年月日 is null)  )   
  THEN substring(dbYearAjust.dbo.FN_Year_GetYear(OME.入社年月日),3,2)  
  WHEN (  (( OME.休職退職区分 = 2 and OME.年度=2010)  or( OME.退職年月日 <> '''' and OME.年度 >= 2011)) AND OME.入社年月日 <> ''''  )   
  THEN substring(dbYearAjust.dbo.FN_Year_GetYear(OME.退職年月日),3,2)  
  ELSE ''''  
  END   AS ''中途の年''  
 ,CASE WHEN ( OME.休職退職区分 = 0 AND OME.入社年月日 >= ''' + @YearStart + '''  and (OME.退職年月日 = '''' or OME.退職年月日 is null) )  
  THEN (CASE WHEN  CONVERT(VARCHAR,MONTH(OME.入社年月日)) < 10  
                                        THEN (''0'' + CONVERT(VARCHAR,MONTH(OME.入社年月日)))  
                                         ELSE CONVERT(VARCHAR,MONTH(OME.入社年月日))  END)  
  WHEN (  (( OME.休職退職区分 = 2 and OME.年度=2010)  or( OME.退職年月日 <> '''' and  OME.年度 >= 2011)) AND OME.入社年月日 <> '''' )  
  THEN (CASE WHEN CONVERT(VARCHAR,MONTH(OME.退職年月日)) < 10  
                                         THEN (''0'' + CONVERT(VARCHAR,MONTH(OME.退職年月日)))  
                                         ELSE CONVERT(VARCHAR,MONTH(OME.退職年月日))  END )  
  ELSE ''　''  
  END    AS ''中途の月''  
 ,CASE WHEN ( OME.休職退職区分 = 0 AND OME.入社年月日 >= ''' + @YearStart + '''  and(OME.退職年月日 = '''' or OME.退職年月日 is null) )  
  THEN (CASE WHEN CONVERT(VARCHAR,DAY(OME.入社年月日)) < 10  
                                         THEN (''0'' + CONVERT(VARCHAR,DAY(OME.入社年月日)))  
                                         ELSE CONVERT(VARCHAR,DAY(OME.入社年月日)) END)  
  WHEN (  (( OME.休職退職区分 = 2 and OME.年度=2010)  or( OME.退職年月日 <> '''' and  OME.年度 >= 2011)) AND OME.入社年月日 <> '''' )  
  THEN  ( CASE WHEN CONVERT(VARCHAR,DAY(OME.退職年月日)) < 10  
                                          THEN (''0'' + CONVERT(VARCHAR,DAY(OME.退職年月日)))  
                                          ELSE CONVERT(VARCHAR,DAY(OME.退職年月日)) END)  
  ELSE ''　''  
  END    AS ''中途の日''  
  
 ,CASE WHEN SUBSTRING(( dbYearAjust.dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''明'' --★  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''受給者生年明''  
 ,CASE WHEN SUBSTRING(( dbYearAjust.dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''大'' --★  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''受給者生年大''  
 ,CASE WHEN SUBSTRING(( dbYearAjust.dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''昭'' --★  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''受給者生年昭''  
 ,CASE WHEN SUBSTRING(( dbYearAjust.dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''平'' --★  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''受給者生年平''  
 ,SUBSTRING(dbYearAjust.dbo.FN_Year_GetYear(OME.生年月日),3,2) AS ''生年の年''  
 ,CASE WHEN MONTH(OME.生年月日) < 10  
                     THEN (''0'' + CONVERT(VARCHAR(2),MONTH(OME.生年月日)))  
                     ELSE CONVERT(VARCHAR(2),MONTH(OME.生年月日))   
                     END                             AS ''生年の月''  
 ,CASE WHEN DAY(OME.生年月日) < 10  
                     THEN (''0'' + CONVERT(VARCHAR(2),DAY(OME.生年月日)))  
                     ELSE CONVERT(VARCHAR(2),DAY(OME.生年月日))  
                     END                             AS ''生年の日'''   
*/

--2019/04/22 10113982 宋家軍 抹消 end


--2019/04/22 10113982 宋家軍 増加 begin
--五．特別処置欄  
                      --,CASE WHEN DATEDIFF( YEAR, CONVERT(DATETIME,OME.生年月日), GETDATE() ) < 18  

SET @SQL5 = ',CASE WHEN DATEDIFF(DAY, (CONVERT(VARCHAR(4),(YEAR(''2012/12/01'') - 19))+ ''/01/03''),OME.生年月日) > 0   
  THEN ''＊''  
  ELSE ''''  
  END   AS ''未成年者''  
 ,CASE WHEN ( (OYAA.年度 = 2010 and OYAA.税額表区分 = 2) or (OYAA.年度 >= 2011 and OYAA.税額表区分 = 1) )  
                      THEN ''＊''  
                      ELSE ''''  
                      END                            AS ''乙欄''  
-- ,CASE WHEN ( OME.本人障害者 = 1 AND OME.本人特別障害者 = 1 )  
 ,CASE WHEN ( OME.対象者区分=1 and OME.本人特別障害者 = 1 )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''本人が障害者の特別''  
-- ,CASE WHEN ( OME.DisabilityFlag = 1 AND OME.SpecialDisabilityFlag = 0 )  
 ,CASE WHEN (  OME.対象者区分=1 and OME.本人障害者 = 1 )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''本人が障害者のその他''  
--20101022  
--  ,CASE WHEN ( OME.WidowFlag = 1 AND OME.SpecialWidowFlag = 0 )  
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人寡婦 = 1)  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''寡婦の一般''  
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人寡婦 = 2 )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''寡婦の特別''  
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人寡婦 = 3 )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''寡夫''  
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人勤労学生 = 1 )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''勤労学生''  
--  ,''''    AS ''死亡退職''  
--  ,''''    AS ''災害者''  
--  ,''''    AS ''外国人''  
  
 ,CASE WHEN ( OME.休職退職区分 = 0 AND OME.入社年月日 >= ''' + @YearStart + ''' and (OME.退職年月日 = '''' or OME.退職年月日 is null) )  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''就職''  
 ,CASE WHEN (  (( OME.休職退職区分 = 2 and OME.年度=2010)  or(OME.退職年月日 <> '''' and OME.年度 >= 2011))  AND OME.入社年月日 <> ''''  )   
  THEN ''＊''  
  ELSE ''''  
  END   AS ''退職''  
 ,CASE WHEN ( OME.休職退職区分 = 0 AND OME.入社年月日 >= ''' + @YearStart + ''' and (OME.退職年月日 = '''' or OME.退職年月日 is null)  )   
  THEN substring(dbYearAjust.dbo.FN_Year_GetYear(OME.入社年月日),3,2)  
  WHEN (  (( OME.休職退職区分 = 2 and OME.年度=2010)  or( OME.退職年月日 <> '''' and OME.年度 >= 2011)) AND OME.入社年月日 <> ''''  )   
  THEN substring(dbYearAjust.dbo.FN_Year_GetYear(OME.退職年月日),3,2)  
  ELSE ''''  
  END   AS ''中途の年''  
 ,CASE WHEN ( OME.休職退職区分 = 0 AND OME.入社年月日 >= ''' + @YearStart + '''  and (OME.退職年月日 = '''' or OME.退職年月日 is null) )  
  THEN (CASE WHEN  CONVERT(VARCHAR,MONTH(OME.入社年月日)) < 10  
                                        THEN (''0'' + CONVERT(VARCHAR,MONTH(OME.入社年月日)))  
                                         ELSE CONVERT(VARCHAR,MONTH(OME.入社年月日))  END)  
  WHEN (  (( OME.休職退職区分 = 2 and OME.年度=2010)  or( OME.退職年月日 <> '''' and  OME.年度 >= 2011)) AND OME.入社年月日 <> '''' )  
  THEN (CASE WHEN CONVERT(VARCHAR,MONTH(OME.退職年月日)) < 10  
                                         THEN (''0'' + CONVERT(VARCHAR,MONTH(OME.退職年月日)))  
                                         ELSE CONVERT(VARCHAR,MONTH(OME.退職年月日))  END )  
  ELSE ''　''  
  END    AS ''中途の月''  
 ,CASE WHEN ( OME.休職退職区分 = 0 AND OME.入社年月日 >= ''' + @YearStart + '''  and(OME.退職年月日 = '''' or OME.退職年月日 is null) )  
  THEN (CASE WHEN CONVERT(VARCHAR,DAY(OME.入社年月日)) < 10  
                                         THEN (''0'' + CONVERT(VARCHAR,DAY(OME.入社年月日)))  
                                         ELSE CONVERT(VARCHAR,DAY(OME.入社年月日)) END)  
  WHEN (  (( OME.休職退職区分 = 2 and OME.年度=2010)  or( OME.退職年月日 <> '''' and  OME.年度 >= 2011)) AND OME.入社年月日 <> '''' )  
  THEN  ( CASE WHEN CONVERT(VARCHAR,DAY(OME.退職年月日)) < 10  
                                          THEN (''0'' + CONVERT(VARCHAR,DAY(OME.退職年月日)))  
                                          ELSE CONVERT(VARCHAR,DAY(OME.退職年月日)) END)  
  ELSE ''　''  
  END    AS ''中途の日''  
 ,CASE WHEN SUBSTRING(( dbYearAjust.dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''大'' --★  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''受給者生年大''  
 ,CASE WHEN SUBSTRING(( dbYearAjust.dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''昭'' --★  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''受給者生年昭''  
 ,CASE WHEN SUBSTRING(( dbYearAjust.dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''平'' --★  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''受給者生年平''  
 ,CASE WHEN SUBSTRING(( dbYearAjust.dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''令'' --★  
  THEN ''＊''  
  ELSE ''''  
  END   AS ''受給者生年令''
 ,SUBSTRING(dbYearAjust.dbo.FN_Year_GetYear(OME.生年月日),3,2) AS ''生年の年''  
 ,CASE WHEN MONTH(OME.生年月日) < 10  
                     THEN (''0'' + CONVERT(VARCHAR(2),MONTH(OME.生年月日)))  
                     ELSE CONVERT(VARCHAR(2),MONTH(OME.生年月日))   
                     END                             AS ''生年の月''  
 ,CASE WHEN DAY(OME.生年月日) < 10  
                     THEN (''0'' + CONVERT(VARCHAR(2),DAY(OME.生年月日)))  
                     ELSE CONVERT(VARCHAR(2),DAY(OME.生年月日))  
                     END                             AS ''生年の日'''   

--2019/04/22 10113982 宋家軍 増加 end 

  
--六．会社情報欄  
  
 SET @SQL6 = ',MSTC.Company_Postal  AS ''会社郵便番号''  
           ,MSTC.Company_Address    AS ''会社所在地''  
 ,MSTC.Company_Name                  AS ''会社名''  
 ,MSTC.Company_Tel                      AS ''会社電話番号'' '  
  
--明細データ  
SET @SQL7 = ', OYAA.年調給与額     AS ''合計総支給額''  
                      , OYAA.給非課税調整    AS ''合計非課税額''  
                      , OYAA.年調給与額  AS ''年調給与額''  
                      , OYAA.申社保年金分               AS ''申社保年金分''  
                      , OYAA.小規模企業共済       AS ''小規模企業共済''  
                      , OYAA.基礎控除等合計            AS ''基礎控除等合計''  
                      , OYAA.差引課税所得額                      AS ''差引課税所得額''  
                      , OYAA.年税額                         AS ''年税額''  
                      , OYAA.特減税還付額                      AS ''特減税還付額''  
                      , OYAA.住宅特別控除       AS ''住宅特別控除''  
                      , OYAA.差引年税額                      AS ''差引年税額1''  
                      , OYAA.合計徴収済税額                AS ''合計徴収済税額''  
                      , OYAA.差引過不足          AS ''差引過不足''  
                      , OYAA.差引超過額                       AS ''差引超過額''  
                      , OYAA.差引不足額                    AS ''差引不足額''  
                      , OYAA.基礎控除                   AS ''基礎控除''  
                      , OYAA.本人障害控除         AS ''本人障害控除''  
                      , OYAA.本人特障控除    AS ''本人特障控除''  
                      , OYAA.本人老年控除                     AS ''本人老年控除''  
                      , OYAA.本人寡婦控除                  AS ''本人寡婦控除''  
                      , OYAA.本人特別寡婦              AS ''本人特別寡婦''  
                      , OYAA.本人寡夫控除              AS ''本人寡夫控除''  
                      , OYAA.本人勤労学生                     AS ''本人勤労学生''  
                      , OYAA.配偶者控除                AS ''配偶者控除''  
                      , OYAA.配偶者老控除            AS ''配偶者老控除''  
                      , OYAA.一般扶養控除    AS ''一般扶養控除''  
                      , OYAA.特定扶養控除       AS ''特定扶養控除''  
                      , OYAA.同居老親等控除      AS ''同居老親等控除''  
                      , OYAA.同居老親等以外   AS ''同居老親等以外''  
                      , OYAA.障害者控除                AS ''障害者控除''  
                      , OYAA.特障害者控除           AS ''特障害者控除''  
                      , OYAA.同居特障控除              AS ''同居特障控除''  
                      , OME.所属3名                        AS ''事務所''  
                      , OME.所属2名                AS ''部門''  
                      , (dbYearAjust.dbo.FN_Year_GetYear(CONVERT(VARCHAR(4),OYAA.対象年月)))  
                       + ''年分''    AS ''対象年''  
                      , (dbYearAjust.dbo.FN_Year_GetYear(''' + CONVERT(VARCHAR(4),@AdjustYear) + '/12/01''))  AS ''今年''   
  ,OME.年少扶養人数 as ''年少扶養親族'''  
  
SET @SQL8 =  ' FROM   dbYearAjust.dbo.Ajust_V_BasisDate_Print ME  
                         INNER JOIN  dbYearAjust.dbo.OBIC_mstEmployeeBasicInforNew OME   
                         ON OME.コード = ME.EmployeeCode  
   
  and OME.年度 = '+CONVERT(VARCHAR(4),@AdjustYear)+'  
                         INNER JOIN  dbYearAjust.dbo.OBIC_YearAdjustAllNew OYAA  
                         ON OYAA.コード = OME.コード  
     and OME.会社CD = OYAA.会社NO   
  and OYAA.年度 = '+CONVERT(VARCHAR(4),@AdjustYear)+'  
                         LEFT JOIN dbYearAjust.dbo.OBIC_YearAbstractNew OYAB  
                         ON OME.コード = OYAB.コード  
   and OME.会社CD = OYAB.会社NO   
  and OYAB.年度 = '+CONVERT(VARCHAR(4),@AdjustYear) + '  
  
                         INNER JOIN dbYearAjust.dbo.mstCompany MSTC  
   ON   ( (OME.会社CD = 1 and MSTC.Company_code = 10001)  
       or  (OME.会社CD = 3 and MSTC.Company_code = 10003)  
       or  (OME.会社CD = 5 and MSTC.Company_code = 10014)  
       or  (OME.会社CD = 6 and MSTC.Company_code = 10015)  
       or  (OME.会社CD = 7 and MSTC.Company_code = 10016 )  
    or (OME.会社CD = 8 and MSTC.Company_code = 10017 )  
or (OME.会社CD = 9 and MSTC.Company_code = 10018 )  
		-- 2200424 20150409 ADD 
		or  (OME.会社CD = 20 and MSTC.Company_code = 10020 )
		or  (OME.会社CD = 21 and MSTC.Company_code = 10021 )
		or  (OME.会社CD = 22 and MSTC.Company_code = 10022 )
		or  (OME.会社CD = 23 and MSTC.Company_code = 10023 )
		or  (OME.会社CD = 24 and MSTC.Company_code = 10024 )
		-- 2200424 20150409 ADD  
   )  
                      and MSTC.AdjustYear = '+CONVERT(VARCHAR(4),@AdjustYear)  
if @PageFlag = 2  
begin  
  
    IF @PrintRange = 1  
    begin   
        SET @SQL9 = ' INNER JOIN dbYearAjust.dbo.TaxPrintEmployeeInfo TPEI ON TPEI.Code = OME.コード AND TPEI.AdminID =' + @AdminID  
    end  
    ELSE IF @PrintRange = 2   
   
        SET @SQL9 = ' INNER JOIN dbYearAjust.dbo.TaxPrintEmployeeInfo TPEI ON (CONVERT(VARCHAR(10),ME.StoreCD)+'',''  
                    +CONVERT(VARCHAR(10),ME.AffiliationCD)) = TPEI.Code AND TPEI.AdminID =' + @AdminID  
    ELSE   
        SET @SQL9 = ' INNER JOIN dbYearAjust.dbo.TaxPrintEmployeeInfo TPEI ON OME.[当年1/1市町村] = TPEI.Code AND TPEI.AdminID =' + @AdminID  
  
    --社員区分  
    IF @EmpDivision = 1  
 SET @SQL10 = ''  
    ELSE IF @EmpDivision = 2  
 SET  @SQL10 = ' WHERE (ME.Employee_division=1 OR  ME.Employee_division=3) AND ME.Retirement_division <> 1 AND ME.Retirement_division <> 2'  
    ELSE IF @EmpDivision = 3  
 SET  @SQL10 = ' WHERE ME.Employee_division=4 AND ME.Retirement_division <> 1 AND ME.Retirement_division <> 2'  
    ELSE IF  @EmpDivision = 4  
 SET  @SQL10 = ' WHERE  ME.Retirement_division = 1 OR ME.Retirement_division = 2'  
 ELSE IF  @EmpDivision = 5  
 SET  @SQL10 = ' WHERE  ME.Employee_division=4 OR (ME.Retirement_division = 1 OR ME.Retirement_division = 2 )'  
  
    IF @EmployeeOrder = 1  
 SET @SQL11 = ' ORDER BY ME.EmployeeCode '  
    ELSE    
 SET @SQL11 =' ORDER BY ME.EmployeeCode DESC'  
    print (@SQL1 + @SQL2 + @SQL3 + @SQL4 + @SQL5 + @SQL6 + @SQL7 + @SQL8 + @SQL9 + @SQL10 + @SQL11)  
    EXEC  (@SQL1 + @SQL2 + @SQL3 + @SQL4 + @SQL5 + @SQL6 + @SQL7 + @SQL8 + @SQL9 + @SQL10 + @SQL11)  
  
END  --@PageFlag = 2  
ELSE IF @PageFlag = 1  
BEGIN  
  
    set @SQL12 = ' where ME.EmployeeCode =' + @LoginCD  
 print (@SQL1 + @SQL2 + @SQL3 + @SQL4 + @SQL5 + @SQL6 + @SQL7 + @SQL8 + @SQL12)  
    EXEC  (@SQL1 + @SQL2 + @SQL3 + @SQL4 + @SQL5 + @SQL6 + @SQL7 + @SQL8 + @SQL12)  
     
END  
  
SELECT    Information_Content  AS 'お知らせ内容'  
FROM       dbYearAjust.dbo.mstInfomation


GO


