PRAGMA FeatureR010="prototype";

$data = SELECT *
FROM pq.`match`
WITH (
    FORMAT=json_each_row,
    SCHEMA
    (
        c0 Uint64,c1 String,c2 Uint64,c3 String,c4 Uint64,c5 String,c6 String,c7 String,c8 Uint64,c9 Uint64,c10 String,c11 String,c12 String,c13 Uint64,c14 String,c15 String,c16 String,c17 Uint64,c18 Uint64,c19 String,c20 Uint64,c21 Uint64,c22 String,c23 Uint64,c24 String,c25 Uint64,c26 Uint64,c27 String,c28 Uint64,c29 String,c30 Uint64,c31 Uint64,c32 Uint64,c33 Uint64,c34 Uint64,c35 Uint64,c36 String,c37 String,c38 String,c39 String
    )
);

-- $match =
--     SELECT * FROM $data
--     MATCH_RECOGNIZE(
--         ORDER BY CAST(time AS Timestamp)
--         MEASURES
--             LAST(M0.time) AS m0_dt,
--             LAST(M1.time) AS m1_dt,
--             LAST(M2.time) AS m2_dt
--         ONE ROW PER MATCH
--         PATTERN ( M0 NOT_M1* M1 NOT_M2* M2 )
--         DEFINE
--             M0 AS
--                 M0.c0 = 0,
--             NOT_M1 AS
--                 NOT_M1.c0 != 1,
--             M1 AS
--                 M1.c0 = 1,
--             NOT_M2 AS
--                 NOT_M2.c0 != 2,
--             M2 AS
--                 M2.c0 = 2
--     );

$match =
    SELECT * FROM $data
    MATCH_RECOGNIZE(
        ORDER BY CAST(time AS Timestamp)
        MEASURES
            LAST(M0.time) AS m0_dt,
            LAST(M1.time) AS m1_dt
        ONE ROW PER MATCH
        PATTERN ( M0 NOT_M1* M1 )
        DEFINE
            M0 AS
                M0.c0 = 0,
            NOT_M1 AS
                NOT_M1.c0 != 1,
            M1 AS
                M1.c0 = 1
    );

INSERT INTO pq.`match`
SELECT ToBytes(Unwrap(Yson::SerializeJson(Yson::From(TableRow())))) FROM $match;
