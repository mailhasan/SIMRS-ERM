unit unitPendaftaran;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons;

type

  { TFormPendaftaran }

  TFormPendaftaran = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    PanelKiri: TPanel;
    PanelTengah: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PanelAtas: TPanel;
    procedure BitBtn1Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
  private

  public

  end;

var
  FormPendaftaran: TFormPendaftaran;

implementation

{$R *.lfm}

{ TFormPendaftaran }
uses unitPersetujuanUmum;

procedure TFormPendaftaran.Panel3Click(Sender: TObject);
begin
  Close;
end;

procedure TFormPendaftaran.BitBtn1Click(Sender: TObject);
begin

end;

end.

