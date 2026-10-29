---soal 1
SELECT 
    c.contactFirstName,
    c.customerName,
    o.city AS office_city,
    CONCAT(e.firstName, ' ', e.lastName) AS sales_rep_name
FROM 
    customers c
JOIN 
    employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN 
    offices o ON e.officeCode = o.officeCode
WHERE 
    c.contactFirstName ILIKE 'A%'
    AND o.city <> 'NYC'
ORDER BY 
    c.customerName ASC;

---soal 2
SELECT 
    c.customerName,
    SUM(p.amount) AS total_payment,
    MAX(p.amount) AS max_single_payment
FROM 
    customers c
JOIN 
    payments p ON c.customerNumber = p.customerNumber
GROUP BY 
    c.customerNumber, 
    c.customerName
HAVING 
    SUM(p.amount) > 50000
ORDER BY 
    total_payment DESC;



---soal 3
SELECT 
    c.customerName,
    COUNT(DISTINCT o.orderNumber) AS total_order,
    ROUND(AVG(od.quantityOrdered), 2) AS avg_quantity_per_order
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
GROUP BY 
    c.customerNumber, 
    c.customerName
HAVING 
    COUNT(DISTINCT o.orderNumber) > 3
    AND AVG(od.quantityOrdered) > 35
ORDER BY 
    total_order DESC, 
    avg_quantity_per_order DESC;


---soal 4
SELECT 
    p.productLine,
    SUM(od.quantityOrdered) AS total_terjual,
    ROUND(AVG(od.priceEach), 2) AS rata_rata_harga,
    ROUND(AVG(((p.MSRP - od.priceEach) / p.MSRP) * 100), 2) AS avg_discount_percentage
FROM 
    products p
JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.productLine
HAVING 
    SUM(od.quantityOrdered) > 3000
    AND AVG(od.priceEach) > 80
ORDER BY 
    total_terjual DESC;


---soal 5
SELECT 
    c.customerName,
    SUM(od.quantityOrdered * od.priceEach) AS total_transaksi,
    COUNT(DISTINCT o.orderNumber) AS total_shipped_orders,
    ROUND(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber), 2) AS avg_transaction_per_order
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
WHERE 
    o.status = 'Shipped'
GROUP BY 
    c.customerNumber, 
    c.customerName
HAVING 
    COUNT(DISTINCT EXTRACT(YEAR FROM o.orderDate)) > 1
ORDER BY 
    total_transaksi DESC
LIMIT 5;


---soal 6
SELECT 
    c.customerName,
    c.city AS customer_city,
    off.city AS office_city,
    SUM(od.quantityOrdered) AS total_unit_terjual,
    ROUND(SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber), 2) AS avg_nilai_per_order
FROM 
    customers c
JOIN 
    employees e ON c.salesRepEmployeeNumber = e.employeeNumber
JOIN 
    offices off ON e.officeCode = off.officeCode
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
WHERE 
    off.territory = 'EMEA'
GROUP BY 
    c.customerNumber, 
    c.customerName, 
    c.city, 
    off.city
HAVING 
    COUNT(DISTINCT EXTRACT(YEAR FROM o.orderDate)) > 2
    AND SUM(od.quantityOrdered) > 1000
    AND (SUM(od.quantityOrdered * od.priceEach) / COUNT(DISTINCT o.orderNumber)) > 10000
ORDER BY 
    avg_nilai_per_order DESC;


--soal tambahan 1
SELECT 
    CONCAT(e.firstName, ' ', e.lastName) AS sales_rep_name,
    COALESCE(STRING_AGG(DISTINCT c.customerName, ', '), 'Belum ada pelanggan') AS daftar_pelanggan,
    COALESCE(SUM(od.quantityOrdered), 0) AS total_barang,
    COALESCE(SUM(od.quantityOrdered * od.priceEach), 0) AS total_pendapatan
FROM 
    employees e
LEFT JOIN 
    customers c ON e.employeeNumber = c.salesRepEmployeeNumber
LEFT JOIN 
    orders o ON c.customerNumber = o.customerNumber
LEFT JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
WHERE 
    e.jobTitle = 'Sales Rep'
GROUP BY 
    e.employeeNumber, 
    e.firstName, 
    e.lastName
ORDER BY 
    total_pendapatan DESC;

--soal tambahan 2
SELECT 
    off.city AS office_city,
    COALESCE(STRING_AGG(DISTINCT CONCAT(e.firstName, ' ', e.lastName), ' - '), 'Belum ada karyawan') AS daftar_karyawan,
    COUNT(DISTINCT c.customerNumber) AS total_pelanggan
FROM 
    offices off
LEFT JOIN 
    employees e ON off.officeCode = e.officeCode
LEFT JOIN 
    customers c ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY 
    off.officeCode, 
    off.city
ORDER BY 
    total_pelanggan DESC;

--soal tambahan3
SELECT 
    c.customerName,
    COALESCE(STRING_AGG(DISTINCT p.productLine, ', '), 'Belum berbelanja') AS daftar_kategori_produk,
    COALESCE(SUM(od.quantityOrdered), 0) AS total_barang,
    COALESCE(SUM(od.quantityOrdered * od.priceEach), 0) AS total_pengeluaran
FROM 
    offices off
JOIN 
    employees e ON off.officeCode = e.officeCode
JOIN 
    customers c ON e.employeeNumber = c.salesRepEmployeeNumber
LEFT JOIN 
    orders o ON c.customerNumber = o.customerNumber
LEFT JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
LEFT JOIN 
    products p ON od.productCode = p.productCode
WHERE 
    off.city = 'Paris'
GROUP BY 
    c.customerNumber, 
    c.customerName
ORDER BY 
    total_pengeluaran DESC;