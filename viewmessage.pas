////////////////////////////////////////////////////////////////////////////////
// Unit Description  : viewmessage Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Thursday 12, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of viewmessage
function viewmessageCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @viewmessage_OnCreate, 'viewmessage');
end;

//OnCreate Event of viewmessage
procedure viewmessage_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _SetFonts(Sender);

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TButton(Sender.find('Button2')).OnClick := @viewmessage_Button2_OnClick;
    TButton(Sender.find('Button1')).OnClick := @viewmessage_Button1_OnClick;
    //</events-bind>
end;

procedure viewmessage_Button1_OnClick(Sender: TButton);
begin
    TForm(Sender.Owner).Close;
end;

procedure viewmessage_Button2_OnClick(Sender: TButton);
var
    tm: TTwitterMessageData;
    f: TForm;
begin
    tm := TTwitterMessageData(NetList.Selected.Data);

    f := messageCreate(MainForm);
    TEdit(f.Find('Edit1')).Text := '@'+tm.UserData.UserName;
    f.ShowModal;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//viewmessage initialization constructor
constructor
begin 
end.
