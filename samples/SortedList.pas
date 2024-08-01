program SortedList;

type
  TMyArray = array of Integer;
  TMyClass = class
  private
    FArray: TMyArray;
  public
    property Items[Index: Integer]: Integer read GetItem write SetItem;
  end;

function TMyClass.GetItem(Index: Integer): Integer;
begin
  Result := FArray[Index];
end;

procedure TMyClass.SetItem(Index: Integer; const Value: Integer);
begin
  FArray[Index] := Value;
end;

type
  PNode = ^TNode;
  TNode = record
    Left, Right: PNode;
    Key: Integer; // Or any comparable type
    Priority: Integer; // Randomly generated
  end;

function NewNode(Key: Integer): PNode;
begin
  New(Result);
  Result^.Key := Key;
  Result^.Priority := Random(MaxInt); // Generate random priority
  Result^.Left := nil;
  Result^.Right := nil;
end;

procedure RotateRight(var Root: PNode);
var
  Left: PNode;
begin
  Left := Root^.Left;
  Root^.Left := Left^.Right;
  Left^.Right := Root;
  Root := Left;
end;

procedure RotateLeft(var Root: PNode);
var
  Right: PNode;
begin
  Right := Root^.Right;
  Root^.Right := Right^.Left;
  Right^.Left := Root;
  Root := Right;
end;

procedure FixHeap(var Root: PNode);
begin
  if Root^.Left <> nil and Root^.Left^.Priority > Root^.Priority then
    RotateRight(Root);
  if Root^.Right <> nil and Root^.Right^.Priority > Root^.Priority then
    RotateLeft(Root);
  FixHeap(Root^.Left);
  FixHeap(Root^.Right);
end;

procedure Insert(var Root: PNode; Key: Integer);
var
  NewNode: PNode;
begin
  if Root = nil then
    Root := NewNode(Key)
  else if Key < Root^.Key then
    Insert(Root^.Left, Key);
  else
    Insert(Root^.Right, Key);
  FixHeap(Root);
end;

procedure Delete(var Root: PNode; Key: Integer);
begin
  if Root = nil then
    Exit;
  if Key < Root^.Key then
    Delete(Root^.Left, Key)
  else if Key > Root^.Key then
    Delete(Root^.Right, Key)
  else
    // Handle deletion logic, including rebalancing
    // ...
  end;
end;


generic
  T: class;

type
  TSortedArray<T> = class
  private
    FData: array of T;
    FCount: Integer;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Add(Item: T);
    procedure RemoveAt(Index: Integer);
    function GetAt(Index: Integer): T;
    property Count: Integer read FCount;
  end;

constructor TSortedArray<T>.Create;
begin
  FCount := 0;
end;

destructor TSortedArray<T>.Destroy;
begin
  // Handle potential memory cleanup for elements if necessary
end;

procedure TSortedArray<T>.Add(Item: T);
var
  i: Integer;
begin
  // Find the insertion point using binary search
  // ...
  // Shift elements to the right
  // ...
  FData[i] := Item;
  Inc(FCount);
end;

procedure TSortedArray<T>.RemoveAt(Index: Integer);
begin
  // Check for valid index
  // Shift elements to the left
  // ...
  Dec(FCount);
end;

function TSortedArray<T>.GetAt(Index: Integer): T;
begin
  // Check for valid index
  Result := FData[Index];
end;


generic
  T: class;

type
  PNode = ^TNode;
  TNode = record
    Left, Right: PNode;
    Key: T;
    Priority: Integer;
  end;

  TSortedTreap<T> = class
  private
    Root: PNode;
  public
    constructor Create;
    destructor Destroy; override;
    procedure Insert(Item: T);
    procedure RemoveAt(Index: Integer);
    function GetAt(Index: Integer): T;
    property Count: Integer read FCount;
  end;

begin
end.
