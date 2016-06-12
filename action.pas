////////////////////////////////////////////////////////////////////////////////
// Unit Description  : action Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Thursday 12, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of action
function actionCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @action_OnCreate, 'action');
end;

//OnCreate Event of action
procedure action_OnCreate(Sender: TForm);
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
    TEdit(Sender.find('Edit1')).OnChange := @action_Edit1_OnChange;
    TMemo(Sender.find('Memo1')).OnChange := @action_Memo1_OnChange;
    TComboBox(Sender.find('ComboBox1')).OnChange := @action_ComboBox1_OnChange;
    Sender.OnClose := @action_OnClose;
    Sender.OnCloseQuery := @action_OnCloseQuery;
    Sender.OnShow := @action_OnShow;
    //</events-bind>
end;

procedure action_ComboBox1_OnChange(Sender: TComboBox);
begin
    case Sender.ItemIndex of
        0,2:
            begin
                TPanel(Sender.Owner.Find('Panel1')).Visible := false;
                TLabel(Sender.Owner.Find('Label3')).Visible := true;
                TMemo(Sender.Owner.Find('Memo1')).Visible := true;
                action_Memo1_OnChange(TMemo(Sender.Owner.Find('Memo1')));
            end;
        1,3:
            begin
                TPanel(Sender.Owner.Find('Panel1')).Visible := false;
                TLabel(Sender.Owner.Find('Label3')).Visible := true;
                TMemo(Sender.Owner.Find('Memo1')).Visible := true;
                TLabel(Sender.Owner.Find('Label3')).Caption := 'Message Text';
            end;
        4,5,6,7:
            begin
                TPanel(Sender.Owner.Find('Panel1')).Visible := true;
                TLabel(Sender.Owner.Find('Label3')).Visible := false;
                TMemo(Sender.Owner.Find('Memo1')).Visible := false;
            end;
    end;

    ValidateAction(TForm(Sender.Owner));
end;

procedure action_Memo1_OnChange(Sender: TMemo);
begin
    if TComboBox(Sender.Owner.Find('ComboBox1')).ItemIndex in [0,2] then
    begin
        TLabel(Sender.Owner.Find('Label3')).Caption :=
            'Tweet Text ('+IntToStr(_calcChars(Sender.Lines.Text, false, true))+' characters)';
        if Pos('-', TLabel(Sender.Owner.Find('Label3')).Caption) > 0 then
            TLabel(Sender.Owner.Find('Label3')).Font.Color := clRed
            else
            TLabel(Sender.Owner.Find('Label3')).Font.Color := $00444444;
    end
        else
        TLabel(Sender.Owner.Find('Label3')).Font.Color := $00444444;

    ValidateAction(TForm(Sender.Owner));
end;

procedure action_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure action_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    actid: string;
    home: string;
    str: TStringList;
    isEdit: bool;
    tc: TTwitter;
    txt, signal, newUrl: string;
    hasErrors: bool = false;
    i: int;
    urla: TUrla;
begin
    home := root+'actions'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep;
    tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

    ForceDir(home);

    if Sender.Hint <> '' then
    begin
        actid := Sender.Hint;
        isEdit := true;
    end
        else
    begin
        actid := DateFormat('yyyymmddhhnnzzz', Now);
        isEdit := false;
    end;

    if Sender.ModalResult = mrOK then
    begin
        if not FileExists(home+actid+'.action') or isEdit then
        begin
            str := TStringList.Create;
            str.Add('name='+TEdit(Sender.Find('Edit1')).Text);
            str.Add('action='+IntToStr(TComboBox(Sender.Find('ComboBox1')).ItemIndex));
            str.SaveToFile(home+actid+'.action');
            str.Free;

            if TComboBox(Sender.Find('ComboBox1')).ItemIndex in [4,5,6,7] then
                TMemo(Sender.Find('Memo1')).Lines.Text := '***'
            else
            begin
                txt := TMemo(Sender.Find('Memo1')).Lines.Text;
                str := TStringList.Create;
                if TCheckBox(Sender.Find('CheckBox1')).Checked then
                begin
                    //change links to urla.me
                    signal := appSettings.Values['live-signal'];

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
                TMemo(Sender.Find('Memo1')).Lines.Text := txt;
            end;

            TMemo(Sender.Find('Memo1')).Lines.SaveToFile(home+actid+'.txt');

            if not hasErrors then
            begin
                try
                    _setBusyScreen;
                    if isEdit then
                    tc.updateAction(appSettings.Values['live-key'],
                                    home+actid+'.action',
                                    home+actid+'.txt')
                    else
                    tc.createAction(appSettings.Values['live-key'],
                                    home+actid+'.action',
                                    home+actid+'.txt');
                except
                    _setIdle;
                    if not isEdit then
                    begin
                        DeleteFile(home+actid+'.action');
                        DeleteFile(home+actid+'.txt');
                    end;
                    CanClose := false;
                    MsgError('Error', ExceptionMessage);
                end;
            end
                else
            begin
                _setIdle;
                CanClose := false;
                MsgError('Error', ExceptionMessage);
            end;
        end;
    end;
    _setIdle;
end;

procedure ValidateAction(Sender: TForm);
var
    combo: TComboBox;
    edit: TEdit;
    memo: TMemo;
begin
    combo := TComboBox(Sender.Find('ComboBox1'));
    edit := TEdit(Sender.Find('Edit1'));
    memo := TMemo(Sender.Find('Memo1'));

    case combo.ItemIndex of
        0,1,2,3:
            begin
                TButton(Sender.Find('Button2')).Enabled :=
                    (trim(edit.Text) <> '') and
                    (trim(memo.Lines.Text) <> '') and
                    (Pos('-', TLabel(Sender.Find('Label3')).Caption) = 0);
            end;
        4,5,6,7:
            begin
                TButton(Sender.Find('Button2')).Enabled :=
                    (trim(edit.Text) <> '');
            end;
    end;

    if combo.ItemIndex in [1,3] then
        TLabel(Sender.Find('Label3')).Font.Color := $00444444;
end;

procedure action_Edit1_OnChange(Sender: TEdit);
begin
    ValidateAction(TForm(Sender.Owner));
end;

procedure action_OnShow(Sender: TForm);
begin
    action_Memo1_OnChange(TMemo(Sender.Find('Memo1')));
    action_ComboBox1_OnChange(TComboBox(Sender.Find('ComboBox1')));

    if Pos('urla.me', TMemo(Sender.Find('Memo1')).Lines.Text) > 0 then
        TCheckBox(Sender.Find('CheckBox1')).Checked := true;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//action initialization constructor
constructor
begin 
end.
