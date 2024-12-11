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


-- TPC-H/TPC-R Global Sales Opportunity Query (Q22)
-- TPC TPC-H Parameter Substitution (Version 2.17.2 build 0)
-- using 1680793381 as a seed to the RNG

$customers = (
select
    c_acctbal,
    c_custkey,
    Substring(CAST(c_phone AS STRING), 0u, 2u) as cntrycode
from
    bindings.customer
);

$c = (
select
    c_acctbal,
    c_custkey,
    cntrycode
from
    $customers
where
    cntrycode = '13' or cntrycode = '31' or cntrycode = '23' or cntrycode = '29' or cntrycode = '30' or cntrycode = '18' or cntrycode = '17'
);

$avg = (
select
    avg(c_acctbal) as a
from
    $c
where
    c_acctbal > $z0_12
);

$join1 = (
select
    c.c_acctbal as c_acctbal,
    c.c_custkey as c_custkey,
    c.cntrycode as cntrycode
from
    $c as c
cross join
    $avg as a
where
    c.c_acctbal > a.a
);

$join2 = (
select
    j.cntrycode as cntrycode,
    c_custkey,
    j.c_acctbal as c_acctbal
from
    $join1 as j
left only join 
    bindings.orders as o
on
    o.o_custkey = j.c_custkey
);

select
    cntrycode,
    count(*) as numcust,
    sum(c_acctbal) as totacctbal
from
    $join2 as custsale
group by
    cntrycode
order by
    cntrycode;
