USE [dbkintai]
GO

/****** Object:  StoredProcedure [dbo].[NewTimeCard_EmployeeOverTimeLimitCheckNew]    Script Date: 2019/04/30 9:04:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE	 PROC		[dbo].[NewTimeCard_EmployeeOverTimeLimitCheckNew]
(
	@EmployeeCode INT
	,@StampType INT
	,@StampTime DATETIME
)
AS
BEGIN
	IF object_id('tempdb.dbo.#EmployeeBase') is not null 
	DROP TABLE #EmployeeBase
	IF object_id('tempdb.dbo.#EmployeeRestWork') is not null 
	DROP TABLE #EmployeeRestWork
	IF object_id('tempdb.dbo.#EmployeeRestWorkTime') is not null 
	DROP TABLE #EmployeeRestWorkTime

	DECLARE @YearMonthDay DATETIME
	
	SELECT
		@YearMonthDay=YearMonthDay
	FROM
		dbkintai.dbo.NTE_KintaiInformation
	WHERE
		EmployeeCode=@EmployeeCode
	
	IF @YearMonthDay IS NULL
	BEGIN
		SELECT @YearMonthDay=CONVERT(VARCHAR(100),GETDATE(),111)
	END
	
	PRINT @YearMonthDay
	
	IF @StampType=1
	BEGIN
		SELECT
			NL.EmployeeCode
			,NL.YearMonth
			,NL.OverTime
			,NL.[36Flg]
			,NL.OverTimeFlg
			,NL.OverTimeMessage
		FROM
			dbkintai.dbo.NTE_KintaiEmployeeOverTimeLimit NL
		INNER JOIN
			dbkintai.dbo.T_Mカレンダー_NEW TM
			ON NL.YearMonth=TM.会計月
		WHERE
			NL.EmployeeCode=@EmployeeCode
		AND
			TM.年月日=@YearMonthDay
		AND
			OverTimeFlg>0
	END
	ELSE IF @StampType=2
	BEGIN
		DECLARE @36Flg INT
		DECLARE @OverTime INT
		DECLARE @Employee_division INT
		SELECT 
			@Employee_division=Employee_division
		FROM
			dbEmployee.dbo.mstEmployeeBasic
		WHERE
			EmployeeCode=@EmployeeCode
		SET @36Flg=0
		SET @OverTime=0
		SELECT
			@OverTime=NL.OverTime
			,@36Flg=NL.[36Flg]
		FROM
			dbkintai.dbo.NTE_KintaiEmployeeOverTimeLimit NL
		INNER JOIN
			dbkintai.dbo.T_Mカレンダー_NEW TM
			ON NL.YearMonth=TM.会計月
		WHERE
			NL.EmployeeCode=@EmployeeCode
		AND
			TM.年月日=@YearMonthDay
		DECLARE @OverLimit Float
		DECLARE @OverTimeToDay Float
		SET @OverTimeToDay=0
		SET @OverLimit=9
		IF @Employee_division=4
		BEGIN
			SELECT
				@OverTimeToDay=ISNULL(CAST(DATEDIFF(mi,dbo.GetCalTime(実績出勤時刻,2),dbo.GetCalTime(@StampTime,1)) AS FLOAT)/60-@OverLimit,0)
			FROM
				NTE_KintaiInformation
			WHERE
				EmployeeCode=@EmployeeCode
			IF @OverTimeToDay+@OverTime>=40
			BEGIN
				SELECT
					NL.EmployeeCode
					,NL.YearMonth
					,@OverTimeToDay+@OverTime AS OverTime
					,NL.[36Flg]
					,3 AS OverTimeFlg
					,'残業40時間を超えてしまいました。翌日以降から出勤停止となります' AS OverTimeMessage
				FROM
					dbkintai.dbo.NTE_KintaiEmployeeOverTimeLimit NL
				INNER JOIN
					dbkintai.dbo.T_Mカレンダー_NEW TM
					ON NL.YearMonth=TM.会計月
				WHERE
					NL.EmployeeCode=@EmployeeCode
				AND
					TM.年月日=@YearMonthDay
			END
		END
		--ELSE IF @Employee_division=3
		ELSE IF @Employee_division in (1,3)
		BEGIN
			--SELECT 
			--	MEB.EmployeeCode,TM.会計月,TM.StartDate,TM.EndDate
			--	,CASE 
			--		MONTH(TM.StartDate)
			--		WHEN 1 THEN 22
			--		WHEN 2 THEN 21
			--		WHEN 3 THEN 22
			--		WHEN 4 THEN 21
			--		WHEN 5 THEN 22
			--		WHEN 6 THEN 22
			--		WHEN 7 THEN 22
			--		WHEN 8 THEN 22
			--		WHEN 9 THEN 22
			--		WHEN 10 THEN 22
			--		WHEN 11 THEN 21
			--		WHEN 12 THEN 22
			--		END AS WorkDay
			--INTO #EmployeeBase
			--FROM 
			--	dbEmployee..mstEmployeeBasic MEB WITH(NOLOCK)
			--INNER JOIN(
			--	SELECT 
			--		TM.会計月,MIN(TMD.年月日) AS StartDate,MAX(TMD.年月日) AS EndDate
			--	FROM
			--		dbkintai.dbo.T_Mカレンダー_NEW TM WITH(NOLOCK)
			--	LEFT JOIN
			--		dbkintai.dbo.T_Mカレンダー_NEW TMD WITH(NOLOCK)
			--		ON TMD.会計月=TM.会計月
			--	WHERE
			--		TM.年月日=@YearMonthDay
			--	GROUP BY TM.会計月
			--)TM
			--ON 1=1
			--WHERE
			--	MEB.EmployeeCode=@EmployeeCode
			--ORDER BY EmployeeCode,会計月

			SELECT 				
				MEB.EmployeeCode AS EmployeeCode,				
				TMH.YearMonth AS 会計月,				
				TM.StartDate,				
				TM.EndDate,				
				TM.Totaldays -ISNULL(TMH.Holiday,0) AS WorkDay				
			INTO #EmployeeBase
			FROM 				
			dbEmployee..mstEmployeeBasic MEB 				
			LEFT JOIN dbEmployee..mstAttribute MAT_Temp 				
			ON MEB.EmployeeManagementID = MAT_Temp.EmployeeManagementID 				
			LEFT JOIN dbKintai.dbo.T_M_Affiliation TMAF 				
			ON TMAF.StoreCD = MAT_Temp.Admin_Management 				
			AND TMAF.AffiliationCD = MAT_Temp.Admin_Affiliated 	
			INNER JOIN(				
					SELECT 		
						TM.会計月,MIN(TMD.年月日) AS StartDate,MAX(TMD.年月日) AS EndDate,COUNT(1) AS Totaldays	
					FROM		
						dbkintai.dbo.T_Mカレンダー_NEW TM WITH(NOLOCK)	
					LEFT JOIN		
						dbkintai.dbo.T_Mカレンダー_NEW TMD WITH(NOLOCK)	
						ON TMD.会計月=TM.会計月	
					WHERE		
						TM.年月日 = @YearMonthDay
					GROUP BY TM.会計月		
						)TM	
			ON 1=1
			--10047510 20180604 update ↓↓↓
			/*LEFT  JOIN dbKintai..T_M_Holiday_New TMH  				
			ON TMH.BusinessType = TMAF.HolidayDiv 				
			AND TMH.Groupings = 				
			CASE WHEN MAT_Temp.GPGrade IS NULL OR MAT_Temp.GPGrade = 0 THEN MAT_Temp.Salary_Stage 				
			ELSE (SELECT SalaryGPCode FROM dbEmployee..tmpGPGrade 				
					WHERE GPGrade= MAT_Temp.GPGrade) END 				
			AND TMH.Flag = CASE WHEN MAT_Temp.GPGrade IS NULL OR MAT_Temp.GPGrade = 0 THEN 1 ELSE 2 END */
			LEFT JOIN
				dbkintai.dbo.V_GetEmployeeHoliday TMH
			ON TMH.EmployeeCode=MEB.EmployeeCode
			AND TM.会計月 = TMH.YearMonth
			--10047510 20180604 update ↑↑↑								
			WHERE  				
				MEB.EmployeeCode=@EmployeeCode				
			AND MAT_Temp.Admin_Management IN (4,49,66,109,116,143,151,157,211,241,246,253,269,324,330,334)		
			ORDER BY MEB.EmployeeCode,TMH.YearMonth	

			SELECT 
				EB.EmployeeCode,EB.会計月
				,CASE 
					WHEN (ISNULL(COUNT(TP.EmployeeCd),0)-EB.WorkDay)<0 THEN 0 
					ELSE ISNULL(COUNT(TP.EmployeeCd),0)-EB.WorkDay 
					END AS RestWorkDay
			INTO #EmployeeRestWork
			FROM 
				#EmployeeBase EB
			LEFT JOIN
				dbkintai.dbo.T_Mカレンダー_NEW TM WITH(NOLOCK)
				ON TM.会計月=EB.会計月
			LEFT JOIN
				dbkintai.dbo.T_D_OperationPlan TP WITH(NOLOCK)
				ON TP.EmployeeCd=EB.EmployeeCode AND TP.YearMonthDay=TM.年月日 AND TP.AttendanceKbn IN (1,3,4,5,6,21,22,23,31,32)
			GROUP BY EB.EmployeeCode,EB.会計月,EB.WorkDay
			ORDER BY EB.EmployeeCode,EB.会計月

			SELECT 
				EW.EmployeeCode,EW.会計月,EW.RestWorkDay
				,CASE WHEN HA.EmployeeMID IS NULL THEN 45 ELSE 60 END AS TimeMax
				,CASE 
					WHEN (EW.RestWorkDay*8)>CASE WHEN HA.EmployeeMID IS NULL THEN 45 ELSE 60 END 
					THEN CASE WHEN HA.EmployeeMID IS NULL THEN 45 ELSE 60 END 
					ELSE (EW.RestWorkDay*8) 
					END AS RestWorkTime
			INTO #EmployeeRestWorkTime
			FROM
				#EmployeeRestWork EW
			INNER JOIN
				dbEmployee..mstEmployeeBasic MEB
				ON EW.EmployeeCode=MEB.EmployeeCode
			LEFT JOIN
				dbAttribute.dbo.History_ApplicationState HA
				ON MEB.EmployeeManagementID=HA.EmployeeMID AND HA.ApplyType=4 AND HA.AdmitStateID IN(1,2)
				AND 
					HA.ApplyDate =(LEFT(CAST(EW.会計月 AS VARCHAR),4)+'/'+RIGHT(CAST(EW.会計月 AS VARCHAR),2)+'/01')
			ORDER BY EW.EmployeeCode,EW.会計月
		
			SELECT @OverLimit=CASE @Employee_division WHEN 1 THEN 9.5 WHEN 3 THEN 9 ELSE 9 END
			SELECT
				@OverTimeToDay=ISNULL(CAST(DATEDIFF(mi,dbo.GetCalTime(実績出勤時刻,2),dbo.GetCalTime(@StampTime,1)) AS FLOAT)/60-@OverLimit,0)
			FROM
				NTE_KintaiInformation
			WHERE
				EmployeeCode=@EmployeeCode
			IF @36Flg=1
			BEGIN
				IF @OverTimeToDay+@OverTime>=55
				BEGIN
					SELECT
						NL.EmployeeCode
						,NL.YearMonth
						,@OverTimeToDay+@OverTime AS OverTime
						,NL.[36Flg]
						,3 AS OverTimeFlg
						,CASE WHEN ISNULL(ERW.RestWorkTime,0)>0 THEN '今月は休出'+CAST(ERW.RestWorkTime AS VARCHAR(3))+'時間の為、残業制限を超えてしまいました。翌日以降から出勤停止となります'
						ELSE '残業55時間を超えてしまいました。翌日以降から出勤停止となります' END AS OverTimeMessage
					FROM
						dbkintai.dbo.NTE_KintaiEmployeeOverTimeLimit NL
					INNER JOIN
						dbkintai.dbo.T_Mカレンダー_NEW TM
						ON NL.YearMonth=TM.会計月
					LEFT JOIN
						#EmployeeRestWorkTime ERW
						ON ERW.EmployeeCode=NL.EmployeeCode AND ERW.会計月=TM.会計月
					WHERE
						NL.EmployeeCode=@EmployeeCode
					AND
						TM.年月日=@YearMonthDay
				END
			END
			ELSE
			BEGIN
				IF @OverTimeToDay+@OverTime>=40
				BEGIN
					SELECT
						NL.EmployeeCode
						,NL.YearMonth
						,@OverTimeToDay+@OverTime AS OverTime
						,NL.[36Flg]
						,3 AS OverTimeFlg
						,CASE WHEN ISNULL(ERW.RestWorkTime,0)>0 THEN '今月は休出'+CAST(ERW.RestWorkTime AS VARCHAR(3))+'時間の為、残業制限を超えてしまいました。36協定を申請しないと、翌日以降の出勤は停止となります'
						ELSE '残業40時間を超えてしまいました。36協定を申請しないと、翌日以降の出勤停止となります' END AS OverTimeMessage
					FROM
						dbkintai.dbo.NTE_KintaiEmployeeOverTimeLimit NL
					INNER JOIN
						dbkintai.dbo.T_Mカレンダー_NEW TM
						ON NL.YearMonth=TM.会計月
					LEFT JOIN
						#EmployeeRestWorkTime ERW
						ON ERW.EmployeeCode=NL.EmployeeCode AND ERW.会計月=TM.会計月
					WHERE
						NL.EmployeeCode=@EmployeeCode
					AND
						TM.年月日=@YearMonthDay
				END
			END
		END
		ELSE
		BEGIN
			SELECT @OverLimit=CASE @Employee_division WHEN 1 THEN 9.5 WHEN 3 THEN 9 ELSE 9 END
			SELECT
				@OverTimeToDay=ISNULL(CAST(DATEDIFF(mi,dbo.GetCalTime(実績出勤時刻,2),dbo.GetCalTime(@StampTime,1)) AS FLOAT)/60-@OverLimit,0)
			FROM
				NTE_KintaiInformation
			WHERE
				EmployeeCode=@EmployeeCode
			IF @36Flg=1
			BEGIN
				IF @OverTimeToDay+@OverTime>=55
				BEGIN
					SELECT
						NL.EmployeeCode
						,NL.YearMonth
						,@OverTimeToDay+@OverTime AS OverTime
						,NL.[36Flg]
						,3 AS OverTimeFlg
						,'残業55時間を超えてしまいました。翌日以降から出勤停止となります' AS OverTimeMessage
					FROM
						dbkintai.dbo.NTE_KintaiEmployeeOverTimeLimit NL
					INNER JOIN
						dbkintai.dbo.T_Mカレンダー_NEW TM
						ON NL.YearMonth=TM.会計月
					WHERE
						NL.EmployeeCode=@EmployeeCode
					AND
						TM.年月日=@YearMonthDay
				END
			END
			ELSE
			BEGIN
				IF @OverTimeToDay+@OverTime>=40
				BEGIN
					SELECT
						NL.EmployeeCode
						,NL.YearMonth
						,@OverTimeToDay+@OverTime AS OverTime
						,NL.[36Flg]
						,3 AS OverTimeFlg
						,'残業40時間を超えてしまいました。36協定を申請しないと、翌日以降の出勤停止となります' AS OverTimeMessage
					FROM
						dbkintai.dbo.NTE_KintaiEmployeeOverTimeLimit NL
					INNER JOIN
						dbkintai.dbo.T_Mカレンダー_NEW TM
						ON NL.YearMonth=TM.会計月
					WHERE
						NL.EmployeeCode=@EmployeeCode
					AND
						TM.年月日=@YearMonthDay
				END
			END
		END
	END
END

GO


