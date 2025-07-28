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
    BitBtnSimpan1: TBitBtn;
    BitBtnSimpan2: TBitBtn;
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
    Label9: TLabel;
    MemoInstruksi: TMemo;
    MemoEvaluasi: TMemo;
    MemoAsesmen: TMemo;
    MemoPlan: TMemo;
    MemoSubjek: TMemo;
    MemoObjek: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
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
    procedure BitBtnSimpan1Click(Sender: TObject);
    procedure BitBtnSimpan2Click(Sender: TObject);
    procedure BitBtnSimpanClick(Sender: TObject);
    procedure Chromium1AcceleratedPaint(Sender: TObject;
      const browser: ICefBrowser; type_: TCefPaintElementType;
      dirtyRectsCount: NativeUInt; const dirtyRects: PCefRectArray;
      shared_handle: Pointer);
    procedure GroupBox1Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
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
uses unitdmrawatinap;

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
  EditJABATAN.Clear;
  EditPELAKSANAN.Clear; EditNIP.Clear;
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



procedure TFormERMRanapDokter.Panel3Click(Sender: TObject);
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

procedure TFormERMRanapDokter.GroupBox1Click(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.BitBtnDetailRiwayatClick(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.BitBtnSimpan1Click(Sender: TObject);
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

procedure TFormERMRanapDokter.BitBtnSimpan2Click(Sender: TObject);
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

  ShowMessage('Data pemeriksaan berhasil disimpan.');
end;

procedure TFormERMRanapDokter.BitBtnBaruClick(Sender: TObject);
begin
  /// panggil procedure
  baru;
end;

end.

