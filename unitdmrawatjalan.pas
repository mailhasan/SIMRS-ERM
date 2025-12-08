unit unitdmrawatjalan;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZDataset;

type

  { TDataModuleRawatJalan }

  TDataModuleRawatJalan = class(TDataModule)
    DataSourcePoli: TDataSource;
    DataSourceTampilPxRawatJalan: TDataSource;
    ZQueryPoli: TZQuery;
    ZQueryTampilPxRawatJalan: TZQuery;
  private

  public
   procedure TampilRawatJalan(
    ATglAwal, ATglAkhir: TDate;
    AKdPoli, AKdDokter, AStatusPeriksa, AKdBayar, AKeyword: string);
  end;

var
  DataModuleRawatJalan: TDataModuleRawatJalan;

implementation

{$R *.lfm}

procedure TDataModuleRawatJalan.TampilRawatJalan(
  ATglAwal, ATglAkhir: TDate;
  AKdPoli, AKdDokter, AStatusPeriksa, AKdBayar, AKeyword: string);
begin
  ZQueryTampilPxRawatJalan.Close;
  ZQueryTampilPxRawatJalan.SQL.Clear;

  ZQueryTampilPxRawatJalan.SQL.Add('SELECT ');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.no_reg,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.no_rawat,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.tgl_registrasi,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.jam_reg,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.kd_dokter,');
  ZQueryTampilPxRawatJalan.SQL.Add('    dokter.nm_dokter,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.no_rkm_medis,');
  ZQueryTampilPxRawatJalan.SQL.Add('    pasien.nm_pasien,');
  ZQueryTampilPxRawatJalan.SQL.Add('    pasien.jk,');
  ZQueryTampilPxRawatJalan.SQL.Add('    CONCAT(reg_periksa.umurdaftar, '' '', reg_periksa.sttsumur) AS umur,');
  ZQueryTampilPxRawatJalan.SQL.Add('    poliklinik.nm_poli,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.p_jawab,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.almt_pj,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.hubunganpj,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.biaya_reg,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.stts_daftar,');
  ZQueryTampilPxRawatJalan.SQL.Add('    penjab.png_jawab,');
  ZQueryTampilPxRawatJalan.SQL.Add('    pasien.no_tlp,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.stts,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.status_poli,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.kd_poli,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.kd_pj');
  ZQueryTampilPxRawatJalan.SQL.Add('FROM reg_periksa');
  ZQueryTampilPxRawatJalan.SQL.Add('INNER JOIN dokter ON reg_periksa.kd_dokter = dokter.kd_dokter');
  ZQueryTampilPxRawatJalan.SQL.Add('INNER JOIN pasien ON reg_periksa.no_rkm_medis = pasien.no_rkm_medis');
  ZQueryTampilPxRawatJalan.SQL.Add('INNER JOIN poliklinik ON reg_periksa.kd_poli = poliklinik.kd_poli');
  ZQueryTampilPxRawatJalan.SQL.Add('INNER JOIN penjab ON reg_periksa.kd_pj = penjab.kd_pj');
  ZQueryTampilPxRawatJalan.SQL.Add('WHERE reg_periksa.tgl_registrasi BETWEEN :tgl1 AND :tgl2');

  // === Filter Poli ===
  if AKdPoli <> '' then
    ZQueryTampilPxRawatJalan.SQL.Add('AND reg_periksa.kd_poli = :poli');

  // === Filter Dokter ===
  if AKdDokter <> '' then
    ZQueryTampilPxRawatJalan.SQL.Add('AND reg_periksa.kd_dokter = :dokter');

  // === Filter Status Periksa (stts) ===
  if AStatusPeriksa <> '' then
    ZQueryTampilPxRawatJalan.SQL.Add('AND reg_periksa.stts = :statPeriksa');

  // === Filter Bayar / Penjab ===
  if AKdBayar <> '' then
    ZQueryTampilPxRawatJalan.SQL.Add('AND reg_periksa.kd_pj = :bayar');

  // === Keyword No RM + Nama ===
  if AKeyword <> '' then
  begin
    ZQueryTampilPxRawatJalan.SQL.Add('AND (reg_periksa.no_rkm_medis LIKE :kw');
    ZQueryTampilPxRawatJalan.SQL.Add('OR pasien.nm_pasien LIKE :kw)');
  end;

  ZQueryTampilPxRawatJalan.SQL.Add('ORDER BY reg_periksa.tgl_registrasi, reg_periksa.jam_reg');

  // === Binding parameter ===
  ZQueryTampilPxRawatJalan.ParamByName('tgl1').AsDate := ATglAwal;
  ZQueryTampilPxRawatJalan.ParamByName('tgl2').AsDate := ATglAkhir;

  if AKdPoli <> '' then
    ZQueryTampilPxRawatJalan.ParamByName('poli').AsString := AKdPoli;

  if AKdDokter <> '' then
    ZQueryTampilPxRawatJalan.ParamByName('dokter').AsString := AKdDokter;

  if AStatusPeriksa <> '' then
    ZQueryTampilPxRawatJalan.ParamByName('statPeriksa').AsString := AStatusPeriksa;

  if AKdBayar <> '' then
    ZQueryTampilPxRawatJalan.ParamByName('bayar').AsString := AKdBayar;

  if AKeyword <> '' then
    ZQueryTampilPxRawatJalan.ParamByName('kw').AsString := '%' + AKeyword + '%';

  ZQueryTampilPxRawatJalan.Open;
end;



end.

