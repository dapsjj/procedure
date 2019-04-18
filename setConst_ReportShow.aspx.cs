using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using CrystalDecisions.Shared;
using CrystalDecisions.ReportSource;
using CrystalDecisions.CrystalReports.Engine;
using System.IO;
using System.Text;
using System.Configuration;
using System.Data.SqlClient;
using System.Diagnostics;
using iTextSharp.text;
using iTextSharp.text.pdf;
using System.Security.Cryptography;

 
namespace SalaryDetails
{
	/// <summary>
	/// ReportShow の概要の説明です。
	/// </summary>
	public class ReportShow : System.Web.UI.Page
	{
		protected CrystalDecisions.Web.CrystalReportViewer CrystalReportViewer1;
		SalaryDetails.datereport rpt1 = new SalaryDetails.datereport();
		DataBase DB =new DataBase();
		public bool IsNumeric(string sVal)  //数字かどうか判断する
		{
			return System.Text.RegularExpressions.Regex.IsMatch(sVal, @"^[+-]?\d*[.]?\d*$");
		}
		private void Page_Load(object sender, System.EventArgs e)
		{
			//字段値継承
			string EmployeeCode="";
			string month="";
			string paydata="";
			string typeflug="";
			string EmployeeType="";
			string id="";
			string Affiliation = ConfigurationSettings.AppSettings.Get("Affiliation");
			string connectionString = ConfigurationSettings.AppSettings.Get("dbconn").ToString();
			//番号と名前と管理IDと会社CDを獲取します
			DataSet ds = new DataSet();
			string EmployeeManagementID = "";
			string EmployeeName = "";
			string CodeName = "";
			string CompanyCode = "";
			string str="";
			int flag=0;//10085476 20170214 update
            
			try
			{
				if(Request.QueryString["EmployeeCode"].ToString()!=null||Request.QueryString["EmployeeCode"].ToString()!="")
				{
					flag=0;
				}

			}
			catch
			{
                    flag=1;
			}
			
			flag=0;

			if(flag==0)
			{
//				month =Request.QueryString["month"].ToString();
//				paydata =Request.QueryString["paydata"].ToString();
//				typeflug =Request.QueryString["typeflug"].ToString();
//				EmployeeType =Request.QueryString["EmployeeType"].ToString();
//				EmployeeCode =Request.QueryString["EmployeeCode"].ToString();

				EmployeeType ="1";
				EmployeeCode ="2200167";
				month="11";
				paydata="2011/11";
				typeflug="1";


				string payyear = paydata+"/01";
				str="declare @EMID int ";
				str+="SELECT  mstEmployeeBasic.EmployeeManagementID,mstEmployeeBasic.EmployeeName";
				str+=" FROM  mstEmployeeBasic ";
				str+=" WHERE mstEmployeeBasic.EmployeeCode = "+EmployeeCode ;
				str+=" set @EMID = (SELECT  mstEmployeeBasic.EmployeeManagementID FROM  mstEmployeeBasic  WHERE mstEmployeeBasic.EmployeeCode = "+EmployeeCode+")";
				str+=" Select distinct CompanyCode From SalaryInformation Where  EmployeeManagementID=@EMID and PayYearMonth='"+payyear+"'";
				try
				{
					ds = DB.D_DataSet_Return(str,"dbconn");
					if(ds.Tables[0].Rows.Count!=0)
					{
						EmployeeManagementID = ds.Tables[0].Rows[0]["EmployeeManagementID"].ToString();
						EmployeeName = ds.Tables[0].Rows[0]["EmployeeName"].ToString();
						CodeName = EmployeeCode+"   "+EmployeeName;
						CompanyCode = ds.Tables[1].Rows[0]["CompanyCode"].ToString();
					}
					else
					{
						Page.RegisterStartupScript("wornnings","<script>alert(\'データベースに給与明細データがありません!\');</script>");
						return ;
					}
				}
				catch(Exception ex)
				{
					String strSourceName =ConfigurationSettings.AppSettings.Get("SourceName");
　				EventLog.WriteEntry(strSourceName , ex.Message.ToString(),EventLogEntryType.Error, 1, 1, null);
					Response.Write("<script>alert('給与明細データがありません!');</script>");
					CrystalReportViewer1.Visible = false;
					return ;	
				}


			}
		 else	if(flag==1)
			{
//				EmployeeCode =Request.QueryString["code"].ToString();
//				id =Request.QueryString["id"].ToString();
				EmployeeType ="1";
				EmployeeCode ="2200167";
				id="1";
		
				string PayYearMonth="";
				str="declare @EMID int ";
				str+="SELECT  mstEmployeeBasic.EmployeeManagementID,mstEmployeeBasic.EmployeeName";
				str+=" FROM  mstEmployeeBasic ";
				str+=" WHERE mstEmployeeBasic.EmployeeCode = "+EmployeeCode ;
				str+=" set @EMID = (SELECT  mstEmployeeBasic.EmployeeManagementID FROM  mstEmployeeBasic  WHERE mstEmployeeBasic.EmployeeCode = "+EmployeeCode+")";
				str+=" Select distinct CompanyCode,PayYearMonth,EmployeeType,SalaryType From SalaryInformation Where  EmployeeManagementID=@EMID and id= "+id ;
				try
			{
				ds = DB.D_DataSet_Return(str,"dbconn");
				if(ds.Tables[0].Rows.Count!=0&&ds.Tables[1].Rows.Count!=0)
			{
				EmployeeManagementID = ds.Tables[0].Rows[0]["EmployeeManagementID"].ToString();
				EmployeeName = ds.Tables[0].Rows[0]["EmployeeName"].ToString();
				CodeName = EmployeeCode+"   "+EmployeeName;
				CompanyCode = ds.Tables[1].Rows[0]["CompanyCode"].ToString();
				typeflug= ds.Tables[1].Rows[0]["SalaryType"].ToString();
				EmployeeType=ds.Tables[1].Rows[0]["EmployeeType"].ToString();
				PayYearMonth=ds.Tables[1].Rows[0]["PayYearMonth"].ToString();
				paydata=PayYearMonth.Substring(0,7);
				month=PayYearMonth.Substring(6,1);
								

			}
			else
		{
			Page.RegisterStartupScript("wornnings","<script>alert(\'URLは不正です!\');</script>");
			return ;
		}
		}
		catch(Exception ex)
		{
		String strSourceName =ConfigurationSettings.AppSettings.Get("SourceName");
　						EventLog.WriteEntry(strSourceName , ex.Message.ToString(),EventLogEntryType.Error, 1, 1, null);
		Response.Write("<script>alert('給与明細データがありません!');</script>");
		CrystalReportViewer1.Visible = false;
		return ;	
		}

						
					
	}

			
		
			int i ;
			int z ;
			int position;
			double num;
			string dotstr = "";
			SqlDataAdapter retss=new SqlDataAdapter();
			DataSet dss = new DataSet();
			//各個控件賦値
			str="";
			str="exec Salary_BaseInfoOut "+"'"+paydata+"','"+CompanyCode+"','"+EmployeeType+"','"+typeflug+"','"+EmployeeManagementID+"',"+Affiliation;
			try
			{	
				dss = DB.D_DataSet_Return(str,"dbconn");
			}			
			catch(Exception ex)
			{
　				String strSourceName =ConfigurationSettings.AppSettings.Get("SourceName");
　				EventLog.WriteEntry(strSourceName , ex.Message.ToString(),EventLogEntryType.Error, 1, 1, null);
				//Page.RegisterStartupScript("wornnings","<script>alert(\'給与明細データがありません!\');</script>");
				Response.Write("<script>alert('給与明細データがありません!');</script>");
				CrystalReportViewer1.Visible = false;
				return ;	
			}
			//2010/10/10 xupingping 20日締めについて　↓↓↓↓↓↓↓↓↓↓↓↓↓↓
			DateTime PayDate = new DateTime(Convert.ToInt16(paydata.Substring(0,4)),Convert.ToInt16(paydata.Substring(5,2)),1);
			DateTime NowDate = new DateTime(2011,1,1);
			//DateTime StartDate = new DateTime(2010,10,1);
			//int ComFlagStart = PayDate.CompareTo(StartDate);
			int ComFlag = PayDate.CompareTo(NowDate);
//			if(ComFlagStart == -1 )
//			{
//				((TextObject)rpt1.ReportDefinition.ReportObjects["remarks"]).Text = "";
//			}
//			else
//			{
//				if(ComFlag == -1)
//				{
//					if(EmployeeType == "1")
//					{
//						string valueShow = "10月1日～10月20日までの残業代は11月25日に、10月21日～11月20日までの残業代は12月25日支払いになります。";
//						((TextObject)rpt1.ReportDefinition.ReportObjects["remarks"]).Text = valueShow;
//					}
//					else
//					{
//						string valueShow = "10月1日～10月20日までの残業代は11月10日に、\n10月21日～11月20日までの残業代は12月10日支払いになります。";
//						((TextObject)rpt1.ReportDefinition.ReportObjects["remarks"]).Text = valueShow;
//					}
//				}
//				else
//				{
//					((TextObject)rpt1.ReportDefinition.ReportObjects["remarks"]).Text = "";
//				}
//			}
			DateTime StartDate = new DateTime(2016,3,1);
			int ComFlagStart = PayDate.CompareTo(StartDate);
			if(EmployeeType == "1"&&typeflug=="1"&&ComFlagStart>=0)
			{
				string valueShow = "確定拠出年金加入者は基本給からDC掛金を差し引いた分が給与として支給されます。";
				((TextObject)rpt1.ReportDefinition.ReportObjects["remarks"]).Text = valueShow;
			}
			else
			{
				((TextObject)rpt1.ReportDefinition.ReportObjects["remarks"]).Text = "";
			}
		
			//2010/10/10 xupingping 20日締めについて　↑↑↑↑↑↑↑↑↑↑↑↑↑↑


			try 
			{
				if (dss.Tables.Count!=0)
				{
					for(i=1,z=0;i<41;i++,z++)
					{//勤怠項目のbind
						((TextObject)rpt1.ReportDefinition.ReportObjects["qditem"+i]).Text = dss.Tables[0].Rows[0][z].ToString();
						dotstr = dss.Tables[1].Rows[0][z].ToString();
						if (dotstr != "" && IsNumeric(dotstr))
						{
							num = double.Parse(dotstr);
							dotstr = num.ToString("n");
						}
						if (dotstr!="0"&dotstr!="0.00")
						{
							((TextObject)rpt1.ReportDefinition.ReportObjects["qddtitem"+i]).Text = dotstr;
						}
						//支給項目のbind
						((TextObject)rpt1.ReportDefinition.ReportObjects["zjitem"+i]).Text = dss.Tables[2].Rows[0][z].ToString();
						dotstr = dss.Tables[3].Rows[0][z].ToString();
						if (dotstr != "" && IsNumeric(dotstr))
						{
							position=dotstr.IndexOf(".");   
							if   (position<0)
							{
								num = double.Parse(dotstr);
								dotstr = num.ToString("n0");
							}
							else 
							{
								num = double.Parse(dotstr);
								dotstr = num.ToString("n");
							}
						}
						if (dotstr!="0"&dotstr!="0.00")
						{
							((TextObject)rpt1.ReportDefinition.ReportObjects["zjdtitem"+i]).Text = dotstr ;
						}
						//控除項目のbind
						((TextObject)rpt1.ReportDefinition.ReportObjects["kxitem"+i]).Text = dss.Tables[4].Rows[0][z].ToString();
						dotstr = dss.Tables[5].Rows[0][z].ToString();
						if (dotstr != "" && IsNumeric(dotstr))
						{
							position=dotstr.IndexOf(".");   
							if   (position<0)
							{
								num = double.Parse(dotstr);
								dotstr = num.ToString("n0");
							}
							else 
							{
								num = double.Parse(dotstr);
								dotstr = num.ToString("n");
							}
						}
						if (dotstr!="0"&dotstr!="0.00")
						{
							((TextObject)rpt1.ReportDefinition.ReportObjects["kxdtitem"+i]).Text = dotstr ;
						}
					}
					for(i=1,z=0;i<11;i++,z++)
					{//差引支給項目のbind
						((TextObject)rpt1.ReportDefinition.ReportObjects["cyitem"+i]).Text = dss.Tables[6].Rows[0][z].ToString();
						dotstr = dss.Tables[7].Rows[0][z].ToString();
						if (dotstr != "" && IsNumeric(dotstr))
						{
							position=dotstr.IndexOf(".");   
							if   (position<0)
							{
								num = double.Parse(dotstr);
								dotstr = num.ToString("n0");
							}
							else 
							{
								num = double.Parse(dotstr);
								dotstr = num.ToString("n");
							}
						}
						if (dotstr!="0"&dotstr!="0.00")
						{
							((TextObject)rpt1.ReportDefinition.ReportObjects["cydtitem"+i]).Text = dotstr ;
						}
					}
					//累計項目名の表示----//朱国偉 2009/12/09 追加	
					if (dss.Tables[13].Rows.Count!=0)
					{
						for(i=1,z=0;i<5;i++,z++)
						{
							((TextObject)rpt1.ReportDefinition.ReportObjects["acitem"+i]).Text = dss.Tables[13].Rows[0][z].ToString();//朱国偉 2009/12/09 追加
						}
					}
					//累計の項目内容を抽出				
					if (dss.Tables[8].Rows.Count!=0)
					{
						for(i=1,z=0;i<5;i++,z++)
						{
							string havedotstr = dss.Tables[8].Rows[0][z].ToString();
							if (havedotstr != "" && IsNumeric(dotstr))
							{
								position=havedotstr.IndexOf(".");   
								if   (position<0)
								{
									num = double.Parse(havedotstr);
									havedotstr = num.ToString("n0");
								}
								else 
								{
									num = double.Parse(havedotstr);
									havedotstr = num.ToString("n");
								}
							}
							if (havedotstr!="0"&havedotstr!="0.00")
							{
								((TextObject)rpt1.ReportDefinition.ReportObjects["Gditem"+i]).Text = havedotstr;
							}
								
						}
					}
				}
			}
			catch(Exception ex)
			{
				Response.Write("<script>alert('給与明細データがありません!');</script>");
				String strSourceName =ConfigurationSettings.AppSettings.Get("SourceName");
　				EventLog.WriteEntry(strSourceName , ex.Message.ToString(),EventLogEntryType.Error, 1, 1, null);
				return;
			}
			try 
			{
					
				((TextObject)rpt1.ReportDefinition.ReportObjects["CpyName1"]).Text = dss.Tables[9].Rows[0][0].ToString();
				((TextObject)rpt1.ReportDefinition.ReportObjects["CpyName2"]).Text = dss.Tables[9].Rows[0][0].ToString();

				string[] year = paydata.Split(new char[]{'/'});

				if(typeflug == "1")//2007/12/20
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["STname1"]).Text = "給与支給明細書";
					((TextObject)rpt1.ReportDefinition.ReportObjects["STname2"]).Text = "給与支給明細書";
					((TextObject)rpt1.ReportDefinition.ReportObjects["JpTime"]).Text = dss.Tables[10].Rows[0][0].ToString();
					((TextObject)rpt1.ReportDefinition.ReportObjects["JpTimeleft"]).Text = dss.Tables[10].Rows[0][0].ToString();
				}
				else if (typeflug == "2")//2007/12/20
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["STname1"]).Text = "賞与支給明細書";
					((TextObject)rpt1.ReportDefinition.ReportObjects["STname2"]).Text = "賞与支給明細書";
					((TextObject)rpt1.ReportDefinition.ReportObjects["JpTime"]).Text = "賞与";
					((TextObject)rpt1.ReportDefinition.ReportObjects["JpTimeleft"]).Text = "賞与";

//					if(int.Parse(month) ==8)
//					{
//						((TextObject)rpt1.ReportDefinition.ReportObjects["JpTime"]).Text = "第1四半期賞与";
//						((TextObject)rpt1.ReportDefinition.ReportObjects["JpTimeleft"]).Text = "第1四半期賞与";
//					}
//					else if(int.Parse(month) >=6 & int.Parse(month) <=11)//2007/12/20
//					{
//						((TextObject)rpt1.ReportDefinition.ReportObjects["JpTime"]).Text = "夏季賞与";
//						((TextObject)rpt1.ReportDefinition.ReportObjects["JpTimeleft"]).Text = "夏季賞与";
//					}
//					/*10025763 201212 update
//					else if (dss.Tables[11].Rows[0][0].ToString().Substring(0,8) == "平成23年12月")
//					{
//						((TextObject)rpt1.ReportDefinition.ReportObjects["JpTime"]).Text = "冬季賞与";
//						((TextObject)rpt1.ReportDefinition.ReportObjects["JpTimeleft"]).Text = "冬季賞与";
//					}*/
//
//					else if (Convert.ToInt32(year[0]) >= 2011 && year[1] == "12")
//					{
//						((TextObject)rpt1.ReportDefinition.ReportObjects["JpTime"]).Text = "冬季賞与";
//						((TextObject)rpt1.ReportDefinition.ReportObjects["JpTimeleft"]).Text = "冬季賞与";
//					}
//					else      //2007/12/20
//					{
//						((TextObject)rpt1.ReportDefinition.ReportObjects["JpTime"]).Text = "決算賞与";
//						((TextObject)rpt1.ReportDefinition.ReportObjects["JpTimeleft"]).Text = "決算賞与";
//					}

				}
				((TextObject)rpt1.ReportDefinition.ReportObjects["JpDay"]).Text = dss.Tables[11].Rows[0][0].ToString();
				((TextObject)rpt1.ReportDefinition.ReportObjects["belong2"]).Text = dss.Tables[12].Rows[0][0].ToString();
				((TextObject)rpt1.ReportDefinition.ReportObjects["belong1"]).Text = dss.Tables[12].Rows[0][0].ToString();
				((TextObject)rpt1.ReportDefinition.ReportObjects["name1"]).Text = CodeName;
				((TextObject)rpt1.ReportDefinition.ReportObjects["name2"]).Text = CodeName;
				((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = dss.Tables[14].Rows[0][0].ToString();
				((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = dss.Tables[14].Rows[0][0].ToString();

				/*
				//2007/12/20
				if (CompanyCode=="1")//2007/12/20
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = "株式会社トライアルカンパニー";
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = "株式会社トライアルカンパニー";
				}
				if (CompanyCode=="2")//2009/06/23
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = "株式会社 TAS";
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = "株式会社 TAS";
				}
				if (CompanyCode=="4")//2009/09/18
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = "株式会社 カウボーイ";
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = "株式会社 カウボーイ";
				}
				else if (CompanyCode=="3")//2007/12/20
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = "株式会社 トライアル・ロジスティック・システム";
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = "株式会社 トライアル・ロジスティック・システム";
				}
				else if (CompanyCode=="5")//10004413 張玉剛 2011/04/05
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = "株式会社 トライアル・プラネット";
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = "株式会社 トライアル・プラネット";
				}
				else if (CompanyCode=="6")//10025763
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = "株式会社 ティー・ティー・エル";
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = "株式会社 ティー・ティー・エル";
				}
				else if (CompanyCode=="7")//10025763
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = "Trial　Retail　Engineering.　Inc.　日本支店";
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = "Trial　Retail　Engineering.　Inc.　日本支店";
				}
				else if (CompanyCode=="8")//10025763
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = "株式会社トライウェル";
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = "株式会社トライウェル";
				}
				else if (CompanyCode=="9")//10060815
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = "株式会社トライアルインベストメント";
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = "株式会社トライアルインベストメント";
				}
				else if (CompanyCode=="20")//2200424 20150410 add
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = "株式会社トライアルベーカリー";
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = "株式会社トライアルベーカリー";
				}
				else if (CompanyCode=="21")//2200424 20150410 add
				{
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt1"]).Text = "株式会社トライアル開発";
					((TextObject)rpt1.ReportDefinition.ReportObjects["eptxt2"]).Text = "株式会社トライアル開発";
				}
				*/



			}
			catch(Exception ex)
			{
				String strSourceName =ConfigurationSettings.AppSettings.Get("SourceName");
　				EventLog.WriteEntry(strSourceName , ex.Message.ToString(),EventLogEntryType.Error, 1, 1, null);
				Response.Write("<script>alert('給与明細データがありません!');</script>");
				CrystalReportViewer1.Visible = false;
				return ;	
			}
			
			//PDF格式顕示水晶報表
			try 
			{
				string temppath = EmployeeCode+ DateTime.Now.ToString("yyyyMMdd") + DateTime.Now.Hour + DateTime.Now.Minute + DateTime.Now.Second + ".pdf";  //形成するpdfファイルを命名する
				ExportOptions crExportOptions = new ExportOptions(); 
				DiskFileDestinationOptions crDiskFileDestinationOptions = new DiskFileDestinationOptions(); 
				crExportOptions = rpt1.ExportOptions ;       
				crExportOptions.ExportFormatType = ExportFormatType.PortableDocFormat ;
				crExportOptions.ExportDestinationType = ExportDestinationType.DiskFile;
				string OutputFilePath0 = Server.MapPath(Request.ApplicationPath)+"\\0"+temppath; //印刷できるpdfファイルのパス
				crDiskFileDestinationOptions.DiskFileName = OutputFilePath0;
				crExportOptions.DestinationOptions = crDiskFileDestinationOptions; 
				string OutputFilePath1 = Server.MapPath(Request.ApplicationPath)+"\\1"+temppath; //印刷できませんpdfファイルのパス
				rpt1.Export(); 
				PdfReader reader = new PdfReader(OutputFilePath0);     //pdfファイルコピーして暗号化する       
				Document document = new Document();
				Stream OutPut = File.Create(OutputFilePath1); 
				PdfCopy writer = new PdfCopy(document, OutPut);
				writer.SetEncryption(PdfWriter.STRENGTH40BITS, null, null, PdfWriter.AllowCopy); 
				document.Open();
				StringBuilder sb=new StringBuilder();
				document.NewPage();
				PdfImportedPage page1 = writer.GetImportedPage(reader, 1);
				writer.AddPage(page1);  
				document.Close();
				string GetPrintState = "SELECT SalaryPrintState FROM SalaryOutputType WHERE EmployeeManagementID = "+EmployeeManagementID;
				DataSet dsds = new DataSet();
				dsds = DB.D_DataSet_Return(GetPrintState,"dbconn");
				if (dsds.Tables[0].Rows.Count>0)
				{
					String PrintFlag =dsds.Tables[0].Rows[0][0].ToString();
					if (PrintFlag=="1")  //印刷できるかどうか判断する　1は印刷できる　0はできません
					{
						Response.Clear();    
						Response.ClearContent(); 
						Response.ClearHeaders (); 
						Response.ContentType ="application/pdf"; 
						Response.WriteFile(OutputFilePath0); 
					}
					else
					{
						Response.Clear();    
						Response.ClearContent(); 
						Response.ClearHeaders (); 
						Response.ContentType ="application/pdf"; 
						Response.WriteFile(OutputFilePath1); 
					}				
					
					Response.Flush(); 
					//Response.Close();
					File.Delete(OutputFilePath0); //pdfファイルを削除する
					File.Delete(OutputFilePath1); //pdfファイルを削除する
					Response.End();
				}
				else
				{
					Response.Write("<script>alert('印刷制限標識記録がありません');</script>");                    
				}
			}
			catch(Exception ex)
			{
				String strSourceName =ConfigurationSettings.AppSettings.Get("SourceName");
　				EventLog.WriteEntry(strSourceName , ex.Message.ToString(),EventLogEntryType.Error, 1, 1, null);
			}
		}

		#region Web フォーム デザイナで生成されたコード 
		override protected void OnInit(EventArgs e)
		{
			//
			// CODEGEN: この呼び出しは、ASP.NET Web フォーム デザイナで必要です。
			//
			InitializeComponent();
			base.OnInit(e);
		}
		
		/// <summary>
		/// デザイナ サポートに必要なメソッドです。このメソッドの内容を
		/// コード エディタで変更しないでください。
		/// </summary>
		private void InitializeComponent()
		{    
			this.Load += new System.EventHandler(this.Page_Load);

		}
		#endregion
	}
}
