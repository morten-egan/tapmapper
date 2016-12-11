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
  l_xcount := mod(l_xcount, random_ninja.core_random.r_natural(3,7));
  l_xcount := sqrt(l_xcount);

  dbms_application_info.set_action(null);

  exception
    when others then
      dbms_application_info.set_action(null);
      raise;

end prf_work;
/
