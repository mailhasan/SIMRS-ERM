unit unitFarmasiValidasiResep;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, BufDataset, DB, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, DBGrids;

type

  { TFormValidasiResep }

  TFormValidasiResep = class(TForm)
    BufDataset1: TBufDataset;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    EditKeterangan: TEdit;
    EditNoRawat: TEdit;
    EditNoResep: TEdit;
    Label5: TLabel;
    Label6: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    PanelAtas1: TPanel;
    PanelTengah: TPanel;
    PanelAtas: TPanel;
    procedure FormShow(Sender: TObject);
    procedure PanelTengahClick(Sender: TObject);
  private

  public
   procedure SetupBufDataSetObat;
  end;

var
  FormValidasiResep: TFormValidasiResep;

implementation

{$R *.lfm}

{ TFormValidasiResep }

procedure TFormValidasiResep.SetupBufDataSetObat;
begin
  BufDataset1.Close;
  BufDataset1.FieldDefs.Clear;

  // Menambahkan struktur field
  BufDataset1.FieldDefs.Add('jenis_resep', ftString, 50);
  BufDataset1.FieldDefs.Add('nama_racikan', ftString, 100);
  BufDataset1.FieldDefs.Add('kode_brng', ftString, 20);
  BufDataset1.FieldDefs.Add('nama_brng', ftString, 150);
  BufDataset1.FieldDefs.Add('stok', ftFloat);
  BufDataset1.FieldDefs.Add('harga', ftCurrency);
  BufDataset1.FieldDefs.Add('jumlah', ftFloat);
  BufDataset1.FieldDefs.Add('jml_billing', ftCurrency);
  BufDataset1.FieldDefs.Add('jml_piutang', ftCurrency);
  BufDataset1.FieldDefs.Add('aturan_pakai', ftString, 100);
  BufDataset1.FieldDefs.Add('total', ftCurrency);

  // Membuat dataset di memori
  BufDataset1.CreateDataset;
  BufDataset1.Open;
end;

procedure TFormValidasiResep.PanelTengahClick(Sender: TObject);
begin

end;

procedure TFormValidasiResep.FormShow(Sender: TObject);
begin
  SetupBufDataSetObat;
end;

end.

