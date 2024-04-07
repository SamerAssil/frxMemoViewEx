{ ******************************************************* }
{ Samer Assil }
{ frxComponents.pas }
{ email: samer.assil@gmail.com }
{ 2021 }
{ ******************************************************* }

unit frxComponents;

interface

uses
  System.SysUtils, System.Classes, System.StrUtils, Vcl.Graphics, frxClass,
  frxDsgnIntf, frxRes,
  frxDesgn;

type

  TAutoFontSize = class(TPersistent)
  private
    FActive: boolean;
    FSizeMax: integer;
    FSizeMin: integer;
  published
    property Active: boolean read FActive write FActive;
    property SizeMax: integer read FSizeMax write FSizeMax default 40;
    property SizeMin: integer read FSizeMin write FSizeMin default 4;
  end;

  TfrxMemoViewEx = class(TfrxMemoView)
  private
    FAutoFontSize: TAutoFontSize;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function CamelCase(aText: String): String;
    class function GetDescription: string; override;
  private
    procedure AdjustHeight;
    procedure AdjustWidth;
  published
    procedure Draw(Canvas: TCanvas; ScaleX, ScaleY, OffsetX,
      OffsetY: Extended); override;
    property AutoFontSize: TAutoFontSize read FAutoFontSize write FAutoFontSize;
  end;

implementation

{ TfrxTestComp }
procedure TfrxMemoViewEx.AdjustHeight;
begin
  while CalcHeight < Height - (gapy * 2) do
  begin
    font.size := font.size + 1;
    if font.size > AutoFontSize.SizeMax then
      break;
  end;
end;

procedure TfrxMemoViewEx.AdjustWidth;
begin
  while CalcWidth > width - (gapx * 2) do
  begin
    font.size := font.size - 1;
    if font.size > AutoFontSize.SizeMax then
      break;
  end;
end;

function TfrxMemoViewEx.CamelCase(aText: String): String;
var
  flag: boolean;
  i: integer;
  len: integer;
begin
  flag := true;
  i := 0;
  len := length(Text);

  for i := 0 to len - 1 do
  begin
    if flag then
      aText[i] := UpCase(Text[i]);
    flag := aText[i] = ' ';
  end;

end;

constructor TfrxMemoViewEx.Create(AOwner: TComponent);
begin
  inherited;
  FAutoFontSize := TAutoFontSize.Create;
  FAutoFontSize.FSizeMax := 40;
  FAutoFontSize.FSizeMin := 4;
end;

destructor TfrxMemoViewEx.Destroy;
begin
  FAutoFontSize.Free;
  inherited;
end;

procedure TfrxMemoViewEx.Draw(Canvas: TCanvas;
  ScaleX, ScaleY, OffsetX, OffsetY: Extended);
begin
  if AutoFontSize.Active then
  begin
    font.size := AutoFontSize.SizeMin;

    AdjustHeight;
    var txt: String;

    // becouse Text is a WideString so "Length(Text) = 3" to check if the text is a one Character

    if (not WordWrap) or ( Length(Text) = 3 )  then
    begin
      AdjustWidth;
      font.size := font.size + 1;
    end;

   // text := length(txt).ToString + text;

    font.size := font.size - 1;
    if font.size < AutoFontSize.SizeMin then
      font.size := AutoFontSize.SizeMin;
  end;

  inherited; // must be at the end - do not remove it
end;

class function TfrxMemoViewEx.GetDescription: string;
begin
  result := 'Text Object Ex';
end;

var
  Bmp: TBitmap;

initialization

Bmp := TBitmap.Create;
Bmp.LoadFromResourceName(hInstance, 'frxMemoViewEx');
frxObjects.RegisterObject(TfrxMemoViewEx, Bmp);

finalization

frxObjects.Unregister(TfrxMemoViewEx);
Bmp.Free;

end.
