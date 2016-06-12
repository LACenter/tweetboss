////////////////////////////////////////////////////////////////////////////////
// Unit Description  : newqueue Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Saturday 07, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of newqueue
function newqueueCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @newqueue_OnCreate, 'newqueue');
end;

//OnCreate Event of newqueue
procedure newqueue_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);
    TLabel(Sender.Find('Label1')).Font.Style := fsBold;
    TButton(Sender.Find('Button1')).ModalResult := mrCancel;
    TButton(Sender.Find('Button2')).ModalResult := mrOK;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TEdit(Sender.find('Edit1')).OnChange := @newqueue_Edit1_OnChange;
    Sender.OnClose := @newqueue_OnClose;
    Sender.OnCloseQuery := @newqueue_OnCloseQuery;
    Sender.OnShow := @newqueue_OnShow;
    //</events-bind>
end;

procedure newqueue_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure newqueue_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    queHome: string;
    str: TStringList;
    canCreate: bool = false;
    isEdit: bool = false;
    tc: TTwitter;
begin
    queHome := root+'queues'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+TEdit(Sender.Find('Edit1')).Text+DirSep;

    if Sender.ModalResult = mrOK then
    begin
        if not _ValidateName(TEdit(Sender.Find('Edit1')).Text) then
        begin
            CanClose := false;
            exit;
        end;

        isEdit := (Pos('Edit ', Sender.Caption) > 0);

        if not DirExists(queHome) or isEdit then
        begin
            if Pos('Live ', Sender.Caption) > 0 then
            begin
                _setBusyScreen;
                if accounts.IndexOf(_getSelectedUser) <> -1 then
                begin
                    tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
                    try
                        if isEdit then
                        tc.updateLiveQueue(appSettings.Values['live-key'],
                                        TEdit(Sender.Find('Edit1')).Text,
                                        twtOnline,
                                        TComboBox(Sender.Find('ComboBox1')).ItemIndex,
                                        TComboBox(Sender.Find('ComboBox2')).ItemIndex)
                        else
                        tc.addLiveQueue(appSettings.Values['live-key'],
                                        TEdit(Sender.Find('Edit1')).Text,
                                        twtOnline,
                                        TComboBox(Sender.Find('ComboBox1')).ItemIndex,
                                        TComboBox(Sender.Find('ComboBox2')).ItemIndex,
                                        copy(_getSelectedUser, 2, 1000)); //<- important user must be without the @
                        canCreate := true;
                    except
                        _setIdle;
                        canCreate := false;
                        CanClose := false;
                        if Pos('UNIQUE', ExceptionMessage) > 0 then
                        MsgError('Error', 'Queue name is already in use, please enter a new name')
                        else
                        MsgError('Error', ExceptionMessage);
                        exit;
                    end;
                end;
            end
                else
                canCreate := true;

            if canCreate then
            begin
                ForceDir(queHome);
                str := TStringList.Create;
                str.Add('name='+TEdit(Sender.Find('Edit1')).Text);
                if Pos('Live ', Sender.Caption) > 0 then
                str.Add('type=1')
                else
                str.Add('type=0');
                str.Add('paused=1');
                str.Add('interval='+IntToStr(TComboBox(Sender.Find('ComboBox2')).ItemIndex));
                str.Add('sequence='+IntToStr(TComboBox(Sender.Find('ComboBox1')).ItemIndex));
                str.Add('user='+_getSelectedUser);
                str.SaveToFile(queHome+'queue.manifest');
                str.free;
            end;
        end
            else
        begin
            _setIdle;
            CanClose := false;
            MsgError('Error', 'Queue name is already in use, please enter a new name');
        end;
    end;
    _setIdle;
end;

procedure newqueue_Edit1_OnChange(Sender: TEdit);
begin
    TButton(Sender.Owner.Find('Button2')).Enabled :=
        (Trim(Sender.Text) <> '');
end;

procedure newqueue_OnShow(Sender: TForm);
begin
    if Pos('Local ', Sender.Caption) > 0 then
    begin
        while (TComboBox(Sender.Find('ComboBox2')).Items.Count <> 7) do
            TComboBox(Sender.Find('ComboBox2')).Items.Delete(7);
    end;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//newqueue initialization constructor
constructor
begin 
end.
