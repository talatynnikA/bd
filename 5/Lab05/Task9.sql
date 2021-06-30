USE [AD_Warehouse]
GO

SELECT *
FROM dbo.Products
    FULL JOIN dbo.Deal
    ON Deal.ProductName = Products.ProductName
ORDER BY Products.Price;

-- full
SELECT *
FROM dbo.Deal
    FULL JOIN dbo.Products
    ON Products.ProductName = Deal.ProductName
ORDER BY Products.Price;
-- like a full join
SELECT *
FROM dbo.Deal
    LEFT JOIN dbo.Products
    ON Products.ProductName = Deal.ProductName
UNION
SELECT *
FROM dbo.Deal
    RIGHT JOIN dbo.Products
    ON Products.ProductName = Deal.ProductName
ORDER BY Products.Price;

-- inner join
SELECT *
FROM dbo.Products
    INNER JOIN dbo.Deal
    ON Deal.ProductName = Products.ProductName
ORDER BY Products.Price;

-- like an inner join
SELECT *
FROM dbo.Products
    FULL JOIN dbo.Deal
    ON Deal.ProductName = Products.ProductName
WHERE Deal.ProductName IS NOT NULL
    AND Products.ProductName IS NOT NULL
ORDER BY Products.Price;
