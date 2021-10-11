{version 2.3}
unit MakeTab;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, FileCtrl;

const
  SIZE = 32;

type
  TForm3 = class(TForm)
    imgWork: TImage;
    imgPlan: TImage;
    Panel1: TPanel;
    OpenDialog1: TOpenDialog;
    BtnWall: TButton;
    imgFond: TImage;
    imgPts: TImage;
    imgGum: TImage;
    Bevel1: TBevel;
    Panel2: TPanel;
    FileListBox1: TFileListBox;
    OpenDialog2: TOpenDialog;
    CheckV: TCheckBox;
    CheckH: TCheckBox;
    Label1: TLabel;
    BtnNew: TButton;
    BtnLoad: TButton;
    BtnSave: TButton;
    Bevel2: TBevel;
    Bevel3: TBevel;
    Label2: TLabel;
    imgBrush: TImage;
    procedure FormShow(Sender: TObject);
    procedure BtnWallClick(Sender: TObject);
    procedure imgWorkMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgWorkMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgWorkMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure imgFondMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgPtsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure imgGumMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtnNewClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure Draw(x,y: integer);
  public
    { Déclarations publiques }
  end;

var
  Form3: TForm3;
  sPath: string;
  lDown: boolean;
  imgPlanColor: TColor;

implementation

{$R *.DFM}
procedure TForm3.Draw(x,y: integer);
begin
  X := x div 32; Y := y div 32;
  imgWork.Canvas.CopyRect(Rect(X*32,Y*32,(X*32)+32,(Y*32)+32), imgBrush.Canvas, Rect(0,0,32,32));
  imgPlan.Canvas.Pixels[x, y] := imgPlanColor;

  if CheckV.State = cbChecked then begin
    y := 14-y;
    imgWork.Canvas.CopyRect(Rect(X*32,Y*32,(X*32)+32,(Y*32)+32), imgBrush.Canvas, Rect(0,0,32,32));
    imgPlan.Canvas.Pixels[x, y] := imgPlanColor;
  end;

  if CheckH.State = cbChecked then begin
    x := 14-x;
    imgWork.Canvas.CopyRect(Rect(X*32,Y*32,(X*32)+32,(Y*32)+32), imgBrush.Canvas, Rect(0,0,32,32));
    imgPlan.Canvas.Pixels[x, y] := imgPlanColor;
  end;

  if (CheckV.State = cbChecked) and (CheckH.State = cbChecked) then begin
    y := 14-y;
    imgWork.Canvas.CopyRect(Rect(X*32,Y*32,(X*32)+32,(Y*32)+32), imgBrush.Canvas, Rect(0,0,32,32));
    imgPlan.Canvas.Pixels[x, y] := imgPlanColor;
  end;
end;

procedure TForm3.FormShow(Sender: TObject);
var x,y: byte;
begin
  Caption := 'Nouveau Tableau';
  sPath := ExtractFilePath(ParamStr(0));
  imgPts.Picture.LoadFromFile(sPath+'Points.bmp');
  imgFond.Picture.LoadFromFile(sPath+'Mur1.bmp');
  imgGum.Picture.LoadFromFile(sPath+'PacGum.bmp');

  for x := 0 to 14 do for y := 0 to 14 do
    imgWork.Canvas.CopyRect(Rect(x*32,y*32,(x*32)+32,(y*32)+32), imgFond.Canvas, Rect(0,0,32,32));
  imgPlan.Canvas.Brush.Color := clWhite;
  imgPlan.Canvas.FillRect(Rect(0,0,15,15));

  imgBrush.Picture.Assign(imgPts.Picture.Bitmap);
  imgPlanColor := clBlack;
end;

procedure TForm3.BtnWallClick(Sender: TObject);
var x,y: byte;
begin
  if OpenDialog1.Execute then begin
    imgBrush.Picture.Assign(imgPts.Picture.Bitmap);
    imgPlanColor := clBlack;
    imgFond.Picture.LoadFromFile(OpenDialog1.FileName);
    for x := 0 to 14 do for y := 0 to 14 do
      if imgPlan.Canvas.Pixels[x,y] = clWhite then imgWork.Canvas.CopyRect(Rect(x*32,y*32,(x*32)+32,(y*32)+32), imgFond.Canvas, Rect(0,0,32,32));
  end;
end;

procedure TForm3.imgWorkMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  lDown := true;
  Draw(x,y);
end;

procedure TForm3.imgWorkMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  lDown := false;
end;

procedure TForm3.imgWorkMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if lDown then Draw(x,y);
end;

procedure TForm3.BtnSaveClick(Sender: TObject);
var
  x,y: byte;
  s: string;
  nOld, nNew: integer;
  F: TextFile;
begin
  {$I-}
  ChDir(sPath);
  {$I+}
  FileListBox1.Directory := sPath;
  FileListBox1.Update;
  s := IntToStr(FileListBox1.Items.Count+1);
  if InputQuery('N° du tableau', 'Veuillez indiquer le n° de votre tableau :', s) then
  begin
    Form3.Caption := 'Tableau - n° '+s;
    nNew := StrToInt(s);
    if FileExists('Tab'+s+'.txt') and (MessageDlg('Ce tableau existe déjà, faut-t-il le remplacer ?', mtConfirmation, [mbYes, mbNo], 0) = mrNo) then
    begin
      {Renomme les txt et les bmp au dessus}
      for nOld := FileListBox1.Items.Count downto nNew do begin
        RenameFile('Tab'+IntToStr(nOld)+'.txt', 'Tab'+IntToStr(nOld+1)+'.txt');
        RenameFile('Mur'+IntToStr(nOld)+'.bmp', 'Mur'+IntToStr(nOld+1)+'.bmp');
      end;
    end;
    {Ecrit fichier texte}
    AssignFile(F, 'Tab'+IntToStr(nNew)+'.txt');
    Rewrite(F);
    for y := 0 to 14 do begin
      s := '';
      for x := 0 to 14 do begin
        if imgPlan.Canvas.Pixels[x,y] = clWhite then s := s+'#'
        else if imgPlan.Canvas.Pixels[x,y] = clBlack then s := s+' '
        else if imgPlan.Canvas.Pixels[x,y] = clBlue then s := s+'!';
      end;
      Writeln(F, s);
    end;
    CloseFile(F);
    {Ecrit fichier bmp}
    {Garde les 32x32 pixels uniquement}
    imgBrush.Picture := nil;
    for x := 0 to 31 do for y := 0 to 31 do
      imgBrush.Canvas.Pixels[x,y] := imgFond.Canvas.Pixels[x,y];
    imgBrush.Picture.SaveToFile('Mur'+IntToStr(nNew)+'.bmp');
    imgBrush.Picture.Assign(imgPts.Picture.Bitmap);
    imgPlanColor := clBlack;
  end;
end;

procedure TForm3.BtnLoadClick(Sender: TObject);
var
  x, y: integer;
  aTab: TStringList;
  SRect: TRect;
  s: string;
begin
  if OpenDialog2.Execute then begin
    {n°}
    s := Copy(ExtractFileName(OpenDialog2.FileName),4,3);
    s := Copy(s,1,Pos('.',s)-1);
    Form3.Caption := 'Tableau - n° '+s;
    {Image des murs}
    imgFond.Picture.LoadFromFile(ExtractFilePath(OpenDialog2.FileName)+'Mur'+s+'.bmp');
    {Transforme le fichier texte en image bitmap}
    aTab := TStringList.Create;
    aTab.LoadFromFile(OpenDialog2.FileName);
    SRect := Rect(0,0,SIZE,SIZE);
    for y := 0 to 14 do begin
      for x := 0 to 14 do begin
        case aTab[y][x+1] of
        ' ':
          begin
          imgWork.Canvas.CopyRect(
             Rect(x*SIZE,y*SIZE,(x*SIZE)+SIZE,(y*SIZE)+SIZE),imgPts.Canvas,SRect);
          imgPlan.Canvas.Pixels[x,y] := clBlack;
          end;
        '!':
          begin
          imgWork.Canvas.CopyRect(
             Rect(x*SIZE,y*SIZE,(x*SIZE)+SIZE,(y*SIZE)+SIZE),imgGum.Canvas,SRect);
          imgPlan.Canvas.Pixels[x,y] := clBlue;
          end;
        else
          begin
          imgWork.Canvas.CopyRect(Rect(x*SIZE,y*SIZE,(x*SIZE)+SIZE,(y*SIZE)+SIZE),imgFond.Canvas,SRect);
          imgPlan.Canvas.Pixels[x,y] := clWhite;
          end;
        end;
      end;
    end;
    aTab.free;
    imgBrush.Picture.Assign(imgPts.Picture.Bitmap);
    imgPlanColor := clBlack;
  end;
end;

procedure TForm3.imgFondMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgBrush.Picture.Assign(imgFond.Picture.Bitmap);
  imgPlanColor := clWhite;
end;

procedure TForm3.imgPtsMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgBrush.Picture.Assign(imgPts.Picture.Bitmap);
  imgPlanColor := clBlack;
end;

procedure TForm3.imgGumMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  imgBrush.Picture.Assign(imgGum.Picture.Bitmap);
  imgPlanColor := clBlue;
end;

procedure TForm3.BtnNewClick(Sender: TObject);
begin
  if MessageDlg('Etes-vous sûr de vouloir un nouveau tableau ?', mtConfirmation, [mbYes, mbNo], 0) = mrYes
    then FormShow(Self);
end;

end.
