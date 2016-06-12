////////////////////////////////////////////////////////////////////////////////
// Unit Description  : reply Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Wednesday 11, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of reply
function replyCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @reply_OnCreate, 'reply');
end;

//OnCreate Event of reply
procedure reply_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _SetFonts(Sender);
    TButton(Sender.Find('Button2')).ModalResult := mrCancel;
    TButton(Sender.Find('Button1')).ModalResult := mrOK;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TMemo(Sender.find('Memo1')).OnChange := @reply_Memo1_OnChange;
    Sender.OnClose := @reply_OnClose;
    Sender.OnCloseQuery := @reply_OnCloseQuery;
    Sender.OnShow := @reply_OnShow;
    //</events-bind>
end;

procedure reply_Memo1_OnChange(Sender: TMemo);
begin
    TLabel(Sender.Owner.Find('Label1')).Caption :=
        'Tweet Text ('+IntToStr(_calcChars(Sender.Lines.Text, false))+' characters)';

    if Pos('-', TLabel(Sender.Owner.Find('Label1')).Caption) > 0 then
        TLabel(Sender.Owner.Find('Label1')).Font.Color := clRed
        else
        TLabel(Sender.Owner.Find('Label1')).Font.Color := $00444444;

    TButton(Sender.Owner.Find('Button1')).Enabled :=
        (Trim(Sender.Lines.Text) <> '') and
        (Pos('-', TLabel(Sender.Owner.Find('Label1')).Caption) = 0);
end;

procedure reply_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure reply_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    tc: TTwitter;
begin
    if Sender.ModalResult = mrOK then
    begin
        if accounts.IndexOf(_getSelectedUser) <> -1 then
        begin
            tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

            _setBusyScreen;

            try
                tc.tweetReply(Sender.Hint, TMemo(Sender.Find('Memo1')).Lines.Text);
            except
                _setIdle;
                CanClose := false;
                MsgError('Error', ExceptionMessage);
            end;
        end;
    end;
    _setIdle;
end;

procedure reply_OnShow(Sender: TForm);
begin
    reply_Memo1_OnChange(TMemo(Sender.Find('Memo1')));
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//reply initialization constructor
constructor
begin 
end.
