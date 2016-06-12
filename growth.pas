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

uses 'globals', 'newtweet', 'viewmessage', 'message', 'viewuser', 'newtweet',
    'message', 'action', 'event';

//constructor of growth
function growthCreate(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructorFromResource(Owner, @growth_OnCreate, 'growth');
end;

//OnCreate Event of growth
procedure growth_OnCreate(Sender: TFrame);
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
    TUrlLink(Sender.Find('UrlLink3')).Font.Color := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink3')).ColorHovered := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink3')).ColorVisited := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink4')).Font.Color := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink4')).ColorHovered := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink4')).ColorVisited := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink5')).Font.Color := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink5')).ColorHovered := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink5')).ColorVisited := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink6')).Font.Color := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink6')).ColorHovered := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink6')).ColorVisited := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink7')).Font.Color := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink7')).ColorHovered := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink7')).ColorVisited := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink8')).Font.Color := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink8')).ColorHovered := HexToColor('#ff5500');
    TUrlLink(Sender.Find('UrlLink8')).ColorVisited := HexToColor('#ff5500');

    TLabel(Sender.Find('Label2')).Font.Color := clGray;
    TLabel(Sender.Find('Label4')).Font.Color := clGray;
    TLabel(Sender.Find('lTotal')).Font.Color := clGray;
    TLabel(Sender.Find('lPos')).Font.Color := clGray;

    NetTree := TTreeView(Sender.Find('navTree'));
    NetList := TTreeView(Sender.Find('listTree'));

    NetTree.Items.Clear;
    root := NetTree.Items.Add('Messages');
    root.ImageIndex := 1;
    root.SelectedIndex := root.ImageIndex;

        child := NetTree.Items.AddChild(root, 'Received');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := NetTree.Items.AddChild(root, 'Sent');
        child.ImageIndex := 3;
        child.SelectedIndex := child.ImageIndex;

    root.Expand(false);
    root.Selected := true;

    root := NetTree.Items.Add('Hive');
    root.ImageIndex := 1;
    root.SelectedIndex := root.ImageIndex;

        child := NetTree.Items.AddChild(root, 'Followers');
        child.ImageIndex := 4;
        child.SelectedIndex := child.ImageIndex;

        child := NetTree.Items.AddChild(root, 'Following');
        child.ImageIndex := 5;
        child.SelectedIndex := child.ImageIndex;

        child := NetTree.Items.AddChild(root, 'Dropped');
        child.ImageIndex := 6;
        child.SelectedIndex := child.ImageIndex;

    root.Expand(false);

    {root := NetTree.Items.Add('Groups');
    root.ImageIndex := 0;
    root.SelectedIndex := root.ImageIndex;}

    root := NetTree.Items.Add('Marketing');
    root.ImageIndex := 1;
    root.SelectedIndex := root.ImageIndex;

        child := NetTree.Items.AddChild(root, 'Live Campaigns');
        child.ImageIndex := 7;
        child.SelectedIndex := child.ImageIndex;

    root.Expand(false);

    root := NetTree.Items.Add('Growth');
    root.ImageIndex := 1;
    root.SelectedIndex := root.ImageIndex;

        child := NetTree.Items.AddChild(root, 'Live Actions');
        child.ImageIndex := 8;
        child.SelectedIndex := child.ImageIndex;

        child := NetTree.Items.AddChild(root, 'Live Events');
        child.ImageIndex := 9;
        child.SelectedIndex := child.ImageIndex;

    root.Expand(false);


    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TSimpleAction(Sender.find('actPopulateEvents')).OnExecute := @growth_actPopulateEvents_OnExecute;
    TSimpleAction(Sender.find('actPopulateActions')).OnExecute := @growth_actPopulateActions_OnExecute;
    TSimpleAction(Sender.find('actPopulateCampaigns')).OnExecute := @growth_actPopulateCampaigns_OnExecute;
    TSimpleAction(Sender.find('actPopulateDroppers')).OnExecute := @growth_actPopulateDroppers_OnExecute;
    TSimpleAction(Sender.find('actPopulateFollowing')).OnExecute := @growth_actPopulateFollowing_OnExecute;
    TSimpleAction(Sender.find('actPopulateFollowers')).OnExecute := @growth_actPopulateFollowers_OnExecute;
    TSimpleAction(Sender.find('actPopulateOutbox')).OnExecute := @growth_actPopulateOutbox_OnExecute;
    TSimpleAction(Sender.find('actPopulateInbox')).OnExecute := @growth_actPopulateInbox_OnExecute;
    TMenuItem(Sender.find('mDeleteCampaign')).OnClick := @growth_mDeleteCampaign_OnClick;
    TMenuItem(Sender.find('mDeleteEvent')).OnClick := @growth_mDeleteEvent_OnClick;
    TMenuItem(Sender.find('mModifyEvent')).OnClick := @growth_mModifyEvent_OnClick;
    TMenuItem(Sender.find('mNewEvent')).OnClick := @growth_mNewEvent_OnClick;
    TMenuItem(Sender.find('mDeleteAction')).OnClick := @growth_mDeleteAction_OnClick;
    TMenuItem(Sender.find('mModifyAction')).OnClick := @growth_mModifyAction_OnClick;
    TPopupMenu(Sender.find('PopupMenu2')).OnPopup := @growth_PopupMenu2_OnPopup;
    TMenuItem(Sender.find('mNewAction')).OnClick := @growth_mNewAction_OnClick;
    TMenuItem(Sender.find('mMuteUser2')).OnClick := @growth_mMuteUser2_OnClick;
    TMenuItem(Sender.find('mMuteUser')).OnClick := @growth_mMuteUser_OnClick;
    TMenuItem(Sender.find('mIgnoreAndRemove')).OnClick := @growth_mIgnoreAndRemove_OnClick;
    TMenuItem(Sender.find('mSendMessage')).OnClick := @growth_mSendMessage_OnClick;
    TMenuItem(Sender.find('mTweetUser')).OnClick := @growth_mTweetUser_OnClick;
    TMenuItem(Sender.find('mViewUser2')).OnClick := @growth_mViewUser2_OnClick;
    TMenuItem(Sender.find('mFollow')).OnClick := @growth_mFollow_OnClick;
    TPopupMenu(Sender.find('PopupMenu3')).OnPopup := @growth_PopupMenu3_OnPopup;
    TMenuItem(Sender.find('mViewUser')).OnClick := @growth_mViewUser_OnClick;
    TMenuItem(Sender.find('mDelete')).OnClick := @growth_mDelete_OnClick;
    TMenuItem(Sender.find('mReply')).OnClick := @growth_mReply_OnClick;
    TMenuItem(Sender.find('mMarkasUnread')).OnClick := @growth_mMarkasUnread_OnClick;
    TMenuItem(Sender.find('mMarkasRead')).OnClick := @growth_mMarkasRead_OnClick;
    TMenuItem(Sender.find('mOpenMessage')).OnClick := @growth_mOpenMessage_OnClick;
    TMenuItem(Sender.find('mNewCampaign')).OnClick := @growth_mNewCampaign_OnClick;
    TBGRAButton(Sender.find('bMenu2')).OnClick := @growth_bMenu2_OnClick;
    TTreeView(Sender.find('navTree')).OnCustomDrawItem := @growth_navTree_OnCustomDrawItem;
    TUrlLink(Sender.find('UrlLink8')).OnClick := @growth_UrlLink8_OnClick;
    TUrlLink(Sender.find('UrlLink7')).OnClick := @growth_UrlLink7_OnClick;
    TUrlLink(Sender.find('UrlLink6')).OnClick := @growth_UrlLink6_OnClick;
    TUrlLink(Sender.find('UrlLink5')).OnClick := @growth_UrlLink5_OnClick;
    TUrlLink(Sender.find('UrlLink4')).OnClick := @growth_UrlLink4_OnClick;
    TUrlLink(Sender.find('UrlLink3')).OnClick := @growth_UrlLink3_OnClick;
    TUrlLink(Sender.find('UrlLink2')).OnClick := @growth_UrlLink2_OnClick;
    TUrlLink(Sender.find('UrlLink1')).OnClick := @growth_UrlLink1_OnClick;
    TTreeView(Sender.find('listTree')).OnChange := @growth_listTree_OnChange;
    TPopupMenu(Sender.find('PopupMenu1')).OnPopup := @growth_PopupMenu1_OnPopup;
    TBGRAButton(Sender.find('bMenu')).OnClick := @growth_bMenu_OnClick;
    TTreeView(Sender.find('listTree')).OnMouseWheel := @growth_listTree_OnMouseWheel;
    TTreeView(Sender.find('navTree')).OnChanging := @growth_navTree_OnChanging;
    TTreeView(Sender.find('navTree')).OnChange := @growth_navTree_OnChange;
    TTreeView(Sender.find('listTree')).OnSelectionChanged := @growth_listTree_OnSelectionChanged;
    TTreeView(Sender.find('listTree')).OnClick := @growth_listTree_OnClick;
    TTreeView(Sender.find('listTree')).OnCustomDrawItem := @growth_listTree_OnCustomDrawItem;
    TTreeView(Sender.find('navTree')).OnExpanding := @growth_navTree_OnExpanding;
    TTreeView(Sender.find('navTree')).OnCollapsing := @growth_navTree_OnCollapsing;
    TTreeView(Sender.find('navTree')).OnClick := @growth_navTree_OnClick;
    //</events-bind>
end;

procedure growth_navTree_OnClick(Sender: TTreeView);
begin
    TPanel(Sender.Owner.Find('cursorPanel')).Visible := false;

    if Sender.Selected <> nil then
    begin
        if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep+'followers.init') then
        OldFollowersIDS.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep+'followers.init');

        TTreeView(Sender.Owner.Find('listTree')).Items.BeginUpdate;
        TTreeView(Sender.Owner.Find('listTree')).Items.Clear;
        TTreeView(Sender.Owner.Find('listTree')).Images := TImageList(Sender.Owner.Find('messageDummy'));
        TTreeView(Sender.Owner.Find('listTree')).Items.EndUpdate;

        if Sender.Selected.ImageIndex = 2 then
        begin
            _populateInbox(_getSelectedUser);
            populateInbox(TTreeView(Sender.Owner.Find('listTree')));
            TPanel(Sender.Owner.Find('cursorPanel')).Visible := true;
        end;
        if Sender.Selected.ImageIndex = 3 then
        begin
            _populateOutbox(_getSelectedUser);
            populateOutbox(TTreeView(Sender.Owner.Find('listTree')));
            TPanel(Sender.Owner.Find('cursorPanel')).Visible := true;
        end;
        if Sender.Selected.ImageIndex = 4 then
        begin
            _populateFollowers(_getSelectedUser);
            populateFollowers(TTreeView(Sender.Owner.Find('listTree')));
            TPanel(Sender.Owner.Find('cursorPanel')).Visible := true;
        end;
        if Sender.Selected.ImageIndex = 5 then
        begin
            _populateFollowing(_getSelectedUser);
            populateFollowing(TTreeView(Sender.Owner.Find('listTree')));
            TPanel(Sender.Owner.Find('cursorPanel')).Visible := true;
        end;
        if Sender.Selected.ImageIndex = 6 then
        begin
            _populateDroppers(_getSelectedUser);
            populateDroppers(TTreeView(Sender.Owner.Find('listTree')));
        end;
        if Sender.Selected.ImageIndex = 7 then
        begin
            _populateUserTimeline(_getSelectedUser);
            populateCampaigns(TTreeView(Sender.Owner.Find('listTree')));
        end;
        if Sender.Selected.ImageIndex = 8 then
        begin
            populateActions(TTreeView(Sender.Owner.Find('listTree')));
        end;
        if Sender.Selected.ImageIndex = 9 then
        begin
            populateEvents(TTreeView(Sender.Owner.Find('listTree')));
        end;
    end;
end;

procedure growth_navTree_OnCollapsing(Sender: TTreeView; Node: TTreeNode; var Allow: bool);
begin
    if Node.ImageIndex = 1 then
    begin
        Node.ImageIndex := 0;
        Node.SelectedIndex := Node.ImageIndex;
    end;
end;

procedure growth_navTree_OnExpanding(Sender: TTreeView; Node: TTreeNode; var Allow: bool);
begin
    if Node.ImageIndex = 0 then
    begin
        Node.ImageIndex := 1;
        Node.SelectedIndex := Node.ImageIndex;
    end;
end;

procedure populateActions(tree: TTreeView);
var
    i: int;
    item: TTreeNode;
    files: TStringList;
    homeDir: string;
begin
    tree.Items.BeginUpdate;
    tree.Items.Clear;
    tree.Items.EndUpdate;

    tree.Items.BeginUpdate;

    files := TStringList.Create;
    SearchDir(root+'actions'+DirSep+copy(_getSelectedUser, 2, 1000), '*', files);
    files.Sort;
    for i := files.Count -1 downto 0 do
    begin
        if (Pos('.action', files.Strings[i]) > 0) then
            item := tree.Items.Add(files.Strings[i]);
    end;
    files.free;

    tree.Items.EndUpdate;

    if tree.Items.Count <> 0 then
        tree.Items.Item[0].Selected := true;

    tree.Repaint;
    growth_listTree_OnSelectionChanged(tree);

    try tree.SetFocus; except end;
end;

procedure populateEvents(tree: TTreeView);
var
    i: int;
    item: TTreeNode;
    files: TStringList;
    homeDir: string;
begin
    tree.Items.BeginUpdate;
    tree.Items.Clear;
    tree.Items.EndUpdate;

    tree.Items.BeginUpdate;

    files := TStringList.Create;
    SearchDir(root+'actions'+DirSep+copy(_getSelectedUser, 2, 1000), '*', files);
    files.Sort;
    for i := files.Count -1 downto 0 do
    begin
        if (Pos('.trigger', files.Strings[i]) > 0) then
            item := tree.Items.Add(files.Strings[i]);
    end;
    files.free;

    tree.Items.EndUpdate;

    if tree.Items.Count <> 0 then
        tree.Items.Item[0].Selected := true;

    tree.Repaint;
    growth_listTree_OnSelectionChanged(tree);

    try tree.SetFocus; except end;
end;

procedure populateCampaigns(tree: TTreeView);
var
    i: int;
    item: TTreeNode;
    files: TStringList;
    homeDir: string;
    urla: TUrla;
    month: string;
begin
    tree.Items.BeginUpdate;
    tree.Items.Clear;
    tree.Images := TImageList(tree.Owner.Find('campaignDummy'));
    tree.Items.EndUpdate;

    month := IntToStr(MonthOf(Now));
    if Len(month) = 1 then
        month := '0'+month;

    try
        urla := TUrla.Create;
        clickLog.Text := urla.GetData(appSettings.Values['live-key'], month);
        urla.free;
    except end;

    tree.Items.BeginUpdate;

    files := TStringList.Create;
    SearchDir(root+'campaigns'+DirSep+copy(_getSelectedUser, 2, 1000), '*', files);
    files.Sort;
    for i := files.Count -1 downto 0 do
    begin
        if (Pos('.tweet', files.Strings[i]) > 0) and
           (Pos(DateFormat('yyyymm', Now), files.Strings[i]) > 0) then
            item := tree.Items.Add(files.Strings[i]);
    end;
    files.free;

    tree.Items.EndUpdate;

    if tree.Items.Count <> 0 then
        tree.Items.Item[0].Selected := true;

    tree.Repaint;
    growth_listTree_OnSelectionChanged(tree);

    try tree.SetFocus; except end;
end;

procedure populateInbox(tree: TTreeView);
var
    user: string;
    tc: TTwitter;
    i: int;
    item: TTreeNode;
begin
    if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'msg.list') then
        msgList.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'msg.list');

    user := _getSelectedUser;
    if accounts.IndexOf(user) <> -1 then
    begin
        tree.Items.BeginUpdate;
        tree.Items.Clear;
        tree.Items.EndUpdate;

        tree.Items.BeginUpdate;

        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        for i := 0 to tc.MessagesInbox.Count -1 do
        begin
            if Pos(tc.MessagesInbox.Items[i].UserData.UserName, muteList.Text) = 0 then
            begin
                item := tree.Items.Add('ITEM');
                item.Data := tc.MessagesInbox.Items[i];
            end;
        end;

        tree.Items.EndUpdate;

        if tree.Items.Count <> 0 then
            tree.Items.Item[0].Selected := true;

        TLabel(tree.Owner.Find('lTotal')).Caption := DoubleFormat('#,##0', tc.MessagesInbox.Count);
        if tree.Items.Count <> 0 then
        TLabel(tree.Owner.Find('lPos')).Caption := DoubleFormat('#,##0', tree.selected.AbsoluteIndex +1)
        else
        TLabel(tree.Owner.Find('lPos')).Caption := '0';

        tree.Repaint;
        growth_listTree_OnSelectionChanged(tree);

        try tree.SetFocus; except end;
    end;
end;

procedure populateOutbox(tree: TTreeView);
var
    user: string;
    tc: TTwitter;
    i: int;
    item: TTreeNode;
begin
    user := _getSelectedUser;
    if accounts.IndexOf(user) <> -1 then
    begin
        tree.Items.BeginUpdate;
        tree.Items.Clear;
        tree.Items.EndUpdate;

        tree.Items.BeginUpdate;

        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        for i := 0 to tc.MessagesOutbox.Count -1 do
        begin
            item := tree.Items.Add('ITEM');
            item.Data := tc.MessagesOutbox.Items[i];
        end;

        tree.Items.EndUpdate;

        if tree.Items.Count <> 0 then
            tree.Items.Item[0].Selected := true;

        TLabel(tree.Owner.Find('lTotal')).Caption := DoubleFormat('#,##0', tc.MessagesOutbox.Count);
        if tree.Items.Count <> 0 then
        TLabel(tree.Owner.Find('lPos')).Caption := DoubleFormat('#,##0', tree.selected.AbsoluteIndex +1)
        else
        TLabel(tree.Owner.Find('lPos')).Caption := '0';

        tree.Repaint;
        growth_listTree_OnSelectionChanged(tree);

        try tree.SetFocus; except end;
    end;
end;

procedure populateFollowers(tree: TTreeView);
var
    user: string;
    tc: TTwitter;
    i: int;
    item: TTreeNode;
begin
    user := _getSelectedUser;
    if accounts.IndexOf(user) <> -1 then
    begin
        tree.Items.BeginUpdate;
        tree.Items.Clear;
        tree.Items.EndUpdate;

        tree.Items.BeginUpdate;

        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        for i := 0 to tc.Followers.Count -1 do
        begin
            item := tree.Items.Add('ITEM');
            item.Data := tc.Followers.Items[i];
        end;

        tree.Items.EndUpdate;

        if tree.Items.Count <> 0 then
            tree.Items.Item[0].Selected := true;

        for i := 0 to tc.Followers.Count -1 do
        begin
            if tc.Followers.Items[i].isNew then
            begin
                if i < tree.Items.Count then
                    tree.Items.Item[i].Selected := true
                else
                    tree.Items.Item[tree.Items.Count -1].Selected := true;
                break;
            end;
        end;

        TLabel(tree.Owner.Find('lTotal')).Caption := DoubleFormat('#,##0', tc.Followers.Count);
        if tree.Items.Count <> 0 then
        TLabel(tree.Owner.Find('lPos')).Caption := DoubleFormat('#,##0', tree.selected.AbsoluteIndex +1)
        else
        TLabel(tree.Owner.Find('lPos')).Caption := '0';

        tree.Repaint;
        growth_listTree_OnSelectionChanged(tree);

        try tree.SetFocus; except end;
    end;
end;

procedure populateFollowing(tree: TTreeView);
var
    user: string;
    tc: TTwitter;
    i: int;
    item: TTreeNode;
begin
    user := _getSelectedUser;
    if accounts.IndexOf(user) <> -1 then
    begin
        tree.Items.BeginUpdate;
        tree.Items.Clear;
        tree.Items.EndUpdate;

        tree.Items.BeginUpdate;

        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        for i := 0 to tc.Following.Count -1 do
        begin
            if Pos('        '+tc.Following.Items[i].UserData.UserID, FollowingIDS.Text) > 0 then
            begin
                item := tree.Items.Add('ITEM');
                item.Data := tc.Following.Items[i];
            end;
        end;

        tree.Items.EndUpdate;

        if tree.Items.Count <> 0 then
            tree.Items.Item[0].Selected := true;

        for i := 0 to tc.Following.Count -1 do
        begin
            if tc.Following.Items[i].isNew then
            begin
                if i < tree.Items.Count then
                    tree.Items.Item[i].Selected := true
                else
                    tree.Items.Item[tree.Items.Count -1].Selected := true;
                break;
            end;
        end;

        TLabel(tree.Owner.Find('lTotal')).Caption := DoubleFormat('#,##0', tc.Following.Count);
        if tree.Items.Count <> 0 then
        TLabel(tree.Owner.Find('lPos')).Caption := DoubleFormat('#,##0', tree.selected.AbsoluteIndex +1)
        else
        TLabel(tree.Owner.Find('lPos')).Caption := '0';

        tree.Repaint;
        growth_listTree_OnSelectionChanged(tree);

        try tree.SetFocus; except end;
    end;
end;

procedure populateDroppers(tree: TTreeView);
var
    user: string;
    tc: TTwitter;
    i: int;
    item: TTreeNode;
begin
    user := _getSelectedUser;
    if accounts.IndexOf(user) <> -1 then
    begin
        tree.Items.BeginUpdate;
        tree.Items.Clear;
        tree.Items.EndUpdate;

        tree.Items.BeginUpdate;

        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        for i := 0 to tc.Droppers.Count -1 do
        begin
            if Pos('        '+tc.Droppers.Items[i].UserData.UserID, OldFollowersIDS.Text) > 0 then
            begin
                item := tree.Items.Add('ITEM');
                item.Data := tc.Droppers.Items[i];
            end;
        end;

        tree.Items.EndUpdate;

        if tree.Items.Count <> 0 then
            tree.Items.Item[0].Selected := true;

        tree.Repaint;
        growth_listTree_OnSelectionChanged(tree);

        try tree.SetFocus; except end;
    end;
end;

procedure growth_listTree_OnCustomDrawItem(Sender: TTreeView; Node: TTreeNode; DrawInfo: TCustomDrawInfo; var DefaultDraw: bool);
var
    bgColor: int;
    tw, tw2, th, th2: int;
    ucdate: string;
    tweetID: string;
    tweetTrace: string;
    actionName: string;
    i: int;
    tc: TTwitter = nil;
    favCount: int = 0;
    retCount: int = 0;
    clickCount: int = 0;
    hasImage: bool = false;
    imgFile: string;
    str: TStringList;
    pic: TPicture;
begin
    bgColor := clWhite;

    if Node <> nil then
    begin
        if Node.Data <> nil then
        begin
            //message painter
            if TObject(Node.Data).ClassName = 'TTwitterMessageData' then
            begin
                try
                    if Pos(TTwitterMessageData(Node.Data).MessageID, msgList.Text) > 0 then
                    Sender.Canvas.Font.Color := clGray
                    else
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

                    Sender.Canvas.Font.Size := Sender.Font.Size;
                    Sender.Canvas.Font.Style := fsBold;
                    tw := Sender.Canvas.textWidth(TTwitterMessageData(Node.Data).UserData.UserDisplayName);
                    th := Sender.Canvas.textHeight(TTwitterMessageData(Node.Data).UserData.UserDisplayName);
                    Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 10,
                                          Node.DisplayRectTop(false) + 10,
                                          TTwitterMessageData(Node.Data).UserData.UserDisplayName);
                    Sender.Canvas.Font.Style := 0;

                    if OSX then
                    Sender.Canvas.Font.Size := 12
                    else
                    Sender.Canvas.Font.Size := 8;
                    Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + tw + 20, Node.DisplayRectTop(false) + 10,
                                            '- @'+TTwitterMessageData(Node.Data).UserData.UserName);
                    tw := tw + Sender.Canvas.textWidth('- @'+TTwitterMessageData(Node.Data).UserData.UserName);
                    Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + tw + 20, Node.DisplayRectTop(false) + 10,
                                            ' - '+copy(TTwitterMessageData(Node.Data).MessageCreateDate, 0, Pos('+', TTwitterMessageData(Node.Data).MessageCreateDate) -1));
                    Sender.Canvas.Font.Size := Sender.Font.Size;

                    Sender.Canvas.TextRect(Node.DisplayRectLeft(false) + 10,
                                           Node.DisplayRectTop(false) + th +10,
                                           Node.DisplayRectRight(false) - 10,
                                           Node.DisplayRectBottom(false) - 20,
                                           5, 5,
                                           TTwitterMessageData(Node.Data).MessageText, true, false);

                    Sender.Canvas.drawImageStretch(tweetShadow,
                                                   Node.DisplayRectLeft(false),
                                                   Node.DisplayRectBottom(false) -10,
                                                   Node.DisplayRectRight(false),
                                                   Node.DisplayRectBottom(false));
                except end;
            end;

            //followers painter
            if TObject(Node.Data).ClassName = 'TTwitterHiveData' then
            begin
                try
                    if TTwitterHiveData(Node.Data).isNew then
                    Sender.Canvas.Font.Color := $00444444
                    else
                    Sender.Canvas.Font.Color := clGray;

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

                    Sender.Canvas.Font.Size := Sender.Font.Size;
                    Sender.Canvas.Font.Style := fsBold;
                    tw := Sender.Canvas.textWidth(TTwitterHiveData(Node.Data).UserData.UserDisplayName);
                    th := Sender.Canvas.textHeight(TTwitterHiveData(Node.Data).UserData.UserDisplayName);
                    Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 10,
                                          Node.DisplayRectTop(false) + 10,
                                          TTwitterHiveData(Node.Data).UserData.UserDisplayName);
                    Sender.Canvas.Font.Style := 0;

                    ucdate := copy(TTwitterHiveData(Node.Data).UserData.UserCreateDate, 0, Pos(':', TTwitterHiveData(Node.Data).UserData.UserCreateDate) -3);
                    ucdate := trim(ucdate)+' '+copy(TTwitterHiveData(Node.Data).UserData.UserCreateDate, Pos('+', TTwitterHiveData(Node.Data).UserData.UserCreateDate) +1, 1000);
                    ucdate := ReplaceOnce(ucdate, '0000 ', '');

                    if OSX then
                    Sender.Canvas.Font.Size := 12
                    else
                    Sender.Canvas.Font.Size := 8;
                    Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + tw + 20, Node.DisplayRectTop(false) + 10,
                                            '- @'+TTwitterHiveData(Node.Data).UserData.UserName);
                    tw := tw + Sender.Canvas.textWidth('- @'+TTwitterHiveData(Node.Data).UserData.UserName);
                    Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + tw + 20, Node.DisplayRectTop(false) + 10,
                                            ' - '+ucdate);
                    Sender.Canvas.Font.Size := Sender.Font.Size;

                    Sender.Canvas.TextRect(Node.DisplayRectLeft(false) + 10,
                                           Node.DisplayRectTop(false) + th +10,
                                           Node.DisplayRectRight(false) - 130,
                                           Node.DisplayRectBottom(false) - 20,
                                           5, 5,
                                           TTwitterHiveData(Node.Data).UserData.UserDescription, true, false);

                    if OSX then
                    Sender.Canvas.Font.Size := 18
                    else
                    Sender.Canvas.Font.Size := 14;
                    Sender.Canvas.Font.Color := clBlue;
                    tw := Sender.Canvas.TextWidth('« '+DoubleFormat('#,##0', TTwitterHiveData(Node.Data).UserData.UserFollowersCount));
                    th2 := Sender.Canvas.TextHeight('« '+DoubleFormat('#,##0', TTwitterHiveData(Node.Data).UserData.UserFollowersCount));
                    Sender.Canvas.TextOut(Node.DisplayRectRight(false) - tw - 10,
                                          Node.DisplayRectTop(false) + th +10,
                                          '« '+DoubleFormat('#,##0', TTwitterHiveData(Node.Data).UserData.UserFollowersCount));

                    Sender.Canvas.Font.Color := clGreen;
                    tw := Sender.Canvas.TextWidth('» '+DoubleFormat('#,##0', TTwitterHiveData(Node.Data).UserData.UserFollowingCount));
                    Sender.Canvas.TextOut(Node.DisplayRectRight(false) - tw - 10,
                                          Node.DisplayRectTop(false) + th + th2 +8,
                                          '» '+DoubleFormat('#,##0', TTwitterHiveData(Node.Data).UserData.UserFollowingCount));
                    Sender.Canvas.Font.Color := Sender.Font.Color;

                    Sender.Canvas.Font.Color := clNavy;
                    tw := Sender.Canvas.TextWidth(DoubleFormat('#,##0', TTwitterHiveData(Node.Data).UserData.UserTweetCount));
                    Sender.Canvas.TextOut(Node.DisplayRectRight(false) - tw - 10,
                                          Node.DisplayRectTop(false) + th + th2 + th2 +6,
                                          DoubleFormat('#,##0', TTwitterHiveData(Node.Data).UserData.UserTweetCount));
                    Sender.Canvas.drawImage(birdBmp, Node.DisplayRectRight(false) - tw - 30,
                                            Node.DisplayRectTop(false) + th + th2 + th2 +8);

                    if OSX then
                    Sender.Canvas.Font.Size := 14
                    else
                    Sender.Canvas.Font.Size := 10;
                    if NetTree.Selected <> nil then
                    begin
                        if NetTree.Selected.ImageIndex = 4 then
                        begin
                            Sender.Canvas.Font.Color := clGreen;
                            tw := Sender.Canvas.TextWidth('You''r Following');
                            if TTwitterHiveData(Node.Data).UserData.Following then
                            Sender.Canvas.TextOut(Node.DisplayRectRight(false) - tw - 10,
                                                  Node.DisplayRectTop(false) + th + th2 + th2 + th2 +5,
                                                  'You''r Following');
                        end;
                        if NetTree.Selected.ImageIndex = 5 then
                        begin
                            if Pos('        '+TTwitterHiveData(Node.Data).UserData.UserID, OldFollowersIDS.Text) > 0 then
                            begin
                                Sender.Canvas.Font.Color := clBlue;
                                tw := Sender.Canvas.TextWidth('Is Following You');
                                if TTwitterHiveData(Node.Data).UserData.Following then
                                Sender.Canvas.TextOut(Node.DisplayRectRight(false) - tw - 10,
                                                      Node.DisplayRectTop(false) + th + th2 + th2 + th2 +5,
                                                      'Is Following You');
                            end
                            else
                            begin
                                Sender.Canvas.Font.Color := clRed;
                                tw := Sender.Canvas.TextWidth('Not Following You');
                                if TTwitterHiveData(Node.Data).UserData.Following then
                                Sender.Canvas.TextOut(Node.DisplayRectRight(false) - tw - 10,
                                                      Node.DisplayRectTop(false) + th + th2 + th2 + th2 +5,
                                                      'Not Following You');
                            end;
                        end;
                        if NetTree.Selected.ImageIndex = 6 then
                        begin
                            if Pos('        '+TTwitterHiveData(Node.Data).UserData.UserID, FollowingIDS.Text) > 0 then
                            begin
                                Sender.Canvas.Font.Color := clGreen;
                                tw := Sender.Canvas.TextWidth('You''r Following');
                                if TTwitterHiveData(Node.Data).UserData.Following then
                                Sender.Canvas.TextOut(Node.DisplayRectRight(false) - tw - 10,
                                                      Node.DisplayRectTop(false) + th + th2 + th2 + th2 +5,
                                                      'You''r Following');
                            end;
                        end;
                    end;

                    Sender.Canvas.drawImageStretch(tweetShadow,
                                                   Node.DisplayRectLeft(false),
                                                   Node.DisplayRectBottom(false) -10,
                                                   Node.DisplayRectRight(false),
                                                   Node.DisplayRectBottom(false));

                    Sender.Canvas.Font.Color := $00444444;
                    Sender.Canvas.Font.Size := Sender.Font.Size;
                except end;
            end;
        end;

        //campaing painter
        if pos('.tweet', Node.Text) > 0 then
        begin
            Sender.Canvas.Font.Color := $00444444;
            Sender.Canvas.Font.Size := Sender.Font.Size;

            tweetTrace := FileNameOf(Node.Text);
            tweetTrace := copy(tweetTrace, 0, Pos('-', tweetTrace) -1);
            tweetID := FileNameOf(Node.Text);
            tweetID := copy(tweetID, Pos('-', tweetID) +1, 1000);
            favCount := 0;
            retCount  := 0;
            clickCount := 0;
            if accounts.IndexOf(_getSelectedUser) <> -1 then
            begin
                tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
                for i := 0 to tc.TimelineUser.Count -1 do
                begin
                    if tc.TimelineUser.Items[i].TweetID = tweetID then
                    begin
                        favCount := tc.TimelineUser.Items[i].FavoriteCount;
                        retCount := tc.TimelineUser.Items[i].RetweetCount;
                        break;
                    end;
                end;
            end;
            for i := 0 to clickLog.Count -1 do
            begin
                if Pos(':'+tweetTrace, clickLog.Strings[i]) > 0 then
                    clickCount := clickCount +1;
            end;

            try
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
                imgFile := ChangeFileExt(FilePathOf(Node.Text)+tweetTrace, '.jpg');
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

                imgFile := ChangeFileExt(FilePathOf(Node.Text)+tweetTrace, '.jpeg');
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

                imgFile := ChangeFileExt(FilePathOf(Node.Text)+tweetTrace, '.png');
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

                Sender.Canvas.Font.Color := clGreen;
                Sender.Canvas.Font.Style := fsBold;
                tw := Sender.Canvas.textWidth(IntToStr(retCount));
                th := Sender.Canvas.textHeight(IntToStr(retCount));

                Sender.Canvas.drawImage(rtBmp, Node.DisplayRectLeft(false) + 8,
                                             Node.DisplayRectBottom(false) - th - 16);
                Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 28,
                                      Node.DisplayRectBottom(false) - th - 16,
                                      IntToStr(retCount));

                Sender.Canvas.drawImage(hartBmp, Node.DisplayRectLeft(false) + 28 + tw + 8,
                                             Node.DisplayRectBottom(false) - th - 16);
                Sender.Canvas.Font.Color := clRed;
                Sender.Canvas.Font.Style := fsBold;
                Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 28 + tw + 28,
                                      Node.DisplayRectBottom(false) - th - 16,
                                      IntToStr(favCount));

                tw2 := Sender.Canvas.textWidth(IntToStr(favCount));
                Sender.Canvas.drawImage(clickBmp, Node.DisplayRectLeft(false) + 28 + 28 + tw2 + tw + 8,
                                             Node.DisplayRectBottom(false) - th - 14);
                Sender.Canvas.Font.Color := clBlue;
                Sender.Canvas.Font.Style := fsBold;
                Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 28 + tw + 28 + tw2 + 26,
                                      Node.DisplayRectBottom(false) - th - 16,
                                      IntToStr(clickCount));

                Sender.Canvas.Font.Style := 0;
                Sender.Canvas.Font.Color := Sender.Font.Color;


                Sender.Canvas.drawImageStretch(tweetShadow,
                                               Node.DisplayRectLeft(false),
                                               Node.DisplayRectBottom(false) -10,
                                               Node.DisplayRectRight(false),
                                               Node.DisplayRectBottom(false));
            except end;
        end;

        //action painter
        if pos('.action', Node.Text) > 0 then
        begin
            Sender.Canvas.Font.Color := $00444444;
            Sender.Canvas.Font.Size := Sender.Font.Size;

            try
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


                str := TStringList.Create;
                str.LoadFromFile(Node.Text);

                if str.Values['action'] = '0' then
                    actionName := 'Tweet to User'
                else if str.Values['action'] = '1' then
                    actionName := 'Send Direct Message to User'
                else if str.Values['action'] = '2' then
                    actionName := 'Reply to Tweet'
                else if str.Values['action'] = '3' then
                    actionName := 'Reply to Message'
                else if str.Values['action'] = '4' then
                    actionName := 'Favorite Tweet'
                else if str.Values['action'] = '5' then
                    actionName := 'Re-Tweet Tweet'
                else if str.Values['action'] = '6' then
                    actionName := 'Follow User'
                else if str.Values['action'] = '7' then
                    actionName := 'Unfollow User';

                Sender.Canvas.Font.Style := fsBold;
                Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 10,
                                      Node.DisplayRectTop(false) + 10,
                                      str.Values['name']);

                Sender.Canvas.drawImage(actionArrow,
                                        Node.DisplayRectLeft(false) + 10,
                                        Node.DisplayRectTop(false) + 40);

                Sender.Canvas.Font.Style := 0;
                Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 110,
                                      Node.DisplayRectTop(false) + 53,
                                      actionName);

                str.Free;

                Sender.Canvas.Font.Color := Sender.Font.Color;


                Sender.Canvas.drawImageStretch(tweetShadow,
                                               Node.DisplayRectLeft(false),
                                               Node.DisplayRectBottom(false) -10,
                                               Node.DisplayRectRight(false),
                                               Node.DisplayRectBottom(false));

            except end;
        end;

        //trigger painter
        if pos('.trigger', Node.Text) > 0 then
        begin
            Sender.Canvas.Font.Color := $00444444;
            Sender.Canvas.Font.Size := Sender.Font.Size;

            try
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


                str := TStringList.Create;
                str.LoadFromFile(Node.Text);


                if str.Values['event'] = '0' then
                    actionName := 'On User Tweet > '+str.Values['query']
                else if str.Values['event'] = '1' then
                    actionName := 'On Hash Query > '+str.Values['query']
                else if str.Values['event'] = '2' then
                    actionName := 'On Followed'
                else if str.Values['event'] = '3' then
                    actionName := 'On Unfollowed'
                else if str.Values['event'] = '4' then
                    actionName := 'On Retweeted'
                else if str.Values['event'] = '5' then
                    actionName := 'On Mentioned'
                else if str.Values['event'] = '6' then
                    actionName := 'On Message Received';

                Sender.Canvas.Font.Style := fsBold;
                Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 10,
                                      Node.DisplayRectTop(false) + 10,
                                      actionName);

                Sender.Canvas.drawImage(actionArrow,
                                        Node.DisplayRectLeft(false) + 10,
                                        Node.DisplayRectTop(false) + 40);

                Sender.Canvas.Font.Style := 0;
                Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 110,
                                      Node.DisplayRectTop(false) + 53,
                                      str.Values['actionname']);

                str.Free;

                Sender.Canvas.Font.Color := Sender.Font.Color;


                Sender.Canvas.drawImageStretch(tweetShadow,
                                               Node.DisplayRectLeft(false),
                                               Node.DisplayRectBottom(false) -10,
                                               Node.DisplayRectRight(false),
                                               Node.DisplayRectBottom(false));

            except end;
        end;
    end;

    DefaultDraw := false;
end;

procedure growth_listTree_OnClick(Sender: TTreeView);
var
    pan: TPanel;
begin
    pan := TPanel(Sender.Owner.Find('panActions'));
    if Sender.Selected <> nil then
    begin
        pan.Left := Sender.Left + Sender.Selected.DisplayRectRight(false) - pan.Width -10;
        pan.Top := Sender.Top + Sender.Selected.DisplayRectBottom(false) - pan.Height -18;
    end;
    pan.Visible := (Sender.Selected <> nil) and (NetTree.Selected.ImageIndex in [2,3,4,5,6]);
end;

procedure growth_listTree_OnSelectionChanged(Sender: TTreeView);
var
    pan: TPanel;
begin
    pan := TPanel(Sender.Owner.Find('panActions'));
    if Sender.Selected <> nil then
    begin
        pan.Left := Sender.Left + Sender.Selected.DisplayRectRight(false) - pan.Width -10;
        pan.Top := Sender.Top + Sender.Selected.DisplayRectBottom(false) - pan.Height -18;
    end;
    pan.Visible := (Sender.Selected <> nil) and (NetTree.Selected.ImageIndex in [2,3,4,5,6]);
end;

procedure growth_navTree_OnChange(Sender: TTreeView; Node: TTreeNode);
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

procedure growth_navTree_OnChanging(Sender: TTreeView; Node: TTreeNode; var Allow: bool);
begin
    Allow := (_getSelectedUser <> '');
    if not Allow then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
    end;
end;

procedure growth_listTree_OnMouseWheel(Sender: TTreeView; keyInfo: TKeyInfo; WheelDelta: int; X: int; Y: int; var Handled: bool);
begin
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

procedure growth_bMenu_OnClick(Sender: TBGRAButton);
begin
    if NetTree.Selected.ImageIndex in [2,3] then
        TPopupMenu(Sender.Owner.Find('PopupMenu1')).PopUp;
    if NetTree.Selected.ImageIndex in [4,5,6] then
        TPopupMenu(Sender.Owner.Find('PopupMenu3')).PopUp;
end;

procedure growth_menuLinkClick(Sender: TMenuItem);
begin
    ShellOpen(Sender.Hint);
end;

procedure growth_PopupMenu1_OnPopup(Sender: TPopupMenu);
var
    td: TTwitterMessageData;
    tmp: string = '';
    link: string = '';
    i: int;
    menu: TMenuItem;
begin
    TMenuItem(Sender.Owner.Find('mReply')).Visible := true;

    if NetTree.Selected <> nil then
    begin
        if Pos('Sent', NetTree.Selected.Text) > 0 then
            TMenuItem(Sender.Owner.Find('mReply')).Visible := false;
    end;

    if NetList.Selected <> nil then
    begin
        //links
        TMenuItem(Sender.Owner.Find('mOpenLink')).Clear;

        td := TTwitterMessageData(NetList.Selected.Data);

        if Pos('http', Lower(td.MessageText)) > 0 then
        begin
            tmp := td.MessageText;
            while (Pos('http', Lower(tmp)) > 0) do
            begin
                tmp := copy(tmp, Pos('http', Lower(tmp)), 100000);
                i := 0;
                link := '';
                while true do
                begin
                    i := i + 1;
                    if (tmp[i] = ' ') or
                       (tmp[i] = #0) or
                       (tmp[i] = #13) or
                       (tmp[i] = #10) then break;
                    link := link+tmp[i];
                end;
                if (Pos('...', trim(link)) = 0) and
                   (Pos('http:/...', trim(link)) = 0) and
                   (Pos('https:/...', trim(link)) = 0) and
                   (trim(link) <> 'https:/...') and
                   (trim(link) <> 'http:/...') and
                   (len(trim(link)) > 20) and
                   //(len(trim(link)) < 30) and
                   (trim(link) <> '') then
                begin
                    link := ReplaceAll(link, ',', '');
                    menu := TMenuItem.Create(Sender.Owner);
                    menu.Caption := link;
                    menu.Hint := link;
                    menu.OnClick := @growth_menuLinkClick;
                    TMenuItem(Sender.Owner.Find('mOpenLink')).Add(menu);
                end;
                tmp := copy(tmp, len(link) +1, 1000);
            end;

            TMenuItem(Sender.Owner.Find('mOpenLink')).Visible := (TMenuItem(Sender.Owner.Find('mOpenLink')).Count <> 0);
        end
            else
        begin
            TMenuItem(Sender.Owner.Find('mOpenLink')).Visible := false;
        end;

        TMenuItem(Sender.Owner.Find('MenuItem2')).Visible :=
            TMenuItem(Sender.Owner.Find('mOpenLink')).Visible;

        TMenuItem(Sender.Owner.Find('mMuteUser')).Enabled :=
            (_getSelectedUser <> '@'+td.UserData.UserName);
    end;
end;

procedure growth_listTree_OnChange(Sender: TTreeView; Node: TTreeNode);
begin
    if Sender.Selected <> nil then
    TLabel(Sender.Owner.Find('lPos')).Caption := DoubleFormat('#,##0', Sender.selected.AbsoluteIndex +1)
    else
    TLabel(Sender.Owner.Find('lPos')).Caption := '0';
end;

procedure growth_UrlLink1_OnClick(Sender: TUrlLink);
begin
    NetTree.Items[1].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_UrlLink2_OnClick(Sender: TUrlLink);
begin
    NetTree.Items[2].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_UrlLink3_OnClick(Sender: TUrlLink);
begin
    NetTree.Items[4].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_UrlLink4_OnClick(Sender: TUrlLink);
begin
    NetTree.Items[5].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_UrlLink5_OnClick(Sender: TUrlLink);
begin
    NetTree.Items[6].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_UrlLink6_OnClick(Sender: TUrlLink);
begin
    NetTree.Items[8].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_UrlLink7_OnClick(Sender: TUrlLink);
begin
    NetTree.Items[10].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_UrlLink8_OnClick(Sender: TUrlLink);
begin
    NetTree.Items[11].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_navTree_OnCustomDrawItem(Sender: TTreeView; Node: TTreeNode; DrawInfo: TCustomDrawInfo; var DefaultDraw: bool);
begin
    if Node <> nil then
    begin
        if Pos('sec)', Node.Text) > 0 then
        begin
            //Sender.Canvas.Font.Style := 0;
            Sender.Canvas.Font.Color := clGray
        end
            else
        begin
            //Sender.Canvas.Font.Style := fsBold;
            Sender.Canvas.Font.Color := $00444444;
        end;
    end;
end;

procedure growth_bMenu2_OnClick(Sender: TBGRAButton);
var
    pop: TPopupMenu;
    x, y: int;
begin
    pop := TPopupMenu(Sender.Owner.Find('PopupMenu2'));

    x := Sender.ClientToScreenX(0, 0);
    y := Sender.ClientToScreenY(0, 0) + Sender.Height;

    pop.PopUpAt(x, y);
end;

procedure growth_mNewCampaign_OnClick(Sender: TMenuItem);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    f := newtweetCreate(MainForm);
    f.Caption := 'New Campaign Tweet';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    f.ShowModalDimmed;
end;

procedure growth_mOpenMessage_OnClick(Sender: TMenuItem);
var
    f: TForm;
    tm: TTwitterMessageData;
begin
    tm := TTwitterMessageData(NetList.Selected.Data);

    if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'msg.list') then
        msgList.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'msg.list');

    if msgList.IndexOf(tm.MessageID) = -1 then
        msgList.Add(tm.MessageID);

    msgList.SaveToFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'msg.list');

    f := viewmessageCreate(MainForm);
    f.Caption := 'Message from '+tm.UserData.UserDisplayName;
    TMemo(f.Find('Memo1')).Lines.Text := tm.MessageText;
    f.ShowModalDimmed;
end;

procedure growth_mMarkasRead_OnClick(Sender: TMenuItem);
var
    tm: TTwitterMessageData;
begin
    tm := TTwitterMessageData(NetList.Selected.Data);

    if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'msg.list') then
        msgList.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'msg.list');

    if msgList.IndexOf(tm.MessageID) = -1 then
        msgList.Add(tm.MessageID);

    msgList.SaveToFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'msg.list');

    NetList.repaint;
end;

procedure growth_mMarkasUnread_OnClick(Sender: TMenuItem);
var
    tm: TTwitterMessageData;
begin
    tm := TTwitterMessageData(NetList.Selected.Data);

    if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'msg.list') then
        msgList.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'msg.list');

    if msgList.IndexOf(tm.MessageID) <> -1 then
        msgList.Delete(msgList.IndexOf(tm.MessageID));

    msgList.SaveToFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'msg.list');

    NetList.repaint;
end;

procedure growth_mReply_OnClick(Sender: TMenuItem);
var
    tm: TTwitterMessageData;
    f: TForm;
begin
    tm := TTwitterMessageData(NetList.Selected.Data);

    f := messageCreate(MainForm);
    TEdit(f.Find('Edit1')).Text := '@'+tm.UserData.UserName;
    f.ShowModalDimmed;
end;

procedure growth_mDelete_OnClick(Sender: TMenuItem);
var
    tm: TTwitterMessageData;
    tc: TTwitter;
begin
    if MsgWarning('Warning', 'You are about to delete a message, continue?') then
    begin
        tm := TTwitterMessageData(NetList.Selected.Data);
        tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

        try
            tc.deleteMessage(tm.MessageID);
            NetList.Selected.Delete;
        except end;
    end;
end;

procedure growth_mViewUser_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterMessageData;
    http: THttp;
    fs: TFileStream;
    imgFile: string;
begin
    td := TTwitterMessageData(NetList.Selected.Data);

    if Pos('.jpg', Lower(td.UserData.UserImageUrl)) > 0 then
        imgFile := TempDir+'img.jpg';
    if Pos('.jpeg', Lower(td.UserData.UserImageUrl)) > 0 then
        imgFile := TempDir+'img.jpeg';
    if Pos('.png', Lower(td.UserData.UserImageUrl)) > 0 then
        imgFile := TempDir+'img.png';

    f := viewuserCreate(MainForm);
    f.Caption := td.UserData.UserDisplayName;
    TLabel(f.Find('lName')).Caption := td.UserData.UserDisplayName;
    TLabel(f.Find('lUser')).Caption := '@'+td.UserData.UserName;
    TPanel(f.Find('Panel1')).Caption := DoubleFormat('#,##0', td.UserData.UserFollowersCount);
    TPanel(f.Find('Panel2')).Caption := DoubleFormat('#,##0', td.UserData.UserFollowingCount);
    TPanel(f.Find('Panel3')).Caption := DoubleFormat('#,##0', td.UserData.UserTweetCount);
    TLabel(f.Find('Label4')).Caption := td.UserData.UserDescription;
    TLabel(f.Find('Label5')).Caption := 'Location: '+td.UserData.UserLocation;

    DeleteFile(imgFile);
    try
        http := THttp.Create;
        fs := TFileStream.Create(imgFile, fmCreate);
        http.urlGetBinary(ReplaceOnce(td.UserData.UserImageUrl, '_normal', ''), fs);
        fs.free;
        http.free;
        TImage(f.Find('Image1')).Picture.LoadFromFile(imgFile);
    except end;

    if Pos('        '+td.UserData.UserID, FollowingIDS.Text) > 0 then
    TButton(f.Find('Button2')).Caption := 'Unfollow'
    else
    TButton(f.Find('Button2')).Caption := 'Follow';

    if Pos('        '+td.UserData.UserID, FollowersIDS.Text) > 0 then
    TLabel(f.Find('Label6')).Caption := 'Is Following You';

    if _getSelectedUser =  '@'+td.UserData.UserName then
    TButton(f.Find('Button2')).Visible := false;

    DeleteFile(imgFile);


    f.ShowModalDimmed;
end;

procedure growth_PopupMenu3_OnPopup(Sender: TPopupMenu);
var
    td: TTwitterHiveData;
    link: string;
    tmp: string;
    menu: TMenuItem;
    i: int;
begin
    td := TTwitterHiveData(NetList.Selected.Data);

    if NetList.Selected <> nil then
    begin
        //links
        TMenuItem(Sender.Owner.Find('mOpenLink2')).Clear;

        td := TTwitterHiveData(NetList.Selected.Data);

        if Pos('http', Lower(td.UserData.UserDescription)) > 0 then
        begin
            tmp := td.UserData.UserDescription;
            while (Pos('http', Lower(tmp)) > 0) do
            begin
                tmp := copy(tmp, Pos('http', Lower(tmp)), 100000);
                i := 0;
                link := '';
                while true do
                begin
                    i := i + 1;
                    if (tmp[i] = ' ') or
                       (tmp[i] = #0) or
                       (tmp[i] = #13) or
                       (tmp[i] = #10) then break;
                    link := link+tmp[i];
                end;
                if (trim(link) <> '') then
                begin
                    link := ReplaceAll(link, ',', '');
                    menu := TMenuItem.Create(Sender.Owner);
                    menu.Caption := link;
                    menu.Hint := link;
                    menu.OnClick := @growth_menuLinkClick;
                    TMenuItem(Sender.Owner.Find('mOpenLink2')).Add(menu);
                end;
                tmp := copy(tmp, len(link) +1, 1000);
            end;

            TMenuItem(Sender.Owner.Find('mOpenLink2')).Visible := (TMenuItem(Sender.Owner.Find('mOpenLink2')).Count <> 0);
        end
            else
        begin
            TMenuItem(Sender.Owner.Find('mOpenLink2')).Visible := false;
        end;

        TMenuItem(Sender.Owner.Find('MenuItem22')).Visible :=
            TMenuItem(Sender.Owner.Find('mOpenLink2')).Visible;
    end;

    if Pos(td.UserData.UserID, FollowingIDS.Text) > 0 then
    TMenuItem(Sender.Owner.Find('mFollow')).Caption := 'Unfollow'
    else
    TMenuItem(Sender.Owner.Find('mFollow')).Caption := 'Follow';

    TMenuItem(Sender.Owner.Find('mIgnoreAndRemove')).Visible :=
        (NetTree.Selected.ImageIndex = 6);

    if NetTree.Selected.ImageIndex = 4 then
        TMenuItem(Sender.Owner.Find('mSendMessage')).Visible := true
    else
        TMenuItem(Sender.Owner.Find('mSendMessage')).Visible :=
            (Pos('        '+td.UserData.UserID, FollowersIDS.Text) > 0);

    TMenuItem(Sender.Owner.Find('mMuteUser2')).Enabled :=
            (_getSelectedUser <> '@'+td.UserData.UserName);
end;

procedure growth_mFollow_OnClick(Sender: TMenuItem);
var
    td: TTwitterHiveData;
    tc: TTwitter;
begin
    td := TTwitterHiveData(NetList.Selected.Data);
    tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

    if Sender.Caption = 'Unfollow' then
    begin
        try
            tc.unfollowUser(td.UserData.UserName);
            FollowingIDS.Text := ReplaceOnce(FollowingIDS.Text, '        '+td.UserData.UserID, '');
            if NetTree.Selected.ImageIndex = 5 then
                NetList.Selected.Delete;

        except end;
    end
        else
    begin
        try
            tc.followUser(td.UserData.UserName);
            FollowingIDS.Add('        '+td.UserData.UserID);
        except end;
    end;
    NetList.repaint;
end;

procedure growth_mViewUser2_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterHiveData;
    http: THttp;
    fs: TFileStream;
    imgFile: string;
begin
    td := TTwitterHiveData(NetList.Selected.Data);

    if Pos('.jpg', Lower(td.UserData.UserImageUrl)) > 0 then
        imgFile := TempDir+'img.jpg';
    if Pos('.jpeg', Lower(td.UserData.UserImageUrl)) > 0 then
        imgFile := TempDir+'img.jpeg';
    if Pos('.png', Lower(td.UserData.UserImageUrl)) > 0 then
        imgFile := TempDir+'img.png';

    f := viewuserCreate(MainForm);
    f.Caption := td.UserData.UserDisplayName;
    TLabel(f.Find('lName')).Caption := td.UserData.UserDisplayName;
    TLabel(f.Find('lUser')).Caption := '@'+td.UserData.UserName;
    TPanel(f.Find('Panel1')).Caption := DoubleFormat('#,##0', td.UserData.UserFollowersCount);
    TPanel(f.Find('Panel2')).Caption := DoubleFormat('#,##0', td.UserData.UserFollowingCount);
    TPanel(f.Find('Panel3')).Caption := DoubleFormat('#,##0', td.UserData.UserTweetCount);
    TLabel(f.Find('Label4')).Caption := td.UserData.UserDescription;
    TLabel(f.Find('Label5')).Caption := 'Location: '+td.UserData.UserLocation;

    DeleteFile(imgFile);
    try
        http := THttp.Create;
        fs := TFileStream.Create(imgFile, fmCreate);
        http.urlGetBinary(ReplaceOnce(td.UserData.UserImageUrl, '_normal', ''), fs);
        fs.free;
        http.free;
        TImage(f.Find('Image1')).Picture.LoadFromFile(imgFile);
    except end;

    if Pos('        '+td.UserData.UserID, FollowingIDS.Text) > 0 then
    TButton(f.Find('Button2')).Caption := 'Unfollow'
    else
    TButton(f.Find('Button2')).Caption := 'Follow';

    if Pos('        '+td.UserData.UserID, FollowersIDS.Text) > 0 then
    TLabel(f.Find('Label6')).Caption := 'Is Following You';

    if _getSelectedUser =  '@'+td.UserData.UserName then
    TButton(f.Find('Button2')).Visible := false;

    DeleteFile(imgFile);


    f.ShowModalDimmed;
end;

procedure growth_mTweetUser_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterHiveData;
begin
    td := TTwitterHiveData(NetList.Selected.Data);

    f := newtweetCreate(MainForm);
    f.Caption := 'Tweet Now';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    TMemo(f.Find('Memo1')).Lines.Text := '@'+td.UserData.UserName;
    f.ShowModalDimmed;
end;

procedure growth_mSendMessage_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterHiveData;
begin
    td := TTwitterHiveData(NetList.Selected.Data);

    f := messageCreate(MainForm);
    f.Caption := 'Tweet Now';
    TEdit(f.Find('Edit1')).Text := '@'+td.UserData.UserName;
    f.ShowModalDimmed;
end;

procedure growth_mIgnoreAndRemove_OnClick(Sender: TMenuItem);
var
    td: TTwitterHiveData;
begin
    td := TTwitterHiveData(NetList.Selected.Data);

    OldFollowersIDS.Text := ReplaceOnce(OldFollowersIDS.Text, '        '+td.UserData.UserID, '');
    OldFollowersIDS.SaveToFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep+'followers.init');
    NetList.Selected.Delete;
end;

procedure growth_mMuteUser_OnClick(Sender: TMenuItem);
var
    td: TTwitterMessageData;
begin
    if MsgWarning('Warning', 'You are about to mute all Tweets and Messages of a user, continue?') then
    begin
        td := TTwitterMessageData(TimelineList.Selected.Data);

        if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list') then
            muteList.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list');

        if muteList.indexOf(td.UserData.UserName) = -1 then
            muteList.Add(td.UserData.UserName);

        muteList.SaveToFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list');
    end;
end;

procedure growth_mMuteUser2_OnClick(Sender: TMenuItem);
var
    td: TTwitterHiveData;
begin
    if MsgWarning('Warning', 'You are about to mute all Tweets and Messages of a user, continue?') then
    begin
        td := TTwitterHiveData(TimelineList.Selected.Data);

        if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list') then
            muteList.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list');

        if muteList.indexOf(td.UserData.UserName) = -1 then
            muteList.Add(td.UserData.UserName);

        muteList.SaveToFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list');
    end;
end;

procedure growth_mNewAction_OnClick(Sender: TMenuItem);
begin
    actionCreate(MainForm).ShowModalDimmed;
    NetTree.Items[10].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_PopupMenu2_OnPopup(Sender: TPopupMenu);
begin
    TMenuItem(Sender.Owner.Find('mNewCampaign')).Enabled :=
        (trim(appSettings.Values['live-key']) <> '');
    TMenuItem(Sender.Owner.Find('mDeleteCampaign')).Enabled :=
        (NetList.Selected <> nil) and (NetTree.Selected.ImageIndex = 7);

    TMenuItem(Sender.Owner.Find('mNewAction')).Enabled :=
        (trim(appSettings.Values['live-key']) <> '');
    TMenuItem(Sender.Owner.Find('mModifyAction')).Enabled :=
        (NetList.Selected <> nil) and (NetTree.Selected.ImageIndex = 8);
    TMenuItem(Sender.Owner.Find('mDeleteAction')).Enabled :=
        (NetList.Selected <> nil) and (NetTree.Selected.ImageIndex = 8);

    TMenuItem(Sender.Owner.Find('mNewEvent')).Enabled :=
        (trim(appSettings.Values['live-key']) <> '');
    TMenuItem(Sender.Owner.Find('mModifyEvent')).Enabled :=
        (NetList.Selected <> nil) and (NetTree.Selected.ImageIndex = 9);
    TMenuItem(Sender.Owner.Find('mDeleteEvent')).Enabled :=
        (NetList.Selected <> nil) and (NetTree.Selected.ImageIndex = 9);
end;

procedure growth_mModifyAction_OnClick(Sender: TMenuItem);
var
    str: TStringList;
    f: TForm;
    id: string;
begin
    str := TStringList.Create;
    str.LoadFromFile(NetList.Selected.Text);

    f := actionCreate(MainForm);
    TEdit(f.Find('Edit1')).Text := str.Values['name'];
    TEdit(f.Find('Edit1')).Enabled := false;
    TComboBox(f.Find('ComboBox1')).ItemIndex := StrToIntDef(str.Values['action'], 0);

    str.LoadFromFile(ChangeFileExt(NetList.Selected.Text, '.txt'));
    if trim(str.Text) <> '***' then
    TMemo(f.Find('Memo1')).Lines.Text := str.Text;

    id := FileNameOf(NetList.Selected.Text);
    id := copy(id, 0, Pos('.', id) -1);

    f.Hint := id;
    f.Caption := 'Modify Trigger Action';

    str.Free;

    f.ShowModalDimmed;
    NetTree.Items[10].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_mDeleteAction_OnClick(Sender: TMenuItem);
var
    tc: TTwitter;
    actionName: string;
    files: TStringList;
    str: TStringList;
    canDelete: bool = true;
    home: string;
    i: int;
begin
    home := root+'actions'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep;
    actionName := FileNameOf(NetList.Selected.Text);

    files := TStringList.Create;
    SearchDir(home, '*', files);
    for i := 0 to files.Count -1 do
    begin
        if Pos('.trigger', files.Strings[i]) > 0 then
        begin
            str := TStringList.Create;
            str.LoadFromFile(files.Strings[i]);
            if Pos(actionName, str.Text) > 0 then
            begin
                canDelete := false;
            end;
            str.Free;
        end;
    end;
    files.Free;

    if not canDelete then
    begin
        MsgError('Error', 'Can''t delete an action that is in use by an event.');
        exit;
    end;

    if MsgWarning('Warning', 'You are about to delete an action, continue?') then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

        try
            tc.deleteAction(appSettings.Values['live-key'],
                            NetList.Selected.Text,
                            ChangeFileExt(NetList.Selected.Text, '.txt'));
            DeleteFile(NetList.Selected.Text);
            DeleteFile(ChangeFileExt(NetList.Selected.Text, '.txt'));
            NetList.Selected.Delete;
        except end;
    end;
end;

procedure growth_mNewEvent_OnClick(Sender: TMenuItem);
begin
    eventCreate(MainForm).ShowModalDimmed;
    NetTree.Items[11].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_mModifyEvent_OnClick(Sender: TMenuItem);
var
    str: TStringList;
    f: TForm;
    id: string;
begin
    str := TStringList.Create;
    str.LoadFromFile(NetList.Selected.Text);

    f := eventCreate(MainForm);
    TComboBox(f.Find('ComboBox1')).ItemIndex := StrToIntDef(str.Values['event'], 0);
    event_ComboBox1_OnChange(TComboBox(f.Find('ComboBox1')));
    TComboBox(f.Find('ComboBox2')).ItemIndex := TComboBox(f.Find('ComboBox2')).Items.IndexOf(str.Values['actionname']);
    TEdit(f.Find('Edit1')).Text := str.Values['query'];

    id := FileNameOf(NetList.Selected.Text);
    id := copy(id, 0, Pos('.', id) -1);

    f.Hint := id;
    f.Caption := 'Modify Event Trigger';

    str.Free;

    f.ShowModalDimmed;
    NetTree.Items[11].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_mDeleteEvent_OnClick(Sender: TMenuItem);
var
    tc: TTwitter;
begin
    if MsgWarning('Warning', 'You are about to delete an event, continue?') then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

        try
            tc.deleteEvent(appSettings.Values['live-key'],
                            NetList.Selected.Text);
            DeleteFile(NetList.Selected.Text);
            NetList.Selected.Delete;
        except end;
    end;
end;

procedure growth_mDeleteCampaign_OnClick(Sender: TMenuItem);
begin
    if MsgWarning('Warning', 'You are about to remove a campaign from the Live Click Gate. This action will NOT delete the tweet. Would you like to continue?') then
    begin
        DeleteFile(NetList.Selected.Text);
        NetList.Selected.Delete;
    end;
end;

procedure growth_actPopulateInbox_OnExecute(Sender: TSimpleAction);
begin
    NetTree.Items[1].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_actPopulateOutbox_OnExecute(Sender: TSimpleAction);
begin
    NetTree.Items[2].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_actPopulateFollowers_OnExecute(Sender: TSimpleAction);
begin
    NetTree.Items[4].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_actPopulateFollowing_OnExecute(Sender: TSimpleAction);
begin
    NetTree.Items[5].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_actPopulateDroppers_OnExecute(Sender: TSimpleAction);
begin
    NetTree.Items[6].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_actPopulateCampaigns_OnExecute(Sender: TSimpleAction);
begin
    NetTree.Items[8].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_actPopulateActions_OnExecute(Sender: TSimpleAction);
begin
    NetTree.Items[10].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

procedure growth_actPopulateEvents_OnExecute(Sender: TSimpleAction);
begin
    NetTree.Items[11].Selected := true;
    growth_navTree_OnClick(NetTree);
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//growth initialization constructor
constructor
begin 
end.
