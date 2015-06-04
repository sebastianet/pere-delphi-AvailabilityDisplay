unit AvailabilityDisplayForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, pdatesw;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    OpenDialog1: TOpenDialog;
    Button1: TButton;
    Timer1: TTimer;
    Button2: TButton;
    Button3: TButton;
    ListBox1: TListBox;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    PaintBoxToday: TPaintBox;
    Panel3: TPanel;
    PaintBoxMonth1: TPaintBox;
    PaintBoxMonth2: TPaintBox;
    PaintBoxMonth3: TPaintBox;
    PaintBoxCurrentMonth: TPaintBox;
    PaintBoxMonth4: TPaintBox;

    procedure PaintBoxTodayPaint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PaintBoxTodayMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxTodayMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxMonthPaint(Sender: TObject);
    procedure PaintBoxCurrentMonthPaint(Sender: TObject);
  private
    pings: TStrings;

    procedure LoadFile(fn: string);
    procedure loadArray(a: array of integer);
    procedure loadText(text: string);
    procedure doPing;
    procedure say(s: string);
    function randomValue: integer;
    function valueToColor(v: integer): TColor;
    function getDayValue(d: TDateTime): integer;
    function getHourValue(d: TDateTime): integer;
    function getMinuteValue(d: TDateTime): integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

(***************************************************************)
const dotsize=10; margin=10;


(***************************************************************)
function TForm1.randomValue:integer;
 begin
  if random(5)<1 then
    result:=0
  else
    result:=100+random(100);
 end;

function TForm1.valueToColor(v:integer):TColor;
 begin
   if v=0 then result:=clRed else result:=RGB(0,0,v);
 end;


(***************************************************************)
function TForm1.getDayValue(d:TDateTime):integer;
 begin
   result:=randomValue;
 end;

function TForm1.getHourValue(d:TDateTime):integer;
 begin
   result:=randomValue;
 end;

function TForm1.getMinuteValue(d:TDateTime):integer;
 begin
   result:=randomValue;
 end;

(***************************************************************)
procedure TForm1.Button1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
   begin
     loadFile(openDialog1.FileName);
     caption:=OpenDialog1.FileName;
   end;
end;

procedure tForm1.say(s:string);
 var m:string;
 begin
  DateTimeToString(m, 'hh:nn:ss.zzz', now);
  m:=m+' '+s;
  Listbox1.items.add(m);
  Listbox1.Itemindex:=Listbox1.Items.Count-1;
 end;

procedure TForm1.PaintBoxTodayMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var i,h,m,v:integer;
begin
  if (x<margin) or (y<margin) or (x>61*(dotsize+1)) or (y>25*(dotsize+1)) then
   exit;

  m:=(x-margin) div (dotsize+1);
  h:=(y-margin) div (dotsize+1);
  i:=h*60+m;
  v:=-1;
  if i<pings.count then v:=strtoint(pings[i]);
  say(format('%.2d:%.2d  %d',[h,m,v]));
end;

procedure TForm1.PaintBoxTodayMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var i,h,m,v:integer;
begin
  label1.caption:='';
  if (x<margin) or (y<margin) or (x>61*(dotsize+1)) or (y>25*(dotsize+1)) then
   exit;

  m:=(x-margin) div (dotsize+1);
  h:=(y-margin) div (dotsize+1);
  i:=h*60+m;
  v:=-1;
  if i<pings.count then v:=strtoint(pings[i]);
  label1.caption:=format('%.2d:%.2d  %d',[h,m,v]);
end;

procedure TForm1.PaintBoxTodayPaint(Sender: TObject);
var
 h,m,i,v:integer;
 c:TColor;

begin

 // margins and numbers
 PaintBoxToday.Canvas.brush.style:=bsClear;
 PaintBoxToday.Canvas.Font.Size:=6;
 for m := 0 to 60 do
  if (m=0) or (m=15) or (m=30) or (m=45) or (m=60) then
    PaintBoxToday.canvas.Textout(margin+m*(dotsize+1),1,inttostr(m));
//   paintbox1.canvas.Textout(margin+m*(dotsize+1),1,inttostr(m));
 for h := 0 to 24 do
   if (h=0) or (h=6) or (h=12) or (h=18) or (h=24) then
     PaintBoxToday.canvas.Textout(1,margin+h*(dotsize+1),inttostr(h));
   //paintbox1.canvas.Textout(1,margin+h*(dotsize+1),inttostr(h));


 PaintBoxToday.Canvas.brush.style:=bsSolid;
 PaintBoxToday.Canvas.Pen.Style:=psClear;
 for h := 0 to 23 do
  begin
   for m := 0 to 59 do
    begin
     i:=h*60+m;
     if i<pings.Count then
      begin
       v:=strtoint(pings[i]);
       c:=ValueToColor(v);
       PaintBoxToday.Canvas.brush.Color:=c;
      end
     else
      begin
       PaintBoxToday.Canvas.brush.color:=clWhite;
      end;
     PaintBoxToday.Canvas.Rectangle(margin+m*(dotsize+1),margin+h*(dotsize+1), margin-1+(m+1)*(dotsize+1),margin-1+(h+1)*(dotsize+1));
    end;
  end;
end;

procedure TForm1.PaintBoxCurrentMonthPaint(Sender: TObject);
var
  d,h: integer;
  fdm,cdc:TDateTime;
begin
 fdm:=trunc(beginOf(iMonth,today));
 paintboxCurrentMonth.Canvas.Pen.Style:=psSolid;
 paintboxCurrentMonth.Canvas.Pen.Color:=clBlack;
 paintboxCurrentMonth.canvas.Textout(1,1,FormatSettings.LongMonthNames[MonthOf(fdm)]+' '+inttostr(YearOf(fdm)));

 paintboxCurrentMonth.Canvas.Font.Size:=6;
 for d := 1 to dayOf(endOf(iMonth,fdm)) do
  paintboxCurrentMonth.canvas.Textout(1,margin+d*(dotsize+1),inttostr(d));

 for h := 0 to 24 do
  if (h=6) or (h=12) or (h=18) or (h=24) then
    paintboxCurrentMonth.canvas.Textout(margin+h*(dotsize+1),dotsize,inttostr(h));

 paintboxCurrentMonth.Canvas.pen.Style:=psClear;
 for d := 1 to dayOf(endOf(iMonth,fdm)) do
  begin
   for h := 0 to 23 do
    begin
     cdc:=(fdm+d-1)+encodeTime(h,0,0,0);
     if cdc>trunc(now) then
       paintboxCurrentMonth.Canvas.brush.color:=clWhite
     else
       paintboxCurrentMonth.Canvas.brush.color:=valueToColor(gethourvalue(cdc));
     paintboxCurrentMonth.Canvas.Rectangle(margin+h*(dotsize+1),margin+d*(dotsize+1), margin-1+(h+1)*(dotsize+1),margin-1+(d+1)*(dotsize+1));
    end;
  end;
end;


procedure TForm1.PaintBoxMonthPaint(Sender: TObject);
var
  w,d: integer;
  fdm,fdc,cdc:TDateTime;
  senderpaintbox:TPaintBox;
begin
 senderpaintbox:=Sender as TPaintbox;
 // first day of this month is...
 if senderpaintbox=paintboxmonth1 then
   fdm:=BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,now)))
 else if senderpaintbox=paintboxmonth2 then
   fdm:=BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,now))
 else if senderpaintbox=paintboxmonth3 then
   fdm:=BeginOfPrevious(iMonth,now)
 else
   fdm:=now;
 // first day of this calendar is ...
 fdc:=beginof(iweek,fdm);

 senderPaintbox.Canvas.Pen.Style:=psSolid;
 senderPaintbox.Canvas.Pen.Color:=clBlack;
 senderPaintbox.canvas.Textout(1,1,FormatSettings.LongMonthNames[MonthOf(fdm)]+' '+inttostr(YearOf(fdm)));

 senderPaintbox.Canvas.brush.style:=bsSolid;
 senderPaintbox.Canvas.Pen.Style:=psClear;

 for w := 1 to 6 do
  begin
   for d := 1 to 7 do
    begin
     // current day of calendar is ...
     cdc:=fdc+(w-1)*7+d-1;
     if (monthOf(cdc)=monthOf(fdm)) and (cdc<now) then
       senderPaintbox.Canvas.brush.color:=valueToColor(getDayValue(cdc))
     else if (monthOf(cdc)<>monthOf(fdm)) then
       senderPaintbox.Canvas.brush.color:=clWhite
     else
       senderPaintbox.Canvas.brush.color:=clGray;
     senderPaintbox.Canvas.Rectangle((d-1)*(dotsize+1),margin+w*(dotsize+1),d*(dotsize+1)-1,margin-1+(w+1)*(dotsize+1));
    end;
  end;
end;

(***************************************************************)
procedure TForm1.Timer1Timer(Sender: TObject);
begin
  doPing;
end;


(***************************************************************)
procedure TForm1.Button2Click(Sender: TObject);
begin
  Timer1.Enabled:=true;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Timer1.Enabled:=false;
end;

(***************************************************************)
procedure TForm1.doPing;
var s:string; v:integer;
begin
  v:=randomValue;
  pings.Add(inttostr(v));
  say(inttostr(v));
  paintboxtoday.repaint;
end;

(***************************************************************)
procedure TForm1.FormCreate(Sender: TObject);
var i:integer;
 n:TDateTime;
 h,m:integer;
begin
 Pings := TStringList.Create;
 n:=now;
 for i:=1 to hourof(n)*60+minuteof(n) do doPing;
end;

procedure TForm1.loadArray(a: array of integer);
begin

end;

(***************************************************************)
procedure TForm1.LoadFile(fn:string);
var s:TStrings;
 begin
  s:=TStringList.Create;
  s.LoadFromFile(fn);
  loadText(s.Text);
 end;

procedure TForm1.loadText(text:string);
 begin
  pings.SetText(pWideChar(text));
 end;


end.
