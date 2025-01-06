unit database_unit;

interface

uses
  FireDAC.Comp.Client, System.Classes, System.SysUtils, System.Types, Data.DB,
  FMX.Dialogs, FMX.Edit, FMX.Objects, RegularExpressions,
  System.Hash, LocalTypes;

procedure ConnectToDb(const dbname: string; var dbconnection: TFDConnection);

function CreateUser(const query: TFDQuery; var username, password: string;
  out ErrorMessage: string): Boolean;

function ValidatePassword(const password: string;
  out ErrorMessage: string): Boolean;

function HashPassword(const password: string): string;

function CheckPassword(const password, HashedPassword: string): Boolean;

function LoginUser(const query: TFDQuery; var username, password: string;
  out ErrorMessage: string): TUser;

function DeleteTask(const query: TFDQuery; var id: Integer;
  out ErrorMessage: string): Boolean;

function CompleteTask(const query: TFDQuery; var id: Integer;
  out ErrorMessage: string): Boolean;

function UpdateTask(const query: TFDQuery; var id: Integer;
  var title, date, description: string; var priority, user_id, status: Integer;
  out ErrorMessage: string): Boolean;

function CreateTask(const query: TFDQuery; var title, date, description: string;
  var priority, user_id, status: Integer; out ErrorMessage: string): Boolean;

function GetUserTasks(const query: TFDQuery; var user_id: Integer;
  out ErrorMessage: string): TArray<TTask>;

function statusCircleCompleted(const query: TFDQuery;
  var user_id: Integer): Integer;
function statusCircleInProgress(const query: TFDQuery;
  var user_id: Integer): Integer;
function statusCircleNotStarted(const query: TFDQuery;
  var user_id: Integer): Integer;

implementation

const
  solt = 'bBMM3zOiCXkOVsJGOcph';

function ValidatePassword(const password: string;
  out ErrorMessage: string): Boolean;
const
  MinPasswordLength = 4;
begin
  if Length(password) < MinPasswordLength then
  begin
    ErrorMessage := 'Password must be at least ' + IntToStr(MinPasswordLength) +
      ' characters long';
    Exit(False);
  end;

  // if not TRegEx.IsMatch(password, '[A-Z]') then
  // begin
  // ErrorMessage := 'Password must contain at least one uppercase letter';
  // Exit(False);
  // end;

  // if not TRegEx.IsMatch(password, '[a-z]') then
  // begin
  // ErrorMessage := 'Password must contain at least one lowercase letter';
  // Exit(False);
  // end;

  if not TRegEx.IsMatch(password, '\d') then
  begin
    ErrorMessage := 'Password must contain at least one number';
    Exit(False);
  end;

  ErrorMessage := '';
  Result := True;
end;

function HashPassword(const password: string): string;
begin
  Result := THashSHA2.GetHashString(solt + password);
end;

function CheckPassword(const password, HashedPassword: string): Boolean;
begin

  Result := HashPassword(password) = HashedPassword;
end;

procedure ConnectToDb(const dbname: string; var dbconnection: TFDConnection);
var
  ResStream: TResourceStream;
  DBfile: string;
  FileStream: TFileStream;
begin
  DBfile := ExtractFilePath(ParamStr(0)) + dbname + '.db';
  if not FileExists(DBfile) then
  begin
    ResStream := TResourceStream.Create(HInstance, dbname, RT_RCDATA);
    try
      FileStream := TFileStream.Create(DBfile, fmCreate);
      try
        FileStream.CopyFrom(ResStream, ResStream.Size);
      finally
        FileStream.Free;
      end;
    finally
      ResStream.Free;
    end;
  end;

  dbconnection.Params.Values['Database'] := DBfile;
  dbconnection.LoginPrompt := False;
  try
    dbconnection.Connected := True;
  except
    on E: EDatabaseError do
      ShowMessage('Exception raised with message' + E.Message);
  end;
end;

function CreateUser(const query: TFDQuery; var username, password: string;
  out ErrorMessage: string): Boolean;
var
  HashedPassword: string;
begin
  if not ValidatePassword(password, ErrorMessage) then
    Exit(False);

  HashedPassword := HashPassword(password);

  try

    query.Close;

    query.SQL.Text := 'SELECT * FROM users WHERE username=:username';
    query.ParamByName('username').AsString := username;
    query.Open;
    if not query.IsEmpty then
    begin
      ErrorMessage := 'Username already exists';
      Result := False;
    end
    else
    begin
      query.Close;
      query.SQL.Text :=
        'INSERT INTO users (username, password) VALUES (:username, :password)';
      query.ParamByName('username').AsString := username;
      query.ParamByName('password').AsString := HashedPassword;

      query.ExecSQL;

      ErrorMessage := '';
      Result := True;
    end;

  except
    on E: Exception do
    begin
      ErrorMessage := 'An error occurred: ' + E.Message;
      Result := False;
    end;
  end;
end;

function LoginUser(const query: TFDQuery; var username, password: string;
  out ErrorMessage: string): TUser;
var
  db_password: string;
  IsPasswordCorrect: Boolean;
  user: TUser;
begin
  Result := Default (TUser);
  try
    query.Close;
    query.SQL.Text :=
      'SELECT id, username, password FROM users WHERE username=:username';
    query.ParamByName('username').AsString := username;
    query.Open;
    if not query.IsEmpty then
    begin
      db_password := query.FieldByName('password').AsString;
      IsPasswordCorrect := CheckPassword(password, db_password);
      if IsPasswordCorrect then
      begin
        user.id := query.FieldByName('id').AsInteger;
        user.username := query.FieldByName('username').AsString;
        Result := user;
      end
      else
      begin
        ErrorMessage := 'Incorrect password';
      end;
    end
    else
    begin
      ErrorMessage := 'Username not found';
    end;
  except
    on E: Exception do
    begin
      ErrorMessage := 'An error occurred: ' + E.Message;
    end;
  end;
end;

function CreateTask(const query: TFDQuery; var title, date, description: string;
  var priority, user_id, status: Integer; out ErrorMessage: string): Boolean;
begin
  Result := False;
  try
    query.SQL.Text := 'INSERT INTO tasks' +
      ' (title, date, description, priority, user_id, status)' + ' VALUES' +
      ' (:title, :date, :description, :priority, :user_id, :status)';
    query.ParamByName('title').AsString := title;
    query.ParamByName('date').AsString := date;
    query.ParamByName('description').AsString := description;
    query.ParamByName('priority').AsInteger := priority;
    query.ParamByName('user_id').AsInteger := user_id;
    query.ParamByName('status').AsInteger := status;
    query.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      ErrorMessage := E.Message;
    end;
  end;
end;

function UpdateTask(const query: TFDQuery; var id: Integer;
  var title, date, description: string; var priority, user_id, status: Integer;
  out ErrorMessage: string): Boolean;
begin
  Result := False;
  try
    query.SQL.Text := 'UPDATE tasks SET ' +
      'title = :title, date = :date, description = :description, ' +
      'priority = :priority, user_id = :user_id, status = :status ' +
      'WHERE id = :id';
    query.ParamByName('id').AsInteger := id;
    query.ParamByName('title').AsString := title;
    query.ParamByName('date').AsString := date;
    query.ParamByName('description').AsString := description;
    query.ParamByName('priority').AsInteger := priority;
    query.ParamByName('user_id').AsInteger := user_id;
    query.ParamByName('status').AsInteger := status;
    query.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      ErrorMessage := E.Message;
    end;
  end;
end;

function CompleteTask(const query: TFDQuery; var id: Integer;
  out ErrorMessage: string): Boolean;
begin
  Result := False;
  try
    query.SQL.Text := 'UPDATE tasks SET status = :status WHERE id = :id';
    query.ParamByName('id').AsInteger := id;
    query.ParamByName('status').AsInteger := 3;
    query.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      ErrorMessage := E.Message;
    end;
  end;
end;

function DeleteTask(const query: TFDQuery; var id: Integer;
  out ErrorMessage: string): Boolean;
begin
  Result := False;
  try
    query.SQL.Text := 'DELETE FROM tasks WHERE id = :id';
    query.ParamByName('id').AsInteger := id;
    query.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      ErrorMessage := E.Message;
    end;
  end;
end;

function GetUserTasks(const query: TFDQuery; var user_id: Integer;
  out ErrorMessage: string): TArray<TTask>;
var
  tasks: TArray<TTask>;
  counter: Integer;
begin
  Result := nil;
  try
    query.SQL.Text := 'SELECT * FROM tasks WHERE user_id = :user_id';
    query.ParamByName('user_id').AsInteger := user_id;
    query.Open;

    SetLength(tasks, query.RecordCount);
    counter := 0;

    while not query.Eof do
    begin
      tasks[counter].id := query.FieldByName('id').AsInteger;
      tasks[counter].UserId := query.FieldByName('user_id').AsInteger;
      tasks[counter].title := query.FieldByName('title').AsString;
      tasks[counter].description := query.FieldByName('description').AsString;
      tasks[counter].date := query.FieldByName('date').AsString;
      tasks[counter].priority := query.FieldByName('priority').AsInteger;
      tasks[counter].status := query.FieldByName('status').AsInteger;
      counter := counter + 1;
      query.Next;
    end;

    Result := tasks;
  except
    on E: Exception do
    begin
      ErrorMessage := 'Error occurred: ' + E.Message;
    end;
  end;
end;

function statusCircleCompleted(const query: TFDQuery;
  var user_id: Integer): Integer;

var
  usertasks, usercompletedtasks: Integer;
  error: string;
begin
  usertasks := Length(GetUserTasks(query, user_id, error));

  if usertasks = 0 then
    Exit(0);

  query.SQL.Text :=
    'SELECT *  FROM tasks WHERE user_id = :user_id AND status = :status';
  query.ParamByName('user_id').AsInteger := user_id;
  query.ParamByName('status').AsInteger := 3;
  query.Open;
  usercompletedtasks := query.RecordCount;
  query.Close;

  Result := Round((usercompletedtasks / usertasks) * 360);
end;

function statusCircleInProgress(const query: TFDQuery;
  var user_id: Integer): Integer;
var
  usertasks, userinprogresstasks: Integer;
  error: string;
begin
  usertasks := Length(GetUserTasks(query, user_id, error));

  if usertasks = 0 then
    Exit(0);

  query.SQL.Text :=
    'SELECT * FROM tasks WHERE user_id = :user_id AND status = :status';
  query.ParamByName('user_id').AsInteger := user_id;
  query.ParamByName('status').AsInteger := 2;
  query.Open;
  userinprogresstasks := query.RecordCount;
  query.Close;

  Result := Round((userinprogresstasks / usertasks) * 360);
end;

function statusCircleNotStarted(const query: TFDQuery;
  var user_id: Integer): Integer;
var
  usertasks, usernotcompeleted: Integer;
  error: string;
begin
  usertasks := Length(GetUserTasks(query, user_id, error));

  if usertasks = 0 then
    Exit(0);

  query.SQL.Text :=
    'SELECT * FROM tasks WHERE user_id = :user_id AND status = :status';
  query.ParamByName('user_id').AsInteger := user_id;
  query.ParamByName('status').AsInteger := 1;
  query.Open;
  usernotcompeleted := query.RecordCount;
  query.Close;

  Result := Round((usernotcompeleted / usertasks) * 360);
end;

end.
