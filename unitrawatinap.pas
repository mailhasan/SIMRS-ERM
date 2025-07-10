unit unitRawatInap;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  DBGrids, StdCtrls, DBCtrls, Menus, DBDateTimePicker, DateTimePicker;

type

  { TFormRawatInap }

  TFormRawatInap = class(TForm)
    BitBtnKeluar: TBitBtn;
    ButtonTampil: TButton;
    ButtonTampil1: TButton;
    ComboBoxKategori: TComboBox;
    DateTimePicker1: TDateTimePicker;
    DateTimePickerSelesai: TDateTimePicker;
    DBGridPasienRanap: TDBGrid;
    DBLookupComboBox1: TDBLookupComboBox;
    EditCari: TEdit;
    EditDokter: TEdit;
    EditKamar: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    MenuItem1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
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
    procedure ButtonTampilClick(Sender: TObject);
    procedure EditNamaChange(Sender: TObject);
    procedure EditNoRmChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FormRawatInap: TFormRawatInap;

implementation

{$R *.lfm}

{ TFormRawatInap }
uses unitdmrawatinap;

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

 DataModuleRanap.CariData('', '', '', '', '-', 0, 0, 0, 0); // Tampilkan pasien belum pulang

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
    FixedColor := clSkyBlue;          // Warna header
    GridLineColor := clSilver;

    BorderStyle := bsSingle;
  end;

  // Opsi: Auto-fit kolom
  for i := 0 to DBGridPasienRanap.Columns.Count - 1 do
    DBGridPasienRanap.Columns[i].Width := 120;

end;

end.

