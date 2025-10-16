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
  Forms, FrameViewer09, datetimectrls, anchordockpkg, unitLogin, unitUtama,
  unitDmKoneksi, zcomponent, unitRawatInap, unitdmrawatinap, unitKamar,
  unitERMRanapDokter, unitDmFarmasi, unitIGD, unitDmIgd, unitPemeriksaanIGD,
  unitTriaseIgd;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TDataModuleKoneksi, DataModuleKoneksi);
  Application.CreateForm(TDataModuleRanap, DataModuleRanap);
  Application.CreateForm(TDataModuleFarmasi, DataModuleFarmasi);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TFormKamar, FormKamar);
  Application.CreateForm(TFormERMRanapDokter, FormERMRanapDokter);
  Application.CreateForm(TFormIGD, FormIGD);
  Application.CreateForm(TDataModuleIgd, DataModuleIgd);
  Application.CreateForm(TFormPemeriksaanIgd, FormPemeriksaanIgd);
  Application.CreateForm(TFormTriaseIgd, FormTriaseIgd);
  Application.Run;
end.

