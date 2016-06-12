////////////////////////////////////////////////////////////////////////////////
// Unit Description  : rndstats Description
// Unit Author       : LA.Center Corporation
// Date Created      : April, Thursday 28, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of rndstats
function rndstatsCreate(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructorFromResource(Owner, @rndstats_OnCreate, 'rndstats');
end;

//OnCreate Event of rndstats
procedure rndstats_OnCreate(Sender: TFrame);
begin
    //Frame Constructor

    //todo: some additional constructing code
    Sender.Caption := Application.Title;
    Sender.Font.Color := $00444444;
    if OSX then
    Sender.Font.Size := 12
    else
    Sender.Font.Size := 10;

    TLabel(Sender.Find('lTitle')).Font.Style := fsBold;
    if OSX then
    TLabel(Sender.Find('lTitle')).Font.Size := 18
    else
    TLabel(Sender.Find('lTitle')).Font.Size := 14;

    TLabel(Sender.Find('lPercent')).Font.Color := HexToColor(clrGreen);
    TLabel(Sender.Find('lPercent')).Font.Style := fsBold;
    if OSX then
    TLabel(Sender.Find('lPercent')).Font.Size := 14
    else
    TLabel(Sender.Find('lPercent')).Font.Size := 10;
    TShape(Sender.Find('Shape1')).Pen.Color := HexToColor('#ff5500');

    TLabel(Sender.Find('lcount')).Font.Style := fsBold;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    //</events-bind>
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//rndstats initialization constructor
constructor
begin 
end.
