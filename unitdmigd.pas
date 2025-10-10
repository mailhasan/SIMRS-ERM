unit unitDmIgd;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, ZDataset;

type

  { TDataModuleIgd }

  TDataModuleIgd = class(TDataModule)
    DataSourceTampilDaftarPxIgd: TDataSource;
    ZQuerydata_triase_igddetail_skala2: TZQuery;
    ZQuerydata_triase_igddetail_skala3: TZQuery;
    ZQuerydata_triase_igddetail_skala4: TZQuery;
    ZQuerymaster_triase_skala2: TZQuery;
    ZQuerymaster_triase_skala3: TZQuery;
    ZQuerymaster_triase_skala4: TZQuery;
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
     // === CRUD Triase Utama ===
    procedure SimpanTriaseUtama(
      ANoRawat, AKodeKasus, ACaraMasuk, ATransportasi,
      AAlasan, AKet, ATD, ANadi, APernapasan, ASuhu, ASaturasi, ANyeri: string;
      ATanggal: TDateTime);
    procedure EditTriaseUtama(
      ANoRawat, AKodeKasus, ACaraMasuk, ATransportasi,
      AAlasan, AKet, ATD, ANadi, APernapasan, ASuhu, ASaturasi, ANyeri: string;
      ATanggal: TDateTime);
    procedure HapusTriaseUtama(ANoRawat: string);
    function LoadTriaseUtama(ANoRawat: string): TDataSet;

    // === CRUD Triase Primer ===
    procedure SimpanTriasePrimer(
      ANoRawat, AKeluhan, AKebutuhan, ACatatan, APlan, ANik: string;
      ATanggal: TDateTime);
    procedure EditTriasePrimer(
      ANoRawat, AKeluhan, AKebutuhan, ACatatan, APlan, ANik: string;
      ATanggal: TDateTime);
    procedure HapusTriasePrimer(ANoRawat: string);
    function LoadTriasePrimer(ANoRawat: string): TDataSet;

    // === CRUD Triase Sekunder ===
    procedure SimpanTriaseSekunder(
      ANoRawat, AAnamnesa, ACatatan, APlan, ANik: string;
      ATanggal: TDateTime);
    procedure EditTriaseSekunder(
      ANoRawat, AAnamnesa, ACatatan, APlan, ANik: string;
      ATanggal: TDateTime);
    procedure HapusTriaseSekunder(ANoRawat: string);
    function LoadTriaseSekunder(ANoRawat: string): TDataSet;

    // === CRUD Skala Dinamis (Skala 1–5) ===
    procedure SimpanDetailSkala(ANoRawat, AKodeSkala, ASkalaKe: string);
    procedure HapusDetailSkala(ANoRawat, ASkalaKe: string);
    function LoadDetailSkala(ANoRawat, ASkalaKe: string): TDataSet;
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

{======================== TRIAGE UTAMA ========================}

procedure TDataModuleIgd.SimpanTriaseUtama(
  ANoRawat, AKodeKasus, ACaraMasuk, ATransportasi,
  AAlasan, AKet, ATD, ANadi, APernapasan, ASuhu, ASaturasi, ANyeri: string;
  ATanggal: TDateTime);
begin
  with ZQuerydata_triase_igd do
  begin
    Close;
    SQL.Text := 'INSERT INTO data_triase_igd ' +
      '(no_rawat, tgl_kunjungan, cara_masuk, alat_transportasi, alasan_kedatangan, ' +
      'keterangan_kedatangan, kode_kasus, tekanan_darah, nadi, pernapasan, suhu, saturasi_o2, nyeri) ' +
      'VALUES (:no_rawat, :tgl, :cara, :alat, :alasan, :ket, :kode, :td, :nadi, :napas, :suhu, :o2, :nyeri)';
    ParamByName('no_rawat').AsString := ANoRawat;
    ParamByName('tgl').AsDateTime := ATanggal;
    ParamByName('cara').AsString := ACaraMasuk;
    ParamByName('alat').AsString := ATransportasi;
    ParamByName('alasan').AsString := AAlasan;
    ParamByName('ket').AsString := AKet;
    ParamByName('kode').AsString := AKodeKasus;
    ParamByName('td').AsString := ATD;
    ParamByName('nadi').AsString := ANadi;
    ParamByName('napas').AsString := APernapasan;
    ParamByName('suhu').AsString := ASuhu;
    ParamByName('o2').AsString := ASaturasi;
    ParamByName('nyeri').AsString := ANyeri;
    ExecSQL;
  end;
end;

procedure TDataModuleIgd.EditTriaseUtama(
  ANoRawat, AKodeKasus, ACaraMasuk, ATransportasi,
  AAlasan, AKet, ATD, ANadi, APernapasan, ASuhu, ASaturasi, ANyeri: string;
  ATanggal: TDateTime);
begin
  with ZQuerydata_triase_igd do
  begin
    Close;
    SQL.Text := 'UPDATE data_triase_igd SET ' +
      'tgl_kunjungan=:tgl, cara_masuk=:cara, alat_transportasi=:alat, alasan_kedatangan=:alasan, ' +
      'keterangan_kedatangan=:ket, kode_kasus=:kode, tekanan_darah=:td, nadi=:nadi, ' +
      'pernapasan=:napas, suhu=:suhu, saturasi_o2=:o2, nyeri=:nyeri WHERE no_rawat=:no_rawat';
    ParamByName('no_rawat').AsString := ANoRawat;
    ParamByName('tgl').AsDateTime := ATanggal;
    ParamByName('cara').AsString := ACaraMasuk;
    ParamByName('alat').AsString := ATransportasi;
    ParamByName('alasan').AsString := AAlasan;
    ParamByName('ket').AsString := AKet;
    ParamByName('kode').AsString := AKodeKasus;
    ParamByName('td').AsString := ATD;
    ParamByName('nadi').AsString := ANadi;
    ParamByName('napas').AsString := APernapasan;
    ParamByName('suhu').AsString := ASuhu;
    ParamByName('o2').AsString := ASaturasi;
    ParamByName('nyeri').AsString := ANyeri;
    ExecSQL;
  end;
end;

procedure TDataModuleIgd.HapusTriaseUtama(ANoRawat: string);
begin
  with ZQuerydata_triase_igd do
  begin
    Close;
    SQL.Text := 'DELETE FROM data_triase_igd WHERE no_rawat=:no_rawat';
    ParamByName('no_rawat').AsString := ANoRawat;
    ExecSQL;
  end;
end;

function TDataModuleIgd.LoadTriaseUtama(ANoRawat: string): TDataSet;
begin
  with ZQuerydata_triase_igd do
  begin
    Close;
    SQL.Text := 'SELECT * FROM data_triase_igd WHERE no_rawat=:no_rawat';
    ParamByName('no_rawat').AsString := ANoRawat;
    Open;
    Result := ZQuerydata_triase_igd;
  end;
end;

{======================== TRIAGE PRIMER ========================}

procedure TDataModuleIgd.SimpanTriasePrimer(
  ANoRawat, AKeluhan, AKebutuhan, ACatatan, APlan, ANik: string;
  ATanggal: TDateTime);
begin
  with ZQuerydata_triase_igdprimer do
  begin
    Close;
    SQL.Text := 'INSERT INTO data_triase_igdprimer ' +
      '(no_rawat, keluhan_utama, kebutuhan_khusus, catatan, plan, tanggaltriase, nik) ' +
      'VALUES (:no_rawat, :keluhan, :kebutuhan, :catatan, :plan, :tgl, :nik)';
    ParamByName('no_rawat').AsString := ANoRawat;
    ParamByName('keluhan').AsString := AKeluhan;
    ParamByName('kebutuhan').AsString := AKebutuhan;
    ParamByName('catatan').AsString := ACatatan;
    ParamByName('plan').AsString := APlan;
    ParamByName('tgl').AsDateTime := ATanggal;
    ParamByName('nik').AsString := ANik;
    ExecSQL;
  end;
end;

procedure TDataModuleIgd.EditTriasePrimer(
  ANoRawat, AKeluhan, AKebutuhan, ACatatan, APlan, ANik: string;
  ATanggal: TDateTime);
begin
  with ZQuerydata_triase_igdprimer do
  begin
    Close;
    SQL.Text := 'UPDATE data_triase_igdprimer SET ' +
      'keluhan_utama=:keluhan, kebutuhan_khusus=:kebutuhan, catatan=:catatan, ' +
      'plan=:plan, tanggaltriase=:tgl, nik=:nik WHERE no_rawat=:no_rawat';
    ParamByName('no_rawat').AsString := ANoRawat;
    ParamByName('keluhan').AsString := AKeluhan;
    ParamByName('kebutuhan').AsString := AKebutuhan;
    ParamByName('catatan').AsString := ACatatan;
    ParamByName('plan').AsString := APlan;
    ParamByName('tgl').AsDateTime := ATanggal;
    ParamByName('nik').AsString := ANik;
    ExecSQL;
  end;
end;

procedure TDataModuleIgd.HapusTriasePrimer(ANoRawat: string);
begin
  with ZQuerydata_triase_igdprimer do
  begin
    Close;
    SQL.Text := 'DELETE FROM data_triase_igdprimer WHERE no_rawat=:no_rawat';
    ParamByName('no_rawat').AsString := ANoRawat;
    ExecSQL;
  end;
end;

function TDataModuleIgd.LoadTriasePrimer(ANoRawat: string): TDataSet;
begin
  with ZQuerydata_triase_igdprimer do
  begin
    Close;
    SQL.Text := 'SELECT * FROM data_triase_igdprimer WHERE no_rawat=:no_rawat';
    ParamByName('no_rawat').AsString := ANoRawat;
    Open;
    Result := ZQuerydata_triase_igdprimer;
  end;
end;

{======================== TRIAGE SEKUNDER ========================}

procedure TDataModuleIgd.SimpanTriaseSekunder(
  ANoRawat, AAnamnesa, ACatatan, APlan, ANik: string;
  ATanggal: TDateTime);
begin
  with ZQuerydata_triase_igdsekunder do
  begin
    Close;
    SQL.Text := 'INSERT INTO data_triase_igdsekunder ' +
      '(no_rawat, anamnesa_singkat, catatan, plan, tanggaltriase, nik) ' +
      'VALUES (:no_rawat, :anamnesa, :catatan, :plan, :tgl, :nik)';
    ParamByName('no_rawat').AsString := ANoRawat;
    ParamByName('anamnesa').AsString := AAnamnesa;
    ParamByName('catatan').AsString := ACatatan;
    ParamByName('plan').AsString := APlan;
    ParamByName('tgl').AsDateTime := ATanggal;
    ParamByName('nik').AsString := ANik;
    ExecSQL;
  end;
end;

procedure TDataModuleIgd.EditTriaseSekunder(
  ANoRawat, AAnamnesa, ACatatan, APlan, ANik: string;
  ATanggal: TDateTime);
begin
  with ZQuerydata_triase_igdsekunder do
  begin
    Close;
    SQL.Text := 'UPDATE data_triase_igdsekunder SET ' +
      'anamnesa_singkat=:anamnesa, catatan=:catatan, plan=:plan, tanggaltriase=:tgl, nik=:nik ' +
      'WHERE no_rawat=:no_rawat';
    ParamByName('no_rawat').AsString := ANoRawat;
    ParamByName('anamnesa').AsString := AAnamnesa;
    ParamByName('catatan').AsString := ACatatan;
    ParamByName('plan').AsString := APlan;
    ParamByName('tgl').AsDateTime := ATanggal;
    ParamByName('nik').AsString := ANik;
    ExecSQL;
  end;
end;

procedure TDataModuleIgd.HapusTriaseSekunder(ANoRawat: string);
begin
  with ZQuerydata_triase_igdsekunder do
  begin
    Close;
    SQL.Text := 'DELETE FROM data_triase_igdsekunder WHERE no_rawat=:no_rawat';
    ParamByName('no_rawat').AsString := ANoRawat;
    ExecSQL;
  end;
end;

function TDataModuleIgd.LoadTriaseSekunder(ANoRawat: string): TDataSet;
begin
  with ZQuerydata_triase_igdsekunder do
  begin
    Close;
    SQL.Text := 'SELECT * FROM data_triase_igdsekunder WHERE no_rawat=:no_rawat';
    ParamByName('no_rawat').AsString := ANoRawat;
    Open;
    Result := ZQuerydata_triase_igdsekunder;
  end;
end;

{======================== DETAIL SKALA (DINAMIS) ========================}

procedure TDataModuleIgd.SimpanDetailSkala(ANoRawat, AKodeSkala, ASkalaKe: string);
var tbl: string;
begin
  tbl := 'data_triase_igddetail_skala' + ASkalaKe;
  with TZQuery.Create(nil) do
  try
    Connection := ZConn;
    Close;
    SQL.Text := Format('REPLACE INTO %s (no_rawat, kode_skala%s) VALUES (:no_rawat, :kode)',
      [tbl, ASkalaKe]);
    ParamByName('no_rawat').AsString := ANoRawat;
    ParamByName('kode').AsString := AKodeSkala;
    ExecSQL;
  finally
    Free;
  end;
end;

procedure TDataModuleIgd.HapusDetailSkala(ANoRawat, ASkalaKe: string);
var tbl: string;
begin
  tbl := 'data_triase_igddetail_skala' + ASkalaKe;
  with TZQuery.Create(nil) do
  try
    Connection := ZConn;
    SQL.Text := Format('DELETE FROM %s WHERE no_rawat=:no_rawat', [tbl]);
    ParamByName('no_rawat').AsString := ANoRawat;
    ExecSQL;
  finally
    Free;
  end;
end;

function TDataModuleIgd.LoadDetailSkala(ANoRawat, ASkalaKe: string): TDataSet;
var tbl: string;
begin
  tbl := 'data_triase_igddetail_skala' + ASkalaKe;
  with TZQuery.Create(nil) do
  begin
    Connection := ZConn;
    SQL.Text := Format('SELECT * FROM %s WHERE no_rawat=:no_rawat', [tbl]);
    ParamByName('no_rawat').AsString := ANoRawat;
    Open;
    Result := TDataSet(Self); // hanya untuk compile
  end;
end;


end.

