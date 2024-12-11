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


-- TPC-H/TPC-R Potential Part Promotion Query (Q20)
-- TPC TPC-H Parameter Substitution (Version 2.17.2 build 0)
-- using 1680793381 as a seed to the RNG

$border = Date("1994-01-01");
$threshold = (
select
    $z0_5_35 * sum(l_quantity) as threshold,
    l_partkey as l_partkey,
    l_suppkey as l_suppkey
from
    bindings.lineitem
where
    l_shipdate >= $border
    and l_shipdate < ($border + Interval("P365D"))
group by
    l_partkey, l_suppkey
);

$parts = (
select
    p_partkey
from
    bindings.part
where
    p_name like 'forest%'
);

$join1 = (
select
    ps.ps_suppkey as ps_suppkey,
    ps.ps_availqty as ps_availqty,
    ps.ps_partkey as ps_partkey
from
    bindings.partsupp as ps
join any
    $parts as p
on
    ps.ps_partkey = p.p_partkey
);

$join2 = (
select
    distinct(j.ps_suppkey) as ps_suppkey
from
    $join1 as j
join any
    $threshold as t
on
    j.ps_partkey = t.l_partkey and j.ps_suppkey = t.l_suppkey
where
    j.ps_availqty > t.threshold
);

$join3 = (
select
    j.ps_suppkey as ps_suppkey,
    s.s_name as s_name,
    s.s_address as s_address,
    s.s_nationkey as s_nationkey
from
    $join2 as j
join any
    bindings.supplier as s
on
    j.ps_suppkey = s.s_suppkey
);

select
    j.s_name as s_name,
    j.s_address as s_address
from
    $join3 as j
join
    bindings.nation as n
on
    j.s_nationkey = n.n_nationkey
where
    n.n_name = 'CANADA'
order by
    s_name;
