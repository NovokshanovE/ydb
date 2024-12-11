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


-- TPC-H/TPC-R Top Supplier Query (Q15)
-- TPC TPC-H Parameter Substitution (Version 2.17.2 build 0)
-- using 1680793381 as a seed to the RNG

$border = Date("1996-01-01");
$revenue0 = (
    select
        l_suppkey as supplier_no,
        $round(sum(l_extendedprice * ($z1_12 - l_discount)), -8) as total_revenue
    from
        bindings.lineitem
    where
        l_shipdate  >= $border
        and l_shipdate < ($border + Interval("P91D"))
    group by
        l_suppkey
);
$max_revenue = (
select
    max(total_revenue) as max_revenue
from
    $revenue0
);
$join1 = (
select
    s.s_suppkey as s_suppkey,
    s.s_name as s_name,
    s.s_address as s_address,
    s.s_phone as s_phone,
    r.total_revenue as total_revenue
from
    bindings.supplier as s
join
    $revenue0 as r
on
    s.s_suppkey = r.supplier_no
);

select
    j.s_suppkey as s_suppkey,
    j.s_name as s_name,
    j.s_address as s_address,
    j.s_phone as s_phone,
    j.total_revenue as total_revenue
from
    $join1 as j
join
    $max_revenue as m
on
    j.total_revenue = m.max_revenue
order by
    s_suppkey;
