unit unitDmKoneksi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection;

type

  { TDataModuleKoneksi }

  TDataModuleKoneksi = class(TDataModule)
    ZConnectionSimrsERM: TZConnection;
  private

  public

  end;

var
  DataModuleKoneksi: TDataModuleKoneksi;

implementation

{$R *.lfm}

end.

