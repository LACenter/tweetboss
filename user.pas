////////////////////////////////////////////////////////////////////////////////
// Unit Description  : user Description
// Unit Author       : LA.Center Corporation
// Date Created      : April, Tuesday 26, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals', 'login';

//constructor of user
function userCreate(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructorFromResource(Owner, @user_OnCreate, 'user');
end;

//OnCreate Event of user
procedure user_OnCreate(Sender: TFrame);
begin
    //Frame Constructor

    //todo: some additional constructing code
    Sender.Caption := Application.Title;
    Sender.Font.Color := $00444444;
    if OSX then
    Sender.Font.Size := 12
    else
    Sender.Font.Size := 10;
    TLabel(Sender.Find('lUser')).Font.Style := fsBold;
    TLabel(Sender.Find('lName')).Font.Style := fsBold;
    if OSX then
    TLabel(Sender.Find('lName')).Font.Size := 18
    else
    TLabel(Sender.Find('lName')).Font.Size := 14;
    TShape(Sender.Find('Shape1')).Pen.Color := Sender.Font.Color;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TTimer(Sender.find('resetTimer10')).OnTimer := @user_resetTimer10_OnTimer;
    TTimer(Sender.find('resetTimer9')).OnTimer := @user_resetTimer9_OnTimer;
    TTimer(Sender.find('resetTimer8')).OnTimer := @user_resetTimer8_OnTimer;
    TTimer(Sender.find('resetTimer7')).OnTimer := @user_resetTimer7_OnTimer;
    TTimer(Sender.find('resetTimer6')).OnTimer := @user_resetTimer6_OnTimer;
    TTimer(Sender.find('resetTimer5')).OnTimer := @user_resetTimer5_OnTimer;
    TTimer(Sender.find('countDown')).OnTimer := @user_countDown_OnTimer;
    TTimer(Sender.find('resetTimer4')).OnTimer := @user_resetTimer4_OnTimer;
    TTimer(Sender.find('resetTimer3')).OnTimer := @user_resetTimer3_OnTimer;
    TTimer(Sender.find('resetTimer2')).OnTimer := @user_resetTimer2_OnTimer;
    TTimer(Sender.find('resetcountDown')).OnTimer := @user_resetcountDown_OnTimer;
    TBGRALED(Sender.find('led')).OnClick := @user_led_OnClick;
    TLabel(Sender.Find('lUser')).OnClick := @user_led_OnClick;
    TLabel(Sender.Find('lName')).OnClick := @user_led_OnClick;
    TImage(Sender.Find('img')).OnClick := @user_led_OnClick;
    TPanel(Sender.Find('Panel1')).OnClick := @user_led_OnClick;
    TSimpleAction(Sender.find('actSetSelected')).OnExecute := @user_actSetSelected_OnExecute;
    TSimpleAction(Sender.find('actSetUnselected')).OnExecute := @user_actSetUnselected_OnExecute;
    //</events-bind>
end;

procedure user_actSetUnselected_OnExecute(Sender: TComponent);
begin
    TPanel(Sender.Owner.Find('Panel1')).Color := HexToColor('#f0f0f0');
    TLabel(Sender.Owner.Find('lName')).Font.Color := $00444444;
    TLabel(Sender.Owner.Find('lUser')).Font.Color := $00444444;

    resToFile('shadowTop', TempDir+'tmp.png');
    TImage(Sender.Owner.Find('imgTop')).Picture.LoadFromFile(TempDir+'tmp.png');

    resToFile('shadowBottom', TempDir+'tmp.png');
    TImage(Sender.Owner.Find('imgBottom')).Picture.LoadFromFile(TempDir+'tmp.png');

    DeleteFile(TempDir+'tmp.png');
end;

procedure user_actSetSelected_OnExecute(Sender: TComponent);
begin
    _DeselectAllUsers;

    TimeLineList.Items.BeginUpdate;
    TimeLineList.Items.Clear;
    TimeLineList.Items.EndUpdate;

    TPanel(Sender.Owner.Find('Panel1')).Color := HexToColor('#ff5500');
    TLabel(Sender.Owner.Find('lName')).Font.Color := clWhite;
    TLabel(Sender.Owner.Find('lUser')).Font.Color := clWhite;

    resToFile('none', TempDir+'tmp.png');
    TImage(Sender.Owner.Find('imgTop')).Picture.LoadFromFile(TempDir+'tmp.png');
    TImage(Sender.Owner.Find('imgBottom')).Picture.LoadFromFile(TempDir+'tmp.png');

    DeleteFile(TempDir+'tmp.png');

    _DoAfterSelect(TLabel(Sender.Owner.Find('lUser')).Caption);
end;

procedure user_led_OnClick(Sender: TComponent);
var
    f: TForm;
    user, pass: string;
    autoLogin: bool = false;
    tc: TTwitter;
begin
    loginUser := TLabel(Sender.Owner.Find('lUser')).Caption;
    loginName := TLabel(Sender.Owner.Find('lName')).Caption;

    if accounts.IndexOf(TLabel(Sender.Owner.Find('lUser')).Caption) = -1 then
    begin
        user := ReplaceOnce(loginUser, '@', '');

        actXML.Close;
        actXML.LoadFromXMLFile(actXML.FileName);
        actXML.Open;
        while not actXML.Eof do
        begin
            if actXML.Field('username').Text = user then
            begin
                if actXML.Field('storepass').Text = '1' then
                begin
                    pass := actXML.Field('password').Text;
                    autoLogin := true;
                    break;
                end;
            end;
            actXML.Next;
        end;
        actXML.Close;

        if autoLogin then
        begin
            _setBusy('Connecting to Twitter, please wait...');
            tc := TTwitter.Create;
            try
                Screen.Cursor := crHourGlass;
                Application.ProcessMessages;

                if tc.Login(user, pass) then
                begin
                    accounts.AddObject(loginUser, tc);
                    ForceDir(root+'accounts'+DirSep+tc.AccountUserName);

                    _DoAfterLogin(loginUser);
                end;
            except
                Screen.Cursor := crDefault;
                Application.ProcessMessages;

                tc.Free;
                MsgError('Error', ExceptionMessage);

                f := loginCreate(MainForm);
                f.ShowModalDimmed;
            end;

            Screen.Cursor := crDefault;
            Application.ProcessMessages;

            _setIdle;
        end
            else
        begin
            f := loginCreate(MainForm);
            f.ShowModalDimmed;
        end;
    end;

    if accounts.IndexOf(loginUser) <> -1 then
    begin
        TBGRALed(Sender.Owner.Find('led')).Color := clLime;
        user_actSetSelected_OnExecute(Sender);
    end;
end;

procedure user_resetcountDown_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    TVars(Sender.Owner.Find('apiLimits')).Vars.Values['home'] := '0';
end;

procedure user_resetTimer2_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    TVars(Sender.Owner.Find('apiLimits')).Vars.Values['mentions'] := '0';
end;

procedure user_resetTimer3_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    TVars(Sender.Owner.Find('apiLimits')).Vars.Values['user'] := '0';
end;

procedure user_resetTimer4_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    TVars(Sender.Owner.Find('apiLimits')).Vars.Values['search'] := '0';
end;

procedure user_resetTimer5_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    TVars(Sender.Owner.Find('apiLimits')).Vars.Values['top10'] := '0';
end;

procedure user_countDown_OnTimer(Sender: TTimer);
begin
    if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['home'] <> '0' then
    begin
        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['home'] :=
            IntToStr(StrToInt(TVars(Sender.Owner.Find('apiLimits')).Vars.Values['home']) -1)
    end;
    if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['mentions'] <> '0' then
    begin
        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['mentions'] :=
            IntToStr(StrToInt(TVars(Sender.Owner.Find('apiLimits')).Vars.Values['mentions']) -1)
    end;
    if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['user'] <> '0' then
    begin
        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['user'] :=
            IntToStr(StrToInt(TVars(Sender.Owner.Find('apiLimits')).Vars.Values['user']) -1)
    end;
    if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['search'] <> '0' then
    begin
        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['search'] :=
            IntToStr(StrToInt(TVars(Sender.Owner.Find('apiLimits')).Vars.Values['search']) -1)
    end;

    if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['top10'] <> '0' then
    begin
        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['top10Pulled'] := '1';

        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['top10'] :=
            IntToStr(StrToInt(TVars(Sender.Owner.Find('apiLimits')).Vars.Values['top10']) -1)
    end;

    if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['inbox'] <> '0' then
    begin
        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['inbox'] :=
            IntToStr(StrToInt(TVars(Sender.Owner.Find('apiLimits')).Vars.Values['inbox']) -1)
    end;

    if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['outbox'] <> '0' then
    begin
        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['outbox'] :=
            IntToStr(StrToInt(TVars(Sender.Owner.Find('apiLimits')).Vars.Values['outbox']) -1)
    end;

    if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['following'] <> '0' then
    begin
        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['following'] :=
            IntToStr(StrToInt(TVars(Sender.Owner.Find('apiLimits')).Vars.Values['following']) -1)
    end;

    if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['followers'] <> '0' then
    begin
        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['followers'] :=
            IntToStr(StrToInt(TVars(Sender.Owner.Find('apiLimits')).Vars.Values['followers']) -1)
    end;

    if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['droppers'] <> '0' then
    begin
        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['droppers'] :=
            IntToStr(StrToInt(TVars(Sender.Owner.Find('apiLimits')).Vars.Values['droppers']) -1)
    end;

    if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['message'] <> '0' then
    begin
        TVars(Sender.Owner.Find('apiLimits')).Vars.Values['message'] :=
            IntToStr(StrToInt(TVars(Sender.Owner.Find('apiLimits')).Vars.Values['message']) -1);
    end;

    if appSettings.Values['show-countdown'] = '1' then
    begin
        if TLabel(Sender.Owner.Find('lUser')).Caption = _getSelectedUser then
        begin
            if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['home'] <> '0' then
            TimeLineTree.Items.Item[1].Text := 'Home ('+TVars(Sender.Owner.Find('apiLimits')).Vars.Values['home']+' sec)'
            else
            TimeLineTree.Items.Item[1].Text := 'Home';

            if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['user'] <> '0' then
            TimeLineTree.Items.Item[2].Text := 'User ('+TVars(Sender.Owner.Find('apiLimits')).Vars.Values['user']+' sec)'
            else
            TimeLineTree.Items.Item[2].Text := 'User';

            if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['mentions'] <> '0' then
            TimeLineTree.Items.Item[3].Text := 'Mentions ('+TVars(Sender.Owner.Find('apiLimits')).Vars.Values['mentions']+' sec)'
            else
            TimeLineTree.Items.Item[3].Text := 'Mentions';

            if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['search'] <> '0' then
            TimeLineTree.Items.Item[5].Text := 'Queries ('+TVars(Sender.Owner.Find('apiLimits')).Vars.Values['search']+' sec)'
            else
            TimeLineTree.Items.Item[5].Text := 'Queries';

            if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['top10'] <> '0' then
            TimeLineTree.Items.Item[4].Text := 'Top 10 ('+TVars(Sender.Owner.Find('apiLimits')).Vars.Values['top10']+' sec)'
            else
            TimeLineTree.Items.Item[4].Text := 'Top 10';

            //

            if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['inbox'] <> '0' then
            NetTree.Items.Item[1].Text := 'Received ('+TVars(Sender.Owner.Find('apiLimits')).Vars.Values['inbox']+' sec)'
            else
            NetTree.Items.Item[1].Text := 'Received';

            if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['outbox'] <> '0' then
            NetTree.Items.Item[2].Text := 'Sent ('+TVars(Sender.Owner.Find('apiLimits')).Vars.Values['outbox']+' sec)'
            else
            NetTree.Items.Item[2].Text := 'Sent';

            if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['followers'] <> '0' then
            NetTree.Items.Item[4].Text := 'Followers ('+TVars(Sender.Owner.Find('apiLimits')).Vars.Values['followers']+' sec)'
            else
            NetTree.Items.Item[4].Text := 'Followers';

            if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['following'] <> '0' then
            NetTree.Items.Item[5].Text := 'Following ('+TVars(Sender.Owner.Find('apiLimits')).Vars.Values['following']+' sec)'
            else
            NetTree.Items.Item[5].Text := 'Following';

            if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['droppers'] <> '0' then
            NetTree.Items.Item[6].Text := 'Dropped ('+TVars(Sender.Owner.Find('apiLimits')).Vars.Values['droppers']+' sec)'
            else
            NetTree.Items.Item[6].Text := 'Dropped';

            if TVars(Sender.Owner.Find('apiLimits')).Vars.Values['user'] <> '0' then
            NetTree.Items.Item[8].Text := 'Campaigns ('+TVars(Sender.Owner.Find('apiLimits')).Vars.Values['user']+' sec)'
            else
            NetTree.Items.Item[8].Text := 'Campaigns';
        end;
    end;
end;

procedure user_resetTimer6_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    TVars(Sender.Owner.Find('apiLimits')).Vars.Values['inbox'] := '0';
end;

procedure user_resetTimer7_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    TVars(Sender.Owner.Find('apiLimits')).Vars.Values['outbox'] := '0';
end;

procedure user_resetTimer8_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    TVars(Sender.Owner.Find('apiLimits')).Vars.Values['followers'] := '0';
end;

procedure user_resetTimer9_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    TVars(Sender.Owner.Find('apiLimits')).Vars.Values['following'] := '0';
end;

procedure user_resetTimer10_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    TVars(Sender.Owner.Find('apiLimits')).Vars.Values['droppers'] := '0';
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//user initialization constructor
constructor
begin 
end.
