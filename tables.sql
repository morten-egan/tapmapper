create table job_mapper (
  para_block          number
  , entity_code       varchar2(10)
  , tp_id             varchar2(250)
  , use_date          date
  , status            number
);

create index job_mapper_upd_scan_idx on job_mapper(para_block, entity_code);
