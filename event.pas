////////////////////////////////////////////////////////////////////////////////
// Unit Description  : event Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Friday 13, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

var
    TriggerFiles: TStringList;

//constructor of event
function eventCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @event_OnCreate, 'event');
end;

//OnCreate Event of event
procedure event_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);
    TButton(Sender.Find('Button1')).ModalResult := mrCancel;
    TButton(Sender.Find('Button2')).ModalResult := mrOK;
    TLabel(Sender.Find('Label4')).Font.Style := fsItalic;
    TLabel(Sender.Find('Label4')).Font.Color := clMaroon;

    TriggerFiles := TStringList.Create;

    populateMatchingActions(Sender);

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TEdit(Sender.find('Edit1')).OnChange := @event_Edit1_OnChange;
    TComboBox(Sender.find('ComboBox2')).OnChange := @event_ComboBox2_OnChange;
    TComboBox(Sender.find('ComboBox1')).OnChange := @event_ComboBox1_OnChange;
    Sender.OnClose := @event_OnClose;
    Sender.OnCloseQuery := @event_OnCloseQuery;
    Sender.OnShow := @event_OnShow;
    //</events-bind>
end;

procedure ValidateEvent(Sender: TForm);
begin
    if TComboBox(Sender.Find('ComboBox1')).ItemIndex in [0,1] then
    TButton(Sender.Find('Button2')).Enabled :=
        (trim(TComboBox(Sender.Find('ComboBox2')).Text) <> '') and
        (trim(TEdit(Sender.Find('Edit1')).Text) <> '')
    else
    TButton(Sender.Find('Button2')).Enabled :=
        (trim(TComboBox(Sender.Find('ComboBox2')).Text) <> '');
end;

procedure populateMatchingActions(Sender: TForm);
var
    files: TStringList;
    home: string;
    i: int;
    str: TStringList;
    combo: TComboBox;
    combo2: TComboBox;
    canAdd: bool;
begin
    home := root+'actions'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep;
    combo := TComboBox(Sender.Find('ComboBox1'));
    combo2 := TComboBox(Sender.Find('ComboBox2'));

    combo2.Items.Clear;
    TriggerFiles.Clear;

    files := TStringList.Create;
    SearchDir(home, '*', files);

    for i := files.Count -1 downto 0 do
    begin
        canAdd := false;
        if (Pos('.action', files.Strings[i]) > 0) then
        begin
            str := TStringList.Create;
            str.LoadFromFile(files.Strings[i]);

            case combo.ItemIndex of
                0:  if StrToInt(str.Values['action']) in [0,2,4,5,6,7] then canAdd := true;
                1:  if StrToInt(str.Values['action']) in [0,2,4,5,6,7] then canAdd := true;
                2:  if StrToInt(str.Values['action']) in [0,1,6,7] then canAdd := true;
                3:  if StrToInt(str.Values['action']) in [0,6,7] then canAdd := true;
                4:  if StrToInt(str.Values['action']) in [0,6,7] then canAdd := true;
                5:  if StrToInt(str.Values['action']) in [0,2,4,6,7] then canAdd := true;
                6:  if StrToInt(str.Values['action']) in [0,1,3,6,7] then canAdd := true;
            end;

            if canAdd then
            begin
                TriggerFiles.Add(FileNameOf(files.Strings[i]));
                combo2.Items.Add(str.Values['name']);
            end;

            str.Free;
        end;
    end;

    files.Free;
end;

procedure event_ComboBox1_OnChange(Sender: TComboBox);
begin
    TEdit(Sender.Owner.Find('Edit1')).Enabled := false;
    TLabel(Sender.Owner.Find('Label3')).Enabled := false;
    TLabel(Sender.Owner.Find('Label4')).Enabled := false;

    case Sender.ItemIndex of
        0:
            begin
                TLabel(Sender.Owner.Find('Label4')).Enabled := true;
                TLabel(Sender.Owner.Find('Label3')).Enabled := true;
                TEdit(Sender.Owner.Find('Edit1')).Enabled := true;
                TLabel(Sender.Owner.Find('Label3')).Caption := 'Please enter Twitter @Username:(optional #hashtag)';
                TLabel(Sender.Owner.Find('Label4')).Caption := 'Example: @liveappscenter, or @liveappshelp:#tutorial';
            end;
        1:
            begin
                TLabel(Sender.Owner.Find('Label4')).Enabled := true;
                TLabel(Sender.Owner.Find('Label3')).Enabled := true;
                TEdit(Sender.Owner.Find('Edit1')).Enabled := true;
                TLabel(Sender.Owner.Find('Label3')).Caption := 'Please enter Twitter #Hashtag';
                TLabel(Sender.Owner.Find('Label4')).Caption := 'Example: #LiveApps, or "Live Applications"';
            end;
    end;

    populateMatchingActions(TForm(Sender.Owner));
    ValidateEvent(TForm(Sender.Owner));
end;

procedure event_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    TriggerFiles.Free;
    Action := caFree;
end;

procedure event_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    home: string;
    tc: TTwitter;
    str: TStringList;
    trid: string;
    isEdit: bool;
begin
    home := root+'actions'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep;
    tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

    if Sender.Hint <> '' then
    begin
        trid := Sender.Hint;
        isEdit := true;
    end
        else
    begin
        trid := DateFormat('yyyymmddhhnnzzz', Now);
        isEdit := false;
    end;

    if Sender.ModalResult = mrOK then
    begin
        if not FileExists(home+trid+'.trigger') or isEdit then
        begin
            str := TStringList.Create;
            str.Add('event='+IntToStr(TComboBox(Sender.Find('ComboBox1')).ItemIndex));
            str.Add('query='+TEdit(Sender.Find('Edit1')).Text);
            str.Add('actionname='+TComboBox(Sender.Find('ComboBox2')).Text);
            str.Add('actionfile='+TriggerFiles.Strings[TComboBox(Sender.Find('ComboBox2')).ItemIndex]);
            str.Add('user='+_getSelectedUser);
            str.SaveToFile(home+trid+'.trigger');
            str.Free;

            try
                _setBusyScreen;
                if isEdit then
                tc.updateEvent(appSettings.Values['live-key'],
                               home+trid+'.trigger')
                else
                tc.createEvent(appSettings.Values['live-key'],
                               home+trid+'.trigger');
            except
                _setIdle;
                if not isEdit then
                    DeleteFile(home+trid+'.trigger');
                CanClose := false;
                MsgError('Error', ExceptionMessage);
            end;
        end;
    end;
    _setIdle;
end;

procedure event_ComboBox2_OnChange(Sender: TComboBox);
begin
    ValidateEvent(TForm(Sender.Owner));
end;

procedure event_Edit1_OnChange(Sender: TEdit);
begin
    ValidateEvent(TForm(Sender.Owner));
end;

procedure event_OnShow(Sender: TForm);
begin
    ValidateEvent(Sender);
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//event initialization constructor
constructor
begin 
end.
