unit unitTtdSoapRehab;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, EditBtn,
  StdCtrls, DBGrids, HtmlView, DateTimePicker, Grids,LCLType, LCLIntf;

type

  { TFormTtdSoapRehab }

  TFormTtdSoapRehab = class(TForm)
    ButtonTampil: TButton;
    ButtonPdf: TButton;
    DateTimePicker1: TDateTimePicker;
    DBGrid1: TDBGrid;
    Panel1: TPanel;
    Panel3: TPanel;
    PanelAtas: TPanel;
    procedure ButtonPdfClick(Sender: TObject);
    procedure ButtonTampilClick(Sender: TObject);
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGrid1DrawColumnTitle(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure Panel3Click(Sender: TObject);
  private

  public

  end;

var
  FormTtdSoapRehab: TFormTtdSoapRehab;

implementation

{$R *.lfm}

{ TFormTtdSoapRehab }

uses unitdmrawatjalan,unitUtama;

{Contoh: panggil berdasarkan tanggal saja : dmRawatJalan.LoadPemeriksaanRalan(Date1.Date, Date2.Date, '', '');}

{Berdasarkan No Rawat saja: dmRawatJalan.LoadPemeriksaanRalan(0, 0, EditNoRawat.Text, '');}

{Berdasarkan No RM: dmRawatJalan.LoadPemeriksaanRalan(0, 0, '', EditNoRM.Text);}

{Kombinasi semua: dmRawatJalan.LoadPemeriksaanRalan(DateAwal.Date, DateAkhir.Date,
                                  EditNoRawat.Text, EditNoRM.Text);}



procedure TFormTtdSoapRehab.ButtonTampilClick(Sender: TObject);
begin
  DataModuleRawatJalan.LoadPemeriksaanRalan(DateTimePicker1.Date, DateTimePicker1.Date, '', '','FISIOTERAPIS','');
end;

procedure TFormTtdSoapRehab.ButtonPdfClick(Sender: TObject);
begin

end;

procedure TFormTtdSoapRehab.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
var
  txt: string;
  R: TRect;
begin
  txt := Column.Field.AsString;
  R := Rect;

  // Warna zebra mirip tabel website
  if gdSelected in State then
    DBGrid1.Canvas.Brush.Color := $00FFE2B3   // warna orange muda
  else if (DBGrid1.DataSource.DataSet.RecNo mod 2 = 0) then
    DBGrid1.Canvas.Brush.Color := $00F8F8F8   // zebra light
  else
    DBGrid1.Canvas.Brush.Color := clWhite;

  DBGrid1.Canvas.FillRect(Rect);

  // Teks elegan
  DBGrid1.Canvas.Font.Color := clBlack;
  DBGrid1.Canvas.Font.Size := 11;

  // DrawText modern dari LCLIntf
  LCLIntf.DrawText(DBGrid1.Canvas.Handle,
    PChar(txt), Length(txt), R,
    DT_LEFT or DT_VCENTER or DT_SINGLELINE);
end;

procedure TFormTtdSoapRehab.DBGrid1DrawColumnTitle(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin

end;

procedure TFormTtdSoapRehab.Panel3Click(Sender: TObject);
begin
  Close;
end;

end.

