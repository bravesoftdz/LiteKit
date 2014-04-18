unit regfpguitestrunner;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, lazideintf, ProjectIntf, Controls, Forms;
  
Type

  { TlqUITestRunnerProjectDescriptor }
  TlqUITestRunnerProjectDescriptor = class(TProjectDescriptor)
  public
    constructor Create; override;
    function GetLocalizedName: string; override;
    function GetLocalizedDescription: string; override;
    function InitProject(AProject: TLazProject) : TModalResult; override;
    function CreateStartFiles(AProject: TLazProject) : TModalResult; override;
  published
    { Published declarations }
  end;
  
var
  LiteKitFTestRunnerProjectDescriptor : TlqUITestRunnerProjectDescriptor;
  
procedure Register;

implementation
{$define uselazideintf}
{$ifdef uselazideintf}
uses FPCUnitLazIDEIntf;
{$endif}

procedure Register;

begin
  LiteKitFTestRunnerProjectDescriptor:=TlqUITestRunnerProjectDescriptor.Create;
  RegisterProjectDescriptor(LiteKitFTestRunnerProjectDescriptor);
end;

{ TlqUITestRunnerProjectDescriptor }

constructor TlqUITestRunnerProjectDescriptor.Create;
begin
  inherited Create;
  Name:='FPCUnit LiteKit Application';
end;
    
function TlqUITestRunnerProjectDescriptor.GetLocalizedName: string;
begin
  Result:='FPGUITestRunner';
end;

function TlqUITestRunnerProjectDescriptor.GetLocalizedDescription: string;
begin
  Result:='FPCUnit test runner application using a LiteKit front-end';
end;

function TlqUITestRunnerProjectDescriptor.InitProject(AProject: TLazProject
  ): TModalResult;
  
Var
  L : TStrings;
  MainFile: TLazProjectFile;

begin
  inherited InitProject(AProject);

  MainFile:=AProject.CreateProjectFile('fpcunitproject1.lpr');
  MainFile.IsPartOfProject:=true;
  AProject.AddFile(MainFile,false);
  AProject.MainFileID:=0;
  L:=TStringList.Create;
  try
    With L do
      begin
      Add('program fpcunitproject1;');
      Add('');
      Add('{$mode objfpc}{$H+}');
      Add('');
      Add('uses');
      Add('  {$IFDEF UNIX}{$IFDEF UseCThreads}');
      Add('  cthreads,');
      Add('  {$ENDIF}{$ENDIF}');
      Add('  Classes,');
      Add('  lq_main, lq_guitestrunner;');
      Add('');
      Add('procedure MainProc;');
      Add('');
      Add('var');
      Add('  frm: TGUITestRunnerForm;');
      Add('');
      Add('begin');
      Add('  lqApplication.Initialize;');
      Add('  frm := TGUITestRunnerForm.Create(nil);');
      Add('  try');
      Add('    frm.Show;');
      Add('    lqApplication.Run;');
      Add('  finally');
      Add('    frm.Free;');
      Add('  end;');
      Add('end;');
      Add('');
      Add('begin');
      Add('  MainProc;');
      Add('end.');
      end;
    AProject.MainFile.SetSourceText(L.text);
  finally
    L.Free;
  end;
  // add dependencies
  AProject.AddPackageDependency('FCL');
  AProject.AddPackageDependency('guitestrunner_fpgui');
  // Don't know if this is needed, actually.
  //  AProject.AddPackageDependency('FPCUnitTestRunner');
  Result:=mrOK;
end;

function TlqUITestRunnerProjectDescriptor.CreateStartFiles(
  AProject: TLazProject): TModalResult;
begin
{$ifdef uselazideintf}
  LazarusIDE.DoNewEditorFile(FileDescriptorFPCUnitTestCase,'','',
                         [nfIsPartOfProject,nfOpenInEditor,nfCreateDefaultSrc]);
{$endif}
  Result:=mrOK;
end;

end.

