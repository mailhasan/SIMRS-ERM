unit unitKamar;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DBGrids;

type

  { TFormKamar }

  TFormKamar = class(TForm)
    DBGrid1: TDBGrid;
    EditCari: TEdit;
    Label1: TLabel;
    PanelAtas: TPanel;
    PanelKonten: TPanel;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure EditCariChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  FormKamar: TFormKamar;

implementation

{$R *.lfm}
uses unitdmrawatinap,unitRawatInap;

{ TFormKamar }

procedure TFormKamar.FormShow(Sender: TObject);
begin
  EditCari.Clear;
  EditCariChange(Sender);
end;

procedure TFormKamar.EditCariChange(Sender: TObject);
begin
 DataModuleRanap.FilterBangsal(EditCari.Text);
end;

procedure TFormKamar.DBGrid1DblClick(Sender: TObject);
var
  kode, nama: string;
begin
  // Pastikan dataset aktif dan tidak kosong
  if not DataModuleRanap.ZQueryBangsal.IsEmpty then
  begin
    ///kode := DataModuleRanap.ZQueryBangsal.FieldByName('kd_bangsal').AsString;
    nama := DataModuleRanap.ZQueryBangsal.FieldByName('nm_bangsal').AsString;

    ///ShowMessage('Kode: ' + kode + sLineBreak + 'Nama: ' + nama);

    // Atau bisa langsung isi ke komponen edit, misal:
    ///EditKode.Text := kode;

    FormRawatInap.EditKamar.Text := nama;
  end;
  Close;
end;

end.

