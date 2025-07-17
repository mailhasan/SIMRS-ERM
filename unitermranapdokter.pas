unit unitERMRanapDokter;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Buttons, DBGrids, uCEFChromium, uCEFTypes, uCEFInterfaces,
  uCEFChromiumEvents;

type

  { TFormERMRanapDokter }

  TFormERMRanapDokter = class(TForm)
    BitBtnSimpan: TBitBtn;
    BitBtnSimpan1: TBitBtn;
    BitBtnSimpan2: TBitBtn;
    BitBtnBaru: TBitBtn;
    BitBtnDetailRiwayat: TBitBtn;
    ComboBoxKesadaran: TComboBox;
    DBGrid1: TDBGrid;
    EditAlergi: TEdit;
    EditSuhu: TEdit;
    EditTensi: TEdit;
    EditBerat: TEdit;
    EditTb: TEdit;
    EditRR: TEdit;
    EditNadi: TEdit;
    EditSp02: TEdit;
    EditGcs: TEdit;
    EditPELAKSANAN: TEdit;
    EditDIAGNOSA: TEdit;
    EditJABATAN: TEdit;
    EditRANAP: TEdit;
    EditNoRawat: TEdit;
    EditNORM: TEdit;
    EditNAMA: TEdit;
    EditJENISBAYAR: TEdit;
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
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox8: TGroupBox;
    GroupBox9: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
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
    procedure BitBtnDetailRiwayatClick(Sender: TObject);
    procedure Chromium1AcceleratedPaint(Sender: TObject;
      const browser: ICefBrowser; type_: TCefPaintElementType;
      dirtyRectsCount: NativeUInt; const dirtyRects: PCefRectArray;
      shared_handle: Pointer);
    procedure Panel3Click(Sender: TObject);
  private

  public

  end;

var
  FormERMRanapDokter: TFormERMRanapDokter;

implementation

{$R *.lfm}

{ TFormERMRanapDokter }

procedure TFormERMRanapDokter.Panel3Click(Sender: TObject);
begin
  Close;
end;

procedure TFormERMRanapDokter.Chromium1AcceleratedPaint(Sender: TObject;
  const browser: ICefBrowser; type_: TCefPaintElementType;
  dirtyRectsCount: NativeUInt; const dirtyRects: PCefRectArray;
  shared_handle: Pointer);
begin

end;

procedure TFormERMRanapDokter.BitBtnDetailRiwayatClick(Sender: TObject);
begin

end;

end.

