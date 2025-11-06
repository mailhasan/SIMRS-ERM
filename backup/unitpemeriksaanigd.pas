unit unitPemeriksaanIGD;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Grids, DateTimePicker, AnchorDockPanel, Types, LCLIntf, LCLType,
  Buttons;

type

  { TFormPemeriksaanIgd }

  TFormPemeriksaanIgd = class(TForm)
    BitBtn1: TBitBtn;
    BitBtnHapusTriase: TBitBtn;
    ButtonTampilDataTriase: TButton;
    ButtonSimpanTriase: TButton;
    ButtonInputPemeriksaan: TButton;
    ComboBoxAlasanKedatangan: TComboBox;
    ComboBoxKebutuhanKhusus: TComboBox;
    ComboBoxMacamKasus: TComboBox;
    ComboBoxJenisTriase: TComboBox;
    ComboBoxSkala: TComboBox;
    ComboBoxPlan: TComboBox;
    ComboBoxCaraMasuk: TComboBox;
    ComboBoxTransportasi: TComboBox;
    DateTimePicker: TDateTimePicker;
    DateTimePickerMulaiTriase: TDateTimePicker;
    DateTimePickerKunjungan: TDateTimePicker;
    DateTimePickerSampaiTriase: TDateTimePicker;
    DateTimePickerTriase: TDateTimePicker;
    EditCariTriase: TEdit;
    EditKodePetugas: TEdit;
    EditNamaPetugas: TEdit;
    EditKeterangan: TEdit;
    EditNadi: TEdit;
    EditNoSep: TEdit;
    EditNama: TEdit;
    EditNoRm: TEdit;
    EditNoRawat: TEdit;
    EditNyeri: TEdit;
    EditRespirasi: TEdit;
    EditSaturasi: TEdit;
    EditSuhu: TEdit;
    EditTensi: TEdit;
    GroupBox1: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    GroupBox13: TGroupBox;
    GroupBox16: TGroupBox;
    GroupBox17: TGroupBox;
    GroupBox18: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    LabelJumlah: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LabelMasterPemeriksaan: TLabel;
    MemoCatatan: TMemo;
    MemoKeluhanAnamesa: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    PanelKonten: TPanel;
    PanelTengah: TPanel;
    PanelAtas: TPanel;
    StringGridTriaseIgd: TStringGrid;
    StringGridMasterPemeriksaan: TStringGrid;
    StringGridHasilPemeriksaan: TStringGrid;
    StringGridSkala: TStringGrid;
    TabSheetTriase: TTabSheet;
    TabSheet2: TTabSheet;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtnHapusTriaseClick(Sender: TObject);
    procedure ButtonSimpanTriaseClick(Sender: TObject);
    procedure ButtonInputPemeriksaanClick(Sender: TObject);
    procedure ButtonTampilDataTriaseClick(Sender: TObject);
    procedure ButtonTriaseClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBoxJenisTriaseChange(Sender: TObject);
    procedure ComboBoxSkalaChange(Sender: TObject);
    procedure ComboBoxSkalaClick(Sender: TObject);
    procedure ComboBoxSkalaSelect(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGridHasilPemeriksaanDrawCell(Sender: TObject; aCol,
      aRow: Integer; aRect: TRect; aState: TGridDrawState);
    procedure StringGridMasterPemeriksaanClick(Sender: TObject);
    procedure StringGridMasterPemeriksaanDrawCell(Sender: TObject; aCol,
      aRow: Integer; aRect: TRect; aState: TGridDrawState);
    procedure TabControl1Change(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
  private
   procedure TampilkanFormDiPanel(AForm: TForm);
   procedure ClearPanel;

  public
    procedure baruTriase;
    procedure cbbmaster_triase_macam_kasus;
    procedure masterPemeriksaan;
    procedure CariDataMaterPemeriksaan(const KataKunci: string);
    procedure TampilSkala(const kodePemeriksaan, skala: string);
    procedure settingGridHasil;
    procedure KirimTriaseLengkap;
    // tampil data triase
    procedure InisialisasiGrid;
    procedure TampilDataTriase;
    procedure BersihkanGridTriase;
  end;

var
  FormPemeriksaanIgd: TFormPemeriksaanIgd;

implementation

{$R *.lfm}

{ TFormPemeriksaanIgd }
uses unitTriaseIgd,unitDmIgd;

procedure TFormPemeriksaanIgd.ClearPanel;
var
  i: Integer;
begin
  for i := PanelKonten.ControlCount - 1 downto 0 do
  begin
    // Jangan Free kalau kontrol yang mau dipakai lagi
    if PanelKonten.Controls[i] <> FormPemeriksaanIgd then
      PanelKonten.Controls[i].Free;
  end;
end;

procedure TFormPemeriksaanIgd.TampilkanFormDiPanel(AForm: TForm);
begin
  ClearPanel;
  AForm.Parent := PanelTengah;
  AForm.Align := alClient;
  AForm.BorderStyle := bsNone;
  AForm.Visible := True;
end;

procedure TFormPemeriksaanIgd.ButtonTriaseClick(Sender: TObject);
begin
if not Assigned(FormTriaseIgd) then
  FormTriaseIgd := TFormTriaseIgd.Create(Self);
 /// tampil form
  TampilkanFormDiPanel(FormTriaseIgd);
end;

/// procedure crud pemeriksaan
procedure TFormPemeriksaanIgd.KirimTriaseLengkap;
var
  NoRawat, KodeKasus, CaraMasuk, Transportasi, Alasan, Ket, TD, Nadi,
  Napas, Suhu, Saturasi, Nyeri, Keluhan, Kebutuhan, Catatan, Plan, Nik,
  Anamnesa, SkalaKe, KodeSkala: string;
  i,PosStrip: Integer;
  Tgl: TDateTime;
begin
  // Ambil nilai kode_kasus dari ComboBox
  if ComboBoxMacamKasus.ItemIndex = -1 then
  begin
    ShowMessage('Pilih macam kasus dulu!');
    Exit;
  end;

  // Pisahkan teks sebelum tanda ' - '
  PosStrip := Pos(' - ', ComboBoxMacamKasus.Text);
  if PosStrip > 0 then
    KodeKasus := Copy(ComboBoxMacamKasus.Text, 1, PosStrip - 1)
  else
    KodeKasus := ComboBoxMacamKasus.Text; // fallback kalau tidak ada strip

  // Ambil data umum dari form
  NoRawat := EditNoRawat.Text;
  //KodeKasus := '';//edtKodeKasus.Text;
  CaraMasuk := ComboBoxCaraMasuk.Text;
  Transportasi := ComboBoxTransportasi.Text;
  Alasan := ComboBoxAlasanKedatangan.Text;
  Ket := EditKeterangan.Text;
  TD := EditTensi.Text;
  Nadi := EditNadi.Text;
  Napas := EditRespirasi.Text;
  Suhu := EditSuhu.Text;
  Saturasi := EditSaturasi.Text;
  Nyeri := EditNyeri.Text;
  Tgl := DateTimePickerTriase.DateTime;

  // Simpan Triase Utama
  DataModuleIgd.HapusTriaseUtama(NoRawat);
  DataModuleIgd.SimpanTriaseUtama(NoRawat, KodeKasus, CaraMasuk, Transportasi,
    Alasan, Ket, TD, Nadi, Napas, Suhu, Saturasi, Nyeri, Tgl);

  // Simpan berdasarkan jenis triase
  if ComboBoxJenisTriase.Text = 'Triase Primer' then
  begin
    Keluhan := MemoKeluhanAnamesa.Text;
    Kebutuhan := ComboBoxKebutuhanKhusus.Text;
    Catatan := MemoCatatan.Text;
    Plan := ComboBoxJenisTriase.Text;
    Nik := EditKodePetugas.Text;

    DataModuleIgd.HapusTriasePrimer(NoRawat);
    DataModuleIgd.SimpanTriasePrimer(NoRawat, Keluhan, Kebutuhan, Catatan, Plan, Nik, Tgl);
  end
  else if ComboBoxJenisTriase.Text = 'Triase Sekunder' then
  begin
    Anamnesa := MemoKeluhanAnamesa.Text;
    Catatan := MemoCatatan.Text;
    Plan := ComboBoxJenisTriase.Text;
    Nik := EditKodePetugas.Caption;

    DataModuleIgd.HapusTriaseSekunder(NoRawat);
    DataModuleIgd.SimpanTriaseSekunder(NoRawat, Anamnesa, Catatan, Plan, Nik, Tgl);
  end;

  // --- Skala ---
  // Pastikan ComboBoxSkala sudah diisi (contoh: 'Skala 1', 'Skala 2', dst)
  if ComboBoxSkala.ItemIndex = -1 then
  begin
   ShowMessage('Pilih skala pemeriksaan terlebih dahulu.');
   Exit;
  end;

  // Ambil angka skala dari teks: 'Skala 3' -> '3'
  SkalaKe := Trim(StringReplace(ComboBoxSkala.Text, 'Skala ', '', [rfIgnoreCase]));

  // Hapus data skala lama
  DataModuleIgd.HapusDetailSkala(NoRawat, SkalaKe);

  // Loop StringGrid
  for i := 1 to StringGridHasilPemeriksaan.RowCount - 1 do
  begin
    // Asumsikan StringGrid: Col[0]=No, Col[1]=KodeSkala, Col[2]=Nama Pemeriksaan
    KodeSkala := StringGridHasilPemeriksaan.Cells[1, i];

    if Trim(KodeSkala) <> '' then
      DataModuleIgd.SimpanDetailSkala(NoRawat, KodeSkala, SkalaKe);
  end;

  ShowMessage('Data Triase berhasil dikirim ke database.');
end;

procedure TFormPemeriksaanIgd.ButtonSimpanTriaseClick(Sender: TObject);
begin
  /// proses crud
  KirimTriaseLengkap;
end;

procedure TFormPemeriksaanIgd.BitBtn1Click(Sender: TObject);
var
  i, row: Integer;
begin
 row := StringGridHasilPemeriksaan.Row;

  // Pastikan bukan baris header
  if row < 1 then
  begin
    ShowMessage('Pilih baris data yang akan dihapus!');
    Exit;
  end;

  // Pastikan ada data lebih dari header
  if StringGridHasilPemeriksaan.RowCount <= 1 then
  begin
    ShowMessage('Tidak ada data untuk dihapus!');
    Exit;
  end;

  // Konfirmasi
  if MessageDlg('Konfirmasi', 'Hapus data pemeriksaan ini?', mtConfirmation,
    [mbYes, mbNo], 0) = mrNo then
    Exit;

  // Geser baris ke atas untuk menutupi baris yang dihapus
  for i := row to StringGridHasilPemeriksaan.RowCount - 2 do
    StringGridHasilPemeriksaan.Rows[i].Assign(StringGridHasilPemeriksaan.Rows[i + 1]);

  // Kurangi jumlah baris
  StringGridHasilPemeriksaan.RowCount := StringGridHasilPemeriksaan.RowCount - 1;

  // Jika semua baris habis, sisakan header
  if StringGridHasilPemeriksaan.RowCount < 2 then
    StringGridHasilPemeriksaan.RowCount := 2;

  // Set fokus kembali ke baris pertama data
  StringGridHasilPemeriksaan.Row := 1;
end;

procedure TFormPemeriksaanIgd.BitBtnHapusTriaseClick(Sender: TObject);
var
  NoRawat, SkalaKe: string;
begin
  NoRawat := Trim(EditNoRawat.Text);

  if NoRawat = '' then
  begin
    ShowMessage('Nomor rawat belum dipilih!');
    Exit;
  end;

  if MessageDlg('Yakin ingin menghapus semua data triase untuk No. Rawat: ' + NoRawat + '?',
    mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  try
    // --- Hapus Triase Utama ---
    DataModuleIgd.HapusTriaseUtama(NoRawat);

    // --- Hapus Triase Primer / Sekunder sesuai pilihan ---
    if ComboBoxJenisTriase.Text = 'Triase Primer' then
      DataModuleIgd.HapusTriasePrimer(NoRawat)
    else if ComboBoxJenisTriase.Text = 'Triase Sekunder' then
      DataModuleIgd.HapusTriaseSekunder(NoRawat)
    else
      ShowMessage('Jenis triase belum dipilih, hanya menghapus data utama.');

    // --- Hapus Detail Skala ---
    if ComboBoxSkala.ItemIndex <> -1 then
    begin
      // "Skala 3" → "3"
      SkalaKe := Trim(StringReplace(ComboBoxSkala.Text, 'Skala ', '', [rfIgnoreCase]));
      if SkalaKe <> '' then
        DataModuleIgd.HapusDetailSkala(NoRawat, SkalaKe);
    end;

    // --- Bersihkan Tampilan Form ---
    ComboBoxMacamKasus.ItemIndex := -1;
    ComboBoxCaraMasuk.ItemIndex := -1;
    ComboBoxTransportasi.ItemIndex := -1;
    ComboBoxAlasanKedatangan.ItemIndex := -1;
    ComboBoxKebutuhanKhusus.ItemIndex := -1;
    ComboBoxSkala.ItemIndex := -1;
    ComboBoxJenisTriase.ItemIndex := -1;

    EditKeterangan.Clear;
    EditTensi.Clear;
    EditNadi.Clear;
    EditRespirasi.Clear;
    EditSuhu.Clear;
    EditSaturasi.Clear;
    EditNyeri.Clear;

    MemoKeluhanAnamesa.Clear;
    MemoCatatan.Clear;

    // Kosongkan StringGrid
    StringGridHasilPemeriksaan.RowCount := 1;
    StringGridHasilPemeriksaan.Rows[0].Clear;
    StringGridHasilPemeriksaan.Cells[0, 0] := 'No';
    StringGridHasilPemeriksaan.Cells[1, 0] := 'Kode Skala';
    StringGridHasilPemeriksaan.Cells[2, 0] := 'Nama Pemeriksaan';

    ShowMessage('✅ Data triase berhasil dihapus dari database.');

  except
    on E: Exception do
      ShowMessage('⚠️ Gagal menghapus data triase: ' + E.Message);
  end;
end;

procedure TFormPemeriksaanIgd.ButtonInputPemeriksaanClick(Sender: TObject);
var
  rowS, newRow: Integer;
  kodeP, namaP, kodeS, skalaS: string;
begin
  // --- Pastikan Label Pemeriksaan tidak kosong ---
  if Trim(LabelMasterPemeriksaan.Caption) = '' then
  begin
    ShowMessage('Nama Pemeriksaan belum dipilih!');
    Exit;
  end;

  // --- Ambil nama pemeriksaan dari Label ---
  namaP := LabelMasterPemeriksaan.Caption;

  // --- Ambil kode pemeriksaan dari grid master jika perlu ---
  if StringGridMasterPemeriksaan.Row >= 1 then
    kodeP := StringGridMasterPemeriksaan.Cells[0, StringGridMasterPemeriksaan.Row]
  else
    kodeP := '';

  // --- Ambil baris aktif di StringGridSkala ---
  rowS := StringGridSkala.Row;
  if (rowS < 1) or (rowS >= StringGridSkala.RowCount) then
  begin
    ShowMessage('Pilih salah satu skala terlebih dahulu!');
    Exit;
  end;

  // --- Pastikan jumlah kolom cukup ---
  if StringGridHasilPemeriksaan.ColCount < 5 then
    StringGridHasilPemeriksaan.ColCount := 5;

  // --- Ambil data skala ---
  kodeS := StringGridSkala.Cells[0, rowS];
  skalaS := StringGridSkala.Cells[1, rowS];

  // --- Tambahkan ke grid hasil ---
  newRow := StringGridHasilPemeriksaan.RowCount;
  StringGridHasilPemeriksaan.RowCount := newRow + 1;

  with StringGridHasilPemeriksaan do
  begin
    Cells[0, newRow] := IntToStr(newRow); // No
    Cells[1, newRow] := namaP;            // Nama Pemeriksaan dari Label
    Cells[2, newRow] := kodeS;            // Kode Skala
    Cells[3, newRow] := skalaS;           // Skala
  end;

end;

procedure TFormPemeriksaanIgd.ButtonTampilDataTriaseClick(Sender: TObject);
begin
  TampilDataTriase;
end;


/// procedure baru triase
procedure TFormPemeriksaanIgd.baruTriase;
begin
 ComboBoxTransportasi.ItemIndex:=0;
 DateTimePickerKunjungan.Date:= Now;
 ComboBoxCaraMasuk.ItemIndex:= 0;

 ComboBoxAlasanKedatangan.ItemIndex:=0;
 /// panggil procedure
 cbbmaster_triase_macam_kasus;
 ComboBoxMacamKasus.ItemIndex:=0;
 EditKeterangan.Clear;
 MemoKeluhanAnamesa.Clear;

 EditSuhu.Clear; EditTensi.Clear; EditNyeri.Clear; EditNadi.Clear; EditSaturasi.Clear; EditRespirasi.Clear;
 ComboBoxKebutuhanKhusus.ItemIndex:=0;

 //ComboBoxJenisTriase.ItemIndex:=0; ComboBoxSkala.ItemIndex:=0;  ComboBoxPlan.ItemIndex:=0;
 ComboBoxJenisTriase.ItemIndex := 0; // Pilih 'Triase Primer' secara default
 ComboBoxJenisTriaseChange(nil);    // Panggil handler untuk mengisi combobox lain

 MemoCatatan.Clear; DateTimePickerTriase.Date:= Now;
 EditKodePetugas.Clear; EditNamaPetugas.Clear;

 /// panggil procedure

 masterPemeriksaan;

end;

procedure TFormPemeriksaanIgd.cbbmaster_triase_macam_kasus;
begin
 try
    ComboBoxMacamKasus.Items.Clear;

    DataModuleIgd.ZQuerymaster_triase_macam_kasus.SQL.Text := 'SELECT kode_kasus, macam_kasus FROM master_triase_macam_kasus ORDER BY kode_kasus';
    DataModuleIgd.ZQuerymaster_triase_macam_kasus.Open;

    while not DataModuleIgd.ZQuerymaster_triase_macam_kasus.EOF do
    begin
      ComboBoxMacamKasus.Items.Add(DataModuleIgd.ZQuerymaster_triase_macam_kasus.FieldByName('kode_kasus').AsString + ' - ' +
                         DataModuleIgd.ZQuerymaster_triase_macam_kasus.FieldByName('macam_kasus').AsString);
      DataModuleIgd.ZQuerymaster_triase_macam_kasus.Next;
    end;

    DataModuleIgd.ZQuerymaster_triase_macam_kasus.Close;

  except
    on E: Exception do
      ShowMessage('Error: ' + E.Message);
  end;
end;

/// stringrid hasil
procedure TFormPemeriksaanIgd.settingGridHasil;
begin
 // Kolom dan header StringGridHasil
  with StringGridHasilPemeriksaan do
  begin
    RowCount := 1;
    ColCount := 4;
    FixedRows := 1; // header
    Options := Options + [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine];

    Cells[0,0] := 'No';
    Cells[1,0] := 'Nama Pemeriksaan';
    Cells[2,0] := 'Kode Skala';
    Cells[3,0] := 'Skala';

    DefaultRowHeight := 26;
    ColWidths[0] := 40;
    ColWidths[1] := 280;
    ColWidths[2] := 120;
    ColWidths[3] := 400;

    // Style header
    FixedColor := RGBToColor(0, 120, 215);  // biru modern
    Font.Color := clBlack;
    Font.Style := [];
  end;
end;


procedure TFormPemeriksaanIgd.Button2Click(Sender: TObject);
begin

end;

procedure TFormPemeriksaanIgd.ComboBoxJenisTriaseChange(Sender: TObject);
begin
  // Kosongkan dulu semua combobox tujuan
  ComboBoxSkala.Clear;
  ComboBoxPlan.Clear;

  if ComboBoxJenisTriase.Text = 'Triase Primer' then
  begin
    // Tambahkan isi untuk Triase Primer
    ComboBoxSkala.Items.Add('Skala 1');
    ComboBoxSkala.Items.Add('Skala 2');

    ComboBoxPlan.Items.Add('Ruang Resusitasi');
    ComboBoxPlan.Items.Add('Ruang Kritis');
  end
  else if ComboBoxJenisTriase.Text = 'Triase Sekunder' then
  begin
    // Tambahkan isi untuk Triase Sekunder
    ComboBoxSkala.Items.Add('Skala 3');
    ComboBoxSkala.Items.Add('Skala 4');
    ComboBoxSkala.Items.Add('Skala 5');

    ComboBoxPlan.Items.Add('Zona Kuning');
    ComboBoxPlan.Items.Add('Zona Hijau');
  end;
end;

procedure TFormPemeriksaanIgd.ComboBoxSkalaChange(Sender: TObject);
var
  kodePemeriksaan,namaPemeriksaan: string;
begin
  if StringGridMasterPemeriksaan.Row > 0 then
  begin
    kodePemeriksaan := StringGridMasterPemeriksaan.Cells[0, StringGridMasterPemeriksaan.Row];
    namaPemeriksaan := StringGridMasterPemeriksaan.Cells[1, StringGridMasterPemeriksaan.Row];
    // panggil prosedur tampil skala
    TampilSkala(kodePemeriksaan, ComboBoxSkala.Text);
    LabelMasterPemeriksaan.Caption:= namaPemeriksaan;
  end;
end;

procedure TFormPemeriksaanIgd.ComboBoxSkalaClick(Sender: TObject);
begin

end;

procedure TFormPemeriksaanIgd.ComboBoxSkalaSelect(Sender: TObject);
begin
 if ComboBoxSkala.Text = 'Skala 1' then
begin
  LabelMasterPemeriksaan.Font.Color := clWhite;
  GroupBox4.Color := clRed;
end
else if (ComboBoxSkala.Text = 'Skala 2') or (ComboBoxSkala.Text = 'Skala 3') then
begin
  LabelMasterPemeriksaan.Font.Color := clBlack;
  GroupBox4.Color := clYellow;
end
else if (ComboBoxSkala.Text = 'Skala 4') or (ComboBoxSkala.Text = 'Skala 5') then
begin
  LabelMasterPemeriksaan.Font.Color := clBlack;
  GroupBox4.Color := clGreen;
end
else
begin
  LabelMasterPemeriksaan.Font.Color := clWhite;
  GroupBox4.Color := clBtnFace;  // warna default GroupBox
end;

end;

/// tampil master pemeriksaan
procedure TFormPemeriksaanIGD.masterPemeriksaan;
var
  i: Integer;
begin
  with DataModuleIgd.ZQuerymaster_triase_pemeriksaan do
  begin
    Close;
    SQL.Text := 'SELECT * FROM master_triase_pemeriksaan order by nama_pemeriksaan asc';
    Open;
  end;

  // Inisialisasi header kolom StringGrid
  StringGridMasterPemeriksaan.RowCount := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.RecordCount + 1;
  StringGridMasterPemeriksaan.ColCount := 2; // kode + nama
  StringGridMasterPemeriksaan.Cells[0,0] := 'Kode';
  StringGridMasterPemeriksaan.Cells[1,0] := 'Nama Pemeriksaan';
  StringGridMasterPemeriksaan.ColWidths[0] := 50; // kode_pemeriksaan
  StringGridMasterPemeriksaan.ColWidths[1] := 200; // nama_pemeriksaan

  // Tampilkan data ke StringGrid
  i := 1;
  while not DataModuleIgd.ZQuerymaster_triase_pemeriksaan.EOF do
  begin
    StringGridMasterPemeriksaan.Cells[0, i] := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.FieldByName('kode_pemeriksaan').AsString;
    StringGridMasterPemeriksaan.Cells[1, i] := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.FieldByName('nama_pemeriksaan').AsString;
    DataModuleIgd.ZQuerymaster_triase_pemeriksaan.Next;
    Inc(i);
  end;
end;

procedure TFormPemeriksaanIGD.CariDataMaterPemeriksaan(const KataKunci: string);
var
  i: Integer;
begin
  with DataModuleIgd.ZQuerymaster_triase_pemeriksaan do
  begin
    Close;
    SQL.Text := 'SELECT * FROM master_triase_pemeriksaan ' +
                'WHERE kode_pemeriksaan LIKE :kata OR nama_pemeriksaan LIKE :kata';
    ParamByName('kata').AsString := '%' + KataKunci + '%';
    Open;
  end;

  // Inisialisasi header
  StringGridMasterPemeriksaan.RowCount := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.RecordCount + 1;
  StringGridMasterPemeriksaan.ColCount := 2;
  StringGridMasterPemeriksaan.Cells[0,0] := 'Kode Pemeriksaan';
  StringGridMasterPemeriksaan.Cells[1,0] := 'Nama Pemeriksaan';
  StringGridMasterPemeriksaan.ColWidths[0] := 50; // kode_pemeriksaan
  StringGridMasterPemeriksaan.ColWidths[1] := 200; // nama_pemeriksaan

  i := 1;
  while not DataModuleIgd.ZQuerymaster_triase_pemeriksaan.EOF do
  begin
    StringGridMasterPemeriksaan.Cells[0, i] := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.FieldByName('kode_pemeriksaan').AsString;
    StringGridMasterPemeriksaan.Cells[1, i] := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.FieldByName('nama_pemeriksaan').AsString;
    DataModuleIgd.ZQuerymaster_triase_pemeriksaan.Next;
    Inc(i);
  end;
end;

/// tampil data skala
procedure TFormPemeriksaanIGD.TampilSkala(const kodePemeriksaan, skala: string);
var
  i:Integer;
begin
  with StringGridSkala do
  begin
    RowCount := 1; // reset data
    ColCount := 2; // default minimal
    Cells[0,0] := 'Kode';
    Cells[1,0] := 'Pengkajian SKALA';
    ColWidths[0] := 50; // kode_pemeriksaan
    ColWidths[1] := 350; // nama_pemeriksaan
  end;

  if skala = 'Skala 1' then
  begin
    with DataModuleIgd.ZQuerymaster_triase_skala1 do
    begin
      Close;
      SQL.Text := 'SELECT a.kode_skala1, a.pengkajian_skala1, b.kode_pemeriksaan '+
                  'FROM master_triase_skala1 a '+
                  'LEFT JOIN master_triase_pemeriksaan b ON b.kode_pemeriksaan=a.kode_pemeriksaan '+
                  'WHERE a.kode_pemeriksaan=:kode';
      ParamByName('kode').AsString := kodePemeriksaan;
      Open;
    end;

    // isi grid
    StringGridSkala.RowCount := DataModuleIgd.ZQuerymaster_triase_skala1.RecordCount + 1;
    StringGridSkala.ColCount := 2;
    StringGridSkala.Cells[0,0] := 'Kode';
    StringGridSkala.Cells[1,0] := 'Pengkajian SKALA';
    StringGridSkala.ColWidths[0] := 50; // kode_pemeriksaan
    StringGridSkala. ColWidths[1] := 250; // nama_pemeriksaan

    i:=1;
    while not DataModuleIgd.ZQuerymaster_triase_skala1.EOF do
    begin
      StringGridSkala.Cells[0,i] := DataModuleIgd.ZQuerymaster_triase_skala1.FieldByName('kode_skala1').AsString;
      StringGridSkala.Cells[1,i] := DataModuleIgd.ZQuerymaster_triase_skala1.FieldByName('pengkajian_skala1').AsString;
      Inc(i);
      DataModuleIgd.ZQuerymaster_triase_skala1.Next;
    end;
  end
  else if skala = 'Skala 2' then
  begin
    with DataModuleIgd.ZQuerymaster_triase_skala2 do
    begin
      Close;
      SQL.Text := 'SELECT  a.kode_pemeriksaan, a.kode_skala2, '+
                  '        a.pengkajian_skala2, b.nama_pemeriksaan '+
                  'FROM master_triase_skala2 a '+
                  'LEFT JOIN master_triase_pemeriksaan b ON b.kode_pemeriksaan=a.kode_pemeriksaan '+
                  'WHERE a.kode_pemeriksaan=:kode';
      ParamByName('kode').AsString := kodePemeriksaan;
      Open;
    end;

    StringGridSkala.RowCount := DataModuleIgd.ZQuerymaster_triase_skala2.RecordCount + 1;
    StringGridSkala.ColCount := 2;
    StringGridSkala.Cells[0,0] := 'Kode';
    StringGridSkala.Cells[1,0] := 'Pengkajian Skala2';
    StringGridSkala.ColWidths[0] := 50; // kode_pemeriksaan
    StringGridSkala. ColWidths[1] := 250; // nama_pemeriksaan

    i:=1;
    while not DataModuleIgd.ZQuerymaster_triase_skala2.EOF do
    begin
      StringGridSkala.Cells[0,i] := DataModuleIgd.ZQuerymaster_triase_skala2.FieldByName('kode_skala2').AsString;
      StringGridSkala.Cells[1,i] := DataModuleIgd.ZQuerymaster_triase_skala2.FieldByName('pengkajian_skala2').AsString;
      Inc(i);
      DataModuleIgd.ZQuerymaster_triase_skala2.Next;
    end;
  end
  else if skala = 'Skala 3' then
  begin
    with DataModuleIgd.ZQuerymaster_triase_skala3 do
    begin
      Close;
      SQL.Text := 'SELECT a.kode_pemeriksaan, a.kode_skala3, a.pengkajian_skala3, b.nama_pemeriksaan '+
                  'FROM master_triase_skala3 a '+
                  'LEFT JOIN master_triase_pemeriksaan b ON b.kode_pemeriksaan=a.kode_pemeriksaan '+
                  'WHERE a.kode_pemeriksaan=:kode';
      ParamByName('kode').AsString := kodePemeriksaan;
      Open;
    end;

    StringGridSkala.RowCount := DataModuleIgd.ZQuerymaster_triase_skala3.RecordCount + 1;
    StringGridSkala.ColCount := 2;
    StringGridSkala.Cells[0,0] := 'Kode Skala3';
    StringGridSkala.Cells[1,0] := 'Pengkajian Skala3';
    StringGridSkala.ColWidths[0] := 50; // kode_pemeriksaan
    StringGridSkala. ColWidths[1] := 250; // nama_pemeriksaan

    i:=1;
    while not DataModuleIgd.ZQuerymaster_triase_skala3.EOF do
    begin
      StringGridSkala.Cells[0,i] := DataModuleIgd.ZQuerymaster_triase_skala3.FieldByName('kode_skala3').AsString;
      StringGridSkala.Cells[1,i] := DataModuleIgd.ZQuerymaster_triase_skala3.FieldByName('pengkajian_skala3').AsString;
      Inc(i);
      DataModuleIgd.ZQuerymaster_triase_skala3.Next;
    end;
  end
  else if skala = 'Skala 4' then
  begin
    with DataModuleIgd.ZQuerymaster_triase_skala4 do
    begin
      Close;
      SQL.Text := 'SELECT a.kode_pemeriksaan, a.kode_skala4, a.pengkajian_skala4, b.nama_pemeriksaan '+
                  'FROM master_triase_skala4 a '+
                  'LEFT JOIN master_triase_pemeriksaan b ON b.kode_pemeriksaan=a.kode_pemeriksaan '+
                  'WHERE a.kode_pemeriksaan=:kode';
      ParamByName('kode').AsString := kodePemeriksaan;
      Open;
    end;

    StringGridSkala.RowCount := DataModuleIgd.ZQuerymaster_triase_skala4.RecordCount + 1;
    StringGridSkala.ColCount := 2;
    StringGridSkala.Cells[0,0] := 'Kode Skala4';
    StringGridSkala.Cells[1,0] := 'Pengkajian Skala4';
    StringGridSkala.ColWidths[0] := 50; // kode_pemeriksaan
    StringGridSkala. ColWidths[1] := 250; // nama_pemeriksaan

    i:=1;
    while not DataModuleIgd.ZQuerymaster_triase_skala4.EOF do
    begin
      StringGridSkala.Cells[0,i] := DataModuleIgd.ZQuerymaster_triase_skala4.FieldByName('kode_skala4').AsString;
      StringGridSkala.Cells[1,i] := DataModuleIgd.ZQuerymaster_triase_skala4.FieldByName('pengkajian_skala4').AsString;
      Inc(i);
      DataModuleIgd.ZQuerymaster_triase_skala4.Next;
    end;
  end
  else if skala = 'Skala 5' then
  begin
    with DataModuleIgd.ZQuerymaster_triase_skala5 do
    begin
      Close;
      SQL.Text := 'SELECT a.kode_pemeriksaan, a.kode_skala5, a.pengkajian_skala5, b.nama_pemeriksaan '+
                  'FROM master_triase_skala5 a '+
                  'LEFT JOIN master_triase_pemeriksaan b ON b.kode_pemeriksaan=a.kode_pemeriksaan '+
                  'WHERE a.kode_pemeriksaan=:kode';
      ParamByName('kode').AsString := kodePemeriksaan;
      Open;
    end;

    StringGridSkala.RowCount := DataModuleIgd.ZQuerymaster_triase_skala5.RecordCount + 1;
    StringGridSkala.ColCount := 2;
    StringGridSkala.Cells[0,0] := 'Kode Skala5';
    StringGridSkala.Cells[1,0] := 'Pengkajian Skala5';
    StringGridSkala.ColWidths[0] := 50; // kode_pemeriksaan
    StringGridSkala. ColWidths[1] := 250; // nama_pemeriksaan

    i:=1;
    while not DataModuleIgd.ZQuerymaster_triase_skala5.EOF do
    begin
      StringGridSkala.Cells[0,i] := DataModuleIgd.ZQuerymaster_triase_skala5.FieldByName('kode_skala5').AsString;
      StringGridSkala.Cells[1,i] := DataModuleIgd.ZQuerymaster_triase_skala5.FieldByName('pengkajian_skala5').AsString;
      Inc(i);
      DataModuleIgd.ZQuerymaster_triase_skala5.Next;
    end;
  end;
end;


procedure TFormPemeriksaanIgd.FormShow(Sender: TObject);
begin
  /// panggil procedure
 settingGridHasil;
end;

procedure TFormPemeriksaanIgd.StringGridHasilPemeriksaanDrawCell(
  Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin
  with (Sender as TStringGrid) do
  begin
    // Header Row
    if ARow = 0 then
    begin
      Canvas.Brush.Color := RGBToColor(0, 120, 215); // biru
      Canvas.Font.Color := clWhite;
      Canvas.Font.Style := [fsBold];
      Canvas.FillRect(ARect);
      DrawText(Canvas.Handle, PChar(Cells[ACol, ARow]), -1, ARect,
        DT_CENTER or DT_VCENTER or DT_SINGLELINE);
    end
    else
    begin
      // Sel biasa (baris data)
      if gdSelected in aState then
      begin
        Canvas.Brush.Color := RGBToColor(220, 240, 255);
        Canvas.Font.Color := clBlack;
      end
      else
      begin
        Canvas.Brush.Color := clWhite;
        Canvas.Font.Color := clBlack;
      end;

      Canvas.FillRect(ARect);
      DrawText(Canvas.Handle, PChar(Cells[ACol, ARow]), -1, ARect,
        DT_LEFT or DT_VCENTER or DT_SINGLELINE);
    end;
  end;
end;

procedure TFormPemeriksaanIgd.StringGridMasterPemeriksaanClick(Sender: TObject);
var
  kodePemeriksaan,namaPemeriksaan: string;
begin
   if StringGridMasterPemeriksaan.Row > 0 then
  begin
    kodePemeriksaan := StringGridMasterPemeriksaan.Cells[0, StringGridMasterPemeriksaan.Row];
    namaPemeriksaan := StringGridMasterPemeriksaan.Cells[1, StringGridMasterPemeriksaan.Row];
    // panggil prosedur tampil skala
    TampilSkala(kodePemeriksaan, ComboBoxSkala.Text);
    LabelMasterPemeriksaan.Caption:= namaPemeriksaan;
  end;
end;

procedure TFormPemeriksaanIgd.StringGridMasterPemeriksaanDrawCell(
  Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin

end;

procedure TFormPemeriksaanIgd.TabControl1Change(Sender: TObject);
begin

end;

procedure TFormPemeriksaanIgd.TabSheet2Show(Sender: TObject);
begin
  InisialisasiGrid;

  // Tampil data awal
  TampilDataTriase;
end;

/// tampil data triase
procedure TFormPemeriksaanIgd.InisialisasiGrid;
begin
 with StringGridTriaseIgd do
  begin
    // Clear existing data tapi pertahankan struktur
    RowCount := 1; // Hanya header
    ColCount := 10; // Pastikan ada 10 kolom

    // Set header
    Cells[0,0] := 'No. Rawat';
    Cells[1,0] := 'No. RM';
    Cells[2,0] := 'Nama Pasien';
    Cells[3,0] := 'Tgl Kunjungan';
    Cells[4,0] := 'Cara Masuk';
    Cells[5,0] := 'Alat Transport';
    Cells[6,0] := 'Alasan Kedatangan';
    Cells[7,0] := 'Keterangan';
    Cells[8,0] := 'Kode Kasus';
    Cells[9,0] := 'Macam Kasus';

    // Set column widths
    ColWidths[0] := 100;
    ColWidths[1] := 70;
    ColWidths[2] := 150;
    ColWidths[3] := 120;
    ColWidths[4] := 100;
    ColWidths[5] := 100;
    ColWidths[6] := 120;
    ColWidths[7] := 150;
    ColWidths[8] := 80;
    ColWidths[9] := 120;

    FixedRows := 1;
    FixedCols := 0;

    // Pastikan grid dalam keadaan bersih
    BersihkanGridTriase;
  end;
end;

procedure TFormPemeriksaanIgd.BersihkanGridTriase;
var
  i, j: Integer;
begin
  with StringGridTriaseIgd do
  begin
    // Bersihkan semua cell kecuali header
    for i := 1 to RowCount - 1 do
      for j := 0 to ColCount - 1 do
        Cells[j, i] := '';

    // Set ke hanya header
    if RowCount > 1 then
      RowCount := 1;
  end;
end;

procedure TFormPemeriksaanIgd.TampilDataTriase;
var
  i: Integer;
begin
  // Panggil procedure dari DataModule
  DataModuleIgd.CariDataTriaseSemua(
    DateTimePickerMulaiTriase.Date,
    DateTimePickerSampaiTriase.Date + 1, // Tambah 1 hari untuk sampai jam 23:59:59
    Trim(EditCariTriase.Text)
  );

   // Bersihkan grid sebelum isi data baru
    BersihkanGridTriase;

    // Isi data ke grid
    i := 1;
    with DataModuleIgd.ZQueryTriase do
    begin
      if not IsEmpty then
      begin
        First;
        while not Eof do
        begin
          // Pastikan grid punya cukup row
          if StringGridTriaseIgd.RowCount <= i then
            StringGridTriaseIgd.RowCount := StringGridTriaseIgd.RowCount + 1;

          // Isi data dengan pengecekan field
          if FindField('no_rawat') <> nil then
            StringGridTriaseIgd.Cells[0, i] := FieldByName('no_rawat').AsString;

          if FindField('no_rkm_medis') <> nil then
            StringGridTriaseIgd.Cells[1, i] := FieldByName('no_rkm_medis').AsString;

          if FindField('nm_pasien') <> nil then
            StringGridTriaseIgd.Cells[2, i] := FieldByName('nm_pasien').AsString;

          if FindField('tgl_kunjungan') <> nil then
            StringGridTriaseIgd.Cells[3, i] := FormatDateTime('dd/mm/yyyy HH:nn', FieldByName('tgl_kunjungan').AsDateTime);

          if FindField('cara_masuk') <> nil then
            StringGridTriaseIgd.Cells[4, i] := FieldByName('cara_masuk').AsString;

          if FindField('alat_transportasi') <> nil then
            StringGridTriaseIgd.Cells[5, i] := FieldByName('alat_transportasi').AsString;

          if FindField('alasan_kedatangan') <> nil then
            StringGridTriaseIgd.Cells[6, i] := FieldByName('alasan_kedatangan').AsString;

          if FindField('keterangan_kedatangan') <> nil then
            StringGridTriaseIgd.Cells[7, i] := FieldByName('keterangan_kedatangan').AsString;

          if FindField('kode_kasus') <> nil then
            StringGridTriaseIgd.Cells[8, i] := FieldByName('kode_kasus').AsString;

          if FindField('macam_kasus') <> nil then
            StringGridTriaseIgd.Cells[9, i] := FieldByName('macam_kasus').AsString;

          Next;
          Inc(i);
        end;
      end;
    end;

    // Update label jumlah data
    LabelJumlah.Caption := 'Jumlah Data: ' + IntToStr(StringGridTriaseIgd.RowCount - 1);

  except
    on E: Exception do
    begin
      ShowMessage('Error saat menampilkan data: ' + E.Message);
      // Reset grid ke keadaan aman
      InisialisasiGrid;
    end;
  end;

end;



end.

