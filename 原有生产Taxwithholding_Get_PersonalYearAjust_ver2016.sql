USE [dbYearAjust]
GO

/****** Object:  StoredProcedure [dbo].[Taxwithholding_Get_PersonalYearAjust_ver2016]    Script Date: 2019/04/18 16:59:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




--exec Taxwithholding_Get_PersonalYearAjust_ver2016 2200166,1,2200166,2  


--***********************************************************************  
--CREATEBY: 李艶紅  
--CREATEDATE:2010/10/19  
--REMARKS:年末調整２次、個人源泉徴収票・年調明細票用  
--exec Taxwithholding_Get_PersonalYearAjust_ver2016_test 1129,1,118,2   --10056307
--exec Taxwithholding_Get_PersonalYearAjust_ver2016 1129,1,118,2  
--***********************************************************************  
  
CREATE  PROC [dbo].[Taxwithholding_Get_PersonalYearAjust_ver2016]  
@AdminID VARCHAR(50)          --登録者コード  
,@EmployeeOrder tinyint           --社員順　１：昇順　2.降順  
,@LoginCD  VARCHAR(50)        --トラボウズのログイン者コード  
,@PageFlag tinyint                   --PageFlag = 1 トラボウズから PageFlag = 2 印刷画面から  
  
AS  
  
  
DECLARE @AdjustYear INT  
SELECT @AdjustYear = isnull(min(AdjustYear ),2017)  
FROM dbo.TaxPrintEmployeeInfo  
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
DECLARE @SQL13 VARCHAR(8000)--10061820 20160809 add  扶養親族
DECLARE @SQL14 VARCHAR(8000)
  
  
--DECLARE @SQL VARCHAR(8000)  
DECLARE @PrintRange  tinyint   --印刷範囲を選択　1:個人毎に　2:所属毎に　3:市町村毎に  
DECLARE @EmpDivision  tinyint --全て=1, 特別徴(社員、契約社員)=2 , 普通徴(AS)=3, 退職者の徴収(退職者)=4  
SELECT TOP 1  @EmpDivision=EmployeeDivision ,@PrintRange = PrintRange FROM  TaxPrintEmployeeInfo  WHERE AdminID = @AdminID  
-- 20101230 2011になると、22年の源泉の計算が間違うになるのため  
--　GetDate()は2010年の固定日'2010/12/01'に変わる  
SELECT  @YearStart =  convert(varchar(4),@AdjustYear) + '/01/01'  

----------------10061820 20160809 add begin
declare @StoreCD int
declare @AffiliationCD int
BEGIN
    CREATE TABLE #AObj
    (   EmployeeCode decimal(18,0)
        ,Name nvarchar(30)
        ,Name_syllabary nvarchar(30)
        ,Inmate tinyint)

    CREATE TABLE #BObj
    (  EmployeeCode decimal(18,0)
        ,Name1 nvarchar(30)
        ,Name_syllabary1 nvarchar(30)
        ,Inmate1 tinyint
        ,Name2 nvarchar(30)
        ,Name_syllabary2 nvarchar(30)
        ,Inmate2 tinyint
        ,Name3 nvarchar(30)
        ,Name_syllabary3 nvarchar(30)
        ,Inmate3 tinyint
        ,Name4 nvarchar(30)
        ,Name_syllabary4 nvarchar(30)
        ,Inmate4 tinyint)

    CREATE TABLE #MObj
    (   EmployeeCode decimal(18,0)
        ,Name1 nvarchar(30)
        ,Name_syllabary1 nvarchar(30)
        ,Inmate1 tinyint
        ,Name2 nvarchar(30)
        ,Name_syllabary2 nvarchar(30)
        ,Inmate2 tinyint
        ,Name3 nvarchar(30)
        ,Name_syllabary3 nvarchar(30)
        ,Inmate3 tinyint
        ,Name4 nvarchar(30)
        ,Name_syllabary4 nvarchar(30)
        ,Inmate4 tinyint)

    create table #str
    (
       EmployeeCode decimal(18,0)
        ,strlst nvarchar(800))

    create table #inmateCountList
    (
        EmployeeCode decimal(18,0)
        ,inmateCount int)

    declare @count int
    declare @name  nvarchar(30)
    declare @name_syllabary  nvarchar(30)
    declare @inmate  tinyint
    declare @inmateName nvarchar(30)
    declare @ObjID  int
    declare @indext  int
    --declare @employeeManageID decimal
    declare @str varchar(800)
    declare @strIndex int
    declare @inmateCount int --非居住者統計

    declare @EmployeeCode decimal(18,0)
    declare @EmployeeCount int 

    SELECT top(0) Code into  #EmployeeCodeList FROM TaxPrintEmployeeInfo
    if(@PrintRange = 1)
    begin
        insert into #EmployeeCodeList
        SELECT 
            Code
        FROM
            TaxPrintEmployeeInfo  
        WHERE
            AdminID = @AdminID
    end 
    else  if(@PrintRange = 2)
    begin
        select 
            @StoreCD = CONVERT(INT, SUBSTRING(Code, 0 ,CHARINDEX(',',Code)))
            ,@AffiliationCD = CONVERT(INT,SUBSTRING(Code, CHARINDEX(',',Code)+1,len(Code)+1))
        from 
            TaxPrintEmployeeInfo
        where
            AdminID = @AdminID

        insert into #EmployeeCodeList
        select
            EmployeeCode 
        from
            Ajust_V_BasisDate_Print
        where
            StoreCD = @StoreCD 
        and
            AffiliationCD = @AffiliationCD
        --insert into #EmployeeCodeList
        --select distinct 
        --    EmployeeCode 
        --from 
        --    Ajust_V_BasisDate_Print ME
        --inner join
        --    TaxPrintEmployeeInfo T
        --on
        --    t.Code =CONVERT(VARCHAR(10),ME.StoreCD)+',' + CONVERT(VARCHAR(10),ME.AffiliationCD)
        --where
        --    t.AdminID = @AdminID
    end
    
    if(@AdminID = '0' )
    begin 
        insert into #EmployeeCodeList
        select @LoginCD
    end 
    
    select @EmployeeCount = count(1) from #EmployeeCodeList

    while (@EmployeeCount > 0)
    begin
        
        select top 1 @EmployeeCode = Code from #EmployeeCodeList
        set @EmployeeCount = @EmployeeCount - 1
        delete #EmployeeCodeList where Code = @EmployeeCode 

        set @strIndex=0
        set @str=''
        set @inmateCount=0

        if object_id('tempdb..#maintainObj') is not null
        begin
            drop table #maintainObj
        end

        select
            明細ID  ObjID
            ,コード EmployeeCode
            ,case when  配偶者区分 =1 then  'A'
                when DATEDIFF(DAY,DATEADD(year,16, 生年月日),CONVERT(DATE, convert(varchar(4),@AdjustYear + 1) + '/01/02'))<=0 then 'M'
                else 'B' END AS ObjKind
            ,姓 + '　' + 名 Name  
            ,姓ｶﾅ + '　' + 名ｶﾅ  Name_syllabary
            ,ISNULL(居住者区分,0) Inmate
        into #maintainObj
        from OBIC_ProviderInforNew
        where コード= @EmployeeCode
        and 年度=@AdjustYear
        and 税扶養区分 = 1


        insert into #AObj
        select EmployeeCode,Name,Name_syllabary,Inmate
        from #maintainObj
        where ObjKind='A'
    
        SELECT
            @str=Name+'（配特）'+(CASE Inmate WHEN 0 THEN ''ELSE '（非居住者）' END) 
        FROM #AObj a
        INNER JOIN InsEstimateDetail ins
        on ins.EmployeeManageID=a.EmployeeCode
        AND  ins.AdjustYear = @AdjustYear
        AND  ins.TypeID=1
        AND  ins.Income  >= CAST (1030000 AS MONEY) 
        AND  ins.Income <= CAST (1410000 AS MONEY)
    
        set @Inmate = 0
        select  @Inmate=Inmate from #AObj
        if(@inmate <> 0) set @inmateCount=@inmateCount+1 

        set @indext=1
        select @count=COUNT(1) from #maintainObj where ObjKind='B'
        while (@count>0)
        BEGIN
            select top 1 @ObjID=ObjID
                ,@name=Name
                ,@name_syllabary=Name_syllabary
                ,@inmate = ISNULL(inmate,0)
            from #maintainObj where ObjKind='B' order by ObjID

            delete  #maintainObj where ObjKind='B' and ObjID = @ObjID
            if(@inmate = 0) set @inmateName='' 
            else BEGIN set @inmateName='（非居住者）' set @inmateCount = @inmateCount+1 END
        
            if(@indext=1)
                insert into #BObj values(@EmployeeCode,@name,@name_syllabary,@inmate,'','',0,'','',0,'','',0)
            else if(@indext=2)
                update  #BObj set Name2 =@name,Name_syllabary2=@name_syllabary,Inmate2 =@inmate  where EmployeeCode = @EmployeeCode
            else if(@indext=3)
                update  #BObj set Name3 =@name,Name_syllabary3=@name_syllabary,Inmate3 =@inmate  where EmployeeCode = @EmployeeCode
            else if(@indext=4)
                update  #BObj set Name4 =@name,Name_syllabary4=@name_syllabary,Inmate4 =@inmate  where EmployeeCode = @EmployeeCode
            else if(@indext>4)
            BEGIN
                set @strIndex=@strIndex+1
                set @str =@str+'('+CONVERT(varchar,@strIndex)+')'+' '+replace(@name,'　','')+@inmateName+' '
            END
            set @count=@count-1
            set @indext=@indext+1
        END

        set @indext=1
        select @count=COUNT(1) from #maintainObj where ObjKind='M'
        while (@count>0)
        BEGIN
            select top 1 @ObjID=ObjID
                ,@name=Name
                ,@name_syllabary=Name_syllabary
                ,@inmate =inmate
            from #maintainObj where ObjKind='M' order by ObjID
            delete  #maintainObj where ObjKind='M' and ObjID=@ObjID
            if(@inmate = 0) set @inmateName='' 
            else BEGIN set @inmateName='（非居住者）' set @inmateCount=@inmateCount+1 END
            if(@indext=1)
                insert into #MObj values(@EmployeeCode,@name,@name_syllabary,@inmate,'','',0,'','',0,'','',0)
            else if(@indext=2)
                update  #MObj set Name2 =@name,Name_syllabary2=@name_syllabary,Inmate2 =@inmate  where EmployeeCode = @EmployeeCode
            else if(@indext=3)
                update  #MObj set Name3 =@name,Name_syllabary3=@name_syllabary,Inmate3 =@inmate  where EmployeeCode = @EmployeeCode
            else if(@indext=4)
                update  #MObj set Name4 =@name,Name_syllabary4=@name_syllabary,Inmate4 =@inmate  where EmployeeCode = @EmployeeCode
            else if(@indext>4)
            BEGIN
                if(@inmate = 0) set @inmateName='' else set @inmateName='（非居住者）'
                set @strIndex=@strIndex+1
                set @str =@str+'('+CONVERT(varchar,@strIndex)+')'+' '+replace(@name,'　','')+'（年少）'+@inmateName+' '
            END
            set @count=@count-1
            set @indext=@indext+1
        END

        insert into #str values (@EmployeeCode,@str)
        insert into #inmateCountList values(@EmployeeCode,@inmateCount)
    end
END
--------10061820 20160809 add end

-- 一．基本情報  
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
     ,dbo.FN_Year_GetMoney(OYAA.合計課税総額,3,2) AS ''合計課税総額百万''
     ,dbo.FN_Year_GetMoney(OYAA.合計課税総額,2,2) AS ''合計課税総額千''
     ,dbo.FN_Year_GetMoney(OYAA.合計課税総額,1,2) AS ''合計課税総額1'' 
     ,OYAA.合計課税総額 AS ''合計課税総額''
     ,dbo.FN_Year_GetMoney(OYAA.所得控除後金額,3,2) AS ''所得控除後金額百万''
     ,dbo.FN_Year_GetMoney(OYAA.所得控除後金額,2,2) AS ''所得控除後金額千''
     ,dbo.FN_Year_GetMoney(OYAA.所得控除後金額,1,2) AS ''所得控除後金額1''
     ,OYAA.所得控除後金額 AS ''所得控除後金額''
     ,dbo.FN_Year_GetMoney(OYAA.所得控除額合計,3,2) AS ''所得控除額合計百万''
     ,dbo.FN_Year_GetMoney(OYAA.所得控除額合計,2,2) AS ''所得控除額合計千''
     ,dbo.FN_Year_GetMoney(OYAA.所得控除額合計,1,2) AS ''所得控除額合計1''
     ,OYAA.所得控除額合計 AS ''所得控除額合計''
     ,dbo.FN_Year_GetMoney(CASE WHEN ( (OYAA.年度 = 2010 and OYAA.税額表区分 = 2) or (OYAA.年度 >= 2011 and OYAA.対象者区分 = 0)  ) THEN OYAA.合計徴収済税額 ELSE OYAA.差引年税額 END,3,2) AS ''差引年税額百万'' 
     ,dbo.FN_Year_GetMoney(CASE WHEN ( (OYAA.年度 = 2010 and OYAA.税額表区分 = 2) or (OYAA.年度 >= 2011 and OYAA.対象者区分 = 0)  ) THEN OYAA.合計徴収済税額 ELSE OYAA.差引年税額 END,2,2) AS ''差引年税額千'' 
     ,dbo.FN_Year_GetMoney(CASE WHEN ( (OYAA.年度 = 2010 and OYAA.税額表区分 = 2) or (OYAA.年度 >= 2011 and OYAA.対象者区分 = 0)  ) THEN OYAA.合計徴収済税額 ELSE OYAA.差引年税額 END,1,2) AS ''差引年税額1'''  
     -- ,CASE WHEN ( (OYAA.年度 = 2010 and OYAA.税額表区分 = 2) or (OYAA.年度 >= 2011 and OYAA.対象者区分 = 0)  ) THEN OYAA.合計徴収済税額 ELSE OYAA.差引年税額 END AS ''差引年税額''
 --,OYAA.DifYearTax AS ''差引年税額'''   
-- 三．扶養控除欄  
  
SET @SQL3 = ',CASE WHEN OME.対象者区分=1 AND OME.配偶者控除区分 = 1  
  THEN ''○''  
  ELSE ''''  
  END AS ''控除対象配偶者の有''  
 ,CASE WHEN OME.対象者区分=1 AND OME.配偶者控除区分 = 0  
  THEN ''○''  
  ELSE ''''  
  END AS ''控除対象配偶者の無''  
 ,CASE WHEN OME.対象者区分=1 AND OME.配偶者控除区分 = 2  
  THEN ''○''  
  ELSE ''''  
  END AS ''控除対象配偶者の老人''  
  
 ,CASE WHEN OME.対象者区分=1 then OYAA.配特別控除額 else 0 end  AS ''配特別控除額''
 ,CASE WHEN OME.対象者区分=1 then dbo.FN_Year_GetMoney(OYAA.配特別控除額,2,1) else '''' end  AS ''配特別控除額千''  
 ,CASE WHEN OME.対象者区分=1 then dbo.FN_Year_GetMoney(OYAA.配特別控除額,1,1) else ''0'' end  AS ''配特別控除額1'' 
  
 ,CASE WHEN OME.対象者区分=1 then OME.特定扶養親族 else 0 end           AS ''扶養親族の数特定の人''  
 ,CASE WHEN OME.対象者区分=1 then OME.同居老親等 else 0 end AS ''扶養親族の数老人の内''  
 ,CASE WHEN OME.対象者区分=1 then OME.老人扶養親族数+OME.同居老親等 else 0 end AS ''扶養親族の数老人の人''  
 ,CASE WHEN OME.対象者区分=1 then OME.一般扶養親族 else 0 end AS ''扶養親族の数その他の人''  
 ,CASE WHEN OME.対象者区分=1 then OME.同居特別障害者 else 0 end AS ''障害者の数特定の内''  
 ,CASE WHEN OME.対象者区分=1 then OME.特別障害者 else 0 end AS ''障害者の数特定の人''  
 ,CASE WHEN OME.対象者区分=1 then OME.一般障害者 else 0 end AS ''障害者の数その他の人''  
 
 ,dbo.FN_Year_GetMoney(OYAA.合計社保控除額,2,1)  AS ''合計社保控除額千''
 ,dbo.FN_Year_GetMoney(OYAA.合計社保控除額,1,1) AS ''合計社保控除額1''
 ,OYAA.合計社保控除額 AS ''合計社保控除額''
 ,dbo.FN_Year_GetMoney(OYAA.合計生保控除,2,1) AS ''合計生保控除千''--生命保険料の控除額
 ,dbo.FN_Year_GetMoney(OYAA.合計生保控除,1,1) AS ''合計生保控除1''--生命保険料の控除額
 ,OYAA.合計生保控除 AS ''合計生保控除''--生命保険料の控除額
--20101022  
-- ,OYAA.EarthquakeInsDeduct AS ''地震険料の控除額''  
 ,dbo.FN_Year_GetMoney(OYAA.合計地震控除,2,1) AS ''合計地震控除千''--地震険料の控除額
 ,dbo.FN_Year_GetMoney(OYAA.合計地震控除,1,1) AS ''合計地震控除1''--地震険料の控除額
 ,OYAA.合計地震控除 AS ''合計地震控除''--地震険料の控除額
 ,dbo.FN_Year_GetMoney(OYAA.住宅特別控除,2,1) AS ''住宅借入金等特別控除の額千''
 ,dbo.FN_Year_GetMoney(OYAA.住宅特別控除,1,1) AS ''住宅借入金等特別控除の額1''
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
                              		
SET @SQL4 = ',OYAA.申社保年金分+OYAA.申社保年金外分 AS ''摘要1'''  --国民年金保険料等の金額
            --+','''+@str+''''  +'AS ''摘要3'''
            --+',OYAB.摘要2 +''  '' + OYAB.摘要3 +''  ''  + '''+@str+''''  +'AS ''摘要3''' 10061820 20161212 update
           -- +',OYAB.摘要1 +''  '' + OYAB.摘要3 +''  ''  +  isnull ((select strlst from #str where EmployeeCode = OME.コード),'''')  AS ''摘要3'''
            --+',OYAB.摘要1 +''  '' + OYAB.摘要2 +''  '' + OYAB.摘要3 +''
            -- ''   + OYAB.摘要4   AS ''摘要3'''
           +',case when replace (OYAB.摘要1 + OYAB.摘要2 + OYAB.摘要3,'' '','''') ='''' then OYAB.摘要4 
             else replace(OYAB.摘要1 +''  '' + OYAB.摘要2 +''  '' + OYAB.摘要3,''  '','' '') +''     ''   + OYAB.摘要4  end  AS ''摘要3'''
            
            
--SET @SQL4 = ',OYAB.摘要1            AS ''摘要1''  
--                    ,ISNULL(OYAB.摘要2,'''') + ''   '' + ISNULL(OYAB.摘要3,'''')+ ''   '' + ISNULL(OYAB.摘要4,'''')    AS ''摘要3'''  
                    -- ,OYAB.Abstract2            AS ''摘要2''  
                    -- ,OYAB.Abstract3            AS ''摘要3''  
                    -- ,CONVERT(VARCHAR(100),OYAB.Abstract2) + ''　'' + CONVERT(VARCHAR(100),OYAB.Abstract3) AS ''摘要3'''--OBIC_YearAbstract  
  
--五．特別処置欄  
                      --,CASE WHEN DATEDIFF( YEAR, CONVERT(DATETIME,OME.生年月日), GETDATE() ) < 18  
SET @SQL5 = ',CASE WHEN DATEDIFF(DAY, (CONVERT(VARCHAR(4),(YEAR('''+convert(varchar(4),@AdjustYear)+'/12/01'') - 19))+ ''/01/03''),OME.生年月日) > 0   
  THEN ''○''  
  ELSE ''''  
  END   AS ''未成年者''  
 ,CASE WHEN ( (OYAA.年度 = 2010 and OYAA.税額表区分 = 2) or (OYAA.年度 >= 2011 and OYAA.税額表区分 = 1) )  
                      THEN ''○''  
                      ELSE ''''  
                      END                            AS ''乙欄''  
 ,CASE WHEN ( OME.対象者区分=1 and OME.本人特別障害者 = 1 )  
  THEN ''○''  
  ELSE ''''  
  END   AS ''本人が障害者の特別''  
 ,CASE WHEN (  OME.対象者区分=1 and OME.本人障害者 = 1 )  
  THEN ''○''  
  ELSE ''''  
  END   AS ''本人が障害者のその他''    
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人寡婦 = 1)  
  THEN ''○''  
  ELSE ''''  
  END   AS ''寡婦の一般''  
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人寡婦 = 2 )  
  THEN ''○''  
  ELSE ''''  
  END   AS ''寡婦の特別''  
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人寡婦 = 3 )  
  THEN ''○''  
  ELSE ''''  
  END   AS ''寡夫''  
 ,CASE WHEN ( OME.対象者区分=1 and  OME.本人勤労学生 = 1 )  
  THEN ''○''  
  ELSE ''''  
  END   AS ''勤労学生''  
 ,CASE WHEN ( OME.休職退職区分 = 0 AND OME.入社年月日 >= ''' + @YearStart + ''' and (OME.退職年月日 = '''' or OME.退職年月日 is null) )  
  THEN ''○''  
  ELSE ''''  
  END   AS ''就職''  
 ,CASE WHEN (  (( OME.休職退職区分 = 2 and OME.年度=2010)  or(OME.退職年月日 <> '''' and OME.年度 >= 2011))  AND OME.入社年月日 <> ''''  )   
  THEN ''○''  
  ELSE ''''  
  END   AS ''退職''  
 ,CASE WHEN ( OME.休職退職区分 = 0 AND OME.入社年月日 >= ''' + @YearStart + ''' and (OME.退職年月日 = '''' or OME.退職年月日 is null)  )   
  THEN substring(dbo.FN_Year_GetYear(OME.入社年月日),3,2)  
  WHEN (  (( OME.休職退職区分 = 2 and OME.年度=2010)  or( OME.退職年月日 <> '''' and OME.年度 >= 2011)) AND OME.入社年月日 <> ''''  )   
  THEN substring(dbo.FN_Year_GetYear(OME.退職年月日),3,2)  
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
  
 ,CASE WHEN SUBSTRING(( dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''明'' --★  
  THEN ''○''  
  ELSE ''''  
  END   AS ''受給者生年明''  
 ,CASE WHEN SUBSTRING(( dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''大'' --★  
  THEN ''○''  
  ELSE ''''  
  END   AS ''受給者生年大''  
 ,CASE WHEN SUBSTRING(( dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''昭'' --★  
  THEN ''○''  
  ELSE ''''  
  END   AS ''受給者生年昭''  
 ,CASE WHEN SUBSTRING(( dbo.FN_Year_GetYear(OME.生年月日)),1,1) = ''平'' --★  
  THEN ''○''  
  ELSE ''''  
  END   AS ''受給者生年平''  
 ,SUBSTRING(dbo.FN_Year_GetYear(OME.生年月日),3,2) AS ''生年の年''  
 ,CASE WHEN MONTH(OME.生年月日) < 10  
                     THEN (''0'' + CONVERT(VARCHAR(2),MONTH(OME.生年月日)))  
                     ELSE CONVERT(VARCHAR(2),MONTH(OME.生年月日))   
                     END                             AS ''生年の月''  
 ,CASE WHEN DAY(OME.生年月日) < 10  
                     THEN (''0'' + CONVERT(VARCHAR(2),DAY(OME.生年月日)))  
                     ELSE CONVERT(VARCHAR(2),DAY(OME.生年月日))  
                     END                             AS ''生年の日'''   
  
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
                      , dbo.FN_Year_GetMoney(OYAA.小規模企業共済,2,1) AS ''小規模企業共済千''
                      , dbo.FN_Year_GetMoney(OYAA.小規模企業共済,1,1) AS ''小規模企業共済1''
                      , OYAA.基礎控除等合計  AS ''基礎控除等合計''  
                      , OYAA.差引課税所得額  AS ''差引課税所得額''  
                      , OYAA.年税額          AS ''年税額''  
                      , OYAA.特減税還付額    AS ''特減税還付額''  
                      , OYAA.住宅特別控除    AS ''住宅特別控除''  
                      , OYAA.差引年税額      AS ''差引年税額11''  
                      , OYAA.合計徴収済税額  AS ''合計徴収済税額''  
                      , OYAA.差引過不足      AS ''差引過不足''  
                      , OYAA.差引超過額      AS ''差引超過額''  
                      , OYAA.差引不足額      AS ''差引不足額''  
                      , OYAA.基礎控除        AS ''基礎控除''  
                      , OYAA.本人障害控除    AS ''本人障害控除''  
                      , OYAA.本人特障控除    AS ''本人特障控除''  
                      , OYAA.本人老年控除    AS ''本人老年控除''  
                      , OYAA.本人寡婦控除    AS ''本人寡婦控除''  
                      , OYAA.本人特別寡婦    AS ''本人特別寡婦''  
                      , OYAA.本人寡夫控除    AS ''本人寡夫控除''  
                      , OYAA.本人勤労学生    AS ''本人勤労学生''  
                      , OYAA.配偶者控除      AS ''配偶者控除''  
                      , OYAA.配偶者老控除    AS ''配偶者老控除''  
                      , OYAA.一般扶養控除    AS ''一般扶養控除''  
                      , OYAA.特定扶養控除       AS ''特定扶養控除''  
                      , OYAA.同居老親等控除      AS ''同居老親等控除''  
                      , OYAA.同居老親等以外   AS ''同居老親等以外''  
                      , OYAA.障害者控除                AS ''障害者控除''  
                      , OYAA.特障害者控除           AS ''特障害者控除''  
                      , OYAA.同居特障控除              AS ''同居特障控除''  
                      , OME.所属3名                        AS ''事務所''  
                      , OME.所属2名                AS ''部門''  
                      , (dbo.FN_Year_GetYear(CONVERT(VARCHAR(4),OYAA.対象年月)))  
                       + ''年分''    AS ''対象年''  
                      , (dbo.FN_Year_GetYear(''' + CONVERT(VARCHAR(4),@AdjustYear) + '/12/01''))  AS ''今年''   
  ,OME.年少扶養人数 as ''年少扶養親族'''  
  
SET @SQL8 =  ' FROM   Ajust_V_BasisDate_Print ME  
                         INNER JOIN  dbo.OBIC_mstEmployeeBasicInforNew OME   
                         ON OME.コード = ME.EmployeeCode  
   
  and OME.年度 = '+CONVERT(VARCHAR(4),@AdjustYear)+'  
                         INNER JOIN  OBIC_YearAdjustAllNew OYAA  
                         ON OYAA.コード = OME.コード  
     and OME.会社CD = OYAA.会社NO   
  and OYAA.年度 = '+CONVERT(VARCHAR(4),@AdjustYear)+'  
                         LEFT JOIN OBIC_YearAbstractNew OYAB  
                         ON OME.コード = OYAB.コード  
   and OME.会社CD = OYAB.会社NO   
  and OYAB.年度 = '+CONVERT(VARCHAR(4),@AdjustYear) + '  
  
                         INNER JOIN mstCompany MSTC  
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
		--10061820 20161213 ADD  
		or  (OME.会社CD = 27 and MSTC.Company_code = 10027 )
		or  (OME.会社CD = 28 and MSTC.Company_code = 10028 )
		or  (OME.会社CD = 29 and MSTC.Company_code = 10029 )
		or  (OME.会社CD = 31 and MSTC.Company_code = 10031 )
		--10061820 20161213 ADD
		--1129 20171230 ADD
		or  (OME.会社CD = 32 and MSTC.Company_code = 10032 )
		--1129 20171230 ADD 
		--10061820 20181226 ADD
		or  (OME.会社CD = 37 and MSTC.Company_code = 20000 )
		--10061820 20171226 ADD   
   )  
                      and MSTC.AdjustYear = '+CONVERT(VARCHAR(4),@AdjustYear)

SET @SQL13  =  ',OYAA.特別控除適用数
     ,isnull(OYAA.住宅控除申告,0)  AS 特別控除可能額
     ,dbo.FN_Year_GetJpanYear(OYAA.居住開始年月日1回目)  as 居住開始年1
     ,MONTH(OYAA.居住開始年月日1回目) as 居住開始月1
     ,DAY(OYAA.居住開始年月日1回目)  as 居住開始日1
     ,dbo.FN_Year_GetJpanYear(OYAA.居住開始年月日2回目) as 居住開始年2
     ,MONTH(OYAA.居住開始年月日2回目) as 居住開始月2
     ,DAY(OYAA.居住開始年月日2回目) as 居住開始日2
     ,OYAA.特別控除区分1回目
     ,OYAA.特別控除区分2回目
     ,isnull(OYAA.年末残高1回目,0) 年末残高1回目
     ,isnull(OYAA.年末残高2回目,0) 年末残高2回目
     ,ISNULL((select Name from #AObj where EmployeeCode = OME.コード ),'''') AS 扶養名A
     ,ISNULL((select Name_syllabary from #AObj  where EmployeeCode = OME.コード),'''')  扶養名カナA
     ,ISNULL((select CASE when ISNULL(Inmate,0)= 0 then '''' else ''〇'' end from #AObj  where EmployeeCode = OME.コード ),'''') 扶養区分A
     ,ISNULL((select  Name1  from #BObj where EmployeeCode = OME.コード),'''') 扶養名B1
     ,ISNULL((select Name_syllabary1 from #BObj where EmployeeCode = OME.コード),'''')  扶養名カナB1
     ,ISNULL((select CASE when ISNULL(Inmate1,0)= 0 then '''' else ''〇'' end from #BObj where EmployeeCode = OME.コード),'''') 扶養区分B1
     ,ISNULL((select Name2  from #BObj where EmployeeCode = OME.コード),'''') 扶養名B2
     ,ISNULL((select Name_syllabary2 from #BObj where EmployeeCode = OME.コード),'''')  扶養名カナB2
     ,ISNULL((select CASE when ISNULL(Inmate2,0)= 0 then '''' else ''〇'' end from #BObj where EmployeeCode = OME.コード),'''') 扶養区分B2
     ,ISNULL((select Name3  from #BObj where EmployeeCode = OME.コード),'''') 扶養名B3
     ,ISNULL((select Name_syllabary3 from #BObj where EmployeeCode = OME.コード),'''')  扶養名カナB3
     ,ISNULL((select CASE when ISNULL(Inmate3,0)= 0 then '''' else ''〇'' end from #BObj where EmployeeCode = OME.コード),'''') 扶養区分B3
     ,ISNULL((select Name4 from #BObj where EmployeeCode = OME.コード),'''') 扶養名B4
     ,ISNULL((select Name_syllabary4 from #BObj where EmployeeCode = OME.コード),'''')  扶養名カナB4
     ,ISNULL((select CASE when ISNULL(Inmate4,0)= 0 then '''' else ''〇'' end from #BObj where EmployeeCode = OME.コード),'''') 扶養区分B4
     ,ISNULL((select Name1 from #MObj where EmployeeCode = OME.コード),'''') 扶養名M1
     ,ISNULL((select Name_syllabary1 from #MObj where EmployeeCode = OME.コード),'''')  扶養名カナM1
     ,ISNULL((select CASE when ISNULL(Inmate1,0)= 0 then '''' else ''〇'' end from #MObj where EmployeeCode = OME.コード),'''') 扶養区分M1
     ,ISNULL((select Name2 from #MObj where EmployeeCode = OME.コード),'''') 扶養名M2
     ,ISNULL((select Name_syllabary2 from #MObj where EmployeeCode = OME.コード),'''')  扶養名カナM2
     ,ISNULL((select CASE when ISNULL(Inmate2,0)= 0 then '''' else ''〇'' end from #MObj where EmployeeCode = OME.コード),'''') 扶養区分M2
     ,ISNULL((select Name3 from #MObj where EmployeeCode = OME.コード),'''') 扶養名M3
     ,ISNULL((select Name_syllabary3 from #MObj where EmployeeCode = OME.コード),'''')  扶養名カナM3
     ,ISNULL((select CASE when ISNULL(Inmate3,0)= 0 then '''' else ''〇'' end from #MObj where EmployeeCode = OME.コード),'''') 扶養区分M3
     ,ISNULL((select Name4  from #MObj where EmployeeCode = OME.コード),'''') 扶養名M4
     ,ISNULL((select Name_syllabary4 from #MObj where EmployeeCode = OME.コード),'''')  扶養名カナM4
     ,ISNULL((select CASE when ISNULL(Inmate4,0)= 0 then '''' else ''〇'' end from #MObj where EmployeeCode = OME.コード),'''') 扶養区分M4
     ,ISNULL((select inmateCount from #inmateCountList where EmployeeCode =  OME.コード),0) AS 非居住者親族数'

if @PageFlag = 2  
begin  
  
    IF @PrintRange = 1  
    begin   
        SET @SQL9 = ' INNER JOIN TaxPrintEmployeeInfo TPEI ON TPEI.Code = OME.コード AND TPEI.AdminID =' + @AdminID  
    end  
    ELSE IF @PrintRange = 2   
   
        SET @SQL9 = ' INNER JOIN TaxPrintEmployeeInfo TPEI ON (CONVERT(VARCHAR(10),ME.StoreCD)+'',''  
                    +CONVERT(VARCHAR(10),ME.AffiliationCD)) = TPEI.Code AND TPEI.AdminID =' + @AdminID  
    ELSE   
        SET @SQL9 = ' INNER JOIN TaxPrintEmployeeInfo TPEI ON OME.[当年1/1市町村] = TPEI.Code AND TPEI.AdminID =' + @AdminID  
  
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
    print (@SQL1 + @SQL2 + @SQL3 + @SQL4 + @SQL5 + @SQL6 + @SQL7 + @SQL13 + @SQL8 + @SQL9 + @SQL10 + @SQL11)  
   EXEC  (@SQL1 + @SQL2 + @SQL3 + @SQL4 + @SQL5 + @SQL6 + @SQL7 + @SQL13 + @SQL8 + @SQL9 + @SQL10 + @SQL11)  
  
END  --@PageFlag = 2  
ELSE IF @PageFlag = 1  
BEGIN  
  
    set @SQL12 = ' where ME.EmployeeCode =' + @LoginCD  
    print (@SQL1 + @SQL2 + @SQL3 + @SQL4 + @SQL5 + @SQL6 + @SQL7 + @SQL13 + @SQL8 + @SQL12)  
   EXEC  (@SQL1 + @SQL2 + @SQL3 + @SQL4 + @SQL5 + @SQL6 + @SQL7 + @SQL13 + @SQL8 + @SQL12)  
     
END





GO


