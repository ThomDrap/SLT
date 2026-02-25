SELECT 
    "Date",
    "Heure",
    MAX("MT_002_Count") AS "Replication PS1 to PC2",
    MAX("MT_004_Count") AS "Replication PSA to PCB",
    MAX("MT_005_Count") AS "Replication PC2 to BQ",
    MAX("MT_007_Count") AS "Replication PCB to BQ",
    MAX("MT_003_Count") AS "SLT_BQ",
    MAX("MT_006_Count") AS "SLT_BQ_LM"

    
FROM (
    -- ÉTAPE 1 : On identifie la famille et on compte les PIDs par seconde
    SELECT 
        W."DATUM" AS "Date", 
        SUBSTRING(W."TIME", 1, 2) AS "Heure", 
        W."TIME" AS "Seconde",
        -- On compte les PIDs distincts pour chaque famille à chaque seconde
        COUNT(DISTINCT CASE WHEN W."APPLICATION_INFO" LIKE '%MT_002%' THEN W."PID" END) AS "MT_002_Count",
        COUNT(DISTINCT CASE WHEN W."APPLICATION_INFO" LIKE '%MT_004%' THEN W."PID" END) AS "MT_004_Count",
        COUNT(DISTINCT CASE WHEN W."APPLICATION_INFO" LIKE '%MT_005%' THEN W."PID" END) AS "MT_005_Count",
        COUNT(DISTINCT CASE WHEN W."APPLICATION_INFO" LIKE '%MT_007%' THEN W."PID" END) AS "MT_007_Count",
        COUNT(DISTINCT CASE WHEN W."APPLICATION_INFO" LIKE '%MT_003%' THEN W."PID" END) AS "MT_003_Count",
        COUNT(DISTINCT CASE WHEN W."APPLICATION_INFO" LIKE '%MT_006%' THEN W."PID" END) AS "MT_006_Count"
    FROM "SAPSR3"."/SDF/SMON_WPINFO" AS W
    WHERE W."APPLICATION_INFO" LIKE '%/1LT/IUC_LOAD_MT_%'
      AND W."WP_TYPE" = '4'
      AND W."DATUM" = '20260222'
    GROUP BY W."DATUM", W."TIME" -- On groupe par seconde pour avoir le parallélisme réel
) AS SousRequete
GROUP BY "Date", "Heure"
ORDER BY "Date", "Heure";