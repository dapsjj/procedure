USE [dbkintai]
GO


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER	 PROC	[dbo].[NewTimeCard_EmployeeOverTimeLimitSendEmail]

AS
BEGIN

	IF object_id('tempdb.dbo.#ForSendEmail') is not null --如果临时表不是空则删除临时表
	DROP TABLE #ForSendEmail

	select TN.EmployeeCode,TN.YearMonth,TN.OverTime,TN.[36Flg],TN.OverTimeFlg,TN.OverTimeMessage,getdate() as CreateDate --插入临时表
		   --,TH.EmployeeCode,TH.YearMonth,TH.OverTime,TH.[36Flg],TH.OverTimeFlg,TH.OverTimeMessage,TH.CreateDate
	into #ForSendEmail

	from NTE_KintaiEmployeeOverTimeLimitNew TN
	left join NTE_KintaiEmployeeOverTimeLimitNew_History TH 
	on TN.EmployeeCode = TH.EmployeeCode and TN.YearMonth = TH.YearMonth and TN.OverTimeMessage = TH.OverTimeMessage
	where TN.OverTimeFlg>0 
	      and TH.EmployeeCode is null and TH.YearMonth is null and TH.OverTimeMessage is null

	insert into NTE_KintaiEmployeeOverTimeLimitNew_History --临时表数据插入履历表
	select * from #ForSendEmail

	select * from #ForSendEmail



END
GO
