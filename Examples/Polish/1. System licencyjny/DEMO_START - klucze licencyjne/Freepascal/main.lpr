program main;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, gui, LResources
  { you can add units after this };

{$IFDEF WINDOWS}{$R main.rc}{$ENDIF}

begin
  {$I main.lrs}
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.

