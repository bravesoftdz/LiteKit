program calendartest;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils,
  lq_base, lq_main, lq_form, lq_popupcalendar, lq_edit,
  lq_button, lq_label, lq_popupwindow, lq_combobox, lq_checkbox,
  lq_panel, dateutils;

type
  TMainForm = class(TlqForm)
  private
    {@VFD_HEAD_BEGIN: MainForm}
    btnClear: TlqButton;
    lblWHoliday: TlqLabel;
    cbWHoliday: TlqComboBox;
    cbName1: TlqComboBox;
    cal: TlqCalendarCombo;
    btnDateFormat: TlqButton;
    edtDateFormat: TlqEdit;
    lblName4: TlqLabel;
    lblName5: TlqLabel;
    btnToday: TlqButton;
    edtMinDate: TlqEdit;
    edtMaxDate: TlqEdit;
    btnMinDate: TlqButton;
    btnMaxDate: TlqButton;
    cbCloseOnSelect: TlqCheckBox;
    lblName1: TlqLabel;
    bvlName1: TlqBevel;
    CalendarCombo1: TlqCalendarCheckCombo;
    Label1: TlqLabel;
    cbSingleClickClose: TlqCheckBox;
    {@VFD_HEAD_END: MainForm}
    procedure   btnDateFormatClicked(Sender: TObject);
    procedure   btnTodayClicked(Sender: TObject);
    procedure   btnMinDateClicked(Sender: TObject);
    procedure   btnMaxDateClicked(Sender: TObject);
    procedure   cbWHolidayChange(Sender: TObject);
    procedure   cbName1Change(Sender: TObject);
    procedure   cbCloseOnSelectChanged(Sender: TObject);
    procedure   cbSingleClickCloseChanged(Sender: TObject);
    procedure   btnClearClicked(Sender: TObject);
    procedure   DrawCalendar(month, year: integer);
  public
    FDropDown: TlqPopupCalendar;
    procedure   AfterCreate; override;
  end;
  
{@VFD_NEWFORM_DECL}

{ TMainForm }

procedure TMainForm.cbCloseOnSelectChanged(Sender: TObject);
begin
  cal.CloseOnSelect := TlqCheckBox(Sender).Checked;
end;

procedure TMainForm.cbSingleClickCloseChanged(Sender: TObject);
begin
  cal.SingleClickSelect := TlqCheckBox(Sender).Checked;
end;

procedure TMainForm.btnClearClicked(Sender: TObject);
begin
  cbWHoliday.FocusItem := -1;
  cal.WeeklyHoliday := -1;
end;

type
  TStartDay = (wdSun, wdMon, wdTue, wdWed, wdThu, wdFri, wdSat);

procedure TMainForm.DrawCalendar(month, year: integer);
var
  weekstartday: TStartDay;
  i: integer;
  dayIndex: Byte;
  startingPos: integer;
  days: integer;
  currentDay: integer;
  s: string;
begin
  weekstartday := wdMon;  // 0=Sun, 1=Mon, 2=Tue etc.
  weekstartday := TStartDay(Ord(cbName1.FocusItem-1));
  
  // Month and year
  writeln('');
  writeln(LongMonthNames[month], ' ', year);

  // draw day-of-week header
  for i := Ord(weekstartday) to Ord(weekstartday)+6 do
  begin
    if (i < 7) then
      dayIndex := i
    else
      dayIndex := i - 7;

    write(ShortDayNames[dayIndex+1] + ' ');
  end;
  writeln('');
  
  startingPos := DayOfTheWeek(EncodeDate(year, month, 1)-Ord(weekstartday))-1;
  days := DaysInAMonth(year, month);
//  writeln('startingpos:', startingPos, '  days:', days);

  // draw blanks before first of month
  if not (startingPos = 6) then
  for i := 0 to startingPos do
    write('    ');

  // draw days of month
  currentDay := 1;
  i := startingPos;
  //for i := startingPos to days do
  while currentDay <= days do
  begin
    i := i + 1;
    if ((i mod 7) = 0) and (currentDay <> 1) then
      writeln('');
    if currentDay <= 9 then
      s := ' '
    else
      s := '';
    write(currentDay, '  ' + s);
    currentDay := currentDay + 1;
  end;
  
  writeln('');
  writeln('-----');
end;

procedure TMainForm.btnDateFormatClicked(Sender: TObject);
begin
  cal.DateFormat := edtDateFormat.Text;
end;

procedure TMainForm.btnTodayClicked(Sender: TObject);
begin
  cal.DateValue := Now;
end;

procedure TMainForm.btnMinDateClicked(Sender: TObject);
var
  old: string;
begin
  old := ShortDateFormat;
  ShortDateFormat := 'yyyy-mm-dd';
  try
    cal.MinDate := StrToDate(edtMinDate.Text);
  finally
    ShortDateFormat := old;
  end;
end;

procedure TMainForm.btnMaxDateClicked(Sender: TObject);
var
  old: string;
begin
  old := ShortDateFormat;
  ShortDateFormat := 'yyyy-mm-dd';
  try
    cal.MaxDate := StrToDate(edtMaxDate.Text);
  finally
    ShortDateFormat := old;
  end;

//  DrawCalendar(StrToInt(edtMaxDate.Text), 2008);
end;

procedure TMainForm.cbWHolidayChange(Sender: TObject);
begin
  cal.WeeklyHoliday := cbWHoliday.FocusItem;
end;

procedure TMainForm.cbName1Change(Sender: TObject);
begin
  cal.WeekStartDay := cbName1.FocusItem;
end;

procedure TMainForm.AfterCreate;
begin
  inherited AfterCreate;
  {@VFD_BODY_BEGIN: MainForm}
  Name := 'MainForm';
  SetPosition(362, 186, 372, 340);
  WindowTitle := 'LiteKit Calendar Test';
  Hint := '';
  WindowPosition := wpUser;

  btnClear := TlqButton.Create(self);
  with btnClear do
  begin
    Name := 'btnClear';
    SetPosition(256, 32, 59, 23);
    Text := 'Clear';
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    ShowImage := False;
    TabOrder := 1;
    OnClick := @btnClearClicked;
  end;

  lblWHoliday := TlqLabel.Create(self);
  with lblWHoliday do
  begin
    Name := 'lblWHoliday';
    SetPosition(24, 36, 100, 16);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Weekly holiday';
  end;

  cbWHoliday := TlqComboBox.Create(self);
  with cbWHoliday do
  begin
    Name := 'cbWHoliday';
    SetPosition(132, 32, 120, 23);
    FontDesc := '#List';
    Hint := '';
    Items.Add('Sun');
    Items.Add('Mon');
    Items.Add('Tue');
    Items.Add('Wed');
    Items.Add('Thu');
    Items.Add('Fri');
    Items.Add('Sat');
    TabOrder := 5;
    OnChange := @cbWHolidayChange;
  end;

  cbName1 := TlqComboBox.Create(self);
  with cbName1 do
  begin
    Name := 'cbName1';
    SetPosition(132, 64, 120, 23);
    FontDesc := '#List';
    Hint := '';
    Items.Add('Sun');
    Items.Add('Mon');
    Items.Add('Tue');
    Items.Add('Wed');
    Items.Add('Thu');
    Items.Add('Fri');
    Items.Add('Sat');
    TabOrder := 4;
    FocusItem := 0;
    OnChange := @cbName1Change;
  end;

  cal := TlqCalendarCombo.Create(self);
  with cal do
  begin
    Name := 'cal';
    SetPosition(132, 268, 120, 23);
    DateFormat := 'dd mmm yyyy';
    FontDesc := '#List';
    Hint := '';
    TabOrder := 5;
    DayColor := clBlue;
    HolidayColor := clRed;
    SelectedColor:= clYellow;
  end;

  btnDateFormat := TlqButton.Create(self);
  with btnDateFormat do
  begin
    Name := 'btnDateFormat';
    SetPosition(232, 160, 75, 23);
    Text := 'Set Format';
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 6;
    OnClick := @btnDateFormatClicked;
  end;

  edtDateFormat := TlqEdit.Create(self);
  with edtDateFormat do
  begin
    Name := 'edtDateFormat';
    SetPosition(132, 160, 92, 24);
    ExtraHint := '';
    Hint := '';
    TabOrder := 7;
    Text := 'yy-mm-d';
    FontDesc := '#Edit1';
  end;

  lblName4 := TlqLabel.Create(self);
  with lblName4 do
  begin
    Name := 'lblName4';
    SetPosition(24, 68, 96, 15);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Week start day';
  end;

  lblName5 := TlqLabel.Create(self);
  with lblName5 do
  begin
    Name := 'lblName5';
    SetPosition(8, 272, 104, 15);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Calendar Combo:';
  end;

  btnToday := TlqButton.Create(self);
  with btnToday do
  begin
    Name := 'btnToday';
    SetPosition(256, 268, 59, 23);
    Text := 'Today';
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 11;
    OnClick := @btnTodayClicked;
  end;

  edtMinDate := TlqEdit.Create(self);
  with edtMinDate do
  begin
    Name := 'edtMinDate';
    SetPosition(132, 188, 92, 24);
    ExtraHint := '';
    Hint := '';
    TabOrder := 13;
    Text := '2005-01-01';
    FontDesc := '#Edit1';
  end;

  edtMaxDate := TlqEdit.Create(self);
  with edtMaxDate do
  begin
    Name := 'edtMaxDate';
    SetPosition(132, 216, 92, 24);
    ExtraHint := '';
    Hint := '';
    TabOrder := 14;
    Text := '2009-01-01';
    FontDesc := '#Edit1';
  end;

  btnMinDate := TlqButton.Create(self);
  with btnMinDate do
  begin
    Name := 'btnMinDate';
    SetPosition(232, 188, 75, 23);
    Text := 'Min Date';
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 15;
    OnClick := @btnMinDateClicked;
  end;

  btnMaxDate := TlqButton.Create(self);
  with btnMaxDate do
  begin
    Name := 'btnMaxDate';
    SetPosition(232, 216, 75, 23);
    Text := 'Max Date';
    FontDesc := '#Label1';
    Hint := '';
    ImageName := '';
    TabOrder := 16;
    OnClick := @btnMaxDateClicked;
  end;

  cbCloseOnSelect := TlqCheckBox.Create(self);
  with cbCloseOnSelect do
  begin
    Name := 'cbCloseOnSelect';
    SetPosition(128, 92, 236, 20);
    Checked := True;
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 17;
    Text := 'Close combo on date selection';
    OnChange := @cbCloseOnSelectChanged;
  end;

  lblName1 := TlqLabel.Create(self);
  with lblName1 do
  begin
    Name := 'lblName1';
    SetPosition(8, 8, 144, 16);
    FontDesc := '#Label2';
    Hint := '';
    Text := 'Calendar Settings';
  end;

  bvlName1 := TlqBevel.Create(self);
  with bvlName1 do
  begin
    Name := 'bvlName1';
    SetPosition(8, 248, 350, 2);
    Anchors := [anLeft,anRight,anTop];
    Hint := '';
    Style := bsLowered;
  end;

  CalendarCombo1 := TlqCalendarCheckCombo.Create(self);
  with CalendarCombo1 do
  begin
    Name := 'CalendarCombo1';
    SetPosition(132, 308, 120, 22);
    Checked := True;
    DateFormat := 'yyyy-mm-dd';
    FontDesc := '#List';
    Hint := '';
    TabOrder := 18;
  end;

  Label1 := TlqLabel.Create(self);
  with Label1 do
  begin
    Name := 'Label1';
    SetPosition(8, 312, 116, 16);
    FontDesc := '#Label1';
    Hint := '';
    Text := 'Optional date:';
  end;

  cbSingleClickClose := TlqCheckBox.Create(self);
  with cbSingleClickClose do
  begin
    Name := 'cbSingleClickClose';
    SetPosition(128, 112, 236, 20);
    FontDesc := '#Label1';
    Hint := '';
    TabOrder := 20;
    Text := 'Single click selection';
    OnChange := @cbSingleClickCloseChanged;
  end;

  {@VFD_BODY_END: MainForm}
end;


{@VFD_NEWFORM_IMPL}

procedure MainProc;
var
  frm: TMainForm;
begin
  lqApplication.Initialize;
  frm := TMainForm.Create(nil);
  try
    frm.Show;
    lqApplication.Run;
  finally
    frm.Free;
  end;
end;

begin
  MainProc;
end.



