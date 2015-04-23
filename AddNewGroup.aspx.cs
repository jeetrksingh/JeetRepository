using System;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using Thinkgate.Base.Classes;
using Thinkgate.Base.Enums;
using Thinkgate.Classes;
using Thinkgate.Domain;
using Thinkgate.Domain.Classes;

namespace Thinkgate.Dialogues
{
    public partial class AddNewGroup : Page
    {
        private EnvironmentParametersViewModel _environmentParametersViewModel;
        private RolePortal _rolePortalId;
        private bool _canCreatePrivateGroups;
        private bool _canCreatePublicGroups;

        protected void Page_Load(object sender, EventArgs e)
        {
            var session = (SessionObject)Session["SessionObject"];
            SetPermissions(session);
            ValidateSecurity();
            _environmentParametersViewModel = new EnvironmentParametersFactory(AppSettings.ConnectionStringName).GetEnvironmentParameters();
            _rolePortalId = (RolePortal)session.LoggedInUser.Roles.Where(w => w.RolePortalSelection != 0).Min(m => m.RolePortalSelection);

            if (IsPostBack) return;

            txtName.Focus();
            ConfigureGroupAddPermissions();
        }

        private void SetPermissions(SessionObject session)
        {
            _canCreatePrivateGroups = session.LoggedInUser.HasPermission(Permission.Folder_Linking);
            _canCreatePublicGroups = session.LoggedInUser.HasPermission(Permission.Create_Public_Group);
        }

        private void ConfigureGroupAddPermissions()
        {
            rdoPrivate.Enabled = _canCreatePrivateGroups;
            rdoPublic.Enabled = _canCreatePublicGroups;
            chkReadOnly.Enabled = _canCreatePublicGroups;
            lblPublic.Disabled = !_canCreatePublicGroups;
            chkReadOnly.Enabled = false;    // private is chosen as default option, this can't be enabled on first load
        }

        protected bool ValidateSecurity()
        {
            if (!_canCreatePrivateGroups)
            {
                Server.Transfer(@"..\UnauthorizedAccess.aspx");
            }

            return true;
        }

        private TargetType CalculateTarget()
        {
            // if private then nothing else to see/do here
            if (rdoPrivate.Checked)
                return TargetType.Personal;

            // public requires a little calculating based upon the user's role level
            switch (_rolePortalId)
            {
                case RolePortal.District:
                    return TargetType.District;
                case RolePortal.School:
                    return TargetType.School;
                case RolePortal.Teacher:
                    return TargetType.Personal;
                default:
                    throw new Exception(String.Format("The portal type: {0}, was not recognized as a valid portal for creating groups", _rolePortalId));
            }
        }

        private VisibilityType CalculateVisibility()
        {
            if (rdoPrivate.Checked)
                return VisibilityType.Private;

            return chkReadOnly.Checked ? VisibilityType.PublicReadOnly : VisibilityType.Public;
        }

        protected void Save(object sender, EventArgs e)
        {
            if (!Page.IsValid) return;


            var groupViewModel = new GroupViewModel
                {
                    DisplayName = txtName.Text,
                    Description = txtDescription.Text,
                    TargetType = CalculateTarget(),
                    VisibilityType = CalculateVisibility()
                };

            var sessionObject = (SessionObject)Session["SessionObject"];
            var grouping = new Grouping(_environmentParametersViewModel);
            grouping.CreateGroup(groupViewModel, sessionObject.LoggedInUser.School); 

            ScriptManager.RegisterStartupScript(Page, typeof(Page), "closeScript", "CloseDialog('Saved');", true);
        }

        protected void GetDuplicateExists(object source, ServerValidateEventArgs args)
        {
            if (string.IsNullOrWhiteSpace(txtName.Text)) { args.IsValid = true; return; }
            var grouping = new Grouping(_environmentParametersViewModel);
            args.IsValid = !grouping.GetDuplicateExists(txtName.Text);
        }
    }
}