////////////////////////////////////////////////////////////////////////////////
// Unit Description  : settings Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Sunday 15, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of settings
function settingsCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @settings_OnCreate, 'settings');
end;

//OnCreate Event of settings
procedure settings_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);

    TCalcEdit(Sender.Find('CalcEdit1')).Text := appSettings.Values['tweet-cycle'];
    TCheckBox(Sender.Find('CheckBox1')).Checked := (appSettings.Values['show-countdown'] = '1');

    TEdit(Sender.Find('Edit1')).Text := appSettings.Values['live-key'];
    TEdit(Sender.Find('Edit2')).Text := appSettings.Values['live-signal'];

    TButton(Sender.Find('Button1')).ModalResult := mrCancel;
    TButton(Sender.Find('Button2')).ModalResult := mrOK;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    Sender.OnClose := @settings_OnClose;
    Sender.OnCloseQuery := @settings_OnCloseQuery;
    //</events-bind>
end;

procedure settings_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure settings_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        appSettings.Values['tweet-cycle'] := TCalcEdit(Sender.Find('CalcEdit1')).Text;
        appSettings.Values['live-key'] := TEdit(Sender.Find('Edit1')).Text;
        appSettings.Values['live-signal'] := TEdit(Sender.Find('Edit2')).Text;
        if TCheckBox(Sender.Find('CheckBox1')).Checked then
        appSettings.Values['show-countdown'] := '1'
        else
        appSettings.Values['show-countdown'] := '0';
        appSettings.SaveToFile(root+'app.settings');

        populateLimit := StrToIntDef(appSettings.Values['tweet-cycle'], 10);
    end;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//settings initialization constructor
constructor
begin 
end.
