USE [dbYearAjust]
GO
/****** Object:  UserDefinedFunction [dbo].[FN_Year_GetMoney]    Script Date: 2019/04/22 9:46:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/************年末調整システム使用***********
--作成者：10061820
--作成日：2016/12/23

--例：
SELECT  dbo.FN_Year_GetMoney(1464582,2,1) 

****************************************/
ALTER FUNCTION  [dbo].[FN_Year_GetMoney]
(@in_money money
 ,@flag int
 ,@type int)
 -- @flag=1 1 
 -- @flag=2 千
 -- @flag=3 百万
 -- @type = 1  千
 -- @type = 2   百万
RETURNS VARCHAR(5)
AS
begin
    declare @result VARCHAR(5)
    declare @money int
    set @money = CONVERT(int,@in_money)
    if @flag = 1 --1
    begin
        if @money>=1000  set @result = Right('000'+convert(varchar,@money%1000),3)
        else  set @result = convert(varchar,@money%1000)
    end
    else if @flag = 2  --千
    begin
        if (@money >= 1000000 and @type = 2)  set @result = Right('000'+convert(varchar,@money/1000%1000),3)
        else if   @money >= 1000 set @result = convert(varchar,@money/1000)
        else set @result=''
    end
    else if @flag = 3  --百万
    begin
        if @money>=1000000  set @result = convert(varchar,@money/1000000)
        else set @result=''
    end
    return @result
end



