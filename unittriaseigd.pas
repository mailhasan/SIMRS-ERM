unit unitTriaseIgd;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  DateTimePicker;

type

  { TFormTriaseIgd }

  TFormTriaseIgd = class(TForm)
    ButtonKeluar: TButton;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBoxCaraMasuk: TComboBox;
    ComboBoxTransportasi: TComboBox;
    DateTimePicker1: TDateTimePicker;
    EditNyeri: TEdit;
    EditRespirasi: TEdit;
    EditKeterangan: TEdit;
    EditNadi: TEdit;
    EditSaturasi: TEdit;
    EditSuhu: TEdit;
    EditTensi: TEdit;
    GroupBox1: TGroupBox;
    GroupBox11: TGroupBox;
    GroupBox12: TGroupBox;
    GroupBox13: TGroupBox;
    GroupBox16: TGroupBox;
    GroupBox17: TGroupBox;
    GroupBox18: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    GroupBox5: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PanelTengah: TPanel;
    PanelAtas: TPanel;
    procedure ButtonKeluarClick(Sender: TObject);
  private

  public

  end;

var
  FormTriaseIgd: TFormTriaseIgd;

implementation

{$R *.lfm}

{ TFormTriaseIgd }

procedure TFormTriaseIgd.ButtonKeluarClick(Sender: TObject);
begin
  Close;
end;

end.

