USE plato;

SELECT
    key,
    max(1u / (4u - subkey)),
    max(subkey),
    max(1u),
    max(1u / 0u)
FROM
    Input
GROUP BY
    key
ORDER BY
    key
;
