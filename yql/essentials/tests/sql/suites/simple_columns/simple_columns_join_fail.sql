/* custom error:Duplicated member: kk*/
PRAGMA SimpleColumns;
USE plato;

$data = (SELECT key as kk, subkey as sk, value as val FROM Input WHERE cast(key as uint32)/100 < 5);

--INSERT INTO Output
SELECT
  d.*,
  Input.key as kk -- 'kk' is exist from d.kk
FROM Input JOIN $data as d ON Input.subkey = cast(cast(d.kk as uint32)/100 as string)
ORDER BY key, val
;
