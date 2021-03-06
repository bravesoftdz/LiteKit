{ Demo program for PDF Reporting engine }

program pdf_demo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,
  lq_main,
  U_Demo;

procedure MainProc;
var
  frm: TF_Demo;
begin
  lqApplication.Initialize;
  frm := TF_Demo.Create(nil);
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

