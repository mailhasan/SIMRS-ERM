unit unitRiwayatPasien;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  HtmlView;

type

  { TFormRiwayatPasien }

  TFormRiwayatPasien = class(TForm)
    EditCari: TEdit;
    HtmlViewer1: THtmlViewer;
    Label1: TLabel;
    PanelAtas: TPanel;
    PanelKonten: TPanel;
  private

  public

  end;

var
  FormRiwayatPasien: TFormRiwayatPasien;

implementation

{$R *.lfm}

end.

