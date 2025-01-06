unit MainView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Effects,
  FMX.Layouts,
  FMX.Edit, helpers, Components, CreateTaskView, LocalTypes, database_unit;

type
  Tmain_view = class(TForm)

    nav: TRectangle;
    LabelTitle1: TLabel;
    LabelTitle2: TLabel;
    SearchBox: TRectangle;
    ShadowEffect1: TShadowEffect;
    BtnSearch: TRectangle;
    BtnSreachIcon: TImage;
    Rectangle2: TRectangle;
    Image1: TImage;
    Rectangle3: TRectangle;
    Image2: TImage;
    LayoutDate: TLayout;
    LabelDate: TLabel;
    LabelDay: TLabel;
    SideNav: TRectangle;
    SideBarBtnDashboard: TRectangle;
    SideBarBtnDashboardIcon: TImage;
    SideBarBtnDashboardLabel: TLabel;
    EditSearch: TEdit;
    SideBarBtnVitalTask: TRectangle;
    SideBarBtnVitalTaskIcon: TImage;
    SideBarBtnVitalTaskLabel: TLabel;
    LabelEmail: TLabel;
    LabelUsername: TLabel;
    SideBarBtnMyTask: TRectangle;
    SideBarBtnMyTaskIcon: TImage;
    SideBarBtnMyTaskLabel: TLabel;
    SideBarBtnTaskCategories: TRectangle;
    SideBarBtnTaskCategoriesIcon: TImage;
    SideBarBtnTaskCategoriesLabel: TLabel;
    SideBarBtnLogout: TRectangle;
    SideBarBtnLogoutIcon: TImage;
    SideBarBtnLogoutLabel: TLabel;
    RecDashboard: TRectangle;
    ShadowEffect2: TShadowEffect;
    RecHeadTasks: TRectangle;
    ShadowEffect3: TShadowEffect;
    Labelwellcome: TLabel;
    Image3: TImage;
    HeadTaskDate: TLabel;
    Z: TLabel;
    Label4: TLabel;
    Layout1: TLayout;
    Image4: TImage;
    LayHeadTaskAddTask: TLayout;
    Label3: TLabel;
    LayoutHeadTasks: TLayout;
    RecTasksStatus: TRectangle;
    ShadowEffect5: TShadowEffect;
    LayCompletedPBar: TLayout;
    Circle7: TCircle;
    LayCompletedPBarPie: TPie;
    Circle8: TCircle;
    LayCompletedPBarText: TLabel;
    Label12: TLabel;
    LayNotStartedPBar: TLayout;
    Circle9: TCircle;
    LayNotStartedPBarPie: TPie;
    Circle10: TCircle;
    LayNotStartedPBarText: TLabel;
    Label14: TLabel;
    LayInProgressPBar: TLayout;
    Circle11: TCircle;
    LayInProgressPBarPie: TPie;
    Circle12: TCircle;
    LayInProgressPBarText: TLabel;
    Label16: TLabel;
    Layout9: TLayout;
    Image5: TImage;
    Label17: TLabel;
    RecCompletedTask: TRectangle;
    ShadowEffect4: TShadowEffect;
    Layout3: TLayout;
    Image6: TImage;
    Label6: TLabel;
    LayCompletedTask: TLayout;
    Layout2: TLayout;
    HeadTaskAddTaskBtn: TRectangle;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SideBarBtnLogoutClick(Sender: TObject);
    procedure SideBarBtnVitalTaskClick(Sender: TObject);
    procedure SideBarBtnMyTaskClick(Sender: TObject);
    procedure SideBarBtnTaskCategoriesClick(Sender: TObject);
    procedure SideBarBtnDashboardClick(Sender: TObject);
    procedure BtnSearchClick(Sender: TObject);
    procedure HeadTaskAddTaskBtnClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  main_view: Tmain_view;

implementation

uses
  SignInUpView;
{$R *.fmx}

procedure Tmain_view.BtnSearchClick(Sender: TObject);
begin
  CreateTaskForm.Show;

end;

procedure Tmain_view.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Application.Terminate;

end;

procedure Tmain_view.HeadTaskAddTaskBtnClick(Sender: TObject);
begin

  CreateTaskForm.ShowModal;

end;

procedure Tmain_view.SideBarBtnDashboardClick(Sender: TObject);

var
  usertasks: TArray<TTask>;
  error: string;
  Hstart, Hend, user_id: Integer;
  CompeletedtaskStatus, InProgresstaskStatus, NotStartedtaskStatus: Integer;
begin
  CompeletedtaskStatus := database_unit.statusCircleCompleted
    (signin_up_form.DbQuery, signin_up_form.user_id);

  self.LayCompletedPBarPie.EndAngle := CompeletedtaskStatus;
  self.LayCompletedPBarText.text :=
    IntToStr(Round((CompeletedtaskStatus / 360) * 100)) + '%';

  NotStartedtaskStatus := database_unit.statusCircleNotStarted
    (signin_up_form.DbQuery, signin_up_form.user_id);

  self.LayNotStartedPBarPie.EndAngle := NotStartedtaskStatus;
  self.LayNotStartedPBarText.text :=
    IntToStr(Round((NotStartedtaskStatus / 360) * 100)) + '%';

  InProgresstaskStatus := database_unit.statusCircleInProgress
    (signin_up_form.DbQuery, signin_up_form.user_id);

  self.LayInProgressPBarPie.EndAngle := InProgresstaskStatus;
  self.LayInProgressPBarText.text :=
    IntToStr(Round((InProgresstaskStatus / 360) * 100)) + '%';

  self.RecDashboard.Visible := True;
  ResetButtonStyles;
  SetButtonStyle(SideBarBtnDashboard, SideBarBtnDashboardIcon,
    SideBarBtnDashboardLabel, $FFFFFFFF, 'category_icon_2', $FFFF6767);
  user_id := signin_up_form.user_id;
  usertasks := GetUserTasks(signin_up_form.DbQuery, user_id, error);
  if error <> '' then
  begin
    ShowMessage(error);
    Exit;
  end;

  Hend := Length(usertasks);
  if Hend > 2 then
    Hend := 2;

  self.LayoutHeadTasks.DeleteChildren;
  for Hstart := 0 to Hend do
  begin
    CreateHeadTaskCard(self.LayoutHeadTasks, usertasks[Hstart].title,
      usertasks[Hstart].description, IntToStr(usertasks[Hstart].priority),
      IntToStr(usertasks[Hstart].status), usertasks[Hstart].date);
  end;
end;

// begin
//
//

//
// CreateCompletedTaskCard(Self.LayCompletedTask,
// // Parent layout where the card will be added
// 'Attend Nischal�s Birthday Party', // Card title
// 'Buy gifts on the way and pick up cake from the bakery. (6 PM | Fresh Elements).....',
// // Card description
// 'Moderate', // Priority
// '20/06/2023' // Created on date
// );
//
// end;

procedure Tmain_view.SideBarBtnLogoutClick(Sender: TObject);
begin
  ResetButtonStyles;
  SetButtonStyle(SideBarBtnLogout, SideBarBtnLogoutIcon, SideBarBtnLogoutLabel,
    $FFFFFFFF, 'logout_icon2', $FFFF6767);
end;

procedure Tmain_view.SideBarBtnMyTaskClick(Sender: TObject);
begin
  ResetButtonStyles;
  SetButtonStyle(SideBarBtnMyTask, SideBarBtnMyTaskIcon, SideBarBtnMyTaskLabel,
    $FFFFFFFF, 'my_task_icon2', $FFFF6767);
end;

procedure Tmain_view.SideBarBtnTaskCategoriesClick(Sender: TObject);
begin
  ResetButtonStyles;
  SetButtonStyle(SideBarBtnTaskCategories, SideBarBtnTaskCategoriesIcon,
    SideBarBtnTaskCategoriesLabel, $FFFFFFFF, 'task_category_icon1', $FFFF6767);
end;

procedure Tmain_view.SideBarBtnVitalTaskClick(Sender: TObject);
begin
  ResetButtonStyles;
  SetButtonStyle(SideBarBtnVitalTask, SideBarBtnVitalTaskIcon,
    SideBarBtnVitalTaskLabel, $FFFFFFFF, 'vital_task_icon2', $FFFF6767);
end;

end.
