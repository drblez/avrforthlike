unit CG;

interface

procedure GenAsm;

implementation

uses
  Globals, Utils, Classes, SysUtils;

procedure GenAsm;
var
  I, J: Integer;
  S: String;
  Args: TStringList;
  Cmd: String;
  RH, RL, TL: String;
  ArgsType: String;
  AddArg: Boolean;
  CGWordName: String;
  W: PWord;
  NeedExitLabel: Boolean;
  WordLabel: String;

procedure GetArgs;
var
  I: Integer;
  T: String;
  A: String;
begin
  Args.Clear;
  if AddArg then
    I := 3
  else
    I := 2;
  T := Copy(S, Length(Cmd) + I, Length(S));
  ArgsType := '';
  CGWordName := '';
  if Length(T) = 0 then
    exit;
  if T[Length(T)] <> #9 then
    T := T + #9;
  if not(T[1] in ['0'..'9']) then
    exit;
  Delete(T, 1, 2);
  I := 1;
  A := '';
  ArgsType := '';
  while I <= Length(T) do
  begin
    if (T[I] = #9) then
    begin
      ArgsType := ArgsType + A[1];
      Delete(A, 1, 1);
      Args.Add(A);
      A := '';
    end
    else
      A := A + T[I];
    Inc(I);
  end;
  CGWordName := '(' + Cmd + ':' + ArgsType + ':';
  if (ArgsType = 'I') or (ArgsType = 'IR') or (ArgsType = 'II') then
  begin
    if (Args[0] = '0') or (Args[0] = '1') or (Args[0] = '2') or (Args[0] = '255') then
      CGWordName := CGWordName + Args[0];
  end
  else if (ArgsType = 'R') or (ArgsType = 'RI') or (ArgsType = 'RR') then
  begin
    if Args[0] = '0' then
      CgWordName := CGWordName + Args[0];
  end;
  CGWordName := CGWordName + ':';
  if (ArgsType = 'II') or (ArgsType = 'RI') then
  begin
    if (Args[1] = '0') or (Args[1] = '1') or (Args[1] = '2') then
      CGWordName := CGWordName + Args[1];
  end
  else if (ArgsType = 'IR') or (ArgsType = 'RR') then
  begin
    if (Args[1] = '0') then
      CGWordName := CGWordName + Args[1];
  end;
  CGWordName := CGWordName + ':)';
end;

procedure AsmCmd(Cmd: String; Args: String);
begin
  Listing.Add(#9 + Cmd + #9 + Args);
end;

procedure PopByte(R: Char);
var
  RL: String;
begin
  RL := 'temp' + R + 'l';
  AsmCmd('ld', RL + ', Y+');
end;

procedure BadArgType;
begin
  AsmCmd('.error', '"Bad argument type [' + S + '], [' + ArgsType + ']"');
  WarningMsg('Bad argument type [' + S + '], [' + ArgsType + ']');
end;

function ReplaceArgs(S: String): String;
var
  T: String;
  Idx: Integer;
  i: Integer;
  SysCall: String;
  W: PWord;
begin
  T := '';
  i := 1;
  while i <= Length(S) do
  begin
    if S[i] = '%' then
    begin
      Idx := Ord(S[i + 1]) - 48;
      if Idx > Args.Count - 1 then
        T := T + '*** BAD ARG NO ***'
      else
        T := T + Args[Idx];
      Inc(i);
    end
    else if S[i] = '`' then
    begin
      SysCall := '';
      Inc(i);
      while (S[i] <> '`') and (i <= Length(S)) do
      begin
        SysCall := SysCall + S[i];
        Inc(i);
      end;
      W := FindWord(SysCall);
      if W = nil then
        T := T + '*** SYSCALL ' + SysCall + ' NOT DEFINED'
      else
      begin
        T := T + W^.AsmName;
        W^.InUse := true;
      end;
    end
    else
      T := T + S[i];
    Inc(i);
  end;
  Result := T;
end;

procedure CheckImms;
var
  I: Integer;
  S, S1: String;
begin
  I := 0;
  while I <= LLL.Count - 1 do
  begin
    S := LLL[I];
    if Pos('IMM_', S) > 0 then
      LLL.Insert(I + 1, 'PUSH_' + S[5] + S[6]);
    Inc(I);
  end;
  I := 1;
  while I <= LLL.Count - 1 do
  begin
    S := LLL[I];
    S1 := LLL[I - 1];
    if (Pos('TOP_', S) > 0) and (Pos('PUSH_', S1) > 0) then
    begin
      if (S[5] = S1[6]) and (S[6] = S1[7]) then
        LLL.Delete(I);
    end
    else if (Pos('POP_', S) > 0) and (Pos('PUSH_', S1) > 0) then
    begin
      if (S[5] = S1[6]) and (S[6] = S1[7]) then
      begin
        LLL.Delete(I);
        LLL.Delete(I - 1);
      end
      else if (S[5] = S1[6]) then
      begin
        LLL.Delete(I);
        LLL.Delete(I - 1);
        LLL.Insert(I - 1, 'MOVTMP' + S[5] + #9'2'#9'R' + S1[7] + #9'R' + S[6]);
      end
    end;
    Inc(I);
  end;
end;

begin
  WriteLn('Checking immediates...');
  CheckImms;
  WriteLn('Generate assembler code...');
  Args := TStringList.Create;
  WordLabel := '';
  NeedExitLabel := false;
  for I := 0 to LLL.Count - 1 do
  begin
    AddArg := false;
    S := LLL[I];
    Cmd := '';
    J := 1;
    while (S[J] <> #9) and (not (S[J] in ['0'..'2'])) and (J <= Length(S)) do
    begin
      Cmd := Cmd + S[J];
      Inc(J);
    end;
//    if Cmd <> 'ASM' then
//      Listing.Add('; ' + S);
//    AddArg := Cmd = 'SET_LOOP_B';
    GetArgs;
    if CgWordName = '' then
      Args.Clear;
//    if CGWordName <> '' then
//      Listing.Add('; ' + CGWordName);
    if (Cmd = 'IMM_B') or (Cmd = 'IMM_W') or (Cmd = 'IMM_Q') then
    begin
      Args.Add(S[6]);
      CGWordName := '(' + Cmd + ':RI:::)';
      Args.Add(Copy(S, 8, 255));
    end
    else if (Cmd = 'PUSH_B') or (Cmd = 'PUSH_W') or (Cmd = 'PUSH_Q') then
    begin
      Args.Add(S[7]);
      CGWordName := '(' + Cmd + ':R:::)';
    end
    else if (Cmd = 'POP_B') or (Cmd = 'POP_W') or (Cmd = 'POP_Q') then
    begin
      Args.Add(S[6]);
      CGWordName := '(' + Cmd + ':R:::)';
    end
    else if (Cmd = 'TOP_B') or (Cmd = 'TOP_W') or (Cmd = 'TOP_Q') then
    begin
      Args.Add(S[6]);
      CGWordName := '(' + Cmd + ':R:::)';
    end
    else if Cmd = 'LABEL' then
    begin
      Listing.Add(Copy(S, 7, Length(S)) + ':');
      CGWordName := 'NOTHING';
    end
    else if Cmd = 'STARTWORD' then
    begin
      WordLabel := Copy(S, 11, Length(S));
      Listing.Add(WordLabel + ':');
      NeedExitLabel := false;
      CGWordName := 'NOTHING';
    end
    else if Cmd = 'EXITLABEL' then
    begin
      CGWordName := 'NOTHING';
      if NeedExitLabel then
        Listing.Add(Copy(S, 11, Length(S)) + ':');
    end
    else if Cmd = 'CALL' then
    begin
      CGWordName := 'NOTHING';
      Listing.Add(#9'call'#9 + Copy(S, 6, Length(S)));
    end
    else if Cmd = 'BRANCH' then
    begin
      CGWordName := 'NOTHING';
      Listing.Add(#9'rjmp'#9 + Copy(S, 8, Length(S)));
    end
    else if Cmd = '?BRANCH' then
    begin
      Args.Add(Copy(LLL[I + 1], 8, Length(LLL[I + 1])));
      LLL[I + 1] := 'NOTHING';
    end
    else if Cmd = '?UNTIL' then
    begin
      Args.Add(Copy(LLL[I + 1], 7, Length(LLL[I + 1])));
      LLL[I + 1] := 'NOTHING';
    end
    else if Cmd = 'BRANCHTOEXIT' then
    begin
      CGWordName := 'NOTHING';
      Listing.Add(#9'rjmp'#9 + WordLabel + '_exit');
      NeedExitLabel := true;
    end
    else if Cmd = 'RETURN' then
    begin
      CGWordName := 'NOTHING';
      Listing.Add(#9'ret');
    end
    else if Cmd = 'ASM' then
    begin
      CGWordName := 'NOTHING';
      Listing.Add(#9 + Copy(S, 5, Length(S)));
    end
    else if Cmd = 'DROPBYTE' then
    begin
      CGWordName := 'NOTHING';
      AsmCmd('adiw', 'sp, 1');
    end
    else if Cmd = 'DROPWORD' then
    begin
      CGWordName := 'NOTHING';
      AsmCmd('adiw', 'sp, 2');
    end
    else if Cmd = 'DROPQUAD' then
    begin
      CGWordName := 'NOTHING';
      AsmCmd('adiw', 'sp, 4');
    end
    else if Cmd = 'TOP-ONE_W' then
    begin
      CGWordName := 'NOTHING';
      RL := 'temp' + S[10] + 'l';
      RH := 'temp' + S[10] + 'h';
      AsmCmd('ldd', RL + ', Y + 3');
      AsmCmd('ldd', RH + ', Y + 2');
    end
    else if Cmd = 'SET_LOOP_B' then
    begin
      AddArg := true;
      GetArgs;
      CGWordName := 'NOTHING';
      if ArgsType = 'I' then
      begin
        RL := 'l' + S[11] + '_reg';
        RH := 'l' + S[11] + '_end';
        PopByte('0');
        AsmCmd('ldi', 'temp1l, low(' + Args[0] + ')');
        AsmCmd('mov', Rh + ', temp0l');
        AsmCmd('mov', Rl + ', temp1l');
      end
      else if ArgsType = 'IR' then
      begin
        RL := 'l' + S[11] + '_reg';
        RH := 'l' + S[11] + '_end';
        TL := 'temp' + Args[1] + 'l';
        AsmCmd('ldi', 'temp3l, low(' + Args[0] + ')');
        AsmCmd('mov', Rh + ', ' + TL);
        AsmCmd('mov', Rl + ', temp3l');
      end
      else if ArgsType = 'II' then
      begin
        RL := 'l' + S[11] + '_reg';
        RH := 'l' + S[11] + '_end';
        AsmCmd('ldi', 'temp3l, low(' + Args[0] + ')');
        AsmCmd('ldi', 'temp3h, low(' + Args[1] + ')');
        AsmCmd('mov', RL + ', temp3l');
        AsmCmd('mov', RH + ', temp3h');
      end
      else
        BadArgType;
    end
    else if Cmd = 'INC_LOOP_ONE_B' then
    begin
      CGWordName := 'NOTHING';
      RL := 'l' + S[15] + '_reg';
      AsmCmd('inc', RL);
    end
    else if Cmd = 'INC_LOOP_PLUS_B' then
    begin
      AddArg := true;
      GetArgs;
      CGWordName := 'NOTHING';
      RL := 'l' + S[16] + '_reg';
      if ArgsType = 'I' then
      begin
        AsmCmd('ldi', 'temp0l, low(' + Args[0] + ')');
        AsmCmd('add', RL + ', temp0l'); 
      end
      else
        BadArgType;
    end
    else if Cmd = 'COMP_LOOP_B' then
    begin
      CGWordName := 'NOTHING';
      RL := 'l' + S[12] + '_reg';
      RH := 'l' + S[12] + '_end';
      AsmCmd('cpse', RL + ', ' + RH);
    end
    else if Cmd = 'GET_CNT_W' then
    begin
      CGWordName := 'NOTHING';
      RL := 'l' + S[10] + '_reg';
      AsmCmd('mov', 'temp0l, ' + RL);
      AsmCmd('mov', 'temp0h, zero_reg');
    end
    else if Cmd = 'PUSH_SREG' then
    begin
      CGWordName := '(STARTINT:I:::)';
      Args.Add(WordLabel);
      //AsmCmd('push', 'r0');
      //AsmCmd('in', 'r0, SREG');
      //PushAllRegs;
    end
    else if Cmd = 'RETINT' then
    begin
      CGWordName := '(RETINT:I:::)';
      Args.Add(WordLabel);
      //PopAllRegs;
      //AsmCmd('out', 'SREG, r0');
      //AsmCmd('pop', 'r0');
      //AsmCmd('reti', '');
    end
    else if Cmd = 'RECURSE' then
    begin
      CGWordName := '(RECURSE:I:::)';
      Args.Add(WordLabel);
    end
    else if Cmd = 'SWITCHLABEL' then
    begin
      CGWordName := 'NOTHING';
      Listing.Add(WordLabel + '_switch:');
    end
    else if Cmd = 'NOTHING' then
    begin
      CGWordName := 'NOTHING';
      //Do nothing
    end;
    
    if (CGWordName <> '') then
    begin
      if CGWordName <> 'NOTHING' then
      begin
        W := FindWord(CGWordName);
        if W = nil then
        begin
          WarningMsg('Code generation word ' + CGWordName + ' not found');
          Listing.Add('; ' + S);
          Listing.Add(#9'.error'#9'Code generation word ' + CGWordName + ' not found')
        end
        else
        begin
          if (W^.CodeGen = '') then
            WarningMsg('Empty code generation info ' + CGWordName)
          else
          begin
            Listing.Add(ConvertAsm(ReplaceArgs(W^.CodeGen)));
            W^.Used := true;
          end;
        end;
      end;
    end
    else
    begin
      //Listing.Add('; ' + S);
      Listing.Add(#9'.error'#9'"Unknown cmd [' + S + ']"');
      WarningMsg('Unknown cmd [' + S + ']');
    end;
  end;
end;

end.
