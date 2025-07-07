unit System.Net.RSS.Feeds;

interface

{$REGION 'Infos'}
//  https://www.rssboard.org/rss-specification#requiredChannelElements
//  https://www.rssboard.org/rss-draft-1
//  https://docwiki.embarcadero.com/RADStudio/Athens/de/Benutzerdefinierte_verwaltete_Records
//  https://de.wikipedia.org/wiki/RSS_(Web-Feed)
//  https://blog.marcocantu.com/blog/2018-november-custom-managed-records-delphi.html
{$ENDREGION}

uses
  System.Generics.Collections;

type
  TFeedChannelItem = record
  strict private
    FDescription: string;
    FTitle: string;
    FLink: string;
    FPubDate: TDateTime;
    //    DAuthor, FCategory, FComments, FEnclosure, FGuid, FPubDate, FSource  ... more fields
    FAdvancedFields: TArray<TPair<string, string>>;
  private
    function GetValueByName(const AKeyName: string): string;
  public
    property Description: string read FDescription write FDescription;
    property Title: string read FTitle write FTitle;
    property Link: string read FLink write FLink;
    property PubDate: TDateTime read FPubDate write FPubDate;
    property AdvancedFields: TArray<TPair<string, string>> read FAdvancedFields;
    property Values[const AName: string]: string read GetValueByName; default;

    procedure AddAdvancedFields(const AKey: string; const AValue: string); overload;
    procedure AddAdvancedFields(AValue: TPair<string, string>); overload;
  end;

  TFeedChannel = record
  strict private
    FDescription: string;
    FLink: string;
    FTitle: string;
    FLanguage: string;
    FCopyright: string;
    FPubDate: string;
    FAdvancedFields: TArray<TPair<string, string>>;

    FChannelItems: TArray<TFeedChannelItem>;
  private
    function GetValueByName(const AKeyName: string): string;
  public
    class operator Implicit(const AData: string): TFeedChannel;

    procedure AddAdvancedFields(const AKey: string; const AValue: string); overload;
    procedure AddAdvancedFields(AValue: TPair<string, string>); overload;
    function CreateFeedChannelItem(): Integer;

    property Description: string read FDescription write FDescription;
    property Link: string read FLink write FLink;
    property Title: string read FTitle write FTitle;
    property Language: string read FLanguage write FLanguage;
    property Copyright: string read FCopyright write FCopyright;
    property PubDate: string read FPubDate write FPubDate;

    property AdvancedFields: TArray<TPair<string, string>> read FAdvancedFields;

    property ChannelItems: TArray<TFeedChannelItem> read FChannelItems write FChannelItems;
    property Values[const AName: string]: string read GetValueByName; default;
  end;

implementation

uses
  System.SysUtils;

{ TFeedChannelItem }

procedure TFeedChannelItem.AddAdvancedFields(const AKey, AValue: string);
begin
  AddAdvancedFields(TPair<string, string>.Create(AKey, AValue));
end;

procedure TFeedChannelItem.AddAdvancedFields(AValue: TPair<string, string>);
begin
  SetLength(FAdvancedFields, (Length(FAdvancedFields) + 1));
  FAdvancedFields[High(FAdvancedFields)] := AValue;
end;

function TFeedChannelItem.GetValueByName(const AKeyName: string): string;
begin
  Result := '';
  for var Idx := Low(FAdvancedFields) to High(FAdvancedFields) do
  begin
    if (FAdvancedFields[Idx].Key.ToLower = AKeyName.ToLower) then
    begin
      Exit(FAdvancedFields[Idx].Value);
    end;
  end;
end;

{ TFeedChannel }

class operator TFeedChannel.Implicit(const AData: string): TFeedChannel;
begin
  Result := Default(TFeedChannel);  //  Init my record...
  Result.Title := AData;
  Result.AddAdvancedFields('4711', 'Water');
end;

procedure TFeedChannel.AddAdvancedFields(const AKey, AValue: string);
begin
  AddAdvancedFields(TPair<string, string>.Create(AKey, AValue));
end;

procedure TFeedChannel.AddAdvancedFields(AValue: TPair<string, string>);
begin
  SetLength(FAdvancedFields, (Length(FAdvancedFields) + 1));
  FAdvancedFields[High(FAdvancedFields)] := AValue;
end;

function TFeedChannel.CreateFeedChannelItem(): Integer;
begin
  SetLength(FChannelItems, (Length(FChannelItems) + 1));
  Result := High(FChannelItems);
end;

function TFeedChannel.GetValueByName(const AKEyName: string): string;
begin
  Result := '';
  for var Idx := Low(FAdvancedFields) to High(FAdvancedFields) do
  begin
    if (FAdvancedFields[Idx].Key.ToLower = AKeyName.ToLower) then
    begin
      Exit(FAdvancedFields[Idx].Value);
    end;
  end;
end;

end.
