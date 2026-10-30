--soal 1
SELECT 
    productCode,
    productName,
    MSRP,
    quantityInStock,
    CASE 
        WHEN MSRP < 50 AND quantityInStock > 500 
			THEN 'Ekonomis - Stok Tinggi'
        WHEN MSRP < 50 AND quantityInStock <= 500 
			THEN 'Ekonomis - Stok Rendah'
        WHEN MSRP BETWEEN 50 AND 100 
			THEN 'Harga Menengah'
        WHEN MSRP > 100 
			THEN 'Harga Premium'
    END AS kategori_produk
FROM products
ORDER BY MSRP DESC;

--soal 2
SELECT 
    productCode,
    SUM(quantityOrdered) AS total_unit_terjual,
    COUNT(DISTINCT orderNumber) AS jumlah_pesanan
FROM orderdetails
GROUP BY productCode
HAVING SUM(quantityOrdered) > (
    SELECT AVG(quantityOrdered) 
    FROM orderdetails
)
AND COUNT(DISTINCT orderNumber) > 10
ORDER BY total_unit_terjual DESC;

--soal 3
SELECT 
    productCode,
    productName,
    quantityInStock,
    MSRP
FROM products
WHERE quantityInStock > (
    SELECT AVG(quantityInStock) 
    FROM products
)
AND MSRP > (
    SELECT AVG(MSRP) 
    FROM products
)
ORDER BY quantityInStock DESC;

--soal 4
BEGIN;

UPDATE orders
SET status = 'Pengiriman'
WHERE orderNumber = 10100;

SAVEPOINT status_pengiriman;

UPDATE orders
SET status = 'Batal'
WHERE orderNumber = 10100;

ROLLBACK TO SAVEPOINT status_pengiriman;

COMMIT;

--soal 5
CREATE TABLE anggota (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nama_anggota VARCHAR(50) NOT NULL,
    kota_domisili VARCHAR(20) NOT NULL
);

CREATE TABLE buku (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    judul_buku VARCHAR(100) NOT NULL,
    genre VARCHAR(20) NOT NULL,
    stok INTEGER DEFAULT 1
);

CREATE TABLE peminjaman (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_anggota INTEGER NOT NULL,
    id_buku INTEGER NOT NULL,
    tanggal_pinjam DATE NOT NULL,
    tanggal_kembali DATE NULL,
    denda INTEGER DEFAULT 0,
    FOREIGN KEY (id_anggota) REFERENCES anggota(id),
    FOREIGN KEY (id_buku) REFERENCES buku(id)
);

CREATE INDEX idx_buku_genre ON buku(genre);
CREATE INDEX idx_anggota_kota_domisili ON anggota(kota_domisili);


--soal Tambahan no 3
SELECT 
    productCode,
    productName,
    productLine,
    buyPrice
FROM products
WHERE productLine = 'Classic Cars'
  AND buyPrice > ANY (
      SELECT buyPrice
      FROM products
      WHERE productLine = 'Vintage Cars'
  )
ORDER BY buyPrice DESC;