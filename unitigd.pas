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
    EditCari: TEdit;
    GroupBox1: TGroupBox;
    GroupBoxDaftarDataPasien: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    MemoDataPasien: TMemo;
    MenuItem1: TMenuItem;
    PageControl1: TPageControl;
    Panel1: TPanel;
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
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure PageControlPasienChange(Sender: TObject);
    procedure PanelKeluarClick(Sender: TObject);
  private

  public

  end;

var
  FormIGD: TFormIGD;

implementation

{$R *.lfm}

{ TFormIGD }
uses unitDmIgd;

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

procedure TFormIGD.BitBtnTampilClick(Sender: TObject);
var
  Tgl1, Tgl2: TDate;
begin
   // Ambil nilai dari DateTimePicker
  Tgl1 := DateTimePickerTglDaftar.Date;
  Tgl2 := DateTimePickerTglDaftar.Date;

  // Panggil procedure dengan parameter tanggal
  DataModuleIgd.CariDataPoli(
    EditCari.Text,        // NoRM
    '',        // NamaPasien
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
  i: Integer;
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

  MemoDataPasien.Text:= '';
  DateTimePickerTglDaftar.Date:= Now; EditCari.Text:='';

end;

procedure TFormIGD.MenuItem1Click(Sender: TObject);
var
  NoRawat, NamaPasien,noRM: string;
  i: Integer;
  NewTab: TTabSheet;
  NewMemo: TMemo;
begin
  NoRawat := DataModuleIgd.ZQueryTampilDaftarPxIgd.FieldByName('no_rawat').AsString;
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

  PageControl1.ActivePage := NewTab;
end;

procedure TFormIGD.PageControl1Change(Sender: TObject);
begin

end;

procedure TFormIGD.PageControlPasienChange(Sender: TObject);
begin

end;


end.

