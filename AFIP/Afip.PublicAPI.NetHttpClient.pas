{$I jedi.inc}

unit Afip.PublicAPI.NetHttpClient;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Implementacion de IHttpClient usando la biblioteca System.Net

interface

{$IFDEF DELPHIXE8_UP}
uses
  Afip.PublicAPI.HttpClient,
  System.Classes,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
/// <summary>
///  Implementa Afip.PublicAPI.HttpClient.IHttpClient usando los componentes NetHttp Delphi XE8+
/// </summary>
  TNativeHttpClient = class(TInterfacedObject, IHttpClient)
  strict private
    FHttpClient: TNetHTTPClient;
    FHttpRequest: TNetHTTPRequest;
  public
    constructor Create;
    destructor Destroy; override;
    function HttpGetText(const AUrl: string): string;
    function HttpGetBinary(const AUrl: string): TStream;
  end;
{$ENDIF}

implementation

{$IFDEF DELPHIXE8_UP}
uses
  System.SysUtils;

constructor TNativeHttpClient.Create;
begin
  inherited Create;
  FHttpClient := TNetHTTPClient.Create(NIL);
  FHttpClient.AllowCookies := True;
  FHttpClient.HandleRedirects := True;

  FHttpRequest := TNetHTTPRequest.Create(NIL);
  FHttpRequest.Client := FHttpClient;
  FHttpRequest.MethodString := 'GET';
end;

destructor TNativeHttpClient.Destroy;
begin
  FHttpClient.Free;
  FHttpRequest.Free;
  inherited Destroy;
end;

function TNativeHttpClient.HttpGetBinary(const AUrl: string): TStream;
begin
  Result := TMemoryStream.Create;
  FHttpClient.Get(AUrl, Result);
end;

function TNativeHttpClient.HttpGetText(const AUrl: string): string;
begin
  FHttpRequest.URL := AUrl;
  Result := FHttpRequest.Execute.ContentAsString(TEncoding.UTF8);
end;
{$ENDIF}

end.

