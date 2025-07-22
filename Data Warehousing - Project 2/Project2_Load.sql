-- Group: Christopher Bragg, William Roe

-- Load data into Paint Table
INSERT INTO PAINT
SELECT  p.PaintID,
        p.ColorName,
        p.ColorStyle,
        p.ColorList,
        p.DateIntroduced,
        p.DateDiscontinued
FROM BIKE_SHOP.PAINT p;

COMMIT;

INSERT INTO MODEL
SELECT ROW_NUMBER () OVER (ORDER BY ModelName) ModelID, tbl.*
FROM
(
SELECT DISTINCT 
        b.ModelType ModelName
FROM BIKE_SHOP.BICYCLE b
) tbl;
COMMIT;

-- Load data into Address Table
INSERT INTO ADDRESS
SELECT ROW_NUMBER() OVER (ORDER BY Address, City, State, ZIP, Country) AddressID, tbl.*
FROM (
SELECT
        c.Address,
        cy.City,
        cy.State,
        cy.ZIPCODE ZIP,
        cy.Country
FROM BIKE_SHOP.CUSTOMER c
INNER JOIN BIKE_SHOP.CITY cy ON cy.CITYID = c.CITYID

UNION

SELECT
        e.Address,
        cy.City,
        cy.State,
        cy.ZIPCODE ZIP,
        cy.Country
FROM BIKE_SHOP.EMPLOYEE e
INNER JOIN BIKE_SHOP.CITY cy ON cy.CITYID = e.CITYID

UNION

SELECT
        rs.Address,
        cy.City,
        cy.State,
        cy.ZIPCODE ZIP,
        cy.Country
FROM BIKE_SHOP.RETAILSTORE rs
INNER JOIN BIKE_SHOP.CITY cy ON cy.CITYID = rs.CITYID
) tbl;


-- Load data into Customer table
INSERT INTO Customer (CUSTOMERID, FIRSTNAME, LASTNAME, PHONE, ADDRESSID)
SELECT c.CustomerID,
       c.FIRSTNAME,
       c.LASTNAME,
       c.Phone,
       c.CITYID AddressID
FROM BIKE_SHOP.CUSTOMER c;
COMMIT;



-- Load data into Employee table
INSERT INTO Employee (EMPLOYEEID, FIRSTNAME, LASTNAME, HOMEPHONE, ADDRESSID, HIREDATE, RELEASEDATE)
SELECT e.EmployeeID,
       e.FIRSTNAME,
       e.LASTNAME,
       e.HOMEPHONE,
       e.CITYID AddressID,
       e.DATEHIRED HireDate,
       e.DATERELEASED ReleaseDate
FROM BIKE_SHOP.EMPLOYEE e
WHERE e.FIRSTNAME IS NOT NULL;
COMMIT;


-- Load data into Store Table
INSERT INTO STORE
    SELECT  rs.STOREID,
            rs.STORENAME,
            rs.PHONE,
            rs.CITYID AddressID
    FROM BIKE_SHOP.RETAILSTORE rs;


-- Load data into Bicycle table
INSERT INTO Bicycle (SERIALNUMBER, MODELID, PAINTID, FRAMESIZE)
SELECT b.SERIALNUMBER,
       m.MODELID,
       p.PAINTID,
       cs.FRAMESIZE
FROM BIKE_SHOP.BICYCLE b
INNER JOIN Model m ON b.MODELTYPE = m.MODELTYPE
INNER JOIN Paint p ON b.PAINTID = p.PAINTID
INNER JOIN BIKE_SHOP.CommonSizes cs ON b.FRAMESIZE = cs.FRAMESIZE;
COMMIT;

--- Load data into Part Table
INSERT INTO PART
    SELECT ROW_NUMBER() OVER(ORDER BY EstimatedCost) PartID, tbl.*
FROM (SELECT UNIQUE
    cn.ComponentName PartName,
    m.ManufacturerName,
    c.Description, 
    c.ListPrice, 
    c.EstimatedCost
FROM BIKE_SHOP.Component c
INNER JOIN BIKE_SHOP.Manufacturer m
    ON c.Manufacturerid = m.ManufacturerID
INNER JOIN BIKE_SHOP.ComponentName cn
    ON c.Category = cn.ComponentName) tbl;

-- Load data into Purchase Table
INSERT INTO PURCHASE
    SELECT ROW_NUMBER() OVER(ORDER BY CustomerID) PurchaseID, tbl.*
FROM (SELECT
    b.SerialNumber BicycleSerialNumber,
    c.CustomerID,
    s.StoreID,
    e.EmployeeID, 
    bs.ListPrice, 
    bs.SalePrice, 
    bs.SalesTax, 
    bs.ShipPrice, 
    bs.OrderDate, 
    bs.StartDate, 
    bs.ShipDate
FROM BICYCLE b
INNER JOIN BIKE_SHOP.BICYCLE bs ON bs.SERIALNUMBER = b.SerialNumber
INNER JOIN CUSTOMER c ON c.CustomerID = bs.CustomerID
INNER JOIN EMPLOYEE e ON e.EmployeeID = bs.EmployeeID
INNER JOIN STORE s ON s.StoreID = bs.STOREID
) tbl;
COMMIT;


-- Load data into Component table
INSERT INTO Component (COMPONENTID, BICYCLESERIALNUMBER, EMPLOYEEID, PARTID, QUANTITY, COST, DATEINSTALLED)
SELECT
    ROW_NUMBER() OVER (ORDER BY b.SERIALNUMBER, e.EmployeeID, p.PartID) AS COMPONENTID,
    b.SERIALNUMBER AS BICYCLESERIALNUMBER,
    e.EmployeeID AS EMPLOYEEID,
    p.PartID AS PARTID,
    c.QUANTITYONHAND AS QUANTITY,
    c.ESTIMATEDCOST AS COST,
    bp.DATEINSTALLED AS DATEINSTALLED
FROM BIKE_SHOP.COMPONENT c
INNER JOIN BIKE_SHOP.BIKEPARTS bp ON bp.COMPONENTID = c.COMPONENTID
INNER JOIN BICYCLE b ON b.SerialNumber = bp.SERIALNUMBER
INNER JOIN EMPLOYEE e ON e.EMPLOYEEID = bp.EMPLOYEEID
INNER JOIN PART p ON p.PARTID = c.MANUFACTURERID;
COMMIT;
