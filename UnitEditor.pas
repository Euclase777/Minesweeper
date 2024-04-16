unit UnitEditor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  Vcl.ExtCtrls, Vcl.StdCtrls;

type
  TFormEditor = class(TForm)
    PanelTop: TPanel;
    PanelEditor: TPanel;
    ButtonedEditWidth: TButtonedEdit;
    ButtonedEditHeight: TButtonedEdit;
    ButtonedEditBombs: TButtonedEdit;
    ImageListButtons: TImageList;
    procedure EditorStart(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormEditor: TFormEditor;

implementation

{$R *.dfm}

uses UnitMain;

procedure TFormEditor.EditorStart(Sender: TObject);
begin
  FormEditor.Width:=FormMain.GamePanel.Width;
  FormEditor.Height:=FormMain.GamePanel.Height+100;
  PanelTop.Height:=100;
end;

end.
