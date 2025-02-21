SELECT 
    h.name, 
    t.description, 
    COUNT(e.eventid) AS 'count' 
FROM 
    hosts h 
INNER JOIN 
    items i ON h.hostid = i.hostid 
INNER JOIN 
    functions f ON i.itemid = f.itemid 
INNER JOIN 
    triggers t ON f.triggerid = t.triggerid 
INNER JOIN 
    events e ON t.triggerid = e.objectid 
    AND e.object = 0 
    AND e.source = 0 
    AND e.value = 1 
    AND e.clock > UNIX_TIMESTAMP() - 86400 * 30 
WHERE 
    h.status = 0 
    AND i.status = 0 
    AND t.status = 0 
GROUP BY 
    h.name, 
    t.description 
ORDER BY 
    count DESC 
LIMIT 100;



--- Ou então, para usar no grafana com variaveis de data:


SELECT 
    h.name, 
    t.description, 
    COUNT(e.eventid) AS 'count' 
FROM 
    hosts h 
INNER JOIN 
    items i ON h.hostid = i.hostid 
INNER JOIN 
    functions f ON i.itemid = f.itemid 
INNER JOIN 
    triggers t ON f.triggerid = t.triggerid 
INNER JOIN 
    events e ON t.triggerid = e.objectid 
    AND e.object = 0 
    AND e.source = 0 
    AND e.value = 1 
    AND FROM_UNIXTIME(e.clock) BETWEEN $__timeFrom() AND $__timeTo() -- Filtro de tempo dinâmico do Grafana
WHERE 
    h.status = 0 
    AND i.status = 0 
    AND t.status = 0 
GROUP BY 
    h.name, 
    t.description 
ORDER BY 
    count DESC 
