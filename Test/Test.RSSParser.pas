unit Test.RSSParser;

interface

uses
  DUnitX.TestFramework,
  System.Net.RSS.Parser;

type
  [TestFixture]
  TMyTestObject = class
  private
    FSut: IFeedParser;
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test1;

//    [Test]
//    [TestCase('TestA','1,2')]
//    [TestCase('TestB','3,4')]
//    procedure Test2(const AValue1 : Integer;const AValue2 : Integer);
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils,
  System.Net.RSS.Feeds;

procedure TMyTestObject.Setup;
begin
  FSut := TFeedParser.Create;
end;

procedure TMyTestObject.TearDown;
begin
  FSut := nil;
end;

procedure TMyTestObject.Test1;
var
  Return: TFeedChannel;
begin
  //  Arrange...
  //  Act...
  Return := FSut.ParseRSSFeed(TFile.ReadAllText('.\..\..\dummy.rss'));

  //  Assert...
  Assert.AreEqual('Titel des Feeds', Return.Title);
  Assert.AreEqual('Kurze Beschreibung des Feeds', Return.Description);
  Assert.AreEqual('URL der Webpräsenz', Return.Link);
  Assert.AreEqual(3, Length(Return.ChannelItems));

  for var Idx := 0 to Length(Return.AdvancedFields) - 1 do
  begin
    Assert.AreEqual('4711', Return.AdvancedFields[Idx].Key);
    Assert.AreEqual('Water', Return.AdvancedFields[Idx].Value);
  end;

  //  for var Idx := 0 to Length(Return.ChannelItems) - 1 do
  Assert.AreEqual('Das neue Live-News-Widget ist da!', Return.ChannelItems[0].Title);
  Assert.AreEqual('', Return.ChannelItems[0].Description);
  Assert.AreEqual('https://www.immo.ch/post-2/das-neue-live-news-widget-ist-da/', Return.ChannelItems[0].Link);
  Assert.AreEqual(3, Length(Return.ChannelItems));

  //    for var I := 0 to High(Return.ChannelItems[Idx].AdvancedFields)  do
  Assert.AreEqual('id', Return.ChannelItems[0].AdvancedFields[0].Key);
  Assert.AreEqual('24292', Return.ChannelItems[0].AdvancedFields[0].Value);
  Assert.AreEqual(8, High(Return.ChannelItems[0].AdvancedFields));
  Assert.AreEqual(8, High(Return.ChannelItems[1].AdvancedFields));
end;

//procedure TMyTestObject.Test2(const AValue1 : Integer;const AValue2 : Integer);
//begin
//end;

initialization
  TDUnitX.RegisterTestFixture(TMyTestObject);

end.
