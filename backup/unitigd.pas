unit unitIGD;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, HtmlView, uCEFChromium, AnchorDockPanel, DateTimePicker, uCEFTypes,
  uCEFInterfaces, uCEFChromiumEvents, uCEFChromiumWindow;

type

  { TFormIGD }

  TFormIGD = class(TForm)
    BitBtnTampil: TBitBtn;
    Chromium1: TChromium;
    DateTimePicker1: TDateTimePicker;
    EditCari: TEdit;
    GroupBox1: TGroupBox;
    HtmlViewer1: THtmlViewer;
    Label1: TLabel;
    Label2: TLabel;
    Panel1: TPanel;
    PanelAtas1: TPanel;
    PanelTengah: TPanel;
    PanelKiri: TPanel;
    PanelAtas: TPanel;
    PanelKeluar: TPanel;
    procedure BitBtnTampilClick(Sender: TObject);
    procedure Chromium1AcceleratedPaint(Sender: TObject;
      const browser: ICefBrowser; type_: TCefPaintElementType;
      dirtyRectsCount: NativeUInt; const dirtyRects: PCefRectArray;
      shared_handle: Pointer);
    procedure FormShow(Sender: TObject);
    procedure PanelKeluarClick(Sender: TObject);
  private

  public

  end;

var
  FormIGD: TFormIGD;

implementation

{$R *.lfm}

{ TFormIGD }
uses unitDmIgd;

procedure TFormIGD.PanelKeluarClick(Sender: TObject);
begin
  Close;
end;

procedure TFormIGD.Chromium1AcceleratedPaint(Sender: TObject;
  const browser: ICefBrowser; type_: TCefPaintElementType;
  dirtyRectsCount: NativeUInt; const dirtyRects: PCefRectArray;
  shared_handle: Pointer);
begin

end;

procedure TFormIGD.BitBtnTampilClick(Sender: TObject);
var
  S, CardHTML, StatusTag: string;;
begin
  // panggil query sesuai filter
  DataModuleIgd.CariDataPoli('', '', '', '', '', 0, 0);

  // header HTML
  S :=
    '<html>' +
    '<head>' +
    '<style>' +
    'body { font-family: Arial, sans-serif; background: #f5f5f5; margin: 0; padding: 10px; }' +
    'h2 { text-align: center; color: #333; }' +
    '.card { background: #fff; border-radius: 12px; box-shadow: 0 2px 6px rgba(0,0,0,0.15); margin-bottom: 12px; padding: 15px; transition: 0.2s; }' +
    '.card:hover { transform: scale(1.02); box-shadow: 0 4px 10px rgba(0,0,0,0.2); }' +
    '.card .nama { font-size: 18px; font-weight: bold; color: #0077b6; margin-bottom: 5px; }' +
    '.card .info { font-size: 14px; color: #555; margin-bottom: 3px; }' +
    '.tag { display: inline-block; background: #00b4d8; color: white; font-size: 12px; padding: 3px 8px; border-radius: 8px; margin-top: 6px; }' +
    '</style>' +
    '</head>' +
    '<body>' +
    '<h2>Daftar Pasien</h2>';

  with DataModuleIgd.ZQueryTampilDaftarPxIgd do
  begin
    First;
    while not EOF do
    begin
      // pilih warna tag berdasarkan status
      if FieldByName('status_poli').AsString = 'Belum' then
        StatusTag := '<span class="tag">Belum Dilayani</span>'
      else if FieldByName('status_poli').AsString = 'Sudah' then
        StatusTag := '<span class="tag" style="background:#ff6b6b;">Selesai</span>'
      else
        StatusTag := '<span class="tag" style="background:#6c757d;">' +
                     FieldByName('status_poli').AsString + '</span>';

      // buat kartu pasien
      CardHTML :=
        '<div class="card">' +
        '<div class="nama">' + FieldByName('no_rkm_medis').AsString + ' - ' +
                                FieldByName('nm_pasien').AsString + '</div>' +
        '<div class="info">👨⚕️ Dokter: ' + FieldByName('nm_dokter').AsString + '</div>' +
        '<div class="info">🏥 Poli: ' + FieldByName('nm_poli').AsString + '</div>' +
        '<div class="info">📅 Tanggal: ' + DateToStr(FieldByName('tgl_registrasi').AsDateTime) + '</div>' +
        StatusTag +
        '</div>';

      S := S + CardHTML;
      Next;
    end;
  end;

  // footer HTML
  S := S + '</body></html>';

  HTMLViewer1.LoadFromString(S);
end;

procedure TFormIGD.FormShow(Sender: TObject);
begin

end;

end.

