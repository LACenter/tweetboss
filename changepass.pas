////////////////////////////////////////////////////////////////////////////////
// Unit Description  : changepass Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Sunday 15, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of changepass
function changepassCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @changepass_OnCreate, 'changepass');
end;

//OnCreate Event of changepass
procedure changepass_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);

    TButton(Sender.Find('Button1')).ModalResult := mrCancel;
    TButton(Sender.Find('Button2')).ModalResult := mrOK;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TEdit(Sender.find('Edit3')).OnChange := @changepass_Edit3_OnChange;
    TEdit(Sender.find('Edit2')).OnChange := @changepass_Edit2_OnChange;
    TEdit(Sender.find('Edit1')).OnChange := @changepass_Edit1_OnChange;
    Sender.OnClose := @changepass_OnClose;
    Sender.OnCloseQuery := @changepass_OnCloseQuery;
    //</events-bind>
end;

procedure changepass_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure changepass_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    tc: TTwitter;
begin
    if Sender.ModalResult = mrOK then
    begin
        try
            _setBusyScreen;
            tc := TTwitter.Create;
            canClose := tc.changePassword(Sender.Hint,
                            TEdit(Sender.Find('Edit1')).Text,
                            TEdit(Sender.Find('Edit2')).Text);
            tc.Free;
        except
            _setIdle;
            CanClose := false;
            MsgError('Error', ExceptionMessage);
        end;
        if CanClose then
        begin
            actXML.Close;
            actXML.LoadFromXMLFile(actXML.FileName);
            actXML.Open;
            while not actXML.Eof do
            begin
                if actXML.Field('username').Text = Sender.Hint then
                begin
                    actXML.Edit;
                    actXML.Field('password').Text := TEdit(Sender.Find('Edit2')).Text;
                    if TCheckBox(Sender.Find('CheckBox1')).Checked then
                    actXML.Field('storepass').Text := '1'
                    else
                    actXML.Field('storepass').Text := '0';
                    break;
                end;
                actXML.Next;
            end;
            actXML.SaveToXMLFile(actXML.FileName);
            actXML.Close;
        end;
    end;
    _setIdle;
end;

procedure changepass_Edit1_OnChange(Sender: TEdit);
begin
    TButton(Sender.Owner.Find('Button2')).Enabled :=
        (Trim(TEdit(Sender.Owner.Find('Edit1')).Text) <> '') and
        (Trim(TEdit(Sender.Owner.Find('Edit2')).Text) <> '') and
        (TEdit(Sender.Owner.Find('Edit2')).Text = TEdit(Sender.Owner.Find('Edit3')).Text) and
end;

procedure changepass_Edit2_OnChange(Sender: TEdit);
begin
    changepass_Edit1_OnChange(Sender);
end;

procedure changepass_Edit3_OnChange(Sender: TEdit);
begin
    changepass_Edit1_OnChange(Sender);
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//changepass initialization constructor
constructor
begin 
end.
