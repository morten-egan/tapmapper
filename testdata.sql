insert into job_mapper
select --+ materialize
        mod(rownum, 10)
        , 'HK'
        , random_ninja.util_random.ru_numcharfy('?########_HK')
        , sysdate - 1
        , 0
      from
        dual
      connect by
        level <= 5000;

commit;
