/*Identifying Products with High inventory and low sales*/
select
productCode,
productName,
quantityInStock,
totalOrdered,
(quantityInStock-totalOrdered)AS inventoryShortage
from
(
select
p.productCode,
p.productName,
P.quantityInStock,
sum(od.quantityOrdered)as totalOrdered
from
mintclassics.products as p
left join
mintclassics.orderdetails as od on p.productCode=od.productCode
group by
p.productCode,
p.productName,
p.quantityInStock
)as inventory_data
where
(quantityInStock-totalOrdered)>0
order by
inventoryShortage desc;
/*Total inventory of product in each warehouse*/
select 
p.productName,
w.warehouseName,
sum(p.quantityInStock)AS totalInventory
from
mintclassics.products as p
join
mintclassics.warehouses as w on p.warehouseCode=w.warehouseCode
group by
p.productName,w.warehouseName
order by
totalInventory asc
/*Product in each Warehouse*/

select 
w.warehouseCode,
w.warehouseName,
sum(p.quantityInStock)As totalInventory
from
mintclassics.warehouses as w
left join
mintclassics.products as p on w.warehouseCode=p.warehouseCode
group by
w.warehouseCode,
w.warehouseName
order by
totalInventory desc

select
e.employeeNumber,
e.lastName,
e.firstName,
e.jobTitle,
sum(od.priceEach*od.quantityOrdered)as totalSales
from
mintclassics.employees as e
left join mintclassics.customers as c on e.employeeNumber=c.salesRepEmployeeNumber
left join mintclassics.orders as o on c.customerNumber=o.customerNumber
left join mintclassics.orderdetails as od on o.orderNumber=od.orderNumber
group by
e.employeeNumber,e.lastName,e.firstName,e.jobTitle
order by
totalSales desc

select
c.customerNumber,
c.customerName,
p.paymentDate,
p.amount as paymentAmount
from
mintclassics.customers as c
left join
mintclassics.payments as p on c.customerNumber=p.customerNumber
order by
paymentAmount desc

SELECT
    p.productLine,
    pl.textDescription AS productLineDescription,
    SUM(p.quantityInStock) AS totalInventory,
    SUM(od.quantityOrdered) AS totalSales,
    SUM(od.priceEach * od.quantityOrdered) AS totalRevenue,
    (SUM(od.quantityOrdered) / SUM(p.quantityInStock)) * 100 AS salesToInventoryPercentage
FROM
    mintclassics.products AS p
LEFT JOIN
    mintclassics.productlines AS pl ON p.productLine = pl.productLine
LEFT JOIN
    mintclassics.orderdetails AS od ON p.productCode = od.productCode
GROUP BY
    p.productLine, pl.textDescription
ORDER BY
	salesToInventoryPercentage desc
    
SELECT
    c.customerNumber,
    c.customerName,
    c.creditLimit,
    SUM(p.amount) AS totalPayments,
    (SUM(p.amount) - c.creditLimit) AS creditLimitDifference
FROM
    mintclassics.customers AS c
LEFT JOIN
    mintclassics.payments AS p ON c.customerNumber = p.customerNumber
GROUP BY
    c.customerNumber, c.creditLimit
HAVING
    SUM(p.amount) < c.creditLimit
ORDER BY
	totalPayments asc