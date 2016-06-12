////////////////////////////////////////////////////////////////////////////////
// Unit Description  : message Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Wednesday 11, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of message
function messageCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @message_OnCreate, 'message');
end;

//OnCreate Event of message
procedure message_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);
    TButton(Sender.Find('Button1')).ModalResult := mrCancel;
    TButton(Sender.Find('Button2')).ModalResult := mrOK;

    TCheckBox(Sender.Find('CheckBox1')).Enabled := (trim(appSettings.Values['live-key']) <> '');

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TTimer(Sender.find('Timer1')).OnTimer := @message_Timer1_OnTimer;
    TMemo(Sender.find('Memo1')).OnChange := @message_Memo1_OnChange;
    TEdit(Sender.find('Edit1')).OnChange := @message_Edit1_OnChange;
    Sender.OnClose := @message_OnClose;
    Sender.OnCloseQuery := @message_OnCloseQuery;
    //</events-bind>
end;

procedure message_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure message_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    str: TStringList;
    str2: TStringList;
    tc: TTwitter;
    i: int;
    c: int = 0;
    txt: string;
    newUrl: string;
    urla: TUrla;
    signal: string;
begin
    if Sender.ModalResult = mrOK then
    begin
        _setBusyScreen;
        if accounts.IndexOf(_getSelectedUser) <> -1 then
        begin
            txt := TMemo(Sender.Find('Memo1')).Lines.Text;
            signal := appSettings.Values['live-signal'];

            tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

            str := TStringList.Create;
            str2 := TStringList.Create;
            str.CommaText := TEdit(Sender.Find('Edit1')).Text;

            if TCheckBox(Sender.Find('CheckBox1')).Checked then
            begin
                urla := TUrla.Create;
                _getLinks(TMemo(Sender.Find('Memo1')).Lines.Text, str2);
                for i := 0 to str2.Count -1 do
                begin
                    try
                        if Pos('urla.me', str2.Strings[i]) = 0 then
                        begin
                            newUrl := urla.ShortenUrl(appSettings.Values['live-key'],
                                                      str2.Strings[i],
                                                      signal);
                            txt := ReplaceAll(txt, str2.Strings[i], newUrl);
                        end;
                    except end;
                end;
                urla.free;
            end;

            for i := 0 to str.Count -1 do
            begin
                try
                    tc.sendMessage(str.Strings[i], txt);
                    c := c + 60;
                except end;
            end;

            str.free;
            str2.free;

            _startMessageApiLimit(_getSelectedUser, c);
        end;
    end;
    _setIdle;
end;

procedure message_Edit1_OnChange(Sender: TComponent);
begin
    TButton(Sender.Owner.Find('Button2')).Enabled :=
        (Trim(TMemo(Sender.Owner.Find('Memo1')).Lines.Text) <> '') and
        (Trim(TEdit(Sender.Owner.Find('Edit1')).Text) <> '') and
        (_getMessageApiLimit(_getSelectedUser) = '0');
end;

procedure message_Memo1_OnChange(Sender: TMemo);
begin
    message_Edit1_OnChange(Sender);
end;

procedure message_Timer1_OnTimer(Sender: TTimer);
begin
    if _getMessageApiLimit(_getSelectedUser) <> '0' then
    begin
        TLabel(Sender.Owner.Find('Label3')).Caption := 'Please wait '+_getMessageApiLimit(_getSelectedUser)+' sec.';
        TLabel(Sender.Owner.Find('Label3')).Visible := true;
    end
        else
        TLabel(Sender.Owner.Find('Label3')).Visible := false;
    message_Edit1_OnChange(Sender);
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//message initialization constructor
constructor
begin 
end.
