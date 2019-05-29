using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using TcclMail.TcclApi;
using System.Configuration;
using System.Data.SqlClient;
using System.Collections;
using DBconnectionspace;

using System.IO;
using System.Reflection;



namespace TcclMail
{
    public partial class Form1 : Form
    {
        DBconnection member = new DBconnection();
        public Form1()
        {
            InitializeComponent();

        }

        public void SendMail()
        {
            try
            {
                
                TcclClient TC = new TcclClient();
                member.Open("dbkintai");
                string planCon = "EXEC NewTimeCard_EmployeeOverTimeLimitSendEmail";

                member.selectSql(planCon);
                DataSet myDataSet = member.ds;

                WriteLog(myDataSet.Tables.Count.ToString());//log

                for (int j = 0; j < myDataSet.Tables.Count; j++){
					
					string blockID = "0";
					string topicTypeID = "3";//作業指示
					//string topicCreaterCD = "99000109";
					string topicCreaterCD = "10113982";//songjiajun 
                    //string topicCreaterCD = "90001058";//
                    string topicTitle = "残業時間調整指示";
					string topicContent = "";
					string fileIDs = "";
					string receivers = "";
					//string doEndTime = DateTime.Now.AddDays(30).ToString("yyyy-MM-dd");
                    //string doEndTime = DateTime.Now.ToString("yyyy-MM-dd");
                    string doEndTime = "";
					string importanceID = "1";
					string isPush = "0";
					string isOnlyReceivers = "0";
					string tagID = "0";
					string _tagNM = "";
					//string systemName = "AsEmployeeUpdate";//dingmingguang
                    //string appKey = "1e85bfb42d296646db1a026da6950d02164f3444c58ed3b0a60c8e9dfe0c4eedce17f6e2b975187f5623bf72428f1da7be97f56c7ddfc6cfc3b819db9ac72a33";//dingmingguang

                    //string systemName = "overtimecheck";
                    //string appKey = "664b54dfb19c87926c56dd086ba68a7a15ca11511c252eb57fff22cc3f7d65993d4aed427bdabafa550a7028c04e4a912de6c34fe972e4d9130bfdaf22a968f3";//use for test

                    string systemName = "NewTimeCard_Entrance";
                    string appKey = "af51bc9cea7c384850c007ada22d54cd3a680b607b019d7bc1d9901d01017dec727c9faa14d1c256a715d2981686395f1d57f623c592b526895558fa12785820";

                    //string systemName = "Web_OsechiCakeOrder";//cuiweixia
                    //string appKey = "6869a849a9dd3f6e84a7c06c1eaf7c7803acd1bd34f7a912a37077d172406371d6001eddcb15b89b5594742f29449ca2b543508a6d46458271dca687c34a3001";//cuiweixia

					receivers = "E" + myDataSet.Tables[j].Rows[0]["EmployeeCD"].ToString();//一番目の上司を獲得する
                    //receivers = "E10113982";
					//string employeeCode = myDataSet.Tables[j].Rows[i]["EmployeeCode"].ToString();
					//string employeeName = myDataSet.Tables[j].Rows[i]["EmployeeName"].ToString();
					string OverTimeMessage = myDataSet.Tables[j].Rows[0]["OverTimeMessage"].ToString();//一番目のOverTimeMessageを獲得する
					string OverTimeMessageFlg = myDataSet.Tables[j].Rows[0]["OverTimeMessageFlg"].ToString();//一番目のOverTimeMessageFlgを獲得する
					if (OverTimeMessageFlg == "2")
					{
						topicContent = "<div style=\"color:red\">※特別条項 期限間近</div>";
                        topicContent += "<br/>";
					}
					else
					{
                        topicContent = "<div style=\"color:red\">※過重労働 調整指示</div>";
                        topicContent += "<br/>";
					}
					
                        topicContent += "<table style=\"padding-left:30px\">";
						topicContent += "<tr>";
						topicContent += "<td>社員CD</td>";
						topicContent += "<td>氏名</td>";						
						topicContent += "</tr>";
						
                    for (int i = 0; i < myDataSet.Tables[j].Rows.Count; i++)
                    {				
						topicContent += "<tr>";
						topicContent += "<td>" + myDataSet.Tables[j].Rows[i]["EmployeeCode"].ToString() + "</td>";
						topicContent += "<td>" + myDataSet.Tables[j].Rows[i]["EmployeeName"].ToString() + "</td>";
						topicContent += "</tr>";
                    }
											
						topicContent += "</table>";
                        topicContent += "<br/>";
						
                        topicContent += "<div>" + OverTimeMessage + "</div>";
					
					if (myDataSet.Tables[j].Rows.Count > 0){//データがあればメールします。


                            DateTime beforDT = System.DateTime.Now;
                            string str_mail = TC.AddOtherSystemTopicInfo(blockID, topicTypeID, topicCreaterCD, topicTitle, topicContent, fileIDs, receivers, doEndTime, importanceID, isPush, isOnlyReceivers, tagID, _tagNM, systemName, appKey);
                            DateTime afterDT = System.DateTime.Now;
                            TimeSpan ts = afterDT.Subtract(beforDT);
                            string myTime = ts.ToString();
                            WriteLog(myTime);
                            WriteLog(receivers.ToString());


						
					}
                }

                TC.Close();
            }
            catch (Exception ex)
            {
 
            }
            finally
            {
                member.Close();
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            SendMail();
            this.Close();
        }



        //20190522 10113982 add

        public void WriteLog(string msg)
        {
            string filePath = AppDomain.CurrentDomain.BaseDirectory + "Log";
            if (!Directory.Exists(filePath))
            {
                Directory.CreateDirectory(filePath);
            }
            string logPath = AppDomain.CurrentDomain.BaseDirectory + "Log\\" + DateTime.Now.ToString("yyyy-MM-dd") + ".txt";
            try
            {
                using (StreamWriter sw = File.AppendText(logPath))
                {
                    sw.WriteLine("Message：" + msg);
                    sw.WriteLine("Time：" + DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss.fff"));
                    sw.WriteLine("**************************************************");
                    sw.WriteLine();
                    sw.Flush();
                    sw.Close();
                    sw.Dispose();
                }
            }
            catch (IOException e)
            {
                using (StreamWriter sw = File.AppendText(logPath))
                {
                    sw.WriteLine("Exception：" + e.Message);
                    sw.WriteLine("Time：" + DateTime.Now.ToString("yyy-MM-dd HH:mm:ss"));
                    sw.WriteLine("**************************************************");
                    sw.WriteLine();
                    sw.Flush();
                    sw.Close();
                    sw.Dispose();
                }
            }
        }
        //20190522 10113982 add





    }


}
