unit CreateTaskView;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Objects, FMX.Controls.Presentation, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo, database_unit, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.Phys.SQLite, FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TCreateTaskForm = class(TForm)
    Label1: TLabel;
    Line1: TLine;
    RecAddTask: TRectangle;
    Rectangle1: TRectangle;
    EditCreateTaskTitle: TEdit;
    EditCreateTaskRadioModerate: TRadioButton;
    Label3: TLabel;
    Label4: TLabel;
    Rectangle2: TRectangle;
    EditCreateTaskDate: TEdit;
    Image1: TImage;
    Label5: TLabel;
    EditCreateTaskRadioExtreme: TRadioButton;
    EditCreateTaskRadioLow: TRadioButton;
    Label6: TLabel;
    Rectangle3: TRectangle;
    Memo1: TMemo;
    StyleBook1: TStyleBook;
    CreateTaskBtn: TRectangle;
    Label7: TLabel;
    Rectangle5: TRectangle;
    user_id: TLabel;
    DbConnection: TFDConnection;
    DbQuery: TFDQuery;
    procedure Memo1Enter(Sender: TObject);
    procedure Memo1Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CreateTaskBtnClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  CreateTaskForm: TCreateTaskForm;

implementation

uses
  SignInUpView;
{$R *.fmx}

procedure TCreateTaskForm.CreateTaskBtnClick(Sender: TObject);
var
  title, description, date, Error: string;
  priority, status: Integer;
begin
  title := self.EditCreateTaskTitle.Text;
  description := self.Memo1.Text;
  date := self.EditCreateTaskDate.Text;

  if title = '' then
  begin
    ShowMessage('Please enter a title for the task.');
    Exit;
  end;

  if description = '' then
  begin
    ShowMessage('Please enter a description for the task.');
    Exit;
  end;

  if date = '' then
  begin
    ShowMessage('Please enter a date for the task.');
    Exit;
  end;

  if self.EditCreateTaskRadioLow.IsChecked then
    priority := 1
  else if self.EditCreateTaskRadioModerate.IsChecked then
    priority := 2
  else if self.EditCreateTaskRadioExtreme.IsChecked then
    priority := 3
  else
  begin
    ShowMessage('Please select a priority for the task.');
    Exit;
  end;


  status := 1;
  database_unit.CreateTask(signin_up_form.DbQuery, title, date, description, priority, signin_up_form.user_id,
    status, Error);
  if Error = '' then
    ShowMessage('Task created successfully!')
  else
    ShowMessage('Failed to create task: ' + Error);

end;

procedure TCreateTaskForm.FormCreate(Sender: TObject);
begin
  Memo1.Text := 'Start writing here.....';
  Memo1.StyledSettings := [];
  Memo1.TextSettings.FontColor := TAlphaColorRec.Gray;
end;

procedure TCreateTaskForm.Memo1Enter(Sender: TObject);
begin
  if Memo1.Text = 'Start writing here.....' then
  begin
    Memo1.Text := '';
    Memo1.StyledSettings := [];
    Memo1.TextSettings.FontColor := TAlphaColorRec.Black;
  end;
end;

procedure TCreateTaskForm.Memo1Exit(Sender: TObject);
begin
  if Memo1.Text = '' then
  begin
    Memo1.Text := 'Start writing here.....';
    Memo1.StyledSettings := [];
    Memo1.TextSettings.FontColor := TAlphaColorRec.Gray;
  end;
end;

end.
