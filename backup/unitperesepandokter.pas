unit unitPeresepanDokter;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBGrids, Buttons, ActnList, DateTimePicker;

type

  { TFormPeresepanDokter }

  TFormPeresepanDokter = class(TForm)
    ActionTambah: TAction;
    ActionInputObat: TAction;
    ActionBaru: TAction;
    ActionSimpan: TAction;
    ActionUbah: TAction;
    ActionHapus: TAction;
    ActionList1: TActionList;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtnBaru1: TBitBtn;
    BitBtnHapus1: TBitBtn;
    BitBtnSimpan1: TBitBtn;
    BitBtnUbah1: TBitBtn;
    ComboBoxKelas: TComboBox;
    ComboBoxPeresep: TComboBox;
    DateTimePickerResep: TDateTimePicker;
    DBGridTransaksi: TDBGrid;
    DBGridPencarian: TDBGrid;
    EditPencarian: TEdit;
    EditAturanPakai: TEdit;
    EditNamaObat: TEdit;
    EditSatuan: TEdit;
    EditKomposisi: TEdit;
    EditHarga: TEdit;
    EditKode: TEdit;
    EditJenisObat: TEdit;
    EditStok: TEdit;
    EditJml: TEdit;
    EditPasienResep: TEdit;
    EditNoResep: TEdit;
    EditKodePeresep: TEdit;
    EditNoRawatResep: TEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    PanelAtas: TPanel;
    PanelKeluar: TPanel;
    SpeedButton1: TSpeedButton;
    procedure PanelKeluarClick(Sender: TObject);
  private

  public
   procedure baru;

  end;

var
  FormPeresepanDokter: TFormPeresepanDokter;

implementation

{$R *.lfm}
uses unitDmFarmasi;


{ TFormPeresepanDokter }
/// tampil baru
procedure TFormPeresepanDokter.baru;
begin
   DateTimePickerResep.DateTime:= Now;
   // Ambil nomor resep otomatis berdasarkan tanggal dari DateTimePicker
  // fNoResep bisa disimpan di variabel global atau langsung ke EditNoResep.Text
   EditNoResep.Text := DataModuleFarmasi.GenerateNoResep(DateTimePickerResep.DateTime);
end;

procedure TFormPeresepanDokter.PanelKeluarClick(Sender: TObject);
begin
  Close;
end;

end.

