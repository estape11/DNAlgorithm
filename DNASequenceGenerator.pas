program DNASequenceGenerator;
uses
  crt,sysutils;

var
  F1:TextFile;//El archivo donde va a almacenar la cadena
  len:integer;//La longitud de la cadena
  cadenaGenerada:string;//La cadena generada
  fileName:string;//Nombre del archivo a generar

//Genera una cadena de len longitud aleatoria
function DNASequenceGenerator(len: integer): string;
var
  n,valor : integer;
  cadena:string;
begin
     Randomize;
     n:=0;
     cadena:='';
     while n<len do
           begin
             valor:=random(4);
             if(valor=0) then
                         cadena+='A'
             else if(valor=1) then
                         cadena+='C'
             else if(valor=2) then
                         cadena+='T'
             else
                         cadena+='G';
             n+=1;
           end;
     DNASequenceGenerator:=cadena;
end;

//Main
begin
  try
    begin
      try
        begin
          write('Specify the length of the DNA sequence: ');
          readln(len);
        end;
      except
         begin
           len:=0;
         end;
      end;
    end;
  finally
    begin

    end;
  end;
  if(len<>0) then
    begin
      write('Type the name of the file: ');
      readln(fileName);
      cadenaGenerada:=DNASequenceGenerator(len);
      writeln();
      writeln('File '+fileName+' has been generated successfully with the following content:');
      writeln();
      writeln(cadenaGenerada);
      writeln();
      AssignFile(F1, fileName);
      Rewrite(F1);
      Writeln(F1, cadenaGenerada);
      CloseFile(F1);
      write('Press ENTER to close the program...');
    end
  else
    begin
        write('Invalid input, re-open the program, press ENTER to close the program...');
        readln;
    end;
  readln;
end.

