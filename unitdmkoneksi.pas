unit unitDmKoneksi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, ZDataset,IniFiles, Dialogs, Forms;

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
    ShowMessage('❌ Gagal memuat konfigurasi koneksi database!');
end;
function TDataModuleKoneksi.LoadConfigDB: Boolean;
var
  ini: TIniFile;
  filePath: string;
begin
  Result := False;

  // Lokasi file config.ini di folder .exe
  filePath := ExtractFilePath(ParamStr(0)) + 'config.ini';

  // Debug lokasi
  if not FileExists(filePath) then
  begin
    ShowMessage('File config.ini tidak ditemukan di: ' + filePath);
    Exit;
  end;

  ini := TIniFile.Create(filePath);
  try
    // --- Coba baca konfigurasi
    ShowMessage('Host DB: ' + ini.ReadString('Database', 'Host', 'tidak ditemukan'));

    // Set koneksi ZConnection
    ZConnectionSimrsERM.Disconnect;
    ZConnectionSimrsERM.HostName := ini.ReadString('Database', 'Host', 'localhost');
    ZConnectionSimrsERM.LibraryLocation := ini.ReadString('Database', 'lib', 'libmariadb.dll');
    ZConnectionSimrsERM.Port := ini.ReadInteger('Database', 'Port', 3306);
    ZConnectionSimrsERM.Database := ini.ReadString('Database', 'Nama', '');
    ZConnectionSimrsERM.User := ini.ReadString('Database', 'User', '');
    ZConnectionSimrsERM.Password := ini.ReadString('Database', 'Pass', '');
    ZConnectionSimrsERM.Protocol := 'mysql';

    ZConnectionSimrsERM.Connect;
    Result := ZConnectionSimrsERM.Connected;

    if Result then
      ShowMessage('Koneksi database berhasil!')
    else
      ShowMessage('Koneksi database gagal!');
  except
    on E: Exception do
      ShowMessage('Koneksi gagal: ' + E.Message);
  end;
  ini.Free;
end;


end.

