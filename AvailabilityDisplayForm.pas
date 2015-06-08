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
  private
    yearPings: TYearPings;
    displayDay: TDateTime;

    procedure LoadFile(fn: string);
    procedure loadText(text: string);
    procedure loadStrings(s: TStrings);
    procedure doPing;
    procedure say(s: string);
    function randomValue: integer;
    function valueToColor(v: integer): TColor;
    function getDayValue(d: TDateTime): integer;
    function getHourValue(d: TDateTime): integer;
    function getMinuteValue(d: TDateTime): integer;
    procedure setMinuteValue(d: TDateTime; v:integer);
  public

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
  if random(10)<1 then
    result:=0
  else
    result:=100+random(100);
 end;

function TForm1.valueToColor(v:integer):TColor;
 begin
   if v=-1 then result:=clWhite
   else if v=0 then result:=clRed
   else result:=RGB(v,200+(2*(100-v)),200);
 end;


(***************************************************************)

const thresholdForZeroDay = 5;

function TForm1.getDayValue(d:TDateTime):integer;
 var
  i,c,r,v,c0:integer; t:TDateTime;
 begin
  r:=-1;
  t:=d;
  c0:=0; // counter of zero values
  c:=0;
  result:=0;
  for i := 0 to 23 do
  begin
    t:=encodedatetime(yearof(d),monthof(d),dayof(d),i,0,0,0);
    v:=getHourValue(t);
    if v=0 then
     begin
      inc(c0);
      if c0>=thresholdForZeroDay then exit;
     end
    else if v<>-1 then
     begin
      inc(c);
      if r=-1 then r:=v else r:=r+v;
     end;
  end;
  result:=r div c;
 end;

const thresholdForZeroHour=10;
function TForm1.getHourValue(d:TDateTime):integer;
var  i,c,c0,r,v: Integer; t:TDateTime;
 begin
   r:=-1;
   t:=d;
   c0:=0;   // counter for zeros
   c:=0;
   result:=0;
   for i := 0 to 59 do
    begin
      t:=encodedatetime(yearof(d),monthof(d),dayof(d),hourof(d),i,0,0);
      v:=getMinuteValue(t);
      if v=0 then
       begin
        inc(c0);
        if c0>=thresholdForZeroHour then exit;
       end
      else if v<>-1 then
       begin
        inc(c);
        if r=-1 then r:=v else r:=r+v;
       end;
    end;
   if c<>0 then result:=r div c else result:=-1;
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
       paintboxCurrentMonth.Canvas.brush.color:=valueToColor(gethourvalue(cdc));
     paintboxCurrentMonth.Canvas.Rectangle(margin+h*(dotsize+1),d*(dotsize+1), margin-1+(h+1)*(dotsize+1),(d+1)*(dotsize+1)-1);
    end;
  end;
end;


procedure TForm1.PaintBoxMonthMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  w,d:integer;
  senderPaintbox:TPaintBox;
  fdm,fdc,cdc:TDateTime;
begin
  if (x>7*(dotsize+1)) or (y>6*(dotsize+1)) then
   exit;

  senderpaintbox:=Sender as TPaintbox;
  if senderpaintbox=paintboxmonth1 then
   fdm:=BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,today)))
  else if senderpaintbox=paintboxmonth2 then
   fdm:=BeginOfPrevious(iMonth,BeginOfPrevious(iMonth,today))
  else if senderpaintbox=paintboxmonth3 then
   fdm:=BeginOfPrevious(iMonth,today)
  else
   fdm:=BeginOf(iMonth,today);
  fdc:=beginof(iweek,fdm);

  d:=x div (dotsize+1);
  w:=y div (dotsize+1);

  cdc:=fdc+w*7+d;

  say(format('%.2d - %.2d  %s',[d,w,datetostr(cdc)]));

  displayDay:=trunc(cdc);
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
       senderPaintbox.Canvas.brush.color:=valueToColor(getDayValue(cdc))
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
var s:string; v:integer;
begin
  v:=randomValue;
  //pings.Add(inttostr(v));
  setminutevalue(now,v);
  say(inttostr(v));
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
         yearPings[mo,da][ho,mi]:=-1;

 cd:=encodedatetime(yearof(today),1,1,0,0,0,0);
 nd:=now;
 repeat
  cd:=incminute(cd);
  setminutevalue(cd,randomValue);
 until cd>nd;
 say(datetimetostr(cd));
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
