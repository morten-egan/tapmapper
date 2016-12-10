select
  *
from
  table(
    prf_calc.prf_calc_do_worker(
      cursor(
          select
            *
          from
            table(
              prf_calc.prf_calc_mapper(
                cursor(
                 select * from job_mapper
                )
              )
            ) map_result
      )
    )
  );
