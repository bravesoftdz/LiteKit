program EditGridDemo;

{$mode objfpc}{$H+}

uses
  Classes,fpgui_toolkit
  { you can add units after this },
  lq_main, u_demo, u_editgrid;

procedure MainProc;
begin
fpgApplication.Initialize;
F_Demo:= TF_Demo.Create(nil);
try
  F_Demo.Show;
  lqApplication.Run;
finally
  F_Demo.Free;
  end;
end;

begin
MainProc;
end.

