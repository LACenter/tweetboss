////////////////////////////////////////////////////////////////////////////////
// Unit Description  : accountman Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Sunday 15, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals', 'account', 'changepass';

//constructor of accountman
function accountmanCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @accountman_OnCreate, 'accountman');
end;

//OnCreate Event of accountman
procedure accountman_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);

    TButton(Sender.Find('bClose')).ModalResult := mrCancel;
    accountman_LoadAccounts(Sender);

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TButton(Sender.find('bDel')).OnClick := @accountman_bDel_OnClick;
    TButton(Sender.find('bEdit')).OnClick := @accountman_bEdit_OnClick;
    TListView(Sender.find('ListView1')).OnChange := @accountman_ListView1_OnChange;
    TButton(Sender.find('bAdd')).OnClick := @accountman_bAdd_OnClick;
    //</events-bind>
end;

procedure accountman_LoadAccounts(Sender: TForm);
var
    list: TListView;
    item: TListItem;
begin
    list := TListView(Sender.Find('ListView1'));
    list.Items.BeginUpdate;
    list.Items.Clear;

    actXML.Close;
    actXML.LoadFromXMLFile(actXML.FileName);
    actXML.Open;

    while not actXML.Eof do
    begin
        item := list.Items.Add;
        item.Caption := actXML.Field('displayname').Text+' ('+actXML.Field('username').Text+')';
        item.ImageIndex := 0;
        if actXML.Field('storepass').Text = '1' then
        item.SubItems.Add('YES')
        else
        item.SubItems.Add('NO');

        actXML.Next;
    end;

    actXML.Close;

    list.Items.EndUpdate;
end;

procedure accountman_bAdd_OnClick(Sender: TButton);
begin
    accountCreate(MainForm).ShowModal;
    accountman_LoadAccounts(TForm(Sender.Owner));
end;

procedure accountman_ListView1_OnChange(Sender: TListView; Item: TListItem; Change: TItemChange);
begin
    TButton(Sender.Owner.Find('bEdit')).Enabled := (Sender.SelCount <> 0);
    TButton(Sender.Owner.Find('bDel')).Enabled := (Sender.SelCount <> 0);
end;

procedure accountman_bEdit_OnClick(Sender: TButton);
var
    f: TForm;
    list: TListView;
    user: string;
begin
    list := TListView(Sender.Owner.Find('ListView1'));
    user := list.Selected.Caption;
    user := copy(user, Pos('(', user) +1, 1000);
    user := copy(user, 0, Pos(')', user) -1);

    f := changepassCreate(MainForm);
    f.Hint := user;
    if list.Selected.SubItems.Strings[0] = 'YES' then
        TCheckBox(f.find('CheckBox1')).Checked := true;
    if f.ShowModal = mrOK then
    begin
        if TCheckBox(f.find('CheckBox1')).Checked then
        list.Selected.SubItems.Strings[0] := 'YES'
        else
        list.Selected.SubItems.Strings[0] := 'NO';
    end;
end;

procedure accountman_bDel_OnClick(Sender: TButton);
var
    list: TListView;
    user: string;
begin
    list := TListView(Sender.Owner.Find('ListView1'));
    user := list.Selected.Caption;
    user := copy(user, Pos('(', user) +1, 1000);
    user := copy(user, 0, Pos(')', user) -1);

    if MsgWarning('Warning', 'You are about to delete a Twitter account, continue?') then
    begin
        actXML.Close;
        actXML.LoadFromXMLFile(actXML.FileName);
        actXML.Open;
        while not actXML.Eof do
        begin
            if actXML.Field('username').Text = user then
            begin
                actXML.Delete;
                break;
            end;
            actXML.Next;
        end;
        actXML.SaveToXMLFile(actXML.FileName);
        actXML.Close;

        _RemoveAccount('@'+user);
    end;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//accountman initialization constructor
constructor
begin 
end.
