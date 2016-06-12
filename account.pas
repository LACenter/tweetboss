////////////////////////////////////////////////////////////////////////////////
// Unit Description  : account Description
// Unit Author       : LA.Center Corporation
// Date Created      : April, Wednesday 27, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of account
function accountCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @account_OnCreate, 'account');
end;

//OnCreate Event of account
procedure account_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;

    TLabel(Sender.Find('Label1')).Font.Style := fsBold;
    TButton(Sender.Find('bCancel')).ModalResult := mrCancel;
    TButton(Sender.Find('bOK')).ModalResult := mrOK;
    _setFonts(Sender);
    TUrlLink(Sender.Find('UrlLink1')).Font.Color := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink1')).setTag(-1);
    TLabel(Sender.Find('Label11')).Font.Size := 0;
    TLabel(Sender.Find('Label11')).Font.Style := fsItalic;
    TLabel(Sender.Find('Label11')).Font.Color := clMaroon;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TEdit(Sender.find('Edit1')).OnChange := @account_Edit1_OnChange;
    TEdit(Sender.find('Edit2')).OnChange := @account_Edit1_OnChange;
    Sender.OnClose := @account_OnClose;
    Sender.OnCloseQuery := @account_OnCloseQuery;
    //</events-bind>
end;

procedure account_Edit1_OnChange(Sender: TEdit);
begin
    TButton(Sender.Owner.Find('bOK')).Enabled :=
        (Trim(TEdit(Sender.Owner.Find('Edit1')).Text) <> '') and
        (Trim(TEdit(Sender.Owner.Find('Edit2')).Text) <> '');
end;

procedure account_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure account_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    user: string;
    pass: string;
    tc: TTwitter;
    http: THttp;
    fs: TFileStream;
    imageFile: string;
begin
    if Sender.ModalResult = mrOK then
    begin
        try
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            user := TEdit(Sender.Find('Edit1')).Text;
            pass := TEdit(Sender.Find('Edit2')).Text;
            tc := TTwitter.Create;
            if tc.Login(user, pass) then
            begin
                ForceDir(root+'accounts'+DirSep+tc.AccountUserName);

                if Pos('.jpg', Lower(tc.AccountImageUrl)) > 0 then
                    imageFile := root+'accounts'+DirSep+tc.AccountUserName+DirSep+'profile.jpg'
                else if Pos('.jpeg', Lower(tc.AccountImageUrl)) > 0 then
                    imageFile := root+'accounts'+DirSep+tc.AccountUserName+DirSep+'profile.jpeg'
                else if Pos('.gif', Lower(tc.AccountImageUrl)) > 0 then
                    imageFile := root+'accounts'+DirSep+tc.AccountUserName+DirSep+'profile.gif'
                else if Pos('.png', Lower(tc.AccountImageUrl)) > 0 then
                    imageFile := root+'accounts'+DirSep+tc.AccountUserName+DirSep+'profile.png';

                http := THttp.Create;
                fs := TFileStream.Create(imageFile, fmCreate);
                http.urlGetBinary(tc.AccountImageUrl, fs);
                fs.free;
                http.free;

                actXML.Close;
                actXML.LoadFromXMLFile(actXML.FileName);
                actXML.Open;
                actXML.Append;
                actXML.Field('username').Text := tc.AccountUserName;
                actXML.Field('displayname').Text := tc.AccountDisplayname;
                actXML.Field('imageurl').Text := tc.AccountImageUrl;
                actXML.SaveToXMLFile(actXML.FileName);
                actXML.Close;

                accounts.AddObject('@'+tc.AccountUserName, tc);

                TAction(MainForm.Find('actPopulateAccounts')).Execute;

                _DoAfterLogin('@'+tc.AccountUserName);
            end;
        except
            MsgError('Error', ExceptionMessage);
            CanClose := false;
        end;

        Screen.Cursor := crDefault;
        Application.ProcessMessages;
    end;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//account initialization constructor
constructor
begin 
end.
