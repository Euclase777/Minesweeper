unit UnitHelp;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TFormHelp = class(TForm)
    RichEditHelp: TRichEdit;
    SplitterHelp: TSplitter;
    ButtonHelpClose: TButton;
    procedure OnClickHelpClose(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormHelp: TFormHelp;

implementation

{$R *.dfm}

uses UnitMain;

procedure TFormHelp.OnClickHelpClose(Sender: TObject);
begin
FormHelp.Close;
end;

end.
