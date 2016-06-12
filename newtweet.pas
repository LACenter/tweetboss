////////////////////////////////////////////////////////////////////////////////
// Unit Description  : newtweet Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Saturday 07, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of newtweet
function newtweetCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @newtweet_OnCreate, 'newtweet');
end;

//OnCreate Event of newtweet
procedure newtweet_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);
    TLabel(Sender.Find('Label1')).Font.Style := fsBold;
    TButton(Sender.Find('Button1')).ModalResult := mrCancel;
    TButton(Sender.Find('Button2')).ModalResult := mrOK;
    TUrlLink(Sender.Find('UrlLink1')).Font.Color := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink1')).ColorHovered := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink1')).ColorVisited := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink2')).Font.Color := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink2')).ColorHovered := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink2')).ColorVisited := HexToColor('#ff5500');

    TCheckBox(Sender.Find('CheckBox1')).Enabled := (trim(appSettings.Values['live-key']) <> '');

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TUrlLink(Sender.find('UrlLink1')).OnClick := @newtweet_UrlLink1_OnClick;
    TUrlLink(Sender.find('UrlLink2')).OnClick := @newtweet_UrlLink2_OnClick;
    TMemo(Sender.find('Memo1')).OnChange := @newtweet_Memo1_OnChange;
    Sender.OnClose := @newtweet_OnClose;
    Sender.OnCloseQuery := @newtweet_OnCloseQuery;
    Sender.OnShow := @newtweet_OnShow;
    //</events-bind>
end;

procedure newtweet_Memo1_OnChange(Sender: TMemo);
var
    hasMedia: bool = false;
begin
    if (TImage(Sender.Owner.Find('Image1')).Hint <> '') or
       (TLabel(Sender.Owner.Find('labImage')).Caption <> '') then
        hasMedia := true;

    TLabel(Sender.Owner.Find('Label1')).Caption :=
        'Tweet Text ('+IntToStr(_calcChars(Sender.Lines.Text, hasMedia))+' characters)';
    if Pos('-', TLabel(Sender.Owner.Find('Label1')).Caption) > 0 then
        TLabel(Sender.Owner.Find('Label1')).Font.Color := clRed
        else
        TLabel(Sender.Owner.Find('Label1')).Font.Color := $00444444;

    TButton(Sender.Owner.Find('Button2')).Enabled :=
        (Trim(Sender.Lines.Text) <> '') and
        (Pos('-', TLabel(Sender.Owner.Find('Label1')).Caption) = 0);
end;

procedure newtweet_UrlLink2_OnClick(Sender: TUrlLink);
begin
    if TOpenPictureDialog(Sender.Owner.Find('OpenPictureDialog1')).Execute then
    begin
        TImage(Sender.Owner.Find('Image1')).Picture.LoadFromFile(TOpenPictureDialog(Sender.Owner.Find('OpenPictureDialog1')).Filename);
        TImage(Sender.Owner.Find('Image1')).Hint := TOpenPictureDialog(Sender.Owner.Find('OpenPictureDialog1')).Filename;
        newtweet_Memo1_OnChange(TMemo(Sender.Owner.Find('Memo1')));
    end;
end;

procedure newtweet_UrlLink1_OnClick(Sender: TUrlLink);
begin
    TImage(Sender.Owner.Find('Image1')).Picture.Clear;
    TImage(Sender.Owner.Find('Image1')).Hint := '';
    newtweet_Memo1_OnChange(TMemo(Sender.Owner.Find('Memo1')));
end;

procedure newtweet_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure newtweet_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    str: TStringList;
    txt: string;
    queHome, qname: string;
    twid: string;
    i: int;
    urla: TUrla;
    newUrl: string;
    hasErrors: bool = false;
    livePostErrors: bool = false;
    tc: TTwitter;
    signal: string;
    tweeterID: string;
begin
    if Sender.Caption = 'Tweet Now' then
    begin
        if Sender.ModalResult = mrOK then
        begin
            _setBusyScreen;
            try
                txt := TMemo(Sender.Find('Memo1')).Lines.Text;

                str := TStringList.Create;
                if TCheckBox(Sender.Find('CheckBox1')).Checked then
                begin
                    //change links to urla.me

                    if Pos(' Campaign ', Sender.Caption) = 0 then
                    signal := appSettings.Values['live-signal']
                    else
                    signal := 'trace:'+twid+'.tweet';

                    urla := TUrla.Create;
                    _getLinks(TMemo(Sender.Find('Memo1')).Lines.Text, str);
                    for i := 0 to str.Count -1 do
                    begin
                        try
                            if Pos('urla.me', str.Strings[i]) = 0 then
                            begin
                                newUrl := urla.ShortenUrl(appSettings.Values['live-key'],
                                                          str.Strings[i],
                                                          signal);
                                txt := ReplaceAll(txt, str.Strings[i], newUrl);
                            end;
                        except
                            hasErrors := true;
                        end;
                    end;
                    urla.free;
                end;
                str.Free;

                if not hasErrors then
                begin
                    if accounts.IndexOf(_getSelectedUser) <> -1 then
                    begin
                        tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
                        if TImage(Sender.Find('Image1')).Hint <> '' then
                        tweeterID := tc.TweetMedia(txt, TImage(Sender.Find('Image1')).Hint)
                        else
                        tweeterID := tc.Tweet(txt);
                    end;
                end
                    else
                begin
                    _setIdle;
                    CanClose := false;
                    MsgError('Error', ExceptionMessage);
                end;
            except
                _setIdle;
                CanClose := false;
                MsgError('Error', ExceptionMessage);
            end;
        end;
    end
        else
    begin
        qname := QueTree.Selected.Text;
        if Pos('(', qname) > 0 then
        qname := copy(qname, 0, Pos('(', qname) -1);
        qname := Trim(qname);
        if Pos(' Campaign ', Sender.Caption) = 0 then
        queHome := root+'queues'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+qname+DirSep
        else
        queHome := root+'campaigns'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep;

        ForceDir(queHome);

        livePostErrors := false;
        if Sender.Hint = '' then
        twid := DateFormat('yyyymmddhhnnsszzz', Now)
        else
        twid := Sender.Hint;

        if Sender.ModalResult = mrOK then
        begin
            _setBusyScreen;
            txt := TMemo(Sender.Find('Memo1')).Lines.Text;

            str := TStringList.Create;
            if TCheckBox(Sender.Find('CheckBox1')).Checked then
            begin
                //change links to urla.me

                if Pos(' Campaign ', Sender.Caption) = 0 then
                signal := appSettings.Values['live-signal']
                else
                signal := 'trace:'+twid+'.tweet';

                urla := TUrla.Create;
                _getLinks(TMemo(Sender.Find('Memo1')).Lines.Text, str);
                for i := 0 to str.Count -1 do
                begin
                    try
                        if Pos('urla.me', str.Strings[i]) = 0 then
                        begin
                            newUrl := urla.ShortenUrl(appSettings.Values['live-key'],
                                                      str.Strings[i],
                                                      signal);
                            txt := ReplaceAll(txt, str.Strings[i], newUrl);
                        end;
                    except
                        hasErrors := true;
                    end;
                end;
                urla.free;
            end;

            if not hasErrors then
            begin
                str.Text := txt;
                str.SaveToFile(queHome+twid+'.tweet');
                str.free;

                if Pos('Live ', Sender.Caption) > 0 then
                begin
                    try
                        if accounts.IndexOf(_getSelectedUser) <> -1 then
                        begin
                            tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
                            tc.saveLiveTweetData(appSettings.Values['live-key'],
                                                 qname,
                                                 queHome+twid+'.tweet');
                        end;
                    except
                        _setIdle;
                        livePostErrors := true;
                        raise(ExceptionMessage);
                    end;
                end;

                if TImage(Sender.Find('Image1')).Hint <> '' then
                begin
                    DeleteFile(queHome+twid+FileExtOf(TImage(Sender.Find('Image1')).Hint));
                    copyFile(TImage(Sender.Find('Image1')).Hint,
                             queHome+twid+FileExtOf(TImage(Sender.Find('Image1')).Hint));

                    if Pos('Live ', Sender.Caption) > 0 then
                    begin
                        try
                            if accounts.IndexOf(_getSelectedUser) <> -1 then
                            begin
                                tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
                                tc.deleteLiveTweetData(appSettings.Values['live-key'],
                                                     qname,
                                                     queHome+twid+FileExtOf(TImage(Sender.Find('Image1')).Hint));
                                tc.saveLiveTweetData(appSettings.Values['live-key'],
                                                     qname,
                                                     queHome+twid+FileExtOf(TImage(Sender.Find('Image1')).Hint));
                            end;
                        except
                            _setIdle;
                            livePostErrors := true;
                            raise(ExceptionMessage);
                        end;
                    end;
                end;

                if livePostErrors then
                begin
                    _setIdle;
                    CanClose := false;
                    DeleteFile(queHome+twid+'.tweet');
                    DeleteFile(queHome+twid+FileExtOf(TImage(Sender.Find('Image1')).Hint));
                    MsgError('Error', 'Could not save Tweet Data, please try again.');
                end;

                if Pos(' Campaign ', Sender.Caption) > 0 then
                begin
                    //tweet now and get the id
                    try
                        if accounts.IndexOf(_getSelectedUser) <> -1 then
                        begin
                            tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
                            if TImage(Sender.Find('Image1')).Hint <> '' then
                            tweeterID := tc.TweetMedia(txt, TImage(Sender.Find('Image1')).Hint)
                            else
                            tweeterID := tc.Tweet(txt);
                            tweeterID := copy(tweeterID, Pos('=', tweeterID) +1, 10000);

                            RenameFile(queHome+twid+'.tweet', queHome+twid+'.tweet-'+tweeterID);
                        end;
                    except
                        _setIdle;
                        DeleteFile(queHome+twid+'.tweet-'+tweeterID);
                        DeleteFile(queHome+twid+FileExtOf(TImage(Sender.Find('Image1')).Hint));
                        CanClose := false;
                        MsgError('Error', ExceptionMessage);
                    end;
                end;
            end
                else
            begin
                _setIdle;
                DeleteFile(queHome+twid+'.tweet');
                DeleteFile(queHome+twid+FileExtOf(TImage(Sender.Find('Image1')).Hint));
                CanClose := false;
                MsgError('Error', 'Was not able to save Tweet Data, please try again.');
            end;
        end;
    end;
    _setIdle;
end;

procedure newtweet_OnShow(Sender: TForm);
begin
    if Pos('urla.me', TMemo(Sender.Find('Memo1')).Lines.Text) > 0 then
        TCheckBox(Sender.Find('CheckBox1')).Checked := true;

    if Pos(' Campaign ', Sender.Caption) > 0 then
    begin
        TCheckBox(Sender.Find('CheckBox1')).Checked := true;
        TCheckBox(Sender.Find('CheckBox1')).Caption := 'Trace Clicks';
        TCheckBox(Sender.Find('CheckBox1')).Enabled := false;
    end;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//newtweet initialization constructor
constructor
begin 
end.
