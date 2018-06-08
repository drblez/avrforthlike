unit Utils;

interface

procedure AbortMsg(Msg: String);

procedure WarningMsg(Msg: String);

function NameToAsm(Name: String; Prefix: String): String;

function HexToInt(S: String): Integer;

function Byte0(I: Integer): Integer;
function Byte1(I: Integer): Integer;
function Byte2(I: Integer): Integer;
function Byte3(I: Integer): Integer;

function ConvertAsm(S: String): String;

function GetNextBrLabel: Integer;

implementation

uses
  Globals, SysUtils;

procedure AbortMsg(Msg: String);
begin
  Write('ABORT: ');
  if LastFileName <> '' then
    Write(LastFileName, ': ');
  WriteLn(Msg);
  WriteLn(ListingFile);
  Write(ListingFile, '*** ABORT: ');
  if LastFileName <> '' then
    Write(ListingFile, LastFileName, ': ');
  WriteLn(ListingFile, Msg);
  Close(ListingFile);
  Halt(16);
end;

procedure WarningMsg(Msg: String);
begin
  WriteLn('WARNING: ' + Msg);
  WriteLn(ListingFile);
  WriteLn(ListingFile, '*** WARNING: ' + Msg);
  WriteLn(ListingFile);
end;

function NameToAsm(Name: String; Prefix: String): String;
var
  i: Integer;
begin
  Result := Prefix;
  for i := 1 to Length(Name) do
  begin
    case Name[i] of
      #0: Result := Result + '_ZERO_';
      #1..#32: Result := Result + '_CTRL_' + Chr(Ord(Name[i]) + 64) + '_';
      '0'..'9': Result := Result + Name[i];
      'A'..'Z': Result := Result + Name[i];
      'a'..'z': Result := Result + '_' + Name[i];
      '!': Result := Result + '_excl';
      '"': Result := Result + '_dquot';
      '#': Result := Result + '_numba';
      '$': Result := Result + '_dollar';
      '%': Result := Result + '_percent';
      '&': Result := Result + '_amp';
      '''': Result := Result + '_quot';
      '(': Result := Result + '_lpar';
      ')': Result := Result + '_rpar';
      '*': Result := Result + '_star';
      '+': Result := Result + '_plus';
      ',': Result := Result + '_comma';
      '-': Result := Result + '_';
      '.': Result := Result + '_dot';
      '/': Result := Result + '_slash';
      ':': Result := Result + '_colon';
      ';': Result := Result + '_semicolon';
      '<': Result := Result + '_le';
      '=': Result := Result + '_eq';
      '>': Result := Result + '_gr';
      '?': Result := Result + '_quest';
      '@': Result := Result + '_at';
      '[': Result := Result + '_lbr';
      '\': Result := Result + '_bslash';
      ']': Result := Result + '_rbr';
      '^': Result := Result + '_up';
      '_': Result := Result + '__under';
      '`': Result := Result + '_bquot';
      '{': Result := Result + '_lcbr';
      '|': Result := Result + '_fuck';
      '}': Result := Result + '_rcbr';
      '~': Result := Result + '_tilda';
      '': Result := Result + '_delta';
      '�': Result := Result + '_A';
      '�': Result := Result + '_B';
      '�': Result := Result + '_V';
      '�': Result := Result + '_G';
      '�': Result := Result + '_D';
      '�': Result := Result + '_YE';
      '�': Result := Result + '_ZH';
      '�': Result := Result + '_Z';
      '�': Result := Result + '_I';
      '�': Result := Result + '_J';
      '�': Result := Result + '_K';
      '�': Result := Result + '_L';
      '�': Result := Result + '_M';
      '�': Result := Result + '_N';
      '�': Result := Result + '_O';
      '�': Result := Result + '_P';
      '�': Result := Result + '_R';
      '�': Result := Result + '_S';
      '�': Result := Result + '_T';
      '�': Result := Result + '_U';
      '�': Result := Result + '_F';
      '�': Result := Result + '_KH';
      '�': Result := Result + '_TS';
      '�': Result := Result + '_CH';
      '�': Result := Result + '_SH';
      '�': Result := Result + '_SHCH';
      '�': Result := Result + '___';
      '�': Result := Result + '_Y';
      '�': Result := Result + '____';
      '�': Result := Result + '_E';
      '�': Result := Result + '_YU';
      '�': Result := Result + '_YA';
      '�': Result := Result + '__A';
      '�': Result := Result + '__B';
      '�': Result := Result + '__V';
      '�': Result := Result + '__G';
      '�': Result := Result + '__D';
      '�': Result := Result + '__YE';
      '�': Result := Result + '__ZH';
      '�': Result := Result + '__Z';
      '�': Result := Result + '__I';
      '�': Result := Result + '__J';
      '�': Result := Result + '__K';
      '�': Result := Result + '__L';
      '�': Result := Result + '__M';
      '�': Result := Result + '__N';
      '�': Result := Result + '__O';
      '�': Result := Result + '__P';
      '�'..'�': Result := Result + IntToStr(Ord(Name[i]));
      '�': Result := Result + '__R';
      '�': Result := Result + '__S';
      '�': Result := Result + '__T';
      '�': Result := Result + '__U';
      '�': Result := Result + '__F';
      '�': Result := Result + '__KH';
      '�': Result := Result + '__TS';
      '�': Result := Result + '__CH';
      '�': Result := Result + '__SH';
      '�': Result := Result + '__SHCH';
      '�': Result := Result + '_____';
      '�': Result := Result + '__Y';
      '�': Result := Result + '______';
      '�': Result := Result + '__E';
      '�': Result := Result + '__YU';
      '�': Result := Result + '__YA';
      '�': Result := Result + '_YO';
      '�': Result := Result + '__YO';
      '�'..#255: Result := Result + IntToStr(Ord(Name[i]));
    end;
  end;
end;

function HexToInt(S: String): Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 1 to Length(S) do
    case S[i] of
      '0'..'9': Result := (Result shl 4) + (Ord(S[i]) - Ord('0'));
      'A'..'F': Result := (Result shl 4) + (Ord(S[i]) - Ord('A') + 10);
      else
        raise EConvertError.Create('Bad HEX digit');
    end;
end;

function Byte0(I: Integer): Integer;
begin
  Result := I and $000000FF;
end;

function Byte1(I: Integer): Integer;
begin
  Result := (I and $0000FF00) shr 8;
end;

function Byte2(I: Integer): Integer;
begin
  Result := (I and $00FF0000) shr 16;
end;

function Byte3(I: Integer): Integer;
begin
  Result := (I and $FF000000) shr 24;
end;

function ConvertAsm(S: String): String;
var
  T: String;
  Lbl: array [0..9] of Integer;
  Idx: Integer;
  i: Integer;
begin
  Result := '';
  if Length(S) = 0 then
    exit;
  if S[1] <> #9 then
    T := #9
  else
    T := '';
  for i := 0 to 9 do Lbl[i] := 0;
  i := 1;
  while i <= Length(S) do
  begin
    if S[i] = '@' then
    begin
      Idx := Ord(S[i + 1]) - 48;
      if Lbl[Idx] = 0 then
        Lbl[Idx] := GetNextBrLabel;
      T := T + IntToStr(Lbl[Idx]);
      Inc(i);
    end
    else
      T := T + S[i];
    Inc(i);
  end;
  Result := T;
end;

function GetNextBrLabel: Integer;
begin
  Inc(GlBrLabel);
  Result := GlBrLabel;
end;

end.
