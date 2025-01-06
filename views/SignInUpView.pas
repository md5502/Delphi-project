unit SignInUpView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Layouts, FMX.Objects, FMX.Edit,
  FMX.Effects, FMX.Ani, Data.DbxSqlite, Data.FMTBcd, Data.DB, Data.SqlExpr,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, MainView, signin_up_logic, database_unit,
  LocalTypes, FMX.Menus;

type
  Tsignin_up_form = class(TForm)
    closeBtn: TRectangle;
    closeBtnLabel: TLabel;
    minimizeBtn: TRectangle;
    minimizeBtnLabel: TLabel;
    applicationCaptionLabel: TLabel;
    appLogo: TImage;
    RecMain: TRectangle;
    RecOver: TRectangle;
    RecSignin: TRectangle;
    LabelTitle_signin: TLabel;
    RecInputPassword_signin: TRectangle;
    EditPassowrd_signin: TEdit;
    RecInputUsername_signin: TRectangle;
    EditUsername_signin: TEdit;
    PasswordShowHideIcon_signin: TImage;
    LayTopControls: TLayout;
    RecBtn_signin: TRectangle;
    Label2: TLabel;
    TitleLabel: TLabel;
    TitleCaptionLabel: TLabel;
    RoundRecOverBtn: TRoundRect;
    OverBoxShadowEfect: TShadowEffect;
    ChnageBtnLabel: TLabel;
    SigninShadowEfect: TShadowEffect;
    SigninShadowadminationIn: TFloatAnimation;
    SigninShadowadminationOut: TFloatAnimation;
    OverBoxBtnShadowadminationIn: TFloatAnimation;
    OverBoxBtnShadowadminationOut: TFloatAnimation;
    RecSignup: TRectangle;
    RecInputUsername_signup: TRectangle;
    EditUsername_signup: TEdit;
    RecInputPassword_signup: TRectangle;
    EditPassword_signup: TEdit;
    PasswordShowHideIcon_signup: TImage;
    LabelTitle_signup: TLabel;
    RecBtn_signup: TRectangle;
    Label7: TLabel;
    SignupShadowEfect: TShadowEffect;
    RecInputPasswordConfirm_signup: TRectangle;
    EditPasswordConfirm_signup: TEdit;
    PasswordConfirmShowHideIcon_signup: TImage;
    MoveOverBoxAnimation: TFloatAnimation;
    ChangeCaptionOpacityAnimation: TFloatAnimation;
    RecTopControls: TRectangle;
    SignupShadowadminationIn: TFloatAnimation;
    SignupShadowadminationOut: TFloatAnimation;
    MainShadowEffect: TShadowEffect;
    ShadowEffect1: TShadowEffect;
    ErorrLabel_signup: TLabel;
    ErorrLabel_signin: TLabel;
    DbConnection: TFDConnection;
    DbQuery: TFDQuery;
    procedure closeBtnClick(Sender: TObject);
    procedure closeBtnMouseEnter(Sender: TObject);
    procedure closeBtnMouseLeave(Sender: TObject);
    procedure minimizeBtnMouseEnter(Sender: TObject);
    procedure minimizeBtnMouseLeave(Sender: TObject);
    procedure minimizeBtnClick(Sender: TObject);
    procedure RecTopControlsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure RecTopControlsMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Single);
    procedure RecTopControlsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormCreate(Sender: TObject);
    procedure RecBtn_signinMouseEnter(Sender: TObject);
    procedure RecBtn_signinMouseLeave(Sender: TObject);
    procedure RoundRecOverBtnMouseEnter(Sender: TObject);
    procedure RoundRecOverBtnMouseLeave(Sender: TObject);
    procedure PasswordShowHideIcon_signinClick(Sender: TObject);
    procedure RoundRecOverBtnClick(Sender: TObject);
    procedure MoveOverBoxAnimationFinish(Sender: TObject);
    procedure PasswordShowHideIcon_signupClick(Sender: TObject);
    procedure PasswordConfirmShowHideIcon_signupClick(Sender: TObject);
    procedure RecBtn_signupMouseEnter(Sender: TObject);
    procedure RecBtn_signupMouseLeave(Sender: TObject);
    procedure RecBtn_signupClick(Sender: TObject);
    procedure RecBtn_signinClick(Sender: TObject);

  private
    { Private declarations }

    FDragging: Boolean;
    FMouseX, FMouseY: Single;
    show_hide_icon_file_name_signin: string;
    show_hide_icon_file_name_signup: string;
    show_hide_icon_file_name_confirm_signup: string;
  public
    { Public declarations }
    user_id: Integer;
    user_username: string;
  end;

var
  signin_up_form: Tsignin_up_form;

implementation

{$R *.fmx}

procedure Tsignin_up_form.closeBtnClick(Sender: TObject);
begin
  Close;
end;

procedure Tsignin_up_form.closeBtnMouseEnter(Sender: TObject);
begin
  self.closeBtn.Fill.Kind := TBrushKind.Solid;
  self.closeBtn.Fill.Color := TAlphaColors.Red;
  self.closeBtnLabel.TextSettings.FontColor := TAlphaColors.White;

end;

procedure Tsignin_up_form.closeBtnMouseLeave(Sender: TObject);
begin
  self.closeBtn.Fill.Kind := TBrushKind.None;
  self.closeBtnLabel.TextSettings.FontColor := TAlphaColors.Black;

end;

procedure Tsignin_up_form.FormCreate(Sender: TObject);

var
  ResStream: TResourceStream;

begin
  try
    show_hide_icon_file_name_signin := 'password_show_icon';
    show_hide_icon_file_name_signup := 'password_show_icon';
    show_hide_icon_file_name_confirm_signup := 'password_show_icon';
    ResStream := TResourceStream.Create(HInstance,
      show_hide_icon_file_name_signin, RT_RCDATA);
    ConnectToDb('Database', DbConnection);
    try
      PasswordShowHideIcon_signin.Bitmap.LoadFromStream(ResStream)
    finally
      ResStream.Free;

    end;
  except
    on E: Exception do
      ShowMessage('Exception raised with message: ' + E.Message);
  end;
end;

procedure Tsignin_up_form.minimizeBtnClick(Sender: TObject);
begin
  WindowState := TWindowState.wsMinimized;
end;

procedure Tsignin_up_form.minimizeBtnMouseEnter(Sender: TObject);
begin
  self.minimizeBtn.Fill.Color := TAlphaColors.Gray;
  self.minimizeBtn.Fill.Kind := TBrushKind.Solid;
  self.minimizeBtnLabel.TextSettings.FontColor := TAlphaColors.White;
end;

procedure Tsignin_up_form.minimizeBtnMouseLeave(Sender: TObject);
begin

  self.minimizeBtn.Fill.Kind := TBrushKind.None;
  self.minimizeBtnLabel.TextSettings.FontColor := TAlphaColors.Black;

end;

procedure Tsignin_up_form.MoveOverBoxAnimationFinish(Sender: TObject);
begin
  if self.RecOver.Position.X = 0 then
  begin
    self.TitleLabel.text := 'Todo Manager';
    self.ChnageBtnLabel.text := 'Already have an account! Sign In';
    self.applicationCaptionLabel.text := 'Todo Manager Sign Up';
  end;
  if self.RecOver.Position.X = 450 then
  begin
    self.TitleLabel.text := 'Welcome back!';
    self.ChnageBtnLabel.text := 'No account yet ? Sign up';
    self.applicationCaptionLabel.text := 'Todo Manager Sign In';
  end;

end;

procedure Tsignin_up_form.PasswordConfirmShowHideIcon_signupClick
  (Sender: TObject);
begin
  TogglePasswordVisibility(EditPasswordConfirm_signup,
    PasswordConfirmShowHideIcon_signup,
    show_hide_icon_file_name_confirm_signup);
end;

procedure Tsignin_up_form.PasswordShowHideIcon_signinClick(Sender: TObject);

begin
  TogglePasswordVisibility(EditPassowrd_signin, PasswordShowHideIcon_signin,
    show_hide_icon_file_name_signin);
end;

procedure Tsignin_up_form.PasswordShowHideIcon_signupClick(Sender: TObject);

begin
  TogglePasswordVisibility(EditPassword_signup, PasswordShowHideIcon_signup,
    show_hide_icon_file_name_signup);
end;

procedure Tsignin_up_form.RecBtn_signinClick(Sender: TObject);
var
  username, password, erorr: string;
  user: TUser;
begin
  if EditUsername_signin.text = '' then
  begin
    ErorrLabel_signin.text := 'You have to enter your Username';
    exit;
  end;
  if EditPassowrd_signin.text = '' then
  begin
    ErorrLabel_signin.text := 'You have to enter your Password';
    exit;
  end;
  username := EditUsername_signin.text;
  password := EditPassowrd_signin.text;
  user := LoginUser(DbQuery, username, password, erorr);
  if user.id <> 0 then
  begin
    user_id := user.id;
    user_username := user.username;
    main_view.Labelwellcome.text := 'Welcome back,' + user_username;
    main_view.LabelUsername.text := user_username;
    main_view.Show;
    self.Hide;
  end
  else
  begin
    ErorrLabel_signin.TextSettings.FontColor := TAlphaColors.Red;
    ErorrLabel_signin.text := erorr;
    self.EditUsername_signin.text := '';
    self.EditPassowrd_signin.text := '';
  end;
end;

procedure Tsignin_up_form.RecBtn_signinMouseEnter(Sender: TObject);
begin

  self.SigninShadowadminationIn.start;
end;

procedure Tsignin_up_form.RecBtn_signinMouseLeave(Sender: TObject);
begin

  self.SigninShadowadminationOut.start;

end;

procedure Tsignin_up_form.RecBtn_signupClick(Sender: TObject);
var
  username, password, erorr: string;
  isSuccess: Boolean;
begin
  if self.EditUsername_signup.text = '' then
  begin
    self.ErorrLabel_signup.text := 'You have to enter the Username';
    exit;
  end;
  if self.EditPassword_signup.text = '' then
  begin
    self.ErorrLabel_signup.text := 'You have to enter the password';
    exit;
  end;
  if self.EditPasswordConfirm_signup.text = '' then
  begin
    self.ErorrLabel_signup.text := 'You have to enter the Confirm password';
    exit;
  end;
  if self.EditPassword_signup.text <> self.EditPasswordConfirm_signup.text then
  begin
    self.ErorrLabel_signup.text :=
      'Password and Password confirm must be equal';
    exit;
  end;
  username := self.EditUsername_signup.text;
  password := self.EditPassword_signup.text;

  isSuccess := CreateUser(DbQuery, username, password, erorr);
  if isSuccess then
  begin
    self.RecOver.Corners := [TCorner.TopLeft, TCorner.BottomLeft];
    self.MoveOverBoxAnimation.StartValue := 0;
    self.MoveOverBoxAnimation.StopValue := 450;
    self.MoveOverBoxAnimation.start;
    self.ErorrLabel_signin.TextSettings.FontColor := TAlphaColors.Black;
    self.ErorrLabel_signin.text :=
      'Account created successfully you may login now :)'

  end
  else
  begin
    self.ErorrLabel_signup.text := erorr;
    exit;
  end;

end;

procedure Tsignin_up_form.RecBtn_signupMouseEnter(Sender: TObject);
begin
  self.SignupShadowadminationIn.start;
end;

procedure Tsignin_up_form.RecBtn_signupMouseLeave(Sender: TObject);
begin
  self.SignupShadowadminationOut.start;
end;

procedure Tsignin_up_form.RecTopControlsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Button = TMouseButton.mbLeft then
  begin
    FDragging := true;
    FMouseX := X;
    FMouseY := Y;
  end;
end;

procedure Tsignin_up_form.RecTopControlsMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Single);
var
  DeltaX, DeltaY: Integer;
begin
  if FDragging then
  begin
    DeltaX := Round(X - FMouseX);
    DeltaY := Round(Y - FMouseY);
    Left := Left + DeltaX;
    Top := Top + DeltaY;
  end;
end;

procedure Tsignin_up_form.RecTopControlsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
  if Button = TMouseButton.mbLeft then
  begin
    FDragging := False;
  end;
end;

procedure Tsignin_up_form.RoundRecOverBtnClick(Sender: TObject);
var
  ResStream: TResourceStream;
begin

  if self.RecOver.Position.X = 0 then
  begin
    self.RecOver.Corners := [TCorner.TopLeft, TCorner.BottomLeft];
    self.MoveOverBoxAnimation.StartValue := 0;
    self.MoveOverBoxAnimation.StopValue := 450;
    self.MoveOverBoxAnimation.start;
  end;
  if self.RecOver.Position.X = 450 then
  begin
    self.RecOver.Corners := [TCorner.TopRight, TCorner.BottomRight];
    self.MoveOverBoxAnimation.StartValue := 450;
    self.MoveOverBoxAnimation.StopValue := 0;
    self.MoveOverBoxAnimation.start;
    try
      show_hide_icon_file_name_signin := 'password_show_icon';
      ResStream := TResourceStream.Create(HInstance,
        show_hide_icon_file_name_signin, RT_RCDATA);
      try
        PasswordShowHideIcon_signup.Bitmap.LoadFromStream(ResStream);
        PasswordConfirmShowHideIcon_signup.Bitmap.LoadFromStream(ResStream);
      finally
        ResStream.Free;
      end;
    except
      on E: Exception do
        ShowMessage('Exception raised with message: ' + E.Message);
    end;
  end;

end;

procedure Tsignin_up_form.RoundRecOverBtnMouseEnter(Sender: TObject);
begin
  self.OverBoxBtnShadowadminationIn.start;
end;

procedure Tsignin_up_form.RoundRecOverBtnMouseLeave(Sender: TObject);
begin
  self.OverBoxBtnShadowadminationOut.start;
end;

end.
