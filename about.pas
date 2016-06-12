////////////////////////////////////////////////////////////////////////////////
// Unit Description  : about Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Sunday 15, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of about
function aboutCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @about_OnCreate, 'about');
end;

//OnCreate Event of about
procedure about_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);
    TLabel(Sender.Find('Label1')).Font.Style := fsBold;
    TLabel(Sender.Find('Label2')).Caption := 'Version '+appVersion;
    TButton(Sender.Find('Button1')).ModalResult := mrCancel;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    //</events-bind>
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//about initialization constructor
constructor
begin 
end.
