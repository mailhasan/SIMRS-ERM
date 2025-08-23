unit unitDmKoneksi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset,IniFiles,Dialogs;

type

  { TDataModuleKoneksi }

  TDataModuleKoneksi = class(TDataModule)
    ZConnectionSimrsERM: TZConnection;
    ZQueryPegawai: TZQuery;
    ZQueryUser: TZQuery;
    procedure DataModuleCreate(Sender: TObject);
    function LoadConfigDB: Boolean;
  private

  public

  end;

var
  DataModuleKoneksi: TDataModuleKoneksi;

implementation

{$R *.lfm}

{ TDataModuleKoneksi }

procedure TDataModuleKoneksi.DataModuleCreate(Sender: TObject);
begin
  if not LoadConfigDB then
    ShowMessage('Gagal memuat konfigurasi koneksi database!');
end;

function TDataModuleKoneksi.LoadConfigDB: Boolean;
var
  ini: TIniFile;
  filePath: string;
begin
  Result := False;
  filePath := ExtractFilePath(ApplicationName) + 'config.ini';

  if not FileExists(filePath) then
  begin
    ShowMessage('File config.ini tidak ditemukan!');
    Exit;
  end;

  ini := TIniFile.Create(filePath);
  try
    ZConnectionSimrsERM.Disconnect;
    ZConnectionSimrsERM.HostName := ini.ReadString('Database', 'Host', 'localhost');
    ZConnectionSimrsERM.LibraryLocation := ini.ReadString('Database', 'lib', 'libmysql.dll');
    ZConnectionSimrsERM.Port     := ini.ReadInteger('Database', 'Port', 3307);
    ZConnectionSimrsERM.Database := ini.ReadString('Database', 'Nama', '');
    ZConnectionSimrsERM.User     := ini.ReadString('Database', 'User', '');
    ZConnectionSimrsERM.Password := ini.ReadString('Database', 'Pass', '');
    ZConnectionSimrsERM.Protocol := 'mysql';

    ZConnectionSimrsERM.Connect;
    Result := ZConnectionSimrsERM.Connected;
  except
    on E: Exception do
      ShowMessage('Koneksi gagal: ' + E.Message);
  end;
  ini.Free;
end;

end.

