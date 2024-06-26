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
    ImageListTiles: TImageList;
    ImageListWalls: TImageList;
    procedure GameFieldDraw(Sender: TObject);
    procedure TileOpen(Sender: TObject);
    procedure RestartGame(Sender: TObject);
    procedure TileFlag(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure OnClickSettings(Sender: TObject);
    procedure TimerInc(Sender: TObject);
    procedure OnClickHelp(Sender: TObject);
    procedure GameStart(Sender: TObject);
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
  Blocks: integer = 0;

implementation

{$R *.dfm}

uses UnitHelp, UnitSettings;

procedure TFormMain.GameStart(Sender: TObject);
var
i:integer;
begin
  setLength(TileStates,xs);
  for i := 0 to xs-1 do begin
    setLength(TileStates[i],ys);
  end;
end;

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

//�������� ����
procedure recount;
begin
  FormMain.PanelBombs.Caption:=AddLeadZero(MinesAm-flags,3);
end;

//���������� ������� ������
procedure TileMouseCoords;
begin
  TileMouseX:=(Mouse.CursorPos.X-FormMain.Left-24) div 32;
  TileMouseY:=(Mouse.CursorPos.Y-FormMain.Top-154) div 32;
end;

//��������� ������
procedure openTile(TileX:integer;TileY:integer);
var
i,j:integer;
begin
  if (TileStates[TileX,TileY]=1)or(TileStates[TileX,TileY]=-2) then begin
    TileStates[TileX,TileY]:=0;
    inc(openTiles);

    FormMain.ImageListTiles.Draw(FormMain.PaintBox.Canvas,TileX*32,TileY*32,0,True);

    //��������� ������ ���������������
    if MinesLocation[TileX,TileY]=0 then begin
      for i := (TileX-1) to (TileX+1) do begin
        for j := (TileY-1) to (TileY+1) do begin
          if ((i>-1)and(j>-1)and(i<xs)and(j<ys))then begin
          openTile(i,j);
          end;
        end;
      end;
    end;

    //������� �����
    if MinesLocation[TileX, TileY]=9 then begin
      FormMain.BtnRestart.ImageIndex:=4;
      FormMain.ImageListTiles.Draw(FormMain.PaintBox.Canvas,TileX*32,TileY*32,14,True);
    end;

    //������� �����
    if (MinesLocation[TileX, TileY]>0)and(MinesLocation[TileX, TileY]<9) then begin
      FormMain.ImageListTiles.Draw(FormMain.PaintBox.Canvas,TileX*32,TileY*32,MinesLocation[TileX,TileY],True);
    end;

    //�������� �� ������
    if (openTiles)=(xs*ys-MinesAm-Blocks) then FormMain.BtnRestart.ImageIndex:=3;
  end;
end;

//������� ������� ���� ������
procedure pcount(x:integer;y:integer);
var
count:integer;
i,j:integer;
begin
count:=0;
 for i := (x-1) to (x+1) do begin
   for j := (y-1) to (y+1) do begin
     if ((i>-1)and(j>-1)and(i<xs)and(j<ys))then begin
       if MinesLocation[i,j]=9 then inc(count);
     end;
   end;
 end;
 MinesLocation[x,y]:=count;
end;

//���������
procedure generate(Amount:integer);
var
MinesSpawned:integer;
i,j:integer;
begin
  randomize;
  MinesSpawned:=0;
  //�������� �������
  SetLength(MinesLocation,xs);
  SetLength(TileStates, xs);
  for i := 0 to xs-1 do begin
    SetLength(MinesLocation[i],ys);
    SetLength(TileStates[i], ys);
  end;
  //���������� ����
  while MinesSpawned < MinesAm do begin
    MinesLocation[random(xs),random(ys)]:=9;

    //����� �� ��������� � ������� �����
    if MinesLocation[TileMouseX,TileMouseY]=9 then
    MinesLocation[TileMouseX,TileMouseY]:=0;

    MinesSpawned:=0;
    for i := 0 to xs-1 do begin
      for j := 0 to ys-1 do begin
        if (TileStates[i,j]=2) and (MinesLocation[i,j]=9) then begin
          MinesLocation[i,j]:=0;
          MinesSpawned:=MinesSpawned-1;
        end;
        if (MinesLocation[i,j]=9) then begin
        inc(MinesSpawned);
        end
        else pcount(i,j);
      end;
    end;
  end;

  //�������� ��� ������ ���������
  for i := 0 to xs-1 do begin
    for j := 0 to ys-1 do begin
    if TileStates[i,j]<2 then
      TileStates[i,j]:=1;
    end;
  end;
  MinesGend:=True;
end;

//������ ����
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
  openTiles:=0;
  for i := 0 to (xs-1) do begin
    for j := 0 to (ys-1) do begin
      if TileStates[i,j]=0 then
      FormMain.ImageListTiles.Draw(FormMain.PaintBox.Canvas,i*32,j*32,9,True)
      else
      FormMain.ImageListTiles.Draw(FormMain.PaintBox.Canvas,i*32,j*32,16,True)
    end;
  end;
end;

//�������� ����
procedure TFormMain.GameFieldDraw(Sender: TObject);
begin
  draw;
end;

//�������
procedure TFormMain.RestartGame(Sender: TObject);
var
i,j:integer;
begin
  if (MinesGend) then begin
    for i := 0 to xs-1 do begin
      for j := 0 to ys-1 do begin
        if TileStates[i,j]<=1 then begin
          TileStates[i,j]:=0;
          MinesLocation[i,j]:=0
        end;
      end;
    end;
  end;
  flags:=0;
  BtnRestart.ImageIndex:=0;
  MinesGend:=False;
  draw();
  recount;
  PanelTimer.Caption:='000';
  FormMain.Top:=(720-FormMain.Height)div 2;
  FormMain.Left:=(1366-FormMain.Width)div 2;
end;

//����/������
procedure SwitchTileState(X:integer;Y:integer);
begin
  case TileStates[TileMouseX,TileMouseY] of
  //����
    1:begin
    TileStates[TileMouseX,TileMouseY]:=-1;
    FormMain.ImageListTiles.Draw(FormMain.PaintBox.Canvas,TileMouseX*32,TileMouseY*32,10,True);
    inc(flags);
    recount;
    end;
  //������
    -1: begin
    TileStates[TileMouseX,TileMouseY]:=-2;
    FormMain.ImageListTiles.Draw(FormMain.PaintBox.Canvas,TileMouseX*32,TileMouseY*32,11,True);
    dec(flags);
    recount;
    end;
  //�������
    -2:begin
    TileStates[TileMouseX,TileMouseY]:=1;
    FormMain.ImageListTiles.Draw(FormMain.PaintBox.Canvas,TileMouseX*32,TileMouseY*32,9,True);
    end;
  end;
end;

//��� ������
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

//��� ������
procedure TFormMain.TileOpen(Sender: TObject);
begin
  TileMouseCoords;
  if not(MinesGend) then generate(MinesAm);
  openTile(TileMouseX,TileMouseY);
end;

//������
procedure TFormMain.TimerInc(Sender: TObject);
begin
  if MinesGend then begin
    if (not(PanelTimer.Caption = '999'))and(FormMain.BtnRestart.ImageIndex=0) then begin
      PanelTimer.Caption:=AddLeadZero(StrToInt(PanelTimer.Caption)+1,3);
    end;
  end;
end;

end.
