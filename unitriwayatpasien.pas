unit unitRiwayatPasien;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBGrids, CheckLst, SynEdit, ZDataset, RichMemo;

type

  { TFormRiwayatPasien }

  TFormRiwayatPasien = class(TForm)
    clbRiwayat: TCheckListBox;
    DataSourceKunjungan: TDataSource;
    DBGridKunjungan: TDBGrid;
    EditNAMA: TEdit;
    EditNORM: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    PanelKanan: TPanel;
    Panel2: TPanel;
    PanelAtas: TPanel;
    PanelKeluar: TPanel;
    PanelKiri: TPanel;
    PanelKonten: TPanel;
    RichMemoRiwayat: TRichMemo;
    zqSOAP: TZQuery;
    ZQueryTindakanRajal: TZQuery;
    ZQueryTindakanRanap: TZQuery;
    ZQueryPenilaianMedisIGD: TZQuery;
    ZQueryRencanaKeperawatan: TZQuery;
    ZQueryMasalahKeperawatan: TZQuery;
    ZQueryPenilaianIGD: TZQuery;
    ZQuerySkala5: TZQuery;
    ZQuerySkala4: TZQuery;
    ZQuerySkala3: TZQuery;
    ZQuerySkala2: TZQuery;
    ZQuerySkala1: TZQuery;
    ZQueryTriaseSekunder: TZQuery;
    ZQueryTriasePrimer: TZQuery;
    ZQueryTriase: TZQuery;
    ZQueryKunjungan: TZQuery;
    procedure DBGridKunjunganCellClick(Column: TColumn);
    procedure FormShow(Sender: TObject);
    procedure PanelKeluarClick(Sender: TObject);
  private
    procedure AddHeader(const S: string; AColor: TColor = clNavy; AFontSize: Integer = 12);
    procedure AddSubHeader(const S: string);
    procedure AddLine(const S: string; AIndent: Integer = 0);
    procedure AddSeparator;
    procedure AddSectionSeparator;
    //function StringRepeat(const AChar: Char; ACount: Integer): string;
    function FormatCurrency(Value: Currency): string;
  public
    procedure LoadKunjungan(NoRM: string);
    //procedure TampilTriase(NoRawat: string);

    procedure InitRichMemo;
    procedure LoadSOAPRajal(const NoRawat: string);
    procedure LoadSOAPRanap(const NoRawat: string);
    procedure LoadTriase(const NoRawat: string);
    procedure LoadPenilaianAwalIGD(const NoRawat: string);
    procedure LoadPenilaianMedisIGD(const NoRawat: string);
    procedure LoadTindakanJalan(const NoRawat: string);
    procedure LoadTindakanRanap(const NoRawat: string);
  end;

var
  FormRiwayatPasien: TFormRiwayatPasien;

implementation

{$R *.lfm}

{ TFormRiwayatPasien }
uses unitDmKoneksi,unitDmIgd;

// Helper function untuk StringRepeat
function StringRepeat(const AChar: Char; ACount: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for i := 1 to ACount do
    Result := Result + AChar;
end;

// Helper function untuk format currency
function TFormRiwayatPasien.FormatCurrency(Value: Currency): string;
begin
  Result := FormatFloat('#,##0', Value);
end;



/// SETUP RICHMEMO (WAJIB)
procedure TFormRiwayatPasien.InitRichMemo;
begin
  RichMemoRiwayat.Clear;
  RichMemoRiwayat.ReadOnly := True;
  RichMemoRiwayat.ScrollBars := ssVertical;
  RichMemoRiwayat.Font.Name := 'Segoe UI';
  RichMemoRiwayat.Font.Size := 10;
  RichMemoRiwayat.Font.Color := clBlack;
end;

/// HELPER FORMAT - VERSI YANG BENAR DENGAN TFontParams
procedure TFormRiwayatPasien.AddHeader(const S: string; AColor: TColor = clNavy; AFontSize: Integer = 12);
var
  StartPos: Integer;
  FP: TFontParams;
begin
  // Tambahkan header dengan bold dan warna menggunakan TFontParams
  RichMemoRiwayat.Lines.Add('');
  StartPos := RichMemoRiwayat.GetTextLen;

  // Tambahkan teks
  RichMemoRiwayat.Lines.Add('== ' + S + ' ==');

  // Setup TFontParams
  InitFontParams(FP); // Inisialisasi parameter font
  FP.Name := 'Segoe UI';
  FP.Size := AFontSize;
  FP.Color := AColor;
  FP.Style := [fsBold];

  // Terapkan gaya
  RichMemoRiwayat.SetTextAttributes(StartPos, Length('== ' + S + ' =='), FP);
  RichMemoRiwayat.Lines.Add('');
end;

procedure TFormRiwayatPasien.AddSubHeader(const S: string);
var
  StartPos: Integer;
  FP: TFontParams;
begin
  RichMemoRiwayat.Lines.Add('');
  StartPos := RichMemoRiwayat.GetTextLen;
  RichMemoRiwayat.Lines.Add('▶ ' + S);

  // Setup TFontParams untuk subheader
  InitFontParams(FP);
  FP.Name := 'Segoe UI';
  FP.Size := 10;
  FP.Color := clTeal;
  FP.Style := [fsBold];

  // Terapkan gaya
  RichMemoRiwayat.SetTextAttributes(StartPos, Length('▶ ' + S), FP);
end;

procedure TFormRiwayatPasien.AddLine(const S: string; AIndent: Integer = 0);
var
  IndentStr, TextToAdd: string;
  StartPos: Integer;
  FP: TFontParams;
begin
  // Buat indentasi
  IndentStr := '';
  if AIndent > 0 then
    IndentStr := StringRepeat(' ', AIndent);

  // Format teks
  if Length(S) > 100 then
    TextToAdd := IndentStr + '└ ' + S
  else
    TextToAdd := IndentStr + '• ' + S;

  StartPos := RichMemoRiwayat.GetTextLen;
  RichMemoRiwayat.Lines.Add(TextToAdd);

  // Atur gaya normal untuk teks biasa
  InitFontParams(FP);
  FP.Name := 'Segoe UI';
  FP.Size := 10;
  FP.Color := clBlack;
  FP.Style := [];

  RichMemoRiwayat.SetTextAttributes(StartPos, Length(TextToAdd), FP);
end;

procedure TFormRiwayatPasien.AddSeparator;
begin
  RichMemoRiwayat.Lines.Add('');
  RichMemoRiwayat.Lines.Add(StringRepeat('-', 80));
  RichMemoRiwayat.Lines.Add('');
end;

procedure TFormRiwayatPasien.AddSectionSeparator;
begin
  RichMemoRiwayat.Lines.Add('');
  RichMemoRiwayat.Lines.Add('════════════════════════════════════════════════════════════');
  RichMemoRiwayat.Lines.Add('');
end;

procedure TFormRiwayatPasien.LoadKunjungan(NoRM: string);
begin
  with zqueryKunjungan do
  begin
    Close;
    SQL.Clear;

    SQL.Text :=
      'SELECT rp.no_rawat, rp.tgl_registrasi, rp.jam_reg, ' +
      'rp.no_rkm_medis, ps.nm_pasien, rp.status_lanjut, ' +
      'rp.stts, rp.status_bayar, pl.nm_poli, dk.nm_dokter, ' +
      'bg.nm_bangsal, kmr.kd_kamar, kmr.kelas ' +
      'FROM reg_periksa rp ' +
      'LEFT JOIN pasien ps ON rp.no_rkm_medis = ps.no_rkm_medis ' +
      'LEFT JOIN poliklinik pl ON rp.kd_poli = pl.kd_poli ' +
      'LEFT JOIN dokter dk ON rp.kd_dokter = dk.kd_dokter ' +
      'LEFT JOIN kamar_inap ki ON rp.no_rawat = ki.no_rawat ' +
      'LEFT JOIN kamar kmr ON ki.kd_kamar = kmr.kd_kamar ' +
      'LEFT JOIN bangsal bg ON kmr.kd_bangsal = bg.kd_bangsal ' +
      'WHERE rp.status_lanjut IN (''Ralan'',''Ranap'') ' +
      'AND rp.no_rkm_medis = :no_rm ' +
      'ORDER BY rp.tgl_registrasi DESC, rp.jam_reg DESC, rp.no_rawat DESC ' +
      'LIMIT 10';

    ParamByName('no_rm').AsString := NoRM;
    Open;
  end;
end;


/// PROCEDURE UNTUK LOAD DATA TRIASE
procedure TFormRiwayatPasien.LoadTriase(const NoRawat: string);
var
  HasDataTriase: Boolean;
  SkalaItems: TStringList;
  i: Integer;
begin
  HasDataTriase := False;

  // ==================== HEADER TRIASE ====================
  with ZQueryTriase do
  begin
    Close;
    SQL.Clear;
    SQL.Text :=
      'SELECT ' +
      '  dt.no_rawat, ' +
      '  dt.tgl_kunjungan, ' +
      '  dt.cara_masuk, ' +
      '  dt.alat_transportasi, ' +
      '  dt.alasan_kedatangan, ' +
      '  dt.keterangan_kedatangan, ' +
      '  dt.tekanan_darah, ' +
      '  dt.nadi, ' +
      '  dt.pernapasan, ' +
      '  dt.suhu, ' +
      '  dt.saturasi_o2, ' +
      '  dt.nyeri, ' +
      '  mk.macam_kasus ' +
      'FROM data_triase_igd dt ' +
      'LEFT JOIN master_triase_macam_kasus mk ' +
      '  ON dt.kode_kasus = mk.kode_kasus ' +
      'WHERE dt.no_rawat = :no_rawat';

    ParamByName('no_rawat').AsString := NoRawat;
    Open;

    if not IsEmpty then
    begin
      HasDataTriase := True;

      AddHeader('TRIASE IGD', clRed, 13);

      // Informasi Kedatangan
      AddSubHeader('INFORMASI KEDATANGAN');
      AddLine('Tanggal Kunjungan : ' + FieldByName('tgl_kunjungan').AsString, 2);
      AddLine('Cara Masuk        : ' + FieldByName('cara_masuk').AsString, 2);
      AddLine('Alat Transportasi : ' + FieldByName('alat_transportasi').AsString, 2);
      AddLine('Alasan Kedatangan : ' + FieldByName('alasan_kedatangan').AsString, 2);
      AddLine('Keterangan        : ' + FieldByName('keterangan_kedatangan').AsString, 2);
      AddLine('Macam Kasus       : ' + FieldByName('macam_kasus').AsString, 2);

      // TTV
      AddSubHeader('TANDA-TANDA VITAL (TTV)');
      AddLine('Tekanan Darah : ' + FieldByName('tekanan_darah').AsString + ' mmHg', 2);
      AddLine('Nadi          : ' + FieldByName('nadi').AsString + ' x/menit', 2);
      AddLine('Pernapasan    : ' + FieldByName('pernapasan').AsString + ' x/menit', 2);
      AddLine('Suhu          : ' + FieldByName('suhu').AsString + ' °C', 2);
      AddLine('Saturasi O2   : ' + FieldByName('saturasi_o2').AsString + ' %', 2);
      AddLine('Skala Nyeri   : ' + FieldByName('nyeri').AsString + '/10', 2);

      AddSeparator;
    end;
    Close;
  end;

  // ==================== TRIASE PRIMER (RESUSITASI / KRITIS) ====================
  with ZQueryTriasePrimer do
  begin
    Close;
    SQL.Clear;
    SQL.Text :=
      'SELECT ' +
      '  p.tanggaltriase, ' +
      '  p.keluhan_utama, ' +
      '  p.kebutuhan_khusus, ' +
      '  p.catatan, ' +
      '  p.plan, ' +
      '  pg.nama ' +
      'FROM data_triase_igdprimer p ' +
      'LEFT JOIN pegawai pg ON p.nik = pg.nik ' +
      'WHERE p.no_rawat = :no_rawat';

    ParamByName('no_rawat').AsString := NoRawat;
    Open;

    if not IsEmpty then
    begin
      HasDataTriase := True;

      AddSubHeader('🔴 TRIASE PRIMER (ZONA MERAH - RESUSITASI)');

      while not EOF do
      begin
        AddLine('Tanggal Triase     : ' + FieldByName('tanggaltriase').AsString, 2);
        AddLine('Perawat/Petugas    : ' + FieldByName('nama').AsString, 2);
        AddLine('Keluhan Utama      : ' + FieldByName('keluhan_utama').AsString, 2);
        AddLine('Kebutuhan Khusus   : ' + FieldByName('kebutuhan_khusus').AsString, 2);
        AddLine('Catatan            : ' + FieldByName('catatan').AsString, 2);
        AddLine('Rencana (Plan)     : ' + FieldByName('plan').AsString, 2);

        if not EOF then
          AddSeparator;
        Next;
      end;

      AddSeparator;
    end;
    Close;
  end;

  // ==================== TRIASE SEKUNDER (ZONA KUNING/HIJAU) ====================
  with ZQueryTriaseSekunder do
  begin
    Close;
    SQL.Clear;
    SQL.Text :=
      'SELECT ' +
      '  s.tanggaltriase, ' +
      '  s.anamnesa_singkat, ' +
      '  s.catatan, ' +
      '  s.plan, ' +
      '  pg.nama ' +
      'FROM data_triase_igdsekunder s ' +
      'LEFT JOIN pegawai pg ON s.nik = pg.nik ' +
      'WHERE s.no_rawat = :no_rawat';

    ParamByName('no_rawat').AsString := NoRawat;
    Open;

    if not IsEmpty then
    begin
      HasDataTriase := True;

      AddSubHeader('🟡 TRIASE SEKUNDER (ZONA KUNING/HIJAU)');

      while not EOF do
      begin
        AddLine('Tanggal Triase     : ' + FieldByName('tanggaltriase').AsString, 2);
        AddLine('Perawat/Petugas    : ' + FieldByName('nama').AsString, 2);
        AddLine('Anamnesa Singkat   : ' + FieldByName('anamnesa_singkat').AsString, 2);
        AddLine('Catatan            : ' + FieldByName('catatan').AsString, 2);
        AddLine('Rencana (Plan)     : ' + FieldByName('plan').AsString, 2);

        if not EOF then
          AddSeparator;
        Next;
      end;

      AddSeparator;
    end;
    Close;
  end;

  // ==================== SKALA 1-5 ====================
  SkalaItems := TStringList.Create;
  try
    // SKALA 1
    with ZQuerySkala1 do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT ' +
        '  m.pengkajian_skala1 ' +
        'FROM data_triase_igddetail_skala1 d ' +
        'JOIN master_triase_skala1 m ' +
        '  ON d.kode_skala1 = m.kode_skala1 ' +
        'WHERE d.no_rawat = :no_rawat';

      ParamByName('no_rawat').AsString := NoRawat;
      Open;

      if not IsEmpty then
      begin
        HasDataTriase := True;
        while not EOF do
        begin
          SkalaItems.Add('🔴 ' + FieldByName('pengkajian_skala1').AsString);
          Next;
        end;
      end;
      Close;
    end;

    // SKALA 2
    with ZQuerySkala2 do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT ' +
        '  m.pengkajian_skala2 ' +
        'FROM data_triase_igddetail_skala2 d ' +
        'JOIN master_triase_skala2 m ' +
        '  ON d.kode_skala2 = m.kode_skala2 ' +
        'WHERE d.no_rawat = :no_rawat';

      ParamByName('no_rawat').AsString := NoRawat;
      Open;

      if not IsEmpty then
      begin
        HasDataTriase := True;
        while not EOF do
        begin
          SkalaItems.Add('🟠 ' + FieldByName('pengkajian_skala2').AsString);
          Next;
        end;
      end;
      Close;
    end;

    // SKALA 3
    with ZQuerySkala3 do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT ' +
        '  m.pengkajian_skala3 ' +
        'FROM data_triase_igddetail_skala3 d ' +
        'JOIN master_triase_skala3 m ' +
        '  ON d.kode_skala3 = m.kode_skala3 ' +
        'WHERE d.no_rawat = :no_rawat';

      ParamByName('no_rawat').AsString := NoRawat;
      Open;

      if not IsEmpty then
      begin
        HasDataTriase := True;
        while not EOF do
        begin
          SkalaItems.Add('🟡 ' + FieldByName('pengkajian_skala3').AsString);
          Next;
        end;
      end;
      Close;
    end;

    // SKALA 4
    with ZQuerySkala4 do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT ' +
        '  m.pengkajian_skala4 ' +
        'FROM data_triase_igddetail_skala4 d ' +
        'JOIN master_triase_skala4 m ' +
        '  ON d.kode_skala4 = m.kode_skala4 ' +
        'WHERE d.no_rawat = :no_rawat';

      ParamByName('no_rawat').AsString := NoRawat;
      Open;

      if not IsEmpty then
      begin
        HasDataTriase := True;
        while not EOF do
        begin
          SkalaItems.Add('🟢 ' + FieldByName('pengkajian_skala4').AsString);
          Next;
        end;
      end;
      Close;
    end;

    // SKALA 5
    with ZQuerySkala5 do
    begin
      Close;
      SQL.Clear;
      SQL.Text :=
        'SELECT ' +
        '  m.pengkajian_skala5 ' +
        'FROM data_triase_igddetail_skala5 d ' +
        'JOIN master_triase_skala5 m ' +
        '  ON d.kode_skala5 = m.kode_skala5 ' +
        'WHERE d.no_rawat = :no_rawat';

      ParamByName('no_rawat').AsString := NoRawat;
      Open;

      if not IsEmpty then
      begin
        HasDataTriase := True;
        while not EOF do
        begin
          SkalaItems.Add('🔵 ' + FieldByName('pengkajian_skala5').AsString);
          Next;
        end;
      end;
      Close;
    end;

    // Tampilkan semua skala jika ada
    if SkalaItems.Count > 0 then
    begin
      AddSubHeader('📋 HASIL PENILAIAN SKALA TRIASE');
      AddLine('Total item penilaian: ' + IntToStr(SkalaItems.Count), 2);

      for i := 0 to SkalaItems.Count - 1 do
      begin
        AddLine(SkalaItems[i], 2);
      end;
    end;

  finally
    SkalaItems.Free;
  end;

  // Jika tidak ada data triase sama sekali
  if not HasDataTriase then
  begin
    AddHeader('TRIASE IGD', clGray, 13);
    AddLine('Tidak ada data triase untuk kunjungan ini.', 2);
  end;

  //AddSectionSeparator;
  AddSeparator;
end;

/// PROCEDURE UNTUK LOAD PENILAIAN AWAL KEPERAWATAN IGD
procedure TFormRiwayatPasien.LoadPenilaianAwalIGD(const NoRawat: string);
var
  HasData: Boolean;
  MasalahCount, RencanaCount: Integer;
begin
  HasData := False;

  // ==================== HEADER PENILAIAN AWAL KEPERAWATAN IGD ====================
  with ZQueryPenilaianIGD do
  begin
    Close;
    SQL.Clear;
    SQL.Text :=
      'SELECT ' +
      '  p.no_rawat, ' +
      '  p.tanggal, ' +
      '  p.informasi, ' +
      '  p.keluhan_utama, ' +
      '  p.rpd, ' +
      '  p.rpo, ' +
      '  p.status_kehamilan, ' +
      '  p.gravida, ' +
      '  p.para, ' +
      '  p.abortus, ' +
      '  p.hpht, ' +
      '  ' +
      '  p.tekanan, ' +
      '  p.pupil, ' +
      '  p.neurosensorik, ' +
      '  p.integumen, ' +
      '  p.turgor, ' +
      '  p.edema, ' +
      '  p.mukosa, ' +
      '  p.perdarahan, ' +
      '  p.jumlah_perdarahan, ' +
      '  p.warna_perdarahan, ' +
      '  p.intoksikasi, ' +
      '  ' +
      '  p.psikologis, ' +
      '  p.jiwa, ' +
      '  p.perilaku, ' +
      '  ' +
      '  p.nyeri, ' +
      '  p.provokes, ' +
      '  p.ket_provokes, ' +
      '  p.quality, ' +
      '  p.ket_quality, ' +
      '  p.lokasi, ' +
      '  p.menyebar, ' +
      '  p.skala_nyeri, ' +
      '  p.durasi, ' +
      '  p.nyeri_hilang, ' +
      '  ' +
      '  p.hasil, ' +
      '  p.rencana, ' +
      '  pg.nama AS perawat ' +
      'FROM penilaian_awal_keperawatan_igd p ' +
      'LEFT JOIN petugas pg ON p.nip = pg.nip ' +
      'WHERE p.no_rawat = :no_rawat';

    ParamByName('no_rawat').AsString := NoRawat;
    Open;

    if not IsEmpty then
    begin
      HasData := True;

      AddHeader('PENILAIAN AWAL KEPERAWATAN IGD', clPurple, 13);

      // Informasi Umum
      AddSubHeader('INFORMASI UMUM');
      AddLine('Tanggal Penilaian : ' + FieldByName('tanggal').AsString, 2);
      AddLine('Perawat           : ' + FieldByName('perawat').AsString, 2);
      AddLine('Informasi         : ' + FieldByName('informasi').AsString, 2);
      AddLine('Keluhan Utama     : ' + FieldByName('keluhan_utama').AsString, 2);

      // Riwayat Penyakit
      if (FieldByName('rpd').AsString <> '') or (FieldByName('rpo').AsString <> '') then
      begin
        AddSubHeader('RIWAYAT PENYAKIT');
        if FieldByName('rpd').AsString <> '' then
          AddLine('RPD (Riwayat Penyakit Dahulu) : ' + FieldByName('rpd').AsString, 2);
        if FieldByName('rpo').AsString <> '' then
          AddLine('RPO (Riwayat Penyakit Ortu)    : ' + FieldByName('rpo').AsString, 2);
      end;

      // Status Kehamilan (jika ada)
      if FieldByName('status_kehamilan').AsString <> '' then
      begin
        AddSubHeader('STATUS KEHAMILAN');
        AddLine('Status Kehamilan : ' + FieldByName('status_kehamilan').AsString, 2);
        if FieldByName('gravida').AsString <> '' then
          AddLine('Gravida           : ' + FieldByName('gravida').AsString, 2);
        if FieldByName('para').AsString <> '' then
          AddLine('Para              : ' + FieldByName('para').AsString, 2);
        if FieldByName('abortus').AsString <> '' then
          AddLine('Abortus           : ' + FieldByName('abortus').AsString, 2);
        if FieldByName('hpht').AsString <> '' then
          AddLine('HPHT              : ' + FieldByName('hpht').AsString, 2);
      end;

      // Pemeriksaan Fisik
      AddSubHeader('PEMERIKSAAN FISIK');

      // Sirkulasi & Neurologi
      if (FieldByName('tekanan').AsString <> '') or (FieldByName('pupil').AsString <> '') then
      begin
        AddLine('Sirkulasi & Neurologi:', 2);
        if FieldByName('tekanan').AsString <> '' then
          AddLine('  Tekanan      : ' + FieldByName('tekanan').AsString, 4);
        if FieldByName('pupil').AsString <> '' then
          AddLine('  Pupil        : ' + FieldByName('pupil').AsString, 4);
        if FieldByName('neurosensorik').AsString <> '' then
          AddLine('  Neurosensorik: ' + FieldByName('neurosensorik').AsString, 4);
      end;

      // Integumen & Cairan
      if (FieldByName('integumen').AsString <> '') or (FieldByName('turgor').AsString <> '') or
         (FieldByName('edema').AsString <> '') then
      begin
        AddLine('Integumen & Cairan:', 2);
        if FieldByName('integumen').AsString <> '' then
          AddLine('  Integumen    : ' + FieldByName('integumen').AsString, 4);
        if FieldByName('turgor').AsString <> '' then
          AddLine('  Turgor       : ' + FieldByName('turgor').AsString, 4);
        if FieldByName('edema').AsString <> '' then
          AddLine('  Edema        : ' + FieldByName('edema').AsString, 4);
      end;

      // Mukosa & Perdarahan
      if (FieldByName('mukosa').AsString <> '') or (FieldByName('perdarahan').AsString <> '') then
      begin
        AddLine('Mukosa & Perdarahan:', 2);
        if FieldByName('mukosa').AsString <> '' then
          AddLine('  Mukosa               : ' + FieldByName('mukosa').AsString, 4);
        if FieldByName('perdarahan').AsString <> '' then
          AddLine('  Perdarahan           : ' + FieldByName('perdarahan').AsString, 4);
        if FieldByName('jumlah_perdarahan').AsString <> '' then
          AddLine('  Jumlah Perdarahan    : ' + FieldByName('jumlah_perdarahan').AsString, 4);
        if FieldByName('warna_perdarahan').AsString <> '' then
          AddLine('  Warna Perdarahan     : ' + FieldByName('warna_perdarahan').AsString, 4);
      end;

      if FieldByName('intoksikasi').AsString <> '' then
        AddLine('Intoksikasi : ' + FieldByName('intoksikasi').AsString, 2);

      // Psikologis & Jiwa
      if (FieldByName('psikologis').AsString <> '') or (FieldByName('jiwa').AsString <> '') or
         (FieldByName('perilaku').AsString <> '') then
      begin
        AddSubHeader('PSIKOLOGIS & JIWA');
        if FieldByName('psikologis').AsString <> '' then
          AddLine('Psikologis : ' + FieldByName('psikologis').AsString, 2);
        if FieldByName('jiwa').AsString <> '' then
          AddLine('Jiwa       : ' + FieldByName('jiwa').AsString, 2);
        if FieldByName('perilaku').AsString <> '' then
          AddLine('Perilaku   : ' + FieldByName('perilaku').AsString, 2);
      end;

      // NYERI - PQRST Assessment
      if (FieldByName('nyeri').AsString <> '') or (FieldByName('skala_nyeri').AsString <> '') then
      begin
        AddSubHeader('ASSESMENT NYERI (PQRST)');

        if FieldByName('nyeri').AsString <> '' then
          AddLine('Nyeri              : ' + FieldByName('nyeri').AsString, 2);

        if FieldByName('provokes').AsString <> '' then
          AddLine('P - Provokes       : ' + FieldByName('provokes').AsString, 2);
        if FieldByName('ket_provokes').AsString <> '' then
          AddLine('   Keterangan      : ' + FieldByName('ket_provokes').AsString, 4);

        if FieldByName('quality').AsString <> '' then
          AddLine('Q - Quality        : ' + FieldByName('quality').AsString, 2);
        if FieldByName('ket_quality').AsString <> '' then
          AddLine('   Keterangan      : ' + FieldByName('ket_quality').AsString, 4);

        if FieldByName('lokasi').AsString <> '' then
          AddLine('R - Region/Lokasi  : ' + FieldByName('lokasi').AsString, 2);
        if FieldByName('menyebar').AsString <> '' then
          AddLine('   Menyebar ke     : ' + FieldByName('menyebar').AsString, 4);

        if FieldByName('skala_nyeri').AsString <> '' then
          AddLine('S - Severity/Skala : ' + FieldByName('skala_nyeri').AsString + '/10', 2);

        if FieldByName('durasi').AsString <> '' then
          AddLine('T - Time/Durasi    : ' + FieldByName('durasi').AsString, 2);
        if FieldByName('nyeri_hilang').AsString <> '' then
          AddLine('   Nyeri hilang jika: ' + FieldByName('nyeri_hilang').AsString, 4);
      end;

      // Hasil & Rencana Umum
      if FieldByName('hasil').AsString <> '' then
      begin
        AddSubHeader('HASIL PENILAIAN');
        AddLine(FieldByName('hasil').AsString, 2);
      end;

      if FieldByName('rencana').AsString <> '' then
      begin
        AddSubHeader('RENCANA UMUM');
        AddLine(FieldByName('rencana').AsString, 2);
      end;

      AddSeparator;
    end;
    Close;
  end;

  // ==================== MASALAH KEPERAWATAN (LIST) ====================
  MasalahCount := 0;
  with ZQueryMasalahKeperawatan do
  begin
    Close;
    SQL.Clear;
    SQL.Text :=
      'SELECT ' +
      '  m.kode_masalah, ' +
      '  m.nama_masalah ' +
      'FROM penilaian_awal_keperawatan_igd_masalah pm ' +
      'JOIN master_masalah_keperawatan_igd m ' +
      '  ON pm.kode_masalah = m.kode_masalah ' +
      'WHERE pm.no_rawat = :no_rawat ' +
      'ORDER BY m.nama_masalah';

    ParamByName('no_rawat').AsString := NoRawat;
    Open;

    if not IsEmpty then
    begin
      HasData := True;
      MasalahCount := RecordCount;

      AddSubHeader('📋 MASALAH KEPERAWATAN');
      AddLine('Total masalah: ' + IntToStr(MasalahCount), 2);

      while not EOF do
      begin
        AddLine('⚫ ' + FieldByName('nama_masalah').AsString, 2);
        Next;
      end;

      AddSeparator;
    end;
    Close;
  end;

  // ==================== RENCANA KEPERAWATAN (LIST) ====================
  RencanaCount := 0;
  with ZQueryRencanaKeperawatan do
  begin
    Close;
    SQL.Clear;
    SQL.Text :=
      'SELECT ' +
      '  r.kode_rencana, ' +
      '  mr.rencana_keperawatan ' +
      'FROM penilaian_awal_keperawatan_ralan_rencana_igd r ' +
      'JOIN master_rencana_keperawatan_igd mr ' +
      '  ON r.kode_rencana = mr.kode_rencana ' +
      'WHERE r.no_rawat = :no_rawat ' +
      'ORDER BY r.kode_rencana';

    ParamByName('no_rawat').AsString := NoRawat;
    Open;

    if not IsEmpty then
    begin
      HasData := True;
      RencanaCount := RecordCount;

      AddSubHeader('📝 RENCANA KEPERAWATAN');
      AddLine('Total rencana: ' + IntToStr(RencanaCount), 2);

      while not EOF do
      begin
        AddLine('✅ ' + FieldByName('rencana_keperawatan').AsString, 2);
        Next;
      end;
    end;
    Close;
  end;

  // ==================== TAMPILKAN INFORMASI JIKA TIDAK ADA DATA ====================
  if not HasData then
  begin
    AddHeader('PENILAIAN AWAL KEPERAWATAN IGD', clGray, 13);
    AddLine('Tidak ada data penilaian awal keperawatan IGD untuk kunjungan ini.', 2);
  end;

  AddSectionSeparator;
end;


/// PROCEDURE UNTUK LOAD PENILAIAN MEDIS IGD
procedure TFormRiwayatPasien.LoadPenilaianMedisIGD(const NoRawat: string);
var
  HasData: Boolean;
  DataCount: Integer;
begin
  HasData := False;
  DataCount := 0;

  with ZQueryPenilaianMedisIGD do
  begin
    Close;
    SQL.Clear;
    SQL.Text :=
      'SELECT ' +
      '  pmi.tanggal, ' +
      '  d.nm_dokter, ' +
      '  pmi.anamnesis, ' +
      '  pmi.hubungan, ' +
      '  pmi.keluhan_utama, ' +
      '  pmi.rps, ' +
      '  pmi.rpd, ' +
      '  pmi.rpk, ' +
      '  pmi.rpo, ' +
      '  pmi.alergi, ' +
      '  pmi.keadaan, ' +
      '  pmi.gcs, ' +
      '  pmi.kesadaran, ' +
      '  pmi.td, ' +
      '  pmi.nadi, ' +
      '  pmi.rr, ' +
      '  pmi.suhu, ' +
      '  pmi.spo, ' +
      '  pmi.bb, ' +
      '  pmi.tb, ' +
      '  pmi.kepala, ' +
      '  pmi.mata, ' +
      '  pmi.gigi, ' +
      '  pmi.leher, ' +
      '  pmi.thoraks, ' +
      '  pmi.abdomen, ' +
      '  pmi.genital, ' +
      '  pmi.ekstremitas, ' +
      '  pmi.ket_fisik, ' +
      '  pmi.ket_lokalis, ' +
      '  pmi.ekg, ' +
      '  pmi.rad, ' +
      '  pmi.lab, ' +
      '  pmi.diagnosis, ' +
      '  pmi.tata ' +
      'FROM penilaian_medis_igd pmi ' +
      'LEFT JOIN dokter d ON pmi.kd_dokter = d.kd_dokter ' +
      'WHERE pmi.no_rawat = :no_rawat ' +
      'ORDER BY pmi.tanggal DESC';

    ParamByName('no_rawat').AsString := NoRawat;
    Open;

    if not IsEmpty then
    begin
      HasData := True;
      DataCount := RecordCount;

      if DataCount > 1 then
        AddHeader('PENILAIAN MEDIS IGD (' + IntToStr(DataCount) + ' rekaman)', clBlue, 13)
      else
        AddHeader('PENILAIAN MEDIS IGD', clBlue, 13);

      while not EOF do
      begin
        // Header untuk tiap penilaian
        AddSubHeader('🩺 Tanggal: ' + FieldByName('tanggal').AsString);
        AddLine('Dokter: ' + FieldByName('nm_dokter').AsString, 2);

        // ANAMNESIS
        if (Trim(FieldByName('anamnesis').AsString) <> '') or
           (Trim(FieldByName('keluhan_utama').AsString) <> '') then
        begin
          AddSubHeader('ANAMNESIS');

          if Trim(FieldByName('anamnesis').AsString) <> '' then
            AddLine(FieldByName('anamnesis').AsString, 2);

          if Trim(FieldByName('hubungan').AsString) <> '' then
            AddLine('Hubungan dengan pasien: ' + FieldByName('hubungan').AsString, 2);

          if Trim(FieldByName('keluhan_utama').AsString) <> '' then
          begin
            AddLine('Keluhan Utama:', 2);
            AddLine(FieldByName('keluhan_utama').AsString, 4);
          end;
        end;

        // RIWAYAT
        if (Trim(FieldByName('rps').AsString) <> '') or
           (Trim(FieldByName('rpd').AsString) <> '') or
           (Trim(FieldByName('rpk').AsString) <> '') or
           (Trim(FieldByName('rpo').AsString) <> '') then
        begin
          AddSubHeader('RIWAYAT');

          if Trim(FieldByName('rps').AsString) <> '' then
            AddLine('RPS: ' + FieldByName('rps').AsString, 2);

          if Trim(FieldByName('rpd').AsString) <> '' then
            AddLine('RPD: ' + FieldByName('rpd').AsString, 2);

          if Trim(FieldByName('rpk').AsString) <> '' then
            AddLine('RPK: ' + FieldByName('rpk').AsString, 2);

          if Trim(FieldByName('rpo').AsString) <> '' then
            AddLine('RPO: ' + FieldByName('rpo').AsString, 2);
        end;

        // ALERGI
        if Trim(FieldByName('alergi').AsString) <> '' then
        begin
          AddSubHeader('ALERGI');
          AddLine(FieldByName('alergi').AsString, 2);
        end;

        // STATUS PRAESENS
        AddSubHeader('STATUS PRAESENS');

        // Keadaan Umum
        if Trim(FieldByName('keadaan').AsString) <> '' then
          AddLine('Keadaan Umum  : ' + FieldByName('keadaan').AsString, 2);

        if Trim(FieldByName('kesadaran').AsString) <> '' then
          AddLine('Kesadaran     : ' + FieldByName('kesadaran').AsString, 2);

        if Trim(FieldByName('gcs').AsString) <> '' then
          AddLine('GCS           : ' + FieldByName('gcs').AsString, 2);

        // Tanda Vital
        AddLine('Tanda Vital:', 2);
        if Trim(FieldByName('td').AsString) <> '' then
          AddLine('  TD   : ' + FieldByName('td').AsString + ' mmHg', 4);
        if Trim(FieldByName('nadi').AsString) <> '' then
          AddLine('  Nadi : ' + FieldByName('nadi').AsString + ' x/menit', 4);
        if Trim(FieldByName('rr').AsString) <> '' then
          AddLine('  RR   : ' + FieldByName('rr').AsString + ' x/menit', 4);
        if Trim(FieldByName('suhu').AsString) <> '' then
          AddLine('  Suhu : ' + FieldByName('suhu').AsString + ' °C', 4);
        if Trim(FieldByName('spo').AsString) <> '' then
          AddLine('  SpO2 : ' + FieldByName('spo').AsString + ' %', 4);

        // Antropometri
        if (Trim(FieldByName('bb').AsString) <> '') or (Trim(FieldByName('tb').AsString) <> '') then
        begin
          AddLine('Antropometri:', 2);
          if Trim(FieldByName('bb').AsString) <> '' then
            AddLine('  BB : ' + FieldByName('bb').AsString + ' kg', 4);
          if Trim(FieldByName('tb').AsString) <> '' then
            AddLine('  TB : ' + FieldByName('tb').AsString + ' cm', 4);
        end;

        // PEMERIKSAAN FISIK
        AddSubHeader('PEMERIKSAAN FISIK');

        // Sistem tubuh
        if Trim(FieldByName('kepala').AsString) <> '' then
          AddLine('Kepala      : ' + FieldByName('kepala').AsString, 2);
        if Trim(FieldByName('mata').AsString) <> '' then
          AddLine('Mata        : ' + FieldByName('mata').AsString, 2);
        if Trim(FieldByName('gigi').AsString) <> '' then
          AddLine('Gigi & Mulut: ' + FieldByName('gigi').AsString, 2);
        if Trim(FieldByName('leher').AsString) <> '' then
          AddLine('Leher       : ' + FieldByName('leher').AsString, 2);
        if Trim(FieldByName('thoraks').AsString) <> '' then
          AddLine('Thoraks     : ' + FieldByName('thoraks').AsString, 2);
        if Trim(FieldByName('abdomen').AsString) <> '' then
          AddLine('Abdomen     : ' + FieldByName('abdomen').AsString, 2);
        if Trim(FieldByName('genital').AsString) <> '' then
          AddLine('Genital     : ' + FieldByName('genital').AsString, 2);
        if Trim(FieldByName('ekstremitas').AsString) <> '' then
          AddLine('Ekstremitas : ' + FieldByName('ekstremitas').AsString, 2);

        // Keterangan tambahan
        if Trim(FieldByName('ket_fisik').AsString) <> '' then
        begin
          AddSubHeader('KETERANGAN FISIK LAINNYA');
          AddLine(FieldByName('ket_fisik').AsString, 2);
        end;

        if Trim(FieldByName('ket_lokalis').AsString) <> '' then
        begin
          AddSubHeader('KETERANGAN LOKALIS');
          AddLine(FieldByName('ket_lokalis').AsString, 2);
        end;

        // PEMERIKSAAN PENUNJANG
        if (Trim(FieldByName('ekg').AsString) <> '') or
           (Trim(FieldByName('rad').AsString) <> '') or
           (Trim(FieldByName('lab').AsString) <> '') then
        begin
          AddSubHeader('PEMERIKSAAN PENUNJANG');

          if Trim(FieldByName('ekg').AsString) <> '' then
          begin
            AddLine('EKG:', 2);
            AddLine(FieldByName('ekg').AsString, 4);
          end;

          if Trim(FieldByName('rad').AsString) <> '' then
          begin
            AddLine('Radiologi:', 2);
            AddLine(FieldByName('rad').AsString, 4);
          end;

          if Trim(FieldByName('lab').AsString) <> '' then
          begin
            AddLine('Laboratorium:', 2);
            AddLine(FieldByName('lab').AsString, 4);
          end;
        end;

        // DIAGNOSIS & TATA LAKSANA
        AddSubHeader('DIAGNOSIS & TATA LAKSANA');

        if Trim(FieldByName('diagnosis').AsString) <> '' then
        begin
          AddLine('Diagnosis:', 2);
          AddLine(FieldByName('diagnosis').AsString, 4);
        end;

        if Trim(FieldByName('tata').AsString) <> '' then
        begin
          AddLine('Tata Laksana:', 2);
          AddLine(FieldByName('tata').AsString, 4);
        end;

        // Pemisah antar penilaian (kecuali yang terakhir)
        Next;
        if not EOF then
        begin
          AddSeparator;
          AddLine('════════════════════════════════════════════════════════════', 0);
          AddSeparator;
        end;
      end;
    end;
    Close;
  end;

  if not HasData then
  begin
    AddHeader('PENILAIAN MEDIS IGD', clGray, 13);
    AddLine('Tidak ada data penilaian medis IGD untuk kunjungan ini.', 2);
  end;

  AddSectionSeparator;
end;

// PROCEDURE UNTUK LOAD TINDAKAN RAWAT JALAN
// PROCEDURE UNTUK LOAD TINDAKAN RAWAT JALAN - VERSI FINAL
procedure TFormRiwayatPasien.LoadTindakanJalan(const NoRawat: string);
var
  HasData: Boolean;
  TotalTindakan: Integer;
  GrandTotal: Currency;
  Count: Integer;
  TanggalSekarang, TanggalSebelum: string;
  NamaTindakan, Petugas, StatusBayarText: string;
  Biaya: Currency;
  i: Integer;
begin
  HasData := False;
  TotalTindakan := 0;
  GrandTotal := 0;
  Count := 0;
  TanggalSebelum := '';

  with ZQueryTindakanRajal do
  begin
    Close;
    SQL.Clear;

    // ==============================================
    // QUERY SEDERHANA - PASTI JALAN
    // ==============================================
    SQL.Text :=
      'SELECT ' +
      '    r.tgl_perawatan, ' +
      '    DATE_FORMAT(r.tgl_perawatan, "%d/%m/%Y") AS tgl_format, ' +
      '    COALESCE(jp.nm_perawatan, "Tindakan") AS nm_perawatan, ' +
      '    r.biaya_rawat, ' +
      '    COALESCE(r.stts_bayar, "Belum") AS stts_bayar ' +
      'FROM ' +
      '( ' +
      '    SELECT tgl_perawatan, kd_jenis_prw, biaya_rawat, stts_bayar ' +
      '    FROM rawat_jl_dr WHERE no_rawat = "' + NoRawat + '" ' +
      '    UNION ALL ' +
      '    SELECT tgl_perawatan, kd_jenis_prw, biaya_rawat, stts_bayar ' +
      '    FROM rawat_jl_pr WHERE no_rawat = "' + NoRawat + '" ' +
      '    UNION ALL ' +
      '    SELECT tgl_perawatan, kd_jenis_prw, biaya_rawat, stts_bayar ' +
      '    FROM rawat_jl_drpr WHERE no_rawat = "' + NoRawat + '" ' +
      ') r ' +
      'LEFT JOIN jns_perawatan jp ON r.kd_jenis_prw = jp.kd_jenis_prw ' +
      'ORDER BY r.tgl_perawatan DESC';

    try
      Open;

      if not IsEmpty then
      begin
        HasData := True;
        TotalTindakan := RecordCount;

        // HITUNG GRAND TOTAL
        First;
        while not EOF do
        begin
          GrandTotal := GrandTotal + FieldByName('biaya_rawat').AsCurrency;
          Next;
        end;
        First;

        // ==============================================
        // HEADER UTAMA
        // ==============================================
        AddHeader('═══════════════════════════════════════════════════════════════════════', clNavy, 10);
        AddHeader('🏥  TINDAKAN RAWAT JALAN', clNavy, 14);
        AddHeader('═══════════════════════════════════════════════════════════════════════', clNavy, 10);
        AddLine('', 0);

        // SUMMARY
        AddLine('📋  No. Rawat: ' + NoRawat, 1);
        AddLine('💰  Total Biaya: Rp ' + FormatFloat('#,##0', GrandTotal), 1);
        AddLine('📊  Jumlah Tindakan: ' + IntToStr(TotalTindakan) + ' item', 1);
        AddSeparator;
        AddLine('', 0);

        // ==============================================
        // DETAIL TINDAKAN
        // ==============================================
        Count := 0;
        TanggalSebelum := '';

        while not EOF do
        begin
          Inc(Count);

          // FORMAT TANGGAL
          if FindField('tgl_format') <> nil then
            TanggalSekarang := FieldByName('tgl_format').AsString
          else
            TanggalSekarang := FormatDateTime('dd/mm/yyyy', FieldByName('tgl_perawatan').AsDateTime);

          // HEADER TANGGAL
          if TanggalSekarang <> TanggalSebelum then
          begin
            if TanggalSebelum <> '' then
              AddLine('', 0);
            AddHeader('📅  ' + TanggalSekarang, clBlue, 11);
            AddHeader('───────────────────────────────────────────────────────────────────', clGray, 8);
            TanggalSebelum := TanggalSekarang;
          end;

          // NAMA TINDAKAN
          NamaTindakan := FieldByName('nm_perawatan').AsString;
          if NamaTindakan = '' then
            NamaTindakan := 'Tindakan';
          NamaTindakan := Copy(NamaTindakan, 1, 35);

          // STATUS BAYAR
          StatusBayarText := FieldByName('stts_bayar').AsString;
          if StatusBayarText = 'Sudah' then
            StatusBayarText := '✅'
          else if StatusBayarText = 'Belum' then
            StatusBayarText := '⏳'
          else
            StatusBayarText := '❓';

          // BIAYA
          Biaya := FieldByName('biaya_rawat').AsCurrency;

          // TAMPILKAN 1 BARIS
          AddLine(Format('  %2d.  %s  %-35s  Rp %s',
            [Count,
             StatusBayarText,
             NamaTindakan,
             FormatFloat('#,##0', Biaya)]), 0);

          Next;
        end;

        AddLine('', 0);
        AddSeparator;
        AddHeader('✅  TOTAL: Rp ' + FormatFloat('#,##0', GrandTotal) + ' (' + IntToStr(TotalTindakan) + ' tindakan)', clGreen, 11);
        AddSeparator;
      end;

    except
      on E: Exception do
      begin
        AddHeader('═══════════════════════════════════════════════════════════════════════', clRed, 10);
        AddHeader('❌  ERROR', clRed, 14);
        AddHeader('═══════════════════════════════════════════════════════════════════════', clRed, 10);
        AddLine('', 0);
        AddLine('Terjadi kesalahan:', 1);
        AddLine(E.Message, 1);
        AddLine('', 0);
        AddLine('No. Rawat: ' + NoRawat, 1);
        AddSeparator;
      end;
    end;

    Close;
  end;

  if not HasData then
  begin
    AddHeader('═══════════════════════════════════════════════════════════════════════', clGray, 10);
    AddHeader('🏥  TINDAKAN RAWAT JALAN', clGray, 14);
    AddHeader('═══════════════════════════════════════════════════════════════════════', clGray, 10);
    AddLine('', 0);
    AddLine('ℹ️  Tidak ada data tindakan', 2);
    AddLine('   No. Rawat: ' + NoRawat, 1);
    AddSeparator;
  end;

  AddSectionSeparator;
end;

// VERSI LENGKAP - SUDAH DENGAN NAMA TINDAKAN
procedure TFormRiwayatPasien.LoadTindakanRanap(const NoRawat: string);
var
  HasData: Boolean;
  GrandTotal: Currency;
  Count: Integer;
  TanggalSekarang, TanggalSebelum: string;
begin
  HasData := False;
  GrandTotal := 0;
  Count := 0;
  TanggalSebelum := '';

  with ZQueryTindakanRanap do
  begin
    Close;
    SQL.Clear;

    // QUERY UNTUK RAWAT_INAP_DR
    SQL.Text :=
      'SELECT ' +
      '    rd.tgl_perawatan, ' +
      '    rd.biaya_rawat, ' +
      '    "Tindakan Dokter" as nama_tindakan ' +
      'FROM rawat_inap_dr rd ' +
      'WHERE rd.no_rawat = "' + NoRawat + '" ' +
      'UNION ALL ' +
      'SELECT ' +
      '    rp.tgl_perawatan, ' +
      '    rp.biaya_rawat, ' +
      '    "Tindakan Perawat" as nama_tindakan ' +
      'FROM rawat_inap_pr rp ' +
      'WHERE rp.no_rawat = "' + NoRawat + '" ' +
      'UNION ALL ' +
      'SELECT ' +
      '    rdp.tgl_perawatan, ' +
      '    rdp.biaya_rawat, ' +
      '    "Tindakan Dokter & Perawat" as nama_tindakan ' +
      'FROM rawat_inap_drpr rdp ' +
      'WHERE rdp.no_rawat = "' + NoRawat + '" ' +
      'ORDER BY tgl_perawatan DESC';

    try
      Open;

      if not IsEmpty then
      begin
        HasData := True;

        // Hitung Grand Total
        First;
        while not EOF do
        begin
          GrandTotal := GrandTotal + FieldByName('biaya_rawat').AsCurrency;
          Next;
        end;
        First;

        // ==============================================
        // HEADER
        // ==============================================
        AddHeader('═══════════════════════════════════════════════════════════════════════', clNavy, 10);
        AddHeader('🏥  TINDAKAN RAWAT INAP', clNavy, 14);
        AddHeader('═══════════════════════════════════════════════════════════════════════', clNavy, 10);
        AddLine('', 0);
        AddHeader('💰 TOTAL KESELURUHAN: Rp ' + FormatFloat('#,##0', GrandTotal), clGreen, 12);
        AddSeparator;
        AddLine('', 0);

        // ==============================================
        // DETAIL PER TANGGAL
        // ==============================================
        while not EOF do
        begin
          Inc(Count);

          // Format tanggal
          TanggalSekarang := FormatDateTime('dd/mm/yyyy', FieldByName('tgl_perawatan').AsDateTime);

          // Tampilkan header tanggal
          if TanggalSekarang <> TanggalSebelum then
          begin
            if TanggalSebelum <> '' then
              AddLine('', 0);
            AddHeader('📅  ' + TanggalSekarang, clBlue, 11);
            AddHeader('───────────────────────────────────────────────────────────────────', clGray, 8);
            TanggalSebelum := TanggalSekarang;
          end;

          // Tampilkan tindakan
          AddLine(Format('  %2d.  %-30s  Rp %s',
            [Count,
             Copy(FieldByName('nama_tindakan').AsString, 1, 30),
             FormatFloat('#,##0', FieldByName('biaya_rawat').AsCurrency)]), 0);

          Next;
        end;

        AddLine('', 0);
        AddSeparator;
        AddHeader('✅  Total: ' + IntToStr(Count) + ' tindakan', clGreen, 11);
        AddSeparator;
      end;

    except
      on E: Exception do
      begin
        AddHeader('❌ ERROR', clRed, 12);
        AddLine('Terjadi kesalahan: ' + E.Message, 1);
        AddSeparator;
      end;
    end;

    Close;
  end;

  if not HasData then
  begin
    AddHeader('═══════════════════════════════════════════════════════════════════════', clGray, 10);
    AddHeader('🏥  TINDAKAN RAWAT INAP', clGray, 14);
    AddHeader('═══════════════════════════════════════════════════════════════════════', clGray, 10);
    AddLine('', 0);
    AddLine('ℹ️  Tidak ada data tindakan', 2);
    AddSeparator;
  end;

  AddSectionSeparator;
end;

/// soap rawat jalan
const
  SQL_SOAP_RAJAL =
    'SELECT ' +
    ' pr.tgl_perawatan, pr.jam_rawat, ' +
    ' pr.keluhan, pr.pemeriksaan, pr.penilaian, pr.rtl, ' +
    ' pr.instruksi, pr.evaluasi, ' +
    ' pr.tensi, pr.nadi, pr.respirasi, pr.suhu_tubuh, pr.spo2, ' +
    ' pr.kesadaran, pg.nama ' +
    'FROM pemeriksaan_ralan pr ' +
    'LEFT JOIN pegawai pg ON pr.nip = pg.nik ' +
    'WHERE pr.no_rawat = :no_rawat ' +
    'ORDER BY pr.tgl_perawatan DESC, pr.jam_rawat DESC';

procedure TFormRiwayatPasien.LoadSOAPRajal(const NoRawat: string);
var
  HasData: Boolean;
  TglJam, Dokter, Keluhan, Pemeriksaan, Penilaian, RTL, Instruksi, Evaluasi: string;
begin
  zqSOAP.Close;
  zqSOAP.SQL.Text := SQL_SOAP_RAJAL;
  zqSOAP.ParamByName('no_rawat').AsString := NoRawat;
  zqSOAP.Open;

  HasData := False;

  // Cek dulu apakah ada data
  if not zqSOAP.IsEmpty then
  begin
    AddHeader('SOAP RAWAT JALAN', clPurple, 11);
    HasData := True;

    while not zqSOAP.EOF do
    begin
      // Ambil data ke variabel
      TglJam := zqSOAP.FieldByName('tgl_perawatan').AsString + ' ' +
                zqSOAP.FieldByName('jam_rawat').AsString;
      Dokter := zqSOAP.FieldByName('nama').AsString;
      Keluhan := zqSOAP.FieldByName('keluhan').AsString;
      Pemeriksaan := zqSOAP.FieldByName('pemeriksaan').AsString;
      Penilaian := zqSOAP.FieldByName('penilaian').AsString;
      RTL := zqSOAP.FieldByName('rtl').AsString;
      Instruksi := zqSOAP.FieldByName('instruksi').AsString;
      Evaluasi := zqSOAP.FieldByName('evaluasi').AsString;

      // Header pemeriksaan
      AddSubHeader('Pemeriksaan: ' + TglJam);

      // Dokter
      if Dokter <> '' then
        AddLine('Dokter: ' + Dokter, 2);

      // SOAP format - hanya tampilkan jika ada isinya
      if Trim(Keluhan) <> '' then
      begin
        AddSubHeader('S - SUBJEKTIF');
        AddLine(Keluhan, 4);
      end;

      if Trim(Pemeriksaan) <> '' then
      begin
        AddSubHeader('O - OBJEKTIF');
        AddLine(Pemeriksaan, 4);
      end;

      if Trim(Penilaian) <> '' then
      begin
        AddSubHeader('A - ASSESMENT');
        AddLine(Penilaian, 4);
      end;

      if Trim(RTL) <> '' then
      begin
        AddSubHeader('P - PLAN');
        AddLine(RTL, 4);
      end;

      // Instruksi & Evaluasi
      if Trim(Instruksi) <> '' then
      begin
        AddSubHeader('Instruksi');
        AddLine(Instruksi, 4);
      end;

      if Trim(Evaluasi) <> '' then
      begin
        AddSubHeader('Evaluasi');
        AddLine(Evaluasi, 4);
      end;

      // Tanda Vital - hanya tampilkan jika ada data
      if (zqSOAP.FieldByName('tensi').AsString <> '') or
         (zqSOAP.FieldByName('nadi').AsString <> '') then
      begin
        AddSubHeader('Tanda Vital');

        if zqSOAP.FieldByName('tensi').AsString <> '' then
          AddLine('TD        : ' + zqSOAP.FieldByName('tensi').AsString + ' mmHg', 4);

        if zqSOAP.FieldByName('nadi').AsString <> '' then
          AddLine('Nadi      : ' + zqSOAP.FieldByName('nadi').AsString + ' x/menit', 4);

        if zqSOAP.FieldByName('respirasi').AsString <> '' then
          AddLine('RR        : ' + zqSOAP.FieldByName('respirasi').AsString + ' x/menit', 4);

        if zqSOAP.FieldByName('suhu_tubuh').AsString <> '' then
          AddLine('Suhu      : ' + zqSOAP.FieldByName('suhu_tubuh').AsString + ' °C', 4);

        if zqSOAP.FieldByName('spo2').AsString <> '' then
          AddLine('SpO2      : ' + zqSOAP.FieldByName('spo2').AsString + ' %', 4);

        if zqSOAP.FieldByName('kesadaran').AsString <> '' then
          AddLine('Kesadaran : ' + zqSOAP.FieldByName('kesadaran').AsString, 4);
      end;

      // Pemisah antar pemeriksaan
      zqSOAP.Next;
      if not zqSOAP.EOF then
        AddSeparator;
    end;
  end;

  if not HasData then
    AddLine('Tidak ada data pemeriksaan rawat jalan.', 0);
end;

/// soap ranap
const
  SQL_SOAP_RANAP =
    'SELECT ' +
    ' pr.tgl_perawatan, pr.jam_rawat, ' +
    ' pr.keluhan, pr.pemeriksaan, pr.penilaian, pr.rtl, ' +
    ' pr.instruksi, pr.evaluasi, ' +
    ' pr.tensi, pr.nadi, pr.respirasi, pr.suhu_tubuh, pr.spo2, ' +
    ' pr.kesadaran, pg.nama ' +
    'FROM pemeriksaan_ranap pr ' +
    'LEFT JOIN pegawai pg ON pr.nip = pg.nik ' +
    'WHERE pr.no_rawat = :no_rawat ' +
    'ORDER BY pr.tgl_perawatan DESC, pr.jam_rawat DESC';

procedure TFormRiwayatPasien.LoadSOAPRanap(const NoRawat: string);
var
  HasData: Boolean;
  TglJam, Dokter, Keluhan, Pemeriksaan, Penilaian, RTL, Instruksi, Evaluasi: string;
begin
  zqSOAP.Close;
  zqSOAP.SQL.Text := SQL_SOAP_RANAP;
  zqSOAP.ParamByName('no_rawat').AsString := NoRawat;
  zqSOAP.Open;

  HasData := False;

  if not zqSOAP.IsEmpty then
  begin
    AddHeader('SOAP RAWAT INAP', clMaroon, 11);
    HasData := True;

    while not zqSOAP.EOF do
    begin
      // Ambil data ke variabel
      TglJam := zqSOAP.FieldByName('tgl_perawatan').AsString + ' ' +
                zqSOAP.FieldByName('jam_rawat').AsString;
      Dokter := zqSOAP.FieldByName('nama').AsString;
      Keluhan := zqSOAP.FieldByName('keluhan').AsString;
      Pemeriksaan := zqSOAP.FieldByName('pemeriksaan').AsString;
      Penilaian := zqSOAP.FieldByName('penilaian').AsString;
      RTL := zqSOAP.FieldByName('rtl').AsString;
      Instruksi := zqSOAP.FieldByName('instruksi').AsString;
      Evaluasi := zqSOAP.FieldByName('evaluasi').AsString;

      // Header pemeriksaan
      AddSubHeader('Pemeriksaan: ' + TglJam);

      // Dokter
      if Dokter <> '' then
        AddLine('Dokter: ' + Dokter, 2);

      // SOAP format - hanya tampilkan jika ada isinya
      if Trim(Keluhan) <> '' then
      begin
        AddSubHeader('S - SUBJEKTIF');
        AddLine(Keluhan, 4);
      end;

      if Trim(Pemeriksaan) <> '' then
      begin
        AddSubHeader('O - OBJEKTIF');
        AddLine(Pemeriksaan, 4);
      end;

      if Trim(Penilaian) <> '' then
      begin
        AddSubHeader('A - ASSESMENT');
        AddLine(Penilaian, 4);
      end;

      if Trim(RTL) <> '' then
      begin
        AddSubHeader('P - PLAN');
        AddLine(RTL, 4);
      end;

      // Instruksi & Evaluasi
      if Trim(Instruksi) <> '' then
      begin
        AddSubHeader('Instruksi');
        AddLine(Instruksi, 4);
      end;

      if Trim(Evaluasi) <> '' then
      begin
        AddSubHeader('Evaluasi');
        AddLine(Evaluasi, 4);
      end;

      // Tanda Vital - hanya tampilkan jika ada data
      if (zqSOAP.FieldByName('tensi').AsString <> '') or
         (zqSOAP.FieldByName('nadi').AsString <> '') then
      begin
        AddSubHeader('Tanda Vital');

        if zqSOAP.FieldByName('tensi').AsString <> '' then
          AddLine('TD        : ' + zqSOAP.FieldByName('tensi').AsString + ' mmHg', 4);

        if zqSOAP.FieldByName('nadi').AsString <> '' then
          AddLine('Nadi      : ' + zqSOAP.FieldByName('nadi').AsString + ' x/menit', 4);

        if zqSOAP.FieldByName('respirasi').AsString <> '' then
          AddLine('RR        : ' + zqSOAP.FieldByName('respirasi').AsString + ' x/menit', 4);

        if zqSOAP.FieldByName('suhu_tubuh').AsString <> '' then
          AddLine('Suhu      : ' + zqSOAP.FieldByName('suhu_tubuh').AsString + ' °C', 4);

        if zqSOAP.FieldByName('spo2').AsString <> '' then
          AddLine('SpO2      : ' + zqSOAP.FieldByName('spo2').AsString + ' %', 4);

        if zqSOAP.FieldByName('kesadaran').AsString <> '' then
          AddLine('Kesadaran : ' + zqSOAP.FieldByName('kesadaran').AsString, 4);
      end;

      // Pemisah antar pemeriksaan
      zqSOAP.Next;
      if not zqSOAP.EOF then
        AddSeparator;
    end;
  end;

  if not HasData then
    AddLine('Tidak ada data pemeriksaan rawat inap.', 0);
end;

procedure TFormRiwayatPasien.PanelKeluarClick(Sender: TObject);
begin
 Close;
end;

procedure TFormRiwayatPasien.FormShow(Sender: TObject);
begin
  if Trim(EditNORM.Text) = '' then Exit;
  LoadKunjungan(EditNORM.Text);

   // Bersihkan RichMemo saat pertama kali form muncul
  InitRichMemo;

  /// grid pemeriksaan awal medis umum
  DBGridKunjungan.DataSource := DataSourceKunjungan;
 // Gaya seperti tabel web modern
  with DBGridKunjungan do
  begin
    Font.Name := 'Segoe UI';        // Font modern
    Font.Size := 9;
    Height := 24;                // Spasi antar baris
    DefaultRowHeight := 24;

    Options := Options + [
      dgTitles,         // Tampilkan judul kolom
      dgColLines,       // Garis antar kolom
      dgRowLines,       // Garis antar baris
      dgRowHighlight,   // Highlight baris saat mouse hover
      dgColumnResize    // Boleh resize kolom
    ] - [dgEditing];     // Nonaktifkan edit langsung di grid

    //AlternatingRowColor := $00F8F8F8; // Warna selang-seling baris
    TitleFont.Style := [fsBold];      // Judul kolom tebal
    TitleFont.Color:= clWhite;//$00232120;
    FixedColor := $00B4963C;//$00232120;          // Warna header
    GridLineColor := clSilver;

    BorderStyle := bsSingle;
  end;

  clbRiwayat.Items.Add('Triase IGD');
  clbRiwayat.Items.Add('Keperawatan IGD');
  clbRiwayat.Items.Add('Penilaian Medis IGD');
  clbRiwayat.Items.Add('Tindakan Rajal/Igd');
  clbRiwayat.Items.Add('Tindakan Ranap');
  clbRiwayat.Items.Add('SOAP Rawat Jalan');
  clbRiwayat.Items.Add('SOAP Rawat Inap');

  // default dicentang semua
  clbRiwayat.Checked[0] := True;
  clbRiwayat.Checked[1] := True;
  clbRiwayat.Checked[2] := True;
  clbRiwayat.Checked[3] := True;
  clbRiwayat.Checked[4] := True;
  clbRiwayat.Checked[5] := True;
  clbRiwayat.Checked[6] := True;

end;

procedure TFormRiwayatPasien.DBGridKunjunganCellClick(Column: TColumn);
var
  NoRawat: string;
begin
  //TampilTriase(zqueryKunjungan.FieldByName('no_rawat').AsString);
  //ShowMessage(zqueryKunjungan.FieldByName('no_rawat').AsString);
  //TampilTriase('2025/03/08/000111 ');
  if ZQueryKunjungan.IsEmpty then Exit;

  NoRawat := ZQueryKunjungan.FieldByName('no_rawat').AsString;

  InitRichMemo;

  // Tambahkan header pasien
  AddHeader('RIWAYAT PASIEN', clGreen, 13);
  AddLine('Nama: ' + EditNAMA.Text, 2);
  AddLine('No RM: ' + EditNORM.Text, 2);
  AddLine('No Rawat: ' + NoRawat, 2);
  AddSeparator;

  //AddSectionSeparator;
  LoadTriase(NoRawat);
  LoadPenilaianAwalIGD(NoRawat);
  LoadPenilaianMedisIGD(NoRawat);
  /// tindakan
  LoadTindakanJalan(NoRawat);
  LoadTindakanRanap(NoRawat);
  ///
  LoadSOAPRajal(NoRawat);
  LoadSOAPRanap(NoRawat);


  // Jika tidak ada data sama sekali
  if RichMemoRiwayat.Lines.Count < 10 then
  begin
    AddHeader('Informasi');
    AddLine('Tidak ada data pemeriksaan SOAP untuk kunjungan ini.', 2);
  end;

  // Scroll ke atas
  RichMemoRiwayat.SelStart := 0;
  RichMemoRiwayat.SelLength := 0;
  RichMemoRiwayat.VertScrollBar.Position := 0;
end;

end.

