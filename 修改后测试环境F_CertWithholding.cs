using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using DBconnectionspace;
using CrystalDecisions.CrystalReports.Engine;
using NewTimeCard.Class;

namespace NewTimeCard
{
    public partial class F_CertWithholding : Form
    {
        string str = "";
        NewTimeCard_Entrance.Report.F_CertWithholdingReport rpt = new NewTimeCard_Entrance.Report.F_CertWithholdingReport();//2015/09/22 ADD 10085270
        NewTimeCard_Entrance.Report.F_CertWithholdingReport2016 rpt2016 = new NewTimeCard_Entrance.Report.F_CertWithholdingReport2016();//20161220 add 10061820
        /// <summary>
        /// 初期画面
        /// </summary>
        public F_CertWithholding()
        {
            InitializeComponent();
        }

        /// <summary>
        /// 閉じる
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void cmdClose_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        /// <summary>
        /// comboboxを賦値
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void F_CertWithholding_Load(object sender, EventArgs e)
        {
            this.lbl_Name.Text = F_CertificateMenu.empCd + "  " + F_CertificateMenu.empName + "  さん";

            timer1.Enabled = true;

            str = "exec Taxwithholding_Get_YearList_Person " + F_CertificateMenu.empCd;
            DBconnection DB = new DBconnection();
            try
            {
                DB.Open("dbYearAjust_database");
                DB.selectSql(str);
                DataSet ds1 = DB.ds;


                if (ds1.Tables[0].Rows.Count != 0)//データがないとき
                {
                    this.btnPrint.Enabled = true;
                    selYearMonth.DataSource = ds1.Tables[0];
                    selYearMonth.DisplayMember = ds1.Tables[0].Columns[0].ColumnName;
                    selYearMonth.ValueMember = ds1.Tables[0].Columns[1].ColumnName;
                }
                else
                {
                    //MessageBox.Show("データがありません!");
                    return;
                }
                DB.Close();
            }
            catch//データベースに接続できない時
            {
                DB.Close();
                F_Main_Message FMM = new F_Main_Message();
                F_Main_Message.MeFlag = 9;
                FMM.ShowDialog();
                return;
            }	
        }


        /*------------------------10061820 20161219 update begin-----------------------------------*/
        /// <summary>
        /// 印刷
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnPrint_Click(object sender, EventArgs e)
        {
            #region 10061820  20161219 delete
            //System.Data.DataRowView dv = (System.Data.DataRowView)selYearMonth.SelectedItem;
            //string EmployeeType = dv["AdjustYear"].ToString();
            //InsertTaxPrintEmpInfo(" ", " ", " ", "0" + F_CertificateMenu.empCd, "1", " ");
            //InsertTaxPrintEmpInfo("1", F_CertificateMenu.empCd, "1", "0" + F_CertificateMenu.empCd, "0", EmployeeType);

            //CertHelperTools helperTools = new CertHelperTools();

            //try{

            //    DBconnection DB = new DBconnection();
            //    DB.Open("dbEmployee_database");
            //    str = "exec Cert_Get_PersonalYearAjust " + F_CertificateMenu.empCd + ",1," + F_CertificateMenu.empCd + ",2";
            //    DB.selectSql(str);
            //    DataSet ds = DB.ds;
            //    //crystalReportViewer1绑数据
            //    //↓↓↓↓↓↓　2015/09/22 10085270 劉宝山 ADD ↓↓↓↓↓↓
            //    if (ds == null || ds.Tables.Count != 2 || ds.Tables[0].Rows.Count == 0)
            //    {
            //        crystalReportViewer1.Visible = true;
            //        //MessageBox.Show("該当社員情報がありません");
            //        F_Main_Message FMM = new F_Main_Message();
            //        F_Main_Message.MeFlag = 10;
            //        FMM.ShowDialog();
            //        return;
            //    }

            //    if (!helperTools.getMaxNumbers("exec CertificatePrintHistoryNumber '001'"))
            //    {
            //        //MessageBox.Show("本日の証明書発行受付を終了いたしました。\nお手数かけますが、翌日再度発行を行ってください。");
            //        F_Main_Message FMM = new F_Main_Message();
            //        F_Main_Message.MeFlag = 35;
            //        FMM.ShowDialog();
            //        return;
            //    }
            //    else
            //    {
            //        string[] Inform = ds.Tables[1].Rows[0]["お知らせ内容"].ToString().Replace("\r\n", ",").Split(',');
            //        string JYear = ds.Tables[0].Rows[0]["対象年"].ToString();
            //        string JYearMonthDay = ds.Tables[0].Rows[0]["年月日"].ToString();
            //        //*************************左************************************

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["txtYear"]).Text = JYear;
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox130"]).Text = ds.Tables[0].Rows[0]["郵便番号"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox131"]).Text = ds.Tables[0].Rows[0]["住所"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox132"]).Text = ds.Tables[0].Rows[0]["受給者番号"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox133"]).Text = ds.Tables[0].Rows[0]["フリガナ"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox134"]).Text = ds.Tables[0].Rows[0]["役職名"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox155"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計課税総額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox156"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["所得控除後金額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["所得控除後金額1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["所得控除額合計"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["所得控除額合計1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引年税額"]));

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox1"]).Text = ds.Tables[0].Rows[0]["控除対象配偶者の有"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox2"]).Text = ds.Tables[0].Rows[0]["控除対象配偶者の無"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["Label73"]).Text = ds.Tables[0].Rows[0]["控除対象配偶者の老人"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox151"]).Text = ds.Tables[0].Rows[0]["配特別控除額"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox140"]).Text = ds.Tables[0].Rows[0]["扶養親族の数特定の人"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox141"]).Text = ds.Tables[0].Rows[0]["扶養親族の数老人の内"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox142"]).Text = ds.Tables[0].Rows[0]["扶養親族の数老人の人"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox143"]).Text = ds.Tables[0].Rows[0]["扶養親族の数その他の人"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox144"]).Text = ds.Tables[0].Rows[0]["障害者の数特定の内"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox145"]).Text = ds.Tables[0].Rows[0]["障害者の数特定の人"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox146"]).Text = ds.Tables[0].Rows[0]["障害者の数その他の人"].ToString();

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox208"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計社保控除額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["生命保険料の控除額1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計生保控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["地震険料の控除額1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計地震控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox150"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["住宅借入金等特別控除の額"]));

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox136"]).Text = ds.Tables[0].Rows[0]["摘要1"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox138"]).Text = ds.Tables[0].Rows[0]["摘要3"].ToString();

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox22"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配偶者の合計所得"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["新生命保険料1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["新生命保険料"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["旧生命保険料1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["旧生命保険料"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["介護医療保険料1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["介護医療保険料"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["新個人年金保険料"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["新個人年金保険料"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox24"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["個人年金保険料の金額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox139"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["旧長期損害保険の金額"]));

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["年少扶養親族"]).Text = ds.Tables[0].Rows[0]["年少扶養親族"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox42"]).Text = ds.Tables[0].Rows[0]["未成年者"].ToString();
            //        //外国人　無し
            //        //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox50"]).Text = ds.Tables[0].Rows[0][""].ToString();
            //        //死亡退職 無し
            //        //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox49"]).Text = ds.Tables[0].Rows[0][""].ToString();
            //        //災害者 無し
            //        //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox48"]).Text = ds.Tables[0].Rows[0][""].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox43"]).Text = ds.Tables[0].Rows[0]["乙欄"].ToString();

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox44"]).Text = ds.Tables[0].Rows[0]["本人が障害者の特別"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox63"]).Text = ds.Tables[0].Rows[0]["本人が障害者のその他"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox45"]).Text = ds.Tables[0].Rows[0]["寡婦の一般"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox64"]).Text = ds.Tables[0].Rows[0]["寡婦の特別"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox46"]).Text = ds.Tables[0].Rows[0]["寡夫"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox47"]).Text = ds.Tables[0].Rows[0]["勤労学生"].ToString();

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox51"]).Text = ds.Tables[0].Rows[0]["就職"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox52"]).Text = ds.Tables[0].Rows[0]["退職"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox53"]).Text = ds.Tables[0].Rows[0]["中途の年"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox54"]).Text = ds.Tables[0].Rows[0]["中途の月"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox55"]).Text = ds.Tables[0].Rows[0]["中途の日"].ToString();

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox56"]).Text = ds.Tables[0].Rows[0]["受給者生年明"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox57"]).Text = ds.Tables[0].Rows[0]["受給者生年大"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox58"]).Text = ds.Tables[0].Rows[0]["受給者生年昭"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox59"]).Text = ds.Tables[0].Rows[0]["受給者生年平"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox60"]).Text = ds.Tables[0].Rows[0]["生年の年"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox61"]).Text = ds.Tables[0].Rows[0]["生年の月"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox62"]).Text = ds.Tables[0].Rows[0]["生年の日"].ToString();

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["会社郵便番号1"]).Text = ds.Tables[0].Rows[0]["会社郵便番号"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox154"]).Text = ds.Tables[0].Rows[0]["会社所在地"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox152"]).Text = ds.Tables[0].Rows[0]["会社名"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox153"]).Text = ds.Tables[0].Rows[0]["会社電話番号"].ToString();

            //        for (int i = 1; i < 19; i++)
            //        {
            //            ((TextObject)rpt.ReportDefinition.ReportObjects["txtInform" + i]).Text = Inform[i - 1];
            //        }
            //        //**************************右**********************************

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["YearMonth"]).Text = JYear;
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["txtYearMonthDay"]).Text = JYearMonthDay;

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox161"]).Text = ds.Tables[0].Rows[0]["部門"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox162"]).Text = ds.Tables[0].Rows[0]["事務所"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox163"]).Text = ds.Tables[0].Rows[0]["受給者番号"].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox164"]).Text = ds.Tables[0].Rows[0]["役職名"].ToString();

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox168"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計課税総額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox169"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["年調給与額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox170"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["所得控除後金額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox171"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計社保控除額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox172"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["申社保年金分"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox173"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["小規模企業共済"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox174"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計生保控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox175"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計地震控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox176"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配特別控除額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox177"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["基礎控除等合計"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox178"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["所得控除額合計"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox179"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引課税所得額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox180"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["年税額"]));

            //        //特減税還付額
            //        //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox181"]).Text = ds.Tables[0].Rows[0][""].ToString();
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox182"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["住宅特別控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox191"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引年税額1"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox192"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計徴収済税額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox193"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引過不足"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox194"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引超過額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox195"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引不足額"]));

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox183"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["基礎控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox184"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人障害控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox185"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人特障控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox186"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人老年控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox187"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人寡婦控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox188"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人特別寡婦"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox189"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人寡夫控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox190"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人勤労学生"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox196"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配偶者控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox197"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配偶者老控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox198"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["一般扶養控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox199"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["特定扶養控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox200"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["同居老親等控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox201"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["同居老親等以外"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox202"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["障害者控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox203"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["特障害者控除"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox204"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["同居特障控除"]));

            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox205"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引過不足"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox206"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引超過額"]));
            //        ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox207"]).Text = String.Format("{0:n0}", (Convert.ToInt32(ds.Tables[0].Rows[0]["差引過不足"]) - Convert.ToInt32(ds.Tables[0].Rows[0]["差引超過額"])));

            //        this.crystalReportViewer1.ReportSource = rpt;

            //        //テスト
            //        //rpt.PrintToPrinter(0, true, 0, 0);


            //        IniFileRead cIni = new IniFileRead();//printer code
            //        string Printer = cIni.IniRead("Loppitxt", "Printer");
            //        rpt.PrintOptions.PrinterName = Printer;
            //        rpt.PrintToPrinter(1, true, 0, 0);

            //        str = "exec CertificatePrintHistorySave "  // save print history
            //               + F_CertificateMenu.empCd + ", '" + F_CertificateMenu.empName + "', '001', '源泉徴収票'";
            //        DB.DBoperation(str);

            //        //↑↑↑↑↑↑　2015/09/22 10085270 劉宝山 ADD ↑↑↑↑↑↑↑
            //        DB.Close();
            //        //MessageBox.Show("源泉徴収票が印刷しました。");
            //        F_Main_Message FMM = new F_Main_Message();
            //        F_Main_Message.MeFlag = 34;
            //        FMM.ShowDialog();
            //        if (FMM.DialogResult == DialogResult.OK)
            //        {
            //            this.DialogResult = DialogResult.OK;
            //            this.Close();
            //        }
            //    }

            //}
            //catch (Exception ex) 
            //{
            //    this.crystalReportViewer1.Visible = false;
            //    //MessageBox.Show(ex.Message);
            //    return;
            //}
            #endregion

            System.Data.DataRowView dv = (System.Data.DataRowView)selYearMonth.SelectedItem;
            string EmployeeType = dv["AdjustYear"].ToString();
            if (Convert.ToInt32(EmployeeType) >= 2016)
            {
                report2016();
            }
            else
            {
                report();
            }
        }

        public void report2016()
        {
            System.Data.DataRowView dv = (System.Data.DataRowView)selYearMonth.SelectedItem;
            string EmployeeType = dv["AdjustYear"].ToString();
            InsertTaxPrintEmpInfo(" ", " ", " ", "0" + F_CertificateMenu.empCd, "1", " ");
            InsertTaxPrintEmpInfo("1", F_CertificateMenu.empCd, "1", "0" + F_CertificateMenu.empCd, "0", EmployeeType);

            CertHelperTools helperTools = new CertHelperTools();

            try
            {

                DBconnection DB = new DBconnection();
                DB.Open("dbEmployee_database");
                str = "exec dbYearAjust.dbo.Taxwithholding_Get_PersonalYearAjust_ver2016 " + F_CertificateMenu.empCd + ",1," + F_CertificateMenu.empCd + ",2";
                DB.selectSql(str);
                DataSet ds = DB.ds;

                if (ds == null || ds.Tables.Count != 1 || ds.Tables[0].Rows.Count == 0)
                {
                    crystalReportViewer1.Visible = true;
                    F_Main_Message FMM = new F_Main_Message();
                    F_Main_Message.MeFlag = 10;
                    FMM.ShowDialog();
                    return;
                }

                if (!helperTools.getMaxNumbers("exec CertificatePrintHistoryNumber '001'"))
                {
                    //MessageBox.Show("本日の証明書発行受付を終了いたしました。\nお手数かけますが、翌日再度発行を行ってください。");
                    F_Main_Message FMM = new F_Main_Message();
                    F_Main_Message.MeFlag = 35;
                    FMM.ShowDialog();
                    return;
                }
                else
                {
                    string JYear = ds.Tables[0].Rows[0]["対象年"].ToString();
                    string JYearMonthDay = ds.Tables[0].Rows[0]["年月日"].ToString();


                    //*************************左************************************
                    #region
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["txtYear"]).Text = JYear;
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox130"]).Text = ds.Tables[0].Rows[0]["郵便番号"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox131"]).Text = ds.Tables[0].Rows[0]["住所"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox132"]).Text = ds.Tables[0].Rows[0]["受給者番号"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox133"]).Text = ds.Tables[0].Rows[0]["フリガナ"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox134"]).Text = ds.Tables[0].Rows[0]["役職名"].ToString();

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text24"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["合計課税総額百万"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text39"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["合計課税総額千"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox155"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["合計課税総額1"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text41"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["所得控除後金額百万"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text43"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["所得控除後金額千"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox156"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["所得控除後金額1"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text83"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["所得控除額合計百万"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text87"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["所得控除額合計千"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["所得控除後金額1"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["所得控除額合計1"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text88"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["差引年税額百万"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text89"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["差引年税額千"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["所得控除額合計1"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["差引年税額1"]);

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox1"]).Text = ds.Tables[0].Rows[0]["控除対象配偶者の有"].ToString();
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox2"]).Text = ds.Tables[0].Rows[0]["控除対象配偶者の無"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Label73"]).Text = ds.Tables[0].Rows[0]["控除対象配偶者の老人"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text116"]).Text = ds.Tables[0].Rows[0]["配特別控除額千"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox151"]).Text = ds.Tables[0].Rows[0]["配特別控除額1"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox140"]).Text = ds.Tables[0].Rows[0]["扶養親族の数特定の人"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox141"]).Text = ds.Tables[0].Rows[0]["扶養親族の数老人の内"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox142"]).Text = ds.Tables[0].Rows[0]["扶養親族の数老人の人"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox143"]).Text = ds.Tables[0].Rows[0]["扶養親族の数その他の人"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["年少扶養親族"]).Text = ds.Tables[0].Rows[0]["年少扶養親族"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox144"]).Text = ds.Tables[0].Rows[0]["障害者の数特定の内"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox145"]).Text = ds.Tables[0].Rows[0]["障害者の数特定の人"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox146"]).Text = ds.Tables[0].Rows[0]["障害者の数その他の人"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text121"]).Text = ds.Tables[0].Rows[0]["非居住者親族数"].ToString();

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text290"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["小規模企業共済千"]);
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text2"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["小規模企業共済1"]);

                    if (Convert.ToString(ds.Tables[0].Rows[0]["小規模企業共済千"]) != "")
                    {
                        ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text290"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["小規模企業共済千"]));
                    }
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text2"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["小規模企業共済1"]);

                    if (Convert.ToString(ds.Tables[0].Rows[0]["合計社保控除額千"]) != "")
                    {
                        ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text122"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計社保控除額千"]));
                    }
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox208"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["合計社保控除額1"]);

                    if (Convert.ToString(ds.Tables[0].Rows[0]["合計生保控除千"]) != "")
                    {
                        ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text123"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計生保控除千"]));
                    }
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["生命保険料の控除額1"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["合計生保控除1"]);

                    if (Convert.ToString(ds.Tables[0].Rows[0]["合計地震控除千"]) != "")
                    {
                        ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text229"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計地震控除千"]));
                    }
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["地震険料の控除額1"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["合計地震控除1"]);

                    if (Convert.ToString(ds.Tables[0].Rows[0]["住宅借入金等特別控除の額千"]) != "")
                    {
                        ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text230"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["住宅借入金等特別控除の額千"]));
                    }
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox150"]).Text = Convert.ToString(ds.Tables[0].Rows[0]["住宅借入金等特別控除の額1"]);

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text231"]).Text = ds.Tables[0].Rows[0]["摘要3"].ToString();

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text237"]).Text = ds.Tables[0].Rows[0]["特別控除適用数"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text244"]).Text = ds.Tables[0].Rows[0]["居住開始年1"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text246"]).Text = ds.Tables[0].Rows[0]["居住開始月1"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text248"]).Text = ds.Tables[0].Rows[0]["居住開始日1"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text254"]).Text = ds.Tables[0].Rows[0]["特別控除区分1回目"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text252"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["年末残高1回目"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text238"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["特別控除可能額"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text245"]).Text = ds.Tables[0].Rows[0]["居住開始年2"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text247"]).Text = ds.Tables[0].Rows[0]["居住開始月2"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text249"]).Text = ds.Tables[0].Rows[0]["居住開始日2"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text255"]).Text = ds.Tables[0].Rows[0]["特別控除区分2回目"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text253"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["年末残高2回目"]));

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["新生命保険料1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["新生命保険料"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["旧生命保険料1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["旧生命保険料"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["介護医療保険料1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["介護医療保険料"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["新個人年金保険料"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["新個人年金保険料"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox24"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["個人年金保険料の金額"]));

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox22"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配偶者の合計所得"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox139"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["旧長期損害保険の金額"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text232"]).Text = ds.Tables[0].Rows[0]["摘要1"].ToString();//国民年金保険料等の金額

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text256"]).Text = ds.Tables[0].Rows[0]["扶養名カナA"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text257"]).Text = ds.Tables[0].Rows[0]["扶養名A"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text258"]).Text = ds.Tables[0].Rows[0]["扶養名カナB1"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text259"]).Text = ds.Tables[0].Rows[0]["扶養名カナB2"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text260"]).Text = ds.Tables[0].Rows[0]["扶養名カナB3"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text261"]).Text = ds.Tables[0].Rows[0]["扶養名カナB4"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text262"]).Text = ds.Tables[0].Rows[0]["扶養名カナM1"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text263"]).Text = ds.Tables[0].Rows[0]["扶養名カナM2"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text264"]).Text = ds.Tables[0].Rows[0]["扶養名カナM3"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text265"]).Text = ds.Tables[0].Rows[0]["扶養名カナM4"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text266"]).Text = ds.Tables[0].Rows[0]["扶養名B1"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text267"]).Text = ds.Tables[0].Rows[0]["扶養名B2"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text268"]).Text = ds.Tables[0].Rows[0]["扶養名B3"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text269"]).Text = ds.Tables[0].Rows[0]["扶養名B4"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text270"]).Text = ds.Tables[0].Rows[0]["扶養名M1"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text271"]).Text = ds.Tables[0].Rows[0]["扶養名M2"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text272"]).Text = ds.Tables[0].Rows[0]["扶養名M3"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text273"]).Text = ds.Tables[0].Rows[0]["扶養名M4"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text274"]).Text = ds.Tables[0].Rows[0]["扶養区分A"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text275"]).Text = ds.Tables[0].Rows[0]["扶養区分B1"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text276"]).Text = ds.Tables[0].Rows[0]["扶養区分B2"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text277"]).Text = ds.Tables[0].Rows[0]["扶養区分B3"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text278"]).Text = ds.Tables[0].Rows[0]["扶養区分B4"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text279"]).Text = ds.Tables[0].Rows[0]["扶養区分M1"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text280"]).Text = ds.Tables[0].Rows[0]["扶養区分M2"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text281"]).Text = ds.Tables[0].Rows[0]["扶養区分M3"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["Text282"]).Text = ds.Tables[0].Rows[0]["扶養区分M4"].ToString();
                                 
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox42"]).Text = ds.Tables[0].Rows[0]["未成年者"].ToString();
                    //外国人　無し  
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox50"]).Text = ds.Tables[0].Rows[0][""].ToString();
                    //死亡退職 無し 
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox49"]).Text = ds.Tables[0].Rows[0][""].ToString();
                    //災害者 無し
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox48"]).Text = ds.Tables[0].Rows[0][""].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox42"]).Text = ds.Tables[0].Rows[0]["未成年者"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox43"]).Text = ds.Tables[0].Rows[0]["乙欄"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox44"]).Text = ds.Tables[0].Rows[0]["本人が障害者の特別"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox63"]).Text = ds.Tables[0].Rows[0]["本人が障害者のその他"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox45"]).Text = ds.Tables[0].Rows[0]["寡婦の一般"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox64"]).Text = ds.Tables[0].Rows[0]["寡婦の特別"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox46"]).Text = ds.Tables[0].Rows[0]["寡夫"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox47"]).Text = ds.Tables[0].Rows[0]["勤労学生"].ToString();

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox51"]).Text = ds.Tables[0].Rows[0]["就職"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox52"]).Text = ds.Tables[0].Rows[0]["退職"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox53"]).Text = ds.Tables[0].Rows[0]["中途の年"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox54"]).Text = ds.Tables[0].Rows[0]["中途の月"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox55"]).Text = ds.Tables[0].Rows[0]["中途の日"].ToString();
                                    
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox56"]).Text = ds.Tables[0].Rows[0]["受給者生年明"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox57"]).Text = ds.Tables[0].Rows[0]["受給者生年大"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox58"]).Text = ds.Tables[0].Rows[0]["受給者生年昭"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox59"]).Text = ds.Tables[0].Rows[0]["受給者生年平"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox60"]).Text = ds.Tables[0].Rows[0]["生年の年"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox61"]).Text = ds.Tables[0].Rows[0]["生年の月"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox62"]).Text = ds.Tables[0].Rows[0]["生年の日"].ToString();
                                    
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["会社郵便番号1"]).Text = ds.Tables[0].Rows[0]["会社郵便番号"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox154"]).Text = ds.Tables[0].Rows[0]["会社所在地"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox152"]).Text = ds.Tables[0].Rows[0]["会社名"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox153"]).Text = ds.Tables[0].Rows[0]["会社電話番号"].ToString();

                    #endregion
                    //**************************右**********************************

                    #region 年調支給明細書
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["YearMonth"]).Text = JYear;
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["txtYearMonthDay"]).Text = JYearMonthDay;

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox161"]).Text = ds.Tables[0].Rows[0]["部門"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox162"]).Text = ds.Tables[0].Rows[0]["事務所"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox163"]).Text = ds.Tables[0].Rows[0]["受給者番号"].ToString();
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox164"]).Text = ds.Tables[0].Rows[0]["役職名"].ToString();

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox168"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計課税総額"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox169"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["年調給与額"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox170"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["所得控除後金額"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox171"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計社保控除額"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox172"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["申社保年金分"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox173"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["小規模企業共済"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox174"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計生保控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox175"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計地震控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox176"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配特別控除額"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox177"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["基礎控除等合計"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox178"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["所得控除額合計"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox179"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引課税所得額"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox180"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["年税額"]));


                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox182"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["住宅特別控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox191"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引年税額11"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox192"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計徴収済税額"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox193"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引過不足"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox194"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引超過額"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox195"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引不足額"]));

                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox183"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["基礎控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox184"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人障害控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox185"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人特障控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox186"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人老年控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox187"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人寡婦控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox188"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人特別寡婦"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox189"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人寡夫控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox190"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人勤労学生"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox196"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配偶者控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox197"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配偶者老控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox198"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["一般扶養控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox199"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["特定扶養控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox200"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["同居老親等控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox201"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["同居老親等以外"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox202"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["障害者控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox203"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["特障害者控除"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox204"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["同居特障控除"]));
                                    
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox205"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引過不足"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox206"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引超過額"]));
                    ((TextObject)rpt2016.ReportDefinition.ReportObjects["TextBox207"]).Text = String.Format("{0:n0}", (Convert.ToInt32(ds.Tables[0].Rows[0]["差引過不足"]) - Convert.ToInt32(ds.Tables[0].Rows[0]["差引超過額"])));
                    #endregion

                    this.crystalReportViewer1.ReportSource = rpt2016;
                    IniFileRead cIni = new IniFileRead();//printer code
                    string Printer = cIni.IniRead("Loppitxt", "Printer");
                    rpt2016.PrintOptions.PrinterName = Printer;
                    rpt2016.PrintToPrinter(1, true, 0, 0);

                    str = "exec CertificatePrintHistorySave "  // save print history
                           + F_CertificateMenu.empCd + ", '" + F_CertificateMenu.empName + "', '001', '源泉徴収票'";
                    DB.DBoperation(str);

                    DB.Close();
  
                    F_Main_Message FMM = new F_Main_Message();
                    F_Main_Message.MeFlag = 34;
                    FMM.ShowDialog();
                    if (FMM.DialogResult == DialogResult.OK)
                    {
                        this.DialogResult = DialogResult.OK;
                        this.Close();
                    }
                }

            }
            catch (Exception ex)
            {
                this.crystalReportViewer1.Visible = false;
                //MessageBox.Show(ex.Message);
                return;
            }

        }

        public void report()
        {
            System.Data.DataRowView dv = (System.Data.DataRowView)selYearMonth.SelectedItem;
            string EmployeeType = dv["AdjustYear"].ToString();
            InsertTaxPrintEmpInfo(" ", " ", " ", "0" + F_CertificateMenu.empCd, "1", " ");
            InsertTaxPrintEmpInfo("1", F_CertificateMenu.empCd, "1", "0" + F_CertificateMenu.empCd, "0", EmployeeType);

            CertHelperTools helperTools = new CertHelperTools();

            try
            {

                DBconnection DB = new DBconnection();
                DB.Open("dbEmployee_database");
                str = "exec Cert_Get_PersonalYearAjust " + F_CertificateMenu.empCd + ",1," + F_CertificateMenu.empCd + ",2";
                DB.selectSql(str);
                DataSet ds = DB.ds;
                //crystalReportViewer1绑数据
                //↓↓↓↓↓↓　2015/09/22 10085270 劉宝山 ADD ↓↓↓↓↓↓
                if (ds == null || ds.Tables.Count != 2 || ds.Tables[0].Rows.Count == 0)
                {
                    crystalReportViewer1.Visible = true;
                    //MessageBox.Show("該当社員情報がありません");
                    F_Main_Message FMM = new F_Main_Message();
                    F_Main_Message.MeFlag = 10;
                    FMM.ShowDialog();
                    return;
                }

                if (!helperTools.getMaxNumbers("exec CertificatePrintHistoryNumber '001'"))
                {
                    //MessageBox.Show("本日の証明書発行受付を終了いたしました。\nお手数かけますが、翌日再度発行を行ってください。");
                    F_Main_Message FMM = new F_Main_Message();
                    F_Main_Message.MeFlag = 35;
                    FMM.ShowDialog();
                    return;
                }
                else
                {
                    string[] Inform = ds.Tables[1].Rows[0]["お知らせ内容"].ToString().Replace("\r\n", ",").Split(',');
                    string JYear = ds.Tables[0].Rows[0]["対象年"].ToString();
                    string JYearMonthDay = ds.Tables[0].Rows[0]["年月日"].ToString();
                    //*************************左************************************

                    ((TextObject)rpt.ReportDefinition.ReportObjects["txtYear"]).Text = JYear;
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox130"]).Text = ds.Tables[0].Rows[0]["郵便番号"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox131"]).Text = ds.Tables[0].Rows[0]["住所"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox132"]).Text = ds.Tables[0].Rows[0]["受給者番号"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox133"]).Text = ds.Tables[0].Rows[0]["フリガナ"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox134"]).Text = ds.Tables[0].Rows[0]["役職名"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox155"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計課税総額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox156"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["所得控除後金額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["所得控除後金額1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["所得控除額合計"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["所得控除額合計1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引年税額"]));

                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox1"]).Text = ds.Tables[0].Rows[0]["控除対象配偶者の有"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox2"]).Text = ds.Tables[0].Rows[0]["控除対象配偶者の無"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["Label73"]).Text = ds.Tables[0].Rows[0]["控除対象配偶者の老人"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox151"]).Text = ds.Tables[0].Rows[0]["配特別控除額"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox140"]).Text = ds.Tables[0].Rows[0]["扶養親族の数特定の人"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox141"]).Text = ds.Tables[0].Rows[0]["扶養親族の数老人の内"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox142"]).Text = ds.Tables[0].Rows[0]["扶養親族の数老人の人"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox143"]).Text = ds.Tables[0].Rows[0]["扶養親族の数その他の人"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox144"]).Text = ds.Tables[0].Rows[0]["障害者の数特定の内"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox145"]).Text = ds.Tables[0].Rows[0]["障害者の数特定の人"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox146"]).Text = ds.Tables[0].Rows[0]["障害者の数その他の人"].ToString();

                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox208"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計社保控除額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["生命保険料の控除額1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計生保控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["地震険料の控除額1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計地震控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox150"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["住宅借入金等特別控除の額"]));

                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox136"]).Text = ds.Tables[0].Rows[0]["摘要1"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox138"]).Text = ds.Tables[0].Rows[0]["摘要3"].ToString();

                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox22"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配偶者の合計所得"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["新生命保険料1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["新生命保険料"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["旧生命保険料1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["旧生命保険料"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["介護医療保険料1"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["介護医療保険料"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["新個人年金保険料"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["新個人年金保険料"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox24"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["個人年金保険料の金額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox139"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["旧長期損害保険の金額"]));

                    ((TextObject)rpt.ReportDefinition.ReportObjects["年少扶養親族"]).Text = ds.Tables[0].Rows[0]["年少扶養親族"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox42"]).Text = ds.Tables[0].Rows[0]["未成年者"].ToString();
                    //外国人　無し
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox50"]).Text = ds.Tables[0].Rows[0][""].ToString();
                    //死亡退職 無し
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox49"]).Text = ds.Tables[0].Rows[0][""].ToString();
                    //災害者 無し
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox48"]).Text = ds.Tables[0].Rows[0][""].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox43"]).Text = ds.Tables[0].Rows[0]["乙欄"].ToString();

                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox44"]).Text = ds.Tables[0].Rows[0]["本人が障害者の特別"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox63"]).Text = ds.Tables[0].Rows[0]["本人が障害者のその他"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox45"]).Text = ds.Tables[0].Rows[0]["寡婦の一般"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox64"]).Text = ds.Tables[0].Rows[0]["寡婦の特別"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox46"]).Text = ds.Tables[0].Rows[0]["寡夫"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox47"]).Text = ds.Tables[0].Rows[0]["勤労学生"].ToString();

                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox51"]).Text = ds.Tables[0].Rows[0]["就職"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox52"]).Text = ds.Tables[0].Rows[0]["退職"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox53"]).Text = ds.Tables[0].Rows[0]["中途の年"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox54"]).Text = ds.Tables[0].Rows[0]["中途の月"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox55"]).Text = ds.Tables[0].Rows[0]["中途の日"].ToString();

                    //2019/04/19 10113982 宋家軍 抹消 begin
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox56"]).Text = ds.Tables[0].Rows[0]["受給者生年明"].ToString();
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox57"]).Text = ds.Tables[0].Rows[0]["受給者生年大"].ToString();
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox58"]).Text = ds.Tables[0].Rows[0]["受給者生年昭"].ToString();
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox59"]).Text = ds.Tables[0].Rows[0]["受給者生年平"].ToString();
                    //2019/04/19 10113982 宋家軍 抹消 end


                    //2019/04/19 10113982 宋家軍 増加 begin
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox56"]).Text = ds.Tables[0].Rows[0]["受給者生年大"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox57"]).Text = ds.Tables[0].Rows[0]["受給者生年昭"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox58"]).Text = ds.Tables[0].Rows[0]["受給者生年平"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox59"]).Text = ds.Tables[0].Rows[0]["受給者生年令"].ToString();
                    //2019/04/19 10113982 宋家軍 増加 end

                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox60"]).Text = ds.Tables[0].Rows[0]["生年の年"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox61"]).Text = ds.Tables[0].Rows[0]["生年の月"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox62"]).Text = ds.Tables[0].Rows[0]["生年の日"].ToString();

                    ((TextObject)rpt.ReportDefinition.ReportObjects["会社郵便番号1"]).Text = ds.Tables[0].Rows[0]["会社郵便番号"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox154"]).Text = ds.Tables[0].Rows[0]["会社所在地"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox152"]).Text = ds.Tables[0].Rows[0]["会社名"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox153"]).Text = ds.Tables[0].Rows[0]["会社電話番号"].ToString();

                    for (int i = 1; i < 19; i++)
                    {
                        ((TextObject)rpt.ReportDefinition.ReportObjects["txtInform" + i]).Text = Inform[i - 1];
                    }
                    //**************************右**********************************

                    ((TextObject)rpt.ReportDefinition.ReportObjects["YearMonth"]).Text = JYear;
                    ((TextObject)rpt.ReportDefinition.ReportObjects["txtYearMonthDay"]).Text = JYearMonthDay;

                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox161"]).Text = ds.Tables[0].Rows[0]["部門"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox162"]).Text = ds.Tables[0].Rows[0]["事務所"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox163"]).Text = ds.Tables[0].Rows[0]["受給者番号"].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox164"]).Text = ds.Tables[0].Rows[0]["役職名"].ToString();

                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox168"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計課税総額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox169"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["年調給与額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox170"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["所得控除後金額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox171"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計社保控除額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox172"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["申社保年金分"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox173"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["小規模企業共済"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox174"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計生保控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox175"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計地震控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox176"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配特別控除額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox177"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["基礎控除等合計"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox178"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["所得控除額合計"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox179"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引課税所得額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox180"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["年税額"]));

                    //特減税還付額
                    //((TextObject)rpt.ReportDefinition.ReportObjects["TextBox181"]).Text = ds.Tables[0].Rows[0][""].ToString();
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox182"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["住宅特別控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox191"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引年税額1"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox192"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["合計徴収済税額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox193"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引過不足"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox194"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引超過額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox195"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引不足額"]));

                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox183"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["基礎控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox184"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人障害控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox185"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人特障控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox186"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人老年控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox187"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人寡婦控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox188"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人特別寡婦"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox189"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人寡夫控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox190"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["本人勤労学生"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox196"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配偶者控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox197"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["配偶者老控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox198"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["一般扶養控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox199"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["特定扶養控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox200"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["同居老親等控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox201"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["同居老親等以外"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox202"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["障害者控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox203"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["特障害者控除"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox204"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["同居特障控除"]));

                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox205"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引過不足"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox206"]).Text = String.Format("{0:n0}", Convert.ToInt32(ds.Tables[0].Rows[0]["差引超過額"]));
                    ((TextObject)rpt.ReportDefinition.ReportObjects["TextBox207"]).Text = String.Format("{0:n0}", (Convert.ToInt32(ds.Tables[0].Rows[0]["差引過不足"]) - Convert.ToInt32(ds.Tables[0].Rows[0]["差引超過額"])));

                    this.crystalReportViewer1.ReportSource = rpt;

                    //テスト
                    //rpt.PrintToPrinter(0, true, 0, 0);


                    IniFileRead cIni = new IniFileRead();//printer code
                    string Printer = cIni.IniRead("Loppitxt", "Printer");
                    rpt.PrintOptions.PrinterName = Printer;
                    rpt.PrintToPrinter(1, true, 0, 0);

                    str = "exec CertificatePrintHistorySave "  // save print history
                           + F_CertificateMenu.empCd + ", '" + F_CertificateMenu.empName + "', '001', '源泉徴収票'";
                    DB.DBoperation(str);

                    //↑↑↑↑↑↑　2015/09/22 10085270 劉宝山 ADD ↑↑↑↑↑↑↑
                    DB.Close();
                    //MessageBox.Show("源泉徴収票が印刷しました。");
                    F_Main_Message FMM = new F_Main_Message();
                    F_Main_Message.MeFlag = 34;
                    FMM.ShowDialog();
                    if (FMM.DialogResult == DialogResult.OK)
                    {
                        this.DialogResult = DialogResult.OK;
                        this.Close();
                    }
                }

            }
            catch (Exception ex)
            {
                this.crystalReportViewer1.Visible = false;
                //MessageBox.Show(ex.Message);
                return;
            }
        }

        /*------------------------10061820 20161219 update end-----------------------------------*/

        /// <summary>
        ///　臨時テーブルTaxPrintEmployeeInfoにデータの削除と挿入
        /// </summary>
        /// <param name="printRange">印刷範囲</param>
        /// <param name="code">コード</param>
        /// <param name="EmpDivision">社員区分</param>
        /// <param name="AdminID">登録者コード</param>
        /// <param name="flag">flag=1場合、削除。flag=2場合、挿入</param>
        /// <returns>1:成功　0:失敗</returns>
        public string InsertTaxPrintEmpInfo(string printRange, string code, string EmpDivision, string AdminID, string flag, string AdjustYear)
        {
            string reValue = "";
            try
            {
                DBconnection DB = new DBconnection();
                DB.Open("dbYearAjust_database");
                str = "exec Taxwithholding_Insert_PrintEmpInfo '" + printRange+"','"+code+"','"+EmpDivision+"',"+AdminID+","+flag+",'"+AdjustYear+"'";
                DB.selectSql(str);
                reValue = DB.ds.Tables[0].Rows[0][0].ToString();
                DB.Close();
            }
            catch (Exception ex)
            {
                //MessageBox.Show(ex.Message);
                return "0";
            }
            return reValue;
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            this.Close();
            timer1.Enabled = false;
        }
    }
}
