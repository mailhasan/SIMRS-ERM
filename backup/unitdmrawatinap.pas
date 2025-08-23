unit unitdmrawatinap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,unitDmKoneksi, DB, ZDataset,Dialogs, Forms, Controls, Graphics, ExtCtrls, ComCtrls,
  StdCtrls,ZConnection;

type

  { TDataModuleRanap }

  TDataModuleRanap = class(TDataModule)
    DataSourcePenilaian_medis_ranap: TDataSource;
    DataSourcePemeriksaanRanap: TDataSource;
    DataSourceBangsal: TDataSource;
    DsRawatInap: TDataSource;
    ZQRRawatInap: TZQuery;
    ZQueryCekPenilaian: TZQuery;
    ZQueryPenilaian_medis_ranap: TZQuery;
    ZQueryPemeriksaanRanap: TZQuery;
    ZQueryBangsal: TZQuery;
    procedure DataModuleCreate(Sender: TObject);

  private

  public
   ///procedure CariRawatInap(NoRM, Nama, Dokter, Kamar, Status: string);
  procedure CariData(
      NoRM, NamaPasien, NamaDokter, KodeKamar, StatusPulang: string;
      TglMasukAwal, TglMasukAkhir, TglKeluarAwal, TglKeluarAkhir: TDate
    );
  procedure FilterBangsal(NamaBangsal: string);
  /// pemeriksaaan
  procedure LoadPemeriksaanRanap(no_rawat, no_rkm_medis: string; tgl_awal, tgl_akhir: TDate);

  procedure InsertPemeriksaanRanap(
  no_rawat, tgl_perawatan, jam_rawat,
  suhu, tensi, nadi, respirasi, berat, spo2, gcs, kesadaran,
  keluhan, pemeriksaan, penilaian, rtl, instruksi, evaluasi,alergi,
  nip: string);

  procedure UpdatePemeriksaanRanap(
  no_rawat, tgl_perawatan, jam_rawat,
  suhu, tensi, nadi, respirasi, berat, spo2, gcs, kesadaran,
  keluhan, pemeriksaan, penilaian, rtl, instruksi,evaluasi,alergi,
  nip: string
  );

  procedure DeletePemeriksaanRanap(no_rawat, tgl_perawatan, jam_rawat: string);

  function IsPrimaryKeyExists(no_rawat, tgl_perawatan, jam_rawat: string): Boolean;

  /// penilian awal medis umum
  procedure LoadPenilaianMedisRanap(no_rawat, no_rkm_medis: string; tgl_awal, tgl_akhir: TDate);

  procedure InsertPenilaianMedisRanap(
  no_rawat, tanggal, kd_dokter,
  anamnesis, hubungan, keluhan_utama, rps, rpk, rpd, rpo, alergi,
  keadaan, gcs, kesadaran, td, nadi, rr, suhu, spo, bb, tb,
  kepala, mata, gigi, tht, thoraks, jantung, paru, abdomen,
  ekstremitas, genital, kulit, ket_fisik, ket_lokalis,
  lab, rad, penunjang, diagnosis, tata, edukasi: string
  );

  /// update penilaian medis rawat inap
  procedure UpdatePenilaianMedisRanap(
    no_rawat, tanggal, kd_dokter,
    anamnesis, hubungan, keluhan_utama, rps, rpk, rpd, rpo, alergi,
    keadaan, gcs, kesadaran, td, nadi, rr, suhu, spo, bb, tb,
    kepala, mata, gigi, tht, thoraks, jantung, paru, abdomen,
    ekstremitas, genital, kulit, ket_fisik, ket_lokalis,
    lab, rad, penunjang, diagnosis, tata, edukasi: string
  );
  /// hapus
  procedure DeletePenilaianMedisRanap(no_rawat, tanggal: string);

  function IsPenilaianMedisExists(no_rawat, tanggal: string): Boolean;

  function IsPrimaryKeyExistsPenilaian(no_rawat, tanggal: string): Boolean;

  end;


var
  DataModuleRanap: TDataModuleRanap;
  ZQueryPemeriksaanRanap: TZQuery;

implementation

{$R *.lfm}

/// pengujian primerykey
{ Mengecek apakah PK sudah ada }
function TDataModuleRanap.IsPrimaryKeyExists(no_rawat, tgl_perawatan, jam_rawat: string): Boolean;
begin
  ZQueryPemeriksaanRanap.Close;
  ZQueryPemeriksaanRanap.SQL.Text :=
    'SELECT COUNT(*) AS cnt FROM pemeriksaan_ranap '+
    'WHERE no_rawat=:no_rawat AND tgl_perawatan=:tgl AND jam_rawat=:jam';
  ZQueryPemeriksaanRanap.ParamByName('no_rawat').AsString := no_rawat;
  ZQueryPemeriksaanRanap.ParamByName('tgl').AsString := tgl_perawatan;
  ZQueryPemeriksaanRanap.ParamByName('jam').AsString := jam_rawat;
  ZQueryPemeriksaanRanap.Open;

  Result := ZQueryPemeriksaanRanap.FieldByName('cnt').AsInteger > 0;
end;



/// procedure tidak boleh di hapus
procedure TDataModuleRanap.DataModuleCreate(Sender: TObject);
begin
  // kode inisialisasi disini
end;


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

/// cari data pasien
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
      Add('  kamar.trf_kamar,bangsal.nm_bangsal, kamar_inap.diagnosa_awal, kamar_inap.diagnosa_akhir,');
      Add('  kamar_inap.tgl_masuk, kamar_inap.jam_masuk, kamar_inap.tgl_keluar, kamar_inap.jam_keluar,');
      Add('  kamar_inap.ttl_biaya, kamar_inap.stts_pulang, kamar_inap.lama, dokter.nm_dokter,');
      Add('  kamar.kd_kamar, reg_periksa.status_bayar, pasien.agama');
      Add('FROM kamar_inap');
      Add('JOIN reg_periksa ON kamar_inap.no_rawat = reg_periksa.no_rawat');
      Add('JOIN pasien ON reg_periksa.no_rkm_medis = pasien.no_rkm_medis');
      Add('JOIN penjab ON reg_periksa.kd_pj = penjab.kd_pj');
      Add('JOIN kamar ON kamar_inap.kd_kamar = kamar.kd_kamar');
      Add('JOIN bangsal ON kamar.kd_bangsal = bangsal.kd_bangsal');
      Add('JOIN dokter ON reg_periksa.kd_dokter = dokter.kd_dokter');
      Add('WHERE 1=1');

      if NoRM <> '' then
        Add('AND pasien.no_rkm_medis LIKE :norm');
      if NamaPasien <> '' then
        Add('AND pasien.nm_pasien LIKE :nmpasien');
      if NamaDokter <> '' then
        Add('AND dokter.nm_dokter LIKE :nmdokter');
      if KodeKamar <> '' then
        Add('AND bangsal.nm_bangsal LIKE :kdkamar');
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

/// filter berdasarkan tanggal
procedure TDataModuleRanap.FilterBangsal(NamaBangsal: string);
begin
  ZQueryBangsal.Close;
  ZQueryBangsal.SQL.Clear;
  ZQueryBangsal.SQL.Add('SELECT * FROM bangsal');
  ZQueryBangsal.SQL.Add('WHERE (:nama = '''' OR nm_bangsal LIKE CONCAT(''%'', :nama, ''%''))');
  ZQueryBangsal.SQL.Add('ORDER BY kd_bangsal');
  ZQueryBangsal.ParamByName('nama').AsString := Trim(NamaBangsal);
  ZQueryBangsal.Open;
end;

/// pemeriksaaan ranap

procedure TDataModuleRanap.LoadPemeriksaanRanap(no_rawat, no_rkm_medis: string; tgl_awal, tgl_akhir: TDate);
begin
  with ZQueryPemeriksaanRanap do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT pr.no_rawat, pr.tgl_perawatan, pr.jam_rawat,');
    SQL.Add('p.nm_pasien, p.no_rkm_medis,');
    SQL.Add('pr.suhu_tubuh, pr.tensi, pr.nadi, pr.respirasi, pr.berat,pr.alergi,');
    SQL.Add('pr.SpO2, pr.GCS, pr.kesadaran,');
    SQL.Add('pr.keluhan, pr.pemeriksaan, pr.penilaian, pr.rtl AS plan, pr.instruksi,pr.evaluasi,');
    SQL.Add('pr.nip, pg.nama AS nama_petugas, pg.`jbtn`');
    SQL.Add('FROM pemeriksaan_ranap pr');
    SQL.Add('JOIN reg_periksa rp ON pr.no_rawat = rp.no_rawat');
    SQL.Add('JOIN pasien p ON rp.no_rkm_medis = p.no_rkm_medis');
    SQL.Add('LEFT JOIN pegawai pg ON pr.nip = pg.nik');
    SQL.Add('WHERE (:no_rawat IS NULL OR :no_rawat = '''' OR pr.no_rawat = :no_rawat)');
    SQL.Add('AND (:no_rawat IS NOT NULL AND :no_rawat <> '''' OR');
    SQL.Add('(p.no_rkm_medis = :no_rkm_medis AND pr.tgl_perawatan BETWEEN :tgl_awal AND :tgl_akhir))');
    SQL.Add('ORDER BY pr.tgl_perawatan DESC, pr.jam_rawat DESC');

    ParamByName('no_rawat').AsString := no_rawat;
    ParamByName('no_rkm_medis').AsString := no_rkm_medis;
    ParamByName('tgl_awal').AsDate := tgl_awal;
    ParamByName('tgl_akhir').AsDate := tgl_akhir;
    Open;
  end;
end;

/// insert pemeriksaan
procedure TDataModuleRanap.InsertPemeriksaanRanap(
  no_rawat, tgl_perawatan, jam_rawat,
  suhu, tensi, nadi, respirasi, berat, spo2, gcs, kesadaran,
  keluhan, pemeriksaan, penilaian, rtl, instruksi, evaluasi,alergi,
  nip: string
);
begin
  if IsPrimaryKeyExists(no_rawat, tgl_perawatan, jam_rawat) then
  begin
    ShowMessage('Data sudah ada! (PK duplikat)');
    Exit;
  end;

  try
    if not DataModuleKoneksi.ZConnectionSimrsERM.Connected then
      DataModuleKoneksi.ZConnectionSimrsERM.Connect;

    DataModuleKoneksi.ZConnectionSimrsERM.StartTransaction;
  with ZQueryPemeriksaanRanap do
  begin
    Close;
    SQL.Clear;
    SQL.Add('INSERT INTO pemeriksaan_ranap (');
    SQL.Add('no_rawat, tgl_perawatan, jam_rawat,');
    SQL.Add('suhu_tubuh, tensi, nadi, respirasi, berat,');
    SQL.Add('SpO2, GCS, kesadaran, keluhan, pemeriksaan, penilaian, rtl, instruksi,evaluasi,alergi, nip)');
    SQL.Add('VALUES (');
    SQL.Add(':no_rawat, :tgl_perawatan, :jam_rawat,');
    SQL.Add(':suhu, :tensi, :nadi, :respirasi, :berat,');
    SQL.Add(':spo2, :gcs, :kesadaran, :keluhan, :pemeriksaan, :penilaian, :rtl, :instruksi, :evaluasi,:alergi, :nip)');

    ParamByName('no_rawat').AsString := no_rawat;
    ParamByName('tgl_perawatan').AsString := tgl_perawatan;
    ParamByName('jam_rawat').AsString := jam_rawat;
    ParamByName('suhu').AsString := suhu;
    ParamByName('tensi').AsString := tensi;
    ParamByName('nadi').AsString := nadi;
    ParamByName('respirasi').AsString := respirasi;
    ParamByName('berat').AsString := berat;
    ParamByName('spo2').AsString := spo2;
    ParamByName('gcs').AsString := gcs;
    ParamByName('kesadaran').AsString := kesadaran;
    ParamByName('keluhan').AsString := keluhan;
    ParamByName('pemeriksaan').AsString := pemeriksaan;
    ParamByName('penilaian').AsString := penilaian;
    ParamByName('rtl').AsString := rtl;
    ParamByName('instruksi').AsString := instruksi;
    ParamByName('evaluasi').AsString := evaluasi;
    ParamByName('alergi').AsString := alergi;
    ParamByName('nip').AsString := nip;
    ExecSQL;
  end;
  DataModuleKoneksi.ZConnectionSimrsERM.Commit;
    ShowMessage('Data pemeriksaan berhasil disimpan.');

  except
    on E: Exception do
    begin
      if DataModuleKoneksi.ZConnectionSimrsERM.InTransaction then
        DataModuleKoneksi.ZConnectionSimrsERM.Rollback;
      ShowMessage('Gagal menyimpan data pemeriksaan: ' + E.Message);
    end;
  end;
end;

/// update pemeriksaan
procedure TDataModuleRanap.UpdatePemeriksaanRanap(
  no_rawat, tgl_perawatan, jam_rawat,
  suhu, tensi, nadi, respirasi, berat, spo2, gcs, kesadaran,
  keluhan, pemeriksaan, penilaian, rtl, instruksi,evaluasi,alergi,
  nip: string
);
begin
  try
    if not DataModuleKoneksi.ZConnectionSimrsERM.Connected then
      DataModuleKoneksi.ZConnectionSimrsERM.Connect;

    DataModuleKoneksi.ZConnectionSimrsERM.StartTransaction;
  with ZQueryPemeriksaanRanap do
  begin
    Close;
    Close;
      SQL.Clear;
      SQL.Add('UPDATE pemeriksaan_ranap SET');
      SQL.Add('suhu_tubuh = :suhu,');
      SQL.Add('tensi = :tensi,');
      SQL.Add('nadi = :nadi,');
      SQL.Add('respirasi = :respirasi,');
      SQL.Add('berat = :berat,');
      SQL.Add('SpO2 = :spo2,');
      SQL.Add('GCS = :gcs,');
      SQL.Add('kesadaran = :kesadaran,');
      SQL.Add('keluhan = :keluhan,');
      SQL.Add('pemeriksaan = :pemeriksaan,');
      SQL.Add('penilaian = :penilaian,');
      SQL.Add('rtl = :rtl,');
      SQL.Add('instruksi = :instruksi,');
      SQL.Add('evaluasi = :evaluasi,');
      SQL.Add('alergi = :alergi,');
      SQL.Add('nip = :nip');
      SQL.Add('WHERE no_rawat = :no_rawat AND tgl_perawatan = :tgl_perawatan AND jam_rawat = :jam_rawat');

      ParamByName('suhu').AsString := suhu;
      ParamByName('tensi').AsString := tensi;
      ParamByName('nadi').AsString := nadi;
      ParamByName('respirasi').AsString := respirasi;
      ParamByName('berat').AsString := berat;
      ParamByName('spo2').AsString := spo2;
      ParamByName('gcs').AsString := gcs;
      ParamByName('kesadaran').AsString := kesadaran;
      ParamByName('keluhan').AsString := keluhan;
      ParamByName('pemeriksaan').AsString := pemeriksaan;
      ParamByName('penilaian').AsString := penilaian;
      ParamByName('rtl').AsString := rtl;
      ParamByName('instruksi').AsString := instruksi;
      ParamByName('evaluasi').AsString := evaluasi;
      ParamByName('alergi').AsString := alergi;
      ParamByName('nip').AsString := nip;
      ParamByName('no_rawat').AsString := no_rawat;
      ParamByName('tgl_perawatan').AsString := tgl_perawatan;
      ParamByName('jam_rawat').AsString := jam_rawat;

      ExecSQL;
  end;
  DataModuleKoneksi.ZConnectionSimrsERM.Commit;
    ShowMessage('Data pemeriksaan berhasil disimpan.');

  except
    on E: Exception do
    begin
      if DataModuleKoneksi.ZConnectionSimrsERM.InTransaction then
        DataModuleKoneksi.ZConnectionSimrsERM.Rollback;
      ShowMessage('Gagal menyimpan data pemeriksaan: ' + E.Message);
    end;
  end;
end;


/// delete pemeriksaan ranap
procedure TDataModuleRanap.DeletePemeriksaanRanap(no_rawat, tgl_perawatan, jam_rawat: string);
begin
  if MessageDlg('Apakah anda yakin ingin menghapus data pemeriksaan?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      if not DataModuleKoneksi.ZConnectionSimrsERM.Connected then
        DataModuleKoneksi.ZConnectionSimrsERM.Connect;

      DataModuleKoneksi.ZConnectionSimrsERM.StartTransaction;

      with ZQueryPemeriksaanRanap do
      begin
        Close;
        SQL.Clear;
        SQL.Add('DELETE FROM pemeriksaan_ranap');
        SQL.Add('WHERE no_rawat = :no_rawat AND tgl_perawatan = :tgl_perawatan AND jam_rawat = :jam_rawat');
        ParamByName('no_rawat').AsString := no_rawat;
        ParamByName('tgl_perawatan').AsString := tgl_perawatan;
        ParamByName('jam_rawat').AsString := jam_rawat;
        ExecSQL;
      end;

      DataModuleKoneksi.ZConnectionSimrsERM.Commit;
      ShowMessage('Data pemeriksaan berhasil dihapus.');

    except
      on E: Exception do
      begin
        if DataModuleKoneksi.ZConnectionSimrsERM.InTransaction then
          DataModuleKoneksi.ZConnectionSimrsERM.Rollback;
        ShowMessage('Gagal menghapus data pemeriksaan: ' + E.Message);
      end;
    end;
  end
  else
  begin
    ShowMessage('Penghapusan dibatalkan.');
  end;
end;

/// tampil data daftar pemeriksaan awal medis
procedure TDataModuleRanap.LoadPenilaianMedisRanap(no_rawat, no_rkm_medis: string; tgl_awal, tgl_akhir: TDate);
begin
  with ZQueryPenilaian_medis_ranap do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT');
    SQL.Add('  reg_periksa.no_rawat,');
    SQL.Add('  pasien.no_rkm_medis,');
    SQL.Add('  pasien.nm_pasien,');
    SQL.Add('  IF(pasien.jk=''L'',''Laki-Laki'',''Perempuan'') AS jk,');
    SQL.Add('  pasien.tgl_lahir,');
    SQL.Add('  penilaian_medis_ranap.tanggal,');
    SQL.Add('  penilaian_medis_ranap.kd_dokter,');
    SQL.Add('  penilaian_medis_ranap.anamnesis,');
    SQL.Add('  penilaian_medis_ranap.hubungan,');
    SQL.Add('  penilaian_medis_ranap.keluhan_utama,');
    SQL.Add('  penilaian_medis_ranap.rps,');
    SQL.Add('  penilaian_medis_ranap.rpk,');
    SQL.Add('  penilaian_medis_ranap.rpd,');
    SQL.Add('  penilaian_medis_ranap.rpo,');
    SQL.Add('  penilaian_medis_ranap.alergi,');
    SQL.Add('  penilaian_medis_ranap.keadaan,');
    SQL.Add('  penilaian_medis_ranap.gcs,');
    SQL.Add('  penilaian_medis_ranap.kesadaran,');
    SQL.Add('  penilaian_medis_ranap.td,');
    SQL.Add('  penilaian_medis_ranap.nadi,');
    SQL.Add('  penilaian_medis_ranap.rr,');
    SQL.Add('  penilaian_medis_ranap.suhu,');
    SQL.Add('  penilaian_medis_ranap.spo,');
    SQL.Add('  penilaian_medis_ranap.bb,');
    SQL.Add('  penilaian_medis_ranap.tb,');
    SQL.Add('  penilaian_medis_ranap.kepala,');
    SQL.Add('  penilaian_medis_ranap.mata,');
    SQL.Add('  penilaian_medis_ranap.gigi,');
    SQL.Add('  penilaian_medis_ranap.tht,');
    SQL.Add('  penilaian_medis_ranap.thoraks,');
    SQL.Add('  penilaian_medis_ranap.jantung,');
    SQL.Add('  penilaian_medis_ranap.paru,');
    SQL.Add('  penilaian_medis_ranap.abdomen,');
    SQL.Add('  penilaian_medis_ranap.ekstremitas,');
    SQL.Add('  penilaian_medis_ranap.genital,');
    SQL.Add('  penilaian_medis_ranap.kulit,');
    SQL.Add('  penilaian_medis_ranap.ket_fisik,');
    SQL.Add('  penilaian_medis_ranap.ket_lokalis,');
    SQL.Add('  penilaian_medis_ranap.lab,');
    SQL.Add('  penilaian_medis_ranap.rad,');
    SQL.Add('  penilaian_medis_ranap.penunjang,');
    SQL.Add('  penilaian_medis_ranap.diagnosis,');
    SQL.Add('  penilaian_medis_ranap.tata,');
    SQL.Add('  penilaian_medis_ranap.edukasi,');
    SQL.Add('  dokter.nm_dokter');
    SQL.Add('FROM reg_periksa');
    SQL.Add('INNER JOIN pasien ON reg_periksa.no_rkm_medis = pasien.no_rkm_medis');
    SQL.Add('INNER JOIN penilaian_medis_ranap ON reg_periksa.no_rawat = penilaian_medis_ranap.no_rawat');
    SQL.Add('INNER JOIN dokter ON penilaian_medis_ranap.kd_dokter = dokter.kd_dokter');
    SQL.Add('WHERE (:no_rawat IS NULL OR :no_rawat = '''' OR penilaian_medis_ranap.no_rawat = :no_rawat)');
    SQL.Add('AND (:no_rawat IS NOT NULL AND :no_rawat <> '''' OR');
    SQL.Add('(pasien.no_rkm_medis = :no_rkm_medis AND penilaian_medis_ranap.tanggal BETWEEN :tgl_awal AND :tgl_akhir))');
    SQL.Add('ORDER BY penilaian_medis_ranap.tanggal DESC');

    ParamByName('no_rawat').AsString := no_rawat;
    ParamByName('no_rkm_medis').AsString := no_rkm_medis;
    ParamByName('tgl_awal').AsDate := tgl_awal;
    ParamByName('tgl_akhir').AsDate := tgl_akhir;
    Open;
  end;
end;

/// insert penilaian medis rawat inap
procedure TDataModuleRanap.InsertPenilaianMedisRanap(
  no_rawat, tanggal, kd_dokter,
  anamnesis, hubungan, keluhan_utama, rps, rpk, rpd, rpo, alergi,
  keadaan, gcs, kesadaran, td, nadi, rr, suhu, spo, bb, tb,
  kepala, mata, gigi, tht, thoraks, jantung, paru, abdomen,
  ekstremitas, genital, kulit, ket_fisik, ket_lokalis,
  lab, rad, penunjang, diagnosis, tata, edukasi: string
);
begin
  if IsPrimaryKeyExistsPenilaian(no_rawat, tanggal) then
  begin
    ShowMessage('Data penilaian medis sudah ada untuk nomor rawat dan tanggal tersebut!');
    Exit;
  end;

  try
    if not DataModuleKoneksi.ZConnectionSimrsERM.Connected then
      DataModuleKoneksi.ZConnectionSimrsERM.Connect;

    DataModuleKoneksi.ZConnectionSimrsERM.StartTransaction;

    with ZQueryPenilaian_medis_ranap do
    begin
      Close;
      SQL.Clear;
      SQL.Add('INSERT INTO penilaian_medis_ranap (');
      SQL.Add('no_rawat, tanggal, kd_dokter,');
      SQL.Add('anamnesis, hubungan, keluhan_utama, rps, rpk, rpd, rpo, alergi,');
      SQL.Add('keadaan, gcs, kesadaran, td, nadi, rr, suhu, spo, bb, tb,');
      SQL.Add('kepala, mata, gigi, tht, thoraks, jantung, paru, abdomen,');
      SQL.Add('ekstremitas, genital, kulit, ket_fisik, ket_lokalis,');
      SQL.Add('lab, rad, penunjang, diagnosis, tata, edukasi)');
      SQL.Add('VALUES (');
      SQL.Add(':no_rawat, :tanggal, :kd_dokter,');
      SQL.Add(':anamnesis, :hubungan, :keluhan_utama, :rps, :rpk, :rpd, :rpo, :alergi,');
      SQL.Add(':keadaan, :gcs, :kesadaran, :td, :nadi, :rr, :suhu, :spo, :bb, :tb,');
      SQL.Add(':kepala, :mata, :gigi, :tht, :thoraks, :jantung, :paru, :abdomen,');
      SQL.Add(':ekstremitas, :genital, :kulit, :ket_fisik, :ket_lokalis,');
      SQL.Add(':lab, :rad, :penunjang, :diagnosis, :tata, :edukasi)');

      // Parameter binding
      ParamByName('no_rawat').AsString := no_rawat;
      ParamByName('tanggal').AsString := tanggal;
      ParamByName('kd_dokter').AsString := kd_dokter;

      // Anamnesis dan identifikasi
      ParamByName('anamnesis').AsString := anamnesis;
      ParamByName('hubungan').AsString := hubungan;
      ParamByName('keluhan_utama').AsString := keluhan_utama;
      ParamByName('rps').AsString := rps;
      ParamByName('rpk').AsString := rpk;
      ParamByName('rpd').AsString := rpd;
      ParamByName('rpo').AsString := rpo;
      ParamByName('alergi').AsString := alergi;

      // Status umum
      ParamByName('keadaan').AsString := keadaan;
      ParamByName('gcs').AsString := gcs;
      ParamByName('kesadaran').AsString := kesadaran;
      ParamByName('td').AsString := td;
      ParamByName('nadi').AsString := nadi;
      ParamByName('rr').AsString := rr;
      ParamByName('suhu').AsString := suhu;
      ParamByName('spo').AsString := spo;
      ParamByName('bb').AsString := bb;
      ParamByName('tb').AsString := tb;

      // Pemeriksaan fisik
      ParamByName('kepala').AsString := kepala;
      ParamByName('mata').AsString := mata;
      ParamByName('gigi').AsString := gigi;
      ParamByName('tht').AsString := tht;
      ParamByName('thoraks').AsString := thoraks;
      ParamByName('jantung').AsString := jantung;
      ParamByName('paru').AsString := paru;
      ParamByName('abdomen').AsString := abdomen;
      ParamByName('ekstremitas').AsString := ekstremitas;
      ParamByName('genital').AsString := genital;
      ParamByName('kulit').AsString := kulit;
      ParamByName('ket_fisik').AsString := ket_fisik;
      ParamByName('ket_lokalis').AsString := ket_lokalis;

      // Penunjang dan diagnosis
      ParamByName('lab').AsString := lab;
      ParamByName('rad').AsString := rad;
      ParamByName('penunjang').AsString := penunjang;
      ParamByName('diagnosis').AsString := diagnosis;
      ParamByName('tata').AsString := tata;
      ParamByName('edukasi').AsString := edukasi;

      ExecSQL;
    end;

    DataModuleKoneksi.ZConnectionSimrsERM.Commit;
    ShowMessage('Data penilaian medis rawat inap berhasil disimpan.');

  except
    on E: Exception do
    begin
      if DataModuleKoneksi.ZConnectionSimrsERM.InTransaction then
        DataModuleKoneksi.ZConnectionSimrsERM.Rollback;
      ShowMessage('Gagal menyimpan data penilaian medis: ' + E.Message);
    end;
  end;
end;

// Fungsi pengecekan primary key
function TDataModuleRanap.IsPrimaryKeyExistsPenilaian(no_rawat, tanggal: string): Boolean;
begin
  with ZQueryPenilaian_medis_ranap do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COUNT(*) AS jumlah FROM penilaian_medis_ranap');
    SQL.Add('WHERE no_rawat = :no_rawat AND tanggal = :tanggal');
    ParamByName('no_rawat').AsString := no_rawat;
    ParamByName('tanggal').AsString := tanggal;
    Open;
    Result := FieldByName('jumlah').AsInteger > 0;
    Close;
  end;
end;

/// update penilaian medis rawat inap
procedure TDataModuleRanap.UpdatePenilaianMedisRanap(
  no_rawat, tanggal, kd_dokter,
  anamnesis, hubungan, keluhan_utama, rps, rpk, rpd, rpo, alergi,
  keadaan, gcs, kesadaran, td, nadi, rr, suhu, spo, bb, tb,
  kepala, mata, gigi, tht, thoraks, jantung, paru, abdomen,
  ekstremitas, genital, kulit, ket_fisik, ket_lokalis,
  lab, rad, penunjang, diagnosis, tata, edukasi: string
);
begin
  try
    if not DataModuleKoneksi.ZConnectionSimrsERM.Connected then
      DataModuleKoneksi.ZConnectionSimrsERM.Connect;

    DataModuleKoneksi.ZConnectionSimrsERM.StartTransaction;

    with ZQueryPenilaian_medis_ranap do
    begin
      Close;
      SQL.Clear;
      SQL.Add('UPDATE penilaian_medis_ranap SET');
      SQL.Add('kd_dokter = :kd_dokter,');
      SQL.Add('anamnesis = :anamnesis, hubungan = :hubungan, keluhan_utama = :keluhan_utama,');
      SQL.Add('rps = :rps, rpk = :rpk, rpd = :rpd, rpo = :rpo, alergi = :alergi,');
      SQL.Add('keadaan = :keadaan, gcs = :gcs, kesadaran = :kesadaran,');
      SQL.Add('td = :td, nadi = :nadi, rr = :rr, suhu = :suhu, spo = :spo, bb = :bb, tb = :tb,');
      SQL.Add('kepala = :kepala, mata = :mata, gigi = :gigi, tht = :tht,');
      SQL.Add('thoraks = :thoraks, jantung = :jantung, paru = :paru, abdomen = :abdomen,');
      SQL.Add('ekstremitas = :ekstremitas, genital = :genital, kulit = :kulit,');
      SQL.Add('ket_fisik = :ket_fisik, ket_lokalis = :ket_lokalis,');
      SQL.Add('lab = :lab, rad = :rad, penunjang = :penunjang,');
      SQL.Add('diagnosis = :diagnosis, tata = :tata, edukasi = :edukasi');
      SQL.Add('WHERE no_rawat = :no_rawat AND tanggal = :tanggal');

      // Parameter binding
      ParamByName('no_rawat').AsString := no_rawat;
      ParamByName('tanggal').AsString := tanggal;
      ParamByName('kd_dokter').AsString := kd_dokter;

      // Parameter lainnya (sama seperti insert)
       // Anamnesis dan identifikasi
      ParamByName('anamnesis').AsString := anamnesis;
      ParamByName('hubungan').AsString := hubungan;
      ParamByName('keluhan_utama').AsString := keluhan_utama;
      ParamByName('rps').AsString := rps;
      ParamByName('rpk').AsString := rpk;
      ParamByName('rpd').AsString := rpd;
      ParamByName('rpo').AsString := rpo;
      ParamByName('alergi').AsString := alergi;

      // Status umum
      ParamByName('keadaan').AsString := keadaan;
      ParamByName('gcs').AsString := gcs;
      ParamByName('kesadaran').AsString := kesadaran;
      ParamByName('td').AsString := td;
      ParamByName('nadi').AsString := nadi;
      ParamByName('rr').AsString := rr;
      ParamByName('suhu').AsString := suhu;
      ParamByName('spo').AsString := spo;
      ParamByName('bb').AsString := bb;
      ParamByName('tb').AsString := tb;

      // Pemeriksaan fisik
      ParamByName('kepala').AsString := kepala;
      ParamByName('mata').AsString := mata;
      ParamByName('gigi').AsString := gigi;
      ParamByName('tht').AsString := tht;
      ParamByName('thoraks').AsString := thoraks;
      ParamByName('jantung').AsString := jantung;
      ParamByName('paru').AsString := paru;
      ParamByName('abdomen').AsString := abdomen;
      ParamByName('ekstremitas').AsString := ekstremitas;
      ParamByName('genital').AsString := genital;
      ParamByName('kulit').AsString := kulit;
      ParamByName('ket_fisik').AsString := ket_fisik;
      ParamByName('ket_lokalis').AsString := ket_lokalis;

      // Penunjang dan diagnosis
      ParamByName('lab').AsString := lab;
      ParamByName('rad').AsString := rad;
      ParamByName('penunjang').AsString := penunjang;
      ParamByName('diagnosis').AsString := diagnosis;
      ParamByName('tata').AsString := tata;
      ParamByName('edukasi').AsString := edukasi;

      ExecSQL;
    end;

    DataModuleKoneksi.ZConnectionSimrsERM.Commit;
    ShowMessage('Data penilaian medis berhasil diperbarui.');

  except
    on E: Exception do
    begin
      if DataModuleKoneksi.ZConnectionSimrsERM.InTransaction then
        DataModuleKoneksi.ZConnectionSimrsERM.Rollback;
      ShowMessage('Gagal memperbarui data: ' + E.Message);
    end;
  end;
end;

/// delete penilaian medis rawat inap
procedure TDataModuleRanap.DeletePenilaianMedisRanap(no_rawat, tanggal: string);
begin
  if MessageDlg('Apakah Anda yakin ingin menghapus data penilaian medis ini?',
      mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  try
    if not DataModuleKoneksi.ZConnectionSimrsERM.Connected then
      DataModuleKoneksi.ZConnectionSimrsERM.Connect;

    DataModuleKoneksi.ZConnectionSimrsERM.StartTransaction;

    with ZQueryPenilaian_medis_ranap do
    begin
      Close;
      SQL.Clear;
      SQL.Add('DELETE FROM penilaian_medis_ranap');
      SQL.Add('WHERE no_rawat = :no_rawat AND tanggal = :tanggal');

      ParamByName('no_rawat').AsString := no_rawat;
      ParamByName('tanggal').AsString := tanggal;

      ExecSQL;
    end;

    DataModuleKoneksi.ZConnectionSimrsERM.Commit;
    ShowMessage('Data penilaian medis berhasil dihapus.');

  except
    on E: Exception do
    begin
      if DataModuleKoneksi.ZConnectionSimrsERM.InTransaction then
        DataModuleKoneksi.ZConnectionSimrsERM.Rollback;
      ShowMessage('Gagal menghapus data: ' + E.Message);
    end;
  end;
end;

// Fungsi untuk mengecek apakah data ada sebelum operasi
function TDataModuleRanap.IsPenilaianMedisExists(no_rawat, tanggal: string): Boolean;
begin
  Result := False;
  with ZQueryCekPenilaian do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT COUNT(*) AS jumlah FROM penilaian_medis_ranap');
    SQL.Add('WHERE no_rawat = :no_rawat AND tanggal = :tanggal');
    ParamByName('no_rawat').AsString := no_rawat;
    ParamByName('tanggal').AsString := tanggal;
    Open;
    Result := FieldByName('jumlah').AsInteger > 0;
    Close;
  end;
end;

end.

