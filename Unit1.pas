unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    Memo3: TMemo;
    Memo4: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  //тип потока для обработки одного массива канала в блоке
TProcess=class(TThread)
private
  //с какого массива начинать обработку
  indBeg:integer;
  //сколько массивов надо обрабатывать
  numArr:integer;
  //номер процесса
  prNum:integer;
  //колич. обр точек в массиве
  numP:integer;
  writeNBlock:boolean;
  //вывод
  procedure OutRez;
protected
  procedure Execute; override;
public
  property ind: integer read indBeg write indBeg;
  property countArr: integer read numArr write numArr;
  property processNum:integer read prNum write prNum;
  property numPoint:integer read numP write numP;
end;

var
  Form1: TForm1;
  //массив процессов
  thGistArr:array of TProcess;
  count:integer;

  kkk:integer;
  cs:TRTLCriticalSection;

  arr:array [1..24] of integer;
implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
//выделяем память под переменную потока
SetLength(thGistArr,count+1);
//создаем поток
thGistArr[count]:=TProcess.Create(true);
thGistArr[count].Priority:=tpNormal;
thGistArr[count].prNum:=count;
thGistArr[count].numP:=1;
thGistArr[count].FreeOnTerminate:=true;
thGistArr[count].Resume;
inc(count);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
i:integer;
begin
for i:=1 to length(arr) do
  begin
    arr[i]:=i;
  end;
count:=0;
kkk:=0;
InitializeCriticalSection(cs);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
//выделяем память под переменную потока
SetLength(thGistArr,count+1);
//создаем поток
thGistArr[count]:=TProcess.Create(true);
thGistArr[count].Priority:=tpNormal;
thGistArr[count].prNum:=count;
thGistArr[count].numP:=2;
thGistArr[count].FreeOnTerminate:=true;
thGistArr[count].Resume;
inc(count);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
//выделяем память под переменную потока
SetLength(thGistArr,count+1);
//создаем поток
thGistArr[count]:=TProcess.Create(true);
thGistArr[count].Priority:=tpNormal;
thGistArr[count].prNum:=count;
thGistArr[count].numP:=3;
thGistArr[count].FreeOnTerminate:=true;
thGistArr[count].Resume;
inc(count);
end;


procedure TProcess.OutRez;
begin
  if prNum=0 then
    begin
      form1.Memo4.Lines.Add(intTostr(arr[24]));

    end
  else
    begin
      form1.Memo4.Lines.Add(intTostr(arr[24])+'!!!');
    end;
  
  case numP of
      1:
        begin
          form1.Memo1.Lines.Add(intTostr(arr[prNum+1])+' '+intToStr(prNum));
          inc(arr[prNum+1]);
        end;
      2:
        begin
          form1.Memo2.Lines.Add(intTostr(prNum));
        end;
      3:
        begin
          form1.Memo3.Lines.Add(intTostr(prNum));
        end;
    end;
end;




//==============================================================================
//
//==============================================================================
procedure TProcess.Execute;
var
i:integer;
begin
i:=0;
while i<=1000 do
  begin
    Sleep(1);
    //EnterCriticalSection(cs);
    Synchronize(OutRez);
    //kkk:=kkk+((prNum+1)*10);
    //LeaveCriticalSection(cs);
    inc(i);
  end;
end;
//==============================================================================

end.
