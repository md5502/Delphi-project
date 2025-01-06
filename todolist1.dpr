program todolist1;



{$R *.dres}

uses
  System.StartUpCopy,
  FMX.Forms,
  SignInUpView in 'views\SignInUpView.pas' {signin_up_form},
  MainView in 'views\MainView.pas' {main_view},
  signin_up_logic in 'logic\signin_up_logic.pas',
  helpers in 'helpers.pas',
  Components in 'Components_units\Components.pas',
  database_unit in 'logic\database_unit.pas',
  CreateTaskView in 'views\CreateTaskView.pas' {CreateTaskForm},
  LocalTypes in 'logic\LocalTypes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tsignin_up_form, signin_up_form);
  Application.CreateForm(Tmain_view, main_view);
  Application.CreateForm(TCreateTaskForm, CreateTaskForm);
  Application.Run;
end.
