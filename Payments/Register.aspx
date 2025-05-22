<%@ Page Title="Register" MasterPageFile="~/MasterPage.master" 
    CodeBehind="Register.aspx.cs"  Inherits="Payments.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container">
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server">
            <div class="register-form">
                <h2>Create Account</h2>
                
                <telerik:RadTextBox ID="txtUsername" runat="server" 
                    Label="Username:" Width="300px" />
                
                <telerik:RadTextBox ID="txtEmail" runat="server" 
                    Label="Email:"  Width="300px" />
                
                <telerik:RadTextBox ID="txtPassword" runat="server" 
                    Label="Password:" TextMode="Password" Width="300px" />
                
                <telerik:RadTextBox ID="txtConfirmPassword" runat="server" 
                    Label="Confirm Password:" TextMode="Password" Width="300px" />
                
                <telerik:RadButton ID="btnRegister" runat="server" Text="Register" 
                    OnClick="btnRegister_Click" Skin="Material" />
            </div>
        </telerik:RadAjaxPanel>
    </div>
</asp:Content>