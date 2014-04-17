program fpcunitproject;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,
  lq_base, lq_main, lq_guitestrunner, tcTreeview;

procedure MainProc;

var
  frm: TGUITestRunnerForm;

begin
  fpgApplication.Initialize;
  frm := TGUITestRunnerForm.Create(nil);
  try
    frm.Show;
    fpgApplication.Run;
  finally
    frm.Free;
  end;
end;

begin
  MainProc;
end.
