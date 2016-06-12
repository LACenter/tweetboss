////////////////////////////////////////////////////////////////////////////////
// Unit Description  : mutelist Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Sunday 15, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of mutelist
function mutelistCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @mutelist_OnCreate, 'mutelist');
end;

//OnCreate Event of mutelist
procedure mutelist_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);
    TButton(Sender.Find('Button2')).ModalResult := mrCancel;

    if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list') then
            muteList.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list');

    TListBox(Sender.Find('ListBox1')).Items.Assign(muteList);

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TButton(Sender.find('Button1')).OnClick := @mutelist_Button1_OnClick;
    TListBox(Sender.find('ListBox1')).OnClick := @mutelist_ListBox1_OnClick;
    TListBox(Sender.find('ListBox1')).OnChange := @mutelist_ListBox1_OnChange;
    Sender.OnClose := @mutelist_OnClose;
    Sender.OnCloseQuery := @mutelist_OnCloseQuery;
    //</events-bind>
end;

procedure mutelist_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure mutelist_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    muteList.Assign(TListBox(Sender.Find('ListBox1')).Items);
    muteList.SaveToFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list');
end;

procedure mutelist_ListBox1_OnChange(Sender: TListBox);
begin
    TButton(Sender.Owner.Find('Button1')).Enabled :=
        (Sender.ItemIndex <> -1);
end;

procedure mutelist_ListBox1_OnClick(Sender: TListBox);
begin
    mutelist_ListBox1_OnChange(Sender);
end;

procedure mutelist_Button1_OnClick(Sender: TButton);
begin
    TListBox(Sender.Owner.Find('ListBox1')).Items.
        Delete(TListBox(Sender.Owner.Find('ListBox1')).ItemIndex);
    mutelist_ListBox1_OnClick(TListBox(Sender.Owner.Find('ListBox1')));
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//mutelist initialization constructor
constructor
begin 
end.
