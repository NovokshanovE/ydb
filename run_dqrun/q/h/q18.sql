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


-- TPC-H/TPC-R Large Volume Customer Query (Q18)
-- TPC TPC-H Parameter Substitution (Version 2.17.2 build 0)
-- using 1680793381 as a seed to the RNG

$in = (
select
    l_orderkey,
    sum(l_quantity) as sum_l_quantity
from
    bindings.lineitem
group by
    l_orderkey having
        sum(l_quantity) > 300
);

$join1 = (
select
    c.c_name as c_name,
    c.c_custkey as c_custkey,
    o.o_orderkey as o_orderkey,
    o.o_orderdate as o_orderdate,
    o.o_totalprice as o_totalprice
from
    bindings.customer as c
join
    bindings.orders as o
on
    c.c_custkey = o.o_custkey
);
select
    j.c_name as c_name,
    j.c_custkey as c_custkey,
    j.o_orderkey as o_orderkey,
    j.o_orderdate as o_orderdate,
    j.o_totalprice as o_totalprice,
    sum(i.sum_l_quantity) as sum_l_quantity
from
    $join1 as j
join
    $in as i
on
    i.l_orderkey = j.o_orderkey
group by
    j.c_name,
    j.c_custkey,
    j.o_orderkey,
    j.o_orderdate,
    j.o_totalprice
order by
    o_totalprice desc,
    o_orderdate
limit 100;