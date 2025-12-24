unit unitdmrawatjalan;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, SQLDB, ZDataset;

type

  { TDataModuleRawatJalan }

  TDataModuleRawatJalan = class(TDataModule)
    DataSourcePemeriksaan: TDataSource;
    DataSourcePoli: TDataSource;
    DataSourceTampilPxRawatJalan: TDataSource;
    ZQueryPemeriksaan: TZQuery;
    ZQueryPoli: TZQuery;
    ZQueryTampilPxRawatJalan: TZQuery;
  private

  public
   procedure TampilRawatJalan(
    ATglAwal, ATglAkhir: TDate;
    AKdPoli, AKdDokter, AStatusPeriksa, AKdBayar, AKeyword: string);

    procedure LoadPemeriksaanRalan(
              ATglAwal, ATglAkhir: TDate;
              ANoRawat, ANoRM, AJabatan, ANama: string);
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
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.kd_pj,');
  ZQueryTampilPxRawatJalan.SQL.Add('    reg_periksa.status_bayar');
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
  {if AKdBayar <> '' then
    ZQueryTampilPxRawatJalan.SQL.Add('AND reg_periksa.kd_pj = :bayar');}

  if AKdBayar <> '' then
    ZQueryTampilPxRawatJalan.SQL.Add('AND reg_periksa.status_bayar = :bayar');

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

/// load pemeriksaan
procedure TDataModuleRawatJalan.LoadPemeriksaanRalan(
  ATglAwal, ATglAkhir: TDate;
  ANoRawat, ANoRM, AJabatan, ANama: string);
var
  SQLFilter: TStringList;
  FilterSQL: string;
begin
  SQLFilter := TStringList.Create;
  try
    // --- BASE QUERY ---
    ZQueryPemeriksaan.Close;
    ZQueryPemeriksaan.SQL.Clear;

    ZQueryPemeriksaan.SQL.Add('SELECT ');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.tgl_perawatan,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.jam_rawat,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.suhu_tubuh,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.tensi,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.nadi,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.respirasi,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.tinggi,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.berat,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.gcs,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.spo2,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.kesadaran,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.keluhan,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.pemeriksaan,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.alergi,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.lingkar_perut,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.rtl,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.penilaian,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.instruksi,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.evaluasi,');
    ZQueryPemeriksaan.SQL.Add('  pemeriksaan_ralan.nip,');
    ZQueryPemeriksaan.SQL.Add('  pegawai.nama,');
    ZQueryPemeriksaan.SQL.Add('  pegawai.jbtn');
    ZQueryPemeriksaan.SQL.Add('FROM pemeriksaan_ralan');
    ZQueryPemeriksaan.SQL.Add('INNER JOIN pegawai ON pemeriksaan_ralan.nip = pegawai.nik');


    // -------------- FILTERS ---------------------

    if (ATglAwal <> 0) and (ATglAkhir <> 0) then
      SQLFilter.Add('pemeriksaan_ralan.tgl_perawatan BETWEEN :tgl_awal AND :tgl_akhir');

    if Trim(ANoRawat) <> '' then
      SQLFilter.Add('pemeriksaan_ralan.no_rawat = :no_rawat');

    if Trim(ANoRM) <> '' then
      SQLFilter.Add('pemeriksaan_ralan.no_rkm_medis = :no_rm');

    if Trim(AJabatan) <> '' then
      SQLFilter.Add('pegawai.jbtn LIKE :jbtn');

    if Trim(ANama) <> '' then
      SQLFilter.Add('pegawai.nama LIKE :nama');


    // -------------- BUILD WHERE -----------------

    if SQLFilter.Count > 0 then
    begin
      FilterSQL := String.Join(' AND ', SQLFilter.ToStringArray);
      ZQueryPemeriksaan.SQL.Add('WHERE ' + FilterSQL);
    end;

    // ORDER BY
    ZQueryPemeriksaan.SQL.Add('ORDER BY pemeriksaan_ralan.tgl_perawatan, pemeriksaan_ralan.jam_rawat');


    // ------------- SET PARAMETERS ----------------

    if (ATglAwal <> 0) and (ATglAkhir <> 0) then
    begin
      ZQueryPemeriksaan.ParamByName('tgl_awal').AsDate := ATglAwal;
      ZQueryPemeriksaan.ParamByName('tgl_akhir').AsDate := ATglAkhir;
    end;

    if Trim(ANoRawat) <> '' then
      ZQueryPemeriksaan.ParamByName('no_rawat').AsString := ANoRawat;

    if Trim(ANoRM) <> '' then
      ZQueryPemeriksaan.ParamByName('no_rm').AsString := ANoRM;

    if Trim(AJabatan) <> '' then
      ZQueryPemeriksaan.ParamByName('jbtn').AsString := '%' + AJabatan + '%';

    if Trim(ANama) <> '' then
      ZQueryPemeriksaan.ParamByName('nama').AsString := '%' + ANama + '%';


    // EXEC
    ZQueryPemeriksaan.Open;

  finally
    SQLFilter.Free;
  end;
end;





end.

