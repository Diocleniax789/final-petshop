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
     mail = string[45];
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
    END;
  2:BEGIN
    END;
  3:BEGIN
    END;
  4:BEGIN
    END;
  5:BEGIN
    END;
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
