unit unitdmpendaftaran;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZDataset;

type

  { TDataModulePendaftaran }

  TDataModulePendaftaran = class(TDataModule)
    ZQuery1: TZQuery;
  private

  public

  end;

var
  DataModulePendaftaran: TDataModulePendaftaran;

implementation

{$R *.lfm}
uses unitDmKoneksi;


end.

