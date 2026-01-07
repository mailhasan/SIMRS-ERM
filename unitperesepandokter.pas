unit unitPeresepanDokter;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type

  { TFormPeresepanDokter }

  TFormPeresepanDokter = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PanelAtas: TPanel;
    PanelKeluar: TPanel;
    procedure PanelKeluarClick(Sender: TObject);
  private

  public

  end;

var
  FormPeresepanDokter: TFormPeresepanDokter;

implementation

{$R *.lfm}

{ TFormPeresepanDokter }

procedure TFormPeresepanDokter.PanelKeluarClick(Sender: TObject);
begin
  Close;
end;

end.

