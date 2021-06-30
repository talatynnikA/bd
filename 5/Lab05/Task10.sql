USE [AD_Warehouse]
GO

SELECT *
FROM dbo.Deal
    FULL JOIN dbo.Products
    ON Deal.ProductName = Products.ProductName;

SELECT *
FROM dbo.Deal
    FULL JOIN dbo.Products
    ON Deal.ProductName = Products.ProductName
WHERE Products.ProductName IS NOT NULL;

