unit unitLogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TFormLogin }

  TFormLogin = class(TForm)
    Button1: TButton;
    EditPassword: TEdit;
    EditUsername: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    PanelBawah: TPanel;
    PanelKonten: TPanel;
    PanelAtas: TPanel;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.lfm}
uses unitUtama;

{ TFormLogin }

procedure TFormLogin.Button1Click(Sender: TObject);
begin
  Application.CreateForm
  FormUtama.ShowModal;
end;

end.

