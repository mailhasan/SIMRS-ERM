unit unitUtama;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, ComCtrls;

type

  { TFormUtama }

  TFormUtama = class(TForm)
    BitBtnRawatInap: TBitBtn;
    BitBtnTombolMenu: TBitBtn;
    PanelKiriAtas: TPanel;
    PanelTengah: TPanel;
    PanelKiri: TPanel;
    PanelAtas: TPanel;
    StatusBar1: TStatusBar;
    procedure BitBtnRawatInapClick(Sender: TObject);
    procedure BitBtnTombolMenuClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
  private
    procedure TampilkanFormDiPanel(AForm: TForm);
    procedure ClearPanel;

  public

  end;

var
  FormUtama: TFormUtama;

implementation

{$R *.lfm}

{ TFormUtama }
uses unitRawatInap;

var
   SidebarVisible: Boolean = True;

procedure TFormUtama.TampilkanFormDiPanel(AForm: TForm);
begin
  ClearPanel;
  AForm.Parent := PanelTengah;
  AForm.Align := alClient;
  AForm.BorderStyle := bsNone;
  AForm.Visible := True;
end;

procedure TFormUtama.ClearPanel;
var
  i: Integer;
begin
  for i := PanelTengah.ControlCount - 1 downto 0 do
    PanelTengah.Controls[i].Free;
end;

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

procedure TFormUtama.BitBtnRawatInapClick(Sender: TObject);
begin
 /// tampil form
  TampilkanFormDiPanel(TFormRawatInap.Create(Self));
end;

end.

