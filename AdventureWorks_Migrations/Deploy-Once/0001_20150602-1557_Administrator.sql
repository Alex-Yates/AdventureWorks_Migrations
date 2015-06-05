-- <Migration ID="47cd4ee8-b5a2-4b7a-9821-c8a77353d597" />
GO


Print 'Create Schema [HumanResources]'
GO
CREATE SCHEMA [HumanResources]
	AUTHORIZATION [dbo]
GO


Print 'Create Extended Property MS_Description on [HumanResources]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains objects related to employees and departments.', 'SCHEMA', N'HumanResources', NULL, NULL, NULL, NULL
GO


Print 'Create Schema [Production]'
GO
CREATE SCHEMA [Production]
	AUTHORIZATION [dbo]
GO


Print 'Create Extended Property MS_Description on [Production]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains objects related to products, inventory, and manufacturing.', 'SCHEMA', N'Production', NULL, NULL, NULL, NULL
GO


Print 'Create Schema [Purchasing]'
GO
CREATE SCHEMA [Purchasing]
	AUTHORIZATION [dbo]
GO


Print 'Create Extended Property MS_Description on [Purchasing]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains objects related to vendors and purchase orders.', 'SCHEMA', N'Purchasing', NULL, NULL, NULL, NULL
GO


Print 'Create Schema [Sales]'
GO
CREATE SCHEMA [Sales]
	AUTHORIZATION [dbo]
GO


Print 'Create Extended Property MS_Description on [Sales]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains objects related to customers, sales orders, and sales territories.', 'SCHEMA', N'Sales', NULL, NULL, NULL, NULL
GO


Print 'Create Schema [Person]'
GO
CREATE SCHEMA [Person]
	AUTHORIZATION [dbo]
GO


Print 'Create Extended Property MS_Description on [Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains objects related to names and addresses of customers, vendors, and employees', 'SCHEMA', N'Person', NULL, NULL, NULL, NULL
GO


Print 'Create Type [dbo].[AccountNumber]'
GO
CREATE TYPE [dbo].[AccountNumber]
	FROM [nvarchar](15)
	NULL
GO


Print 'Create Type [dbo].[Flag]'
GO
CREATE TYPE [dbo].[Flag]
	FROM [bit]
	NOT NULL
GO


Print 'Create Type [dbo].[Name]'
GO
CREATE TYPE [dbo].[Name]
	FROM [nvarchar](50)
	NULL
GO


Print 'Create Type [dbo].[NameStyle]'
GO
CREATE TYPE [dbo].[NameStyle]
	FROM [bit]
	NOT NULL
GO


Print 'Create Type [dbo].[Phone]'
GO
CREATE TYPE [dbo].[Phone]
	FROM [nvarchar](25)
	NULL
GO


Print 'Create Type [dbo].[OrderNumber]'
GO
CREATE TYPE [dbo].[OrderNumber]
	FROM [nvarchar](25)
	NULL
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [dbo].[AWBuildVersion]'
GO
CREATE TABLE [dbo].[AWBuildVersion] (
		[SystemInformationID]     [tinyint] IDENTITY(1, 1) NOT NULL,
		[Database Version]        [nvarchar](25) NOT NULL,
		[VersionDate]             [datetime] NOT NULL,
		[ModifiedDate]            [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_AWBuildVersion_SystemInformationID to [dbo].[AWBuildVersion]'
GO
ALTER TABLE [dbo].[AWBuildVersion]
	ADD
	CONSTRAINT [PK_AWBuildVersion_SystemInformationID]
	PRIMARY KEY
	CLUSTERED
	([SystemInformationID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_AWBuildVersion_ModifiedDate to [dbo].[AWBuildVersion]'
GO
ALTER TABLE [dbo].[AWBuildVersion]
	ADD
	CONSTRAINT [DF_AWBuildVersion_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [dbo].[AWBuildVersion] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [dbo].[DatabaseLog]'
GO
CREATE TABLE [dbo].[DatabaseLog] (
		[DatabaseLogID]     [int] IDENTITY(1, 1) NOT NULL,
		[PostTime]          [datetime] NOT NULL,
		[DatabaseUser]      [sysname] NOT NULL,
		[Event]             [sysname] NOT NULL,
		[Schema]            [sysname] NULL,
		[Object]            [sysname] NULL,
		[TSQL]              [nvarchar](max) NOT NULL,
		[XmlEvent]          [xml] NOT NULL
)
GO


Print 'Add Primary Key PK_DatabaseLog_DatabaseLogID to [dbo].[DatabaseLog]'
GO
ALTER TABLE [dbo].[DatabaseLog]
	ADD
	CONSTRAINT [PK_DatabaseLog_DatabaseLogID]
	PRIMARY KEY
	NONCLUSTERED
	([DatabaseLogID])
	ON [PRIMARY]
GO


ALTER TABLE [dbo].[DatabaseLog] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [dbo].[ErrorLog]'
GO
CREATE TABLE [dbo].[ErrorLog] (
		[ErrorLogID]         [int] IDENTITY(1, 1) NOT NULL,
		[ErrorTime]          [datetime] NOT NULL,
		[UserName]           [sysname] NOT NULL,
		[ErrorNumber]        [int] NOT NULL,
		[ErrorSeverity]      [int] NULL,
		[ErrorState]         [int] NULL,
		[ErrorProcedure]     [nvarchar](126) NULL,
		[ErrorLine]          [int] NULL,
		[ErrorMessage]       [nvarchar](4000) NOT NULL
)
GO


Print 'Add Primary Key PK_ErrorLog_ErrorLogID to [dbo].[ErrorLog]'
GO
ALTER TABLE [dbo].[ErrorLog]
	ADD
	CONSTRAINT [PK_ErrorLog_ErrorLogID]
	PRIMARY KEY
	CLUSTERED
	([ErrorLogID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ErrorLog_ErrorTime to [dbo].[ErrorLog]'
GO
ALTER TABLE [dbo].[ErrorLog]
	ADD
	CONSTRAINT [DF_ErrorLog_ErrorTime]
	DEFAULT (getdate()) FOR [ErrorTime]
GO


ALTER TABLE [dbo].[ErrorLog] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Function [dbo].[ufnGetAccountingEndDate]'
GO
CREATE FUNCTION [dbo].[ufnGetAccountingEndDate]()
RETURNS [datetime] 
AS 
BEGIN
    RETURN DATEADD(millisecond, -2, CONVERT(datetime, '20040701', 112));
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetAccountingEndDate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Scalar function used in the uSalesOrderHeader trigger to set the starting account date.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetAccountingEndDate', NULL, NULL
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Function [dbo].[ufnLeadingZeros]'
GO
CREATE FUNCTION [dbo].[ufnLeadingZeros](
    @Value int
) 
RETURNS varchar(8) 
WITH SCHEMABINDING 
AS 
BEGIN
    DECLARE @ReturnValue varchar(8);

    SET @ReturnValue = CONVERT(varchar(8), @Value);
    SET @ReturnValue = REPLICATE('0', 8 - DATALENGTH(@ReturnValue)) + @ReturnValue;

    RETURN (@ReturnValue);
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnLeadingZeros]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Scalar function used by the Sales.Customer table to help set the account number.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnLeadingZeros', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnLeadingZeros]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the scalar function ufnLeadingZeros. Enter a valid integer.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnLeadingZeros', 'PARAMETER', N'@Value'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Function [dbo].[ufnGetPurchaseOrderStatusText]'
GO
CREATE FUNCTION [dbo].[ufnGetPurchaseOrderStatusText](@Status [tinyint])
RETURNS [nvarchar](15) 
AS 
-- Returns the sales order status text representation for the status value.
BEGIN
    DECLARE @ret [nvarchar](15);

    SET @ret = 
        CASE @Status
            WHEN 1 THEN 'Pending'
            WHEN 2 THEN 'Approved'
            WHEN 3 THEN 'Rejected'
            WHEN 4 THEN 'Complete'
            ELSE '** Invalid **'
        END;
    
    RETURN @ret
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetPurchaseOrderStatusText]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Scalar function returning the text representation of the Status column in the PurchaseOrderHeader table.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetPurchaseOrderStatusText', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetPurchaseOrderStatusText]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the scalar function ufnGetPurchaseOrdertStatusText. Enter a valid integer.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetPurchaseOrderStatusText', 'PARAMETER', N'@Status'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Function [dbo].[ufnGetDocumentStatusText]'
GO
CREATE FUNCTION [dbo].[ufnGetDocumentStatusText](@Status [tinyint])
RETURNS [nvarchar](16) 
AS 
-- Returns the sales order status text representation for the status value.
BEGIN
    DECLARE @ret [nvarchar](16);

    SET @ret = 
        CASE @Status
            WHEN 1 THEN N'Pending approval'
            WHEN 2 THEN N'Approved'
            WHEN 3 THEN N'Obsolete'
            ELSE N'** Invalid **'
        END;
    
    RETURN @ret
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetDocumentStatusText]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Scalar function returning the text representation of the Status column in the Document table.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetDocumentStatusText', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetDocumentStatusText]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the scalar function ufnGetDocumentStatusText. Enter a valid integer.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetDocumentStatusText', 'PARAMETER', N'@Status'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Function [dbo].[ufnGetAccountingStartDate]'
GO
CREATE FUNCTION [dbo].[ufnGetAccountingStartDate]()
RETURNS [datetime] 
AS 
BEGIN
    RETURN CONVERT(datetime, '20030701', 112);
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetAccountingStartDate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Scalar function used in the uSalesOrderHeader trigger to set the ending account date.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetAccountingStartDate', NULL, NULL
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Function [dbo].[ufnGetSalesOrderStatusText]'
GO
CREATE FUNCTION [dbo].[ufnGetSalesOrderStatusText](@Status [tinyint])
RETURNS [nvarchar](15) 
AS 
-- Returns the sales order status text representation for the status value.
BEGIN
    DECLARE @ret [nvarchar](15);

    SET @ret = 
        CASE @Status
            WHEN 1 THEN 'In process'
            WHEN 2 THEN 'Approved'
            WHEN 3 THEN 'Backordered'
            WHEN 4 THEN 'Rejected'
            WHEN 5 THEN 'Shipped'
            WHEN 6 THEN 'Cancelled'
            ELSE '** Invalid **'
        END;
    
    RETURN @ret
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetSalesOrderStatusText]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Scalar function returning the text representation of the Status column in the SalesOrderHeader table.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetSalesOrderStatusText', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetSalesOrderStatusText]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the scalar function ufnGetSalesOrderStatusText. Enter a valid integer.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetSalesOrderStatusText', 'PARAMETER', N'@Status'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Procedure [dbo].[uspPrintError]'
GO
-- uspPrintError prints error information about the error that caused 
-- execution to jump to the CATCH block of a TRY...CATCH construct. 
-- Should be executed from within the scope of a CATCH block otherwise 
-- it will return without printing any error information.
CREATE PROCEDURE [dbo].[uspPrintError] 
AS
BEGIN
    SET NOCOUNT ON;

    -- Print error information. 
    PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) +
          ', Severity ' + CONVERT(varchar(5), ERROR_SEVERITY()) +
          ', State ' + CONVERT(varchar(5), ERROR_STATE()) + 
          ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') + 
          ', Line ' + CONVERT(varchar(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[uspPrintError]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Prints error information about the error that caused execution to jump to the CATCH block of a TRY...CATCH construct. Should be executed from within the scope of a CATCH block otherwise it will return without printing any error information.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspPrintError', NULL, NULL
GO


Print 'Create Xml Schema Collection [Production].[ProductDescriptionSchemaCollection]'
GO
CREATE XML SCHEMA COLLECTION [Production].[ProductDescriptionSchemaCollection] AS
N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain" elementFormDefault="qualified"><xsd:element name="Maintenance"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="NoOfYears" type="xsd:string" /><xsd:element name="Description" type="xsd:string" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element><xsd:element name="Warranty"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="WarrantyPeriod" type="xsd:string" /><xsd:element name="Description" type="xsd:string" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:schema><xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:ns1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription" elementFormDefault="qualified"><xsd:import namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain" /><xsd:element name="Code" type="xsd:string" /><xsd:element name="Description" type="xsd:string" /><xsd:element name="ProductDescription" type="t:ProductDescription" /><xsd:element name="Taxonomy" type="xsd:string" /><xsd:complexType name="Category"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element ref="t:Taxonomy" /><xsd:element ref="t:Code" /><xsd:element ref="t:Description" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="Features" mixed="true"><xsd:complexContent mixed="true"><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element ref="ns1:Warranty" /><xsd:element ref="ns1:Maintenance" /><xsd:any namespace="##other" processContents="skip" minOccurs="0" maxOccurs="unbounded" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="Manufacturer"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Name" type="xsd:string" minOccurs="0" /><xsd:element name="CopyrightURL" type="xsd:string" minOccurs="0" /><xsd:element name="Copyright" type="xsd:string" minOccurs="0" /><xsd:element name="ProductURL" type="xsd:string" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="Picture"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Name" type="xsd:string" minOccurs="0" /><xsd:element name="Angle" type="xsd:string" minOccurs="0" /><xsd:element name="Size" type="xsd:string" minOccurs="0" /><xsd:element name="ProductPhotoID" type="xsd:integer" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="ProductDescription"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Summary" type="t:Summary" minOccurs="0" /><xsd:element name="Manufacturer" type="t:Manufacturer" minOccurs="0" /><xsd:element name="Features" type="t:Features" minOccurs="0" maxOccurs="unbounded" /><xsd:element name="Picture" type="t:Picture" minOccurs="0" maxOccurs="unbounded" /><xsd:element name="Category" type="t:Category" minOccurs="0" maxOccurs="unbounded" /><xsd:element name="Specifications" type="t:Specifications" minOccurs="0" maxOccurs="unbounded" /></xsd:sequence><xsd:attribute name="ProductModelID" type="xsd:string" /><xsd:attribute name="ProductModelName" type="xsd:string" /></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="Specifications" mixed="true"><xsd:complexContent mixed="true"><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:any processContents="skip" minOccurs="0" maxOccurs="unbounded" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="Summary" mixed="true"><xsd:complexContent mixed="true"><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:any namespace="http://www.w3.org/1999/xhtml" processContents="skip" minOccurs="0" maxOccurs="unbounded" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:schema>'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDescriptionSchemaCollection]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collection of XML schemas for the CatalogDescription column in the Production.ProductModel table.', 'SCHEMA', N'Production', 'XML SCHEMA COLLECTION', N'ProductDescriptionSchemaCollection', NULL, NULL
GO


Print 'Create Xml Schema Collection [Person].[AdditionalContactInfoSchemaCollection]'
GO
CREATE XML SCHEMA COLLECTION [Person].[AdditionalContactInfoSchemaCollection] AS
N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"><xsd:element name="AdditionalContactInfo"><xsd:complexType mixed="true"><xsd:complexContent mixed="true"><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:any namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" minOccurs="0" maxOccurs="unbounded" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:schema><xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord"><xsd:element name="ContactRecord"><xsd:complexType mixed="true"><xsd:complexContent mixed="true"><xsd:restriction base="xsd:anyType"><xsd:choice minOccurs="0" maxOccurs="unbounded"><xsd:any namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" /></xsd:choice><xsd:attribute name="date" type="xsd:date" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:schema><xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" elementFormDefault="qualified"><xsd:element name="eMail" type="t:eMailType" /><xsd:element name="facsimileTelephoneNumber" type="t:phoneNumberType" /><xsd:element name="homePostalAddress" type="t:addressType" /><xsd:element name="internationaliSDNNumber" type="t:phoneNumberType" /><xsd:element name="mobile" type="t:phoneNumberType" /><xsd:element name="pager" type="t:phoneNumberType" /><xsd:element name="physicalDeliveryOfficeName" type="t:addressType" /><xsd:element name="registeredAddress" type="t:addressType" /><xsd:element name="telephoneNumber" type="t:phoneNumberType" /><xsd:element name="telexNumber" type="t:phoneNumberType" /><xsd:complexType name="addressType"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Street" type="xsd:string" maxOccurs="2" /><xsd:element name="City" type="xsd:string" /><xsd:element name="StateProvince" type="xsd:string" /><xsd:element name="PostalCode" type="xsd:string" minOccurs="0" /><xsd:element name="CountryRegion" type="xsd:string" /><xsd:element name="SpecialInstructions" type="t:specialInstructionsType" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="eMailType"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="eMailAddress" type="xsd:string" /><xsd:element name="SpecialInstructions" type="t:specialInstructionsType" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="phoneNumberType"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="number"><xsd:simpleType><xsd:restriction base="xsd:string"><xsd:pattern value="[0-9\(\)\-]*" /></xsd:restriction></xsd:simpleType></xsd:element><xsd:element name="SpecialInstructions" type="t:specialInstructionsType" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="specialInstructionsType" mixed="true"><xsd:complexContent mixed="true"><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:any namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" minOccurs="0" maxOccurs="unbounded" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:schema>'
GO


Print 'Create Extended Property MS_Description on [Person].[AdditionalContactInfoSchemaCollection]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collection of XML schemas for the AdditionalContactInfo column in the Person.Contact table.', 'SCHEMA', N'Person', 'XML SCHEMA COLLECTION', N'AdditionalContactInfoSchemaCollection', NULL, NULL
GO


Print 'Create Xml Schema Collection [Person].[IndividualSurveySchemaCollection]'
GO
CREATE XML SCHEMA COLLECTION [Person].[IndividualSurveySchemaCollection] AS
N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey" elementFormDefault="qualified"><xsd:element name="IndividualSurvey"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="TotalPurchaseYTD" type="xsd:decimal" minOccurs="0" /><xsd:element name="DateFirstPurchase" type="xsd:date" minOccurs="0" /><xsd:element name="BirthDate" type="xsd:date" minOccurs="0" /><xsd:element name="MaritalStatus" type="xsd:string" minOccurs="0" /><xsd:element name="YearlyIncome" type="t:SalaryType" minOccurs="0" /><xsd:element name="Gender" type="xsd:string" minOccurs="0" /><xsd:element name="TotalChildren" type="xsd:int" minOccurs="0" /><xsd:element name="NumberChildrenAtHome" type="xsd:int" minOccurs="0" /><xsd:element name="Education" type="xsd:string" minOccurs="0" /><xsd:element name="Occupation" type="xsd:string" minOccurs="0" /><xsd:element name="HomeOwnerFlag" type="xsd:string" minOccurs="0" /><xsd:element name="NumberCarsOwned" type="xsd:int" minOccurs="0" /><xsd:element name="Hobby" type="xsd:string" minOccurs="0" maxOccurs="unbounded" /><xsd:element name="CommuteDistance" type="t:MileRangeType" minOccurs="0" /><xsd:element name="Comments" type="xsd:string" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element><xsd:simpleType name="MileRangeType"><xsd:restriction base="xsd:string"><xsd:enumeration value="0-1 Miles" /><xsd:enumeration value="1-2 Miles" /><xsd:enumeration value="2-5 Miles" /><xsd:enumeration value="5-10 Miles" /><xsd:enumeration value="10+ Miles" /></xsd:restriction></xsd:simpleType><xsd:simpleType name="SalaryType"><xsd:restriction base="xsd:string"><xsd:enumeration value="0-25000" /><xsd:enumeration value="25001-50000" /><xsd:enumeration value="50001-75000" /><xsd:enumeration value="75001-100000" /><xsd:enumeration value="greater than 100000" /></xsd:restriction></xsd:simpleType></xsd:schema>'
GO


Print 'Create Extended Property MS_Description on [Person].[IndividualSurveySchemaCollection]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collection of XML schemas for the Demographics column in the Person.Person table.', 'SCHEMA', N'Person', 'XML SCHEMA COLLECTION', N'IndividualSurveySchemaCollection', NULL, NULL
GO


Print 'Create Xml Schema Collection [Production].[ManuInstructionsSchemaCollection]'
GO
CREATE XML SCHEMA COLLECTION [Production].[ManuInstructionsSchemaCollection] AS
N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions" elementFormDefault="qualified"><xsd:element name="root"><xsd:complexType mixed="true"><xsd:complexContent mixed="true"><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Location" maxOccurs="unbounded"><xsd:complexType mixed="true"><xsd:complexContent mixed="true"><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="step" type="t:StepType" maxOccurs="unbounded" /></xsd:sequence><xsd:attribute name="LocationID" type="xsd:integer" use="required" /><xsd:attribute name="SetupHours" type="xsd:decimal" /><xsd:attribute name="MachineHours" type="xsd:decimal" /><xsd:attribute name="LaborHours" type="xsd:decimal" /><xsd:attribute name="LotSize" type="xsd:decimal" /></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element><xsd:complexType name="StepType" mixed="true"><xsd:complexContent mixed="true"><xsd:restriction base="xsd:anyType"><xsd:choice minOccurs="0" maxOccurs="unbounded"><xsd:element name="tool" type="xsd:string" /><xsd:element name="material" type="xsd:string" /><xsd:element name="blueprint" type="xsd:string" /><xsd:element name="specs" type="xsd:string" /><xsd:element name="diag" type="xsd:string" /></xsd:choice></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:schema>'
GO


Print 'Create Extended Property MS_Description on [Production].[ManuInstructionsSchemaCollection]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collection of XML schemas for the Instructions column in the Production.ProductModel table.', 'SCHEMA', N'Production', 'XML SCHEMA COLLECTION', N'ManuInstructionsSchemaCollection', NULL, NULL
GO


Print 'Create Xml Schema Collection [HumanResources].[HRResumeSchemaCollection]'
GO
CREATE XML SCHEMA COLLECTION [HumanResources].[HRResumeSchemaCollection] AS
N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume" elementFormDefault="qualified"><xsd:element name="Address" type="t:AddressType" /><xsd:element name="Education" type="t:EducationType" /><xsd:element name="Employment" type="t:EmploymentType" /><xsd:element name="Location" type="t:LocationType" /><xsd:element name="Name" type="t:NameType" /><xsd:element name="Resume" type="t:ResumeType" /><xsd:element name="Telephone" type="t:TelephoneType" /><xsd:complexType name="AddressType"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Addr.Type" type="xsd:string" /><xsd:element name="Addr.OrgName" type="xsd:string" minOccurs="0" /><xsd:element name="Addr.Street" type="xsd:string" maxOccurs="unbounded" /><xsd:element name="Addr.Location"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element ref="t:Location" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element><xsd:element name="Addr.PostalCode" type="xsd:string" /><xsd:element name="Addr.Telephone" minOccurs="0"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element ref="t:Telephone" maxOccurs="unbounded" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="EducationType"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Edu.Level" type="xsd:string" /><xsd:element name="Edu.StartDate" type="xsd:date" /><xsd:element name="Edu.EndDate" type="xsd:date" /><xsd:element name="Edu.Degree" type="xsd:string" minOccurs="0" /><xsd:element name="Edu.Major" type="xsd:string" minOccurs="0" /><xsd:element name="Edu.Minor" type="xsd:string" minOccurs="0" /><xsd:element name="Edu.GPA" type="xsd:string" minOccurs="0" /><xsd:element name="Edu.GPAAlternate" type="xsd:decimal" minOccurs="0" /><xsd:element name="Edu.GPAScale" type="xsd:decimal" minOccurs="0" /><xsd:element name="Edu.School" type="xsd:string" minOccurs="0" /><xsd:element name="Edu.Location" minOccurs="0"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element ref="t:Location" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="EmploymentType"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Emp.StartDate" type="xsd:date" minOccurs="0" /><xsd:element name="Emp.EndDate" type="xsd:date" minOccurs="0" /><xsd:element name="Emp.OrgName" type="xsd:string" /><xsd:element name="Emp.JobTitle" type="xsd:string" /><xsd:element name="Emp.Responsibility" type="xsd:string" /><xsd:element name="Emp.FunctionCategory" type="xsd:string" minOccurs="0" /><xsd:element name="Emp.IndustryCategory" type="xsd:string" minOccurs="0" /><xsd:element name="Emp.Location" minOccurs="0"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element ref="t:Location" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="LocationType"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Loc.CountryRegion" type="xsd:string" /><xsd:element name="Loc.State" type="xsd:string" minOccurs="0" /><xsd:element name="Loc.City" type="xsd:string" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="NameType"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Name.Prefix" type="xsd:string" minOccurs="0" /><xsd:element name="Name.First" type="xsd:string" /><xsd:element name="Name.Middle" type="xsd:string" minOccurs="0" /><xsd:element name="Name.Last" type="xsd:string" /><xsd:element name="Name.Suffix" type="xsd:string" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="ResumeType"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element ref="t:Name" /><xsd:element name="Skills" type="xsd:string" minOccurs="0" /><xsd:element ref="t:Employment" maxOccurs="unbounded" /><xsd:element ref="t:Education" maxOccurs="unbounded" /><xsd:element ref="t:Address" maxOccurs="unbounded" /><xsd:element ref="t:Telephone" minOccurs="0" /><xsd:element name="EMail" type="xsd:string" minOccurs="0" /><xsd:element name="WebSite" type="xsd:string" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType><xsd:complexType name="TelephoneType"><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="Tel.Type" type="xsd:anyType" minOccurs="0" /><xsd:element name="Tel.IntlCode" type="xsd:int" minOccurs="0" /><xsd:element name="Tel.AreaCode" type="xsd:int" minOccurs="0" /><xsd:element name="Tel.Number" type="xsd:string" /><xsd:element name="Tel.Extension" type="xsd:int" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:schema>'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[HRResumeSchemaCollection]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collection of XML schemas for the Resume column in the HumanResources.JobCandidate table.', 'SCHEMA', N'HumanResources', 'XML SCHEMA COLLECTION', N'HRResumeSchemaCollection', NULL, NULL
GO


Print 'Create Xml Schema Collection [Sales].[StoreSurveySchemaCollection]'
GO
CREATE XML SCHEMA COLLECTION [Sales].[StoreSurveySchemaCollection] AS
N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey" elementFormDefault="qualified"><xsd:element name="StoreSurvey"><xsd:complexType><xsd:complexContent><xsd:restriction base="xsd:anyType"><xsd:sequence><xsd:element name="ContactName" type="xsd:string" minOccurs="0" /><xsd:element name="JobTitle" type="xsd:string" minOccurs="0" /><xsd:element name="AnnualSales" type="xsd:decimal" minOccurs="0" /><xsd:element name="AnnualRevenue" type="xsd:decimal" minOccurs="0" /><xsd:element name="BankName" type="xsd:string" minOccurs="0" /><xsd:element name="BusinessType" type="t:BusinessType" minOccurs="0" /><xsd:element name="YearOpened" type="xsd:gYear" minOccurs="0" /><xsd:element name="Specialty" type="t:SpecialtyType" minOccurs="0" /><xsd:element name="SquareFeet" type="xsd:float" minOccurs="0" /><xsd:element name="Brands" type="t:BrandType" minOccurs="0" /><xsd:element name="Internet" type="t:InternetType" minOccurs="0" /><xsd:element name="NumberEmployees" type="xsd:int" minOccurs="0" /><xsd:element name="Comments" type="xsd:string" minOccurs="0" /></xsd:sequence></xsd:restriction></xsd:complexContent></xsd:complexType></xsd:element><xsd:simpleType name="BrandType"><xsd:restriction base="xsd:string"><xsd:enumeration value="AW" /><xsd:enumeration value="2" /><xsd:enumeration value="3" /><xsd:enumeration value="4+" /></xsd:restriction></xsd:simpleType><xsd:simpleType name="BusinessType"><xsd:restriction base="xsd:string"><xsd:enumeration value="BM" /><xsd:enumeration value="BS" /><xsd:enumeration value="D" /><xsd:enumeration value="OS" /><xsd:enumeration value="SGS" /></xsd:restriction></xsd:simpleType><xsd:simpleType name="InternetType"><xsd:restriction base="xsd:string"><xsd:enumeration value="56kb" /><xsd:enumeration value="ISDN" /><xsd:enumeration value="DSL" /><xsd:enumeration value="T1" /><xsd:enumeration value="T2" /><xsd:enumeration value="T3" /></xsd:restriction></xsd:simpleType><xsd:simpleType name="SpecialtyType"><xsd:restriction base="xsd:string"><xsd:enumeration value="Family" /><xsd:enumeration value="Kids" /><xsd:enumeration value="BMX" /><xsd:enumeration value="Touring" /><xsd:enumeration value="Road" /><xsd:enumeration value="Mountain" /><xsd:enumeration value="All" /></xsd:restriction></xsd:simpleType></xsd:schema>'
GO


Print 'Create Extended Property MS_Description on [Sales].[StoreSurveySchemaCollection]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collection of XML schemas for the Demographics column in the Sales.Store table.', 'SCHEMA', N'Sales', 'XML SCHEMA COLLECTION', N'StoreSurveySchemaCollection', NULL, NULL
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductPhoto]'
GO
CREATE TABLE [Production].[ProductPhoto] (
		[ProductPhotoID]             [int] IDENTITY(1, 1) NOT NULL,
		[ThumbNailPhoto]             [varbinary](max) NULL,
		[ThumbnailPhotoFileName]     [nvarchar](50) NULL,
		[LargePhoto]                 [varbinary](max) NULL,
		[LargePhotoFileName]         [nvarchar](50) NULL,
		[ModifiedDate]               [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductPhoto_ProductPhotoID to [Production].[ProductPhoto]'
GO
ALTER TABLE [Production].[ProductPhoto]
	ADD
	CONSTRAINT [PK_ProductPhoto_ProductPhotoID]
	PRIMARY KEY
	CLUSTERED
	([ProductPhotoID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductPhoto_ModifiedDate to [Production].[ProductPhoto]'
GO
ALTER TABLE [Production].[ProductPhoto]
	ADD
	CONSTRAINT [DF_ProductPhoto_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [Production].[ProductPhoto] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[Location]'
GO
CREATE TABLE [Production].[Location] (
		[LocationID]       [smallint] IDENTITY(1, 1) NOT NULL,
		[Name]             [dbo].[Name] NOT NULL,
		[CostRate]         [smallmoney] NOT NULL,
		[Availability]     [decimal](8, 2) NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Location_LocationID to [Production].[Location]'
GO
ALTER TABLE [Production].[Location]
	ADD
	CONSTRAINT [PK_Location_LocationID]
	PRIMARY KEY
	CLUSTERED
	([LocationID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Location_Availability to [Production].[Location]'
GO
ALTER TABLE [Production].[Location]
	ADD
	CONSTRAINT [DF_Location_Availability]
	DEFAULT ((0.00)) FOR [Availability]
GO


Print 'Add Default Constraint DF_Location_CostRate to [Production].[Location]'
GO
ALTER TABLE [Production].[Location]
	ADD
	CONSTRAINT [DF_Location_CostRate]
	DEFAULT ((0.00)) FOR [CostRate]
GO


Print 'Add Default Constraint DF_Location_ModifiedDate to [Production].[Location]'
GO
ALTER TABLE [Production].[Location]
	ADD
	CONSTRAINT [DF_Location_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index AK_Location_Name on [Production].[Location]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Location_Name]
	ON [Production].[Location] ([Name])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[Location] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[PhoneNumberType]'
GO
CREATE TABLE [Person].[PhoneNumberType] (
		[PhoneNumberTypeID]     [int] IDENTITY(1, 1) NOT NULL,
		[Name]                  [dbo].[Name] NOT NULL,
		[ModifiedDate]          [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_PhoneNumberType_PhoneNumberTypeID to [Person].[PhoneNumberType]'
GO
ALTER TABLE [Person].[PhoneNumberType]
	ADD
	CONSTRAINT [PK_PhoneNumberType_PhoneNumberTypeID]
	PRIMARY KEY
	CLUSTERED
	([PhoneNumberTypeID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_PhoneNumberType_ModifiedDate to [Person].[PhoneNumberType]'
GO
ALTER TABLE [Person].[PhoneNumberType]
	ADD
	CONSTRAINT [DF_PhoneNumberType_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [Person].[PhoneNumberType] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductCategory]'
GO
CREATE TABLE [Production].[ProductCategory] (
		[ProductCategoryID]     [int] IDENTITY(1, 1) NOT NULL,
		[Name]                  [dbo].[Name] NOT NULL,
		[rowguid]               [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]          [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductCategory_ProductCategoryID to [Production].[ProductCategory]'
GO
ALTER TABLE [Production].[ProductCategory]
	ADD
	CONSTRAINT [PK_ProductCategory_ProductCategoryID]
	PRIMARY KEY
	CLUSTERED
	([ProductCategoryID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductCategory_ModifiedDate to [Production].[ProductCategory]'
GO
ALTER TABLE [Production].[ProductCategory]
	ADD
	CONSTRAINT [DF_ProductCategory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_ProductCategory_rowguid to [Production].[ProductCategory]'
GO
ALTER TABLE [Production].[ProductCategory]
	ADD
	CONSTRAINT [DF_ProductCategory_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_ProductCategory_Name on [Production].[ProductCategory]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ProductCategory_Name]
	ON [Production].[ProductCategory] ([Name])
	ON [PRIMARY]
GO


Print 'Create Index AK_ProductCategory_rowguid on [Production].[ProductCategory]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ProductCategory_rowguid]
	ON [Production].[ProductCategory] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[ProductCategory] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductDescription]'
GO
CREATE TABLE [Production].[ProductDescription] (
		[ProductDescriptionID]     [int] IDENTITY(1, 1) NOT NULL,
		[Description]              [nvarchar](400) NOT NULL,
		[rowguid]                  [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]             [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductDescription_ProductDescriptionID to [Production].[ProductDescription]'
GO
ALTER TABLE [Production].[ProductDescription]
	ADD
	CONSTRAINT [PK_ProductDescription_ProductDescriptionID]
	PRIMARY KEY
	CLUSTERED
	([ProductDescriptionID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductDescription_ModifiedDate to [Production].[ProductDescription]'
GO
ALTER TABLE [Production].[ProductDescription]
	ADD
	CONSTRAINT [DF_ProductDescription_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_ProductDescription_rowguid to [Production].[ProductDescription]'
GO
ALTER TABLE [Production].[ProductDescription]
	ADD
	CONSTRAINT [DF_ProductDescription_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_ProductDescription_rowguid on [Production].[ProductDescription]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ProductDescription_rowguid]
	ON [Production].[ProductDescription] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[ProductDescription] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[CountryRegion]'
GO
CREATE TABLE [Person].[CountryRegion] (
		[CountryRegionCode]     [nvarchar](3) NOT NULL,
		[Name]                  [dbo].[Name] NOT NULL,
		[ModifiedDate]          [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_CountryRegion_CountryRegionCode to [Person].[CountryRegion]'
GO
ALTER TABLE [Person].[CountryRegion]
	ADD
	CONSTRAINT [PK_CountryRegion_CountryRegionCode]
	PRIMARY KEY
	CLUSTERED
	([CountryRegionCode])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_CountryRegion_ModifiedDate to [Person].[CountryRegion]'
GO
ALTER TABLE [Person].[CountryRegion]
	ADD
	CONSTRAINT [DF_CountryRegion_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index AK_CountryRegion_Name on [Person].[CountryRegion]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_CountryRegion_Name]
	ON [Person].[CountryRegion] ([Name])
	ON [PRIMARY]
GO


ALTER TABLE [Person].[CountryRegion] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[ContactType]'
GO
CREATE TABLE [Person].[ContactType] (
		[ContactTypeID]     [int] IDENTITY(1, 1) NOT NULL,
		[Name]              [dbo].[Name] NOT NULL,
		[ModifiedDate]      [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ContactType_ContactTypeID to [Person].[ContactType]'
GO
ALTER TABLE [Person].[ContactType]
	ADD
	CONSTRAINT [PK_ContactType_ContactTypeID]
	PRIMARY KEY
	CLUSTERED
	([ContactTypeID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ContactType_ModifiedDate to [Person].[ContactType]'
GO
ALTER TABLE [Person].[ContactType]
	ADD
	CONSTRAINT [DF_ContactType_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index AK_ContactType_Name on [Person].[ContactType]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ContactType_Name]
	ON [Person].[ContactType] ([Name])
	ON [PRIMARY]
GO


ALTER TABLE [Person].[ContactType] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ScrapReason]'
GO
CREATE TABLE [Production].[ScrapReason] (
		[ScrapReasonID]     [smallint] IDENTITY(1, 1) NOT NULL,
		[Name]              [dbo].[Name] NOT NULL,
		[ModifiedDate]      [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ScrapReason_ScrapReasonID to [Production].[ScrapReason]'
GO
ALTER TABLE [Production].[ScrapReason]
	ADD
	CONSTRAINT [PK_ScrapReason_ScrapReasonID]
	PRIMARY KEY
	CLUSTERED
	([ScrapReasonID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ScrapReason_ModifiedDate to [Production].[ScrapReason]'
GO
ALTER TABLE [Production].[ScrapReason]
	ADD
	CONSTRAINT [DF_ScrapReason_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index AK_ScrapReason_Name on [Production].[ScrapReason]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ScrapReason_Name]
	ON [Production].[ScrapReason] ([Name])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[ScrapReason] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[TransactionHistoryArchive]'
GO
CREATE TABLE [Production].[TransactionHistoryArchive] (
		[TransactionID]            [int] NOT NULL,
		[ProductID]                [int] NOT NULL,
		[ReferenceOrderID]         [int] NOT NULL,
		[ReferenceOrderLineID]     [int] NOT NULL,
		[TransactionDate]          [datetime] NOT NULL,
		[TransactionType]          [nchar](1) NOT NULL,
		[Quantity]                 [int] NOT NULL,
		[ActualCost]               [money] NOT NULL,
		[ModifiedDate]             [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_TransactionHistoryArchive_TransactionID to [Production].[TransactionHistoryArchive]'
GO
ALTER TABLE [Production].[TransactionHistoryArchive]
	ADD
	CONSTRAINT [PK_TransactionHistoryArchive_TransactionID]
	PRIMARY KEY
	CLUSTERED
	([TransactionID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_TransactionHistoryArchive_ModifiedDate to [Production].[TransactionHistoryArchive]'
GO
ALTER TABLE [Production].[TransactionHistoryArchive]
	ADD
	CONSTRAINT [DF_TransactionHistoryArchive_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_TransactionHistoryArchive_ReferenceOrderLineID to [Production].[TransactionHistoryArchive]'
GO
ALTER TABLE [Production].[TransactionHistoryArchive]
	ADD
	CONSTRAINT [DF_TransactionHistoryArchive_ReferenceOrderLineID]
	DEFAULT ((0)) FOR [ReferenceOrderLineID]
GO


Print 'Add Default Constraint DF_TransactionHistoryArchive_TransactionDate to [Production].[TransactionHistoryArchive]'
GO
ALTER TABLE [Production].[TransactionHistoryArchive]
	ADD
	CONSTRAINT [DF_TransactionHistoryArchive_TransactionDate]
	DEFAULT (getdate()) FOR [TransactionDate]
GO


Print 'Create Index IX_TransactionHistoryArchive_ProductID on [Production].[TransactionHistoryArchive]'
GO
CREATE NONCLUSTERED INDEX [IX_TransactionHistoryArchive_ProductID]
	ON [Production].[TransactionHistoryArchive] ([ProductID])
	ON [PRIMARY]
GO


Print 'Create Index IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID on [Production].[TransactionHistoryArchive]'
GO
CREATE NONCLUSTERED INDEX [IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID]
	ON [Production].[TransactionHistoryArchive] ([ReferenceOrderID], [ReferenceOrderLineID])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[TransactionHistoryArchive] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[BusinessEntity]'
GO
CREATE TABLE [Person].[BusinessEntity] (
		[BusinessEntityID]     [int] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
		[rowguid]              [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_BusinessEntity_BusinessEntityID to [Person].[BusinessEntity]'
GO
ALTER TABLE [Person].[BusinessEntity]
	ADD
	CONSTRAINT [PK_BusinessEntity_BusinessEntityID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_BusinessEntity_ModifiedDate to [Person].[BusinessEntity]'
GO
ALTER TABLE [Person].[BusinessEntity]
	ADD
	CONSTRAINT [DF_BusinessEntity_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_BusinessEntity_rowguid to [Person].[BusinessEntity]'
GO
ALTER TABLE [Person].[BusinessEntity]
	ADD
	CONSTRAINT [DF_BusinessEntity_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_BusinessEntity_rowguid on [Person].[BusinessEntity]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_BusinessEntity_rowguid]
	ON [Person].[BusinessEntity] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Person].[BusinessEntity] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[Illustration]'
GO
CREATE TABLE [Production].[Illustration] (
		[IllustrationID]     [int] IDENTITY(1, 1) NOT NULL,
		[Diagram]            [xml] NULL,
		[ModifiedDate]       [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Illustration_IllustrationID to [Production].[Illustration]'
GO
ALTER TABLE [Production].[Illustration]
	ADD
	CONSTRAINT [PK_Illustration_IllustrationID]
	PRIMARY KEY
	CLUSTERED
	([IllustrationID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Illustration_ModifiedDate to [Production].[Illustration]'
GO
ALTER TABLE [Production].[Illustration]
	ADD
	CONSTRAINT [DF_Illustration_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [Production].[Illustration] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[UnitMeasure]'
GO
CREATE TABLE [Production].[UnitMeasure] (
		[UnitMeasureCode]     [nchar](3) NOT NULL,
		[Name]                [dbo].[Name] NOT NULL,
		[ModifiedDate]        [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_UnitMeasure_UnitMeasureCode to [Production].[UnitMeasure]'
GO
ALTER TABLE [Production].[UnitMeasure]
	ADD
	CONSTRAINT [PK_UnitMeasure_UnitMeasureCode]
	PRIMARY KEY
	CLUSTERED
	([UnitMeasureCode])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_UnitMeasure_ModifiedDate to [Production].[UnitMeasure]'
GO
ALTER TABLE [Production].[UnitMeasure]
	ADD
	CONSTRAINT [DF_UnitMeasure_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index AK_UnitMeasure_Name on [Production].[UnitMeasure]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_UnitMeasure_Name]
	ON [Production].[UnitMeasure] ([Name])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[UnitMeasure] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[AddressType]'
GO
CREATE TABLE [Person].[AddressType] (
		[AddressTypeID]     [int] IDENTITY(1, 1) NOT NULL,
		[Name]              [dbo].[Name] NOT NULL,
		[rowguid]           [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]      [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_AddressType_AddressTypeID to [Person].[AddressType]'
GO
ALTER TABLE [Person].[AddressType]
	ADD
	CONSTRAINT [PK_AddressType_AddressTypeID]
	PRIMARY KEY
	CLUSTERED
	([AddressTypeID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_AddressType_ModifiedDate to [Person].[AddressType]'
GO
ALTER TABLE [Person].[AddressType]
	ADD
	CONSTRAINT [DF_AddressType_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_AddressType_rowguid to [Person].[AddressType]'
GO
ALTER TABLE [Person].[AddressType]
	ADD
	CONSTRAINT [DF_AddressType_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_AddressType_Name on [Person].[AddressType]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_AddressType_Name]
	ON [Person].[AddressType] ([Name])
	ON [PRIMARY]
GO


Print 'Create Index AK_AddressType_rowguid on [Person].[AddressType]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_AddressType_rowguid]
	ON [Person].[AddressType] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Person].[AddressType] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Purchasing].[ShipMethod]'
GO
CREATE TABLE [Purchasing].[ShipMethod] (
		[ShipMethodID]     [int] IDENTITY(1, 1) NOT NULL,
		[Name]             [dbo].[Name] NOT NULL,
		[ShipBase]         [money] NOT NULL,
		[ShipRate]         [money] NOT NULL,
		[rowguid]          [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]     [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ShipMethod_ShipMethodID to [Purchasing].[ShipMethod]'
GO
ALTER TABLE [Purchasing].[ShipMethod]
	ADD
	CONSTRAINT [PK_ShipMethod_ShipMethodID]
	PRIMARY KEY
	CLUSTERED
	([ShipMethodID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ShipMethod_ModifiedDate to [Purchasing].[ShipMethod]'
GO
ALTER TABLE [Purchasing].[ShipMethod]
	ADD
	CONSTRAINT [DF_ShipMethod_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_ShipMethod_rowguid to [Purchasing].[ShipMethod]'
GO
ALTER TABLE [Purchasing].[ShipMethod]
	ADD
	CONSTRAINT [DF_ShipMethod_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Add Default Constraint DF_ShipMethod_ShipBase to [Purchasing].[ShipMethod]'
GO
ALTER TABLE [Purchasing].[ShipMethod]
	ADD
	CONSTRAINT [DF_ShipMethod_ShipBase]
	DEFAULT ((0.00)) FOR [ShipBase]
GO


Print 'Add Default Constraint DF_ShipMethod_ShipRate to [Purchasing].[ShipMethod]'
GO
ALTER TABLE [Purchasing].[ShipMethod]
	ADD
	CONSTRAINT [DF_ShipMethod_ShipRate]
	DEFAULT ((0.00)) FOR [ShipRate]
GO


Print 'Create Index AK_ShipMethod_Name on [Purchasing].[ShipMethod]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ShipMethod_Name]
	ON [Purchasing].[ShipMethod] ([Name])
	ON [PRIMARY]
GO


Print 'Create Index AK_ShipMethod_rowguid on [Purchasing].[ShipMethod]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ShipMethod_rowguid]
	ON [Purchasing].[ShipMethod] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Purchasing].[ShipMethod] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[CreditCard]'
GO
CREATE TABLE [Sales].[CreditCard] (
		[CreditCardID]     [int] IDENTITY(1, 1) NOT NULL,
		[CardType]         [nvarchar](50) NOT NULL,
		[CardNumber]       [nvarchar](25) NOT NULL,
		[ExpMonth]         [tinyint] NOT NULL,
		[ExpYear]          [smallint] NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_CreditCard_CreditCardID to [Sales].[CreditCard]'
GO
ALTER TABLE [Sales].[CreditCard]
	ADD
	CONSTRAINT [PK_CreditCard_CreditCardID]
	PRIMARY KEY
	CLUSTERED
	([CreditCardID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_CreditCard_ModifiedDate to [Sales].[CreditCard]'
GO
ALTER TABLE [Sales].[CreditCard]
	ADD
	CONSTRAINT [DF_CreditCard_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index AK_CreditCard_CardNumber on [Sales].[CreditCard]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_CreditCard_CardNumber]
	ON [Sales].[CreditCard] ([CardNumber])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[CreditCard] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[Currency]'
GO
CREATE TABLE [Sales].[Currency] (
		[CurrencyCode]     [nchar](3) NOT NULL,
		[Name]             [dbo].[Name] NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Currency_CurrencyCode to [Sales].[Currency]'
GO
ALTER TABLE [Sales].[Currency]
	ADD
	CONSTRAINT [PK_Currency_CurrencyCode]
	PRIMARY KEY
	CLUSTERED
	([CurrencyCode])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Currency_ModifiedDate to [Sales].[Currency]'
GO
ALTER TABLE [Sales].[Currency]
	ADD
	CONSTRAINT [DF_Currency_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index AK_Currency_Name on [Sales].[Currency]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Currency_Name]
	ON [Sales].[Currency] ([Name])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[Currency] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [HumanResources].[Department]'
GO
CREATE TABLE [HumanResources].[Department] (
		[DepartmentID]     [smallint] IDENTITY(1, 1) NOT NULL,
		[Name]             [dbo].[Name] NOT NULL,
		[GroupName]        [dbo].[Name] NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Department_DepartmentID to [HumanResources].[Department]'
GO
ALTER TABLE [HumanResources].[Department]
	ADD
	CONSTRAINT [PK_Department_DepartmentID]
	PRIMARY KEY
	CLUSTERED
	([DepartmentID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Department_ModifiedDate to [HumanResources].[Department]'
GO
ALTER TABLE [HumanResources].[Department]
	ADD
	CONSTRAINT [DF_Department_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index AK_Department_Name on [HumanResources].[Department]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Department_Name]
	ON [HumanResources].[Department] ([Name])
	ON [PRIMARY]
GO


ALTER TABLE [HumanResources].[Department] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[SalesReason]'
GO
CREATE TABLE [Sales].[SalesReason] (
		[SalesReasonID]     [int] IDENTITY(1, 1) NOT NULL,
		[Name]              [dbo].[Name] NOT NULL,
		[ReasonType]        [dbo].[Name] NOT NULL,
		[ModifiedDate]      [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_SalesReason_SalesReasonID to [Sales].[SalesReason]'
GO
ALTER TABLE [Sales].[SalesReason]
	ADD
	CONSTRAINT [PK_SalesReason_SalesReasonID]
	PRIMARY KEY
	CLUSTERED
	([SalesReasonID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_SalesReason_ModifiedDate to [Sales].[SalesReason]'
GO
ALTER TABLE [Sales].[SalesReason]
	ADD
	CONSTRAINT [DF_SalesReason_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [Sales].[SalesReason] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[SpecialOffer]'
GO
CREATE TABLE [Sales].[SpecialOffer] (
		[SpecialOfferID]     [int] IDENTITY(1, 1) NOT NULL,
		[Description]        [nvarchar](255) NOT NULL,
		[DiscountPct]        [smallmoney] NOT NULL,
		[Type]               [nvarchar](50) NOT NULL,
		[Category]           [nvarchar](50) NOT NULL,
		[StartDate]          [datetime] NOT NULL,
		[EndDate]            [datetime] NOT NULL,
		[MinQty]             [int] NOT NULL,
		[MaxQty]             [int] NULL,
		[rowguid]            [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]       [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_SpecialOffer_SpecialOfferID to [Sales].[SpecialOffer]'
GO
ALTER TABLE [Sales].[SpecialOffer]
	ADD
	CONSTRAINT [PK_SpecialOffer_SpecialOfferID]
	PRIMARY KEY
	CLUSTERED
	([SpecialOfferID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_SpecialOffer_DiscountPct to [Sales].[SpecialOffer]'
GO
ALTER TABLE [Sales].[SpecialOffer]
	ADD
	CONSTRAINT [DF_SpecialOffer_DiscountPct]
	DEFAULT ((0.00)) FOR [DiscountPct]
GO


Print 'Add Default Constraint DF_SpecialOffer_MinQty to [Sales].[SpecialOffer]'
GO
ALTER TABLE [Sales].[SpecialOffer]
	ADD
	CONSTRAINT [DF_SpecialOffer_MinQty]
	DEFAULT ((0)) FOR [MinQty]
GO


Print 'Add Default Constraint DF_SpecialOffer_ModifiedDate to [Sales].[SpecialOffer]'
GO
ALTER TABLE [Sales].[SpecialOffer]
	ADD
	CONSTRAINT [DF_SpecialOffer_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_SpecialOffer_rowguid to [Sales].[SpecialOffer]'
GO
ALTER TABLE [Sales].[SpecialOffer]
	ADD
	CONSTRAINT [DF_SpecialOffer_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_SpecialOffer_rowguid on [Sales].[SpecialOffer]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SpecialOffer_rowguid]
	ON [Sales].[SpecialOffer] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[SpecialOffer] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [HumanResources].[Shift]'
GO
CREATE TABLE [HumanResources].[Shift] (
		[ShiftID]          [tinyint] IDENTITY(1, 1) NOT NULL,
		[Name]             [dbo].[Name] NOT NULL,
		[StartTime]        [time](7) NOT NULL,
		[EndTime]          [time](7) NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Shift_ShiftID to [HumanResources].[Shift]'
GO
ALTER TABLE [HumanResources].[Shift]
	ADD
	CONSTRAINT [PK_Shift_ShiftID]
	PRIMARY KEY
	CLUSTERED
	([ShiftID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Shift_ModifiedDate to [HumanResources].[Shift]'
GO
ALTER TABLE [HumanResources].[Shift]
	ADD
	CONSTRAINT [DF_Shift_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index AK_Shift_Name on [HumanResources].[Shift]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Shift_Name]
	ON [HumanResources].[Shift] ([Name])
	ON [PRIMARY]
GO


Print 'Create Index AK_Shift_StartTime_EndTime on [HumanResources].[Shift]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Shift_StartTime_EndTime]
	ON [HumanResources].[Shift] ([StartTime], [EndTime])
	ON [PRIMARY]
GO


ALTER TABLE [HumanResources].[Shift] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[Culture]'
GO
CREATE TABLE [Production].[Culture] (
		[CultureID]        [nchar](6) NOT NULL,
		[Name]             [dbo].[Name] NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Culture_CultureID to [Production].[Culture]'
GO
ALTER TABLE [Production].[Culture]
	ADD
	CONSTRAINT [PK_Culture_CultureID]
	PRIMARY KEY
	CLUSTERED
	([CultureID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Culture_ModifiedDate to [Production].[Culture]'
GO
ALTER TABLE [Production].[Culture]
	ADD
	CONSTRAINT [DF_Culture_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index AK_Culture_Name on [Production].[Culture]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Culture_Name]
	ON [Production].[Culture] ([Name])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[Culture] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Procedure [dbo].[uspLogError]'
GO
-- uspLogError logs error information in the ErrorLog table about the 
-- error that caused execution to jump to the CATCH block of a 
-- TRY...CATCH construct. This should be executed from within the scope 
-- of a CATCH block otherwise it will return without inserting error 
-- information. 
CREATE PROCEDURE [dbo].[uspLogError] 
    @ErrorLogID [int] = 0 OUTPUT -- contains the ErrorLogID of the row inserted
AS                               -- by uspLogError in the ErrorLog table
BEGIN
    SET NOCOUNT ON;

    -- Output parameter value of 0 indicates that error 
    -- information was not logged
    SET @ErrorLogID = 0;

    BEGIN TRY
        -- Return if there is no error information to log
        IF ERROR_NUMBER() IS NULL
            RETURN;

        -- Return if inside an uncommittable transaction.
        -- Data insertion/modification is not allowed when 
        -- a transaction is in an uncommittable state.
        IF XACT_STATE() = -1
        BEGIN
            PRINT 'Cannot log error since the current transaction is in an uncommittable state. ' 
                + 'Rollback the transaction before executing uspLogError in order to successfully log error information.';
            RETURN;
        END

        INSERT [dbo].[ErrorLog] 
            (
            [UserName], 
            [ErrorNumber], 
            [ErrorSeverity], 
            [ErrorState], 
            [ErrorProcedure], 
            [ErrorLine], 
            [ErrorMessage]
            ) 
        VALUES 
            (
            CONVERT(sysname, CURRENT_USER), 
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_MESSAGE()
            );

        -- Pass back the ErrorLogID of the row inserted
        SET @ErrorLogID = @@IDENTITY;
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred in stored procedure uspLogError: ';
        EXECUTE [dbo].[uspPrintError];
        RETURN -1;
    END CATCH
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[uspLogError]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Logs error information in the ErrorLog table about the error that caused execution to jump to the CATCH block of a TRY...CATCH construct. Should be executed from within the scope of a CATCH block otherwise it will return without inserting error information.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspLogError', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[uspLogError]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Output parameter for the stored procedure uspLogError. Contains the ErrorLogID value corresponding to the row inserted by uspLogError in the ErrorLog table.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspLogError', 'PARAMETER', N'@ErrorLogID'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Purchasing].[Vendor]'
GO
CREATE TABLE [Purchasing].[Vendor] (
		[BusinessEntityID]            [int] NOT NULL,
		[AccountNumber]               [dbo].[AccountNumber] NOT NULL,
		[Name]                        [dbo].[Name] NOT NULL,
		[CreditRating]                [tinyint] NOT NULL,
		[PreferredVendorStatus]       [dbo].[Flag] NOT NULL,
		[ActiveFlag]                  [dbo].[Flag] NOT NULL,
		[PurchasingWebServiceURL]     [nvarchar](1024) NULL,
		[ModifiedDate]                [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Vendor_BusinessEntityID to [Purchasing].[Vendor]'
GO
ALTER TABLE [Purchasing].[Vendor]
	ADD
	CONSTRAINT [PK_Vendor_BusinessEntityID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Vendor_ActiveFlag to [Purchasing].[Vendor]'
GO
ALTER TABLE [Purchasing].[Vendor]
	ADD
	CONSTRAINT [DF_Vendor_ActiveFlag]
	DEFAULT ((1)) FOR [ActiveFlag]
GO


Print 'Add Default Constraint DF_Vendor_ModifiedDate to [Purchasing].[Vendor]'
GO
ALTER TABLE [Purchasing].[Vendor]
	ADD
	CONSTRAINT [DF_Vendor_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_Vendor_PreferredVendorStatus to [Purchasing].[Vendor]'
GO
ALTER TABLE [Purchasing].[Vendor]
	ADD
	CONSTRAINT [DF_Vendor_PreferredVendorStatus]
	DEFAULT ((1)) FOR [PreferredVendorStatus]
GO


Print 'Create Index AK_Vendor_AccountNumber on [Purchasing].[Vendor]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Vendor_AccountNumber]
	ON [Purchasing].[Vendor] ([AccountNumber])
	ON [PRIMARY]
GO


ALTER TABLE [Purchasing].[Vendor] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[CurrencyRate]'
GO
CREATE TABLE [Sales].[CurrencyRate] (
		[CurrencyRateID]       [int] IDENTITY(1, 1) NOT NULL,
		[CurrencyRateDate]     [datetime] NOT NULL,
		[FromCurrencyCode]     [nchar](3) NOT NULL,
		[ToCurrencyCode]       [nchar](3) NOT NULL,
		[AverageRate]          [money] NOT NULL,
		[EndOfDayRate]         [money] NOT NULL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_CurrencyRate_CurrencyRateID to [Sales].[CurrencyRate]'
GO
ALTER TABLE [Sales].[CurrencyRate]
	ADD
	CONSTRAINT [PK_CurrencyRate_CurrencyRateID]
	PRIMARY KEY
	CLUSTERED
	([CurrencyRateID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_CurrencyRate_ModifiedDate to [Sales].[CurrencyRate]'
GO
ALTER TABLE [Sales].[CurrencyRate]
	ADD
	CONSTRAINT [DF_CurrencyRate_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index AK_CurrencyRate_CurrencyRateDate_FromCurrencyCode_ToCurrencyCode on [Sales].[CurrencyRate]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_CurrencyRate_CurrencyRateDate_FromCurrencyCode_ToCurrencyCode]
	ON [Sales].[CurrencyRate] ([CurrencyRateDate], [FromCurrencyCode], [ToCurrencyCode])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[CurrencyRate] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductSubcategory]'
GO
CREATE TABLE [Production].[ProductSubcategory] (
		[ProductSubcategoryID]     [int] IDENTITY(1, 1) NOT NULL,
		[ProductCategoryID]        [int] NOT NULL,
		[Name]                     [dbo].[Name] NOT NULL,
		[rowguid]                  [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]             [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductSubcategory_ProductSubcategoryID to [Production].[ProductSubcategory]'
GO
ALTER TABLE [Production].[ProductSubcategory]
	ADD
	CONSTRAINT [PK_ProductSubcategory_ProductSubcategoryID]
	PRIMARY KEY
	CLUSTERED
	([ProductSubcategoryID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductSubcategory_ModifiedDate to [Production].[ProductSubcategory]'
GO
ALTER TABLE [Production].[ProductSubcategory]
	ADD
	CONSTRAINT [DF_ProductSubcategory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_ProductSubcategory_rowguid to [Production].[ProductSubcategory]'
GO
ALTER TABLE [Production].[ProductSubcategory]
	ADD
	CONSTRAINT [DF_ProductSubcategory_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_ProductSubcategory_Name on [Production].[ProductSubcategory]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ProductSubcategory_Name]
	ON [Production].[ProductSubcategory] ([Name])
	ON [PRIMARY]
GO


Print 'Create Index AK_ProductSubcategory_rowguid on [Production].[ProductSubcategory]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ProductSubcategory_rowguid]
	ON [Production].[ProductSubcategory] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[ProductSubcategory] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductModel]'
GO
CREATE TABLE [Production].[ProductModel] (
		[ProductModelID]         [int] IDENTITY(1, 1) NOT NULL,
		[Name]                   [dbo].[Name] NOT NULL,
		[CatalogDescription]     [xml](CONTENT [Production].[ProductDescriptionSchemaCollection]) NULL,
		[Instructions]           [xml](CONTENT [Production].[ManuInstructionsSchemaCollection]) NULL,
		[rowguid]                [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]           [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductModel_ProductModelID to [Production].[ProductModel]'
GO
ALTER TABLE [Production].[ProductModel]
	ADD
	CONSTRAINT [PK_ProductModel_ProductModelID]
	PRIMARY KEY
	CLUSTERED
	([ProductModelID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductModel_ModifiedDate to [Production].[ProductModel]'
GO
ALTER TABLE [Production].[ProductModel]
	ADD
	CONSTRAINT [DF_ProductModel_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_ProductModel_rowguid to [Production].[ProductModel]'
GO
ALTER TABLE [Production].[ProductModel]
	ADD
	CONSTRAINT [DF_ProductModel_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_ProductModel_Name on [Production].[ProductModel]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ProductModel_Name]
	ON [Production].[ProductModel] ([Name])
	ON [PRIMARY]
GO


Print 'Create Index AK_ProductModel_rowguid on [Production].[ProductModel]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_ProductModel_rowguid]
	ON [Production].[ProductModel] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Xml Index PXML_ProductModel_CatalogDescription on [Production].[ProductModel]'
GO
CREATE PRIMARY XML INDEX [PXML_ProductModel_CatalogDescription]
	ON [Production].[ProductModel] ([CatalogDescription])
GO


Print 'Create Xml Index PXML_ProductModel_Instructions on [Production].[ProductModel]'
GO
CREATE PRIMARY XML INDEX [PXML_ProductModel_Instructions]
	ON [Production].[ProductModel] ([Instructions])
GO


ALTER TABLE [Production].[ProductModel] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[SalesTerritory]'
GO
CREATE TABLE [Sales].[SalesTerritory] (
		[TerritoryID]           [int] IDENTITY(1, 1) NOT NULL,
		[Name]                  [dbo].[Name] NOT NULL,
		[CountryRegionCode]     [nvarchar](3) NOT NULL,
		[Group]                 [nvarchar](50) NOT NULL,
		[SalesYTD]              [money] NOT NULL,
		[SalesLastYear]         [money] NOT NULL,
		[CostYTD]               [money] NOT NULL,
		[CostLastYear]          [money] NOT NULL,
		[rowguid]               [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]          [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_SalesTerritory_TerritoryID to [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	ADD
	CONSTRAINT [PK_SalesTerritory_TerritoryID]
	PRIMARY KEY
	CLUSTERED
	([TerritoryID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_SalesTerritory_CostLastYear to [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	ADD
	CONSTRAINT [DF_SalesTerritory_CostLastYear]
	DEFAULT ((0.00)) FOR [CostLastYear]
GO


Print 'Add Default Constraint DF_SalesTerritory_CostYTD to [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	ADD
	CONSTRAINT [DF_SalesTerritory_CostYTD]
	DEFAULT ((0.00)) FOR [CostYTD]
GO


Print 'Add Default Constraint DF_SalesTerritory_ModifiedDate to [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	ADD
	CONSTRAINT [DF_SalesTerritory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_SalesTerritory_rowguid to [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	ADD
	CONSTRAINT [DF_SalesTerritory_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Add Default Constraint DF_SalesTerritory_SalesLastYear to [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	ADD
	CONSTRAINT [DF_SalesTerritory_SalesLastYear]
	DEFAULT ((0.00)) FOR [SalesLastYear]
GO


Print 'Add Default Constraint DF_SalesTerritory_SalesYTD to [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	ADD
	CONSTRAINT [DF_SalesTerritory_SalesYTD]
	DEFAULT ((0.00)) FOR [SalesYTD]
GO


Print 'Create Index AK_SalesTerritory_Name on [Sales].[SalesTerritory]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SalesTerritory_Name]
	ON [Sales].[SalesTerritory] ([Name])
	ON [PRIMARY]
GO


Print 'Create Index AK_SalesTerritory_rowguid on [Sales].[SalesTerritory]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SalesTerritory_rowguid]
	ON [Sales].[SalesTerritory] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[SalesTerritory] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[CountryRegionCurrency]'
GO
CREATE TABLE [Sales].[CountryRegionCurrency] (
		[CountryRegionCode]     [nvarchar](3) NOT NULL,
		[CurrencyCode]          [nchar](3) NOT NULL,
		[ModifiedDate]          [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode to [Sales].[CountryRegionCurrency]'
GO
ALTER TABLE [Sales].[CountryRegionCurrency]
	ADD
	CONSTRAINT [PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode]
	PRIMARY KEY
	CLUSTERED
	([CountryRegionCode], [CurrencyCode])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_CountryRegionCurrency_ModifiedDate to [Sales].[CountryRegionCurrency]'
GO
ALTER TABLE [Sales].[CountryRegionCurrency]
	ADD
	CONSTRAINT [DF_CountryRegionCurrency_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index IX_CountryRegionCurrency_CurrencyCode on [Sales].[CountryRegionCurrency]'
GO
CREATE NONCLUSTERED INDEX [IX_CountryRegionCurrency_CurrencyCode]
	ON [Sales].[CountryRegionCurrency] ([CurrencyCode])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[CountryRegionCurrency] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[Person]'
GO
CREATE TABLE [Person].[Person] (
		[BusinessEntityID]          [int] NOT NULL,
		[PersonType]                [nchar](2) NOT NULL,
		[NameStyle]                 [dbo].[NameStyle] NOT NULL,
		[Title]                     [nvarchar](8) NULL,
		[FirstName]                 [dbo].[Name] NOT NULL,
		[MiddleName]                [dbo].[Name] NULL,
		[LastName]                  [dbo].[Name] NOT NULL,
		[Suffix]                    [nvarchar](10) NULL,
		[EmailPromotion]            [int] NOT NULL,
		[AdditionalContactInfo]     [xml](CONTENT [Person].[AdditionalContactInfoSchemaCollection]) NULL,
		[Demographics]              [xml](CONTENT [Person].[IndividualSurveySchemaCollection]) NULL,
		[rowguid]                   [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]              [datetime] NOT NULL,
		[Nickname]                  [nvarchar](50) NULL
)
GO


Print 'Add Primary Key PK_Person_BusinessEntityID to [Person].[Person]'
GO
ALTER TABLE [Person].[Person]
	ADD
	CONSTRAINT [PK_Person_BusinessEntityID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Person_EmailPromotion to [Person].[Person]'
GO
ALTER TABLE [Person].[Person]
	ADD
	CONSTRAINT [DF_Person_EmailPromotion]
	DEFAULT ((0)) FOR [EmailPromotion]
GO


Print 'Add Default Constraint DF_Person_ModifiedDate to [Person].[Person]'
GO
ALTER TABLE [Person].[Person]
	ADD
	CONSTRAINT [DF_Person_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_Person_NameStyle to [Person].[Person]'
GO
ALTER TABLE [Person].[Person]
	ADD
	CONSTRAINT [DF_Person_NameStyle]
	DEFAULT ((0)) FOR [NameStyle]
GO


Print 'Add Default Constraint DF_Person_rowguid to [Person].[Person]'
GO
ALTER TABLE [Person].[Person]
	ADD
	CONSTRAINT [DF_Person_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_Person_rowguid on [Person].[Person]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Person_rowguid]
	ON [Person].[Person] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index IX_Person_LastName_FirstName_MiddleName on [Person].[Person]'
GO
CREATE NONCLUSTERED INDEX [IX_Person_LastName_FirstName_MiddleName]
	ON [Person].[Person] ([LastName], [FirstName], [MiddleName])
	ON [PRIMARY]
GO


Print 'Create Xml Index PXML_Person_AddContact on [Person].[Person]'
GO
CREATE PRIMARY XML INDEX [PXML_Person_AddContact]
	ON [Person].[Person] ([AdditionalContactInfo])
GO


Print 'Create Xml Index PXML_Person_Demographics on [Person].[Person]'
GO
CREATE PRIMARY XML INDEX [PXML_Person_Demographics]
	ON [Person].[Person] ([Demographics])
GO


Print 'Create Xml Index XMLPATH_Person_Demographics on [Person].[Person]'
GO
CREATE XML INDEX [XMLPATH_Person_Demographics]
	ON [Person].[Person] ([Demographics])
	USING XML INDEX [PXML_Person_Demographics]
	FOR PATH
GO


Print 'Create Xml Index XMLPROPERTY_Person_Demographics on [Person].[Person]'
GO
CREATE XML INDEX [XMLPROPERTY_Person_Demographics]
	ON [Person].[Person] ([Demographics])
	USING XML INDEX [PXML_Person_Demographics]
	FOR PROPERTY
GO


Print 'Create Xml Index XMLVALUE_Person_Demographics on [Person].[Person]'
GO
CREATE XML INDEX [XMLVALUE_Person_Demographics]
	ON [Person].[Person] ([Demographics])
	USING XML INDEX [PXML_Person_Demographics]
	FOR VALUE
GO


ALTER TABLE [Person].[Person] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductModelProductDescriptionCulture]'
GO
CREATE TABLE [Production].[ProductModelProductDescriptionCulture] (
		[ProductModelID]           [int] NOT NULL,
		[ProductDescriptionID]     [int] NOT NULL,
		[CultureID]                [nchar](6) NOT NULL,
		[ModifiedDate]             [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID to [Production].[ProductModelProductDescriptionCulture]'
GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	ADD
	CONSTRAINT [PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID]
	PRIMARY KEY
	CLUSTERED
	([ProductModelID], [ProductDescriptionID], [CultureID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductModelProductDescriptionCulture_ModifiedDate to [Production].[ProductModelProductDescriptionCulture]'
GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	ADD
	CONSTRAINT [DF_ProductModelProductDescriptionCulture_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [Production].[ProductModelProductDescriptionCulture] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[EmailAddress]'
GO
CREATE TABLE [Person].[EmailAddress] (
		[BusinessEntityID]     [int] NOT NULL,
		[EmailAddressID]       [int] IDENTITY(1, 1) NOT NULL,
		[EmailAddress]         [nvarchar](50) NULL,
		[rowguid]              [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_EmailAddress_BusinessEntityID_EmailAddressID to [Person].[EmailAddress]'
GO
ALTER TABLE [Person].[EmailAddress]
	ADD
	CONSTRAINT [PK_EmailAddress_BusinessEntityID_EmailAddressID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID], [EmailAddressID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_EmailAddress_ModifiedDate to [Person].[EmailAddress]'
GO
ALTER TABLE [Person].[EmailAddress]
	ADD
	CONSTRAINT [DF_EmailAddress_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_EmailAddress_rowguid to [Person].[EmailAddress]'
GO
ALTER TABLE [Person].[EmailAddress]
	ADD
	CONSTRAINT [DF_EmailAddress_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index IX_EmailAddress_EmailAddress on [Person].[EmailAddress]'
GO
CREATE NONCLUSTERED INDEX [IX_EmailAddress_EmailAddress]
	ON [Person].[EmailAddress] ([EmailAddress])
	ON [PRIMARY]
GO


ALTER TABLE [Person].[EmailAddress] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[PersonCreditCard]'
GO
CREATE TABLE [Sales].[PersonCreditCard] (
		[BusinessEntityID]     [int] NOT NULL,
		[CreditCardID]         [int] NOT NULL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_PersonCreditCard_BusinessEntityID_CreditCardID to [Sales].[PersonCreditCard]'
GO
ALTER TABLE [Sales].[PersonCreditCard]
	ADD
	CONSTRAINT [PK_PersonCreditCard_BusinessEntityID_CreditCardID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID], [CreditCardID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_PersonCreditCard_ModifiedDate to [Sales].[PersonCreditCard]'
GO
ALTER TABLE [Sales].[PersonCreditCard]
	ADD
	CONSTRAINT [DF_PersonCreditCard_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [Sales].[PersonCreditCard] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductModelIllustration]'
GO
CREATE TABLE [Production].[ProductModelIllustration] (
		[ProductModelID]     [int] NOT NULL,
		[IllustrationID]     [int] NOT NULL,
		[ModifiedDate]       [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductModelIllustration_ProductModelID_IllustrationID to [Production].[ProductModelIllustration]'
GO
ALTER TABLE [Production].[ProductModelIllustration]
	ADD
	CONSTRAINT [PK_ProductModelIllustration_ProductModelID_IllustrationID]
	PRIMARY KEY
	CLUSTERED
	([ProductModelID], [IllustrationID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductModelIllustration_ModifiedDate to [Production].[ProductModelIllustration]'
GO
ALTER TABLE [Production].[ProductModelIllustration]
	ADD
	CONSTRAINT [DF_ProductModelIllustration_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [Production].[ProductModelIllustration] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[Password]'
GO
CREATE TABLE [Person].[Password] (
		[BusinessEntityID]     [int] NOT NULL,
		[PasswordHash]         [varchar](128) NOT NULL,
		[PasswordSalt]         [varchar](10) NOT NULL,
		[rowguid]              [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Password_BusinessEntityID to [Person].[Password]'
GO
ALTER TABLE [Person].[Password]
	ADD
	CONSTRAINT [PK_Password_BusinessEntityID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Password_ModifiedDate to [Person].[Password]'
GO
ALTER TABLE [Person].[Password]
	ADD
	CONSTRAINT [DF_Password_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_Password_rowguid to [Person].[Password]'
GO
ALTER TABLE [Person].[Password]
	ADD
	CONSTRAINT [DF_Password_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


ALTER TABLE [Person].[Password] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[BusinessEntityContact]'
GO
CREATE TABLE [Person].[BusinessEntityContact] (
		[BusinessEntityID]     [int] NOT NULL,
		[PersonID]             [int] NOT NULL,
		[ContactTypeID]        [int] NOT NULL,
		[rowguid]              [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID to [Person].[BusinessEntityContact]'
GO
ALTER TABLE [Person].[BusinessEntityContact]
	ADD
	CONSTRAINT [PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID], [PersonID], [ContactTypeID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_BusinessEntityContact_ModifiedDate to [Person].[BusinessEntityContact]'
GO
ALTER TABLE [Person].[BusinessEntityContact]
	ADD
	CONSTRAINT [DF_BusinessEntityContact_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_BusinessEntityContact_rowguid to [Person].[BusinessEntityContact]'
GO
ALTER TABLE [Person].[BusinessEntityContact]
	ADD
	CONSTRAINT [DF_BusinessEntityContact_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_BusinessEntityContact_rowguid on [Person].[BusinessEntityContact]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_BusinessEntityContact_rowguid]
	ON [Person].[BusinessEntityContact] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index IX_BusinessEntityContact_ContactTypeID on [Person].[BusinessEntityContact]'
GO
CREATE NONCLUSTERED INDEX [IX_BusinessEntityContact_ContactTypeID]
	ON [Person].[BusinessEntityContact] ([ContactTypeID])
	ON [PRIMARY]
GO


Print 'Create Index IX_BusinessEntityContact_PersonID on [Person].[BusinessEntityContact]'
GO
CREATE NONCLUSTERED INDEX [IX_BusinessEntityContact_PersonID]
	ON [Person].[BusinessEntityContact] ([PersonID])
	ON [PRIMARY]
GO


ALTER TABLE [Person].[BusinessEntityContact] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [HumanResources].[Employee]'
GO
CREATE TABLE [HumanResources].[Employee] (
		[BusinessEntityID]      [int] NOT NULL,
		[NationalIDNumber]      [nvarchar](15) NOT NULL,
		[LoginID]               [nvarchar](256) NOT NULL,
		[OrganizationNode]      [hierarchyid] NULL,
		[OrganizationLevel]     AS ([OrganizationNode].[GetLevel]()),
		[JobTitle]              [nvarchar](50) NOT NULL,
		[BirthDate]             [date] NOT NULL,
		[MaritalStatus]         [nchar](1) NOT NULL,
		[Gender]                [nchar](1) NOT NULL,
		[HireDate]              [date] NOT NULL,
		[SalariedFlag]          [dbo].[Flag] NOT NULL,
		[VacationHours]         [smallint] NOT NULL,
		[SickLeaveHours]        [smallint] NOT NULL,
		[CurrentFlag]           [dbo].[Flag] NOT NULL,
		[rowguid]               [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]          [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Employee_BusinessEntityID to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [PK_Employee_BusinessEntityID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Employee_CurrentFlag to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [DF_Employee_CurrentFlag]
	DEFAULT ((1)) FOR [CurrentFlag]
GO


Print 'Add Default Constraint DF_Employee_ModifiedDate to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [DF_Employee_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_Employee_rowguid to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [DF_Employee_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Add Default Constraint DF_Employee_SalariedFlag to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [DF_Employee_SalariedFlag]
	DEFAULT ((1)) FOR [SalariedFlag]
GO


Print 'Add Default Constraint DF_Employee_SickLeaveHours to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [DF_Employee_SickLeaveHours]
	DEFAULT ((0)) FOR [SickLeaveHours]
GO


Print 'Add Default Constraint DF_Employee_VacationHours to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [DF_Employee_VacationHours]
	DEFAULT ((0)) FOR [VacationHours]
GO


Print 'Create Index AK_Employee_LoginID on [HumanResources].[Employee]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Employee_LoginID]
	ON [HumanResources].[Employee] ([LoginID])
	ON [PRIMARY]
GO


Print 'Create Index AK_Employee_NationalIDNumber on [HumanResources].[Employee]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Employee_NationalIDNumber]
	ON [HumanResources].[Employee] ([NationalIDNumber])
	ON [PRIMARY]
GO


Print 'Create Index AK_Employee_rowguid on [HumanResources].[Employee]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Employee_rowguid]
	ON [HumanResources].[Employee] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index IX_Employee_OrganizationLevel_OrganizationNode on [HumanResources].[Employee]'
GO
CREATE NONCLUSTERED INDEX [IX_Employee_OrganizationLevel_OrganizationNode]
	ON [HumanResources].[Employee] ([OrganizationLevel], [OrganizationNode])
	ON [PRIMARY]
GO


Print 'Create Index IX_Employee_OrganizationNode on [HumanResources].[Employee]'
GO
CREATE NONCLUSTERED INDEX [IX_Employee_OrganizationNode]
	ON [HumanResources].[Employee] ([OrganizationNode])
	ON [PRIMARY]
GO


ALTER TABLE [HumanResources].[Employee] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[PersonPhone]'
GO
CREATE TABLE [Person].[PersonPhone] (
		[BusinessEntityID]      [int] NOT NULL,
		[PhoneNumber]           [dbo].[Phone] NOT NULL,
		[PhoneNumberTypeID]     [int] NOT NULL,
		[ModifiedDate]          [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID to [Person].[PersonPhone]'
GO
ALTER TABLE [Person].[PersonPhone]
	ADD
	CONSTRAINT [PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID], [PhoneNumber], [PhoneNumberTypeID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_PersonPhone_ModifiedDate to [Person].[PersonPhone]'
GO
ALTER TABLE [Person].[PersonPhone]
	ADD
	CONSTRAINT [DF_PersonPhone_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index IX_PersonPhone_PhoneNumber on [Person].[PersonPhone]'
GO
CREATE NONCLUSTERED INDEX [IX_PersonPhone_PhoneNumber]
	ON [Person].[PersonPhone] ([PhoneNumber])
	ON [PRIMARY]
GO


ALTER TABLE [Person].[PersonPhone] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[Product]'
GO
CREATE TABLE [Production].[Product] (
		[ProductID]                 [int] IDENTITY(1, 1) NOT NULL,
		[Name]                      [dbo].[Name] NOT NULL,
		[ProductNumber]             [nvarchar](25) NOT NULL,
		[MakeFlag]                  [dbo].[Flag] NOT NULL,
		[FinishedGoodsFlag]         [dbo].[Flag] NOT NULL,
		[Color]                     [nvarchar](15) NULL,
		[SafetyStockLevel]          [smallint] NOT NULL,
		[ReorderPoint]              [smallint] NOT NULL,
		[StandardCost]              [money] NOT NULL,
		[ListPrice]                 [money] NOT NULL,
		[Size]                      [nvarchar](5) NULL,
		[SizeUnitMeasureCode]       [nchar](3) NULL,
		[WeightUnitMeasureCode]     [nchar](3) NULL,
		[Weight]                    [decimal](8, 2) NULL,
		[DaysToManufacture]         [int] NOT NULL,
		[ProductLine]               [nchar](2) NULL,
		[Class]                     [nchar](2) NULL,
		[Style]                     [nchar](2) NULL,
		[ProductSubcategoryID]      [int] NULL,
		[ProductModelID]            [int] NULL,
		[SellStartDate]             [datetime] NOT NULL,
		[SellEndDate]               [datetime] NULL,
		[DiscontinuedDate]          [datetime] NULL,
		[rowguid]                   [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]              [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Product_ProductID to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [PK_Product_ProductID]
	PRIMARY KEY
	CLUSTERED
	([ProductID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Product_FinishedGoodsFlag to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [DF_Product_FinishedGoodsFlag]
	DEFAULT ((1)) FOR [FinishedGoodsFlag]
GO


Print 'Add Default Constraint DF_Product_MakeFlag to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [DF_Product_MakeFlag]
	DEFAULT ((1)) FOR [MakeFlag]
GO


Print 'Add Default Constraint DF_Product_ModifiedDate to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [DF_Product_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_Product_rowguid to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [DF_Product_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_Product_Name on [Production].[Product]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Product_Name]
	ON [Production].[Product] ([Name])
	ON [PRIMARY]
GO


Print 'Create Index AK_Product_ProductNumber on [Production].[Product]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Product_ProductNumber]
	ON [Production].[Product] ([ProductNumber])
	ON [PRIMARY]
GO


Print 'Create Index AK_Product_rowguid on [Production].[Product]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Product_rowguid]
	ON [Production].[Product] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[Product] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[StateProvince]'
GO
CREATE TABLE [Person].[StateProvince] (
		[StateProvinceID]             [int] IDENTITY(1, 1) NOT NULL,
		[StateProvinceCode]           [nchar](3) NOT NULL,
		[CountryRegionCode]           [nvarchar](3) NOT NULL,
		[IsOnlyStateProvinceFlag]     [dbo].[Flag] NOT NULL,
		[Name]                        [dbo].[Name] NOT NULL,
		[TerritoryID]                 [int] NOT NULL,
		[rowguid]                     [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]                [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_StateProvince_StateProvinceID to [Person].[StateProvince]'
GO
ALTER TABLE [Person].[StateProvince]
	ADD
	CONSTRAINT [PK_StateProvince_StateProvinceID]
	PRIMARY KEY
	CLUSTERED
	([StateProvinceID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_StateProvince_IsOnlyStateProvinceFlag to [Person].[StateProvince]'
GO
ALTER TABLE [Person].[StateProvince]
	ADD
	CONSTRAINT [DF_StateProvince_IsOnlyStateProvinceFlag]
	DEFAULT ((1)) FOR [IsOnlyStateProvinceFlag]
GO


Print 'Add Default Constraint DF_StateProvince_ModifiedDate to [Person].[StateProvince]'
GO
ALTER TABLE [Person].[StateProvince]
	ADD
	CONSTRAINT [DF_StateProvince_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_StateProvince_rowguid to [Person].[StateProvince]'
GO
ALTER TABLE [Person].[StateProvince]
	ADD
	CONSTRAINT [DF_StateProvince_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_StateProvince_Name on [Person].[StateProvince]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_StateProvince_Name]
	ON [Person].[StateProvince] ([Name])
	ON [PRIMARY]
GO


Print 'Create Index AK_StateProvince_rowguid on [Person].[StateProvince]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_StateProvince_rowguid]
	ON [Person].[StateProvince] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index AK_StateProvince_StateProvinceCode_CountryRegionCode on [Person].[StateProvince]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_StateProvince_StateProvinceCode_CountryRegionCode]
	ON [Person].[StateProvince] ([StateProvinceCode], [CountryRegionCode])
	ON [PRIMARY]
GO


ALTER TABLE [Person].[StateProvince] SET (LOCK_ESCALATION = TABLE)
GO


Print 'Create View [Sales].[vPersonDemographics]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Sales].[vPersonDemographics] 
AS 
SELECT 
    p.[BusinessEntityID] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        TotalPurchaseYTD[1]', 'money') AS [TotalPurchaseYTD] 
    ,CONVERT(datetime, REPLACE([IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        DateFirstPurchase[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [DateFirstPurchase] 
    ,CONVERT(datetime, REPLACE([IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        BirthDate[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [BirthDate] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        MaritalStatus[1]', 'nvarchar(1)') AS [MaritalStatus] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        YearlyIncome[1]', 'nvarchar(30)') AS [YearlyIncome] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        Gender[1]', 'nvarchar(1)') AS [Gender] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        TotalChildren[1]', 'integer') AS [TotalChildren] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        NumberChildrenAtHome[1]', 'integer') AS [NumberChildrenAtHome] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        Education[1]', 'nvarchar(30)') AS [Education] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        Occupation[1]', 'nvarchar(30)') AS [Occupation] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        HomeOwnerFlag[1]', 'bit') AS [HomeOwnerFlag] 
    ,[IndividualSurvey].[ref].[value](N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
        NumberCarsOwned[1]', 'integer') AS [NumberCarsOwned] 
FROM [Person].[Person] p 
CROSS APPLY p.[Demographics].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
    /IndividualSurvey') AS [IndividualSurvey](ref) 
WHERE [Demographics] IS NOT NULL;
GO


Print 'Create Extended Property MS_Description on [Sales].[vPersonDemographics]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Displays the content from each element in the xml column Demographics for each customer in the Person.Person table.', 'SCHEMA', N'Sales', 'VIEW', N'vPersonDemographics', NULL, NULL
GO


Print 'Create View [Production].[vProductModelCatalogDescription]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Production].[vProductModelCatalogDescription] 
AS 
SELECT 
    [ProductModelID] 
    ,[Name] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace html="http://www.w3.org/1999/xhtml"; 
        (/p1:ProductDescription/p1:Summary/html:p)[1]', 'nvarchar(max)') AS [Summary] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Manufacturer/p1:Name)[1]', 'nvarchar(max)') AS [Manufacturer] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Manufacturer/p1:Copyright)[1]', 'nvarchar(30)') AS [Copyright] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Manufacturer/p1:ProductURL)[1]', 'nvarchar(256)') AS [ProductURL] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain"; 
        (/p1:ProductDescription/p1:Features/wm:Warranty/wm:WarrantyPeriod)[1]', 'nvarchar(256)') AS [WarrantyPeriod] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain"; 
        (/p1:ProductDescription/p1:Features/wm:Warranty/wm:Description)[1]', 'nvarchar(256)') AS [WarrantyDescription] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain"; 
        (/p1:ProductDescription/p1:Features/wm:Maintenance/wm:NoOfYears)[1]', 'nvarchar(256)') AS [NoOfYears] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wm="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelWarrAndMain"; 
        (/p1:ProductDescription/p1:Features/wm:Maintenance/wm:Description)[1]', 'nvarchar(256)') AS [MaintenanceDescription] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures"; 
        (/p1:ProductDescription/p1:Features/wf:wheel)[1]', 'nvarchar(256)') AS [Wheel] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures"; 
        (/p1:ProductDescription/p1:Features/wf:saddle)[1]', 'nvarchar(256)') AS [Saddle] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures"; 
        (/p1:ProductDescription/p1:Features/wf:pedal)[1]', 'nvarchar(256)') AS [Pedal] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures"; 
        (/p1:ProductDescription/p1:Features/wf:BikeFrame)[1]', 'nvarchar(max)') AS [BikeFrame] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        declare namespace wf="http://www.adventure-works.com/schemas/OtherFeatures"; 
        (/p1:ProductDescription/p1:Features/wf:crankset)[1]', 'nvarchar(256)') AS [Crankset] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Picture/p1:Angle)[1]', 'nvarchar(256)') AS [PictureAngle] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Picture/p1:Size)[1]', 'nvarchar(256)') AS [PictureSize] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Picture/p1:ProductPhotoID)[1]', 'nvarchar(256)') AS [ProductPhotoID] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Specifications/Material)[1]', 'nvarchar(256)') AS [Material] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Specifications/Color)[1]', 'nvarchar(256)') AS [Color] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Specifications/ProductLine)[1]', 'nvarchar(256)') AS [ProductLine] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Specifications/Style)[1]', 'nvarchar(256)') AS [Style] 
    ,[CatalogDescription].value(N'declare namespace p1="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelDescription"; 
        (/p1:ProductDescription/p1:Specifications/RiderExperience)[1]', 'nvarchar(1024)') AS [RiderExperience] 
    ,[rowguid] 
    ,[ModifiedDate]
FROM [Production].[ProductModel] 
WHERE [CatalogDescription] IS NOT NULL;
GO


Print 'Create Extended Property MS_Description on [Production].[vProductModelCatalogDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Displays the content from each element in the xml column CatalogDescription for each product in the Production.ProductModel table that has catalog data.', 'SCHEMA', N'Production', 'VIEW', N'vProductModelCatalogDescription', NULL, NULL
GO


Print 'Create View [Production].[vProductModelInstructions]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Production].[vProductModelInstructions] 
AS 
SELECT 
    [ProductModelID] 
    ,[Name] 
    ,[Instructions].value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions"; 
        (/root/text())[1]', 'nvarchar(max)') AS [Instructions] 
    ,[MfgInstructions].ref.value('@LocationID[1]', 'int') AS [LocationID] 
    ,[MfgInstructions].ref.value('@SetupHours[1]', 'decimal(9, 4)') AS [SetupHours] 
    ,[MfgInstructions].ref.value('@MachineHours[1]', 'decimal(9, 4)') AS [MachineHours] 
    ,[MfgInstructions].ref.value('@LaborHours[1]', 'decimal(9, 4)') AS [LaborHours] 
    ,[MfgInstructions].ref.value('@LotSize[1]', 'int') AS [LotSize] 
    ,[Steps].ref.value('string(.)[1]', 'nvarchar(1024)') AS [Step] 
    ,[rowguid] 
    ,[ModifiedDate]
FROM [Production].[ProductModel] 
CROSS APPLY [Instructions].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions"; 
    /root/Location') MfgInstructions(ref)
CROSS APPLY [MfgInstructions].ref.nodes('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ProductModelManuInstructions"; 
    step') Steps(ref);
GO


Print 'Create Extended Property MS_Description on [Production].[vProductModelInstructions]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Displays the content from each element in the xml column Instructions for each product in the Production.ProductModel table that has manufacturing instructions.', 'SCHEMA', N'Production', 'VIEW', N'vProductModelInstructions', NULL, NULL
GO


Print 'Create View [Person].[vAdditionalContactInfo]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Person].[vAdditionalContactInfo] 
AS 
SELECT 
    [BusinessEntityID] 
    ,[FirstName]
    ,[MiddleName]
    ,[LastName]
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:telephoneNumber)[1]/act:number', 'nvarchar(50)') AS [TelephoneNumber] 
    ,LTRIM(RTRIM([ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:telephoneNumber/act:SpecialInstructions/text())[1]', 'nvarchar(max)'))) AS [TelephoneSpecialInstructions] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes";
        (act:homePostalAddress/act:Street)[1]', 'nvarchar(50)') AS [Street] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:homePostalAddress/act:City)[1]', 'nvarchar(50)') AS [City] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:homePostalAddress/act:StateProvince)[1]', 'nvarchar(50)') AS [StateProvince] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:homePostalAddress/act:PostalCode)[1]', 'nvarchar(50)') AS [PostalCode] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:homePostalAddress/act:CountryRegion)[1]', 'nvarchar(50)') AS [CountryRegion] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:homePostalAddress/act:SpecialInstructions/text())[1]', 'nvarchar(max)') AS [HomeAddressSpecialInstructions] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:eMail/act:eMailAddress)[1]', 'nvarchar(128)') AS [EMailAddress] 
    ,LTRIM(RTRIM([ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:eMail/act:SpecialInstructions/text())[1]', 'nvarchar(max)'))) AS [EMailSpecialInstructions] 
    ,[ContactInfo].ref.value(N'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
        declare namespace act="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes"; 
        (act:eMail/act:SpecialInstructions/act:telephoneNumber/act:number)[1]', 'nvarchar(50)') AS [EMailTelephoneNumber] 
    ,[rowguid] 
    ,[ModifiedDate]
FROM [Person].[Person]
OUTER APPLY [AdditionalContactInfo].nodes(
    'declare namespace ci="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo"; 
    /ci:AdditionalContactInfo') AS ContactInfo(ref) 
WHERE [AdditionalContactInfo] IS NOT NULL;
GO


Print 'Create Extended Property MS_Description on [Person].[vAdditionalContactInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Displays the contact name and content from each element in the xml column AdditionalContactInfo for that person.', 'SCHEMA', N'Person', 'VIEW', N'vAdditionalContactInfo', NULL, NULL
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Trigger [Person].[iuPerson]'
GO
CREATE TRIGGER [Person].[iuPerson] ON [Person].[Person] 
AFTER INSERT, UPDATE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    IF UPDATE([BusinessEntityID]) OR UPDATE([Demographics]) 
    BEGIN
        UPDATE [Person].[Person] 
        SET [Person].[Person].[Demographics] = N'<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"> 
            <TotalPurchaseYTD>0.00</TotalPurchaseYTD> 
            </IndividualSurvey>' 
        FROM inserted 
        WHERE [Person].[Person].[BusinessEntityID] = inserted.[BusinessEntityID] 
            AND inserted.[Demographics] IS NULL;
        
        UPDATE [Person].[Person] 
        SET [Demographics].modify(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
            insert <TotalPurchaseYTD>0.00</TotalPurchaseYTD> 
            as first 
            into (/IndividualSurvey)[1]') 
        FROM inserted 
        WHERE [Person].[Person].[BusinessEntityID] = inserted.[BusinessEntityID] 
            AND inserted.[Demographics] IS NOT NULL 
            AND inserted.[Demographics].exist(N'declare default element namespace 
                "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
                /IndividualSurvey/TotalPurchaseYTD') <> 1;
    END;
END;
GO


Print 'Create Extended Property MS_Description on [Person].[iuPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AFTER INSERT, UPDATE trigger inserting Individual only if the Customer does not exist in the Store table and setting the ModifiedDate column in the Person table to the current date.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'TRIGGER', N'iuPerson'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Trigger [Purchasing].[dVendor]'
GO
CREATE TRIGGER [Purchasing].[dVendor] ON [Purchasing].[Vendor] 
INSTEAD OF DELETE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @DeleteCount int;

        SELECT @DeleteCount = COUNT(*) FROM deleted;
        IF @DeleteCount > 0 
        BEGIN
            RAISERROR
                (N'Vendors cannot be deleted. They can only be marked as not active.', -- Message
                10, -- Severity.
                1); -- State.

        -- Rollback any active or uncommittable transactions
            IF @@TRANCOUNT > 0
            BEGIN
                ROLLBACK TRANSACTION;
            END
        END;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


Print 'Create Extended Property MS_Description on [Purchasing].[dVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'INSTEAD OF DELETE trigger which keeps Vendors from being deleted.', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'TRIGGER', N'dVendor'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [HumanResources].[EmployeeDepartmentHistory]'
GO
CREATE TABLE [HumanResources].[EmployeeDepartmentHistory] (
		[BusinessEntityID]     [int] NOT NULL,
		[DepartmentID]         [smallint] NOT NULL,
		[ShiftID]              [tinyint] NOT NULL,
		[StartDate]            [date] NOT NULL,
		[EndDate]              [date] NULL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID to [HumanResources].[EmployeeDepartmentHistory]'
GO
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]
	ADD
	CONSTRAINT [PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID], [StartDate], [DepartmentID], [ShiftID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_EmployeeDepartmentHistory_ModifiedDate to [HumanResources].[EmployeeDepartmentHistory]'
GO
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]
	ADD
	CONSTRAINT [DF_EmployeeDepartmentHistory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index IX_EmployeeDepartmentHistory_DepartmentID on [HumanResources].[EmployeeDepartmentHistory]'
GO
CREATE NONCLUSTERED INDEX [IX_EmployeeDepartmentHistory_DepartmentID]
	ON [HumanResources].[EmployeeDepartmentHistory] ([DepartmentID])
	ON [PRIMARY]
GO


Print 'Create Index IX_EmployeeDepartmentHistory_ShiftID on [HumanResources].[EmployeeDepartmentHistory]'
GO
CREATE NONCLUSTERED INDEX [IX_EmployeeDepartmentHistory_ShiftID]
	ON [HumanResources].[EmployeeDepartmentHistory] ([ShiftID])
	ON [PRIMARY]
GO


ALTER TABLE [HumanResources].[EmployeeDepartmentHistory] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[BillOfMaterials]'
GO
CREATE TABLE [Production].[BillOfMaterials] (
		[BillOfMaterialsID]     [int] IDENTITY(1, 1) NOT NULL,
		[ProductAssemblyID]     [int] NULL,
		[ComponentID]           [int] NOT NULL,
		[StartDate]             [datetime] NOT NULL,
		[EndDate]               [datetime] NULL,
		[UnitMeasureCode]       [nchar](3) NOT NULL,
		[BOMLevel]              [smallint] NOT NULL,
		[PerAssemblyQty]        [decimal](8, 2) NOT NULL,
		[ModifiedDate]          [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_BillOfMaterials_BillOfMaterialsID to [Production].[BillOfMaterials]'
GO
ALTER TABLE [Production].[BillOfMaterials]
	ADD
	CONSTRAINT [PK_BillOfMaterials_BillOfMaterialsID]
	PRIMARY KEY
	NONCLUSTERED
	([BillOfMaterialsID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_BillOfMaterials_ModifiedDate to [Production].[BillOfMaterials]'
GO
ALTER TABLE [Production].[BillOfMaterials]
	ADD
	CONSTRAINT [DF_BillOfMaterials_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_BillOfMaterials_PerAssemblyQty to [Production].[BillOfMaterials]'
GO
ALTER TABLE [Production].[BillOfMaterials]
	ADD
	CONSTRAINT [DF_BillOfMaterials_PerAssemblyQty]
	DEFAULT ((1.00)) FOR [PerAssemblyQty]
GO


Print 'Add Default Constraint DF_BillOfMaterials_StartDate to [Production].[BillOfMaterials]'
GO
ALTER TABLE [Production].[BillOfMaterials]
	ADD
	CONSTRAINT [DF_BillOfMaterials_StartDate]
	DEFAULT (getdate()) FOR [StartDate]
GO


Print 'Create Index AK_BillOfMaterials_ProductAssemblyID_ComponentID_StartDate on [Production].[BillOfMaterials]'
GO
CREATE UNIQUE CLUSTERED INDEX [AK_BillOfMaterials_ProductAssemblyID_ComponentID_StartDate]
	ON [Production].[BillOfMaterials] ([ProductAssemblyID], [ComponentID], [StartDate])
	ON [PRIMARY]
GO


Print 'Create Index IX_BillOfMaterials_UnitMeasureCode on [Production].[BillOfMaterials]'
GO
CREATE NONCLUSTERED INDEX [IX_BillOfMaterials_UnitMeasureCode]
	ON [Production].[BillOfMaterials] ([UnitMeasureCode])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[BillOfMaterials] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[SpecialOfferProduct]'
GO
CREATE TABLE [Sales].[SpecialOfferProduct] (
		[SpecialOfferID]     [int] NOT NULL,
		[ProductID]          [int] NOT NULL,
		[rowguid]            [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]       [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_SpecialOfferProduct_SpecialOfferID_ProductID to [Sales].[SpecialOfferProduct]'
GO
ALTER TABLE [Sales].[SpecialOfferProduct]
	ADD
	CONSTRAINT [PK_SpecialOfferProduct_SpecialOfferID_ProductID]
	PRIMARY KEY
	CLUSTERED
	([SpecialOfferID], [ProductID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_SpecialOfferProduct_ModifiedDate to [Sales].[SpecialOfferProduct]'
GO
ALTER TABLE [Sales].[SpecialOfferProduct]
	ADD
	CONSTRAINT [DF_SpecialOfferProduct_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_SpecialOfferProduct_rowguid to [Sales].[SpecialOfferProduct]'
GO
ALTER TABLE [Sales].[SpecialOfferProduct]
	ADD
	CONSTRAINT [DF_SpecialOfferProduct_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_SpecialOfferProduct_rowguid on [Sales].[SpecialOfferProduct]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SpecialOfferProduct_rowguid]
	ON [Sales].[SpecialOfferProduct] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index IX_SpecialOfferProduct_ProductID on [Sales].[SpecialOfferProduct]'
GO
CREATE NONCLUSTERED INDEX [IX_SpecialOfferProduct_ProductID]
	ON [Sales].[SpecialOfferProduct] ([ProductID])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[SpecialOfferProduct] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[ShoppingCartItem]'
GO
CREATE TABLE [Sales].[ShoppingCartItem] (
		[ShoppingCartItemID]     [int] IDENTITY(1, 1) NOT NULL,
		[ShoppingCartID]         [nvarchar](50) NOT NULL,
		[Quantity]               [int] NOT NULL,
		[ProductID]              [int] NOT NULL,
		[DateCreated]            [datetime] NOT NULL,
		[ModifiedDate]           [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ShoppingCartItem_ShoppingCartItemID to [Sales].[ShoppingCartItem]'
GO
ALTER TABLE [Sales].[ShoppingCartItem]
	ADD
	CONSTRAINT [PK_ShoppingCartItem_ShoppingCartItemID]
	PRIMARY KEY
	CLUSTERED
	([ShoppingCartItemID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ShoppingCartItem_DateCreated to [Sales].[ShoppingCartItem]'
GO
ALTER TABLE [Sales].[ShoppingCartItem]
	ADD
	CONSTRAINT [DF_ShoppingCartItem_DateCreated]
	DEFAULT (getdate()) FOR [DateCreated]
GO


Print 'Add Default Constraint DF_ShoppingCartItem_ModifiedDate to [Sales].[ShoppingCartItem]'
GO
ALTER TABLE [Sales].[ShoppingCartItem]
	ADD
	CONSTRAINT [DF_ShoppingCartItem_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_ShoppingCartItem_Quantity to [Sales].[ShoppingCartItem]'
GO
ALTER TABLE [Sales].[ShoppingCartItem]
	ADD
	CONSTRAINT [DF_ShoppingCartItem_Quantity]
	DEFAULT ((1)) FOR [Quantity]
GO


Print 'Create Index IX_ShoppingCartItem_ShoppingCartID_ProductID on [Sales].[ShoppingCartItem]'
GO
CREATE NONCLUSTERED INDEX [IX_ShoppingCartItem_ShoppingCartID_ProductID]
	ON [Sales].[ShoppingCartItem] ([ShoppingCartID], [ProductID])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[ShoppingCartItem] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[SalesPerson]'
GO
CREATE TABLE [Sales].[SalesPerson] (
		[BusinessEntityID]     [int] NOT NULL,
		[TerritoryID]          [int] NULL,
		[SalesQuota]           [money] NULL,
		[Bonus]                [money] NOT NULL,
		[CommissionPct]        [smallmoney] NOT NULL,
		[SalesYTD]             [money] NOT NULL,
		[SalesLastYear]        [money] NOT NULL,
		[rowguid]              [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_SalesPerson_BusinessEntityID to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [PK_SalesPerson_BusinessEntityID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_SalesPerson_Bonus to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [DF_SalesPerson_Bonus]
	DEFAULT ((0.00)) FOR [Bonus]
GO


Print 'Add Default Constraint DF_SalesPerson_CommissionPct to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [DF_SalesPerson_CommissionPct]
	DEFAULT ((0.00)) FOR [CommissionPct]
GO


Print 'Add Default Constraint DF_SalesPerson_ModifiedDate to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [DF_SalesPerson_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_SalesPerson_rowguid to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [DF_SalesPerson_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Add Default Constraint DF_SalesPerson_SalesLastYear to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [DF_SalesPerson_SalesLastYear]
	DEFAULT ((0.00)) FOR [SalesLastYear]
GO


Print 'Add Default Constraint DF_SalesPerson_SalesYTD to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [DF_SalesPerson_SalesYTD]
	DEFAULT ((0.00)) FOR [SalesYTD]
GO


Print 'Create Index AK_SalesPerson_rowguid on [Sales].[SalesPerson]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SalesPerson_rowguid]
	ON [Sales].[SalesPerson] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[SalesPerson] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [HumanResources].[EmployeePayHistory]'
GO
CREATE TABLE [HumanResources].[EmployeePayHistory] (
		[BusinessEntityID]     [int] NOT NULL,
		[RateChangeDate]       [datetime] NOT NULL,
		[Rate]                 [money] NOT NULL,
		[PayFrequency]         [tinyint] NOT NULL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_EmployeePayHistory_BusinessEntityID_RateChangeDate to [HumanResources].[EmployeePayHistory]'
GO
ALTER TABLE [HumanResources].[EmployeePayHistory]
	ADD
	CONSTRAINT [PK_EmployeePayHistory_BusinessEntityID_RateChangeDate]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID], [RateChangeDate])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_EmployeePayHistory_ModifiedDate to [HumanResources].[EmployeePayHistory]'
GO
ALTER TABLE [HumanResources].[EmployeePayHistory]
	ADD
	CONSTRAINT [DF_EmployeePayHistory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [HumanResources].[EmployeePayHistory] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [HumanResources].[JobCandidate]'
GO
CREATE TABLE [HumanResources].[JobCandidate] (
		[JobCandidateID]       [int] IDENTITY(1, 1) NOT NULL,
		[BusinessEntityID]     [int] NULL,
		[Resume]               [xml](CONTENT [HumanResources].[HRResumeSchemaCollection]) NULL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_JobCandidate_JobCandidateID to [HumanResources].[JobCandidate]'
GO
ALTER TABLE [HumanResources].[JobCandidate]
	ADD
	CONSTRAINT [PK_JobCandidate_JobCandidateID]
	PRIMARY KEY
	CLUSTERED
	([JobCandidateID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_JobCandidate_ModifiedDate to [HumanResources].[JobCandidate]'
GO
ALTER TABLE [HumanResources].[JobCandidate]
	ADD
	CONSTRAINT [DF_JobCandidate_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index IX_JobCandidate_BusinessEntityID on [HumanResources].[JobCandidate]'
GO
CREATE NONCLUSTERED INDEX [IX_JobCandidate_BusinessEntityID]
	ON [HumanResources].[JobCandidate] ([BusinessEntityID])
	ON [PRIMARY]
GO


ALTER TABLE [HumanResources].[JobCandidate] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[Address]'
GO
CREATE TABLE [Person].[Address] (
		[AddressID]           [int] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
		[AddressLine1]        [nvarchar](60) NOT NULL,
		[AddressLine2]        [nvarchar](60) NULL,
		[City]                [nvarchar](30) NOT NULL,
		[StateProvinceID]     [int] NOT NULL,
		[PostalCode]          [nvarchar](15) NOT NULL,
		[SpatialLocation]     [geography] NULL,
		[rowguid]             [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]        [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Address_AddressID to [Person].[Address]'
GO
ALTER TABLE [Person].[Address]
	ADD
	CONSTRAINT [PK_Address_AddressID]
	PRIMARY KEY
	CLUSTERED
	([AddressID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Address_ModifiedDate to [Person].[Address]'
GO
ALTER TABLE [Person].[Address]
	ADD
	CONSTRAINT [DF_Address_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_Address_rowguid to [Person].[Address]'
GO
ALTER TABLE [Person].[Address]
	ADD
	CONSTRAINT [DF_Address_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_Address_rowguid on [Person].[Address]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Address_rowguid]
	ON [Person].[Address] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode on [Person].[Address]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode]
	ON [Person].[Address] ([AddressLine1], [AddressLine2], [City], [StateProvinceID], [PostalCode])
	ON [PRIMARY]
GO


Print 'Create Index IX_Address_StateProvinceID on [Person].[Address]'
GO
CREATE NONCLUSTERED INDEX [IX_Address_StateProvinceID]
	ON [Person].[Address] ([StateProvinceID])
	ON [PRIMARY]
GO


ALTER TABLE [Person].[Address] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Purchasing].[ProductVendor]'
GO
CREATE TABLE [Purchasing].[ProductVendor] (
		[ProductID]            [int] NOT NULL,
		[BusinessEntityID]     [int] NOT NULL,
		[AverageLeadTime]      [int] NOT NULL,
		[StandardPrice]        [money] NOT NULL,
		[LastReceiptCost]      [money] NULL,
		[LastReceiptDate]      [datetime] NULL,
		[MinOrderQty]          [int] NOT NULL,
		[MaxOrderQty]          [int] NOT NULL,
		[OnOrderQty]           [int] NULL,
		[UnitMeasureCode]      [nchar](3) NOT NULL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductVendor_ProductID_BusinessEntityID to [Purchasing].[ProductVendor]'
GO
ALTER TABLE [Purchasing].[ProductVendor]
	ADD
	CONSTRAINT [PK_ProductVendor_ProductID_BusinessEntityID]
	PRIMARY KEY
	CLUSTERED
	([ProductID], [BusinessEntityID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductVendor_ModifiedDate to [Purchasing].[ProductVendor]'
GO
ALTER TABLE [Purchasing].[ProductVendor]
	ADD
	CONSTRAINT [DF_ProductVendor_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index IX_ProductVendor_BusinessEntityID on [Purchasing].[ProductVendor]'
GO
CREATE NONCLUSTERED INDEX [IX_ProductVendor_BusinessEntityID]
	ON [Purchasing].[ProductVendor] ([BusinessEntityID])
	ON [PRIMARY]
GO


Print 'Create Index IX_ProductVendor_UnitMeasureCode on [Purchasing].[ProductVendor]'
GO
CREATE NONCLUSTERED INDEX [IX_ProductVendor_UnitMeasureCode]
	ON [Purchasing].[ProductVendor] ([UnitMeasureCode])
	ON [PRIMARY]
GO


ALTER TABLE [Purchasing].[ProductVendor] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[WorkOrder]'
GO
CREATE TABLE [Production].[WorkOrder] (
		[WorkOrderID]       [int] IDENTITY(1, 1) NOT NULL,
		[ProductID]         [int] NOT NULL,
		[OrderQty]          [int] NOT NULL,
		[StockedQty]        AS (isnull([OrderQty]-[ScrappedQty],(0))),
		[ScrappedQty]       [smallint] NOT NULL,
		[StartDate]         [datetime] NOT NULL,
		[EndDate]           [datetime] NULL,
		[DueDate]           [datetime] NOT NULL,
		[ScrapReasonID]     [smallint] NULL,
		[ModifiedDate]      [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_WorkOrder_WorkOrderID to [Production].[WorkOrder]'
GO
ALTER TABLE [Production].[WorkOrder]
	ADD
	CONSTRAINT [PK_WorkOrder_WorkOrderID]
	PRIMARY KEY
	CLUSTERED
	([WorkOrderID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_WorkOrder_ModifiedDate to [Production].[WorkOrder]'
GO
ALTER TABLE [Production].[WorkOrder]
	ADD
	CONSTRAINT [DF_WorkOrder_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index IX_WorkOrder_ProductID on [Production].[WorkOrder]'
GO
CREATE NONCLUSTERED INDEX [IX_WorkOrder_ProductID]
	ON [Production].[WorkOrder] ([ProductID])
	ON [PRIMARY]
GO


Print 'Create Index IX_WorkOrder_ScrapReasonID on [Production].[WorkOrder]'
GO
CREATE NONCLUSTERED INDEX [IX_WorkOrder_ScrapReasonID]
	ON [Production].[WorkOrder] ([ScrapReasonID])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[WorkOrder] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[Document]'
GO
CREATE TABLE [Production].[Document] (
		[DocumentNode]        [hierarchyid] NOT NULL,
		[DocumentLevel]       AS ([DocumentNode].[GetLevel]()),
		[Title]               [nvarchar](50) NOT NULL,
		[Owner]               [int] NOT NULL,
		[FolderFlag]          [bit] NOT NULL,
		[FileName]            [nvarchar](400) NOT NULL,
		[FileExtension]       [nvarchar](8) NOT NULL,
		[Revision]            [nchar](5) NOT NULL,
		[ChangeNumber]        [int] NOT NULL,
		[Status]              [tinyint] NOT NULL,
		[DocumentSummary]     [nvarchar](max) NULL,
		[Document]            [varbinary](max) NULL,
		[rowguid]             [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]        [datetime] NOT NULL,
		CONSTRAINT [UQ__Document__F73921F793071A63]
		UNIQUE
		NONCLUSTERED
		([rowguid])
		ON [PRIMARY]
)
GO


Print 'Add Primary Key PK_Document_DocumentNode to [Production].[Document]'
GO
ALTER TABLE [Production].[Document]
	ADD
	CONSTRAINT [PK_Document_DocumentNode]
	PRIMARY KEY
	CLUSTERED
	([DocumentNode])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Document_ChangeNumber to [Production].[Document]'
GO
ALTER TABLE [Production].[Document]
	ADD
	CONSTRAINT [DF_Document_ChangeNumber]
	DEFAULT ((0)) FOR [ChangeNumber]
GO


Print 'Add Default Constraint DF_Document_FolderFlag to [Production].[Document]'
GO
ALTER TABLE [Production].[Document]
	ADD
	CONSTRAINT [DF_Document_FolderFlag]
	DEFAULT ((0)) FOR [FolderFlag]
GO


Print 'Add Default Constraint DF_Document_ModifiedDate to [Production].[Document]'
GO
ALTER TABLE [Production].[Document]
	ADD
	CONSTRAINT [DF_Document_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_Document_rowguid to [Production].[Document]'
GO
ALTER TABLE [Production].[Document]
	ADD
	CONSTRAINT [DF_Document_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_Document_DocumentLevel_DocumentNode on [Production].[Document]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Document_DocumentLevel_DocumentNode]
	ON [Production].[Document] ([DocumentLevel], [DocumentNode])
	ON [PRIMARY]
GO


Print 'Create Index AK_Document_rowguid on [Production].[Document]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Document_rowguid]
	ON [Production].[Document] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index IX_Document_FileName_Revision on [Production].[Document]'
GO
CREATE NONCLUSTERED INDEX [IX_Document_FileName_Revision]
	ON [Production].[Document] ([FileName], [Revision])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[Document] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[TransactionHistory]'
GO
CREATE TABLE [Production].[TransactionHistory] (
		[TransactionID]            [int] IDENTITY(100000, 1) NOT NULL,
		[ProductID]                [int] NOT NULL,
		[ReferenceOrderID]         [int] NOT NULL,
		[ReferenceOrderLineID]     [int] NOT NULL,
		[TransactionDate]          [datetime] NOT NULL,
		[TransactionType]          [nchar](1) NOT NULL,
		[Quantity]                 [int] NOT NULL,
		[ActualCost]               [money] NOT NULL,
		[ModifiedDate]             [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_TransactionHistory_TransactionID to [Production].[TransactionHistory]'
GO
ALTER TABLE [Production].[TransactionHistory]
	ADD
	CONSTRAINT [PK_TransactionHistory_TransactionID]
	PRIMARY KEY
	CLUSTERED
	([TransactionID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_TransactionHistory_ModifiedDate to [Production].[TransactionHistory]'
GO
ALTER TABLE [Production].[TransactionHistory]
	ADD
	CONSTRAINT [DF_TransactionHistory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_TransactionHistory_ReferenceOrderLineID to [Production].[TransactionHistory]'
GO
ALTER TABLE [Production].[TransactionHistory]
	ADD
	CONSTRAINT [DF_TransactionHistory_ReferenceOrderLineID]
	DEFAULT ((0)) FOR [ReferenceOrderLineID]
GO


Print 'Add Default Constraint DF_TransactionHistory_TransactionDate to [Production].[TransactionHistory]'
GO
ALTER TABLE [Production].[TransactionHistory]
	ADD
	CONSTRAINT [DF_TransactionHistory_TransactionDate]
	DEFAULT (getdate()) FOR [TransactionDate]
GO


Print 'Create Index IX_TransactionHistory_ProductID on [Production].[TransactionHistory]'
GO
CREATE NONCLUSTERED INDEX [IX_TransactionHistory_ProductID]
	ON [Production].[TransactionHistory] ([ProductID])
	ON [PRIMARY]
GO


Print 'Create Index IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID on [Production].[TransactionHistory]'
GO
CREATE NONCLUSTERED INDEX [IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID]
	ON [Production].[TransactionHistory] ([ReferenceOrderID], [ReferenceOrderLineID])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[TransactionHistory] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductReview]'
GO
CREATE TABLE [Production].[ProductReview] (
		[ProductReviewID]     [int] IDENTITY(1, 1) NOT NULL,
		[ProductID]           [int] NOT NULL,
		[ReviewerName]        [dbo].[Name] NOT NULL,
		[ReviewDate]          [datetime] NOT NULL,
		[EmailAddress]        [nvarchar](50) NOT NULL,
		[Rating]              [int] NOT NULL,
		[Comments]            [nvarchar](3850) NULL,
		[ModifiedDate]        [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductReview_ProductReviewID to [Production].[ProductReview]'
GO
ALTER TABLE [Production].[ProductReview]
	ADD
	CONSTRAINT [PK_ProductReview_ProductReviewID]
	PRIMARY KEY
	CLUSTERED
	([ProductReviewID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductReview_ModifiedDate to [Production].[ProductReview]'
GO
ALTER TABLE [Production].[ProductReview]
	ADD
	CONSTRAINT [DF_ProductReview_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_ProductReview_ReviewDate to [Production].[ProductReview]'
GO
ALTER TABLE [Production].[ProductReview]
	ADD
	CONSTRAINT [DF_ProductReview_ReviewDate]
	DEFAULT (getdate()) FOR [ReviewDate]
GO


Print 'Create Index IX_ProductReview_ProductID_Name on [Production].[ProductReview]'
GO
CREATE NONCLUSTERED INDEX [IX_ProductReview_ProductID_Name]
	ON [Production].[ProductReview] ([ProductID], [ReviewerName])
	INCLUDE ([Comments])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[ProductReview] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductProductPhoto]'
GO
CREATE TABLE [Production].[ProductProductPhoto] (
		[ProductID]          [int] NOT NULL,
		[ProductPhotoID]     [int] NOT NULL,
		[Primary]            [dbo].[Flag] NOT NULL,
		[ModifiedDate]       [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductProductPhoto_ProductID_ProductPhotoID to [Production].[ProductProductPhoto]'
GO
ALTER TABLE [Production].[ProductProductPhoto]
	ADD
	CONSTRAINT [PK_ProductProductPhoto_ProductID_ProductPhotoID]
	PRIMARY KEY
	NONCLUSTERED
	([ProductID], [ProductPhotoID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductProductPhoto_ModifiedDate to [Production].[ProductProductPhoto]'
GO
ALTER TABLE [Production].[ProductProductPhoto]
	ADD
	CONSTRAINT [DF_ProductProductPhoto_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_ProductProductPhoto_Primary to [Production].[ProductProductPhoto]'
GO
ALTER TABLE [Production].[ProductProductPhoto]
	ADD
	CONSTRAINT [DF_ProductProductPhoto_Primary]
	DEFAULT ((0)) FOR [Primary]
GO


ALTER TABLE [Production].[ProductProductPhoto] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductListPriceHistory]'
GO
CREATE TABLE [Production].[ProductListPriceHistory] (
		[ProductID]        [int] NOT NULL,
		[StartDate]        [datetime] NOT NULL,
		[EndDate]          [datetime] NULL,
		[ListPrice]        [money] NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductListPriceHistory_ProductID_StartDate to [Production].[ProductListPriceHistory]'
GO
ALTER TABLE [Production].[ProductListPriceHistory]
	ADD
	CONSTRAINT [PK_ProductListPriceHistory_ProductID_StartDate]
	PRIMARY KEY
	CLUSTERED
	([ProductID], [StartDate])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductListPriceHistory_ModifiedDate to [Production].[ProductListPriceHistory]'
GO
ALTER TABLE [Production].[ProductListPriceHistory]
	ADD
	CONSTRAINT [DF_ProductListPriceHistory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [Production].[ProductListPriceHistory] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductInventory]'
GO
CREATE TABLE [Production].[ProductInventory] (
		[ProductID]        [int] NOT NULL,
		[LocationID]       [smallint] NOT NULL,
		[Shelf]            [nvarchar](10) NOT NULL,
		[Bin]              [tinyint] NOT NULL,
		[Quantity]         [smallint] NOT NULL,
		[rowguid]          [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]     [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductInventory_ProductID_LocationID to [Production].[ProductInventory]'
GO
ALTER TABLE [Production].[ProductInventory]
	ADD
	CONSTRAINT [PK_ProductInventory_ProductID_LocationID]
	PRIMARY KEY
	CLUSTERED
	([ProductID], [LocationID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductInventory_ModifiedDate to [Production].[ProductInventory]'
GO
ALTER TABLE [Production].[ProductInventory]
	ADD
	CONSTRAINT [DF_ProductInventory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_ProductInventory_Quantity to [Production].[ProductInventory]'
GO
ALTER TABLE [Production].[ProductInventory]
	ADD
	CONSTRAINT [DF_ProductInventory_Quantity]
	DEFAULT ((0)) FOR [Quantity]
GO


Print 'Add Default Constraint DF_ProductInventory_rowguid to [Production].[ProductInventory]'
GO
ALTER TABLE [Production].[ProductInventory]
	ADD
	CONSTRAINT [DF_ProductInventory_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


ALTER TABLE [Production].[ProductInventory] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductCostHistory]'
GO
CREATE TABLE [Production].[ProductCostHistory] (
		[ProductID]        [int] NOT NULL,
		[StartDate]        [datetime] NOT NULL,
		[EndDate]          [datetime] NULL,
		[StandardCost]     [money] NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductCostHistory_ProductID_StartDate to [Production].[ProductCostHistory]'
GO
ALTER TABLE [Production].[ProductCostHistory]
	ADD
	CONSTRAINT [PK_ProductCostHistory_ProductID_StartDate]
	PRIMARY KEY
	CLUSTERED
	([ProductID], [StartDate])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductCostHistory_ModifiedDate to [Production].[ProductCostHistory]'
GO
ALTER TABLE [Production].[ProductCostHistory]
	ADD
	CONSTRAINT [DF_ProductCostHistory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [Production].[ProductCostHistory] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Purchasing].[PurchaseOrderHeader]'
GO
CREATE TABLE [Purchasing].[PurchaseOrderHeader] (
		[PurchaseOrderID]     [int] IDENTITY(1, 1) NOT NULL,
		[RevisionNumber]      [tinyint] NOT NULL,
		[Status]              [tinyint] NOT NULL,
		[EmployeeID]          [int] NOT NULL,
		[VendorID]            [int] NOT NULL,
		[ShipMethodID]        [int] NOT NULL,
		[OrderDate]           [datetime] NOT NULL,
		[ShipDate]            [datetime] NULL,
		[SubTotal]            [money] NOT NULL,
		[TaxAmt]              [money] NOT NULL,
		[Freight]             [money] NOT NULL,
		[TotalDue]            AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))) PERSISTED NOT NULL,
		[ModifiedDate]        [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_PurchaseOrderHeader_PurchaseOrderID to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [PK_PurchaseOrderHeader_PurchaseOrderID]
	PRIMARY KEY
	CLUSTERED
	([PurchaseOrderID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_PurchaseOrderHeader_Freight to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [DF_PurchaseOrderHeader_Freight]
	DEFAULT ((0.00)) FOR [Freight]
GO


Print 'Add Default Constraint DF_PurchaseOrderHeader_ModifiedDate to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [DF_PurchaseOrderHeader_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_PurchaseOrderHeader_OrderDate to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [DF_PurchaseOrderHeader_OrderDate]
	DEFAULT (getdate()) FOR [OrderDate]
GO


Print 'Add Default Constraint DF_PurchaseOrderHeader_RevisionNumber to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [DF_PurchaseOrderHeader_RevisionNumber]
	DEFAULT ((0)) FOR [RevisionNumber]
GO


Print 'Add Default Constraint DF_PurchaseOrderHeader_Status to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [DF_PurchaseOrderHeader_Status]
	DEFAULT ((1)) FOR [Status]
GO


Print 'Add Default Constraint DF_PurchaseOrderHeader_SubTotal to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [DF_PurchaseOrderHeader_SubTotal]
	DEFAULT ((0.00)) FOR [SubTotal]
GO


Print 'Add Default Constraint DF_PurchaseOrderHeader_TaxAmt to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [DF_PurchaseOrderHeader_TaxAmt]
	DEFAULT ((0.00)) FOR [TaxAmt]
GO


Print 'Create Index IX_PurchaseOrderHeader_EmployeeID on [Purchasing].[PurchaseOrderHeader]'
GO
CREATE NONCLUSTERED INDEX [IX_PurchaseOrderHeader_EmployeeID]
	ON [Purchasing].[PurchaseOrderHeader] ([EmployeeID])
	ON [PRIMARY]
GO


Print 'Create Index IX_PurchaseOrderHeader_VendorID on [Purchasing].[PurchaseOrderHeader]'
GO
CREATE NONCLUSTERED INDEX [IX_PurchaseOrderHeader_VendorID]
	ON [Purchasing].[PurchaseOrderHeader] ([VendorID])
	ON [PRIMARY]
GO


ALTER TABLE [Purchasing].[PurchaseOrderHeader] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[SalesTaxRate]'
GO
CREATE TABLE [Sales].[SalesTaxRate] (
		[SalesTaxRateID]      [int] IDENTITY(1, 1) NOT NULL,
		[StateProvinceID]     [int] NOT NULL,
		[TaxType]             [tinyint] NOT NULL,
		[TaxRate]             [smallmoney] NOT NULL,
		[Name]                [dbo].[Name] NOT NULL,
		[rowguid]             [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]        [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_SalesTaxRate_SalesTaxRateID to [Sales].[SalesTaxRate]'
GO
ALTER TABLE [Sales].[SalesTaxRate]
	ADD
	CONSTRAINT [PK_SalesTaxRate_SalesTaxRateID]
	PRIMARY KEY
	CLUSTERED
	([SalesTaxRateID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_SalesTaxRate_ModifiedDate to [Sales].[SalesTaxRate]'
GO
ALTER TABLE [Sales].[SalesTaxRate]
	ADD
	CONSTRAINT [DF_SalesTaxRate_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_SalesTaxRate_rowguid to [Sales].[SalesTaxRate]'
GO
ALTER TABLE [Sales].[SalesTaxRate]
	ADD
	CONSTRAINT [DF_SalesTaxRate_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Add Default Constraint DF_SalesTaxRate_TaxRate to [Sales].[SalesTaxRate]'
GO
ALTER TABLE [Sales].[SalesTaxRate]
	ADD
	CONSTRAINT [DF_SalesTaxRate_TaxRate]
	DEFAULT ((0.00)) FOR [TaxRate]
GO


Print 'Create Index AK_SalesTaxRate_rowguid on [Sales].[SalesTaxRate]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SalesTaxRate_rowguid]
	ON [Sales].[SalesTaxRate] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index AK_SalesTaxRate_StateProvinceID_TaxType on [Sales].[SalesTaxRate]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SalesTaxRate_StateProvinceID_TaxType]
	ON [Sales].[SalesTaxRate] ([StateProvinceID], [TaxType])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[SalesTaxRate] SET (LOCK_ESCALATION = TABLE)
GO


Print 'Create View [Production].[vProductAndDescription]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Production].[vProductAndDescription] 
WITH SCHEMABINDING 
AS 
-- View (indexed or standard) to display products and product descriptions by language.
SELECT 
    p.[ProductID] 
    ,p.[Name] 
    ,pm.[Name] AS [ProductModel] 
    ,pmx.[CultureID] 
    ,pd.[Description] 
FROM [Production].[Product] p 
    INNER JOIN [Production].[ProductModel] pm 
    ON p.[ProductModelID] = pm.[ProductModelID] 
    INNER JOIN [Production].[ProductModelProductDescriptionCulture] pmx 
    ON pm.[ProductModelID] = pmx.[ProductModelID] 
    INNER JOIN [Production].[ProductDescription] pd 
    ON pmx.[ProductDescriptionID] = pd.[ProductDescriptionID];
GO


Print 'Create Extended Property MS_Description on [Production].[vProductAndDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product names and descriptions. Product descriptions are provided in multiple languages.', 'SCHEMA', N'Production', 'VIEW', N'vProductAndDescription', NULL, NULL
GO


Print 'Create Index IX_vProductAndDescription on [Production].[vProductAndDescription]'
GO
CREATE UNIQUE CLUSTERED INDEX [IX_vProductAndDescription]
	ON [Production].[vProductAndDescription] ([CultureID], [ProductID])
	ON [PRIMARY]
GO


Print 'Create Extended Property MS_Description on [Production].[vProductAndDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index on the view vProductAndDescription.', 'SCHEMA', N'Production', 'VIEW', N'vProductAndDescription', 'INDEX', N'IX_vProductAndDescription'
GO


Print 'Create View [Person].[vStateProvinceCountryRegion]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Person].[vStateProvinceCountryRegion] 
WITH SCHEMABINDING 
AS 
SELECT 
    sp.[StateProvinceID] 
    ,sp.[StateProvinceCode] 
    ,sp.[IsOnlyStateProvinceFlag] 
    ,sp.[Name] AS [StateProvinceName] 
    ,sp.[TerritoryID] 
    ,cr.[CountryRegionCode] 
    ,cr.[Name] AS [CountryRegionName]
FROM [Person].[StateProvince] sp 
    INNER JOIN [Person].[CountryRegion] cr 
    ON sp.[CountryRegionCode] = cr.[CountryRegionCode];
GO


Print 'Create Extended Property MS_Description on [Person].[vStateProvinceCountryRegion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Joins StateProvince table with CountryRegion table.', 'SCHEMA', N'Person', 'VIEW', N'vStateProvinceCountryRegion', NULL, NULL
GO


Print 'Create Index IX_vStateProvinceCountryRegion on [Person].[vStateProvinceCountryRegion]'
GO
CREATE UNIQUE CLUSTERED INDEX [IX_vStateProvinceCountryRegion]
	ON [Person].[vStateProvinceCountryRegion] ([StateProvinceID], [CountryRegionCode])
	ON [PRIMARY]
GO


Print 'Create Extended Property MS_Description on [Person].[vStateProvinceCountryRegion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index on the view vStateProvinceCountryRegion.', 'SCHEMA', N'Person', 'VIEW', N'vStateProvinceCountryRegion', 'INDEX', N'IX_vStateProvinceCountryRegion'
GO


Print 'Create View [Purchasing].[vVendorWithContacts]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Purchasing].[vVendorWithContacts] AS 
SELECT 
    v.[BusinessEntityID]
    ,v.[Name]
    ,ct.[Name] AS [ContactType] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,pp.[PhoneNumber] 
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress] 
    ,p.[EmailPromotion] 
FROM [Purchasing].[Vendor] v
    INNER JOIN [Person].[BusinessEntityContact] bec 
    ON bec.[BusinessEntityID] = v.[BusinessEntityID]
	INNER JOIN [Person].ContactType ct
	ON ct.[ContactTypeID] = bec.[ContactTypeID]
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = bec.[PersonID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID];
GO


Print 'Create Extended Property MS_Description on [Purchasing].[vVendorWithContacts]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Vendor (company) names  and the names of vendor employees to contact.', 'SCHEMA', N'Purchasing', 'VIEW', N'vVendorWithContacts', NULL, NULL
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Procedure [HumanResources].[uspUpdateEmployeeLogin]'
GO
CREATE PROCEDURE [HumanResources].[uspUpdateEmployeeLogin]
    @BusinessEntityID [int], 
    @OrganizationNode [hierarchyid],
    @LoginID [nvarchar](256),
    @JobTitle [nvarchar](50),
    @HireDate [datetime],
    @CurrentFlag [dbo].[Flag]
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [HumanResources].[Employee] 
        SET [OrganizationNode] = @OrganizationNode 
            ,[LoginID] = @LoginID 
            ,[JobTitle] = @JobTitle 
            ,[HireDate] = @HireDate 
            ,[CurrentFlag] = @CurrentFlag 
        WHERE [BusinessEntityID] = @BusinessEntityID;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeLogin]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Updates the Employee table with the values specified in the input parameters for the given BusinessEntityID.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeLogin', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeLogin]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeLogin. Enter a valid EmployeeID from the Employee table.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeLogin', 'PARAMETER', N'@BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeLogin]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter the current flag for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeLogin', 'PARAMETER', N'@CurrentFlag'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeLogin]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a hire date for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeLogin', 'PARAMETER', N'@HireDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeLogin]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a title for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeLogin', 'PARAMETER', N'@JobTitle'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeLogin]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a valid login for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeLogin', 'PARAMETER', N'@LoginID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeLogin]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a valid ManagerID for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeLogin', 'PARAMETER', N'@OrganizationNode'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Procedure [HumanResources].[uspUpdateEmployeePersonalInfo]'
GO
CREATE PROCEDURE [HumanResources].[uspUpdateEmployeePersonalInfo]
    @BusinessEntityID [int], 
    @NationalIDNumber [nvarchar](15), 
    @BirthDate [datetime], 
    @MaritalStatus [nchar](1), 
    @Gender [nchar](1)
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        UPDATE [HumanResources].[Employee] 
        SET [NationalIDNumber] = @NationalIDNumber 
            ,[BirthDate] = @BirthDate 
            ,[MaritalStatus] = @MaritalStatus 
            ,[Gender] = @Gender 
        WHERE [BusinessEntityID] = @BusinessEntityID;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeePersonalInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Updates the Employee table with the values specified in the input parameters for the given EmployeeID.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeePersonalInfo', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeePersonalInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a birth date for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeePersonalInfo', 'PARAMETER', N'@BirthDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeePersonalInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeePersonalInfo. Enter a valid BusinessEntityID from the HumanResources.Employee table.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeePersonalInfo', 'PARAMETER', N'@BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeePersonalInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a gender for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeePersonalInfo', 'PARAMETER', N'@Gender'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeePersonalInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a marital status for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeePersonalInfo', 'PARAMETER', N'@MaritalStatus'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeePersonalInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a national ID for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeePersonalInfo', 'PARAMETER', N'@NationalIDNumber'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Procedure [dbo].[uspGetEmployeeManagers]'
GO
CREATE PROCEDURE [dbo].[uspGetEmployeeManagers]
    @BusinessEntityID [int]
AS
BEGIN
    SET NOCOUNT ON;

    -- Use recursive query to list out all Employees required for a particular Manager
    WITH [EMP_cte]([BusinessEntityID], [OrganizationNode], [FirstName], [LastName], [JobTitle], [RecursionLevel]) -- CTE name and columns
    AS (
        SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], e.[JobTitle], 0 -- Get the initial Employee
        FROM [HumanResources].[Employee] e 
			INNER JOIN [Person].[Person] as p
			ON p.[BusinessEntityID] = e.[BusinessEntityID]
        WHERE e.[BusinessEntityID] = @BusinessEntityID
        UNION ALL
        SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], e.[JobTitle], [RecursionLevel] + 1 -- Join recursive member to anchor
        FROM [HumanResources].[Employee] e 
            INNER JOIN [EMP_cte]
            ON e.[OrganizationNode] = [EMP_cte].[OrganizationNode].GetAncestor(1)
            INNER JOIN [Person].[Person] p 
            ON p.[BusinessEntityID] = e.[BusinessEntityID]
    )
    -- Join back to Employee to return the manager name 
    SELECT [EMP_cte].[RecursionLevel], [EMP_cte].[BusinessEntityID], [EMP_cte].[FirstName], [EMP_cte].[LastName], 
        [EMP_cte].[OrganizationNode].ToString() AS [OrganizationNode], p.[FirstName] AS 'ManagerFirstName', p.[LastName] AS 'ManagerLastName'  -- Outer select from the CTE
    FROM [EMP_cte] 
        INNER JOIN [HumanResources].[Employee] e 
        ON [EMP_cte].[OrganizationNode].GetAncestor(1) = e.[OrganizationNode]
        INNER JOIN [Person].[Person] p 
        ON p.[BusinessEntityID] = e.[BusinessEntityID]
    ORDER BY [RecursionLevel], [EMP_cte].[OrganizationNode].ToString()
    OPTION (MAXRECURSION 25) 
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[uspGetEmployeeManagers]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stored procedure using a recursive query to return the direct and indirect managers of the specified employee.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetEmployeeManagers', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[uspGetEmployeeManagers]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspGetEmployeeManagers. Enter a valid BusinessEntityID from the HumanResources.Employee table.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetEmployeeManagers', 'PARAMETER', N'@BusinessEntityID'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Procedure [dbo].[uspGetManagerEmployees]'
GO
CREATE PROCEDURE [dbo].[uspGetManagerEmployees]
    @BusinessEntityID [int]
AS
BEGIN
    SET NOCOUNT ON;

    -- Use recursive query to list out all Employees required for a particular Manager
    WITH [EMP_cte]([BusinessEntityID], [OrganizationNode], [FirstName], [LastName], [RecursionLevel]) -- CTE name and columns
    AS (
        SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], 0 -- Get the initial list of Employees for Manager n
        FROM [HumanResources].[Employee] e 
			INNER JOIN [Person].[Person] p 
			ON p.[BusinessEntityID] = e.[BusinessEntityID]
        WHERE e.[BusinessEntityID] = @BusinessEntityID
        UNION ALL
        SELECT e.[BusinessEntityID], e.[OrganizationNode], p.[FirstName], p.[LastName], [RecursionLevel] + 1 -- Join recursive member to anchor
        FROM [HumanResources].[Employee] e 
            INNER JOIN [EMP_cte]
            ON e.[OrganizationNode].GetAncestor(1) = [EMP_cte].[OrganizationNode]
			INNER JOIN [Person].[Person] p 
			ON p.[BusinessEntityID] = e.[BusinessEntityID]
        )
    -- Join back to Employee to return the manager name 
    SELECT [EMP_cte].[RecursionLevel], [EMP_cte].[OrganizationNode].ToString() as [OrganizationNode], p.[FirstName] AS 'ManagerFirstName', p.[LastName] AS 'ManagerLastName',
        [EMP_cte].[BusinessEntityID], [EMP_cte].[FirstName], [EMP_cte].[LastName] -- Outer select from the CTE
    FROM [EMP_cte] 
        INNER JOIN [HumanResources].[Employee] e 
        ON [EMP_cte].[OrganizationNode].GetAncestor(1) = e.[OrganizationNode]
			INNER JOIN [Person].[Person] p 
			ON p.[BusinessEntityID] = e.[BusinessEntityID]
    ORDER BY [RecursionLevel], [EMP_cte].[OrganizationNode].ToString()
    OPTION (MAXRECURSION 25) 
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[uspGetManagerEmployees]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stored procedure using a recursive query to return the direct and indirect employees of the specified manager.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetManagerEmployees', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[uspGetManagerEmployees]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspGetManagerEmployees. Enter a valid BusinessEntityID of the manager from the HumanResources.Employee table.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetManagerEmployees', 'PARAMETER', N'@BusinessEntityID'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Trigger [HumanResources].[dEmployee]'
GO
CREATE TRIGGER [HumanResources].[dEmployee] ON [HumanResources].[Employee] 
INSTEAD OF DELETE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN
        RAISERROR
            (N'Employees cannot be deleted. They can only be marked as not current.', -- Message
            10, -- Severity.
            1); -- State.

        -- Rollback any active or uncommittable transactions
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END
    END;
END;
GO


Print 'Create Extended Property MS_Description on [HumanResources].[dEmployee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'INSTEAD OF DELETE trigger which keeps Employees from being deleted.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'TRIGGER', N'dEmployee'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[SalesTerritoryHistory]'
GO
CREATE TABLE [Sales].[SalesTerritoryHistory] (
		[BusinessEntityID]     [int] NOT NULL,
		[TerritoryID]          [int] NOT NULL,
		[StartDate]            [datetime] NOT NULL,
		[EndDate]              [datetime] NULL,
		[rowguid]              [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID to [Sales].[SalesTerritoryHistory]'
GO
ALTER TABLE [Sales].[SalesTerritoryHistory]
	ADD
	CONSTRAINT [PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID], [StartDate], [TerritoryID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_SalesTerritoryHistory_ModifiedDate to [Sales].[SalesTerritoryHistory]'
GO
ALTER TABLE [Sales].[SalesTerritoryHistory]
	ADD
	CONSTRAINT [DF_SalesTerritoryHistory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_SalesTerritoryHistory_rowguid to [Sales].[SalesTerritoryHistory]'
GO
ALTER TABLE [Sales].[SalesTerritoryHistory]
	ADD
	CONSTRAINT [DF_SalesTerritoryHistory_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_SalesTerritoryHistory_rowguid on [Sales].[SalesTerritoryHistory]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SalesTerritoryHistory_rowguid]
	ON [Sales].[SalesTerritoryHistory] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[SalesTerritoryHistory] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[SalesPersonQuotaHistory]'
GO
CREATE TABLE [Sales].[SalesPersonQuotaHistory] (
		[BusinessEntityID]     [int] NOT NULL,
		[QuotaDate]            [datetime] NOT NULL,
		[SalesQuota]           [money] NOT NULL,
		[rowguid]              [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate to [Sales].[SalesPersonQuotaHistory]'
GO
ALTER TABLE [Sales].[SalesPersonQuotaHistory]
	ADD
	CONSTRAINT [PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID], [QuotaDate])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_SalesPersonQuotaHistory_ModifiedDate to [Sales].[SalesPersonQuotaHistory]'
GO
ALTER TABLE [Sales].[SalesPersonQuotaHistory]
	ADD
	CONSTRAINT [DF_SalesPersonQuotaHistory_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_SalesPersonQuotaHistory_rowguid to [Sales].[SalesPersonQuotaHistory]'
GO
ALTER TABLE [Sales].[SalesPersonQuotaHistory]
	ADD
	CONSTRAINT [DF_SalesPersonQuotaHistory_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_SalesPersonQuotaHistory_rowguid on [Sales].[SalesPersonQuotaHistory]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SalesPersonQuotaHistory_rowguid]
	ON [Sales].[SalesPersonQuotaHistory] ([rowguid])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[SalesPersonQuotaHistory] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[ProductDocument]'
GO
CREATE TABLE [Production].[ProductDocument] (
		[ProductID]        [int] NOT NULL,
		[DocumentNode]     [hierarchyid] NOT NULL,
		[ModifiedDate]     [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_ProductDocument_ProductID_DocumentNode to [Production].[ProductDocument]'
GO
ALTER TABLE [Production].[ProductDocument]
	ADD
	CONSTRAINT [PK_ProductDocument_ProductID_DocumentNode]
	PRIMARY KEY
	CLUSTERED
	([ProductID], [DocumentNode])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_ProductDocument_ModifiedDate to [Production].[ProductDocument]'
GO
ALTER TABLE [Production].[ProductDocument]
	ADD
	CONSTRAINT [DF_ProductDocument_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [Production].[ProductDocument] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Person].[BusinessEntityAddress]'
GO
CREATE TABLE [Person].[BusinessEntityAddress] (
		[BusinessEntityID]     [int] NOT NULL,
		[AddressID]            [int] NOT NULL,
		[AddressTypeID]        [int] NOT NULL,
		[rowguid]              [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID to [Person].[BusinessEntityAddress]'
GO
ALTER TABLE [Person].[BusinessEntityAddress]
	ADD
	CONSTRAINT [PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID], [AddressID], [AddressTypeID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_BusinessEntityAddress_ModifiedDate to [Person].[BusinessEntityAddress]'
GO
ALTER TABLE [Person].[BusinessEntityAddress]
	ADD
	CONSTRAINT [DF_BusinessEntityAddress_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_BusinessEntityAddress_rowguid to [Person].[BusinessEntityAddress]'
GO
ALTER TABLE [Person].[BusinessEntityAddress]
	ADD
	CONSTRAINT [DF_BusinessEntityAddress_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_BusinessEntityAddress_rowguid on [Person].[BusinessEntityAddress]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_BusinessEntityAddress_rowguid]
	ON [Person].[BusinessEntityAddress] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index IX_BusinessEntityAddress_AddressID on [Person].[BusinessEntityAddress]'
GO
CREATE NONCLUSTERED INDEX [IX_BusinessEntityAddress_AddressID]
	ON [Person].[BusinessEntityAddress] ([AddressID])
	ON [PRIMARY]
GO


Print 'Create Index IX_BusinessEntityAddress_AddressTypeID on [Person].[BusinessEntityAddress]'
GO
CREATE NONCLUSTERED INDEX [IX_BusinessEntityAddress_AddressTypeID]
	ON [Person].[BusinessEntityAddress] ([AddressTypeID])
	ON [PRIMARY]
GO


ALTER TABLE [Person].[BusinessEntityAddress] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Production].[WorkOrderRouting]'
GO
CREATE TABLE [Production].[WorkOrderRouting] (
		[WorkOrderID]            [int] NOT NULL,
		[ProductID]              [int] NOT NULL,
		[OperationSequence]      [smallint] NOT NULL,
		[LocationID]             [smallint] NOT NULL,
		[ScheduledStartDate]     [datetime] NOT NULL,
		[ScheduledEndDate]       [datetime] NOT NULL,
		[ActualStartDate]        [datetime] NULL,
		[ActualEndDate]          [datetime] NULL,
		[ActualResourceHrs]      [decimal](9, 4) NULL,
		[PlannedCost]            [money] NOT NULL,
		[ActualCost]             [money] NULL,
		[ModifiedDate]           [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence to [Production].[WorkOrderRouting]'
GO
ALTER TABLE [Production].[WorkOrderRouting]
	ADD
	CONSTRAINT [PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence]
	PRIMARY KEY
	CLUSTERED
	([WorkOrderID], [ProductID], [OperationSequence])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_WorkOrderRouting_ModifiedDate to [Production].[WorkOrderRouting]'
GO
ALTER TABLE [Production].[WorkOrderRouting]
	ADD
	CONSTRAINT [DF_WorkOrderRouting_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index IX_WorkOrderRouting_ProductID on [Production].[WorkOrderRouting]'
GO
CREATE NONCLUSTERED INDEX [IX_WorkOrderRouting_ProductID]
	ON [Production].[WorkOrderRouting] ([ProductID])
	ON [PRIMARY]
GO


ALTER TABLE [Production].[WorkOrderRouting] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[Store]'
GO
CREATE TABLE [Sales].[Store] (
		[BusinessEntityID]     [int] NOT NULL,
		[Name]                 [dbo].[Name] NOT NULL,
		[SalesPersonID]        [int] NULL,
		[Demographics]         [xml](CONTENT [Sales].[StoreSurveySchemaCollection]) NULL,
		[rowguid]              [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]         [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Store_BusinessEntityID to [Sales].[Store]'
GO
ALTER TABLE [Sales].[Store]
	ADD
	CONSTRAINT [PK_Store_BusinessEntityID]
	PRIMARY KEY
	CLUSTERED
	([BusinessEntityID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Store_ModifiedDate to [Sales].[Store]'
GO
ALTER TABLE [Sales].[Store]
	ADD
	CONSTRAINT [DF_Store_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_Store_rowguid to [Sales].[Store]'
GO
ALTER TABLE [Sales].[Store]
	ADD
	CONSTRAINT [DF_Store_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_Store_rowguid on [Sales].[Store]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Store_rowguid]
	ON [Sales].[Store] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index IX_Store_SalesPersonID on [Sales].[Store]'
GO
CREATE NONCLUSTERED INDEX [IX_Store_SalesPersonID]
	ON [Sales].[Store] ([SalesPersonID])
	ON [PRIMARY]
GO


Print 'Create Xml Index PXML_Store_Demographics on [Sales].[Store]'
GO
CREATE PRIMARY XML INDEX [PXML_Store_Demographics]
	ON [Sales].[Store] ([Demographics])
GO


ALTER TABLE [Sales].[Store] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Purchasing].[PurchaseOrderDetail]'
GO
CREATE TABLE [Purchasing].[PurchaseOrderDetail] (
		[PurchaseOrderID]           [int] NOT NULL,
		[PurchaseOrderDetailID]     [int] IDENTITY(1, 1) NOT NULL,
		[DueDate]                   [datetime] NOT NULL,
		[OrderQty]                  [smallint] NOT NULL,
		[ProductID]                 [int] NOT NULL,
		[UnitPrice]                 [money] NOT NULL,
		[LineTotal]                 AS (isnull([OrderQty]*[UnitPrice],(0.00))),
		[ReceivedQty]               [decimal](8, 2) NOT NULL,
		[RejectedQty]               [decimal](8, 2) NOT NULL,
		[StockedQty]                AS (isnull([ReceivedQty]-[RejectedQty],(0.00))),
		[ModifiedDate]              [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID to [Purchasing].[PurchaseOrderDetail]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderDetail]
	ADD
	CONSTRAINT [PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID]
	PRIMARY KEY
	CLUSTERED
	([PurchaseOrderID], [PurchaseOrderDetailID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_PurchaseOrderDetail_ModifiedDate to [Purchasing].[PurchaseOrderDetail]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderDetail]
	ADD
	CONSTRAINT [DF_PurchaseOrderDetail_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Create Index IX_PurchaseOrderDetail_ProductID on [Purchasing].[PurchaseOrderDetail]'
GO
CREATE NONCLUSTERED INDEX [IX_PurchaseOrderDetail_ProductID]
	ON [Purchasing].[PurchaseOrderDetail] ([ProductID])
	ON [PRIMARY]
GO


ALTER TABLE [Purchasing].[PurchaseOrderDetail] SET (LOCK_ESCALATION = TABLE)
GO


Print 'Create View [HumanResources].[vJobCandidateEmployment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [HumanResources].[vJobCandidateEmployment] 
AS 
SELECT 
    jc.[JobCandidateID] 
    ,CONVERT(datetime, REPLACE([Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.StartDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Emp.StartDate] 
    ,CONVERT(datetime, REPLACE([Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.EndDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Emp.EndDate] 
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.OrgName)[1]', 'nvarchar(100)') AS [Emp.OrgName]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.JobTitle)[1]', 'nvarchar(100)') AS [Emp.JobTitle]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.Responsibility)[1]', 'nvarchar(max)') AS [Emp.Responsibility]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.FunctionCategory)[1]', 'nvarchar(max)') AS [Emp.FunctionCategory]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.IndustryCategory)[1]', 'nvarchar(max)') AS [Emp.IndustryCategory]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.Location/Location/Loc.CountryRegion)[1]', 'nvarchar(max)') AS [Emp.Loc.CountryRegion]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.Location/Location/Loc.State)[1]', 'nvarchar(max)') AS [Emp.Loc.State]
    ,[Employment].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Emp.Location/Location/Loc.City)[1]', 'nvarchar(max)') AS [Emp.Loc.City]
FROM [HumanResources].[JobCandidate] jc 
CROSS APPLY jc.[Resume].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
    /Resume/Employment') AS Employment(ref);
GO


Print 'Create Extended Property MS_Description on [HumanResources].[vJobCandidateEmployment]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Displays the content from each employement history related element in the xml column Resume in the HumanResources.JobCandidate table. The content has been localized into French, Simplified Chinese and Thai. Some data may not display correctly unless supplemental language support is installed.', 'SCHEMA', N'HumanResources', 'VIEW', N'vJobCandidateEmployment', NULL, NULL
GO


Print 'Create View [HumanResources].[vJobCandidate]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


-- View

CREATE VIEW [HumanResources].[vJobCandidate] 
AS 
SELECT 
    jc.[JobCandidateID] 
    ,jc.[BusinessEntityID] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/Name/Name.Prefix)[1]', 'nvarchar(30)') AS [Name.Prefix] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume";
        (/Resume/Name/Name.First)[1]', 'nvarchar(30)') AS [Name.First] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/Name/Name.Middle)[1]', 'nvarchar(30)') AS [Name.Middle] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/Name/Name.Last)[1]', 'nvarchar(30)') AS [Name.Last] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/Name/Name.Suffix)[1]', 'nvarchar(30)') AS [Name.Suffix] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/Skills)[1]', 'nvarchar(max)') AS [Skills] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Address/Addr.Type)[1]', 'nvarchar(30)') AS [Addr.Type]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Address/Addr.Location/Location/Loc.CountryRegion)[1]', 'nvarchar(100)') AS [Addr.Loc.CountryRegion]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Address/Addr.Location/Location/Loc.State)[1]', 'nvarchar(100)') AS [Addr.Loc.State]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Address/Addr.Location/Location/Loc.City)[1]', 'nvarchar(100)') AS [Addr.Loc.City]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Address/Addr.PostalCode)[1]', 'nvarchar(20)') AS [Addr.PostalCode]
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/EMail)[1]', 'nvarchar(max)') AS [EMail] 
    ,[Resume].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (/Resume/WebSite)[1]', 'nvarchar(max)') AS [WebSite] 
    ,jc.[ModifiedDate] 
FROM [HumanResources].[JobCandidate] jc 
CROSS APPLY jc.[Resume].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
    /Resume') AS Resume(ref);
GO


Print 'Create Extended Property MS_Description on [HumanResources].[vJobCandidate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job candidate names and resumes.', 'SCHEMA', N'HumanResources', 'VIEW', N'vJobCandidate', NULL, NULL
GO


Print 'Create View [HumanResources].[vEmployeeDepartmentHistory]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [HumanResources].[vEmployeeDepartmentHistory] 
AS 
SELECT 
    e.[BusinessEntityID] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,s.[Name] AS [Shift]
    ,d.[Name] AS [Department] 
    ,d.[GroupName] 
    ,edh.[StartDate] 
    ,edh.[EndDate]
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh 
    ON e.[BusinessEntityID] = edh.[BusinessEntityID] 
    INNER JOIN [HumanResources].[Department] d 
    ON edh.[DepartmentID] = d.[DepartmentID] 
    INNER JOIN [HumanResources].[Shift] s
    ON s.[ShiftID] = edh.[ShiftID];
GO


Print 'Create Extended Property MS_Description on [HumanResources].[vEmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Returns employee name and current and previous departments.', 'SCHEMA', N'HumanResources', 'VIEW', N'vEmployeeDepartmentHistory', NULL, NULL
GO


Print 'Create View [HumanResources].[vEmployeeDepartment]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [HumanResources].[vEmployeeDepartment] 
AS 
SELECT 
    e.[BusinessEntityID] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,e.[JobTitle]
    ,d.[Name] AS [Department] 
    ,d.[GroupName] 
    ,edh.[StartDate] 
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [HumanResources].[EmployeeDepartmentHistory] edh 
    ON e.[BusinessEntityID] = edh.[BusinessEntityID] 
    INNER JOIN [HumanResources].[Department] d 
    ON edh.[DepartmentID] = d.[DepartmentID] 
WHERE edh.EndDate IS NULL
GO


Print 'Create Extended Property MS_Description on [HumanResources].[vEmployeeDepartment]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Returns employee name, title, and current department.', 'SCHEMA', N'HumanResources', 'VIEW', N'vEmployeeDepartment', NULL, NULL
GO


Print 'Create View [HumanResources].[vJobCandidateEducation]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [HumanResources].[vJobCandidateEducation] 
AS 
SELECT 
    jc.[JobCandidateID] 
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Level)[1]', 'nvarchar(max)') AS [Edu.Level]
    ,CONVERT(datetime, REPLACE([Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.StartDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Edu.StartDate] 
    ,CONVERT(datetime, REPLACE([Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.EndDate)[1]', 'nvarchar(20)') ,'Z', ''), 101) AS [Edu.EndDate] 
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Degree)[1]', 'nvarchar(50)') AS [Edu.Degree]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Major)[1]', 'nvarchar(50)') AS [Edu.Major]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Minor)[1]', 'nvarchar(50)') AS [Edu.Minor]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.GPA)[1]', 'nvarchar(5)') AS [Edu.GPA]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.GPAScale)[1]', 'nvarchar(5)') AS [Edu.GPAScale]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.School)[1]', 'nvarchar(100)') AS [Edu.School]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Location/Location/Loc.CountryRegion)[1]', 'nvarchar(100)') AS [Edu.Loc.CountryRegion]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Location/Location/Loc.State)[1]', 'nvarchar(100)') AS [Edu.Loc.State]
    ,[Education].ref.value(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
        (Edu.Location/Location/Loc.City)[1]', 'nvarchar(100)') AS [Edu.Loc.City]
FROM [HumanResources].[JobCandidate] jc 
CROSS APPLY jc.[Resume].nodes(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/Resume"; 
    /Resume/Education') AS [Education](ref);
GO


Print 'Create Extended Property MS_Description on [HumanResources].[vJobCandidateEducation]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Displays the content from each education related element in the xml column Resume in the HumanResources.JobCandidate table. The content has been localized into French, Simplified Chinese and Thai. Some data may not display correctly unless supplemental language support is installed.', 'SCHEMA', N'HumanResources', 'VIEW', N'vJobCandidateEducation', NULL, NULL
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Function [dbo].[ufnGetStock]'
GO
CREATE FUNCTION [dbo].[ufnGetStock](@ProductID [int])
RETURNS [int] 
AS 
-- Returns the stock level for the product. This function is used internally only
BEGIN
    DECLARE @ret int;
    
    SELECT @ret = SUM(p.[Quantity]) 
    FROM [Production].[ProductInventory] p 
    WHERE p.[ProductID] = @ProductID 
        AND p.[LocationID] = '6'; -- Only look at inventory in the misc storage
    
    IF (@ret IS NULL) 
        SET @ret = 0
    
    RETURN @ret
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetStock]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Scalar function returning the quantity of inventory in LocationID 6 (Miscellaneous Storage)for a specified ProductID.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetStock', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetStock]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the scalar function ufnGetStock. Enter a valid ProductID from the Production.ProductInventory table.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetStock', 'PARAMETER', N'@ProductID'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Function [dbo].[ufnGetProductDealerPrice]'
GO
CREATE FUNCTION [dbo].[ufnGetProductDealerPrice](@ProductID [int], @OrderDate [datetime])
RETURNS [money] 
AS 
-- Returns the dealer price for the product on a specific date.
BEGIN
    DECLARE @DealerPrice money;
    DECLARE @DealerDiscount money;

    SET @DealerDiscount = 0.60  -- 60% of list price

    SELECT @DealerPrice = plph.[ListPrice] * @DealerDiscount 
    FROM [Production].[Product] p 
        INNER JOIN [Production].[ProductListPriceHistory] plph 
        ON p.[ProductID] = plph.[ProductID] 
            AND p.[ProductID] = @ProductID 
            AND @OrderDate BETWEEN plph.[StartDate] AND COALESCE(plph.[EndDate], CONVERT(datetime, '99991231', 112)); -- Make sure we get all the prices!

    RETURN @DealerPrice;
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetProductDealerPrice]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Scalar function returning the dealer price for a given product on a particular order date.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetProductDealerPrice', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetProductDealerPrice]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the scalar function ufnGetProductDealerPrice. Enter a valid order date.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetProductDealerPrice', 'PARAMETER', N'@OrderDate'
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetProductDealerPrice]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the scalar function ufnGetProductDealerPrice. Enter a valid ProductID from the Production.Product table.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetProductDealerPrice', 'PARAMETER', N'@ProductID'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Function [dbo].[ufnGetProductListPrice]'
GO
CREATE FUNCTION [dbo].[ufnGetProductListPrice](@ProductID [int], @OrderDate [datetime])
RETURNS [money] 
AS 
BEGIN
    DECLARE @ListPrice money;

    SELECT @ListPrice = plph.[ListPrice] 
    FROM [Production].[Product] p 
        INNER JOIN [Production].[ProductListPriceHistory] plph 
        ON p.[ProductID] = plph.[ProductID] 
            AND p.[ProductID] = @ProductID 
            AND @OrderDate BETWEEN plph.[StartDate] AND COALESCE(plph.[EndDate], CONVERT(datetime, '99991231', 112)); -- Make sure we get all the prices!

    RETURN @ListPrice;
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetProductListPrice]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Scalar function returning the list price for a given product on a particular order date.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetProductListPrice', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetProductListPrice]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the scalar function ufnGetProductListPrice. Enter a valid order date.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetProductListPrice', 'PARAMETER', N'@OrderDate'
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetProductListPrice]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the scalar function ufnGetProductListPrice. Enter a valid ProductID from the Production.Product table.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetProductListPrice', 'PARAMETER', N'@ProductID'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Function [dbo].[ufnGetProductStandardCost]'
GO
CREATE FUNCTION [dbo].[ufnGetProductStandardCost](@ProductID [int], @OrderDate [datetime])
RETURNS [money] 
AS 
-- Returns the standard cost for the product on a specific date.
BEGIN
    DECLARE @StandardCost money;

    SELECT @StandardCost = pch.[StandardCost] 
    FROM [Production].[Product] p 
        INNER JOIN [Production].[ProductCostHistory] pch 
        ON p.[ProductID] = pch.[ProductID] 
            AND p.[ProductID] = @ProductID 
            AND @OrderDate BETWEEN pch.[StartDate] AND COALESCE(pch.[EndDate], CONVERT(datetime, '99991231', 112)); -- Make sure we get all the prices!

    RETURN @StandardCost;
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetProductStandardCost]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Scalar function returning the standard cost for a given product on a particular order date.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetProductStandardCost', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetProductStandardCost]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the scalar function ufnGetProductStandardCost. Enter a valid order date.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetProductStandardCost', 'PARAMETER', N'@OrderDate'
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetProductStandardCost]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the scalar function ufnGetProductStandardCost. Enter a valid ProductID from the Production.Product table.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetProductStandardCost', 'PARAMETER', N'@ProductID'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Procedure [HumanResources].[uspUpdateEmployeeHireInfo]'
GO
CREATE PROCEDURE [HumanResources].[uspUpdateEmployeeHireInfo]
    @BusinessEntityID [int], 
    @JobTitle [nvarchar](50), 
    @HireDate [datetime], 
    @RateChangeDate [datetime], 
    @Rate [money], 
    @PayFrequency [tinyint], 
    @CurrentFlag [dbo].[Flag] 
WITH EXECUTE AS CALLER
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        UPDATE [HumanResources].[Employee] 
        SET [JobTitle] = @JobTitle 
            ,[HireDate] = @HireDate 
            ,[CurrentFlag] = @CurrentFlag 
        WHERE [BusinessEntityID] = @BusinessEntityID;

        INSERT INTO [HumanResources].[EmployeePayHistory] 
            ([BusinessEntityID]
            ,[RateChangeDate]
            ,[Rate]
            ,[PayFrequency]) 
        VALUES (@BusinessEntityID, @RateChangeDate, @Rate, @PayFrequency);

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeHireInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Updates the Employee table and inserts a new row in the EmployeePayHistory table with the values specified in the input parameters.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeHireInfo', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeHireInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a valid BusinessEntityID from the Employee table.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeHireInfo', 'PARAMETER', N'@BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeHireInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter the current flag for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeHireInfo', 'PARAMETER', N'@CurrentFlag'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeHireInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a hire date for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeHireInfo', 'PARAMETER', N'@HireDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeHireInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter a title for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeHireInfo', 'PARAMETER', N'@JobTitle'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeHireInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter the pay frequency for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeHireInfo', 'PARAMETER', N'@PayFrequency'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeHireInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter the new rate for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeHireInfo', 'PARAMETER', N'@Rate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[uspUpdateEmployeeHireInfo]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspUpdateEmployeeHireInfo. Enter the date the rate changed for the employee.', 'SCHEMA', N'HumanResources', 'PROCEDURE', N'uspUpdateEmployeeHireInfo', 'PARAMETER', N'@RateChangeDate'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Procedure [dbo].[uspGetBillOfMaterials]'
GO
CREATE PROCEDURE [dbo].[uspGetBillOfMaterials]
    @StartProductID [int],
    @CheckDate [datetime]
AS
BEGIN
    SET NOCOUNT ON;

    -- Use recursive query to generate a multi-level Bill of Material (i.e. all level 1 
    -- components of a level 0 assembly, all level 2 components of a level 1 assembly)
    -- The CheckDate eliminates any components that are no longer used in the product on this date.
    WITH [BOM_cte]([ProductAssemblyID], [ComponentID], [ComponentDesc], [PerAssemblyQty], [StandardCost], [ListPrice], [BOMLevel], [RecursionLevel]) -- CTE name and columns
    AS (
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], 0 -- Get the initial list of components for the bike assembly
        FROM [Production].[BillOfMaterials] b
            INNER JOIN [Production].[Product] p 
            ON b.[ComponentID] = p.[ProductID] 
        WHERE b.[ProductAssemblyID] = @StartProductID 
            AND @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        UNION ALL
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], [RecursionLevel] + 1 -- Join recursive member to anchor
        FROM [BOM_cte] cte
            INNER JOIN [Production].[BillOfMaterials] b 
            ON b.[ProductAssemblyID] = cte.[ComponentID]
            INNER JOIN [Production].[Product] p 
            ON b.[ComponentID] = p.[ProductID] 
        WHERE @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        )
    -- Outer select from the CTE
    SELECT b.[ProductAssemblyID], b.[ComponentID], b.[ComponentDesc], SUM(b.[PerAssemblyQty]) AS [TotalQuantity] , b.[StandardCost], b.[ListPrice], b.[BOMLevel], b.[RecursionLevel]
    FROM [BOM_cte] b
    GROUP BY b.[ComponentID], b.[ComponentDesc], b.[ProductAssemblyID], b.[BOMLevel], b.[RecursionLevel], b.[StandardCost], b.[ListPrice]
    ORDER BY b.[BOMLevel], b.[ProductAssemblyID], b.[ComponentID]
    OPTION (MAXRECURSION 25) 
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[uspGetBillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stored procedure using a recursive query to return a multi-level bill of material for the specified ProductID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetBillOfMaterials', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[uspGetBillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspGetBillOfMaterials used to eliminate components not used after that date. Enter a valid date.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetBillOfMaterials', 'PARAMETER', N'@CheckDate'
GO


Print 'Create Extended Property MS_Description on [dbo].[uspGetBillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspGetBillOfMaterials. Enter a valid ProductID from the Production.Product table.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetBillOfMaterials', 'PARAMETER', N'@StartProductID'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Procedure [dbo].[uspGetWhereUsedProductID]'
GO
CREATE PROCEDURE [dbo].[uspGetWhereUsedProductID]
    @StartProductID [int],
    @CheckDate [datetime]
AS
BEGIN
    SET NOCOUNT ON;

    --Use recursive query to generate a multi-level Bill of Material (i.e. all level 1 components of a level 0 assembly, all level 2 components of a level 1 assembly)
    WITH [BOM_cte]([ProductAssemblyID], [ComponentID], [ComponentDesc], [PerAssemblyQty], [StandardCost], [ListPrice], [BOMLevel], [RecursionLevel]) -- CTE name and columns
    AS (
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], 0 -- Get the initial list of components for the bike assembly
        FROM [Production].[BillOfMaterials] b
            INNER JOIN [Production].[Product] p 
            ON b.[ProductAssemblyID] = p.[ProductID] 
        WHERE b.[ComponentID] = @StartProductID 
            AND @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        UNION ALL
        SELECT b.[ProductAssemblyID], b.[ComponentID], p.[Name], b.[PerAssemblyQty], p.[StandardCost], p.[ListPrice], b.[BOMLevel], [RecursionLevel] + 1 -- Join recursive member to anchor
        FROM [BOM_cte] cte
            INNER JOIN [Production].[BillOfMaterials] b 
            ON cte.[ProductAssemblyID] = b.[ComponentID]
            INNER JOIN [Production].[Product] p 
            ON b.[ProductAssemblyID] = p.[ProductID] 
        WHERE @CheckDate >= b.[StartDate] 
            AND @CheckDate <= ISNULL(b.[EndDate], @CheckDate)
        )
    -- Outer select from the CTE
    SELECT b.[ProductAssemblyID], b.[ComponentID], b.[ComponentDesc], SUM(b.[PerAssemblyQty]) AS [TotalQuantity] , b.[StandardCost], b.[ListPrice], b.[BOMLevel], b.[RecursionLevel]
    FROM [BOM_cte] b
    GROUP BY b.[ComponentID], b.[ComponentDesc], b.[ProductAssemblyID], b.[BOMLevel], b.[RecursionLevel], b.[StandardCost], b.[ListPrice]
    ORDER BY b.[BOMLevel], b.[ProductAssemblyID], b.[ComponentID]
    OPTION (MAXRECURSION 25) 
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[uspGetWhereUsedProductID]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stored procedure using a recursive query to return all components or assemblies that directly or indirectly use the specified ProductID.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetWhereUsedProductID', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[uspGetWhereUsedProductID]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspGetWhereUsedProductID used to eliminate components not used after that date. Enter a valid date.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetWhereUsedProductID', 'PARAMETER', N'@CheckDate'
GO


Print 'Create Extended Property MS_Description on [dbo].[uspGetWhereUsedProductID]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the stored procedure uspGetWhereUsedProductID. Enter a valid ProductID from the Production.Product table.', 'SCHEMA', N'dbo', 'PROCEDURE', N'uspGetWhereUsedProductID', 'PARAMETER', N'@StartProductID'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Trigger [Production].[uWorkOrder]'
GO
CREATE TRIGGER [Production].[uWorkOrder] ON [Production].[WorkOrder] 
AFTER UPDATE AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        IF UPDATE([ProductID]) OR UPDATE([OrderQty])
        BEGIN
            INSERT INTO [Production].[TransactionHistory](
                [ProductID]
                ,[ReferenceOrderID]
                ,[TransactionType]
                ,[TransactionDate]
                ,[Quantity])
            SELECT 
                inserted.[ProductID]
                ,inserted.[WorkOrderID]
                ,'W'
                ,GETDATE()
                ,inserted.[OrderQty]
            FROM inserted;
        END;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


Print 'Create Extended Property MS_Description on [Production].[uWorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AFTER UPDATE trigger that inserts a row in the TransactionHistory table, updates ModifiedDate in the WorkOrder table.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'TRIGGER', N'uWorkOrder'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Trigger [Production].[iWorkOrder]'
GO
CREATE TRIGGER [Production].[iWorkOrder] ON [Production].[WorkOrder] 
AFTER INSERT AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO [Production].[TransactionHistory](
            [ProductID]
            ,[ReferenceOrderID]
            ,[TransactionType]
            ,[TransactionDate]
            ,[Quantity]
            ,[ActualCost])
        SELECT 
            inserted.[ProductID]
            ,inserted.[WorkOrderID]
            ,'W'
            ,GETDATE()
            ,inserted.[OrderQty]
            ,0
        FROM inserted;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


Print 'Create Extended Property MS_Description on [Production].[iWorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AFTER INSERT trigger that inserts a row in the TransactionHistory table.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'TRIGGER', N'iWorkOrder'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Trigger [Purchasing].[uPurchaseOrderHeader]'
GO
CREATE TRIGGER [Purchasing].[uPurchaseOrderHeader] ON [Purchasing].[PurchaseOrderHeader] 
AFTER UPDATE AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        -- Update RevisionNumber for modification of any field EXCEPT the Status.
        IF NOT UPDATE([Status])
        BEGIN
            UPDATE [Purchasing].[PurchaseOrderHeader]
            SET [Purchasing].[PurchaseOrderHeader].[RevisionNumber] = 
                [Purchasing].[PurchaseOrderHeader].[RevisionNumber] + 1
            WHERE [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID] IN 
                (SELECT inserted.[PurchaseOrderID] FROM inserted);
        END;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


Print 'Create Extended Property MS_Description on [Purchasing].[uPurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AFTER UPDATE trigger that updates the RevisionNumber and ModifiedDate columns in the PurchaseOrderHeader table.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'TRIGGER', N'uPurchaseOrderHeader'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[Customer]'
GO
CREATE TABLE [Sales].[Customer] (
		[CustomerID]        [int] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
		[PersonID]          [int] NULL,
		[StoreID]           [int] NULL,
		[TerritoryID]       [int] NULL,
		[AccountNumber]     AS (isnull('AW'+[dbo].[ufnLeadingZeros]([CustomerID]),'')),
		[rowguid]           [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]      [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_Customer_CustomerID to [Sales].[Customer]'
GO
ALTER TABLE [Sales].[Customer]
	ADD
	CONSTRAINT [PK_Customer_CustomerID]
	PRIMARY KEY
	CLUSTERED
	([CustomerID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_Customer_ModifiedDate to [Sales].[Customer]'
GO
ALTER TABLE [Sales].[Customer]
	ADD
	CONSTRAINT [DF_Customer_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_Customer_rowguid to [Sales].[Customer]'
GO
ALTER TABLE [Sales].[Customer]
	ADD
	CONSTRAINT [DF_Customer_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Create Index AK_Customer_AccountNumber on [Sales].[Customer]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Customer_AccountNumber]
	ON [Sales].[Customer] ([AccountNumber])
	ON [PRIMARY]
GO


Print 'Create Index AK_Customer_rowguid on [Sales].[Customer]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Customer_rowguid]
	ON [Sales].[Customer] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index IX_Customer_TerritoryID on [Sales].[Customer]'
GO
CREATE NONCLUSTERED INDEX [IX_Customer_TerritoryID]
	ON [Sales].[Customer] ([TerritoryID])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[Customer] SET (LOCK_ESCALATION = TABLE)
GO


Print 'Create View [Purchasing].[vVendorWithAddresses]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Purchasing].[vVendorWithAddresses] AS 
SELECT 
    v.[BusinessEntityID]
    ,v.[Name]
    ,at.[Name] AS [AddressType]
    ,a.[AddressLine1] 
    ,a.[AddressLine2] 
    ,a.[City] 
    ,sp.[Name] AS [StateProvinceName] 
    ,a.[PostalCode] 
    ,cr.[Name] AS [CountryRegionName] 
FROM [Purchasing].[Vendor] v
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = v.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    INNER JOIN [Person].[AddressType] at 
    ON at.[AddressTypeID] = bea.[AddressTypeID];
GO


Print 'Create Extended Property MS_Description on [Purchasing].[vVendorWithAddresses]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Vendor (company) names and addresses .', 'SCHEMA', N'Purchasing', 'VIEW', N'vVendorWithAddresses', NULL, NULL
GO


Print 'Create View [Sales].[vStoreWithAddresses]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Sales].[vStoreWithAddresses] AS 
SELECT 
    s.[BusinessEntityID] 
    ,s.[Name] 
    ,at.[Name] AS [AddressType]
    ,a.[AddressLine1] 
    ,a.[AddressLine2] 
    ,a.[City] 
    ,sp.[Name] AS [StateProvinceName] 
    ,a.[PostalCode] 
    ,cr.[Name] AS [CountryRegionName] 
FROM [Sales].[Store] s
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = s.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    INNER JOIN [Person].[AddressType] at 
    ON at.[AddressTypeID] = bea.[AddressTypeID];
GO


Print 'Create Extended Property MS_Description on [Sales].[vStoreWithAddresses]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores (including store addresses) that sell Adventure Works Cycles products to consumers.', 'SCHEMA', N'Sales', 'VIEW', N'vStoreWithAddresses', NULL, NULL
GO


Print 'Create View [Sales].[vStoreWithContacts]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Sales].[vStoreWithContacts] AS 
SELECT 
    s.[BusinessEntityID] 
    ,s.[Name] 
    ,ct.[Name] AS [ContactType] 
    ,p.[Title] 
    ,p.[FirstName] 
    ,p.[MiddleName] 
    ,p.[LastName] 
    ,p.[Suffix] 
    ,pp.[PhoneNumber] 
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress] 
    ,p.[EmailPromotion] 
FROM [Sales].[Store] s
    INNER JOIN [Person].[BusinessEntityContact] bec 
    ON bec.[BusinessEntityID] = s.[BusinessEntityID]
	INNER JOIN [Person].[ContactType] ct
	ON ct.[ContactTypeID] = bec.[ContactTypeID]
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = bec.[PersonID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID];
GO


Print 'Create Extended Property MS_Description on [Sales].[vStoreWithContacts]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores (including store contacts) that sell Adventure Works Cycles products to consumers.', 'SCHEMA', N'Sales', 'VIEW', N'vStoreWithContacts', NULL, NULL
GO


Print 'Create View [Sales].[vStoreWithDemographics]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Sales].[vStoreWithDemographics] AS 
SELECT 
    s.[BusinessEntityID] 
    ,s.[Name] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/AnnualSales)[1]', 'money') AS [AnnualSales] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/AnnualRevenue)[1]', 'money') AS [AnnualRevenue] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/BankName)[1]', 'nvarchar(50)') AS [BankName] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/BusinessType)[1]', 'nvarchar(5)') AS [BusinessType] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/YearOpened)[1]', 'integer') AS [YearOpened] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/Specialty)[1]', 'nvarchar(50)') AS [Specialty] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/SquareFeet)[1]', 'integer') AS [SquareFeet] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/Brands)[1]', 'nvarchar(30)') AS [Brands] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/Internet)[1]', 'nvarchar(30)') AS [Internet] 
    ,s.[Demographics].value('declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/StoreSurvey"; 
        (/StoreSurvey/NumberEmployees)[1]', 'integer') AS [NumberEmployees] 
FROM [Sales].[Store] s;
GO


Print 'Create Extended Property MS_Description on [Sales].[vStoreWithDemographics]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Stores (including demographics) that sell Adventure Works Cycles products to consumers.', 'SCHEMA', N'Sales', 'VIEW', N'vStoreWithDemographics', NULL, NULL
GO


Print 'Create View [HumanResources].[vEmployee]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [HumanResources].[vEmployee] 
AS 
SELECT 
    e.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,e.[JobTitle]  
    ,pp.[PhoneNumber]
    ,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,sp.[Name] AS [StateProvinceName] 
    ,a.[PostalCode]
    ,cr.[Name] AS [CountryRegionName] 
    ,p.[AdditionalContactInfo]
FROM [HumanResources].[Employee] e
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = e.[BusinessEntityID]
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = e.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    LEFT OUTER JOIN [Person].[PersonPhone] pp
    ON pp.BusinessEntityID = p.[BusinessEntityID]
    LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
    ON pp.[PhoneNumberTypeID] = pnt.[PhoneNumberTypeID]
    LEFT OUTER JOIN [Person].[EmailAddress] ea
    ON p.[BusinessEntityID] = ea.[BusinessEntityID];
GO


Print 'Create Extended Property MS_Description on [HumanResources].[vEmployee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employee names and addresses.', 'SCHEMA', N'HumanResources', 'VIEW', N'vEmployee', NULL, NULL
GO


Print 'Create View [Sales].[vSalesPerson]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Sales].[vSalesPerson] 
AS 
SELECT 
    s.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,e.[JobTitle]
    ,pp.[PhoneNumber]
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,[StateProvinceName] = sp.[Name]
    ,a.[PostalCode]
    ,[CountryRegionName] = cr.[Name]
    ,[TerritoryName] = st.[Name]
    ,[TerritoryGroup] = st.[Group]
    ,s.[SalesQuota]
    ,s.[SalesYTD]
    ,s.[SalesLastYear]
FROM [Sales].[SalesPerson] s
    INNER JOIN [HumanResources].[Employee] e 
    ON e.[BusinessEntityID] = s.[BusinessEntityID]
	INNER JOIN [Person].[Person] p
	ON p.[BusinessEntityID] = s.[BusinessEntityID]
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = s.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    LEFT OUTER JOIN [Sales].[SalesTerritory] st 
    ON st.[TerritoryID] = s.[TerritoryID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID];
GO


Print 'Create Extended Property MS_Description on [Sales].[vSalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales representiatives (names and addresses) and their sales-related information.', 'SCHEMA', N'Sales', 'VIEW', N'vSalesPerson', NULL, NULL
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Trigger [Purchasing].[uPurchaseOrderDetail]'
GO
CREATE TRIGGER [Purchasing].[uPurchaseOrderDetail] ON [Purchasing].[PurchaseOrderDetail] 
AFTER UPDATE AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        IF UPDATE([ProductID]) OR UPDATE([OrderQty]) OR UPDATE([UnitPrice])
        -- Insert record into TransactionHistory 
        BEGIN
            INSERT INTO [Production].[TransactionHistory]
                ([ProductID]
                ,[ReferenceOrderID]
                ,[ReferenceOrderLineID]
                ,[TransactionType]
                ,[TransactionDate]
                ,[Quantity]
                ,[ActualCost])
            SELECT 
                inserted.[ProductID]
                ,inserted.[PurchaseOrderID]
                ,inserted.[PurchaseOrderDetailID]
                ,'P'
                ,GETDATE()
                ,inserted.[OrderQty]
                ,inserted.[UnitPrice]
            FROM inserted 
                INNER JOIN [Purchasing].[PurchaseOrderDetail] 
                ON inserted.[PurchaseOrderID] = [Purchasing].[PurchaseOrderDetail].[PurchaseOrderID];

            -- Update SubTotal in PurchaseOrderHeader record. Note that this causes the 
            -- PurchaseOrderHeader trigger to fire which will update the RevisionNumber.
            UPDATE [Purchasing].[PurchaseOrderHeader]
            SET [Purchasing].[PurchaseOrderHeader].[SubTotal] = 
                (SELECT SUM([Purchasing].[PurchaseOrderDetail].[LineTotal])
                    FROM [Purchasing].[PurchaseOrderDetail]
                    WHERE [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID] 
                        = [Purchasing].[PurchaseOrderDetail].[PurchaseOrderID])
            WHERE [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID] 
                IN (SELECT inserted.[PurchaseOrderID] FROM inserted);

            UPDATE [Purchasing].[PurchaseOrderDetail]
            SET [Purchasing].[PurchaseOrderDetail].[ModifiedDate] = GETDATE()
            FROM inserted
            WHERE inserted.[PurchaseOrderID] = [Purchasing].[PurchaseOrderDetail].[PurchaseOrderID]
                AND inserted.[PurchaseOrderDetailID] = [Purchasing].[PurchaseOrderDetail].[PurchaseOrderDetailID];
        END;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


Print 'Create Extended Property MS_Description on [Purchasing].[uPurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AFTER UPDATE trigger that inserts a row in the TransactionHistory table, updates ModifiedDate in PurchaseOrderDetail and updates the PurchaseOrderHeader.SubTotal column.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'TRIGGER', N'uPurchaseOrderDetail'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Trigger [Purchasing].[iPurchaseOrderDetail]'
GO
CREATE TRIGGER [Purchasing].[iPurchaseOrderDetail] ON [Purchasing].[PurchaseOrderDetail] 
AFTER INSERT AS
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        INSERT INTO [Production].[TransactionHistory]
            ([ProductID]
            ,[ReferenceOrderID]
            ,[ReferenceOrderLineID]
            ,[TransactionType]
            ,[TransactionDate]
            ,[Quantity]
            ,[ActualCost])
        SELECT 
            inserted.[ProductID]
            ,inserted.[PurchaseOrderID]
            ,inserted.[PurchaseOrderDetailID]
            ,'P'
            ,GETDATE()
            ,inserted.[OrderQty]
            ,inserted.[UnitPrice]
        FROM inserted 
            INNER JOIN [Purchasing].[PurchaseOrderHeader] 
            ON inserted.[PurchaseOrderID] = [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID];

        -- Update SubTotal in PurchaseOrderHeader record. Note that this causes the 
        -- PurchaseOrderHeader trigger to fire which will update the RevisionNumber.
        UPDATE [Purchasing].[PurchaseOrderHeader]
        SET [Purchasing].[PurchaseOrderHeader].[SubTotal] = 
            (SELECT SUM([Purchasing].[PurchaseOrderDetail].[LineTotal])
                FROM [Purchasing].[PurchaseOrderDetail]
                WHERE [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID] = [Purchasing].[PurchaseOrderDetail].[PurchaseOrderID])
        WHERE [Purchasing].[PurchaseOrderHeader].[PurchaseOrderID] IN (SELECT inserted.[PurchaseOrderID] FROM inserted);
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


Print 'Create Extended Property MS_Description on [Purchasing].[iPurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AFTER INSERT trigger that inserts a row in the TransactionHistory table and updates the PurchaseOrderHeader.SubTotal column.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'TRIGGER', N'iPurchaseOrderDetail'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[SalesOrderHeader]'
GO
CREATE TABLE [Sales].[SalesOrderHeader] (
		[SalesOrderID]               [int] IDENTITY(1, 1) NOT FOR REPLICATION NOT NULL,
		[RevisionNumber]             [tinyint] NOT NULL,
		[OrderDate]                  [datetime] NOT NULL,
		[DueDate]                    [datetime] NOT NULL,
		[ShipDate]                   [datetime] NULL,
		[Status]                     [tinyint] NOT NULL,
		[OnlineOrderFlag]            [dbo].[Flag] NOT NULL,
		[SalesOrderNumber]           AS (isnull(N'SO'+CONVERT([nvarchar](23),[SalesOrderID],(0)),N'*** ERROR ***')),
		[PurchaseOrderNumber]        [dbo].[OrderNumber] NULL,
		[AccountNumber]              [dbo].[AccountNumber] NULL,
		[CustomerID]                 [int] NOT NULL,
		[SalesPersonID]              [int] NULL,
		[TerritoryID]                [int] NULL,
		[BillToAddressID]            [int] NOT NULL,
		[ShipToAddressID]            [int] NOT NULL,
		[ShipMethodID]               [int] NOT NULL,
		[CreditCardID]               [int] NULL,
		[CreditCardApprovalCode]     [varchar](15) NULL,
		[CurrencyRateID]             [int] NULL,
		[SubTotal]                   [money] NOT NULL,
		[TaxAmt]                     [money] NOT NULL,
		[Freight]                    [money] NOT NULL,
		[TotalDue]                   AS (isnull(([SubTotal]+[TaxAmt])+[Freight],(0))),
		[Comment]                    [nvarchar](128) NULL,
		[rowguid]                    [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]               [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_SalesOrderHeader_SalesOrderID to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [PK_SalesOrderHeader_SalesOrderID]
	PRIMARY KEY
	CLUSTERED
	([SalesOrderID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_SalesOrderHeader_Freight to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_Freight]
	DEFAULT ((0.00)) FOR [Freight]
GO


Print 'Add Default Constraint DF_SalesOrderHeader_ModifiedDate to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_SalesOrderHeader_OnlineOrderFlag to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_OnlineOrderFlag]
	DEFAULT ((1)) FOR [OnlineOrderFlag]
GO


Print 'Add Default Constraint DF_SalesOrderHeader_OrderDate to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_OrderDate]
	DEFAULT (getdate()) FOR [OrderDate]
GO


Print 'Add Default Constraint DF_SalesOrderHeader_RevisionNumber to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_RevisionNumber]
	DEFAULT ((0)) FOR [RevisionNumber]
GO


Print 'Add Default Constraint DF_SalesOrderHeader_rowguid to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Add Default Constraint DF_SalesOrderHeader_Status to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_Status]
	DEFAULT ((1)) FOR [Status]
GO


Print 'Add Default Constraint DF_SalesOrderHeader_SubTotal to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_SubTotal]
	DEFAULT ((0.00)) FOR [SubTotal]
GO


Print 'Add Default Constraint DF_SalesOrderHeader_TaxAmt to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [DF_SalesOrderHeader_TaxAmt]
	DEFAULT ((0.00)) FOR [TaxAmt]
GO


Print 'Create Index AK_SalesOrderHeader_rowguid on [Sales].[SalesOrderHeader]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SalesOrderHeader_rowguid]
	ON [Sales].[SalesOrderHeader] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index AK_SalesOrderHeader_SalesOrderNumber on [Sales].[SalesOrderHeader]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SalesOrderHeader_SalesOrderNumber]
	ON [Sales].[SalesOrderHeader] ([SalesOrderNumber])
	ON [PRIMARY]
GO


Print 'Create Index IX_SalesOrderHeader_CustomerID on [Sales].[SalesOrderHeader]'
GO
CREATE NONCLUSTERED INDEX [IX_SalesOrderHeader_CustomerID]
	ON [Sales].[SalesOrderHeader] ([CustomerID])
	ON [PRIMARY]
GO


Print 'Create Index IX_SalesOrderHeader_SalesPersonID on [Sales].[SalesOrderHeader]'
GO
CREATE NONCLUSTERED INDEX [IX_SalesOrderHeader_SalesPersonID]
	ON [Sales].[SalesOrderHeader] ([SalesPersonID])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[SalesOrderHeader] SET (LOCK_ESCALATION = TABLE)
GO


Print 'Create View [Sales].[vIndividualCustomer]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Sales].[vIndividualCustomer] 
AS 
SELECT 
    p.[BusinessEntityID]
    ,p.[Title]
    ,p.[FirstName]
    ,p.[MiddleName]
    ,p.[LastName]
    ,p.[Suffix]
    ,pp.[PhoneNumber]
	,pnt.[Name] AS [PhoneNumberType]
    ,ea.[EmailAddress]
    ,p.[EmailPromotion]
    ,at.[Name] AS [AddressType]
    ,a.[AddressLine1]
    ,a.[AddressLine2]
    ,a.[City]
    ,[StateProvinceName] = sp.[Name]
    ,a.[PostalCode]
    ,[CountryRegionName] = cr.[Name]
    ,p.[Demographics]
FROM [Person].[Person] p
    INNER JOIN [Person].[BusinessEntityAddress] bea 
    ON bea.[BusinessEntityID] = p.[BusinessEntityID] 
    INNER JOIN [Person].[Address] a 
    ON a.[AddressID] = bea.[AddressID]
    INNER JOIN [Person].[StateProvince] sp 
    ON sp.[StateProvinceID] = a.[StateProvinceID]
    INNER JOIN [Person].[CountryRegion] cr 
    ON cr.[CountryRegionCode] = sp.[CountryRegionCode]
    INNER JOIN [Person].[AddressType] at 
    ON at.[AddressTypeID] = bea.[AddressTypeID]
	INNER JOIN [Sales].[Customer] c
	ON c.[PersonID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[EmailAddress] ea
	ON ea.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PersonPhone] pp
	ON pp.[BusinessEntityID] = p.[BusinessEntityID]
	LEFT OUTER JOIN [Person].[PhoneNumberType] pnt
	ON pnt.[PhoneNumberTypeID] = pp.[PhoneNumberTypeID]
WHERE c.StoreID IS NULL;
GO


Print 'Create Extended Property MS_Description on [Sales].[vIndividualCustomer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Individual customers (names and addresses) that purchase Adventure Works Cycles products online.', 'SCHEMA', N'Sales', 'VIEW', N'vIndividualCustomer', NULL, NULL
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Function [dbo].[ufnGetContactInformation]'
GO
CREATE FUNCTION [dbo].[ufnGetContactInformation](@PersonID int)
RETURNS @retContactInformation TABLE 
(
    -- Columns returned by the function
    [PersonID] int NOT NULL, 
    [FirstName] [nvarchar](50) NULL, 
    [LastName] [nvarchar](50) NULL, 
	[JobTitle] [nvarchar](50) NULL,
    [BusinessEntityType] [nvarchar](50) NULL
)
AS 
-- Returns the first name, last name, job title and business entity type for the specified contact.
-- Since a contact can serve multiple roles, more than one row may be returned.
BEGIN
	IF @PersonID IS NOT NULL 
		BEGIN
		IF EXISTS(SELECT * FROM [HumanResources].[Employee] e 
					WHERE e.[BusinessEntityID] = @PersonID) 
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, e.[JobTitle], 'Employee'
				FROM [HumanResources].[Employee] AS e
					INNER JOIN [Person].[Person] p
					ON p.[BusinessEntityID] = e.[BusinessEntityID]
				WHERE e.[BusinessEntityID] = @PersonID;

		IF EXISTS(SELECT * FROM [Purchasing].[Vendor] AS v
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = v.[BusinessEntityID]
					WHERE bec.[PersonID] = @PersonID)
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, ct.[Name], 'Vendor Contact' 
				FROM [Purchasing].[Vendor] AS v
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = v.[BusinessEntityID]
					INNER JOIN [Person].ContactType ct
					ON ct.[ContactTypeID] = bec.[ContactTypeID]
					INNER JOIN [Person].[Person] p
					ON p.[BusinessEntityID] = bec.[PersonID]
				WHERE bec.[PersonID] = @PersonID;
		
		IF EXISTS(SELECT * FROM [Sales].[Store] AS s
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = s.[BusinessEntityID]
					WHERE bec.[PersonID] = @PersonID)
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, ct.[Name], 'Store Contact' 
				FROM [Sales].[Store] AS s
					INNER JOIN [Person].[BusinessEntityContact] bec 
					ON bec.[BusinessEntityID] = s.[BusinessEntityID]
					INNER JOIN [Person].ContactType ct
					ON ct.[ContactTypeID] = bec.[ContactTypeID]
					INNER JOIN [Person].[Person] p
					ON p.[BusinessEntityID] = bec.[PersonID]
				WHERE bec.[PersonID] = @PersonID;

		IF EXISTS(SELECT * FROM [Person].[Person] AS p
					INNER JOIN [Sales].[Customer] AS c
					ON c.[PersonID] = p.[BusinessEntityID]
					WHERE p.[BusinessEntityID] = @PersonID AND c.[StoreID] IS NULL) 
			INSERT INTO @retContactInformation
				SELECT @PersonID, p.FirstName, p.LastName, NULL, 'Consumer' 
				FROM [Person].[Person] AS p
					INNER JOIN [Sales].[Customer] AS c
					ON c.[PersonID] = p.[BusinessEntityID]
					WHERE p.[BusinessEntityID] = @PersonID AND c.[StoreID] IS NULL; 
		END

	RETURN;
END;
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetContactInformation]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Table value function returning the first name, last name, job title and contact type for a given contact.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetContactInformation', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[ufnGetContactInformation]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Input parameter for the table value function ufnGetContactInformation. Enter a valid PersonID from the Person.Contact table.', 'SCHEMA', N'dbo', 'FUNCTION', N'ufnGetContactInformation', 'PARAMETER', N'@PersonID'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[SalesOrderHeaderSalesReason]'
GO
CREATE TABLE [Sales].[SalesOrderHeaderSalesReason] (
		[SalesOrderID]      [int] NOT NULL,
		[SalesReasonID]     [int] NOT NULL,
		[ModifiedDate]      [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID to [Sales].[SalesOrderHeaderSalesReason]'
GO
ALTER TABLE [Sales].[SalesOrderHeaderSalesReason]
	ADD
	CONSTRAINT [PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID]
	PRIMARY KEY
	CLUSTERED
	([SalesOrderID], [SalesReasonID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_SalesOrderHeaderSalesReason_ModifiedDate to [Sales].[SalesOrderHeaderSalesReason]'
GO
ALTER TABLE [Sales].[SalesOrderHeaderSalesReason]
	ADD
	CONSTRAINT [DF_SalesOrderHeaderSalesReason_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


ALTER TABLE [Sales].[SalesOrderHeaderSalesReason] SET (LOCK_ESCALATION = TABLE)
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON

GO


Print 'Create Table [Sales].[SalesOrderDetail]'
GO
CREATE TABLE [Sales].[SalesOrderDetail] (
		[SalesOrderID]              [int] NOT NULL,
		[SalesOrderDetailID]        [int] IDENTITY(1, 1) NOT NULL,
		[CarrierTrackingNumber]     [nvarchar](25) NULL,
		[OrderQty]                  [smallint] NOT NULL,
		[ProductID]                 [int] NOT NULL,
		[SpecialOfferID]            [int] NOT NULL,
		[UnitPrice]                 [money] NOT NULL,
		[UnitPriceDiscount]         [money] NOT NULL,
		[LineTotal]                 AS (isnull(([UnitPrice]*((1.0)-[UnitPriceDiscount]))*[OrderQty],(0.0))),
		[rowguid]                   [uniqueidentifier] NOT NULL ROWGUIDCOL,
		[ModifiedDate]              [datetime] NOT NULL
)
GO


Print 'Add Primary Key PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID to [Sales].[SalesOrderDetail]'
GO
ALTER TABLE [Sales].[SalesOrderDetail]
	ADD
	CONSTRAINT [PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID]
	PRIMARY KEY
	CLUSTERED
	([SalesOrderID], [SalesOrderDetailID])
	ON [PRIMARY]
GO


Print 'Add Default Constraint DF_SalesOrderDetail_ModifiedDate to [Sales].[SalesOrderDetail]'
GO
ALTER TABLE [Sales].[SalesOrderDetail]
	ADD
	CONSTRAINT [DF_SalesOrderDetail_ModifiedDate]
	DEFAULT (getdate()) FOR [ModifiedDate]
GO


Print 'Add Default Constraint DF_SalesOrderDetail_rowguid to [Sales].[SalesOrderDetail]'
GO
ALTER TABLE [Sales].[SalesOrderDetail]
	ADD
	CONSTRAINT [DF_SalesOrderDetail_rowguid]
	DEFAULT (newid()) FOR [rowguid]
GO


Print 'Add Default Constraint DF_SalesOrderDetail_UnitPriceDiscount to [Sales].[SalesOrderDetail]'
GO
ALTER TABLE [Sales].[SalesOrderDetail]
	ADD
	CONSTRAINT [DF_SalesOrderDetail_UnitPriceDiscount]
	DEFAULT ((0.0)) FOR [UnitPriceDiscount]
GO


Print 'Create Index AK_SalesOrderDetail_rowguid on [Sales].[SalesOrderDetail]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_SalesOrderDetail_rowguid]
	ON [Sales].[SalesOrderDetail] ([rowguid])
	ON [PRIMARY]
GO


Print 'Create Index IX_SalesOrderDetail_ProductID on [Sales].[SalesOrderDetail]'
GO
CREATE NONCLUSTERED INDEX [IX_SalesOrderDetail_ProductID]
	ON [Sales].[SalesOrderDetail] ([ProductID])
	ON [PRIMARY]
GO


ALTER TABLE [Sales].[SalesOrderDetail] SET (LOCK_ESCALATION = TABLE)
GO


Print 'Create View [Sales].[vSalesPersonSalesByFiscalYears]'
GO
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [Sales].[vSalesPersonSalesByFiscalYears] 
AS 
SELECT 
    pvt.[SalesPersonID]
    ,pvt.[FullName]
    ,pvt.[JobTitle]
    ,pvt.[SalesTerritory]
    ,pvt.[2002]
    ,pvt.[2003]
    ,pvt.[2004] 
FROM (SELECT 
        soh.[SalesPersonID]
        ,p.[FirstName] + ' ' + COALESCE(p.[MiddleName], '') + ' ' + p.[LastName] AS [FullName]
        ,e.[JobTitle]
        ,st.[Name] AS [SalesTerritory]
        ,soh.[SubTotal]
        ,YEAR(DATEADD(m, 6, soh.[OrderDate])) AS [FiscalYear] 
    FROM [Sales].[SalesPerson] sp 
        INNER JOIN [Sales].[SalesOrderHeader] soh 
        ON sp.[BusinessEntityID] = soh.[SalesPersonID]
        INNER JOIN [Sales].[SalesTerritory] st 
        ON sp.[TerritoryID] = st.[TerritoryID] 
        INNER JOIN [HumanResources].[Employee] e 
        ON soh.[SalesPersonID] = e.[BusinessEntityID] 
		INNER JOIN [Person].[Person] p
		ON p.[BusinessEntityID] = sp.[BusinessEntityID]
	 ) AS soh 
PIVOT 
(
    SUM([SubTotal]) 
    FOR [FiscalYear] 
    IN ([2002], [2003], [2004])
) AS pvt;
GO


Print 'Create Extended Property MS_Description on [Sales].[vSalesPersonSalesByFiscalYears]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Uses PIVOT to return aggregated sales information for each sales representative.', 'SCHEMA', N'Sales', 'VIEW', N'vSalesPersonSalesByFiscalYears', NULL, NULL
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Trigger [Sales].[uSalesOrderHeader]'
GO
CREATE TRIGGER [Sales].[uSalesOrderHeader] ON [Sales].[SalesOrderHeader] 
AFTER UPDATE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        -- Update RevisionNumber for modification of any field EXCEPT the Status.
        IF NOT UPDATE([Status])
        BEGIN
            UPDATE [Sales].[SalesOrderHeader]
            SET [Sales].[SalesOrderHeader].[RevisionNumber] = 
                [Sales].[SalesOrderHeader].[RevisionNumber] + 1
            WHERE [Sales].[SalesOrderHeader].[SalesOrderID] IN 
                (SELECT inserted.[SalesOrderID] FROM inserted);
        END;

        -- Update the SalesPerson SalesYTD when SubTotal is updated
        IF UPDATE([SubTotal])
        BEGIN
            DECLARE @StartDate datetime,
                    @EndDate datetime

            SET @StartDate = [dbo].[ufnGetAccountingStartDate]();
            SET @EndDate = [dbo].[ufnGetAccountingEndDate]();

            UPDATE [Sales].[SalesPerson]
            SET [Sales].[SalesPerson].[SalesYTD] = 
                (SELECT SUM([Sales].[SalesOrderHeader].[SubTotal])
                FROM [Sales].[SalesOrderHeader] 
                WHERE [Sales].[SalesPerson].[BusinessEntityID] = [Sales].[SalesOrderHeader].[SalesPersonID]
                    AND ([Sales].[SalesOrderHeader].[Status] = 5) -- Shipped
                    AND [Sales].[SalesOrderHeader].[OrderDate] BETWEEN @StartDate AND @EndDate)
            WHERE [Sales].[SalesPerson].[BusinessEntityID] 
                IN (SELECT DISTINCT inserted.[SalesPersonID] FROM inserted 
                    WHERE inserted.[OrderDate] BETWEEN @StartDate AND @EndDate);

            -- Update the SalesTerritory SalesYTD when SubTotal is updated
            UPDATE [Sales].[SalesTerritory]
            SET [Sales].[SalesTerritory].[SalesYTD] = 
                (SELECT SUM([Sales].[SalesOrderHeader].[SubTotal])
                FROM [Sales].[SalesOrderHeader] 
                WHERE [Sales].[SalesTerritory].[TerritoryID] = [Sales].[SalesOrderHeader].[TerritoryID]
                    AND ([Sales].[SalesOrderHeader].[Status] = 5) -- Shipped
                    AND [Sales].[SalesOrderHeader].[OrderDate] BETWEEN @StartDate AND @EndDate)
            WHERE [Sales].[SalesTerritory].[TerritoryID] 
                IN (SELECT DISTINCT inserted.[TerritoryID] FROM inserted 
                    WHERE inserted.[OrderDate] BETWEEN @StartDate AND @EndDate);
        END;
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


Print 'Create Extended Property MS_Description on [Sales].[uSalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AFTER UPDATE trigger that updates the RevisionNumber and ModifiedDate columns in the SalesOrderHeader table.Updates the SalesYTD column in the SalesPerson and SalesTerritory tables.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'TRIGGER', N'uSalesOrderHeader'
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Trigger [Sales].[iduSalesOrderDetail]'
GO
CREATE TRIGGER [Sales].[iduSalesOrderDetail] ON [Sales].[SalesOrderDetail] 
AFTER INSERT, DELETE, UPDATE AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    BEGIN TRY
        -- If inserting or updating these columns
        IF UPDATE([ProductID]) OR UPDATE([OrderQty]) OR UPDATE([UnitPrice]) OR UPDATE([UnitPriceDiscount]) 
        -- Insert record into TransactionHistory
        BEGIN
            INSERT INTO [Production].[TransactionHistory]
                ([ProductID]
                ,[ReferenceOrderID]
                ,[ReferenceOrderLineID]
                ,[TransactionType]
                ,[TransactionDate]
                ,[Quantity]
                ,[ActualCost])
            SELECT 
                inserted.[ProductID]
                ,inserted.[SalesOrderID]
                ,inserted.[SalesOrderDetailID]
                ,'S'
                ,GETDATE()
                ,inserted.[OrderQty]
                ,inserted.[UnitPrice]
            FROM inserted 
                INNER JOIN [Sales].[SalesOrderHeader] 
                ON inserted.[SalesOrderID] = [Sales].[SalesOrderHeader].[SalesOrderID];

            UPDATE [Person].[Person] 
            SET [Demographics].modify('declare default element namespace 
                "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
                replace value of (/IndividualSurvey/TotalPurchaseYTD)[1] 
                with data(/IndividualSurvey/TotalPurchaseYTD)[1] + sql:column ("inserted.LineTotal")') 
            FROM inserted 
                INNER JOIN [Sales].[SalesOrderHeader] AS SOH
                ON inserted.[SalesOrderID] = SOH.[SalesOrderID] 
                INNER JOIN [Sales].[Customer] AS C
                ON SOH.[CustomerID] = C.[CustomerID]
            WHERE C.[PersonID] = [Person].[Person].[BusinessEntityID];
        END;

        -- Update SubTotal in SalesOrderHeader record. Note that this causes the 
        -- SalesOrderHeader trigger to fire which will update the RevisionNumber.
        UPDATE [Sales].[SalesOrderHeader]
        SET [Sales].[SalesOrderHeader].[SubTotal] = 
            (SELECT SUM([Sales].[SalesOrderDetail].[LineTotal])
                FROM [Sales].[SalesOrderDetail]
                WHERE [Sales].[SalesOrderHeader].[SalesOrderID] = [Sales].[SalesOrderDetail].[SalesOrderID])
        WHERE [Sales].[SalesOrderHeader].[SalesOrderID] IN (SELECT inserted.[SalesOrderID] FROM inserted);

        UPDATE [Person].[Person] 
        SET [Demographics].modify('declare default element namespace 
            "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
            replace value of (/IndividualSurvey/TotalPurchaseYTD)[1] 
            with data(/IndividualSurvey/TotalPurchaseYTD)[1] - sql:column("deleted.LineTotal")') 
        FROM deleted 
            INNER JOIN [Sales].[SalesOrderHeader] 
            ON deleted.[SalesOrderID] = [Sales].[SalesOrderHeader].[SalesOrderID] 
            INNER JOIN [Sales].[Customer]
            ON [Sales].[Customer].[CustomerID] = [Sales].[SalesOrderHeader].[CustomerID]
        WHERE [Sales].[Customer].[PersonID] = [Person].[Person].[BusinessEntityID];
    END TRY
    BEGIN CATCH
        EXECUTE [dbo].[uspPrintError];

        -- Rollback any active or uncommittable transactions before
        -- inserting information in the ErrorLog
        IF @@TRANCOUNT > 0
        BEGIN
            ROLLBACK TRANSACTION;
        END

        EXECUTE [dbo].[uspLogError];
    END CATCH;
END;
GO


Print 'Create Extended Property MS_Description on [Sales].[iduSalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AFTER INSERT, DELETE, UPDATE trigger that inserts a row in the TransactionHistory table, updates ModifiedDate in SalesOrderDetail and updates the SalesOrderHeader.SubTotal column.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'TRIGGER', N'iduSalesOrderDetail'
GO


Print 'Create Foreign Key FK_Employee_Person_BusinessEntityID on [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	WITH CHECK
	ADD CONSTRAINT [FK_Employee_Person_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Person].[Person] ([BusinessEntityID])
ALTER TABLE [HumanResources].[Employee]
	CHECK CONSTRAINT [FK_Employee_Person_BusinessEntityID]

GO


Print 'Add Check Constraint CK_Employee_BirthDate to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [CK_Employee_BirthDate]
	CHECK
	([BirthDate]>='1930-01-01' AND [BirthDate]<=dateadd(year,(-18),getdate()))
GO


ALTER TABLE [HumanResources].[Employee]
CHECK CONSTRAINT [CK_Employee_BirthDate]
GO


Print 'Add Check Constraint CK_Employee_Gender to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [CK_Employee_Gender]
	CHECK
	(upper([Gender])='F' OR upper([Gender])='M')
GO


ALTER TABLE [HumanResources].[Employee]
CHECK CONSTRAINT [CK_Employee_Gender]
GO


Print 'Add Check Constraint CK_Employee_HireDate to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [CK_Employee_HireDate]
	CHECK
	([HireDate]>='1996-07-01' AND [HireDate]<=dateadd(day,(1),getdate()))
GO


ALTER TABLE [HumanResources].[Employee]
CHECK CONSTRAINT [CK_Employee_HireDate]
GO


Print 'Add Check Constraint CK_Employee_MaritalStatus to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [CK_Employee_MaritalStatus]
	CHECK
	(upper([MaritalStatus])='S' OR upper([MaritalStatus])='M')
GO


ALTER TABLE [HumanResources].[Employee]
CHECK CONSTRAINT [CK_Employee_MaritalStatus]
GO


Print 'Add Check Constraint CK_Employee_SickLeaveHours to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [CK_Employee_SickLeaveHours]
	CHECK
	([SickLeaveHours]>=(0) AND [SickLeaveHours]<=(120))
GO


ALTER TABLE [HumanResources].[Employee]
CHECK CONSTRAINT [CK_Employee_SickLeaveHours]
GO


Print 'Add Check Constraint CK_Employee_VacationHours to [HumanResources].[Employee]'
GO
ALTER TABLE [HumanResources].[Employee]
	ADD
	CONSTRAINT [CK_Employee_VacationHours]
	CHECK
	([VacationHours]>=(-40) AND [VacationHours]<=(240))
GO


ALTER TABLE [HumanResources].[Employee]
CHECK CONSTRAINT [CK_Employee_VacationHours]
GO


Print 'Create Foreign Key FK_EmployeeDepartmentHistory_Department_DepartmentID on [HumanResources].[EmployeeDepartmentHistory]'
GO
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]
	WITH CHECK
	ADD CONSTRAINT [FK_EmployeeDepartmentHistory_Department_DepartmentID]
	FOREIGN KEY ([DepartmentID]) REFERENCES [HumanResources].[Department] ([DepartmentID])
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]
	CHECK CONSTRAINT [FK_EmployeeDepartmentHistory_Department_DepartmentID]

GO


Print 'Create Foreign Key FK_EmployeeDepartmentHistory_Employee_BusinessEntityID on [HumanResources].[EmployeeDepartmentHistory]'
GO
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]
	WITH CHECK
	ADD CONSTRAINT [FK_EmployeeDepartmentHistory_Employee_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [HumanResources].[Employee] ([BusinessEntityID])
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]
	CHECK CONSTRAINT [FK_EmployeeDepartmentHistory_Employee_BusinessEntityID]

GO


Print 'Create Foreign Key FK_EmployeeDepartmentHistory_Shift_ShiftID on [HumanResources].[EmployeeDepartmentHistory]'
GO
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]
	WITH CHECK
	ADD CONSTRAINT [FK_EmployeeDepartmentHistory_Shift_ShiftID]
	FOREIGN KEY ([ShiftID]) REFERENCES [HumanResources].[Shift] ([ShiftID])
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]
	CHECK CONSTRAINT [FK_EmployeeDepartmentHistory_Shift_ShiftID]

GO


Print 'Add Check Constraint CK_EmployeeDepartmentHistory_EndDate to [HumanResources].[EmployeeDepartmentHistory]'
GO
ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]
	ADD
	CONSTRAINT [CK_EmployeeDepartmentHistory_EndDate]
	CHECK
	([EndDate]>=[StartDate] OR [EndDate] IS NULL)
GO


ALTER TABLE [HumanResources].[EmployeeDepartmentHistory]
CHECK CONSTRAINT [CK_EmployeeDepartmentHistory_EndDate]
GO


Print 'Create Foreign Key FK_EmployeePayHistory_Employee_BusinessEntityID on [HumanResources].[EmployeePayHistory]'
GO
ALTER TABLE [HumanResources].[EmployeePayHistory]
	WITH CHECK
	ADD CONSTRAINT [FK_EmployeePayHistory_Employee_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [HumanResources].[Employee] ([BusinessEntityID])
ALTER TABLE [HumanResources].[EmployeePayHistory]
	CHECK CONSTRAINT [FK_EmployeePayHistory_Employee_BusinessEntityID]

GO


Print 'Add Check Constraint CK_EmployeePayHistory_PayFrequency to [HumanResources].[EmployeePayHistory]'
GO
ALTER TABLE [HumanResources].[EmployeePayHistory]
	ADD
	CONSTRAINT [CK_EmployeePayHistory_PayFrequency]
	CHECK
	([PayFrequency]=(2) OR [PayFrequency]=(1))
GO


ALTER TABLE [HumanResources].[EmployeePayHistory]
CHECK CONSTRAINT [CK_EmployeePayHistory_PayFrequency]
GO


Print 'Add Check Constraint CK_EmployeePayHistory_Rate to [HumanResources].[EmployeePayHistory]'
GO
ALTER TABLE [HumanResources].[EmployeePayHistory]
	ADD
	CONSTRAINT [CK_EmployeePayHistory_Rate]
	CHECK
	([Rate]>=(6.50) AND [Rate]<=(200.00))
GO


ALTER TABLE [HumanResources].[EmployeePayHistory]
CHECK CONSTRAINT [CK_EmployeePayHistory_Rate]
GO


Print 'Create Foreign Key FK_JobCandidate_Employee_BusinessEntityID on [HumanResources].[JobCandidate]'
GO
ALTER TABLE [HumanResources].[JobCandidate]
	WITH CHECK
	ADD CONSTRAINT [FK_JobCandidate_Employee_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [HumanResources].[Employee] ([BusinessEntityID])
ALTER TABLE [HumanResources].[JobCandidate]
	CHECK CONSTRAINT [FK_JobCandidate_Employee_BusinessEntityID]

GO


Print 'Create Foreign Key FK_Address_StateProvince_StateProvinceID on [Person].[Address]'
GO
ALTER TABLE [Person].[Address]
	WITH CHECK
	ADD CONSTRAINT [FK_Address_StateProvince_StateProvinceID]
	FOREIGN KEY ([StateProvinceID]) REFERENCES [Person].[StateProvince] ([StateProvinceID])
ALTER TABLE [Person].[Address]
	CHECK CONSTRAINT [FK_Address_StateProvince_StateProvinceID]

GO


Print 'Create Foreign Key FK_BusinessEntityAddress_Address_AddressID on [Person].[BusinessEntityAddress]'
GO
ALTER TABLE [Person].[BusinessEntityAddress]
	WITH CHECK
	ADD CONSTRAINT [FK_BusinessEntityAddress_Address_AddressID]
	FOREIGN KEY ([AddressID]) REFERENCES [Person].[Address] ([AddressID])
ALTER TABLE [Person].[BusinessEntityAddress]
	CHECK CONSTRAINT [FK_BusinessEntityAddress_Address_AddressID]

GO


Print 'Create Foreign Key FK_BusinessEntityAddress_AddressType_AddressTypeID on [Person].[BusinessEntityAddress]'
GO
ALTER TABLE [Person].[BusinessEntityAddress]
	WITH CHECK
	ADD CONSTRAINT [FK_BusinessEntityAddress_AddressType_AddressTypeID]
	FOREIGN KEY ([AddressTypeID]) REFERENCES [Person].[AddressType] ([AddressTypeID])
ALTER TABLE [Person].[BusinessEntityAddress]
	CHECK CONSTRAINT [FK_BusinessEntityAddress_AddressType_AddressTypeID]

GO


Print 'Create Foreign Key FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID on [Person].[BusinessEntityAddress]'
GO
ALTER TABLE [Person].[BusinessEntityAddress]
	WITH CHECK
	ADD CONSTRAINT [FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Person].[BusinessEntity] ([BusinessEntityID])
ALTER TABLE [Person].[BusinessEntityAddress]
	CHECK CONSTRAINT [FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID]

GO


Print 'Create Foreign Key FK_BusinessEntityContact_BusinessEntity_BusinessEntityID on [Person].[BusinessEntityContact]'
GO
ALTER TABLE [Person].[BusinessEntityContact]
	WITH CHECK
	ADD CONSTRAINT [FK_BusinessEntityContact_BusinessEntity_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Person].[BusinessEntity] ([BusinessEntityID])
ALTER TABLE [Person].[BusinessEntityContact]
	CHECK CONSTRAINT [FK_BusinessEntityContact_BusinessEntity_BusinessEntityID]

GO


Print 'Create Foreign Key FK_BusinessEntityContact_ContactType_ContactTypeID on [Person].[BusinessEntityContact]'
GO
ALTER TABLE [Person].[BusinessEntityContact]
	WITH CHECK
	ADD CONSTRAINT [FK_BusinessEntityContact_ContactType_ContactTypeID]
	FOREIGN KEY ([ContactTypeID]) REFERENCES [Person].[ContactType] ([ContactTypeID])
ALTER TABLE [Person].[BusinessEntityContact]
	CHECK CONSTRAINT [FK_BusinessEntityContact_ContactType_ContactTypeID]

GO


Print 'Create Foreign Key FK_BusinessEntityContact_Person_PersonID on [Person].[BusinessEntityContact]'
GO
ALTER TABLE [Person].[BusinessEntityContact]
	WITH CHECK
	ADD CONSTRAINT [FK_BusinessEntityContact_Person_PersonID]
	FOREIGN KEY ([PersonID]) REFERENCES [Person].[Person] ([BusinessEntityID])
ALTER TABLE [Person].[BusinessEntityContact]
	CHECK CONSTRAINT [FK_BusinessEntityContact_Person_PersonID]

GO


Print 'Create Foreign Key FK_EmailAddress_Person_BusinessEntityID on [Person].[EmailAddress]'
GO
ALTER TABLE [Person].[EmailAddress]
	WITH CHECK
	ADD CONSTRAINT [FK_EmailAddress_Person_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Person].[Person] ([BusinessEntityID])
ALTER TABLE [Person].[EmailAddress]
	CHECK CONSTRAINT [FK_EmailAddress_Person_BusinessEntityID]

GO


Print 'Create Foreign Key FK_Password_Person_BusinessEntityID on [Person].[Password]'
GO
ALTER TABLE [Person].[Password]
	WITH CHECK
	ADD CONSTRAINT [FK_Password_Person_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Person].[Person] ([BusinessEntityID])
ALTER TABLE [Person].[Password]
	CHECK CONSTRAINT [FK_Password_Person_BusinessEntityID]

GO


Print 'Create Foreign Key FK_Person_BusinessEntity_BusinessEntityID on [Person].[Person]'
GO
ALTER TABLE [Person].[Person]
	WITH CHECK
	ADD CONSTRAINT [FK_Person_BusinessEntity_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Person].[BusinessEntity] ([BusinessEntityID])
ALTER TABLE [Person].[Person]
	CHECK CONSTRAINT [FK_Person_BusinessEntity_BusinessEntityID]

GO


Print 'Add Check Constraint CK_Person_EmailPromotion to [Person].[Person]'
GO
ALTER TABLE [Person].[Person]
	ADD
	CONSTRAINT [CK_Person_EmailPromotion]
	CHECK
	([EmailPromotion]>=(0) AND [EmailPromotion]<=(2))
GO


ALTER TABLE [Person].[Person]
CHECK CONSTRAINT [CK_Person_EmailPromotion]
GO


Print 'Add Check Constraint CK_Person_PersonType to [Person].[Person]'
GO
ALTER TABLE [Person].[Person]
	ADD
	CONSTRAINT [CK_Person_PersonType]
	CHECK
	([PersonType] IS NULL OR upper([PersonType])='GC' OR upper([PersonType])='SP' OR upper([PersonType])='EM' OR upper([PersonType])='IN' OR upper([PersonType])='VC' OR upper([PersonType])='SC')
GO


ALTER TABLE [Person].[Person]
CHECK CONSTRAINT [CK_Person_PersonType]
GO


Print 'Create Foreign Key FK_PersonPhone_Person_BusinessEntityID on [Person].[PersonPhone]'
GO
ALTER TABLE [Person].[PersonPhone]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonPhone_Person_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Person].[Person] ([BusinessEntityID])
ALTER TABLE [Person].[PersonPhone]
	CHECK CONSTRAINT [FK_PersonPhone_Person_BusinessEntityID]

GO


Print 'Create Foreign Key FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID on [Person].[PersonPhone]'
GO
ALTER TABLE [Person].[PersonPhone]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID]
	FOREIGN KEY ([PhoneNumberTypeID]) REFERENCES [Person].[PhoneNumberType] ([PhoneNumberTypeID])
ALTER TABLE [Person].[PersonPhone]
	CHECK CONSTRAINT [FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID]

GO


Print 'Create Foreign Key FK_StateProvince_CountryRegion_CountryRegionCode on [Person].[StateProvince]'
GO
ALTER TABLE [Person].[StateProvince]
	WITH CHECK
	ADD CONSTRAINT [FK_StateProvince_CountryRegion_CountryRegionCode]
	FOREIGN KEY ([CountryRegionCode]) REFERENCES [Person].[CountryRegion] ([CountryRegionCode])
ALTER TABLE [Person].[StateProvince]
	CHECK CONSTRAINT [FK_StateProvince_CountryRegion_CountryRegionCode]

GO


Print 'Create Foreign Key FK_StateProvince_SalesTerritory_TerritoryID on [Person].[StateProvince]'
GO
ALTER TABLE [Person].[StateProvince]
	WITH CHECK
	ADD CONSTRAINT [FK_StateProvince_SalesTerritory_TerritoryID]
	FOREIGN KEY ([TerritoryID]) REFERENCES [Sales].[SalesTerritory] ([TerritoryID])
ALTER TABLE [Person].[StateProvince]
	CHECK CONSTRAINT [FK_StateProvince_SalesTerritory_TerritoryID]

GO


Print 'Create Foreign Key FK_BillOfMaterials_Product_ComponentID on [Production].[BillOfMaterials]'
GO
ALTER TABLE [Production].[BillOfMaterials]
	WITH CHECK
	ADD CONSTRAINT [FK_BillOfMaterials_Product_ComponentID]
	FOREIGN KEY ([ComponentID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Production].[BillOfMaterials]
	CHECK CONSTRAINT [FK_BillOfMaterials_Product_ComponentID]

GO


Print 'Create Foreign Key FK_BillOfMaterials_Product_ProductAssemblyID on [Production].[BillOfMaterials]'
GO
ALTER TABLE [Production].[BillOfMaterials]
	WITH CHECK
	ADD CONSTRAINT [FK_BillOfMaterials_Product_ProductAssemblyID]
	FOREIGN KEY ([ProductAssemblyID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Production].[BillOfMaterials]
	CHECK CONSTRAINT [FK_BillOfMaterials_Product_ProductAssemblyID]

GO


Print 'Create Foreign Key FK_BillOfMaterials_UnitMeasure_UnitMeasureCode on [Production].[BillOfMaterials]'
GO
ALTER TABLE [Production].[BillOfMaterials]
	WITH CHECK
	ADD CONSTRAINT [FK_BillOfMaterials_UnitMeasure_UnitMeasureCode]
	FOREIGN KEY ([UnitMeasureCode]) REFERENCES [Production].[UnitMeasure] ([UnitMeasureCode])
ALTER TABLE [Production].[BillOfMaterials]
	CHECK CONSTRAINT [FK_BillOfMaterials_UnitMeasure_UnitMeasureCode]

GO


Print 'Add Check Constraint CK_BillOfMaterials_BOMLevel to [Production].[BillOfMaterials]'
GO
ALTER TABLE [Production].[BillOfMaterials]
	ADD
	CONSTRAINT [CK_BillOfMaterials_BOMLevel]
	CHECK
	([ProductAssemblyID] IS NULL AND [BOMLevel]=(0) AND [PerAssemblyQty]=(1.00) OR [ProductAssemblyID] IS NOT NULL AND [BOMLevel]>=(1))
GO


ALTER TABLE [Production].[BillOfMaterials]
CHECK CONSTRAINT [CK_BillOfMaterials_BOMLevel]
GO


Print 'Add Check Constraint CK_BillOfMaterials_EndDate to [Production].[BillOfMaterials]'
GO
ALTER TABLE [Production].[BillOfMaterials]
	ADD
	CONSTRAINT [CK_BillOfMaterials_EndDate]
	CHECK
	([EndDate]>[StartDate] OR [EndDate] IS NULL)
GO


ALTER TABLE [Production].[BillOfMaterials]
CHECK CONSTRAINT [CK_BillOfMaterials_EndDate]
GO


Print 'Add Check Constraint CK_BillOfMaterials_PerAssemblyQty to [Production].[BillOfMaterials]'
GO
ALTER TABLE [Production].[BillOfMaterials]
	ADD
	CONSTRAINT [CK_BillOfMaterials_PerAssemblyQty]
	CHECK
	([PerAssemblyQty]>=(1.00))
GO


ALTER TABLE [Production].[BillOfMaterials]
CHECK CONSTRAINT [CK_BillOfMaterials_PerAssemblyQty]
GO


Print 'Add Check Constraint CK_BillOfMaterials_ProductAssemblyID to [Production].[BillOfMaterials]'
GO
ALTER TABLE [Production].[BillOfMaterials]
	ADD
	CONSTRAINT [CK_BillOfMaterials_ProductAssemblyID]
	CHECK
	([ProductAssemblyID]<>[ComponentID])
GO


ALTER TABLE [Production].[BillOfMaterials]
CHECK CONSTRAINT [CK_BillOfMaterials_ProductAssemblyID]
GO


Print 'Create Foreign Key FK_Document_Employee_Owner on [Production].[Document]'
GO
ALTER TABLE [Production].[Document]
	WITH CHECK
	ADD CONSTRAINT [FK_Document_Employee_Owner]
	FOREIGN KEY ([Owner]) REFERENCES [HumanResources].[Employee] ([BusinessEntityID])
ALTER TABLE [Production].[Document]
	CHECK CONSTRAINT [FK_Document_Employee_Owner]

GO


Print 'Add Check Constraint CK_Document_Status to [Production].[Document]'
GO
ALTER TABLE [Production].[Document]
	ADD
	CONSTRAINT [CK_Document_Status]
	CHECK
	([Status]>=(1) AND [Status]<=(3))
GO


ALTER TABLE [Production].[Document]
CHECK CONSTRAINT [CK_Document_Status]
GO


Print 'Add Check Constraint CK_Location_Availability to [Production].[Location]'
GO
ALTER TABLE [Production].[Location]
	ADD
	CONSTRAINT [CK_Location_Availability]
	CHECK
	([Availability]>=(0.00))
GO


ALTER TABLE [Production].[Location]
CHECK CONSTRAINT [CK_Location_Availability]
GO


Print 'Add Check Constraint CK_Location_CostRate to [Production].[Location]'
GO
ALTER TABLE [Production].[Location]
	ADD
	CONSTRAINT [CK_Location_CostRate]
	CHECK
	([CostRate]>=(0.00))
GO


ALTER TABLE [Production].[Location]
CHECK CONSTRAINT [CK_Location_CostRate]
GO


Print 'Create Foreign Key FK_Product_ProductModel_ProductModelID on [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	WITH CHECK
	ADD CONSTRAINT [FK_Product_ProductModel_ProductModelID]
	FOREIGN KEY ([ProductModelID]) REFERENCES [Production].[ProductModel] ([ProductModelID])
ALTER TABLE [Production].[Product]
	CHECK CONSTRAINT [FK_Product_ProductModel_ProductModelID]

GO


Print 'Create Foreign Key FK_Product_ProductSubcategory_ProductSubcategoryID on [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	WITH CHECK
	ADD CONSTRAINT [FK_Product_ProductSubcategory_ProductSubcategoryID]
	FOREIGN KEY ([ProductSubcategoryID]) REFERENCES [Production].[ProductSubcategory] ([ProductSubcategoryID])
ALTER TABLE [Production].[Product]
	CHECK CONSTRAINT [FK_Product_ProductSubcategory_ProductSubcategoryID]

GO


Print 'Create Foreign Key FK_Product_UnitMeasure_SizeUnitMeasureCode on [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	WITH CHECK
	ADD CONSTRAINT [FK_Product_UnitMeasure_SizeUnitMeasureCode]
	FOREIGN KEY ([SizeUnitMeasureCode]) REFERENCES [Production].[UnitMeasure] ([UnitMeasureCode])
ALTER TABLE [Production].[Product]
	CHECK CONSTRAINT [FK_Product_UnitMeasure_SizeUnitMeasureCode]

GO


Print 'Create Foreign Key FK_Product_UnitMeasure_WeightUnitMeasureCode on [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	WITH CHECK
	ADD CONSTRAINT [FK_Product_UnitMeasure_WeightUnitMeasureCode]
	FOREIGN KEY ([WeightUnitMeasureCode]) REFERENCES [Production].[UnitMeasure] ([UnitMeasureCode])
ALTER TABLE [Production].[Product]
	CHECK CONSTRAINT [FK_Product_UnitMeasure_WeightUnitMeasureCode]

GO


Print 'Add Check Constraint CK_Product_Class to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [CK_Product_Class]
	CHECK
	(upper([Class])='H' OR upper([Class])='M' OR upper([Class])='L' OR [Class] IS NULL)
GO


ALTER TABLE [Production].[Product]
CHECK CONSTRAINT [CK_Product_Class]
GO


Print 'Add Check Constraint CK_Product_DaysToManufacture to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [CK_Product_DaysToManufacture]
	CHECK
	([DaysToManufacture]>=(0))
GO


ALTER TABLE [Production].[Product]
CHECK CONSTRAINT [CK_Product_DaysToManufacture]
GO


Print 'Add Check Constraint CK_Product_ListPrice to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [CK_Product_ListPrice]
	CHECK
	([ListPrice]>=(0.00))
GO


ALTER TABLE [Production].[Product]
CHECK CONSTRAINT [CK_Product_ListPrice]
GO


Print 'Add Check Constraint CK_Product_ProductLine to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [CK_Product_ProductLine]
	CHECK
	(upper([ProductLine])='R' OR upper([ProductLine])='M' OR upper([ProductLine])='T' OR upper([ProductLine])='S' OR [ProductLine] IS NULL)
GO


ALTER TABLE [Production].[Product]
CHECK CONSTRAINT [CK_Product_ProductLine]
GO


Print 'Add Check Constraint CK_Product_ReorderPoint to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [CK_Product_ReorderPoint]
	CHECK
	([ReorderPoint]>(0))
GO


ALTER TABLE [Production].[Product]
CHECK CONSTRAINT [CK_Product_ReorderPoint]
GO


Print 'Add Check Constraint CK_Product_SafetyStockLevel to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [CK_Product_SafetyStockLevel]
	CHECK
	([SafetyStockLevel]>(0))
GO


ALTER TABLE [Production].[Product]
CHECK CONSTRAINT [CK_Product_SafetyStockLevel]
GO


Print 'Add Check Constraint CK_Product_SellEndDate to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [CK_Product_SellEndDate]
	CHECK
	([SellEndDate]>=[SellStartDate] OR [SellEndDate] IS NULL)
GO


ALTER TABLE [Production].[Product]
CHECK CONSTRAINT [CK_Product_SellEndDate]
GO


Print 'Add Check Constraint CK_Product_StandardCost to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [CK_Product_StandardCost]
	CHECK
	([StandardCost]>=(0.00))
GO


ALTER TABLE [Production].[Product]
CHECK CONSTRAINT [CK_Product_StandardCost]
GO


Print 'Add Check Constraint CK_Product_Style to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [CK_Product_Style]
	CHECK
	(upper([Style])='U' OR upper([Style])='M' OR upper([Style])='W' OR [Style] IS NULL)
GO


ALTER TABLE [Production].[Product]
CHECK CONSTRAINT [CK_Product_Style]
GO


Print 'Add Check Constraint CK_Product_Weight to [Production].[Product]'
GO
ALTER TABLE [Production].[Product]
	ADD
	CONSTRAINT [CK_Product_Weight]
	CHECK
	([Weight]>(0.00))
GO


ALTER TABLE [Production].[Product]
CHECK CONSTRAINT [CK_Product_Weight]
GO


Print 'Create Foreign Key FK_ProductCostHistory_Product_ProductID on [Production].[ProductCostHistory]'
GO
ALTER TABLE [Production].[ProductCostHistory]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductCostHistory_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Production].[ProductCostHistory]
	CHECK CONSTRAINT [FK_ProductCostHistory_Product_ProductID]

GO


Print 'Add Check Constraint CK_ProductCostHistory_EndDate to [Production].[ProductCostHistory]'
GO
ALTER TABLE [Production].[ProductCostHistory]
	ADD
	CONSTRAINT [CK_ProductCostHistory_EndDate]
	CHECK
	([EndDate]>=[StartDate] OR [EndDate] IS NULL)
GO


ALTER TABLE [Production].[ProductCostHistory]
CHECK CONSTRAINT [CK_ProductCostHistory_EndDate]
GO


Print 'Add Check Constraint CK_ProductCostHistory_StandardCost to [Production].[ProductCostHistory]'
GO
ALTER TABLE [Production].[ProductCostHistory]
	ADD
	CONSTRAINT [CK_ProductCostHistory_StandardCost]
	CHECK
	([StandardCost]>=(0.00))
GO


ALTER TABLE [Production].[ProductCostHistory]
CHECK CONSTRAINT [CK_ProductCostHistory_StandardCost]
GO


Print 'Create Foreign Key FK_ProductDocument_Document_DocumentNode on [Production].[ProductDocument]'
GO
ALTER TABLE [Production].[ProductDocument]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductDocument_Document_DocumentNode]
	FOREIGN KEY ([DocumentNode]) REFERENCES [Production].[Document] ([DocumentNode])
ALTER TABLE [Production].[ProductDocument]
	CHECK CONSTRAINT [FK_ProductDocument_Document_DocumentNode]

GO


Print 'Create Foreign Key FK_ProductDocument_Product_ProductID on [Production].[ProductDocument]'
GO
ALTER TABLE [Production].[ProductDocument]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductDocument_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Production].[ProductDocument]
	CHECK CONSTRAINT [FK_ProductDocument_Product_ProductID]

GO


Print 'Create Foreign Key FK_ProductInventory_Location_LocationID on [Production].[ProductInventory]'
GO
ALTER TABLE [Production].[ProductInventory]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductInventory_Location_LocationID]
	FOREIGN KEY ([LocationID]) REFERENCES [Production].[Location] ([LocationID])
ALTER TABLE [Production].[ProductInventory]
	CHECK CONSTRAINT [FK_ProductInventory_Location_LocationID]

GO


Print 'Create Foreign Key FK_ProductInventory_Product_ProductID on [Production].[ProductInventory]'
GO
ALTER TABLE [Production].[ProductInventory]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductInventory_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Production].[ProductInventory]
	CHECK CONSTRAINT [FK_ProductInventory_Product_ProductID]

GO


Print 'Add Check Constraint CK_ProductInventory_Bin to [Production].[ProductInventory]'
GO
ALTER TABLE [Production].[ProductInventory]
	ADD
	CONSTRAINT [CK_ProductInventory_Bin]
	CHECK
	([Bin]>=(0) AND [Bin]<=(100))
GO


ALTER TABLE [Production].[ProductInventory]
CHECK CONSTRAINT [CK_ProductInventory_Bin]
GO


Print 'Add Check Constraint CK_ProductInventory_Shelf to [Production].[ProductInventory]'
GO
ALTER TABLE [Production].[ProductInventory]
	ADD
	CONSTRAINT [CK_ProductInventory_Shelf]
	CHECK
	([Shelf] like '[A-Za-z]' OR [Shelf]='N/A')
GO


ALTER TABLE [Production].[ProductInventory]
CHECK CONSTRAINT [CK_ProductInventory_Shelf]
GO


Print 'Create Foreign Key FK_ProductListPriceHistory_Product_ProductID on [Production].[ProductListPriceHistory]'
GO
ALTER TABLE [Production].[ProductListPriceHistory]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductListPriceHistory_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Production].[ProductListPriceHistory]
	CHECK CONSTRAINT [FK_ProductListPriceHistory_Product_ProductID]

GO


Print 'Add Check Constraint CK_ProductListPriceHistory_EndDate to [Production].[ProductListPriceHistory]'
GO
ALTER TABLE [Production].[ProductListPriceHistory]
	ADD
	CONSTRAINT [CK_ProductListPriceHistory_EndDate]
	CHECK
	([EndDate]>=[StartDate] OR [EndDate] IS NULL)
GO


ALTER TABLE [Production].[ProductListPriceHistory]
CHECK CONSTRAINT [CK_ProductListPriceHistory_EndDate]
GO


Print 'Add Check Constraint CK_ProductListPriceHistory_ListPrice to [Production].[ProductListPriceHistory]'
GO
ALTER TABLE [Production].[ProductListPriceHistory]
	ADD
	CONSTRAINT [CK_ProductListPriceHistory_ListPrice]
	CHECK
	([ListPrice]>(0.00))
GO


ALTER TABLE [Production].[ProductListPriceHistory]
CHECK CONSTRAINT [CK_ProductListPriceHistory_ListPrice]
GO


Print 'Create Foreign Key FK_ProductModelIllustration_Illustration_IllustrationID on [Production].[ProductModelIllustration]'
GO
ALTER TABLE [Production].[ProductModelIllustration]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelIllustration_Illustration_IllustrationID]
	FOREIGN KEY ([IllustrationID]) REFERENCES [Production].[Illustration] ([IllustrationID])
ALTER TABLE [Production].[ProductModelIllustration]
	CHECK CONSTRAINT [FK_ProductModelIllustration_Illustration_IllustrationID]

GO


Print 'Create Foreign Key FK_ProductModelIllustration_ProductModel_ProductModelID on [Production].[ProductModelIllustration]'
GO
ALTER TABLE [Production].[ProductModelIllustration]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelIllustration_ProductModel_ProductModelID]
	FOREIGN KEY ([ProductModelID]) REFERENCES [Production].[ProductModel] ([ProductModelID])
ALTER TABLE [Production].[ProductModelIllustration]
	CHECK CONSTRAINT [FK_ProductModelIllustration_ProductModel_ProductModelID]

GO


Print 'Create Foreign Key FK_ProductModelProductDescriptionCulture_Culture_CultureID on [Production].[ProductModelProductDescriptionCulture]'
GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID]
	FOREIGN KEY ([CultureID]) REFERENCES [Production].[Culture] ([CultureID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_Culture_CultureID]

GO


Print 'Create Foreign Key FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID on [Production].[ProductModelProductDescriptionCulture]'
GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID]
	FOREIGN KEY ([ProductDescriptionID]) REFERENCES [Production].[ProductDescription] ([ProductDescriptionID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID]

GO


Print 'Create Foreign Key FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID on [Production].[ProductModelProductDescriptionCulture]'
GO
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID]
	FOREIGN KEY ([ProductModelID]) REFERENCES [Production].[ProductModel] ([ProductModelID])
ALTER TABLE [Production].[ProductModelProductDescriptionCulture]
	CHECK CONSTRAINT [FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID]

GO


Print 'Create Foreign Key FK_ProductProductPhoto_Product_ProductID on [Production].[ProductProductPhoto]'
GO
ALTER TABLE [Production].[ProductProductPhoto]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductProductPhoto_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Production].[ProductProductPhoto]
	CHECK CONSTRAINT [FK_ProductProductPhoto_Product_ProductID]

GO


Print 'Create Foreign Key FK_ProductProductPhoto_ProductPhoto_ProductPhotoID on [Production].[ProductProductPhoto]'
GO
ALTER TABLE [Production].[ProductProductPhoto]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductProductPhoto_ProductPhoto_ProductPhotoID]
	FOREIGN KEY ([ProductPhotoID]) REFERENCES [Production].[ProductPhoto] ([ProductPhotoID])
ALTER TABLE [Production].[ProductProductPhoto]
	CHECK CONSTRAINT [FK_ProductProductPhoto_ProductPhoto_ProductPhotoID]

GO


Print 'Create Foreign Key FK_ProductReview_Product_ProductID on [Production].[ProductReview]'
GO
ALTER TABLE [Production].[ProductReview]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductReview_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Production].[ProductReview]
	CHECK CONSTRAINT [FK_ProductReview_Product_ProductID]

GO


Print 'Add Check Constraint CK_ProductReview_Rating to [Production].[ProductReview]'
GO
ALTER TABLE [Production].[ProductReview]
	ADD
	CONSTRAINT [CK_ProductReview_Rating]
	CHECK
	([Rating]>=(1) AND [Rating]<=(5))
GO


ALTER TABLE [Production].[ProductReview]
CHECK CONSTRAINT [CK_ProductReview_Rating]
GO


Print 'Create Foreign Key FK_ProductSubcategory_ProductCategory_ProductCategoryID on [Production].[ProductSubcategory]'
GO
ALTER TABLE [Production].[ProductSubcategory]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductSubcategory_ProductCategory_ProductCategoryID]
	FOREIGN KEY ([ProductCategoryID]) REFERENCES [Production].[ProductCategory] ([ProductCategoryID])
ALTER TABLE [Production].[ProductSubcategory]
	CHECK CONSTRAINT [FK_ProductSubcategory_ProductCategory_ProductCategoryID]

GO


Print 'Create Foreign Key FK_TransactionHistory_Product_ProductID on [Production].[TransactionHistory]'
GO
ALTER TABLE [Production].[TransactionHistory]
	WITH CHECK
	ADD CONSTRAINT [FK_TransactionHistory_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Production].[TransactionHistory]
	CHECK CONSTRAINT [FK_TransactionHistory_Product_ProductID]

GO


Print 'Add Check Constraint CK_TransactionHistory_TransactionType to [Production].[TransactionHistory]'
GO
ALTER TABLE [Production].[TransactionHistory]
	ADD
	CONSTRAINT [CK_TransactionHistory_TransactionType]
	CHECK
	(upper([TransactionType])='P' OR upper([TransactionType])='S' OR upper([TransactionType])='W')
GO


ALTER TABLE [Production].[TransactionHistory]
CHECK CONSTRAINT [CK_TransactionHistory_TransactionType]
GO


Print 'Add Check Constraint CK_TransactionHistoryArchive_TransactionType to [Production].[TransactionHistoryArchive]'
GO
ALTER TABLE [Production].[TransactionHistoryArchive]
	ADD
	CONSTRAINT [CK_TransactionHistoryArchive_TransactionType]
	CHECK
	(upper([TransactionType])='P' OR upper([TransactionType])='S' OR upper([TransactionType])='W')
GO


ALTER TABLE [Production].[TransactionHistoryArchive]
CHECK CONSTRAINT [CK_TransactionHistoryArchive_TransactionType]
GO


Print 'Create Foreign Key FK_WorkOrder_Product_ProductID on [Production].[WorkOrder]'
GO
ALTER TABLE [Production].[WorkOrder]
	WITH CHECK
	ADD CONSTRAINT [FK_WorkOrder_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Production].[WorkOrder]
	CHECK CONSTRAINT [FK_WorkOrder_Product_ProductID]

GO


Print 'Create Foreign Key FK_WorkOrder_ScrapReason_ScrapReasonID on [Production].[WorkOrder]'
GO
ALTER TABLE [Production].[WorkOrder]
	WITH CHECK
	ADD CONSTRAINT [FK_WorkOrder_ScrapReason_ScrapReasonID]
	FOREIGN KEY ([ScrapReasonID]) REFERENCES [Production].[ScrapReason] ([ScrapReasonID])
ALTER TABLE [Production].[WorkOrder]
	CHECK CONSTRAINT [FK_WorkOrder_ScrapReason_ScrapReasonID]

GO


Print 'Add Check Constraint CK_WorkOrder_EndDate to [Production].[WorkOrder]'
GO
ALTER TABLE [Production].[WorkOrder]
	ADD
	CONSTRAINT [CK_WorkOrder_EndDate]
	CHECK
	([EndDate]>=[StartDate] OR [EndDate] IS NULL)
GO


ALTER TABLE [Production].[WorkOrder]
CHECK CONSTRAINT [CK_WorkOrder_EndDate]
GO


Print 'Add Check Constraint CK_WorkOrder_OrderQty to [Production].[WorkOrder]'
GO
ALTER TABLE [Production].[WorkOrder]
	ADD
	CONSTRAINT [CK_WorkOrder_OrderQty]
	CHECK
	([OrderQty]>(0))
GO


ALTER TABLE [Production].[WorkOrder]
CHECK CONSTRAINT [CK_WorkOrder_OrderQty]
GO


Print 'Add Check Constraint CK_WorkOrder_ScrappedQty to [Production].[WorkOrder]'
GO
ALTER TABLE [Production].[WorkOrder]
	ADD
	CONSTRAINT [CK_WorkOrder_ScrappedQty]
	CHECK
	([ScrappedQty]>=(0))
GO


ALTER TABLE [Production].[WorkOrder]
CHECK CONSTRAINT [CK_WorkOrder_ScrappedQty]
GO


Print 'Create Foreign Key FK_WorkOrderRouting_Location_LocationID on [Production].[WorkOrderRouting]'
GO
ALTER TABLE [Production].[WorkOrderRouting]
	WITH CHECK
	ADD CONSTRAINT [FK_WorkOrderRouting_Location_LocationID]
	FOREIGN KEY ([LocationID]) REFERENCES [Production].[Location] ([LocationID])
ALTER TABLE [Production].[WorkOrderRouting]
	CHECK CONSTRAINT [FK_WorkOrderRouting_Location_LocationID]

GO


Print 'Create Foreign Key FK_WorkOrderRouting_WorkOrder_WorkOrderID on [Production].[WorkOrderRouting]'
GO
ALTER TABLE [Production].[WorkOrderRouting]
	WITH CHECK
	ADD CONSTRAINT [FK_WorkOrderRouting_WorkOrder_WorkOrderID]
	FOREIGN KEY ([WorkOrderID]) REFERENCES [Production].[WorkOrder] ([WorkOrderID])
ALTER TABLE [Production].[WorkOrderRouting]
	CHECK CONSTRAINT [FK_WorkOrderRouting_WorkOrder_WorkOrderID]

GO


Print 'Add Check Constraint CK_WorkOrderRouting_ActualCost to [Production].[WorkOrderRouting]'
GO
ALTER TABLE [Production].[WorkOrderRouting]
	ADD
	CONSTRAINT [CK_WorkOrderRouting_ActualCost]
	CHECK
	([ActualCost]>(0.00))
GO


ALTER TABLE [Production].[WorkOrderRouting]
CHECK CONSTRAINT [CK_WorkOrderRouting_ActualCost]
GO


Print 'Add Check Constraint CK_WorkOrderRouting_ActualEndDate to [Production].[WorkOrderRouting]'
GO
ALTER TABLE [Production].[WorkOrderRouting]
	ADD
	CONSTRAINT [CK_WorkOrderRouting_ActualEndDate]
	CHECK
	([ActualEndDate]>=[ActualStartDate] OR [ActualEndDate] IS NULL OR [ActualStartDate] IS NULL)
GO


ALTER TABLE [Production].[WorkOrderRouting]
CHECK CONSTRAINT [CK_WorkOrderRouting_ActualEndDate]
GO


Print 'Add Check Constraint CK_WorkOrderRouting_ActualResourceHrs to [Production].[WorkOrderRouting]'
GO
ALTER TABLE [Production].[WorkOrderRouting]
	ADD
	CONSTRAINT [CK_WorkOrderRouting_ActualResourceHrs]
	CHECK
	([ActualResourceHrs]>=(0.0000))
GO


ALTER TABLE [Production].[WorkOrderRouting]
CHECK CONSTRAINT [CK_WorkOrderRouting_ActualResourceHrs]
GO


Print 'Add Check Constraint CK_WorkOrderRouting_PlannedCost to [Production].[WorkOrderRouting]'
GO
ALTER TABLE [Production].[WorkOrderRouting]
	ADD
	CONSTRAINT [CK_WorkOrderRouting_PlannedCost]
	CHECK
	([PlannedCost]>(0.00))
GO


ALTER TABLE [Production].[WorkOrderRouting]
CHECK CONSTRAINT [CK_WorkOrderRouting_PlannedCost]
GO


Print 'Add Check Constraint CK_WorkOrderRouting_ScheduledEndDate to [Production].[WorkOrderRouting]'
GO
ALTER TABLE [Production].[WorkOrderRouting]
	ADD
	CONSTRAINT [CK_WorkOrderRouting_ScheduledEndDate]
	CHECK
	([ScheduledEndDate]>=[ScheduledStartDate])
GO


ALTER TABLE [Production].[WorkOrderRouting]
CHECK CONSTRAINT [CK_WorkOrderRouting_ScheduledEndDate]
GO


Print 'Create Foreign Key FK_ProductVendor_Product_ProductID on [Purchasing].[ProductVendor]'
GO
ALTER TABLE [Purchasing].[ProductVendor]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductVendor_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Purchasing].[ProductVendor]
	CHECK CONSTRAINT [FK_ProductVendor_Product_ProductID]

GO


Print 'Create Foreign Key FK_ProductVendor_UnitMeasure_UnitMeasureCode on [Purchasing].[ProductVendor]'
GO
ALTER TABLE [Purchasing].[ProductVendor]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductVendor_UnitMeasure_UnitMeasureCode]
	FOREIGN KEY ([UnitMeasureCode]) REFERENCES [Production].[UnitMeasure] ([UnitMeasureCode])
ALTER TABLE [Purchasing].[ProductVendor]
	CHECK CONSTRAINT [FK_ProductVendor_UnitMeasure_UnitMeasureCode]

GO


Print 'Create Foreign Key FK_ProductVendor_Vendor_BusinessEntityID on [Purchasing].[ProductVendor]'
GO
ALTER TABLE [Purchasing].[ProductVendor]
	WITH CHECK
	ADD CONSTRAINT [FK_ProductVendor_Vendor_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Purchasing].[Vendor] ([BusinessEntityID])
ALTER TABLE [Purchasing].[ProductVendor]
	CHECK CONSTRAINT [FK_ProductVendor_Vendor_BusinessEntityID]

GO


Print 'Add Check Constraint CK_ProductVendor_AverageLeadTime to [Purchasing].[ProductVendor]'
GO
ALTER TABLE [Purchasing].[ProductVendor]
	ADD
	CONSTRAINT [CK_ProductVendor_AverageLeadTime]
	CHECK
	([AverageLeadTime]>=(1))
GO


ALTER TABLE [Purchasing].[ProductVendor]
CHECK CONSTRAINT [CK_ProductVendor_AverageLeadTime]
GO


Print 'Add Check Constraint CK_ProductVendor_LastReceiptCost to [Purchasing].[ProductVendor]'
GO
ALTER TABLE [Purchasing].[ProductVendor]
	ADD
	CONSTRAINT [CK_ProductVendor_LastReceiptCost]
	CHECK
	([LastReceiptCost]>(0.00))
GO


ALTER TABLE [Purchasing].[ProductVendor]
CHECK CONSTRAINT [CK_ProductVendor_LastReceiptCost]
GO


Print 'Add Check Constraint CK_ProductVendor_MaxOrderQty to [Purchasing].[ProductVendor]'
GO
ALTER TABLE [Purchasing].[ProductVendor]
	ADD
	CONSTRAINT [CK_ProductVendor_MaxOrderQty]
	CHECK
	([MaxOrderQty]>=(1))
GO


ALTER TABLE [Purchasing].[ProductVendor]
CHECK CONSTRAINT [CK_ProductVendor_MaxOrderQty]
GO


Print 'Add Check Constraint CK_ProductVendor_MinOrderQty to [Purchasing].[ProductVendor]'
GO
ALTER TABLE [Purchasing].[ProductVendor]
	ADD
	CONSTRAINT [CK_ProductVendor_MinOrderQty]
	CHECK
	([MinOrderQty]>=(1))
GO


ALTER TABLE [Purchasing].[ProductVendor]
CHECK CONSTRAINT [CK_ProductVendor_MinOrderQty]
GO


Print 'Add Check Constraint CK_ProductVendor_OnOrderQty to [Purchasing].[ProductVendor]'
GO
ALTER TABLE [Purchasing].[ProductVendor]
	ADD
	CONSTRAINT [CK_ProductVendor_OnOrderQty]
	CHECK
	([OnOrderQty]>=(0))
GO


ALTER TABLE [Purchasing].[ProductVendor]
CHECK CONSTRAINT [CK_ProductVendor_OnOrderQty]
GO


Print 'Add Check Constraint CK_ProductVendor_StandardPrice to [Purchasing].[ProductVendor]'
GO
ALTER TABLE [Purchasing].[ProductVendor]
	ADD
	CONSTRAINT [CK_ProductVendor_StandardPrice]
	CHECK
	([StandardPrice]>(0.00))
GO


ALTER TABLE [Purchasing].[ProductVendor]
CHECK CONSTRAINT [CK_ProductVendor_StandardPrice]
GO


Print 'Create Foreign Key FK_PurchaseOrderDetail_Product_ProductID on [Purchasing].[PurchaseOrderDetail]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderDetail]
	WITH CHECK
	ADD CONSTRAINT [FK_PurchaseOrderDetail_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Purchasing].[PurchaseOrderDetail]
	CHECK CONSTRAINT [FK_PurchaseOrderDetail_Product_ProductID]

GO


Print 'Create Foreign Key FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID on [Purchasing].[PurchaseOrderDetail]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderDetail]
	WITH CHECK
	ADD CONSTRAINT [FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID]
	FOREIGN KEY ([PurchaseOrderID]) REFERENCES [Purchasing].[PurchaseOrderHeader] ([PurchaseOrderID])
ALTER TABLE [Purchasing].[PurchaseOrderDetail]
	CHECK CONSTRAINT [FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID]

GO


Print 'Add Check Constraint CK_PurchaseOrderDetail_OrderQty to [Purchasing].[PurchaseOrderDetail]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderDetail]
	ADD
	CONSTRAINT [CK_PurchaseOrderDetail_OrderQty]
	CHECK
	([OrderQty]>(0))
GO


ALTER TABLE [Purchasing].[PurchaseOrderDetail]
CHECK CONSTRAINT [CK_PurchaseOrderDetail_OrderQty]
GO


Print 'Add Check Constraint CK_PurchaseOrderDetail_ReceivedQty to [Purchasing].[PurchaseOrderDetail]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderDetail]
	ADD
	CONSTRAINT [CK_PurchaseOrderDetail_ReceivedQty]
	CHECK
	([ReceivedQty]>=(0.00))
GO


ALTER TABLE [Purchasing].[PurchaseOrderDetail]
CHECK CONSTRAINT [CK_PurchaseOrderDetail_ReceivedQty]
GO


Print 'Add Check Constraint CK_PurchaseOrderDetail_RejectedQty to [Purchasing].[PurchaseOrderDetail]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderDetail]
	ADD
	CONSTRAINT [CK_PurchaseOrderDetail_RejectedQty]
	CHECK
	([RejectedQty]>=(0.00))
GO


ALTER TABLE [Purchasing].[PurchaseOrderDetail]
CHECK CONSTRAINT [CK_PurchaseOrderDetail_RejectedQty]
GO


Print 'Add Check Constraint CK_PurchaseOrderDetail_UnitPrice to [Purchasing].[PurchaseOrderDetail]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderDetail]
	ADD
	CONSTRAINT [CK_PurchaseOrderDetail_UnitPrice]
	CHECK
	([UnitPrice]>=(0.00))
GO


ALTER TABLE [Purchasing].[PurchaseOrderDetail]
CHECK CONSTRAINT [CK_PurchaseOrderDetail_UnitPrice]
GO


Print 'Create Foreign Key FK_PurchaseOrderHeader_Employee_EmployeeID on [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_PurchaseOrderHeader_Employee_EmployeeID]
	FOREIGN KEY ([EmployeeID]) REFERENCES [HumanResources].[Employee] ([BusinessEntityID])
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	CHECK CONSTRAINT [FK_PurchaseOrderHeader_Employee_EmployeeID]

GO


Print 'Create Foreign Key FK_PurchaseOrderHeader_ShipMethod_ShipMethodID on [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_PurchaseOrderHeader_ShipMethod_ShipMethodID]
	FOREIGN KEY ([ShipMethodID]) REFERENCES [Purchasing].[ShipMethod] ([ShipMethodID])
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	CHECK CONSTRAINT [FK_PurchaseOrderHeader_ShipMethod_ShipMethodID]

GO


Print 'Create Foreign Key FK_PurchaseOrderHeader_Vendor_VendorID on [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_PurchaseOrderHeader_Vendor_VendorID]
	FOREIGN KEY ([VendorID]) REFERENCES [Purchasing].[Vendor] ([BusinessEntityID])
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	CHECK CONSTRAINT [FK_PurchaseOrderHeader_Vendor_VendorID]

GO


Print 'Add Check Constraint CK_PurchaseOrderHeader_Freight to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [CK_PurchaseOrderHeader_Freight]
	CHECK
	([Freight]>=(0.00))
GO


ALTER TABLE [Purchasing].[PurchaseOrderHeader]
CHECK CONSTRAINT [CK_PurchaseOrderHeader_Freight]
GO


Print 'Add Check Constraint CK_PurchaseOrderHeader_ShipDate to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [CK_PurchaseOrderHeader_ShipDate]
	CHECK
	([ShipDate]>=[OrderDate] OR [ShipDate] IS NULL)
GO


ALTER TABLE [Purchasing].[PurchaseOrderHeader]
CHECK CONSTRAINT [CK_PurchaseOrderHeader_ShipDate]
GO


Print 'Add Check Constraint CK_PurchaseOrderHeader_Status to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [CK_PurchaseOrderHeader_Status]
	CHECK
	([Status]>=(1) AND [Status]<=(4))
GO


ALTER TABLE [Purchasing].[PurchaseOrderHeader]
CHECK CONSTRAINT [CK_PurchaseOrderHeader_Status]
GO


Print 'Add Check Constraint CK_PurchaseOrderHeader_SubTotal to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [CK_PurchaseOrderHeader_SubTotal]
	CHECK
	([SubTotal]>=(0.00))
GO


ALTER TABLE [Purchasing].[PurchaseOrderHeader]
CHECK CONSTRAINT [CK_PurchaseOrderHeader_SubTotal]
GO


Print 'Add Check Constraint CK_PurchaseOrderHeader_TaxAmt to [Purchasing].[PurchaseOrderHeader]'
GO
ALTER TABLE [Purchasing].[PurchaseOrderHeader]
	ADD
	CONSTRAINT [CK_PurchaseOrderHeader_TaxAmt]
	CHECK
	([TaxAmt]>=(0.00))
GO


ALTER TABLE [Purchasing].[PurchaseOrderHeader]
CHECK CONSTRAINT [CK_PurchaseOrderHeader_TaxAmt]
GO


Print 'Add Check Constraint CK_ShipMethod_ShipBase to [Purchasing].[ShipMethod]'
GO
ALTER TABLE [Purchasing].[ShipMethod]
	ADD
	CONSTRAINT [CK_ShipMethod_ShipBase]
	CHECK
	([ShipBase]>(0.00))
GO


ALTER TABLE [Purchasing].[ShipMethod]
CHECK CONSTRAINT [CK_ShipMethod_ShipBase]
GO


Print 'Add Check Constraint CK_ShipMethod_ShipRate to [Purchasing].[ShipMethod]'
GO
ALTER TABLE [Purchasing].[ShipMethod]
	ADD
	CONSTRAINT [CK_ShipMethod_ShipRate]
	CHECK
	([ShipRate]>(0.00))
GO


ALTER TABLE [Purchasing].[ShipMethod]
CHECK CONSTRAINT [CK_ShipMethod_ShipRate]
GO


Print 'Create Foreign Key FK_Vendor_BusinessEntity_BusinessEntityID on [Purchasing].[Vendor]'
GO
ALTER TABLE [Purchasing].[Vendor]
	WITH CHECK
	ADD CONSTRAINT [FK_Vendor_BusinessEntity_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Person].[BusinessEntity] ([BusinessEntityID])
ALTER TABLE [Purchasing].[Vendor]
	CHECK CONSTRAINT [FK_Vendor_BusinessEntity_BusinessEntityID]

GO


Print 'Add Check Constraint CK_Vendor_CreditRating to [Purchasing].[Vendor]'
GO
ALTER TABLE [Purchasing].[Vendor]
	ADD
	CONSTRAINT [CK_Vendor_CreditRating]
	CHECK
	([CreditRating]>=(1) AND [CreditRating]<=(5))
GO


ALTER TABLE [Purchasing].[Vendor]
CHECK CONSTRAINT [CK_Vendor_CreditRating]
GO


Print 'Create Foreign Key FK_CountryRegionCurrency_CountryRegion_CountryRegionCode on [Sales].[CountryRegionCurrency]'
GO
ALTER TABLE [Sales].[CountryRegionCurrency]
	WITH CHECK
	ADD CONSTRAINT [FK_CountryRegionCurrency_CountryRegion_CountryRegionCode]
	FOREIGN KEY ([CountryRegionCode]) REFERENCES [Person].[CountryRegion] ([CountryRegionCode])
ALTER TABLE [Sales].[CountryRegionCurrency]
	CHECK CONSTRAINT [FK_CountryRegionCurrency_CountryRegion_CountryRegionCode]

GO


Print 'Create Foreign Key FK_CountryRegionCurrency_Currency_CurrencyCode on [Sales].[CountryRegionCurrency]'
GO
ALTER TABLE [Sales].[CountryRegionCurrency]
	WITH CHECK
	ADD CONSTRAINT [FK_CountryRegionCurrency_Currency_CurrencyCode]
	FOREIGN KEY ([CurrencyCode]) REFERENCES [Sales].[Currency] ([CurrencyCode])
ALTER TABLE [Sales].[CountryRegionCurrency]
	CHECK CONSTRAINT [FK_CountryRegionCurrency_Currency_CurrencyCode]

GO


Print 'Create Foreign Key FK_CurrencyRate_Currency_FromCurrencyCode on [Sales].[CurrencyRate]'
GO
ALTER TABLE [Sales].[CurrencyRate]
	WITH CHECK
	ADD CONSTRAINT [FK_CurrencyRate_Currency_FromCurrencyCode]
	FOREIGN KEY ([FromCurrencyCode]) REFERENCES [Sales].[Currency] ([CurrencyCode])
ALTER TABLE [Sales].[CurrencyRate]
	CHECK CONSTRAINT [FK_CurrencyRate_Currency_FromCurrencyCode]

GO


Print 'Create Foreign Key FK_CurrencyRate_Currency_ToCurrencyCode on [Sales].[CurrencyRate]'
GO
ALTER TABLE [Sales].[CurrencyRate]
	WITH CHECK
	ADD CONSTRAINT [FK_CurrencyRate_Currency_ToCurrencyCode]
	FOREIGN KEY ([ToCurrencyCode]) REFERENCES [Sales].[Currency] ([CurrencyCode])
ALTER TABLE [Sales].[CurrencyRate]
	CHECK CONSTRAINT [FK_CurrencyRate_Currency_ToCurrencyCode]

GO


Print 'Create Foreign Key FK_Customer_Person_PersonID on [Sales].[Customer]'
GO
ALTER TABLE [Sales].[Customer]
	WITH CHECK
	ADD CONSTRAINT [FK_Customer_Person_PersonID]
	FOREIGN KEY ([PersonID]) REFERENCES [Person].[Person] ([BusinessEntityID])
ALTER TABLE [Sales].[Customer]
	CHECK CONSTRAINT [FK_Customer_Person_PersonID]

GO


Print 'Create Foreign Key FK_Customer_SalesTerritory_TerritoryID on [Sales].[Customer]'
GO
ALTER TABLE [Sales].[Customer]
	WITH CHECK
	ADD CONSTRAINT [FK_Customer_SalesTerritory_TerritoryID]
	FOREIGN KEY ([TerritoryID]) REFERENCES [Sales].[SalesTerritory] ([TerritoryID])
ALTER TABLE [Sales].[Customer]
	CHECK CONSTRAINT [FK_Customer_SalesTerritory_TerritoryID]

GO


Print 'Create Foreign Key FK_Customer_Store_StoreID on [Sales].[Customer]'
GO
ALTER TABLE [Sales].[Customer]
	WITH CHECK
	ADD CONSTRAINT [FK_Customer_Store_StoreID]
	FOREIGN KEY ([StoreID]) REFERENCES [Sales].[Store] ([BusinessEntityID])
ALTER TABLE [Sales].[Customer]
	CHECK CONSTRAINT [FK_Customer_Store_StoreID]

GO


Print 'Create Foreign Key FK_PersonCreditCard_CreditCard_CreditCardID on [Sales].[PersonCreditCard]'
GO
ALTER TABLE [Sales].[PersonCreditCard]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonCreditCard_CreditCard_CreditCardID]
	FOREIGN KEY ([CreditCardID]) REFERENCES [Sales].[CreditCard] ([CreditCardID])
ALTER TABLE [Sales].[PersonCreditCard]
	CHECK CONSTRAINT [FK_PersonCreditCard_CreditCard_CreditCardID]

GO


Print 'Create Foreign Key FK_PersonCreditCard_Person_BusinessEntityID on [Sales].[PersonCreditCard]'
GO
ALTER TABLE [Sales].[PersonCreditCard]
	WITH CHECK
	ADD CONSTRAINT [FK_PersonCreditCard_Person_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Person].[Person] ([BusinessEntityID])
ALTER TABLE [Sales].[PersonCreditCard]
	CHECK CONSTRAINT [FK_PersonCreditCard_Person_BusinessEntityID]

GO


Print 'Create Foreign Key FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID on [Sales].[SalesOrderDetail]'
GO
ALTER TABLE [Sales].[SalesOrderDetail]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID]
	FOREIGN KEY ([SalesOrderID]) REFERENCES [Sales].[SalesOrderHeader] ([SalesOrderID])
	ON DELETE CASCADE
ALTER TABLE [Sales].[SalesOrderDetail]
	CHECK CONSTRAINT [FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID]

GO


Print 'Create Foreign Key FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID on [Sales].[SalesOrderDetail]'
GO
ALTER TABLE [Sales].[SalesOrderDetail]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID]
	FOREIGN KEY ([SpecialOfferID], [ProductID]) REFERENCES [Sales].[SpecialOfferProduct] ([SpecialOfferID], [ProductID])
ALTER TABLE [Sales].[SalesOrderDetail]
	CHECK CONSTRAINT [FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID]

GO


Print 'Add Check Constraint CK_SalesOrderDetail_OrderQty to [Sales].[SalesOrderDetail]'
GO
ALTER TABLE [Sales].[SalesOrderDetail]
	ADD
	CONSTRAINT [CK_SalesOrderDetail_OrderQty]
	CHECK
	([OrderQty]>(0))
GO


ALTER TABLE [Sales].[SalesOrderDetail]
CHECK CONSTRAINT [CK_SalesOrderDetail_OrderQty]
GO


Print 'Add Check Constraint CK_SalesOrderDetail_UnitPrice to [Sales].[SalesOrderDetail]'
GO
ALTER TABLE [Sales].[SalesOrderDetail]
	ADD
	CONSTRAINT [CK_SalesOrderDetail_UnitPrice]
	CHECK
	([UnitPrice]>=(0.00))
GO


ALTER TABLE [Sales].[SalesOrderDetail]
CHECK CONSTRAINT [CK_SalesOrderDetail_UnitPrice]
GO


Print 'Add Check Constraint CK_SalesOrderDetail_UnitPriceDiscount to [Sales].[SalesOrderDetail]'
GO
ALTER TABLE [Sales].[SalesOrderDetail]
	ADD
	CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount]
	CHECK
	([UnitPriceDiscount]>=(0.00))
GO


ALTER TABLE [Sales].[SalesOrderDetail]
CHECK CONSTRAINT [CK_SalesOrderDetail_UnitPriceDiscount]
GO


Print 'Create Foreign Key FK_SalesOrderHeader_Address_BillToAddressID on [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeader_Address_BillToAddressID]
	FOREIGN KEY ([BillToAddressID]) REFERENCES [Person].[Address] ([AddressID])
ALTER TABLE [Sales].[SalesOrderHeader]
	CHECK CONSTRAINT [FK_SalesOrderHeader_Address_BillToAddressID]

GO


Print 'Create Foreign Key FK_SalesOrderHeader_Address_ShipToAddressID on [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeader_Address_ShipToAddressID]
	FOREIGN KEY ([ShipToAddressID]) REFERENCES [Person].[Address] ([AddressID])
ALTER TABLE [Sales].[SalesOrderHeader]
	CHECK CONSTRAINT [FK_SalesOrderHeader_Address_ShipToAddressID]

GO


Print 'Create Foreign Key FK_SalesOrderHeader_CreditCard_CreditCardID on [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeader_CreditCard_CreditCardID]
	FOREIGN KEY ([CreditCardID]) REFERENCES [Sales].[CreditCard] ([CreditCardID])
ALTER TABLE [Sales].[SalesOrderHeader]
	CHECK CONSTRAINT [FK_SalesOrderHeader_CreditCard_CreditCardID]

GO


Print 'Create Foreign Key FK_SalesOrderHeader_CurrencyRate_CurrencyRateID on [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeader_CurrencyRate_CurrencyRateID]
	FOREIGN KEY ([CurrencyRateID]) REFERENCES [Sales].[CurrencyRate] ([CurrencyRateID])
ALTER TABLE [Sales].[SalesOrderHeader]
	CHECK CONSTRAINT [FK_SalesOrderHeader_CurrencyRate_CurrencyRateID]

GO


Print 'Create Foreign Key FK_SalesOrderHeader_Customer_CustomerID on [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID]
	FOREIGN KEY ([CustomerID]) REFERENCES [Sales].[Customer] ([CustomerID])
ALTER TABLE [Sales].[SalesOrderHeader]
	CHECK CONSTRAINT [FK_SalesOrderHeader_Customer_CustomerID]

GO


Print 'Create Foreign Key FK_SalesOrderHeader_SalesPerson_SalesPersonID on [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeader_SalesPerson_SalesPersonID]
	FOREIGN KEY ([SalesPersonID]) REFERENCES [Sales].[SalesPerson] ([BusinessEntityID])
ALTER TABLE [Sales].[SalesOrderHeader]
	CHECK CONSTRAINT [FK_SalesOrderHeader_SalesPerson_SalesPersonID]

GO


Print 'Create Foreign Key FK_SalesOrderHeader_SalesTerritory_TerritoryID on [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeader_SalesTerritory_TerritoryID]
	FOREIGN KEY ([TerritoryID]) REFERENCES [Sales].[SalesTerritory] ([TerritoryID])
ALTER TABLE [Sales].[SalesOrderHeader]
	CHECK CONSTRAINT [FK_SalesOrderHeader_SalesTerritory_TerritoryID]

GO


Print 'Create Foreign Key FK_SalesOrderHeader_ShipMethod_ShipMethodID on [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeader_ShipMethod_ShipMethodID]
	FOREIGN KEY ([ShipMethodID]) REFERENCES [Purchasing].[ShipMethod] ([ShipMethodID])
ALTER TABLE [Sales].[SalesOrderHeader]
	CHECK CONSTRAINT [FK_SalesOrderHeader_ShipMethod_ShipMethodID]

GO


Print 'Add Check Constraint CK_SalesOrderHeader_DueDate to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_DueDate]
	CHECK
	([DueDate]>=[OrderDate])
GO


ALTER TABLE [Sales].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_DueDate]
GO


Print 'Add Check Constraint CK_SalesOrderHeader_Freight to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_Freight]
	CHECK
	([Freight]>=(0.00))
GO


ALTER TABLE [Sales].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_Freight]
GO


Print 'Add Check Constraint CK_SalesOrderHeader_ShipDate to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_ShipDate]
	CHECK
	([ShipDate]>=[OrderDate] OR [ShipDate] IS NULL)
GO


ALTER TABLE [Sales].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_ShipDate]
GO


Print 'Add Check Constraint CK_SalesOrderHeader_Status to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_Status]
	CHECK
	([Status]>=(0) AND [Status]<=(8))
GO


ALTER TABLE [Sales].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_Status]
GO


Print 'Add Check Constraint CK_SalesOrderHeader_SubTotal to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_SubTotal]
	CHECK
	([SubTotal]>=(0.00))
GO


ALTER TABLE [Sales].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_SubTotal]
GO


Print 'Add Check Constraint CK_SalesOrderHeader_TaxAmt to [Sales].[SalesOrderHeader]'
GO
ALTER TABLE [Sales].[SalesOrderHeader]
	ADD
	CONSTRAINT [CK_SalesOrderHeader_TaxAmt]
	CHECK
	([TaxAmt]>=(0.00))
GO


ALTER TABLE [Sales].[SalesOrderHeader]
CHECK CONSTRAINT [CK_SalesOrderHeader_TaxAmt]
GO


Print 'Create Foreign Key FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID on [Sales].[SalesOrderHeaderSalesReason]'
GO
ALTER TABLE [Sales].[SalesOrderHeaderSalesReason]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID]
	FOREIGN KEY ([SalesOrderID]) REFERENCES [Sales].[SalesOrderHeader] ([SalesOrderID])
	ON DELETE CASCADE
ALTER TABLE [Sales].[SalesOrderHeaderSalesReason]
	CHECK CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID]

GO


Print 'Create Foreign Key FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID on [Sales].[SalesOrderHeaderSalesReason]'
GO
ALTER TABLE [Sales].[SalesOrderHeaderSalesReason]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID]
	FOREIGN KEY ([SalesReasonID]) REFERENCES [Sales].[SalesReason] ([SalesReasonID])
ALTER TABLE [Sales].[SalesOrderHeaderSalesReason]
	CHECK CONSTRAINT [FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID]

GO


Print 'Create Foreign Key FK_SalesPerson_Employee_BusinessEntityID on [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesPerson_Employee_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [HumanResources].[Employee] ([BusinessEntityID])
ALTER TABLE [Sales].[SalesPerson]
	CHECK CONSTRAINT [FK_SalesPerson_Employee_BusinessEntityID]

GO


Print 'Create Foreign Key FK_SalesPerson_SalesTerritory_TerritoryID on [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesPerson_SalesTerritory_TerritoryID]
	FOREIGN KEY ([TerritoryID]) REFERENCES [Sales].[SalesTerritory] ([TerritoryID])
ALTER TABLE [Sales].[SalesPerson]
	CHECK CONSTRAINT [FK_SalesPerson_SalesTerritory_TerritoryID]

GO


Print 'Add Check Constraint CK_SalesPerson_Bonus to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [CK_SalesPerson_Bonus]
	CHECK
	([Bonus]>=(0.00))
GO


ALTER TABLE [Sales].[SalesPerson]
CHECK CONSTRAINT [CK_SalesPerson_Bonus]
GO


Print 'Add Check Constraint CK_SalesPerson_CommissionPct to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [CK_SalesPerson_CommissionPct]
	CHECK
	([CommissionPct]>=(0.00))
GO


ALTER TABLE [Sales].[SalesPerson]
CHECK CONSTRAINT [CK_SalesPerson_CommissionPct]
GO


Print 'Add Check Constraint CK_SalesPerson_SalesLastYear to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [CK_SalesPerson_SalesLastYear]
	CHECK
	([SalesLastYear]>=(0.00))
GO


ALTER TABLE [Sales].[SalesPerson]
CHECK CONSTRAINT [CK_SalesPerson_SalesLastYear]
GO


Print 'Add Check Constraint CK_SalesPerson_SalesQuota to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [CK_SalesPerson_SalesQuota]
	CHECK
	([SalesQuota]>(0.00))
GO


ALTER TABLE [Sales].[SalesPerson]
CHECK CONSTRAINT [CK_SalesPerson_SalesQuota]
GO


Print 'Add Check Constraint CK_SalesPerson_SalesYTD to [Sales].[SalesPerson]'
GO
ALTER TABLE [Sales].[SalesPerson]
	ADD
	CONSTRAINT [CK_SalesPerson_SalesYTD]
	CHECK
	([SalesYTD]>=(0.00))
GO


ALTER TABLE [Sales].[SalesPerson]
CHECK CONSTRAINT [CK_SalesPerson_SalesYTD]
GO


Print 'Create Foreign Key FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID on [Sales].[SalesPersonQuotaHistory]'
GO
ALTER TABLE [Sales].[SalesPersonQuotaHistory]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Sales].[SalesPerson] ([BusinessEntityID])
ALTER TABLE [Sales].[SalesPersonQuotaHistory]
	CHECK CONSTRAINT [FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID]

GO


Print 'Add Check Constraint CK_SalesPersonQuotaHistory_SalesQuota to [Sales].[SalesPersonQuotaHistory]'
GO
ALTER TABLE [Sales].[SalesPersonQuotaHistory]
	ADD
	CONSTRAINT [CK_SalesPersonQuotaHistory_SalesQuota]
	CHECK
	([SalesQuota]>(0.00))
GO


ALTER TABLE [Sales].[SalesPersonQuotaHistory]
CHECK CONSTRAINT [CK_SalesPersonQuotaHistory_SalesQuota]
GO


Print 'Create Foreign Key FK_SalesTaxRate_StateProvince_StateProvinceID on [Sales].[SalesTaxRate]'
GO
ALTER TABLE [Sales].[SalesTaxRate]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesTaxRate_StateProvince_StateProvinceID]
	FOREIGN KEY ([StateProvinceID]) REFERENCES [Person].[StateProvince] ([StateProvinceID])
ALTER TABLE [Sales].[SalesTaxRate]
	CHECK CONSTRAINT [FK_SalesTaxRate_StateProvince_StateProvinceID]

GO


Print 'Add Check Constraint CK_SalesTaxRate_TaxType to [Sales].[SalesTaxRate]'
GO
ALTER TABLE [Sales].[SalesTaxRate]
	ADD
	CONSTRAINT [CK_SalesTaxRate_TaxType]
	CHECK
	([TaxType]>=(1) AND [TaxType]<=(3))
GO


ALTER TABLE [Sales].[SalesTaxRate]
CHECK CONSTRAINT [CK_SalesTaxRate_TaxType]
GO


Print 'Create Foreign Key FK_SalesTerritory_CountryRegion_CountryRegionCode on [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesTerritory_CountryRegion_CountryRegionCode]
	FOREIGN KEY ([CountryRegionCode]) REFERENCES [Person].[CountryRegion] ([CountryRegionCode])
ALTER TABLE [Sales].[SalesTerritory]
	CHECK CONSTRAINT [FK_SalesTerritory_CountryRegion_CountryRegionCode]

GO


Print 'Add Check Constraint CK_SalesTerritory_CostLastYear to [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	ADD
	CONSTRAINT [CK_SalesTerritory_CostLastYear]
	CHECK
	([CostLastYear]>=(0.00))
GO


ALTER TABLE [Sales].[SalesTerritory]
CHECK CONSTRAINT [CK_SalesTerritory_CostLastYear]
GO


Print 'Add Check Constraint CK_SalesTerritory_CostYTD to [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	ADD
	CONSTRAINT [CK_SalesTerritory_CostYTD]
	CHECK
	([CostYTD]>=(0.00))
GO


ALTER TABLE [Sales].[SalesTerritory]
CHECK CONSTRAINT [CK_SalesTerritory_CostYTD]
GO


Print 'Add Check Constraint CK_SalesTerritory_SalesLastYear to [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	ADD
	CONSTRAINT [CK_SalesTerritory_SalesLastYear]
	CHECK
	([SalesLastYear]>=(0.00))
GO


ALTER TABLE [Sales].[SalesTerritory]
CHECK CONSTRAINT [CK_SalesTerritory_SalesLastYear]
GO


Print 'Add Check Constraint CK_SalesTerritory_SalesYTD to [Sales].[SalesTerritory]'
GO
ALTER TABLE [Sales].[SalesTerritory]
	ADD
	CONSTRAINT [CK_SalesTerritory_SalesYTD]
	CHECK
	([SalesYTD]>=(0.00))
GO


ALTER TABLE [Sales].[SalesTerritory]
CHECK CONSTRAINT [CK_SalesTerritory_SalesYTD]
GO


Print 'Create Foreign Key FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID on [Sales].[SalesTerritoryHistory]'
GO
ALTER TABLE [Sales].[SalesTerritoryHistory]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Sales].[SalesPerson] ([BusinessEntityID])
ALTER TABLE [Sales].[SalesTerritoryHistory]
	CHECK CONSTRAINT [FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID]

GO


Print 'Create Foreign Key FK_SalesTerritoryHistory_SalesTerritory_TerritoryID on [Sales].[SalesTerritoryHistory]'
GO
ALTER TABLE [Sales].[SalesTerritoryHistory]
	WITH CHECK
	ADD CONSTRAINT [FK_SalesTerritoryHistory_SalesTerritory_TerritoryID]
	FOREIGN KEY ([TerritoryID]) REFERENCES [Sales].[SalesTerritory] ([TerritoryID])
ALTER TABLE [Sales].[SalesTerritoryHistory]
	CHECK CONSTRAINT [FK_SalesTerritoryHistory_SalesTerritory_TerritoryID]

GO


Print 'Add Check Constraint CK_SalesTerritoryHistory_EndDate to [Sales].[SalesTerritoryHistory]'
GO
ALTER TABLE [Sales].[SalesTerritoryHistory]
	ADD
	CONSTRAINT [CK_SalesTerritoryHistory_EndDate]
	CHECK
	([EndDate]>=[StartDate] OR [EndDate] IS NULL)
GO


ALTER TABLE [Sales].[SalesTerritoryHistory]
CHECK CONSTRAINT [CK_SalesTerritoryHistory_EndDate]
GO


Print 'Create Foreign Key FK_ShoppingCartItem_Product_ProductID on [Sales].[ShoppingCartItem]'
GO
ALTER TABLE [Sales].[ShoppingCartItem]
	WITH CHECK
	ADD CONSTRAINT [FK_ShoppingCartItem_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Sales].[ShoppingCartItem]
	CHECK CONSTRAINT [FK_ShoppingCartItem_Product_ProductID]

GO


Print 'Add Check Constraint CK_ShoppingCartItem_Quantity to [Sales].[ShoppingCartItem]'
GO
ALTER TABLE [Sales].[ShoppingCartItem]
	ADD
	CONSTRAINT [CK_ShoppingCartItem_Quantity]
	CHECK
	([Quantity]>=(1))
GO


ALTER TABLE [Sales].[ShoppingCartItem]
CHECK CONSTRAINT [CK_ShoppingCartItem_Quantity]
GO


Print 'Add Check Constraint CK_SpecialOffer_DiscountPct to [Sales].[SpecialOffer]'
GO
ALTER TABLE [Sales].[SpecialOffer]
	ADD
	CONSTRAINT [CK_SpecialOffer_DiscountPct]
	CHECK
	([DiscountPct]>=(0.00))
GO


ALTER TABLE [Sales].[SpecialOffer]
CHECK CONSTRAINT [CK_SpecialOffer_DiscountPct]
GO


Print 'Add Check Constraint CK_SpecialOffer_EndDate to [Sales].[SpecialOffer]'
GO
ALTER TABLE [Sales].[SpecialOffer]
	ADD
	CONSTRAINT [CK_SpecialOffer_EndDate]
	CHECK
	([EndDate]>=[StartDate])
GO


ALTER TABLE [Sales].[SpecialOffer]
CHECK CONSTRAINT [CK_SpecialOffer_EndDate]
GO


Print 'Add Check Constraint CK_SpecialOffer_MaxQty to [Sales].[SpecialOffer]'
GO
ALTER TABLE [Sales].[SpecialOffer]
	ADD
	CONSTRAINT [CK_SpecialOffer_MaxQty]
	CHECK
	([MaxQty]>=(0))
GO


ALTER TABLE [Sales].[SpecialOffer]
CHECK CONSTRAINT [CK_SpecialOffer_MaxQty]
GO


Print 'Add Check Constraint CK_SpecialOffer_MinQty to [Sales].[SpecialOffer]'
GO
ALTER TABLE [Sales].[SpecialOffer]
	ADD
	CONSTRAINT [CK_SpecialOffer_MinQty]
	CHECK
	([MinQty]>=(0))
GO


ALTER TABLE [Sales].[SpecialOffer]
CHECK CONSTRAINT [CK_SpecialOffer_MinQty]
GO


Print 'Create Foreign Key FK_SpecialOfferProduct_Product_ProductID on [Sales].[SpecialOfferProduct]'
GO
ALTER TABLE [Sales].[SpecialOfferProduct]
	WITH CHECK
	ADD CONSTRAINT [FK_SpecialOfferProduct_Product_ProductID]
	FOREIGN KEY ([ProductID]) REFERENCES [Production].[Product] ([ProductID])
ALTER TABLE [Sales].[SpecialOfferProduct]
	CHECK CONSTRAINT [FK_SpecialOfferProduct_Product_ProductID]

GO


Print 'Create Foreign Key FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID on [Sales].[SpecialOfferProduct]'
GO
ALTER TABLE [Sales].[SpecialOfferProduct]
	WITH CHECK
	ADD CONSTRAINT [FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID]
	FOREIGN KEY ([SpecialOfferID]) REFERENCES [Sales].[SpecialOffer] ([SpecialOfferID])
ALTER TABLE [Sales].[SpecialOfferProduct]
	CHECK CONSTRAINT [FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID]

GO


Print 'Create Foreign Key FK_Store_BusinessEntity_BusinessEntityID on [Sales].[Store]'
GO
ALTER TABLE [Sales].[Store]
	WITH CHECK
	ADD CONSTRAINT [FK_Store_BusinessEntity_BusinessEntityID]
	FOREIGN KEY ([BusinessEntityID]) REFERENCES [Person].[BusinessEntity] ([BusinessEntityID])
ALTER TABLE [Sales].[Store]
	CHECK CONSTRAINT [FK_Store_BusinessEntity_BusinessEntityID]

GO


Print 'Create Foreign Key FK_Store_SalesPerson_SalesPersonID on [Sales].[Store]'
GO
ALTER TABLE [Sales].[Store]
	WITH CHECK
	ADD CONSTRAINT [FK_Store_SalesPerson_SalesPersonID]
	FOREIGN KEY ([SalesPersonID]) REFERENCES [Sales].[SalesPerson] ([BusinessEntityID])
ALTER TABLE [Sales].[Store]
	CHECK CONSTRAINT [FK_Store_SalesPerson_SalesPersonID]

GO


Print 'Create Extended Property MS_Description on [dbo].[AWBuildVersion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Version number of the database in 9.yy.mm.dd.00 format.', 'SCHEMA', N'dbo', 'TABLE', N'AWBuildVersion', 'COLUMN', N'Database Version'
GO


Print 'Create Extended Property MS_Description on [dbo].[AWBuildVersion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'dbo', 'TABLE', N'AWBuildVersion', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [dbo].[AWBuildVersion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for AWBuildVersion records.', 'SCHEMA', N'dbo', 'TABLE', N'AWBuildVersion', 'COLUMN', N'SystemInformationID'
GO


Print 'Create Extended Property MS_Description on [dbo].[AWBuildVersion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'dbo', 'TABLE', N'AWBuildVersion', 'COLUMN', N'VersionDate'
GO


Print 'Create Extended Property MS_Description on [dbo].[AWBuildVersion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'dbo', 'TABLE', N'AWBuildVersion', 'CONSTRAINT', N'DF_AWBuildVersion_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [dbo].[AWBuildVersion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'dbo', 'TABLE', N'AWBuildVersion', 'CONSTRAINT', N'PK_AWBuildVersion_SystemInformationID'
GO


Print 'Create Extended Property MS_Description on [dbo].[AWBuildVersion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'dbo', 'TABLE', N'AWBuildVersion', 'INDEX', N'PK_AWBuildVersion_SystemInformationID'
GO


Print 'Create Extended Property MS_Description on [dbo].[AWBuildVersion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current version number of the AdventureWorks 2012 sample database. ', 'SCHEMA', N'dbo', 'TABLE', N'AWBuildVersion', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[DatabaseLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for DatabaseLog records.', 'SCHEMA', N'dbo', 'TABLE', N'DatabaseLog', 'COLUMN', N'DatabaseLogID'
GO


Print 'Create Extended Property MS_Description on [dbo].[DatabaseLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user who implemented the DDL change.', 'SCHEMA', N'dbo', 'TABLE', N'DatabaseLog', 'COLUMN', N'DatabaseUser'
GO


Print 'Create Extended Property MS_Description on [dbo].[DatabaseLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The type of DDL statement that was executed.', 'SCHEMA', N'dbo', 'TABLE', N'DatabaseLog', 'COLUMN', N'Event'
GO


Print 'Create Extended Property MS_Description on [dbo].[DatabaseLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The object that was changed by the DDL statment.', 'SCHEMA', N'dbo', 'TABLE', N'DatabaseLog', 'COLUMN', N'Object'
GO


Print 'Create Extended Property MS_Description on [dbo].[DatabaseLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time the DDL change occurred.', 'SCHEMA', N'dbo', 'TABLE', N'DatabaseLog', 'COLUMN', N'PostTime'
GO


Print 'Create Extended Property MS_Description on [dbo].[DatabaseLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The schema to which the changed object belongs.', 'SCHEMA', N'dbo', 'TABLE', N'DatabaseLog', 'COLUMN', N'Schema'
GO


Print 'Create Extended Property MS_Description on [dbo].[DatabaseLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The exact Transact-SQL statement that was executed.', 'SCHEMA', N'dbo', 'TABLE', N'DatabaseLog', 'COLUMN', N'TSQL'
GO


Print 'Create Extended Property MS_Description on [dbo].[DatabaseLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The raw XML data generated by database trigger.', 'SCHEMA', N'dbo', 'TABLE', N'DatabaseLog', 'COLUMN', N'XmlEvent'
GO


Print 'Create Extended Property MS_Description on [dbo].[DatabaseLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (nonclustered) constraint', 'SCHEMA', N'dbo', 'TABLE', N'DatabaseLog', 'CONSTRAINT', N'PK_DatabaseLog_DatabaseLogID'
GO


Print 'Create Extended Property MS_Description on [dbo].[DatabaseLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index created by a primary key constraint.', 'SCHEMA', N'dbo', 'TABLE', N'DatabaseLog', 'INDEX', N'PK_DatabaseLog_DatabaseLogID'
GO


Print 'Create Extended Property MS_Description on [dbo].[DatabaseLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Audit table tracking all DDL changes made to the AdventureWorks database. Data is captured by the database trigger ddlDatabaseTriggerLog.', 'SCHEMA', N'dbo', 'TABLE', N'DatabaseLog', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The line number at which the error occurred.', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'COLUMN', N'ErrorLine'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ErrorLog records.', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'COLUMN', N'ErrorLogID'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The message text of the error that occurred.', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'COLUMN', N'ErrorMessage'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The error number of the error that occurred.', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'COLUMN', N'ErrorNumber'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The name of the stored procedure or trigger where the error occurred.', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'COLUMN', N'ErrorProcedure'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The severity of the error that occurred.', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'COLUMN', N'ErrorSeverity'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The state number of the error that occurred.', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'COLUMN', N'ErrorState'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The date and time at which the error occurred.', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'COLUMN', N'ErrorTime'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The user who executed the batch in which the error occurred.', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'COLUMN', N'UserName'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'CONSTRAINT', N'DF_ErrorLog_ErrorTime'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'CONSTRAINT', N'PK_ErrorLog_ErrorLogID'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', 'INDEX', N'PK_ErrorLog_ErrorLogID'
GO


Print 'Create Extended Property MS_Description on [dbo].[ErrorLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Audit table tracking errors in the the AdventureWorks database that are caught by the CATCH block of a TRY...CATCH construct. Data is inserted by stored procedure dbo.uspLogError when it is executed from inside the CATCH block of a TRY...CATCH construct.', 'SCHEMA', N'dbo', 'TABLE', N'ErrorLog', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Department]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Department records.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'COLUMN', N'DepartmentID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Department]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the group to which the department belongs.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'COLUMN', N'GroupName'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Department]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Department]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the department.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Department]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'CONSTRAINT', N'DF_Department_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Department]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'CONSTRAINT', N'PK_Department_DepartmentID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Department]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'INDEX', N'AK_Department_Name'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Department]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', 'INDEX', N'PK_Department_DepartmentID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Department]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table containing the departments within the Adventure Works Cycles company.', 'SCHEMA', N'HumanResources', 'TABLE', N'Department', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date of birth.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'BirthDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Employee records.  Foreign key to BusinessEntity.BusinessEntityID.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Inactive, 1 = Active', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'CurrentFlag'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'M = Male, F = Female', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'Gender'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employee hired on this date.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'HireDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Work title such as Buyer or Sales Representative.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'JobTitle'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Network login.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'LoginID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'M = Married, S = Single', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'MaritalStatus'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique national identification number such as a social security number.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'NationalIDNumber'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The depth of the employee in the corporate hierarchy.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'OrganizationLevel'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Where the employee is located in corporate hierarchy.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'OrganizationNode'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Job classification. 0 = Hourly, not exempt from collective bargaining. 1 = Salaried, exempt from collective bargaining.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'SalariedFlag'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of available sick leave hours.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'SickLeaveHours'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of available vacation hours.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'COLUMN', N'VacationHours'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [BirthDate] >= ''1930-01-01'' AND [BirthDate] <= dateadd(year,(-18),GETDATE())', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_BirthDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Gender]=''f'' OR [Gender]=''m'' OR [Gender]=''F'' OR [Gender]=''M''', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_Gender'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [HireDate] >= ''1996-07-01'' AND [HireDate] <= dateadd(day,(1),GETDATE())', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_HireDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [MaritalStatus]=''s'' OR [MaritalStatus]=''m'' OR [MaritalStatus]=''S'' OR [MaritalStatus]=''M''', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_MaritalStatus'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SickLeaveHours] >= (0) AND [SickLeaveHours] <= (120)', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_SickLeaveHours'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [VacationHours] >= (-40) AND [VacationHours] <= (240)', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'CK_Employee_VacationHours'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_CurrentFlag'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_rowguid'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1 (TRUE)', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_SalariedFlag'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_SickLeaveHours'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'DF_Employee_VacationHours'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'FK_Employee_Person_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'CONSTRAINT', N'PK_Employee_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'AK_Employee_LoginID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'AK_Employee_NationalIDNumber'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'AK_Employee_rowguid'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'IX_Employee_OrganizationLevel_OrganizationNode'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'IX_Employee_OrganizationNode'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', 'INDEX', N'PK_Employee_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Employee]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employee information such as salary, department, and title.', 'SCHEMA', N'HumanResources', 'TABLE', N'Employee', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employee identification number. Foreign key to Employee.BusinessEntityID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Department in which the employee worked including currently. Foreign key to Department.DepartmentID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'DepartmentID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the employee left the department. NULL = Current department.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'EndDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Identifies which 8-hour shift the employee works. Foreign key to Shift.Shift.ID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'ShiftID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the employee started work in the department.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'COLUMN', N'StartDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [EndDate] >= [StartDate] OR [EndDate] IS NUL', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'CK_EmployeeDepartmentHistory_EndDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'DF_EmployeeDepartmentHistory_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Department.DepartmentID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'FK_EmployeeDepartmentHistory_Department_DepartmentID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'FK_EmployeeDepartmentHistory_Employee_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Shift.ShiftID', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'FK_EmployeeDepartmentHistory_Shift_ShiftID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'CONSTRAINT', N'PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'INDEX', N'IX_EmployeeDepartmentHistory_DepartmentID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'INDEX', N'IX_EmployeeDepartmentHistory_ShiftID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', 'INDEX', N'PK_EmployeeDepartmentHistory_BusinessEntityID_StartDate_DepartmentID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeeDepartmentHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employee department transfers.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeeDepartmentHistory', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employee identification number. Foreign key to Employee.BusinessEntityID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 = Salary received monthly, 2 = Salary received biweekly', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'COLUMN', N'PayFrequency'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Salary hourly rate.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'COLUMN', N'Rate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the change in pay is effective', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'COLUMN', N'RateChangeDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [PayFrequency]=(3) OR [PayFrequency]=(2) OR [PayFrequency]=(1)', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'CONSTRAINT', N'CK_EmployeePayHistory_PayFrequency'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Rate] >= (6.50) AND [Rate] <= (200.00)', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'CONSTRAINT', N'CK_EmployeePayHistory_Rate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'CONSTRAINT', N'DF_EmployeePayHistory_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'CONSTRAINT', N'FK_EmployeePayHistory_Employee_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'CONSTRAINT', N'PK_EmployeePayHistory_BusinessEntityID_RateChangeDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', 'INDEX', N'PK_EmployeePayHistory_BusinessEntityID_RateChangeDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[EmployeePayHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employee pay history.', 'SCHEMA', N'HumanResources', 'TABLE', N'EmployeePayHistory', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [HumanResources].[JobCandidate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employee identification number if applicant was hired. Foreign key to Employee.BusinessEntityID.', 'SCHEMA', N'HumanResources', 'TABLE', N'JobCandidate', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[JobCandidate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for JobCandidate records.', 'SCHEMA', N'HumanResources', 'TABLE', N'JobCandidate', 'COLUMN', N'JobCandidateID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[JobCandidate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'HumanResources', 'TABLE', N'JobCandidate', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[JobCandidate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Résumé in XML format.', 'SCHEMA', N'HumanResources', 'TABLE', N'JobCandidate', 'COLUMN', N'Resume'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[JobCandidate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'HumanResources', 'TABLE', N'JobCandidate', 'CONSTRAINT', N'DF_JobCandidate_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[JobCandidate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', 'SCHEMA', N'HumanResources', 'TABLE', N'JobCandidate', 'CONSTRAINT', N'FK_JobCandidate_Employee_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[JobCandidate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'HumanResources', 'TABLE', N'JobCandidate', 'CONSTRAINT', N'PK_JobCandidate_JobCandidateID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[JobCandidate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'JobCandidate', 'INDEX', N'IX_JobCandidate_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[JobCandidate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'HumanResources', 'TABLE', N'JobCandidate', 'INDEX', N'PK_JobCandidate_JobCandidateID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[JobCandidate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Résumés submitted to Human Resources by job applicants.', 'SCHEMA', N'HumanResources', 'TABLE', N'JobCandidate', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Shift]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shift end time.', 'SCHEMA', N'HumanResources', 'TABLE', N'Shift', 'COLUMN', N'EndTime'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Shift]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'HumanResources', 'TABLE', N'Shift', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Shift]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shift description.', 'SCHEMA', N'HumanResources', 'TABLE', N'Shift', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Shift]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Shift records.', 'SCHEMA', N'HumanResources', 'TABLE', N'Shift', 'COLUMN', N'ShiftID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Shift]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shift start time.', 'SCHEMA', N'HumanResources', 'TABLE', N'Shift', 'COLUMN', N'StartTime'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Shift]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'HumanResources', 'TABLE', N'Shift', 'CONSTRAINT', N'DF_Shift_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Shift]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'HumanResources', 'TABLE', N'Shift', 'CONSTRAINT', N'PK_Shift_ShiftID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Shift]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Shift', 'INDEX', N'AK_Shift_Name'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Shift]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'HumanResources', 'TABLE', N'Shift', 'INDEX', N'AK_Shift_StartTime_EndTime'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Shift]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'HumanResources', 'TABLE', N'Shift', 'INDEX', N'PK_Shift_ShiftID'
GO


Print 'Create Extended Property MS_Description on [HumanResources].[Shift]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Work shift lookup table.', 'SCHEMA', N'HumanResources', 'TABLE', N'Shift', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Address records.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'COLUMN', N'AddressID'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First street address line.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'COLUMN', N'AddressLine1'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Second street address line.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'COLUMN', N'AddressLine2'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the city.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'COLUMN', N'City'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Postal code for the street address.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'COLUMN', N'PostalCode'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Latitude and longitude of this address.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'COLUMN', N'SpatialLocation'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique identification number for the state or province. Foreign key to StateProvince table.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'COLUMN', N'StateProvinceID'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'Address', 'CONSTRAINT', N'DF_Address_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Person', 'TABLE', N'Address', 'CONSTRAINT', N'DF_Address_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing StateProvince.StateProvinceID.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'CONSTRAINT', N'FK_Address_StateProvince_StateProvinceID'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'Address', 'CONSTRAINT', N'PK_Address_AddressID'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'INDEX', N'AK_Address_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'INDEX', N'IX_Address_AddressLine1_AddressLine2_City_StateProvinceID_PostalCode'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'INDEX', N'IX_Address_StateProvinceID'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'Address', 'INDEX', N'PK_Address_AddressID'
GO


Print 'Create Extended Property MS_Description on [Person].[Address]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Street address information for customers, employees, and vendors.', 'SCHEMA', N'Person', 'TABLE', N'Address', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[AddressType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for AddressType records.', 'SCHEMA', N'Person', 'TABLE', N'AddressType', 'COLUMN', N'AddressTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[AddressType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'AddressType', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[AddressType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Address type description. For example, Billing, Home, or Shipping.', 'SCHEMA', N'Person', 'TABLE', N'AddressType', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Person].[AddressType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Person', 'TABLE', N'AddressType', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[AddressType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'AddressType', 'CONSTRAINT', N'DF_AddressType_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[AddressType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Person', 'TABLE', N'AddressType', 'CONSTRAINT', N'DF_AddressType_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[AddressType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'AddressType', 'CONSTRAINT', N'PK_AddressType_AddressTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[AddressType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'AddressType', 'INDEX', N'AK_AddressType_Name'
GO


Print 'Create Extended Property MS_Description on [Person].[AddressType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Person', 'TABLE', N'AddressType', 'INDEX', N'AK_AddressType_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[AddressType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'AddressType', 'INDEX', N'PK_AddressType_AddressTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[AddressType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Types of addresses stored in the Address table. ', 'SCHEMA', N'Person', 'TABLE', N'AddressType', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntity]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for all customers, vendors, and employees.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntity]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntity]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntity]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'CONSTRAINT', N'DF_BusinessEntity_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntity]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'CONSTRAINT', N'DF_BusinessEntity_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntity]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'CONSTRAINT', N'PK_BusinessEntity_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntity]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'INDEX', N'AK_BusinessEntity_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntity]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'INDEX', N'PK_BusinessEntity_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntity]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Source of the ID that connects vendors, customers, and employees with address and contact information.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to Address.AddressID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'COLUMN', N'AddressID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to AddressType.AddressTypeID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'COLUMN', N'AddressTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to BusinessEntity.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'CONSTRAINT', N'DF_BusinessEntityAddress_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'CONSTRAINT', N'DF_BusinessEntityAddress_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Address.AddressID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'CONSTRAINT', N'FK_BusinessEntityAddress_Address_AddressID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing AddressType.AddressTypeID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'CONSTRAINT', N'FK_BusinessEntityAddress_AddressType_AddressTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing BusinessEntity.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'CONSTRAINT', N'FK_BusinessEntityAddress_BusinessEntity_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'CONSTRAINT', N'PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'INDEX', N'AK_BusinessEntityAddress_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'INDEX', N'IX_BusinessEntityAddress_AddressID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'INDEX', N'IX_BusinessEntityAddress_AddressTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', 'INDEX', N'PK_BusinessEntityAddress_BusinessEntityID_AddressID_AddressTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping customers, vendors, and employees to their addresses.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityAddress', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to BusinessEntity.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.  Foreign key to ContactType.ContactTypeID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'COLUMN', N'ContactTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to Person.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'COLUMN', N'PersonID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'CONSTRAINT', N'DF_BusinessEntityContact_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'CONSTRAINT', N'DF_BusinessEntityContact_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing BusinessEntity.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'CONSTRAINT', N'FK_BusinessEntityContact_BusinessEntity_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ContactType.ContactTypeID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'CONSTRAINT', N'FK_BusinessEntityContact_ContactType_ContactTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'CONSTRAINT', N'FK_BusinessEntityContact_Person_PersonID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'CONSTRAINT', N'PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'INDEX', N'AK_BusinessEntityContact_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'INDEX', N'IX_BusinessEntityContact_ContactTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'INDEX', N'IX_BusinessEntityContact_PersonID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', 'INDEX', N'PK_BusinessEntityContact_BusinessEntityID_PersonID_ContactTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[BusinessEntityContact]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping stores, vendors, and employees to people', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntityContact', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[ContactType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ContactType records.', 'SCHEMA', N'Person', 'TABLE', N'ContactType', 'COLUMN', N'ContactTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[ContactType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'ContactType', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[ContactType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contact type description.', 'SCHEMA', N'Person', 'TABLE', N'ContactType', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Person].[ContactType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'ContactType', 'CONSTRAINT', N'DF_ContactType_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[ContactType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'ContactType', 'CONSTRAINT', N'PK_ContactType_ContactTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[ContactType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'ContactType', 'INDEX', N'AK_ContactType_Name'
GO


Print 'Create Extended Property MS_Description on [Person].[ContactType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'ContactType', 'INDEX', N'PK_ContactType_ContactTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[ContactType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table containing the types of business entity contacts.', 'SCHEMA', N'Person', 'TABLE', N'ContactType', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[CountryRegion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ISO standard code for countries and regions.', 'SCHEMA', N'Person', 'TABLE', N'CountryRegion', 'COLUMN', N'CountryRegionCode'
GO


Print 'Create Extended Property MS_Description on [Person].[CountryRegion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'CountryRegion', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[CountryRegion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Country or region name.', 'SCHEMA', N'Person', 'TABLE', N'CountryRegion', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Person].[CountryRegion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'CountryRegion', 'CONSTRAINT', N'DF_CountryRegion_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[CountryRegion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'CountryRegion', 'CONSTRAINT', N'PK_CountryRegion_CountryRegionCode'
GO


Print 'Create Extended Property MS_Description on [Person].[CountryRegion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'CountryRegion', 'INDEX', N'AK_CountryRegion_Name'
GO


Print 'Create Extended Property MS_Description on [Person].[CountryRegion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'CountryRegion', 'INDEX', N'PK_CountryRegion_CountryRegionCode'
GO


Print 'Create Extended Property MS_Description on [Person].[CountryRegion]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table containing the ISO standard codes for countries and regions.', 'SCHEMA', N'Person', 'TABLE', N'CountryRegion', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Person associated with this email address.  Foreign key to Person.BusinessEntityID', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'E-mail address for the person.', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', 'COLUMN', N'EmailAddress'
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. ID of this email address.', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', 'COLUMN', N'EmailAddressID'
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', 'CONSTRAINT', N'DF_EmailAddress_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', 'CONSTRAINT', N'DF_EmailAddress_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', 'CONSTRAINT', N'FK_EmailAddress_Person_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', 'CONSTRAINT', N'PK_EmailAddress_BusinessEntityID_EmailAddressID'
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', 'INDEX', N'IX_EmailAddress_EmailAddress'
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', 'INDEX', N'PK_EmailAddress_BusinessEntityID_EmailAddressID'
GO


Print 'Create Extended Property MS_Description on [Person].[EmailAddress]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Where to send a person email.', 'SCHEMA', N'Person', 'TABLE', N'EmailAddress', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[Password]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'Password', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[Password]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Password for the e-mail account.', 'SCHEMA', N'Person', 'TABLE', N'Password', 'COLUMN', N'PasswordHash'
GO


Print 'Create Extended Property MS_Description on [Person].[Password]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Random value concatenated with the password string before the password is hashed.', 'SCHEMA', N'Person', 'TABLE', N'Password', 'COLUMN', N'PasswordSalt'
GO


Print 'Create Extended Property MS_Description on [Person].[Password]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Person', 'TABLE', N'Password', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[Password]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'Password', 'CONSTRAINT', N'DF_Password_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[Password]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Person', 'TABLE', N'Password', 'CONSTRAINT', N'DF_Password_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[Password]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'Password', 'CONSTRAINT', N'FK_Password_Person_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[Password]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'Password', 'CONSTRAINT', N'PK_Password_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[Password]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'Password', 'INDEX', N'PK_Password_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[Password]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'One way hashed authentication information', 'SCHEMA', N'Person', 'TABLE', N'Password', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Additional contact information about the person stored in xml format. ', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'AdditionalContactInfo'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Person records.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Personal information such as hobbies, and income collected from online shoppers. Used for sales analysis.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'Demographics'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Contact does not wish to receive e-mail promotions, 1 = Contact does wish to receive e-mail promotions from AdventureWorks, 2 = Contact does wish to receive e-mail promotions from AdventureWorks and selected partners. ', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'EmailPromotion'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First name of the person.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'FirstName'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last name of the person.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'LastName'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Middle name or middle initial of the person.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'MiddleName'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = The data in FirstName and LastName are stored in western style (first name, last name) order.  1 = Eastern style (last name, first name) order.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'NameStyle'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary type of person: SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'PersonType'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surname suffix. For example, Sr. or Jr.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'Suffix'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A courtesy title. For example, Mr. or Ms.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'Title'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [EmailPromotion] >= (0) AND [EmailPromotion] <= (2)', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'CK_Person_EmailPromotion'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [PersonType] is one of SC, VC, IN, EM or SP.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'CK_Person_PersonType'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'DF_Person_EmailPromotion'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'DF_Person_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'DF_Person_NameStyle'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'DF_Person_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing BusinessEntity.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'FK_Person_BusinessEntity_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'PK_Person_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'AK_Person_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'PK_Person_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary XML index.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'PXML_Person_AddContact'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary XML index.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'PXML_Person_Demographics'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Secondary XML index for path.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'XMLPATH_Person_Demographics'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Secondary XML index for property.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'XMLPROPERTY_Person_Demographics'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Secondary XML index for value.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'XMLVALUE_Person_Demographics'
GO


Print 'Create Extended Property MS_Description on [Person].[Person]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Human beings involved with AdventureWorks: employees, customer contacts, and vendor contacts.', 'SCHEMA', N'Person', 'TABLE', N'Person', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[PersonPhone]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Business entity identification number. Foreign key to Person.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'PersonPhone', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[PersonPhone]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'PersonPhone', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[PersonPhone]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Telephone number identification number.', 'SCHEMA', N'Person', 'TABLE', N'PersonPhone', 'COLUMN', N'PhoneNumber'
GO


Print 'Create Extended Property MS_Description on [Person].[PersonPhone]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Kind of phone number. Foreign key to PhoneNumberType.PhoneNumberTypeID.', 'SCHEMA', N'Person', 'TABLE', N'PersonPhone', 'COLUMN', N'PhoneNumberTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[PersonPhone]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'PersonPhone', 'CONSTRAINT', N'DF_PersonPhone_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[PersonPhone]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'PersonPhone', 'CONSTRAINT', N'FK_PersonPhone_Person_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Person].[PersonPhone]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing PhoneNumberType.PhoneNumberTypeID.', 'SCHEMA', N'Person', 'TABLE', N'PersonPhone', 'CONSTRAINT', N'FK_PersonPhone_PhoneNumberType_PhoneNumberTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[PersonPhone]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'PersonPhone', 'CONSTRAINT', N'PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[PersonPhone]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'PersonPhone', 'INDEX', N'IX_PersonPhone_PhoneNumber'
GO


Print 'Create Extended Property MS_Description on [Person].[PersonPhone]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'PersonPhone', 'INDEX', N'PK_PersonPhone_BusinessEntityID_PhoneNumber_PhoneNumberTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[PersonPhone]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Telephone number and type of a person.', 'SCHEMA', N'Person', 'TABLE', N'PersonPhone', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[PhoneNumberType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'PhoneNumberType', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[PhoneNumberType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the telephone number type', 'SCHEMA', N'Person', 'TABLE', N'PhoneNumberType', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Person].[PhoneNumberType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for telephone number type records.', 'SCHEMA', N'Person', 'TABLE', N'PhoneNumberType', 'COLUMN', N'PhoneNumberTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[PhoneNumberType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'PhoneNumberType', 'CONSTRAINT', N'DF_PhoneNumberType_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[PhoneNumberType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'PhoneNumberType', 'CONSTRAINT', N'PK_PhoneNumberType_PhoneNumberTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[PhoneNumberType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'PhoneNumberType', 'INDEX', N'PK_PhoneNumberType_PhoneNumberTypeID'
GO


Print 'Create Extended Property MS_Description on [Person].[PhoneNumberType]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Type of phone number of a person.', 'SCHEMA', N'Person', 'TABLE', N'PhoneNumberType', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ISO standard country or region code. Foreign key to CountryRegion.CountryRegionCode. ', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'COLUMN', N'CountryRegionCode'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = StateProvinceCode exists. 1 = StateProvinceCode unavailable, using CountryRegionCode.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'COLUMN', N'IsOnlyStateProvinceFlag'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State or province description.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ISO standard state or province code.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'COLUMN', N'StateProvinceCode'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for StateProvince records.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'COLUMN', N'StateProvinceID'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of the territory in which the state or province is located. Foreign key to SalesTerritory.SalesTerritoryID.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'COLUMN', N'TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1 (TRUE)', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'CONSTRAINT', N'DF_StateProvince_IsOnlyStateProvinceFlag'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'CONSTRAINT', N'DF_StateProvince_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'CONSTRAINT', N'DF_StateProvince_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing CountryRegion.CountryRegionCode.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'CONSTRAINT', N'FK_StateProvince_CountryRegion_CountryRegionCode'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesTerritory.TerritoryID.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'CONSTRAINT', N'FK_StateProvince_SalesTerritory_TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'CONSTRAINT', N'PK_StateProvince_StateProvinceID'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'INDEX', N'AK_StateProvince_Name'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'INDEX', N'AK_StateProvince_rowguid'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'INDEX', N'AK_StateProvince_StateProvinceCode_CountryRegionCode'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', 'INDEX', N'PK_StateProvince_StateProvinceID'
GO


Print 'Create Extended Property MS_Description on [Person].[StateProvince]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State and province lookup table.', 'SCHEMA', N'Person', 'TABLE', N'StateProvince', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for BillOfMaterials records.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'COLUMN', N'BillOfMaterialsID'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Indicates the depth the component is from its parent (AssemblyID).', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'COLUMN', N'BOMLevel'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Component identification number. Foreign key to Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'COLUMN', N'ComponentID'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the component stopped being used in the assembly item.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'COLUMN', N'EndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Quantity of the component needed to create the assembly.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'COLUMN', N'PerAssemblyQty'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Parent product identification number. Foreign key to Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'COLUMN', N'ProductAssemblyID'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the component started being used in the assembly item.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'COLUMN', N'StartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Standard code identifying the unit of measure for the quantity.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'COLUMN', N'UnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ProductAssemblyID] IS NULL AND [BOMLevel] = (0) AND [PerAssemblyQty] = (1) OR [ProductAssemblyID] IS NOT NULL AND [BOMLevel] >= (1)', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'CONSTRAINT', N'CK_BillOfMaterials_BOMLevel'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint EndDate] > [StartDate] OR [EndDate] IS NULL', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'CONSTRAINT', N'CK_BillOfMaterials_EndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [PerAssemblyQty] >= (1.00)', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'CONSTRAINT', N'CK_BillOfMaterials_PerAssemblyQty'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ProductAssemblyID] <> [ComponentID]', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'CONSTRAINT', N'CK_BillOfMaterials_ProductAssemblyID'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'CONSTRAINT', N'DF_BillOfMaterials_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1.0', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'CONSTRAINT', N'DF_BillOfMaterials_PerAssemblyQty'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'CONSTRAINT', N'DF_BillOfMaterials_StartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ComponentID.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'CONSTRAINT', N'FK_BillOfMaterials_Product_ComponentID'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductAssemblyID.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'CONSTRAINT', N'FK_BillOfMaterials_Product_ProductAssemblyID'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing UnitMeasure.UnitMeasureCode.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'CONSTRAINT', N'FK_BillOfMaterials_UnitMeasure_UnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'CONSTRAINT', N'PK_BillOfMaterials_BillOfMaterialsID'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'INDEX', N'AK_BillOfMaterials_ProductAssemblyID_ComponentID_StartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'INDEX', N'IX_BillOfMaterials_UnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', 'INDEX', N'PK_BillOfMaterials_BillOfMaterialsID'
GO


Print 'Create Extended Property MS_Description on [Production].[BillOfMaterials]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Items required to make bicycles and bicycle subassemblies. It identifies the heirarchical relationship between a parent product and its components.', 'SCHEMA', N'Production', 'TABLE', N'BillOfMaterials', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[Culture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Culture records.', 'SCHEMA', N'Production', 'TABLE', N'Culture', 'COLUMN', N'CultureID'
GO


Print 'Create Extended Property MS_Description on [Production].[Culture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'Culture', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Culture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Culture description.', 'SCHEMA', N'Production', 'TABLE', N'Culture', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Production].[Culture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'Culture', 'CONSTRAINT', N'DF_Culture_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Culture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'Culture', 'CONSTRAINT', N'PK_Culture_CultureID'
GO


Print 'Create Extended Property MS_Description on [Production].[Culture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'Culture', 'INDEX', N'AK_Culture_Name'
GO


Print 'Create Extended Property MS_Description on [Production].[Culture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'Culture', 'INDEX', N'PK_Culture_CultureID'
GO


Print 'Create Extended Property MS_Description on [Production].[Culture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table containing the languages in which some AdventureWorks data is stored.', 'SCHEMA', N'Production', 'TABLE', N'Culture', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Engineering change approval number.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'ChangeNumber'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Complete document.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'Document'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Depth in the document hierarchy.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'DocumentLevel'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Document records.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'DocumentNode'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Document abstract.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'DocumentSummary'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'File extension indicating the document type. For example, .doc or .txt.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'FileExtension'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'File name of the document', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'FileName'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = This is a folder, 1 = This is a document.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'FolderFlag'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employee who controls the document.  Foreign key to Employee.BusinessEntityID', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'Owner'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Revision number of the document. ', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'Revision'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Required for FileStream.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 = Pending approval, 2 = Approved, 3 = Obsolete', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'Status'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Title of the document.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'COLUMN', N'Title'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Status] BETWEEN (1) AND (3)', 'SCHEMA', N'Production', 'TABLE', N'Document', 'CONSTRAINT', N'CK_Document_Status'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'Production', 'TABLE', N'Document', 'CONSTRAINT', N'DF_Document_ChangeNumber'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'Document', 'CONSTRAINT', N'DF_Document_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Production', 'TABLE', N'Document', 'CONSTRAINT', N'DF_Document_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Employee.BusinessEntityID.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'CONSTRAINT', N'FK_Document_Employee_Owner'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'Document', 'CONSTRAINT', N'PK_Document_DocumentNode'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'INDEX', N'AK_Document_DocumentLevel_DocumentNode'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support FileStream.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'INDEX', N'AK_Document_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'INDEX', N'IX_Document_FileName_Revision'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'Document', 'INDEX', N'PK_Document_DocumentNode'
GO


Print 'Create Extended Property MS_Description on [Production].[Document]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product maintenance documents.', 'SCHEMA', N'Production', 'TABLE', N'Document', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[Illustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Illustrations used in manufacturing instructions. Stored as XML.', 'SCHEMA', N'Production', 'TABLE', N'Illustration', 'COLUMN', N'Diagram'
GO


Print 'Create Extended Property MS_Description on [Production].[Illustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Illustration records.', 'SCHEMA', N'Production', 'TABLE', N'Illustration', 'COLUMN', N'IllustrationID'
GO


Print 'Create Extended Property MS_Description on [Production].[Illustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'Illustration', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Illustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'Illustration', 'CONSTRAINT', N'DF_Illustration_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Illustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'Illustration', 'CONSTRAINT', N'PK_Illustration_IllustrationID'
GO


Print 'Create Extended Property MS_Description on [Production].[Illustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'Illustration', 'INDEX', N'PK_Illustration_IllustrationID'
GO


Print 'Create Extended Property MS_Description on [Production].[Illustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bicycle assembly diagrams.', 'SCHEMA', N'Production', 'TABLE', N'Illustration', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Work capacity (in hours) of the manufacturing location.', 'SCHEMA', N'Production', 'TABLE', N'Location', 'COLUMN', N'Availability'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Standard hourly cost of the manufacturing location.', 'SCHEMA', N'Production', 'TABLE', N'Location', 'COLUMN', N'CostRate'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Location records.', 'SCHEMA', N'Production', 'TABLE', N'Location', 'COLUMN', N'LocationID'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'Location', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Location description.', 'SCHEMA', N'Production', 'TABLE', N'Location', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Availability] >= (0.00)', 'SCHEMA', N'Production', 'TABLE', N'Location', 'CONSTRAINT', N'CK_Location_Availability'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [CostRate] >= (0.00)', 'SCHEMA', N'Production', 'TABLE', N'Location', 'CONSTRAINT', N'CK_Location_CostRate'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.00', 'SCHEMA', N'Production', 'TABLE', N'Location', 'CONSTRAINT', N'DF_Location_Availability'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Production', 'TABLE', N'Location', 'CONSTRAINT', N'DF_Location_CostRate'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'Location', 'CONSTRAINT', N'DF_Location_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'Location', 'CONSTRAINT', N'PK_Location_LocationID'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'Location', 'INDEX', N'AK_Location_Name'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'Location', 'INDEX', N'PK_Location_LocationID'
GO


Print 'Create Extended Property MS_Description on [Production].[Location]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product inventory and manufacturing locations.', 'SCHEMA', N'Production', 'TABLE', N'Location', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'H = High, M = Medium, L = Low', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'Class'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product color.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'Color'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of days required to manufacture the product.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'DaysToManufacture'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the product was discontinued.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'DiscontinuedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Product is not a salable item. 1 = Product is salable.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'FinishedGoodsFlag'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Selling price.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'ListPrice'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Product is purchased, 1 = Product is manufactured in-house.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'MakeFlag'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the product.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Product records.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'R = Road, M = Mountain, T = Touring, S = Standard', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'ProductLine'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product is a member of this product model. Foreign key to ProductModel.ProductModelID.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'ProductModelID'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique product identification number.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'ProductNumber'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product is a member of this product subcategory. Foreign key to ProductSubCategory.ProductSubCategoryID. ', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'ProductSubcategoryID'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inventory level that triggers a purchase order or work order. ', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'ReorderPoint'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Minimum inventory quantity. ', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'SafetyStockLevel'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the product was no longer available for sale.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'SellEndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the product was available for sale.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'SellStartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product size.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'Size'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unit of measure for Size column.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'SizeUnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Standard cost of the product.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'StandardCost'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'W = Womens, M = Mens, U = Universal', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'Style'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product weight.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'Weight'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unit of measure for Weight column.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'COLUMN', N'WeightUnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Class]=''h'' OR [Class]=''m'' OR [Class]=''l'' OR [Class]=''H'' OR [Class]=''M'' OR [Class]=''L'' OR [Class] IS NULL', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_Class'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [DaysToManufacture] >= (0)', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_DaysToManufacture'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ListPrice] >= (0.00)', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_ListPrice'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ProductLine]=''r'' OR [ProductLine]=''m'' OR [ProductLine]=''t'' OR [ProductLine]=''s'' OR [ProductLine]=''R'' OR [ProductLine]=''M'' OR [ProductLine]=''T'' OR [ProductLine]=''S'' OR [ProductLine] IS NULL', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_ProductLine'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ReorderPoint] > (0)', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_ReorderPoint'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SafetyStockLevel] > (0)', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_SafetyStockLevel'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SellEndDate] >= [SellStartDate] OR [SellEndDate] IS NULL', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_SellEndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SafetyStockLevel] > (0)', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_StandardCost'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Style]=''u'' OR [Style]=''m'' OR [Style]=''w'' OR [Style]=''U'' OR [Style]=''M'' OR [Style]=''W'' OR [Style] IS NULL', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_Style'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Weight] > (0.00)', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'CK_Product_Weight'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of  1', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'DF_Product_FinishedGoodsFlag'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of  1', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'DF_Product_MakeFlag'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'DF_Product_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'DF_Product_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductModel.ProductModelID.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'FK_Product_ProductModel_ProductModelID'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductSubcategory.ProductSubcategoryID.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'FK_Product_ProductSubcategory_ProductSubcategoryID'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing UnitMeasure.UnitMeasureCode.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'FK_Product_UnitMeasure_SizeUnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing UnitMeasure.UnitMeasureCode.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'FK_Product_UnitMeasure_WeightUnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'Product', 'CONSTRAINT', N'PK_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'INDEX', N'AK_Product_Name'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'INDEX', N'AK_Product_ProductNumber'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'INDEX', N'AK_Product_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'Product', 'INDEX', N'PK_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[Product]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Products sold or used in the manfacturing of sold products.', 'SCHEMA', N'Production', 'TABLE', N'Product', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductCategory', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Category description.', 'SCHEMA', N'Production', 'TABLE', N'ProductCategory', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ProductCategory records.', 'SCHEMA', N'Production', 'TABLE', N'ProductCategory', 'COLUMN', N'ProductCategoryID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Production', 'TABLE', N'ProductCategory', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductCategory', 'CONSTRAINT', N'DF_ProductCategory_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()()', 'SCHEMA', N'Production', 'TABLE', N'ProductCategory', 'CONSTRAINT', N'DF_ProductCategory_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductCategory', 'CONSTRAINT', N'PK_ProductCategory_ProductCategoryID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'ProductCategory', 'INDEX', N'AK_ProductCategory_Name'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Production', 'TABLE', N'ProductCategory', 'INDEX', N'AK_ProductCategory_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductCategory', 'INDEX', N'PK_ProductCategory_ProductCategoryID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'High-level product categorization.', 'SCHEMA', N'Production', 'TABLE', N'ProductCategory', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product cost end date.', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', 'COLUMN', N'EndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product identification number. Foreign key to Product.ProductID', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Standard cost of the product.', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', 'COLUMN', N'StandardCost'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product cost start date.', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', 'COLUMN', N'StartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [EndDate] >= [StartDate] OR [EndDate] IS NULL', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', 'CONSTRAINT', N'CK_ProductCostHistory_EndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [StandardCost] >= (0.00)', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', 'CONSTRAINT', N'CK_ProductCostHistory_StandardCost'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', 'CONSTRAINT', N'DF_ProductCostHistory_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', 'CONSTRAINT', N'FK_ProductCostHistory_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', 'CONSTRAINT', N'PK_ProductCostHistory_ProductID_StartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', 'INDEX', N'PK_ProductCostHistory_ProductID_StartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductCostHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Changes in the cost of a product over time.', 'SCHEMA', N'Production', 'TABLE', N'ProductCostHistory', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Description of the product.', 'SCHEMA', N'Production', 'TABLE', N'ProductDescription', 'COLUMN', N'Description'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductDescription', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ProductDescription records.', 'SCHEMA', N'Production', 'TABLE', N'ProductDescription', 'COLUMN', N'ProductDescriptionID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Production', 'TABLE', N'ProductDescription', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductDescription', 'CONSTRAINT', N'DF_ProductDescription_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Production', 'TABLE', N'ProductDescription', 'CONSTRAINT', N'DF_ProductDescription_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductDescription', 'CONSTRAINT', N'PK_ProductDescription_ProductDescriptionID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Production', 'TABLE', N'ProductDescription', 'INDEX', N'AK_ProductDescription_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductDescription', 'INDEX', N'PK_ProductDescription_ProductDescriptionID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDescription]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product descriptions in several languages.', 'SCHEMA', N'Production', 'TABLE', N'ProductDescription', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDocument]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Document identification number. Foreign key to Document.DocumentNode.', 'SCHEMA', N'Production', 'TABLE', N'ProductDocument', 'COLUMN', N'DocumentNode'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDocument]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductDocument', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDocument]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'ProductDocument', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDocument]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductDocument', 'CONSTRAINT', N'DF_ProductDocument_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDocument]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Document.DocumentNode.', 'SCHEMA', N'Production', 'TABLE', N'ProductDocument', 'CONSTRAINT', N'FK_ProductDocument_Document_DocumentNode'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDocument]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'ProductDocument', 'CONSTRAINT', N'FK_ProductDocument_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDocument]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductDocument', 'CONSTRAINT', N'PK_ProductDocument_ProductID_DocumentNode'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDocument]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductDocument', 'INDEX', N'PK_ProductDocument_ProductID_DocumentNode'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductDocument]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping products to related product documents.', 'SCHEMA', N'Production', 'TABLE', N'ProductDocument', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Storage container on a shelf in an inventory location.', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'COLUMN', N'Bin'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Inventory location identification number. Foreign key to Location.LocationID. ', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'COLUMN', N'LocationID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Quantity of products in the inventory location.', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'COLUMN', N'Quantity'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Storage compartment within an inventory location.', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'COLUMN', N'Shelf'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Bin] BETWEEN (0) AND (100)', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'CONSTRAINT', N'CK_ProductInventory_Bin'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Shelf] like ''[A-Za-z]'' OR [Shelf]=''N/A''', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'CONSTRAINT', N'CK_ProductInventory_Shelf'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'CONSTRAINT', N'DF_ProductInventory_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'CONSTRAINT', N'DF_ProductInventory_Quantity'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'CONSTRAINT', N'DF_ProductInventory_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Location.LocationID.', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'CONSTRAINT', N'FK_ProductInventory_Location_LocationID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'CONSTRAINT', N'FK_ProductInventory_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'CONSTRAINT', N'PK_ProductInventory_ProductID_LocationID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', 'INDEX', N'PK_ProductInventory_ProductID_LocationID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductInventory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product inventory information.', 'SCHEMA', N'Production', 'TABLE', N'ProductInventory', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'List price end date', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', 'COLUMN', N'EndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product list price.', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', 'COLUMN', N'ListPrice'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product identification number. Foreign key to Product.ProductID', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'List price start date.', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', 'COLUMN', N'StartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [EndDate] >= [StartDate] OR [EndDate] IS NULL', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', 'CONSTRAINT', N'CK_ProductListPriceHistory_EndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ListPrice] > (0.00)', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', 'CONSTRAINT', N'CK_ProductListPriceHistory_ListPrice'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', 'CONSTRAINT', N'DF_ProductListPriceHistory_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', 'CONSTRAINT', N'FK_ProductListPriceHistory_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', 'CONSTRAINT', N'PK_ProductListPriceHistory_ProductID_StartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', 'INDEX', N'PK_ProductListPriceHistory_ProductID_StartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductListPriceHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Changes in the list price of a product over time.', 'SCHEMA', N'Production', 'TABLE', N'ProductListPriceHistory', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Detailed product catalog information in xml format.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'CatalogDescription'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manufacturing instructions in xml format.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'Instructions'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product model description.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ProductModel records.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'ProductModelID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'CONSTRAINT', N'DF_ProductModel_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'CONSTRAINT', N'DF_ProductModel_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'CONSTRAINT', N'PK_ProductModel_ProductModelID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'INDEX', N'AK_ProductModel_Name'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'INDEX', N'AK_ProductModel_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'INDEX', N'PK_ProductModel_ProductModelID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary XML index.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'INDEX', N'PXML_ProductModel_CatalogDescription'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary XML index.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', 'INDEX', N'PXML_ProductModel_Instructions'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModel]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product model classification.', 'SCHEMA', N'Production', 'TABLE', N'ProductModel', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelIllustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to Illustration.IllustrationID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'COLUMN', N'IllustrationID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelIllustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelIllustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to ProductModel.ProductModelID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'COLUMN', N'ProductModelID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelIllustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'CONSTRAINT', N'DF_ProductModelIllustration_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelIllustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Illustration.IllustrationID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'CONSTRAINT', N'FK_ProductModelIllustration_Illustration_IllustrationID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelIllustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductModel.ProductModelID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'CONSTRAINT', N'FK_ProductModelIllustration_ProductModel_ProductModelID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelIllustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'CONSTRAINT', N'PK_ProductModelIllustration_ProductModelID_IllustrationID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelIllustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', 'INDEX', N'PK_ProductModelIllustration_ProductModelID_IllustrationID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelIllustration]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping product models and illustrations.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelIllustration', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelProductDescriptionCulture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Culture identification number. Foreign key to Culture.CultureID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'COLUMN', N'CultureID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelProductDescriptionCulture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelProductDescriptionCulture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to ProductDescription.ProductDescriptionID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'COLUMN', N'ProductDescriptionID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelProductDescriptionCulture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to ProductModel.ProductModelID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'COLUMN', N'ProductModelID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelProductDescriptionCulture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'DF_ProductModelProductDescriptionCulture_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelProductDescriptionCulture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Culture.CultureID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'FK_ProductModelProductDescriptionCulture_Culture_CultureID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelProductDescriptionCulture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductDescription.ProductDescriptionID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'FK_ProductModelProductDescriptionCulture_ProductDescription_ProductDescriptionID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelProductDescriptionCulture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductModel.ProductModelID.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'FK_ProductModelProductDescriptionCulture_ProductModel_ProductModelID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelProductDescriptionCulture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'CONSTRAINT', N'PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelProductDescriptionCulture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', 'INDEX', N'PK_ProductModelProductDescriptionCulture_ProductModelID_ProductDescriptionID_CultureID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductModelProductDescriptionCulture]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping product descriptions and the language the description is written in.', 'SCHEMA', N'Production', 'TABLE', N'ProductModelProductDescriptionCulture', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Large image of the product.', 'SCHEMA', N'Production', 'TABLE', N'ProductPhoto', 'COLUMN', N'LargePhoto'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Large image file name.', 'SCHEMA', N'Production', 'TABLE', N'ProductPhoto', 'COLUMN', N'LargePhotoFileName'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductPhoto', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ProductPhoto records.', 'SCHEMA', N'Production', 'TABLE', N'ProductPhoto', 'COLUMN', N'ProductPhotoID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Small image of the product.', 'SCHEMA', N'Production', 'TABLE', N'ProductPhoto', 'COLUMN', N'ThumbNailPhoto'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Small image file name.', 'SCHEMA', N'Production', 'TABLE', N'ProductPhoto', 'COLUMN', N'ThumbnailPhotoFileName'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductPhoto', 'CONSTRAINT', N'DF_ProductPhoto_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductPhoto', 'CONSTRAINT', N'PK_ProductPhoto_ProductPhotoID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductPhoto', 'INDEX', N'PK_ProductPhoto_ProductPhotoID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product images.', 'SCHEMA', N'Production', 'TABLE', N'ProductPhoto', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductProductPhoto', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Photo is not the principal image. 1 = Photo is the principal image.', 'SCHEMA', N'Production', 'TABLE', N'ProductProductPhoto', 'COLUMN', N'Primary'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'ProductProductPhoto', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product photo identification number. Foreign key to ProductPhoto.ProductPhotoID.', 'SCHEMA', N'Production', 'TABLE', N'ProductProductPhoto', 'COLUMN', N'ProductPhotoID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductProductPhoto', 'CONSTRAINT', N'DF_ProductProductPhoto_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0 (FALSE)', 'SCHEMA', N'Production', 'TABLE', N'ProductProductPhoto', 'CONSTRAINT', N'DF_ProductProductPhoto_Primary'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'ProductProductPhoto', 'CONSTRAINT', N'FK_ProductProductPhoto_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductPhoto.ProductPhotoID.', 'SCHEMA', N'Production', 'TABLE', N'ProductProductPhoto', 'CONSTRAINT', N'FK_ProductProductPhoto_ProductPhoto_ProductPhotoID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductProductPhoto', 'CONSTRAINT', N'PK_ProductProductPhoto_ProductID_ProductPhotoID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductProductPhoto', 'INDEX', N'PK_ProductProductPhoto_ProductID_ProductPhotoID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductProductPhoto]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping products and product photos.', 'SCHEMA', N'Production', 'TABLE', N'ProductProductPhoto', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reviewer''s comments', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'COLUMN', N'Comments'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reviewer''s e-mail address.', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'COLUMN', N'EmailAddress'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ProductReview records.', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'COLUMN', N'ProductReviewID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product rating given by the reviewer. Scale is 1 to 5 with 5 as the highest rating.', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'COLUMN', N'Rating'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date review was submitted.', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'COLUMN', N'ReviewDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the reviewer.', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'COLUMN', N'ReviewerName'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Rating] BETWEEN (1) AND (5)', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'CONSTRAINT', N'CK_ProductReview_Rating'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'CONSTRAINT', N'DF_ProductReview_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'CONSTRAINT', N'DF_ProductReview_ReviewDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'CONSTRAINT', N'FK_ProductReview_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'CONSTRAINT', N'PK_ProductReview_ProductReviewID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'INDEX', N'IX_ProductReview_ProductID_Name'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', 'INDEX', N'PK_ProductReview_ProductReviewID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductReview]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer reviews of products they have purchased.', 'SCHEMA', N'Production', 'TABLE', N'ProductReview', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Subcategory description.', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product category identification number. Foreign key to ProductCategory.ProductCategoryID.', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'COLUMN', N'ProductCategoryID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ProductSubcategory records.', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'COLUMN', N'ProductSubcategoryID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'CONSTRAINT', N'DF_ProductSubcategory_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'CONSTRAINT', N'DF_ProductSubcategory_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ProductCategory.ProductCategoryID.', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'CONSTRAINT', N'FK_ProductSubcategory_ProductCategory_ProductCategoryID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'CONSTRAINT', N'PK_ProductSubcategory_ProductSubcategoryID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'INDEX', N'AK_ProductSubcategory_Name'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'INDEX', N'AK_ProductSubcategory_rowguid'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', 'INDEX', N'PK_ProductSubcategory_ProductSubcategoryID'
GO


Print 'Create Extended Property MS_Description on [Production].[ProductSubcategory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product subcategories. See ProductCategory table.', 'SCHEMA', N'Production', 'TABLE', N'ProductSubcategory', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[ScrapReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'ScrapReason', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ScrapReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Failure description.', 'SCHEMA', N'Production', 'TABLE', N'ScrapReason', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Production].[ScrapReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ScrapReason records.', 'SCHEMA', N'Production', 'TABLE', N'ScrapReason', 'COLUMN', N'ScrapReasonID'
GO


Print 'Create Extended Property MS_Description on [Production].[ScrapReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'ScrapReason', 'CONSTRAINT', N'DF_ScrapReason_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[ScrapReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'ScrapReason', 'CONSTRAINT', N'PK_ScrapReason_ScrapReasonID'
GO


Print 'Create Extended Property MS_Description on [Production].[ScrapReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'ScrapReason', 'INDEX', N'AK_ScrapReason_Name'
GO


Print 'Create Extended Property MS_Description on [Production].[ScrapReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'ScrapReason', 'INDEX', N'PK_ScrapReason_ScrapReasonID'
GO


Print 'Create Extended Property MS_Description on [Production].[ScrapReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manufacturing failure reasons lookup table.', 'SCHEMA', N'Production', 'TABLE', N'ScrapReason', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product cost.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'COLUMN', N'ActualCost'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product quantity.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'COLUMN', N'Quantity'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchase order, sales order, or work order identification number.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'COLUMN', N'ReferenceOrderID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Line number associated with the purchase order, sales order, or work order.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'COLUMN', N'ReferenceOrderLineID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time of the transaction.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'COLUMN', N'TransactionDate'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for TransactionHistory records.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'COLUMN', N'TransactionID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'W = WorkOrder, S = SalesOrder, P = PurchaseOrder', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'COLUMN', N'TransactionType'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [TransactionType]=''p'' OR [TransactionType]=''s'' OR [TransactionType]=''w'' OR [TransactionType]=''P'' OR [TransactionType]=''S'' OR [TransactionType]=''W'')', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'CONSTRAINT', N'CK_TransactionHistory_TransactionType'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'CONSTRAINT', N'DF_TransactionHistory_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'CONSTRAINT', N'DF_TransactionHistory_ReferenceOrderLineID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'CONSTRAINT', N'DF_TransactionHistory_TransactionDate'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'CONSTRAINT', N'FK_TransactionHistory_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'CONSTRAINT', N'PK_TransactionHistory_TransactionID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'INDEX', N'IX_TransactionHistory_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'INDEX', N'IX_TransactionHistory_ReferenceOrderID_ReferenceOrderLineID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', 'INDEX', N'PK_TransactionHistory_TransactionID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Record of each purchase order, sales order, or work order transaction year to date.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistory', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product cost.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'COLUMN', N'ActualCost'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product quantity.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'COLUMN', N'Quantity'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchase order, sales order, or work order identification number.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'COLUMN', N'ReferenceOrderID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Line number associated with the purchase order, sales order, or work order.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'COLUMN', N'ReferenceOrderLineID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time of the transaction.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'COLUMN', N'TransactionDate'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for TransactionHistoryArchive records.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'COLUMN', N'TransactionID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'W = Work Order, S = Sales Order, P = Purchase Order', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'COLUMN', N'TransactionType'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [TransactionType]=''p'' OR [TransactionType]=''s'' OR [TransactionType]=''w'' OR [TransactionType]=''P'' OR [TransactionType]=''S'' OR [TransactionType]=''W''', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'CONSTRAINT', N'CK_TransactionHistoryArchive_TransactionType'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'CONSTRAINT', N'DF_TransactionHistoryArchive_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'CONSTRAINT', N'DF_TransactionHistoryArchive_ReferenceOrderLineID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'CONSTRAINT', N'DF_TransactionHistoryArchive_TransactionDate'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'CONSTRAINT', N'PK_TransactionHistoryArchive_TransactionID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'INDEX', N'IX_TransactionHistoryArchive_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'INDEX', N'IX_TransactionHistoryArchive_ReferenceOrderID_ReferenceOrderLineID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', 'INDEX', N'PK_TransactionHistoryArchive_TransactionID'
GO


Print 'Create Extended Property MS_Description on [Production].[TransactionHistoryArchive]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Transactions for previous years.', 'SCHEMA', N'Production', 'TABLE', N'TransactionHistoryArchive', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[UnitMeasure]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'UnitMeasure', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[UnitMeasure]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unit of measure description.', 'SCHEMA', N'Production', 'TABLE', N'UnitMeasure', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Production].[UnitMeasure]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'Production', 'TABLE', N'UnitMeasure', 'COLUMN', N'UnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Production].[UnitMeasure]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'UnitMeasure', 'CONSTRAINT', N'DF_UnitMeasure_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[UnitMeasure]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'UnitMeasure', 'CONSTRAINT', N'PK_UnitMeasure_UnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Production].[UnitMeasure]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'UnitMeasure', 'INDEX', N'AK_UnitMeasure_Name'
GO


Print 'Create Extended Property MS_Description on [Production].[UnitMeasure]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'UnitMeasure', 'INDEX', N'PK_UnitMeasure_UnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Production].[UnitMeasure]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unit of measure lookup table.', 'SCHEMA', N'Production', 'TABLE', N'UnitMeasure', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Work order due date.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'COLUMN', N'DueDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Work order end date.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'COLUMN', N'EndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product quantity to build.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'COLUMN', N'OrderQty'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Quantity that failed inspection.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'COLUMN', N'ScrappedQty'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Reason for inspection failure.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'COLUMN', N'ScrapReasonID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Work order start date.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'COLUMN', N'StartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Quantity built and put in inventory.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'COLUMN', N'StockedQty'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for WorkOrder records.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'COLUMN', N'WorkOrderID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [EndDate] >= [StartDate] OR [EndDate] IS NULL', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'CONSTRAINT', N'CK_WorkOrder_EndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [OrderQty] > (0)', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'CONSTRAINT', N'CK_WorkOrder_OrderQty'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ScrappedQty] >= (0)', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'CONSTRAINT', N'CK_WorkOrder_ScrappedQty'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'CONSTRAINT', N'DF_WorkOrder_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'CONSTRAINT', N'FK_WorkOrder_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ScrapReason.ScrapReasonID.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'CONSTRAINT', N'FK_WorkOrder_ScrapReason_ScrapReasonID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'CONSTRAINT', N'PK_WorkOrder_WorkOrderID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'INDEX', N'IX_WorkOrder_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'INDEX', N'IX_WorkOrder_ScrapReasonID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', 'INDEX', N'PK_WorkOrder_WorkOrderID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrder]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manufacturing work orders.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrder', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Actual manufacturing cost.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'ActualCost'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Actual end date.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'ActualEndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Number of manufacturing hours used.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'ActualResourceHrs'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Actual start date.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'ActualStartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Manufacturing location where the part is processed. Foreign key to Location.LocationID.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'LocationID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Indicates the manufacturing process sequence.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'OperationSequence'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estimated manufacturing cost.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'PlannedCost'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to Product.ProductID.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Planned manufacturing end date.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'ScheduledEndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Planned manufacturing start date.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'ScheduledStartDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to WorkOrder.WorkOrderID.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'COLUMN', N'WorkOrderID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ActualCost] > (0.00)', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'CONSTRAINT', N'CK_WorkOrderRouting_ActualCost'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ActualEndDate] >= [ActualStartDate] OR [ActualEndDate] IS NULL OR [ActualStartDate] IS NULL', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'CONSTRAINT', N'CK_WorkOrderRouting_ActualEndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ActualResourceHrs] >= (0.0000)', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'CONSTRAINT', N'CK_WorkOrderRouting_ActualResourceHrs'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [PlannedCost] > (0.00)', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'CONSTRAINT', N'CK_WorkOrderRouting_PlannedCost'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ScheduledEndDate] >= [ScheduledStartDate]', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'CONSTRAINT', N'CK_WorkOrderRouting_ScheduledEndDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'CONSTRAINT', N'DF_WorkOrderRouting_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Location.LocationID.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'CONSTRAINT', N'FK_WorkOrderRouting_Location_LocationID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing WorkOrder.WorkOrderID.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'CONSTRAINT', N'FK_WorkOrderRouting_WorkOrder_WorkOrderID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'CONSTRAINT', N'PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'INDEX', N'IX_WorkOrderRouting_ProductID'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', 'INDEX', N'PK_WorkOrderRouting_WorkOrderID_ProductID_OperationSequence'
GO


Print 'Create Extended Property MS_Description on [Production].[WorkOrderRouting]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Work order details.', 'SCHEMA', N'Production', 'TABLE', N'WorkOrderRouting', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The average span of time (in days) between placing an order with the vendor and receiving the purchased product.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'COLUMN', N'AverageLeadTime'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to Vendor.BusinessEntityID.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The selling price when last purchased.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'COLUMN', N'LastReceiptCost'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the product was last received by the vendor.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'COLUMN', N'LastReceiptDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The minimum quantity that should be ordered.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'COLUMN', N'MaxOrderQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The maximum quantity that should be ordered.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'COLUMN', N'MinOrderQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The quantity currently on order.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'COLUMN', N'OnOrderQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to Product.ProductID.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The vendor''s usual selling price.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'COLUMN', N'StandardPrice'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The product''s unit of measure.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'COLUMN', N'UnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [AverageLeadTime] >= (1)', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'CONSTRAINT', N'CK_ProductVendor_AverageLeadTime'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [LastReceiptCost] > (0.00)', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'CONSTRAINT', N'CK_ProductVendor_LastReceiptCost'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [MaxOrderQty] >= (1)', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'CONSTRAINT', N'CK_ProductVendor_MaxOrderQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [MinOrderQty] >= (1)', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'CONSTRAINT', N'CK_ProductVendor_MinOrderQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [OnOrderQty] >= (0)', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'CONSTRAINT', N'CK_ProductVendor_OnOrderQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [StandardPrice] > (0.00)', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'CONSTRAINT', N'CK_ProductVendor_StandardPrice'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'CONSTRAINT', N'DF_ProductVendor_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'CONSTRAINT', N'FK_ProductVendor_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing UnitMeasure.UnitMeasureCode.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'CONSTRAINT', N'FK_ProductVendor_UnitMeasure_UnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Vendor.BusinessEntityID.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'CONSTRAINT', N'FK_ProductVendor_Vendor_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'CONSTRAINT', N'PK_ProductVendor_ProductID_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'INDEX', N'IX_ProductVendor_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'INDEX', N'IX_ProductVendor_UnitMeasureCode'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', 'INDEX', N'PK_ProductVendor_ProductID_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ProductVendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping vendors with the products they supply.', 'SCHEMA', N'Purchasing', 'TABLE', N'ProductVendor', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the product is expected to be received.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'COLUMN', N'DueDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Per product subtotal. Computed as OrderQty * UnitPrice.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'COLUMN', N'LineTotal'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Quantity ordered.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'COLUMN', N'OrderQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. One line number per purchased product.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'COLUMN', N'PurchaseOrderDetailID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to PurchaseOrderHeader.PurchaseOrderID.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'COLUMN', N'PurchaseOrderID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Quantity actually received from the vendor.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'COLUMN', N'ReceivedQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Quantity rejected during inspection.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'COLUMN', N'RejectedQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Quantity accepted into inventory. Computed as ReceivedQty - RejectedQty.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'COLUMN', N'StockedQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Vendor''s selling price of a single product.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'COLUMN', N'UnitPrice'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [OrderQty] > (0)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'CONSTRAINT', N'CK_PurchaseOrderDetail_OrderQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ReceivedQty] >= (0.00)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'CONSTRAINT', N'CK_PurchaseOrderDetail_ReceivedQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [RejectedQty] >= (0.00)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'CONSTRAINT', N'CK_PurchaseOrderDetail_RejectedQty'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [UnitPrice] >= (0.00)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'CONSTRAINT', N'CK_PurchaseOrderDetail_UnitPrice'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'CONSTRAINT', N'DF_PurchaseOrderDetail_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'CONSTRAINT', N'FK_PurchaseOrderDetail_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing PurchaseOrderHeader.PurchaseOrderID.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'CONSTRAINT', N'FK_PurchaseOrderDetail_PurchaseOrderHeader_PurchaseOrderID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'CONSTRAINT', N'PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'INDEX', N'IX_PurchaseOrderDetail_ProductID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', 'INDEX', N'PK_PurchaseOrderDetail_PurchaseOrderID_PurchaseOrderDetailID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Individual products associated with a specific purchase order. See PurchaseOrderHeader.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderDetail', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Employee who created the purchase order. Foreign key to Employee.BusinessEntityID.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'EmployeeID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shipping cost.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'Freight'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchase order creation date.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'OrderDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'PurchaseOrderID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Incremental number to track changes to the purchase order over time.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'RevisionNumber'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Estimated shipment date from the vendor.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'ShipDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shipping method. Foreign key to ShipMethod.ShipMethodID.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'ShipMethodID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order current status. 1 = Pending; 2 = Approved; 3 = Rejected; 4 = Complete', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'Status'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Purchase order subtotal. Computed as SUM(PurchaseOrderDetail.LineTotal)for the appropriate PurchaseOrderID.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'SubTotal'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tax amount.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'TaxAmt'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total due to vendor. Computed as Subtotal + TaxAmt + Freight.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'TotalDue'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Vendor with whom the purchase order is placed. Foreign key to Vendor.BusinessEntityID.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'COLUMN', N'VendorID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Freight] >= (0.00)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'CK_PurchaseOrderHeader_Freight'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ShipDate] >= [OrderDate] OR [ShipDate] IS NULL', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'CK_PurchaseOrderHeader_ShipDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Status] BETWEEN (1) AND (4)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'CK_PurchaseOrderHeader_Status'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SubTotal] >= (0.00)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'CK_PurchaseOrderHeader_SubTotal'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [TaxAmt] >= (0.00)', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'CK_PurchaseOrderHeader_TaxAmt'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'DF_PurchaseOrderHeader_Freight'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'DF_PurchaseOrderHeader_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'DF_PurchaseOrderHeader_OrderDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'DF_PurchaseOrderHeader_RevisionNumber'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'DF_PurchaseOrderHeader_Status'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'DF_PurchaseOrderHeader_SubTotal'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'DF_PurchaseOrderHeader_TaxAmt'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'FK_PurchaseOrderHeader_Employee_EmployeeID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ShipMethod.ShipMethodID.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'FK_PurchaseOrderHeader_ShipMethod_ShipMethodID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Vendor.VendorID.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'FK_PurchaseOrderHeader_Vendor_VendorID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'CONSTRAINT', N'PK_PurchaseOrderHeader_PurchaseOrderID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'INDEX', N'IX_PurchaseOrderHeader_EmployeeID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'INDEX', N'IX_PurchaseOrderHeader_VendorID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', 'INDEX', N'PK_PurchaseOrderHeader_PurchaseOrderID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[PurchaseOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'General purchase order information. See PurchaseOrderDetail.', 'SCHEMA', N'Purchasing', 'TABLE', N'PurchaseOrderHeader', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shipping company name.', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Minimum shipping charge.', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'COLUMN', N'ShipBase'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ShipMethod records.', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'COLUMN', N'ShipMethodID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shipping charge per pound.', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'COLUMN', N'ShipRate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ShipBase] > (0.00)', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'CONSTRAINT', N'CK_ShipMethod_ShipBase'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ShipRate] > (0.00)', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'CONSTRAINT', N'CK_ShipMethod_ShipRate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'CONSTRAINT', N'DF_ShipMethod_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'CONSTRAINT', N'DF_ShipMethod_rowguid'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'CONSTRAINT', N'DF_ShipMethod_ShipBase'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'CONSTRAINT', N'DF_ShipMethod_ShipRate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'CONSTRAINT', N'PK_ShipMethod_ShipMethodID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'INDEX', N'AK_ShipMethod_Name'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'INDEX', N'AK_ShipMethod_rowguid'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', 'INDEX', N'PK_ShipMethod_ShipMethodID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[ShipMethod]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shipping company lookup table.', 'SCHEMA', N'Purchasing', 'TABLE', N'ShipMethod', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Vendor account (identification) number.', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'COLUMN', N'AccountNumber'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Vendor no longer used. 1 = Vendor is actively used.', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'COLUMN', N'ActiveFlag'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Vendor records.  Foreign key to BusinessEntity.BusinessEntityID', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 = Superior, 2 = Excellent, 3 = Above average, 4 = Average, 5 = Below average', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'COLUMN', N'CreditRating'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Company name.', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Do not use if another vendor is available. 1 = Preferred over other vendors supplying the same product.', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'COLUMN', N'PreferredVendorStatus'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Vendor URL.', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'COLUMN', N'PurchasingWebServiceURL'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [CreditRating] BETWEEN (1) AND (5)', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'CONSTRAINT', N'CK_Vendor_CreditRating'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1 (TRUE)', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'CONSTRAINT', N'DF_Vendor_ActiveFlag'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'CONSTRAINT', N'DF_Vendor_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1 (TRUE)', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'CONSTRAINT', N'DF_Vendor_PreferredVendorStatus'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing BusinessEntity.BusinessEntityID', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'CONSTRAINT', N'FK_Vendor_BusinessEntity_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'CONSTRAINT', N'PK_Vendor_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'INDEX', N'AK_Vendor_AccountNumber'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', 'INDEX', N'PK_Vendor_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Purchasing].[Vendor]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Companies from whom Adventure Works Cycles purchases parts or other goods.', 'SCHEMA', N'Purchasing', 'TABLE', N'Vendor', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[CountryRegionCurrency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ISO code for countries and regions. Foreign key to CountryRegion.CountryRegionCode.', 'SCHEMA', N'Sales', 'TABLE', N'CountryRegionCurrency', 'COLUMN', N'CountryRegionCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CountryRegionCurrency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ISO standard currency code. Foreign key to Currency.CurrencyCode.', 'SCHEMA', N'Sales', 'TABLE', N'CountryRegionCurrency', 'COLUMN', N'CurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CountryRegionCurrency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'CountryRegionCurrency', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[CountryRegionCurrency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'CountryRegionCurrency', 'CONSTRAINT', N'DF_CountryRegionCurrency_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[CountryRegionCurrency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing CountryRegion.CountryRegionCode.', 'SCHEMA', N'Sales', 'TABLE', N'CountryRegionCurrency', 'CONSTRAINT', N'FK_CountryRegionCurrency_CountryRegion_CountryRegionCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CountryRegionCurrency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Currency.CurrencyCode.', 'SCHEMA', N'Sales', 'TABLE', N'CountryRegionCurrency', 'CONSTRAINT', N'FK_CountryRegionCurrency_Currency_CurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CountryRegionCurrency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'CountryRegionCurrency', 'CONSTRAINT', N'PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CountryRegionCurrency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'CountryRegionCurrency', 'INDEX', N'IX_CountryRegionCurrency_CurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CountryRegionCurrency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'CountryRegionCurrency', 'INDEX', N'PK_CountryRegionCurrency_CountryRegionCode_CurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CountryRegionCurrency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping ISO currency codes to a country or region.', 'SCHEMA', N'Sales', 'TABLE', N'CountryRegionCurrency', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[CreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Credit card number.', 'SCHEMA', N'Sales', 'TABLE', N'CreditCard', 'COLUMN', N'CardNumber'
GO


Print 'Create Extended Property MS_Description on [Sales].[CreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Credit card name.', 'SCHEMA', N'Sales', 'TABLE', N'CreditCard', 'COLUMN', N'CardType'
GO


Print 'Create Extended Property MS_Description on [Sales].[CreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for CreditCard records.', 'SCHEMA', N'Sales', 'TABLE', N'CreditCard', 'COLUMN', N'CreditCardID'
GO


Print 'Create Extended Property MS_Description on [Sales].[CreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Credit card expiration month.', 'SCHEMA', N'Sales', 'TABLE', N'CreditCard', 'COLUMN', N'ExpMonth'
GO


Print 'Create Extended Property MS_Description on [Sales].[CreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Credit card expiration year.', 'SCHEMA', N'Sales', 'TABLE', N'CreditCard', 'COLUMN', N'ExpYear'
GO


Print 'Create Extended Property MS_Description on [Sales].[CreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'CreditCard', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[CreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'CreditCard', 'CONSTRAINT', N'DF_CreditCard_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[CreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'CreditCard', 'CONSTRAINT', N'PK_CreditCard_CreditCardID'
GO


Print 'Create Extended Property MS_Description on [Sales].[CreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'CreditCard', 'INDEX', N'AK_CreditCard_CardNumber'
GO


Print 'Create Extended Property MS_Description on [Sales].[CreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'CreditCard', 'INDEX', N'PK_CreditCard_CreditCardID'
GO


Print 'Create Extended Property MS_Description on [Sales].[CreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer credit card information.', 'SCHEMA', N'Sales', 'TABLE', N'CreditCard', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[Currency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'The ISO code for the Currency.', 'SCHEMA', N'Sales', 'TABLE', N'Currency', 'COLUMN', N'CurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[Currency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'Currency', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[Currency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Currency name.', 'SCHEMA', N'Sales', 'TABLE', N'Currency', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Sales].[Currency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'Currency', 'CONSTRAINT', N'DF_Currency_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[Currency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'Currency', 'CONSTRAINT', N'PK_Currency_CurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[Currency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'Currency', 'INDEX', N'AK_Currency_Name'
GO


Print 'Create Extended Property MS_Description on [Sales].[Currency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'Currency', 'INDEX', N'PK_Currency_CurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[Currency]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table containing standard ISO currencies.', 'SCHEMA', N'Sales', 'TABLE', N'Currency', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Average exchange rate for the day.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'COLUMN', N'AverageRate'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the exchange rate was obtained.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'COLUMN', N'CurrencyRateDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for CurrencyRate records.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'COLUMN', N'CurrencyRateID'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Final exchange rate for the day.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'COLUMN', N'EndOfDayRate'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Exchange rate was converted from this currency code.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'COLUMN', N'FromCurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Exchange rate was converted to this currency code.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'COLUMN', N'ToCurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'CONSTRAINT', N'DF_CurrencyRate_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Currency.FromCurrencyCode.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'CONSTRAINT', N'FK_CurrencyRate_Currency_FromCurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Currency.ToCurrencyCode.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'CONSTRAINT', N'FK_CurrencyRate_Currency_ToCurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'CONSTRAINT', N'PK_CurrencyRate_CurrencyRateID'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'INDEX', N'AK_CurrencyRate_CurrencyRateDate_FromCurrencyCode_ToCurrencyCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', 'INDEX', N'PK_CurrencyRate_CurrencyRateID'
GO


Print 'Create Extended Property MS_Description on [Sales].[CurrencyRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Currency exchange rates.', 'SCHEMA', N'Sales', 'TABLE', N'CurrencyRate', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique number identifying the customer assigned by the accounting system.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'COLUMN', N'AccountNumber'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'COLUMN', N'CustomerID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to Person.BusinessEntityID', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'COLUMN', N'PersonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key to Store.BusinessEntityID', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'COLUMN', N'StoreID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of the territory in which the customer is located. Foreign key to SalesTerritory.SalesTerritoryID.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'COLUMN', N'TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'CONSTRAINT', N'DF_Customer_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'CONSTRAINT', N'DF_Customer_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'CONSTRAINT', N'FK_Customer_Person_PersonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesTerritory.TerritoryID.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'CONSTRAINT', N'FK_Customer_SalesTerritory_TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Store.BusinessEntityID.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'CONSTRAINT', N'FK_Customer_Store_StoreID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'CONSTRAINT', N'PK_Customer_CustomerID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'INDEX', N'AK_Customer_AccountNumber'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'INDEX', N'AK_Customer_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'INDEX', N'IX_Customer_TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', 'INDEX', N'PK_Customer_CustomerID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Customer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Current customer information. Also see the Person and Store tables.', 'SCHEMA', N'Sales', 'TABLE', N'Customer', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[PersonCreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Business entity identification number. Foreign key to Person.BusinessEntityID.', 'SCHEMA', N'Sales', 'TABLE', N'PersonCreditCard', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[PersonCreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Credit card identification number. Foreign key to CreditCard.CreditCardID.', 'SCHEMA', N'Sales', 'TABLE', N'PersonCreditCard', 'COLUMN', N'CreditCardID'
GO


Print 'Create Extended Property MS_Description on [Sales].[PersonCreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'PersonCreditCard', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[PersonCreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'PersonCreditCard', 'CONSTRAINT', N'DF_PersonCreditCard_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[PersonCreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing CreditCard.CreditCardID.', 'SCHEMA', N'Sales', 'TABLE', N'PersonCreditCard', 'CONSTRAINT', N'FK_PersonCreditCard_CreditCard_CreditCardID'
GO


Print 'Create Extended Property MS_Description on [Sales].[PersonCreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Person.BusinessEntityID.', 'SCHEMA', N'Sales', 'TABLE', N'PersonCreditCard', 'CONSTRAINT', N'FK_PersonCreditCard_Person_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[PersonCreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'PersonCreditCard', 'CONSTRAINT', N'PK_PersonCreditCard_BusinessEntityID_CreditCardID'
GO


Print 'Create Extended Property MS_Description on [Sales].[PersonCreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'PersonCreditCard', 'INDEX', N'PK_PersonCreditCard_BusinessEntityID_CreditCardID'
GO


Print 'Create Extended Property MS_Description on [Sales].[PersonCreditCard]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping people to their credit card information in the CreditCard table. ', 'SCHEMA', N'Sales', 'TABLE', N'PersonCreditCard', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shipment tracking number supplied by the shipper.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'CarrierTrackingNumber'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Per product subtotal. Computed as UnitPrice * (1 - UnitPriceDiscount) * OrderQty.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'LineTotal'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Quantity ordered per product.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'OrderQty'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product sold to customer. Foreign key to Product.ProductID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. One incremental unique number per product sold.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'SalesOrderDetailID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to SalesOrderHeader.SalesOrderID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'SalesOrderID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Promotional code. Foreign key to SpecialOffer.SpecialOfferID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'SpecialOfferID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Selling price of a single product.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'UnitPrice'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Discount amount.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'COLUMN', N'UnitPriceDiscount'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [OrderQty] > (0)', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'CK_SalesOrderDetail_OrderQty'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [UnitPrice] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'CK_SalesOrderDetail_UnitPrice'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [UnitPriceDiscount] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'CK_SalesOrderDetail_UnitPriceDiscount'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'DF_SalesOrderDetail_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'DF_SalesOrderDetail_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'DF_SalesOrderDetail_UnitPriceDiscount'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesOrderHeader.PurchaseOrderID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'FK_SalesOrderDetail_SalesOrderHeader_SalesOrderID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SpecialOfferProduct.SpecialOfferIDProductID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'FK_SalesOrderDetail_SpecialOfferProduct_SpecialOfferIDProductID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'CONSTRAINT', N'PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'INDEX', N'AK_SalesOrderDetail_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'INDEX', N'IX_SalesOrderDetail_ProductID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', 'INDEX', N'PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderDetail]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Individual products associated with a specific sales order. See SalesOrderHeader.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderDetail', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Financial accounting number reference.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'AccountNumber'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer billing address. Foreign key to Address.AddressID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'BillToAddressID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales representative comments.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'Comment'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Approval code provided by the credit card company.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'CreditCardApprovalCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Credit card identification number. Foreign key to CreditCard.CreditCardID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'CreditCardID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Currency exchange rate used. Foreign key to CurrencyRate.CurrencyRateID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'CurrencyRateID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer identification number. Foreign key to Customer.BusinessEntityID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'CustomerID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the order is due to the customer.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'DueDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shipping cost.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'Freight'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Order placed by sales person. 1 = Order placed online by customer.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'OnlineOrderFlag'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Dates the sales order was created.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'OrderDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer purchase order number reference. ', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'PurchaseOrderNumber'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Incremental number to track changes to the sales order over time.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'RevisionNumber'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'SalesOrderID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique sales order identification number.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'SalesOrderNumber'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales person who created the sales order. Foreign key to SalesPerson.BusinessEntityID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'SalesPersonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the order was shipped to the customer.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'ShipDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shipping method. Foreign key to ShipMethod.ShipMethodID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'ShipMethodID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customer shipping address. Foreign key to Address.AddressID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'ShipToAddressID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Order current status. 1 = In process; 2 = Approved; 3 = Backordered; 4 = Rejected; 5 = Shipped; 6 = Cancelled', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'Status'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales subtotal. Computed as SUM(SalesOrderDetail.LineTotal)for the appropriate SalesOrderID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'SubTotal'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tax amount.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'TaxAmt'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Territory in which the sale was made. Foreign key to SalesTerritory.SalesTerritoryID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Total due from customer. Computed as Subtotal + TaxAmt + Freight.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'COLUMN', N'TotalDue'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [DueDate] >= [OrderDate]', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_DueDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Freight] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_Freight'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [ShipDate] >= [OrderDate] OR [ShipDate] IS NULL', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_ShipDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Status] BETWEEN (0) AND (8)', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_Status'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SubTotal] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_SubTotal'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [TaxAmt] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'CK_SalesOrderHeader_TaxAmt'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_Freight'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1 (TRUE)', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_OnlineOrderFlag'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_OrderDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_RevisionNumber'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_Status'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_SubTotal'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'DF_SalesOrderHeader_TaxAmt'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Address.AddressID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_Address_BillToAddressID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Address.AddressID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_Address_ShipToAddressID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing CreditCard.CreditCardID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_CreditCard_CreditCardID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing CurrencyRate.CurrencyRateID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_CurrencyRate_CurrencyRateID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Customer.CustomerID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_Customer_CustomerID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesPerson.SalesPersonID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_SalesPerson_SalesPersonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesTerritory.TerritoryID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_SalesTerritory_TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing ShipMethod.ShipMethodID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'FK_SalesOrderHeader_ShipMethod_ShipMethodID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'CONSTRAINT', N'PK_SalesOrderHeader_SalesOrderID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'INDEX', N'AK_SalesOrderHeader_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'INDEX', N'AK_SalesOrderHeader_SalesOrderNumber'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'INDEX', N'IX_SalesOrderHeader_CustomerID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'INDEX', N'IX_SalesOrderHeader_SalesPersonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', 'INDEX', N'PK_SalesOrderHeader_SalesOrderID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeader]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'General sales order information.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeader', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeaderSalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeaderSalesReason', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeaderSalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to SalesOrderHeader.SalesOrderID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeaderSalesReason', 'COLUMN', N'SalesOrderID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeaderSalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to SalesReason.SalesReasonID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeaderSalesReason', 'COLUMN', N'SalesReasonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeaderSalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeaderSalesReason', 'CONSTRAINT', N'DF_SalesOrderHeaderSalesReason_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeaderSalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesOrderHeader.SalesOrderID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeaderSalesReason', 'CONSTRAINT', N'FK_SalesOrderHeaderSalesReason_SalesOrderHeader_SalesOrderID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeaderSalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesReason.SalesReasonID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeaderSalesReason', 'CONSTRAINT', N'FK_SalesOrderHeaderSalesReason_SalesReason_SalesReasonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeaderSalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeaderSalesReason', 'CONSTRAINT', N'PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeaderSalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeaderSalesReason', 'INDEX', N'PK_SalesOrderHeaderSalesReason_SalesOrderID_SalesReasonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesOrderHeaderSalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping sales orders to sales reason codes.', 'SCHEMA', N'Sales', 'TABLE', N'SalesOrderHeaderSalesReason', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Bonus due if quota is met.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'COLUMN', N'Bonus'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for SalesPerson records. Foreign key to Employee.BusinessEntityID', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Commision percent received per sale.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'COLUMN', N'CommissionPct'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales total of previous year.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'COLUMN', N'SalesLastYear'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Projected yearly sales.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'COLUMN', N'SalesQuota'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales total year to date.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'COLUMN', N'SalesYTD'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Territory currently assigned to. Foreign key to SalesTerritory.SalesTerritoryID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'COLUMN', N'TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Bonus] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'CK_SalesPerson_Bonus'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [CommissionPct] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'CK_SalesPerson_CommissionPct'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SalesLastYear] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'CK_SalesPerson_SalesLastYear'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SalesQuota] > (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'CK_SalesPerson_SalesQuota'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SalesYTD] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'CK_SalesPerson_SalesYTD'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'DF_SalesPerson_Bonus'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'DF_SalesPerson_CommissionPct'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'DF_SalesPerson_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'DF_SalesPerson_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'DF_SalesPerson_SalesLastYear'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'DF_SalesPerson_SalesYTD'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Employee.EmployeeID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'FK_SalesPerson_Employee_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesTerritory.TerritoryID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'FK_SalesPerson_SalesTerritory_TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'CONSTRAINT', N'PK_SalesPerson_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'INDEX', N'AK_SalesPerson_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', 'INDEX', N'PK_SalesPerson_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPerson]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales representative current information.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPerson', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales person identification number. Foreign key to SalesPerson.BusinessEntityID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales quota date.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'COLUMN', N'QuotaDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales quota amount.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'COLUMN', N'SalesQuota'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SalesQuota] > (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'CONSTRAINT', N'CK_SalesPersonQuotaHistory_SalesQuota'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'CONSTRAINT', N'DF_SalesPersonQuotaHistory_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'CONSTRAINT', N'DF_SalesPersonQuotaHistory_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesPerson.SalesPersonID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'CONSTRAINT', N'FK_SalesPersonQuotaHistory_SalesPerson_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'CONSTRAINT', N'PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'INDEX', N'AK_SalesPersonQuotaHistory_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', 'INDEX', N'PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesPersonQuotaHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales performance tracking.', 'SCHEMA', N'Sales', 'TABLE', N'SalesPersonQuotaHistory', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'SalesReason', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales reason description.', 'SCHEMA', N'Sales', 'TABLE', N'SalesReason', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Category the sales reason belongs to.', 'SCHEMA', N'Sales', 'TABLE', N'SalesReason', 'COLUMN', N'ReasonType'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for SalesReason records.', 'SCHEMA', N'Sales', 'TABLE', N'SalesReason', 'COLUMN', N'SalesReasonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SalesReason', 'CONSTRAINT', N'DF_SalesReason_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'SalesReason', 'CONSTRAINT', N'PK_SalesReason_SalesReasonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'SalesReason', 'INDEX', N'PK_SalesReason_SalesReasonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesReason]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Lookup table of customer purchase reasons.', 'SCHEMA', N'Sales', 'TABLE', N'SalesReason', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tax rate description.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for SalesTaxRate records.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'COLUMN', N'SalesTaxRateID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'State, province, or country/region the sales tax applies to.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'COLUMN', N'StateProvinceID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tax rate amount.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'COLUMN', N'TaxRate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'1 = Tax applied to retail transactions, 2 = Tax applied to wholesale transactions, 3 = Tax applied to all sales (retail and wholesale) transactions.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'COLUMN', N'TaxType'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [TaxType] BETWEEN (1) AND (3)', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'CONSTRAINT', N'CK_SalesTaxRate_TaxType'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'CONSTRAINT', N'DF_SalesTaxRate_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'CONSTRAINT', N'DF_SalesTaxRate_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'CONSTRAINT', N'DF_SalesTaxRate_TaxRate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing StateProvince.StateProvinceID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'CONSTRAINT', N'FK_SalesTaxRate_StateProvince_StateProvinceID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'CONSTRAINT', N'PK_SalesTaxRate_SalesTaxRateID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'INDEX', N'AK_SalesTaxRate_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'INDEX', N'AK_SalesTaxRate_StateProvinceID_TaxType'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', 'INDEX', N'PK_SalesTaxRate_SalesTaxRateID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTaxRate]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Tax rate lookup table.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTaxRate', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Business costs in the territory the previous year.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'COLUMN', N'CostLastYear'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Business costs in the territory year to date.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'COLUMN', N'CostYTD'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ISO standard country or region code. Foreign key to CountryRegion.CountryRegionCode. ', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'COLUMN', N'CountryRegionCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Geographic area to which the sales territory belong.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'COLUMN', N'Group'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales territory description', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales in the territory the previous year.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'COLUMN', N'SalesLastYear'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales in the territory year to date.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'COLUMN', N'SalesYTD'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for SalesTerritory records.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'COLUMN', N'TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [CostLastYear] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'CK_SalesTerritory_CostLastYear'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [CostYTD] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'CK_SalesTerritory_CostYTD'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SalesLastYear] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'CK_SalesTerritory_SalesLastYear'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [SalesYTD] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'CK_SalesTerritory_SalesYTD'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'DF_SalesTerritory_CostLastYear'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'DF_SalesTerritory_CostYTD'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'DF_SalesTerritory_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'DF_SalesTerritory_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'DF_SalesTerritory_SalesLastYear'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'DF_SalesTerritory_SalesYTD'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing CountryRegion.CountryRegionCode.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'FK_SalesTerritory_CountryRegion_CountryRegionCode'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'CONSTRAINT', N'PK_SalesTerritory_TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'INDEX', N'AK_SalesTerritory_Name'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'INDEX', N'AK_SalesTerritory_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', 'INDEX', N'PK_SalesTerritory_TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales territory lookup table.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritory', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. The sales rep.  Foreign key to SalesPerson.BusinessEntityID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the sales representative left work in the territory.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'COLUMN', N'EndDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Date the sales representive started work in the territory.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'COLUMN', N'StartDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Territory identification number. Foreign key to SalesTerritory.SalesTerritoryID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'COLUMN', N'TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [EndDate] >= [StartDate] OR [EndDate] IS NULL', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'CONSTRAINT', N'CK_SalesTerritoryHistory_EndDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'CONSTRAINT', N'DF_SalesTerritoryHistory_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'CONSTRAINT', N'DF_SalesTerritoryHistory_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesPerson.SalesPersonID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'CONSTRAINT', N'FK_SalesTerritoryHistory_SalesPerson_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesTerritory.TerritoryID.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'CONSTRAINT', N'FK_SalesTerritoryHistory_SalesTerritory_TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'CONSTRAINT', N'PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'INDEX', N'AK_SalesTerritoryHistory_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', 'INDEX', N'PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SalesTerritoryHistory]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sales representative transfers to other sales territories.', 'SCHEMA', N'Sales', 'TABLE', N'SalesTerritoryHistory', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date the time the record was created.', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'COLUMN', N'DateCreated'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product ordered. Foreign key to Product.ProductID.', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product quantity ordered.', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'COLUMN', N'Quantity'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Shopping cart identification number.', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'COLUMN', N'ShoppingCartID'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for ShoppingCartItem records.', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'COLUMN', N'ShoppingCartItemID'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [Quantity] >= (1)', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'CONSTRAINT', N'CK_ShoppingCartItem_Quantity'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'CONSTRAINT', N'DF_ShoppingCartItem_DateCreated'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'CONSTRAINT', N'DF_ShoppingCartItem_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 1', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'CONSTRAINT', N'DF_ShoppingCartItem_Quantity'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'CONSTRAINT', N'FK_ShoppingCartItem_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'CONSTRAINT', N'PK_ShoppingCartItem_ShoppingCartItemID'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'INDEX', N'IX_ShoppingCartItem_ShoppingCartID_ProductID'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', 'INDEX', N'PK_ShoppingCartItem_ShoppingCartItemID'
GO


Print 'Create Extended Property MS_Description on [Sales].[ShoppingCartItem]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains online customer orders until the order is submitted or cancelled.', 'SCHEMA', N'Sales', 'TABLE', N'ShoppingCartItem', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Group the discount applies to such as Reseller or Customer.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'COLUMN', N'Category'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Discount description.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'COLUMN', N'Description'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Discount precentage.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'COLUMN', N'DiscountPct'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Discount end date.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'COLUMN', N'EndDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Maximum discount percent allowed.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'COLUMN', N'MaxQty'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Minimum discount percent allowed.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'COLUMN', N'MinQty'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for SpecialOffer records.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'COLUMN', N'SpecialOfferID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Discount start date.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'COLUMN', N'StartDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Discount type category.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'COLUMN', N'Type'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [DiscountPct] >= (0.00)', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'CONSTRAINT', N'CK_SpecialOffer_DiscountPct'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [EndDate] >= [StartDate]', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'CONSTRAINT', N'CK_SpecialOffer_EndDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [MaxQty] >= (0)', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'CONSTRAINT', N'CK_SpecialOffer_MaxQty'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [MinQty] >= (0)', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'CONSTRAINT', N'CK_SpecialOffer_MinQty'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'CONSTRAINT', N'DF_SpecialOffer_DiscountPct'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0.0', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'CONSTRAINT', N'DF_SpecialOffer_MinQty'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'CONSTRAINT', N'DF_SpecialOffer_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'CONSTRAINT', N'DF_SpecialOffer_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'CONSTRAINT', N'PK_SpecialOffer_SpecialOfferID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'INDEX', N'AK_SpecialOffer_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', 'INDEX', N'PK_SpecialOffer_SpecialOfferID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOffer]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Sale discounts lookup table.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOffer', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Product identification number. Foreign key to Product.ProductID.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'COLUMN', N'ProductID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for SpecialOfferProduct records.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'COLUMN', N'SpecialOfferID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'CONSTRAINT', N'DF_SpecialOfferProduct_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'CONSTRAINT', N'DF_SpecialOfferProduct_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing Product.ProductID.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'CONSTRAINT', N'FK_SpecialOfferProduct_Product_ProductID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SpecialOffer.SpecialOfferID.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'CONSTRAINT', N'FK_SpecialOfferProduct_SpecialOffer_SpecialOfferID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'CONSTRAINT', N'PK_SpecialOfferProduct_SpecialOfferID_ProductID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'INDEX', N'AK_SpecialOfferProduct_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'INDEX', N'IX_SpecialOfferProduct_ProductID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', 'INDEX', N'PK_SpecialOfferProduct_SpecialOfferID_ProductID'
GO


Print 'Create Extended Property MS_Description on [Sales].[SpecialOfferProduct]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Cross-reference table mapping products to special offer discounts.', 'SCHEMA', N'Sales', 'TABLE', N'SpecialOfferProduct', NULL, NULL
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key. Foreign key to Customer.BusinessEntityID.', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'COLUMN', N'BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Demographic informationg about the store such as the number of employees, annual sales and store type.', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'COLUMN', N'Demographics'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'COLUMN', N'ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Name of the store.', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'COLUMN', N'Name'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'COLUMN', N'rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ID of the sales person assigned to the customer. Foreign key to SalesPerson.BusinessEntityID.', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'COLUMN', N'SalesPersonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'CONSTRAINT', N'DF_Store_ModifiedDate'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'CONSTRAINT', N'DF_Store_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing BusinessEntity.BusinessEntityID', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'CONSTRAINT', N'FK_Store_BusinessEntity_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing SalesPerson.SalesPersonID', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'CONSTRAINT', N'FK_Store_SalesPerson_SalesPersonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'CONSTRAINT', N'PK_Store_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'INDEX', N'AK_Store_rowguid'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Nonclustered index.', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'INDEX', N'IX_Store_SalesPersonID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'INDEX', N'PK_Store_BusinessEntityID'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary XML index.', 'SCHEMA', N'Sales', 'TABLE', N'Store', 'INDEX', N'PXML_Store_Demographics'
GO


Print 'Create Extended Property MS_Description on [Sales].[Store]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Customers (resellers) of Adventure Works products.', 'SCHEMA', N'Sales', 'TABLE', N'Store', NULL, NULL
GO


SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


Print 'Create Trigger [ddlDatabaseTriggerLog]'
GO
CREATE TRIGGER [ddlDatabaseTriggerLog] ON DATABASE 
FOR DDL_DATABASE_LEVEL_EVENTS AS 
BEGIN
    SET NOCOUNT ON;

    DECLARE @data XML;
    DECLARE @schema sysname;
    DECLARE @object sysname;
    DECLARE @eventType sysname;

    SET @data = EVENTDATA();
    SET @eventType = @data.value('(/EVENT_INSTANCE/EventType)[1]', 'sysname');
    SET @schema = @data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'sysname');
    SET @object = @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'sysname') 

    IF @object IS NOT NULL
        PRINT '  ' + @eventType + ' - ' + @schema + '.' + @object;
    ELSE
        PRINT '  ' + @eventType + ' - ' + @schema;

    IF @eventType IS NULL
        PRINT CONVERT(nvarchar(max), @data);

    INSERT [dbo].[DatabaseLog] 
        (
        [PostTime], 
        [DatabaseUser], 
        [Event], 
        [Schema], 
        [Object], 
        [TSQL], 
        [XmlEvent]
        ) 
    VALUES 
        (
        GETDATE(), 
        CONVERT(sysname, CURRENT_USER), 
        @eventType, 
        CONVERT(sysname, @schema), 
        CONVERT(sysname, @object), 
        @data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'nvarchar(max)'), 
        @data
        );
END;
GO


Print 'Create Extended Property MS_Description on [ddlDatabaseTriggerLog]'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Database trigger to audit all of the DDL changes made to the AdventureWorks 2012 database.', 'TRIGGER', N'ddlDatabaseTriggerLog', NULL, NULL, NULL, NULL
GO


Print 'Set Trigger [ddlDatabaseTriggerLog] To Disabled State'

GO


DISABLE TRIGGER [ddlDatabaseTriggerLog]
	ON DATABASE
GO


