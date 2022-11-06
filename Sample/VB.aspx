<%@ Page Language="VB" AutoEventWireup="false" CodeFile="VB.aspx.vb" Inherits="VB" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        body { font-family: Arial; font-size: 10pt; }
        .Pager span { text-align: center; color: #999; display: inline-block; width: 20px; background-color: #A1DCF2; margin-right: 3px; line-height: 150%; border: 1px solid #3AC0F2; }
        .Pager a { text-align: center; display: inline-block; width: 20px; background-color: #3AC0F2; color: #fff; border: 1px solid #3AC0F2; margin-right: 3px; line-height: 150%; text-decoration: none; }
        table { border: 1px solid #ccc; border-collapse: collapse; }
        table th { background-color: #F7F7F7; color: #333; font-weight: bold; }
        table th, table td { padding: 5px; border: 1px solid #ccc; width: 150px; }
    </style>
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script src="ASPSnippets_Pager.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            GetCustomers(1);
        });
        $(".Pager .page").live("click", function () {
            GetCustomers(parseInt($(this).attr('page')));
        });
        function GetCustomers(pageIndex) {
            $.ajax({
                type: "POST",
                url: "VB.aspx/GetCustomers",
                data: '{pageIndex: ' + pageIndex + '}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: OnSuccess,
                failure: function (response) {
                    alert(response.responseText);
                },
                error: function (response) {
                    alert(response.responseText);
                }
            });
        }

        function OnSuccess(response) {
            var xmlDoc = $.parseXML(response.d);
            var xml = $(xmlDoc);
            var customers = xml.find("Customers");
            var row = $("[id*=gvCustomers] tr:last-child").clone(true);
            $("[id*=gvCustomers] tr").not($("[id*=gvCustomers] tr:first-child")).remove();
            $.each(customers, function () {
                $("td", row).eq(0).html($(this).find("CustomerID").text());
                $("td", row).eq(1).html($(this).find("ContactName").text());
                $("td", row).eq(2).html($(this).find("City").text());
                $("[id*=gvCustomers]").append(row);
                row = $("[id*=gvCustomers] tr:last-child").clone(true);
            });
            var pager = xml.find("Pager");
            $(".Pager").ASPSnippets_Pager({
                ActiveCssClass: "current",
                PagerCssClass: "pager",
                PageIndex: parseInt(pager.find("PageIndex").text()),
                PageSize: parseInt(pager.find("PageSize").text()),
                RecordCount: parseInt(pager.find("RecordCount").text())
            });
        };
    </script>
</head>
<body>
    <form id="form1" runat="server">
        <asp:GridView ID="gvCustomers" runat="server" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="CustomerID" HeaderText="CustomerID" />
                <asp:BoundField DataField="ContactName" HeaderText="Contact Name" />
                <asp:BoundField DataField="City" HeaderText="City" />
            </Columns>
        </asp:GridView>
        <br />
        <div class="Pager"></div>
    </form>
</body>
</html>
