////////////////////////////////////////////////////////////////////////////////
// Unit Description  : mainform Description
// Unit Author       : LA.Center Corporation
// Date Created      : April, Sunday 24, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals', 'user', 'account', 'rndstats', 'timelines', 'ques', 'growth',
    'reports', 'counter', 'message', 'accountman', 'mutelist', 'settings', 'about';

//constructor of mainform
function mainformCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @mainform_OnCreate, 'mainform');
end;

//OnCreate Event of mainform
procedure mainform_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    MainForm := Sender;
    Sender.Caption := appPreName+' '+appVersion+' - '+appSurName;
    _setFonts(Sender);

    leftScroller := TScrollBox(Sender.Find('scroller1'));
    leftScroller.ChildSizing.LeftRightSpacing := 8;
    leftScroller.ChildSizing.TopBottomSpacing := 10;
    leftScroller.ChildSizing.HorizontalSpacing := 10;
    leftScroller.ChildSizing.VerticalSpacing := 10;
    leftScroller.ChildSizing.Layout := cclLeftToRightThenTopToBottom;
    leftScroller.ChildSizing.ControlsPerLine := 1;
    leftScroller.HorzScrollBar.Tracking := true;
    leftScroller.HorzScrollBar.Smooth := true;
    leftScroller.HorzScrollBar.Visible := false;
    leftScroller.VertScrollBar.Tracking := true;
    leftScroller.VertScrollBar.Smooth := true;

    TLabel(Sender.Find('status')).Font.Color := clWhite;
    TLabel(Sender.Find('status')).Font.Style := fsBold;

    TPanel(Sender.Find('clientPanel')).BorderSpacing.Right := 8;
    TPanel(Sender.Find('clientPanel')).BorderSpacing.Bottom := 8;

    Pages := TATTabs(Sender.Find('Pages'));
    Pages.Height := 36;
    Pages.ColorBG := clWhite;
    Pages.ColorTabActive := clWhite;
    Pages.ColorTabPassive := HexToColor('#f0f0f0');
    Pages.ColorTabOver := clWhite;
    Pages.ColorBorderActive := clSilver;
    Pages.ColorBorderPassive := clSilver;
    Pages.Font.Color := $00444444;
    Pages.TabShowPlus := false;
    Pages.TabAngle := 5;

    _setButton(TBGRAButton(Sender.find('bPromote')), false, false);
    _setButton(TBGRAButton(Sender.find('bSendDM')), false, false);
    _setButton(TBGRAButton(Sender.find('bMenu')), false, false);
    _setButton(TBGRAButton(Sender.find('bTweet')), false, false);
    _setButton(TBGRAButton(Sender.find('bAddAccount')), false, false);
    _setButton(TBGRAButton(Sender.find('bExit')), false, false);

    TShape(Sender.Find('leftBorder')).Pen.Color := clSilver;
    TShape(Sender.Find('rightBorder')).Pen.Color := clSilver;
    TShape(Sender.Find('bottomBorder')).Pen.Color := clSilver;

    counter := counterCreate(Sender);
    counter.Parent := TPanel(Sender.Find('dash'));
    counter.Align := alClient;
    counter.BorderSpacing.Left := 2;
    counter.BorderSpacing.Right := 2;
    counter.BorderSpacing.Top := 4;
    counter.BorderSpacing.Bottom := 4;
    counter.Visible := true;

    dashScroller := TScrollBox(counter.Find('scroller'));
    dashScroller.ChildSizing.LeftRightSpacing := 5;
    dashScroller.ChildSizing.TopBottomSpacing := 5;
    dashScroller.ChildSizing.HorizontalSpacing := 5;
    dashScroller.ChildSizing.VerticalSpacing := 5;
    dashScroller.ChildSizing.Layout := cclLeftToRightThenTopToBottom;
    dashScroller.ChildSizing.ControlsPerLine := 3;
    dashScroller.HorzScrollBar.Tracking := true;
    dashScroller.HorzScrollBar.Smooth := true;
    dashScroller.HorzScrollBar.Visible := false;
    dashScroller.VertScrollBar.Tracking := true;
    dashScroller.VertScrollBar.Smooth := true;

    timeline := timelinesCreate(Sender);
    timeline.Parent := TPanel(Sender.Find('dash'));
    timeline.Align := alClient;
    timeline.BorderSpacing.Left := 2;
    timeline.BorderSpacing.Right := 2;
    timeline.BorderSpacing.Top := 4;
    timeline.BorderSpacing.Bottom := 4;
    timeline.Visible := false;

    growth := growthCreate(Sender);
    growth.Parent := TPanel(Sender.Find('dash'));
    growth.Align := alClient;
    growth.BorderSpacing.Left := 2;
    growth.BorderSpacing.Right := 2;
    growth.BorderSpacing.Top := 4;
    growth.BorderSpacing.Bottom := 4;
    growth.Visible := false;

    que := quesCreate(Sender);
    que.Parent := TPanel(Sender.Find('dash'));
    que.Align := alClient;
    que.BorderSpacing.Left := 2;
    que.BorderSpacing.Right := 2;
    que.BorderSpacing.Top := 4;
    que.BorderSpacing.Bottom := 4;
    que.Visible := false;

    report := reportsCreate(Sender);
    report.Parent := TPanel(Sender.Find('dash'));
    report.Align := alClient;
    report.BorderSpacing.Left := 2;
    report.BorderSpacing.Right := 2;
    report.BorderSpacing.Top := 4;
    report.BorderSpacing.Bottom := 4;
    report.Visible := false;

    Pages.AddTab(0, 'Counters', counter, -1);
    Pages.AddTab(1, 'Timelines', timeline, -1);
    Pages.AddTab(2, 'Network', growth, -1);
    Pages.AddTab(3, 'Queues', que, -1);
    Pages.AddTab(4, 'Clicks', report, -1);

    counter.BringToFront;


    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TMenuItem(Sender.find('mPlan')).OnClick := @mainform_mPlan_OnClick;
    TMenuItem(Sender.find('mStartLocalTweetGate')).OnClick := @mainform_mStartLocalTweetGate_OnClick;
    TMenuItem(Sender.find('mAbout')).OnClick := @mainform_mAbout_OnClick;
    TMenuItem(Sender.find('mSettings')).OnClick := @mainform_mSettings_OnClick;
    TMenuItem(Sender.find('mExit')).OnClick := @mainform_mExit_OnClick;
    TMenuItem(Sender.find('mMutedUsers')).OnClick := @mainform_mMutedUsers_OnClick;
    TMenuItem(Sender.find('mAccounts')).OnClick := @mainform_mAccounts_OnClick;
    TMenuItem(Sender.find('mAddTwitterAccount')).OnClick := @mainform_mAddTwitterAccount_OnClick;
    TMenuItem(Sender.find('mHelp')).OnClick := @mainform_mHelp_OnClick;
    TMenuItem(Sender.find('mFraun')).OnClick := @mainform_mFraun_OnClick;
    TMenuItem(Sender.find('mSmile')).OnClick := @mainform_mSmile_OnClick;
    TMenuItem(Sender.find('mFeature')).OnClick := @mainform_mFeature_OnClick;
    TMenuItem(Sender.find('mPro')).OnClick := @mainform_mPro_OnClick;
    TMenuItem(Sender.find('mCool')).OnClick := @mainform_mCool_OnClick;
    TMenuItem(Sender.find('mILike')).OnClick := @mainform_mILike_OnClick;
    TMenuItem(Sender.find('mILove')).OnClick := @mainform_mILove_OnClick;
    TMenuItem(Sender.find('mFollowLACenterSupport')).OnClick := @mainform_mFollowLACenterSupport_OnClick;
    TMenuItem(Sender.find('mFollowLACenter')).OnClick := @mainform_mFollowLACenter_OnClick;
    TBGRAButton(Sender.find('bPromote')).OnClick := @mainform_bPromote_OnClick;
    TBGRAButton(Sender.find('bMenu')).OnButtonClick := @mainform_bMenu_OnButtonClick;
    TBGRAButton(Sender.find('bSendDM')).OnClick := @mainform_bSendDM_OnClick;
    TSimpleAction(Sender.find('populateCounters')).OnExecute := @mainform_populateCounters_OnExecute;
    TATTabs(Sender.find('Pages')).OnTabClick := @mainform_Pages_OnTabClick;
    TBGRAButton(Sender.find('bTweet')).OnClick := @mainform_bTweet_OnClick;
    TTimer(Sender.find('busyTimer')).OnTimer := @mainform_busyTimer_OnTimer;
    TSimpleAction(Sender.find('actPopulateAccounts')).OnExecute := @mainform_actPopulateAccounts_OnExecute;
    TBGRAButton(Sender.find('bAddAccount')).OnClick := @mainform_bAddAccount_OnClick;
    TBGRAButton(Sender.find('bExit')).OnClick := @mainform_bExit_OnClick;
    TBGRAButton(Sender.find('bMenu')).OnClick := @mainform_bMenu_OnClick;
    Sender.OnResize := @mainform_OnResize;
    Sender.OnShow := @mainform_OnShow;
    Sender.OnWindowStateChange := @mainform_OnWindowStateChange;
    //</events-bind>

    //Set as Application.MainForm
    Sender.setAsMainForm;
end;

procedure mainform_bMenu_OnClick(Sender: TComponent);
begin
    accountmanCreate(MainForm).ShowModalDimmed;
end;

procedure mainform_OnResize(Sender: TForm);
begin
    dashScroller.ChildSizing.ControlsPerLine := dashScroller.Width div 265;

    TControl(Sender.Find('bAddAccount')).Left :=
        (Sender.Width - TControl(Sender.Find('bAddAccount')).Width) div 2;
    TControl(Sender.Find('bExit')).Left :=
        (Sender.Width - TControl(Sender.Find('bExit')).Width) div 2;
    TControl(Sender.Find('logo')).Left :=
        (Sender.Width - TControl(Sender.Find('logo')).Width) div 2;
end;

procedure mainform_bExit_OnClick(Sender: TBGRAButton);
begin
    TForm(Sender.Owner).Close;
end;

procedure mainform_OnShow(Sender: TForm);
begin
    actXML.Close;
    actXML.LoadFromXMLFile(actXML.FileName);
    actXML.Open;
    if actXML.RecordCount = 0 then
    begin
        TPanel(Sender.Find('startPanel')).Visible := true;
        TPanel(Sender.Find('startPanel')).BringToFront;
        mainform_OnResize(Sender);
    end
        else
        populateAccounts;
    actXML.Close;
end;

procedure mainform_bAddAccount_OnClick(Sender: TBGRAButton);
var
    f: TForm;
begin
    f := accountCreate(Sender.Owner);
    f.ShowModalDimmed;
end;

procedure populateAccounts();
var
    f: TFrame;
    i: int;
begin
    for i := leftScroller.ComponentCount -1 downto 0 do
        try leftScroller.Components[i].free; except end;

    TPanel(MainForm.Find('startpanel')).SendToBack;
    TPanel(MainForm.Find('startpanel')).Visible := false;

    actXML.Close;
    actXML.LoadFromXMLFile(actXML.FileName);
    actXML.Open;

    while not actXML.Eof do
    begin
        f := userCreate(leftScroller);
        f.Parent := leftScroller;
        f.Constraints.MaxHeight := 69;
        f.Constraints.MinHeight := 69;
        f.Constraints.MaxWidth := 250;
        f.Constraints.MinWidth := 250;
        TLabel(f.Find('lName')).Caption := actXML.Field('displayname').Text;
        TLabel(f.Find('lUser')).Caption := '@'+actXML.Field('username').Text;
        if FileExists(root+'accounts'+DirSep+actXML.Field('username').Text+DirSep+'profile.jpg') then
            TImage(f.Find('img')).Picture.LoadFromFile(root+'accounts'+DirSep+actXML.Field('username').Text+DirSep+'profile.jpg')
        else if FileExists(root+'accounts'+DirSep+actXML.Field('username').Text+DirSep+'profile.jpeg') then
            TImage(f.Find('img')).Picture.LoadFromFile(root+'accounts'+DirSep+actXML.Field('username').Text+DirSep+'profile.jpeg')
        else if FileExists(root+'accounts'+DirSep+actXML.Field('username').Text+DirSep+'profile.gif') then
            TImage(f.Find('img')).Picture.LoadFromFile(root+'accounts'+DirSep+actXML.Field('username').Text+DirSep+'profile.gif')
        else if FileExists(root+'accounts'+DirSep+actXML.Field('username').Text+DirSep+'profile.png') then
            TImage(f.Find('img')).Picture.LoadFromFile(root+'accounts'+DirSep+actXML.Field('username').Text+DirSep+'profile.png');

        if accounts.IndexOf('@'+actXML.Field('username').Text) <> -1 then
            TBGRALed(f.Find('led')).Color := clLime;

        actXML.Next;
    end;

    actXML.Close;
end;

procedure mainform_actPopulateAccounts_OnExecute(Sender: TSimpleAction);
begin
    populateAccounts;
end;

procedure mainform_busyTimer_OnTimer(Sender: TTimer);
var
    progress: TCircleProgress;
begin
    progress := TCircleProgress(Sender.Owner.Find('progress'));
    progress.ColorDoneMax := $00444444;
    progress.StartAngle := progress.StartAngle +10;
    progress.Repaint;
    if progress.StartAngle >= 350 then
    progress.StartAngle := 0;
    Application.ProcessMessages;
end;

procedure mainform_bTweet_OnClick(Sender: TBGRAButton);
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
    f.Caption := 'Tweet Now';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    f.ShowModalDimmed;
end;

procedure mainform_Pages_OnTabClick(Sender: TATTabs);
begin
    counter.Visible := false;
    timeline.Visible := false;
    que.Visible := false;
    growth.Visible := false;
    report.Visible := false;

    case Sender.TabIndex of
        0:  begin
                if TimeLineTree.Selected <> nil then
                begin
                    if TimeLineTree.Selected.ImageIndex in [5,6] then
                        TimeLineTree.Selected.Parent.Selected := true;
                end;
                counter.Visible := true;
                counter.BringToFront;
            end;
        1:  begin
                timeline.Visible := true;
                timeline.BringToFront;
            end;
        2:  begin
                growth.Visible := true;
                growth.BringToFront;
            end;
        3:  begin
                QueTree.Items.Item[0].Selected := true;
                que.Visible := true;
                que.BringToFront;
            end;
        4:  begin
                RepTree.Items.Item[0].Selected := true;
                report.Visible := true;
                report.BringToFront;
            end;
    end;

    if (_getSelectedUser <> '') then
        _DoAfterSelect(_getSelectedUser);
end;

procedure populateCounters(user: string);
var                             //0      //1   //2   //3   //4   //5   //6    //7   //8   //9   //10  //11  //12
    months: array of string = ['dummy', 'Jan','Feb','Mar','Apr','May','Jun', 'Jul','Aug','Sep','Oct','Nov','Dec'];
                              //0   //1   //2   //3   //4  //5   //6
    days: array of string = ['dymmy','Mon','Tue','Wed','Thu','Fri','Sat', 'Sun'];

    i: Integer;
    followers, following, tweets, retweets, likes, listed: integer = 0;
    followers2, following2, tweets2, retweets2, likes2, listed2: integer = 0;
    dateToday, dateYesterday, yesterdayDataFile: string;
    tc: TTwitter;
    str: TStringList;
    percent: double;
    f: TFrame;
    dd, mm, dn: string;
begin
    _setBusy('Updating Counters, please wait...');
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;

    yesterdayDataFile := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+IntToStr(YearOf(Today))+'.counters';

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        for i := dashScroller.ComponentCount -1 downto 0 do
            try dashScroller.Components[i].free; except end;

        //convert system date to twitter format
        dd := days[DayOfTheWeek(today)];
        mm := months[MonthOfTheYear(today)];
        dn := IntToStr(DayOf(today));
        if len(dn) = 1 then dn := '0'+dn;
        dateToday := dd+' '+mm+' '+dn;

        //convert system date to twitter format
        dd := days[DayOfTheWeek(yesterday)];
        mm := months[MonthOfTheYear(yesterday)];
        dn := IntToStr(DayOf(yesterday));
        if len(dn) = 1 then dn := '0'+dn;
        dateYesterday := dd+' '+mm+' '+dn;

        for i := 0 to tc.TimeLineUser.Count -1 do
        begin
            if Pos(dateToday, tc.TimeLineUser.Items[i].TweetCreateDate) > 0 then
                tweets := tweets +1;
            if Pos(dateYesterday, tc.TimeLineUser.Items[i].TweetCreateDate) > 0 then
                tweets2 := tweets2 +1;
            if Pos(dateToday, tc.TimeLineUser.Items[i].TweetCreateDate) > 0 then
                retweets := retweets + tc.TimeLineUser.Items[i].RetweetCount;
            if Pos(dateYesterday, tc.TimeLineUser.Items[i].TweetCreateDate) > 0 then
                retweets2 := retweets2 + tc.TimeLineUser.Items[i].RetweetCount;
            if Pos(dateToday, tc.TimeLineUser.Items[i].TweetCreateDate) > 0 then
                likes := likes + tc.TimeLineUser.Items[i].FavoriteCount;
            if Pos(dateYesterday, tc.TimeLineUser.Items[i].TweetCreateDate) > 0 then
                likes2 := likes2 + tc.TimeLineUser.Items[i].FavoriteCount;
        end;

        for i := 0 to tc.TimeLineUser.Count -1 do
        begin
            if Pos(dateToday, tc.TimeLineUser.Items[i].TweetCreateDate) > 0 then
            begin
                followers := tc.TimeLineUser.Items[i].UserData.UserFollowersCount;
                following := tc.TimeLineUser.Items[i].UserData.UserFollowingCount;
                listed := tc.TimeLineUser.Items[i].UserData.UserListedCount;
                break;
            end;
        end;

        str := TStringList;
        if FileExists(yesterdayDataFile) then
            str.LoadFromFile(yesterdayDataFile);

        followers2 := StrToIntDef(str.Values[dateYesterday+'-followers'], 0);
        following2 := StrToIntDef(str.Values[dateYesterday+'-following'], 0);
        listed2 := StrToIntDef(str.Values[dateYesterday+'-listed'], 0);

        //if yesterday was not found make it stale
        if followers2 = 0 then followers2 := followers;
        if following2 = 0 then following2 := following;
        if listed2 = 0 then listed2 := listed;

        //if today was not found make it stale
        if followers = 0 then followers := followers2;
        if following = 0 then following := following2;
        if listed = 0 then listed := listed2;

        str.Values[dateToday+'-followers'] := IntToStr(followers);
        str.Values[dateToday+'-following'] := IntToStr(following);
        str.Values[dateToday+'-listed'] := IntToStr(listed);
        str.SaveToFile(yesterdayDataFile);
        str.Free;

        if (followers = 0) and
           (followers2 = 0) then
        begin
            //no data was received get the data from the frist found tweet
            if tc.TimeLineUser.Count <> 0 then
            begin
                followers := tc.TimeLineUser.Items[0].UserData.UserFollowersCount;
                following := tc.TimeLineUser.Items[0].UserData.UserFollowingCount;
                listed := tc.TimeLineUser.Items[0].UserData.UserListedCount;
                followers2 := tc.TimeLineUser.Items[0].UserData.UserFollowersCount;
                following2 := tc.TimeLineUser.Items[0].UserData.UserFollowingCount;
                listed2 := tc.TimeLineUser.Items[0].UserData.UserListedCount;
            end;
        end;


        //Followers
        f := rndstatsCreate(dashScroller);
        f.Parent := dashScroller;
        f.Constraints.MaxWidth := 255;
        f.Constraints.MinWidth := 255;
        f.Constraints.MaxHeight := 250;
        f.Constraints.MinHeight := 250;
        TLabel(f.Find('lTitle')).Caption := 'Followers';
        TPanel(f.Find('lcount')).Caption := DoubleFormat('#,##0', followers);

        //stale
        if followers = followers2 then
        begin
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', followers);
            TLabel(f.Find('lPercent')).Caption := '0%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrBlue);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrBlue);
            ResToFile('stale', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TCircleProgress(f.Find('progress')).Position := 0;
        end;

        //gained
        if followers > followers2 then
        begin
            percent := ((followers - followers2) / followers2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrGreen);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrGreen);
            ResToFile('gain', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', followers2)+' +'+DoubleFormat('#,##0', followers - followers2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrGreen);
        end;

        //lost
        if followers2 > followers then
        begin
            percent := ((followers - followers2) / followers2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrRed);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrRed);
            ResToFile('lost', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', followers2)+' '+DoubleFormat('#,##0', followers - followers2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrRed);
        end;



        //Following
        f := rndstatsCreate(dashScroller);
        f.Parent := dashScroller;
        f.Constraints.MaxWidth := 255;
        f.Constraints.MinWidth := 255;
        f.Constraints.MaxHeight := 250;
        f.Constraints.MinHeight := 250;
        TLabel(f.Find('lTitle')).Caption := 'Following';
        TPanel(f.Find('lcount')).Caption := DoubleFormat('#,##0', following);

        //stale
        if following = following2 then
        begin
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', following);
            TLabel(f.Find('lPercent')).Caption := '0%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrBlue);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrBlue);
            ResToFile('stale', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TCircleProgress(f.Find('progress')).Position := 0;
        end;

        //gained
        if following > following2 then
        begin
            percent := ((following - following2) / following2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrGreen);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrGreen);
            ResToFile('gain', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', following2)+' +'+DoubleFormat('#,##0', following - following2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrGreen);
        end;

        //lost
        if following2 > following then
        begin
            percent := ((following - following2) / following2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrRed);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrRed);
            ResToFile('lost', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', following2)+' '+DoubleFormat('#,##0', following - following2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrRed);
        end;



        //Listed
        f := rndstatsCreate(dashScroller);
        f.Parent := dashScroller;
        f.Constraints.MaxWidth := 255;
        f.Constraints.MinWidth := 255;
        f.Constraints.MaxHeight := 250;
        f.Constraints.MinHeight := 250;
        TLabel(f.Find('lTitle')).Caption := 'Listed';
        TPanel(f.Find('lcount')).Caption := DoubleFormat('#,##0', listed);

        //stale
        if listed = listed2 then
        begin
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', listed);
            TLabel(f.Find('lPercent')).Caption := '0%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrBlue);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrBlue);
            ResToFile('stale', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TCircleProgress(f.Find('progress')).Position := 0;
        end;

        //gained
        if listed > listed2 then
        begin
            percent := ((listed - listed2) / listed2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrGreen);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrGreen);
            ResToFile('gain', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', listed2)+' +'+DoubleFormat('#,##0', listed - listed2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrGreen);
        end;

        //lost
        if listed2 > listed then
        begin
            percent := ((listed - listed2) / listed2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrRed);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrRed);
            ResToFile('lost', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', listed2)+' '+DoubleFormat('#,##0', listed - listed2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrRed);
        end;



        //Tweets
        f := rndstatsCreate(dashScroller);
        f.Parent := dashScroller;
        f.Constraints.MaxWidth := 255;
        f.Constraints.MinWidth := 255;
        f.Constraints.MaxHeight := 250;
        f.Constraints.MinHeight := 250;
        TLabel(f.Find('lTitle')).Caption := 'Tweets';
        TPanel(f.Find('lcount')).Caption := DoubleFormat('#,##0', tweets);

        //stale
        if tweets = tweets2 then
        begin
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', tweets);
            TLabel(f.Find('lPercent')).Caption := '0%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrBlue);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrBlue);
            ResToFile('stale', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TCircleProgress(f.Find('progress')).Position := 0;
        end;

        //gained
        if tweets > tweets2 then
        begin
            percent := ((tweets - tweets2) / tweets2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrGreen);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrGreen);
            ResToFile('gain', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', tweets2)+' +'+DoubleFormat('#,##0', tweets - tweets2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrGreen);
        end;

        //lost
        if tweets2 > tweets then
        begin
            percent := ((tweets - tweets2) / tweets2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrRed);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrRed);
            ResToFile('lost', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', tweets2)+' '+DoubleFormat('#,##0', tweets - tweets2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrRed);
        end;



        //Retweets
        f := rndstatsCreate(dashScroller);
        f.Parent := dashScroller;
        f.Constraints.MaxWidth := 255;
        f.Constraints.MinWidth := 255;
        f.Constraints.MaxHeight := 250;
        f.Constraints.MinHeight := 250;
        TLabel(f.Find('lTitle')).Caption := 'Re-Tweets';
        TPanel(f.Find('lcount')).Caption := DoubleFormat('#,##0', retweets);

        //stale
        if retweets = retweets2 then
        begin
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', retweets);
            TLabel(f.Find('lPercent')).Caption := '0%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrBlue);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrBlue);
            ResToFile('stale', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TCircleProgress(f.Find('progress')).Position := 0;
        end;

        //gained
        if retweets > retweets2 then
        begin
            percent := ((retweets - retweets2) / retweets2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrGreen);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrGreen);
            ResToFile('gain', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', retweets2)+' +'+DoubleFormat('#,##0', retweets - retweets2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrGreen);
        end;

        //lost
        if retweets2 > retweets then
        begin
            percent := ((retweets - retweets2) / retweets2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrRed);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrRed);
            ResToFile('lost', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', retweets2)+' '+DoubleFormat('#,##0', retweets - retweets2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrRed);
        end;



        //Likes
        f := rndstatsCreate(dashScroller);
        f.Parent := dashScroller;
        f.Constraints.MaxWidth := 255;
        f.Constraints.MinWidth := 255;
        f.Constraints.MaxHeight := 250;
        f.Constraints.MinHeight := 250;
        TLabel(f.Find('lTitle')).Caption := 'Likes';
        TPanel(f.Find('lcount')).Caption := DoubleFormat('#,##0', likes);

        //stale
        if likes = likes2 then
        begin
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', likes);
            TLabel(f.Find('lPercent')).Caption := '0%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrBlue);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrBlue);
            ResToFile('stale', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TCircleProgress(f.Find('progress')).Position := 0;
        end;

        //gained
        if likes > likes2 then
        begin
            percent := ((likes - likes2) / likes2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrGreen);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrGreen);
            ResToFile('gain', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', likes2)+' +'+DoubleFormat('#,##0', likes - likes2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrGreen);
        end;

        //lost
        if likes2 > likes then
        begin
            percent := ((likes - likes2) / likes2) *100;
            TLabel(f.Find('lPercent')).Caption := DoubleFormat('0.00', percent)+'%';
            TLabel(f.Find('lPercent')).Font.Color := HexToColor(clrRed);
            TPanel(f.Find('ldiff')).Font.Color := HexToColor(clrRed);
            ResToFile('lost', TempDir+'tmp.png');
            TImage(f.Find('img')).Picture.LoadFromFile(TempDir+'tmp.png');
            TPanel(f.Find('ldiff')).Caption := DoubleFormat('#,##0', likes2)+' '+DoubleFormat('#,##0', likes - likes2);
            if abs(percent) <= 1 then percent := 1;
            if abs(percent) >= 100 then percent := 100;
            TCircleProgress(f.Find('progress')).Position := Round(abs(percent));
            TCircleProgress(f.Find('progress')).ColorDoneMax := HexToColor(clrRed);
        end;


        DeleteFile(TempDir+'tmp.png');
    end;

    _setIdle();
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
end;

procedure mainform_populateCounters_OnExecute(Sender: TSimpleAction);
begin
    populateCounters(loginUser);
end;

procedure mainform_bSendDM_OnClick(Sender: TBGRAButton);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    f := messageCreate(MainForm);
    f.ShowModalDimmed;
end;

procedure mainform_OnWindowStateChange(Sender: TForm);
begin
    TimeLineList.Repaint;
    NetList.Repaint;
    QueList.Repaint;
    RepList.Repaint;
    mainform_OnResize(Sender);
end;

procedure mainform_bMenu_OnButtonClick(Sender: TBGRAButton);
var
    pop: TPopupMenu;
    x, y: int;
begin
    pop := TPopupMenu(Sender.Owner.Find('PopupMenu1'));

    x := Sender.ClientToScreenX(0, 0);
    y := Sender.ClientToScreenY(0, 0) + Sender.Height;

    pop.PopUpAt(x, y);
end;

procedure mainform_bPromote_OnClick(Sender: TBGRAButton);
var
    pop: TPopupMenu;
    x, y: int;
begin
    pop := TPopupMenu(Sender.Owner.Find('PopupMenu2'));

    x := Sender.ClientToScreenX(0, 0);
    y := Sender.ClientToScreenY(0, 0) + Sender.Height;

    pop.PopUpAt(x, y);
end;

procedure mainform_mFollowLACenter_OnClick(Sender: TMenuItem);
var
    tc: TTwitter;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
    tc.followUser('@liveappscenter');
    ShowMessage('Thank you :)');
end;

procedure mainform_mFollowLACenterSupport_OnClick(Sender: TMenuItem);
var
    tc: TTwitter;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    tc := TTwitter(accounts.Objects[accounts.IndexOf(_getSelectedUser)]);
    tc.followUser('@liveappshelp');
    ShowMessage('Thank you :)');
end;

procedure mainform_mILove_OnClick(Sender: TMenuItem);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    f := newTweetCreate(MainForm);
    f.Caption := 'Tweet Now';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    TMemo(f.Find('Memo1')).Lines.Text := '@liveappscenter - I Love #LATweetBoss - https://liveapps.center';
    ResToFile('sendlove', TempDir+'img.jpg');
    TImage(f.Find('Image1')).Picture.LoadFromFile(TempDir+'img.jpg');
    TImage(f.Find('Image1')).Hint := TempDir+'img.jpg';
    newtweet_Memo1_OnChange(TMemo(f.Find('Memo1')));
    f.ShowModalDimmed;
end;

procedure mainform_mILike_OnClick(Sender: TMenuItem);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    f := newTweetCreate(MainForm);
    f.Caption := 'Tweet Now';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    TMemo(f.Find('Memo1')).Lines.Text := '@liveappscenter - I Like #LATweetBoss - https://liveapps.center';
    ResToFile('sendlike', TempDir+'img.jpg');
    TImage(f.Find('Image1')).Picture.LoadFromFile(TempDir+'img.jpg');
    TImage(f.Find('Image1')).Hint := TempDir+'img.jpg';
    newtweet_Memo1_OnChange(TMemo(f.Find('Memo1')));
    f.ShowModalDimmed;
end;

procedure mainform_mCool_OnClick(Sender: TMenuItem);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    f := newTweetCreate(MainForm);
    f.Caption := 'Tweet Now';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    TMemo(f.Find('Memo1')).Lines.Text := '@liveappscenter - #LATweetBoss is Cool - https://liveapps.center';
    ResToFile('sendcool', TempDir+'img.jpg');
    TImage(f.Find('Image1')).Picture.LoadFromFile(TempDir+'img.jpg');
    TImage(f.Find('Image1')).Hint := TempDir+'img.jpg';
    newtweet_Memo1_OnChange(TMemo(f.Find('Memo1')));
    f.ShowModalDimmed;
end;

procedure mainform_mPro_OnClick(Sender: TMenuItem);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    f := newTweetCreate(MainForm);
    f.Caption := 'Tweet Now';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    TMemo(f.Find('Memo1')).Lines.Text := '@liveappscenter - I am a Pro, I use #LATweetBoss - https://liveapps.center';
    ResToFile('sendpro', TempDir+'img.jpg');
    TImage(f.Find('Image1')).Picture.LoadFromFile(TempDir+'img.jpg');
    TImage(f.Find('Image1')).Hint := TempDir+'img.jpg';
    newtweet_Memo1_OnChange(TMemo(f.Find('Memo1')));
    f.ShowModalDimmed;
end;

procedure mainform_mFeature_OnClick(Sender: TMenuItem);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    f := newTweetCreate(MainForm);
    f.Caption := 'Tweet Now';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    TMemo(f.Find('Memo1')).Lines.Text := '@liveappscenter - Please add [feature] to #LATweetBoss - https://liveapps.center';
    ResToFile('sendrequest', TempDir+'img.jpg');
    TImage(f.Find('Image1')).Picture.LoadFromFile(TempDir+'img.jpg');
    TImage(f.Find('Image1')).Hint := TempDir+'img.jpg';
    newtweet_Memo1_OnChange(TMemo(f.Find('Memo1')));
    f.ShowModalDimmed;
end;

procedure mainform_mSmile_OnClick(Sender: TMenuItem);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    f := newTweetCreate(MainForm);
    f.Caption := 'Tweet Now';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    TMemo(f.Find('Memo1')).Lines.Text := '@liveappscenter - A :) to the #LATweetBoss Team - https://liveapps.center';
    ResToFile('sendsmile', TempDir+'img.jpg');
    TImage(f.Find('Image1')).Picture.LoadFromFile(TempDir+'img.jpg');
    TImage(f.Find('Image1')).Hint := TempDir+'img.jpg';
    newtweet_Memo1_OnChange(TMemo(f.Find('Memo1')));
    f.ShowModalDimmed;
end;

procedure mainform_mFraun_OnClick(Sender: TMenuItem);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    f := newTweetCreate(MainForm);
    f.Caption := 'Tweet Now';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    TMemo(f.Find('Memo1')).Lines.Text := '@liveappscenter - A :( to the #LATweetBoss Team - https://liveapps.center';
    ResToFile('sendfrown', TempDir+'img.jpg');
    TImage(f.Find('Image1')).Picture.LoadFromFile(TempDir+'img.jpg');
    TImage(f.Find('Image1')).Hint := TempDir+'img.jpg';
    newtweet_Memo1_OnChange(TMemo(f.Find('Memo1')));
    f.ShowModalDimmed;
end;

procedure mainform_mHelp_OnClick(Sender: TMenuItem);
var
    f: TForm;
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    f := newTweetCreate(MainForm);
    f.Caption := 'Tweet Now';
    TButton(f.Find('Button2')).Caption := 'Tweet';
    TMemo(f.Find('Memo1')).Lines.Text := '@liveappshelp - Please help me with [feature] - https://liveapps.center';
    ResToFile('sendhelp', TempDir+'img.jpg');
    TImage(f.Find('Image1')).Picture.LoadFromFile(TempDir+'img.jpg');
    TImage(f.Find('Image1')).Hint := TempDir+'img.jpg';
    newtweet_Memo1_OnChange(TMemo(f.Find('Memo1')));
    f.ShowModalDimmed;
end;

procedure mainform_mAddTwitterAccount_OnClick(Sender: TMenuItem);
begin
    accountCreate(MainForm).ShowModalDimmed;
end;

procedure mainform_mAccounts_OnClick(Sender: TMenuItem);
begin
    mainform_bMenu_OnClick(Sender);
end;

procedure mainform_mMutedUsers_OnClick(Sender: TMenuItem);
begin
    if _getSelectedUser = '' then
    begin
        _setBusy('Please select a user first...');
        Application.ProcessMessages;
        exit;
    end;

    mutelistCreate(MainForm).ShowModalDimmed;
end;

procedure mainform_mExit_OnClick(Sender: TMenuItem);
begin
    TForm(Sender.Owner).Close;
end;

procedure mainform_mSettings_OnClick(Sender: TMenuItem);
begin
    settingsCreate(MainForm).ShowModalDimmed;
end;

procedure mainform_mAbout_OnClick(Sender: TMenuItem);
begin
    aboutCreate(MainForm).ShowModalDimmed;
end;

procedure mainform_mStartLocalTweetGate_OnClick(Sender: TMenuItem);
begin
    _StartLocalTweetGate;
end;

procedure mainform_mPlan_OnClick(Sender: TMenuItem);
begin
    ShellOpen('https://liveapps.center/store/buy/?item=tweetboss');
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//mainform initialization constructor
constructor
begin 
end.
