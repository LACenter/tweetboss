////////////////////////////////////////////////////////////////////////////////
// Unit Description  : delquery Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Sunday 01, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of delquery
function delqueryCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @delquery_OnCreate, 'delquery');
end;

//OnCreate Event of delquery
procedure delquery_OnCreate(Sender: TForm);
var
    i: int;
    str: TStringList;
    node: TTreeNode;
    queryFile: string;
    tree: TTreeView;
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);

    queryFile := root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'queries.timeline';
    tree := TTreeView(Sender.Find('TreeView1'));
    str := TStringList.Create;
    if FileExists(queryFile) then
        str.LoadFromFile(queryFile);

    str.Sort;

    for i := 0 to str.Count -1 do
    begin
        node := tree.Items.Add(str.ValueByIndex(i));
        if str.Names[i] = 'user' then
        node.ImageIndex := 0
        else
        node.ImageIndex := 1;
        node.SelectedIndex := node.ImageIndex;
    end;
    str.free;

    TButton(Sender.Find('Button2')).ModalResult := mrCancel;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TButton(Sender.find('Button1')).OnClick := @delquery_Button1_OnClick;
    TTreeView(Sender.find('TreeView1')).OnChange := @delquery_TreeView1_OnChange;
    Sender.OnClose := @delquery_OnClose;
    Sender.OnCloseQuery := @delquery_OnCloseQuery;
    //</events-bind>
end;

procedure delquery_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure delquery_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    str: TStringList;
    tree: TTreeView;
    i: int;
    queryFile: string;
begin
    queryFile := root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'queries.timeline';
    tree := TTreeView(Sender.Find('TreeView1'));
    str := TStringList.Create;
    for i := 0 to tree.Items.Count -1 do
    begin
        if tree.Items.Item[i].ImageIndex = 0 then
        str.Add('user='+tree.Items.Item[i].Text)
        else
        str.Add('hash='+tree.Items.Item[i].Text);
    end;
    str.SaveToFile(queryFile);
    str.free;

    TimelineTree.Items.Item[0].Selected := true;
end;

procedure delquery_TreeView1_OnChange(Sender: TTreeView; Node: TTreeNode);
begin
    TButton(Sender.Owner.Find('Button1')).Enabled :=
        (Sender.Selected <> nil);
end;

procedure delquery_Button1_OnClick(Sender: TButton);
begin
    if TTreeView(Sender.Owner.Find('TreeView1')).Selected <> nil then
        TTreeView(Sender.Owner.Find('TreeView1')).Selected.Delete;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//delquery initialization constructor
constructor
begin 
end.
