{
    fpGUI  -  Free Pascal GUI Toolkit

    Copyright (C) 2006 - 2010 See the file AUTHORS.txt, included in this
    distribution, for details of the copyright.

    See the file COPYING.modifiedLGPL, included in this distribution,
    for details about redistributing fpGUI.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    Description:
      Property editor for grid columns.
}

unit vfdpropeditgrid;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils,
  lq_base,
  lq_widget,
  lq_form,
  lq_label,
  lq_edit,
  lq_button,
  lq_combobox,
  lq_customgrid,
  lq_basegrid,
  lq_grid,
  vfdwidgetclass,
  vfdprops,
  vfdformparser;

type

  TPropertyDBColumns = class(TVFDWidgetProperty)
  public
    function    ParseSourceLine(wg: TlqWidget; const line: string): boolean; override;
    function    GetPropertySource(wg: TlqWidget; const ident: string): string; override;
    function    GetValueText(wg: TlqWidget): string; override;
    function    CreateEditor(AOwner: TComponent): TVFDPropertyEditor; override;
    procedure   OnExternalEdit(wg: TlqWidget); override;
  end;


  // A normal grid's column information now become rows of data.
  TColumnsGrid = class(TlqCustomGrid)
  protected
    function    GetRowCount: Integer; override;
    procedure   DrawCell(ARow, ACol: Integer; ARect: TlqRect; AFlags: TlqGridDrawState);  override;
  public
    dbgrid: TlqStringGrid;
    constructor Create(AOwner: TComponent); override;
  end;


  TColumnEditForm = class(TlqForm)
  private
    procedure GridRowChange(Sender: TObject; row: Integer);
    procedure EditChange(Sender: TObject);
    procedure NewButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure UpDownButtonClick(Sender: TObject);
    procedure SaveColumn(row: integer);
  public
    {@VFD_HEAD_BEGIN: ColumnEditForm}
    lbLabel1: TlqLabel;
    grid: TColumnsGrid;
    lbLabel2: TlqLabel;
    lbLabel3: TlqLabel;
    lbLabel6: TlqLabel;
    lbLabel5: TlqLabel;
    lbCOLNO: TlqLabel;
    edTITLE: TlqEdit;
    edCOLWIDTH: TlqEdit;
    chlALIGN: TlqComboBox;
    btnNew: TlqButton;
    btnDelete: TlqButton;
    btnUP: TlqButton;
    btnDOWN: TlqButton;
    btnClose: TlqButton;
    {@VFD_HEAD_END: ColumnEditForm}

    dbgrid: TlqStringGrid;
    procedure AfterCreate; override;
  end;


implementation


procedure EditStringGridColumns(agrid: TlqStringGrid);
var
  frm: TColumnEditForm;
begin
  frm        := TColumnEditForm.Create(nil);
  frm.dbgrid := agrid;
  frm.grid.dbgrid := agrid;
  frm.ShowModal;
  frm.Free;
end;

{ TColumnEditForm }

procedure TColumnEditForm.AfterCreate;
begin
  {%region 'Auto-generated GUI code' -fold}
  {@VFD_BODY_BEGIN: ColumnEditForm}
  Name := 'ColumnEditForm';
  SetPosition(270, 267, 511, 269);
  WindowTitle := 'Column editor';
  Sizeable := False;

  lbLabel1 := TlqLabel.Create(self);
  with lbLabel1 do
  begin
    Name := 'lbLabel1';
    SetPosition(8, 4, 110, 16);
    Text := 'String Grid columns:';
    FontDesc := '#Label1';
    AutoSize := True;
  end;

  grid := TColumnsGrid.Create(self);
  with grid do
  begin
    Name := 'grid';
    SetPosition(8, 24, 328, 204);
    OnRowChange := @GridRowChange;
  end;

  lbLabel2 := TlqLabel.Create(self);
  with lbLabel2 do
  begin
    Name := 'lbLabel2';
    SetPosition(344, 24, 56, 16);
    Text := 'Column:';
    FontDesc := '#Label1';
    AutoSize := True;
  end;

  lbLabel3 := TlqLabel.Create(self);
  with lbLabel3 do
  begin
    Name := 'lbLabel3';
    SetPosition(344, 56, 34, 16);
    Text := 'Title:';
    FontDesc := '#Label1';
    AutoSize := True;
  end;

  lbLabel6 := TlqLabel.Create(self);
  with lbLabel6 do
  begin
    Name := 'lbLabel6';
    SetPosition(344, 100, 88, 16);
    Text := 'Column width:';
    FontDesc := '#Label1';
    AutoSize := True;
  end;

  lbLabel5 := TlqLabel.Create(self);
  with lbLabel5 do
  begin
    Name := 'lbLabel5';
    SetPosition(344, 144, 83, 16);
    Text := 'Alignment:';
    FontDesc := '#Label1';
    AutoSize := True;
  end;

  lbCOLNO := TlqLabel.Create(self);
  with lbCOLNO do
  begin
    Name := 'lbCOLNO';
    SetPosition(404, 24, 54, 16);
    Text := '--';
    FontDesc := '#Label1';
    AutoSize := True;
  end;

  edTITLE := TlqEdit.Create(self);
  with edTITLE do
  begin
    Name := 'edTITLE';
    SetPosition(344, 72, 160, 22);
    Text := '';
    FontDesc := '#Edit1';
    OnChange := @EditChange;
  end;

  edCOLWIDTH := TlqEdit.Create(self);
  with edCOLWIDTH do
  begin
    Name := 'edCOLWIDTH';
    SetPosition(344, 116, 160, 22);
    Text := '';
    FontDesc := '#Edit1';
    OnChange := @EditChange;
  end;

  chlALIGN := TlqComboBox.Create(self);
  with chlALIGN do
  begin
    Name := 'chlALIGN';
    SetPosition(344, 162, 160, 22);
    Items.Add('Left');
    Items.Add('Right');
    Items.Add('Center');
    FontDesc := '#List';
    OnChange := @EditChange;
  end;

  btnNew := TlqButton.Create(self);
  with btnNew do
  begin
    Name := 'btnNew';
    SetPosition(8, 236, 75, 24);
    Text := 'New';
    FontDesc := '#Label1';
    ImageName := '';
    OnClick := @NewButtonClick;
  end;

  btnDelete := TlqButton.Create(self);
  with btnDelete do
  begin
    Name := 'btnDelete';
    SetPosition(86, 236, 75, 24);
    Text := 'Delete';
    FontDesc := '#Label1';
    ImageName := '';
    OnClick := @DeleteButtonClick;
  end;

  btnUP := TlqButton.Create(self);
  with btnUP do
  begin
    Name := 'btnUP';
    SetPosition(182, 236, 75, 24);
    Text := 'UP';
    FontDesc := '#Label1';
    ImageName := '';
    OnClick := @UpDownButtonClick;
  end;

  btnDOWN := TlqButton.Create(self);
  with btnDOWN do
  begin
    Name := 'btnDOWN';
    SetPosition(260, 236, 75, 24);
    Text := 'DOWN';
    FontDesc := '#Label1';
    ImageName := '';
    OnClick := @UpDownButtonClick;
  end;

  btnClose := TlqButton.Create(self);
  with btnClose do
  begin
    Name := 'btnClose';
    SetPosition(428, 236, 75, 24);
    Text := 'Close';
    FontDesc := '#Label1';
    ImageName := 'stdimg.close';
    OnClick := @CloseButtonClick;
  end;

  {@VFD_BODY_END: ColumnEditForm}
  {%endregion}
end;

procedure TColumnEditForm.GridRowChange(Sender: TObject; row: Integer);
var
  i: integer;
  c: TlqStringColumn;
begin
  c := dbgrid.Columns[row];
  if c = nil then
    Exit;

  try
    // disable event handlers
    edTITLE.OnChange := nil;
    edCOLWIDTH.OnChange := nil;
    chlALIGN.OnChange := nil;

    lbCOLNO.Text     := IntToStr(row);
    edTITLE.Text     := c.Title;
    edCOLWIDTH.Text  := IntToStr(c.Width);
    case c.Alignment of
      taRightJustify:
          i := 1;
      taCenter:
          i := 2
      else
          i := 0;
    end;
    chlALIGN.FocusItem := i;
  finally
    // enable event handlers again.
    edTITLE.OnChange    := @EditChange;
    edCOLWIDTH.OnChange := @EditChange;
    chlALIGN.OnChange   := @EditChange;
  end;
end;

procedure TColumnEditForm.SaveColumn(row: integer);
var
  c: TlqStringColumn;
begin
  c := dbgrid.Columns[row];
  if c = nil then
    Exit;

  c.Title      := edTITLE.Text;
  c.Width      := StrToIntDef(edCOLWIDTH.Text, 30);
  case chlALIGN.FocusItem of
    1: c.Alignment := taRightJustify;
    2: c.Alignment := taCenter;
    else
      c.Alignment  := taLeftJustify;
  end;

  grid.RePaint;
  dbgrid.Update;
end;

procedure TColumnEditForm.EditChange(Sender: TObject);
begin
  if grid.FocusRow < 0 then
    Exit;
  SaveColumn(grid.FocusRow)
end;

procedure TColumnEditForm.NewButtonClick(Sender: TObject);
begin
  dbgrid.AddColumn('New', 50, taLeftJustify);
  grid.FocusRow := grid.RowCount;
  grid.Update;
  GridRowChange(Sender, grid.FocusRow);
end;

procedure TColumnEditForm.DeleteButtonClick(Sender: TObject);
begin
  dbgrid.DeleteColumn(grid.FocusRow);
  grid.Update;
end;

procedure TColumnEditForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TColumnEditForm.UpDownButtonClick(Sender: TObject);
begin
  if Sender = btnUP then
  begin
    if grid.FocusRow > 0 then
    begin
      dbgrid.MoveColumn(grid.FocusRow, grid.FocusRow - 1);
      grid.FocusRow := grid.FocusRow - 1;
      grid.Update;
    end;
  end
  else if grid.FocusRow < grid.RowCount-1 then
  begin
    dbgrid.MoveColumn(grid.FocusRow, grid.FocusRow+1);
    grid.FocusRow := grid.FocusRow + 1;
    grid.Update;
  end;
end;


{ TColumnsGrid }

function TColumnsGrid.GetRowCount: Integer;
begin
  try
    // Yes, it must be ColumnCount and *not* RowCount!
    Result := dbgrid.ColumnCount;
  except
    Result := inherited GetColumnCount;
  end;
end;

procedure TColumnsGrid.DrawCell(ARow, ACol: Integer; ARect: TlqRect; AFlags: TlqGridDrawState);
var
  s: string;
  x: integer;
  c: TlqStringColumn;
begin
//  writeln('ARow=', ARow, '  ACol=', ACol);
  c := dbgrid.Columns[ARow{ - 1}];
  if c = nil then
  begin
//    writeln(' TColumnsGrid.DrawCell -> exit early because c = nil');
    Exit;
  end;
//  writeln(' ... we passed the nil test');
  x := ARect.Left + 1;

  case ACol of
    0:  s := IntToStr(ARow);
    1:  s := c.Title;
    2:  s := IntToStr(c.Width);
    3:  case c.Alignment of
          taRightJustify:
              s := 'Right';
          taCenter:
              s := 'Center';
          else
              s := 'Left';
        end;
    else
      s := '?';
  end;

  Canvas.DrawString(x, ARect.Top + 1, s);
end;

constructor TColumnsGrid.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  RowSelect := True;
  ColumnCount := 0;
  RowCount := 0;
  AddColumn('Col.', 30);
  AddColumn('Title', 80);
  AddColumn('Width', 40);
  AddColumn('Align', 50);
end;

{ TPropertyDBColumns }

function TPropertyDBColumns.CreateEditor(AOwner: TComponent): TVFDPropertyEditor;
begin
  Result := TExternalPropertyEditor.Create(AOwner, self);
end;

function TPropertyDBColumns.GetValueText(wg: TlqWidget): string;
begin
  with TlqStringGrid(wg) do
    Result := '[' + IntToStr(ColumnCount) + ' columns]';
end;

procedure TPropertyDBColumns.OnExternalEdit(wg: TlqWidget);
begin
  if not Assigned(wg) then
    raise Exception.Create('TPropertyDBColumns.OnExternalEdit(wg) - wg widget may not be nil.');
  if not (wg is TlqStringGrid) then
    raise Exception.Create('TPropertyDBColumns.OnExternalEdit(wg) - wg widget is not a TlqStringGrid.');
  EditStringGridColumns(TlqStringGrid(wg));
end;

function TPropertyDBColumns.ParseSourceLine(wg: TlqWidget; const line: string): boolean;
var
  c: TlqStringColumn;
  s: string;
  sval: string;
begin
  s      := line;
  Result := False;
  if UpperCase(GetIdentifier(s)) <> UpperCase('ADDCOLUMN') then
    Exit;

  c := TlqStringColumn.Create;

  Result := CheckSymbol(s, '(');

  if Result then
    c.Title := GetStringValue(s);
  Result := Result and CheckSymbol(s, ',');
  if Result then
    c.Width := GetIntValue(s);
  Result := Result and CheckSymbol(s, ',');
  if Result then
  begin
    sval := UpperCase(GetIdentifier(s));
    if sval = 'TARIGHTJUSTIFY' then
      c.Alignment := taRightJustify
    else if sval = 'TACENTER' then
      c.Alignment := taCenter
    else
      c.Alignment := taLeftJustify;
  end;

  Result := Result and CheckSymbol(s, ')');
  Result := Result and CheckSymbol(s, ';');

  if Result then
    TlqStringGrid(wg).AddColumn(c.Title, c.Width, c.Alignment);

  c.Free;
end;

function TPropertyDBColumns.GetPropertySource(wg: TlqWidget; const ident: string): string;
var
  f: integer;
  c: TlqStringColumn;
  alstr: string;
begin
  Result := '';
  with TlqStringGrid(wg) do
  begin
    for f := 0 to ColumnCount-1 do
    begin
      c := Columns[f];
      case c.Alignment of
        taRightJustify:
            alstr := 'taRightJustify';
        taCenter:
            alstr := 'taCenter';
        else
            alstr := 'taLeftJustify';
      end;
      Result := Result + ident
          + 'AddColumn(' + QuotedStr(c.Title) + ', '
          + IntToStr(c.Width) + ', '
          + alstr + ');' + LineEnding;
    end;  { for }
  end;  { with }
end;

end.

