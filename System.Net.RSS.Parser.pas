unit System.Net.RSS.Parser;

interface

uses
  System.SysUtils,
  System.Net.RSS.Feeds,
  Xml.XMLIntf;

type
  ERSSParserException = class(Exception);
  ERSSRequiredFieldException = class(Exception);

  IFeedParser = interface(IInvokable)
    ['{D206BC96-B72B-4BAE-8519-42108968BFCA}']
    procedure SetNotValidateException(AAction: TProc<TArray<string>, Exception>);

    function ParseRSSFeed(const AXmlContent: string): TFeedChannel;

    property OnNotValidateException: TProc<TArray<string>, Exception> write SetNotValidateException;
  end;

  TFeedParser = class(TInterfacedObject, IFeedParser)
  strict private
    FOnValidated: TProc<TArray<string>, Exception>;
    FListOfRequiredElements: TArray<string>;
  private
    const EX_RequiredField = 'Channel required fields not found.';
    const RequiredChannel_Title = 'channel.title';
    const RequiredChannel_Link = 'channel.link';
    const RequiredChannel_Description = 'channel.description';

  private
    procedure PrepareValidator;
    procedure Validator;
    function GetNodeFromName(const StartNode: IXmlNode; const Value: string): IXmlNode;
    function ProcessDoc(const XMLDoc: IXMLDocument): TFeedChannel;

    procedure SetNotValidateException(AAction: TProc<TArray<string>, Exception>);
  public
    constructor Create();
    destructor Destroy(); override;

    function ParseRSSFeed(const AXmlContent: string): TFeedChannel;
  end;


implementation

uses
  System.DateUtils,
  Xml.XMLDoc,
  Xml.xmldom,
  //  Xml.Win.msxmldom; // Windows: MSXML as DOM-Vendor
  Winapi.ActiveX;

{ TFeedParser }

constructor TFeedParser.Create;
begin
  inherited Create;
  //...
end;

destructor TFeedParser.Destroy;
begin
  SetLength(FListOfRequiredElements, 0);
  inherited;
end;

function TFeedParser.ParseRSSFeed(const AXmlContent: string): TFeedChannel;
var
  XMLDoc: IXMLDocument;
begin
  //  FeedChannel := 'hallo Welt';  //  operator Implicit
  //  Caption := FeedChannel.AdvancedFields[0].Key;

  XMLDoc := TXMLDocument.Create(nil);
  CoInitialize(nil);
  try
    XMLDoc := LoadXMLData(AXmlContent);
    XMLDoc.Active := True;
    Result := ProcessDoc(XMLDoc);
    XMLDoc.Active := False;
  finally
    CoUninitialize();
  end;
end;

function TFeedParser.GetNodeFromName(const StartNode: IXmlNode; const Value: string): IXmlNode;
var
  Node: IXmlNode;
begin
  if StartNode.NodeName.StartsWith(Value, True) then
  begin
    Exit(StartNode);
  end;

  Result := nil;

  for var Idx := 0 to StartNode.ChildNodes.Count - 1 do
  begin
    Node := StartNode.ChildNodes.Nodes[Idx];
    if Node.NodeName.StartsWith(Value, True) then
    begin
      Result := Node;
      Break;
    end
    else
    if (Node.HasChildNodes)
    and ((Node.ChildNodes.First.NodeType = ntElement) or (Node.ChildNodes.First.NodeType = ntText)) then
    begin
      Result := GetNodeFromName(Node, Value);
    end;

    if Assigned(Result) then
    begin
      Break;
    end;
  end;
end;

procedure TFeedParser.PrepareValidator;
begin
  SetLength(FListOfRequiredElements, 3);
  FListOfRequiredElements[0] := RequiredChannel_Title;
  FListOfRequiredElements[1] := RequiredChannel_Link;
  FListOfRequiredElements[2] := RequiredChannel_Description;
end;

procedure TFeedParser.Validator;
begin
  if (not Assigned(FOnValidated)) then
    Exit;

  if FListOfRequiredElements[0].IsEmpty
  or FListOfRequiredElements[1].IsEmpty
  or FListOfRequiredElements[2].IsEmpty then
  begin
    FOnValidated(FListOfRequiredElements, ERSSRequiredFieldException.Create(EX_RequiredField));
  end;
end;

function TFeedParser.ProcessDoc(const XMLDoc: IXMLDocument): TFeedChannel;
var
  Idx: Integer;
  Node: IXMLNode;
  RootNodeRss: IXMLNode;
  ChannelNode: IXMLNode;
  ItemNode: IXMLNode;
begin
  Result := '';
  PrepareValidator();
  try
    RootNodeRss := XMLDoc.DocumentElement;
    if (Assigned(RootNodeRss)) then
    begin
      //  Sample for another options:
      //  Result.Description := ChannelNode.ChildNodes.FindNode('description').Text;
      //  Result.Description := ChannelNode.ChildNodes['description'].Text;
      //  Result.Description := GetNodeFromName(ChannelNode, 'description').Text
      ChannelNode := RootNodeRss.ChildNodes.FindNode('channel');
      if (not Assigned(ChannelNode)) then
      begin
        Exit;
      end;

      Node := ChannelNode.ChildNodes.First;
      while (Assigned(Node)) do
      begin
        if (Node.NodeName.ToLower = 'title') then
        begin
          Result.Title := Node.Text;
          FListOfRequiredElements[0] := '';
        end
        else
        if (Node.NodeName.ToLower = 'link') then
        begin
          Result.Link := Node.Text;
          FListOfRequiredElements[1] := '';
        end
        else
        if (Node.NodeName.ToLower = 'description') then
        begin
          Result.Description := Node.Text;
          FListOfRequiredElements[2] := '';
        end
        else
        if (Node.NodeName.ToLower = 'language') then
        begin
          Result.Language := Node.Text;
        end
        else
        if (Node.NodeName.ToLower = 'copyright') then
        begin
          Result.Copyright := Node.Text;
        end
        else
        if (Node.NodeName.ToLower = 'pubdate') then
        begin
          Result.PubDate := Node.Text;
        end
        else
        if ((Node.NodeName.ToLower = 'image') and (Node.HasChildNodes)) then
        begin
          ItemNode := Node.ChildNodes.First();
          while (Assigned(ItemNode)) do
          begin
            if (ItemNode.NodeName.ToLower = 'title') then
            begin
              Result.Image.Title := ItemNode.Text;
            end
            else
            if (ItemNode.NodeName.ToLower = 'link') then
            begin
              Result.Image.Link := ItemNode.Text;
            end
            else
            if (ItemNode.NodeName.ToLower = 'url') then
            begin
              Result.Image.URL := ItemNode.Text;
            end;

            ItemNode := ItemNode.NextSibling();
          end;
        end
        else
        if ((Node.NodeName.ToLower = 'item') and (Node.HasChildNodes)) then
        begin
          Idx := Result.CreateFeedChannelItem;
          ItemNode := Node.ChildNodes.First();
          while (Assigned(ItemNode)) do
          begin
            if (ItemNode.NodeName.ToLower = 'description') then
            begin
              Result.ChannelItems[Idx].Description := ItemNode.Text;
            end
            else
            if (ItemNode.NodeName.ToLower = 'title') then
            begin
              Result.ChannelItems[Idx].Title := ItemNode.Text;
            end
            else
            if (ItemNode.NodeName.ToLower = 'link') then
            begin
              Result.ChannelItems[Idx].Link := ItemNode.Text;
            end
            else
            if (ItemNode.NodeName.ToLower = 'author') then
            begin
              Result.ChannelItems[Idx].Author := ItemNode.Text;
            end
            else
            if (ItemNode.NodeName.ToLower = 'guid') then
            begin
              Result.ChannelItems[Idx].Guid := ItemNode.Text;
            end
            else
            if (ItemNode.NodeName.ToLower = 'pubdate') then
            begin
              Result.ChannelItems[Idx].PubDate := System.DateUtils.RFC822ToDate(ItemNode.Text);
            end
            else
            begin
              Result.ChannelItems[Idx].AddAdvancedFields(ItemNode.NodeName, ItemNode.Text);
            end;

            ItemNode := ItemNode.NextSibling();
          end;
        end;

        Node := Node.NextSibling;
      end;
    end;
  except
    on Ex: Exception do //  on Ex: Exception do raise;
    begin
      raise ERSSParserException.CreateFmt('Failed to parse RSS: %s', [Ex.Message]);
    end;
  end;

  Validator;
end;

procedure TFeedParser.SetNotValidateException(AAction: TProc<TArray<string>, Exception>);
begin
  FOnValidated := AAction;
end;

end.
