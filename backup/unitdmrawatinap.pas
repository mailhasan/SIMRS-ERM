unit unitdmrawatinap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,unitDmKoneksi, DB, ZDataset,Dialogs, Forms, Controls, Graphics, ExtCtrls, ComCtrls,
  StdCtrls,ZConnection;

type

  { TDataModuleRanap }

  TDataModuleRanap = class(TDataModule)
    DataSourcePemeriksaanRanap: TDataSource;
    DataSourceBangsal: TDataSource;
    DsRawatInap: TDataSource;
    ZQRRawatInap: TZQuery;
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
  keluhan, pemeriksaan, penilaian, rtl, instruksi,
  nip: string);

  procedure UpdatePemeriksaanRanap(
  no_rawat, tgl_perawatan, jam_rawat,
  suhu, tensi, nadi, respirasi, berat, spo2, gcs, kesadaran,
  keluhan, pemeriksaan, penilaian, rtl, instruksi,
  nip: string
  );

  function IsPrimaryKeyExists(no_rawat, tgl_perawatan, jam_rawat: string): Boolean;
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
  ZQPemeriksaan.SQL.Text :=
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
    SQL.Add('pr.suhu_tubuh, pr.tensi, pr.nadi, pr.respirasi, pr.berat,');
    SQL.Add('pr.SpO2, pr.GCS, pr.kesadaran,');
    SQL.Add('pr.keluhan, pr.pemeriksaan, pr.penilaian, pr.rtl AS plan, pr.instruksi,');
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
  keluhan, pemeriksaan, penilaian, rtl, instruksi,
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
    SQL.Add('SpO2, GCS, kesadaran, keluhan, pemeriksaan, penilaian, rtl, instruksi, nip)');
    SQL.Add('VALUES (');
    SQL.Add(':no_rawat, :tgl_perawatan, :jam_rawat,');
    SQL.Add(':suhu, :tensi, :nadi, :respirasi, :berat,');
    SQL.Add(':spo2, :gcs, :kesadaran, :keluhan, :pemeriksaan, :penilaian, :rtl, :instruksi, :nip)');

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
  keluhan, pemeriksaan, penilaian, rtl, instruksi,
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
procedure DeletePemeriksaanRanap(no_rawat, tgl_perawatan, jam_rawat: string);
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



end.

