unit unitAiAuditKeluhan;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ZDataset,fphttpclient, fpjson, jsonparser;

type

  { TFormAiAuditKeluhan }

  TFormAiAuditKeluhan = class(TForm)
    Button1: TButton;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    MemoAnalisaRekomendasi: TMemo;
    MemoRiwayatKeluhan: TMemo;
    PanelTengah: TPanel;
    PanelBawah: TPanel;
    Panel3: TPanel;
    PanelAtas: TPanel;
    ZQuery1: TZQuery;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public
   procedure LoadRiwayatKeluhan(NoRawat: string);
   procedure KirimKeGeminiMelaluiPHP;
  end;

var
  FormAiAuditKeluhan: TFormAiAuditKeluhan;

implementation

{$R *.lfm}
uses unitDmKoneksi,unitRiwayatPasien;

procedure TFormAiAuditKeluhan.FormShow(Sender: TObject);
begin
  // Contoh memanggil dengan nomor rawat yang Anda berikan
  LoadRiwayatKeluhan('2026/05/07/042095');
end;

procedure TFormAiAuditKeluhan.Button1Click(Sender: TObject);
begin
 KirimKeGeminiMelaluiPHP;
end;

procedure TFormAiAuditKeluhan.LoadRiwayatKeluhan(NoRawat: string);
var
  zqAudit: TZQuery;
begin
  // Inisialisasi Query Internal
  zqAudit := TZQuery.Create(Self);
  try
    zqAudit.Connection := DataModuleKoneksi.ZConnectionSimrsERM; // Sesuaikan dengan nama ZConnection Anda
    MemoRiwayatKeluhan.Lines.Clear;
    MemoRiwayatKeluhan.Lines.Add('--- RIWAYAT KELUHAN PASIEN (' + NoRawat + ') ---');
    MemoRiwayatKeluhan.Lines.Add('');

    // 1. Ambil Data Triase IGD Primer
    zqAudit.SQL.Text := 'SELECT keluhan_utama FROM data_triase_igdprimer WHERE no_rawat = :no_rawat';
    zqAudit.ParamByName('no_rawat').AsString := NoRawat;
    zqAudit.Open;
    if not zqAudit.IsEmpty then
      MemoRiwayatKeluhan.Lines.Add('[TRIASE PRIMER]: ' + zqAudit.FieldByName('keluhan_utama').AsString);
    zqAudit.Close;

    // 2. Ambil Data Triase IGD Sekunder
    zqAudit.SQL.Text := 'SELECT anamnesa_singkat FROM data_triase_igdsekunder WHERE no_rawat = :no_rawat';
    zqAudit.ParamByName('no_rawat').AsString := NoRawat;
    zqAudit.Open;
    if not zqAudit.IsEmpty then
      MemoRiwayatKeluhan.Lines.Add('[TRIASE SEKUNDER]: ' + zqAudit.FieldByName('anamnesa_singkat').AsString);
    zqAudit.Close;

    // 3. Ambil Penilaian Medis IGD
    zqAudit.SQL.Text := 'SELECT keluhan_utama FROM penilaian_medis_igd WHERE no_rawat = :no_rawat';
    zqAudit.ParamByName('no_rawat').AsString := NoRawat;
    zqAudit.Open;
    if not zqAudit.IsEmpty then
      MemoRiwayatKeluhan.Lines.Add('[MEDIS IGD]: ' + zqAudit.FieldByName('keluhan_utama').AsString);
    zqAudit.Close;

    // 4. Ambil Pemeriksaan Rawat Jalan
    zqAudit.SQL.Text := 'SELECT keluhan FROM pemeriksaan_ralan WHERE no_rawat = :no_rawat';
    zqAudit.ParamByName('no_rawat').AsString := NoRawat;
    zqAudit.Open;
    if not zqAudit.IsEmpty then
    begin
      MemoRiwayatKeluhan.Lines.Add('[RAWAT JALAN]:');
      while not zqAudit.Eof do
      begin
        MemoRiwayatKeluhan.Lines.Add('- ' + zqAudit.FieldByName('keluhan').AsString);
        zqAudit.Next;
      end;
    end;
    zqAudit.Close;

    // 5. Ambil Pemeriksaan Rawat Inap
    zqAudit.SQL.Text := 'SELECT keluhan FROM pemeriksaan_ranap WHERE no_rawat = :no_rawat';
    zqAudit.ParamByName('no_rawat').AsString := NoRawat;
    zqAudit.Open;
    if not zqAudit.IsEmpty then
    begin
      MemoRiwayatKeluhan.Lines.Add('[RAWAT INAP]:');
      while not zqAudit.Eof do
      begin
        MemoRiwayatKeluhan.Lines.Add('- ' + zqAudit.FieldByName('keluhan').AsString);
        zqAudit.Next;
      end;
    end;
    zqAudit.Close;

    if MemoRiwayatKeluhan.Lines.Count <= 3 then
       MemoRiwayatKeluhan.Lines.Add('Data riwayat tidak ditemukan.');

  finally
    zqAudit.Free;
  end;
end;

procedure TFormAiAuditKeluhan.KirimKeGeminiMelaluiPHP;
var
  HTTPClient: TFPHTTPClient;
  RawData: TJSONObject;
  JSONStream: TStringStream;
  ResponseStream: TStringStream;
  URL: string;
begin
  URL := 'http://localhost/www/gemini/ai_auditkeluhan.php';

  HTTPClient := TFPHTTPClient.Create(Nil);
  RawData := TJSONObject.Create;
  ResponseStream := TStringStream.Create('');
  try
    RawData.Add('no_rawat', '2026/05/07/042095');
    RawData.Add('konten_medis', MemoRiwayatKeluhan.Text);

    JSONStream := TStringStream.Create(RawData.AsJSON, TEncoding.UTF8);
    try
      HTTPClient.AddHeader('Content-Type', 'application/json');
      HTTPClient.IOTimeout := 40000;

      // PENTING: Jangan gunakan := pada baris Post
      HTTPClient.RequestBody := JSONStream;
      HTTPClient.Post(URL, ResponseStream);

      // Ambil hasil dari ResponseStream
      MemoAnalisaRekomendasi.Lines.Clear;
      MemoAnalisaRekomendasi.Lines.Text := ResponseStream.DataString;

    finally
      JSONStream.Free;
    end;
  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;

  ResponseStream.Free;
  RawData.Free;
  HTTPClient.Free;
end;

end.
