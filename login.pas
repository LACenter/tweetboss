////////////////////////////////////////////////////////////////////////////////
// Unit Description  : login Description
// Unit Author       : LA.Center Corporation
// Date Created      : April, Wednesday 27, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of login
function loginCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @login_OnCreate, 'login');
end;

//OnCreate Event of login
procedure login_OnCreate(Sender: TForm);
var
    user: string;
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);

    TLabel(Sender.Find('lUser')).Font.Style := fsBold;
    TLabel(Sender.Find('lName')).Font.Style := fsBold;
    if OSX then
    TLabel(Sender.Find('lName')).Font.Size := 18
    else
    TLabel(Sender.Find('lName')).Font.Size := 14;
    TShape(Sender.Find('Shape1')).Pen.Color := Sender.Font.Color;
    TButton(Sender.Find('bCancel')).ModalResult := mrCancel;
    TButton(Sender.Find('bOK')).ModalResult := mrOK;

    TLabel(Sender.Find('lUser')).Caption := loginUser;
    TLabel(Sender.Find('lName')).Caption := loginName;

    user := ReplaceOnce(loginUser, '@', '');

    if FileExists(root+'accounts'+DirSep+user+DirSep+'profile.jpg') then
        TImage(Sender.Find('img')).Picture.LoadFromFile(root+'accounts'+DirSep+user+DirSep+'profile.jpg')
    else if FileExists(root+'accounts'+DirSep+user+DirSep+'profile.jpeg') then
        TImage(Sender.Find('img')).Picture.LoadFromFile(root+'accounts'+DirSep+user+DirSep+'profile.jpeg')
    else if FileExists(root+'accounts'+DirSep+user+DirSep+'profile.gif') then
        TImage(Sender.Find('img')).Picture.LoadFromFile(root+'accounts'+DirSep+user+DirSep+'profile.gif')
    else if FileExists(root+'accounts'+DirSep+user+DirSep+'profile.png') then
        TImage(Sender.Find('img')).Picture.LoadFromFile(root+'accounts'+DirSep+user+DirSep+'profile.png');

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TEdit(Sender.find('Edit1')).OnChange := @login_Edit1_OnChange;
    Sender.OnClose := @login_OnClose;
    Sender.OnCloseQuery := @login_OnCloseQuery;
    //</events-bind>
end;

procedure login_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure login_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    user: string;
    pass: string;
    tc: TTwitter;
begin
    if Sender.ModalResult = mrOK then
    begin
        Screen.Cursor := crHourGlass;
        Application.ProcessMessages;

        user := ReplaceOnce(loginUser, '@', '');
        pass := TEdit(Sender.Find('Edit1')).Text;
        tc := TTwitter.Create;
        try
            tc.Login(user, pass);
            accounts.AddObject(loginUser, tc);

            _DoAfterLogin(loginUser);

            actXML.Close;
            actXML.LoadFromXMLFile(actXML.FileName);
            actXML.Open;
            while not actXML.Eof do
            begin
                if actXML.Field('username').Text = user then
                begin
                    actXML.Edit;
                    if TCheckBox(Sender.Find('CheckBox1')).Checked then
                    begin
                        actXML.Field('password').Text := pass;
                        actXML.Field('storepass').Text := '1';
                    end
                        else
                    begin
                        actXML.Field('password').Text := '';
                        actXML.Field('storepass').Text := '0';
                    end;
                    break;
                end;
                actXML.Next;
            end;
            actXML.SaveToXMLFile(actXML.FileName);
            actXML.Close;
        except
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
            CanClose := false;
            tc.Free;
            MsgError('Error', ExceptionMessage);
        end;

        Screen.Cursor := crDefault;
        Application.ProcessMessages;
    end;
end;

procedure login_Edit1_OnChange(Sender: TEdit);
begin
    TButton(Sender.Owner.Find('bOK')).Enabled :=
        (Trim(Sender.Text) <> '');
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//login initialization constructor
constructor
begin 
end.
