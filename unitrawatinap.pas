unit unitRawatInap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  DBGrids, StdCtrls, DBCtrls, Menus, DBDateTimePicker, DateTimePicker;

type

  { TFormRawatInap }

  TFormRawatInap = class(TForm)
    ButtonTampil: TButton;
    ButtonTampil1: TButton;
    ComboBoxStatus: TComboBox;
    ComboBoxKategori: TComboBox;
    DateTimePickerMulai: TDateTimePicker;
    DateTimePickerSelesai: TDateTimePicker;
    DBGridPasienRanap: TDBGrid;
    EditKamar: TEdit;
    EditNama: TEdit;
    EditCari: TEdit;
    EditDokter: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    PanelAtas: TPanel;
    PanelAtas1: TPanel;
    PanelTengah1: TPanel;
    PanelTengah: TPanel;
    PopupMenu1: TPopupMenu;
    SpeedButtonDokter: TSpeedButton;
    SpeedButtonKamar: TSpeedButton;
    procedure BitBtnKeluarClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ButtonFilterClick(Sender: TObject);
    procedure ButtonTampil1Click(Sender: TObject);
    procedure ButtonTampilClick(Sender: TObject);
    procedure EditNamaChange(Sender: TObject);
    procedure EditNoRmChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure SpeedButtonKamarClick(Sender: TObject);
  private

  public
   procedure BaruPencarian;
   procedure TerimaKamar(const NamaKamar: string);
  end;

var
  FormRawatInap: TFormRawatInap;

implementation

{$R *.lfm}

{ TFormRawatInap }
uses unitdmrawatinap,unitKamar,unitERMRanapDokter;

procedure TFormRawatInap.TerimaKamar(const NamaKamar: string);
begin
  //EditKodeKamar.Text := Kode;
  EditKamar.Text := NamaKamar;

  // Fokus ke field lain jika perlu
  //EditDiagnosa.SetFocus;
end;

procedure TFormRawatInap.BaruPencarian;
begin
 DataModuleRanap.CariData('', '', '', '', '-', 0, 0, 0, 0); // Tampilkan pasien belum pulang
 ComboBoxKategori.ItemIndex:= 0; ComboBoxStatus.Text :=''; DateTimePickerMulai.Date:= Now; DateTimePickerSelesai.Date:= Now+1;
 EditCari.Text:= ''; EditNama.Text :=''; EditDokter.Text:=''; EditKamar.Text:='';
end;

procedure TFormRawatInap.BitBtnKeluarClick(Sender: TObject);
begin
  Close;
end;

procedure TFormRawatInap.Button1Click(Sender: TObject);
begin

end;

procedure TFormRawatInap.ButtonFilterClick(Sender: TObject);
begin

end;

procedure TFormRawatInap.ButtonTampil1Click(Sender: TObject);
begin
  /// panggil procedure
  BaruPencarian;
end;

procedure TFormRawatInap.ButtonTampilClick(Sender: TObject);
begin
  {DataModuleRanap.CariData(
    EditNoRM.Text,
    EditNama.Text,
    ComboDokter.Text,
    EditKamar.Text,
    ComboStatus.Text,
    DateMasuk1.Date,
    DateMasuk2.Date,
    DateKeluar1.Date,
    DateKeluar2.Date
  );}

/// tampil data pencarian
  if ComboBoxKategori.ItemIndex =0 then
     begin
        dataModuleRanap.CariData(
        EditCari.Text,
        EditNama.Text,
        EditDokter.Text,
        EditKamar.Text,
        '-',
        0, /// tgl mulai masuk
        0, /// tgl selesai masuk
        0, /// tgl mulai keluar
        0); /// tgl selesai keluar
     end
  else if ComboBoxKategori.ItemIndex =1 then
      begin
        dataModuleRanap.CariData(
        EditCari.Text,
        EditNama.Text,
        EditDokter.Text,
        EditKamar.Text,
        ComboBoxStatus.Text,
        DateTimePickerMulai.Date, /// tgl mulai masuk
        DateTimePickerSelesai.Date, /// tgl selesai masuk
        0, /// tgl mulai keluar
        0); /// tgl selesai keluar
      end
  else
      begin
        dataModuleRanap.CariData(
        EditCari.Text,
        EditNama.Text,
        EditDokter.Text,
        EditKamar.Text,
        ComboBoxStatus.Text,
        0, /// tgl mulai masuk
        0, /// tgl selesai masuk
        DateTimePickerMulai.Date, /// tgl mulai keluar
        DateTimePickerSelesai.Date); /// tgl selesai keluar
      end;
end;

procedure TFormRawatInap.EditNamaChange(Sender: TObject);
begin

end;

procedure TFormRawatInap.EditNoRmChange(Sender: TObject);
begin

end;

procedure TFormRawatInap.FormCreate(Sender: TObject);
begin

end;

procedure TFormRawatInap.FormShow(Sender: TObject);
var
  i: Integer;
begin

 DBGridPasienRanap.DataSource := DataModuleRanap.DsRawatInap;
 // Gaya seperti tabel web modern
  with DBGridPasienRanap do
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
    FixedColor := $00232120;          // Warna header
    GridLineColor := clSilver;

    BorderStyle := bsSingle;
  end;

  // Opsi: Auto-fit kolom
  for i := 0 to DBGridPasienRanap.Columns.Count - 1 do
    DBGridPasienRanap.Columns[i].Width := 120;

  /// panggil procedure
  BaruPencarian;

end;

procedure TFormRawatInap.MenuItem1Click(Sender: TObject);
var
  noRawat : String;
begin
/// tampil form rawat inap
Application.CreateForm(TFormERMRanapDokter, FormERMRanapDokter);
if not DataModuleRanap.ZQRRawatInap.IsEmpty then
    begin
      noRawat := DataModuleRanap.ZQRRawatInap.FieldByName('no_rawat').AsString;
      //ShowMessage('Data dari grid: ' + DataYangDipilih);
    end;
  with FormERMRanapDokter do
  begin
  EditNoRawat.Text:= noRawat;
  ShowModal;
  ///FormERMRanapDokter.ShowModal;
  end;
end;

procedure TFormRawatInap.MenuItem2Click(Sender: TObject);
begin

end;

procedure TFormRawatInap.Panel3Click(Sender: TObject);
begin
  Close;
end;

procedure TFormRawatInap.SpeedButtonKamarClick(Sender: TObject);
begin
  //Application.CreateForm(TFormKamar, FormKamar);
  //FormKamar.ShowModal;
  if not Assigned(FormKamar) then
    FormKamar := TFormKamar.Create(Self);
  FormKamar.ShowModal; // atau Show jika Anda pakai panel

end;

end.

