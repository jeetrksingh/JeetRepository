<%@ Page Title="" Language="C#" MasterPageFile="~/Dialogue.Master" AutoEventWireup="true" CodeBehind="AddNewGroup.aspx.cs" Inherits="Thinkgate.Dialogues.AddNewGroup" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script type="text/javascript">
        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow;
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow;
            return oWindow;
        }

        function ToggleReadonly() {
            var rdoPrivate = window.$find('<%= rdoPrivate.ClientID %>');
            var chkReadOnly = window.$find('<%= chkReadOnly.ClientID %>');

            if (rdoPrivate.get_checked() == true) {
                chkReadOnly.set_checked(false);
                chkReadOnly.set_enabled(false);
            } else {
                chkReadOnly.set_enabled(true);
            }
        }

        function CloseDialog(arg) {
            var oWindow = GetRadWindow();
            setTimeout(function () {
                oWindow.Close(arg);
            }, 0);
        }

        function openInfoWindow() {
            window.radopen(null, "infoWindow");
        }
        
        function SaveClicking() {
            if (typeof (window.Page_ClientValidate) == 'function') {
                window.Page_ClientValidate();
            }
            if (window.Page_IsValid)
                ButtonsSetEnabled(false);
        }

        function ButtonsSetEnabled(arg) {
            var btnOk = window.$find('<%= btnOK.ClientID %>');
            var btnCancel = window.$find('<%= btnCancel.ClientID %>');
            btnOk.set_enabled(arg);
            btnCancel.set_enabled(arg);
        }
    </script>
    <style type="text/css">
        #container {
            width: 540px;
            height: 100%;
            margin-left: auto;
            margin-right: auto;
        }

        div.columnLeft {
            float: left;
            width: 100px;
            margin-top: 20px;
        }

        div.columnRight {
            float: right;
            width: 440px;
            margin-top: 20px;
        }

        label.description {
            margin-left: 25px;
            display: inline-block;
        }

        div.buttonGroup {
            float: right;
            margin-right: 20px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <telerik:RadWindowManager ID="RadWindowManager1" runat="server">
        <Windows>
            <telerik:RadWindow ID="infoWindow" runat="server" Title="Group Information" ShowContentDuringLoad="False" Width="400px" Height="400px"
                Behavior="Close" NavigateUrl="GroupOptionsInformation.aspx" ReloadOnShow="True" Modal="True" Skin="Web20" VisibleStatusbar="False">
            </telerik:RadWindow>
        </Windows>
    </telerik:RadWindowManager>
    <telerik:RadAjaxPanel ID="updPanel" runat="server" LoadingPanelID="updPanelLoadingPanel" />
    <div id="container">
        <div class="columnLeft">
            <label>Name:</label>
        </div>
        <div class="columnRight">
            <telerik:RadTextBox runat="server" ID="txtName" TabIndex="1" Width="100%" BorderStyle="Solid" BorderColor="black" BorderWidth="1px" MaxLength="100" />
            <asp:RequiredFieldValidator runat="server" ID="nameValidator" ControlToValidate="txtName" ValidationGroup="main" ErrorMessage="<span style='color: red;'>Group Name is Required</span>" />
            <asp:CustomValidator runat="server" ID="DupeValidator" OnServerValidate="GetDuplicateExists" ControlToValidate="txtName" Display="Dynamic" ValidationGroup="main" ErrorMessage="<span style='color: red;float: left'>This Group Name is already taken - Please choose another</span>" />
        </div>
        <br style="clear: both;" />
        <br />
        <div class="columnLeft">
            <label>Description:</label>
        </div>
        <div class="columnRight">
            <telerik:RadTextBox runat="server" ID="txtDescription" Width="100%" Height="200px" BorderStyle="Solid" BorderColor="black" BorderWidth="1px" TextMode="MultiLine" MaxLength="256" />
        </div>
        <br style="clear: both;" />
        <br />
        <br />
        <div class="columnLeft">
            <telerik:RadButton runat="server" ID="btnInfo" ButtonType="LinkButton" BorderStyle="None" ToolTip="Options" Skin="Web20" OnClientClicked="openInfoWindow" AutoPostBack="False">
                <Icon PrimaryIconUrl="../Images/Toolbars/info.png" PrimaryIconWidth="30px" PrimaryIconHeight="30px"></Icon>
            </telerik:RadButton>
            <label class="inputLabels">Options:</label>
        </div>
        <div class="columnRight">
            <telerik:RadButton runat="server" ID="rdoPrivate" OnClientCheckedChanged="ToggleReadonly" Skin="Web20" Text="Private" ToggleType="Radio" ButtonType="ToggleButton" Checked="True" GroupName="Visibility" AutoPostBack="False" />
            <br />
            <label class="description">Only the user who created the group can view and edit the group.</label>
            <br />
            <br />
            <telerik:RadButton runat="server" ID="rdoPublic" OnClientCheckedChanged="ToggleReadonly" Skin="Web20" Text="Public" ToggleType="Radio" ButtonType="ToggleButton" GroupName="Visibility" AutoPostBack="False" />
            <br />
            <label runat="server" id="lblPublic" class="description">All selected targets can view the group.  Targets may move students, which they have access to, in and out of the group, only if the group is not marked Read-Only.</label>
            <br />
            <br />
            <div>
                <telerik:RadButton runat="server" Skin="Web20" ToggleType="CheckBox" ID="chkReadOnly" ButtonType="ToggleButton" Text="Read-Only" AutoPostBack="False" />
            </div>
        </div>
        <div style="clear: both;" />
        <br />
        <br />
        <div class="buttonGroup">
            <telerik:RadButton Skin="Web20" runat="server" ID="btnCancel" Text="Cancel" AutoPostBack="False" OnClientClicked="CloseDialog" />
            <telerik:RadButton Skin="Web20" runat="server" ID="btnOK" Text="OK" OnClick="Save" AutoPostBack="True" OnClientClicking="SaveClicking" CausesValidation="True" ValidationGroup="main" />
        </div>
    </div>
    <asp:HiddenField runat="server" ID="hdnTargetType" />


</asp:Content>
