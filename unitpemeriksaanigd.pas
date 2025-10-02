unit unitPemeriksaanIGD;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ComCtrls, Grids,DateTimePicker, AnchorDockPanel, Types;

type

  { TFormPemeriksaanIgd }

  TFormPemeriksaanIgd = class(TForm)
    Button1: TButton;
    ComboBoxAlasanKedatangan: TComboBox;
    ComboBoxKebutuhanKhusus: TComboBox;
    ComboBoxMacamKasus: TComboBox;
    ComboBoxJenisTriase: TComboBox;
    ComboBoxSkala: TComboBox;
    ComboBoxPlan: TComboBox;
    ComboBoxCaraMasuk: TComboBox;
    ComboBoxTransportasi: TComboBox;
    DateTimePicker: TDateTimePicker;
    DateTimePickerKunjungan: TDateTimePicker;
    DateTimePickerTriase: TDateTimePicker;
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
    StringGridMasterPemeriksaan: TStringGrid;
    StringGrid2: TStringGrid;
    StringGrid3: TStringGrid;
    TabSheetTriase: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure ButtonTriaseClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBoxJenisTriaseChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGridMasterPemeriksaanDrawCell(Sender: TObject; aCol,
      aRow: Integer; aRect: TRect; aState: TGridDrawState);
    procedure TabControl1Change(Sender: TObject);
  private
   procedure TampilkanFormDiPanel(AForm: TForm);
   procedure ClearPanel;

  public
    procedure baruTriase;
    procedure cbbmaster_triase_macam_kasus;

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

procedure TFormPemeriksaanIgd.Button1Click(Sender: TObject);
begin

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
    ComboBoxSkala.Items.Add('Skala 2');
    ComboBoxSkala.Items.Add('Skala 3');
    ComboBoxSkala.Items.Add('Skala 4');

    ComboBoxPlan.Items.Add('Zona Kuning');
    ComboBoxPlan.Items.Add('Zona Hijau');
  end;
end;

procedure TFormPemeriksaanIgd.FormShow(Sender: TObject);
begin
  /// panggil procedure
end;

procedure TFormPemeriksaanIgd.StringGridMasterPemeriksaanDrawCell(
  Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin

end;

procedure TFormPemeriksaanIgd.TabControl1Change(Sender: TObject);
begin

end;

end.

