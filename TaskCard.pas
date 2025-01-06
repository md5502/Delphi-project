unit TaskCard;

interface

uses

  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Effects,
  FMX.Layouts,
  FMX.Edit, helpers;

procedure CreateHeadTaskCard(ParentLayout: TLayout;
  CardTitle, CardDescription, Priority, Status, CreatedOn: string);

implementation

procedure CreateHeadTaskCard(ParentLayout: TLayout;
  CardTitle, CardDescription, Priority, Status, CreatedOn: string);
var
  HeadTaskCard: TRectangle;
  HeadTaskCardCircleType: TRoundRect;
  LayoutHeadTaskCardPrimary: TLayout;
  HeadTaskTitle, HeadTaskDescription: TLabel;
  HeadTaskimage: TImage;
  LayoutHeadTaskCardSecondry: TLayout;
  priorityLayout, StatusLayout, DateLayout: TLayout;
  PriorityLabel, PriorityLabelVar, StatusLabel, CratedOnLabelVar,
    StatusLabelVar, CratedOnLabel: TLabel;
begin
  // Create the main card (Rectangle)
  HeadTaskCard := TRectangle.Create(ParentLayout);
  with HeadTaskCard do
  begin
    Parent := ParentLayout;
    Align := TAlignLayout.Top;
    Fill.Color := TAlphaColors.White;
    Size.Width := 410;
    Size.Height := 180;
    Stroke.Color := $FFA1A3AB;
    XRadius := 15;
    YRadius := 15;
    Margins.Bottom := 10; // Add some margin between cards
  end;

  // Create the small circle (RoundRect)
  HeadTaskCardCircleType := TRoundRect.Create(HeadTaskCard);
  with HeadTaskCardCircleType do
  begin
    Parent := HeadTaskCard;
    Fill.Color := TAlphaColors.Null;
    Position.X := 15;
    Position.Y := 15;
    Size.Width := 12;
    Size.Height := 12;
    Stroke.Color := TAlphaColors.Blue;
    Stroke.Thickness := 2;
  end;

  // Create the primary layout for title and description
  LayoutHeadTaskCardPrimary := TLayout.Create(HeadTaskCard);
  with LayoutHeadTaskCardPrimary do
  begin
    Parent := HeadTaskCard;
    Position.X := 35;
    Position.Y := 15;
    Size.Width := 246;
    Size.Height := 130;
  end;

  HeadTaskTitle := TLabel.Create(LayoutHeadTaskCardPrimary);
  with HeadTaskTitle do
  begin
    Parent := LayoutHeadTaskCardPrimary;
    StyledSettings := [];
    Align := TAlignLayout.Top;
    AutoSize := True;
    Text := CardTitle;

    TextSettings.Font.Family := 'Inter';
    TextSettings.Font.Size := 16;
    TextSettings.Font.Style := [TFontStyle.fsBold];

    ApplyStyleLookup;
  end;

  // Create the description label
  HeadTaskDescription := TLabel.Create(LayoutHeadTaskCardPrimary);
  with HeadTaskDescription do
  begin
    Parent := LayoutHeadTaskCardPrimary;
    Align := TAlignLayout.Top;
    AutoSize := True;
    Margins.Top := 10;
    StyledSettings := [];
    TextSettings.Font.Family := 'Inter';
    TextSettings.Font.Size := 16;
    TextSettings.FontColor := $FF747474;
    Text := CardDescription;
  end;

  // Create the image placeholder
  HeadTaskimage := TImage.Create(HeadTaskCard);
  with HeadTaskimage do
  begin
    Parent := HeadTaskCard;
    Position.X := 296;
    Position.Y := 37;
    Size.Width := 90;
    Size.Height := 90;
    LoadImageFromResource('category_icon_2', Bitmap)
  end;

  // Create the secondary layout for priority, status, and created date
  LayoutHeadTaskCardSecondry := TLayout.Create(HeadTaskCard);
  with LayoutHeadTaskCardSecondry do
  begin
    Parent := HeadTaskCard;
    Align := TAlignLayout.Bottom;
    Margins.Bottom := 10;
    Size.Height := 24;
  end;

  // Create the priority layout
  priorityLayout := TLayout.Create(LayoutHeadTaskCardSecondry);
  with priorityLayout do
  begin
    Parent := LayoutHeadTaskCardSecondry;
    Align := TAlignLayout.Left;
    Margins.Left := 10;
    Size.Width := 100;
    Size.Height := 24;
  end;

  PriorityLabel := TLabel.Create(priorityLayout);
  with PriorityLabel do
  begin
    Parent := priorityLayout;
    Align := TAlignLayout.Left;
    AutoSize := True;
    Width := 45;
    StyledSettings := [];
    TextSettings.Font.Family := 'Inter';
    TextSettings.Font.Size := 12;
    Text := 'Priority: ';
  end;

  PriorityLabelVar := TLabel.Create(priorityLayout);
  with PriorityLabelVar do
  begin
    Parent := priorityLayout;
    Align := TAlignLayout.Left;
    AutoSize := True;

    Width := 55;
    StyledSettings := [];
    AutoSize := True;
    TextSettings.Font.Family := 'Inter';
    TextSettings.Font.Size := 12;
    TextSettings.FontColor := $FF42ADE2;
    Text := Priority;
  end;

  // Create the status layout
  StatusLayout := TLayout.Create(LayoutHeadTaskCardSecondry);
  with StatusLayout do
  begin
    Parent := LayoutHeadTaskCardSecondry;
    Align := TAlignLayout.Left;
    Margins.Left := 20;
    Size.Width := 105;
    Size.Height := 24;
  end;

  StatusLabel := TLabel.Create(StatusLayout);
  with StatusLabel do
  begin
    Parent := StatusLayout;
    Align := TAlignLayout.Left;
    AutoSize := True;
    Width := 37;
    StyledSettings := [];
    TextSettings.Font.Family := 'Inter';
    TextSettings.Font.Size := 11;
    TextSettings.FontColor := $FF000000;
    Text := 'Status';
  end;

  StatusLabelVar := TLabel.Create(StatusLayout);
  with StatusLabelVar do
  begin
    Parent := StatusLayout;
    Align := TAlignLayout.Left;
    AutoSize := True;
    Width := 68;
    StyledSettings := [];
    TextSettings.Font.Family := 'Inter';
    TextSettings.Font.Size := 11;
    TextSettings.FontColor := $FFF21E1E;
    Text := Status;
  end;

  // Create the created date layout
  DateLayout := TLayout.Create(LayoutHeadTaskCardSecondry);
  with DateLayout do
  begin
    Parent := LayoutHeadTaskCardSecondry;
    Align := TAlignLayout.Left;
    Margins.Left := 12;
    Size.Width := 143;
    Size.Height := 24;
  end;

  CratedOnLabel := TLabel.Create(DateLayout);
  with CratedOnLabel do
  begin
    Parent := DateLayout;
    Align := TAlignLayout.Left;
    Width := 70;
    StyledSettings := [];
    TextSettings.Font.Family := 'Inter';
    TextSettings.Font.Size := 12;
    TextSettings.FontColor := $FFA1A3AB;
    Text := 'Created on:';
  end;

  CratedOnLabelVar := TLabel.Create(DateLayout);
  with CratedOnLabelVar do
  begin
    Parent := DateLayout;
    Align := TAlignLayout.Left;
    Width := 73;
    StyledSettings := [];
    TextSettings.Font.Family := 'Inter';
    TextSettings.Font.Size := 12;
    TextSettings.FontColor := $FFA1A3AB;
    Text := CreatedOn;
  end;
end;

end.
