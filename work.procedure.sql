create or replace procedure prf_work (
  tp_id_in              in        varchar2
  , entity_code_in      in        varchar2
  , use_date_in         in        date
)

as

  l_xcount              number;

begin

  dbms_application_info.set_action('prf_work');

  l_xcount := 1 + 1 + 1 * 2;

  dbms_application_info.set_action(null);

  exception
    when others then
      dbms_application_info.set_action(null);
      raise;

end prf_work;
/
