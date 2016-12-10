create or replace package body prf_calc

as

  function prf_calc_mapper (
    job_cursor            sys_refcursor
  )
  return job_mapper_tab
  pipelined
  parallel_enable(partition job_cursor by any)

  as

    l_ret_var               job_mapper%rowtype;

  begin

    dbms_application_info.set_action('prf_calc_mapper');

    -- All we do here is tream the work rows
    loop
      fetch job_cursor into l_ret_var;
      exit when job_cursor%notfound;

      pipe row(l_ret_var);
    end loop;

    dbms_application_info.set_action(null);

    return;

    exception
      when others then
        dbms_application_info.set_action(null);
        raise;

  end prf_calc_mapper;

  function prf_calc_do_worker (
    job_cursor            job_map_cur
  )
  return job_result_para_block_tab
  pipelined
  parallel_enable(partition job_cursor by hash(para_block))
  cluster job_cursor by (para_block)

  as

    l_work_rec              job_mapper%rowtype;
    l_ret_var               job_result_para_block_rec;

  begin

    dbms_application_info.set_action('prf_calc_do_worker');

    l_ret_var.para_block := null;
    l_ret_var.status := 0;
    l_ret_var.processed := 0;

    loop
      fetch job_cursor into l_work_rec;
      exit when job_cursor%notfound;

      if l_ret_var.para_block is null then
        -- First row arriving
        l_ret_var.para_block := l_work_rec.para_block;
        -- This is where we should do the calculation
        -- <fill in procedure call here>
        -- Once done update processed.
        l_ret_var.processed := l_ret_var.processed + 1;
      elsif l_ret_var.para_block <> l_work_rec.para_block then
        -- We switch para_block, so pipe row with previous para_block values.
        l_ret_var.status := 1;
        pipe row(l_ret_var);

        -- Set values for new para_block
        l_ret_var.para_block := l_work_rec.para_block;
        l_ret_var.status := 0;

        -- Do calculation for the current row
        -- <fill in procedure call here>
        -- Once done update processed.
        l_ret_var.processed := 1;
      else
        -- We have new row in existing para_block
        -- Do calculation for the current row
        -- <fill in procedure call here>
        -- Once done update processed.
        l_ret_var.processed := l_ret_var.processed + 1;
      end if;
    end loop;

    dbms_application_info.set_action(null);

    return;

    exception
      when others then
        dbms_application_info.set_action(null);
        raise;

  end prf_calc_do_worker;

begin

  dbms_application_info.set_client_info('prf_calc');
  dbms_session.set_identifier('prf_calc');

end prf_calc;
/
