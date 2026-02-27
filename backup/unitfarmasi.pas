unit unitFarmasi;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons;

type

  { TFormFarmasi }

  TFormFarmasi = class(TForm)
    BitBtnRawatJalan: TBitBtn;
    BitBtnGudang: TBitBtn;
    BitBtnIgd: TBitBtn;
    BitBtnRawatInap: TBitBtn;
    procedure BitBtnGudangClick(Sender: TObject);
    procedure BitBtnIgdClick(Sender: TObject);
    procedure BitBtnRawatJalanClick(Sender: TObject);
    procedure BitBtnRawatInapClick(Sender: TObject);
  private

  public

  end;

var
  FormFarmasi: TFormFarmasi;

implementation

{$R *.lfm}

{ TFormFarmasi }
USES unitFarmasiRawatJalan;

procedure TFormFarmasi.BitBtnRawatJalanClick(Sender: TObject);
begin
  /// FARMASI RAWAT JALAN
   Application.CreateForm(TFormFarmasiRawatJalan, FormFarmasiRawatJalan);
  FormFarmasiRawatJalan.ShowModal;
end;

procedure TFormFarmasi.BitBtnIgdClick(Sender: TObject);
begin
    ShowMessage('Proses Pengembangan');
end;

procedure TFormFarmasi.BitBtnGudangClick(Sender: TObject);
begin
    ShowMessage('Proses Pengembangan');
end;

procedure TFormFarmasi.BitBtnRawatInapClick(Sender: TObject);
begin
  ShowMessage('Proses Pengembangan');
end;

end.

