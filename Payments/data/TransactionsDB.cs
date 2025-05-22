using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;
namespace Payments.Data
{
    public static class TransactionsDB
    {
        private static readonly string ConnString = WebConfigurationManager.ConnectionStrings["PaymentsDB"].ConnectionString;

        public static void CreateTransaction(Transaction transaction)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("sp_InsertTransaction", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@UserID", SqlDbType.Int).Value = transaction.UserID;
                cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = transaction.Amount;
                cmd.Parameters["@Amount"].Precision = 18;
                cmd.Parameters["@Amount"].Scale = 2;
                cmd.Parameters.Add("@TransactionDate", SqlDbType.DateTime).Value = transaction.TransactionDate;
                cmd.Parameters.Add("@Description", SqlDbType.NVarChar, 255).Value = transaction.Description;
                cmd.Parameters.Add("@Status", SqlDbType.NVarChar, 50).Value = transaction.Status;
                cmd.Parameters.Add("@Reference", SqlDbType.NVarChar, 100).Value = transaction.Reference;

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }

        public static DataTable GetTransactions()
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("SELECT * FROM Transactions", conn))
            {
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                dt.Columns["Amount"].DataType = typeof(decimal);

                dt.Columns["TransactionDate"].DataType = typeof(DateTime);

                return dt;
            }
        }
        public static void UpdateTransaction(Transaction transaction)
        {
            using (SqlConnection conn = new SqlConnection(ConnString))
            using (SqlCommand cmd = new SqlCommand("sp_UpdateTransaction", conn))
            {
                cmd.CommandType = CommandType.StoredProcedure;
                cmd.Parameters.Add("@TransactionID", SqlDbType.Int).Value = transaction.TransactionID;
                cmd.Parameters.Add("@Amount", SqlDbType.Decimal).Value = transaction.Amount;
                cmd.Parameters.Add("@TransactionDate", SqlDbType.DateTime).Value = transaction.TransactionDate;
                cmd.Parameters.Add("@Description", SqlDbType.NVarChar, 255).Value = transaction.Description;
                cmd.Parameters.Add("@Status", SqlDbType.NVarChar, 50).Value = transaction.Status;

                conn.Open();
                cmd.ExecuteNonQuery();
            }
        }
        public static DataTable GetTransactionsByDate(DateTime startDate, DateTime endDate)
        {
            using (var conn = new SqlConnection(ConnString))
            {
                using (var cmd = new SqlCommand("sp_GetTransactionsByDate", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddWithValue("@StartDate", startDate);
                    cmd.Parameters.AddWithValue("@EndDate", endDate);

                    var da = new SqlDataAdapter(cmd);
                    var dt = new DataTable();
                    da.Fill(dt);

                    return dt;
                }
            }
        }

        public static void DeleteTransaction(int transactionId)
        {
            using (var conn = new SqlConnection(ConnString))
            {
                using (var cmd = new SqlCommand("DELETE FROM Transactions WHERE TransactionID = @ID", conn))
                {
                    cmd.Parameters.AddWithValue("@ID", transactionId);
                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
        }
    }
}