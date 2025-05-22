<%@ Page Title="Dashboard" MasterPageFile="~/MasterPage.master" Language="C#"
    AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs"
     Inherits="Payments.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="radGridTransactions">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="radGridTransactions" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>

    <div class="dashboard-container">
        <asp:Panel ID="kpiContainer" runat="server">
            <div class="kpi-tiles">
                <div class="kpi-card" style="border-left: 4px solid #3f51b5;">
                    <div class="kpi-title">Total Transactions</div>
                    <div class="kpi-value"><%= TotalTransactions.ToString("N0") %></div>
                </div>

                <div class="kpi-card" style="border-left: 4px solid #4CAF50;">
                    <div class="kpi-title">Success Rate</div>
                    <div class="kpi-value"><%= SuccessRate.ToString("P1") %></div>
                </div>

                <div class="kpi-card" style="border-left: 4px solid #2196F3;">
                    <div class="kpi-title">Total Amount</div>
                    <div class="kpi-value"><%= TotalAmount.ToString("C") %></div>
                </div>
            </div>
        </asp:Panel>

        <telerik:RadGrid ID="radGridTransactions" runat="server" OnItemDataBound="radGridTransactions_ItemDataBound"
            OnNeedDataSource="radGridTransactions_NeedDataSource"
            OnInsertCommand="radGridTransactions_InsertCommand"
            OnUpdateCommand="radGridTransactions_UpdateCommand"
            OnItemCommand="radGridTransactions_ItemCommand">

            <MasterTableView
                AutoGenerateColumns="False"
                CommandItemDisplay="Top"
                DataKeyNames="TransactionID"
                InsertItemDisplay="Bottom"
                EditMode="InPlace">

                <CommandItemSettings
                    ShowAddNewRecordButton="true"
                    AddNewRecordText="New Transaction"
                    ShowRefreshButton="true"
                    ShowExportToExcelButton="true" />

                <EditFormSettings>
                    <PopUpSettings Modal="true" Width="600px" />
                </EditFormSettings>

                <Columns>
                    <telerik:GridEditCommandColumn
                        UniqueName="EditCommandColumn"
                        ButtonType="ImageButton"
                        EditText="Edit"
                        InsertText="Add"
                        UpdateText="Save"
                        CancelText="Cancel">
                    </telerik:GridEditCommandColumn>
                    <telerik:GridTemplateColumn DataField="TransactionDate" HeaderText="Date"
                        DataType="System.DateTime" UniqueName="TransactionDate"
                        FilterControlWidth="160px">
                        <ItemTemplate>
                            <%# Eval("TransactionDate", "{0:dd-MMM-yyyy HH:mm}") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadDateTimePicker ID="dtpTransactionDate" runat="server"
                                SelectedDate='<%# Eval("TransactionDate") as DateTime? %>'
                                DateInput-DateFormat="dd-MMM-yyyy HH:mm" />

                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="Reference" HeaderText="Reference ID"
                        UniqueName="Reference" ReadOnly="true">
                        <ItemTemplate>
                            <%# Eval("Reference") %>
                        </ItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="Amount" HeaderText="Amount"
                        DataType="System.Decimal" UniqueName="Amount">
                        <ItemTemplate>
                            <%# Eval("Amount", "{0:C}") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                             <telerik:RadNumericTextBox RenderMode="Lightweight" DbValue='<%# Bind("Amount") %>' ID="txtAmount"
	                            runat="server">
	                        </telerik:RadNumericTextBox>
  
</EditItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn DataField="Description" HeaderText="Description"
                        UniqueName="Description">
                        <ItemTemplate>
                            <%# Eval("Description") %>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadTextBox ID="txtDescription" runat="server"
                                Text='<%# Bind("Description") %>'
                                Width="100%" />
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>

                    <telerik:GridTemplateColumn HeaderText="Status" UniqueName="Status"
                        AllowFiltering="true">
                        <ItemTemplate>
                            <span class="status-badge status-<%# Eval("Status").ToString().ToLower() %>">
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                        <EditItemTemplate>
                            <telerik:RadComboBox ID="cmbStatus" runat="server"
                                SelectedValue='<%# Bind("Status") %>'>
                                <Items>
                                    <telerik:RadComboBoxItem Text="Pending" Value="Pending" Selected="true" />
                                    <telerik:RadComboBoxItem Text="Success" Value="Success" />
                                    <telerik:RadComboBoxItem Text="Failed" Value="Failed" />
                                </Items>
                            </telerik:RadComboBox>
                        </EditItemTemplate>
                    </telerik:GridTemplateColumn>


                    <telerik:GridButtonColumn CommandName="Delete" ButtonType="ImageButton" UniqueName="DeleteColumn" />
                </Columns>

                <EditFormSettings>
                    <PopUpSettings Modal="true" Width="600px" />
                </EditFormSettings>
            </MasterTableView>

            <ClientSettings>
                <Scrolling AllowScroll="True" UseStaticHeaders="True" />
            </ClientSettings>
        </telerik:RadGrid>
    </div>
</asp:Content>
