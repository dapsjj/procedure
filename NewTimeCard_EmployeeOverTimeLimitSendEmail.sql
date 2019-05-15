USE [dbkintai]
GO

/****** Object:  StoredProcedure [dbo].[NewTimeCard_EmployeeOverTimeLimitSendEmail]    Script Date: 2019/05/15 15:17:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER	 PROC	[dbo].[NewTimeCard_EmployeeOverTimeLimitSendEmail]

AS
BEGIN

	IF object_id('tempdb.dbo.#ForSendEmail') is not null --drop table #ForSendEmail
	DROP TABLE #ForSendEmail

	select TN.EmployeeCode,TN.YearMonth,TN.OverTime,TN.[36Flg],TN.OverTimeFlg,TN.OverTimeMessage,getdate() as CreateDate --insert into #ForSendEmail
	into #ForSendEmail
	from NTE_KintaiEmployeeOverTimeLimitNew TN
	left join NTE_KintaiEmployeeOverTimeLimitNew_History TH 
	on TN.EmployeeCode = TH.EmployeeCode and TN.YearMonth = TH.YearMonth and TN.OverTimeMessage = TH.OverTimeMessage
	where TN.OverTimeFlg>0 
	      and TH.EmployeeCode is null and TH.YearMonth is null and TH.OverTimeMessage is null

	insert into NTE_KintaiEmployeeOverTimeLimitNew_History --insert into NTE_KintaiEmployeeOverTimeLimitNew_History
	select * from #ForSendEmail

	select * from #ForSendEmail



END

GO


