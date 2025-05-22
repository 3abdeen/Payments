using System;
using System.IO;

namespace Payments
{
    public partial class MasterPage : System.Web.UI.MasterPage
    {
        public Telerik.Web.UI.RadWindowManager WindowManager => this.RadWindowManager1;

        protected void Page_Load(object sender, EventArgs e)
        {
            var currentPage = Path.GetFileName(Request.Path).ToLower();

            if (currentPage != "login.aspx" && currentPage != "register.aspx" && Session["UserID"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }
        }
    }
}