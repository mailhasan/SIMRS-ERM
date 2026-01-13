unit unitDmFarmasi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZDataset,Dialogs;

type
  TResepHeader = record
    NoResep     : string;
    TglResep    : TDate;
    JamResep    : string;
    NoRawat     : string;
    NoRM        : string;
    NamaPasien  : string;
    KodeDokter  : string;
    NamaDokter  : string;
    Status      : string;
    StatusAsal  : string;
    StatusLanjut : String;
  end;

  TResepHeaderArray = array of TResepHeader;

 // Record untuk Obat Biasa
  TResepDetailObat = record
    KodeBrng, NamaBrng, Satuan, Aturan: string;
    Jumlah: Double; // Kita gunakan nama 'Jumlah' agar seragam
  end;
  TResepDetailObatArray = array of TResepDetailObat;

  // Record untuk Komposisi Racikan
  TKomposisiRacikan = record
    KodeBrng, NamaBrng, Satuan: string;
    Jumlah: Double;
  end;
  TKomposisiArray = array of TKomposisiRacikan;

  // Record untuk Header Racikan
  TResepRacikan = record
    NoRacik, NamaRacik, Metode, Aturan, Keterangan: string;
    Jumlah: Double;
    Komposisi: TKomposisiArray;
  end;
  TResepRacikanArray = array of TResepRacikan;

type

  { TDataModuleFarmasi }

  TDataModuleFarmasi = class(TDataModule)
    zqResepHeader: TZQuery;
    ZQueryObatResep: TZQuery;
    ZQueryResepRacikanDetail: TZQuery;
    ZQueryResepRacikan: TZQuery;
    ZQueryResepDetail: TZQuery;
    ZQueryResep: TZQuery;

  private

  public
   procedure LoadResepHeader(const ANoRawat: string; const ATglAwal, ATglAkhir: TDate; const ALimit: string; out AData: TResepHeaderArray);

   procedure LoadDetailObat(const ANoResep: string; out AData: TResepDetailObatArray);
   procedure LoadDetailRacikan(const ANoResep: string; out AData: TResepRacikanArray);
  end;

var
  DataModuleFarmasi: TDataModuleFarmasi;

implementation

{$R *.lfm}
uses unitDmKoneksi;


{procedure TDataModuleFarmasi.LoadResepHeader(
  const ANoRM: string;
  const ATglAwal, ATglAkhir: TDate;
  const AKodeDokter: string;
  out AData: TResepHeaderArray
);
var
  i: Integer;
begin
  zqResepHeader.Close;
  zqResepHeader.SQL.Clear;

  // Query yang lebih robust
  zqResepHeader.SQL.Text :=
    'SELECT ' +
    '  ro.no_resep, ' +
    '  ro.tgl_peresepan, ' +
    '  ro.jam_peresepan, ' +
    '  ro.no_rawat, ' +
    '  p.no_rkm_medis, ' +
    '  p.nm_pasien, ' +
    '  ro.kd_dokter, ' +
    '  d.nm_dokter, ' +
    '  CASE ' +
    '    WHEN ro.tgl_perawatan IS NULL OR ro.tgl_perawatan = ''0000-00-00'' THEN ''Belum Terlayani'' ' +
    '    ELSE ''Sudah Terlayani'' ' +
    '  END AS status, ' +
    '  COALESCE(ro.status, '''') AS status_asal ' +
    'FROM resep_obat ro ' +
    'LEFT JOIN reg_periksa rp ON ro.no_rawat = rp.no_rawat ' +
    'LEFT JOIN pasien p ON rp.no_rkm_medis = p.no_rkm_medis ' +
    'LEFT JOIN dokter d ON ro.kd_dokter = d.kd_dokter ' +
    'WHERE 1=1 ';

  // Filter tanggal
  if (ATglAwal > 0) and (ATglAkhir > 0) then
  begin
    zqResepHeader.SQL.Add('AND DATE(ro.tgl_peresepan) BETWEEN :tgl1 AND :tgl2');
  end
  else
  begin
    // Jika tidak ada tanggal, ambil semua
    zqResepHeader.SQL.Add('AND ro.tgl_peresepan IS NOT NULL');
  end;

  // Filter No RM
  if Trim(ANoRM) <> '' then
    zqResepHeader.SQL.Add('AND p.no_rkm_medis = :norm');

  // Filter Dokter
  if Trim(AKodeDokter) <> '' then
    zqResepHeader.SQL.Add('AND ro.kd_dokter = :dokter');

  // Urutkan
  zqResepHeader.SQL.Add(
    'ORDER BY ' +
    '  CASE WHEN ro.tgl_peresepan IS NULL THEN 1 ELSE 0 END, ' +
    '  ro.tgl_peresepan DESC, ' +
    '  ro.jam_peresepan DESC ' +
    'LIMIT 100'
  );

  // Set parameter hanya jika diperlukan
  if (ATglAwal > 0) and (ATglAkhir > 0) then
  begin
    zqResepHeader.ParamByName('tgl1').AsDate := ATglAwal;
    zqResepHeader.ParamByName('tgl2').AsDate := ATglAkhir;
  end;

  if Trim(ANoRM) <> '' then
    zqResepHeader.ParamByName('norm').AsString := Trim(ANoRM);

  if Trim(AKodeDokter) <> '' then
    zqResepHeader.ParamByName('dokter').AsString := Trim(AKodeDokter);

  try
    zqResepHeader.Open;

    // Debug: Tampilkan jumlah record
    // ShowMessage('Record ditemukan: ' + IntToStr(zqResepHeader.RecordCount));

    SetLength(AData, zqResepHeader.RecordCount);
    i := 0;

    while not zqResepHeader.EOF do
    begin
      AData[i].NoResep    := zqResepHeader.FieldByName('no_resep').AsString;

      // Tangani tanggal yang mungkin null
      if not zqResepHeader.FieldByName('tgl_peresepan').IsNull then
        AData[i].TglResep := zqResepHeader.FieldByName('tgl_peresepan').AsDateTime
      else
        AData[i].TglResep := 0;

      AData[i].JamResep   := zqResepHeader.FieldByName('jam_peresepan').AsString;
      AData[i].NoRawat    := zqResepHeader.FieldByName('no_rawat').AsString;
      AData[i].NoRM       := zqResepHeader.FieldByName('no_rkm_medis').AsString;
      AData[i].NamaPasien := zqResepHeader.FieldByName('nm_pasien').AsString;
      AData[i].KodeDokter := zqResepHeader.FieldByName('kd_dokter').AsString;
      AData[i].NamaDokter := zqResepHeader.FieldByName('nm_dokter').AsString;
      AData[i].Status     := zqResepHeader.FieldByName('status').AsString;
      AData[i].StatusAsal := zqResepHeader.FieldByName('status_asal').AsString;

      Inc(i);
      zqResepHeader.Next;
    end;

    // Jika tidak ada data, set array kosong
    if zqResepHeader.RecordCount = 0 then
      SetLength(AData, 0);

  except
    on E: Exception do
    begin
      ShowMessage('Error query resep: ' + E.Message);
      SetLength(AData, 0);
    end;
  end;
end;}

{ Prosedur Load Header Resep dengan Filter Tanggal & Limit }
procedure TDataModuleFarmasi.LoadResepHeader(const ANoRawat: string; const ATglAwal, ATglAkhir: TDate; const ALimit: string; out AData: TResepHeaderArray);
var
  i: Integer;
begin
  zqResepHeader.Close;
  zqResepHeader.SQL.Text :=
    'SELECT ro.no_resep, ro.tgl_peresepan, ro.jam_peresepan, ro.no_rawat, ' +
    'rp.no_rkm_medis, rp.status_lanjut, p.nm_pasien, ro.kd_dokter, d.nm_dokter, ' +
    'CASE WHEN ro.tgl_perawatan IS NULL OR ro.tgl_perawatan = "0000-00-00" THEN "Belum Terlayani" ELSE "Sudah Terlayani" END AS status_layan, ' +
    'ro.status AS status_asal ' +
    'FROM resep_obat ro ' +
    'LEFT JOIN reg_periksa rp ON ro.no_rawat = rp.no_rawat ' +
    'LEFT JOIN pasien p ON rp.no_rkm_medis = p.no_rkm_medis ' +
    'LEFT JOIN dokter d ON ro.kd_dokter = d.kd_dokter ' +
    'WHERE rp.no_rkm_medis = :no_rawat ';

  { Tambahkan Filter Tanggal jika tidak 0 }
  if (ATglAwal > 0) then
    zqResepHeader.SQL.Add('AND ro.tgl_peresepan BETWEEN :tgl1 AND :tgl2 ');

  zqResepHeader.SQL.Add('ORDER BY ro.tgl_peresepan DESC, ro.jam_peresepan DESC');

  { Tambahkan Limit (misal: LIMIT 10) }
  if ALimit <> '' then zqResepHeader.SQL.Add(ALimit);

  zqResepHeader.ParamByName('no_rawat').AsString := ANoRawat;
  if (ATglAwal > 0) then
  begin
    zqResepHeader.ParamByName('tgl1').AsDate := ATglAwal;
    zqResepHeader.ParamByName('tgl2').AsDate := ATglAkhir;
  end;

  try
    zqResepHeader.Open;
    SetLength(AData, zqResepHeader.RecordCount);
    i := 0;
    while not zqResepHeader.Eof do
    begin
      with AData[i] do
      begin
        NoResep      := zqResepHeader.FieldByName('no_resep').AsString;
        TglResep     := zqResepHeader.FieldByName('tgl_peresepan').AsDateTime;
        JamResep     := zqResepHeader.FieldByName('jam_peresepan').AsString;
        NoRawat      := zqResepHeader.FieldByName('no_rawat').AsString;
        NoRM         := zqResepHeader.FieldByName('no_rkm_medis').AsString;
        NamaPasien   := zqResepHeader.FieldByName('nm_pasien').AsString;
        KodeDokter   := zqResepHeader.FieldByName('kd_dokter').AsString;
        NamaDokter   := zqResepHeader.FieldByName('nm_dokter').AsString;
        Status       := zqResepHeader.FieldByName('status_layan').AsString;
        StatusAsal   := zqResepHeader.FieldByName('status_asal').AsString;
        StatusLanjut := zqResepHeader.FieldByName('status_lanjut').AsString;
      end;
      Inc(i);
      zqResepHeader.Next;
    end;
  except
    on E: Exception do SetLength(AData, 0);
  end;
end;


{ --- Prosedur 1: Load Obat Non-Racikan --- }
procedure TDataModuleFarmasi.LoadDetailObat(const ANoResep: string; out AData: TResepDetailObatArray);
var i: Integer;
begin
  ZQueryResepDetail.Close;
  ZQueryResepDetail.SQL.Text :=
    'SELECT db.kode_brng, db.nama_brng, rd.jml, db.kode_sat, rd.aturan_pakai ' +
    'FROM resep_dokter rd ' +
    'INNER JOIN databarang db ON rd.kode_brng = db.kode_brng ' +
    'WHERE rd.no_resep = :no_resep ORDER BY db.kode_brng';
  ZQueryResepDetail.ParamByName('no_resep').AsString := ANoResep;

  try
    ZQueryResepDetail.Open;
    SetLength(AData, ZQueryResepDetail.RecordCount);
    i := 0;
    while not ZQueryResepDetail.EOF do
    begin
      AData[i].KodeBrng := ZQueryResepDetail.FieldByName('kode_brng').AsString;
      AData[i].NamaBrng := ZQueryResepDetail.FieldByName('nama_brng').AsString;
      AData[i].Jumlah   := ZQueryResepDetail.FieldByName('jml').AsFloat;
      AData[i].Satuan   := ZQueryResepDetail.FieldByName('kode_sat').AsString;
      AData[i].Aturan   := ZQueryResepDetail.FieldByName('aturan_pakai').AsString;
      Inc(i);
      ZQueryResepDetail.Next;
    end;
  except
    on E: Exception do ShowMessage('Error LoadDetailObat: ' + E.Message);
  end;
end;

{ --- Prosedur 2: Load Header Racikan & Komposisinya --- }
procedure TDataModuleFarmasi.LoadDetailRacikan(const ANoResep: string; out AData: TResepRacikanArray);
var
  i, j: Integer;
begin
  // A. Ambil Header Racikan
  ZQueryResepRacikan.Close;
  ZQueryResepRacikan.SQL.Text :=
    'SELECT rdr.no_racik, rdr.nama_racik, mr.nm_racik as metode, ' +
    'rdr.jml_dr, rdr.aturan_pakai, rdr.keterangan ' +
    'FROM resep_dokter_racikan rdr ' +
    'INNER JOIN metode_racik mr ON rdr.kd_racik = mr.kd_racik ' +
    'WHERE rdr.no_resep = :no_resep';
  ZQueryResepRacikan.ParamByName('no_resep').AsString := ANoResep;

  try
    ZQueryResepRacikan.Open;
    SetLength(AData, ZQueryResepRacikan.RecordCount);
    i := 0;
    while not ZQueryResepRacikan.EOF do
    begin
      AData[i].NoRacik    := ZQueryResepRacikan.FieldByName('no_racik').AsString;
      AData[i].NamaRacik  := ZQueryResepRacikan.FieldByName('nama_racik').AsString;
      AData[i].Metode     := ZQueryResepRacikan.FieldByName('metode').AsString;
      AData[i].Jumlah     := ZQueryResepRacikan.FieldByName('jml_dr').AsFloat;
      AData[i].Aturan     := ZQueryResepRacikan.FieldByName('aturan_pakai').AsString;
      AData[i].Keterangan := ZQueryResepRacikan.FieldByName('keterangan').AsString;

      // B. Ambil Komposisi Barang untuk racikan ini (Query Ketiga)
      ZQueryResepRacikanDetail.Close;
      ZQueryResepRacikanDetail.SQL.Text :=
        'SELECT db.kode_brng, db.nama_brng, rdrd.jml, db.kode_sat ' +
        'FROM resep_dokter_racikan_detail rdrd ' +
        'INNER JOIN databarang db ON rdrd.kode_brng = db.kode_brng ' +
        'WHERE rdrd.no_resep = :no_resep AND rdrd.no_racik = :no_racik';
      ZQueryResepRacikanDetail.ParamByName('no_resep').AsString := ANoResep;
      ZQueryResepRacikanDetail.ParamByName('no_racik').AsString := AData[i].NoRacik;
      ZQueryResepRacikanDetail.Open;

      SetLength(AData[i].Komposisi, ZQueryResepRacikanDetail.RecordCount);
      j := 0;
      while not ZQueryResepRacikanDetail.EOF do
      begin
        AData[i].Komposisi[j].KodeBrng := ZQueryResepRacikanDetail.FieldByName('kode_brng').AsString;
        AData[i].Komposisi[j].NamaBrng := ZQueryResepRacikanDetail.FieldByName('nama_brng').AsString;
        AData[i].Komposisi[j].Jumlah   := ZQueryResepRacikanDetail.FieldByName('jml').AsFloat;
        AData[i].Komposisi[j].Satuan   := ZQueryResepRacikanDetail.FieldByName('kode_sat').AsString;
        Inc(j);
        ZQueryResepRacikanDetail.Next;
      end;

      Inc(i);
      ZQueryResepRacikan.Next;
    end;
  except
    on E: Exception do ShowMessage('Error LoadDetailRacikan: ' + E.Message);
  end;
end;



end.


