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


-- TPC-H/TPC-R Returned Item Reporting Query (Q10)
-- TPC TPC-H Parameter Substitution (Version 2.17.2 build 0)
-- using 1680793381 as a seed to the RNG

$border = Date("1993-10-01");
$join1 = (
select
    c.c_custkey as c_custkey,
    c.c_name as c_name,
    c.c_acctbal as c_acctbal,
    c.c_address as c_address,
    c.c_phone as c_phone,
    c.c_comment as c_comment,
    c.c_nationkey as c_nationkey,
    o.o_orderkey as o_orderkey
from
    bindings.customer as c
join
    bindings.orders as o
on
    c.c_custkey = o.o_custkey
where
    o.o_orderdate >= $border
    and o.o_orderdate < ($border + Interval("P90D"))
);
$join2 = (
select
    j.c_custkey as c_custkey,
    j.c_name as c_name,
    j.c_acctbal as c_acctbal,
    j.c_address as c_address,
    j.c_phone as c_phone,
    j.c_comment as c_comment,
    j.c_nationkey as c_nationkey,
    l.l_extendedprice as l_extendedprice,
    l.l_discount as l_discount
from
    $join1 as j 
join
    bindings.lineitem as l
on
    l.l_orderkey = j.o_orderkey
where
    l.l_returnflag = 'R'
);
$join3 = (
select
    j.c_custkey as c_custkey,
    j.c_name as c_name,
    j.c_acctbal as c_acctbal,
    j.c_address as c_address,
    j.c_phone as c_phone,
    j.c_comment as c_comment,
    j.c_nationkey as c_nationkey,
    j.l_extendedprice as l_extendedprice,
    j.l_discount as l_discount,
    n.n_name as n_name
from
    $join2 as j 
join
    bindings.nation as n
on
    n.n_nationkey = j.c_nationkey
);
select
    c_custkey,
    c_name,
    sum(l_extendedprice * ($z1_12 - l_discount)) as revenue,
    c_acctbal,
    n_name,
    c_address,
    c_phone,
    c_comment
from
    $join3
group by
    c_custkey,
    c_name,
    c_acctbal,
    c_phone,
    n_name,
    c_address,
    c_comment
order by
    revenue desc
limit 20;