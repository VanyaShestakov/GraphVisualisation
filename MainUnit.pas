unit MainUnit;

interface

uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
    Vcl.Samples.Spin, Vcl.Menus, Vcl.Grids, System.Generics.Collections,System.RegularExpressions,
    Vcl.Imaging.jpeg, Vcl.ExtDlgs;

type
    Coords = record
        X: Integer;
        Y: Integer;
    end;
    VertexList = TList<Coords>;
    TMatrix = array of array of Byte;
  TMainForm = class(TForm)
    Visualizer: TImage;
    MatrixGrid: TStringGrid;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    MainMenu1: TMainMenu;
    About1: TMenuItem;
    File1: TMenuItem;
    Open1: TMenuItem;
    OrderSpinEdit: TSpinEdit;
    Label2: TLabel;
    Label1: TLabel;
    ShowGraphButton: TButton;
    Label3: TLabel;
    SavePictureDialog: TSavePictureDialog;
    procedure OrderSpinEditChange(Sender: TObject);
    procedure SetSize(Size: Byte);
    procedure FormCreate(Sender: TObject);
    procedure Open1Click(Sender: TObject);
    function CheckFile(): Boolean;
    procedure DrawVertexes(Amount: Integer; var VertexCoords: VertexList);
    procedure DrawLines(AdjMatrix: TMatrix; VertexCoords: VertexList);
    procedure DrawGraph(AdjMatrix: TMatrix);
    procedure ShowGraphButtonClick(Sender: TObject);
    procedure GetMatrixFromGrid(var Matrix: TMatrix);
    procedure DrawSpanningTree(VertexCoords: VertexList; AdjMatrix: TMatrix; Vertex: Integer);
    procedure ClearScreen();
    procedure InitUsed();
    procedure MatrixGridSetEditText(Sender: TObject; ACol, ARow: Integer;
      const Value: string);
    procedure About1Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;
  Used: array of Boolean;
const
    DEFAULT_WIDTH = 490;
    EXTENDED_WIDTH = 990;
    VERTEXES_COLOR = $00B3B300;
    BACKGROUND_COLOR = $001C1A13;
    TREE_COLOR =  $004F009D;
    POINT_RAD = 10;
    LINE_WIDTH = 5;
    GRAPH_RAD = 150;
    VERTEX_RAD = 30;
    FONT_SIZE = 20;

implementation

{$R *.dfm}

procedure TMainForm.DrawVertexes(Amount: Integer;var VertexCoords: VertexList);
var
    I, X, Y: Integer;
    Center: Coords;
    CurrPhi, Phi: Extended;
    CurrCoords: Coords;
begin
    VertexCoords := TList<Coords>.Create;
    Phi := (2 * Pi) / Amount;
    Center.X := Visualizer.Width div 2;
    Center.Y := Visualizer.Height div 2;
    with Visualizer.Canvas do
    begin
        Pen.Color := VERTEXES_COLOR;
        Pen.Width := 1;
        X := Center.X;
        Y := Center.Y;
        Font.Name := 'Segoe UI';
        Font.Style := [fsBold];
        Font.Color := VERTEXES_COLOR;
        Font.Height := FONT_SIZE;
        CurrPhi := 0;
        for I := 0 to Amount - 1 do
        begin
            Brush.Color := VERTEXES_COLOR;
            CurrPhi := CurrPhi + Phi;
            Y := Round(Center.Y - GRAPH_RAD * Sin(CurrPhi));
            X := Round(Center.X - GRAPH_RAD * Cos(CurrPhi));
            Ellipse(X - VERTEX_RAD, Y - VERTEX_RAD, X + VERTEX_RAD, Y + VERTEX_RAD);
            CurrCoords.X := X;
            CurrCoords.Y := Y;
            VertexCoords.Add(CurrCoords);
            Brush.Color := BACKGROUND_COLOR;
            if CurrPhi < Pi then
                TextOut(X - 5 , Y - 64, IntToStr(I + 1))
            else
                TextOut(X - 5, Y + 32, IntToStr(I + 1));
        end;
    end;
end;

procedure TMainForm.DrawLines(AdjMatrix: TMatrix; VertexCoords: VertexList);
var
    I, J: Byte;
    InciedenceList: TList;
    Line: String;
begin
    for I := 0 to High(AdjMatrix) do
    begin
        for J := 0 to High(AdjMatrix) do
        begin
            if AdjMatrix[I][J] = 1 then
            begin
                with Visualizer.Canvas do
                begin
                    Pen.Color := VERTEXES_COLOR;
                    Pen.Width := LINE_WIDTH;
                    MoveTo(VertexCoords.Items[I].X, VertexCoords.Items[I].Y);
                    LineTo(VertexCoords.Items[J].X, VertexCoords.Items[J].Y);
                end;
            end;
        end;
    end;
end;

procedure TMainForm.DrawGraph(AdjMatrix: TMatrix);
var
    VertexCoords: VertexList;
begin
    VertexCoords := TList<Coords>.Create;
    DrawVertexes(Length(AdjMatrix), VertexCoords);
    DrawLines(AdjMatrix, VertexCoords);
    DrawSpanningTree(VertexCoords, AdjMatrix, 0);
end;

procedure TMainForm.DrawSpanningTree(VertexCoords: VertexList; AdjMatrix: TMatrix; Vertex: Integer);
var
    I: integer;
begin
    Used[Vertex] := true;
    for i := 0 to High(AdjMatrix) do
        if (AdjMatrix[Vertex, I] = 1) and not Used[I] then
        begin
            with Visualizer.Canvas do
            begin
                Pen.Color := TREE_COLOR;
                Pen.Width := LINE_WIDTH;
                Brush.Color := TREE_COLOR;
                Ellipse(VertexCoords.Items[Vertex].X - POINT_RAD, VertexCoords.Items[Vertex].Y - POINT_RAD, VertexCoords.Items[Vertex].X + POINT_RAD, VertexCoords.Items[Vertex].Y + POINT_RAD);
                Ellipse(VertexCoords.Items[I].X - POINT_RAD, VertexCoords.Items[I].Y - POINT_RAD, VertexCoords.Items[I].X + POINT_RAD, VertexCoords.Items[I].Y + POINT_RAD);
                MoveTo(VertexCoords.Items[Vertex].X, VertexCoords.Items[Vertex].Y);
                LineTo(VertexCoords.Items[I].X, VertexCoords.Items[I].Y);
            end;
            DrawSpanningTree(VertexCoords, AdjMatrix, I);
        end;
end;


procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
     CanClose := MessageDlg('Are you sure you want to leave the program?', mtConfirmation, mbYesNo, 0) = mrYes;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
    OrderSpinEdit.Text := IntToStr(10);
    ClearScreen();
    MainForm.Width := DEFAULT_WIDTH;
end;

procedure TMainForm.ClearScreen();
begin
    with Visualizer.Canvas do
    begin
        Brush.Color := BACKGROUND_COLOR;
        Rectangle(0,0,Visualizer.Width,Visualizer.Height);
    end;
end;

procedure TMainForm.Open1Click(Sender: TObject);
var
    I, J: Integer;
    InputFile: TextFile;
    IsCorrect: Boolean;
    Buff: Integer;
begin
    IsCorrect := CheckFile();
    if IsCorrect then
    begin
        MainForm.Width := DEFAULT_WIDTH;
        AssignFile(InputFile,OpenDialog.FileName);
        Reset(InputFile);
        Readln(InputFile);
        for I := 1 to MatrixGrid.ColCount - 1  do
        begin
            for J := 1 to MatrixGrid.ColCount - 1  do
            begin
                Read(InputFile, Buff);
                MatrixGrid.Cells[J, I] := IntToStr(Buff);
            end;
            Readln(InputFile);
        end;
        CloseFile(InputFile);
    end;
end;

procedure TMainForm.About1Click(Sender: TObject);
begin
    MessageDlg('The graph is given by the adjacency matrix. The program finds a spanning tree in a graph using the depth-first search method.', mtInformation, [mbOK], 0);
end;

function TMainForm.CheckFile(): Boolean;
var
    Order: Integer;
    InputFile: TextFile;
    IsCorrect: Boolean;
    Buff: Integer;
    CountOfElements, CountOfLines: Integer;
begin
    IsCorrect := False;
    if OpenDialog.Execute then
    begin
        AssignFile(InputFile, OpenDialog.FileName);
        Reset(InputFile);
        CountOfElements := 0;
        CountOfLines := 0;
        IsCorrect := True;
        if not SeekEOF(InputFile) then
        begin
            try
                Readln(InputFile, Order);
            except
                IsCorrect := False;
            end;
            if IsCorrect and ((Order > 10) or (Order < 2)) then
            begin
                IsCorrect := False;
                MessageDlg('Incorrect order in your file!', mtError, [mbOK], 0);
            end;
            if IsCorrect then
            begin
                try
                    while not SeekEOF(InputFile) and IsCorrect do
                    begin
                        Read(InputFile, Buff);
                        IsCorrect := (Buff = 0) or (Buff = 1);
                        CountOfElements := CountOfElements + 1;
                        if SeekEOLN(InputFile) then
                            CountOfLines := CountOfLines + 1;
                    end;
                except
                    IsCorrect := False;
                end;
            end;
            if IsCorrect and (CountOfElements = Order * Order) and (CountOfLines = Order) then
            begin
                OrderSpinEdit.Text := IntToStr(Order);
            end
            else
            begin
                IsCorrect := False;
                MessageDlg('Incorrect data in the file or the matrix is entered incorrectly!', mtError, [mbOK], 0);
            end;
        end
        else
            MessageDlg('File is empty', mtError, [mbOK], 0);
        CloseFile(InputFile);
    end;
    CheckFile := IsCorrect;
end;

procedure TMainForm.OrderSpinEditChange(Sender: TObject);
begin
    SetSize(StrToInt(OrderSpinEdit.Text) + 1);
    MainForm.Width := DEFAULT_WIDTH;
end;

procedure TMainForm.SetSize(Size: Byte);
var
    I: Byte;
begin
    MatrixGrid.ColCount := Size;
    MatrixGrid.RowCount := Size;
    MatrixGrid.DefaultColWidth := MatrixGrid.Width div (StrToInt(OrderSpinEdit.Text) + 1) - 2;
    MatrixGrid.DefaultRowHeight := MatrixGrid.Height div (StrToInt(OrderSpinEdit.Text) + 1) - 2;
    MatrixGrid.Font.Height := 200 div StrToInt(OrderSpinEdit.Text);
    for I := 0 to Size - 1 do
    begin
        MatrixGrid.Rows[I].Clear;
        MatrixGrid.Cols[I].Clear;
    end;
    for I := 0 to Size - 1 do
    begin
        MatrixGrid.Cells[0, I + 1] := IntToStr(I + 1);
    end;
    for I := 0 to Size - 1 do
    begin
        MatrixGrid.Cells[I + 1, 0] := IntToStr(I + 1);
    end;
end;

procedure TMainForm.ShowGraphButtonClick(Sender: TObject);
var
    Matrix: TMatrix;
    Order: Byte;
    IsCorrect: Boolean;
    InciedenceList: TList;
begin
    IsCorrect := True;
    Order := StrToInt(OrderSpinEdit.Text);
    SetLength(Matrix, Order, Order);
    SetLength(Used, Order);
    try
        GetMatrixFromGrid(Matrix);
    except
        MessageDlg('Enter all values into the matrix!', mtError, [mbOK], 0);
        IsCorrect := False;
    end;
    if isCorrect then
    begin
        MainForm.Width := EXTENDED_WIDTH;
        ClearScreen;
        InitUsed;
        DrawGraph(Matrix);
    end;
end;

procedure TMainForm.InitUsed();
var
    I: Integer;
begin
    for I := 0 to High(Used) do
        Used[I] := False;
end;

procedure TMainForm.MatrixGridSetEditText(Sender: TObject; ACol, ARow: Integer;
  const Value: string);
begin
    if not TRegEx.IsMatch(Value, '^([01]{1})$') then
        MatrixGrid.Cells[ACol, ARow] := TRegEx.Match(Value, '^([01]{1})').Value;
    MainForm.Width := DEFAULT_WIDTH;
end;

procedure TMainForm.GetMatrixFromGrid(var Matrix: TMatrix);
var
    I, J: Byte;
begin
    for I := 0 to High(Matrix) do
        for J := 0 to High(Matrix) do
            Matrix[I][J] := StrToInt(MatrixGrid.Cells[J + 1 , I + 1]);
end;

end.
