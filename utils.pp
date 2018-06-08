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
      'Ä': Result := Result + '_A';
      'Å': Result := Result + '_B';
      'Ç': Result := Result + '_V';
      'É': Result := Result + '_G';
      'Ñ': Result := Result + '_D';
      'Ö': Result := Result + '_YE';
      'Ü': Result := Result + '_ZH';
      'á': Result := Result + '_Z';
      'à': Result := Result + '_I';
      'â': Result := Result + '_J';
      'ä': Result := Result + '_K';
      'ã': Result := Result + '_L';
      'å': Result := Result + '_M';
      'ç': Result := Result + '_N';
      'é': Result := Result + '_O';
      'è': Result := Result + '_P';
      'ê': Result := Result + '_R';
      'ë': Result := Result + '_S';
      'í': Result := Result + '_T';
      'ì': Result := Result + '_U';
      'î': Result := Result + '_F';
      'ï': Result := Result + '_KH';
      'ñ': Result := Result + '_TS';
      'ó': Result := Result + '_CH';
      'ò': Result := Result + '_SH';
      'ô': Result := Result + '_SHCH';
      'ö': Result := Result + '___';
      'õ': Result := Result + '_Y';
      'ú': Result := Result + '____';
      'ù': Result := Result + '_E';
      'û': Result := Result + '_YU';
      'ü': Result := Result + '_YA';
      '†': Result := Result + '__A';
      '°': Result := Result + '__B';
      '¢': Result := Result + '__V';
      '£': Result := Result + '__G';
      '§': Result := Result + '__D';
      '•': Result := Result + '__YE';
      '¶': Result := Result + '__ZH';
      'ß': Result := Result + '__Z';
      '®': Result := Result + '__I';
      '©': Result := Result + '__J';
      '™': Result := Result + '__K';
      '´': Result := Result + '__L';
      '¨': Result := Result + '__M';
      '≠': Result := Result + '__N';
      'Æ': Result := Result + '__O';
      'Ø': Result := Result + '__P';
      '∞'..'ﬂ': Result := Result + IntToStr(Ord(Name[i]));
      '‡': Result := Result + '__R';
      '·': Result := Result + '__S';
      '‚': Result := Result + '__T';
      '„': Result := Result + '__U';
      '‰': Result := Result + '__F';
      'Â': Result := Result + '__KH';
      'Ê': Result := Result + '__TS';
      'Á': Result := Result + '__CH';
      'Ë': Result := Result + '__SH';
      'È': Result := Result + '__SHCH';
      'Í': Result := Result + '_____';
      'Î': Result := Result + '__Y';
      'Ï': Result := Result + '______';
      'Ì': Result := Result + '__E';
      'Ó': Result := Result + '__YU';
      'Ô': Result := Result + '__YA';
      '': Result := Result + '_YO';
      'Ò': Result := Result + '__YO';
      'Ú'..#255: Result := Result + IntToStr(Ord(Name[i]));
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
