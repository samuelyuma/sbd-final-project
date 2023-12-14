-- TRANSACTION & ROLLBACK

START TRANSACTION;

-- Step 1: Insert new customer
INSERT INTO customer (nama_customer, alamat_customer, email_customer) 
VALUES ('Yuma', 'Keputih Perintis', 'yuma@example.com');

-- Step 2: Insert corresponding order with a complex subquery
INSERT INTO pemesanan (tanggal_pemesanan, id_customer, id_hewan, id_pakan) 
VALUES (CURDATE(), LAST_INSERT_ID(), 
        (SELECT id_hewan FROM Hewan WHERE jenis_hewan = 'Mutant' ORDER BY RAND() LIMIT 1),
        (SELECT id_pakan FROM Pakan_Hewan WHERE tipe_pakan = 'Tulang' ORDER BY stok_pakan DESC LIMIT 1)
);

COMMIT; -- If all steps are successful
-- ROLLBACK; -- Uncomment this line to simulate a failure (e.g., duplicate email in Step 1)

-- VIEW

CREATE VIEW TampilkanPesananPelanggan AS
SELECT 
    customer.id_customer AS 'ID Customer',
    customer.nama_customer AS 'Nama Customer',
    customer.alamat_customer AS 'Alamat Customer',
    customer.email_customer AS 'Email Customer',
    pemesanan.id_pemesanan AS 'ID Pemesanan',
    pemesanan.tanggal_pemesanan AS 'Tanggal Pemesanan',
    hewan.jenis_hewan AS 'Jenis Hewan',
    pakan_hewan.tipe_pakan AS 'Tipe Pakan',
    COUNT(pemesanan.id_pemesanan) AS 'Jumlah Pesanan'
FROM customer
JOIN pemesanan ON customer.id_customer = pemesanan.id_customer
JOIN hewan ON pemesanan.id_hewan = hewan.id_hewan
JOIN pakan_hewan ON pakan_hewan.id_pakan = pakan_hewan.id_pakan
WHERE hewan.stok_hewan > 0
GROUP BY customer.id_customer, hewan.jenis_hewan
HAVING COUNT(pemesanan.id_pemesanan) > 1
ORDER BY pemesanan.tanggal_pemesanan DESC;

-- Example usage:
-- SELECT * FROM TampilkanPesananPelanggan LIMIT 10;

-- STORED PROCEDURE

DELIMITER //
CREATE PROCEDURE UpdateStokHewan(IN animal_type VARCHAR(256), IN new_stock VARCHAR(256))
BEGIN
    UPDATE hewan
    SET stok_hewan = new_stock
    WHERE tipe_hewan = animal_type
    AND stok_hewan > 0;
END //
DELIMITER ;

-- Example usage:
-- CALL UpdateStokHewan('Bulldog', '50');

-- STORED FUNCTION

DELIMITER //
CREATE FUNCTION TotalPembayaran(id_customer INT) RETURNS VARCHAR(256)
BEGIN
    DECLARE total_and_name VARCHAR(256);
    SELECT 
        CONCAT('Nama: ', customer.nama_customer, ', Total Pembayaran: ', SUM(pembayaran.jumlah_pembayaran), ) INTO total_and_name
    FROM pembayaran
    JOIN pemesanan ON pembayaran.id_pemesanan = pemesanan.id_pemesanan
    JOIN customer ON pemesanan.id_customer = customer.id_customer
    WHERE pemesanan.id_customer = id_customer;
    RETURN total_and_name;
END //
DELIMITER ;

-- Example usage:
-- SELECT * FROM DetailTotalPembayaran(1);

-- TRIGGER

CREATE TRIGGER KurangiStokHewanDanPakan
AFTER INSERT ON pemesanan
FOR EACH ROW
BEGIN
    UPDATE hewan
    SET stok_hewan = stok_hewan - 1
    WHERE id_hewan = NEW.id_hewan AND stok_hewan > 0;

    UPDATE pakan_hewan
    SET stok_pakan = stok_pakan - 1
    WHERE id_pakan = NEW.id_pakan AND stok_pakan > 0;
END;


