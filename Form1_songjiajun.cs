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

                for (int i = 0; i < myDataSet.Tables[0].Rows.Count; i++)
                {
                    string blockID = "0";
                    string topicTypeID = "2";
                    //string topicCreaterCD = "99000109";
                    string topicCreaterCD = "10154231";
                    string topicTitle = "";
                    string topicContent = "";
                    string fileIDs = "";
                    string receivers = "";
                    string doEndTime = DateTime.Now.AddDays(30).ToString("yyyy-MM-dd");
                    string importanceID = "1";
                    string isPush = "0";
                    string isOnlyReceivers = "0";
                    string tagID = "0";
                    string _tagNM = "";
                    //string systemName = "AsEmployeeUpdate";
					string systemName = "dbkintai";
                    string appKey = "1e85bfb42d296646db1a026da6950d02164f3444c58ed3b0a60c8e9dfe0c4eedce17f6e2b975187f5623bf72428f1da7be97f56c7ddfc6cfc3b819db9ac72a33";
                    receivers = myDataSet.Tables[0].Rows[i]["receivers"].ToString();
					receivers = "E10113982"
                    employees = myDataSet.Tables[0].Rows[i]["employees"].ToString();
					message = myDataSet.Tables[0].Rows[i]["message"].ToString();
					OverTimeMessage = myDataSet.Tables[0].Rows[i]["OverTimeMessage"].ToString();
					if(OverTimeMessage=="2"){
						topicContent = "<div>※特別条項 期限間近</div>";
						topicContent += "<BR>";
					}else{
						topicContent = "<div>※過重労働 調整指示</div>";
						topicContent += "<BR>";
					}
					topicContent += "<div>"+employees+"</div>";
					topicContent += "<BR>";
                    topicContent += "<div>"+message+"</div>";

                    string str_mail = TC.AddOtherSystemTopicInfo(blockID, topicTypeID, topicCreaterCD, topicTitle, topicContent, fileIDs, receivers, doEndTime, importanceID, isPush, isOnlyReceivers, tagID, _tagNM, systemName, appKey);
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
        
       
    }

   
}
