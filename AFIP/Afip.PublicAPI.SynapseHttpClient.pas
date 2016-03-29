unit Afip.PublicAPI.SynapseHttpClient;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Implementacion de IHttpClient usando la biblioteca Synapse

interface

uses
  Afip.PublicAPI.HttpClient,
  Classes,
  SysUtils,
  httpsend;

type
{$REGION 'Excepciones'}
  ESynapseException = class(Exception)
  strict private
    FResultCode: Integer;
    FResultString: string;
  public
    constructor Create(const AErrorCode: Integer; const AErrorMsg: string);
    property ErrorCode: Integer read FResultCode;
    property ErrorMsg: string read FResultString;
  end;
{$ENDREGION}

/// <summary>
///  Implementa Afip.PublicAPI.HttpClient.IHttpClient mediante la biblioteca Synapse
/// </summary>
  TSynapseHttpClient = class(TInterfacedObject, IHttpClient)
  strict private
    FHttp: THTTPSend;

    procedure ExecuteGet(const AUrl: string);
  public
    constructor Create;
    destructor Destroy; override;
    function HttpGetText(const AUrl: string): string;
    function HttpGetBinary(const AUrl: string): TStream;
  end;

implementation

uses
  // es necesario que se cargue la biblioteca SSL
  ssl_openssl,
  ssl_openssl_lib;

constructor TSynapseHttpClient.Create;
begin
  inherited Create;
  FHttp := THTTPSend.Create;
end;

destructor TSynapseHttpClient.Destroy;
begin
  FHttp.Free;
  inherited Destroy;
end;

procedure TSynapseHttpClient.ExecuteGet(const AUrl: string);
begin
  if not FHttp.HTTPMethod('GET', AUrl) then
  raise ESynapseException.Create(FHttp.ResultCode, FHttp.ResultString);
end;

function TSynapseHttpClient.HttpGetBinary(const AUrl: string): TStream;
begin
  ExecuteGet(AUrl);
  Result := TMemoryStream.Create;
  Result.Position := 0;
  Result.CopyFrom(FHttp.Document, 0);
end;

function TSynapseHttpClient.HttpGetText(const AUrl: string): string;
var
  Response: TStrings;
begin
  ExecuteGet(AUrl);

  Response := TStringList.Create;
  try
    Response.LoadFromStream(FHttp.Document);
    Result := Response.Text;
  finally
    Response.Free;
  end;
end;

{ ESynapseException }

constructor ESynapseException.Create(const AErrorCode: Integer; const AErrorMsg: string);
begin
  FResultCode := AErrorCode;
  FResultString := AErrorMsg;
  inherited CreateFmt('Synapse Error: ErrorCode: %d, Message: %s', [FResultCode, FResultString]);
end;

end.
