-- TRANSACTION & ROLLBACK

START TRANSACTION;

-- Step 1: Insert new customer
INSERT INTO customer (nama_customer, alamat_customer, email_customer) 
VALUES ('John Doe', '123 Main St', 'john.doe@example.com');

-- Step 2: Insert corresponding order with a complex subquery
INSERT INTO pemesanan (tanggal_pemesanan, id_customer, id_hewan, id_pakan) 
VALUES (CURDATE(), LAST_INSERT_ID(), 
        (SELECT id_hewan FROM Hewan WHERE jenis_hewan = 'Dog' ORDER BY RAND() LIMIT 1),
        (SELECT id_pakan FROM Pakan_Hewan WHERE tipe_pakan = 'Premium' ORDER BY stok_pakan DESC LIMIT 1)
);

COMMIT; -- If all steps are successful
-- ROLLBACK; -- Uncomment this line to simulate a failure (e.g., duplicate email in Step 1)

-- VIEW

CREATE VIEW CustomerOrderView AS
SELECT 
    customer.id_customer,
    customer.nama_customer,
    customer.alamat_customer,
    customer.email_customer,
    pemesanan.id_pemesanan,
    pakan.tanggal_pemesanan,
    hewan.jenis_hewan,
    pakan_hewan.tipe_pakan
FROM customer
JOIN pemesanan ON customer.id_customer = pemesanan.id_customer
JOIN hewan ON pemesanan.id_hewan = hewan.id_hewan
JOIN pakan_hewan ON pakan_hewan.id_pakan = pakan_hewan.id_pakan
WHERE hewan.stok_hewan > 0
ORDER BY pemesanan.tanggal_pemesanan DESC;

-- STORED PROCEDURE

DELIMITER //
CREATE PROCEDURE UpdateStockAnimalType(IN animal_type VARCHAR(256), IN new_stock VARCHAR(256))
BEGIN
    UPDATE hewan
    SET stok_hewan = new_stock
    WHERE jenis_hewan = animal_type
    AND stok_hewan > 0;
END //
DELIMITER ;

-- Example usage:
-- CALL UpdateStockAnimalType('Dog', '50');

-- STORED FUNCTION

DELIMITER //
CREATE FUNCTION CalculateOrderTotalCost(order_id INT(11)) RETURNS INT(11)
BEGIN
    DECLARE totalCost INT(11);

    SELECT 
        (hewan.harga_hewan + pakan_hewan.harga_satuan_pakan) AS total
    INTO totalCost
    FROM pemesanan
    JOIN hewan ON pemesanan.id_hewan = hewan.id_hewan
    JOIN pakan_hewan ON pemesanan.id_pakan = pakan_hewan.id_pakan
    WHERE pemesanan.id_pemesanan = order_id
    GROUP BY pemesanan.id_pemesanan
    HAVING totalCost > 0;

    RETURN totalCost;
END //
DELIMITER ;

-- Example usage:
-- SELECT CalculateOrderTotalCost(1) AS totalCost;

-- TRIGGER

CREATE TRIGGER UpdateStockOnOrder
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


