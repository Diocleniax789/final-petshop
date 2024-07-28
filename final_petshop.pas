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

{PROCEDURE mostrar_articulos_actualizado;
VAR
 f,h: integer;
 BEGIN
  for f := 0 to filesize(archivo_articulos) - 1 DO
   BEGIN
   seek(archivo_articulos, f);
   read(archivo_articulos, registro_articulos);
   write(registro_articulos.categoria,' ',registro_articulos.descripcion);
   FOR h:= 1 to 2 do
    begin
    writeln(registro_articulos.importes[h]);
    end;
   writeln();
   END;

 END;    }


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
  { mostrar_articulos_actualizado; }
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

FUNCTION verificar_estado_archivo_proveedores(): boolean;
 BEGIN
 IF filesize(archivo_proveedores) = 0 THEN
  verificar_estado_archivo_proveedores:= true
 ELSE
  verificar_estado_archivo_proveedores:= false;
 END;

FUNCTION existe_proveedor(cod_prov: integer): boolean;
VAR
 f: boolean;
 BEGIN
 f:= false;
 REPEAT
 read(archivo_proveedores, registro_proveedores);
 IF cod_prov = registro_proveedores.codigo_proveedor THEN
  f:= true;
 UNTIL eof(archivo_proveedores) OR (f = true);
 IF f = true THEN
   existe_proveedor:= true
 ELSE
   existe_proveedor:= false;
 END;

PROCEDURE ordena_archivo_proveedores;
VAR
 i,j: integer;
 reg_aux: proveedores;
 BEGIN
 FOR i:= 0 TO filesize(archivo_proveedores) - 2 DO
  BEGIN
   FOR j:= i + 1 TO filesize(archivo_proveedores) - 1 DO
    BEGIN
    seek(archivo_proveedores, i);
    read(archivo_proveedores, registro_proveedores);
    seek(archivo_proveedores, j);
    read(archivo_proveedores, reg_aux);
    IF registro_proveedores.codigo_proveedor > reg_aux.codigo_proveedor THEN
     BEGIN
     seek(archivo_proveedores, i);
     read(archivo_proveedores, reg_aux);
     seek(archivo_proveedores, j);
     read(archivo_proveedores, registro_proveedores);
     END;
    END;
  END;
 END;

PROCEDURE carga_proveedores;
VAR
 op: string;
 cod_prov: integer;
 BEGIN
 clrscr;
 textcolor(white);
 reset(archivo_proveedores);
 IF verificar_estado_archivo_proveedores = true THEN
  BEGIN
  writeln('Como sera el primer registro que vas a agregar, no hara falta la verificacion para ver si se repite');
  writeln();
  write('>>> Ingrese codigo de proovedor: ');
  readln(registro_proveedores.codigo_proveedor);
  writeln();
  write('>>> Ingrese nombre y apellido: ');
  readln(registro_proveedores.nombre_apellido);
  writeln();
  write('>>> Ingrese mail: ');
  readln(registro_proveedores.mail);
  seek(archivo_proveedores,filesize(archivo_proveedores));
  write(archivo_proveedores,registro_proveedores);
  close(archivo_proveedores);
  writeln();
  writeln('=========================');
  writeln('*** REGISTRO GUARDADO ***');
  writeln('=========================');
  delay(2000);
  END
 ELSE
  BEGIN
  REPEAT
   clrscr;
   textcolor(white);
   reset(archivo_proveedores);
   write('>>> Ingrese codigo de proveedor: ');
   readln(cod_prov);
   IF existe_proveedor(cod_prov) = true THEN
    BEGIN
    textcolor(lightred);
    writeln();
    writeln('/////////////////////////////////////');
    writeln('X YA EXISTE ESE CODIGO DE PROOVEDOR X');
    writeln('/////////////////////////////////////');
    writeln();
    END
   ELSE
    BEGIN
    registro_proveedores.codigo_proveedor:= cod_prov;
    writeln();
    write('>>> Ingrese nombre y apellido: ');
    readln(registro_proveedores.nombre_apellido);
    writeln();
    write('>>> Ingrese mail: ');
    readln(registro_proveedores.mail);
    seek(archivo_proveedores,filesize(archivo_proveedores));
    write(archivo_proveedores,registro_proveedores);
    ordena_archivo_proveedores;
    writeln();
    writeln('=========================');
    writeln('*** REGISTRO GUARDADO ***');
    writeln('=========================');
    writeln();
    END;
   close(archivo_proveedores);
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

FUNCTION porcen(importe,por: real): real;
VAR
 resultado: real;
 BEGIN
 resultado:= importe * por;
 porcen:= resultado;
 END;


PROCEDURE actualizar_porcentaje;
VAR
 f: integer;
 cat: char;
 por,imp_1,imp_2: real;
 op: string;
 BEGIN
 clrscr;
 textcolor(white);
 reset(archivo_articulos);
 IF verificar_estado_archivo_articulos = true THEN
  BEGIN
  textcolor(lightred);
  writeln();
  writeln('////////////////////////////////////////////////////');
  writeln('X EL ARCHIVO ARTICULOS ESTA VACIO. INTENTE DESPUES X');
  writeln('////////////////////////////////////////////////////');
  writeln();
  delay(2000);
  close(archivo_articulos);
  END
 ELSE
  BEGIN
  REPEAT
   clrscr;
   textcolor(white);
   reset(archivo_articulos);
   writeln('>>> Ingrese categoria: ');
   readln(cat);
   cat:= valida_categoria;
   writeln();
   write('>>> Ingrese porcentaje: ');
   readln(por);
   seek(archivo_articulos, 0);
   WHILE NOT eof(archivo_articulos) DO
    BEGIN
    read(archivo_articulos,registro_articulos);
    IF cat = registro_articulos.categoria THEN
      FOR f:= 1 TO 2 DO
       BEGIN
       IF f = 1 THEN
        BEGIN
        imp_1:= registro_articulos.importes[f];
        registro_articulos.importes[f]:= porcen(imp_1,por);
        seek(archivo_articulos,filepos(archivo_articulos) - 1);
        write(archivo_articulos,registro_articulos);
        END
       ELSE
        BEGIN
        imp_2:= registro_articulos.importes[f];
        registro_articulos.importes[f]:= porcen(imp_2,por);
        seek(archivo_articulos,filepos(archivo_articulos) - 1);
        write(archivo_articulos,registro_articulos);
        END;
       END;
       textcolor(lightgreen);
       writeln('=================================================');
       writeln('*** Valores de compra y de venta actualizados ***');
       writeln('=================================================');
       writeln();
     END;
    {mostrar_articulos_actualizado; }
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

PROCEDURE listado_articulos_menor_stock;
VAR
 codigo_prov: integer;
 BEGIN
 clrscr;
 textcolor(white);
 reset(archivo_articulos);
 IF verificar_estado_archivo_articulos = true THEN
  BEGIN
  textcolor(lightred);
  writeln();
  writeln('////////////////////////////////////////////////////');
  writeln('X EL ARCHIVO ARTICULOS ESTA VACIO. INTENTE DESPUES X');
  writeln('////////////////////////////////////////////////////');
  writeln();
  delay(2000);
  close(archivo_articulos);
  END
 ELSE
  BEGIN
  clrscr;
  writeln('LISTA DE PRODUCTOS CON UN STOCK MENOR QUE EL MINIMO POR PROVEEDOR');
  writeln('-----------------------------------------------------------------');
  writeln();
  reset(archivo_articulos);
  reset(archivo_proveedores);
  seek(archivo_proveedores, 0);
  WHILE NOT eof(archivo_proveedores) DO
   BEGIN
   read(archivo_proveedores,registro_proveedores);
   writeln('NOMBRE PROVEEDOR: ',registro_proveedores.nombre_apellido);
   codigo_prov:= registro_proveedores.codigo_proveedor;
   seek(archivo_articulos, 0);
   WHILE NOT eof(archivo_articulos) DO
    BEGIN
    read(archivo_articulos,registro_articulos);
    IF (codigo_prov = registro_articulos.codigo_proveedor) AND (registro_articulos.stock <= registro_articulos.stock_minimo) THEN
     BEGIN
     write('Descipcion articulo: ',registro_articulos.descripcion,' ','Stock actual: ',registro_articulos.stock);
     writeln();
     seek(archivo_articulos, filepos(archivo_articulos) - 1);
     read(archivo_articulos,registro_articulos);
     END;
    END;
   writeln();
   seek(archivo_proveedores,filepos(archivo_proveedores) - 1);
   read(archivo_proveedores,registro_proveedores);
   END;
  close(archivo_articulos);
  close(archivo_proveedores);
  END;
  writeln();
  writeln('Presione enter para salir...');
  readln();
 END;

PROCEDURE verificar_existencia_articulo_stock;
VAR
 op,op_1: string;
 cod_art,cant: integer;
 BEGIN
 clrscr;
 textcolor(white);
 reset(archivo_articulos);
 IF verificar_estado_archivo_articulos = true THEN
  BEGIN
  textcolor(lightred);
  writeln();
  writeln('////////////////////////////////////////////////////');
  writeln('X EL ARCHIVO ARTICULOS ESTA VACIO. INTENTE DESPUES X');
  writeln('////////////////////////////////////////////////////');
  writeln();
  delay(2000);
  close(archivo_articulos);
  END
 ELSE
  BEGIN
  REPEAT
  clrscr;
  reset(archivo_articulos);
  write('>>> Ingrese codigo de articulo: ');
  readln(cod_art);
  IF existe_art(cod_art) = true THEN
   BEGIN
   writeln();
   write('>>> Ingrese cantidad deseada: ');
   readln(cant);
   IF cant <= registro_articulos.stock THEN
    BEGIN
    writeln();
    write('>>> Realizar pago[s/n]?: ');
    readln(op);
    IF op = 's' THEN
     BEGIN
     registro_articulos.stock:= registro_articulos.stock - cant;
     seek(archivo_articulos,filepos(archivo_articulos) - 1);
     write(archivo_articulos,registro_articulos);
     writeln();
     textcolor(lightgreen);
     writeln('========================================================');
     writeln('*** PAGO REALIZADO CON EXITO! GRACIAS POR TU COMPRA! ***');
     writeln('========================================================');
     writeln();
     END
    ELSE
     BEGIN
     textcolor(lightcyan);
     writeln();
     writeln('=========================');
     writeln('& Gracias por su tiempo &');
     writeln('=========================');
     writeln();
     END;
    END
   ELSE
    BEGIN
    textcolor(lightmagenta);
    writeln();
    writeln('||||||||||||||||');
    writeln('# NO HAY STOCK #');
    writeln('||||||||||||||||');
    writeln();
    END;
   END
  ELSE
   BEGIN
   textcolor(lightred);
   writeln();
   writeln('//////////////////////////');
   writeln('X NO EXISTE ESE ARTICULO X');
   writeln('//////////////////////////');
   writeln();
   END;
   close(archivo_articulos);
  REPEAT
  textcolor(lightcyan);
  write('Desea agregar otro registro[s/n]?: ');
  readln(op_1);
  IF (op_1 <> 's') AND (op_1 <> 'n') THEN
   BEGIN
   textcolor(lightred);
   writeln();
   writeln('////////////////////////////////////////');
   writeln('X VALOR INCORRECTO. INGRESE NUEVAMENTE X');
   writeln('////////////////////////////////////////');
   writeln();
   END;
  UNTIL (op_1 = 's') OR (op_1 = 'n');
  UNTIL (op_1 = 'n');
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
 writeln('2. Cargar proveedor');
 writeln('3. Actualizar porcentajes de valores de compra y venta.');
 writeln('4. Listado de articulos con stock menor al minimo por proveedor.');
 writeln('5. Verificar existencia de un articulo con poco stock.');
 writeln('6. Emitir listado.');
 writeln('7. Salir.');
 writeln();
 writeln('-------------------------------');
 write('Seleccione una opcion: ');
 readln(op);
 CASE op OF
  1:BEGIN
    carga_articulos;
    END;
  2:BEGIN
     carga_proveedores;
    END;
  3:BEGIN
    actualizar_porcentaje;
    END;
  4:BEGIN
    listado_articulos_menor_stock;
    END;
  5:BEGIN
    verificar_existencia_articulo_stock;
    END;
{  6:BEGIN
    END;  }
 END;
 UNTIL (op = 7);
 END;

BEGIN
assign(archivo_articulos,'C:\Users\JULIO\Desktop\final-petshop\articulos.dat');
assign(archivo_proveedores,'C:\Users\JULIO\Desktop\final-petshop\proveedores.dat');
crea_archivo_articulos;
crea_archivo_proveedores;
menu_principal;
END.
