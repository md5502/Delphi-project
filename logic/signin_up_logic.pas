unit signin_up_logic;

interface

uses
  FireDAC.Comp.Client, System.Classes, System.SysUtils, System.Types, Data.DB,
  FMX.Dialogs, FMX.Edit, FMX.Objects;

procedure TogglePasswordVisibility(Edit: TEdit; Icon: TImage; var IconFileName: string);


implementation

procedure TogglePasswordVisibility(Edit: TEdit; Icon: TImage; var IconFileName: string);
var
  ResStream: TResourceStream;
begin
  if IconFileName = 'password_show_icon' then
    IconFileName := 'password_hide_icon'
  else
    IconFileName := 'password_show_icon';

  try
    ResStream := TResourceStream.Create(HInstance, IconFileName, RT_RCDATA);
    try
      Icon.Bitmap.LoadFromStream(ResStream);
      Edit.Password := not Edit.Password;
    finally
      ResStream.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Exception raised with message: ' + E.Message);
  end;
end;

end.
