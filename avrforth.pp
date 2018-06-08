{$I+,Q+,R+,S+}
uses
  Globals, CG, Classes, Utils, SysUtils, Strings;

var
  VarList: TList;
  
procedure PushFile(F: String);
begin
  Inc(FilesP);
  if FilesP > 10 then
    AbortMsg('Includes stack overflow');
  Assign(Files[FilesP], F);
  try
    Reset(Files[FilesP]);
  except
    on EInOutError do
      AbortMsg('Can not open input file ' + F);
  end;
  LastFileName := F;
  WriteLn(ListingFile);
end;

procedure PopFile;
var
  T: TextRec;
begin
  Close(Files[FilesP]);
  T := TextRec(Files[FilesP]);
  WriteLn('Compiled ', T.Name, '...');
  Dec(FilesP);
  if FilesP < 0 then
    AbortMsg('Includes stack underflow');
  if FilesP = 0 then
    LastFileName := ''
  else
    T := TextRec(Files[FilesP]);
  LastFileName := StrPas(T.Name);
end;

procedure ReadFile(var C: Char);
begin
  C := #0;
  if Eof(Files[FilesP]) then
    PopFile
  else
  begin
    Read(Files[FilesP], C);
    Write(ListingFile, C);
  end;
end;

procedure SetLastCode(C: PCodeList);
begin
  C^.Prev := LastCode;
  if LastCode = nil then
    LastWord^.Code := C
  else
    LastCode^.Next := C;
  LastCode := C;
end;

procedure PushBackwardBr;
var
  C: PCodeList;
begin
  if BrSP > MaxBranch then
    AbortMsg('Branch stack overflow');
  New(C);
  C^.Inst := 0;
  C^.CodeType := ctLabel;
  C^.Code := '';
  C^.Next := nil;
  C^.BrLabel := GetNextBrLabel;
  C^.AWord := nil;
  SetLastCode(C);
  BrStack[BrSP].C := C;
  BrStack[BrSP].W := LastWord;
  Inc(BrSP);
end;

procedure PopBr(var Br: TBr);
begin
  Dec(BrSP);
  if BrSP < 0 then
    AbortMsg('Branch stack underflow');
  Br.C := BrStack[BrSP].C;
  Br.W := BrStack[BrSP].W;
end;

procedure PushBr(Br: TBr);
begin
  if BrSP > MaxBranch then
    AbortMsg('Branch stack overflow');
  BrStack[BrSP] := Br;
  Inc(BrSP);
end;

procedure SwapBr;
var
  Br1, Br2: TBr;
begin
  PopBr(Br1);
  PopBr(Br2);
  PushBr(Br1);
  PushBr(Br2);
end;

procedure PushForwardBr;
var
  C: PCodeList;
begin
  if BrSP > MaxBranch then
    AbortMsg('Branch stack overflow');
  New(C);
  C^.Inst := 0;
  C^.CodeType := ctBranch;
  C^.Code := 'ERROR';
  C^.Next := nil;
  C^.AWord := nil;
  C^.BrLabel := GetNextBrLabel;
  SetLastCode(C);
  BrStack[BrSP].C := C;
  BrStack[BrSP].W := nil;
  Inc(BrSP);
end;

procedure CheckCompile(Mode: Boolean);
begin
  if InCompile = Mode then
  begin
    if Mode then
      AbortMsg('In not compilation mode only')
    else
      AbortMsg('In compilation mode only');
  end;
end;

function GetWord: String;
var
  C: Char;

procedure SkipWhite;
begin
  C := ' ';
  while (C <= #32) and (C <> #0) do
    ReadFile(C);
end;

begin
  Result := '';
  SkipWhite;
  if C = ' ' then
    exit;
  while (C > #32) and (C <> #0) do
  begin
    Result := Result + C;
    ReadFile(C);
  end;
end;

procedure AddToWord(W: PWord);
var
  P: PCodeList;
begin
  New(P);
  P^.Inst := 0;
  P^.Next := nil;
  P^.Code := W^.AsmName;
  P^.CodeType := ctWord;
  P^.BrLabel := 0;
  P^.AWord := W;
  SetLastCode(P);
  //if LastWord^.SwitchWord then
  //  AddPrim('RETURN');
end;

procedure AddInlineWord(W: PWord);
var
  P: PCodeList;
  T: PCodeList;
  I: Integer;
begin
  P := W^.Code;
  while P <> nil do
  begin
    P^.Inst := P^.Inst + 1;
    New(T);
    T^ := P^;
    T^.Next := nil;
    SetLastCode(T);
    P := P^.Next;
  end;
end;

procedure AddPrim(S: String);
var
  P: PCodeList;
begin
  New(P);
  P^.Inst := 0;
  P^.Next := nil;
  P^.Code := S;
  P^.CodeType := ctPrimitive;
  P^.BrLabel := 0;
  P^.AWord := nil;
  SetLastCode(P);
end;

procedure AddASM(S: String);
var
  P: PCodeList;
  
function ConvertAsm(S: String): String;
var
  i: Integer;
  T: String;
  Name: TName;
  W: PWord;
  C: Char;
begin
  T := '';
  i := 1;
  while i <= Length(S) do
  begin
    if S[i] in ['`', '{'] then
    begin
      C := S[i];
      Name := '';
      Inc(i);
      while not(S[i] in ['`', '}']) and (i <= Length(S)) do
      begin
        Name := Name + S[i];
        Inc(i);
      end;
      W := FindWord(Name);
      if W = nil then
        AbortMsg(Name + ' not found');
      case C of
        '`': begin
               if W^.WordType = wtConst then
                 T := T + W^.Code^.Code
               else
                 T := T + W^.AsmName;
               P^.AWord := W;
             end;
        '{': begin
               T := T + W^.CodeGen;
               W^.Used := true;
             end;  
      end;
    end
    else
      T := T + S[i];
    Inc(i);
  end;
  Result := T;
end;
  
begin
  New(P);
  P^.Inst := 0;
  P^.Next := nil;
  P^.AWord := nil;
  if S <> '' then
    if S[1] <> #9 then
      S := #9 + S;
  P^.Code := ConvertAsm(S);
  P^.CodeType := ctASM;
  P^.BrLabel := 0;
  SetLastCode(P);
end;

function NewDefinition(SwitchWord: Boolean): PWord;
var
  W: PWord;
  Name: TName;
  AsmName: String;
begin
  CheckCompile(true);
  Name := GetWord;
  if Name = '' then
    AbortMsg('Word name expected');
  AsmName := NameToAsm(Name, 'U_');
  W := FindWord(Name);
  if W <> nil then
  begin
    WarningMsg(Name + ' redefined');
    AsmName := AsmName + '_' + IntToStr(GetNextBrLabel);
  end;
  New(W);
  W^.CodeGen := '';
  W^.IsInit := false;
  W^.Used := false;
  W^.WordType := wtWord;
  W^.Name := Name;
  W^.SwitchWord := SwitchWord;
  W^.AsmName := AsmName;
  W^.Link := LastWord;
  W^.Immediate := false;
  W^.InlineFlag := false;
  W^.Smugde := true;
  W^.Code := nil;
  W^.InUse := false;
  W^.IsInt := false;
  InCompile := true;
  LastWord := W;
  LastCode := nil;
  Result := W;
  if SwitchWord then
  begin
    W := FindWord('(SWITCH)');
    if W = nil then
      AbortMsg('(SWITCH) not found');
    AddAsm('ldi'#9'ZL, low(' + AsmName + '_switch)');
    AddAsm('ldi'#9'ZH, high(' + AsmName + '_switch)');
    AddInlineWord(W);
    AddPrim('SWITCHLABEL');
  end;
end;

procedure EndDefinition;
begin
  CheckCompile(false);
  LastWord^.Smugde := false;
  LastCode := nil;
  InCompile := false;
end;

procedure ImmediateWord;
begin
  CheckCompile(true);
  LastWord^.Immediate := true;
end;

procedure InlineWord;
begin
  CheckCompile(true);
  LastWord^.InlineFlag := true;
end;

procedure AddIntLit(L: Integer; CodeType: TCodeType);
var
  P: PCodeList;
begin
  New(P);
  P^.Inst := 0;
  P^.Next := nil;
  P^.Code := IntToStr(L);
  P^.CodeType := CodeType;
  P^.BrLabel := 0;
  P^.AWord := nil;
  SetLastCode(P);
{
  if CodeType = ctIntLit then
    AddPrim('PUSH_W@')
  else
    AddPrim('PUSH_B@');
}
end;

function CheckNumberAndAdd(N: String): Boolean;
var
  V, Code: Integer;
  CodeType: TCodeType;
begin
  if N[Length(N)]='.' then
  begin
    Delete(N, Length(N), 1);
    CodeType := ctIntLit
  end
  else if N[Length(N)]='Q' then
  begin
    Delete(N, Length(N), 1);
    CodeType := ctQuadLit
  end
  else
    CodeType := ctByteLit;
  Code := 0;
  if N[1] = '$' then
    V := HexToInt(Copy(N, 2, 255))
  else
    Val(N, V, Code);
  if Code = 0 then
  begin
//    if ((CodeType = ctIntLit) and (V > $FFFF) or (V < ($FFFF * -1))) or
//       ((CodeType = ctByteLit) and (V > $FF) or (V < ($FF * -1))) then
//      AbortMsg('Bad numeric value');
    Result := true;
    if not InCompile then
      PushData(V)
    else
      AddIntLit(V, CodeType);
  end
  else
    Result := false;
end;

procedure ASMStr;
var
  C: Char;
  S: String;
begin
  C := ' ';
  S := '';
  while (C <> '"') and (C <> #0) do
  begin
    S := S + C;
    ReadFile(C);
  end;
  AddAsm(Trim(S));
end;

procedure SetMainWord;
begin
  CheckCompile(true);
  if MainWord <> nil then
    MainWord^.InUse := false;
  MainWord := LastWord;
  MainWord^.InUse := true;
end;

procedure GenWord(W: PWord);
var
  P: PCodeList;
  LastPushB0: Boolean;
  SkipCmd: Integer;

procedure SetDepth(var S: String);
var
  P: Integer;
begin
  if Depth = -1 then
    Depth := 0;
  P := Pos('@', S);
  if P > 0 then
    S[P] := Chr(Ord('0') + Depth);
end;

function Step1: Boolean;
var
  S0, S1, S2: String;
  Args: TStringList;
  I: Integer;
  ArgsType: String;

function CheckImmOrPush(S: String; T: Char): Boolean;
var
  V: Integer;
begin
  Result := true;
  if Pos('IMM_' + T, S) > 0 then
  begin
    Args.Add('I' + Copy(S, 8, 255));
    ArgsType := ArgsType + 'I';
  end
  else if Pos('PUSH_' + T, S) > 0 then
    Args.Add('R' + Copy(S, 7, 1))
  else
    Result := false;
end;

function DoCmdByte(T: String; S: String): Boolean;
var
  V1, V2: Integer;
  Swap: Boolean;
begin
  if ArgsType <> T then
  begin
    Result := false;
    exit;
  end;
  if ArgsType = 'II' then
  begin
    Result := true;
    Swap := false;
    V1 := StrToInt(Copy(Args[0], 2, 255));
    V2 := StrToInt(Copy(Args[1], 2, 255));
    if S = 'ADDBYTE' then
      V1 := V2 + V1
    else if S = 'SUBBYTE' then
    begin
      V1 := V2 - V1
    end
    else if S = 'MULBYTE' then
      V1 := V2 * V1
    else if S = 'SHRBYTE' then
      V1 := V2 shr V1
    else if S = 'SHLBYTE' then
      V1 := V2 shl V1
    else if S = 'ANDBYTE' then
      V1 := V2 and V1
    else if S = 'ORBYTE' then
      V1 := V2 or V1
    else if S = 'XORBYTE' then
      V1 := V2 xor V1
    else if S = 'SWAPBYTE' then
    begin
      LLL.Add('IMM_B0'#9 + IntToStr(V1));
      LLL.Add('IMM_B1'#9 + IntToStr(V2));
      Swap := true;
      SkipCmd := 2;
    end
    else
      Result := false;
    if Result and (not Swap) then
    begin
      LLL.Add('IMM_B*'#9 + IntToStr(V1));
    end;
  end
  else if ArgsType = 'I' then
  begin
    Result := true;
    V1 := StrToInt(Copy(Args[0], 2, 255));
    if S = 'NOTBYTE' then
      V1 := not V1
    else
      Result := false;
    if Result then
      LLL.Add('IMM_B*'#9 + IntToStr(V1));
  end
  else
    AbortMsg('Strange argument type [' + ArgsType + ']');
end;

function DoCmdWord(T: String; S: String): Boolean;
var
  V1, V2: Integer;
  Swap: Boolean;
begin
  if ArgsType <> T then
  begin
    Result := false;
    exit;
  end;
  if ArgsType = 'II' then
  begin
    Result := true;
    Swap := false;
    V1 := StrToInt(Copy(Args[0], 2, 255));
    V2 := StrToInt(Copy(Args[1], 2, 255));
    if S = 'ADDWORD' then
      V1 := V2 + V1
    else if S = 'SUBWORD' then
      V1 := V2 - V1
    else
      Result := false;
    if Result then
      LLL.Add('IMM_W*'#9 + IntToStr(V1));
  end
  else if ArgsType = 'I' then
  begin
    Result := true;
    V1 := StrToInt(Copy(Args[0], 2, 255));
    if S = 'NEGWORD' then
      V1 := -V1
    else
      Result := false;
    if Result then
      LLL.Add('IMM_W*'#9 + IntToStr(V1));
  end
  else
    AbortMsg('Strange argument type [' + ArgsType + ']');
end;

function DoCmdQuad(T: String; S: String): Boolean;
begin
  Result := false;
end;

begin
  Result := true;
  S0 := P^.Code;
  S1 := LLL[LLL.Count - 1];
  Args := TStringList.Create;
  ArgsType := '';
  if Pos('_LOOP_', S0) > 0 then
  begin
    S0 := S0 + IntToStr(LoopDepth);
    Result := false;
    P^.Code := S0;
  end;
  if Pos('2%', S0) > 0 then
  begin
    Delete(S0, 1, 2);
    S2 := LLL[LLL.Count - 2];
//    WriteLn(S2);
//    WriteLn(S1);
//    WriteLn(S0);
    if CheckImmOrPush(S1, 'B') then
    begin
      LLL.Delete(LLL.Count - 1);
      if CheckImmOrPush(S2, 'B') then
        LLL.Delete(LLL.Count - 1);
    end;
    if not DoCmdByte('II', S0) then
    begin
      S0 := S0 + #9 + IntToStr(Args.Count);
      for I := 0 to Args.Count - 1 do
        S0 := S0 + #9 + Args[I];
      P^.Code := S0;
      Result := false;
    end;
  end
  else if Pos('1%', S0) > 0 then
  begin
    Delete(S0, 1, 2);
    if CheckImmOrPush(S1, 'B') then
      LLL.Delete(LLL.Count - 1);
    if not DoCmdByte('I', S0) then
    begin
      S0 := S0 + #9 + IntToStr(Args.Count);
      for I := 0 to Args.Count - 1 do
        S0 := S0 + #9 + Args[I];
      P^.Code := S0;
      Result := false;
    end;
  end
  else if Pos('2&', S0) > 0 then
  begin
    Delete(S0, 1, 2);
    S2 := LLL[LLL.Count - 2];
    if CheckImmOrPush(S1, 'W') then
    begin
      LLL.Delete(LLL.Count - 1);
      if CheckImmOrPush(S2, 'W') then
        LLL.Delete(LLL.Count - 1);
    end;
    if not DoCmdWord('II', S0) then
    begin
      S0 := S0 + #9 + IntToStr(Args.Count);
      for I := 0 to Args.Count - 1 do
        S0 := S0 + #9 + Args[I];
      P^.Code := S0;
      Result := false;
    end;
  end
  else if Pos('1&', S0) > 0 then
  begin
    Delete(S0, 1, 2);
    if CheckImmOrPush(S1, 'W') then
      LLL.Delete(LLL.Count - 1);
    if not DoCmdWord('II', S0) then
    begin
      S0 := S0 + #9 + IntToStr(Args.Count);
      for I := 0 to Args.Count - 1 do
        S0 := S0 + #9 + Args[I];
      P^.Code := S0;
      Result := false;
    end;
  end
  else if Pos('2*', S0) > 0 then
  begin
    Delete(S0, 1, 2);
    S2 := LLL[LLL.Count - 2];
    if CheckImmOrPush(S1, 'W') then
    begin
      LLL.Delete(LLL.Count - 1);
      if CheckImmOrPush(S2, 'B') then
        LLL.Delete(LLL.Count - 1);
    end;
    S0 := S0 + #9 + IntToStr(Args.Count);
    for I := 0 to Args.Count - 1 do
      S0 := S0 + #9 + Args[I];
    P^.Code := S0 + #9;
    Result := false;
  end
  else if Pos('2#', S0) > 0 then
  begin
    Delete(S0, 1, 2);
    S2 := LLL[LLL.Count - 2];
    if CheckImmOrPush(S1, 'Q') then
    begin
      LLL.Delete(LLL.Count - 1);
      if CheckImmOrPush(S2, 'Q') then
        LLL.Delete(LLL.Count - 1);
    end;
    S0 := S0 + #9 + IntToStr(Args.Count);
    for I := 0 to Args.Count - 1 do
      S0 := S0 + #9 + Args[I];
    P^.Code := S0 + #9;
    Result := false;
  end
  else if Pos('2$', S0) > 0 then
  begin
    Delete(S0, 1, 2);
    S2 := LLL[LLL.Count - 2];
    if CheckImmOrPush(S1, 'W') then
    begin
      LLL.Delete(LLL.Count - 1);
      if CheckImmOrPush(S2, 'Q') then
        LLL.Delete(LLL.Count - 1);
    end;
    S0 := S0 + #9 + IntToStr(Args.Count);
    for I := 0 to Args.Count - 1 do
      S0 := S0 + #9 + Args[I];
    P^.Code := S0 + #9;
    Result := false;
  end
  else if (S0 = 'DROPBYTE') and (Pos('PUSH_B', S1) > 0) then
  begin
    LLL.Delete(LLL.Count - 1);
  end
  else if (S0 = 'DROPWORD') and (Pos('PUSH_W', S1) > 0) then
  begin
    LLL.Delete(LLL.Count - 1);
  end
  else if (S0 = 'DROPQUAD') and (Pos('PUSH_Q', S1) > 0) then
  begin
    LLL.Delete(LLL.Count - 1);
  end
  else if ((S1 = 'PUSH_B0') and (S0 = 'TOP_B0')) or
    ((S1 = 'PUSH_B1') and (S0 = 'TOP_B1')) or
    ((S1 = 'PUSH_B2') and (S0 = 'TOP_B2')) then
  begin
    //LLL.Delete(LLL.Count - 1);
    //Result := false;
  end
  else if ((S1 = 'PUSH_W0') and (S0 = 'TOP_W0')) or
    ((S1 = 'PUSH_W1') and (S0 = 'TOP_W1')) or
    ((S1 = 'PUSH_W2') and (S0 = 'TOP_W2')) then
  begin
    //LLL.Delete(LLL.Count - 1);
    //Result := false;
  end
  else if ((S1 = 'PUSH_B0') and (S0 = 'POP_B0')) or
    ((S1 = 'PUSH_B1') and (S0 = 'POP_B1')) or
    ((S1 = 'PUSH_B2') and (S0 = 'POP_B2')) then
  begin
    LLL.Delete(LLL.Count - 1);
  end
  else if ((S1 = 'PUSH_W0') and (S0 = 'POP_W0')) or
    ((S1 = 'PUSH_W1') and (S0 = 'POP_W1')) or
    ((S1 = 'PUSH_W2') and (S0 = 'POP_W2')) then
  begin
    LLL.Delete(LLL.Count - 1);
  end
  else if ((S1 = 'PUSH_Q0') and (S0 = 'POP_Q0')) or
    ((S1 = 'PUSH_Q1') and (S0 = 'POP_Q1')) or
    ((S1 = 'PUSH_Q2') and (S0 = 'POP_Q2')) then
  begin
    LLL.Delete(LLL.Count - 1);
  end
  else if (Pos('TOP_', S0) > 0) and (Pos('IMM_', S1) > 0) then
  begin
    Result := (S0[5] = S1[5]) and (S0[6] = S1[6]);
  end
  else if (Pos('PUSH_B', S0) > 0) and (Pos('IMM_B*', S1) > 0) then
  begin
    S1[6] := S0[7];
    LLL[LLL.Count - 1] := S1;
  end
  else if (Pos('PUSH_W', S0) > 0) and (Pos('IMM_W*', S1) > 0) then
  begin
    S1[6] := S0[7];
    LLL[LLL.Count - 1] := S1;
  end
  else if (Pos('PUSH_Q', S0) > 0) and (Pos('IMM_Q*', S1) > 0) then
  begin
    S1[6] := S0[7];
    LLL[LLL.Count - 1] := S1;
  end
  else if (Pos('PUSH_', S0) > 0) and (Pos('IMM_', S1) > 0) then
  begin
    if (S0[6] = S1[5]) and (S0[7] = S1[6]) then
    begin
      P^.Code := S1;
      Result := false;
    end;
  end
  else if S0 = 'STARTDO' then
  begin
    Inc(LoopDepth);
    if LoopDepth > 2 then
      AbortMsg('DO/LOOP too deep');
  end
  else if S0 = 'ENDDO' then
  begin
    Dec(LoopDepth);
    if LoopDepth < -1 then
      AbortMsg('DO/LOOP depth error');
  end
  else
    Result := false;
  Args.Free;
end;

procedure IncDepth;
begin
  Inc(Depth);
  if Depth > 2 then
    Depth := 2;
end;

begin
  if W = nil then
    AbortMsg('Word pointer is nil');
  LLL.Add('STARTWORD'#9 + W^.AsmName);
  if W^.IsInt then
  begin
    LLL.Add('PUSH_SREG');
  end;
  P := W^.Code;
  SkipCmd := 0;
  while P <> nil do
  begin
    if SkipCmd > 0 then
    begin
      P^.CodeType := ctNone;
      Dec(SkipCmd);
    end;
    case P^.CodeType of
      ctNone: ;
      ctPrimitive:
        begin
          LastPushB0 := Pos('PUSH_B0', P^.Code) > 0;
          if Pos('TOP_', P^.Code) > 0 then
            IncDepth;
          if Pos('@', P^.Code) > 0 then
            SetDepth(P^.Code)
          else
          begin
            if LastPushB0 then
              Depth := 0
            else
              Depth := -1;
          end;
          if not Step1 then
            LLL.Add(P^.Code);
        end;
      ctIntLit:
        begin
          IncDepth;
          LLL.Add('IMM_W' + IntToStr(Depth) + #9 + P^.Code);
        end;
      ctQuadLit:
        begin
          IncDepth;
          LLL.Add('IMM_Q' + IntToStr(Depth) + #9 + P^.Code);
        end;
      ctByteLit:
        begin
          IncDepth;
          LLL.Add('IMM_B' + IntToStr(Depth) + #9 + P^.Code);
        end;
      ctVar:
        begin
          IncDepth;
          LLL.Add('IMM_W' + IntToStr(Depth) + #9 + P^.Code);
          P^.AWord^.Used := true;
        end;
      ctASM:
        begin
          LLL.Add('ASM' + ConvertAsm(P^.Code))
        end;
      ctLabel:
        begin
          LLL.Add('LABEL'#9 + 'B_' + IntToStr(P^.BrLabel) + '_' + IntToStr(P^.Inst));
        end;
      ctBranch:
        begin
          LLL.Add('BRANCH'#9 + P^.Code + '_' + IntToStr(P^.Inst));
        end;
      ctWord:
        if W^.SwitchWord then
          LLL.Add('ASM'#9'jmp'#9 + P^.Code)
        else
        begin
          LLL.Add('CALL'#9 + P^.Code);
          P^.AWord^.InUse := true;
        end;
    else
      AbortMsg('Bad code type ' + CodeTypeToStr(P^.CodeType));
    end;
    P := P^.Next;
  end;
  LLL.Add('EXITLABEL'#9 + W^.AsmName + '_exit');
  if W^.IsInt then
    LLL.Add('RETINT')
  else
    LLL.Add('RETURN');
end;

procedure SetInUse(AWord: PWord);
var
  C: PCodeList;
begin
  C := AWord^.Code;
  while C <> nil do
  begin
    if C^.AWord <> nil then
    begin
      C^.AWord^.InUse := true;
      C^.AWord^.Used := false;
      if C^.AWord^.WordType <> wtVar then
        SetInUse(C^.AWord);
    end;
    C := C^.Next;
  end;
end;

function GetConst(Name: String): Integer;
var
  W: PWord;
begin
  W := FindWord(Name);
  if W = nil then
    AbortMsg(Name + ' not defined');
  if not (W^.Code^.CodeType in [ctByteLit, ctIntLit]) then
    AbortMsg('Incorrect ' + Name + ' definition');
  Result := StrToInt(W^.Code^.Code);
end;

procedure GenerateCode;
var
  AWord: PWord;
  I, J: Integer;
  S: String;
begin
  WriteLn('Determines used words...');
  if MainWord <> nil then
    SetInUse(MainWord);
  WriteLn('Generate pre-codes');
  Listing := TStringList.Create;
  LLL := TStringList.Create;
  Listing.Add(#9'.nolist');
  if AsmInclude <> '' then
    Listing.Add(#9'.include'#9'"' + AsmInclude + '"');
  Listing.Add(#9'.include'#9'"avrforth.inc"');
  Listing.Add(#9'.list');
  Listing.Add(#9'.org'#9'0');
  Listing.Add(#9'jmp'#9'sys_reset');
  for i := 1 to IntP do
    if IntTable[i].AWord <> nil then
    begin
      Listing.Add(#9'jmp'#9 + IntTable[i].AWord^.AsmName);
      SetInUse(IntTable[i].AWord);
    end
    else
      Listing.Add(#9'jmp'#9'sys_bad_int');
  Listing.Add('sys_reset:');
  Listing.Add(#9'ldi'#9'temp, low(' + IntToStr(GetConst('RAMEND')) + ')');
  Listing.Add(#9'out'#9'SPL, temp');
  Listing.Add(#9'ldi'#9'temp, high(' + IntToStr(GetConst('RAMEND')) + ')');
  Listing.Add(#9'out'#9'SPH, temp');
  Listing.Add(#9'ldi'#9'YL, low(' +
    IntToStr(GetConst('SRAM_START') + GetConst('STACK_SIZE')) + ')');
  Listing.Add(#9'ldi'#9'YH, high(' +
    IntToStr(GetConst('SRAM_START') + GetConst('STACK_SIZE')) + ')');
  Listing.Add(#9'clr'#9'zero_reg');
  Listing.Add(#9'ldi'#9'temp, 1');
  Listing.Add(#9'mov'#9'one_reg, temp');
  Listing.Add(#9'ldi'#9'temp, 2');
  Listing.Add(#9'mov'#9'two_reg, temp');
  Listing.Add(#9'ldi'#9'temp, $ff');
  Listing.Add(#9'mov'#9'ff_reg, temp');
  for I := 0 to InitList.Count - 1 do
    Listing.Add(#9'call'#9 + InitList[I]);
  if MainWord <> nil then
    Listing.Add(#9'call'#9 + MainWord^.AsmName);
  Listing.Add('sys_forever:');
  Listing.Add(#9'rjmp'#9'sys_forever');
  Listing.Add('sys_bad_int:');
  Listing.Add(#9'jmp'#9'sys_reset');
  AWord := LastWord;
  while AWord <> nil do
  begin
    if (not AWord^.Smugde) and (AWord^.InUse) and (not AWord^.InlineFlag) and
       (AWord^.CodeGen = '') then
    begin
      GenWord(AWord);
      AWord^.InUse := false;
      AWord^.Used := true;
    end;
    AWord := AWord^.Link;
  end;
  LLL.SaveToFile(ChangeFileExt(MainOutFile, '.npre'));
  GenAsm;
  AWord := LastWord;
  while AWord <> nil do
  begin
    if (AWord^.InUse) and (AWord^.CodeGen <> '') then
    begin
      Listing.Add(AWord^.AsmName + ':');
      Listing.Add(ConvertAsm(AWord^.CodeGen));
      Listing.Add(#9'ret');
      AWord^.Used := true;
    end;
    AWord := AWord^.Link;
  end;
  if PStr.Count > 0 then
    Listing.Add(#9'.org'#9 + IntToStr(StrP div 2));
  for I := 0 to PStr.Count - 1 do
  begin
    Listing.Add('; ' + PStr[I]);
    S := #9'.db'#9;
    for J := 1 to Length(PStr[I]) do
    begin
      S := S + Format('%3d', [Ord(PStr[I][J])]);
      if J mod 12 = 0 then
      begin
        Listing.Add(S);
        if J <> Length(PStr[I]) then
          S := #9'.db'#9
        else
          S := '';
      end;
      if (J <> Length(PStr[I])) and (J mod 12 <> 0) then
        S := S + ', ';
    end;
    if S <> '' then
      Listing.Add(S);
  end;
  Listing.Add(#9'.dseg');
  Listing.Add(#9'.org'#9 + IntToStr(GetConst('SRAM_START')));
  Listing.Add('sys_vars_start:');
  Listing.Add('sys_data_stack:');
  Listing.Add(#9'.byte'#9 + IntToStr(GetConst('STACK_SIZE')));
  for i := 0 to VarList.Count - 1 do
  begin
    AWord := PWord(VarList[i]);
    Listing.Add(AWord^.AsmName + ':'#9#9 + '; ' + AWord^.Code^.Code);
    Listing.Add(#9'.byte'#9 + IntToStr(AWord^.Size));
  end;
  Listing.Add('sys_vars_end:');
  Listing.SaveToFile(MainOutFile);
  LLL.SaveToFile(ChangeFileExt(MainOutFile, '.pre'));
end;

procedure MarkCode(Back: Boolean);
begin
  CheckCompile(false);
  if Back then
    PushBackwardBr
  else
    PushForwardBr;
end;

procedure ResolveCode(Back: Boolean);
var
  Br: TBr;
  C, P: PCodeList;
begin
  CheckCompile(false);
  PopBr(Br);
  if Br.C = nil then
    AbortMsg('Branch stack destroyed');
  New(C);
  C^.Inst := 0;
  if Back then
  begin
    C^.CodeType := ctBranch;
    C^.Code := 'B_' + IntToStr(Br.C^.BrLabel);
    C^.Next := nil;
    C^.AWord := nil;
  end
  else
  begin
    C^.CodeType := ctLabel;
    C^.Code := '';
    C^.Next := nil;
    C^.BrLabel := BR.C^.BrLabel;
    Br.C^.Code := 'B_' + IntToStr(C^.BrLabel);
    C^.AWord := nil;
  end;
  SetLastCode(C);
end;

procedure DoUntil;
var
  W: PWord;
begin
  W := FindWord('(UNTIL)');
  if W = nil then
    AbortMsg('(?BRANCH) not found');
  AddInlineWord(W);
  ResolveCode(true);
end;

procedure DoUntilBitSet;
var
  W: PWord;
begin
  W := FindWord('(UNTIL-BIT-SET)');
  if W = nil then
    AbortMsg('(UNTIL-BIT-SET) not found');
  AddInlineWord(W);
  ResolveCode(true);
end;

procedure DoUntilBitClear;
var
  W: PWord;
begin
  W := FindWord('(UNTIL-BIT-CLEAR)');
  if W = nil then
    AbortMsg('(UNTIL-BIT-CLEAR) not found');
  AddInlineWord(W);
  ResolveCode(true);
end;

procedure DoIf;
var
  W: PWord;
begin
  W := FindWord('(?BRANCH)');
  if W = nil then
    AbortMsg('(?BRANCH) not found');
  AddInlineWord(W);
  MarkCode(false);
end;

procedure DoWhile;
var
  W: PWord;
begin
  MarkCode(false);
end;

procedure DoRepeat;
begin
  SwapBr;
  ResolveCode(true);
  ResolveCode(false);
end;

procedure DoElse;
begin
  MarkCode(false);
  SwapBr;
  ResolveCode(false);
end;

procedure DoDo;
var
  W: PWord;
begin
  W := FindWord('(DO)');
  if W = nil then
    AbortMsg('(DO) not found');
  AddInlineWord(W);
  MarkCode(true);
end;

procedure DoLoop;
var
  W: PWord;
begin
  W := FindWord('(LOOP)');
  if W = nil then
    AbortMsg('(LOOP) not found');
  AddInlineWord(W);
  ResolveCode(true);
  W := FindWord('(LOOP-CLEAN)');
  if W = nil then
    AbortMsg('(LOOP-CLEAN) not found');
  AddInlineWord(W);
end;

procedure DoPlusLoop;
var
  W: PWord;
begin
  W := FindWord('(+LOOP)');
  if W = nil then
    AbortMsg('(+LOOP) not found');
  AddInlineWord(W);
  ResolveCode(true);
  W := FindWord('(LOOP-CLEAN)');
  if W = nil then
    AbortMsg('(LOOP-CLEAN) not found');
  AddInlineWord(W);
end;

procedure SkipComments;
var
  C: Char;
begin
  C := ' ';
  while (C <> ')') and (C <> #0) do
    ReadFile(C);
end;

procedure DefVar(Size: Integer);
var
  Name: TName;
  W: PWord;
begin
  if DP = -1 then
    DP := GetConst('SRAM_START') + GetConst('STACK_SIZE');
  CheckCompile(true);
  Name := GetWord;
  if Name = '' then
    AbortMsg('Variable name expected');
  New(W);
  if FindWord(Name) <> nil then
    WarningMsg(Name + ' redefined');
  W^.CodeGen := '';
  W^.Used := false;
  W^.WordType := wtVar;
  W^.IsInit := false;
  W^.SwitchWord := false;
  W^.Name := Name;
  W^.AsmName := NameToAsm(Name, 'U_');
  W^.Link := LastWord;
  W^.Immediate := false;
  W^.InlineFlag := true;
  W^.Smugde := false;
  W^.Code := nil;
  W^.InUse := false;
  W^.IsInt := false;
  W^.Size := Size;
  LastWord := W;
  LastCode := nil;
  AddIntLit(DP, ctIntLit);
//  AddIntLit(Size, ctIntLit);
  LastCode^.CodeType := ctVar;
  LastCode^.AWord := W;
  Inc(DP, Size);
  InCompile := true;
  EndDefinition;
  VarList.Add(LastWord);
end;

procedure DoAllocate;
begin
  CheckCompile(true);
  DefVar(PopData);
end;

procedure DefineInterrupt;
var
  Int: TInt;
  Name: TName;
begin
  Inc(IntP);
  if IntP > MaxInts then
    AbortMsg('Too many interrupts');
  CheckCompile(true);
  Name := GetWord;
  if Name = '' then
    AbortMsg('Interrupt name expected');
  Int.Name := Name;
  Int.AWord := nil;
  IntTable[IntP] := Int;
end;

procedure InterruptWord;
var
  i: Integer;
  Name: TName;
  IntNo: Integer;
begin
  CheckCompile(true);
  if LastWord^.InlineFlag then
    AbortMsg('Inline word can not be interrupt');
  Name := GetWord;
  if Name = '' then
    AbortMsg('Interrupt name expected');
  IntNo := 0;
  for i := 1 to IntP do
  begin
    if IntTable[i].Name = Name then
    begin
      IntNo := i;
      break;
    end;
  end;
  if IntNo = 0 then
    AbortMsg('Interrupt definition not found');
  if IntTable[IntNo].AWord <> nil then
    IntTable[IntNo].AWord^.InUse := false;
  IntTable[IntNo].AWord := LastWord;
  LastWord^.InUse := true;
  LastWord^.IsInt := true;
end;

procedure DoInclude(T: Char);
var
  C: Char;
  F: String;
begin
  ReadFile(C);
  F := '';
  while (C <> T) and (C <> #0) do
  begin
    F := F + C;
    ReadFile(C);
  end;
  if T = '>' then
    F := FullPathPrefix + 'system\' + F;
  if Included.IndexOf(F) = -1 then
  begin
    PushFile(F);
    Included.Add(F);
  end
  //else
  //  WriteLn(F, ' already compiled...');
end;

procedure SetAsmInclude;
var
  C: Char;
  F: String;
begin
  ReadFile(C);
  F := '';
  while (C <> '"') and (C <> #0) do
  begin
    F := F + C;
    ReadFile(C);
  end;
  AsmInclude := F;
end;

procedure DefString(T: Char);
var
  C: Char;
  S: String;
  W: PWord;
  L: Integer;
begin
  if StrP = -1 then
  begin
    StrP := GetConst('FLASHEND') * 2;
  end;
  CheckCompile(true);
  ReadFile(C);
  S := '';
  while (C <> T) and (C <> #0) do
  begin
    S := S + C;
    ReadFile(C);
  end;
  L := Length(S);
  if Odd(L) then
    S := S + #0;
  Dec(StrP, Length(S));
  Name := GetWord;
  if Name = '' then
    AbortMsg('String name expected');
  New(W);
  if FindWord(Name) <> nil then
    WarningMsg(Name + ' redefined');
  W^.CodeGen := '';
  W^.Used := false;
  W^.WordType := wtStr;
  W^.IsInit := false;
  W^.SwitchWord := false;
  W^.Name := Name;
  W^.AsmName := NameToAsm(Name, 'U_');
  W^.Link := LastWord;
  W^.Immediate := false;
  W^.InlineFlag := true;
  W^.Smugde := false;
  W^.Code := nil;
  W^.InUse := false;
  W^.IsInt := false;
  W^.Size := Length(S);
  LastWord := W;
  LastCode := nil;
  AddIntLit(L, ctByteLit);
  AddIntLit(StrP, ctIntLit);
  PStr.Add(S);
  InCompile := true;
  EndDefinition;
end;

procedure ParseParams;
var
  i: Integer;
  S: String;
begin
  Assign(ListingFile, 'avrforth.lst');
  Rewrite(ListingFile);
  MainInFile := '';
  MainOutFile := '';
  i := 1;
  while i <= ParamCount do
  begin
    S := ParamStr(i);
    if S = '-no-inline' then
      DoInline := false
    else if S = '-out' then
    begin
      MainOutFile := ParamStr(i + 1);
      if MainOutFile = '' then
        AbortMsg('Output file name expected');
      Inc(i);
    end
    else
      MainInFile := S;
    Inc(i);
  end;
  if MainInFile = '' then
  begin
    WriteLn;
    WriteLn('Usage: ', ParamStr(0), ' <input file> [params]');
    WriteLn;
    WriteLn('Where [params] is:');
    WriteLn(#9'-no-inline');
    WriteLn(#9'-out <output file>');
    WriteLn;
    AbortMsg('File name expected')
  end
  else
  begin
    PushFile(MainInFile);
    if MainOutFile = '' then
      MainOutFile := ChangeFileExt(MainInFile, '.asm');
  end;
end;

procedure DoPrim;
var
  Name: TName;
begin
  CheckCompile(false);
  Name := GetWord;
  if Name = '' then
    AbortMsg('Primitive name expected');
  AddPrim(Name);
end;

procedure MakeCodeGen;
var
  C: Char;
  S: String;
  W: PWord;
  Name: TName;
begin
  CheckCompile(true);
  ReadFile(C);
  S := '';
  while (C <> '"') and (C <> #0) do
  begin
    S := S + C;
    ReadFile(C);
  end;
  Name := GetWord;
  if Name = '' then
    AbortMsg('String name expected');
  New(W);
  if FindWord(Name) <> nil then
    WarningMsg(Name + ' redefined');
  W^.CodeGen := S;
  W^.Used := false;
  W^.WordType := wtCG;
  W^.IsInit := false;
  W^.Name := Name;
  W^.SwitchWord := true;
  W^.AsmName := NameToAsm(Name, 'SYS_');
  W^.Link := LastWord;
  W^.Immediate := false;
  W^.InlineFlag := false;
  W^.Smugde := false;
  W^.Code := nil;
  W^.InUse := false;
  W^.IsInt := false;
  LastWord := W;
  LastCode := nil;
  InCompile := true;
  EndDefinition;
end;

procedure DoInit;
begin
  CheckCompile(true);
  if LastWord = nil then
    exit;
  LastWord^.IsInit := true;
  LastWord^.InUse := true;
  SetInUse(LastWord);
  InitList.Add(LastWord^.AsmName);
end;

procedure DoCharLit;
var
  C: Char;
begin
  CheckCompile(false);
  ReadFile(C);
  if C = #0 then
    AbortMsg('Character expected');
  AddIntLit(Ord(C), ctByteLit);
end;

procedure GetWordAddr;
var
  Name: TName;
  W: PWord;
begin
  CheckCompile(false);
  Name := GetWord;
  if Name = '' then
    AbortMsg('Word name expected');
  W := FindWord(Name);
  if W = nil then
    AbortMsg(Name + ' not found');
  if W^.InlineFlag then
    AbortMsg('Can not use inline words with '' word');
  AddAsm('ldi'#9'temp0l, low(' + W^.AsmName + ')');
  LastCode^.AWord := W;
  AddAsm('ldi'#9'temp0h, high(' + W^.AsmName + ')');
  AddPrim('PUSH_W0');
  W^.InUse := true;
end;

procedure DefConst(T: Char);
begin
  NewDefinition(false);
  case T of
    'S': AddIntLit(PopData, ctByteLit);
    'D': AddIntLit(PopData, ctIntLit);
    'Q': AddIntLit(PopData, ctQuadLit);
  end;
  LastWord^.InlineFlag := true;
  LastWord^.WordType := wtConst;
  EndDefinition;
end;

procedure GenerateInfo;
var
  W: PWord;
  S: String;
  RAMUsed: Integer;
  WordsCount: Integer;
  UsedWords: Integer;
  StrCount: Integer;
  CGCount: Integer;
  CGUsed: Integer;
  
function BoolToStr(B: Boolean): String;
begin
  if B then
    Result := 'TRUE'
  else
    Result := 'FALSE';
end;
  
begin
  RAMUsed := 0;
  WordsCount := 0;
  UsedWords := 0;
  StrCount := 0;
  CGCount := 0;
  CGUsed := 0;
  W := LastWord;
  while W <> nil do
  begin
    S := '';
    case W^.WordType of
      wtWord: begin Inc(WordsCount); if W^.Used then Inc(UsedWords); end;
      wtVar: Inc(RAMUsed, W^.Size);
      wtStr: Inc(StrCount, W^.Size);
      wtCG: begin Inc(CGCount); if W^.Used then Inc(CGUsed); end;
    end;
    if S <> '' then
      WriteLn(S);
    W := W^.Link;
  end;
  RAMUsed := RAMUsed + GetConst('STACK_SIZE');
  WriteLn;
  WriteLn('Statistics:');
  WriteLn(Format('   Words used: %5d of %5d', [UsedWords, WordsCount]));
  WriteLn(Format('     RAM used: %5d of %5d bytes, include stack %d bytes', 
    [RAMUsed, GetConst('SRAM_SIZE'), GetConst('STACK_SIZE')]));
  WriteLn(Format(' String space: %5d bytes', [StrCount]));
  WriteLn(Format('Godegen words: %5d of %5d', [CGUsed, CGCount]));
  WriteLn;
end;

procedure PrintDataStack;
var
  I: Integer;
begin
  if StackP < 0 then
    exit;
  Write('Data stack: ');
  for I := 0 to StackP do
    Write(DataStack[I], ' ');
  WriteLn;
end;

var
  AWord: PWord;

begin
  WriteLn('AVRFORTH');
  WriteLn('Copyright (C) 2005 Ruslan Stepanenko');
  WriteLn;
  WriteLn('This program is free software; you can redistribute it and/or modify');
  WriteLn('it under the terms of the GNU General Public License as published by');
  WriteLn('the Free Software Foundation; either version 2 of the License, or');
  WriteLn('(at your option) any later version.');
  WriteLn;
  WriteLn('This program is distributed in the hope that it will be useful,');
  WriteLn('but WITHOUT ANY WARRANTY; without even the implied warranty of');
  WriteLn('MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the');
  WriteLn('GNU General Public License for more details.');
  WriteLn;
  WriteLn('You should have received a copy of the GNU General Public License');
  WriteLn('along with this program; if not, write to the Free Software');
  WriteLn('Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA');
  WriteLn;
  StackP := -1;
  MainWord := nil;
  LastWord := nil;
  LastCode := nil;
  LastFileName := '';
  AsmInclude := '';
  Included := TStringList.Create;
  IntP := 0;
  FilesP := 0;
  InCompile := false;
  LastWord := nil;
  BrSP := 1;
  GlBrLabel := 0;
  LoopDepth := -1;
  DP := -1;
  StrP := -1;
  PStr := TStringList.Create;
  InitList := TStringList.Create;
  VarList := TList.Create;
  DoInline := true;
  Depth := -1;
  FullPathPrefix :=
    ExtractRelativePath(GetCurrentDir + '\test.f', ExtractFilePath(ParamStr(0)));
  ParseParams;
  PushFile(FullPathPrefix + 'avrforth.f');
  while FilesP >= 1 do
  begin
    Name := GetWord;
    if Name = '' then
      continue;
    NotFound := false;
    case Name[1] of
      '+': if Name = '+LOOP' then
             DoPlusLoop
           else
             NotFound := true;
      ':': if Name = ':' then
             NewDefinition(false)
           else if Name = '::' then
             NewDefinition(true)
           else
             NotFound := true;
      ';': if Name = ';' then
             EndDefinition
           else
             NotFound := true;
      '(': if Name = '(' then
             SkipComments
           else
             NotFound := true;
      '''': if Name = '''' then
             GetWordAddr
           else
             NotFound := true;
      'A': if Name = 'A"' then
             ASMStr
           else if Name = 'ALLOCATE' then
             DoAllocate
           else if Name = 'ASM-INCLUDE"' then
             SetAsmInclude
           else
             NotFound := true;
      'B': if Name = 'BEGIN' then
             MarkCode(true)
           else
             NotFound := true;
      'C': if Name = 'CG"' then
             MakeCodeGen
           else if Name = 'CONSTANT' then
             DefConst('S')
           else if Name = 'C"' then
             DoCharLit
           else
             NotFound := true;
      'D': if Name = 'DO' then
             DoDo
           else if Name = 'DVARIABLE' then
             DefVar(2)
           else if Name = 'DCONSTANT' then
             DefConst('D')
           else if Name = 'DEFINE-INTERRUPT' then
             DefineInterrupt
           else
             NotFound := true;
      'E': if Name = 'ELSE' then
             DoElse
           else
             NotFound := true;
      'I': if Name = 'IMMEDIATE' then
             ImmediateWord
           else if Name = 'INLINE' then
             begin
               if DoInline then
                 InlineWord;
             end
           else if Name = 'INLINE-FOREVER' then
             InlineWord
           else if Name = 'IF' then
             DoIf
           else if Name = 'INTERRUPT' then
             InterruptWord
           else if Name = 'INCLUDE"' then
             DoInclude('"')
           else if Name = 'INCLUDE<' then
             DoInclude('>')
           else if Name = 'INIT' then
             DoInit
           else
             NotFound := true;
      'L': if Name = 'LOOP' then
             DoLoop
           else
             NotFound := true;
      'M': if Name = 'MAIN' then
             SetMainWord
           else
             NotFound := true;
      'P': if Name = 'PSTRING"' then
             DefString('"')
           else if Name = 'PSTRING''' then
             DefString('''')
           else if Name = 'PRIM' then
             DoPrim
           else
             NotFound := true;
      'Q': if Name = 'QVARIABLE' then
             DefVar(4)
           else if Name = 'QCONSTANT' then
             DefConst('Q')
           else
             NotFound := true;
      'R': if Name = 'REPEAT' then
             DoRepeat
           else
             NotFound := true;
      'T': if Name = 'THEN' then
             ResolveCode(false)
           else
             NotFound := true;
      'U': if Name = 'UNTIL' then
             DoUntil
           else if Name = 'UNTIL-BIT-SET' then
             DoUntilBitSet
           else if Name = 'UNTIL-BIT-CLEAR' then
             DoUntilBitClear
           else
             NotFound := true;
      'V': if Name = 'VARIABLE' then
             DefVar(1)
           else
             NotFound := true;
      'W': if Name = 'WHILE' then
             DoWhile
           else
             NotFound := true;
      else
        NotFound := true;
    end;
    if NotFound then
    begin
      //if not InCompile then
      //  AbortMsg(Name + ' not defined');
      AWord := FindWord(Name);
      if AWord = nil then
      begin
        if inCompile then
        begin
          if not CheckNumberAndAdd(Name) then
            AbortMsg(Name + ' not defined')
          else
          begin
            if (LastWord <> nil) then
              if (LastWord^.SwitchWord) then
              AbortMsg('Only words in switch')
          end
        end
        else
        begin
          if not CheckNumberAndAdd(Name) then
            AbortMsg(Name + ' not found');
        end;
      end
      else
      begin
        if inCompile then
        begin
          if AWord^.InlineFlag then
          begin
            if LastWord^.SwitchWord then
              AbortMsg('Can not add inline words in switch');
            AddInlineWord(AWord)
          end
          else
            AddToWord(AWord);
        end
        else
          Execute(AWord);
      end;
    end;
  end;
  GenerateCode;
  GenerateInfo;
  PrintDataStack;
  Close(ListingFile);
  WriteLn('All done.');
end.
