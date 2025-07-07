unit System.Net.RSS.Gateway;

interface

//uses
//  System.Net.URLClient; TUri

type
  IFeedGateway = interface(IInvokable)
    ['{BFB062C9-D343-405D-B88F-A5147370913C}']
    function GetFeed(const AURI: string): string;
  end;

  TFeedGateway = class(TInterfacedObject, IFeedGateway)
  public
    constructor Create();
    destructor Destroy(); override;

    function GetFeed(const AURI: string): string;
  end;

implementation

uses
  System.Classes,
  System.SysUtils,
  System.Net.HttpClient,
  System.Net.URLClient,
  System.NetEncoding;

{ TFeedGateway }

constructor TFeedGateway.Create;
begin
  inherited;
  //...
end;

destructor TFeedGateway.Destroy;
begin
  //...
  inherited;
end;

function TFeedGateway.GetFeed(const AURI: string): string;
var
  HttpClient: THTTPClient;
  Response: IHttpResponse;
  SS: TStringStream;
begin
  SS := TStringStream.Create('');
  HttpClient := THTTPClient.Create;
  try
    //    HttpClient.ContentType := 'application/x-www-form-urlencoded';
    HttpClient.Accept := 'application/rss+xml';

    Response := HttpClient.Get(AURI, SS);
    if Response.StatusCode = 200 then
    begin
      // Process the RSS feed data from the stream
      Result := SS.DataString;
    end
    else
    begin
      // Handle the error (e.g., HTTP status code not 200)
      Result := string.Empty;
    end;
  finally
    SS.Free();
    HttpClient.Free();
  end;
end;

end.
