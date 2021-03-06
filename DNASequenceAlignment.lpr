program DNASequenceAlignment;

uses
    crt,sysutils;

const
  match_award= 10;
  mismatch_penalty= -5;
  gap_penalty= -5;

var
  F1,F2:TextFile; //Archivos donde se cargaran las secuencias
  matrizScore:array of array of integer; //Matriz de relacion entre las secuencias
  Fila,Columna:integer; //Para realizar el manejo de la matriz
  m,n:integer; //Almacena la longitud de las las secuencias
  fileName1,fileName2,cade1,cade2:string; //Las direcciones de los archivos y las cadenas a utilizar en la alineacion
  result:array of string; //Guarda el resultado de la alineacion
  matrixS:array[0..4,0..4] of integer; //Matriz de similaridad

//Definicion de algunos tipos para facilidad
type stringArray= array of string;
type integerMatriz = array of array of integer;

//Imprime una matriz de enteross
function printMatrix(ma:integerMatriz):integer;
var
  i,j:integer;
begin
  for i:=0 to m-1 do
      begin
        for j:=0 to n-1 do
            begin
              write(ma[i,j],',');
            end;
        writeln();
      end;
end;

//Invierte un string
function invertirString(str:string):string;
var
  strTemp:string;
  i:integer;
begin
  i:=Length(str);
  strTemp:='';
  while(i>0) do
    begin
      strTemp:=strTemp+str[i];
      i:=i-1;
    end;
  invertirString:=strTemp;
end;

//Devuelve el valor maximo de tres numeros
function max(d1,d2,d3:integer):integer;
begin
  if(d1>=d2) then
    begin
      if(d1>=d3) then
        max:=d1
      else
        max:=d3;
    end
  else if(d2>=d1) then
    begin
      if(d2>=d3) then
        max:=d2
      else
        max:=d3;
    end;
end;

//Devuelve una matriz MxN llena de ceros
function fillCeros(): integerMatriz;
var
  matrizTemp:integerMatriz;
begin
  SetLength(matrizTemp, m, n);
  for Fila:=0 to m-1 do
      begin
        for Columna:=0 to n-1 do
            begin
                matrizTemp[Fila,Columna]:=0;
            end;
      end;
  fillCeros:=matrizTemp;
end;

//Realiza el match entre las secuencias
function matchScore(dato1:string;dato2:string):integer;
var
  i,j:integer;
begin
  if(dato1='A') then
    i:=0
  else if(dato1='G') then
    i:=1
  else if(dato1='C') then
    i:=2
  else if(dato1='T') then
    i:=3
  else
    matchScore:=gap_penalty;
  if(dato2='A') then
    j:=0
  else if(dato2='G') then
    j:=1
  else if(dato2='C') then
    j:=2
  else if(dato2='T') then
    j:=3
  else
    matchScore:=gap_penalty;
  matchScore:=matrixS[i,j];

end;

//Realiza la alineacion de secuencias con el algoritmo de Needleman-Wunsch
function DNASequenceAlignment(seq1:string;seq2:string):stringArray;
var
  align1,align2:string;
  returnTemp:stringArray;
  i,j,match,delete,insert,sActual,sDiagonal,sArriba,sIzqu:integer;
begin
  //Definicion de la matriz de similaridad
  matrixS[0,0]:=10;matrixS[0,1]:=-1;matrixS[0,2]:=-3;matrixS[0,3]:=-4;
  matrixS[1,0]:=-1;matrixS[1,1]:=7;matrixS[1,2]:=-5;matrixS[1,3]:=-3;
  matrixS[2,0]:=-3;matrixS[2,1]:=-5;matrixS[2,2]:=9;matrixS[2,3]:=0;
  matrixS[3,0]:=-4;matrixS[3,1]:=-3;matrixS[3,2]:=0;matrixS[3,3]:=8;
  m:=length(seq1)+1;
  n:=length(seq2)+1;
  SetLength(returnTemp,2);
  matrizScore:=fillCeros();
  for i:=0 to m-1 do
      begin
         matrizScore[i,0]:=gap_penalty*i;
      end;
  for j:=0 to n-1 do
      begin
        matrizScore[0,j]:=gap_penalty*j;
      end;
  for i:=1 to m-1 do
      begin
        for j:=1 to n-1 do
            begin
              match:=matrizScore[i-1,j-1]+matchScore(seq1[i],seq2[j]);
              delete:=matrizScore[i-1,j]+gap_penalty;
              insert:=matrizScore[i,j-1]+gap_penalty;
              matrizScore[i,j]:=max(match,delete,insert);
            end;
      end;
  align1:='';
  align2:='';
  i:=m-1;
  j:=n-1;
  while((i>0) and (j>0))do
    begin
      sActual:=matrizScore[i,j];
      sDiagonal:=matrizScore[i-1,j-1];
      sArriba:=matrizScore[i,j-1];
      sIzqu:=matrizScore[i-1,j];
      if(sActual=(sDiagonal+matchScore(seq1[i],seq2[j]))) then
        begin
          align1:=seq1[i]+align1;
          align2:=seq2[j]+align2;
          i:=i-1;
          j:=j-1;
        end
      else if(sActual=(sIzqu+gap_penalty)) then
        begin
          align1:=seq1[i]+align1;
          align2:='-'+align2;
          i:=i-1;
        end
      else
        begin
          align1:='-'+align1;
          align2:=seq2[j]+align2;
          j:=j-1;
        end;
    end;
  while(i>0) do
    begin
      align1:=seq1[i]+align1;
      align2:='-'+align2;
      i:=i-1;
    end;
  while(j>0) do
    begin
      align1:='-'+align1;
      align2:=seq2[j]+align2;
      j:=j-1;
    end;
  returnTemp[0]:=align1;
  returnTemp[1]:=align2;
  DNASequenceAlignment:=returnTemp;
end;

//Main
begin
  try
    begin
      try
        begin
          fileName1:=ParamStr(1);fileName2:=ParamStr(2);
          AssignFile(F1, fileName1);AssignFile(F2, fileName2);
          reset(F1);reset(F2);
          read(F1,cade1);read(F2,cade2);
          CloseFile(F1);CloseFile(F2);
          result:=DNASequenceAlignment(cade1,cade2);
          writeln('The Global alignment has been performed:');
          writeln();
          writeln(result[0]);
          writeln(result[1]);
        end;
      except
        begin
          writeln('Invalid files, please check and try again');
        end;
      end;
    end;
  finally
    begin
    end;
  end;
  write('Press ENTER to close the program...');
  readln;
end.
