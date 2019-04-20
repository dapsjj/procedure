USE [dbEmployee]
GO

/****** Object:  UserDefinedFunction [dbo].[F_CertificateYearMonthConvert]    Script Date: 2019/04/20 8:13:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------

ALTER function [dbo].[F_CertificateYearMonthConvert](@convertDate datetime)
Returns nvarchar(50)
as
begin
	--select dbEmployee.dbo.F_CertificateYearMonthConvert('2015-01-05')
	Declare @targetDate VARCHAR(10) = convert(nvarchar(10),@convertDate,20)
	Declare @year int
	Declare @month int
	Declare @day int
	Declare @wareki varchar(50)
	Declare @gengo varchar(5)
	Declare @warekiyear varchar(10)

	IF @targetDate='1868/01/25'
	BEGIN		
		RETURN '明治以前は変換できません'
	END

	set @year  = CAST( SUBSTRING( @targetDate, 1, 4 ) AS INT )
	set @month = CAST( SUBSTRING( @targetDate, 6, 2 ) AS INT )
	set @day   = CAST( SUBSTRING( @targetDate, 9, 2 ) AS INT )

	--和暦変換
	--2019/04/20 10113982 宋家軍 抹消 begin
	/*
	IF @targetDate>'1989/01/07'
	BEGIN
		SET @gengo = '平成'
		SET @warekiyear = CONVERT( VARCHAR( 5 ), @year - 1988 ) + '年'
	END
	ELSE
	BEGIN
		IF @targetDate>'1926/12/24'
		BEGIN
			SET @gengo = '昭和'
			SET @warekiyear = CONVERT( VARCHAR( 5 ),@year - 1925 ) + '年'
		END
		ELSE
		BEGIN
			IF @targetDate>'1912/07/29'
			BEGIN
				SET @gengo='大正'
				SET @warekiyear = CONVERT( VARCHAR( 5 ), @year - 1911 ) + '年'
			END
			ELSE
			BEGIN
				SET @gengo='明治'
				SET @warekiyear = CONVERT( VARCHAR( 5 ), @year - 1867 ) + '年'
			END
		END
	END
	*/
	--2019/04/20 10113982 宋家軍 抹消 end


	--2019/04/20 10113982 宋家軍 増加 begin
	IF @targetDate>'2019/04/30'
		BEGIN
			SET @gengo = '令和'
			SET @warekiyear = CONVERT( VARCHAR( 5 ), @year - 2018 ) + '年'
		END
	ELSE
		BEGIN
			IF @targetDate>'1989/01/07'
				BEGIN
					SET @gengo = '平成'
					SET @warekiyear = CONVERT( VARCHAR( 5 ),@year - 1988 ) + '年'
				END
			ELSE IF @targetDate>'1926/12/24'
				BEGIN
					SET @gengo='昭和'
					SET @warekiyear = CONVERT( VARCHAR( 5 ), @year - 1925 ) + '年'
				END
			ELSE IF @targetDate>'1912/07/29'
				BEGIN
					SET @gengo='大正'
					SET @warekiyear = CONVERT( VARCHAR( 5 ), @year - 1911 ) + '年'
				END
			ELSE
				BEGIN
					SET @gengo='明治'
					SET @warekiyear = CONVERT( VARCHAR( 5 ), @year - 1867 ) + '年'
				END
		END
	--2019/04/20 10113982 宋家軍 増加 end


	-- 1年だったら元年と表示を変更します
	IF @warekiyear = '1年'
	BEGIN
		SET @warekiyear = '元年'
	END

	--結果を文字列として編集
	SET @wareki = @gengo + @warekiyear + CONVERT( VARCHAR( 2 ),@month )+ '月' + CONVERT( VARCHAR( 2 ), @day ) + '日' 

	--結果の表示
	return @wareki

End

GO


