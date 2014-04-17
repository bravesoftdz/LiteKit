program filegrid;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,
  SysUtils,
  lq_base,
  lq_main,
  lq_form,
  lq_grid,
  lq_checkbox,
  lq_button;

type

  { TMainForm }

  TMainForm = class(TlqForm)
  private
    FGrid: TlqFileGrid;
    chkShowHidden: TlqCheckBox;
    btnQuit: TlqButton;
    procedure   chkShowHiddenChanged(Sender: TObject);
    procedure   btnQuitClicked(Sender: TObject);
    procedure   GridDblClick(Sender: TObject; AButton: TMouseButton; AShift: TShiftState; const AMousePos: TPoint);
  public
    constructor Create(AOwner: TComponent); override;
  end;

{ TMainForm }

procedure TMainForm.chkShowHiddenChanged(Sender: TObject);
begin
  FGrid.FileList.ShowHidden := chkShowHidden.Checked;
  FGrid.FileList.ReadDirectory('');
  fpgSendMessage(self, FGrid, FPGM_PAINT);
end;

procedure TMainForm.btnQuitClicked(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.GridDblClick(Sender: TObject; AButton: TMouseButton;
  AShift: TShiftState; const AMousePos: TPoint);
begin
  if FGrid.CurrentEntry.EntryType = etFile then
//  if (FGrid.CurrentEntry.Attributes and faDirectory) = 0 then
    Exit; //==>
    
  FGrid.FileList.ReadDirectory(FGrid.FileList.DirectoryName + FGrid.CurrentEntry.Name);
  WindowTitle := FGrid.FileList.DirectoryName;
  FGrid.Update;
end;

constructor TMainForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  WindowTitle := 'Filegrid Test';
  SetPosition(100, 100, 620, 400);
  
  FGrid := TlqFileGrid.Create(self);
  FGrid.SetPosition(8, 8, 600, 360);
  FGrid.FileList.ShowHidden := True;
  FGrid.FileList.ReadDirectory('');
  FGrid.Anchors := [anLeft, anTop, anBottom, anRight];
  FGrid.OnDoubleClick := @GridDblClick;
  
  chkShowHidden := CreateCheckBox(self, 8, Height - 25, 'Show Hidden');
  chkShowHidden.Checked := True;
  chkShowHidden.OnChange := @chkShowHiddenChanged;
  chkShowHidden.Anchors := [anLeft, anBottom];
  
  btnQuit := CreateButton(self, Width - 88, Height - 30, 80, 'Quit', @btnQuitClicked);
  btnQuit.ImageName := 'stdimg.Quit';
  btnQuit.ShowImage := True;
  btnQuit.Anchors := [anRight, anBottom];
end;


procedure MainProc;
var
  frm: TMainForm;
begin
  fpgApplication.Initialize;
  frm := TMainForm.Create(nil);
  frm.Show;
  fpgApplication.Run;
  frm.Free;
end;

begin
  MainProc;
end.


