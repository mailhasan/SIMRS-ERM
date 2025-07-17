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
    procedure DBGrid1CellClick(Column: TColumn);
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
  NamaKamar: string;
begin
  if not DataModuleRanap.ZQueryBangsal.IsEmpty then
  begin
    ///KodeKamar := ZQuery1.FieldByName('kd_bangsal').AsString;
    if DataModuleRanap.ZQueryBangsal.FieldByName('nm_bangsal').AsString = '-' then
       NamaKamar:= ''
    else
       NamaKamar := DataModuleRanap.ZQueryBangsal.FieldByName('nm_bangsal').AsString;
    //ShowMessage('Dipilih: '+ NamaKamar);

    // Kirim ke form Rawat Inap
    if Assigned(FormRawatInap) then
      FormRawatInap.terimaKamar(NamaKamar);

    Close; // Tutup form kamar setelah pilih
  end;
end;

procedure TFormKamar.DBGrid1CellClick(Column: TColumn);
begin

end;

end.

