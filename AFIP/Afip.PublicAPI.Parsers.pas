unit Afip.PublicAPI.Parsers;

// Source: https://github.com/ortuagustin/Delphi-Utils
// Author: Ortu Agustin

// Implements Json parsing of content retrieved from AFIP to Delphi Classes

interface

uses
  Afip.PublicAPI.Types;

type
  IAfip_PersonParser = interface
    ['{3A2CC23D-B463-45C8-B3BA-8546DBF21A62}']
    function JsonToPerson(const AJson: string): IPersona_Afip;
    function JsonToDocumentos(const AJson: string): TArray<string>;
  end;

  IAfip_ItemParser = interface
    ['{0EF21EDC-EFE9-4600-8732-1BBE3A7B136C}']
    function JsonToItems(const AJson: string): TArray<TItem_Afip>;
    function JsonToDependencies(const AJson: string): TArray<TDependencia_Afip>;
  end;

implementation

end.
