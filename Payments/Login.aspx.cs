using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using Payments;
using Payments.data;
using Telerik.Web.UI;

public partial class Login : System.Web.UI.Page
{
   
    protected void btnLogin_Click(object sender, EventArgs e)
    {
        string username = txtUsername.Text.Trim();
        string password = txtPassword.Text;

        using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["PaymentsDB"].ConnectionString))
        {
            using (SqlCommand cmd = new SqlCommand("sp_AuthenticateUser", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.AddWithValue("@Username", username);

                conn.Open();
                using (SqlDataReader reader = cmd.ExecuteReader())
                {
                    if (reader.Read())
                    {
                        string storedHash = reader["PasswordHash"].ToString();
                        string storedSalt = reader["PasswordSalt"].ToString();
                        bool isLocked = Convert.ToBoolean(reader["IsLocked"]);

                        if (isLocked)
                        {
                            ShowError("Account is locked. Contact support.");
                            return;
                        }

                        if (SecurityHelper.VerifyPassword(password, storedHash, storedSalt))
                        {
                            Session["UserID"] = reader["UserID"];
                            Session["Username"] = username;
                            Response.Redirect("~/Dashboard.aspx");
                        }
                        else
                        {
                            ShowError("Invalid credentials");
                        }
                    }
                    else
                    {
                        ShowError("User not found");
                    }
                }
            }
        }
    }

    private void ShowError(string message)
    {
        if (Master is MasterPage master && master.FindControl("RadWindowManager1") is RadWindowManager manager)
        {
            manager.RadAlert(message, 300, 150, "Error", "");
        }
    }
}