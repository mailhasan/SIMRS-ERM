unit unitLogin;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,Sockets;

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
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  FormLogin: TFormLogin;

implementation

{$R *.lfm}
uses unitUtama, unitDmKoneksi;

{ TFormLogin }


procedure TFormLogin.ButtonLoginClick(Sender: TObject);
begin
  if (EditUsername.Text ='') or (EditPassword.Text='') then
     ShowMessage('Username & Password Harus Di Isi...!')
     else
       begin
        with DataModuleKoneksi.ZQueryUser do
         begin
          SQL.Clear;
          SQL.Clear;
          SQL.Add('SELECT AES_DECRYPT(id_user,"nur") as id_user, AES_DECRYPT(password,"windi") as password FROM user');
          SQL.Add('where id_user = AES_ENCRYPT("'+EditUsername.Text+'","nur") and  password = AES_ENCRYPT("'+EditPassword.Text+'","windi") ');
          //ParamByName('nama').AsString := (NamaBangsal);
          Open;
         end;
         if DataModuleKoneksi.ZQueryUser.RecordCount >= 1 then
            begin
             Application.CreateForm(TFormUtama, FormUtama);
             FormUtama.StatusBarSIMRSERM.Panels.Items[1].Text:= DataModuleKoneksi.ZQueryUser.FieldByName('id_user').AsString;
             FormUtama.StatusBarSIMRSERM.Panels.Items[2].Text:= FormatDateTime('dd-MM-yyyy',Now);
             FormUtama.StatusBarSIMRSERM.Panels[3].Text:= GetLocalIP;
             FormUtama.ShowModal;
            end
         else
             ShowMessage('Login Gagal !');
       end
end;

procedure TFormLogin.FormCreate(Sender: TObject);
begin
  EditUsername.Text:= ''; EditPassword.Text:= '';
end;

end.

