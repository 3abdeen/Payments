using System;
using System.Data;
using System.Drawing;
using System.Web.UI;
using Payments.Data;
using Telerik.Web.UI;

namespace Payments
{
    public partial class TransactionHistory : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (!UserAuthenticated())
                {
                    Response.Redirect("Login.aspx");
                    return;
                }

                dateFrom.SelectedDate = DateTime.Now.AddDays(-30);
                dateTo.SelectedDate = DateTime.Now;
            }
        }

        protected void radGridHistory_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            radGridHistory.DataSource = GetFilteredTransactions();
        }

        protected void btnFilter_Click(object sender, EventArgs e)
        {
            radGridHistory.Rebind();
        }

        protected void radGridHistory_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem dataItem)
            {
                var status = dataItem["Status"].Text;
                var badge = (System.Web.UI.HtmlControls.HtmlGenericControl)dataItem["Status"].FindControl("statusBadge");

                switch (status.ToLower())
                {
                    case "success":
                        badge.Style.Add("background-color", "#c6f6d5");
                        badge.Style.Add("color", "#2f855a");
                        break;
                    case "pending":
                        badge.Style.Add("background-color", "#feebc8");
                        badge.Style.Add("color", "#c05621");
                        break;
                    case "failed":
                        badge.Style.Add("background-color", "#fed7d7");
                        badge.Style.Add("color", "#c53030");
                        break;
                }
            }
        }

        private DataTable GetFilteredTransactions()
        {
            try
            {
                return TransactionsDB.GetTransactionsByDate(
                    dateFrom.SelectedDate ?? DateTime.MinValue,
                    dateTo.SelectedDate ?? DateTime.MaxValue
                );
            }
            catch (Exception ex)
            {
                ShowError($"Error loading transactions: {ex.Message}");
                return new DataTable();
            }
        }

        private bool UserAuthenticated()
        {
            return Session["UserID"] != null;
        }

        private int GetCurrentUserId()
        {
            return Convert.ToInt32(Session["UserID"]);
        }

        private void ShowError(string message)
        {
            if (Master is MasterPage master)
            {
                master.WindowManager.RadAlert(message, 300, 150, "Error", null);
            }
        }
    }
}