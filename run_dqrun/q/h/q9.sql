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


-- TPC-H/TPC-R Product Type Profit Measure Query (Q9)
-- Approved February 1998
-- using 1680793381 as a seed to the RNG

$p = (select p_partkey, p_name
from
    bindings.part
where p_name like '%green%');

$j1 = (select ps_partkey, ps_suppkey, ps_supplycost
from
    bindings.partsupp as ps
join $p as p
on ps.ps_partkey = p.p_partkey);

$j2 = (select l_suppkey, l_partkey, l_orderkey, l_extendedprice, l_discount, ps_supplycost, l_quantity
from
    bindings.lineitem as l
join $j1 as j
on l.l_suppkey = j.ps_suppkey AND l.l_partkey = j.ps_partkey);

$j3 = (select l_orderkey, s_nationkey, l_extendedprice, l_discount, ps_supplycost, l_quantity
from
    bindings.supplier as s
join $j2 as j
on j.l_suppkey = s.s_suppkey);

$j4 = (select o_orderdate, l_extendedprice, l_discount, ps_supplycost, l_quantity, s_nationkey
from
    bindings.orders as o
join $j3 as j
on o.o_orderkey = j.l_orderkey);

$j5 = (select n_name, o_orderdate, l_extendedprice, l_discount, ps_supplycost, l_quantity
from
    bindings.nation as n
join $j4 as j
on j.s_nationkey = n.n_nationkey
);

$profit = (select 
    n_name as nation,
    DateTime::GetYear(cast(o_orderdate as timestamp)) as o_year,
    l_extendedprice * ($z1_12 - l_discount) - ps_supplycost * l_quantity as amount
from $j5);

select
    nation,
    o_year,
    sum(amount) as sum_profit
from $profit
group by
    nation,
    o_year
order by
    nation,
    o_year desc;
