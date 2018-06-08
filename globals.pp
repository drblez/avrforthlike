unit Globals;

interface

uses
  Classes;

const
  MaxBranch = 16;
  MaxInts = 64;

type
  TName = String;
  PName = String;

  PCodeString = String;

  TCodeType = (ctWord, ctIntLit, ctByteLit, ctQuadLit, ctASM, ctLabel, ctVar,
    ctPrimitive, ctBranch, ctCondBranch, ctNone);

  PWord = ^TWord;

  PCodeList = ^TCodeList;
  TCodeList = record
    AWord: PWord;
    Code: PCodeString;
    Next: PCodeList;
    Prev: PCodeList;
    CodeType: TCodeType;
    BrLabel: Integer;
    Inst: Integer;
  end;

  TWordType = (wtWord, wtVar, wtStr, wtCG, wtConst);

  TWord = record
    Name: PName;
    AsmName: PName;
    Link: PWord;
    Immediate: Boolean;
    InlineFlag: Boolean;
    Smugde: Boolean;
    Code: PCodeList;
    InUse: Boolean;
    IsInt: Boolean;
    CodeGen: String;
    IsInit: Boolean;
    SwitchWord: Boolean;
    WordType: TWordType;
    Used: Boolean;
    Size: Integer;
  end;

  TBr = record
    C: PCodeList;
    W: PWord;
  end;

  TBrStack = array [1..MaxBranch] of TBr;

  TInt = record
    Name: PName;
    AWord: PWord;
  end;

  TIntTable = array [1..MaxInts] of TInt;

var
  LastWord: PWord;
  LastCode: PCodeList;
  InCompile: Boolean;
  Name: TName;
  MainWord: PWord;
  BrSP: Integer;
  BrStack: TBrStack;
  GlBrLabel: Integer;
  DP, StrP: Integer;
  Listing: TStringList;
  IntTable: TIntTable;
  IntP: Integer;
  Files: array [1..10] of Text;
  FilesP: Integer;
  LastFileName: String;
  LoopDepth: Integer;
  Included: TStringList;
  PStr: TStringList;
  DoInline: Boolean;
  MainInFile: String;
  MainOutFile: String;
  NotFound: Boolean;
  LLL: TStringList;
  Depth: Integer;
  ListingFile: Text;
  AsmInclude: String;

const
  StackSize = 64;

type
  TStack = array [0 .. StackSize - 1] of Integer;

var
  FullPathPrefix: String;
  InitList: TStringList;
  StackP: Integer;
  DataStack: TStack;

function CodeTypeToStr(C: TCodeType): String;
function FindWord(Name: TName): PWord;
procedure PushData(D: Integer);
function PopData: Integer;
procedure Execute(W: PWord);

implementation

uses
  Utils, SysUtils;

function CodeTypeToStr(C: TCodeType): String;
begin
  case C of
    ctWord: 	Result := 'ctWord';
    ctIntLit: 	Result := 'ctIntLit';
    ctByteLit: 	Result := 'ctByteLit';
    ctQuadLit: 	Result := 'ctQuadLit';
    ctASM: 	Result := 'ctASM';
    ctLabel: 	Result := 'ctLabel';
    ctVar: 	Result := 'ctVar';
    ctPrimitive: Result := 'ctPrimitive';
    ctBranch: 	Result := 'ctBranch';
    ctCondBranch: Result := 'ctCondBranch';
    ctNone: 	Result := 'ctNone';
  end;
end;

function FindWord(Name: TName): PWord;
var
  W: PWord;
begin
  Result := nil;
  W := LastWord;
  while W <> nil do
  begin
    if not W^.Smugde then
    begin
      if W^.Name = Name then
      begin
        Result := W;
        break;
      end;
    end;
    W := W^.Link;
  end;
end;

procedure PushData(D: Integer);
begin
  Inc(StackP);
  if StackP > StackSize - 1 then
    AbortMsg('Data stack overflow');
  DataStack[StackP] := D;
end;

function PopData: Integer;
begin
  if StackP < 0 then
    AbortMsg('Data stack underflow');
  Result := DataStack[StackP];
  Dec(StackP);
end;

procedure Execute(W: PWord);
var
  C: PCodeList;
  R0, R1, R2: Integer;
  S: String;

begin
  if W = nil then
    AbortMsg('Null word');
  C := W^.Code;
  while C <> nil do
  begin
    case C^.CodeType of
      ctWord: Execute(C^.AWord);
      ctByteLit,
      ctIntLit,
      ctQuadLit,
      ctVar: PushData(StrToInt(C^.Code));
      ctPrimitive:
        begin
          S := C^.Code;
          if (Pos('%', S) = 2) then
            Delete(S, 1, 2);
          if S = 'ADDBYTE' then
          begin
            R0 := PopData;
            R1 := PopData;
            R0 := R0 + R1;
          end
          else if S = 'SUBBYTE' then
          begin
            R0 := PopData;
            R1 := PopData;
            R0 := R1 - R0;
          end
          else if S = 'MULBYTE' then
          begin
            R0 := PopData;
            R1 := PopData;
            R0 := R1 * R0;
          end
          else if S = 'DIVMODBYTE' then
          begin
            R0 := PopData;
            R1 := PopData;
            R2 := R1;
            R1 := R1 mod R0;
            R0 := R2 div R0;
          end
          else if S = 'SWAPBYTE' then
          begin
            R0 := PopData;
            R1 := PopData;
          end
          else if S = 'PUSH_B0' then
            PushData(R0)
          else if S = 'PUSH_B1' then
            PushData(R1)
          else if S = 'PUSH_B2' then
            PushData(R2)
          else if S = 'DROPBYTE' then
            PopData
          else
            AbortMsg('Can not execute primitive ' + S);
        end;
    else
      AbortMsg('Can not execute code type ' + CodeTypeToStr(C^.CodeType));
    end;
    C := C^.Next;
  end;
end;

begin
  StackP := -1;
end.
