unit unitDmIgd;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZDataset;

type

  { TDataModuleIgd }

  TDataModuleIgd = class(TDataModule)
    DataSourceTampilDaftarPxIgd: TDataSource;
    ZQueryTampilDaftarPxIgd: TZQuery;
    ZQuerydata_triase_igddetail_skala5: TZQuery;
    ZQuerydata_triase_igddetail_skala1: TZQuery;
    ZQuerymaster_triase_skala5: TZQuery;
    ZQuerymaster_triase_skala1: TZQuery;
    ZQuerymaster_triase_pemeriksaan: TZQuery;
    ZQuerymaster_triase_macam_kasus: TZQuery;
    ZQuerydata_triase_igdsekunder: TZQuery;
    ZQuerydata_triase_igd: TZQuery;
    ZQuerydata_triase_igdprimer: TZQuery;
  private

  public
     procedure CariDataPoli(
              NoRM, NamaPasien, NamaDokter, KodePoli, StatusDaftar: string;
              TglRegAwal, TglRegAkhir: TDate
              );
     procedure TampilDataKeGridPemeriksaan(KodePemeriksaan, NamaPemeriksaan: string);
  end;

var
  DataModuleIgd: TDataModuleIgd;

implementation

{$R *.lfm}
uses unitDmKoneksi,unitPemeriksaanIGD;

  {struktur tabel
   data_triase_igd - Tabel utama triase IGD

  data_triase_igdprimer - Data triase primer

  data_triase_igdsekunder - Data triase sekunder

  master_triase_macam_kasus - Master macam kasus

  master_triase_pemeriksaan - Master pemeriksaan

  master_triase_skala1 sampai master_triase_skala5 - Master skala triase

  data_triase_igddetail_skala1 sampai data_triase_igddetail_skala5 - Detail skala triase}

/// query tampil cari poli
procedure TDataModuleIgd.CariDataPoli(
  NoRM, NamaPasien, NamaDokter, KodePoli, StatusDaftar: string;
  TglRegAwal, TglRegAkhir: TDate
);
var
  FilterSQL: TStringList;
begin
  ZQueryTampilDaftarPxIgd.Close;
  ZQueryTampilDaftarPxIgd.SQL.Clear;
  FilterSQL := TStringList.Create;
  try
    with FilterSQL do
    begin
      Add('SELECT');
      Add('  reg_periksa.no_reg, reg_periksa.no_rawat, reg_periksa.tgl_registrasi,');
      Add('  reg_periksa.jam_reg, reg_periksa.kd_dokter, dokter.nm_dokter,');
      Add('  reg_periksa.no_rkm_medis, pasien.nm_pasien, pasien.jk,');
      Add('  CONCAT(reg_periksa.umurdaftar,'' '',reg_periksa.sttsumur) AS umur,');
      Add('  poliklinik.nm_poli, reg_periksa.p_jawab, reg_periksa.almt_pj,');
      Add('  reg_periksa.hubunganpj, reg_periksa.biaya_reg, reg_periksa.stts_daftar,');
      Add('  penjab.png_jawab, pasien.no_tlp, reg_periksa.stts, reg_periksa.status_poli,');
      Add('  reg_periksa.kd_poli, reg_periksa.kd_pj');
      Add('FROM reg_periksa');
      Add('INNER JOIN dokter ON reg_periksa.kd_dokter = dokter.kd_dokter');
      Add('INNER JOIN pasien ON reg_periksa.no_rkm_medis = pasien.no_rkm_medis');
      Add('INNER JOIN poliklinik ON reg_periksa.kd_poli = poliklinik.kd_poli');
      Add('INNER JOIN penjab ON reg_periksa.kd_pj = penjab.kd_pj');
      Add('WHERE 1=1');

      if NoRM <> '' then
        Add('AND pasien.no_rkm_medis LIKE :norm');
      if NamaPasien <> '' then
        Add('AND pasien.nm_pasien LIKE :nmpasien');
      if NamaDokter <> '' then
        Add('AND dokter.nm_dokter LIKE :nmdokter');
      if KodePoli <> '' then
        Add('AND reg_periksa.kd_poli LIKE :kdpoli');
      if StatusDaftar <> '' then
        Add('AND reg_periksa.stts_daftar LIKE :sttsdaftar');

      if (TglRegAwal <> 0) and (TglRegAkhir <> 0) then
        Add('AND reg_periksa.tgl_registrasi BETWEEN :tgl1 AND :tgl2');

      // Default: tampilkan pasien yang belum dilayani poli
      if (NoRM = '') and (NamaPasien = '') and (NamaDokter = '') and
         (KodePoli = '') and (StatusDaftar = '') and
         (TglRegAwal = 0) then
        Add('AND reg_periksa.status_poli = ''Belum''');

      Add('ORDER BY reg_periksa.tgl_registrasi DESC, reg_periksa.jam_reg DESC');
    end;

    ZQueryTampilDaftarPxIgd.SQL.Text := FilterSQL.Text;

    // Binding parameter
    if NoRM <> '' then ZQueryTampilDaftarPxIgd.ParamByName('norm').AsString := '%' + NoRM + '%';
    if NamaPasien <> '' then ZQueryTampilDaftarPxIgd.ParamByName('nmpasien').AsString := '%' + NamaPasien + '%';
    if NamaDokter <> '' then ZQueryTampilDaftarPxIgd.ParamByName('nmdokter').AsString := '%' + NamaDokter + '%';
    if KodePoli <> '' then ZQueryTampilDaftarPxIgd.ParamByName('kdpoli').AsString := '%' + KodePoli + '%';
    if StatusDaftar <> '' then ZQueryTampilDaftarPxIgd.ParamByName('sttsdaftar').AsString := '%' + StatusDaftar + '%';

    if (TglRegAwal <> 0) and (TglRegAkhir <> 0) then
    begin
      ZQueryTampilDaftarPxIgd.ParamByName('tgl1').AsDate := TglRegAwal;
      ZQueryTampilDaftarPxIgd.ParamByName('tgl2').AsDate := TglRegAkhir;
    end;

    ZQueryTampilDaftarPxIgd.Open;
  finally
    FilterSQL.Free;
  end;
end;


end.

