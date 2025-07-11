program SIMRS_ERM;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, datetimectrls, unitLogin, unitUtama, unitDmKoneksi, zcomponent,
  unitRawatInap, unitdmrawatinap, unitKamar;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TDataModuleKoneksi, DataModuleKoneksi);
  Application.CreateForm(TDataModuleRanap, DataModuleRanap);
  Application.CreateForm(TFormKamar, FormKamar);
  Application.Run;
end.

