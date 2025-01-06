object Data_Module: TData_Module
  Height = 480
  Width = 640
  object Connection: TFDConnection
    Params.Strings = (
      'Database=D:\RAD-projects\TodoList\Win32\Debug\DataBase.db'
      'DriverID=SQLite')
    Connected = True
    LoginPrompt = False
    Left = 376
    Top = 80
  end
  object Query: TFDQuery
    Connection = Connection
    Left = 304
    Top = 80
  end
end
