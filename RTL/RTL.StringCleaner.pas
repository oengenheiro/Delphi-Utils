unit RTL.StringCleaner;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// IStringCleaner is used to clean off some characters from a given string

interface

type
  IStringCleaner = interface
    ['{0253875D-B606-4BB5-AE84-E484177EDB49}']
    function OnlyAscii(const Value: WideString): WideString; overload;
    function OnlyLetters(const Value: WideString): WideString; overload;
    function OnlyNumbers(const Value: WideString): WideString; overload;

    function OnlyAscii(const Value: AnsiString): AnsiString; overload;
    function OnlyLetters(const Value: AnsiString): AnsiString; overload;
    function OnlyNumbers(const Value: AnsiString): AnsiString; overload;

    function OnlyAscii(const Value: string): string; overload;
    function OnlyLetters(const Value: string): string; overload;
    function OnlyNumbers(const Value: string): string; overload;
  end;

  TStringCleaner = class(TInterfacedObject, IStringCleaner)
  private type
    TPredicate<T> = reference to function(const Value: T): Boolean;
  private const
    AsciiLowerCaseLetters = ['a' .. 'z'];
    AsciiUpCaseLetters = ['A' .. 'Z'];
    AsciiLetters = AsciiLowerCaseLetters + AsciiUpCaseLetters;
    AsciiNumbers = ['0' .. '9'];
    WhiteSpace = [' '];
    AsciiChars = AsciiLetters + AsciiNumbers + WhiteSpace;
  private
    function ProcessWideString(const Value: WideString; APredicate: TPredicate<WideChar>): WideString;
    function ProcessAnsiString(const Value: AnsiString; APredicate: TPredicate<AnsiChar>): AnsiString;
    function ProcessString(const Value: string; APredicate: TPredicate<Char>): string;
  public
    function OnlyAscii(const Value: WideString): WideString; overload;
    function OnlyLetters(const Value: WideString): WideString; overload;
    function OnlyNumbers(const Value: WideString): WideString; overload;

    function OnlyAscii(const Value: AnsiString): AnsiString; overload;
    function OnlyLetters(const Value: AnsiString): AnsiString; overload;
    function OnlyNumbers(const Value: AnsiString): AnsiString; overload;

    function OnlyAscii(const Value: string): string; overload;
    function OnlyLetters(const Value: string): string; overload;
    function OnlyNumbers(const Value: string): string; overload;
  end;

implementation

uses
  {$IF CompilerVersion > 21}
  System.SysUtils;
  {$ELSE}
  SysUtils;
  {$IFEND}

{ TStringCleaner }

{$REGION 'WideString Handling'}

function TStringCleaner.ProcessWideString(const Value: WideString; APredicate: TPredicate<WideChar>): WideString;
var
  LChar: WideChar;
begin
  Result := EmptyWideStr;
  for LChar in Value do
    if APredicate(LChar) then
      Result := Result + LChar;
end;

function TStringCleaner.OnlyAscii(const Value: WideString): WideString;
begin
  Result := ProcessWideString(Value,
  function(const Value: WideChar): Boolean
  begin
    Result := CharInSet(Value, AsciiChars);
  end);
end;

function TStringCleaner.OnlyNumbers(const Value: WideString): WideString;
begin
  Result := ProcessWideString(Value,
  function(const Value: WideChar): Boolean
  begin
    Result := CharInSet(Value, AsciiNumbers);
  end);
end;

function TStringCleaner.OnlyLetters(const Value: WideString): WideString;
begin
  Result := ProcessWideString(Value,
  function(const Value: WideChar): Boolean
  begin
    Result := CharInSet(Value, AsciiLetters);
  end);
end;

{$ENDREGION}

{$REGION 'AnsiString Handling'}

function TStringCleaner.ProcessAnsiString(const Value: AnsiString; APredicate: TPredicate<AnsiChar>): AnsiString;
var
  LChar: AnsiChar;
begin
  Result := EmptyAnsiStr;
  for LChar in Value do
    if APredicate(LChar) then
      Result := Result + LChar;
end;

function TStringCleaner.OnlyAscii(const Value: AnsiString): AnsiString;
begin
  Result := ProcessAnsiString(Value,
  function(const Value: AnsiChar): Boolean
  begin
    Result := Value in AsciiChars;
  end);
end;

function TStringCleaner.OnlyNumbers(const Value: AnsiString): AnsiString;
begin
  Result := ProcessAnsiString(Value,
  function(const Value: AnsiChar): Boolean
  begin
    Result := Value in AsciiNumbers;
  end);
end;

function TStringCleaner.OnlyLetters(const Value: AnsiString): AnsiString;
begin
  Result := ProcessAnsiString(Value,
  function(const Value: AnsiChar): Boolean
  begin
    Result := Value in AsciiLetters;
  end);
end;

{$ENDREGION}

{$REGION 'String Handling'}

function TStringCleaner.ProcessString(const Value: string; APredicate: TPredicate<Char>): string;
var
  LChar: Char;
begin
  Result := EmptyStr;
  for LChar in Value do
    if APredicate(LChar) then
      Result := Result + LChar;
end;

function TStringCleaner.OnlyAscii(const Value: string): string;
begin
  Result := ProcessString(Value,
  function(const Value: Char): Boolean
  begin
    Result := CharInSet(Value, AsciiChars);
  end);
end;

function TStringCleaner.OnlyLetters(const Value: string): string;
begin
  Result := ProcessString(Value,
  function(const Value: Char): Boolean
  begin
    Result := CharInSet(Value, AsciiLetters);
  end);
end;

function TStringCleaner.OnlyNumbers(const Value: string): string;
begin
  Result := ProcessString(Value,
  function(const Value: Char): Boolean
  begin
    Result := CharInSet(Value, AsciiNumbers);
  end);
end;

{$ENDREGION}

end.
