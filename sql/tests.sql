-- alpha
select * 
from alpha
order by id asc;

select count(*) from alpha;

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
select id, alpha_id, name, created_at
from alpha
order by created_at desc;


EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
SELECT 
    t1.alpha_id, 
    t1.name, 
    t1.created_at
FROM 
    alpha t1
INNER JOIN 
    (SELECT 
         alpha_id, 
         MAX(created_at) as max_created_at
     FROM 
         alpha
     GROUP BY 
         alpha_id) t2
ON 
    t1.alpha_id = t2.alpha_id 
    AND t1.created_at = t2.max_created_at
order by alpha_id asc;

-- beta

select * from beta;
select count(*) from beta;

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
SELECT 
    t1.alpha_id,
    t1.beta_id, 
    t1.name, 
    t1.created_at
FROM 
    beta t1
INNER JOIN 
    (SELECT 
         beta_id, 
         MAX(created_at) as max_created_at
     FROM 
         beta
     GROUP BY 
         alpha_id, beta_id) t2
ON 
    t1.beta_id = t2.beta_id 
    AND t1.created_at = t2.max_created_at
order by alpha_id asc, beta_id asc;

-- one level join

EXPLAIN (ANALYZE, COSTS, VERBOSE, BUFFERS, FORMAT JSON)
with alpha as (
SELECT 
    t1.alpha_id, 
    t1.name, 
    t1.created_at
FROM 
    alpha t1
INNER JOIN 
    (SELECT 
         alpha_id, 
         MAX(created_at) as max_created_at
     FROM 
         alpha
     GROUP BY 
         alpha_id) t2
ON 
    t1.alpha_id = t2.alpha_id 
    AND t1.created_at = t2.max_created_at
order by alpha_id asc),
beta as (
SELECT 
    t1.alpha_id,
    t1.beta_id, 
    t1.name, 
    t1.created_at
FROM 
    beta t1
INNER JOIN 
    (SELECT 
         beta_id, 
         MAX(created_at) as max_created_at
     FROM 
         beta
     GROUP BY 
         alpha_id, beta_id) t2
ON 
    t1.beta_id = t2.beta_id 
    AND t1.created_at = t2.max_created_at
order by alpha_id asc, beta_id asc
)
select alpha.alpha_id,
  beta.beta_id,
  alpha.name as alpha_name,
  beta.name as beta_name
  from alpha
  left join beta
    on (alpha.alpha_id = beta.alpha_id)



CREATE INDEX idx_alpha_created_at ON alpha(created_at);
CREATE INDEX idx_beta_created_at ON beta(created_at);
CREATE INDEX idx_alpha_alpha_id ON alpha(alpha_id);
CREATE INDEX idx_beta_alpha_id ON beta(alpha_id);
create index idx_beta_beta_id on beta(beta_id);
