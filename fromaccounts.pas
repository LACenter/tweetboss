////////////////////////////////////////////////////////////////////////////////
// Unit Description  : fromaccounts Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Wednesday 11, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of fromaccounts
function fromaccountsCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @fromaccounts_OnCreate, 'fromaccounts');
end;

//OnCreate Event of fromaccounts
procedure fromaccounts_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);
    TButton(Sender.Find('Button1')).ModalResult := mrCancel;
    TButton(Sender.Find('Button2')).ModalResult := mrOK;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TCheckListBox(Sender.find('chkList')).OnClickCheck := @fromaccounts_chkList_OnClickCheck;
    Sender.OnClose := @fromaccounts_OnClose;
    Sender.OnCloseQuery := @fromaccounts_OnCloseQuery;
    Sender.OnShow := @fromaccounts_OnShow;
    //</events-bind>
end;

procedure fromaccounts_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure processLikes(Sender: TForm);
var
    i: int;
    chk: TCheckListBox;
    tc: TTwitter;
begin
    chk := TCheckListBox(Sender.Find('chkList'));

    _setBusyScreen;
    for i := 0 to chk.Items.Count -1 do
    begin
        if chk.Checked[i] then
        begin
            if FileExists(root+'accounts'+DirSep+copy(chk.Items.Strings[i], 2, 1000)+DirSep+'fav.list') then
                favList.LoadFromFile(root+'accounts'+DirSep+copy(chk.Items.Strings[i], 2, 1000)+DirSep+'fav.list');

            tc := TTwitter(accounts.Objects[accounts.IndexOf(chk.Items.Strings[i])]);
            try
                tc.likeTweet(Sender.Hint);
                if favList.IndexOf(Sender.Hint) = -1 then
                    favList.Add(Sender.Hint);
            except end;

            favList.SaveToFile(root+'accounts'+DirSep+copy(chk.Items.Strings[i], 2, 1000)+DirSep+'fav.list');
        end;
    end;
    _setIdle;
end;

procedure processRetweet(Sender: TForm);
var
    i: int;
    chk: TCheckListBox;
    tc: TTwitter;
begin
    chk := TCheckListBox(Sender.Find('chkList'));

    _setBusyScreen;
    for i := 0 to chk.Items.Count -1 do
    begin
        if chk.Checked[i] then
        begin
            if FileExists(root+'accounts'+DirSep+copy(chk.Items.Strings[i], 2, 1000)+DirSep+'fav.list') then
                favList.LoadFromFile(root+'accounts'+DirSep+copy(chk.Items.Strings[i], 2, 1000)+DirSep+'fav.list');

            tc := TTwitter(accounts.Objects[accounts.IndexOf(chk.Items.Strings[i])]);
            try
                tc.reTweet(Sender.Hint);
                if favList.IndexOf('RT'+Sender.Hint) = -1 then
                    favList.Add('RT'+Sender.Hint);
            except end;

            favList.SaveToFile(root+'accounts'+DirSep+copy(chk.Items.Strings[i], 2, 1000)+DirSep+'fav.list');
        end;
    end;
    _setIdle;
end;

procedure processFollow(Sender: TForm);
var
    i: int;
    chk: TCheckListBox;
    tc: TTwitter;
begin
    chk := TCheckListBox(Sender.Find('chkList'));

    _setBusyScreen;
    for i := 0 to chk.Items.Count -1 do
    begin
        if chk.Checked[i] then
        begin
            tc := TTwitter(accounts.Objects[accounts.IndexOf(chk.Items.Strings[i])]);
            try
                tc.followUser(Sender.Hint);
            except end;
        end;
    end;
    _setIdle;
end;

procedure fromaccounts_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    i: int;
begin
    if Sender.ModalResult = mrOK then
    begin
        if Pos('Like ',  Sender.Caption) then
            processLikes(Sender);

        if Pos('Re-Tweet ',  Sender.Caption) then
            processRetweet(Sender);

        if Pos('Follow ',  Sender.Caption) then
            processFollow(Sender);
    end;
end;

procedure fromaccounts_OnShow(Sender: TForm);
var
    i: int;
    chk: TCheckListBox;
begin
    chk := TCheckListBox(Sender.Find('chkList'));
    _listConnectedUsers(chk.Items);
    for i := 0 to chk.Items.Count -1 do
        chk.Checked[i] := true;
end;

procedure fromaccounts_chkList_OnClickCheck(Sender: TCheckListBox);
var
    i: int;
    c: int = 0;
    chk: TCheckListBox;
begin
    chk := TCheckListBox(Sender.Owner.Find('chkList'));
    for i := 0 to chk.Items.Count -1 do
    begin
        if chk.Checked[i] then
        c := c +1;
    end;
    TButton(Sender.Owner.Find('Button2')).Enabled := (c <> 0);
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//fromaccounts initialization constructor
constructor
begin 
end.
