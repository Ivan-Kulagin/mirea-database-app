DROP TABLE SupplyRequests;
CREATE TABLE SupplyRequests
(
    request_id           INTEGER PRIMARY KEY auto_increment,
    customer_id          INTEGER NOT NULL,
    order_time           DATETIME NULL,
    requested_count      INTEGER NULL,
    keyboard_id          INTEGER NOT NULL,
    worker_id            INTEGER NOT NULL
);

DROP FUNCTION GetOrderPrice;

DELIMITER //
CREATE FUNCTION db.GetOrderPrice (request_id INT) RETURNS INT
	BEGIN
    RETURN request_id;
END //
DELIMITER ;

SELECT db.GetOrderPrice(4) as OrderTotal;
