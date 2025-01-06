unit DataModule;

interface

uses
  FireDAC.Comp.Client, System.Classes, System.SysUtils, System.Types, Data.DB,
  FMX.Dialogs, FMX.Edit, FMX.Objects, RegularExpressions,
  System.Hash, LocalTypes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.FMXUI.Wait, FireDAC.Stan.Param,
  FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;

type
  TData_Module = class(TDataModule)
    Connection: TFDConnection;
    Query: TFDQuery;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ConnectToDb(const dbname: string);
  end;

var
  Data_Module: TData_Module;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}
{$R *.dfm}

procedure TData_Module.ConnectToDb(const dbname: string);
var
  ResStream: TResourceStream;
  DBfile: string;
  FileStream: TFileStream;
begin
  if Connection.Connected then
    Connection.Close;

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

  Connection.Params.Values['Database'] := DBfile;
  Connection.LoginPrompt := False;
  try
    Connection.Connected := True;
  except
    on E: EDatabaseError do
      ShowMessage('Exception raised with message: ' + E.Message);
  end;
end;


end.
