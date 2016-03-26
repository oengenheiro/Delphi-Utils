unit Afip.PublicAPI.HttpClient;

interface

uses
  System.Classes;

type
  /// <summary>
  ///  Esta interface define los dos metodos basicos que tienen que implementar los clientes HTTP
  ///  Segun la documentacion de la AFIP el encoding del response es UTF-8
  /// </summary>
  IHttpClient = interface
    ['{AFA99837-6CBB-4111-A268-D8AB8E4CD8DD}']
    function HttpGetText(const AUrl: string): string;
    function HttpGetBinary(const AUrl: string): TStream;
  end;

implementation

end.
