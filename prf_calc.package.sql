create or replace package prf_calc

as

  /** Schedule and run TAP performance calculation based on entity code.
  * @author Morten Egan
  * @version 0.0.1
  * @project TAPMAPPER
  */
  npg_version         varchar2(250) := '0.0.1';

  -- Source types
  type job_mapper_tab is table of job_mapper%rowtype;
  type job_map_cur is ref cursor return job_mapper%rowtype;

  -- Output types.
  type job_result_para_block_rec is record (para_block number, status number, processed number);
  type job_result_para_block_tab is table of job_result_para_block_rec;

  function prf_calc_mapper(
    job_cursor            sys_refcursor
  )
  return job_mapper_tab
  pipelined
  parallel_enable(partition job_cursor by any);

  function prf_calc_do_worker(
    job_cursor            job_map_cur
  )
  return job_result_para_block_tab
  pipelined
  parallel_enable(partition job_cursor by hash(para_block))
  cluster job_cursor by (para_block);

end prf_calc;
/
