////////////////////////////////////////////////////////////////////////////////
// Unit Description  : trending Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Sunday 01, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

var
    CountryCodes: TStringList;

//constructor of trending
function trendingCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @trending_OnCreate, 'trending');
end;

//OnCreate Event of trending
procedure trending_OnCreate(Sender: TForm);
var
    i: int;
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);

    CountryCodes := TStringList.Create;
    CountryCodes.LoadFromResource('trendingcodes');
    CountryCodes.Sort;

    for i := 0 to CountryCodes.Count -1 do
        TComboBox(Sender.Find('ComboBox1')).Items.Add(CountryCodes.Names[i]);

    TComboBox(Sender.Find('ComboBox1')).ItemIndex :=
        TComboBox(Sender.Find('ComboBox1')).Items.IndexOf('Worldwide');

    PopulateTrending(Sender, TComboBox(Sender.Find('ComboBox1')).ItemIndex);

    TButton(Sender.Find('Button1')).ModalResult := mrCancel;
    TButton(Sender.Find('Button2')).ModalResult := mrOK;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TComboBox(Sender.find('ComboBox1')).OnChange := @trending_ComboBox1_OnChange;
    TTreeView(Sender.find('TreeView1')).OnDblClick := @trending_TreeView1_OnDblClick;
    TTreeView(Sender.find('TreeView1')).OnChange := @trending_TreeView1_OnChange;
    Sender.OnClose := @trending_OnClose;
    Sender.OnCloseQuery := @trending_OnCloseQuery;
    //</events-bind>
end;

procedure PopulateTrending(Sender: TForm; index: int);
var
    tc: TTwitter;
    i: int;
    node: TTreeNode;
begin
    if (_getSelectedUser <> '') then
    begin
        if accounts.IndexOf(_getSelectedUser) <> -1 then
        begin
            tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
            try
                //note: 1 is world wide, we can add later country codes
                tc.listTrending(StrToIntDef(CountryCodes.ValueByIndex(index), 1));
            except end;

            TTreeView(Sender.Find('TreeView1')).Items.Clear;

            for i := 0 to tc.Trending.Count -1 do
            begin
                if tc.Trending.Items[i].Name <> 'Worldwide' then
                begin
                    if tc.Trending.Items[i].TweetVolume <> 0 then
                    begin
                        node := TTreeView(Sender.Find('TreeView1')).Items.Add(tc.Trending.Items[i].Name+' ('+doubleformat('#,##0', tc.Trending.Items[i].TweetVolume)+')');
                        node.ImageIndex := 0;
                        node.SelectedIndex := node.ImageIndex;
                    end;
                end;
            end;

            TTreeView(Sender.Find('TreeView1')).AlphaSort;
        end;
    end;
end;

procedure trending_TreeView1_OnChange(Sender: TTreeView; Node: TTreeNode);
begin
    TButton(Sender.Owner.Find('Button2')).Enabled := (Sender.Selected <> nil)
end;

procedure trending_TreeView1_OnDblClick(Sender: TTreeView);
begin
    if Sender.Selected <> nil then
    TForm(Sender.Owner).ModalResult := mrOK;
end;

procedure trending_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    CountryCodes.free;
    Action := caFree;
end;

procedure trending_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin

    end;
end;

procedure trending_ComboBox1_OnChange(Sender: TComboBox);
begin
    PopulateTrending(TForm(Sender.Owner), Sender.ItemIndex);
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//trending initialization constructor
constructor
begin 
end.
