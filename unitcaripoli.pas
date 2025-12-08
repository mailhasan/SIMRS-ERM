unit unitCariPoli;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls;

type

  { TFormCariPoli }

  TFormCariPoli = class(TForm)
    DBGridPoli: TDBGrid;
    EditCari: TEdit;
    procedure DBGridPoliDblClick(Sender: TObject);
    procedure EditCariChange(Sender: TObject);
  private

  public
   procedure CariPoli(AKeyword: string);
  end;

var
  FormCariPoli: TFormCariPoli;

implementation

{$R *.lfm}
uses unitdmrawatjalan,unitRawatJalan;

procedure TFormCariPoli.EditCariChange(Sender: TObject);
begin
  if Trim(EditCari.Text) = '' then Exit;

  CariPoli(EditCari.Text);
end;

procedure TFormCariPoli.DBGridPoliDblClick(Sender: TObject);
begin
  FormRawatJalan.EditPoli.Text :=
    DataModuleRawatJalan.ZQueryPoli.FieldByName('nm_poli').AsString;

  FormRawatJalan.EditKodePoli.Text :=
    DataModuleRawatJalan.ZQueryPoli.FieldByName('kd_poli').AsString;

  Close;
end;

procedure TFormCariPoli.CariPoli(AKeyword: string);
begin
  DataModuleRawatJalan.ZQueryPoli.Close;
  DataModuleRawatJalan.ZQueryPoli.SQL.Clear;
  DataModuleRawatJalan.ZQueryPoli.SQL.Add('SELECT kd_poli, nm_poli');
  DataModuleRawatJalan.ZQueryPoli.SQL.Add('FROM poliklinik');
  DataModuleRawatJalan.ZQueryPoli.SQL.Add('WHERE status = ''1'' ');
  DataModuleRawatJalan.ZQueryPoli.SQL.Add('  AND (kd_poli LIKE :key OR nm_poli LIKE :key)');
  DataModuleRawatJalan.ZQueryPoli.SQL.Add('ORDER BY nm_poli');
  DataModuleRawatJalan.ZQueryPoli.ParamByName('key').AsString := '%' + AKeyword + '%';
  DataModuleRawatJalan.ZQueryPoli.Open;
end;

end.

