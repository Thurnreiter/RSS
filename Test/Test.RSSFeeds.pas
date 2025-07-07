unit Test.RSSFeeds;

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TTestTFeedChannel = class
  private
  public
    [Setup]
    procedure Setup;

    [TearDown]
    procedure TearDown;

    [Test]
    procedure Test_HasDefaultProperies;

    [Test]
    procedure Test_Implicit;

    [Test]
    procedure Test_AddAdvancedFields;

    [Test]
    procedure Test_CreateFeedChannelItem;

    [Test]
    procedure Test_AdvancedFieldsbyValueProperty;
  end;

implementation

uses
  System.Net.RSS.Feeds;

procedure TTestTFeedChannel.Setup;
begin
end;

procedure TTestTFeedChannel.TearDown;
begin
end;

procedure TTestTFeedChannel.Test_AddAdvancedFields;
var
  Cut: TFeedChannel;
begin
  Cut.AddAdvancedFields('1', '11');
  Cut.AddAdvancedFields('2', '22');
  Cut.AddAdvancedFields('3', '33');

  Assert.AreEqual('1', Cut.AdvancedFields[0].Key);
  Assert.AreEqual('11', Cut.AdvancedFields[0].Value);

  Assert.AreEqual('2', Cut.AdvancedFields[1].Key);
  Assert.AreEqual('22', Cut.AdvancedFields[1].Value);

  Assert.AreEqual('3', Cut.AdvancedFields[2].Key);
  Assert.AreEqual('33', Cut.AdvancedFields[2].Value);
end;

procedure TTestTFeedChannel.Test_HasDefaultProperies;
var
  Cut: TFeedChannel;
begin
  Cut.Description := 'Description';
  Cut.Link := 'Link';
  Cut.Title := 'Title';

  Assert.AreEqual('Title', Cut.Title);
  Assert.AreEqual('Description', Cut.Description);
  Assert.AreEqual('Link', Cut.Link);
end;

procedure TTestTFeedChannel.Test_Implicit;
var
  Cut: TFeedChannel;
begin
  //  Arrange...
  //  Act...
  Cut := 'Hallo Welt';  //  operator Implicit

  //  Assert...
  Assert.AreEqual('Hallo Welt', Cut.Title);
  Assert.AreEqual('4711', Cut.AdvancedFields[0].Key);
  Assert.AreEqual('Water', Cut.AdvancedFields[0].Value);
end;

procedure TTestTFeedChannel.Test_CreateFeedChannelItem;
var
  Cut: TFeedChannel;
  Idx: Integer;
begin
  //  Arrange...
  Cut := 'Hallo Welt';  //  operator Implicit

  //  Act...
  Idx := Cut.CreateFeedChannelItem;
  Cut.ChannelItems[Idx].Title := 'title';
  Cut.ChannelItems[Idx].Link := 'link';
  Cut.ChannelItems[Idx].Description := 'description';

  //  Assert...
  Assert.AreEqual('Hallo Welt', Cut.Title);
  Assert.AreEqual('description', Cut.ChannelItems[0].Description);
  Assert.AreEqual('title', Cut.ChannelItems[0].Title);
  Assert.AreEqual('link', Cut.ChannelItems[0].Link);
end;

procedure TTestTFeedChannel.Test_AdvancedFieldsbyValueProperty;
var
  Cut: TFeedChannel;
  Idx: Integer;
begin
  //  Arrange...
  Cut := 'Hallo Welt';  //  operator Implicit

  //  Act...
  Cut.AddAdvancedFields('AnyKeyName', '11');
  Idx := Cut.CreateFeedChannelItem;
  Cut.ChannelItems[Idx].Title := 'title';
  Cut.ChannelItems[Idx].Link := 'link';
  Cut.ChannelItems[Idx].Description := 'description';
  Cut.ChannelItems[Idx].AddAdvancedFields('AnyItemKeyName', '222');

  //  Assert...
  Assert.AreEqual('Hallo Welt', Cut.Title);
  Assert.AreEqual('4711', Cut.AdvancedFields[0].Key);
  Assert.AreEqual('Water', Cut.AdvancedFields[0].Value);
  Assert.AreEqual('11', Cut.Values['AnyKeyName']);

  Assert.AreEqual('Hallo Welt', Cut.Title);
  Assert.AreEqual('description', Cut.ChannelItems[0].Description);
  Assert.AreEqual('title', Cut.ChannelItems[0].Title);
  Assert.AreEqual('link', Cut.ChannelItems[0].Link);
  Assert.AreEqual('222', Cut.ChannelItems[0].Values['AnyItemKeyName']);
end;

initialization
  TDUnitX.RegisterTestFixture(TTestTFeedChannel);

end.
