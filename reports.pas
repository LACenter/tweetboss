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

uses 'globals';

//constructor of reports
function reportsCreate(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructorFromResource(Owner, @reports_OnCreate, 'reports');
end;

//OnCreate Event of reports
procedure reports_OnCreate(Sender: TFrame);
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

    _setButton(TBGRAButton(Sender.Find('bRefresh')), false, false);
    TLabel(Sender.Find('lUser')).Font.Style := fsBold;

    RepTree := TTreeView(Sender.Find('navTree'));
    RepList := TTreeView(Sender.Find('listTree'));

    RepTree.Items.Clear;
    root := RepTree.Items.Add('Months '+IntToStr(YearOf(Now)));
    root.ImageIndex := 0;
    root.SelectedIndex := root.ImageIndex;
    root.Selected := true;

        child := RepTree.Items.AddChild(root, 'January');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := RepTree.Items.AddChild(root, 'February');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := RepTree.Items.AddChild(root, 'March');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := RepTree.Items.AddChild(root, 'April');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := RepTree.Items.AddChild(root, 'May');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := RepTree.Items.AddChild(root, 'June');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := RepTree.Items.AddChild(root, 'July');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := RepTree.Items.AddChild(root, 'August');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := RepTree.Items.AddChild(root, 'September');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := RepTree.Items.AddChild(root, 'October');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := RepTree.Items.AddChild(root, 'November');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

        child := RepTree.Items.AddChild(root, 'December');
        child.ImageIndex := 2;
        child.SelectedIndex := child.ImageIndex;

    root.Expand(false);

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TTreeView(Sender.find('listTree')).OnCustomDrawItem := @reports_listTree_OnCustomDrawItem;
    TBGRAButton(Sender.find('bRefresh')).OnClick := @reports_bRefresh_OnClick;
    TTreeView(Sender.find('navTree')).OnChanging := @reports_navTree_OnChanging;
    TTreeView(Sender.find('navTree')).OnClick := @reports_navTree_OnClick;
    //</events-bind>
end;

procedure populateReport();
var
    urla: TUrla;
    str: TStringList;
    rep: TStringList;
    data: TStringList;
    i: int;
    mon: string;

    function CountClicks(url: string): int;
        var i, c: int;
    begin
        c := 0;
        for i := 0 to str.Count -1 do
            if Pos('"LINK'+url+'"|', ReplaceAll(str.Strings[i], '=', '')) > 0 then
                c := c +1;
        result := c;
    end;
begin
    _setBusyScreen;
    if RepTree.Selected <> nil then
    begin
        mon := IntToStr(RepTree.Selected.AbsoluteIndex);
        if len(mon) = 1 then
        mon := '0'+mon;

        RepList.Items.BeginUpdate;
        RepList.Items.Clear;

        data := TStringList.Create;
        rep := TStringList.Create;
        str := TStringList.Create;
        urla := TUrla.Create;
        str.Text := urla.GetData(appsettings.Values['live-key'], mon);

        data.Delimiter := '|';
        for i := 0 to str.Count -1 do
        begin
            if trim(str.Strings[i]) <> '' then
            begin
                data.DelimitedText := str.Strings[i];
                if rep.IndexOf(ReplaceAll(data.Values['link'], '=', '')+'=') = -1 then
                    rep.Add(ReplaceAll(data.Values['link'], '=', '')+'=');
            end;
        end;

        rep.Sort;

        for i := 0 to rep.Count -1 do
        begin
            rep.Strings[i] := rep.Strings[i]+IntToStr(CountClicks(rep.Names[i]));
            RepList.Items.Add(rep.Strings[i]);
        end;


        data.Free;
        rep.Free;
        str.Free;

        RepList.Items.EndUpdate;
    end;
    _setIdle;
end;

procedure reports_navTree_OnClick(Sender: TTreeView);
begin
    if Sender.Selected <> nil then
    begin
        TTreeView(Sender.Owner.Find('listTree')).Items.BeginUpdate;
        TTreeView(Sender.Owner.Find('listTree')).Items.Clear;
        TTreeView(Sender.Owner.Find('listTree')).Items.EndUpdate;

        if Sender.Selected.ImageIndex in [2] then
        begin
            populateReport;
        end;
    end;
end;

procedure reports_navTree_OnChanging(Sender: TTreeView; Node: TTreeNode; var Allow: bool);
begin
    Allow := (trim(appsettings.Values['live-key']) <> '');
    if not Allow then
        MsgInfo('Information', 'You need specify your Live Services Key');
end;

procedure reports_bRefresh_OnClick(Sender: TBGRAButton);
begin
    reports_navTree_OnClick(RepTree);
end;

procedure reports_listTree_OnCustomDrawItem(Sender: TTreeView; Node: TTreeNode; DrawInfo: TCustomDrawInfo; var DefaultDraw: bool);
var
    bgColor: int;
    tw: int;
    tmp: string;
begin
    if Node.Text <> '' then
    begin
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


        Sender.Canvas.TextOut(Node.DisplayRectLeft(false) + 10,
                              Node.DisplayRectTop(false) + 10,
                              copy(Node.Text, 0, Pos('=', Node.Text) -1));

        if OSX then
        Sender.Canvas.Font.Size := 24
        else
        Sender.Canvas.Font.Size := 20;
        Sender.Canvas.Font.Color := clBlue;

        tmp := Node.Text;
        tmp := copy(tmp, Pos('=', tmp) +1, 100);
        if Pos('=', tmp) > 0 then
            tmp := copy(tmp, Pos('=', tmp) +1, 100);
        if Pos('=', tmp) > 0 then
            tmp := copy(tmp, Pos('=', tmp) +1, 100);
        if Pos('=', tmp) > 0 then
            tmp := copy(tmp, Pos('=', tmp) +1, 100);
        if Pos('=', tmp) > 0 then
            tmp := copy(tmp, Pos('=', tmp) +1, 100);
        if Pos('=', tmp) > 0 then
            tmp := copy(tmp, Pos('=', tmp) +1, 100);

        tw := Sender.Canvas.TextWidth(tmp);

        Sender.Canvas.TextOut(Node.DisplayRectRight(false) - tw - 10,
                              Node.DisplayRectTop(false) + 20,
                              tmp);


        Sender.Canvas.Font.Size := Sender.Font.Size;
        Sender.Canvas.Font.Color := $00444444;

        Sender.Canvas.drawImageStretch(tweetShadow,
                                       Node.DisplayRectLeft(false),
                                       Node.DisplayRectBottom(false) -10,
                                       Node.DisplayRectRight(false),
                                       Node.DisplayRectBottom(false));
    end;

    DefaultDraw := false;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//reports initialization constructor
constructor
begin 
end.
