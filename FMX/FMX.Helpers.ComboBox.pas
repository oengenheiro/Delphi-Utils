unit FMX.Helpers.ComboBox;

interface

uses
  FMX.Types,
  FMX.ListBox;

type
{$REGION 'TComboBoxHelper'}
  TComboBoxHelper = class helper for TComboBox
  public
    /// <summary> Devuelve una coleccion con todos los TComboBox de Target (recursivo) </summary>
    class function GetComboBoxesFrom(Target: TFmxObject): TArray<TComboBox>; static;
    /// <summary> Setea Font.Size := TextSize para todos los items de todos los TComboBox de Owner </summary>
    class procedure SetAllParentedTextSizes(TargetOwner: TFmxObject; const TextSize: Single); overload; static;
    /// <summary> Setea Font.Size := TextSize para todos los items de todos los TComboBox en la coleccion </summary>
    class procedure SetTextSize(Targets: TArray<TComboBox>; const TextSize: Single); overload; static;
    /// <summary> Devuelve el texto del item seleccionado; Si no hay nada seleccionado devuelve EmptyStr </summary>
    function SelectedText: string;
    /// <summary> Devuelve el objeto en Items.Object[ItemIndex] </summary>
    function SelectedObject: TObject;
    /// <summary> Devuelve el objeto en Items.Object[ItemIndex], y le aplica un casting basado en el parametro T </summary>
    function SelectedObjectAs<T: class>: T;
    /// <summary> Pone como seleccionado el item con texto AText, y si no existe deja ItemIndex a -1 </summary>
    procedure SelectItemWithText(const AText: string);
    /// <summary> Tamaño de la fuente de todos los items del TComboBox </summary>
    procedure SetItemsTextSize(const Value: Single);
  end;
{$ENDREGION}

implementation

uses
  Spring.Collections,
  System.SysUtils,
  FMX.Pickers;

{$REGION 'TComboBoxHelper'}

function TComboBoxHelper.SelectedObject: TObject;
begin
  if ItemIndex <> -1 then
    Result := Items.Objects[ItemIndex]
  else
    Result := nil;
end;

function TComboBoxHelper.SelectedObjectAs<T>: T;
begin
  if (ItemIndex <> -1) and (SelectedObject is T) then
    Result := T(Items.Objects[ItemIndex])
  else
    Result := nil;
end;

function TComboBoxHelper.SelectedText: string;
begin
  if ItemIndex <> -1 then
    Result := Selected.Text
  else
    Result := EmptyStr;
end;

procedure TComboBoxHelper.SelectItemWithText(const AText: string);
begin
  ItemIndex := Items.IndexOf(AText);
end;

procedure TComboBoxHelper.SetItemsTextSize(const Value: Single);
var
  I: Integer;
begin
  for I := 0 to Items.Count - 1 do
  begin
    DropDownKind := TDropDownKind.Custom;
    ListItems[I].TextSettings.Font.Size := Value;
    ListItems[I].StyledSettings := ListItems[I].StyledSettings - [TStyledSetting.Size];
  end;
end;

class function TComboBoxHelper.GetComboBoxesFrom(Target: TFmxObject): TArray<TComboBox>;
var
  Items: IList<TComboBox>;
  Each: TFmxObject;
begin
  Items := TCollections.CreateList<TComboBox>;
  try
    if not Assigned(Target.Children) then
      Exit;

    for Each in Target.Children do
    begin
      if Each is TComboBox then
        Items.Add(Each as TComboBox);

      Items.AddRange(GetComboBoxesFrom(Each));
    end;
  finally
    Result := Items.ToArray;
  end;
end;

class procedure TComboBoxHelper.SetAllParentedTextSizes(TargetOwner: TFmxObject; const TextSize: Single);
begin
  SetTextSize(GetComboBoxesFrom(TargetOwner), TextSize);
end;

class procedure TComboBoxHelper.SetTextSize(Targets: TArray<TComboBox>; const TextSize: Single);
var
  I: Integer;
begin
  for I := Low(Targets) to High(Targets) do
    Targets[I].SetItemsTextSize(TextSize);
end;

{$ENDREGION}

end.
