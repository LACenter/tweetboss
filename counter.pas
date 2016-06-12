////////////////////////////////////////////////////////////////////////////////
// Unit Description  : counter Description
// Unit Author       : LA.Center Corporation
// Date Created      : April, Thursday 28, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of counter
function counterCreate(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructorFromResource(Owner, @counter_OnCreate, 'counter');
end;

//OnCreate Event of counter
procedure counter_OnCreate(Sender: TFrame);
begin
    //Frame Constructor

    //todo: some additional constructing code
    Sender.Caption := Application.Title;
    Sender.Font.Color := $00444444;
    if OSX then
    Sender.Font.Size := 12
    else
    Sender.Font.Size := 10;
    _setFonts(Sender);

    TLabel(Sender.Find('lUser')).Font.Style := fsBold;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    //</events-bind>
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//counter initialization constructor
constructor
begin 
end.
