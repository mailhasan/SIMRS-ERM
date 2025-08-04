unit unitERMRanapDokter;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Buttons, DBGrids, ZDataset, DateTimePicker, uCEFChromium, uCEFTypes,
  uCEFInterfaces, uCEFChromiumEvents;

type

  { TFormERMRanapDokter }

  TFormERMRanapDokter = class(TForm)
    BitBtnBaru: TBitBtn;
    BitBtnDetailRiwayat: TBitBtn;
    BitBtnSimpan: TBitBtn;
    BitBtnUbah: TBitBtn;
    BitBtnHapus: TBitBtn;
    BitBtnCopy: TBitBtn;
    ComboBoxKesadaran: TComboBox;
    DateTimePickerTglPemeriksaan: TDateTimePicker;
    DateTimePickerJamPemeriksaan: TDateTimePicker;
    DBGrid1: TDBGrid;
    EditAlergi: TEdit;
    EditBerat: TEdit;
    EditGcs: TEdit;
    EditNadi: TEdit;
    EditNIP: TEdit;
    EditJABATAN: TEdit;
    EditPELAKSANAN: TEdit;
    EditDIAGNOSA: TEdit;
    EditRANAP: TEdit;
    EditNoRawat: TEdit;
    EditNORM: TEdit;
    EditNAMA: TEdit;
    EditJENISBAYAR: TEdit;
    EditRR: TEdit;
    EditSp02: TEdit;
    EditSuhu: TEdit;
    EditTb: TEdit;
    EditTensi: TEdit;
    EditTglJamMasuk: TEdit;
    GroupBox1: TGroupBox;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    GroupBox13: TGroupBox;
    GroupBox14: TGroupBox;
    GroupBox15: TGroupBox;
    GroupBox16: TGroupBox;
    GroupBox17: TGroupBox;
    GroupBox18: TGroupBox;
    GroupBox19: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox20: TGroupBox;
    GroupBox21: TGroupBox;
    GroupBox22: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    MemoAsesmen: TMemo;
    MemoEvaluasi: TMemo;
    MemoInstruksi: TMemo;
    MemoPlan: TMemo;
    MemoSubjek: TMemo;
    MemoObjek: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel2: TPanel;
    PanelKeluar: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    PanelAtas: TPanel;
    PanelTengah: TPanel;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    procedure BitBtnBaruClick(Sender: TObject);
    procedure BitBtnDetailRiwayatClick(Sender: TObject);
    procedure BitBtnUbahClick(Sender: TObject);
    procedure BitBtnHapusClick(Sender: TObject);
    procedure BitBtnSimpanClick(Sender: TObject);
    procedure Chromium1AcceleratedPaint(Sender: TObject;
      const browser: ICefBrowser; type_: TCefPaintElementType;
      dirtyRectsCount: NativeUInt; const dirtyRects: PCefRectArray;
      shared_handle: Pointer);
    procedure ComboBoxKesadaranKeyPress(Sender: TObject; var Key: char);
    procedure EditAlergiKeyPress(Sender: TObject; var Key: char);
    procedure EditBeratKeyPress(Sender: TObject; var Key: char);
    procedure EditGcsKeyPress(Sender: TObject; var Key: char);
    procedure EditNadiKeyPress(Sender: TObject; var Key: char);
    procedure EditRRKeyPress(Sender: TObject; var Key: char);
    procedure EditSp02KeyPress(Sender: TObject; var Key: char);
    procedure EditSuhuKeyPress(Sender: TObject; var Key: char);
    procedure EditTbKeyPress(Sender: TObject; var Key: char);
    procedure EditTensiKeyPress(Sender: TObject; var Key: char);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure GroupBox1Click(Sender: TObject);
    procedure MemoAsesmenKeyPress(Sender: TObject; var Key: char);
    procedure MemoEvaluasiKeyPress(Sender: TObject; var Key: char);
    procedure MemoInstruksiKeyPress(Sender: TObject; var Key: char);
    procedure MemoObjekKeyPress(Sender: TObject; var Key: char);
    procedure MemoPlanKeyPress(Sender: TObject; var Key: char);
    procedure MemoSubjekKeyPress(Sender: TObject; var Key: char);
    procedure PanelKeluarClick(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
  private
   function ValidasiForm: Boolean;
  public
   procedure baru;
   procedure tampilDataPemeriksaan;
  end;

var
  FormERMRanapDokter: TFormERMRanapDokter;

implementation

{$R *.lfm}

{ TFormERMRanapDokter }
uses unitdmrawatinap,LCLType;

function TFormERMRanapDokter.ValidasiForm: Boolean;
begin
  Result := False;
  if (Trim(EditNoRawat.Text) = '') or (Trim(EditSuhu.Text) = '') or (Trim(EditTensi.Text) = '') then
  begin
    ShowMessage('Harap lengkapi data pemeriksaan terlebih dahulu!');
    Exit;
  end;
  Result := True;
end;

procedure TFormERMRanapDokter.baru;
begin
  // Clear Edit Fields
  EditAlergi.Clear;
  //EditJABATAN.Clear; EditPELAKSANAN.Clear; EditNIP.Clear;
  EditSuhu.Clear;
  EditTensi.Clear;
  EditBerat.Clear;
  EditTb.Clear;
  EditRR.Clear;
  EditNadi.Clear;
  EditSp02.Clear;
  EditGcs.Clear;
  EditDIAGNOSA.Clear;
  DateTimePickerTglPemeriksaan.Date:= Now; DateTimePickerJamPemeriksaan.Time:=Now;

  {EditRANAP.Clear;
  EditNoRawat.Clear;
  EditNORM.Clear;
  EditNAMA.Clear;
  EditJENISBAYAR.Clear;
  EditTglJamMasuk.Clear;}
  tampilDataPemeriksaan;


  // Clear Memo Fields
  MemoInstruksi.Clear;
  MemoEvaluasi.Clear;
  MemoAsesmen.Clear;
  MemoPlan.Clear;
  MemoSubjek.Clear;
  MemoObjek.Clear;
  ComboBoxKesadaran.ItemIndex:=0;
end;

procedure TFormERMRanapDokter.tampilDataPemeriksaan;
begin
 ///
  DataModuleRanap.LoadPemeriksaanRanap(EditNoRawat.Text, '', 0, 0);
  // Misal DataSource1.DataSet := unit_moduleranap.zquerypemeriksaan;
end;



procedure TFormERMRanapDokter.PanelKeluarClick(Sender: TObject);
begin
  Close;
end;

procedure TFormERMRanapDokter.Panel7Click(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.Chromium1AcceleratedPaint(Sender: TObject;
  const browser: ICefBrowser; type_: TCefPaintElementType;
  dirtyRectsCount: NativeUInt; const dirtyRects: PCefRectArray;
  shared_handle: Pointer);
begin

end;

procedure TFormERMRanapDokter.ComboBoxKesadaranKeyPress(Sender: TObject;
  var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    EditSuhu.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.EditAlergiKeyPress(Sender: TObject; var Key: char
  );
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    ComboBoxKesadaran.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.EditBeratKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    EditTb.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.EditGcsKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    BitBtnSimpan.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.EditNadiKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    EditSp02.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.EditRRKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    EditNadi.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.EditSp02KeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    EditGcs.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.EditSuhuKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    EditTensi.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.EditTbKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    EditRR.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.EditTensiKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    EditBerat.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_ESCAPE:  // ESC keluar
      Close;

    VK_F1:      // F1 baru
      BitBtnBaru.Click;

    VK_F2:      // F2 simpan
      BitBtnSimpan.Click;

    VK_F3:      // F3 copy
      BitBtnCopy.Click;

    VK_F4:      // F4 ubah
      BitBtnUbah.Click;

    VK_F5:      // F5 hapus
      BitBtnHapus.Click;
  end;
end;

procedure TFormERMRanapDokter.FormShow(Sender: TObject);
var
  i: Integer;
begin
  DBGrid1.DataSource := DataModuleRanap.DataSourcePemeriksaanRanap;
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

end;

procedure TFormERMRanapDokter.GroupBox1Click(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.MemoAsesmenKeyPress(Sender: TObject; var Key: char
  );
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    MemoPlan.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.MemoEvaluasiKeyPress(Sender: TObject;
  var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    EditAlergi.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.MemoInstruksiKeyPress(Sender: TObject;
  var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    MemoEvaluasi.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.MemoObjekKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    MemoAsesmen.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.MemoPlanKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    MemoInstruksi.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.MemoSubjekKeyPress(Sender: TObject; var Key: char
  );
begin
if Key = #13 then  // jika Enter ditekan
  begin
    Key := #0;
    MemoObjek.SetFocus;
  end;
end;

procedure TFormERMRanapDokter.BitBtnDetailRiwayatClick(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.BitBtnUbahClick(Sender: TObject);
begin
if not ValidasiForm then Exit;

DataModuleRanap.UpdatePemeriksaanRanap(
    EditNoRawat.Text,
    FormatDateTime('yyyy-MM-dd', DateTimePickerTglPemeriksaan.Date),
    FormatDateTime('hh:nn:ss', DateTimePickerJamPemeriksaan.Time),
    EditSuhu.Text, EditTensi.Text, EditNadi.Text, EditRR.Text,
    EditBerat.Text, EditSp02.Text, EditGCS.Text, ComboBoxKesadaran.Text,
    MemoSubjek.Text, MemoObjek.Text, MemoAsesmen.Text,
    MemoPlan.Text, MemoInstruksi.Text,
    EditNIP.Text
  );

end;

procedure TFormERMRanapDokter.BitBtnHapusClick(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.BitBtnSimpanClick(Sender: TObject);
begin
  if not ValidasiForm then Exit;

  DataModuleRanap.InsertPemeriksaanRanap(
    EditNoRawat.Text,
    FormatDateTime('yyyy-MM-dd', DateTimePickerTglPemeriksaan.Date),
    FormatDateTime('hh:nn:ss', DateTimePickerJamPemeriksaan.Time),
    EditSuhu.Text, EditTensi.Text, EditNadi.Text, EditRR.Text,
    EditBerat.Text, EditSp02.Text, EditGCS.Text, ComboBoxKesadaran.Text,
    MemoSubjek.Text, MemoObjek.Text, MemoAsesmen.Text,
    MemoPlan.Text, MemoInstruksi.Text,
    EditNIP.Text
  );

  tampilDataPemeriksaan;
end;

procedure TFormERMRanapDokter.BitBtnBaruClick(Sender: TObject);
begin
  /// panggil procedure
  baru;
  tampilDataPemeriksaan;
end;

end.

