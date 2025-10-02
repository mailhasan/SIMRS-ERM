unit unitIGD;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ComCtrls, DBGrids, Menus, HtmlView, uCEFChromium, AnchorDockPanel,
  DateTimePicker, uCEFTypes, uCEFInterfaces;

type

  { TFormIGD }

  TFormIGD = class(TForm)
    BitBtnTampil: TBitBtn;
    Chromium1: TChromium;
    DateTimePickerTglDaftar: TDateTimePicker;
    DBGrid1: TDBGrid;
    EditCariNama: TEdit;
    EditCariNoRm: TEdit;
    GroupBox1: TGroupBox;
    GroupBoxDaftarDataPasien: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    MemoDataPasien: TMemo;
    MenuItem1: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelAtas1: TPanel;
    PanelTengah: TPanel;
    PanelKiri: TPanel;
    PanelAtas: TPanel;
    PanelKeluar: TPanel;
    PopupMenuIgd: TPopupMenu;
    procedure BitBtnTampilClick(Sender: TObject);
    procedure Chromium1AcceleratedPaint(Sender: TObject;
      const browser: ICefBrowser; type_: TCefPaintElementType;
      dirtyRectsCount: NativeUInt; const dirtyRects: PCefRectArray;
      shared_handle: Pointer);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure EditCariNamaClick(Sender: TObject);
    procedure EditCariNoRmClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControlPasienChange(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
    procedure PanelKeluarClick(Sender: TObject);
  private
   procedure CloseTabClick(Sender: TObject);
   procedure TutupSemuaTab;
  public

  end;

var
  FormIGD: TFormIGD;
  SidebarVisible: Boolean = True;

implementation

{$R *.lfm}

{ TFormIGD }
uses unitDmIgd,unitPemeriksaanIGD;

{
NoRM → filter berdasarkan Nomor Rekam Medis pasien.
contoh: '000001' → hanya tampil pasien dengan no RM 000001.

NamaPasien → filter berdasarkan nama pasien (LIKE).
contoh: 'HAFIZ' → akan cari semua pasien yang mengandung kata HAFIZ.

NamaDokter → filter berdasarkan nama dokter.
contoh: 'Sri Rahma'.

KodePoli → filter berdasarkan kode poli (kd_poli di tabel).
contoh: 'U001' untuk poli umum.

StatusDaftar → filter berdasarkan status daftar pasien (Lama / Baru).

TglRegAwal, TglRegAkhir → filter berdasarkan rentang tanggal registrasi.

Jika mau pakai, isi dengan EncodeDate(2025,5,1) sampai EncodeDate(2025,5,31).

Jika tidak mau filter tanggal, cukup isi 0,0 (seperti contoh Anda).
}

/// tutup semua tab
procedure TFormIGD.TutupSemuaTab;
var
  i: Integer;
begin
 // Tutup semua Tab yang ada di PageControl
  for i := PageControl1.PageCount - 1 downto 0 do
    PageControl1.Pages[i].Free;
end;

procedure TFormIGD.PanelKeluarClick(Sender: TObject);
begin
 Close;
end;

procedure TFormIGD.Chromium1AcceleratedPaint(Sender: TObject;
  const browser: ICefBrowser; type_: TCefPaintElementType;
  dirtyRectsCount: NativeUInt; const dirtyRects: PCefRectArray;
  shared_handle: Pointer);
begin

end;

procedure TFormIGD.DBGrid1CellClick(Column: TColumn);
begin
  MemoDataPasien.Lines.Text :=
  Format('No Rawat : %s'#13#10 +
         'Nama Pasien : %s'#13#10 +
         'Dokter : %s'#13#10 +
         'Poli : %s'#13#10 +
         'Tanggal : %s',
  [DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('no_rawat').AsString,
   DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('nm_pasien').AsString,
   DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('nm_dokter').AsString,
   DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('nm_poli').AsString,
   DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('tgl_registrasi').AsString]);
end;

procedure TFormIGD.EditCariNamaClick(Sender: TObject);
begin
  EditCariNoRm.Clear;
end;

procedure TFormIGD.EditCariNoRmClick(Sender: TObject);
begin
  EditCariNama.Clear;
end;

procedure TFormIGD.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin

end;

procedure TFormIGD.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if MessageDlg('Konfirmasi', 'Tutup form ini?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
    CanClose := True;
    TutupSemuaTab;
    end
  else
    CanClose := False;
end;

procedure TFormIGD.FormCreate(Sender: TObject);
var
  iform: Integer;
begin
  {for iForm := PageControl1.PageCount - 1 downto 0 do
  begin
    PageControl1.Pages[iform].PageControl := nil; // Lepas dari PageControl
    PageControl1.Pages[iform].Free;               // Bebaskan memory
  end;}
end;

procedure TFormIGD.BitBtnTampilClick(Sender: TObject);
var
  Tgl1, Tgl2: TDate;
begin
   // Ambil nilai dari DateTimePicker
  Tgl1 := DateTimePickerTglDaftar.Date;
  Tgl2 := DateTimePickerTglDaftar.Date;

  // Panggil procedure dengan parameter tanggal
  DataModuleIgd.CariDataPoli(
    EditCariNoRm.Text,        // NoRM
    EditCariNama.Text,        // NamaPasien
    '',        // NamaDokter
    'IGD',        // KodePoli
    '',        // StatusDaftar
    Tgl1,      // Tanggal Awal
    Tgl2       // Tanggal Akhir
  );

  // contoh: langsung isi DBGrid
  DBGrid1.DataSource := DataModuleIgd.DataSourceTampilDaftarPxIgd;
  GroupBoxDaftarDataPasien.Caption := 'Daftar Data Pasien / Jumlah : ' + IntToStr(DataModuleIgd.ZQueryTampilDaftarPxIgd.RecordCount);
end;

procedure TFormIGD.FormShow(Sender: TObject);
var
  i,iform: Integer;
begin

   DBGrid1.DataSource := DataModuleIgd.DataSourceTampilDaftarPxIgd;
 // Gaya seperti tabel web modern
  with DBGrid1 do
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

  /// bersihkan data
  MemoDataPasien.Text:= '';
  DateTimePickerTglDaftar.Date:= Now; EditCariNoRm.Text:=''; EditCariNama.Text:='';

  /// panggil procedure tombol tampil pencarian
  BitBtnTampilClick(Nil);

  /// tutup semua tab form
  // Hapus semua tab yang ada (dari belakang ke depan agar index tidak kacau)

  for iForm := PageControl1.PageCount - 1 downto 0 do
  begin
    PageControl1.Pages[iform].PageControl := nil; // Lepas dari PageControl
    PageControl1.Pages[iform].Free;               // Bebaskan memory
  end;

end;

/// procedure untuk tutup close on tab
procedure TFormIGD.CloseTabClick(Sender: TObject);
var
  Btn: TButton;
  Tab: TTabSheet;
begin
  if Sender is TButton then
  begin
    Btn := TButton(Sender);
    Tab := TTabSheet(Btn.Parent.Parent);

    if MessageDlg('Konfirmasi', 'Tutup tab ini?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
    begin
      Tab.PageControl := nil;
      Tab.Free;
    end;
  end;
end;

procedure TFormIGD.MenuItem1Click(Sender: TObject);
var
  {NoRawat, NamaPasien,noRM: string;
  i: Integer;
  NewTab: TTabSheet;
  NewMemo: TMemo;}
  NoRawat, NamaPasien, noRM,CleanNoRM: string;
  i,j: Integer;
  NewTab: TTabSheet;
  NewMemo: TMemo;
  CloseButton: TButton;
  TabPanel: TPanel;
  ChildForm: TFormPemeriksaanIgd;

begin
  {NoRawat := DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('no_rawat').AsString;
  NamaPasien := DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('nm_pasien').AsString;
  noRM := DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('no_rkm_medis').AsString;
  // Cek apakah tab dengan pasien ini sudah ada
  for i := 0 to PageControl1.PageCount - 1 do
    if PageControl1.Pages[i].Name = 'Tab_' + noRM then
    begin
      PageControl1.ActivePage := PageControl1.Pages[i];
      Exit; // sudah ada, langsung keluar
    end;

  // Buat tab baru
  NewTab := TTabSheet.Create(PageControl1);
  NewTab.PageControl := PageControl1;
  NewTab.Name := 'Tab_' + noRM; // unik
  NewTab.Caption := NamaPasien;

  // Tambahkan komponen di tab (contoh pakai Memo)
  NewMemo := TMemo.Create(NewTab);
  NewMemo.Parent := NewTab;
  NewMemo.Align := alClient;
  NewMemo.Lines.Add('No Rawat : ' + NoRawat);
  NewMemo.Lines.Add('Nama Pasien : ' + NamaPasien);

  PageControl1.ActivePage := NewTab;}
  NoRawat := DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('no_rawat').AsString;
  NamaPasien := DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('nm_pasien').AsString;
  noRM := DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('no_rkm_medis').AsString;

    // Bersihkan noRM dari karakter yang tidak valid untuk nama komponen
  CleanNoRM := '';
  for j := 1 to Length(noRM) do
  begin
    if noRM[j] in ['A'..'Z', 'a'..'z', '0'..'9', '_'] then
      CleanNoRM := CleanNoRM + noRM[j]
    else
      CleanNoRM := CleanNoRM + '_'; // Ganti karakter invalid dengan underscore
  end;

  // Pastikan nama tidak kosong setelah dibersihkan
  if CleanNoRM = '' then
    CleanNoRM := 'TabEmpty';

  // Cek apakah tab dengan pasien ini sudah ada
  for i := 0 to PageControl1.PageCount - 1 do
  begin
    if PageControl1.Pages[i].Name = 'Tab_' + CleanNoRM then
    begin
      PageControl1.ActivePage := PageControl1.Pages[i];
      Exit; // sudah ada, langsung keluar
    end;
  end;

  // Buat tab baru
  NewTab := TTabSheet.Create(PageControl1);
  NewTab.PageControl := PageControl1;
  NewTab.Name := 'Tab_' + CleanNoRM; // unik
  NewTab.Caption := '   ' + NamaPasien + '   '; // Beri spasi untuk tombol close

  // Buat panel untuk header tab
  TabPanel := TPanel.Create(NewTab);
  TabPanel.Parent := NewTab;
  TabPanel.Align := alTop;
  TabPanel.Height := 30;
  TabPanel.BevelOuter := bvNone;
  TabPanel.Caption := '';

  // Tambahkan label untuk judul
  with TLabel.Create(TabPanel) do
  begin
    Parent := TabPanel;
    Align := alLeft;
    Alignment := taCenter;
    Layout := tlCenter;
    Caption := '  ' + NamaPasien;
    Width := TabPanel.Width - 30;
  end;

  // Tambahkan tombol close
  CloseButton := TButton.Create(TabPanel);
  CloseButton.Parent := TabPanel;
  CloseButton.Align := alRight;
  CloseButton.Width := 25;
  CloseButton.Caption := 'X';
  CloseButton.Hint := 'Tutup tab';
  CloseButton.ShowHint := True;
  CloseButton.Tag := PageControl1.PageCount - 1; // Simpan index tab
  CloseButton.OnClick := @CloseTabClick;

  // Tambahkan komponen di tab (contoh pakai Memo)
  NewMemo := TMemo.Create(NewTab);
  NewMemo.Parent := NewTab;
  NewMemo.Align := alClient;
  NewMemo.Lines.Add('No Rawat : ' + NoRawat);
  NewMemo.Lines.Add('Nama Pasien : ' + NamaPasien);

  // Form pemeriksaan embed ke tab
  ChildForm := TFormPemeriksaanIgd.Create(NewTab);
  ChildForm.Parent := NewTab;
  ChildForm.Align := alClient;
  ChildForm.BorderStyle := bsNone;
  ChildForm.Visible := True;
  //ChildForm.SetPasien(NoRawat, NamaPasien, NoRM);
  ChildForm.EditNoRawat.Text:= NoRawat;
  ChildForm.EditNoRm.Text:= noRM;
  ChildForm.EditNama.Text:= NamaPasien;

  /// panggil procedure
  ChildForm.baruTriase;


  PageControl1.ActivePage := NewTab;
end;

procedure TFormIGD.PageControl1Change(Sender: TObject);
begin

end;

procedure TFormIGD.PageControlPasienChange(Sender: TObject);
begin

end;

procedure TFormIGD.Panel2Click(Sender: TObject);
begin
  if SidebarVisible then
  begin
    PanelKiri.Width := 0;
    Panel1.Caption := '☰';  // Buka
    SidebarVisible := False;
  end
  else
  begin
    PanelKiri.Width := 511;  // Ukuran normal
    Panel1.Caption := '<<';  // Tutup
    SidebarVisible := True;
  end;
end;


end.

