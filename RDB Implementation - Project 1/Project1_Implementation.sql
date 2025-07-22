-- Created by Christopher Bragg

-- Ensures the script can be ran again without errors
DROP TABLE Car CASCADE CONSTRAINTS;
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Salesperson CASCADE CONSTRAINTS;
DROP TABLE Sales CASCADE CONSTRAINTS;
DROP TABLE SaleDetails CASCADE CONSTRAINTS;
DROP TABLE PriceSticker CASCADE CONSTRAINTS;
DROP TABLE LicenseTaxInsuranceDocuments CASCADE CONSTRAINTS;
DROP TABLE BillOfSale CASCADE CONSTRAINTS;
DROP TABLE SalespersonPerformanceReport CASCADE CONSTRAINTS;
DROP TABLE CustomerSatisfactionSurvey CASCADE CONSTRAINTS;


-- Create the Car table
CREATE TABLE Car (
    VehicleID NUMBER PRIMARY KEY,
    ListPrice NUMBER,
    Make VARCHAR2(255),
    Model VARCHAR2(255),
    DateOfManufacture DATE,
    PlaceOfManufacture VARCHAR2(255),
    NumberOfCylinders NUMBER,
    NumberOfDoors NUMBER,
    Weight NUMBER,
    Capacity NUMBER,
    Options VARCHAR2(255),
    Color VARCHAR2(255),
    DateOfDelivery DATE,
    MileageAtDelivery NUMBER
);

-- Create the Customer table
CREATE TABLE Customer (
    CustomerID NUMBER PRIMARY KEY,
    Name VARCHAR2(255),
    ContactInformation VARCHAR2(255)
);

-- Create the Salesperson table
CREATE TABLE Salesperson (
    SalespersonID NUMBER PRIMARY KEY,
    Name VARCHAR2(255)
);

-- Create the Sales table
CREATE TABLE Sales (
    SaleID NUMBER PRIMARY KEY,
    SaleDate DATE,
    Price NUMBER,
    VehicleID NUMBER,
    FOREIGN KEY (VehicleID) REFERENCES Car(VehicleID)
);

-- Create the SaleDetails table
CREATE TABLE SaleDetails (
    SaleID NUMBER PRIMARY KEY,
    FinancingInformation VARCHAR2(255),
    WarrantyInformation VARCHAR2(255),
    LicenseInformation VARCHAR2(255),
    InsuranceInformation VARCHAR2(255),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID)
);

-- Create the Price Sticker table
CREATE TABLE PriceSticker (
    StickerID NUMBER PRIMARY KEY,
    VehicleID NUMBER,
    AdditionalInformation VARCHAR2(255),
    FOREIGN KEY (VehicleID) REFERENCES Car(VehicleID)
);

-- Create the License, Tax, and Insurance Documents table
CREATE TABLE LicenseTaxInsuranceDocuments (
    DocumentID NUMBER PRIMARY KEY,
    VehicleID NUMBER,
    DocumentInformation VARCHAR2(255),
    FOREIGN KEY (VehicleID) REFERENCES Car(VehicleID)
);

-- Create the Bill of Sale table
CREATE TABLE BillOfSale (
    BillID NUMBER PRIMARY KEY,
    SaleID NUMBER,
    CustomerInformation VARCHAR2(255),
    SalespersonName VARCHAR2(255),
    VehicleID NUMBER,
    CurrentMileage NUMBER,
    CustomizationDetails VARCHAR2(255),
    Price NUMBER,
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID)
);

-- Create the Salesperson Performance Report table
CREATE TABLE SalespersonPerformanceReport (
    ReportID NUMBER PRIMARY KEY,
    SalespersonID NUMBER,
    Month DATE,
    SalesSummary VARCHAR2(255),
    CommissionEarned NUMBER,
    FOREIGN KEY (SalespersonID) REFERENCES Salesperson(SalespersonID)
);

-- Create the Customer Satisfaction Survey table
CREATE TABLE CustomerSatisfactionSurvey (
    SurveyID NUMBER PRIMARY KEY,
    SaleID NUMBER,
    CustomerFeedback VARCHAR2(255),
    FOREIGN KEY (SaleID) REFERENCES Sales(SaleID)
);

-- Constraints for the Car table
ALTER TABLE Car ADD CONSTRAINT CHK_Car_Weight CHECK (Weight >= 0);
ALTER TABLE Car ADD CONSTRAINT CHK_Car_NumberOfCylinders CHECK (NumberOfCylinders >= 0);

-- Constraints for the SaleDetails table
ALTER TABLE SaleDetails ADD CONSTRAINT NN_SaleDetails_SaleID_NOT_NULL CHECK (SaleID IS NOT NULL);

-- Constraints for the Price Sticker table
ALTER TABLE PriceSticker ADD CONSTRAINT NN_PriceSticker_VehicleID_NOT_NULL CHECK (VehicleID IS NOT NULL);

-- Constraints for the License, Tax, and Insurance Documents table
ALTER TABLE LicenseTaxInsuranceDocuments ADD CONSTRAINT NN_Document_VehicleID_NOT_NULL CHECK (VehicleID IS NOT NULL);

-- Constraints for the Bill of Sale table
ALTER TABLE BillOfSale ADD CONSTRAINT NN_BillOfSale_SalespersonName_NOT_NULL CHECK (SalespersonName IS NOT NULL);
ALTER TABLE BillOfSale ADD CONSTRAINT NN_BillOfSale_SaleID_NOT_NULL CHECK (SaleID IS NOT NULL);

-- Constraints for the Salesperson Performance Report table
ALTER TABLE SalespersonPerformanceReport ADD CONSTRAINT NN_SalespersonPerformanceReport_Month_NOT_NULL CHECK (Month IS NOT NULL);
ALTER TABLE SalespersonPerformanceReport ADD CONSTRAINT NN_SalespersonPerformanceReport_SalesSummary_NOT_NULL CHECK (SalesSummary IS NOT NULL);

-- Constraints for the Customer Satisfaction Survey table
ALTER TABLE CustomerSatisfactionSurvey ADD CONSTRAINT NN_CustomerSatisfactionSurvey_SaleID_NOT_NULL CHECK (SaleID IS NOT NULL);

-- Commits all changes made
COMMIT;
