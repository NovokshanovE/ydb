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


-- TPC-H/TPC-R Small-Quantity-Order Revenue Query (Q17)
-- TPC TPC-H Parameter Substitution (Version 2.17.2 build 0)
-- using 1680793381 as a seed to the RNG

$p = select p_partkey from bindings.part
where
    p_brand = 'Brand#23'
    and p_container = 'MED BOX'
;

$threshold = (
select
    $z0_2_12 * avg(l_quantity) as threshold,
    l.l_partkey as l_partkey
from
    bindings.lineitem as l
left semi join
    $p as p
on  
    p.p_partkey = l.l_partkey
group by
    l.l_partkey
);

$l = select l.l_partkey as l_partkey, l.l_quantity as l_quantity, l.l_extendedprice as l_extendedprice
from
    bindings.lineitem as l
join
    $p as p
on  
    p.p_partkey = l.l_partkey;

select
    sum(l.l_extendedprice) / $z7_35 as avg_yearly
from
    $l as l
join
    $threshold as t
on  
    t.l_partkey = l.l_partkey
where
    l.l_quantity < t.threshold;
