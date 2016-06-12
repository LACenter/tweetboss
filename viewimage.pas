////////////////////////////////////////////////////////////////////////////////
// Unit Description  : viewimage Description
// Unit Author       : LA.Center Corporation
// Date Created      : May, Wednesday 11, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of viewimage
function viewimageCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @viewimage_OnCreate, 'viewimage');
end;

//OnCreate Event of viewimage
procedure viewimage_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Position := poOwnerFormCenter;
    _setFonts(Sender);
    TButton(Sender.Find('Button1')).ModalResult := mrOK;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TButton(Sender.find('Button2')).OnClick := @viewimage_Button2_OnClick;
    //</events-bind>
end;

procedure viewimage_Button2_OnClick(Sender: TButton);
begin
    TSaveDialog(Sender.Owner.Find('SaveDialog1')).DefaultExt :=
        TImage(Sender.Owner.find('Image1')).Hint;
    TSaveDialog(Sender.Owner.Find('SaveDialog1')).Filter :=
        'Image Files|*'+TImage(Sender.Owner.find('Image1')).Hint;
    if TSaveDialog(Sender.Owner.Find('SaveDialog1')).Execute then
        TImage(Sender.Owner.find('Image1')).Picture.SaveToFile(TSaveDialog(Sender.Owner.Find('SaveDialog1')).FileName);
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//viewimage initialization constructor
constructor
begin 
end.
