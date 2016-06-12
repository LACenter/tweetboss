////////////////////////////////////////////////////////////////////////////////
// Unit Description  : viewtweet Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Monday 02, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of viewtweet
function viewtweetCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @viewtweet_OnCreate, 'viewtweet');
end;

//OnCreate Event of viewtweet
procedure viewtweet_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);
    TButton(Sender.Find('Button1')).ModalResult := mrOK;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    //</events-bind>
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//viewtweet initialization constructor
constructor
begin 
end.
