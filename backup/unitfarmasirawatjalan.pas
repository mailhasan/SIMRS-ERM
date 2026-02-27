unit unitFarmasiRawatJalan;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, DBGrids, Menus, DateTimePicker, Grids, RichMemo;

type

  { TFormFarmasiRawatJalan }

  TFormFarmasiRawatJalan = class(TForm)
    BitBtnTampil: TBitBtn;
    cbPemberian: TCheckBox;
    cbPiutang: TCheckBox;
    CheckBoxAll: TCheckBox;
    cbResepDokter: TCheckBox;
    ComboBoxStatus: TComboBox;
    DateTimePickerMulai: TDateTimePicker;
    DateTimePickerSampai: TDateTimePicker;
    DBGridResepPxRajal: TDBGrid;
    EditKeterangan: TEdit;
    EditNoResep: TEdit;
    EditNoRawat: TEdit;
    EditNoRm: TEdit;
    EditNamaPx: TEdit;
    EditPoli: TEdit;
    EditDokter: TEdit;
    EditPencarian: TEdit;
    GroupBox1: TGroupBox;
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
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelAtas1: TPanel;
    PanelKonten: TPanel;
    PanelAtas: TPanel;
    PopupMenu1: TPopupMenu;
    RichMemoResep: TRichMemo;
    procedure BitBtnTampilClick(Sender: TObject);
    procedure cbPemberianClick(Sender: TObject);
    procedure cbPiutangClick(Sender: TObject);
    procedure cbResepDokterClick(Sender: TObject);
    procedure CheckBoxAllClick(Sender: TObject);
    procedure DBGridResepPxRajalCellClick(Column: TColumn);
    procedure DBGridResepPxRajalDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
    procedure FormShow(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
  private

  public
    procedure TampilDataResep;
    procedure tampilAwal;
    procedure TampilResep(noResep: string);
    procedure TampilPemberianObat(noRawat: string);
    procedure TampilSemuaCekbox(noResep, noRawat: string);
  end;

var
  FormFarmasiRawatJalan: TFormFarmasiRawatJalan;

implementation

{$R *.lfm}

{ TFormFarmasiRawatJalan }
uses unitDmFarmasi;

/// resep dokter
procedure TFormFarmasiRawatJalan.TampilResep(noResep: string);
var
  noUrut: integer;
begin
  //RichMemoResep.Clear;
  RichMemoResep.Lines.Add('==================================================');
  RichMemoResep.Lines.Add('                 R E S E P  O B A T DOKTER');
  RichMemoResep.Lines.Add('==================================================');
  RichMemoResep.Lines.Add('');
  RichMemoResep.Lines.Add('No Resep : ' + noResep);
  RichMemoResep.Lines.Add('Tanggal  : ' + FormatDateTime('dd-mm-yyyy', Date));
  RichMemoResep.Lines.Add('--------------------------------------------------');
  RichMemoResep.Lines.Add('');

  {======================}
  { OBAT NON RACIKAN }
  {======================}
  DataModuleFarmasi.ZQueryResepDetail.Close;
  DataModuleFarmasi.ZQueryResepDetail.ParamByName('no_resep').AsString := noResep;
  DataModuleFarmasi.ZQueryResepDetail.Open;

  if not DataModuleFarmasi.ZQueryResepDetail.IsEmpty then
  begin
    RichMemoResep.Lines.Add('OBAT NON RACIKAN');
    RichMemoResep.Lines.Add('--------------------------------------------------');

    noUrut := 1;
    while not DataModuleFarmasi.ZQueryResepDetail.EOF do
    begin
      RichMemoResep.Lines.Add(
        IntToStr(noUrut) + '. ' +
        DataModuleFarmasi.ZQueryResepDetail.FieldByName('nama_brng').AsString
        );
      RichMemoResep.Lines.Add(
        '   Jumlah  : ' + DataModuleFarmasi.ZQueryResepDetail.FieldByName(
        'jml').AsString
        );
      RichMemoResep.Lines.Add(
        '   Aturan  : ' + DataModuleFarmasi.ZQueryResepDetail.FieldByName(
        'aturan_pakai').AsString
        );
      RichMemoResep.Lines.Add('');

      Inc(noUrut);
      DataModuleFarmasi.ZQueryResepDetail.Next;
    end;
  end;

  {======================}
  { RACIKAN }
  {======================}
  DataModuleFarmasi.ZQueryResepRacikan.Close;
  DataModuleFarmasi.ZQueryResepRacikan.ParamByName('no_resep').AsString := noResep;
  DataModuleFarmasi.ZQueryResepRacikan.Open;

  if not DataModuleFarmasi.ZQueryResepRacikan.IsEmpty then
  begin
    RichMemoResep.Lines.Add('');
    RichMemoResep.Lines.Add('RACIKAN');
    RichMemoResep.Lines.Add('--------------------------------------------------');

    while not DataModuleFarmasi.ZQueryResepRacikan.EOF do
    begin
      RichMemoResep.Lines.Add(
        'Racikan : ' + DataModuleFarmasi.ZQueryResepRacikan.FieldByName(
        'nama_racik').AsString
        );

      RichMemoResep.Lines.Add(
        'Metode  : ' + DataModuleFarmasi.ZQueryResepRacikan.FieldByName(
        'nm_racik').AsString
        );

      RichMemoResep.Lines.Add(
        'Jumlah  : ' + DataModuleFarmasi.ZQueryResepRacikan.FieldByName(
        'jml_dr').AsString
        );

      RichMemoResep.Lines.Add('');
      RichMemoResep.Lines.Add('Komposisi :');

      { Detail Racikan }
      DataModuleFarmasi.ZQueryResepRacikanDetail.Close;
      DataModuleFarmasi.ZQueryResepRacikanDetail.ParamByName('no_resep').AsString :=
        noResep;
      DataModuleFarmasi.ZQueryResepRacikanDetail.ParamByName('no_racik').AsString :=
        DataModuleFarmasi.ZQueryResepRacikan.FieldByName('no_racik').AsString;
      DataModuleFarmasi.ZQueryResepRacikanDetail.Open;

      while not DataModuleFarmasi.ZQueryResepRacikanDetail.EOF do
      begin
        RichMemoResep.Lines.Add(
          '   - ' + DataModuleFarmasi.ZQueryResepRacikanDetail.FieldByName(
          'nama_brng').AsString + '   ' +
          DataModuleFarmasi.ZQueryResepRacikanDetail.FieldByName('jml').AsString
          );
        DataModuleFarmasi.ZQueryResepRacikanDetail.Next;
      end;

      RichMemoResep.Lines.Add('');
      RichMemoResep.Lines.Add(
        'Aturan  : ' + DataModuleFarmasi.ZQueryResepRacikan.FieldByName(
        'aturan_pakai').AsString
        );

      RichMemoResep.Lines.Add('');
      RichMemoResep.Lines.Add('--------------------------------------------------');
      RichMemoResep.Lines.Add('');

      DataModuleFarmasi.ZQueryResepRacikan.Next;
    end;
  end;

  RichMemoResep.Lines.Add('');
  RichMemoResep.Lines.Add('==================================================');
end;

/// resep tervalidasi
procedure TFormFarmasiRawatJalan.TampilPemberianObat(noRawat: string);
var
  noUrut: integer;
  totalSemua: double;
  tglJamSebelumnya: string;
begin
  ///RichMemoResep.Clear;

  if Trim(noRawat) = '' then Exit;

  DataModuleFarmasi.ZQueryPemberianObat.Close;
  DataModuleFarmasi.ZQueryPemberianObat.ParamByName('no_rawat').AsString := noRawat;
  DataModuleFarmasi.ZQueryPemberianObat.Open;

  if DataModuleFarmasi.ZQueryPemberianObat.IsEmpty then Exit;

  RichMemoResep.Lines.Add('==================================================');
  RichMemoResep.Lines.Add('            PEMBERIAN OBAT PASIEN');
  RichMemoResep.Lines.Add('==================================================');
  RichMemoResep.Lines.Add('');
  RichMemoResep.Lines.Add('No Rawat : ' + noRawat);
  RichMemoResep.Lines.Add('Status   : ' +
    DataModuleFarmasi.ZQueryPemberianObat.FieldByName('status').AsString);
  RichMemoResep.Lines.Add('--------------------------------------------------');
  RichMemoResep.Lines.Add('');

  noUrut := 1;
  totalSemua := 0;
  tglJamSebelumnya := '';

  while not DataModuleFarmasi.ZQueryPemberianObat.EOF do
  begin
    // tampilkan header tanggal/jam jika berubah
    if tglJamSebelumnya <> DataModuleFarmasi.ZQueryPemberianObat.FieldByName(
      'tgl_perawatan').AsString + DataModuleFarmasi.ZQueryPemberianObat.FieldByName(
      'jam').AsString then
    begin
      RichMemoResep.Lines.Add(
        'Tanggal : ' + FormatDateTime('dd-mm-yyyy',
        DataModuleFarmasi.ZQueryPemberianObat.FieldByName(
        'tgl_perawatan').AsDateTime) +
        '  Jam : ' + DataModuleFarmasi.ZQueryPemberianObat.FieldByName(
        'jam').AsString);
      RichMemoResep.Lines.Add('');
      tglJamSebelumnya :=
        DataModuleFarmasi.ZQueryPemberianObat.FieldByName('tgl_perawatan').AsString +
        DataModuleFarmasi.ZQueryPemberianObat.FieldByName('jam').AsString;
    end;

    RichMemoResep.Lines.Add(
      IntToStr(noUrut) + '. ' + DataModuleFarmasi.ZQueryPemberianObat.FieldByName(
      'nama_brng').AsString);

    RichMemoResep.Lines.Add(
      '   Jumlah  : ' + DataModuleFarmasi.ZQueryPemberianObat.FieldByName('jml').AsString +
      ' ' + DataModuleFarmasi.ZQueryPemberianObat.FieldByName('satuan').AsString);

    RichMemoResep.Lines.Add(
      '   Aturan  : ' + DataModuleFarmasi.ZQueryPemberianObat.FieldByName('aturan').AsString);

    RichMemoResep.Lines.Add(
      '   Total   : Rp ' + FormatFloat('#,##0',
      DataModuleFarmasi.ZQueryPemberianObat.FieldByName('total').AsFloat));

    RichMemoResep.Lines.Add('');

    totalSemua := totalSemua + DataModuleFarmasi.ZQueryPemberianObat.FieldByName('total').AsFloat;

    Inc(noUrut);
    DataModuleFarmasi.ZQueryPemberianObat.Next;
  end;

  RichMemoResep.Lines.Add('--------------------------------------------------');
  RichMemoResep.Lines.Add(
    'TOTAL BIAYA OBAT : Rp ' + FormatFloat('#,##0', totalSemua));
  RichMemoResep.Lines.Add('==================================================');
end;

/// kateregori tampil
procedure TFormFarmasiRawatJalan.TampilSemuaCekbox(noResep, noRawat: string);
begin
  RichMemoResep.Clear;

  if cbResepDokter.Checked then
  begin
    TampilResep(noResep);
    RichMemoResep.Lines.Add('');
    RichMemoResep.Lines.Add('');
  end;

  if cbPemberian.Checked then
  begin
    TampilPemberianObat(noRawat);
    RichMemoResep.Lines.Add('');
    RichMemoResep.Lines.Add('');
  end;

  if cbPiutang.Checked then
  begin
    //TampilPiutang(noRawat); // nanti kita buat
  end;
end;


procedure TFormFarmasiRawatJalan.tampilAwal;
begin
  EditPencarian.Text := '';
  DateTimePickerMulai.Date := Now;
  DateTimePickerSampai.Date := Now;
  ComboBoxStatus.Items.Add('SEMUA');
  ComboBoxStatus.Items.Add('BELUM');
  ComboBoxStatus.Items.Add('SUDAH');
  ComboBoxStatus.ItemIndex := 0;

  /// identitas pasien
  EditNoResep.Clear;
  EditNoRawat.Clear;
  EditNoRm.Clear;
  EditNamaPx.Clear;
  EditPoli.Clear;
  EditDokter.Clear;
  EditKeterangan.Clear;
end;

procedure TFormFarmasiRawatJalan.TampilDataResep;
begin
  with DataModuleFarmasi.ZQueryResepPxRajal do
  begin
    Close;
    SQL.Text := 'SELECT DISTINCT ro.*, ' +
      'r.no_rkm_medis, p.nm_pasien, d.nm_dokter, pl.nm_poli, ' +
      'CASE WHEN ro.tgl_perawatan IS NULL OR ro.tgl_perawatan = ''0000-00-00'' '
      +
      'THEN ''Belum'' ELSE ''Sudah'' END AS status_layanan ' +
      'FROM resep_obat ro ' +
      'LEFT JOIN reg_periksa r ON r.no_rawat = ro.no_rawat ' +
      'LEFT JOIN pasien p ON p.no_rkm_medis = r.no_rkm_medis ' +
      'LEFT JOIN dokter d ON d.kd_dokter = r.kd_dokter ' +
      'LEFT JOIN poliklinik pl ON pl.kd_poli = r.kd_poli ' +
      'LEFT JOIN resep_dokter rd ON rd.no_resep = ro.no_resep ' +
      'LEFT JOIN detail_pemberian_obat dpo ON dpo.no_rawat = ro.no_rawat ' +
      'WHERE ro.status = ''ralan'' ' +
      'AND (ro.no_resep LIKE :cari ' +
      'OR ro.no_rawat LIKE :cari ' +
      'OR r.no_rkm_medis LIKE :cari ' +
      'OR p.nm_pasien LIKE :cari ' +
      'OR d.nm_dokter LIKE :cari) ' +
      'AND (:filter_status = ''SEMUA'' ' +
      'OR (:filter_status = ''BELUM'' AND (ro.tgl_perawatan IS NULL OR ro.tgl_perawatan = ''0000-00-00'')) '
      +
      'OR (:filter_status = ''SUDAH'' AND (ro.tgl_perawatan IS NOT NULL AND ro.tgl_perawatan <> ''0000-00-00''))) '
      +
      'AND ro.tgl_peresepan BETWEEN :tgl1 AND :tgl2 ' +
      'ORDER BY ro.tgl_peresepan DESC, ' +
      'CASE WHEN ro.tgl_perawatan IS NULL OR ro.tgl_perawatan = ''0000-00-00'' THEN 0 ELSE 1 END ASC';

    ParamByName('cari').AsString :=
      '%' + Trim(EditPencarian.Text) + '%';

    ParamByName('filter_status').AsString :=
      ComboBoxStatus.Text;

    ParamByName('tgl1').AsDate :=
      DateTimePickerMulai.Date;

    ParamByName('tgl2').AsDate :=
      DateTimePickerSampai.Date;

    Open;
  end;
end;

procedure TFormFarmasiRawatJalan.Panel3Click(Sender: TObject);
begin
  Close;
end;

procedure TFormFarmasiRawatJalan.BitBtnTampilClick(Sender: TObject);
begin
  TampilDataResep;
end;

procedure TFormFarmasiRawatJalan.cbPemberianClick(Sender: TObject);
begin
  TampilSemuaCekbox(EditNoResep.Text, EditNoRawat.Text);
end;

procedure TFormFarmasiRawatJalan.cbPiutangClick(Sender: TObject);
begin
  TampilSemuaCekbox(EditNoResep.Text, EditNoRawat.Text);
end;

procedure TFormFarmasiRawatJalan.cbResepDokterClick(Sender: TObject);
begin
  TampilSemuaCekbox(EditNoResep.Text, EditNoRawat.Text);
end;

procedure TFormFarmasiRawatJalan.CheckBoxAllClick(Sender: TObject);
begin
  cbResepDokter.Checked:= True;
  cbPemberian.Checked:= true;
  cbPiutang.Checked:=True;
end;

procedure TFormFarmasiRawatJalan.DBGridResepPxRajalCellClick(Column: TColumn);
var
  tglResep, jamResep, jamSerah, statusLayanan: string;
begin
  if DataModuleFarmasi.ZQueryResepPxRajal.IsEmpty then Exit;

  // Isi edit utama
  EditNoResep.Text := DataModuleFarmasi.ZQueryResepPxRajal.FieldByName(
    'no_resep').AsString;
  EditNoRawat.Text := DataModuleFarmasi.ZQueryResepPxRajal.FieldByName(
    'no_rawat').AsString;
  EditNoRm.Text := DataModuleFarmasi.ZQueryResepPxRajal.FieldByName(
    'no_rkm_medis').AsString;
  EditNamaPx.Text := DataModuleFarmasi.ZQueryResepPxRajal.FieldByName(
    'nm_pasien').AsString;
  EditPoli.Text := DataModuleFarmasi.ZQueryResepPxRajal.FieldByName(
    'nm_poli').AsString;
  EditDokter.Text := DataModuleFarmasi.ZQueryResepPxRajal.FieldByName(
    'nm_dokter').AsString;

  // Format Keterangan
  tglResep := FormatDateTime('dd-mm-yyyy',
    DataModuleFarmasi.ZQueryResepPxRajal.FieldByName(
    'tgl_peresepan').AsDateTime);

  jamResep := DataModuleFarmasi.ZQueryResepPxRajal.FieldByName('jam_peresepan').AsString;

  if (DataModuleFarmasi.ZQueryResepPxRajal.FieldByName('tgl_perawatan').IsNull) or
    (DataModuleFarmasi.ZQueryResepPxRajal.FieldByName('tgl_perawatan').AsString =
    '0000-00-00') then
  begin
    jamSerah := '-';
    statusLayanan := 'BELUM DILAYANI';
  end
  else
  begin
    jamSerah := DataModuleFarmasi.ZQueryResepPxRajal.FieldByName('jam').AsString;
    statusLayanan := 'SUDAH DILAYANI';
  end;

  EditKeterangan.Text :=
    'Tgl Resep : ' + tglResep + ' | ' + 'Jam Resep : ' + jamResep +
    ' | ' + 'Jam Serah : ' + jamSerah + ' | ' + 'Status : ' + statusLayanan;

   TampilSemuaCekbox(EditNoResep.Text, EditNoRawat.Text);
   CheckBoxAll.Checked:= True;
end;

procedure TFormFarmasiRawatJalan.DBGridResepPxRajalDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
begin

end;

procedure TFormFarmasiRawatJalan.FormShow(Sender: TObject);
begin
  tampilAwal;
  TampilDataResep;
end;

end.
