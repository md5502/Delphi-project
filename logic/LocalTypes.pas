unit LocalTypes;

interface

type
  TUser = record
    id: Integer;
    username: String;
  end;

type
  TTask = record
    id: Integer;
    UserId: Integer;
    title: string;
    description: string;
    date: string;
    priority: Integer;
    status: Integer;
  end;
implementation

end.
