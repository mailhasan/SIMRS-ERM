unit unitLogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TFormLogin }

  TFormLogin = class(TForm)
    ButtonLogin: TButton;
    EditPassword: TEdit;
    EditUsername: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PanelBawah: TPanel;
    PanelKonten: TPanel;
    PanelAtas: TPanel;
    procedure ButtonLoginClick(Sender: TObject);
  private

  public

  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.lfm}
uses unitUtama;

{ TFormLogin }

procedure TFormLogin.ButtonLoginClick(Sender: TObject);
begin
  Application.CreateForm(TFormUtama, FormUtama);
  FormUtama.ShowModal;
end;

end.

