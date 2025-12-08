unit unitRawatJalan;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  StdCtrls, Buttons, DateTimePicker;

type

  { TFormRawatJalan }

  TFormRawatJalan = class(TForm)
    ButtonCari: TButton;
    ComboBoxPeriksa: TComboBox;
    ComboBoxBayar: TComboBox;
    DateTimePickerMulai: TDateTimePicker;
    DateTimePickerSelesai: TDateTimePicker;
    DBGridRawatJalan: TDBGrid;
    EditKodeDokter: TEdit;
    EditKodePoli: TEdit;
    EditNoRawat: TEdit;
    EditNoSep: TEdit;
    EditNoRm: TEdit;
    EditKeterangan: TEdit;
    EditPoli: TEdit;
    EditDokter: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    PanelAtas: TPanel;
    SpeedButtonDokter: TSpeedButton;
    SpeedButtonPoli: TSpeedButton;
    procedure ButtonCariClick(Sender: TObject);
    procedure EditPoliChange(Sender: TObject);
    procedure EditPoliDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure SpeedButtonPoliClick(Sender: TObject);
  private

  public
   procedure baru;
   function GetStatusPeriksa: string;
   function GetStatusBayar: string;
  end;

var
  FormRawatJalan: TFormRawatJalan;

implementation

{$R *.lfm}

{ TFormRawatJalan }
uses unitdmrawatjalan,unitCariPoli;

procedure TFormRawatJalan.baru;
begin
  // === Set tanggal jadi hari ini ===
  DateTimePickerMulai.Date   := Date;
  DateTimePickerSelesai.Date := Date;

  // === Clear ComboBox ===
  ComboBoxPeriksa.ItemIndex := -1;
  ComboBoxBayar.ItemIndex   := -1;

  // === Clear Edit ===
  EditNoRawat.Clear;
  EditNoSep.Clear;
  EditNoRm.Clear;
  EditKeterangan.Clear;
  EditPoli.Clear; EditKodePoli.Clear;
  EditDokter.Clear; EditKodeDokter.Clear;

  // Opsional: clear grid
  // DBGridRawatJalan.DataSource.DataSet.Close;
end;

function TFormRawatJalan.GetStatusPeriksa: string;
begin
  if ComboBoxPeriksa.Text = 'Semua' then
    Result := ''        // kosong = tidak difilter
  else
    Result := ComboBoxPeriksa.Text;
end;

function TFormRawatJalan.GetStatusBayar: string;
begin
  if ComboBoxBayar.Text = 'Semua' then
    Result := ''        // kosong = tidak difilter
  else if ComboBoxBayar.Text = 'Sudah Bayar' then
    Result := 'Yes'
  else if ComboBoxBayar.Text = 'Belum Bayar' then
    Result := 'No'
  else
    Result := '';
end;


procedure TFormRawatJalan.Panel3Click(Sender: TObject);
begin
 Close;
end;

procedure TFormRawatJalan.SpeedButtonPoliClick(Sender: TObject);
begin
  Application.CreateForm(TFormCariPoli, FormCariPoli);
  FormCariPoli.ShowModal;
end;

procedure TFormRawatJalan.FormShow(Sender: TObject);
var
  i:Integer;
begin
  DBGridRawatJalan.DataSource := DataModuleRawatJalan.DataSourceTampilPxRawatJalan;
 // Gaya seperti tabel web modern
  with DBGridRawatJalan do
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

  // Opsi: Auto-fit kolom
  {for i := 0 to DBGridRawatJalan.Columns.Count - 1 do
    DBGridRawatJalan.Columns[i].Width := 120;}
   // panggil procedure
   baru;

     // === STATUS PERIKSA ===
  ComboBoxPeriksa.Items.Clear;
  ComboBoxPeriksa.Items.Add('Semua');
  ComboBoxPeriksa.Items.Add('Belum');
  ComboBoxPeriksa.Items.Add('Sudah');
  ComboBoxPeriksa.Items.Add('Batal');
  ComboBoxPeriksa.Items.Add('Berkas Diterima');
  ComboBoxPeriksa.Items.Add('Dirujuk');
  ComboBoxPeriksa.Items.Add('Meninggal');
  ComboBoxPeriksa.Items.Add('Dirawat');
  ComboBoxPeriksa.Items.Add('Pulang Paksa');
  ComboBoxPeriksa.ItemIndex := 0;  // Default 'Semua'

  // === STATUS BAYAR ===
  ComboBoxBayar.Items.Clear;
  ComboBoxBayar.Items.Add('Semua');
  ComboBoxBayar.Items.Add('Sudah Bayar');
  ComboBoxBayar.Items.Add('Belum Bayar');
  ComboBoxBayar.ItemIndex := 0;  // Default 'Semua'

  // Set tanggal hari ini
  DateTimePickerMulai.Date := Date;
  DateTimePickerSelesai.Date := Date;
end;

procedure TFormRawatJalan.ButtonCariClick(Sender: TObject);
begin
  DataModuleRawatJalan.TampilRawatJalan(
  DateTimePickerMulai.Date,
  DateTimePickerSelesai.Date,
  EditKodePoli.Text,
  EditDokter.Text,
  GetStatusPeriksa,//ComboBoxPeriksa.Text,
  GetStatusBayar,//ComboBoxBayar.Text,
  EditNoRm.Text
);
end;

procedure TFormRawatJalan.EditPoliChange(Sender: TObject);
begin
  // Jika EditPoli kosong ⇒ kosongkan kode poli
  if Trim(EditPoli.Text) = '' then
  begin
    EditKdPoli.Clear;
    Exit;  // hentikan proses pencarian
  end;

  // Jika tidak kosong, lakukan pencarian poli
end;

procedure TFormRawatJalan.EditPoliDblClick(Sender: TObject);
begin

end;

end.

