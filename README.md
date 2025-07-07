# RSS Feed Parser Demo

This is a simple RSS Version 2.0 parser for Delphi. As result you get an list of array, with items
#### Sample
```delphi
uses
  System.Net.RSS.Feeds,
  System.Net.RSS.Parser,
  System.Net.RSS.Gateway,
...
var
  RSS_URL: string;
  FeedGateway: IFeedGateway;
begin
  RSS_URL := Edit1.Text; // Sample-RSS-Feed

  if (FeedGateway = nil) then
    FeedGateway := TFeedGateway.Create();

  LoadFeed(FeedGateway.GetFeed(RSS_URL));
end;


....



procedure LoadFeed(const AFeed: string);
var
  Idx: Integer;
  Parser: IFeedParser;
  FeedChannel: TFeedChannel;
begin
  Memo1.Lines.Clear;

  Parser := TFeedParser.Create;
  FeedChannel := Parser.ParseRSSFeed(AFeed);

  Memo1.Lines.Add('--RSS Feed--');
  Memo1.Lines.Add('Title: ' + FeedChannel.Title);
  Memo1.Lines.Add('Link: ' + FeedChannel.Link);
  Memo1.Lines.Add('Description: ' + FeedChannel.Description);
  Memo1.Lines.Add('Language: ' + FeedChannel.Language);
  Memo1.Lines.Add('Copyright: ' + FeedChannel.Copyright);
  Memo1.Lines.Add('PubDate: ' + FeedChannel.PubDate);
  Memo1.Lines.Add('  Channel AdvancedFields: BEGIN');
  for Idx := 0 to Length(FeedChannel.AdvancedFields) - 1 do
  begin
    Memo1.Lines.Add('    ' + FeedChannel.AdvancedFields[Idx].Key + ' : ' + FeedChannel.AdvancedFields[Idx].Value);
  end;
  Memo1.Lines.Add('      ->Title: ' + FeedChannel.Values['Title']);
  Memo1.Lines.Add('  Channel AdvancedFields: END');
  Memo1.Lines.Add('');

  Memo1.Lines.Add('--Channel Items--');
  for Idx := 0 to Length(FeedChannel.ChannelItems) - 1 do
  begin
    Memo1.Lines.Add('');
    Memo1.Lines.Add('Items-Title: ' + FeedChannel.ChannelItems[Idx].Title);
    Memo1.Lines.Add('Items-Link: ' + FeedChannel.ChannelItems[Idx].Link);
    Memo1.Lines.Add('Items-Description: ' + FeedChannel.ChannelItems[Idx].Description);
    Memo1.Lines.Add('  Items-AdvancedFields: BEGIN');
    for var I := 0 to High(FeedChannel.ChannelItems[Idx].AdvancedFields)  do
    begin
      Memo1.Lines.Add('    ' + FeedChannel.ChannelItems[Idx].AdvancedFields[I].Key + ' = ' + FeedChannel.ChannelItems[Idx].AdvancedFields[I].Value);
    end;
    Memo1.Lines.Add('      ->produktname: ' + FeedChannel.ChannelItems[Idx].Values['produktname']);
    Memo1.Lines.Add('  Items-AdvancedFields: END');
  end;
end;


```
