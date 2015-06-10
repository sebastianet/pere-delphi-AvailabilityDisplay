unit AvailabilityDisplayForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.DateUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.ComCtrls, pdatesw;

type

  TdayPings = array[0..23,0..59] of integer;
  TyearPings = array[1..12,1..31] of TdayPings;

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
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;

    procedure PaintBoxTodayPaint(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PaintBoxTodayMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure PaintBoxMonthPaint(Sender: TObject);
    procedure PaintBoxCurrentMonthPaint(Sender: TObject);
    procedure PaintBoxMonthMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxCurrentMonthMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PaintBoxCurrentMonthMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure PaintBoxMonthMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    yearPings: TYearPings;
    displayDay: TDateTime;

    procedure LoadFile(fn: string);
    procedure loadText(text: string);
    procedure loadStrings(s: TStrings);
    procedure doPing;
    procedure say(s:string);
    function randomValue: integer;
    function valueToColor(v: integer): TColor;
    function failCountToColor(c: integer): TColor;
    function getDayValue(d: TDateTime): integer;
    function getHourValue(d: TDateTime): integer;
    function getHourFailCount(d: TDateTime): integer;
    function getDayFailCount(d: TDateTime): integer;
    function getMinuteValue(d: TDateTime): integer;
    procedure setMinuteValue(d: TDateTime; v:integer);
    function monthXYtoDateTime(senderPaintbox: TPaintbox; x, y: integer): TDateTime;
    function failPercentageToColor(c: integer): TColor;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

(***************************************************************)
const dotsize=10; margin=10;

const PINGFAILED = 0;
const PINGNODATA = -1;

(***************************************************************)
function TForm1.randomValue:integer;
 begin
  if random(10)<1 then
    result:= PINGFAILED
  else
    result:=100+random(100);
 end;

function TForm1.valueToColor(v:integer):TColor;
 begin
   if v=PINGNODATA then result:=clWhite
   else if v=PINGFAILED then result:=clRed
   else result:=RGB(v,200+(2*(100-v)),200);
 end;

function TForm1.failPercentageToColor(c:integer): TColor;
 begin
  if c<0 then result:=clWhite
  else if c<=10 then result:=RGB(100+c*15,100-c*10,200-c*2)
  else if c<20 then result:=RGB(255,0,200-c*2)
  else result:=clRed;
 end;

function TForm1.failCountToColor(c: integer): TColor;
 begin
  if c=PINGNODATA then result:=clWhite
  else if c<=10 then result:=RGB(100+c*15,100-c*10,200-c*2)
  else if c<100 then result:=RGB(255,0,100-c)
  else result:=clRed;
 end;




(***************************************************************)

const thresholdForFailuresPerDay = 5;
const thresholdForFailuresPerHour=10;

function TForm1.getDayValue(d:TDateTime):integer;
 var
  i,c,r,v,cf:integer; t:TDateTime;
 begin
  r:=PINGNODATA;
  t:=d;
  cf:=0; // counter of ping fails
  c:=0;
  result:=PINGNODATA;
  for i:=0 to 23 do
  begin
    t:=encodedatetime(yearof(d),monthof(d),dayof(d),i,0,0,0);
    v:=getHourValue(t);
    if v=PINGFAILED then
     begin
      inc(cf);
      if cf>=thresholdForFailuresPerDay then exit;
     end
    else if v<>PINGNODATA then
     begin
      inc(c);
      if r=PINGNODATA then r:=v else r:=r+v;
     end;
  end;
  result:=r div c;
 end;

function TForm1.getHourValue(d:TDateTime):integer;
var  i,c,cf,r,v: Integer; t:TDateTime;
 begin
   r:=PINGNODATA;
   t:=d;
   cf:=0;   // counter for failures
   c:=0;
   result:=PINGFAILED;
   for i := 0 to 59 do
    begin
      t:=encodedatetime(yearof(d),monthof(d),dayof(d),hourof(d),i,0,0);
      v:=getMinuteValue(t);
      if v=PINGFAILED then
       begin
        inc(cf);
        if cf>=thresholdForFailuresPerHour then exit;
       end
      else if v<>PINGNODATA then
       begin
        inc(c);
        if r=PINGNODATA then r:=v else r:=r+v;
       end;
    end;
   if c<>0 then result:=r div c else result:=PINGNODATA;
 end;

function TForm1.getHourFailCount(d:TDateTime):integer;
var i,v:integer;  t:TDateTime;
 begin
  t:=d;
  result:=0;
  for i := 0 to 59 do
   begin
    t:=encodedatetime(yearof(d),monthof(d),dayof(d),hourof(d),i,0,0);
    v:=getMinuteValue(t);
    if v=PINGFAILED then inc(result);
   end;
 end;

function TForm1.getDayFailCount(d:TDateTime):integer;
var i:integer; t:TDateTime;
 begin
  t:=d;
  result:=0;
  for i:=0 to 23 do
   begin
    t:=encodedatetime(yearof(d),monthof(d),dayof(d),i,0,0,0);
    inc(result,getHourFailCount(t));
   end;
  if result<0 then result:=PINGNODATA;

 end;

function TForm1.getMinuteValue(d:TDateTime):integer;
 begin
   result:=yearpings[monthof(d),dayof(d)][hourof(d),minuteof(d)];
 end;

procedure TForm1.setMinuteValue(d: TDateTime; v:integer);
 begin
   yearpings[monthof(d),dayof(d)][hourof(d),minuteof(d)]:=v;
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
  v:=getminutevalue(today+encodetime(h,m,0,0));
  label1.caption:=format('%.2d:%.2d %d ',[h,m,v]);
end;

procedure TForm1.PaintBoxTodayPaint(Sender: TObject);
var
 h,m,v:integer;
 c:TColor;

begin
 label3.caption:=inttostr(dayOf(displayDay))+' '+FormatSettings.LongMonthNames[MonthOf(displayDay)]+' '+inttostr(YearOf(displayDay));

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
     v:=getminutevalue(displayDay+encodetime(h,m,0,0));
     c:=ValueToColor(v);
     PaintBoxToday.Canvas.brush.Color:=c;
     PaintBoxToday.Canvas.Rectangle(margin+m*(dotsize+1),margin+h*(dotsize+1), margin-1+(m+1)*(dotsize+1),margin-1+(h+1)*(dotsize+1));
    end;
  end;
end;

procedure TForm1.PaintBoxCurrentMonthMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var  d:integer;
 begin
  if (y>(daysInMonth(displayDay)+1)*(dotsize+1)) then exit;
  d:=y div (dotsize+1);
  displayDay:=EncodeDate(yearOf(displayDay),monthOf(displayDay),d);
  paintboxToday.repaint;
 end;


procedure TForm1.PaintBoxCurrentMonthMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var  d,h,c:integer;
 begin
  label8.caption:='';
  if (x<margin) or (y<margin) or (y>margin+(daysInMonth(displayDay))*(dotsize+1)) or (x>margin+24*(dotsize+1)) then exit;
  d:=1+(y-margin) div (dotsize+1);
  if d>daysInMonth(displayDay) then d:=daysInMonth(displayDay);
  h:=(x-margin) div (dotsize+1);
  if h>23 then h:=23;


  c:=getHourFailCount(EncodeDateTime(yearOf(displayDay),monthOf(displayDay),d,h,0,0,0));
  label8.caption:=format('%.2d@%.2d:00 %d %d%%',[d,h,c,trunc(100.0*c/60.0)]);

end;

procedure TForm1.PaintBoxCurrentMonthPaint(Sender: TObject);
var
  d,h: integer;
  fdm,cdc:TDateTime;
begin
 fdm:=trunc(beginOf(iMonth,displayDay));
 label2.caption:=FormatSettings.LongMonthNames[MonthOf(fdm)]+' '+inttostr(YearOf(fdm));

 paintboxCurrentMonth.Canvas.Pen.Style:=psSolid;
 paintboxCurrentMonth.Canvas.Pen.Color:=clBlack;
 paintboxCurrentMonth.Canvas.Font.Size:=6;
 for d := 1 to dayOf(endOf(iMonth,fdm)) do
  paintboxCurrentMonth.canvas.Textout(1,d*(dotsize+1),inttostr(d));

 for h := 0 to 24 do
  if (h=6) or (h=12) or (h=18) or (h=24) then
    paintboxCurrentMonth.canvas.Textout(margin+h*(dotsize+1),1,inttostr(h));

 paintboxCurrentMonth.Canvas.pen.Style:=psClear;
 for d := 1 to dayOf(endOf(iMonth,fdm)) do
  begin
   for h := 0 to 23 do
    begin
     cdc:=(fdm+d-1)+encodeTime(h,0,0,0);
     if cdc>now then
       paintboxCurrentMonth.Canvas.brush.color:=clWhite
     else
       //paintboxCurrentMonth.Canvas.brush.color:=valueToColor(gethourvalue(cdc));
       paintboxCurrentMonth.Canvas.brush.color:=failPercentageToColor(trunc(100.0*getHourFailCount(cdc)/60.0));
     paintboxCurrentMonth.Canvas.Rectangle(margin+h*(dotsize+1),d*(dotsize+1), margin-1+(h+1)*(dotsize+1),(d+1)*(dotsize+1)-1);
    end;
  end;
end;


function TForm1.monthXYtoDateTime(senderPaintbox:TPaintbox;x,y:integer):TDateTime;
 var
  fdm,fdc:TDateTime;
  d,w:integer;
 begin
  result:=0.0;
  if (x>7*(dotsize+1)) or (y>6*(dotsize+1)) then exit;

  if senderPaintbox=paintboxMonth1 then
   fdm:=BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,today)))
  else if senderPaintbox=paintboxMonth2 then
   fdm:=BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,today))
  else if senderPaintbox=paintboxMonth3 then
   fdm:=BeginOfPrevious(iMonth,today)
  else
   fdm:=BeginOf(iMonth,today);
  fdc:=beginOf(iweek,fdm);
  d:=x div (dotsize+1);
  w:=y div (dotsize+1);
  result:=fdc+w*7+d;
 end;

procedure TForm1.PaintBoxMonthMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
 var
  c:integer;
  d:TDateTime;
  senderPaintbox:TPaintBox;
 begin
  label8.caption:='';
  d:=monthXYtoDateTime(Sender as TPaintbox,x,y);
  if trunc(d)<>0 then
   begin
    c:=getDayFailCount(d);
    label8.caption:=format('%.2d/%.2d %d %d%%',[dayof(d),monthof(d),c,trunc(100.0*c/60.0/24.0)]);
   end;
end;

procedure TForm1.PaintBoxMonthMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  displayDay:=trunc(monthXYtoDateTime(Sender as TPaintbox,x,y));
  paintboxToday.repaint;
  paintboxCurrentMonth.repaint;
end;

procedure TForm1.PaintBoxMonthPaint(Sender: TObject);
var
  w,d: integer;
  fdm,fdc,cdc:TDateTime;
  senderPaintbox:TPaintBox;
  labelForThis:TLabel;

begin
 senderpaintbox:=Sender as TPaintbox;
 // first day of this month is...
 if senderpaintbox=paintboxmonth1 then
   fdm:=BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,today)))
 else if senderpaintbox=paintboxmonth2 then
   fdm:=BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,today))
 else if senderpaintbox=paintboxmonth3 then
   fdm:=BeginOfPrevious(iMonth,today)
 else
   fdm:=BeginOf(iMonth,today);
 if senderpaintbox=paintboxmonth1 then
   labelForThis:=Label4
 else if senderpaintbox=paintboxmonth2 then
   labelForThis:=Label5
 else if senderpaintbox=paintboxmonth3 then
   labelForThis:=Label6
 else
   labelForThis:=Label7;
 // first day of this calendar is ...
 fdc:=beginof(iweek,fdm);

// senderPaintbox.Canvas.Pen.Style:=psSolid;
// senderPaintbox.Canvas.Pen.Color:=clBlack;
 labelForThis.caption:=FormatSettings.LongMonthNames[MonthOf(fdm)]+' '+inttostr(YearOf(fdm));


 senderPaintbox.Canvas.brush.style:=bsSolid;
 senderPaintbox.Canvas.Pen.Style:=psClear;
 for w := 1 to 6 do
  begin
   for d := 1 to 7 do
    begin
     // current day of calendar is ...
     cdc:=fdc+(w-1)*7+d-1;
     if (monthOf(cdc)=monthOf(fdm)) and (cdc<now) then
       senderPaintbox.Canvas.brush.color:=failPercentageToColor(trunc(100.0*getDayFailCount(cdc)/60.0/24.0))
     else if (monthOf(cdc)<>monthOf(fdm)) then
       senderPaintbox.Canvas.brush.color:=clWhite
     else
       senderPaintbox.Canvas.brush.color:=clSilver;
     senderPaintbox.Canvas.Rectangle((d-1)*(dotsize+1),(w-1)*(dotsize+1),d*(dotsize+1)-1,w*(dotsize+1)-1);
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
var v:integer;
begin
  v:=randomValue;
  setminutevalue(now,v);
  paintboxtoday.repaint;
end;


(***************************************************************)
procedure TForm1.FormCreate(Sender: TObject);
var
 cd,nd:TDateTime;
 mo,da,ho,mi:integer;
begin
 //Pings := TStringList.Create;
 for mo := 1 to 12 do
   for da := 1 to 31 do
     for ho := 0 to 23 do
       for mi := 0 to 59 do
         yearPings[mo,da][ho,mi]:=PINGNODATA;

 cd:=encodedatetime(yearof(today),1,1,0,0,0,0);
 nd:=now;
 repeat
  cd:=incminute(cd);
  setminutevalue(cd,randomValue);
 until cd>nd;
 displayDay:=today;
end;

(***************************************************************)
procedure TForm1.LoadFile(fn:string);
var s:TStrings;
 begin
  s:=TStringList.Create;
  s.LoadFromFile(fn);
  loadStrings(s);
  s.Free;
 end;

procedure TForm1.loadStrings(s:TStrings);
var
  i: Integer;
  cd:TDateTime;
 begin
  cd:=encodedatetime(yearof(today),1,1,0,0,0,0);
  for i := 0 to s.Count-1 do
   begin
    setminutevalue(cd,strtoint(s[i]));
    cd:=incminute(cd);
   end;
 end;


procedure TForm1.loadText(text: string);
var s:TStrings;
 begin
  s:=TStringList.Create;
  s.setText(pWideChar(text));
  loadStrings(s);
  s.Free;
 end;

end.
