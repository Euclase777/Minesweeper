unit UnitSettings;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  System.ImageList, Vcl.ImgList, Vcl.Grids;

type
  TFormSettings = class(TForm)
    Difficulty: TRadioGroup;
    RadioButtonEasy: TRadioButton;
    RadioButtonMedium: TRadioButton;
    RadioButtonHard: TRadioButton;
    RadioButtonSpecial: TRadioButton;
    TextWidth: TStaticText;
    TextHeight: TStaticText;
    TextMines: TStaticText;
    EditWidth: TEdit;
    EditMines: TEdit;
    EditHeight: TEdit;
    ButtonOk: TButton;
    ButtonCancel: TButton;
    PanelEditor: TPanel;
    ImageListWalls: TImageList;
    PaintBoxEdit: TPaintBox;
    procedure DifficultyEasy(Sender: TObject);
    procedure DifficultyMedium(Sender: TObject);
    procedure DifficultyHard(Sender: TObject);
    procedure DifficultySpecial(Sender: TObject);
    procedure DifficultyApply(Sender: TObject);
    procedure DifficultyCancel(Sender: TObject);
    procedure EditorStart(Sender: TObject);
    procedure WidthChange(Sender: TObject);
    procedure HeightChange(Sender: TObject);
    procedure SwitchState(Sender: TObject);
    procedure MouseEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormSettings: TFormSettings;
  TileMouseX,TileMouseY:integer;
  TileBlock: array of array of integer;
  BlockedTiles: integer;

implementation

{$R *.dfm}

uses UnitMain;

//кнопка ОК
procedure TFormSettings.DifficultyApply(Sender: TObject);
var
i,j:integer;
begin
  if (StrToInt(EditHeight.Text)>6) and (StrToInt(EditHeight.Text)<18)
  and (StrToInt(EditWidth.Text)>6) and (StrToInt(EditWidth.Text)<54)
  and (StrToInt(EditMines.Text)>0) and (StrToInt(EditMines.Text)<(StrToInt(EditWidth.Text)*StrToInt(EditHeight.Text)-BlockedTiles))
  then begin
    with FormMain do begin
      ys:=StrToInt(EditHeight.Text);
      xs:=StrToInt(EditWidth.Text);
      MinesAm:=StrToInt(EditMines.Text);
      Blocks:=BlockedTiles;
      SetLength(TileStates,StrToInt(EditWidth.Text));
      for i := 0 to StrToInt(EditWidth.Text)-1 do begin
        SetLength(TileStates[i],StrToInt(EditHeight.Text));
        for j := 0 to StrToInt(EditHeight.Text)-1 do begin
          TileStates[i,j]:=TileBlock[i,j];
        end;
      end;
      FormMain.RestartGame(EditWidth);
    end;
    FormSettings.Close;
  end
  else ShowMessage('Введены неверные значения');
end;

//кнопка отмена
procedure TFormSettings.DifficultyCancel(Sender: TObject);
begin
  FormSettings.Close;
end;

//новичок
procedure TFormSettings.DifficultyEasy(Sender: TObject);
begin
 EditHeight.Text:='9';
 EditHeight.Enabled:=false;
 EditWidth.Text:='9';
 EditWidth.Enabled:=false;
 EditMines.Text:='10';
 EditMines.Enabled:=false;
end;

//любитель
procedure TFormSettings.DifficultyMedium(Sender: TObject);
begin
  EditHeight.Text:='16';
  EditHeight.Enabled:=false;
  EditWidth.Text:='16';
  EditWidth.Enabled:=false;
  EditMines.Text:='40';
  EditMines.Enabled:=false;
end;

//профессионал
procedure TFormSettings.DifficultyHard(Sender: TObject);
begin
  EditHeight.Text:='16';
  EditHeight.Enabled:=false;
  EditWidth.Text:='30';
  EditWidth.Enabled:=false;
  EditMines.Text:='99';
  EditMines.Enabled:=false;
end;

//особый
procedure TFormSettings.DifficultySpecial(Sender: TObject);
begin
  EditHeight.Enabled:=true;
  EditWidth.Enabled:=true;
  EditMines.Enabled:=true;
end;

procedure TFormSettings.EditorStart(Sender: TObject);
var
i,j:integer;
begin
  PanelEditor.Height:=StrToInt(EditHeight.Text)*32+4;
  FormSettings.Height:=200+PanelEditor.Height;
  PanelEditor.Width:=(StrToInt(EditWidth.Text)*32)+4;
  SetLength(TileBlock,StrToInt(EditWidth.Text));
  for i := 0 to StrToInt(EditWidth.Text)-1 do begin
    SetLength(TileBlock[i],StrToInt(EditHeight.Text));
    for j := 0 to StrToInt(EditHeight.Text)-1 do begin
      ImageListWalls.Draw(PaintBoxEdit.Canvas,32*i,32*j,TileBlock[i,j]div 2,True);
    end;
  end;
end;

procedure TFormSettings.HeightChange(Sender: TObject);
var
i,j:integer;
begin
  if not(EditHeight.Text='') then begin
    PanelEditor.Height:=(StrToInt(EditHeight.Text)*32)+4;
    FormSettings.Height:=200+PanelEditor.Height;
    FormSettings.Top:=(720-FormSettings.Height)div 2;
    SetLength(TileBlock,StrToInt(EditWidth.Text));
    for i := 0 to StrToInt(EditWidth.Text)-1 do begin
      SetLength(TileBlock[i],StrToInt(EditHeight.Text));
      for j := 0 to StrToInt(EditHeight.Text)-1 do begin
        ImageListWalls.Draw(PaintBoxEdit.Canvas,32*i,32*j,TileBlock[i,j] div 2,True);
      end;
    end;
  end;
end;

procedure TFormSettings.MouseEnter(Sender: TObject);
var
i,j:integer;
begin
  SetLength(TileBlock,StrToInt(EditWidth.Text));
  for i := 0 to StrToInt(EditWidth.Text)-1 do begin
    SetLength(TileBlock[i],StrToInt(EditHeight.Text));
    for j := 0 to StrToInt(EditHeight.Text)-1 do begin
      ImageListWalls.Draw(PaintBoxEdit.Canvas,32*i,32*j,TileBlock[i,j] div 2,True);
    end;
  end;
end;

procedure TFormSettings.SwitchState(Sender: TObject);
begin
  TileMouseX:=(Mouse.CursorPos.X-FormSettings.Left-16) div 32;
  TileMouseY:=(Mouse.CursorPos.Y-FormSettings.Top-194) div 32;
  case TileBlock[TileMouseX,TileMouseY] of
    0:begin
      TileBlock[TileMouseX,TileMouseY]:=2;
      inc(BlockedTiles);
    end;
    2:begin
      TileBlock[TileMouseX,TileMouseY]:=0;
      BlockedTiles:=BlockedTiles-1;
    end;
  end;
  ImageListWalls.Draw(PaintBoxEdit.Canvas,TileMouseX*32,TileMouseY*32,TileBlock[TileMouseX,TileMouseY] div 2,True);
end;

procedure TFormSettings.WidthChange(Sender: TObject);
var
i,j:integer;
begin
  if not(EditWidth.Text='') then begin
    FormSettings.Width:=(StrToInt(EditWidth.Text)*33);
    FormSettings.Left:=(1366-FormSettings.Width) div 2;
    SetLength(TileBlock,StrToInt(EditWidth.Text));
    for i := 0 to StrToInt(EditWidth.Text)-1 do begin
      SetLength(TileBlock[i],StrToInt(EditHeight.Text));
      for j := 0 to StrToInt(EditHeight.Text)-1 do begin
        ImageListWalls.Draw(PaintBoxEdit.Canvas,32*i,32*j,TileBlock[i,j] div 2,True);
      end;
    end;
  end;
end;

end.
