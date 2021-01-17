--@Author:	    Emanuel Flores Martínez
--@Fecha creación:  16/01/2021
--@Descripción:     Trigger instead of para la vista articulo n1

create or replace trigger t_dml_articulo
instead of insert or update or delete on articulo
declare
  v_count number;
begin
  case 
    when inserting then

      insert into t_articulo_insert (articulo_id, pdf)
      values (:new.articulo_id, :new.pdf);

      insert into articulo_1 (articulo_id, pdf)
        select * from t_articulo_insert
        where articulo_id = :new.articulo_id;

      insert into articulo_2 (articulo_id, titulo, resumen, texto)
      values (:new.articulo_id, :new.titulo, :new.resumen, :new.texto);

      delete from t_articulo_insert 
      where articulo_id = :new.articulo_id;

    when deleting then

      delete from articulo_2
      where articulo_id = :old.articulo_id;

      delete from articulo_1
      where articulo_id = :old.articulo_id;

    when updating then
      raise_application_error(-20002, 
        'Error, sentencia UPDATE no soportada');
  
  end case;
end;
/