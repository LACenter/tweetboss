////////////////////////////////////////////////////////////////////////////////
// Unit Description  : addquery Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Sunday 01, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals', 'trending';

//constructor of addquery
function addqueryCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @addquery_OnCreate, 'addquery');
end;

//OnCreate Event of addquery
procedure addquery_OnCreate(Sender: TForm);
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
    TButton(Sender.find('Button3')).OnClick := @addquery_Button3_OnClick;
    TEdit(Sender.find('Edit1')).OnChange := @addquery_Edit1_OnChange;
    TRadioButton(Sender.find('RadioButton2')).OnClick := @addquery_RadioButton2_OnClick;
    TRadioButton(Sender.find('RadioButton1')).OnClick := @addquery_RadioButton1_OnClick;
    Sender.OnClose := @addquery_OnClose;
    Sender.OnCloseQuery := @addquery_OnCloseQuery;
    //</events-bind>
end;

procedure addquery_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure addquery_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    str: TStringList;
    queryFile: string;
begin
    if Sender.ModalResult = mrOK then
    begin
        str := TStringList.Create;
        queryFile := root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'queries.timeline';
        if FileExists(queryFile) then
        str.LoadFromFile(queryFile);

        if TRadioButton(Sender.Find('RadioButton1')).Checked then
        begin
            if Pos('@', TEdit(Sender.Find('Edit1')).Text) > 0 then
            str.Add('user='+TEdit(Sender.Find('Edit1')).Text)
            else
            str.Add('user=@'+TEdit(Sender.Find('Edit1')).Text);
        end
            else
        begin
            if Pos('#', TEdit(Sender.Find('Edit1')).Text) > 0 then
            str.Add('hash='+TEdit(Sender.Find('Edit1')).Text)
            else
            str.Add('hash=#'+TEdit(Sender.Find('Edit1')).Text);
        end;

        str.SaveToFile(queryFile);
        str.free;
    end;
end;

procedure addquery_RadioButton1_OnClick(Sender: TRadioButton);
begin
    TLabel(Sender.Owner.Find('Label2')).Caption := 'Please enter Twitter @Username';
end;

procedure addquery_RadioButton2_OnClick(Sender: TRadioButton);
begin
    TLabel(Sender.Owner.Find('Label2')).Caption := 'Please enter Twitter #Hashtag';
end;

procedure addquery_Edit1_OnChange(Sender: TEdit);
begin
    TButton(Sender.Owner.Find('Button2')).Enabled := (Trim(Sender.Text) <> '');
end;

procedure addquery_Button3_OnClick(Sender: TButton);
var
    f: TForm;
    s: string;
begin
    f := trendingCreate(Sender.Owner);
    if f.ShowModal = mrOK then
    begin
        s := TTreeView(f.Find('TreeView1')).Selected.Text;
        s := copy(s, 0, Pos('(', s) -1);
        TEdit(Sender.Owner.Find('Edit1')).Text := s;
        TRadioButton(Sender.Owner.Find('RadioButton2')).Checked := true;
        addquery_RadioButton2_OnClick(TRadioButton(Sender.Owner.Find('RadioButton2')));
    end;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//addquery initialization constructor
constructor
begin 
end.
