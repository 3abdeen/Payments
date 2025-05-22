<%@ Page Title="Transaction History" MasterPageFile="~/MasterPage.master" Language="C#"
    AutoEventWireup="true" CodeBehind="TransactionHistory.aspx.cs"
    Inherits="Payments.TransactionHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadAjaxManager ID="RadAjaxManager1" runat="server">
        <AjaxSettings>
            <telerik:AjaxSetting AjaxControlID="radGridHistory">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="radGridHistory" />
                </UpdatedControls>
            </telerik:AjaxSetting>
            <telerik:AjaxSetting AjaxControlID="btnFilter">
                <UpdatedControls>
                    <telerik:AjaxUpdatedControl ControlID="radGridHistory" />
                </UpdatedControls>
            </telerik:AjaxSetting>
        </AjaxSettings>
    </telerik:RadAjaxManager>

    <div class="history-container">
        <div class="filter-panel">
            <telerik:RadDatePicker ID="dateFrom" runat="server" Skin="Material"
                DateInput-Label="From Date:" Width="200px" />
            <telerik:RadDatePicker ID="dateTo" runat="server" Skin="Material"
                DateInput-Label="To Date:" Width="200px" />
            <telerik:RadButton ID="btnFilter" runat="server" Text="Apply Filter"
                Skin="Material" OnClick="btnFilter_Click" />
        </div>

        <telerik:RadGrid ID="radGridHistory" runat="server" Skin="Material"
            AllowPaging="True" PageSize="15" AllowSorting="True"
            AllowFilteringByColumn="True" OnNeedDataSource="radGridHistory_NeedDataSource"
            OnItemDataBound="radGridHistory_ItemDataBound">
            <ExportSettings ExportOnlyData="true" IgnorePaging="true">
                <Excel Format="Xlsx" />
            </ExportSettings>
            <MasterTableView AutoGenerateColumns="False" CommandItemDisplay="Top" DataKeyNames="TransactionID">
                <CommandItemSettings ShowExportToExcelButton="true" ShowAddNewRecordButton="false" />
                <Columns>
                    <telerik:GridDateTimeColumn DataField="TransactionDate" HeaderText="Date"
                        DataFormatString="{0:dd-MMM-yyyy HH:mm}" FilterControlWidth="160px" />
                    <telerik:GridNumericColumn DataField="Amount" HeaderText="Amount"
                        DataFormatString="{0:C}" FilterControlWidth="100px" />
                    <telerik:GridBoundColumn DataField="Description" HeaderText="Description" />
                    <telerik:GridBoundColumn DataField="Reference" HeaderText="Reference ID" />
                    <telerik:GridTemplateColumn HeaderText="Status" UniqueName="Status"
                        AllowFiltering="true">
                        <ItemTemplate>
                            <span class="status-badge status-<%# Eval("Status").ToString().ToLower() %>">
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                        <FilterTemplate>
                            <telerik:RadComboBox ID="StatusFilterComboBox" runat="server"
                                SelectedValue='<%# ((GridItem)Container).OwnerTableView.GetColumn("Status").CurrentFilterValue %>'>
                                <Items>
                                    <telerik:RadComboBoxItem Text="All" Value="" />
                                    <telerik:RadComboBoxItem Text="Success" Value="Success" />
                                    <telerik:RadComboBoxItem Text="Pending" Value="Pending" />
                                    <telerik:RadComboBoxItem Text="Failed" Value="Failed" />
                                </Items>
                            </telerik:RadComboBox>
                        </FilterTemplate>
                    </telerik:GridTemplateColumn>
                </Columns>
            </MasterTableView>
            <PagerStyle Mode="NextPrevAndNumeric" />
        </telerik:RadGrid>
    </div>
</asp:Content>
