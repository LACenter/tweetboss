////////////////////////////////////////////////////////////////////////////////
// Unit Description  : timelines Description
// Unit Author       : LA.Center Corporation
// Date Created      : April, Thursday 28, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals', 'addquery', 'delquery', 'viewtweet', 'reply', 'message', 'fromaccounts',
    'viewtweet', 'viewimage', 'viewuser';

//constructor of timelines
function timelinesCreate(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructorFromResource(Owner, @timelines_OnCreate, 'timelines');
end;

//OnCreate Event of timelines
procedure timelines_OnCreate(Sender: TFrame);
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

    _setButton(TBGRAButton(Sender.Find('bAdd')), false, false);
    _setButton(TBGRAButton(Sender.Find('bRemove')), false, false);
    _setButton(TBGRAButton(Sender.Find('bMenu')), false, false);

    TImageList(Sender.Find('ImageList1')).GetBitmap(8, rtBmp);
    TImageList(Sender.Find('ImageList1')).GetBitmap(7, hartBmp);
    TImageList(Sender.Find('ImageList1')).GetBitmap(10, birdBmp);
    TImageList(Sender.Find('ImageList1')).GetBitmap(11, clickBmp);

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

    TimeLineTree := TTreeView(Sender.Find('navTree'));
    TimeLineList := TTreeView(Sender.Find('listTree'));

    TimeLineTree.Items.Clear;
    root := TimeLineTree.Items.Add('Timelines');
    root.ImageIndex := 1;
    root.SelectedIndex := root.ImageIndex;

        child := TimeLineTree.Items.AddChild(root, 'Home');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := TimeLineTree.Items.AddChild(root, 'User');
        child.ImageIndex := 3;
        child.SelectedIndex := child.ImageIndex;

        child := TimeLineTree.Items.AddChild(root, 'Mentions');
        child.ImageIndex := 4;
        child.SelectedIndex := child.ImageIndex;

        child := TimeLineTree.Items.AddChild(root, 'Top 10');
        child.ImageIndex := 9;
        child.SelectedIndex := child.ImageIndex;

    root.Expand(false);
    root.Selected := true;

    root := TimeLineTree.Items.Add('Queries');
    root.ImageIndex := 0;
    root.SelectedIndex := root.ImageIndex;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TMenuItem(Sender.find('mMuteUser')).OnClick := @timelines_mMuteUser_OnClick;
    TMenuItem(Sender.find('mFollowUser')).OnClick := @timelines_mFollowUser_OnClick;
    TMenuItem(Sender.find('mViewUser')).OnClick := @timelines_mViewUser_OnClick;
    TMenuItem(Sender.find('mViewImage')).OnClick := @timelines_mViewImage_OnClick;
    TMenuItem(Sender.find('mViewTweet')).OnClick := @timelines_mViewTweet_OnClick;
    TMenuItem(Sender.find('mFollowFromAccounts')).OnClick := @timelines_mFollowFromAccounts_OnClick;
    TMenuItem(Sender.find('mRetweetFromAccounts')).OnClick := @timelines_mRetweetFromAccounts_OnClick;
    TMenuItem(Sender.find('mLikeFromAccounts')).OnClick := @timelines_mLikeFromAccounts_OnClick;
    TMenuItem(Sender.find('mDeleteTweet')).OnClick := @timelines_mDeleteTweet_OnClick;
    TMenuItem(Sender.find('mSendDirectMessage')).OnClick := @timelines_mSendDirectMessage_OnClick;
    TMenuItem(Sender.find('mReplytoTweet')).OnClick := @timelines_mReplytoTweet_OnClick;
    TMenuItem(Sender.find('mRetweet')).OnClick := @timelines_mRetweet_OnClick;
    TMenuItem(Sender.find('mLike')).OnClick := @timelines_mLike_OnClick;
    TSimpleAction(Sender.find('actPopulateTop10')).OnExecute := @timelines_actPopulateTop10_OnExecute;
    TUrlLink(Sender.find('UrlLink5')).OnClick := @timelines_UrlLink5_OnClick;
    TUrlLink(Sender.find('UrlLink4')).OnClick := @timelines_UrlLink4_OnClick;
    TBGRAButton(Sender.find('bRemove')).OnClick := @timelines_bRemove_OnClick;
    TTreeView(Sender.find('navTree')).OnCustomDrawItem := @timelines_navTree_OnCustomDrawItem;
    TSimpleAction(Sender.find('actPopulateQueries')).OnExecute := @timelines_actPopulateQueries_OnExecute;
    TBGRAButton(Sender.find('bAdd')).OnClick := @timelines_bAdd_OnClick;
    TPopupMenu(Sender.find('PopupMenu1')).OnPopup := @timelines_PopupMenu1_OnPopup;
    TBGRAButton(Sender.find('bMenu')).OnClick := @timelines_bMenu_OnClick;
    TTreeView(Sender.find('listTree')).OnClick := @timelines_listTree_OnClick;
    TTreeView(Sender.find('listTree')).OnSelectionChanged := @timelines_listTree_OnSelectionChanged;
    TTreeView(Sender.find('listTree')).OnMouseWheel := @timelines_listTree_OnMouseWheel;
    TUrlLink(Sender.find('UrlLink3')).OnClick := @timelines_UrlLink3_OnClick;
    TUrlLink(Sender.find('UrlLink2')).OnClick := @timelines_UrlLink2_OnClick;
    TUrlLink(Sender.find('UrlLink1')).OnClick := @timelines_UrlLink1_OnClick;
    TSimpleAction(Sender.find('actPopulateSearch')).OnExecute := @timelines_actPopulateSearch_OnExecute;
    TSimpleAction(Sender.find('actPopulateMentions')).OnExecute := @timelines_actPopulateMentions_OnExecute;
    TSimpleAction(Sender.find('actPopulateUser')).OnExecute := @timelines_actPopulateUser_OnExecute;
    TSimpleAction(Sender.find('actPopulateHome')).OnExecute := @timelines_actPopulateHome_OnExecute;
    TTreeView(Sender.find('navTree')).OnClick := @timelines_navTree_OnClick;
    TTreeView(Sender.find('navTree')).OnChanging := @timelines_navTree_OnChanging;
    TTreeView(Sender.find('navTree')).OnChange := @timelines_navTree_OnChange;
    TTreeView(Sender.find('navTree')).OnExpanding := @timelines_navTree_OnExpanding;
    TTreeView(Sender.find('navTree')).OnCollapsing := @timelines_navTree_OnCollapsing;
    TTreeView(Sender.find('listTree')).OnCustomDrawItem := @timelines_listTree_OnCustomDrawItem;
    Sender.OnResize := @timelines_OnResize;
    //</events-bind>
end;

procedure timelines_navTree_OnCollapsing(Sender: TTreeView; Node: TTreeNode; var Allow: bool);
begin
    if Node.ImageIndex = 1 then
    begin
        Node.ImageIndex := 0;
        Node.SelectedIndex := Node.ImageIndex;
    end;
end;

procedure timelines_navTree_OnExpanding(Sender: TTreeView; Node: TTreeNode; var Allow: bool);
begin
    if Node.ImageIndex = 0 then
    begin
        Node.ImageIndex := 1;
        Node.SelectedIndex := Node.ImageIndex;
    end;
end;

procedure timelines_navTree_OnChange(Sender: TTreeView; Node: TTreeNode);
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

procedure timelines_navTree_OnChanging(Sender: TTreeView; Node: TTreeNode; var Allow: bool);
begin
    Allow := (_getSelectedUser <> '');
    if not Allow then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
    end;
end;

procedure timelines_navTree_OnClick(Sender: TTreeView);
begin
    if Sender.Selected <> nil then
    begin
        TTreeView(Sender.Owner.Find('listTree')).Items.BeginUpdate;
        TTreeView(Sender.Owner.Find('listTree')).Items.Clear;
        TTreeView(Sender.Owner.Find('listTree')).Items.EndUpdate;

        if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list') then
            muteList.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list');

        if Sender.Selected.ImageIndex = 2 then
        begin
            _populateHomeTimeline(_getSelectedUser);
            populateHomeTimeline(TTreeView(Sender.Owner.Find('listTree')));
        end;
        if Sender.Selected.ImageIndex = 3 then
        begin
            _populateUserTimeline(_getSelectedUser);
            populateUserTimeline(TTreeView(Sender.Owner.Find('listTree')));
        end;
        if Sender.Selected.ImageIndex = 4 then
        begin
            _populateMentionsTimeline(_getSelectedUser);
            populateMentionsTimeline(TTreeView(Sender.Owner.Find('listTree')));
        end;
        if Sender.Selected.ImageIndex = 9 then
        begin
            //we don't need to lock anymore
            //only the last 200 of user times line is compared
            //if not _isTop10Pulled(_getSelectedUser) then

            _PopulateTop10Timeline(_getSelectedUser);
            PopulateTop10Timeline(TTreeView(Sender.Owner.Find('listTree')));
        end;
        if Sender.Selected.ImageIndex = 6 then
        begin
            _populateUserQueryTimeline(_getSelectedUser);
            populateUserTimeline(TTreeView(Sender.Owner.Find('listTree')));
        end;
        if Sender.Selected.ImageIndex = 5 then
        begin
            _populateQuery(_getSelectedUser);
            populateSearchTimeline(TTreeView(Sender.Owner.Find('listTree')));
        end;
    end;

    try TTreeView(Sender.Owner.Find('listTree')).SetFocus; except end;
end;

procedure populateHomeTimeline(tree: TTreeView);
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

        for i := 0 to tc.TimeLineHome.Count -1 do
        begin
            if Pos(tc.TimeLineHome.Items[i].UserData.UserName, muteList.Text) = 0 then
            begin
                item := tree.Items.Add('ITEM');
                item.Data := tc.TimeLineHome.Items[i];
                if i = (populateLimit -1) then
                    break;
            end;
        end;

        tree.Items.EndUpdate;

        if tree.Items.Count <> 0 then
            tree.Items.Item[0].Selected := true;

        for i := 0 to tc.TimeLineHome.Count -1 do
        begin
            if Pos(tc.TimeLineHome.Items[i].UserData.UserName, muteList.Text) = 0 then
            begin
                if not tc.TimeLineHome.Items[i].TweetIsNew then
                begin
                    try
                        if i < tree.Items.Count then
                            tree.Items.Item[i].Selected := true
                        else
                            tree.Items.Item[tree.Items.Count -1].Selected := true;
                    except end;
                    break;
                end;
            end;
        end;

        try tree.SetFocus; except end;
    end;
end;

procedure PopulateTop10Timeline(tree: TTreeView);
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

        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        for i := 0 to tc.TimeLineTop10.Count -1 do
        begin
            item := tree.Items.Add('ITEM');
            item.Data := tc.TimeLineTop10.Items[i];
            if i = (populateLimit -1) then
                break;      //we populate only the newest 25
        end;

        tree.Items.EndUpdate;

        if tree.Items.Count <> 0 then
            tree.Items.Item[0].Selected := true;

        for i := 0 to tc.TimeLineTop10.Count -1 do
        begin
            if not tc.TimeLineTop10.Items[i].TweetIsNew then
            begin
                if i < tree.Items.Count then
                    tree.Items.Item[i].Selected := true
                else
                    tree.Items.Item[tree.Items.Count -1].Selected := true;
                break;
            end;
        end;

        try tree.SetFocus; except end;
    end;
end;

procedure populateUserTimeline(tree: TTreeView);
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

        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        for i := 0 to tc.TimeLineUser.Count -1 do
        begin
            item := tree.Items.Add('ITEM');
            item.Data := tc.TimeLineUser.Items[i];
            if i = (populateLimit -1) then
                break;      //we populate only the newest 25
        end;

        tree.Items.EndUpdate;

        if tree.Items.Count <> 0 then
            tree.Items.Item[0].Selected := true;

        for i := 0 to tc.TimeLineUser.Count -1 do
        begin
            if not tc.TimeLineUser.Items[i].TweetIsNew then
            begin
                if i < tree.Items.Count then
                    tree.Items.Item[i].Selected := true
                else
                    tree.Items.Item[tree.Items.Count -1].Selected := true;
                break;
            end;
        end;

        try tree.SetFocus; except end;
    end;
end;

procedure populateMentionsTimeline(tree: TTreeView);
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

        for i := 0 to tc.TimeLineMentions.Count -1 do
        begin
            item := tree.Items.Add('ITEM');
            item.Data := tc.TimeLineMentions.Items[i];
            if i = (populateLimit -1) then
                break;      //we populate only the newest 25
        end;

        tree.Items.EndUpdate;

        if tree.Items.Count <> 0 then
            tree.Items.Item[0].Selected := true;

        for i := 0 to tc.TimeLineMentions.Count -1 do
        begin
            if not tc.TimeLineMentions.Items[i].TweetIsNew then
            begin
                if i < tree.Items.Count then
                    tree.Items.Item[i].Selected := true
                else
                    tree.Items.Item[tree.Items.Count -1].Selected := true;
                break;
            end;
        end;

        try tree.SetFocus; except end;
    end;
end;

procedure populateSearchTimeline(tree: TTreeView);
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

        for i := 0 to tc.SearchResult.Count -1 do
        begin
            if Pos(tc.TimeLineHome.Items[i].UserData.UserID, muteList.Text) = 0 then
            begin
                item := tree.Items.Add('ITEM');
                item.Data := tc.SearchResult.Items[i];
                if i = (populateLimit -1) then
                    break;      //we populate only the newest 25
            end;
        end;

        tree.Items.EndUpdate;

        if tree.Items.Count <> 0 then
            tree.Items.Item[0].Selected := true;

        for i := 0 to tc.SearchResult.Count -1 do
        begin
            if not tc.SearchResult.Items[i].TweetIsNew then
            begin
                if i < tree.Items.Count then
                    tree.Items.Item[i].Selected := true
                else
                    tree.Items.Item[tree.Items.Count -1].Selected := true;
                break;
            end;
        end;

        try tree.SetFocus; except end;
    end;
end;

procedure timelines_listTree_OnCustomDrawItem(Sender: TTreeView; Node: TTreeNode; DrawInfo: TCustomDrawInfo; var DefaultDraw: bool);
var
    tw, th: int;
    pic: TPicture;
    homedir: string;
    bgColor: int;
begin
    //we use the treeview to as a draw list
    if Node.Data <> nil then
    begin
        try
            homedir := root+'accounts'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep;
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

            if TTwitterTweetData(Node.Data).TweetIsNew then
            Sender.Canvas.Font.Color := Sender.Font.Color
            else
            Sender.Canvas.Font.Color := clGray;

            Sender.Canvas.Font.Style := fsBold;
            tw := Sender.Canvas.textWidth(TTwitterTweetData(Node.Data).UserData.UserDisplayName);
            th := Sender.Canvas.textHeight(TTwitterTweetData(Node.Data).UserData.UserDisplayName);
            Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 10, Node.DisplayRectTop(false) + 10,
                                    TTwitterTweetData(Node.Data).UserData.UserDisplayName);
            Sender.Canvas.Font.Style := 0;
            if OSX then
            Sender.Canvas.Font.Size := 12
            else
            Sender.Canvas.Font.Size := 8;
            Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + tw + 20, Node.DisplayRectTop(false) + 10,
                                    '- @'+TTwitterTweetData(Node.Data).UserData.UserName);
            tw := tw + Sender.Canvas.textWidth('- @'+TTwitterTweetData(Node.Data).UserData.UserName);
            Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + tw + 20, Node.DisplayRectTop(false) + 10,
                                    ' - '+copy(TTwitterTweetData(Node.Data).TweetCreateDate, 0, Pos('+', TTwitterTweetData(Node.Data).TweetCreateDate) -1));
            Sender.Canvas.Font.Size := Sender.Font.Size;

            if Trim(TTwitterTweetData(Node.Data).TweetMediaUrl) <> '' then
            Sender.Canvas.TextRect(Node.DisplayRectLeft(false) + 10,
                                   Node.DisplayRectTop(false) + th +10,
                                   Node.DisplayRectRight(false) - 170,
                                   Node.DisplayRectBottom(false) - 35,
                                   5, 5,
                                   TTwitterTweetData(Node.Data).TweetText, true, false)
            else
            Sender.Canvas.TextRect(Node.DisplayRectLeft(false) + 10,
                                   Node.DisplayRectTop(false) + th +10,
                                   Node.DisplayRectRight(false) - 10,
                                   Node.DisplayRectBottom(false) - 35,
                                   5, 5,
                                   TTwitterTweetData(Node.Data).TweetText, true, false);

            Sender.Canvas.Font.Color := clGreen;
            Sender.Canvas.Font.Style := fsBold;
            tw := Sender.Canvas.textWidth(IntToStr(TTwitterTweetData(Node.Data).RetweetCount));
            th := Sender.Canvas.textHeight(IntToStr(TTwitterTweetData(Node.Data).RetweetCount));

            Sender.Canvas.drawImage(rtBmp, Node.DisplayRectLeft(false) + 8,
                                         Node.DisplayRectBottom(false) - th - 16);
            Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 28,
                                  Node.DisplayRectBottom(false) - th - 16,
                                  IntToStr(TTwitterTweetData(Node.Data).RetweetCount));

            Sender.Canvas.drawImage(hartBmp, Node.DisplayRectLeft(false) + 28 + tw + 8,
                                         Node.DisplayRectBottom(false) - th - 16);
            Sender.Canvas.Font.Color := clRed;
            Sender.Canvas.Font.Style := fsBold;
            Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 28 + tw + 28,
                                  Node.DisplayRectBottom(false) - th - 16,
                                  IntToStr(TTwitterTweetData(Node.Data).FavoriteCount));

            Sender.Canvas.Font.Style := 0;
            Sender.Canvas.Font.Color := Sender.Font.Color;

            if FileExists(homedir+TTwitterTweetData(Node.Data).TweetID+'.jpg') then
            begin
                pic := TPicture.Create;
                try
                    pic.LoadFromFile(homedir+TTwitterTweetData(Node.Data).TweetID+'.jpg');
                    Sender.Canvas.drawImageStretch(pic.Graphic,
                                                   Node.DisplayRectRight(false) - 160,
                                                   Node.DisplayRectTop(false) +th +10,
                                                   Node.DisplayRectRight(false) -10,
                                                   Node.DisplayRectBottom(false) - 50);
                except
                    //file is corrupt delete it
                    DeleteFile(homedir+TTwitterTweetData(Node.Data).TweetID+'.jpg');
                end;
                pic.free;
            end;
            if FileExists(homedir+TTwitterTweetData(Node.Data).TweetID+'.jpeg') then
            begin
                pic := TPicture.Create;
                try
                    pic.LoadFromFile(homedir+TTwitterTweetData(Node.Data).TweetID+'.jpeg');
                    Sender.Canvas.drawImageStretch(pic.Graphic,
                                                   Node.DisplayRectRight(false) - 160,
                                                   Node.DisplayRectTop(false) +th +10,
                                                   Node.DisplayRectRight(false) -10,
                                                   Node.DisplayRectBottom(false) - 50);
                except
                    //file is corrupt delete it
                    DeleteFile(homedir+TTwitterTweetData(Node.Data).TweetID+'.jpeg');
                end;
                pic.free;
            end;
            if FileExists(homedir+TTwitterTweetData(Node.Data).TweetID+'.png') then
            begin
                pic := TPicture.Create;
                try
                    pic.LoadFromFile(homedir+TTwitterTweetData(Node.Data).TweetID+'.png');
                    Sender.Canvas.drawImageStretch(pic.Graphic,
                                                   Node.DisplayRectRight(false) - 160,
                                                   Node.DisplayRectTop(false) +th +10,
                                                   Node.DisplayRectRight(false) -10,
                                                   Node.DisplayRectBottom(false) - 50);
                except
                    //file is corrupt delete it
                    DeleteFile(homedir+TTwitterTweetData(Node.Data).TweetID+'.png');
                end;
                pic.free;
            end;

            Sender.Canvas.drawImageStretch(tweetShadow,
                                           Node.DisplayRectLeft(false),
                                           Node.DisplayRectBottom(false) -10,
                                           Node.DisplayRectRight(false),
                                           Node.DisplayRectBottom(false));
        except end;
    end;

    DefaultDraw := false;
end;

procedure timelines_actPopulateHome_OnExecute(Sender: TSimpleAction);
begin
    TimeLineTree.Items[1].Selected := true;
    timelines_navTree_OnClick(TimeLineTree);
end;

procedure timelines_actPopulateUser_OnExecute(Sender: TSimpleAction);
begin
    TimeLineTree.Items[2].Selected := true;
    timelines_navTree_OnClick(TimeLineTree);
end;

procedure timelines_actPopulateMentions_OnExecute(Sender: TSimpleAction);
begin
    TimeLineTree.Items[3].Selected := true;
    timelines_navTree_OnClick(TimeLineTree);
end;

procedure timelines_actPopulateSearch_OnExecute(Sender: TSimpleAction);
begin
    //populateSearchTimeLine(_getSelectedUser);
end;

procedure timelines_UrlLink1_OnClick(Sender: TUrlLink);
begin
    TimeLineTree.Items[1].Selected := true;
    timelines_navTree_OnClick(TimeLineTree);
end;

procedure timelines_UrlLink2_OnClick(Sender: TUrlLink);
begin
    TimeLineTree.Items[2].Selected := true;
    timelines_navTree_OnClick(TimeLineTree);
end;

procedure timelines_UrlLink3_OnClick(Sender: TUrlLink);
begin
    TimeLineTree.Items[3].Selected := true;
    timelines_navTree_OnClick(TimeLineTree);
end;

procedure timelines_actPopulateTop10_OnExecute(Sender: TSimpleAction);
begin
    TimeLineTree.Items[4].Selected := true;
    timelines_navTree_OnClick(TimeLineTree);
end;

procedure timelines_listTree_OnMouseWheel(Sender: TTreeView; keyInfo: TKeyInfo; WheelDelta: int; X: int; Y: int; var Handled: bool);
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

procedure timelines_listTree_OnSelectionChanged(Sender: TTreeView);
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

procedure timelines_listTree_OnClick(Sender: TTreeView);
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

procedure timelines_bMenu_OnClick(Sender: TBGRAButton);
begin
    TPopupMenu(Sender.Owner.Find('PopupMenu1')).PopUp;
end;

procedure timelines_OnResize(Sender: TFrame);
begin
    TimeLineList.Repaint;
end;

procedure timelines_menuLinkClick(Sender: TMenuItem);
begin
    ShellOpen(Sender.Hint);
end;

procedure timelines_PopupMenu1_OnPopup(Sender: TPopupMenu);
var
    td: TTwitterTweetData;
    tmp: string = '';
    link: string = '';
    i: int;
    menu: TMenuItem;
begin
    if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'fav.list') then
        favList.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'fav.list');

    if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list') then
        muteList.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list');

    if TimeLineList.Selected <> nil then
    begin
        TMenuItem(Sender.Owner.Find('mOpenLink')).Clear;

        td := TTwitterTweetData(TimeLineList.Selected.Data);

        if Pos('http', Lower(td.TweetText)) > 0 then
        begin
            tmp := td.TweetText;
            while (Pos('http', Lower(tmp)) > 0) do
            begin
                tmp := copy(tmp, Pos('http', Lower(tmp)), 1000);
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
                if trim(link) <> '' then
                begin
                    link := ReplaceAll(link, ',', '');
                    menu := TMenuItem.Create(Sender.Owner);
                    menu.Caption := link;
                    menu.Hint := link;
                    menu.OnClick := @timelines_menuLinkClick;
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

        if (Trim(td.TweetMediaUrl) <> '') and
           ((Pos('.jpg', Lower(td.TweetMediaUrl)) > 0) or
            (Pos('.jpeg', Lower(td.TweetMediaUrl)) > 0) or
            (Pos('.png', Lower(td.TweetMediaUrl)) > 0)) then
        TMenuItem(Sender.Owner.Find('mViewImage')).Visible := true
        else
        TMenuItem(Sender.Owner.Find('mViewImage')).Visible := false;

        TMenuItem(Sender.Owner.Find('MenuItem2')).Visible :=
            TMenuItem(Sender.Owner.Find('mOpenLink')).Visible;

        if favList.IndexOf(td.TweetID) <> -1 then
        TMenuItem(Sender.Owner.Find('mLike')).Caption := 'Unlike'
        else
        TMenuItem(Sender.Owner.Find('mLike')).Caption := 'Like';

        if favList.IndexOf('RT'+td.TweetID) <> -1 then
        TMenuItem(Sender.Owner.Find('mRetweet')).Caption := 'UnRe-Tweet'
        else
        TMenuItem(Sender.Owner.Find('mRetweet')).Caption := 'Re-Tweet';

        TMenuItem(Sender.Owner.Find('mDeleteTweet')).Enabled :=
            (_getSelectedUser = '@'+td.UserData.UserName);

        TMenuItem(Sender.Owner.Find('mLike')).Enabled :=
            (_getSelectedUser <> '@'+td.UserData.UserName);
        TMenuItem(Sender.Owner.Find('mRetweet')).Enabled :=
            (_getSelectedUser <> '@'+td.UserData.UserName);
        TMenuItem(Sender.Owner.Find('mReplyToTweet')).Enabled :=
            (_getSelectedUser <> '@'+td.UserData.UserName);
        TMenuItem(Sender.Owner.Find('mMuteUser')).Enabled :=
            (_getSelectedUser <> '@'+td.UserData.UserName);

        TMenuItem(Sender.Owner.Find('mFollowUser')).Enabled :=
            (_getSelectedUser <> '@'+td.UserData.UserName);
        if Pos('        '+td.UserData.UserID, FollowingIDS.Text) > 0 then
        TMenuItem(Sender.Owner.Find('mFollowUser')).Caption := 'Unfollow User'
        else
        TMenuItem(Sender.Owner.Find('mFollowUser')).Caption := 'Follow User';

        TMenuItem(Sender.Owner.Find('mSendDirectMessage')).Enabled :=
            (TMenuItem(Sender.Owner.Find('mFollowUser')).Caption = 'Unfollow User');

        TMenuItem(Sender.Owner.Find('mSendDirectMessage')).Enabled :=
            (_getSelectedUser <> '@'+td.UserData.UserName);


        //we need to think about this???
        {if TimeLineTree.Selected.ImageIndex = 3 then
        begin
            TMenuItem(Sender.Owner.Find('mRetweet')).Caption := 'UnRe-Tweet';
            TMenuItem(Sender.Owner.Find('mRetweet')).Enabled := true;
        end;}
    end;
end;

procedure populateTimelineQueries();
var
    i: int;
    str: TStringList;
    queryFile: string;
    rnode, cnode: TTreeNode;
begin
    for i := TimeLineTree.Items.Count -1 downto 0 do
    begin
        if TimeLineTree.Items.Item[i].ImageIndex in [5,6] then
            TimeLineTree.Items.Item[i].Delete;
    end;

    for i := TimeLineTree.Items.Count -1 downto 0 do
    begin
        if (Pos('Queries', TimeLineTree.Items.Item[i].Text) > 0) and
           (TimeLineTree.Items.Item[i].imageIndex in [0,1]) then
        begin
            rnode := TimeLineTree.Items.Item[i];
            break;
        end;
    end;

    queryFile := root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'queries.timeline';

    str := TStringList.Create;
    if FileExists(queryFile) then
        str.LoadFromFile(queryFile);

    str.Sort;

    for i := 0 to str.Count -1 do
    begin
        cnode := TimeLineTree.Items.AddChild(rnode, str.ValueByIndex(i));
        if str.Names[i] = 'user' then
        cnode.ImageIndex := 6
        else
        cnode.ImageIndex := 5;
        cnode.SelectedIndex := cnode.ImageIndex;
    end;
    str.free;

    rnode.Expand(false);
end;

procedure timelines_bAdd_OnClick(Sender: TComponent);
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    if addQueryCreate(MainForm).ShowModalDimmed = mrOK then
    begin
        TimeLineTree.Items.Item[0].Selected := true;
        populateTimelineQueries;
    end;
end;

procedure timelines_actPopulateQueries_OnExecute(Sender: TSimpleAction);
begin
    populateTimelineQueries;
end;

procedure timelines_navTree_OnCustomDrawItem(Sender: TTreeView; Node: TTreeNode; DrawInfo: TCustomDrawInfo; var DefaultDraw: bool);
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

procedure timelines_bRemove_OnClick(Sender: TBGRAButton);
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    delQueryCreate(MainForm).ShowModalDimmed;
    populateTimelineQueries;
end;

procedure timelines_UrlLink4_OnClick(Sender: TUrlLink);
begin
    timelines_bAdd_OnClick(Sender);
end;

procedure timelines_UrlLink5_OnClick(Sender: TUrlLink);
begin
    TimeLineTree.Items[4].Selected := true;
    timelines_navTree_OnClick(TimeLineTree);
end;

procedure timelines_mLike_OnClick(Sender: TMenuItem);
var
    td: TTwitterTweetData;
    tc: TTwitter;
begin
    tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
    td := TTwitterTweetData(TimeLineList.Selected.Data);

    if Sender.Caption = 'Like' then
    begin
        try
            tc.likeTweet(td.TweetID);
            if favList.IndexOf(td.TweetID) = -1 then
                favList.Add(td.TweetID);
        except end;
    end
        else
    begin
        try
            tc.unlikeTweet(td.TweetID);
            if favList.IndexOf(td.TweetID) <> -1 then
                favList.Delete(favList.IndexOf(td.TweetID));
        except end;
    end;

    TimeLineList.Repaint;
    favList.SaveToFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'fav.list');
end;

procedure timelines_mRetweet_OnClick(Sender: TMenuItem);
var
    td: TTwitterTweetData;
    tc: TTwitter;
begin
    tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
    td := TTwitterTweetData(TimeLineList.Selected.Data);

    if Sender.Caption = 'Re-Tweet' then
    begin
        try
            tc.reTweet(td.TweetID);
            if favList.IndexOf('RT'+td.TweetID) = -1 then
                favList.Add('RT'+td.TweetID);
        except end;
    end
        else
    begin
        try
            tc.unreTweet(td.TweetID);
            if favList.IndexOf('RT'+td.TweetID) <> -1 then
                favList.Delete(favList.IndexOf('RT'+td.TweetID));
        except end;
    end;

    TimeLineList.Repaint;
    favList.SaveToFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'fav.list');
end;

procedure timelines_mReplytoTweet_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterTweetData;
begin
    td := TTwitterTweetData(TimeLineList.Selected.Data);

    f := replyCreate(MainForm);
    f.Hint := td.TweetID;
    TMemo(f.Find('Memo1')).Lines.Text := '@'+td.UserData.UserName;
    f.ShowModalDimmed;
end;

procedure timelines_mSendDirectMessage_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterTweetData;
begin
    td := TTwitterTweetData(TimeLineList.Selected.Data);

    f := messageCreate(MainForm);
    TEdit(f.Find('Edit1')).Text := '@'+td.UserData.UserName;
    f.ShowModalDimmed;
end;

procedure timelines_mDeleteTweet_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterTweetData;
    tc: TTwitter;
begin
    td := TTwitterTweetData(TimeLineList.Selected.Data);
    tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

    if MsgWarning('Warning', 'You are about to Delete / UnRe-Tweet a Tweet, continue?') then
    begin
        try
            tc.unreTweet(td.TweetID);
            if favList.IndexOf('RT'+td.TweetID) <> -1 then
                favList.Delete(favList.IndexOf('RT'+td.TweetID));
            TimeLineList.Selected.Delete;
        except end;

        try
            tc.deleteTweet(td.TweetID);
            if favList.IndexOf('RT'+td.TweetID) <> -1 then
                favList.Delete(favList.IndexOf('RT'+td.TweetID));
            TimeLineList.Selected.Delete;
        except end;

        TimeLineList.Repaint;
        favList.SaveToFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'fav.list');
    end;
end;

procedure timelines_mLikeFromAccounts_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterTweetData;
begin
    td := TTwitterTweetData(TimeLineList.Selected.Data);

    f := fromaccountsCreate(MainForm);
    f.Caption := 'Like from Accounts';
    f.Hint := td.TweetID;
    TLabel(f.Find('Label1')).Caption := f.Caption;
    TButton(f.Find('Button2')).Caption := 'Like';
    f.ShowModalDimmed;
end;

procedure timelines_mRetweetFromAccounts_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterTweetData;
begin
    td := TTwitterTweetData(TimeLineList.Selected.Data);

    f := fromaccountsCreate(MainForm);
    f.Caption := 'Re-Tweet from Accounts';
    f.Hint := td.TweetID;
    TLabel(f.Find('Label1')).Caption := f.Caption;
    TButton(f.Find('Button2')).Caption := 'Re-Tweet';
    f.ShowModalDimmed;
end;

procedure timelines_mFollowFromAccounts_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterTweetData;
begin
    td := TTwitterTweetData(TimeLineList.Selected.Data);

    f := fromaccountsCreate(MainForm);
    f.Caption := 'Follow from Accounts';
    f.Hint := td.UserData.UserName;
    TLabel(f.Find('Label1')).Caption := f.Caption;
    TButton(f.Find('Button2')).Caption := 'Follow';
    f.ShowModalDimmed;
end;

procedure timelines_mViewTweet_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterTweetData;
    homedir: string;
begin
    homedir := root+'accounts'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep;
    td := TTwitterTweetData(TimeLineList.Selected.Data);

    f := viewtweetCreate(MainForm);
    TMemo(f.Find('Memo1')).Lines.Text := td.TweetText;
    if td.TweetMediaUrl <> '' then
    begin
        if FileExists(homedir+td.TweetID+'.jpg') then
        TImage(f.Find('Image1')).Picture.LoadFromFile(homedir+td.TweetID+'.jpg');
        if FileExists(homedir+td.TweetID+'.jpeg') then
        TImage(f.Find('Image1')).Picture.LoadFromFile(homedir+td.TweetID+'.jpeg');
        if FileExists(homedir+td.TweetID+'.png') then
        TImage(f.Find('Image1')).Picture.LoadFromFile(homedir+td.TweetID+'.png');
    end;
    f.ShowModalDimmed;
end;

procedure timelines_mViewImage_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterTweetData;
    homedir: string;
begin
    homedir := root+'accounts'+DirSep+copy(_getSelectedUser, 2, 100)+DirSep;
    td := TTwitterTweetData(TimeLineList.Selected.Data);

    f := viewimageCreate(MainForm);
    if td.TweetMediaUrl <> '' then
    begin
        if FileExists(homedir+td.TweetID+'.jpg') then
        begin
            TImage(f.Find('Image1')).Picture.LoadFromFile(homedir+td.TweetID+'.jpg');
            TImage(f.Find('Image1')).Hint := '.jpg';
        end;
        if FileExists(homedir+td.TweetID+'.jpeg') then
        begin
            TImage(f.Find('Image1')).Picture.LoadFromFile(homedir+td.TweetID+'.jpeg');
            TImage(f.Find('Image1')).Hint := '.jpeg';
        end;
        if FileExists(homedir+td.TweetID+'.png') then
        begin
            TImage(f.Find('Image1')).Picture.LoadFromFile(homedir+td.TweetID+'.png');
            TImage(f.Find('Image1')).Hint := '.png';
        end;
    end;
    f.ShowModalDimmed;
end;

procedure timelines_mViewUser_OnClick(Sender: TMenuItem);
var
    f: TForm;
    td: TTwitterTweetData;
    http: THttp;
    fs: TFileStream;
    imgFile: string;
begin
    td := TTwitterTweetData(TimeLineList.Selected.Data);

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

procedure timelines_mFollowUser_OnClick(Sender: TMenuItem);
var
    td: TTwitterTweetData;
    tc: TTwitter;
begin
    td := TTwitterTweetData(TimelineList.Selected.Data);
    tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);

    if Sender.Caption = 'Unfollow User' then
    begin
        try
            tc.unfollowUser(td.UserData.UserName);
            FollowingIDS.Text := ReplaceOnce(FollowingIDS.Text, '        '+td.UserData.UserID, '');
        except end;
    end
        else
    begin
        try
            tc.followUser(td.UserData.UserName);
            FollowingIDS.Add('        '+td.UserData.UserID);
        except end;
    end;
end;

procedure timelines_mMuteUser_OnClick(Sender: TMenuItem);
var
    td: TTwitterTweetData;
begin
    if MsgWarning('Warning', 'You are about to mute all Tweets and Messages of a user, continue?') then
    begin
        td := TTwitterTweetData(TimelineList.Selected.Data);

        if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list') then
            muteList.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list');

        if muteList.indexOf(td.UserData.UserName) = -1 then
            muteList.Add(td.UserData.UserName);

        muteList.SaveToFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mute.list');
    end;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//timelines initialization constructor
constructor
begin 
end.
