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
    ButtonInputPemeriksaan: TButton;
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
    LabelMasterPemeriksaan: TLabel;
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
    StringGridSkala: TStringGrid;
    StringGridHasilPemeriksaan: TStringGrid;
    TabSheetTriase: TTabSheet;
    TabSheet2: TTabSheet;
    procedure Button1Click(Sender: TObject);
    procedure ButtonTriaseClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure ComboBoxJenisTriaseChange(Sender: TObject);
    procedure ComboBoxSkalaChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGridMasterPemeriksaanClick(Sender: TObject);
    procedure StringGridMasterPemeriksaanDrawCell(Sender: TObject; aCol,
      aRow: Integer; aRect: TRect; aState: TGridDrawState);
    procedure TabControl1Change(Sender: TObject);
  private
   procedure TampilkanFormDiPanel(AForm: TForm);
   procedure ClearPanel;

  public
    procedure baruTriase;
    procedure cbbmaster_triase_macam_kasus;
    procedure masterPemeriksaan;
    procedure CariDataMaterPemeriksaan(const KataKunci: string);
    procedure TampilSkala(const kodePemeriksaan, skala: string);
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

 /// panggil procedure
 masterPemeriksaan;

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
    ComboBoxSkala.Items.Add('Skala 3');
    ComboBoxSkala.Items.Add('Skala 4');
    ComboBoxSkala.Items.Add('Skala 5');

    ComboBoxPlan.Items.Add('Zona Kuning');
    ComboBoxPlan.Items.Add('Zona Hijau');
  end;
end;

procedure TFormPemeriksaanIgd.ComboBoxSkalaChange(Sender: TObject);
var
  kodePemeriksaan,namaPemeriksaan: string;
begin
  if StringGridMasterPemeriksaan.Row > 0 then
  begin
    kodePemeriksaan := StringGridMasterPemeriksaan.Cells[0, StringGridMasterPemeriksaan.Row];
    namaPemeriksaan := StringGridMasterPemeriksaan.Cells[1, StringGridMasterPemeriksaan.Row];
    // panggil prosedur tampil skala
    TampilSkala(kodePemeriksaan, ComboBoxSkala.Text);
    LabelMasterPemeriksaan.Caption:= 'Nama Pemeriksaan '+namaPemeriksaan;
  end;
end;

/// tampil master pemeriksaan
procedure TFormPemeriksaanIGD.masterPemeriksaan;
var
  i: Integer;
begin
  with DataModuleIgd.ZQuerymaster_triase_pemeriksaan do
  begin
    Close;
    SQL.Text := 'SELECT * FROM master_triase_pemeriksaan order by nama_pemeriksaan asc';
    Open;
  end;

  // Inisialisasi header kolom StringGrid
  StringGridMasterPemeriksaan.RowCount := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.RecordCount + 1;
  StringGridMasterPemeriksaan.ColCount := 2; // kode + nama
  StringGridMasterPemeriksaan.Cells[0,0] := 'Kode';
  StringGridMasterPemeriksaan.Cells[1,0] := 'Nama Pemeriksaan';
  StringGridMasterPemeriksaan.ColWidths[0] := 50; // kode_pemeriksaan
  StringGridMasterPemeriksaan.ColWidths[1] := 200; // nama_pemeriksaan

  // Tampilkan data ke StringGrid
  i := 1;
  while not DataModuleIgd.ZQuerymaster_triase_pemeriksaan.EOF do
  begin
    StringGridMasterPemeriksaan.Cells[0, i] := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.FieldByName('kode_pemeriksaan').AsString;
    StringGridMasterPemeriksaan.Cells[1, i] := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.FieldByName('nama_pemeriksaan').AsString;
    DataModuleIgd.ZQuerymaster_triase_pemeriksaan.Next;
    Inc(i);
  end;
end;

procedure TFormPemeriksaanIGD.CariDataMaterPemeriksaan(const KataKunci: string);
var
  i: Integer;
begin
  with DataModuleIgd.ZQuerymaster_triase_pemeriksaan do
  begin
    Close;
    SQL.Text := 'SELECT * FROM master_triase_pemeriksaan ' +
                'WHERE kode_pemeriksaan LIKE :kata OR nama_pemeriksaan LIKE :kata';
    ParamByName('kata').AsString := '%' + KataKunci + '%';
    Open;
  end;

  // Inisialisasi header
  StringGridMasterPemeriksaan.RowCount := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.RecordCount + 1;
  StringGridMasterPemeriksaan.ColCount := 2;
  StringGridMasterPemeriksaan.Cells[0,0] := 'Kode Pemeriksaan';
  StringGridMasterPemeriksaan.Cells[1,0] := 'Nama Pemeriksaan';
  StringGridMasterPemeriksaan.ColWidths[0] := 50; // kode_pemeriksaan
  StringGridMasterPemeriksaan.ColWidths[1] := 200; // nama_pemeriksaan

  i := 1;
  while not DataModuleIgd.ZQuerymaster_triase_pemeriksaan.EOF do
  begin
    StringGridMasterPemeriksaan.Cells[0, i] := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.FieldByName('kode_pemeriksaan').AsString;
    StringGridMasterPemeriksaan.Cells[1, i] := DataModuleIgd.ZQuerymaster_triase_pemeriksaan.FieldByName('nama_pemeriksaan').AsString;
    DataModuleIgd.ZQuerymaster_triase_pemeriksaan.Next;
    Inc(i);
  end;
end;

/// tampil data skala
procedure TFormPemeriksaanIGD.TampilSkala(const kodePemeriksaan, skala: string);
var
  i:Integer;
begin
  with StringGridSkala do
  begin
    RowCount := 1; // reset data
    ColCount := 4; // default minimal
    Cells[0,0] := 'Kode';
    Cells[1,0] := 'Pengkajian SKALA';
    ColWidths[0] := 50; // kode_pemeriksaan
    ColWidths[1] := 200; // nama_pemeriksaan
  end;

  if skala = 'Skala 1' then
  begin
    with DataModuleIgd.ZQuerymaster_triase_skala1 do
    begin
      Close;
      SQL.Text := 'SELECT a.kode_skala1, a.pengkajian_skala1, b.kode_pemeriksaan '+
                  'FROM master_triase_skala1 a '+
                  'LEFT JOIN master_triase_pemeriksaan b ON b.kode_pemeriksaan=a.kode_pemeriksaan '+
                  'WHERE a.kode_pemeriksaan=:kode';
      ParamByName('kode').AsString := kodePemeriksaan;
      Open;
    end;

    // isi grid
    StringGridSkala.RowCount := DataModuleIgd.ZQuerymaster_triase_skala1.RecordCount + 1;
    StringGridSkala.ColCount := 2;
    StringGridSkala.Cells[0,0] := 'Kode';
    StringGridSkala.Cells[1,0] := 'Pengkajian SKALA';
    StringGridSkala.ColWidths[0] := 50; // kode_pemeriksaan
    StringGridSkala. ColWidths[1] := 250; // nama_pemeriksaan

    i:=1;
    while not DataModuleIgd.ZQuerymaster_triase_skala1.EOF do
    begin
      StringGridSkala.Cells[0,i] := DataModuleIgd.ZQuerymaster_triase_skala1.FieldByName('kode_skala1').AsString;
      StringGridSkala.Cells[1,i] := DataModuleIgd.ZQuerymaster_triase_skala1.FieldByName('pengkajian_skala1').AsString;
      Inc(i);
      DataModuleIgd.ZQuerymaster_triase_skala1.Next;
    end;
  end
  else if skala = 'Skala 2' then
  begin
    with DataModuleIgd.ZQuerymaster_triase_skala2 do
    begin
      Close;
      SQL.Text := 'SELECT  a.kode_pemeriksaan, a.kode_skala2, '+
                  '        a.pengkajian_skala2, b.nama_pemeriksaan '+
                  'FROM master_triase_skala2 a '+
                  'LEFT JOIN master_triase_pemeriksaan b ON b.kode_pemeriksaan=a.kode_pemeriksaan '+
                  'WHERE a.kode_pemeriksaan=:kode';
      ParamByName('kode').AsString := kodePemeriksaan;
      Open;
    end;

    StringGridSkala.RowCount := DataModuleIgd.ZQuerymaster_triase_skala2.RecordCount + 1;
    StringGridSkala.ColCount := 2;
    StringGridSkala.Cells[0,0] := 'Kode';
    StringGridSkala.Cells[1,0] := 'Pengkajian Skala2';
    StringGridSkala.ColWidths[0] := 50; // kode_pemeriksaan
    StringGridSkala. ColWidths[1] := 250; // nama_pemeriksaan

    i:=1;
    while not DataModuleIgd.ZQuerymaster_triase_skala2.EOF do
    begin
      StringGridSkala.Cells[0,i] := DataModuleIgd.ZQuerymaster_triase_skala2.FieldByName('kode_skala2').AsString;
      StringGridSkala.Cells[1,i] := DataModuleIgd.ZQuerymaster_triase_skala2.FieldByName('pengkajian_skala2').AsString;
      Inc(i);
      DataModuleIgd.ZQuerymaster_triase_skala2.Next;
    end;
  end
  else if skala = 'Skala 3' then
  begin
    with DataModuleIgd.ZQuerymaster_triase_skala3 do
    begin
      Close;
      SQL.Text := 'SELECT a.kode_pemeriksaan, a.kode_skala3, a.pengkajian_skala3, b.nama_pemeriksaan '+
                  'FROM master_triase_skala3 a '+
                  'LEFT JOIN master_triase_pemeriksaan b ON b.kode_pemeriksaan=a.kode_pemeriksaan '+
                  'WHERE a.kode_pemeriksaan=:kode';
      ParamByName('kode').AsString := kodePemeriksaan;
      Open;
    end;

    StringGridSkala.RowCount := DataModuleIgd.ZQuerymaster_triase_skala3.RecordCount + 1;
    StringGridSkala.ColCount := 2;
    StringGridSkala.Cells[0,0] := 'Kode Skala3';
    StringGridSkala.Cells[1,0] := 'Pengkajian Skala3';
    StringGridSkala.ColWidths[0] := 50; // kode_pemeriksaan
    StringGridSkala. ColWidths[1] := 250; // nama_pemeriksaan

    i:=1;
    while not DataModuleIgd.ZQuerymaster_triase_skala3.EOF do
    begin
      StringGridSkala.Cells[0,i] := DataModuleIgd.ZQuerymaster_triase_skala3.FieldByName('kode_skala3').AsString;
      StringGridSkala.Cells[1,i] := DataModuleIgd.ZQuerymaster_triase_skala3.FieldByName('pengkajian_skala3').AsString;
      Inc(i);
      DataModuleIgd.ZQuerymaster_triase_skala3.Next;
    end;
  end
  else if skala = 'Skala 4' then
  begin
    with DataModuleIgd.ZQuerymaster_triase_skala4 do
    begin
      Close;
      SQL.Text := 'SELECT a.kode_pemeriksaan, a.kode_skala4, a.pengkajian_skala4, b.nama_pemeriksaan '+
                  'FROM master_triase_skala4 a '+
                  'LEFT JOIN master_triase_pemeriksaan b ON b.kode_pemeriksaan=a.kode_pemeriksaan '+
                  'WHERE a.kode_pemeriksaan=:kode';
      ParamByName('kode').AsString := kodePemeriksaan;
      Open;
    end;

    StringGridSkala.RowCount := DataModuleIgd.ZQuerymaster_triase_skala4.RecordCount + 1;
    StringGridSkala.ColCount := 3;
    StringGridSkala.Cells[0,0] := 'Kode Skala4';
    StringGridSkala.Cells[1,0] := 'Pengkajian Skala4';
    StringGridSkala.ColWidths[0] := 50; // kode_pemeriksaan
    StringGridSkala. ColWidths[1] := 250; // nama_pemeriksaan

    i:=1;
    while not DataModuleIgd.ZQuerymaster_triase_skala4.EOF do
    begin
      StringGridSkala.Cells[0,i] := DataModuleIgd.ZQuerymaster_triase_skala4.FieldByName('kode_skala4').AsString;
      StringGridSkala.Cells[1,i] := DataModuleIgd.ZQuerymaster_triase_skala4.FieldByName('pengkajian_skala4').AsString;
      Inc(i);
      DataModuleIgd.ZQuerymaster_triase_skala4.Next;
    end;
  end
  else if skala = 'Skala 5' then
  begin
    with DataModuleIgd.ZQuerymaster_triase_skala5 do
    begin
      Close;
      SQL.Text := 'SELECT a.kode_pemeriksaan, a.kode_skala5, a.pengkajian_skala5, b.nama_pemeriksaan '+
                  'FROM master_triase_skala5 a '+
                  'LEFT JOIN master_triase_pemeriksaan b ON b.kode_pemeriksaan=a.kode_pemeriksaan '+
                  'WHERE a.kode_pemeriksaan=:kode';
      ParamByName('kode').AsString := kodePemeriksaan;
      Open;
    end;

    StringGridSkala.RowCount := DataModuleIgd.ZQuerymaster_triase_skala5.RecordCount + 1;
    StringGridSkala.ColCount := 3;
    StringGridSkala.Cells[0,0] := 'Kode Skala5';
    StringGridSkala.Cells[1,0] := 'Pengkajian Skala5';
    StringGridSkala.ColWidths[0] := 50; // kode_pemeriksaan
    StringGridSkala. ColWidths[1] := 250; // nama_pemeriksaan

    i:=1;
    while not DataModuleIgd.ZQuerymaster_triase_skala5.EOF do
    begin
      StringGridSkala.Cells[0,i] := DataModuleIgd.ZQuerymaster_triase_skala5.FieldByName('kode_skala5').AsString;
      StringGridSkala.Cells[1,i] := DataModuleIgd.ZQuerymaster_triase_skala5.FieldByName('pengkajian_skala5').AsString;
      Inc(i);
      DataModuleIgd.ZQuerymaster_triase_skala5.Next;
    end;
  end;
end;


procedure TFormPemeriksaanIgd.FormShow(Sender: TObject);
begin
  /// panggil procedure
end;

procedure TFormPemeriksaanIgd.StringGridMasterPemeriksaanClick(Sender: TObject);
var
  kodePemeriksaan,namaPemeriksaan: string;
begin
   if StringGridMasterPemeriksaan.Row > 0 then
  begin
    kodePemeriksaan := StringGridMasterPemeriksaan.Cells[0, StringGridMasterPemeriksaan.Row];
    namaPemeriksaan := StringGridMasterPemeriksaan.Cells[1, StringGridMasterPemeriksaan.Row];
    // panggil prosedur tampil skala
    TampilSkala(kodePemeriksaan, ComboBoxSkala.Text);
    LabelMasterPemeriksaan.Caption:= 'Nama Pemeriksaan : '+ namaPemeriksaan;
  end;
end;

procedure TFormPemeriksaanIgd.StringGridMasterPemeriksaanDrawCell(
  Sender: TObject; aCol, aRow: Integer; aRect: TRect; aState: TGridDrawState);
begin

end;

procedure TFormPemeriksaanIgd.TabControl1Change(Sender: TObject);
begin

end;

end.

