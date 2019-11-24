using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;
using System.Data;
using System.Text.RegularExpressions;
using Excel = Microsoft.Office.Interop.Excel;
using System.Threading;


namespace Windowsform
{
    public partial class Form1 : Form
    {
        public static int flag1,tt,uu,kkk;
        string wt_initial;
        string wt;
        string wt_client_initial = "";
        string wt_client;
        string[] search1 = new string[100];
        string[] search2 = new string[100];
        string[] search3 = new string[100];
        string[] search4 = new string[100];
        Color[] cr1 = new Color[100];
        Color[] cr2 = new Color[100];
        Color[] cr3 = new Color[100];
        Color[] cr4 = new Color[100];
        DateTime[] data1 = new DateTime[100];
        DateTime temp,now1;
        int[] data2 = new int[50];
        Sunisoft.IrisSkin.SkinEngine skin = new Sunisoft.IrisSkin.SkinEngine();
        string[] files = Directory.GetFiles(@"E:\VS2019proj\Windowsform\Windowsform\bin\Debug\Skins");

        public Form1()
        {
            InitializeComponent();
            skin.SkinFile = $@"{files[66]}";
            skin.Active = true;
            //System.Diagnostics.Process.Start(@"E:\VS2019proj\test2\txt2.txt");
        }



        private void label1_Click(object sender, EventArgs e)
        {

        }


        private void Form1_Load(object sender, EventArgs e)
        {
            comboBox1.Items.Add("zjw");
            comboBox1.Items.Add("hxy");
            comboBox1.Items.Add("wjy");
            comboBox1.Items.Add("invalid user");
            comboBox2.Items.Add("yes");
            comboBox2.Items.Add("no");
            comboBox2.Items.Add("timeout");
            
        }

        private void button2_Click(object sender, EventArgs e)
        {
            int index = dataGridView1.Rows.Add(); //得到当前控件的行数
            for (int i = 0; i < index + 1; i++)
            {
                dataGridView1.Rows.RemoveAt(0);
            }
            tt = 0;
        }

        private void button6_Click(object sender, EventArgs e)
        {
            timer2.Stop();
        }

        private void button8_Click(object sender, EventArgs e)
        {
            string fileName = "";

            string saveFileName = "";

            SaveFileDialog saveDialog = new SaveFileDialog();

            saveDialog.DefaultExt = "xls";

            saveDialog.Filter = "Excel文件|*.xls";

            saveDialog.FileName = fileName;

            saveDialog.ShowDialog();

            saveFileName = saveDialog.FileName;

            if (saveFileName.IndexOf(":") < 0) return; //被点了取消

            Microsoft.Office.Interop.Excel.Application xlApp = new Microsoft.Office.Interop.Excel.Application();

            if (xlApp == null)

            {

                MessageBox.Show("无法创建Excel对象，您的电脑可能未安装Excel");

                return;

            }

            Microsoft.Office.Interop.Excel.Workbooks workbooks = xlApp.Workbooks;

            Microsoft.Office.Interop.Excel.Workbook workbook = workbooks.Add(Microsoft.Office.Interop.Excel.XlWBATemplate.xlWBATWorksheet);

            Microsoft.Office.Interop.Excel.Worksheet worksheet = (Microsoft.Office.Interop.Excel.Worksheet)workbook.Worksheets[1];//取得sheet1 

            //写入标题             

            for (int i = 0; i < dataGridView3.ColumnCount; i++)

            { worksheet.Cells[1, i + 1] = dataGridView3.Columns[i].HeaderText; }

            //写入数值

            for (int r = 0; r < dataGridView3.Rows.Count; r++)

            {
                for (int i = 0; i < dataGridView3.ColumnCount; i++)

                {

                    worksheet.Cells[r + 2, i + 1] = dataGridView3.Rows[r].Cells[i].Value;

                }

                System.Windows.Forms.Application.DoEvents();

            }

            worksheet.Columns.EntireColumn.AutoFit();//列宽自适应

            MessageBox.Show(fileName + "无效区数据保存成功", "提示", MessageBoxButtons.OK);

            if (saveFileName != "")

            {

                try

                {
                    workbook.Saved = true;

                    workbook.SaveCopyAs(saveFileName);  //fileSaved = true;                 

                }

                catch (Exception ex)

                {//fileSaved = false;                      

                    MessageBox.Show("导出文件时出错,文件可能正被打开！\n" + ex.Message);

                }

            }

            xlApp.Quit();

            GC.Collect();//强行销毁           }
        }

        private void button9_Click(object sender, EventArgs e)
        {
            string fileName = "";

            string saveFileName = "";

            SaveFileDialog saveDialog = new SaveFileDialog();

            saveDialog.DefaultExt = "xls";

            saveDialog.Filter = "Excel文件|*.xls";

            saveDialog.FileName = fileName;

            saveDialog.ShowDialog();

            saveFileName = saveDialog.FileName;

            if (saveFileName.IndexOf(":") < 0) return; //被点了取消

            Microsoft.Office.Interop.Excel.Application xlApp = new Microsoft.Office.Interop.Excel.Application();

            if (xlApp == null)

            {

                MessageBox.Show("无法创建Excel对象，您的电脑可能未安装Excel");

                return;

            }

            Microsoft.Office.Interop.Excel.Workbooks workbooks = xlApp.Workbooks;

            Microsoft.Office.Interop.Excel.Workbook workbook = workbooks.Add(Microsoft.Office.Interop.Excel.XlWBATemplate.xlWBATWorksheet);

            Microsoft.Office.Interop.Excel.Worksheet worksheet = (Microsoft.Office.Interop.Excel.Worksheet)workbook.Worksheets[1];//取得sheet1 

            //写入标题             

            for (int i = 0; i < dataGridView1.ColumnCount; i++)

            { worksheet.Cells[1, i + 1] = dataGridView1.Columns[i].HeaderText; }

            //写入数值

            for (int r = 0; r < dataGridView1.Rows.Count; r++)

            {
                for (int i = 0; i < dataGridView1.ColumnCount; i++)

                {

                    worksheet.Cells[r + 2, i + 1] = dataGridView1.Rows[r].Cells[i].Value;

                }

                System.Windows.Forms.Application.DoEvents();

            }

            worksheet.Columns.EntireColumn.AutoFit();//列宽自适应

            MessageBox.Show(fileName + "申请日志保存成功", "提示", MessageBoxButtons.OK);

            if (saveFileName != "")

            {

                try

                {
                    workbook.Saved = true;

                    workbook.SaveCopyAs(saveFileName);  //fileSaved = true;                 

                }

                catch (Exception ex)

                {//fileSaved = false;                      

                    MessageBox.Show("导出文件时出错,文件可能正被打开！\n" + ex.Message);

                }

            }

            xlApp.Quit();

            GC.Collect();//强行销毁           }
        }

        private void button10_Click(object sender, EventArgs e)
        {
            //dataGridView1.Rows[0].Cells[1].Value = "CDF";
            //dataGridView1.Rows.Add();
            //dataGridView1.Rows[1].Cells[1].Value = "JHK";
            //dataGridView1.Rows.Add();
            //int index = dataGridView1.Rows.Count;
            //dataGridView1.Rows[2].Cells[2].Value = $"{index}";
            //dataGridView1.Rows[2].Cells[1].Value = "CBD";
            //dataGridView1.Rows[2].Cells[1].Value = "ABC";
            //for (int k=0;k<4;k++)
            //dataGridView1.Rows[0].Cells[k].Style.BackColor = System.Drawing.Color.Gray;
            //string now = DateTime.Now.ToString();
            //dataGridView1.Rows[0].Cells[0].Value = now;
            int index = dataGridView1.Rows.Add(); //得到当前控件的行数
            for (int i = 0; i < index + 1; i++)
            {
                dataGridView1.Rows.RemoveAt(0);
            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            string fileName = "";

            string saveFileName = "";

            SaveFileDialog saveDialog = new SaveFileDialog();

            saveDialog.DefaultExt = "xls";

            saveDialog.Filter = "Excel文件|*.xls";

            saveDialog.FileName = fileName;

            saveDialog.ShowDialog();

            saveFileName = saveDialog.FileName;

            if (saveFileName.IndexOf(":") < 0) return; //被点了取消

            Microsoft.Office.Interop.Excel.Application xlApp = new Microsoft.Office.Interop.Excel.Application();

            if (xlApp == null)

            {

                MessageBox.Show("无法创建Excel对象，您的电脑可能未安装Excel");

                return;

            }

            Microsoft.Office.Interop.Excel.Workbooks workbooks = xlApp.Workbooks;

            Microsoft.Office.Interop.Excel.Workbook workbook = workbooks.Add(Microsoft.Office.Interop.Excel.XlWBATemplate.xlWBATWorksheet);

            Microsoft.Office.Interop.Excel.Worksheet worksheet = (Microsoft.Office.Interop.Excel.Worksheet)workbook.Worksheets[1];//取得sheet1 

            //写入标题             

            for (int i = 0; i < dataGridView2.ColumnCount; i++)

            { worksheet.Cells[1, i + 1] = dataGridView2.Columns[i].HeaderText; }

            //写入数值

            for (int r = 0; r < dataGridView2.Rows.Count; r++)

            {
                for (int i = 0; i < dataGridView2.ColumnCount; i++)

                {

                    worksheet.Cells[r + 2, i + 1] = dataGridView2.Rows[r].Cells[i].Value;

                }

                System.Windows.Forms.Application.DoEvents();

            }

            worksheet.Columns.EntireColumn.AutoFit();//列宽自适应

            MessageBox.Show(fileName + "有效区数据保存成功", "提示", MessageBoxButtons.OK);

            if (saveFileName != "")

            {

                try

                {
                    workbook.Saved = true;

                    workbook.SaveCopyAs(saveFileName);  //fileSaved = true;                 

                }

                catch (Exception ex)

                {//fileSaved = false;                      

                    MessageBox.Show("导出文件时出错,文件可能正被打开！\n" + ex.Message);

                }

            }

            xlApp.Quit();

            GC.Collect();//强行销毁           }
        }

        private void button3_Click_2(object sender, EventArgs e)
        {
            string[] files = Directory.GetFiles(@"\\pynq\xilinx\jupyter_notebooks\Quantum_Knight\data");
            for (int z = 0; z < files.Length; z++)
            {
                string files_element = files[z];
                if ((int)files_element[52] != 102)
                {
                    FileInfo fi = new FileInfo($@"{files_element}");
                    wt_initial = fi.LastWriteTime.ToString();
                }
                if ((int)files_element[52] == 102)
                {
                    FileInfo fi = new FileInfo($@"{files_element}");
                    wt_client_initial = fi.LastWriteTime.ToString();
                }
            }
            timer2.Start();
        }


        private void button1_Click(object sender, EventArgs e)
        {
            int index = dataGridView4.Rows.Add(); //得到当前控件的行数
            for (int i = 0; i < index + 1; i++)
            {
                dataGridView4.Rows.RemoveAt(0);
            }
            if (comboBox2.Text == "yes")
            {
                dataGridView1.Hide();
                dataGridView4.Show();
                int index_1 = dataGridView1.Rows.Count;
                for (int i = 0; i < index_1 - 1; i++)
                {
                    if ((string)dataGridView1.Rows[i].Cells[3].Value == "yes")
                    {
                        search1[uu] = (string)dataGridView1.Rows[i].Cells[0].Value;
                        search2[uu] = (string)dataGridView1.Rows[i].Cells[1].Value;
                        search3[uu] = (string)dataGridView1.Rows[i].Cells[2].Value;
                        search4[uu] = (string)dataGridView1.Rows[i].Cells[3].Value;
                        cr1[uu] = dataGridView1.Rows[i].Cells[0].Style.ForeColor;
                        cr2[uu] = dataGridView1.Rows[i].Cells[1].Style.ForeColor;
                        cr3[uu] = dataGridView1.Rows[i].Cells[2].Style.ForeColor;
                        cr4[uu] = dataGridView1.Rows[i].Cells[3].Style.ForeColor;
                        uu = uu + 1;
                    }
                }
                for (int v = 0; v < uu; v++)
                {
                    dataGridView4.Rows.Add();
                    dataGridView4.Rows[v].Cells[0].Value = search1[v];
                    dataGridView4.Rows[v].Cells[1].Value = search2[v];
                    dataGridView4.Rows[v].Cells[2].Value = search3[v];
                    dataGridView4.Rows[v].Cells[3].Value = search4[v];
                    dataGridView4.Rows[v].Cells[0].Style.ForeColor = cr1[v];
                    dataGridView4.Rows[v].Cells[1].Style.ForeColor = cr2[v];
                    dataGridView4.Rows[v].Cells[2].Style.ForeColor = cr3[v];
                    dataGridView4.Rows[v].Cells[3].Style.ForeColor = cr4[v];
                }
                uu = 0;
            }
            if (comboBox2.Text == "no")
            {
                dataGridView1.Hide();
                dataGridView4.Show();
                int index_1 = dataGridView1.Rows.Count;
                for (int i = 0; i < index_1 - 1; i++)
                {
                    if ((string)dataGridView1.Rows[i].Cells[3].Value == "no")
                    {
                        search1[uu] = (string)dataGridView1.Rows[i].Cells[0].Value;
                        search2[uu] = (string)dataGridView1.Rows[i].Cells[1].Value;
                        search3[uu] = (string)dataGridView1.Rows[i].Cells[2].Value;
                        search4[uu] = (string)dataGridView1.Rows[i].Cells[3].Value;
                        cr1[uu] = dataGridView1.Rows[i].Cells[0].Style.ForeColor;
                        cr2[uu] = dataGridView1.Rows[i].Cells[1].Style.ForeColor;
                        cr3[uu] = dataGridView1.Rows[i].Cells[2].Style.ForeColor;
                        cr4[uu] = dataGridView1.Rows[i].Cells[3].Style.ForeColor;
                        uu = uu + 1;
                    }
                }
                for (int v = 0; v < uu; v++)
                {
                    dataGridView4.Rows.Add();
                    dataGridView4.Rows[v].Cells[0].Value = search1[v];
                    dataGridView4.Rows[v].Cells[1].Value = search2[v];
                    dataGridView4.Rows[v].Cells[2].Value = search3[v];
                    dataGridView4.Rows[v].Cells[3].Value = search4[v];
                    dataGridView4.Rows[v].Cells[0].Style.ForeColor = cr1[v];
                    dataGridView4.Rows[v].Cells[1].Style.ForeColor = cr2[v];
                    dataGridView4.Rows[v].Cells[2].Style.ForeColor = cr3[v];
                    dataGridView4.Rows[v].Cells[3].Style.ForeColor = cr4[v];
                }
                uu = 0;
            }
            if (comboBox2.Text == "timeout")
            {
                dataGridView1.Hide();
                dataGridView4.Show();
                int index_1 = dataGridView1.Rows.Count;
                for (int i = 0; i < index_1 - 1; i++)
                {
                    if ((string)dataGridView1.Rows[i].Cells[3].Value == "timeout")
                    {
                        search1[uu] = (string)dataGridView1.Rows[i].Cells[0].Value;
                        search2[uu] = (string)dataGridView1.Rows[i].Cells[1].Value;
                        search3[uu] = (string)dataGridView1.Rows[i].Cells[2].Value;
                        search4[uu] = (string)dataGridView1.Rows[i].Cells[3].Value;
                        cr1[uu] = dataGridView1.Rows[i].Cells[0].Style.ForeColor;
                        cr2[uu] = dataGridView1.Rows[i].Cells[1].Style.ForeColor;
                        cr3[uu] = dataGridView1.Rows[i].Cells[2].Style.ForeColor;
                        cr4[uu] = dataGridView1.Rows[i].Cells[3].Style.ForeColor;
                        uu = uu + 1;
                    }
                }
                for (int v = 0; v < uu; v++)
                {
                    dataGridView4.Rows.Add();
                    dataGridView4.Rows[v].Cells[0].Value = search1[v];
                    dataGridView4.Rows[v].Cells[1].Value = search2[v];
                    dataGridView4.Rows[v].Cells[2].Value = search3[v];
                    dataGridView4.Rows[v].Cells[3].Value = search4[v];
                    dataGridView4.Rows[v].Cells[0].Style.ForeColor = cr1[v];
                    dataGridView4.Rows[v].Cells[1].Style.ForeColor = cr2[v];
                    dataGridView4.Rows[v].Cells[2].Style.ForeColor = cr3[v];
                    dataGridView4.Rows[v].Cells[3].Style.ForeColor = cr4[v];
                }
                uu = 0;
            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            dataGridView1.Show();
            dataGridView4.Hide();
        }

        private void button7_Click(object sender, EventArgs e)
        {
            int index = dataGridView4.Rows.Add(); //得到当前控件的行数
            for (int i = 0; i < index + 1; i++)
            {
                dataGridView4.Rows.RemoveAt(0);
            }
            if (comboBox1.Text == "zjw")
            {
                dataGridView1.Hide();
                dataGridView4.Show();
                int index_1 = dataGridView1.Rows.Count;
                for (int i = 0; i < index_1 - 1; i++)
                {
                    if ((string)dataGridView1.Rows[i].Cells[2].Value == "zjw")
                    {
                        search1[uu] = (string)dataGridView1.Rows[i].Cells[0].Value;
                        search2[uu] = (string)dataGridView1.Rows[i].Cells[1].Value;
                        search3[uu] = (string)dataGridView1.Rows[i].Cells[2].Value;
                        search4[uu] = (string)dataGridView1.Rows[i].Cells[3].Value;
                        cr1[uu] = dataGridView1.Rows[i].Cells[0].Style.ForeColor;
                        cr2[uu] = dataGridView1.Rows[i].Cells[1].Style.ForeColor;
                        cr3[uu] = dataGridView1.Rows[i].Cells[2].Style.ForeColor;
                        cr4[uu] = dataGridView1.Rows[i].Cells[3].Style.ForeColor;
                        uu = uu + 1;
                    }
                }
                for (int v = 0; v < uu; v++)
                {
                    dataGridView4.Rows.Add();
                    dataGridView4.Rows[v].Cells[0].Value = search1[v];
                    dataGridView4.Rows[v].Cells[1].Value = search2[v];
                    dataGridView4.Rows[v].Cells[2].Value = search3[v];
                    dataGridView4.Rows[v].Cells[3].Value = search4[v];
                    dataGridView4.Rows[v].Cells[0].Style.ForeColor = cr1[v];
                    dataGridView4.Rows[v].Cells[1].Style.ForeColor = cr2[v];
                    dataGridView4.Rows[v].Cells[2].Style.ForeColor = cr3[v];
                    dataGridView4.Rows[v].Cells[3].Style.ForeColor = cr4[v];
                }
                uu = 0;
            }
            if (comboBox1.Text == "hxy")
            {
                dataGridView1.Hide();
                dataGridView4.Show();
                int index_1 = dataGridView1.Rows.Count;
                for (int i = 0; i < index_1 - 1; i++)
                {
                    if ((string)dataGridView1.Rows[i].Cells[2].Value == "hxy")
                    {
                        search1[uu] = (string)dataGridView1.Rows[i].Cells[0].Value;
                        search2[uu] = (string)dataGridView1.Rows[i].Cells[1].Value;
                        search3[uu] = (string)dataGridView1.Rows[i].Cells[2].Value;
                        search4[uu] = (string)dataGridView1.Rows[i].Cells[3].Value;
                        cr1[uu] = dataGridView1.Rows[i].Cells[0].Style.ForeColor;
                        cr2[uu] = dataGridView1.Rows[i].Cells[1].Style.ForeColor;
                        cr3[uu] = dataGridView1.Rows[i].Cells[2].Style.ForeColor;
                        cr4[uu] = dataGridView1.Rows[i].Cells[3].Style.ForeColor;
                        uu = uu + 1;
                    }
                }
                for (int v = 0; v < uu; v++)
                {
                    dataGridView4.Rows.Add();
                    dataGridView4.Rows[v].Cells[0].Value = search1[v];
                    dataGridView4.Rows[v].Cells[1].Value = search2[v];
                    dataGridView4.Rows[v].Cells[2].Value = search3[v];
                    dataGridView4.Rows[v].Cells[3].Value = search4[v];
                    dataGridView4.Rows[v].Cells[0].Style.ForeColor = cr1[v];
                    dataGridView4.Rows[v].Cells[1].Style.ForeColor = cr2[v];
                    dataGridView4.Rows[v].Cells[2].Style.ForeColor = cr3[v];
                    dataGridView4.Rows[v].Cells[3].Style.ForeColor = cr4[v];
                }
                uu = 0;
            }
            if (comboBox1.Text == "wjy")
            {
                dataGridView1.Hide();
                dataGridView4.Show();
                int index_1 = dataGridView1.Rows.Count;
                for (int i = 0; i < index_1 - 1; i++)
                {
                    if ((string)dataGridView1.Rows[i].Cells[2].Value == "wjy")
                    {
                        search1[uu] = (string)dataGridView1.Rows[i].Cells[0].Value;
                        search2[uu] = (string)dataGridView1.Rows[i].Cells[1].Value;
                        search3[uu] = (string)dataGridView1.Rows[i].Cells[2].Value;
                        search4[uu] = (string)dataGridView1.Rows[i].Cells[3].Value;
                        cr1[uu] = dataGridView1.Rows[i].Cells[0].Style.ForeColor;
                        cr2[uu] = dataGridView1.Rows[i].Cells[1].Style.ForeColor;
                        cr3[uu] = dataGridView1.Rows[i].Cells[2].Style.ForeColor;
                        cr4[uu] = dataGridView1.Rows[i].Cells[3].Style.ForeColor;
                        uu = uu + 1;
                    }
                }
                for (int v = 0; v < uu; v++)
                {
                    dataGridView4.Rows.Add();
                    dataGridView4.Rows[v].Cells[0].Value = search1[v];
                    dataGridView4.Rows[v].Cells[1].Value = search2[v];
                    dataGridView4.Rows[v].Cells[2].Value = search3[v];
                    dataGridView4.Rows[v].Cells[3].Value = search4[v];
                    dataGridView4.Rows[v].Cells[0].Style.ForeColor = cr1[v];
                    dataGridView4.Rows[v].Cells[1].Style.ForeColor = cr2[v];
                    dataGridView4.Rows[v].Cells[2].Style.ForeColor = cr3[v];
                    dataGridView4.Rows[v].Cells[3].Style.ForeColor = cr4[v];
                }
                uu = 0;
            }
            if (comboBox1.Text == "invalid user")
            {
                dataGridView1.Hide();
                dataGridView4.Show();
                int index_1 = dataGridView1.Rows.Count;
                for (int i = 0; i < index_1 - 1; i++)
                {
                    if ((string)dataGridView1.Rows[i].Cells[2].Value == "invalid user")
                    {
                        search1[uu] = (string)dataGridView1.Rows[i].Cells[0].Value;
                        search2[uu] = (string)dataGridView1.Rows[i].Cells[1].Value;
                        search3[uu] = (string)dataGridView1.Rows[i].Cells[2].Value;
                        search4[uu] = (string)dataGridView1.Rows[i].Cells[3].Value;
                        cr1[uu] = dataGridView1.Rows[i].Cells[0].Style.ForeColor;
                        cr2[uu] = dataGridView1.Rows[i].Cells[1].Style.ForeColor;
                        cr3[uu] = dataGridView1.Rows[i].Cells[2].Style.ForeColor;
                        cr4[uu] = dataGridView1.Rows[i].Cells[3].Style.ForeColor;
                        uu = uu + 1;
                    }
                }
                for (int v = 0; v < uu; v++)
                {
                    dataGridView4.Rows.Add();
                    dataGridView4.Rows[v].Cells[0].Value = search1[v];
                    dataGridView4.Rows[v].Cells[1].Value = search2[v];
                    dataGridView4.Rows[v].Cells[2].Value = search3[v];
                    dataGridView4.Rows[v].Cells[3].Value = search4[v];
                    dataGridView4.Rows[v].Cells[0].Style.ForeColor = cr1[v];
                    dataGridView4.Rows[v].Cells[1].Style.ForeColor = cr2[v];
                    dataGridView4.Rows[v].Cells[2].Style.ForeColor = cr3[v];
                    dataGridView4.Rows[v].Cells[3].Style.ForeColor = cr4[v];
                }
                uu = 0;
            }
        }

        private void timer2_Tick_1(object sender, EventArgs e)
        {
            string[] files = Directory.GetFiles(@"\\pynq\xilinx\jupyter_notebooks\Quantum_Knight\data");
            for (int z = 0; z < files.Length; z++)
            {
                string files_element = files[z];
                if ((int)files_element[52] != 102)
                {
                    FileInfo fi = new FileInfo($@"{files_element}");
                    wt = fi.LastWriteTime.ToString();
                    if (string.Compare(wt, wt_initial) != 0 && (int)wt[0] == 50)
                    {
                        dataGridView2.Rows.Add();
                        StreamReader sr3 = new StreamReader($@"{files_element}", Encoding.GetEncoding("gb2312"));
                        String line_3;
                        line_3 = sr3.ReadToEnd();
                        string[] arrayStr = Regex.Split(line_3, "\r\n");
                        string lastMessage1 = arrayStr[arrayStr.Length - 3];
                        string lastMessage2 = arrayStr[arrayStr.Length - 2];
                        string lastMessage3 = arrayStr[arrayStr.Length - 1];
                        int index = dataGridView2.Rows.Count;
                        dataGridView2.Rows[index - 2].Cells[0].Value = lastMessage1;
                        dataGridView2.Rows[index - 2].Cells[1].Value = lastMessage2;
                        dataGridView2.Rows[index - 2].Cells[2].Value = lastMessage3;
                        if (index >= 7)
                        {
                            dataGridView3.Rows.Add();
                            for (int i = 0; i < 3; i++)
                            {
                                int index3 = dataGridView3.Rows.Count;
                                dataGridView3.Rows[index3 - 2].Cells[i].Value = dataGridView2.Rows[0].Cells[i].Value;
                            }
                            dataGridView2.Rows.RemoveAt(0);
                        }
                        int index2 = dataGridView2.Rows.Count;
                        textBox1.Text = $"{index2 - 1}";
                        int index_2 = dataGridView3.Rows.Count;
                        textBox3.Text = $"{index_2 - 1}";
                        wt_initial = wt;
                    }
                }
                if ((int)files_element[52] == 102)
                {
                    FileInfo fi = new FileInfo($@"{files_element}");
                    wt_client = fi.LastWriteTime.ToString();
                    //Thread.Sleep(5000);
                    if (string.Compare(wt_client, wt_client_initial) != 0 && (int)wt_client[0] == 50)
                    {
                        FileInfo fii = new FileInfo($@"{files_element}");
                        DateTime wt_temp = fii.LastWriteTime;
                        StreamReader sr1 = new StreamReader($@"{files_element}", Encoding.GetEncoding("gb2312"));
                        int i;
                        String line_1;
                        line_1 = sr1.ReadLine();
                        int index4 = dataGridView2.Rows.Count;
                        dataGridView1.Rows.Add();
                        int index5 = dataGridView1.Rows.Count;
                        DateTime now_1 = DateTime.Now;
                        DateTime now_1_temp;
                        dataGridView1.Rows[index5 - 2].Cells[0].Value = $"{now_1}";
                        now_1_temp = now_1.AddSeconds(25);
                        wt_temp = wt_temp.AddSeconds(25);
                        dataGridView1.Rows[index5 - 2].Cells[1].Value = $"{now_1_temp}";
                        for (i = 0; i < index4 - 1; i++)
                        {
                            for (int j = 0; j < 3; j++)
                            {
                                if (string.Compare((string)dataGridView2.Rows[i].Cells[j].Value, line_1) == 0)
                                {
                                    flag1 = 1;
                                    if (j == 0)
                                        dataGridView1.Rows[index5 - 2].Cells[2].Value = "zjw";
                                    if (j == 1)
                                        dataGridView1.Rows[index5 - 2].Cells[2].Value = "hxy";
                                    if (j == 2)
                                        dataGridView1.Rows[index5 - 2].Cells[2].Value = "wjy";
                                    dataGridView1.Rows[index5 - 2].Cells[3].Value = "yes";
                                    for (int k = 0; k < 4; k++)
                                        dataGridView1.Rows[index5 - 2].Cells[k].Style.ForeColor = System.Drawing.Color.Green;
                                    temp = DateTime.Now;
                                    data1[tt] = temp;
                                    data2[tt] = index5 - 2;
                                    tt = tt + 1;
                                    FileStream fs = new FileStream(@"\\pynq\xilinx\jupyter_notebooks\Quantum_Knight\client_reply_1.txt", FileMode.Create);
                                    StreamWriter wr = null;
                                    wr = new StreamWriter(fs);
                                    wr.Write("");
                                    wr.Close();
                                    break;
                                }
                            }
                            if (flag1 == 1) break;
                        }
                        flag1 = 0;
                        if (i == index4 - 1)
                        {
                            dataGridView1.Rows[index5 - 2].Cells[3].Value = "no";
                            dataGridView1.Rows[index5 - 2].Cells[2].Value = "invalid user";
                            for (int k = 0; k < 4; k++)
                                dataGridView1.Rows[index5 - 2].Cells[k].Style.ForeColor = System.Drawing.Color.Red;
                            FileStream fs = new FileStream(@"\\pynq\xilinx\jupyter_notebooks\Quantum_Knight\client_reply_0.txt", FileMode.Create);
                            StreamWriter wr = null;
                            wr = new StreamWriter(fs);
                            wr.Write("");
                            wr.Close();
                        }
                        sr1.Dispose();
                        sr1.Close();
                        wt_client_initial = wt_client;
                    }

                }

            }
            now1 = DateTime.Now;
            for (int q = 0; q < tt; q++)
            {
                if (now1 >= data1[q].AddSeconds(25))
                {
                    for (int k = 0; k < 4; k++)
                    {
                        dataGridView1.Rows[data2[q]].Cells[k].Style.ForeColor = System.Drawing.Color.Gray;
                        dataGridView1.Rows[data2[q]].Cells[3].Value = "timeout";
                    }
                }
            }

        }

    }
}
