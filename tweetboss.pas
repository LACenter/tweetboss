////////////////////////////////////////////////////////////////////////////////
// Unit Description  : tweetboss Description
// Unit Author       : LA.Center Corporation
// Date Created      : April, Sunday 24, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////


uses 'mainform';

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

procedure AppException(Sender: TObject; E: Exception);
begin
    //Uncaught Exceptions
    MsgError('Error', E.Message);
end;

//tweetboss initialization constructor
constructor
begin
    Application.Initialize;
    Application.Icon.LoadFromResource('appicon');
    Application.Title := 'LA.TweetBoss - Tweet like a Boss';
    mainformCreate(nil);
    Application.Run;
end.

//Project Resources
//$res:appicon=[project-home]resources/app.ico
//$res:mainform=[project-home]mainform.pas.frm
//$res:user=[project-home]user.pas.frm
//$res:account=[project-home]account.pas.frm
//$res:login=[project-home]login.pas.frm
//$res:actionarrow=[project-home]resources/action.png
//$res:shadowtop=[project-home]resources/300-banner_shadow2.png
//$res:shadowbottom=[project-home]resources/300-banner_shadow.png
//$res:none=[project-home]resources/none.png
//$res:rndstats=[project-home]rndstats.pas.frm
//$res:timelines=[project-home]timelines.pas.frm
//$res:ques=[project-home]ques.pas.frm
//$res:growth=[project-home]growth.pas.frm
//$res:reports=[project-home]reports.pas.frm
//$res:counter=[project-home]counter.pas.frm
//$res:stale=[project-home]resources/nochange.png
//$res:gain=[project-home]resources/up.png
//$res:lost=[project-home]resources/down.png
//$res:tweetshadow=[project-home]resources/shadow.png
//$res:trendingcodes=[project-home]resources/trendingcodes.txt
//$res:splash=[project-home]resources/splash.jpg
//$res:addquery=[project-home]addquery.pas.frm
//$res:trending=[project-home]trending.pas.frm
//$res:delquery=[project-home]delquery.pas.frm
//$res:viewtweet=[project-home]viewtweet.pas.frm
//$res:newqueue=[project-home]newqueue.pas.frm
//$res:newtweet=[project-home]newtweet.pas.frm
//$res:reply=[project-home]reply.pas.frm
//$res:message=[project-home]message.pas.frm
//$res:fromaccounts=[project-home]fromaccounts.pas.frm
//$res:viewuser=[project-home]viewuser.pas.frm
//$res:viewimage=[project-home]viewimage.pas.frm
//$res:viewmessage=[project-home]viewmessage.pas.frm
//$res:action=[project-home]action.pas.frm
//$res:event=[project-home]event.pas.frm
//$res:accountman=[project-home]accountman.pas.frm
//$res:changepass=[project-home]changepass.pas.frm
//$res:mutelist=[project-home]mutelist.pas.frm
//$res:settings=[project-home]settings.pas.frm
//$res:about=[project-home]about.pas.frm
//$res:tweetgate=[project-home]resources/tweetgate.xap
//$res:sendcool=[project-home]resources/send-cool.jpg
//$res:sendfrown=[project-home]resources/send-frown.jpg
//$res:sendhelp=[project-home]resources/send-help.jpg
//$res:sendlike=[project-home]resources/send-like.jpg
//$res:sendlove=[project-home]resources/send-love.jpg
//$res:sendpro=[project-home]resources/send-pro.jpg
//$res:sendrequest=[project-home]resources/send-request.jpg
//$res:sendsmile=[project-home]resources/send-smile.jpg
