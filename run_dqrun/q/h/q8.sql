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


-- TPC-H/TPC-R National Market Share Query (Q8)
-- TPC TPC-H Parameter Substitution (Version 2.17.2 build 0)
-- using 1680793381 as a seed to the RNG

$join1 = (
select
    l.l_extendedprice * ($z1_12 - l.l_discount) as volume,
    l.l_suppkey as l_suppkey,
    l.l_orderkey as l_orderkey
from
    bindings.part as p
join
    bindings.lineitem as l
on
    p.p_partkey = l.l_partkey
where
    p.p_type = 'ECONOMY ANODIZED STEEL'
);
$join2 = (
select
    j.volume as volume,
    j.l_orderkey as l_orderkey,
    s.s_nationkey as s_nationkey
from
    $join1 as j
join
    bindings.supplier as s
on
    s.s_suppkey = j.l_suppkey
);
$join3 = (
select
    j.volume as volume,
    j.l_orderkey as l_orderkey,
    n.n_name as nation
from
    $join2 as j
join
    bindings.nation as n
on
    n.n_nationkey = j.s_nationkey
);
$join4 = (
select
    j.volume as volume,
    j.nation as nation,
    DateTime::GetYear(cast(o.o_orderdate as Timestamp)) as o_year,
    o.o_custkey as o_custkey
from
    $join3 as j
join
    bindings.orders as o
on
    o.o_orderkey = j.l_orderkey
where o_orderdate between Date('1995-01-01') and Date('1996-12-31')
);
$join5 = (
select
    j.volume as volume,
    j.nation as nation,
    j.o_year as o_year,
    c.c_nationkey as c_nationkey
from
    $join4 as j
join
    bindings.customer as c
on
    c.c_custkey = j.o_custkey
);
$join6 = (
select
    j.volume as volume,
    j.nation as nation,
    j.o_year as o_year,
    n.n_regionkey as n_regionkey
from
    $join5 as j
join
    bindings.nation as n
on
    n.n_nationkey = j.c_nationkey
);
$join7 = (
select
    j.volume as volume,
    j.nation as nation,
    j.o_year as o_year
from
    $join6 as j
join
    bindings.region as r
on
    r.r_regionkey = j.n_regionkey
where
    r.r_name = 'AMERICA'
);

select
    o_year,
    sum(case
        when nation = 'BRAZIL' then volume
        else $z0_12
    end) / sum(volume) as mkt_share
from
    $join7 as all_nations
group by
    o_year
order by
    o_year;