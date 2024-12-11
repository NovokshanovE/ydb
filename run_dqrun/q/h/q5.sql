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


-- TPC-H/TPC-R Local Supplier Volume Query (Q5)
-- TPC TPC-H Parameter Substitution (Version 2.17.2 build 0)
-- using 1680793381 as a seed to the RNG

$border = Date("1994-01-01");

$j1 = (
select
    n.n_name as n_name,
    n.n_nationkey as n_nationkey
from
    bindings.nation as n
join
    bindings.region as r
on
    n.n_regionkey = r.r_regionkey
where
    r_name = 'ASIA'
);

$j2 = (
select
    j.n_name as n_name,
    j.n_nationkey as n_nationkey,
    s.s_suppkey as s_suppkey
from
    bindings.supplier as s
join
    $j1 as j
on
    j.n_nationkey = s.s_nationkey
);

$j3 = (
select
    j.n_name as n_name,
    j.n_nationkey as n_nationkey,
    l.l_extendedprice as l_extendedprice,
    l.l_discount as l_discount,
    l.l_orderkey as l_orderkey
from
    bindings.lineitem as l
join
    $j2 as j
on
    l.l_suppkey = j.s_suppkey
);

$j4 = (
select
    o.o_orderkey as o_orderkey,
    c.c_nationkey as c_nationkey
from
    bindings.orders as o
join
    bindings.customer as c
on
    c.c_custkey = o.o_custkey
where
    o.o_orderdate >= $border
    and o.o_orderdate < ($border + Interval("P365D"))
);

$j5 = (
select
    j3.n_name as n_name,
    j3.l_extendedprice as l_extendedprice,
    j3.l_discount as l_discount
from
    $j3 as j3
join
    $j4 as j4
on
    j3.n_nationkey = j4.c_nationkey
    and j3.l_orderkey = j4.o_orderkey
);

select
    n_name,
    sum(l_extendedprice * ($z1_12 - l_discount)) as revenue
from
    $j5
group by
    n_name
order by
    revenue desc;