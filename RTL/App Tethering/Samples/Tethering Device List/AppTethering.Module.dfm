object TetheringModule: TTetheringModule
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 222
  Width = 329
  object TetheringManager: TTetheringManager
    Text = 'Sample - Tethering Observer - Manager'
    AllowedAdapters = 'Network'
    Left = 92
    Top = 60
  end
  object TetheringAppProfile: TTetheringAppProfile
    Manager = TetheringManager
    Text = 'Tethering Observer - App Profile'
    Group = 'Tethering.Observer'
    Actions = <>
    Resources = <>
    Left = 208
    Top = 62
  end
end
