////////////////////////////////////////////////////////////////////////////////
// Unit Description  : ques Description
// Unit Author       : LA.Center Corporation
// Date Created      : April, Thursday 28, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals', 'newqueue', 'newtweet';

//constructor of ques
function quesCreate(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructorFromResource(Owner, @ques_OnCreate, 'ques');
end;

//OnCreate Event of ques
procedure ques_OnCreate(Sender: TFrame);
var
    root: TTreeNode;
    child: TTreeNode;
begin
    //Frame Constructor

    //todo: some additional constructing code
    Sender.Caption := Application.Title;
    Sender.Font.Color := $00444444;
    if OSX then
    Sender.Font.Size := 12
    else
    Sender.Font.Size := 10;
    _setFonts(Sender);

    _setButton(TBGRAButton(Sender.Find('bMenu')), false, false);
    _setButton(TBGRAButton(Sender.Find('bMenu2')), false, false);

    TLabel(Sender.Find('lUser')).Font.Style := fsBold;

    TUrlLink(Sender.Find('UrlLink1')).Font.Color := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink1')).ColorHovered := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink1')).ColorVisited := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink2')).Font.Color := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink2')).ColorHovered := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink2')).ColorVisited := HexToColor('#ff5500');

    QueTree := TTreeView(Sender.Find('navTree'));
    QueList := TTreeView(Sender.Find('listTree'));

    QueTree.Items.Clear;
    root := QueTree.Items.Add('Local Queues');
    root.ImageIndex := 0;
    root.SelectedIndex := root.ImageIndex;
    root.Selected := true;

    root := QueTree.Items.Add('Live Queues');
    root.ImageIndex := 0;
    root.SelectedIndex := root.ImageIndex;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TMenuItem(Sender.find('mTweetNow')).OnClick := @ques_mTweetNow_OnClick;
    TMenuItem(Sender.find('mStartLocalTweetGate')).OnClick := @ques_mStartLocalTweetGate_OnClick;
    TUrlLink(Sender.find('UrlLink2')).OnClick := @ques_UrlLink2_OnClick;
    TUrlLink(Sender.find('UrlLink1')).OnClick := @ques_UrlLink1_OnClick;
    TMenuItem(Sender.find('mDeleteTweetData2')).OnClick := @ques_mDeleteTweetData2_OnClick;
    TMenuItem(Sender.find('mDeleteTweet')).OnClick := @ques_mDeleteTweet_OnClick;
    TMenuItem(Sender.find('mModifyTweetData2')).OnClick := @ques_mModifyTweetData2_OnClick;
    TBGRAButton(Sender.find('bMenu2')).OnClick := @ques_bMenu2_OnClick;
    TMenuItem(Sender.find('mModifyTweet')).OnClick := @ques_mModifyTweet_OnClick;
    TMenuItem(Sender.find('mDeleteLiveQueue')).OnClick := @ques_mDeleteLiveQueue_OnClick;
    TMenuItem(Sender.find('mRunLiveQueue')).OnClick := @ques_mRunLiveQueue_OnClick;
    TMenuItem(Sender.find('mRunLocalQueue')).OnClick := @ques_mRunLocalQueue_OnClick;
    TPopupMenu(Sender.find('PopupMenu1')).OnPopup := @ques_PopupMenu1_OnPopup;
    TMenuItem(Sender.find('mDeleteLocalQueue')).OnClick := @ques_mDeleteLocalQueue_OnClick;
    TMenuItem(Sender.find('mModifyLocalQueue')).OnClick := @ques_mModifyLocalQueue_OnClick;
    TMenuItem(Sender.find('mModifyLivequeue')).OnClick := @ques_mModifyLivequeue_OnClick;
    TMenuItem(Sender.find('mNewLiveQueue')).OnClick := @ques_mNewLiveQueue_OnClick;
    TTreeView(Sender.find('navTree')).OnCustomDrawItem := @ques_navTree_OnCustomDrawItem;
    TTreeView(Sender.find('listTree')).OnSelectionChanged := @ques_listTree_OnSelectionChanged;
    TTreeView(Sender.find('listTree')).OnClick := @ques_listTree_OnClick;
    TTreeView(Sender.find('listTree')).OnMouseWheel := @ques_listTree_OnMouseWheel;
    TTreeView(Sender.find('listTree')).OnCustomDrawItem := @ques_listTree_OnCustomDrawItem;
    TMenuItem(Sender.find('mNewTweet')).OnClick := @ques_mNewTweet_OnClick;
    TTreeView(Sender.find('navTree')).OnExpanding := @ques_navTree_OnExpanding;
    TTreeView(Sender.find('navTree')).OnCollapsing := @ques_navTree_OnCollapsing;
    TSimpleAction(Sender.find('actPopulateQueues')).OnExecute := @ques_actPopulateQueues_OnExecute;
    TTreeView(Sender.find('navTree')).OnChange := @ques_navTree_OnChange;
    TTreeView(Sender.find('navTree')).OnClick := @ques_navTree_OnClick;
    TTreeView(Sender.find('navTree')).OnChanging := @ques_navTree_OnChanging;
    TMenuItem(Sender.find('mNewLocalQueue')).OnClick := @ques_mNewLocalQueue_OnClick;
    TBGRAButton(Sender.find('bMenu')).OnClick := @ques_bMenu_OnClick;
    //</events-bind>
end;

procedure populateQueues();
var
    files: TStringList;
    str: TStringList;
    i: int;

    node: TTreeNode;

    function findRoot(txt: string): TTreeNode;
    var
        i: int;
    begin
        for i := 0 to QueTree.Items.Count -1 do
        begin
            if QueTree.Items.Item[i].Text = txt then
            begin
                result := QueTree.Items.Item[i];
                break;
            end;
        end;
    end;
begin
    QueTree.Items.BeginUpdate;
    findRoot('Local Queues').DeleteChildren;
    findRoot('Live Queues').DeleteChildren;

    files := TStringList.Create;

    SearchDir(root+'queues'+DirSep+copy(_getSelectedUser, 2, 1000), '*', files);
    files.Sort;
    for i := 0 to files.Count -1 do
    begin
        if (Pos('.manifest', files.Strings[i]) > 0) and
           (Pos('.marker', files.Strings[i]) = 0) then
        begin
            str := TStringList.Create;
            str.LoadFromFile(files.Strings[i]);
            if str.Values['type'] = '1' then
            begin
                node := QueTree.Items.AddChild(findRoot('Live Queues'), str.Values['name']);
                node.ImageIndex := 3;
                node.SelectedIndex := node.ImageIndex;
            end
                else
            begin
                node := QueTree.Items.AddChild(findRoot('Local Queues'), str.Values['name']);
                node.ImageIndex := 2;
                node.SelectedIndex := node.ImageIndex;
            end;
            if str.Values['paused'] = '1' then
            node.Text := node.Text+' (PAUSED)';
            str.free;
        end;
    end;

    files.free;

    if findRoot('Local Queues').Count <> 0 then
        findRoot('Local Queues').Expand(false);
    if findRoot('Live Queues').Count <> 0 then
        findRoot('Live Queues').Expand(false);

    QueTree.Items.Item[0].Selected := true;

    QueTree.Items.EndUpdate;
end;

procedure ques_bMenu_OnClick(Sender: TBGRAButton);
var
    pop: TPopupMenu;
    x, y: int;
begin
    pop := TPopupMenu(Sender.Owner.Find('PopupMenu1'));

    x := Sender.ClientToScreenX(0, 0);
    y := Sender.ClientToScreenY(0, 0) + Sender.Height;

    pop.PopUpAt(x, y);
end;

procedure ques_mNewLocalQueue_OnClick(Sender: TComponent);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    f := newqueueCreate(MainForm);
    f.Caption := 'New Local Queue';
    f.ShowModalDimmed;
    populateQueues;
end;

procedure ques_navTree_OnChanging(Sender: TTreeView; Node: TTreeNode; var Allow: bool);
begin
    Allow := (_getSelectedUser <> '');
    if not Allow then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
    end;
end;

procedure ques_navTree_OnClick(Sender: TTreeView);
begin
    if Sender.Selected <> nil then
    begin
        TTreeView(Sender.Owner.Find('listTree')).Items.BeginUpdate;
        TTreeView(Sender.Owner.Find('listTree')).Items.Clear;
        TTreeView(Sender.Owner.Find('listTree')).Items.EndUpdate;

        if Sender.Selected.ImageIndex in [2,3] then
        begin
            populateQueueList;
        end;
    end;
end;

procedure ques_navTree_OnChange(Sender: TTreeView; Node: TTreeNode);
begin
    if Sender.Selected <> nil then
    begin
        if Node <> nil then
        begin
            if Node.Level = 0 then
            begin
                TTreeView(Sender.Owner.Find('listTree')).Items.BeginUpdate;
                TTreeView(Sender.Owner.Find('listTree')).Items.Clear;
                TTreeView(Sender.Owner.Find('listTree')).Items.EndUpdate;
            end;
            TPanel(Sender.Owner.Find('selPanel')).Visible := (Node.Level = 0);
        end;
    end;
end;

procedure populateQueueList();
var
    files: TStringList;
    i: int;
    node: TTreeNode;
    qname: string;
begin
    qname := QueTree.Selected.Text;
    if Pos('(', qname) > 0 then
    qname := copy(qname, 0, Pos('(', qname) -1);
    qname := Trim(qname);

    QueList.Items.BeginUpdate;
    QueList.Items.Clear;

    files := TStringList.Create;
    SearchDir(root+'queues'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+qname, '*', files);
    files.Sort;
    for i := 0 to files.Count -1 do
    begin
        if Pos('.tweet', files.Strings[i]) > 0 then
            node := QueList.Items.Add(files.Strings[i]);
    end;

    if QueList.Items.Count <> 0 then
        QueList.Items.Item[0].Selected := true;

    QueList.Items.EndUpdate;

    try QueList.SetFocus; except end;
end;

procedure ques_actPopulateQueues_OnExecute(Sender: TSimpleAction);
begin
    populateQueues;
end;

procedure ques_navTree_OnCollapsing(Sender: TTreeView; Node: TTreeNode; var Allow: bool);
begin
    if Node.ImageIndex = 1 then
    begin
        Node.ImageIndex := 0;
        Node.SelectedIndex := Node.ImageIndex;
    end;
end;

procedure ques_navTree_OnExpanding(Sender: TTreeView; Node: TTreeNode; var Allow: bool);
begin
    if Node.ImageIndex = 0 then
    begin
        Node.ImageIndex := 1;
        Node.SelectedIndex := Node.ImageIndex;
    end;
end;

procedure ques_mNewTweet_OnClick(Sender: TMenuItem);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    if QueTree.Selected = nil then exit;
    if QueTree.Selected.Level = 0 then exit;

    f := newtweetCreate(MainForm);
    if QueTree.Selected.ImageIndex = 2 then
    f.Caption := 'New Local Tweet Data'
    else
    f.Caption := 'New Live Tweet Data';
    f.ShowModalDimmed;
    populateQueueList;
end;

procedure ques_listTree_OnCustomDrawItem(Sender: TTreeView; Node: TTreeNode; DrawInfo: TCustomDrawInfo; var DefaultDraw: bool);
var
    imgFile: string;
    bgColor: int;
    hasImage: bool = false;
    pic: TPicture;
    str: TStringList;
begin
    if Node.Text <> '' then
    begin
        try

            bgColor := clWhite;

            Sender.Canvas.Font.Color := $00444444;
            Sender.Canvas.Fillrect(Node.DisplayRectLeft(false),
                                   Node.DisplayRectTop(false),
                                   Node.DisplayRectRight(false),
                                   Node.DisplayRectBottom(false), bgColor);
            if DrawInfo.isSelected then
            begin
                Sender.Canvas.Pen.Color := HexToColor('#ff5500');
                Sender.Canvas.drawRect(Node.DisplayRectLeft(false) +1,
                                        Node.DisplayRectTop(false) +1,
                                        Node.DisplayRectRight(false) -2,
                                        Node.DisplayRectBottom(false) -10);
            end
                else
            begin
                Sender.Canvas.Pen.Color := HexToColor('#f0f0f0');
                Sender.Canvas.drawRect(Node.DisplayRectLeft(false) +1,
                                        Node.DisplayRectTop(false) +1,
                                        Node.DisplayRectRight(false) -2,
                                        Node.DisplayRectBottom(false) -10);
            end;

            hasImage := false;
            //draw text and image
            imgFile := ChangeFileExt(Node.Text, '.jpg');
            if FileExists(imgFile) then
            begin
                pic := TPicture.Create;
                try
                    pic.LoadFromFile(imgFile);
                    Sender.Canvas.drawImageStretch(pic.Graphic,
                                                   Node.DisplayRectRight(false) - 150,
                                                   Node.DisplayRectTop(false) +40,
                                                   Node.DisplayRectRight(false) -30,
                                                   Node.DisplayRectBottom(false) - 50);
                except end;
                pic.free;
                hasImage := true;
            end;

            imgFile := ChangeFileExt(Node.Text, '.jpeg');
            if FileExists(imgFile) then
            begin
                pic := TPicture.Create;
                try
                    pic.LoadFromFile(imgFile);
                    Sender.Canvas.drawImageStretch(pic.Graphic,
                                                   Node.DisplayRectRight(false) - 150,
                                                   Node.DisplayRectTop(false) +40,
                                                   Node.DisplayRectRight(false) -30,
                                                   Node.DisplayRectBottom(false) - 50);
                except end;
                pic.free;
                hasImage := true;
            end;

            imgFile := ChangeFileExt(Node.Text, '.png');
            if FileExists(imgFile) then
            begin
                pic := TPicture.Create;
                try
                    pic.LoadFromFile(imgFile);
                    Sender.Canvas.drawImageStretch(pic.Graphic,
                                                   Node.DisplayRectRight(false) - 150,
                                                   Node.DisplayRectTop(false) +40,
                                                   Node.DisplayRectRight(false) -30,
                                                   Node.DisplayRectBottom(false) - 50);
                except end;
                pic.free;
                hasImage := true;
            end;

            str := TStringList.Create;
            str.LoadFromFile(Node.Text);
            if hasImage then
            Sender.Canvas.TextRect(Node.DisplayRectLeft(false) + 10,
                                   Node.DisplayRectTop(false) +10,
                                   Node.DisplayRectRight(false) - 160,
                                   Node.DisplayRectBottom(false) - 20,
                                   5, 5,
                                   str.Text, true, false)
            else
            Sender.Canvas.TextRect(Node.DisplayRectLeft(false) + 10,
                                   Node.DisplayRectTop(false) +10,
                                   Node.DisplayRectRight(false) - 10,
                                   Node.DisplayRectBottom(false) - 20,
                                   5, 5,
                                   str.Text, true, false);
            str.free;

            Sender.Canvas.drawImageStretch(tweetShadow,
                                           Node.DisplayRectLeft(false),
                                           Node.DisplayRectBottom(false) -10,
                                           Node.DisplayRectRight(false),
                                           Node.DisplayRectBottom(false));
        except end;

        DefaultDraw := false;
    end;
end;

procedure ques_listTree_OnMouseWheel(Sender: TTreeView; keyInfo: TKeyInfo; WheelDelta: int; X: int; Y: int; var Handled: bool);
begin
    //
    if Sender.Items.Count <> 0 then
    begin
        if Sender.Selected = nil then
        Sender.Items.Item[Sender.Items.Count -1].Selected := true;

        if Pos('-', IntToStr(WheelDelta)) > 0 then
        begin
            //down
            if Sender.Selected.AbsoluteIndex <> Sender.Items.Count -1 then
                Sender.Items.Item[Sender.Selected.AbsoluteIndex +1].Selected := true;
        end
            else
        begin
            //up
            if Sender.Selected.AbsoluteIndex <> 0 then
                Sender.Items.Item[Sender.Selected.AbsoluteIndex -1].Selected := true;
        end;
    end;

    Handled := true;
end;

procedure ques_listTree_OnClick(Sender: TTreeView);
var
    pan: TPanel;
begin
    pan := TPanel(Sender.Owner.Find('panActions'));
    if Sender.Selected <> nil then
    begin
        pan.Left := Sender.Left + Sender.Selected.DisplayRectRight(false) - pan.Width -10;
        pan.Top := Sender.Top + Sender.Selected.DisplayRectBottom(false) - pan.Height -18;
    end;
    pan.Visible := (Sender.Selected <> nil);
end;

procedure ques_listTree_OnSelectionChanged(Sender: TTreeView);
var
    pan: TPanel;
begin
    pan := TPanel(Sender.Owner.Find('panActions'));
    if Sender.Selected <> nil then
    begin
        pan.Left := Sender.Left + Sender.Selected.DisplayRectRight(false) - pan.Width -10;
        pan.Top := Sender.Top + Sender.Selected.DisplayRectBottom(false) - pan.Height -18;
    end;
    pan.Visible := (Sender.Selected <> nil);
end;

procedure ques_navTree_OnCustomDrawItem(Sender: TTreeView; Node: TTreeNode; DrawInfo: TCustomDrawInfo; var DefaultDraw: bool);
begin
    if Node <> nil then
    begin
        if Pos('(PAUSED)', Node.Text) > 0 then
        begin
            //Sender.Canvas.Font.Style := 0;
            Sender.Canvas.Font.Color := clRed
        end
            else
        begin
            //Sender.Canvas.Font.Style := fsBold;
            Sender.Canvas.Font.Color := $00444444;
        end;
    end;
end;

procedure ques_mNewLiveQueue_OnClick(Sender: TComponent);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    if trim(appSettings.Values['live-key']) <> '' then
    begin
        f := newqueueCreate(MainForm);
        f.Caption := 'New Live Queue';
        f.ShowModalDimmed;
        populateQueues;
    end
        else
        MsgError('Error', 'No Live Key is defined');
end;

procedure ques_mModifyLivequeue_OnClick(Sender: TMenuItem);
var
    f: TForm;
    str: TStringList;
    homedir, qname: string;
begin
    qname := QueTree.Selected.Text;
    if Pos('(', qname) > 0 then
    qname := copy(qname, 0, Pos('(', qname) -1);
    qname := Trim(qname);

    homedir := root+'queues'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep+qname+DirSep;

    if FileExists(homedir+'queue.manifest') then
    begin
        str := TStringList.Create;
        str.LoadFromFile(homedir+'queue.manifest');

        f := newqueueCreate(MainForm);
        f.Caption := 'Edit Live Queue';
        TEdit(f.Find('Edit1')).Enabled := false;
        TEdit(f.Find('Edit1')).Text := str.Values['name'];
        TComboBox(f.Find('ComboBox1')).ItemIndex := StrToIntDef(str.Values['sequence'], 0);
        TComboBox(f.Find('ComboBox2')).ItemIndex := StrToIntDef(str.Values['interval'], 0);
        TButton(f.Find('Button2')).Caption := 'Save';
        f.ShowModalDimmed;
        populateQueues;

        str.Free;
    end;
end;

procedure ques_mModifyLocalQueue_OnClick(Sender: TMenuItem);
var
    f: TForm;
    str: TStringList;
    homedir, qname: string;
begin
    qname := QueTree.Selected.Text;
    if Pos('(', qname) > 0 then
    qname := copy(qname, 0, Pos('(', qname) -1);
    qname := Trim(qname);

    homedir := root+'queues'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep+qname+DirSep;

    if FileExists(homedir+'queue.manifest') then
    begin
        str := TStringList.Create;
        str.LoadFromFile(homedir+'queue.manifest');

        f := newqueueCreate(MainForm);
        f.Caption := 'Edit Local Queue';
        TEdit(f.Find('Edit1')).Enabled := false;
        TEdit(f.Find('Edit1')).Text := str.Values['name'];
        TComboBox(f.Find('ComboBox1')).ItemIndex := StrToIntDef(str.Values['sequence'], 0);
        TComboBox(f.Find('ComboBox2')).ItemIndex := StrToIntDef(str.Values['interval'], 0);
        TButton(f.Find('Button2')).Caption := 'Save';
        f.ShowModalDimmed;
        populateQueues;

        str.Free;
    end;
end;

procedure ques_mDeleteLocalQueue_OnClick(Sender: TMenuItem);
var
    homedir, qname: string;
begin
    qname := QueTree.Selected.Text;
    if Pos('(', qname) > 0 then
    qname := copy(qname, 0, Pos('(', qname) -1);
    qname := Trim(qname);

    homedir := root+'queues'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep+qname+DirSep;

    if MsgWarning('Warning', 'You are about to delete a local queue, continue?') then
    begin
        ForceDeleteDir(homedir);
        QueTree.Selected.Delete;
        QueTree.Items.Item[0].Selected := true;
    end;
end;

procedure ques_PopupMenu1_OnPopup(Sender: TPopupMenu);
begin
    TMenuItem(Sender.Owner.Find('mModifyLocalQueue')).Enabled := false;
    TMenuItem(Sender.Owner.Find('mDeleteLocalQueue')).Enabled := false;
    TMenuItem(Sender.Owner.Find('mRunLocalQueue')).Enabled := false;
    TMenuItem(Sender.Owner.Find('mModifyLocalQueue')).Enabled := false;
    TMenuItem(Sender.Owner.Find('mDeleteLiveQueue')).Enabled := false;
    TMenuItem(Sender.Owner.Find('mRunLiveQueue')).Enabled := false;
    TMenuItem(Sender.Owner.Find('mNewTweet')).Enabled := false;

    TMenuItem(Sender.Owner.Find('mNewLiveQueue')).Enabled := (trim(appSettings.Values['live-key']) <> '');

    TMenuItem(Sender.Owner.Find('mModifyTweet')).Enabled := (QueList.Selected <> nil);
    TMenuItem(Sender.Owner.Find('mDeleteTweet')).Enabled := (QueList.Selected <> nil);

    TMenuItem(Sender.Owner.Find('mModifyLocalQueue')).Enabled :=
        (QueTree.Selected <> nil) and (QueTree.Selected.ImageIndex = 2);
    TMenuItem(Sender.Owner.Find('mDeleteLocalQueue')).Enabled :=
        (QueTree.Selected <> nil) and (QueTree.Selected.ImageIndex = 2);
    TMenuItem(Sender.Owner.Find('mRunLocalQueue')).Enabled :=
        (QueTree.Selected <> nil) and (QueTree.Selected.ImageIndex = 2);

    TMenuItem(Sender.Owner.Find('mModifyLiveQueue')).Enabled :=
        (QueTree.Selected <> nil) and (QueTree.Selected.ImageIndex = 3);
    TMenuItem(Sender.Owner.Find('mDeleteLiveQueue')).Enabled :=
        (QueTree.Selected <> nil) and (QueTree.Selected.ImageIndex = 3);
    TMenuItem(Sender.Owner.Find('mRunLiveQueue')).Enabled :=
        (QueTree.Selected <> nil) and (QueTree.Selected.ImageIndex = 3);

    TMenuItem(Sender.Owner.Find('mNewTweet')).Enabled :=
        (QueTree.Selected <> nil) and (QueTree.Selected.ImageIndex in [2,3]);

    if TMenuItem(Sender.Owner.Find('mRunLocalQueue')).Enabled then
    begin
        if Pos('(PAUSED)', QueTree.Selected.Text) > 0 then
        TMenuItem(Sender.Owner.Find('mRunLocalQueue')).Caption := 'Run Local Queue'
        else
        TMenuItem(Sender.Owner.Find('mRunLocalQueue')).Caption := 'Pause Local Queue';
    end;

    if TMenuItem(Sender.Owner.Find('mRunLiveQueue')).Enabled then
    begin
        if Pos('(PAUSED)', QueTree.Selected.Text) > 0 then
        TMenuItem(Sender.Owner.Find('mRunLiveQueue')).Caption := 'Run Live Queue'
        else
        TMenuItem(Sender.Owner.Find('mRunLiveQueue')).Caption := 'Pause Live Queue';
    end;
end;

procedure ques_mRunLocalQueue_OnClick(Sender: TMenuItem);
var
    homedir, qname: string;
    str: TStringList;
begin
    qname := QueTree.Selected.Text;
    if Pos('(', qname) > 0 then
    qname := copy(qname, 0, Pos('(', qname) -1);
    qname := Trim(qname);

    homedir := root+'queues'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep+qname+DirSep;

    if FileExists(homedir+'queue.manifest') then
    begin
        str := TStringList.Create;
        str.LoadFromFile(homedir+'queue.manifest');

        if Sender.Caption = 'Run Local Queue' then
        begin
            str.Values['paused'] := '0';
            QueTree.Selected.Text := qname;
        end
        else
        begin
            str.Values['paused'] := '1';
            QueTree.Selected.Text := qname+' (PAUSED)';
        end;

        str.SaveToFile(homedir+'queue.manifest');
        str.free;
    end;
end;

procedure ques_mRunLiveQueue_OnClick(Sender: TMenuItem);
var
    homedir, qname: string;
    str: TStringList;
    tc: TTwitter;
begin
    qname := QueTree.Selected.Text;
    if Pos('(', qname) > 0 then
    qname := copy(qname, 0, Pos('(', qname) -1);
    qname := Trim(qname);

    homedir := root+'queues'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep+qname+DirSep;

    if FileExists(homedir+'queue.manifest') then
    begin
        if accounts.IndexOf(_getSelectedUser) <> -1 then
        begin
            tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

            str := TStringList.Create;
            str.LoadFromFile(homedir+'queue.manifest');

            if Sender.Caption = 'Run Live Queue' then
            begin
                try
                    tc.runLiveQueue(appSettings.Values['live-key'], qname);
                    str.Values['paused'] := '0';
                    QueTree.Selected.Text := qname;
                except
                    raise(ExceptionMessage);
                end;
            end
            else
            begin
                try
                    tc.pauseLiveQueue(appSettings.Values['live-key'], qname);
                    str.Values['paused'] := '1';
                    QueTree.Selected.Text := qname+' (PAUSED)';
                except
                    raise(ExceptionMessage);
                end;
            end;

            str.SaveToFile(homedir+'queue.manifest');
            str.free;
        end;
    end;
end;

procedure ques_mDeleteLiveQueue_OnClick(Sender: TMenuItem);
var
    homedir, qname: string;
    tc: TTwitter;
begin
    qname := QueTree.Selected.Text;
    if Pos('(', qname) > 0 then
    qname := copy(qname, 0, Pos('(', qname) -1);
    qname := Trim(qname);

    homedir := root+'queues'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep+qname+DirSep;

    if accounts.IndexOf(_getSelectedUser) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

        if MsgWarning('Warning', 'You are about to delete a live queue, continue?') then
        begin
            try
                tc.deleteLiveQueue(appSettings.Values['live-key'], qname);
                ForceDeleteDir(homedir);
                QueTree.Selected.Delete;
                QueTree.Items.Item[0].Selected := true;
            except
                raise(ExceptionMessage);
            end;
        end;
    end;
end;

procedure ques_mModifyTweet_OnClick(Sender: TMenuItem);
var
    f: TForm;
    twid: string;
begin
    f := newtweetCreate(MainForm);
    if QueTree.Selected.ImageIndex = 2 then
    f.Caption := 'Edit Local Tweet Data'
    else
    f.Caption := 'Edit Live Tweet Data';

    twid := FileNameOf(QueList.Selected.Text);
    twid := copy(twid, 0, Pos('.', twid) -1);
    f.Hint := twid;

    TButton(f.Find('Button2')).Enabled := true;

    TMemo(f.Find('Memo1')).Lines.LoadFromFile(QueList.Selected.Text);

    if FileExists(ChangeFileExt(QueList.Selected.Text, '.jpg')) then
    begin
        TImage(f.Find('Image1')).Picture.LoadFromFile(ChangeFileExt(QueList.Selected.Text, '.jpg'));
        TLabel(f.Find('labImage')).Caption := ChangeFileExt(QueList.Selected.Text, '.jpg');
    end;

    if FileExists(ChangeFileExt(QueList.Selected.Text, '.jpeg')) then
    begin
        TImage(f.Find('Image1')).Picture.LoadFromFile(ChangeFileExt(QueList.Selected.Text, '.jpeg'));
        TLabel(f.Find('labImage')).Caption := ChangeFileExt(QueList.Selected.Text, '.jpeg');
    end;

    if FileExists(ChangeFileExt(QueList.Selected.Text, '.png')) then
    begin
        TImage(f.Find('Image1')).Picture.LoadFromFile(ChangeFileExt(QueList.Selected.Text, '.png'));
        TLabel(f.Find('labImage')).Caption := ChangeFileExt(QueList.Selected.Text, '.png');
    end;

    newtweet_Memo1_OnChange(TMemo(f.Find('Memo1')));
    f.ShowModalDimmed;
    QueList.Repaint;
end;

procedure ques_bMenu2_OnClick(Sender: TBGRAButton);
begin
    TPopupMenu(Sender.Owner.Find('PopupMenu2')).PopUp;
end;

procedure ques_mModifyTweetData2_OnClick(Sender: TMenuItem);
begin
    ques_mModifyTweet_OnClick(Sender);
end;

procedure ques_mDeleteTweet_OnClick(Sender: TMenuItem);
var
    tc: TTwitter;
    tweetFile: string;
    imgFile: string;
    qname: string;
    hasErrors: bool = false;
begin
    qname := QueTree.Selected.Text;
    if Pos('(', qname) > 0 then
    qname := copy(qname, 0, Pos('(', qname) -1);
    qname := Trim(qname);

    if MsgWarning('Warning', 'You are about to delete a Tweet Data, continue?') then
    begin
        if accounts.IndexOf(_getSelectedUser) <> -1 then
        begin
            tweetFile := QueList.Selected.Text;

            if FileExists(ChangeFileExt(tweetFile, '.jpg')) then
                imgFile := ChangeFileExt(tweetFile, '.jpg');
            if FileExists(ChangeFileExt(tweetFile, '.jpeg')) then
                imgFile := ChangeFileExt(tweetFile, '.jpeg');
            if FileExists(ChangeFileExt(tweetFile, '.png')) then
                imgFile := ChangeFileExt(tweetFile, '.png');

            if QueTree.Selected.ImageIndex = 3 then
            begin
                tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
                try
                    tc.deleteLiveTweetData(appSettings.Values['live-key'],
                                           qname, imgFile);
                    tc.deleteLiveTweetData(appSettings.Values['live-key'],
                                           qname, tweetFile);
                except
                    hasErrors := true;
                    ShowMessage(ExceptionMessage);
                end;
            end;

            if not hasErrors then
            begin
                DeleteFile(tweetFile);
                DeleteFile(imgFile);
                QueList.Selected.Delete;
            end
                else
                MsgError('Error', 'Could not delete Tweet Data, please try again.');
        end;
    end;
end;

procedure ques_mDeleteTweetData2_OnClick(Sender: TMenuItem);
begin
    ques_mDeleteTweet_OnClick(Sender);
end;

procedure ques_UrlLink1_OnClick(Sender: TUrlLink);
begin
    ques_mNewLocalQueue_OnClick(Sender);
end;

procedure ques_UrlLink2_OnClick(Sender: TUrlLink);
begin
    ques_mNewLiveQueue_OnClick(Sender);
end;

procedure ques_mStartLocalTweetGate_OnClick(Sender: TMenuItem);
begin
    _StartLocalTweetGate;
end;

procedure ques_mTweetNow_OnClick(Sender: TMenuItem);
var
    f: TForm;
begin
    if QueTree.Selected = nil then exit;
    if QueTree.Selected.Level = 0 then exit;

    f := newTweetCreate(MainForm);
    f.Caption := 'Tweet Now';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    TMemo(f.Find('Memo1')).Lines.Text := trim(ReadToStr(QueList.Selected.Text));

    if FileExists(ChangeFileExt(QueList.Selected.Text, '.jpg')) then
    begin
        TImage(f.Find('Image1')).Picture.LoadFromFile(ChangeFileExt(QueList.Selected.Text, '.jpg'));
        TImage(f.Find('Image1')).Hint := ChangeFileExt(QueList.Selected.Text, '.jpg');
    end;
    if FileExists(ChangeFileExt(QueList.Selected.Text, '.jpeg')) then
    begin
        TImage(f.Find('Image1')).Picture.LoadFromFile(ChangeFileExt(QueList.Selected.Text, '.jpeg'));
        TImage(f.Find('Image1')).Hint := ChangeFileExt(QueList.Selected.Text, '.jpeg');
    end;
    if FileExists(ChangeFileExt(QueList.Selected.Text, '.png')) then
    begin
        TImage(f.Find('Image1')).Picture.LoadFromFile(ChangeFileExt(QueList.Selected.Text, '.png'));
        TImage(f.Find('Image1')).Hint := ChangeFileExt(QueList.Selected.Text, '.png');
    end;

    newtweet_Memo1_OnChange(TMemo(f.Find('Memo1')));
    f.ShowModalDimmed;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//ques initialization constructor
constructor
begin 
end.
