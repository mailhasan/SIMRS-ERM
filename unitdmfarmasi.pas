unit unitDmFarmasi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZDataset;

type

  { TDataModuleFarmasi }

  TDataModuleFarmasi = class(TDataModule)
    ZQueryResepRacikanDetail: TZQuery;
    ZQueryResepRacikan: TZQuery;
    ZQueryResepDetail: TZQuery;
    ZQueryResep: TZQuery;
  private

  public


  end;

var
  DataModuleFarmasi: TDataModuleFarmasi;

implementation

{$R *.lfm}
uses unitDmKoneksi;




end.


