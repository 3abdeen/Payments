<%@ Page Title="New Transaction" MasterPageFile="~/MasterPage.master" Language="C#"
    AutoEventWireup="true" CodeBehind="CreateTransaction.aspx.cs"
    Inherits="Payments.CreateTransaction" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container">
        <telerik:RadAjaxPanel ID="RadAjaxPanel1" runat="server" LoadingPanelID="RadAjaxLoadingPanel1">
            <div class="transaction-form">
                <h2>New Payment Transaction</h2>

                <div class="form-group">
                    <telerik:RadTextBox ID="txtReference" runat="server" Skin="Material"
                        Label="Reference Number:" MaxLength="50" Width="100%" />
                    <asp:RequiredFieldValidator ControlToValidate="txtReference"
                        ErrorMessage="Reference number is required"
                        CssClass="validator-error" runat="server" Display="Dynamic" />
                </div>

                <div class="form-group">
                    <telerik:RadNumericTextBox ID="txtAmount" runat="server" Skin="Material"
                        Label="Amount:" NumberFormat-DecimalDigits="2" MinValue="0.01"
                        MaxValue="1000000" Width="200px" CssClass="amount-input">
                        <NumberFormat GroupSeparator="," DecimalSeparator="." />
                    </telerik:RadNumericTextBox>
                    <asp:RequiredFieldValidator ControlToValidate="txtAmount"
                        ErrorMessage="Amount is required"
                        CssClass="validator-error" runat="server" Display="Dynamic" />
                    <asp:CompareValidator ControlToValidate="txtAmount" Operator="GreaterThan"
                        ValueToCompare="0" Type="Currency"
                        ErrorMessage="Amount must be greater than 0"
                        CssClass="validator-error" runat="server" Display="Dynamic" />
                </div>

                <div class="form-group">
                    <telerik:RadComboBox ID="cmbCurrency" runat="server" Skin="Material"
                        Label="Currency:"
                        CssClass="currency-selector">
                        <Items>
                            <telerik:RadComboBoxItem runat="server" Text="EGP" />
                        </Items>
                    </telerik:RadComboBox>
                    <asp:RequiredFieldValidator ControlToValidate="cmbCurrency"
                        ErrorMessage="Currency selection is required"
                        CssClass="validator-error" runat="server" Display="Dynamic" />
                </div>

                <div class="form-group">
                    <telerik:RadTextBox ID="txtDescription" runat="server" Skin="Material"
                        Label="Description:" TextMode="MultiLine" Rows="3" Width="100%" />
                    <asp:RequiredFieldValidator ControlToValidate="txtDescription"
                        ErrorMessage="Description is required"
                        CssClass="validator-error" runat="server" Display="Dynamic" />
                </div>

                <div class="form-actions">
                    <telerik:RadButton ID="btnCancel" runat="server" Text="Cancel"
                        Skin="Material" ButtonType="LinkButton" CausesValidation="false"
                        OnClick="btnCancel_Click" />

                    <telerik:RadButton ID="btnSubmit" runat="server" Text="Process Payment"
                        Skin="Material" Primary="true" OnClick="btnSubmit_Click" />
                </div>
            </div>
        </telerik:RadAjaxPanel>
    </div>
</asp:Content>
