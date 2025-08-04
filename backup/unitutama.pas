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
    ImageList1: TImageList;
    Panel1: TPanel;
    PanelKiriAtas: TPanel;
    PanelTengah: TPanel;
    PanelKiri: TPanel;
    PanelAtas: TPanel;
    StatusBarSIMRSERM: TStatusBar;
    procedure BitBtnRawatInapClick(Sender: TObject);
    procedure BitBtnTombolMenuClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    procedure TampilkanFormDiPanel(AForm: TForm);
    procedure ClearPanel;
    procedure TampilPegawai(const ANik: string);
  public

  end;

var
  FormUtama: TFormUtama;

implementation

{$R *.lfm}

{ TFormUtama }
uses unitRawatInap,unitDmKoneksi,unitLogin;

var
   SidebarVisible: Boolean = True;

   /// procedure buat tampil data pegawai
procedure TFormUtama.TampilPegawai(const ANik: string);
begin
 with DataModuleKoneksi do
 begin
  ZQueryPegawai.Close;
  ZQueryPegawai.SQL.Clear;
  ZQueryPegawai.SQL.Add('SELECT * FROM pegawai WHERE nik = :nik');
  ZQueryPegawai.ParamByName('nik').AsString := ANik;
  ZQueryPegawai.Open;
 end;
 // Jika data ditemukan
  if not DataModuleKoneksi.ZQueryPegawai.IsEmpty then
  begin
    StatusBarSIMRSERM.Panels.Items[1].Text := DataModuleKoneksi.ZQueryPegawai.FieldByName('nik').AsString;
    StatusBarSIMRSERM.Panels.Items[3].Text := DataModuleKoneksi.ZQueryPegawai.FieldByName('nik').AsString;
    StatusBarSIMRSERM.Panels.Items[5].Text := DataModuleKoneksi.ZQueryPegawai.FieldByName('jbtn').AsString;
    // ... tambah edit lain sesuai kolom tabel
  end
  else
  begin
    StatusBarSIMRSERM.Panels.Items[0].Text := '';
    StatusBarSIMRSERM.Panels.Items[1].Text := '';
    StatusBarSIMRSERM.Panels.Items[2].Text := '';
    ShowMessage('Data pegawai tidak ditemukan.');
  end;
end;

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
  begin
    // Jangan Free kalau kontrol yang mau dipakai lagi
    if PanelTengah.Controls[i] <> FormRawatInap then
      PanelTengah.Controls[i].Free;
  end;
end;

procedure TFormUtama.FormActivate(Sender: TObject);
begin
  PanelKiriAtas.Width:=200;
  PanelKiri.Width := 200;     // Saat terbuka
  Panel1.Caption := '<<';  // Tanda tutup
end;

procedure TFormUtama.FormShow(Sender: TObject);
begin
 TampilPegawai(FormLogin.EditUsername.Text);
end;

procedure TFormUtama.Panel1Click(Sender: TObject);
begin
  if SidebarVisible then
  begin
    PanelKiri.Width := 0;
    Panel1.Caption := '☰';  // Buka
    SidebarVisible := False;
  end
  else
  begin
    PanelKiri.Width := 200;  // Ukuran normal
    Panel1.Caption := '<<';  // Tutup
    SidebarVisible := True;
  end;
end;

procedure TFormUtama.BitBtnTombolMenuClick(Sender: TObject);
begin

end;

procedure TFormUtama.BitBtnRawatInapClick(Sender: TObject);
begin
  if not Assigned(FormRawatInap) then
  FormRawatInap := TFormRawatInap.Create(Self);

 /// tampil form
  TampilkanFormDiPanel(FormRawatInap);
end;

end.

