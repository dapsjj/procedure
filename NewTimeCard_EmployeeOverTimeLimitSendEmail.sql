USE [dbkintai]
GO

/****** Object:  StoredProcedure [dbo].[NewTimeCard_EmployeeOverTimeLimitSendEmail]    Script Date: 2019/05/16 11:04:53 ******/
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

	--select * from #ForSendEmail






--要发信的临时表
IF object_id('tempdb.dbo.#NTE_KintaiEmployeeOverTimeLimitNew') is not null 
DROP TABLE #NTE_KintaiEmployeeOverTimeLimitNew

SELECT
	[EmployeeCode ],
  [YearMonth],
	[OverTime],
	[36Flg],
	[OverTimeFlg],
	[OverTimeMessage],
	[CreateDate]
INTO #NTE_KintaiEmployeeOverTimeLimitNew
FROM
	dbkintai.dbo.NTE_KintaiEmployeeOverTimeLimitNew
   --#ForSendEmail
------------------------------------------------------------------------------------------
  DECLARE @MSG1 nvarchar(100) ='今月の残業時間が35時間を超えています。残業時間の調整をして下さい。' 
  DECLARE @MSG2 nvarchar(100) ='今月の残業時間が42時間を超えています。<br>特別条項を出すか、残業時間の調整をして下さい。<br>特別条項が出てないので、45時間を超えると、出勤停止になります。' 
  DECLARE @MSG3 nvarchar(100) ='今月の残業時間が50時間を超えています。残業時間の調整をして下さい。' 
  DECLARE @MSG4 nvarchar(100) ='過重労働時間を超えました。出勤できません。' 
  DECLARE @MSG5 nvarchar(100) ='残業制限を超えてしまいました。翌日以降から出勤停止となります。'

-----------------------------------------------------------------------------------------
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=object_id('tempdb..#info'))
DROP TABLE #info
CREATE TABLE #info
(
		[EmployeeCode] [int] ,
		[EmployeeName] [nvarchar](800) ,
		[EmployeeCD] [int] ,  --leader
		[OverTimeMessageFlg] [nvarchar](800),
		[OverTimeMessage] [nvarchar](800),
		[Type][nvarchar](20)
)
        
--勤怠所属長-----------------------------------------------------------------------------
INSERT INTO #info
SELECT
	NL.EmployeeCode,
	mb.EmployeeName,
	tm.EmployeeCD,
  NL.OverTimeMessage AS OverTimeMessageFlg,
  CASE NL.OverTimeMessage WHEN '1' THEN @MSG1
                          WHEN '2' THEN @MSG2
                          WHEN '3' THEN @MSG3
                          WHEN '4' THEN @MSG4
                          ELSE ''END OverTimeMessage,
 '1' Type
FROM #NTE_KintaiEmployeeOverTimeLimitNew NL
INNER JOIN mstEmployeeBasic mb ON NL.EmployeeCode=MB.EmployeeCode	
INNER JOIN mstAttribute ma ON ma.EmployeeManagementID = mb.EmployeeManagementID
LEFT JOIN dbKintai.dbo.T_M_AffiliationChief tm ON tm.StoreCD = ma.Admin_Management
AND tm.AffiliationCD = ma.Admin_Affiliated

--エリアマネジャー
INSERT INTO #info
SELECT 591 EmployeeCode,'手島 亮介' EmployeeName ,10118205 EmployeeCD,'' OverTimeMessageFlg,'' OverTimeMessage,'2' Type
UNION
SELECT 10122965 EmployeeCode,'石光 真之介' EmployeeName ,10118205 EmployeeCD,'' OverTimeMessageFlg,'' OverTimeMessage,'2' Type
UNION
SELECT 887 EmployeeCode,'島津　秀一' EmployeeName ,10118205 EmployeeCD,'4' OverTimeMessageFlg,'' OverTimeMessage,'2' Type
--ゾーンマネジャー
INSERT INTO #info
SELECT 591 EmployeeCode,'手島 亮介' EmployeeName ,10116842 EmployeeCD,'' OverTimeMessageFlg,'' OverTimeMessage,'3' Type

--
IF EXISTS (SELECT * FROM tempdb..sysobjects WHERE id=object_id('tempdb..#LDR'))
DROP TABLE #LDR
CREATE TABLE #LDR
(

		[EmployeeCD] [int] ,
		[OverTimeMessageFlg] [nvarchar](800)

)
INSERT INTO #LDR
SELECT DISTINCT EmployeeCD,OverTimeMessageFlg FROM #info



DECLARE @Countrow int
DECLARE @EmployeeCD int
DECLARE @OverTimeMessageFlg nvarchar(800)

SELECT @Countrow= COUNT(1) FROM #LDR

WHILE @Countrow>0
BEGIN

 SELECT TOP 1 @EmployeeCD=EmployeeCD,@OverTimeMessageFlg=OverTimeMessageFlg FROM #LDR
 SELECT *  FROM #info WHERE EmployeeCD=@EmployeeCD AND  OverTimeMessageFlg=@OverTimeMessageFlg
 DELETE FROM #LDR
 WHERE EmployeeCD=@EmployeeCD AND  OverTimeMessageFlg=@OverTimeMessageFlg
 SELECT @Countrow= COUNT(1) FROM #LDR

END






END



GO


