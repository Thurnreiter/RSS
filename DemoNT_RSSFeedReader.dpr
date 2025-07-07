program DemoNT_RSSFeedReader;

uses
  Vcl.Forms,
  Form.Main in 'Form.Main.pas' {Form1},
  System.Net.RSS.Feeds in 'System.Net.RSS.Feeds.pas',
  System.Net.RSS.Parser in 'System.Net.RSS.Parser.pas',
  System.Net.RSS.Gateway in 'System.Net.RSS.Gateway.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
