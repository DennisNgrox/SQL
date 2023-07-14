SELECT
  COUNT(1)
FROM
  hosts h
  INNER JOIN items i
    ON h.hostid = i.hostid
  INNER JOIN history_str hy
    ON i.itemid = hy.itemid
    AND hy.clock = (SELECT MAX(clock) FROM history_str WHERE itemid = i.itemid)
    AND hy.value LIKE '4.%'
WHERE
  h.status = 0
  AND i.status = 0
  AND i.key_ = 'agent.version';
