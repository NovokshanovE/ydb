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


-- TPC-H/TPC-R Suppliers Who Kept Orders Waiting Query (Q21)
-- TPC TPC-H Parameter Substitution (Version 2.17.2 build 0)
-- using 1680793381 as a seed to the RNG

$n = select n_nationkey from bindings.nation
where n_name = 'SAUDI ARABIA';

$s = select s_name, s_suppkey from bindings.supplier as supplier
join $n as nation
on supplier.s_nationkey = nation.n_nationkey;

$l = select l_suppkey, l_orderkey from bindings.lineitem
where l_receiptdate > l_commitdate;

$j1 = select s_name, l_suppkey, l_orderkey from $l as l1
join $s as supplier
on l1.l_suppkey = supplier.s_suppkey;

-- exists
$j2 = select l1.l_orderkey as l_orderkey, l1.l_suppkey as l_suppkey, l1.s_name as s_name, l2.l_receiptdate as l_receiptdate, l2.l_commitdate as l_commitdate from $j1 as l1
join bindings.lineitem as l2
on l1.l_orderkey = l2.l_orderkey
where l2.l_suppkey <> l1.l_suppkey;

$j2_1 = select s_name, l1.l_suppkey as l_suppkey, l1.l_orderkey as l_orderkey from $j1 as l1
left semi join $j2 as l2
on l1.l_orderkey = l2.l_orderkey;

-- not exists
$j2_2 = select l_orderkey from $j2 where l_receiptdate > l_commitdate;

$j3 = select s_name, l_suppkey, l_orderkey from $j2_1 as l1
left only join $j2_2 as l3
on l1.l_orderkey = l3.l_orderkey;

$j4 = select s_name from $j3 as l1
join bindings.orders as orders
on orders.o_orderkey = l1.l_orderkey
where o_orderstatus = 'F';

select s_name,
    count(*) as numwait from $j4
group by
    s_name
order by
    numwait desc,
    s_name
limit 100;
