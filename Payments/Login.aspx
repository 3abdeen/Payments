<%@ Page Title="Login" MasterPageFile="~/MasterPage.master" 
    CodeBehind="Login.aspx.cs"  Inherits="Login" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container">
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
            <div class="login-form">
                <h2>Sign In</h2>
                
                <telerik:RadTextBox ID="txtUsername" runat="server" 
                    Label="Username:" Width="300px" />
                
                <telerik:RadTextBox ID="txtPassword" runat="server" 
                    Label="Password:" TextMode="Password" Width="300px" />
                
                <telerik:RadButton ID="btnLogin" runat="server" Text="Sign In" 
                    OnClick="btnLogin_Click" Skin="Material" />
                
                <div class="auth-links">
                    <asp:HyperLink NavigateUrl="~/Register.aspx" Text="Create Account" runat="server" />
                </div>
            </div>
        </telerik:RadAjaxPanel>
    </div>
</asp:Content>