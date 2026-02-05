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
  unitTriaseIgd, unitdmrawatjalan, unitRawatJalan, unitCariPoli,
  unitTtdSoapRehab, unitPeresepanDokter, unitPendaftaran, unitPersetujuanUmum,
  unitdmpendaftaran;

{$R *.res}

begin
  RequireDerivedFormResource:=True;
  Application.Scaled:=True;
  Application.Initialize;
  Application.CreateForm(TDataModuleKoneksi, DataModuleKoneksi);
  Application.CreateForm(TDataModuleRanap, DataModuleRanap);
  Application.CreateForm(TDataModuleFarmasi, DataModuleFarmasi);
  Application.CreateForm(TFormLogin, FormLogin);
  Application.CreateForm(TDataModuleIgd, DataModuleIgd);
  Application.CreateForm(TDataModuleRawatJalan, DataModuleRawatJalan);
  Application.CreateForm(TFormUtama, FormUtama);
  Application.CreateForm(TDataModulePendaftaran, DataModulePendaftaran);
  Application.Run;
end.

