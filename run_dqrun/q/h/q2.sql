PRAGMA dq.EnableDqReplicate = "1";
PRAGMA DisableSimpleColumns;

PRAGMA dq.MaxTasksPerStage='200';
PRAGMA dq.MaxTasksPerOperation='1700';
PRAGMA dq.HashJoinMode = "grace";
PRAGMA dq.HashShuffleTasksRatio="1.0";
PRAGMA dq.HashShuffleMaxTasks="200";

-- pragma dq.AggregateStatsByStage="false";
pragma dq.ComputeActorType="sync";
pragma dq.OptLLVM="off";

PRAGMA s3.UseBlocksSource="true";
pragma OrderedColumns="true";

pragma FilterPushdownOverJoinOptionalSide;
pragma RotateJoinTree="false";
pragma AnsiOptionalAs="true";
































pragma warning("disable", "4527");

$z0 = 0;
$z1_2 = 1.2;
$z1_3 = 1.3;
$z0_9 = 0.9;
$z0_99 = 0.99;
$z1_49 = 1.49;

$z0_35 = 0;
$z0_1_35 = 0.1;
$z1_2_35 = 1.2;
$z0_05_35 = 0.05;
$z0_9_35 = 0.9;
$z1_1_35 = 1.1;
$z0_5_35 = 0.5;
$z100_35 = 100.;
$z0_0001_35 = 0.0001;
$z7_35 = 7.;

$z0_12 = 0.;
$z1_12 = 1;
$z0_0100001_12 = 0.0100001;
$z0_06_12 = 0.06;
$z0_2_12 = 0.2;

$scale_factor = 1;

$round = ($x, $y) -> { return Math::Round($x, $y); };
$upscale = ($x) -> { return $x; };

$todecimal = ($x, $p, $s) -> { return cast($x as double); };


-- TPC-H/TPC-R Minimum Cost Supplier Query (Q2)
-- using 1680793381 as a seed to the RNG

$r = (
select
    r_regionkey
from 
    bindings.region
where
    r_name='EUROPE'
);

$n = (
select
    n_name,
    n_nationkey
from
    bindings.nation as n 
left semi join
    $r as r
on 
    n.n_regionkey = r.r_regionkey
);

$s1 = (
select
    s_suppkey
from
    bindings.supplier as s
left semi join
    $n as n
on
    s.s_nationkey = n.n_nationkey
);

$min_ps_supplycost = (
select
    min(ps_supplycost) as min_ps_supplycost,
    ps.ps_partkey as ps_partkey
from
    bindings.partsupp as ps
left semi join
    $s1 as s
on
    ps.ps_suppkey = s.s_suppkey
group by
    ps.ps_partkey
);

$p = (
select
    p_partkey,
    p_mfgr
from
    bindings.part
where
    p_size = 15
    and p_type like '%BRASS'
);

$ps = (
select
    ps.ps_partkey as ps_partkey,
    p.p_mfgr as p_mfgr,
    ps.ps_supplycost as ps_supplycost,
    ps.ps_suppkey as ps_suppkey
from
    bindings.partsupp as ps
join
    $p as p
on
    p.p_partkey = ps.ps_partkey
);

$s2 = (
select
    s_acctbal,
    s_name,
    s_address,
    s_phone,
    s_comment,
    s_suppkey,
    n_name
from
    bindings.supplier as s
join
    $n as n
on
    s.s_nationkey = n.n_nationkey
);

$jp =(
select
    ps_partkey,
    ps_supplycost,
    p_mfgr,
    s_acctbal,
    s_name,
    s_address,
    s_phone,
    s_comment,
    n_name
from
    $ps as ps
join    
    $s2 as s
on
    ps.ps_suppkey = s.s_suppkey  
);

select
    s_acctbal,
    s_name,
    n_name,
    jp.ps_partkey as p_partkey,
    p_mfgr,
    s_address,
    s_phone,
    s_comment
from
    $jp as jp
join
    $min_ps_supplycost as m
on
    jp.ps_partkey = m.ps_partkey
where
    min_ps_supplycost = ps_supplycost
order by
    s_acctbal desc,
    n_name,
    s_name,
    p_partkey
limit 100;