-- Group: Christopher Bragg, William Roe

-- Query 1
SELECT
    A.STATE,
    ROUND(AVG(LISTPRICE),2) AS AVERAGE_LIST_PRICE,
    ROUND(AVG(SALEPRICE),2) AS AVERAGE_SALE_PRICE
FROM
    BRAGGC1.PURCHASE P
    JOIN BRAGGC1.STORE S ON P.STOREID = S.STOREID
    JOIN BRAGGC1.ADDRESS A ON S.ADDRESSID = A.ADDRESSID
GROUP BY
    ROLLUP(A.STATE);


-- Query 2
SELECT
    S.STOREID,
    ROUND(AVG(LISTPRICE),2) AS AVERAGE_LIST_PRICE,
    ROUND(AVG(SALEPRICE),2) AS AVERAGE_SALE_PRICE
FROM
    BRAGGC1.PURCHASE P
    JOIN BRAGGC1.STORE S ON P.STOREID = S.STOREID
GROUP BY
    ROLLUP(S.STOREID);


-- Query 3
SELECT
    DISTINCT s.StoreName,
    p.ColorName,
    COUNT(p.ColorName) Count
    
FROM PAINT p
INNER JOIN BICYCLE b ON b.PaintID = p.PaintID
INNER JOIN PURCHASE p ON p.BicycleSerialNumber = b.SerialNumber
INNER JOIN STORE s ON s.StoreID = p.StoreID
GROUP BY ROLLUP (p.ColorName, s.StoreName)
ORDER BY COUNT(p.ColorName) DESC;


-- Query 4
SELECT s.StoreName,
       p.ManufacturerName,
       GREATEST(COUNT(p.ManufacturerName))
FROM PART p
INNER JOIN COMPONENT c ON c.PartID = p.PartID
INNER JOIN BICYCLE b ON b.SerialNumber = c.BicycleSerialNumber
INNER JOIN PURCHASE p ON p.BicycleSerialNumber = b.SerialNumber
INNER JOIN STORE s ON s.StoreID = p.StoreID
WHERE p.ManufacturerName IS NOT NULL GROUP BY s.StoreName, p.ManufacturerName
ORDER BY COUNT(p.ManufacturerName) DESC;