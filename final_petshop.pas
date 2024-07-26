PROGRAM final_petshop;
USES crt;

TYPE
    articulos = RECORD
     codigo_articulo: integer;
     descripcion: string[30];
     stock: integer;
     stock_minimo: integer;
     importes: array[1..2]of real;
     categoria: char;
     codigo_proveedor: integer;
    END;

    proveedores = RECORD
     codigo_proveedor: integer;
     nombre_apellido: string[30];
     mail: string[45];
    END;

VAR
   archivo_articulos: FILE OF articulos;
   archivo_proveedores: FILE OF proveedores;
   registro_articulos: articulos;
   registro_proveedores: proveedores;

PROCEDURE crea_archivo_articulos;
 BEGIN
 rewrite(archivo_articulos);
 close(archivo_articulos);
 END;

PROCEDURE crea_archivo_proveedores;
 BEGIN
 rewrite(archivo_proveedores);
 close(archivo_proveedores);
 END;

FUNCTION verificar_estado_archivo_articulos(): boolean;
 BEGIN
 IF filesize(archivo_articulos) = 0 THEN
  verificar_estado_archivo_articulos:= true
 ELSE
  verificar_estado_archivo_articulos:= false;
 END;

FUNCTION valida_categoria(): char;
VAR
 op: char;
 BEGIN
 REPEAT
 textcolor(white);
 writeln('- Alimentos(a)');
 writeln('- Vestuario(v)');
 writeln('- Peluqueria(p)');
 writeln();
 writeln('--------------------');
 write('Seleccione la categoria: ');
 readln(op);
 IF (op <> 'a') AND (op <> 'v') AND  (op <> 'p') THEN
  BEGIN
  textcolor(lightred);
  writeln();
  writeln('////////////////////////////////////////');
  writeln('X VALOR INCORRECTO. INGRESE NUEVAMENTE X');
  writeln('////////////////////////////////////////');
  writeln();
  END;
 UNTIL (op = 'a') OR (op = 'v') OR (op = 'p');
 valida_categoria:= op;
 END;

FUNCTION existe_art(cod_art: integer): boolean;
VAR
 f: boolean;
 BEGIN
 f:= false;
 REPEAT
 read(archivo_articulos,registro_articulos);
 IF cod_art = registro_articulos.codigo_articulo THEN
  f:= true;
 UNTIL eof(archivo_articulos) OR (f = true);
 IF f = true THEN
  existe_art:= true
 ELSE
 existe_art:= false;
 END;

PROCEDURE carga_articulos;
VAR
 cod_art,f: integer;
 op: string;
 BEGIN
 clrscr;
 textcolor(lightgreen);
 reset(archivo_articulos);
 IF verificar_estado_archivo_articulos() = true THEN
  BEGIN
  writeln('Como el archivo esta vacio, este sera el primer registro que vas a agregar.');
  writeln();
  write('>>> Ingrese codigo de articulo: ');
  readln(registro_articulos.codigo_articulo);
  writeln();
  write('>>> Ingrese descripcion de articulo: ');
  readln(registro_articulos.descripcion);
  writeln();
  write('>>> Ingrese stock: ');
  readln(registro_articulos.stock);
  writeln();
  write('>>> Ingrese stock minimo: ');
  readln(registro_articulos.stock_minimo);
  writeln();
  FOR f:= 1 TO 2 DO
   BEGIN
    IF f = 1 THEN
     BEGIN
     write('>>> Ingrese valor de venta: ');
     readln(registro_articulos.importes[f]);
     END
    ELSE
     BEGIN
     write('>>> Ingrese valor de compora: ');
     readln(registro_articulos.importes[f]);
     END;
   END;
  registro_articulos.categoria:= valida_categoria;
  writeln();
  write('>>> Ingrese codigo de proveedor: ');
  readln(registro_articulos.codigo_proveedor);
  seek(archivo_articulos,filesize(archivo_articulos));
  write(archivo_articulos,registro_articulos);
  writeln();
  textcolor(green);
  writeln('=========================');
  writeln('*** REGISTRO GUARDADO ***');
  writeln('=========================');
  writeln();
  close(archivo_articulos);
  delay(2000);
  END
 ELSE
  BEGIN
  REPEAT
  clrscr;
  textcolor(white);
  reset(archivo_articulos);
  write('>>> Ingrese codigo de articulo: ');
  readln(cod_art);
  IF existe_art(cod_art) = true THEN
   BEGIN
   textcolor(yellow);
   writeln();
   writeln('***********************************');
   writeln('# CODIGO DE ARTICULO YA EXISTENTE #');
   writeln('***********************************');
   writeln();
   END
  ELSE
   BEGIN
   registro_articulos.codigo_articulo:= cod_art;
   writeln();
   write('>>> Ingrese descripcion del articulo: ');
   readln(registro_articulos.descripcion);
   writeln();
   write('>>> Ingrese stock: ');
   readln(registro_articulos.stock);
   writeln();
   write('>>> Ingrese stock minimo: ');
   readln(registro_articulos.stock_minimo);
   writeln();
   FOR f:= 1 TO 2 DO
    BEGIN
     IF f = 1 THEN
      BEGIN
      write('Ingrese valor de venta: ');
      readln(registro_articulos.importes[f]);
      END
     ELSE
      BEGIN
      write('Ingrese valor de compora: ');
      readln(registro_articulos.importes[f]);
      END;
    END;
   registro_articulos.categoria:= valida_categoria;
   writeln();
   write('>>> Ingrese codigo de proveedor: ');
   readln(registro_articulos.codigo_proveedor);
   seek(archivo_articulos,filesize(archivo_articulos));
   write(archivo_articulos,registro_articulos);
   writeln();
   textcolor(green);
   writeln('=========================');
   writeln('*** REGISTRO GUARDADO ***');
   writeln('=========================');
   writeln();
   END;
   close(archivo_articulos);
   REPEAT
   textcolor(lightcyan);
   write('Desea agregar otro registro[s/n]?: ');
   readln(op);
   IF (op <> 's') AND (op <> 'n') THEN
    BEGIN
    textcolor(lightred);
    writeln();
    writeln('////////////////////////////////////////');
    writeln('X VALOR INCORRECTO. INGRESE NUEVAMENTE X');
    writeln('////////////////////////////////////////');
    writeln();
    END;
   UNTIL (op = 's') OR (op = 'n');
  UNTIL (op = 'n');
  END;
 END;


PROCEDURE menu_principal;
VAR
 op: integer;
 BEGIN
 REPEAT
 clrscr;
 textcolor(white);
 writeln('1. Cargar articulo.');
 writeln('2. Actualizar porcentaje.');
 writeln('3. Listado de articulos con menor porcentaje.');
 writeln('4. Verificar existencia de un articulo con poco stock.');
 writeln('5. Emitir listado.');
 writeln('6. Salir.');
 writeln();
 writeln('-------------------------------');
 write('Seleccione una opcion: ');
 readln(op);
 CASE op OF
  1:BEGIN
    carga_articulos;
    END;
 { 2:BEGIN
    END;
  3:BEGIN
    END;
  4:BEGIN
    END;
  5:BEGIN
    END;  }
 END;
 UNTIL (op = 6);
 END;

BEGIN
assign(archivo_articulos,'C:\Users\JULIO\Desktop\final-petshop\articulos.dat');
assign(archivo_proveedores,'C:\Users\JULIO\Desktop\final-petshop\proveedores.dat');
crea_archivo_articulos;
crea_archivo_proveedores;
menu_principal;
END.
