unit helpers;

interface

uses
  FMX.Graphics, System.Classes, System.Types, FMX.Objects, FMX.StdCtrls,
  System.UITypes;

procedure LoadImageFromResource(const ResourceName: string; Bitmap: TBitmap);
procedure SetButtonStyle(Button: TRectangle; Icon: TImage; LabelText: TLabel;
  FillColor: TAlphaColor; IconResource: string; FontColor: TAlphaColor);
procedure ResetButtonStyles;

implementation
   uses
   MainView;
procedure LoadImageFromResource(const ResourceName: string; Bitmap: TBitmap);
var
  ResStream: TResourceStream;
begin
  ResStream := TResourceStream.Create(HInstance, ResourceName, RT_RCDATA);
  try
    Bitmap.LoadFromStream(ResStream);
  finally
    ResStream.Free;
  end;
end;

procedure SetButtonStyle(Button: TRectangle; Icon: TImage; LabelText: TLabel;
  FillColor: TAlphaColor; IconResource: string; FontColor: TAlphaColor);
begin
  Button.Fill.Color := FillColor;
  LoadImageFromResource(IconResource, Icon.Bitmap);
  LabelText.TextSettings.FontColor := FontColor;
end;

procedure ResetButtonStyles;
begin
  // Reset styles for all buttons to default
  SetButtonStyle(main_view.SideBarBtnDashboard, main_view.SideBarBtnDashboardIcon,
    main_view.SideBarBtnDashboardLabel, $FFFF6767, 'category_icon_1', $FFFFFFFF);

  SetButtonStyle(main_view.SideBarBtnVitalTask, main_view.SideBarBtnVitalTaskIcon,
    main_view.SideBarBtnVitalTaskLabel, $FFFF6767, 'vital_task_icon1', $FFFFFFFF);

  SetButtonStyle(main_view.SideBarBtnMyTask, main_view.SideBarBtnMyTaskIcon, main_view.SideBarBtnMyTaskLabel,
    $FFFF6767, 'my_task_icon1', $FFFFFFFF);

  SetButtonStyle(main_view.SideBarBtnTaskCategories, main_view.SideBarBtnTaskCategoriesIcon,
    main_view.SideBarBtnTaskCategoriesLabel, $FFFF6767, 'task_category_icon2', $FFFFFFFF);

  SetButtonStyle(main_view.SideBarBtnLogout, main_view.SideBarBtnLogoutIcon, main_view.SideBarBtnLogoutLabel,
    $FFFF6767, 'logout_icon1', $FFFFFFFF);
end;

end.
