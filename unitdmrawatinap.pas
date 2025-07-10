unit unitdmrawatinap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,unitDmKoneksi, DB, ZDataset;

type

  { TDataModuleRanap }

  TDataModuleRanap = class(TDataModule)
    DsRawatInap: TDataSource;
    ZQRRawatInap: TZQuery;
  private

  public
   ///procedure CariRawatInap(NoRM, Nama, Dokter, Kamar, Status: string);
  procedure CariData(
      NoRM, NamaPasien, NamaDokter, KodeKamar, StatusPulang: string;
      TglMasukAwal, TglMasukAkhir, TglKeluarAwal, TglKeluarAkhir: TDate
    );
  end;


var
  DataModuleRanap: TDataModuleRanap;

implementation

{$R *.lfm}

{procedure TDataModuleRanap.CariRawatInap(NoRM, Nama, Dokter, Kamar, Status: string);
begin
  ZQRRawatInap.Close;
  ZQRRawatInap.SQL.Clear;

  ZQRRawatInap.SQL.Add('SELECT');
  ZQRRawatInap.SQL.Add('  reg_periksa.no_rawat, pasien.no_rkm_medis, pasien.nm_pasien, pasien.alamat,');
  ZQRRawatInap.SQL.Add('  reg_periksa.p_jawab, reg_periksa.hubunganpj, penjab.png_jawab, kamar.kd_kamar, kamar.trf_kamar,');
  ZQRRawatInap.SQL.Add('  kamar_inap.diagnosa_awal, kamar_inap.diagnosa_akhir, kamar_inap.tgl_masuk, kamar_inap.jam_masuk,');
  ZQRRawatInap.SQL.Add('  kamar_inap.tgl_keluar, kamar_inap.jam_keluar, kamar_inap.ttl_biaya, kamar_inap.stts_pulang,');
  ZQRRawatInap.SQL.Add('  kamar_inap.lama, dokter.nm_dokter, kamar.kd_kamar, reg_periksa.status_bayar, pasien.agama');
  ZQRRawatInap.SQL.Add('FROM kamar_inap');
  ZQRRawatInap.SQL.Add('JOIN reg_periksa ON kamar_inap.no_rawat = reg_periksa.no_rawat');
  ZQRRawatInap.SQL.Add('JOIN pasien ON reg_periksa.no_rkm_medis = pasien.no_rkm_medis');
  ZQRRawatInap.SQL.Add('JOIN penjab ON reg_periksa.kd_pj = penjab.kd_pj');
  ZQRRawatInap.SQL.Add('JOIN kamar ON kamar_inap.kd_kamar = kamar.kd_kamar');
  ZQRRawatInap.SQL.Add('JOIN dokter ON reg_periksa.kd_dokter = dokter.kd_dokter');
  ZQRRawatInap.SQL.Add('WHERE 1=1');

  if Trim(NoRM) <> '' then
    ZQRRawatInap.SQL.Add('AND pasien.no_rkm_medis LIKE :NoRM');
  if Trim(Nama) <> '' then
    ZQRRawatInap.SQL.Add('AND pasien.nm_pasien LIKE :Nama');
  if Trim(Dokter) <> '' then
    ZQRRawatInap.SQL.Add('AND dokter.nm_dokter LIKE :Dokter');
  if Trim(Kamar) <> '' then
    ZQRRawatInap.SQL.Add('AND kamar.kd_kamar LIKE :Kamar');
  if Trim(Status) <> '' then
    ZQRRawatInap.SQL.Add('AND kamar_inap.stts_pulang = :Status')
  else
    ZQRRawatInap.SQL.Add('AND (kamar_inap.stts_pulang IS NULL OR kamar_inap.stts_pulang = '''')');

  if Trim(NoRM) <> '' then
    ZQRRawatInap.ParamByName('NoRM').AsString := '%' + NoRM + '%';
  if Trim(Nama) <> '' then
    ZQRRawatInap.ParamByName('Nama').AsString := '%' + Nama + '%';
  if Trim(Dokter) <> '' then
    ZQRRawatInap.ParamByName('Dokter').AsString := '%' + Dokter + '%';
  if Trim(Kamar) <> '' then
    ZQRRawatInap.ParamByName('Kamar').AsString := '%' + Kamar + '%';
  if Trim(Status) <> '' then
    ZQRRawatInap.ParamByName('Status').AsString := Status;

  ZQRRawatInap.Open;
end;}

procedure TDataModuleRanap.CariData(
  NoRM, NamaPasien, NamaDokter, KodeKamar, StatusPulang: string;
  TglMasukAwal, TglMasukAkhir, TglKeluarAwal, TglKeluarAkhir: TDate
);
var
  FilterSQL: TStringList;
begin
  ZQRRawatInap.Close;
  ZQRRawatInap.SQL.Clear;
  FilterSQL := TStringList.Create;

  try
    with FilterSQL do
    begin
      Add('SELECT');
      Add('  reg_periksa.no_rawat, pasien.no_rkm_medis, pasien.nm_pasien, pasien.alamat,');
      Add('  reg_periksa.p_jawab, reg_periksa.hubunganpj, penjab.png_jawab, kamar.kd_kamar,');
      Add('  kamar.trf_kamar, kamar_inap.diagnosa_awal, kamar_inap.diagnosa_akhir,');
      Add('  kamar_inap.tgl_masuk, kamar_inap.jam_masuk, kamar_inap.tgl_keluar, kamar_inap.jam_keluar,');
      Add('  kamar_inap.ttl_biaya, kamar_inap.stts_pulang, kamar_inap.lama, dokter.nm_dokter,');
      Add('  kamar.kd_kamar, reg_periksa.status_bayar, pasien.agama');
      Add('FROM kamar_inap');
      Add('JOIN reg_periksa ON kamar_inap.no_rawat = reg_periksa.no_rawat');
      Add('JOIN pasien ON reg_periksa.no_rkm_medis = pasien.no_rkm_medis');
      Add('JOIN penjab ON reg_periksa.kd_pj = penjab.kd_pj');
      Add('JOIN kamar ON kamar_inap.kd_kamar = kamar.kd_kamar');
      Add('JOIN dokter ON reg_periksa.kd_dokter = dokter.kd_dokter');
      Add('WHERE 1=1');

      if NoRM <> '' then
        Add('AND pasien.no_rkm_medis LIKE :norm');
      if NamaPasien <> '' then
        Add('AND pasien.nm_pasien LIKE :nmpasien');
      if NamaDokter <> '' then
        Add('AND dokter.nm_dokter LIKE :nmdokter');
      if KodeKamar <> '' then
        Add('AND kamar.kd_kamar LIKE :kdkamar');
      if StatusPulang <> '' then
        Add('AND kamar_inap.stts_pulang LIKE :stts');

      if (TglMasukAwal <> 0) and (TglMasukAkhir <> 0) then
        Add('AND kamar_inap.tgl_masuk BETWEEN :tglmasuk1 AND :tglmasuk2');

      if (TglKeluarAwal <> 0) and (TglKeluarAkhir <> 0) then
        Add('AND kamar_inap.tgl_keluar BETWEEN :tglkeluar1 AND :tglkeluar2');

      // default filter jika semua kosong: tampilkan pasien belum pulang
      if (NoRM = '') and (NamaPasien = '') and (NamaDokter = '') and
         (KodeKamar = '') and (StatusPulang = '') and
         (TglMasukAwal = 0) and (TglKeluarAwal = 0) then
        Add('AND (kamar_inap.stts_pulang = '''')');

      Add('ORDER BY dokter.nm_dokter, pasien.nm_pasien');
    end;

    ZQRRawatInap.SQL.Text := FilterSQL.Text;

    // Binding parameter
    if NoRM <> '' then ZQRRawatInap.ParamByName('norm').AsString := '%' + NoRM + '%';
    if NamaPasien <> '' then ZQRRawatInap.ParamByName('nmpasien').AsString := '%' + NamaPasien + '%';
    if NamaDokter <> '' then ZQRRawatInap.ParamByName('nmdokter').AsString := '%' + NamaDokter + '%';
    if KodeKamar <> '' then ZQRRawatInap.ParamByName('kdkamar').AsString := '%' + KodeKamar + '%';
    if StatusPulang <> '' then ZQRRawatInap.ParamByName('stts').AsString := '%' + StatusPulang + '%';

    if (TglMasukAwal <> 0) and (TglMasukAkhir <> 0) then
    begin
      ZQRRawatInap.ParamByName('tglmasuk1').AsDate := TglMasukAwal;
      ZQRRawatInap.ParamByName('tglmasuk2').AsDate := TglMasukAkhir;
    end;

    if (TglKeluarAwal <> 0) and (TglKeluarAkhir <> 0) then
    begin
      ZQRRawatInap.ParamByName('tglkeluar1').AsDate := TglKeluarAwal;
      ZQRRawatInap.ParamByName('tglkeluar2').AsDate := TglKeluarAkhir;
    end;

    ZQRRawatInap.Open;
  finally
    FilterSQL.Free;
  end;
end;




end.

