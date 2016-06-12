////////////////////////////////////////////////////////////////////////////////
// Unit Description  : globals Description
// Unit Author       : LA.Center Corporation
// Date Created      : February, Monday 22, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

const
    clrGreen = '#19B81D';
    clrBlue = '#413AD8';
    clrRed = '#F41822';
    appPreName = 'LA.TweetBoss';
    appVersion = '1.21';
    appSurName = 'Tweet like a Boss';
    tweetlinkLen = 24;
    tweetmediaLen = 25;

var
    MainForm: TForm;
    leftScroller: TScrollBox;
    dashScroller: TScrollBox;
    Pages: TATTabs;
    actXML: TXMLDataset;
    root: string;
    accounts: TStringList;  //store twitter client instances
    loginUser: string;
    loginName: string;
    counter: TFrame;
    timeline: TFrame;
    que: TFrame;
    growth: TFrame;
    report: TFrame;
    tweetGateIsRunning: bool = false;
    appSettings: TStringList;
    OldFollowersIDS: TSTringList;
    FollowersIDS: TStringList;
    FollowingIDS: TStringList;
    clickLog: TStringList;
    favList: TStringList;
    msgList: TStringList;
    muteList: TStringList;

    tweetShadow: TPortableNetworkGraphic;
    actionArrow: TPortableNetworkGraphic;
    hartBmp: TBitmap;
    rtBmp: TBitmap;
    birdBmp: TBitmap;
    clickBmp: TBitmap;

    populateLimit: int = 25;
    TimeLineTree: TTreeView;
    TimeLineList: TTreeView;
    NetTree: TTreeView;
    NetList: TTreeView;
    QueTree: TTreeView;
    QueList: TTreeView;
    RepTree: TTreeView;
    RepList: TTreeView;

procedure _StartLocalTweetGate();
var
    exe: string;
begin
    if not tweetGateIsRunning then
    begin
        deleteFile(TempDir+'tweetgate.xap');
        resToFile('tweetgate', TempDir+'tweetgate.xap');
        exe := '"'+ArgumentByIndex(0)+'" -action=launch "-project='+TempDir+'tweetgate.xap"';
        CallExecute(exe);
        tweetGateIsRunning := true;
    end;
end;

procedure _setButton(bu: TBGRAButton; arrowLeft, arrowRight: bool);
begin
    bu.TextShadowOffSetX := 0;
    bu.TextShadowOffSetY := 1;
    bu.TextShadowRadius := 0;
    // Normal
    bu.BodyNormal.BorderColor := HexToColor('#dd3333');
    bu.BodyNormal.Font.Color := clWhite;
    if Windows then
    bu.BodyNormal.Font.Size := 10
    else if OSX then
    bu.BodyNormal.Font.Size := 12
    else
    bu.BodyNormal.Font.Size := 8;
    bu.BodyNormal.Gradient1.StartColor := HexToColor('#ee3300');
    bu.BodyNormal.Gradient1.EndColor := HexToColor('#ee4400');
    bu.BodyNormal.Gradient2.StartColor := HexToColor('#ee4400');
    bu.BodyNormal.Gradient2.EndColor := HexToColor('#ee3300');
    // Hover
    bu.BodyHover.BorderColor := HexToColor('#ff7700');
    bu.BodyHover.Font.Color := clWhite;
    if Windows then
    bu.BodyHover.Font.Size := 10
    else if OSX then
    bu.BodyHover.Font.Size := 12
    else
    bu.BodyHover.Font.Size := 8;
    bu.BodyHover.Gradient1.StartColor := HexToColor('#ff8800');
    bu.BodyHover.Gradient1.EndColor := HexToColor('#ff5500');
    bu.BodyHover.Gradient2.StartColor := HexToColor('#ff5500');
    bu.BodyHover.Gradient2.EndColor := HexToColor('#ff8800');
    // Clicked
    bu.BodyClicked.BorderColor := HexToColor('#ff4400');
    bu.BodyClicked.Font.Color := clWhite;
    if Windows then
    bu.BodyClicked.Font.Size := 10
    else if OSX then
    bu.BodyClicked.Font.Size := 12
    else
    bu.BodyClicked.Font.Size := 8;
    bu.BodyClicked.Gradient1.StartColor := HexToColor('#ff6600');
    bu.BodyClicked.Gradient1.EndColor := HexToColor('#ff4400');
    bu.BodyClicked.Gradient2.StartColor := HexToColor('#ff4400');
    bu.BodyClicked.Gradient2.EndColor := HexToColor('#ff6600');

    if arrowLeft then
    begin
        bu.BorderStyle.TopLeft := bsBevel;
        bu.BorderStyle.BottomLeft := bsBevel;
        bu.BorderStyle.TopRight := bsSquare;
        bu.BorderStyle.BottomRight := bsSquare;
        bu.RoundX := 20;
        bu.RoundY := 20;
    end
    else if arrowRight then
    begin
        bu.BorderStyle.TopLeft := bsSquare;
        bu.BorderStyle.BottomLeft := bsSquare;
        bu.BorderStyle.TopRight := bsBevel;
        bu.BorderStyle.BottomRight := bsBevel;
        bu.RoundX := 20;
        bu.RoundY := 20;
    end
    else
    begin
        bu.BorderStyle.TopLeft := bsSquare;
        bu.BorderStyle.BottomLeft := bsSquare;
        bu.BorderStyle.TopRight := bsSquare;
        bu.BorderStyle.BottomRight := bsSquare;
        bu.RoundX := 0;
        bu.RoundY := 0;
    end;
end;

function _ValidateName(val: string): bool;
const
    allowedChars = ['A'..'Z','a'..'z','0'..'9','-','_','#','@',' '];
var
    i: int;
begin
    //we want no spaces or special chars
    result := true;
    if Len(val) <> 0 then
    begin
        for i := 1 to Len(val) do
        begin
            if not (val[i] in allowedChars) then //check for allowed chars
            begin
                MsgError('Invalid Name', 'Given name contains invalid characters, please use only characters in the range of [A-Z,a-z,0-9,-,_, ,#,@]');
                result := false;
            end;
        end;
    end
        else
        result := false;
end;

procedure _setFonts(comp: TComponent);
var
    i: int;
    font: TFont;
begin
    font := TFont.Create;
    for i := 0 to comp.ComponentCount -1 do
    begin
        if comp.Components[i].hasProp('Font') then
        begin
            if Screen.Fonts.IndexOf('DejaVu Sans') then
            TControl(comp.Components[i]).Font.Name := 'DejaVu Sans'
            else if Screen.Fonts.IndexOf('Liberation Sans') then
            TControl(comp.Components[i]).Font.Name := 'Liberation Sans'
            else if Screen.Fonts.IndexOf('Open Sans') then
            TControl(comp.Components[i]).Font.Name := 'Open Sans'
            else if Screen.Fonts.IndexOf('Segoe UI') then
            TControl(comp.Components[i]).Font.Name := 'Segoe UI'
            else if Screen.Fonts.IndexOf('Verdana') then
            TControl(comp.Components[i]).Font.Name := 'Verdana'
            else if Screen.Fonts.IndexOf('Tahoma') then
            TControl(comp.Components[i]).Font.Name := 'Tahoma'
            else if Screen.Fonts.IndexOf('Arial') then
            TControl(comp.Components[i]).Font.Name := 'Arial';

            if comp.Components[i].Tag <> -1 then
                TControl(comp.Components[i]).Font.Color := $00444444;

            if OSX then
            TControl(comp.Components[i]).Font.Size := 16
            else if Windows then
            TControl(comp.Components[i]).Font.Size := 13
            else
            TControl(comp.Components[i]).Font.Size := 12;

            if comp.Components[i].Name = 'status' then
            begin
                if OSX then
                TControl(comp.Components[i]).Font.Size := 16
                else
                TControl(comp.Components[i]).Font.Size := 12;
            end;

            font.Assign(TControl(comp.Components[i]).Font);
        end;
    end;

    if (comp.ClassName = 'TForm') or
       (comp.ClassName = 'TFrame') then
    TControl(comp).Font.Assign(font);

    font.free;
end;

procedure _setBusyScreen();
begin
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;
end;

procedure _setBusy(value: string);
begin
    TLabel(MainForm.Find('status')).Caption := value;
    TTimer(MainForm.Find('busyTimer')).Enabled := true;

    _cleanImageCache;
end;

procedure _setIdle();
begin
    TLabel(MainForm.Find('status')).Caption := 'Ready...';
    TTimer(MainForm.Find('busyTimer')).Enabled := false;
    TCircleProgress(MainForm.Find('progress')).ColorDoneMax := clWhite;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;
end;

procedure _cleanImageCache();
var
    images: TStringList;
    i: int;
    utl, htl, mtl, ttl: TStringList;
    id: string;
begin
    //clean up images for tweets that are
    //out of the cycle
    if _getSelectedUser <> '' then
    begin
        utl := TStringList.Create;
        if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'user.timeline') then
            utl.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'user.timeline');

        htl := TStringList.Create;
        if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'home.timeline') then
            htl.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'home.timeline');

        mtl := TStringList.Create;
        if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mentions.timeline') then
            mtl.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'mentions.timeline');

        ttl := TStringList.Create;
        if FileExists(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'top.timeline') then
            ttl.LoadFromFile(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000)+DirSep+'top.timeline');

        images := TStringList.Create;
        SearchDir(root+'accounts'+DirSep+copy(_getSelectedUser, 2, 1000), '*', images);
        for i := 0 to images.Count -1 do
        begin
            if ((Pos('.jpg', Lower(images.Strings[i])) > 0) or
                (Pos('.jpeg', Lower(images.Strings[i])) > 0) or
                (Pos('.png', Lower(images.Strings[i])) > 0)) and
               (Pos('profile.', Lower(images.Strings[i])) = 0)  then
            begin
                id := FileNameOf(images.Strings[i]);
                id := Copy(id, 0, Pos('.', id) -1);
                if (Pos('id='+id, utl.Text) = 0) and
                   (Pos('id='+id, htl.Text) = 0) and
                   (Pos('id='+id, ttl.Text) = 0) and
                   (Pos('id='+id, mtl.Text) = 0) then
                begin
                    //loose image, we can delete it
                    deleteFile(images.Strings[i]);
                end;
            end;
        end;

        images.Free;
        utl.Free;
        htl.Free;
        mtl.Free;
        ttl.Free;
    end;
end;

procedure _populateQuery(user: string);
var
    tc: TTwitter;
    sinceid: string = '';
    searchTimelineFile: string;
    homedir, imageFile: string;
    http: THttp;
    fs: TFileStream;
    i: int;
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        searchTimelineFile := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+TimeLineTree.Selected.Text+'.timeline';
        homedir := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep;

        ForceDir(homedir);

        if FileExists(searchTimelineFile) then
        begin
            tc.SearchResult.LoadFromFile(searchTimelineFile);
            for i := tc.SearchResult.Count -1 downto (populateLimit * 2) do
            begin
                deleteFile(tc.SearchResult.Items[i].TweetID+'.jpg');
                deleteFile(tc.SearchResult.Items[i].TweetID+'.jpeg');
                deleteFile(tc.SearchResult.Items[i].TweetID+'.png');
                tc.SearchResult.Delete(i);
            end;
        end;

        if tc.SearchResult.Count <> 0 then
            sinceid := tc.SearchResult.Items[0].TweetID;

        //api limit 1 call every 5 sec.
        if not _isInLimit(user, 'search') then
        begin
            _setBusy('Updating Query Timeline, please wait...');
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            try
                tc.search(TimeLineTree.Selected.Text, populateLimit, sinceid, '');
                tc.SearchResult.SaveToFile(searchTimelineFile);
                _startSearchApiLimit(user);
            except
                if tc.SearchResult.Count = 0 then
                begin
                    if FileExists(searchTimelineFile) then
                        tc.SearchResult.LoadFromFile(searchTimelineFile);
                end;
            end;

            for i := 0 to tc.SearchResult.Count -1 do
            begin
                if Trim(tc.SearchResult.Items[i].TweetMediaUrl) <> '' then
                begin
                    try
                        imageFile := '';
                        if Pos('.jpg', tc.SearchResult.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.SearchResult.Items[i].TweetID+'.jpg';
                        if Pos('.jpeg', tc.SearchResult.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.SearchResult.Items[i].TweetID+'.jpeg';
                        if Pos('.png', tc.SearchResult.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.SearchResult.Items[i].TweetID+'.png';
                        if imageFile <> '' then
                        begin
                            if not FileExists(imageFile) then
                            begin
                                http.clear;
                                fs := TFileStream.Create(imageFile, fmCreate);
                                http.urlGetBinary(tc.SearchResult.Items[i].TweetMediaUrl, fs);
                                fs.free;
                            end;
                        end;
                    except end;
                end;
                if i = (populateLimit -1) then
                    break;
            end;

            _setIdle;
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
        end;
    end;

    http.Free;
end;

procedure _populateTop10Timeline(user: string);
var
    tc: TTwitter;
    sinceid: string = '';
    userTimelineFile: string;
    homedir, imageFile: string;
    http: THttp;
    fs: TFileStream;
    i, j, maxLen, topC: int;
    topCount: TStringList;
    ids: TStringList;
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        userTimelineFile := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+'top.timeline';
        homedir := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep;

        ForceDir(homedir);

        //api limit 1 call every 30 sec.
        if not _isInLimit(user, 'top10') then
        begin
            //always clear top 10
            tc.TimeLineTop10.Clear;

            _setBusy('Calculating Top 10 Tweets, please wait...');
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            try
                //get the last 1000 tweets - we burn 25 sec of API time
                tc.listTop10TimeLine(Copy(user, 2, 1000), 200, ''); //5 sec.
                tc.TimeLineTop10.SaveToFile(userTimelineFile);
                tc.TimeLineTop10.SaveToFile(userTimelineFile+'.full');
                _startTop10ApiLimit(user);
            except
                if tc.TimeLineTop10.Count = 0 then
                begin
                    if FileExists(userTimelineFile) then
                        tc.TimeLineTop10.LoadFromFile(userTimelineFile);
                end;
            end;

            topCount := TStringList.Create;
            for i := 0 to tc.TimeLineTop10.Count -1 do
            begin
                if Pos('RT', tc.TimeLineTop10.Items[i].TweetText) = 0 then
                begin
                    if topCount.IndexOf(IntToStr(tc.TimeLineTop10.Items[i].RetweetCount + tc.TimeLineTop10.Items[i].FavoriteCount)) = -1 then
                    begin
                        topCount.AddObject(IntToStr(tc.TimeLineTop10.Items[i].RetweetCount + tc.TimeLineTop10.Items[i].FavoriteCount),
                                    tc.TimeLineTop10.Items[i]);
                    end;
                end;
            end;
            maxLen := 0;
            for i := 0 to topCount.Count -1 do
            begin
                if Len(topCount.Strings[i]) > maxLen then
                maxLen := Len(topCount.Strings[i]);
            end;
            for i := 0 to topCount.Count -1 do
            begin
                while len(topCount.Strings[i]) < (maxLen + 3) do
                    topCount.Strings[i] := '0'+topCount.Strings[i];
            end;

            topCount.Sort;

            ids := TStringList.Create;
            for i := topCount.Count -1 downto 0 do
            begin
                if ids.indexOf(TTwitterTweetData(topCount.Objects[i]).TweetID) = -1 then
                begin
                    ids.Add(TTwitterTweetData(topCount.Objects[i]).TweetID);
                    topC := topC +1;
                    if topC = 10 then break;
                end;
            end;

            for i := tc.TimeLineTop10.Count -1 downto 0 do
            begin
                if ids.indexOf(tc.TimeLineTop10.Items[i].TweetID) = -1 then
                    tc.TimeLineTop10.Delete(i);
            end;

            tc.TimeLineTop10.SaveToFile(userTimelineFile);

            ids.Free;

            for i := 0 to tc.TimeLineTop10.Count -1 do
            begin
                if Trim(tc.TimeLineTop10.Items[i].TweetMediaUrl) <> '' then
                begin
                    try
                        imageFile := '';
                        if Pos('.jpg', tc.TimeLineTop10.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimeLineTop10.Items[i].TweetID+'.jpg';
                        if Pos('.jpeg', tc.TimeLineTop10.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimeLineTop10.Items[i].TweetID+'.jpeg';
                        if Pos('.png', tc.TimeLineTop10.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimeLineTop10.Items[i].TweetID+'.png';
                        if imageFile <> '' then
                        begin
                            if not FileExists(imageFile) then
                            begin
                                http.clear;
                                fs := TFileStream.Create(imageFile, fmCreate);
                                http.urlGetBinary(tc.TimeLineTop10.Items[i].TweetMediaUrl, fs);
                                fs.free;
                            end;
                        end;
                    except end;
                end;
                if i = (populateLimit -1) then
                    break;
            end;

            _setIdle;
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
        end;
    end;

    http.Free;
end;

procedure _populateUserTimeline(user: string);
var
    tc: TTwitter;
    sinceid: string = '';
    userTimelineFile: string;
    homedir, imageFile: string;
    http: THttp;
    fs: TFileStream;
    i: int;
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        userTimelineFile := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+'user.timeline';
        homedir := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep;

        ForceDir(homedir);

        if FileExists(userTimelineFile) then
        begin
            tc.TimeLineUser.LoadFromFile(userTimelineFile);
            for i := tc.TimeLineUser.Count -1 downto (populateLimit * 2) do
            begin
                deleteFile(tc.TimeLineUser.Items[i].TweetID+'.jpg');
                deleteFile(tc.TimeLineUser.Items[i].TweetID+'.jpeg');
                deleteFile(tc.TimeLineUser.Items[i].TweetID+'.png');
                tc.TimeLineUser.Delete(i);
            end;
        end;

        if tc.TimeLineUser.Count > 0 then
            sinceid := tc.TimeLineUser.Items[0].TweetID;

        //api limit 1 call every 5 sec.
        if not _isInLimit(user, 'user') then
        begin
            _setBusy('Updating User Timeline, please wait...');
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            try
                tc.listUserTimeLine(Copy(user, 2, 1000), 200, sinceid);
                tc.TimeLineUser.SaveToFile(userTimelineFile);
                _startUserApiLimit(user);
            except
                if tc.TimeLineUser.Count = 0 then
                begin
                    if FileExists(userTimelineFile) then
                        tc.TimeLineUser.LoadFromFile(userTimelineFile);
                end;
            end;

            for i := 0 to tc.TimelineUser.Count -1 do
            begin
                if Trim(tc.TimelineUser.Items[i].TweetMediaUrl) <> '' then
                begin
                    try
                        imageFile := '';
                        if Pos('.jpg', tc.TimelineUser.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimelineUser.Items[i].TweetID+'.jpg';
                        if Pos('.jpeg', tc.TimelineUser.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimelineUser.Items[i].TweetID+'.jpeg';
                        if Pos('.png', tc.TimelineUser.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimelineUser.Items[i].TweetID+'.png';
                        if imageFile <> '' then
                        begin
                            if not FileExists(imageFile) then
                            begin
                                http.clear;
                                fs := TFileStream.Create(imageFile, fmCreate);
                                http.urlGetBinary(tc.TimelineUser.Items[i].TweetMediaUrl, fs);
                                fs.free;
                            end;
                        end;
                    except end;
                end;
                if i = (populateLimit -1) then
                    break;
            end;

            _setIdle;
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
        end;
    end;

    http.Free;
end;

procedure _populateUserQueryTimeline(user: string);
var
    tc: TTwitter;
    sinceid: string = '';
    userTimelineFile: string;
    homedir, imageFile: string;
    http: THttp;
    fs: TFileStream;
    i: int;
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        userTimelineFile := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+TimeLineTree.Selected.Text+'.timeline';
        homedir := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep;

        ForceDir(homedir);

        if FileExists(userTimelineFile) then
        begin
            tc.TimeLineUser.LoadFromFile(userTimelineFile);
            for i := tc.TimeLineUser.Count -1 downto (populateLimit * 2) do
            begin
                deleteFile(tc.TimeLineUser.Items[i].TweetID+'.jpg');
                deleteFile(tc.TimeLineUser.Items[i].TweetID+'.jpeg');
                deleteFile(tc.TimeLineUser.Items[i].TweetID+'.png');
                tc.TimeLineUser.Delete(i);
            end;
        end;

        if tc.TimeLineUser.Count <> 0 then
            sinceid := tc.TimeLineUser.Items[0].TweetID;

        //api limit 1 call every 5 sec.
        if not _isInLimit(user, 'user') then
        begin
            _setBusy('Updating User Query Timeline, please wait...');
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            try
                tc.listUserTimeLine(TimeLineTree.Selected.Text, 200, sinceid);
                tc.TimeLineUser.SaveToFile(userTimelineFile);
                _startUserApiLimit(user);
            except
                if tc.TimeLineUser.Count = 0 then
                begin
                    if FileExists(userTimelineFile) then
                        tc.TimeLineUser.LoadFromFile(userTimelineFile);
                end;
            end;

            for i := 0 to tc.TimelineUser.Count -1 do
            begin
                if Trim(tc.TimelineUser.Items[i].TweetMediaUrl) <> '' then
                begin
                    try
                        imageFile := '';
                        if Pos('.jpg', tc.TimelineUser.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimelineUser.Items[i].TweetID+'.jpg';
                        if Pos('.jpeg', tc.TimelineUser.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimelineUser.Items[i].TweetID+'.jpeg';
                        if Pos('.png', tc.TimelineUser.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimelineUser.Items[i].TweetID+'.png';
                        if imageFile <> '' then
                        begin
                            if not FileExists(imageFile) then
                            begin
                                http.clear;
                                fs := TFileStream.Create(imageFile, fmCreate);
                                http.urlGetBinary(tc.TimelineUser.Items[i].TweetMediaUrl, fs);
                                fs.free;
                            end;
                        end;
                    except end;
                end;
                if i = (populateLimit -1) then
                    break;
            end;

            _setIdle;
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
        end;
    end;

    http.Free;
end;

procedure onBytesGet(Sender: THttp; BytesGot, BytesTotal: int64);
begin
    Application.ProcessMessages;
end;

procedure _populateHomeTimeline(user: string);
var
    tc: TTwitter;
    sinceid: string = '';
    homeTimelineFile: string;
    homedir, imageFile: string;
    http: THttp;
    fs: TFileStream;
    i: int;
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        homeTimelineFile := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+'home.timeline';
        homedir := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep;

        ForceDir(homedir);

        if FileExists(homeTimelineFile) then
        begin
            tc.TimeLineHome.LoadFromFile(homeTimelineFile);
            for i := tc.TimeLineHome.Count -1 downto (populateLimit * 2) do
            begin
                deleteFile(tc.TimeLineHome.Items[i].TweetID+'.jpg');
                deleteFile(tc.TimeLineHome.Items[i].TweetID+'.jpeg');
                deleteFile(tc.TimeLineHome.Items[i].TweetID+'.png');
                tc.TimeLineHome.Delete(i);
            end;
        end;

        if tc.TimeLineHome.Count <> 0 then
            sinceid := tc.TimeLineHome.Items[0].TweetID;

        //api limit 1 call every 60 sec.
        if not _isInLimit(user, 'home') then
        begin
            _setBusy('Updating Home Timeline, please wait...');
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            try
                tc.listHomeTimeLine(200, sinceid);
                tc.TimeLineHome.SaveToFile(homeTimelineFile);
                _startHomeApiLimit(user);
            except
                if tc.TimeLineHome.Count = 0 then
                begin
                    if FileExists(homeTimelineFile) then
                        tc.TimeLineHome.LoadFromFile(homeTimelineFile);
                end;
            end;

            for i := 0 to tc.TimelineHome.Count -1 do
            begin
                if Trim(tc.TimelineHome.Items[i].TweetMediaUrl) <> '' then
                begin
                    try
                        imageFile := '';
                        if Pos('.jpg', tc.TimelineHome.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimelineHome.Items[i].TweetID+'.jpg';
                        if Pos('.jpeg', tc.TimelineHome.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimelineHome.Items[i].TweetID+'.jpeg';
                        if Pos('.png', tc.TimelineHome.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.TimelineHome.Items[i].TweetID+'.png';
                        if imageFile <> '' then
                        begin
                            if not FileExists(imageFile) then
                            begin
                                http.clear;
                                fs := TFileStream.Create(imageFile, fmCreate);
                                http.urlGetBinary(tc.TimelineHome.Items[i].TweetMediaUrl, fs);
                                fs.free;
                            end;
                        end;
                    except end;
                end;
                if i = (populateLimit -1) then
                    break;      //we populate only the newest 25
            end;

            _setIdle;
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
        end;
    end;

    http.Free;
end;

procedure _populateMentionsTimeline(user: string);
var
    tc: TTwitter;
    sinceid: string = '';
    mentionsTimelineFile: string;
    homedir, imageFile: string;
    http: THttp;
    fs: TFileStream;
    i: int;
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        mentionsTimelineFile := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+'mentions.timeline';
        homedir := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep;

        ForceDir(homedir);

        if FileExists(mentionsTimelineFile) then
        begin
            tc.TimeLinementions.LoadFromFile(mentionsTimelineFile);
            for i := tc.TimeLinementions.Count -1 downto (populateLimit * 2) do
            begin
                deleteFile(tc.TimeLinementions.Items[i].TweetID+'.jpg');
                deleteFile(tc.TimeLinementions.Items[i].TweetID+'.jpeg');
                deleteFile(tc.TimeLinementions.Items[i].TweetID+'.png');
                tc.TimeLinementions.Delete(i);
            end;
        end;

        if tc.TimeLinementions.Count <> 0 then
            sinceid := tc.TimeLinementions.Items[0].TweetID;

        //api limit 1 call every 60 sec.
        if not _isInLimit(user, 'mentions') then
        begin
            _setBusy('Updating Mentions Timeline, please wait...');
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            try
                tc.listmentionsTimeLine(200, sinceid);
                tc.TimeLinementions.SaveToFile(mentionsTimelineFile);
                _startmentionsApiLimit(user);
            except
                if tc.TimeLinementions.Count = 0 then
                begin
                    if FileExists(mentionsTimelineFile) then
                        tc.TimeLinementions.LoadFromFile(mentionsTimelineFile);
                end;
            end;

            for i := 0 to tc.Timelinementions.Count -1 do
            begin
                if Trim(tc.Timelinementions.Items[i].TweetMediaUrl) <> '' then
                begin
                    try
                        imageFile := '';
                        if Pos('.jpg', tc.Timelinementions.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.Timelinementions.Items[i].TweetID+'.jpg';
                        if Pos('.jpeg', tc.Timelinementions.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.Timelinementions.Items[i].TweetID+'.jpeg';
                        if Pos('.png', tc.Timelinementions.Items[i].TweetMediaUrl) then
                            imageFile := homedir+tc.Timelinementions.Items[i].TweetID+'.png';
                        if imageFile <> '' then
                        begin
                            if not FileExists(imageFile) then
                            begin
                                http.clear;
                                fs := TFileStream.Create(imageFile, fmCreate);
                                http.urlGetBinary(tc.Timelinementions.Items[i].TweetMediaUrl, fs);
                                fs.free;
                            end;
                        end;
                    except end;
                end;
                if i = (populateLimit -1) then
                    break;      //we populate only the newest 25
            end;

            _setIdle;
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
        end;
    end;

    http.Free;
end;

procedure _populateInbox(user: string);
var
    tc: TTwitter;
    http: THttp;
    i: int;
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        //api limit 1 call every 60 sec.
        if not _isInLimit(user, 'inbox') then
        begin
            _setBusy('Updating Received Messages, please wait...');
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            try
                tc.listMessagesReceived(200);
                _startInboxApiLimit(user);
            except
                //raise(ExceptionMessage);
            end;

            _setIdle;
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
        end;
    end;

    http.Free;
end;

procedure _populateOutbox(user: string);
var
    tc: TTwitter;
    http: THttp;
    i: int;
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        //api limit 1 call every 60 sec.
        if not _isInLimit(user, 'outbox') then
        begin
            _setBusy('Updating Sent Messages, please wait...');
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            try
                tc.listMessagesSent(200);
                _startOutboxApiLimit(user);
            except
                //raise(ExceptionMessage);
            end;

            _setIdle;
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
        end;
    end;

    http.Free;
end;

procedure _initFollowers(user: string);
var
    tc: TTwitter;
    http: THttp;
    str: TStringList;
    foFile: string;
    i: int;
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    foFile := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+'followers.init';

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);
        str := TStringList.Create;

        try
            if not FileExists(foFile) then
            begin
                str.Text := tc.getFollowersIDs(5000);
                str.SaveToFile(foFile);
                OldFollowersIDS.Text := str.Text;
            end
                else
            begin
                OldFollowersIDS.LoadFromFile(foFile);

                FollowersIDS.Text := tc.getFollowersIDs(5000);
                if FollowersIDS.Count > OldFollowersIDS.Count then
                begin
                    //MERGE ---
                    for i := 0 to FollowersIDS.Count -1 do
                    begin
                        if OldFollowersIDS.IndexOf(FollowersIDS.Strings[i]) = -1 then
                        OldFollowersIDS.Add(FollowersIDS.Strings[i]);
                    end;
                    OldFollowersIDS.SaveToFile(foFile);
                end;
            end;
        except
            //raise(ExceptionMessage);
        end;

        str.Free;
    end;

    http.Free;
end;

procedure _initFollowing(user: string);
var
    tc: TTwitter;
    http: THttp;
    str: TStringList;
    foFile: string;
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    foFile := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+'following.init';

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);
        str := TStringList.Create;

        try
            FollowingIDS.Text := tc.getFollowingIDs(5000);
            FollowingIDS.SaveToFile(foFile);
        except
            //raise(ExceptionMessage);
        end;

        str.Free;
    end;

    http.Free;
end;

procedure _PopulateFollowers(user: string);
var
    tc: TTwitter;
    http: THttp;
    fs: TFileStream;
    i: int;
    cursor: string = '-1';
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        //api limit 1 call every 60 sec.
        if not _isInLimit(user, 'followers') then
        begin
            _setBusy('Updating Followers, please wait...');
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            if tc.Followers.Count <> 0 then
                cursor := tc.Followers.Items[tc.Followers.Count -1].NextCursor;

            try
                tc.listFollowers(200, cursor);
                _startFollowersApiLimit(user);
            except
                //raise(ExceptionMessage);
            end;

            _setIdle;
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
        end;
    end;

    http.Free;
end;

procedure _PopulateFollowing(user: string);
var
    tc: TTwitter;
    http: THttp;
    fs: TFileStream;
    i: int;
    cursor: string = '-1';
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        //api limit 1 call every 60 sec.
        if not _isInLimit(user, 'following') then
        begin
            _setBusy('Updating Following, please wait...');
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            if tc.Following.Count <> 0 then
                cursor := tc.Following.Items[tc.Following.Count -1].NextCursor;

            try
                tc.listFollowing(200, cursor);
                _startFollowingApiLimit(user);
            except
                //raise(ExceptionMessage);
            end;

            _setIdle;
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
        end;
    end;

    http.Free;
end;

procedure _PopulateDroppers(user: string);
var
    tc: TTwitter;
    http: THttp;
    fs: TFileStream;
    i: int;
    foFile: string;
begin
    http := THttp.Create;
    http.onBytesReceived := @onBytesGet;

    foFile := root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+'followers.init';

    if accounts.IndexOf(user) <> -1 then
    begin
        tc := TTwitter(accounts.Objects[accounts.IndexOf(user)]);

        //api limit 1 call every 60 sec.
        if not _isInLimit(user, 'droppers') then
        begin
            _setBusy('Updating Dropped, please wait...');
            Screen.Cursor := crHourGlass;
            Application.ProcessMessages;

            try
                try FollowingIDS.Text := tc.getFollowingIDs(5000); except end;
                try FollowersIDS.Text := tc.getFollowersIDs(5000); except end;
                tc.listDroppers(foFile);
                _startDroppersApiLimit(user);
            except
                //raise(ExceptionMessage);
            end;

            _setIdle;
            Screen.Cursor := crDefault;
            Application.ProcessMessages;
        end;
    end;

    http.Free;
end;

procedure _DeselectAllUsers();
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
        TSimpleAction(leftScroller.Components[i].Find('actSetUnselected')).Execute;
end;

procedure _SelectUser(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TSimpleAction(leftScroller.Components[i].Find('actSetSelected')).Execute;
            break;
        end;
    end;
end;

function _getSelectedUser(): string;
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TPanel(leftScroller.Components[i].Find('Panel1')).Color = HexToColor('#ff5500') then
        begin
            result := TLabel(leftScroller.Components[i].Find('lUser')).Caption;
            break;
        end;
    end;
end;

function _getSelectedUserDisplayName(): string;
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TPanel(leftScroller.Components[i].Find('Panel1')).Color = HexToColor('#ff5500') then
        begin
            result := TLabel(leftScroller.Components[i].Find('lName')).Caption;
            break;
        end;
    end;
end;

function _isInLimit(user, tag: string): bool;
var
    i: int;
begin
    result := false;
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            result := (TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values[tag] <> '0');
            break;
        end;
    end;
end;

function _isTop10Pulled(user: string): bool;
var
    i: int;
begin
    result := false;
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            result := (TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['top10Pulled'] <> '0');
            break;
        end;
    end;
end;

procedure _startFollowersApiLimit(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['followers'] := '60';
            TTimer(leftScroller.Components[i].Find('resetTimer8')).Enabled := true;
            break;
        end;
    end;
end;

procedure _startFollowingApiLimit(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['following'] := '60';
            TTimer(leftScroller.Components[i].Find('resetTimer9')).Enabled := true;
            break;
        end;
    end;
end;

procedure _startInboxApiLimit(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['inbox'] := '60';
            TTimer(leftScroller.Components[i].Find('resetTimer6')).Enabled := true;
            break;
        end;
    end;
end;

procedure _startOutboxApiLimit(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['outbox'] := '60';
            TTimer(leftScroller.Components[i].Find('resetTimer7')).Enabled := true;
            break;
        end;
    end;
end;

procedure _startUserApiLimit(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['user'] := '10';
            TTimer(leftScroller.Components[i].Find('resetTimer3')).Enabled := true;
            break;
        end;
    end;
end;

procedure _startTop10ApiLimit(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['top10'] := '20';
            TTimer(leftScroller.Components[i].Find('resetTimer5')).Enabled := true;
            break;
        end;
    end;
end;

procedure _startSearchApiLimit(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['search'] := '10';
            TTimer(leftScroller.Components[i].Find('resetTimer4')).Enabled := true;
            break;
        end;
    end;
end;

procedure _startHomeApiLimit(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['home'] := '60';
            TTimer(leftScroller.Components[i].Find('resetTimer1')).Enabled := true;
            break;
        end;
    end;
end;

procedure _startMentionsApiLimit(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['mentions'] := '60';
            TTimer(leftScroller.Components[i].Find('resetTimer2')).Enabled := true;
            break;
        end;
    end;
end;

procedure _startDroppersApiLimit(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['droppers'] := '300';
            TTimer(leftScroller.Components[i].Find('resetTimer10')).Enabled := true;
            break;
        end;
    end;
end;

procedure _startMessageApiLimit(user: string; limit: int);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['message'] := IntToStr(limit);
            break;
        end;
    end;
end;

function _getMessageApiLimit(user: string): string;
var
    i: int;
begin
    result := '0';
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            result := TVars(leftScroller.Components[i].Find('apiLimits')).Vars.Values['message'];
            break;
        end;
    end;
end;

procedure _listConnectedUsers(list: TStrings);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TBGRALed(leftScroller.Components[i].Find('led')).Color = clLime then
        begin
            list.Add(TLabel(leftScroller.Components[i].Find('lUser')).Caption);
        end;
    end;
end;

procedure _DoAfterLogin(user: string);
begin
    try
        _initFollowers(user);
        _initFollowing(user);
    except end;

    //this is the inital trigger to start timers
    _populateUserTimeline(user);
    Pages.TabIndex := 0;
end;

procedure _RemoveAccount(user: string);
var
    i: int;
begin
    for i := 0 to leftScroller.ComponentCount -1 do
    begin
        if TLabel(leftScroller.Components[i].Find('lUser')).Caption = user then
        begin
            leftScroller.Components[i].Free;
            break;
        end;
    end;
end;

procedure _DoAfterSelect(user: string);
begin
    //this is the trigger to start after the user has been selected

    if FileExists(root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+'following.init') then
        FollowingIDS.LoadFromFile(root+'accounts'+DirSep+copy(user, 2, 100)+DirSep+'following.init');

    TLabel(counter.Find('lUser')).Caption := _getSelectedUserDisplayName+'''s Counters';
    TLabel(timeline.Find('lUser')).Caption := _getSelectedUserDisplayName+'''s Timelines';
    TLabel(growth.Find('lUser')).Caption := _getSelectedUserDisplayName+'''s Network';
    TLabel(que.Find('lUser')).Caption := _getSelectedUserDisplayName+'''s Queues';
    TLabel(report.Find('lUser')).Caption := _getSelectedUserDisplayName+'''s Clicks';

    if Pages.TabIndex = 0 then
        TSimpleAction(MainForm.Find('populateCounters')).Execute;

    if Pages.TabIndex = 1 then
    begin
        if TimelineTree.Selected <> nil then
        begin
            if TimelineTree.Selected.ImageIndex in [5,6] then
                TimelineTree.Selected.Parent.Selected := true;
        end;
        TSimpleAction(timeline.Find('actPopulateQueries')).Execute;
        if TimeLineTree.Items[1].Selected then
            TSimpleAction(timeline.Find('actPopulateHome')).Execute;
        if TimeLineTree.Items[2].Selected then
            TSimpleAction(timeline.Find('actPopulateUser')).Execute;
        if TimeLineTree.Items[3].Selected then
            TSimpleAction(timeline.Find('actPopulateMentions')).Execute;
        if TimeLineTree.Items[4].Selected then
            TSimpleAction(timeline.Find('actPopulateTop10')).Execute;
    end;

    if Pages.TabIndex = 2 then
    begin
        if NetTree.Items[1].Selected then
            TSimpleAction(growth.Find('actPopulateInbox')).Execute;
        if NetTree.Items[2].Selected then
            TSimpleAction(growth.Find('actPopulateOutbox')).Execute;
        if NetTree.Items[4].Selected then
            TSimpleAction(growth.Find('actPopulateFollowers')).Execute;
        if NetTree.Items[5].Selected then
            TSimpleAction(growth.Find('actPopulateFollowing')).Execute;
        if NetTree.Items[6].Selected then
            TSimpleAction(growth.Find('actPopulateDroppers')).Execute;
        if NetTree.Items[8].Selected then
            TSimpleAction(growth.Find('actPopulateCampaigns')).Execute;
        if NetTree.Items[10].Selected then
            TSimpleAction(growth.Find('actPopulateActions')).Execute;
        if NetTree.Items[11].Selected then
            TSimpleAction(growth.Find('actPopulateEvents')).Execute;
    end;

    if Pages.TabIndex = 3 then
    begin
        TSimpleAction(que.Find('actPopulateQueues')).Execute;
    end;
end;

function _calcChars(txt: string; hasMedia: bool; isReply: bool = false): int;
var
    tmp: string;
    hl: int = 0;
    c: int = 0;
    i: int = 0;
    total: int = 140;
    link: string;
begin

    if Pos(' http', Lower(txt)) > 0 then
    begin
        tmp := txt;
        while (Pos(' http', Lower(tmp)) > 0) do
        begin
            tmp := copy(tmp, Pos(' http', Lower(tmp)), 1000);
            i := 0;
            link := '';
            while true do
            begin
                i := i + 1;
                if i <> 1 then
                begin
                    if (tmp[i] = ' ') or
                       (tmp[i] = #0) or
                       (tmp[i] = #13) or
                       (tmp[i] = #10) then break;
                end;
                link := link+tmp[i];
            end;
            hl := hl + len(link);
            c := c +1;
            tmp := copy(tmp, len(link) +1, 1000);
        end;
    end;

    if Pos(' urla', Lower(txt)) > 0 then
    begin
        tmp := txt;
        while (Pos(' urla', Lower(tmp)) > 0) do
        begin
            tmp := copy(tmp, Pos(' urla', Lower(tmp)), 1000);
            i := 0;
            link := '';
            while true do
            begin
                i := i + 1;
                if i <> 1 then
                begin
                    if (tmp[i] = ' ') or
                       (tmp[i] = #0) or
                       (tmp[i] = #13) or
                       (tmp[i] = #10) then break;
                end;
                link := link+tmp[i];
            end;
            hl := hl + len(link);
            c := c +1;
            tmp := copy(tmp, len(link) +1, 1000);
        end;
    end;

    if hasMedia then
    total := total - ((len(txt) - hl) + (c * tweetlinkLen)) - tweetMediaLen
    else
    total := total - ((len(txt) - hl) + (c * tweetlinkLen));

    if isReply then
    result := total - 40 //we cut 40 chars to leave space for @username in a reply
    else
    result := total;
end;

procedure _getLinks(txt: string; var str: TStrings);
var
    tmp: string;
    i: int = 0;
    link: string;
begin

    if Pos('http', Lower(txt)) > 0 then
    begin
        tmp := txt;
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
            str.Add(link);
            tmp := copy(tmp, len(link) +1, 1000);
        end;
    end;
end;

procedure _resetAppSettings();
begin
    appSettings.Values['tweet-cycle'] := '10';
    appSettings.Values['show-countdown'] := '1';
    populateLimit := 10;


    appSettings.SaveToFile(root+'app.settings');
end;

constructor
begin
    //adjust ModalDimmed Rect
    if IsWindowsXP then
    begin
        AdjustDimOffsetLeft(-9);
        AdjustDimOffsetWidth(9);
    end;
    if IsWindowsVista or IsWindows7 then
    begin
        AdjustDimOffsetLeft(-8);
        AdjustDimOffsetWidth(16);
        AdjustDimOffsetHeight(8);
    end;
    if Linux then
    begin
        AdjustDimOffsetLeft(-1);
        AdjustDimOffsetTop(-1);
        AdjustDimOffsetWidth(5);
        AdjustDimOffsetHeight(3);
    end;

    root := UserDir+'LA.TweetBoss'+DirSep;
    ForceDir(root);

    ForceDir(root+'queues');
    ForceDir(root+'accounts');
    ForceDir(root+'campaigns');
    ForceDir(root+'actions');

    tweetShadow := TPortableNetworkGraphic.Create;
    tweetShadow.LoadFromResource('tweetshadow');
    actionArrow := TPortableNetworkGraphic.Create;
    actionArrow.LoadFromResource('actionArrow');
    hartBmp := TBitmap.Create;
    rtBmp := TBitmap.Create;
    birdBmp := TBitmap.Create;
    clickBmp := TBitmap.Create;

    accounts := TStringList.Create;

    OldFollowersIDS := TStringList.Create;
    FollowersIDS := TStringList.Create;
    FollowingIDS := TStringList.Create;
    clickLog := TStringList.Create;
    favList := TStringList.Create;
    msgList := TStringList.Create;
    muteList := TStringList;

    actXML := TXMLDataset.Create(nil);
    actXML.FileName := root+'accounts.xml';
    if not FileExists(actXML.FileName) then
    begin
        actXML.FieldDefs.Add('username', ftString, 50);
        actXML.FieldDefs.Add('displayname', ftString, 50);
        actXML.FieldDefs.Add('imageurl', ftString, 150);
        actXML.FieldDefs.Add('password', ftString, 50);
        actXML.FieldDefs.Add('storepass', ftInteger);
        actXML.Active := true;
        actXML.SaveToXMLFile(actXML.FileName);
        actXML.Close;
    end;

    appSettings := TStringList.Create;
    if FileExists(root+'app.settings') then
    begin
        appSettings.LoadFromFile(root+'app.settings');
        populateLimit := StrToIntDef(appSettings.Values['tweet-cycle'], 10);
    end
    else
        _resetAppSettings;

end.
