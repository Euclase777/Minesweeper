unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Menus,
  System.ImageList, Vcl.ImgList, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.DBCGrids,
  Vcl.Grids, System.Actions, Vcl.ActnList, System.Types, PngImage;

type
  TFormMain = class(TForm)
    PanelMain: TPanel;
    PanelHUD: TPanel;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    GamePanel: TPanel;
    BtnRestart: TButton;
    ImageListSmile: TImageList;
    PaintBox: TPaintBox;
    Timer1: TTimer;
    PanelBombs: TPanel;
    PanelTimer: TPanel;
    procedure GameFieldDraw(Sender: TObject);
    procedure TileOpen(Sender: TObject);
    procedure RestartGame(Sender: TObject);
    procedure TileFlag(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnClickSettings(Sender: TObject);
    procedure TimerInc(Sender: TObject);
    procedure OnClickHelp(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;
  openTiles:integer;
  MinesGend:boolean = False;
  xs:integer = 9;
  ys:integer = 9;
  MinesAm:integer = 10;
  flags:integer = 0;
  MinesLocation:array of array of integer;
  TileStates:array of array of integer;
  TileMouseX, TileMouseY:integer;

implementation

{$R *.dfm}

uses UnitHelp, UnitSettings;

//настройки
procedure TFormMain.OnClickHelp(Sender: TObject);
begin
UnitHelp.FormHelp.ShowModal;
end;

procedure TFormMain.OnClickSettings(Sender: TObject);
begin
UnitSettings.FormSettings.ShowModal;
end;

function AddLeadZero (const Number, Length : integer) : string;
begin
  result := Format('%.*d', [Length, Number]) ;
end;

//пересчёт бомб
procedure recount;
begin
  FormMain.PanelBombs.Caption:=AddLeadZero(MinesAm-flags,3);
end;

//определяет нажатую клетку
procedure TileMouseCoords;
begin
  TileMouseX:=(Mouse.CursorPos.X-FormMain.Left-24) div 32;
  TileMouseY:=(Mouse.CursorPos.Y-FormMain.Top-154) div 32;
end;

//рисует бомбы
procedure Bomb(TileX:integer; TileY:integer);
var
i,j:integer;
begin
with FormMain.PaintBox, FormMain.PaintBox.Canvas do
    begin
      Pen.Color:=clRed;
      Brush.Color:=clRed;
      Pen.Width:=2;
      Rectangle(32*TileX+2,32*TileY+2,32*(TileX+1)-2,32*(TileY+1)-2);
      for i := 0 to (xs-1) do begin
        for j := 0 to (ys-1) do begin
          if MinesLocation[i,j]=9 then begin
            Pen.Color:=clBlack;
            Brush.Color:=clBlack;
            Pen.Width:=1;
            Rectangle(32*i+11,32*j+7,32*i+21,32*j+25);
            Rectangle(32*i+9,32*j+9,32*i+23,32*j+23);
            Rectangle(32*i+7,32*j+11,32*i+25,32*j+21);
            Rectangle(32*i+3,32*j+15,32*i+29,32*j+17);
            Rectangle(32*i+15,32*j+3,32*i+17,32*j+29);
            Rectangle(32*i+7,32*j+7,32*i+9,32*j+9);
            Rectangle(32*i+23,32*j+7,32*i+25,32*j+9);
            Rectangle(32*i+7,32*j+23,32*i+9,32*j+25);
            Rectangle(32*i+23,32*j+23,32*i+25,32*j+25);
            Pen.Color:=clWhite;
            Brush.Color:=clWhite;
            Rectangle(32*i+11,32*j+11,32*i+15,32*j+15);
          end;
        end;
      end;

    end;
end;

//рисует цифры
procedure Number(X:integer; Y:integer);
begin
  with FormMain.PaintBox, FormMain.PaintBox.Canvas do begin
    case MinesLocation[X,Y] of
      1:begin
      Pen.Color:=clBlue;
      Brush.Color:=clBlue;

      Rectangle(32*X+9,32*Y+11,32*X+11,32*Y+13);
      Rectangle(32*X+11,32*Y+9,32*X+13,32*Y+13);
      Rectangle(32*X+13,32*Y+7,32*X+19,32*Y+21);
      Rectangle(32*X+15,32*Y+5,32*X+19,32*Y+7);
      Rectangle(32*X+9,32*Y+21,32*X+23,32*Y+25);
      end;

      2:begin
      Pen.Color:=clGreen;
      Brush.Color:=clGreen;

      Rectangle(32*X+5,32*Y+7,32*X+11,32*Y+11);
      Rectangle(32*X+7,32*Y+5,32*X+23,32*Y+9);
      Rectangle(32*X+19,32*Y+7,32*X+25,32*Y+13);
      Rectangle(32*X+15,32*Y+13,32*X+23,32*Y+15);
      Rectangle(32*X+11,32*Y+15,32*X+21,32*Y+17);
      Rectangle(32*X+7,32*Y+17,32*X+17,32*Y+19);
      Rectangle(32*X+5,32*Y+19,32*X+13,32*Y+21);
      Rectangle(32*X+5,32*Y+21,32*X+25,32*Y+25);
      end;

      3:begin
      Pen.Color:=clRed;
      Brush.Color:=clRed;

      Rectangle(32*X+5,32*Y+5,32*X+23,32*Y+9);
      Rectangle(32*X+19,32*Y+7,32*X+25,32*Y+13);
      Rectangle(32*X+11,32*Y+13,32*X+23,32*Y+17);
      Rectangle(32*X+19,32*Y+17,32*X+25,32*Y+23);
      Rectangle(32*X+5,32*Y+21,32*X+23,32*Y+25);
      end;

      4:begin
      Pen.Color:=clNavy;
      Brush.Color:=clNavy;

      Rectangle(32*X+9,32*Y+5,32*X+15,32*Y+9);
      Rectangle(32*X+7,32*Y+9,32*X+13,32*Y+13);
      Rectangle(32*X+5,32*Y+13,32*X+25,32*Y+17);
      Rectangle(32*X+17,32*Y+5,32*X+23,32*Y+25);
      end;

      5:begin
      Pen.Color:=clMaroon;
      Brush.Color:=clMaroon;

      Rectangle(32*X+5,32*Y+5,32*X+25,32*Y+9);
      Rectangle(32*X+5,32*Y+9,32*X+11,32*Y+13);
      Rectangle(32*X+5,32*Y+13,32*X+23,32*Y+17);
      Rectangle(32*X+19,32*Y+15,32*X+25,32*Y+23);
      Rectangle(32*X+5,32*Y+21,32*X+23,32*Y+25);
      end;

      6:begin
      Pen.Color:=clTeal;
      Brush.Color:=clTeal;

      Rectangle(32*X+7,32*Y+5,32*X+23,32*Y+9);
      Rectangle(32*X+5,32*Y+7,32*X+11,32*Y+23);
      Rectangle(32*X+7,32*Y+21,32*X+23,32*Y+25);
      Rectangle(32*X+19,32*Y+15,32*X+25,32*Y+23);
      Rectangle(32*X+11,32*Y+13,32*X+23,32*Y+17);
      end;

      7:begin
      Pen.Color:=clBlack;
      Brush.Color:=clBlack;

      Rectangle(32*X+5,32*Y+5,32*X+25,32*Y+9);
      Rectangle(32*X+19,32*Y+9,32*X+25,32*Y+13);
      Rectangle(32*X+17,32*Y+13,32*X+23,32*Y+17);
      Rectangle(32*X+15,32*Y+17,32*X+21,32*Y+21);
      Rectangle(32*X+13,32*Y+21,32*X+19,32*Y+25);
      end;

      8:begin
      Pen.Color:=clGray;
      Pen.Color:=clGray;

      Rectangle(32*X+7,32*Y+5,32*X+23,32*Y+9);
      Rectangle(32*X+7,32*Y+21,32*X+23,32*Y+25);
      Rectangle(32*X+7,32*Y+13,32*X+23,32*Y+17);
      Rectangle(32*X+5,32*Y+7,32*X+11,32*Y+13);
      Rectangle(32*X+19,32*Y+7,32*X+25,32*Y+13);
      Rectangle(32*X+5,32*Y+17,32*X+11,32*Y+23);
      Rectangle(32*X+19,32*Y+17,32*X+25,32*Y+23);
      end;
    end;
  end;
end;

//открывает клетку
procedure openTile(TileX:integer;TileY:integer);
var
i,j:integer;
begin
  if ((TileStates[TileX,TileY]=1)or(TileStates[TileX,TileY]=-2)) then begin
    TileStates[TileX,TileY]:=0;
    inc(openTiles);

    with FormMain.PaintBox, FormMain.PaintBox.Canvas do
    begin
      Pen.Color:=clBtnShadow;
      Brush.Color:=clSilver;
      Rectangle(32*TileX,32*TileY,32*(TileX+1)-1,32*(TileY+1)-1);
    end;

    //открывать пустые последовательно
    if MinesLocation[TileX,TileY]=0 then begin
      for i := (TileX-1) to (TileX+1) do begin
        for j := (TileY-1) to (TileY+1) do begin
          if ((i>-1)and(j>-1)and(i<xs)and(j<ys))then begin
          openTile(i,j);
          end;
        end;
      end;
    end;

    //открыть бомбу
    if MinesLocation[TileX, TileY]=9 then begin
      FormMain.BtnRestart.ImageIndex:=4;
      Bomb(TileX, TileY);
    end;

    //открыть цифру
    if (MinesLocation[TileX, TileY]>0)and(MinesLocation[TileX, TileY]<9) then begin
      Number(TileX,TileY);
    end;

    //проверка на победу
    if (openTiles)=(xs*ys-MinesAm) then FormMain.BtnRestart.ImageIndex:=3;


  end;
end;

//считает сколько бомб вокруг
procedure pcount(x:integer;y:integer);
var
count:integer;
i,j:integer;
begin
count:=0;
 for i := (x-1) to (x+1) do begin
   for j := (y-1) to (y+1) do begin
     if ((i>-1)and(j>-1)and(i<xs-1)and(j<ys-1))then begin
       if MinesLocation[i,j]=9 then inc(count);
     end;
   end;
 end;
 MinesLocation[x,y]:=count;
end;

//генерация
procedure generate(Amount:integer);
var
MinesSpawned:integer;
i,j:integer;
begin
  randomize;
  MinesSpawned:=0;
  //создание таблицы
  SetLength(MinesLocation,xs);
  SetLength(TileStates, xs);
  for i := 0 to xs-1 do begin
    SetLength(MinesLocation[i],ys);
    SetLength(TileStates[i], ys);
  end;
  //добавление бомб
  while MinesSpawned < MinesAm do begin
    MinesLocation[random(xs-1),random(ys-1)]:=9;

    //чтобы не проиграть с первого клика
    if MinesLocation[TileMouseX,TileMouseY]=9 then
    MinesLocation[TileMouseX,TileMouseY]:=0;

    MinesSpawned:=0;
    for i := 0 to xs-1 do begin
      for j := 0 to ys-1 do begin
        if (MinesLocation[i,j]=9) then begin
        inc(MinesSpawned);
        end
        else pcount(i,j);
      end;
    end;
  end;

  //отметить все клетки закрытыми
  for i := 0 to xs-1 do begin
    for j := 0 to ys-1 do begin
    TileStates[i,j]:=1;
    end;
  end;
  MinesGend:=True;
end;

//очищает клетку
procedure Clear(X:integer;Y:integer);
begin
  with FormMain.PaintBox, FormMain.PaintBox.Canvas do
    begin
      Pen.Color:=clSilver;
      Brush.Color:=clSilver;
      Rectangle(32*X+3,32*Y+3,32*X+27,32*Y+27);
    end;
end;

//рисует флаг
procedure Flag(TileX:integer;TileY:integer);
begin
with FormMain.PaintBox, FormMain.PaintBox.Canvas do
    begin
      Pen.Color:=clRed;
      Brush.Color:=clRed;
      Pen.Width:=1;
      Rectangle(32*TileX+13,32*TileY+5,32*TileX+17,32*TileY+15);
      Rectangle(32*TileX+7,32*TileY+9,32*TileX+9,32*TileY+11);
      Rectangle(32*TileX+9,32*TileY+7,32*TileX+13,32*TileY+13);

      Pen.Color:=clBlack;
      Brush.Color:=clBlack;
      Rectangle(32*TileX+15,32*TileY+15,32*TileX+17,32*TileY+19);
      Rectangle(32*TileX+11,32*TileY+19,32*TileX+19,32*TileY+21);
      Rectangle(32*TileX+7,32*TileY+21,32*TileX+23,32*TileY+25);
    end;
end;

//рисует вопрос
procedure Question(X:integer;Y:integer);
begin
  with FormMain.PaintBox, FormMain.PaintBox.Canvas do
    begin
      Pen.Color:=clBlack;
      Brush.Color:=clBlack;
      Rectangle(32*X+9,32*Y+7,32*X+13,32*Y+11);
      Rectangle(32*X+11,32*Y+5,32*X+19,32*Y+7);
      Rectangle(32*X+17,32*Y+7,32*X+21,32*Y+13);
      Rectangle(32*X+15,32*Y+14,32*X+19,32*Y+15);
      Rectangle(32*X+13,32*Y+15,32*X+17,32*Y+19);
      Rectangle(32*X+13,32*Y+21,32*X+17,32*Y+25);
    end;
end;

//рисует поле
procedure draw;
var
i,j:integer;
begin
  recount;
  FormMain.GamePanel.Width:=(32*xs)+8;
  FormMain.GamePanel.Height:=(32*ys)+8;
  FormMain.PanelHUD.Width:=FormMain.GamePanel.Width;
  FormMain.Width:=FormMain.GamePanel.Width+38;
  FormMain.Height:=FormMain.GamePanel.Height+169;
  FormMain.BtnRestart.Left:=FormMain.PanelHUD.Width div 2 - 25;
with FormMain.PaintBox, FormMain.PaintBox.canvas do
  begin
  Brush.Color:=clSilver;
  Pen.Color:=clSilver;
  Rectangle(0,0,32*xs,32*ys);
  openTiles:=0;
  Pen.Width:=1;
      for i := 0 to (xs-1) do begin
      for j := 0 to (ys-1) do begin
      Pen.Color:=clWhite;
      polyline([Point(32*i,32*(j+1)),Point(32*i,32*j),Point(32*(i+1),32*j)]);
      polyline([Point(32*i+1,32*(j+1)-2),Point(32*i+1,32*j+1),Point(32*(i+1)-1,32*j+1)]);
      Pen.Color:=clBtnShadow;
      polyline([Point(32*i,32*(j+1)-1),Point(32*(i+1)-1,32*(j+1)-1),Point(32*(i+1)-1,32*j)]);
      polyline([Point(32*i+1,32*(j+1)-2),Point(32*(i+1)-2,32*(j+1)-2),Point(32*(i+1)-2,32*j+1)]);
      end;
    end;
  end;
end;

//создание поля
procedure TFormMain.GameFieldDraw(Sender: TObject);
begin
  draw;
end;

//рестарт
procedure TFormMain.RestartGame(Sender: TObject);
var
i,j:integer;
begin
  if (MinesGend) then begin
    for i := 0 to xs-1 do begin
      for j := 0 to ys-1 do begin
      TileStates[i,j]:=0;
      MinesLocation[i,j]:=0
      end;
    end;
  end;
  flags:=0;
  BtnRestart.ImageIndex:=0;
  MinesGend:=False;
  draw();
  recount;
  PanelTimer.Caption:='000';
end;

//флаг/вопрос
procedure SwitchTileState(X:integer;Y:integer);
begin
  case TileStates[TileMouseX,TileMouseY] of
  //флаг
    1:begin
    TileStates[TileMouseX,TileMouseY]:=-1;
    Clear(TileMouseX,TileMouseY);
    Flag(TileMouseX,TileMouseY);
    inc(flags);
    recount;
    end;
  //вопрос
    -1: begin
    TileStates[TileMouseX,TileMouseY]:=-2;
    Clear(TileMouseX,TileMouseY);
    Question(TileMouseX,TileMouseY);
    dec(flags);
    recount;
    end;
  //пустота
    -2:begin
    TileStates[TileMouseX,TileMouseY]:=1;
    Clear(TileMouseX,TileMouseY);
    end;
  end;
end;

//пкм клетку
procedure TFormMain.TileFlag(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if MinesGend then begin
    if Button = mbRight then begin
    TileMouseCoords;
      SwitchTileState(TileMouseX,TileMouseY);
    end;
  end;
end;

//лкм клетку
procedure TFormMain.TileOpen(Sender: TObject);
begin
  TileMouseCoords;
  if not(MinesGend) then generate(MinesAm);
  openTile(TileMouseX,TileMouseY);
end;

//таймер
procedure TFormMain.TimerInc(Sender: TObject);
begin
  if MinesGend then begin
    if (not(PanelTimer.Caption = '999'))and(FormMain.BtnRestart.ImageIndex=0) then begin
      PanelTimer.Caption:=AddLeadZero(StrToInt(PanelTimer.Caption)+1,3);
    end;
  end;
end;

end.
