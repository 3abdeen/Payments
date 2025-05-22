using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Net.Mail;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Payments.data;
using Telerik.Web.UI;


namespace Payments
{
    public partial class Register : System.Web.UI.Page
    {
        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if(!txtEmail.Text.IsValidEmail())
            {
                ShowError("Invalid Email.");
                return;
            }
            if (txtPassword.Text != txtConfirmPassword.Text)
            {
                ShowError("Passwords do not match");
                return;
            }

            var (hash, salt) = SecurityHelper.CreatePasswordHash(txtPassword.Text);

            using (SqlConnection conn = new SqlConnection(ConfigurationManager.ConnectionStrings["PaymentsDB"].ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand("sp_RegisterUser", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@Username", txtUsername.Text.Trim());
                    cmd.Parameters.AddWithValue("@PasswordHash", hash);
                    cmd.Parameters.AddWithValue("@PasswordSalt", salt);
                    cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        Response.Redirect("Login.aspx?registered=true");
                    }
                    catch (SqlException ex)
                    {
                        if (ex.Number == 2627)
                        {
                            ShowError("Username or email already exists");
                        }
                        else
                        {
                            ShowError("Registration failed. Please try again.");
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
    public static class StringExtensions
    {
        public static bool IsValidEmail(this string email)
        {
            if (string.IsNullOrWhiteSpace(email))
                return false;

            const string pattern = @"^[^@\s]+@[^@\s]+\.[^@\s]+$";
            return Regex.IsMatch(email, pattern, RegexOptions.IgnoreCase);
        }
    }
}