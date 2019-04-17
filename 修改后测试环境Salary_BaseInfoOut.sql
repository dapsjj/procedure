USE [dbEmployee]
GO

/****** Object:  StoredProcedure [dbo].[Salary_BaseInfoOut]    Script Date: 2019/04/17 15:26:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



                 --************************************************* --  
--  作成者　10004211　　作成日　2007/11/22      --  
  
--  機能： 給与システムの給与明細ペーパーレス化について、給与支払基本情報取得    --  
--exec Salary_BaseInfoOut '2011/09','1','3','1','107',14  
--************************************************* --  
  
ALTER                PROCEDURE [dbo].[Salary_BaseInfoOut]  
  
@YearMonth         VARCHAR(10),           --　支給年月  
@CompanyCode    VARCHAR(10),           --　会社区分フラグ：　1 TRIAL　3 SLS  
@EmployeeType    VARCHAR(10),           --  支給対象区分：　1　社員　2　AS  3　契約社員  
@SalaryType        VARCHAR(10),           --  支給区分：　1　給与　2　賞与　  
@EmployeeManagementID   VARCHAR(10),         -- 従業員管理ID  
@Affiliate   VARCHAR(10)        --所属  
  
  
AS  
DECLARE @YearMonthTemp VARCHAR(10)  
SET @YearMonthTemp=@YearMonth+'/01'  
IF object_id('tempdb.dbo.#TempSalaryItemInformation') is not null   
DROP TABLE #TempSalaryItemInformation  
SELECT   
 TOP 1 *  
INTO  #TempSalaryItemInformation  
FROM   
 SalaryItemInformation  
WHERE   
 CompanyCode=@CompanyCode  
 AND EmployeeType=@EmployeeType  
 AND SalaryType=@SalaryType  
 AND PayYearMonth= @YearMonthTemp  
IF object_id('tempdb.dbo.#TempSalaryInformation') is not null   
DROP TABLE #TempSalaryInformation  
SELECT   
 TOP 1 *  
INTO #TempSalaryInformation  
FROM  
 SalaryInformation  
WHERE  
 CompanyCode=@CompanyCode  
 AND PayYearMonth=@YearMonthTemp  
 AND EmployeeType=@EmployeeType  
 AND SalaryType=@SalaryType  
 AND EmployeeManagementID=@EmployeeManagementID  
  
DECLARE   @str1 as varchar(8000)  
DECLARE   @str2 as varchar(8000)  
DECLARE   @str3 as varchar(8000)  
DECLARE   @str4 as varchar(8000)  
DECLARE   @str5 as varchar(8000)  
DECLARE   @str6 as varchar(8000)  
DECLARE   @str7 as varchar(8000)  
DECLARE   @str8 as varchar(8000)  
DECLARE   @str9 as varchar(8000)  
  
if ((@CompanyCode = '1' or @CompanyCode = '6' or @CompanyCode = '7' or @CompanyCode = '8') and @EmployeeType = '2' and @SalaryType = '1' and @YearMonth > '2011/07/01')  
begin  
 set @Affiliate = '13'  
end  
else if (@EmployeeType = '1' and @SalaryType = '1' and @YearMonth > '2011/07/01')  
begin  
 set @Affiliate = '15'  
end  
else if (@EmployeeType = '2' and @SalaryType = '1' and @YearMonth > '2011/08/01')  
begin  
 set @Affiliate = '13'  
end  
  
  

----------------SalaryItemInformation&&SalaryOutput_Attendance  出力定義（勤怠）項目名情報取得------------------   
set @str1=(select case when convert(nvarchar,SalaryOutput_Attendance.item1) is null then '''''' else  'SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item1) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item2) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item2) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item3) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item3) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item4) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item4) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item5) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item5) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item6) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item6) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item7) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item7) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item8) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item8) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item9) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item9) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item10) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item10) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item11) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item11) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item12) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item12) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item13) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item13) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item14) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item14) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item15) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item15) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item16) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item16) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item17) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item17) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item18) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item18) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item19) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item19) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item20) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item20) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item21) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item21) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item22) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item22) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item23) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item23) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item24) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item24) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item25) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item25) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item26) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item26) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item27) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item27) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item28) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item28) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item29) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item29) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item30) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item30) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item31) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item31) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item32) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item32) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item33) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item33) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item34) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item34) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item35) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item35) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item36) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item36) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item37) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item37) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item38) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item38) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item39) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item39) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item40) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item40) end  
from  SalaryOutput_Attendance   
where  SalaryOutput_Attendance.CompanyCode=@CompanyCode and  convert(varchar(7),SalaryOutput_Attendance.PayYearMonth,111)=@YearMonth   
         and SalaryOutput_Attendance.EmployeeType=@EmployeeType and SalaryOutput_Attendance.SalaryType=@SalaryType)  
if ((select @str1) is null)  
begin  
--select 'str1_A'
exec(@str1) 
end  
else  
begin  
--select 'str1_B'
exec( 'select '+@str1+' from #TempSalaryItemInformation SalaryItemInformation' ) 
end  
  
  
  
---------------SalaryInformation&&SalaryOutput_Attendance  出力定義（勤怠）項目情報取得------------------  
  
set @str2=(select case when convert(nvarchar,SalaryOutput_Attendance.item1)  is null  then '''''' else  'SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item1) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item2)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item2) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item3)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item3) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item4)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item4) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item5)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item5) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item6)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item6) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item7)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item7) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item8)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item8) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item9)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item9) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item10)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item10) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item11)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item11) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item12)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item12) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item13)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item13) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item14)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item14) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item15)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item15) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item16)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item16) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item17)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item17) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item18)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item18) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item19)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item19) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item20)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item20) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item21)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item21) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item22)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item22) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item23)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item23) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item24)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item24) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item25)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item25) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item26)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item26) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item27)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item27) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item28)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item28) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item29)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item29) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item30)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item30) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item31)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item31) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item32)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item32) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item33)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item33) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item34)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item34) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item35)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item35) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item36)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item36) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item37)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item37) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item38)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item38) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item39)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item39) end  
+case when convert(nvarchar,SalaryOutput_Attendance.item40)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Attendance.item40) end   
from  SalaryOutput_Attendance   
where  SalaryOutput_Attendance.CompanyCode=@CompanyCode and  convert(varchar(7),SalaryOutput_Attendance.PayYearMonth,111)=@YearMonth   
         and SalaryOutput_Attendance.EmployeeType=@EmployeeType and SalaryOutput_Attendance.SalaryType=@SalaryType)  
if ((select @str2) is null)  
begin  
--select 'str2_A'
exec(@str2)  
end  
else  
begin  
--select 'str2_B'
exec('select '+@str2+' from #TempSalaryInformation SalaryInformation')  
end  
  
  
  
  
  
  
----------------------SalaryItemInformation&&SalaryOutput_Pay  出力定義（支払）項目名情報取得------------------  
  
set @str3=(select case when convert(nvarchar,SalaryOutput_Pay.item1) is null then '''''' else  'SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item1) end  
+case when convert(nvarchar,SalaryOutput_Pay.item2) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item2) end  
+case when convert(nvarchar,SalaryOutput_Pay.item3) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item3) end  
+case when convert(nvarchar,SalaryOutput_Pay.item4) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item4) end  
+case when convert(nvarchar,SalaryOutput_Pay.item5) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item5) end  
+case when convert(nvarchar,SalaryOutput_Pay.item6) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item6) end  
+case when convert(nvarchar,SalaryOutput_Pay.item7) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item7) end  
+case when convert(nvarchar,SalaryOutput_Pay.item8) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item8) end  
+case when convert(nvarchar,SalaryOutput_Pay.item9) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item9) end  
+case when convert(nvarchar,SalaryOutput_Pay.item10) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item10) end  
+case when convert(nvarchar,SalaryOutput_Pay.item11) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item11) end  
+case when convert(nvarchar,SalaryOutput_Pay.item12) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item12) end  
+case when convert(nvarchar,SalaryOutput_Pay.item13) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item13) end  
+case when convert(nvarchar,SalaryOutput_Pay.item14) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item14) end  
+case when convert(nvarchar,SalaryOutput_Pay.item15) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item15) end  
+case when convert(nvarchar,SalaryOutput_Pay.item16) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item16) end  
+case when convert(nvarchar,SalaryOutput_Pay.item17) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item17) end  
+case when convert(nvarchar,SalaryOutput_Pay.item18) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item18) end  
+case when convert(nvarchar,SalaryOutput_Pay.item19) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item19) end  
+case when convert(nvarchar,SalaryOutput_Pay.item20) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item20) end  
+case when convert(nvarchar,SalaryOutput_Pay.item21) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item21) end  
+case when convert(nvarchar,SalaryOutput_Pay.item22) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item22) end  
  
+case when convert(nvarchar,SalaryOutput_Pay.item23) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item23) end  
+case when convert(nvarchar,SalaryOutput_Pay.item24) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item24) end  
+case when convert(nvarchar,SalaryOutput_Pay.item25) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item25) end  
+case when convert(nvarchar,SalaryOutput_Pay.item26) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item26) end  
+case when convert(nvarchar,SalaryOutput_Pay.item27) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item27) end  
+case when convert(nvarchar,SalaryOutput_Pay.item28) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item28) end  
+case when convert(nvarchar,SalaryOutput_Pay.item29) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item29) end  
+case when convert(nvarchar,SalaryOutput_Pay.item30) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item30) end  
+case when convert(nvarchar,SalaryOutput_Pay.item31) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item31) end  
+case when convert(nvarchar,SalaryOutput_Pay.item32) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item32) end  
+case when convert(nvarchar,SalaryOutput_Pay.item33) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item33) end  
+case when convert(nvarchar,SalaryOutput_Pay.item34) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item34) end  
+case when convert(nvarchar,SalaryOutput_Pay.item35) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item35) end  
+case when convert(nvarchar,SalaryOutput_Pay.item36) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item36) end  
+case when convert(nvarchar,SalaryOutput_Pay.item37) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item37) end  
+case when convert(nvarchar,SalaryOutput_Pay.item38) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item38) end  
+case when convert(nvarchar,SalaryOutput_Pay.item39) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item39) end  
+case when convert(nvarchar,SalaryOutput_Pay.item40) is null then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Pay.item40) end  
from  SalaryOutput_Pay   
where  SalaryOutput_Pay.CompanyCode=@CompanyCode and  convert(varchar(7),SalaryOutput_Pay.PayYearMonth,111)=@YearMonth   
         and SalaryOutput_Pay.EmployeeType=@EmployeeType and SalaryOutput_Pay.SalaryType=@SalaryType)  
if ((select @str3) is null)  
begin  
--select 'str3_A'
exec(@str3)  
end  
else  
begin  
--select 'str3_B'
exec( 'select '+@str3+' from #TempSalaryItemInformation SalaryItemInformation')  
end  
  
  
  
-------------------SalaryInformation&&SalaryOutput_Pay   出力定義（支払）項目情報取得-----------------------  
  
set @str4=(select  case when convert(nvarchar,SalaryOutput_Pay.item1)  is null  then '''''' else  'SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item1) end  
+case when convert(nvarchar,SalaryOutput_Pay.item2)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item2) end  
+case when convert(nvarchar,SalaryOutput_Pay.item3)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item3) end  
+case when convert(nvarchar,SalaryOutput_Pay.item4)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item4) end  
+case when convert(nvarchar,SalaryOutput_Pay.item5)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item5) end  
+case when convert(nvarchar,SalaryOutput_Pay.item6)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item6) end  
+case when convert(nvarchar,SalaryOutput_Pay.item7)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item7) end  
+case when convert(nvarchar,SalaryOutput_Pay.item8)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item8) end  
+case when convert(nvarchar,SalaryOutput_Pay.item9)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item9) end  
+case when convert(nvarchar,SalaryOutput_Pay.item10)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item10) end  
+case when convert(nvarchar,SalaryOutput_Pay.item11)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item11) end  
+case when convert(nvarchar,SalaryOutput_Pay.item12)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item12) end  
+case when convert(nvarchar,SalaryOutput_Pay.item13)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item13) end  
+case when convert(nvarchar,SalaryOutput_Pay.item14)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item14) end  
+case when convert(nvarchar,SalaryOutput_Pay.item15)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item15) end  
+case when convert(nvarchar,SalaryOutput_Pay.item16)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item16) end  
+case when convert(nvarchar,SalaryOutput_Pay.item17)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item17) end  
+case when convert(nvarchar,SalaryOutput_Pay.item18)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item18) end  
+case when convert(nvarchar,SalaryOutput_Pay.item19)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item19) end  
+case when convert(nvarchar,SalaryOutput_Pay.item20)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item20) end  
+case when convert(nvarchar,SalaryOutput_Pay.item21)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item21) end  
+case when convert(nvarchar,SalaryOutput_Pay.item22)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item22) end  
+case when convert(nvarchar,SalaryOutput_Pay.item23)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item23) end  
+case when convert(nvarchar,SalaryOutput_Pay.item24)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item24) end  
+case when convert(nvarchar,SalaryOutput_Pay.item25)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item25) end  
+case when convert(nvarchar,SalaryOutput_Pay.item26)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item26) end  
+case when convert(nvarchar,SalaryOutput_Pay.item27)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item27) end  
+case when convert(nvarchar,SalaryOutput_Pay.item28)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item28) end  
+case when convert(nvarchar,SalaryOutput_Pay.item29)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item29) end  
  
+case when convert(nvarchar,SalaryOutput_Pay.item30)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item30) end  
+case when convert(nvarchar,SalaryOutput_Pay.item31)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item31) end  
+case when convert(nvarchar,SalaryOutput_Pay.item32)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item32) end  
+case when convert(nvarchar,SalaryOutput_Pay.item33)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item33) end  
+case when convert(nvarchar,SalaryOutput_Pay.item34)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item34) end  
+case when convert(nvarchar,SalaryOutput_Pay.item35)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item35) end  
+case when convert(nvarchar,SalaryOutput_Pay.item36)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item36) end  
+case when convert(nvarchar,SalaryOutput_Pay.item37)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item37) end  
+case when convert(nvarchar,SalaryOutput_Pay.item38)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item38) end  
+case when convert(nvarchar,SalaryOutput_Pay.item39)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item39) end  
--10061820 20170105 update
--+case when convert(nvarchar,SalaryOutput_Pay.item40)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item40) end  
+case when convert(nvarchar,SalaryOutput_Pay.item40)  is null  then ',''0''' else  ',case when SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item40)+'='+''''''
+'  then ''0'' else SalaryInformation.item'+convert(nvarchar,SalaryOutput_Pay.item40)+' end item'+convert(nvarchar,SalaryOutput_Pay.item40) end  


from  SalaryOutput_Pay   
where  SalaryOutput_Pay.CompanyCode=@CompanyCode and  convert(varchar(7),SalaryOutput_Pay.PayYearMonth,111)=@YearMonth   
         and SalaryOutput_Pay.EmployeeType=@EmployeeType and SalaryOutput_Pay.SalaryType=@SalaryType)  
if ((select @str4) is null)  
begin 
--select 'str4_A' 
exec(@str4)  
end  
else  
begin 
--select 'str4_B'  
exec('select '+@str4+' from #TempSalaryInformation SalaryInformation')  
end  
  
  
  
----------------SalaryItemInformation&&SalaryOutput_Deduct   出力定義（控除）項目名情報取得------------------  
  
set @str5=(select case when convert(nvarchar,SalaryOutput_Deduct.item1)  is null  then '''''' else  'SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item1) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item2)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item2) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item3)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item3) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item4)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item4) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item5)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item5) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item6)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item6) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item7)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item7) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item8)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item8) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item9)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item9) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item10)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item10) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item11)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item11) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item12)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item12) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item13)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item13) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item14)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item14) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item15)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item15) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item16)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item16) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item17)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item17) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item18)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item18) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item19)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item19) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item20)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item20) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item21)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item21) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item22)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item22) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item23)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item23) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item24)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item24) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item25)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item25) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item26)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item26) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item27)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item27) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item28)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item28) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item29)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item29) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item30)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item30) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item31)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item31) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item32)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item32) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item33)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item33) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item34)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item34) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item35)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item35) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item36)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item36) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item37)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item37) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item38)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item38) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item39)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item39) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item40)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item40) end  
from  SalaryOutput_Deduct   
where  SalaryOutput_Deduct.CompanyCode=@CompanyCode and  convert(varchar(7),SalaryOutput_Deduct.PayYearMonth,111)=@YearMonth   
         and SalaryOutput_Deduct.EmployeeType=@EmployeeType and SalaryOutput_Deduct.SalaryType=@SalaryType)  
if ((select @str5) is null)  
begin  
--select 'str5_A'
print(@str5)
exec(@str5)  
end  
else  
begin  
--select 'str5_B'
exec( 'select '+@str5+' from #TempSalaryItemInformation SalaryItemInformation')  
end  
  
  
  
--------------------SalaryInformation&&SalaryOutput_Deduct     出力定義（控除）項目情報取得------------------  
  
set @str6=(select case when convert(nvarchar,SalaryOutput_Deduct.item1)  is null  then '''''' else  'SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item1) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item2)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item2) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item3)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item3) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item4)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item4) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item5)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item5) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item6)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item6) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item7)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item7) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item8)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item8) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item9)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item9) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item10)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item10) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item11)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item11) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item12)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item12) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item13)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item13) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item14)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item14) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item15)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item15) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item16)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item16) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item17)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item17) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item18)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item18) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item19)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item19) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item20)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item20) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item21)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item21) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item22)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item22) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item23)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item23) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item24)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item24) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item25)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item25) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item26)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item26) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item27)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item27) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item28)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item28) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item29)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item29) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item30)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item30) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item31)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item31) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item32)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item32) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item33)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item33) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item34)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item34) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item35)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item35) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item36)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item36) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item37)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item37) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item38)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item38) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item39)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item39) end  
--10061820 20170105 update
--+case when convert(nvarchar,SalaryOutput_Deduct.item40)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item40) end  
+case when convert(nvarchar,SalaryOutput_Deduct.item40)  is null  then ',''0''' else  ',case when SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item40)+'='+''''''
+'  then ''0'' else SalaryInformation.item'+convert(nvarchar,SalaryOutput_Deduct.item40)+' end item'+convert(nvarchar,SalaryOutput_Deduct.item40) end  
from  SalaryOutput_Deduct   
where  SalaryOutput_Deduct.CompanyCode=@CompanyCode and  convert(varchar(7),SalaryOutput_Deduct.PayYearMonth,111)=@YearMonth   
         and SalaryOutput_Deduct.EmployeeType=@EmployeeType and SalaryOutput_Deduct.SalaryType=@SalaryType)  
if ((select @str6) is null)  
begin  
--select 'str6_A' 
print(@str6)
exec(@str6)  
end  
else  
begin  
--select 'str6_B' 
exec('select '+@str6+' from #TempSalaryInformation SalaryInformation')  
end  
  
  
  
----------------------SalaryItemInformation&&SalaryOutput_Sum   出力定義（合計）項目名情報取得------------------  
  
set @str7=(select case when convert(nvarchar,SalaryOutput_Sum.item1)  is null  then '''''' else  'SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Sum.item1) end  
+case when convert(nvarchar,SalaryOutput_Sum.item2)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Sum.item2) end  
+case when convert(nvarchar,SalaryOutput_Sum.item3)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Sum.item3) end  
+case when convert(nvarchar,SalaryOutput_Sum.item4)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Sum.item4) end  
+case when convert(nvarchar,SalaryOutput_Sum.item5)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Sum.item5) end  
+case when convert(nvarchar,SalaryOutput_Sum.item6)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Sum.item6) end  
+case when convert(nvarchar,SalaryOutput_Sum.item7)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Sum.item7) end  
+case when convert(nvarchar,SalaryOutput_Sum.item8)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Sum.item8) end  
+case when convert(nvarchar,SalaryOutput_Sum.item9)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Sum.item9) end  
+case when convert(nvarchar,SalaryOutput_Sum.item10)  is null  then ',''''' else  ',SalaryItemInformation.item'+convert(nvarchar,SalaryOutput_Sum.item10) end  
from  SalaryOutput_Sum   
where  SalaryOutput_Sum.CompanyCode=@CompanyCode and  convert(varchar(7),SalaryOutput_Sum.PayYearMonth,111)=@YearMonth   
         and SalaryOutput_Sum.EmployeeType=@EmployeeType and SalaryOutput_Sum.SalaryType=@SalaryType)  
if ((select @str7) is null)  
begin  
--select 'str7_A' 
exec(@str7)  
end  
else  
begin  
--select 'str7_B' 
exec( 'select '+@str7+' from #TempSalaryItemInformation SalaryItemInformation')  
end  
  
  
  
-----------------------SalaryInformation&&SalaryOutput_Sum   出力定義（合計）項目情報取得------------------  
  
set @str8=(select 
--10061820 20170105 update
--case when convert(nvarchar,SalaryOutput_Sum.item1)  is null  then '''''' else  'SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item1) end  
--+case when convert(nvarchar,SalaryOutput_Sum.item2)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item2) end  
case when convert(nvarchar,SalaryOutput_Sum.item1)  is null  then '''0''' else  'case when SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item1)+'='+''''''
+'  then ''0'' else SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item1)+' end item'+convert(nvarchar,SalaryOutput_Sum.item1) end
+case when convert(nvarchar,SalaryOutput_Sum.item2)  is null  then ',''0''' else  ',case when SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item2)+'='+''''''
+'  then ''0'' else SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item2)+' end item'+convert(nvarchar,SalaryOutput_Sum.item2) end

+case when convert(nvarchar,SalaryOutput_Sum.item3)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item3) end  
+case when convert(nvarchar,SalaryOutput_Sum.item4)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item4) end  
+case when convert(nvarchar,SalaryOutput_Sum.item5)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item5) end  
+case when convert(nvarchar,SalaryOutput_Sum.item6)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item6) end  
+case when convert(nvarchar,SalaryOutput_Sum.item7)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item7) end  
+case when convert(nvarchar,SalaryOutput_Sum.item8)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item8) end  
+case when convert(nvarchar,SalaryOutput_Sum.item9)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item9) end  
+case when convert(nvarchar,SalaryOutput_Sum.item10)  is null  then ',''''' else  ',SalaryInformation.item'+convert(nvarchar,SalaryOutput_Sum.item10) end  
from  SalaryOutput_Sum   
where  SalaryOutput_Sum.CompanyCode=@CompanyCode and  convert(varchar(7),SalaryOutput_Sum.PayYearMonth,111)=@YearMonth   
         and SalaryOutput_Sum.EmployeeType=@EmployeeType and SalaryOutput_Sum.SalaryType=@SalaryType)  
if ((select @str8) is null)  
begin  
--select 'str8_A' 
exec(@str8)  
end  
else  
begin
--select 'str8_B'   
exec('select '+@str8+' from #TempSalaryInformation SalaryInformation')  
end  
  
  
  
  
-----------------給与合計情報項目情報取得------------------  
--select 'str9' 
select  cast(sum(SalarySum) as int), cast(sum(TaxFreeSum) as int), cast(sum(SocialInsuranceSum) as int), cast(sum(TaxSum) as int)  
from    SalarySumInformation  
where  EmployeeManagementID = @EmployeeManagementID and   
         PayYearMonth>=LEFT(@YearMonthTemp,4)+'/01/01' and PayYearMonth<= @YearMonthTemp   
          and CompanyCode = @CompanyCode  

  
------------------------------社員事業部情報取得--------------------------------------  
  
  
--select  case @CompanyCode    --2200424 20150807 delete
-- when 1 then '（株）トライアルカンパニー'   
-- when 2 then '（株）TAS'   
-- when 3 then '（株）ティー・エル・エス'   
-- when 4 then '（株）カウボーイ'  
-- when 5 then '（株）トライアル・プラネット'  
-- when 6 then '(株)ティー・ティー・エル'  
-- when 7 then 'Trial　Retail　Engineering.　Inc.　日本支店'  
-- when 8 then '（株）トライウェル'  
-- when 9 then '(株)トライアルインベストメント'  --10060815 20130507  
-- when 20 then '(株)トライアルベーカリー'  --2200424 20150409
-- when 21 then '(株)トライアル開発'  --2200424 20150409
--end   
--select 'str10' 
select Company_Name_short_OBIC  --2200424 20150807 add
from mstCompanyName
where Company_code_OBIC=@CompanyCode

  
  
  
---------------------------------給与支給年月情報取得-----------------------------------  
/*  
--2019/04/16 10113982 宋家軍 抹消 begin
if @YearMonth>='1989/01'  
begin  
select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月分'  
end  
else  
begin  
select '昭和'+convert(varchar,substring(convert(varchar(4),@YearMonth),3,4)-25)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月分'  
end  
--2019/04/16 10113982 宋家軍 抹消 end
*/  
  
--2019/04/16 10113982 宋家軍 増加 begin
if @YearMonth>='2019/05'
begin  
--select 'str11_A' 
select '令和'+convert(varchar,convert(varchar(4),@YearMonth)-2018)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月分'  
end 
else if @YearMonth>='1989/01' and @YearMonth<='2019/04'
begin  
--select 'str11_B' 
select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月分'  
end  
else if @YearMonth>='1926/01' and @YearMonth<='1988/12'
begin  
--select 'str11_C' 
select '昭和'+convert(varchar,convert(varchar(4),@YearMonth)-1925)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月分'  
end  
--2019/04/16 10113982 宋家軍 増加 end

---------------------------------給与支給年月日情報取得----------------------------------  
/*
--2019/04/16 10113982 宋家軍 抹消 begin  
if @YearMonth>='1989/01'  
begin  
  
 if (@EmployeeType = '1' and @SalaryType = '1' and @YearMonth > '2011/07/01')  
 begin  
  select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item7 +'日'  
  from #TempSalaryInformation SalaryInformation  
  --where  CompanyCode=@CompanyCode and  convert(varchar(7),PayYearMonth,111)=@YearMonth   
  --         and EmployeeType=@EmployeeType and SalaryType=@SalaryType and EmployeeManagementID = @EmployeeManagementID  
 end  
 else if  (@EmployeeType in (3) and @SalaryType = '1' and @YearMonth > '2011/08/01')  
 begin  
  select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item7 +'日'  
  from #TempSalaryInformation SalaryInformation  
  --where  CompanyCode=@CompanyCode and  convert(varchar(7),PayYearMonth,111)=@YearMonth   
  --         and EmployeeType=@EmployeeType and SalaryType=@SalaryType and EmployeeManagementID = @EmployeeManagementID  
 end   
 else if  (@EmployeeType in (2) and @SalaryType = '1' and @YearMonth > '2011/08/01')  
 begin  
  select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item8 +'日'  
  from #TempSalaryInformation SalaryInformation  
  --where  CompanyCode=@CompanyCode and  convert(varchar(7),PayYearMonth,111)=@YearMonth   
  --         and EmployeeType=@EmployeeType and SalaryType=@SalaryType and EmployeeManagementID = @EmployeeManagementID  
 end   
 else  
 begin  
  select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item6 +'日'  
  from #TempSalaryInformation SalaryInformation  
  --where  CompanyCode=@CompanyCode and  convert(varchar(7),PayYearMonth,111)=@YearMonth   
  --         and EmployeeType=@EmployeeType and SalaryType=@SalaryType and EmployeeManagementID = @EmployeeManagementID  
 end  
  
end  
else  
begin  
  
 select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item6 +'日'  
 from #TempSalaryInformation SalaryInformation  
 --where  CompanyCode=@CompanyCode and  convert(varchar(7),PayYearMonth,111)=@YearMonth   
 --         and EmployeeType=@EmployeeType and SalaryType=@SalaryType and EmployeeManagementID = @EmployeeManagementID  
end  
--2019/04/16 10113982 宋家軍 抹消 end
*/  


--2019/04/16 10113982 宋家軍 増加 begin
if @YearMonth>='2019/05'  
begin  
  
 if (@EmployeeType = '1' and @SalaryType = '1' and @YearMonth > '2011/07/01')  
 begin  
 --select 'str12_A'
  select '令和'+convert(varchar,convert(varchar(4),@YearMonth)-2018)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item7 +'日'  
  from #TempSalaryInformation SalaryInformation  
 end  
 else if  (@EmployeeType in (3) and @SalaryType = '1' and @YearMonth > '2011/08/01')  
 begin  
 -- select 'str12_B'
  select '令和'+convert(varchar,convert(varchar(4),@YearMonth)-2018)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item7 +'日'  
  from #TempSalaryInformation SalaryInformation   
 end   
 else if  (@EmployeeType in (2) and @SalaryType = '1' and @YearMonth > '2011/08/01')  
 begin  
 --select 'str12_C'
  select '令和'+convert(varchar,convert(varchar(4),@YearMonth)-2018)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item8 +'日'  
  from #TempSalaryInformation SalaryInformation  
 end   
 else  
 begin  
 --select 'str12_D'
  select '令和'+convert(varchar,convert(varchar(4),@YearMonth)-2018)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item6 +'日'  
  from #TempSalaryInformation SalaryInformation   
 end  
  
end


else if @YearMonth>='1989/01' and @YearMonth<='2019/04'
begin  
  
 if (@EmployeeType = '1' and @SalaryType = '1' and @YearMonth > '2011/07/01')  
 begin  
  --select 'str12_E'
  select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item7 +'日'  
  from #TempSalaryInformation SalaryInformation  
 end  
 else if  (@EmployeeType in (3) and @SalaryType = '1' and @YearMonth > '2011/08/01')  
 begin  
 --select 'str12_F'
  select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item7 +'日'  
  from #TempSalaryInformation SalaryInformation   
 end   
 else if  (@EmployeeType in (2) and @SalaryType = '1' and @YearMonth > '2011/08/01')  
 begin  
 --select 'str12_G'
  select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item8 +'日'  
  from #TempSalaryInformation SalaryInformation  
 end   
 else  
 begin  
 --select 'str12_H'
  select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item6 +'日'  
  from #TempSalaryInformation SalaryInformation   
 end  
  
end  

else  
begin  
--select 'str12_I'
 select '平成'+convert(varchar,convert(varchar(4),@YearMonth)-1988)+'年'+convert(varchar,convert(int,(substring(convert(varchar(7),@YearMonth),6,2))))+'月'+item6 +'日'  
 from #TempSalaryInformation SalaryInformation  
end  
--2019/04/16 10113982 宋家軍 増加 end

--------------------------------------所属情報取得-----------------------------------------  
  
begin  
set @str9=('item'+@Affiliate)  
--select 'str13'
exec('select '+@str9+' from     #TempSalaryInformation SalaryInformation ')  
end  
--------------------------------------累計項目の名前------朱国偉---2009/12/09--------------------------------  
  
begin 
--select 'str14' 
select isnull(item1,'') as item1  
,isnull(item2,'') as item2  
,isnull(item3,'') as item3  
,isnull(item4,'') as item4  
from SalaryAccumtItemInfor  
where CompanyCode=@CompanyCode and EmployeeType=@EmployeeType and SalaryType=@SalaryType  
end  
  
  
--select  case @CompanyCode   --2200424 2015087 dele
-- when 1 then '株式会社 トライアルカンパニー'   
-- when 2 then '株式会社 TAS'   
-- when 3 then '株式会社　ティー・エル・エス'   
-- when 4 then '株式会社 カウボーイ'  
-- when 5 then '株式会社 トライアル・プラネット'  
-- when 6 then '株式会社 ティー・ティー・エル'  
-- when 7 then 'Trial　Retail　Engineering.　Inc.　日本支店'  
-- when 8 then '株式会社 トライウェル'  
-- when 9 then '株式会社 トライアルインベストメント'  --10060815 20130507  
-- when 20 then '株式会社 トライアルベーカリー'  --2200424 20150409
-- when 21 then '株式会社 トライアル開発'  --2200424 20150409
--end   

--select 'str15'
select Company_Name_OBIC  --2200424 20150807 add
from mstCompanyName
where Company_code_OBIC=@CompanyCode
      
  
  
  
  
  
  
  
  


GO


