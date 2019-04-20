USE [dbYearAjust]
GO

/****** Object:  UserDefinedFunction [dbo].[FN_Year_GetJpanYear]    Script Date: 2019/04/20 15:24:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





/************年末調整システム使用***********
--作成者：10061820
--作成日：2016/12/23

--例：
SELECT  dbo.FN_Year_GetJpanYear('2015/1/1')

SELECT  dbo.FN_Year_GetJpanYear('1989/5/1')
****************************************/


CREATE           FUNCTION  [dbo].[FN_Year_GetJpanYear]
 (@DATE DATETIME)
RETURNS VARCHAR(20)

AS
BEGIN
  DECLARE @YEAR   SMALLINT
  DECLARE @MONTH  TINYINT
  DECLARE @DAY    TINYINT
  DECLARE @WAREKI NVARCHAR(50)
  DECLARE @GENGO  NVARCHAR(5)
  DECLARE @WAYEAR NVARCHAR(10)
   
  /*明治以前は対応しません*/
  IF @DATE < '1868/1/25' RETURN N'変換できません'
  /*月、年、日の取り出し*/
  SET @MONTH = MONTH(@DATE)
  SET @YEAR  = YEAR(@DATE)
  SET @DAY   = DAY(@DATE)
  /*和暦の元号セット*/
  IF @DATE > '1989/1/7'
    BEGIN
      SET @GENGO = '平成'
      SET @WAYEAR = CONVERT(NVARCHAR(5), @YEAR-1988) 
    END
  ELSE IF @DATE > '1926/12/24'
    BEGIN
      SET @GENGO = '昭和'
      SET @WAYEAR = CONVERT(NVARCHAR(5), @YEAR-1925) 
    END
  ELSE IF @DATE > '1912/7/29'
    BEGIN
      SET @GENGO = '大正'
      SET @WAYEAR = CONVERT(NVARCHAR(5), @YEAR-1911)
    END
  ELSE 
    BEGIN
      SET @GENGO = '明治'
      SET @WAYEAR = CONVERT(NVARCHAR(5), @YEAR-1867)
    END
  /*1年だったら元年と表示する*/
  --IF @WAYEAR = N'1年' SET @WAYEAR = N'元年'
  --SET @WAREKI = @GENGO + @WAYEAR + CONVERT(NVARCHAR(2), @MONTH)+ N'月' + CONVERT(NVARCHAR(2), @DAY) + N'日'
  /*和暦を戻します*/
  RETURN @WAYEAR
END




GO


