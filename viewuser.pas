////////////////////////////////////////////////////////////////////////////////
// Unit Description  : viewuser Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Wednesday 11, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of viewuser
function viewuserCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @viewuser_OnCreate, 'viewuser');
end;

//OnCreate Event of viewuser
procedure viewuser_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);

    TLabel(Sender.Find('lUser')).Font.Style := fsBold;
    TLabel(Sender.Find('lName')).Font.Style := fsBold;
    if OSX then
    TLabel(Sender.Find('lName')).Font.Size := 18
    else
    TLabel(Sender.Find('lName')).Font.Size := 14;
    TShape(Sender.Find('Shape1')).Pen.Color := Sender.Font.Color;

    TPanel(Sender.Find('Panel1')).Font.Color := clBlue;
    TPanel(Sender.Find('Panel2')).Font.Color := clGreen;
    TPanel(Sender.Find('Panel3')).Font.Color := clNavy;
    TLabel(Sender.Find('Label6')).Font.Color := clBlue;

    TButton(Sender.Find('Button1')).ModalResult := mrCancel;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TButton(Sender.find('Button2')).OnClick := @viewuser_Button2_OnClick;
    //</events-bind>
end;

procedure viewuser_Button2_OnClick(Sender: TButton);
var
    tc: TTwitter;
begin
    tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

    if Sender.Caption = 'Unfollow' then
    begin
        try
            tc.unfollowUser(TLabel(Sender.Owner.Find('lUser')).Caption);
            Sender.Caption := 'Follow';
        except end;
    end
        else
    begin
        try
            tc.followUser(TLabel(Sender.Owner.Find('lUser')).Caption);
            Sender.Caption := 'Unfollow';
        except end;
    end;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//viewuser initialization constructor
constructor
begin 
end.
