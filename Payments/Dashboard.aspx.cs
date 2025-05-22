using System;
using System.Data;
using System.Drawing;
using System.Data.SqlClient;
using Payments.Data;
using Telerik.Web.UI;
using System.Linq;
using System.Web.UI;
using System.Web.Util;

namespace Payments
{
    public partial class Dashboard : System.Web.UI.Page
    {
        public int TotalTransactions { get; private set; }
        public decimal SuccessRate { get; private set; }
        public decimal TotalAmount { get; private set; }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CalculateKPIs();
                radGridTransactions.Rebind();
            }
        }

        protected void radGridTransactions_NeedDataSource(object sender, GridNeedDataSourceEventArgs e)
        {
            radGridTransactions.DataSource = TransactionsDB.GetTransactions();
        }
        protected void radGridTransactions_UpdateCommand(object source, GridCommandEventArgs e)
        {
            try
            {
                GridEditableItem editedItem = e.Item as GridEditableItem;
                int transactionId = (int)editedItem.GetDataKeyValue("TransactionID");

                var txtAmount = editedItem.FindControl("txtAmount") as RadNumericTextBox;
                var txtDescription = editedItem.FindControl("txtDescription") as RadTextBox;
                var cmbStatus = editedItem.FindControl("cmbStatus") as RadComboBox;
                var dtpDate = editedItem.FindControl("dtpTransactionDate") as RadDateTimePicker;

                if (txtAmount.Value == null || string.IsNullOrWhiteSpace(txtDescription.Text))
                {
                    ShowError("Amount and Description are required!");
                    return;
                }

                var updatedTransaction = new Transaction
                {
                    TransactionID = transactionId,
                    Amount = (decimal)(txtAmount.Value ?? 0),
                    Description = txtDescription.Text.Trim(),
                    Status = cmbStatus.SelectedValue,
                    TransactionDate = dtpDate.SelectedDate ?? DateTime.Now
                };

                TransactionsDB.UpdateTransaction(updatedTransaction);

                radGridTransactions.Rebind();
                CalculateKPIs();

                ShowSuccess("Transaction updated successfully!");
            }
            catch (Exception ex)
            {
                ShowError($"Error updating transaction: {ex.Message}");
            }
        }
        protected void radGridTransactions_InsertCommand(object source, GridCommandEventArgs e)
        {
            try
            {
                GridEditableItem editedItem = (GridEditableItem)e.Item;

                RadDateTimePicker dtpDate = (RadDateTimePicker)editedItem.FindControl("dtpTransactionDate");
                RadNumericTextBox txtAmount = (RadNumericTextBox)editedItem.FindControl("txtAmount");
                RadTextBox txtDescription = (RadTextBox)editedItem.FindControl("txtDescription");
                RadComboBox cmbStatus = (RadComboBox)editedItem.FindControl("cmbStatus");

                if (txtAmount.Value == null || string.IsNullOrWhiteSpace(txtDescription.Text))
                {
                    ShowError("Amount and Description are required!");
                    return;
                }

                var newTransaction = new Transaction
                {
                    UserID = GetCurrentUserId(),
                    Amount = (decimal)(txtAmount.Value ?? 0),
                    Description = txtDescription.Text.Trim(),
                    Status = cmbStatus.SelectedValue,
                    TransactionDate = dtpDate.SelectedDate ?? DateTime.Now,
                    Reference = GenerateTransactionReference()
                };

                TransactionsDB.CreateTransaction(newTransaction);

                radGridTransactions.Rebind();
                CalculateKPIs();

                ShowSuccess("Transaction added successfully!");
            }
            catch (Exception ex)
            {
                ShowError($"Error: {ex.Message}");
            }
        }
        protected void radGridTransactions_ItemDataBound(object sender, GridItemEventArgs e)
        {
            if (e.Item is GridDataItem item)
            {
                string status = DataBinder.Eval(item.DataItem, "Status").ToString();

                if (status.Equals("Success", StringComparison.OrdinalIgnoreCase))
                {
                    System.Web.UI.WebControls.ImageButton imgEdit = (System.Web.UI.WebControls.ImageButton)item["EditCommandColumn"].Controls[0];
                    System.Web.UI.WebControls.ImageButton imgDelete = (System.Web.UI.WebControls.ImageButton)item["DeleteColumn"].Controls[0];
                    imgDelete.Visible = imgEdit.Visible = false;
                }
            }
            if (e.Item.IsInEditMode)
            {
                try
                {
                    var dataItem = ((GridEditableItem)e.Item).DataItem as DataRowView;
                    if (dataItem != null)
                    {
                        decimal amount = Convert.ToDecimal(dataItem["Amount"]);
                    }
                }
                catch (InvalidCastException ex)
                {
                    System.Diagnostics.Debug.WriteLine($"Cast error: {ex.Message}");
                }
            }
        }

        private string GenerateTransactionReference()
        {
            return Guid.NewGuid().ToString().Substring(0, 12).ToUpper();
        }

        private void CalculateKPIs()
        {
            DataTable dt = TransactionsDB.GetTransactions();
            TotalTransactions = dt.Rows.Count;

            var successRows = dt.Select("Status = 'Success'");
            int successCount = successRows.Length;
            SuccessRate = TotalTransactions > 0 ? (decimal)successCount / TotalTransactions : 0;

            TotalAmount = successRows.Sum(row => Convert.ToDecimal(row["Amount"]));
        }

        private int GetCurrentUserId()
        {
            return 1;
        }

        private void ShowError(string message)
        {
            if (Master is MasterPage master && master.FindControl("RadWindowManager1") is RadWindowManager manager)
            {
                manager.RadAlert(message, 300, 150, "Error", "");
            }
        }

        private void ShowSuccess(string message)
        {
            if (Master is MasterPage master && master.FindControl("RadWindowManager1") is RadWindowManager manager)
            {
                manager.RadAlert(message, 300, 150, "Success", "function(){location.reload();}");
            }
        }

        protected void radGridTransactions_ItemCommand(object sender, GridCommandEventArgs e)
        {
            GridDataItem item = ((GridDataItem)e.Item);
            string status = item["Status"].ToString();

            if (status == "Success")
            {
                ShowError("Cannot edit/delete successful transactions");
                e.Canceled = true;
                return;
            }

            if (e.CommandName == "Delete")
            {
                var transactionId = (int)(item).GetDataKeyValue("TransactionID");
                TransactionsDB.DeleteTransaction(transactionId);
                CalculateKPIs();
                radGridTransactions.Rebind();
            }
        }

    }
}