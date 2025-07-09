unit unitUtama;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls;

type

  { TFormUtama }

  TFormUtama = class(TForm)
    BitBtnRawatInap: TBitBtn;
    BitBtnTombolMenu: TBitBtn;
    Label1: TLabel;
    PanelKiriAtas: TPanel;
    PanelTengah: TPanel;
    PanelKiri: TPanel;
    PanelAtas: TPanel;
    procedure BitBtnTombolMenuClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private

  public

  end;

var
  FormUtama: TFormUtama;

implementation

{$R *.lfm}

{ TFormUtama }
var
   SidebarVisible: Boolean = True;

procedure TFormUtama.FormActivate(Sender: TObject);
begin
  PanelKiriAtas.Width:=200;
  PanelKiri.Width := 200;     // Saat terbuka
  BitBtnTombolMenu.Caption := '<<';  // Tanda tutup
end;

procedure TFormUtama.BitBtnTombolMenuClick(Sender: TObject);
begin
  if SidebarVisible then
  begin
    PanelKiri.Width := 0;
    BitBtnTombolMenu.Caption := '☰';  // Buka
    SidebarVisible := False;
  end
  else
  begin
    PanelKiri.Width := 200;  // Ukuran normal
    BitBtnTombolMenu.Caption := '<<';  // Tutup
    SidebarVisible := True;
  end;
end;

end.

