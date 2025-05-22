using System;
using System.Data.SqlClient;
using System.Web;
using Payments.Data;
using Telerik.Web.UI;

namespace Payments
{
    public partial class CreateTransaction : System.Web.UI.Page
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

                cmbCurrency.DataBind();
                cmbCurrency.SelectedIndex = 0;
                txtReference.Focus();
            }
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    var transaction = new Transaction
                    {
                        UserID = GetCurrentUserId(),
                        Amount = txtAmount.Value.HasValue ?
                                (decimal)txtAmount.Value.Value : 0m,
                        Description = txtDescription.Text.Trim(),
                        Reference = txtReference.Text.Trim(),
                        Status = "Pending",
                        TransactionDate = DateTime.Now
                    };

                    if (transaction.Amount <= 0)
                    {
                        ShowError("Amount must be greater than zero");
                        return;
                    }
                    ShowMessage("Processing payment...");
                    bool paymentResult = ProcessPayment(transaction);

                    if (paymentResult)
                    {
                        ShowMessage("Payment processed successfully.");
                        TransactionsDB.CreateTransaction(transaction);
                        Response.Redirect("TransactionHistory.aspx?success=true");
                    }
                    else
                    {
                        ShowError("Payment processing failed. Please try again.");
                    }
                }
                catch (SqlException ex)
                {
                    ShowError($"Database error: {ex.Message}");
                }
                catch (FormatException ex)
                {
                    ShowError($"Invalid currency selection: {ex.Message}");
                }
                catch (Exception ex)
                {
                    ShowError($"Unexpected error: {ex.Message}");
                }
            }
        }

        private bool UserAuthenticated()
        {
            return Session["UserID"] != null;
        }

        private int GetCurrentUserId()
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            return Convert.ToInt32(Session["UserID"]);
        }

        private bool ProcessPayment(Transaction transaction)
        {
            return PempoHelper.ProcessPayment(
                transaction.Amount,
                GetCurrencyCode(),
                transaction.Description
            );
        }

        private string GetCurrencyCode()
        {
            return "EGP";
        }

        private void ShowError(string message)
        {
            if (Master is MasterPage master)
            {
                master.WindowManager.RadAlert(message, 300, 150, "Error", "alertCallback");
            }
        }
        private void ShowMessage(string message)
        {
            if (Master is MasterPage master)
            {
                master.WindowManager.RadAlert(message, null, null, "Message", null);
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Dashboard.aspx");
        }
    }
}