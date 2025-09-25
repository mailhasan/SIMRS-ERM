unit unitPemeriksaanIGD;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Grids,DateTimePicker, AnchorDockPanel;

type

  { TFormPemeriksaanIgd }

  TFormPemeriksaanIgd = class(TForm)
    Button1: TButton;
    ComboBoxAlasanKedatangan: TComboBox;
    ComboBoxMacamKasus: TComboBox;
    ComboBoxKebutuhanKhusus: TComboBox;
    ComboBoxJenisTriase: TComboBox;
    ComboBoxSkala: TComboBox;
    ComboBoxPlan: TComboBox;
    ComboBoxCaraMasuk: TComboBox;
    ComboBoxTransportasi: TComboBox;
    DateTimePicker: TDateTimePicker;
    DateTimePicker1: TDateTimePicker;
    DateTimePickerTriase: TDateTimePicker;
    Edit1: TEdit;
    Edit2: TEdit;
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
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MemoCatatan: TMemo;
    MemoKeluhanAnamesa: TMemo;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    PanelKonten: TPanel;
    PanelTengah: TPanel;
    PanelAtas: TPanel;
    StringGrid1: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    TabSheetTriase: TTabSheet;
    TabSheet2: TTabSheet;
    procedure ButtonTriaseClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TabControl1Change(Sender: TObject);
  private
   procedure TampilkanFormDiPanel(AForm: TForm);
   procedure ClearPanel;
  public

  end;

var
  FormPemeriksaanIgd: TFormPemeriksaanIgd;

implementation

{$R *.lfm}

{ TFormPemeriksaanIgd }
uses unitTriaseIgd;

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

procedure TFormPemeriksaanIgd.Button2Click(Sender: TObject);
begin

end;

procedure TFormPemeriksaanIgd.TabControl1Change(Sender: TObject);
begin

end;

end.

