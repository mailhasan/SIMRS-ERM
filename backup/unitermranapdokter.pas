unit unitERMRanapDokter;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, ComCtrls,
  StdCtrls, Buttons, DBGrids, ActnList, ZDataset, DateTimePicker, uCEFChromium,
  uCEFTypes, uCEFInterfaces, uCEFChromiumEvents, Types;

type

  { TFormERMRanapDokter }

  TFormERMRanapDokter = class(TForm)
    Action1KELUAR: TAction;
    ActionBARU: TAction;
    ActionSIMPAN: TAction;
    ActionCOPY: TAction;
    ActionUBAH: TAction;
    ActionHAPUS: TAction;
    ActionList1: TActionList;
    BitBtnBaru: TBitBtn;
    BitBtnDetailRiwayat: TBitBtn;
    BitBtnSimpan: TBitBtn;
    BitBtnUbah: TBitBtn;
    BitBtnHapus: TBitBtn;
    BitBtnCopy: TBitBtn;
    ComboBox1: TComboBox;
    ComboBox10: TComboBox;
    ComboBox11: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    ComboBoxKeadaanUmum: TComboBox;
    ComboBoxKesadaranAwalMediUmum: TComboBox;
    ComboBoxKesadaran: TComboBox;
    DateTimePickerTglPemeriksaan: TDateTimePicker;
    DateTimePickerJamPemeriksaan: TDateTimePicker;
    DBGrid1: TDBGrid;
    EditAlergi: TEdit;
    EditBerat: TEdit;
    EditBerat1: TEdit;
    EditGcs: TEdit;
    EditGcs1: TEdit;
    EditNadi: TEdit;
    EditNadi1: TEdit;
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
    EditRR1: TEdit;
    EditSp02: TEdit;
    EditSp3: TEdit;
    EditSuhu: TEdit;
    EditSuhu1: TEdit;
    EditTb: TEdit;
    EditTb1: TEdit;
    EditTensi: TEdit;
    EditTensi1: TEdit;
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
    GroupBox23: TGroupBox;
    GroupBox24: TGroupBox;
    GroupBox25: TGroupBox;
    GroupBox26: TGroupBox;
    GroupBox27: TGroupBox;
    GroupBox28: TGroupBox;
    GroupBox29: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox30: TGroupBox;
    GroupBox31: TGroupBox;
    GroupBox32: TGroupBox;
    GroupBox33: TGroupBox;
    GroupBox34: TGroupBox;
    GroupBox35: TGroupBox;
    GroupBox36: TGroupBox;
    GroupBox37: TGroupBox;
    GroupBox38: TGroupBox;
    GroupBox39: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox40: TGroupBox;
    GroupBox41: TGroupBox;
    GroupBox42: TGroupBox;
    GroupBox43: TGroupBox;
    GroupBox44: TGroupBox;
    GroupBox45: TGroupBox;
    GroupBox46: TGroupBox;
    GroupBox47: TGroupBox;
    GroupBox48: TGroupBox;
    GroupBox49: TGroupBox;
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
    MemoRwytAlergi: TMemo;
    MemoRwytPenggunaObat: TMemo;
    MemoRwytPenyakitDahulu: TMemo;
    MemoRwyPenyakitKlrg: TMemo;
    MemoRwytPenykaitSekarang: TMemo;
    MemoKeluhanUtama: TMemo;
    MemoAsesmen: TMemo;
    MemoEvaluasi: TMemo;
    MemoInstruksi: TMemo;
    MemoPlan: TMemo;
    MemoSubjek: TMemo;
    MemoObjek: TMemo;
    PageControl1: TPageControl;
    PageControlAwalMedisUmum: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel13: TPanel;
    Panel14: TPanel;
    Panel15: TPanel;
    Panel16: TPanel;
    Panel17: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    PanelKeluar: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    PanelAtas: TPanel;
    PanelTengah: TPanel;
    TabSheet1: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet11: TTabSheet;
    TabSheet12: TTabSheet;
    TabSheet13: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    procedure Action1KELUARExecute(Sender: TObject);
    procedure ActionBARUExecute(Sender: TObject);
    procedure ActionCOPYExecute(Sender: TObject);
    procedure ActionHAPUSExecute(Sender: TObject);
    procedure ActionSIMPANExecute(Sender: TObject);
    procedure ActionUBAHExecute(Sender: TObject);
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
    procedure DBGrid1CellClick(Column: TColumn);
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
    procedure GroupBox12KeyPress(Sender: TObject; var Key: char);
    procedure GroupBox1Click(Sender: TObject);
    procedure MemoAsesmenKeyPress(Sender: TObject; var Key: char);
    procedure MemoEvaluasiKeyPress(Sender: TObject; var Key: char);
    procedure MemoInstruksiKeyPress(Sender: TObject; var Key: char);
    procedure MemoObjekKeyPress(Sender: TObject; var Key: char);
    procedure MemoPlanKeyPress(Sender: TObject; var Key: char);
    procedure MemoSubjekKeyPress(Sender: TObject; var Key: char);
    procedure PageControlAwalMedisUmumChange(Sender: TObject);
    procedure PanelKeluarClick(Sender: TObject);
    procedure Panel7Click(Sender: TObject);
    procedure TabSheet6ContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
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
uses unitdmrawatinap,DateUtils;

function TFormERMRanapDokter.ValidasiForm: Boolean;
begin
  Result := False;
  if (Trim(MemoSubjek.Text) = '') or (Trim(MemoSubjek.Text) = '') or (Trim(MemoAsesmen.Text) = '') or
     (Trim(MemoPlan.Text) = '') or (Trim(MemoInstruksi.Text) = '') then
  begin
    ShowMessage('Tanda * Harap lengkapi data pemeriksaan terlebih dahulu!');
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

procedure TFormERMRanapDokter.TabSheet6ContextPopup(Sender: TObject;
  MousePos: TPoint; var Handled: Boolean);
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

//// tampil data form
procedure TFormERMRanapDokter.DBGrid1CellClick(Column: TColumn);
var
  pelaksana,nip,jbtn,tgl,jam,subjek,objek,asesmen,plan,intruksi,evaluasi,alergi,kesadaran,suhu,tensi,berat,tb,RR,nadi,sp02,gcs:String;
  dtTanggal, dtJam: TDateTime;
begin
  if not DataModuleRanap.ZQueryPemeriksaanRanap.IsEmpty then
  begin
   pelaksana := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('nama_petugas').AsString;
   nip := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('nip').AsString;
   jbtn := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('jbtn').AsString;
   tgl := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('tgl_perawatan').AsString;
   jam := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('jam_rawat').AsString;
   subjek := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('keluhan').AsString;
   objek := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('pemeriksaan').AsString;
   asesmen := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('penilaian').AsString;
   plan := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('plan').AsString;
   intruksi := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('instruksi').AsString;
   evaluasi := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('evaluasi').AsString;
   alergi := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('nama_petugas').AsString;
   kesadaran := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('kesadaran').AsString;
   suhu := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('suhu_tubuh').AsString;
   tensi := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('tensi').AsString;
   berat := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('berat').AsString;
   tb := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('berat').AsString;
   RR:= DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('respirasi').AsString;
   nadi := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('nadi').AsString;
   sp02 := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('SpO2').AsString;
   gcs := DataModuleRanap.ZQueryPemeriksaanRanap.FieldByName('GCS').AsString;

   dtTanggal:= StrToDate(tgl);
   dtJam:= StrToTime(jam);
   DateTimePickerTglPemeriksaan.Date := dtTanggal;
   DateTimePickerJamPemeriksaan.Time:= dtjam;
   MemoSubjek.Text:= subjek;
   MemoObjek.Text:= objek;
   MemoAsesmen.Text:= asesmen;
   MemoPlan.Text:= plan;
   MemoInstruksi.Text:= intruksi;
   MemoEvaluasi.Text:= evaluasi;
   EditAlergi.Text:= alergi;
   ComboBoxKesadaran.Text:= kesadaran;
   EditSuhu.Text:= suhu;
   EditTensi.Text:= tensi;
   EditBerat.Text:= berat;
   EditTb.Text:= tb;
   EditRR.Text:= RR;
   EditNadi.Text:= nadi;
   EditGcs.Text:= gcs;
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
var
  berat:Double;
begin
   // Hanya izinkan angka, backspace, dan titik desimal
  if not (Key in ['0'..'9', #8, '.', #13]) then
  begin
    Key := #0; // Batalkan input karakter tidak valid
  end;

  // Jika menekan Enter (kode #13)
  if Key = #13 then
  begin
    // Validasi jika ada isi: pastikan tetap angka
    if Trim(EditBerat.Text) <> '' then
    begin
      try
        StrToFloat(EditBerat.Text); // Uji konversi angka
      except
        on E: Exception do
        begin
          ShowMessage('Input berat badan harus berupa angka!');
          EditBerat.SetFocus;
          Exit;
        end;
      end;
    end;

    // Pindah ke field berikutnya
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
var
  suhu:Double;
begin
  if not (Key in ['0'..'9', #8, #13, '.']) then
    Key := #0;

  // Proses setelah tekan Enter
  if Key = #13 then
  begin
    if TryStrToFloat(EditSuhu.Text, suhu) then
    begin
      if (suhu < 30) or (suhu > 45) then
        ShowMessage('Suhu tidak valid! (rentang 30-45 °C)');
    end
    else
      ShowMessage('Masukkan suhu dalam angka, contoh: 36.5');

    EditTensi.SetFocus; // Fokus ke field berikutnya
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
var
  TensiStr: string;
  PosSlash: Integer;
  Sistolik, Diastolik: Integer;
begin
  if Key = #13 then
  begin
    TensiStr := Trim(EditTensi.Text);
    PosSlash := Pos('/', TensiStr);

    // Cek apakah ada karakter "/"
    if PosSlash = 0 then
    begin
      ShowMessage('Format tensi salah. Gunakan format contoh: 120/80');
      EditTensi.SetFocus;
      Exit;
    end;

    try
      // Ambil nilai sebelum dan sesudah slash
      Sistolik := StrToInt(Copy(TensiStr, 1, PosSlash - 1));
      Diastolik := StrToInt(Copy(TensiStr, PosSlash + 1, Length(TensiStr)));

      // Validasi nilai logis
      if (Sistolik < 70) or (Sistolik > 250) then
      begin
        ShowMessage('Nilai sistolik tidak logis. Masukkan antara 70 - 250 mmHg');
        EditTensi.SetFocus;
        Exit;
      end;

      if (Diastolik < 40) or (Diastolik > 150) then
      begin
        ShowMessage('Nilai diastolik tidak logis. Masukkan antara 40 - 150 mmHg');
        EditTensi.SetFocus;
        Exit;
      end;

      // Jika valid, lanjut ke input berikutnya
      EditBerat.SetFocus;

    except
      on E: Exception do
      begin
        ShowMessage('Masukkan tensi dengan angka yang benar, contoh: 120/80');
        EditTensi.SetFocus;
      end;
    end;
  end;
end;

procedure TFormERMRanapDokter.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

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

procedure TFormERMRanapDokter.GroupBox12KeyPress(Sender: TObject; var Key: char
  );
begin

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

procedure TFormERMRanapDokter.PageControlAwalMedisUmumChange(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.BitBtnDetailRiwayatClick(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.BitBtnUbahClick(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.BitBtnHapusClick(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.BitBtnSimpanClick(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.BitBtnBaruClick(Sender: TObject);
begin

end;

procedure TFormERMRanapDokter.ActionBARUExecute(Sender: TObject);
begin
  /// panggil procedure
  baru;
  tampilDataPemeriksaan;
end;

procedure TFormERMRanapDokter.Action1KELUARExecute(Sender: TObject);
begin
  Close;
end;

procedure TFormERMRanapDokter.ActionCOPYExecute(Sender: TObject);
begin
  if not ValidasiForm then Exit;

  DataModuleRanap.InsertPemeriksaanRanap(
    EditNoRawat.Text,
    FormatDateTime('yyyy-MM-dd', Now),
    FormatDateTime('hh:nn:ss', Now),
    EditSuhu.Text, EditTensi.Text, EditNadi.Text, EditRR.Text,
    EditBerat.Text, EditSp02.Text, EditGCS.Text, ComboBoxKesadaran.Text,
    MemoSubjek.Text, MemoObjek.Text, MemoAsesmen.Text,
    MemoPlan.Text, MemoInstruksi.Text, MemoEvaluasi.Text,
    EditNIP.Text
  );

  tampilDataPemeriksaan;
end;

procedure TFormERMRanapDokter.ActionHAPUSExecute(Sender: TObject);
begin
   DataModuleRanap.DeletePemeriksaanRanap(
    EditNoRawat.Text,
    FormatDateTime('yyyy-MM-dd', DateTimePickerTglPemeriksaan.Date),
    FormatDateTime('hh:nn:ss',DateTimePickerJamPemeriksaan.Time)
  );

   tampilDataPemeriksaan;
end;

procedure TFormERMRanapDokter.ActionSIMPANExecute(Sender: TObject);
begin
 if not ValidasiForm then Exit;

  DataModuleRanap.InsertPemeriksaanRanap(
    EditNoRawat.Text,
    FormatDateTime('yyyy-MM-dd', DateTimePickerTglPemeriksaan.Date),
    FormatDateTime('hh:nn:ss', DateTimePickerJamPemeriksaan.Time),
    EditSuhu.Text, EditTensi.Text, EditNadi.Text, EditRR.Text,
    EditBerat.Text, EditSp02.Text, EditGCS.Text, ComboBoxKesadaran.Text,
    MemoSubjek.Text, MemoObjek.Text, MemoAsesmen.Text,
    MemoPlan.Text, MemoInstruksi.Text,MemoEvaluasi.Text,
    EditNIP.Text
  );

  tampilDataPemeriksaan;
end;

procedure TFormERMRanapDokter.ActionUBAHExecute(Sender: TObject);
begin
  if not ValidasiForm then Exit;

  DataModuleRanap.UpdatePemeriksaanRanap(
    EditNoRawat.Text,
    FormatDateTime('yyyy-MM-dd', DateTimePickerTglPemeriksaan.Date),
    FormatDateTime('hh:nn:ss', DateTimePickerJamPemeriksaan.Time),
    EditSuhu.Text, EditTensi.Text, EditNadi.Text, EditRR.Text,
    EditBerat.Text, EditSp02.Text, EditGCS.Text, ComboBoxKesadaran.Text,
    MemoSubjek.Text, MemoObjek.Text, MemoAsesmen.Text,
    MemoPlan.Text, MemoInstruksi.Text,MemoEvaluasi.Text,
    EditNIP.Text
  );

  tampilDataPemeriksaan;
end;

end.

