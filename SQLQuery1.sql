IF OBJECT_ID('customers', 'U') IS NOT NULL
DROP TABLE customers;

IF OBJECT_ID('customers', 'U') IS NULL
CREATE TABLE customers (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(50) NOT NULL,
    address TEXT NOT NULL,
    phone NVARCHAR(15) NOT NULL,
    email NVARCHAR(50) NOT NULL
);

SELECT * FROM customers;
GO

IF OBJECT_ID('products', 'U') IS NOT NULL
DROP TABLE products;

IF OBJECT_ID('products', 'U') IS NULL
CREATE TABLE products (
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(50) NOT NULL,
    description TEXT NOT NULL,
    price FLOAT NOT NULL,
    stock_quantity INT NOT NULL
);

SELECT * FROM products;
GO

IF OBJECT_ID('invoices', 'U') IS NOT NULL
DROP TABLE invoices;

IF OBJECT_ID('invoices', 'U') IS NULL
CREATE TABLE invoices (
    id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT,
    date DATETIME NOT NULL,
    total_amount FLOAT NOT NULL,
    status NVARCHAR(20) NOT NULL DEFAULT 'PENDIGN' ,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

SELECT * FROM invoices;
GO

IF OBJECT_ID('invoice_items', 'U') IS NOT NULL
DROP TABLE invoice_items;

IF OBJECT_ID('invoice_items', 'U') IS NULL
CREATE TABLE invoice_items (
    id INT PRIMARY KEY IDENTITY(1,1),
    invoice_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price FLOAT NOT NULL,
    FOREIGN KEY (invoice_id) REFERENCES invoices(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

SELECT * FROM invoice_items;
GO

-- ======================================================= PROCEDURES ===============================================

IF OBJECT_ID('create_customer', 'P') IS NOT NULL
    DROP PROCEDURE create_customer;
IF OBJECT_ID('update_customer', 'P') IS NOT NULL
    DROP PROCEDURE update_customer;
IF OBJECT_ID('delete_customer', 'P') IS NOT NULL
    DROP PROCEDURE delete_customer;
IF OBJECT_ID('create_product', 'P') IS NOT NULL
    DROP PROCEDURE create_product;
IF OBJECT_ID('update_product', 'P') IS NOT NULL
    DROP PROCEDURE update_product;
IF OBJECT_ID('delete_product', 'P') IS NOT NULL
    DROP PROCEDURE delete_product;
IF OBJECT_ID('create_invoice', 'P') IS NOT NULL
    DROP PROCEDURE create_invoice;
IF OBJECT_ID('update_invoice', 'P') IS NOT NULL
    DROP PROCEDURE update_invoice;
IF OBJECT_ID('delete_invoice', 'P') IS NOT NULL
    DROP PROCEDURE delete_invoice;
IF OBJECT_ID('create_invoice_item', 'P') IS NOT NULL
    DROP PROCEDURE create_invoice_item;
IF OBJECT_ID('update_invoice_item', 'P') IS NOT NULL
    DROP PROCEDURE update_invoice_item;
IF OBJECT_ID('delete_invoice_item', 'P') IS NOT NULL
    DROP PROCEDURE delete_invoice_item;
GO


SELECT name, 
       type
  FROM dbo.sysobjects
 WHERE (type = 'P');
 GO

-- CRUD OPERATION ON customer TABLE



CREATE PROCEDURE create_customer
    @name NVARCHAR(50),
    @address TEXT,
    @phone NVARCHAR(15),
    @email NVARCHAR(50),
    @success BIT OUTPUT,
    @msg TEXT OUTPUT
AS
BEGIN
    BEGIN TRY
        INSERT INTO customers (name, address, phone, email) 
        VALUES (@name, @address, @phone, @email);
        
        SET @success = 1;
        SET @msg = '';
    END TRY
    BEGIN CATCH
        SET @success = 0;
        SET @msg = ERROR_MESSAGE();
    END CATCH
END;
GO


CREATE PROCEDURE update_customer
    @id INT,
    @name NVARCHAR(50),
    @address TEXT,
    @phone NVARCHAR(15),
    @email NVARCHAR(50),
    @success BIT OUTPUT,
    @msg TEXT OUTPUT
AS
BEGIN
    BEGIN TRY
        UPDATE customers
        SET 
            name = @name, 
            address = @address, 
            phone = @phone,
            email = @email
        WHERE id = @id;
        
        SET @success = 1;
        SET @msg = '';
    END TRY
    BEGIN CATCH
        SET @success = 0;
        SET @msg = ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE delete_customer
    @id INT,
    @success BIT OUTPUT,
    @msg TEXT OUTPUT
AS
BEGIN
    BEGIN TRY
        DELETE FROM customers WHERE id = @id;
        
        SET @success = 1;
        SET @msg = '';
    END TRY
    BEGIN CATCH
        SET @success = 0;
        SET @msg = ERROR_MESSAGE();
    END CATCH
END;
GO


CREATE PROCEDURE create_product
    @name NVARCHAR(50),
    @description TEXT,
    @price FLOAT,
    @stock_quantity INT,
    @success BIT OUTPUT,
    @msg TEXT OUTPUT
AS
BEGIN
    BEGIN TRY
        INSERT INTO products (name, description, price, stock_quantity) 
        VALUES (@name, @description, @price, @stock_quantity);
        
        SET @success = 1;
        SET @msg = '';
    END TRY
    BEGIN CATCH
        SET @success = 0;
        SET @msg = ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE update_product
    @id INT,
    @name NVARCHAR(50),
    @description TEXT,
    @price FLOAT,
    @stock_quantity INT,
    @success BIT OUTPUT,
    @msg TEXT OUTPUT
AS
BEGIN
    BEGIN TRY
        UPDATE products 
        SET
            name = @name, 
            description = @description, 
            price = @price, 
            stock_quantity = @stock_quantity
        WHERE id = @id;
        SET @msg = '';
        SET @success = 1;

    END TRY
    BEGIN CATCH
        SET @success = 0;
        SET @msg = ERROR_MESSAGE();
    END CATCH
END;
GO

CREATE PROCEDURE delete_product
    @id INT,
    @success BIT OUTPUT,
    @msg TEXT OUTPUT
AS
BEGIN
    BEGIN TRY
        DELETE FROM products WHERE id = @id;
        
        SET @success = 1;
        SET @msg = '';
    END TRY
    BEGIN CATCH
        SET @success = 0;
        SET @msg = ERROR_MESSAGE();
    END CATCH
END;
GO


CREATE PROCEDURE create_invoice
    @customer_id INT,
    @date DATETIME,
    @total_amount FLOAT,
    @status NVARCHAR(20),
    @success BIT OUTPUT,
    @msg TEXT OUTPUT
AS
BEGIN
    BEGIN TRY
        INSERT INTO invoices (customer_id, date, total_amount, status) 
        VALUES (@customer_id, @date, @total_amount, @status);
        SET @success = 1;
        SET @msg = '';
    END TRY
    BEGIN CATCH
        SET @success = 0;
        SET @msg = ERROR_MESSAGE();
    END CATCH
END;
GO

-- onlly invoice with 
CREATE PROCEDURE update_invoice
    @id INT,
    @customer_id INT,
    @date DATETIME,
    @total_amount FLOAT,
    @status NVARCHAR(20),
    @success BIT OUTPUT
AS
BEGIN
    BEGIN TRY
        UPDATE invoices 
        SET
            customer_id = @customer_id, 
            date = @date, 
            total_amount = @total_amount, 
            status = @status
        WHERE id = @id;
        
        SET @success = 1;
    END TRY
    BEGIN CATCH
        SET @success = 0;
    END CATCH
END;
GO


-- USER CAN ONLY DELETE THE 'PENDIGN' invoices
CREATE PROCEDURE delete_invoice
    @id INT,
    @success BIT OUTPUT,
    @msg TEXT OUTPUT
AS
BEGIN
    BEGIN TRY
        DELETE FROM invoices WHERE id = @id AND status = 'PENDIGN';
        
        SET @success = 1;
        SET @msg = '';
    END TRY
    BEGIN CATCH
        SET @success = 0;
        SET @msg = ERROR_MESSAGE();
    END CATCH
END;
GO


CREATE PROCEDURE create_invoice_item
    @invoice_id INT,
    @product_id INT,
    @quantity INT,
    @unit_price FLOAT,
    @success BIT OUTPUT,
    @msg TEXT OUTPUT
AS
BEGIN
    DECLARE @current_stock INT;
    BEGIN TRY
        SELECT @current_stock = stock_quantity FROM products WHERE id = @product_id;

        IF @current_stock >= @quantity
        BEGIN
            INSERT INTO invoice_items (invoice_id, product_id, quantity, unit_price) 
            VALUES (@invoice_id, @product_id, @quantity, @unit_price);
            UPDATE products SET stock_quantity = stock_quantity - @quantity WHERE id = @product_id;
            SET @success = 1;
            SET @msg = '';
        END
        ELSE
        BEGIN
            SET @success = 0;
            SET @msg = ERROR_MESSAGE();
        END
    END TRY
    BEGIN CATCH
        SET @success = 0;
        SET @msg = ERROR_MESSAGE();
    END CATCH
END;
GO


CREATE PROCEDURE update_invoice_item
    @id INT,
    @invoice_id INT,
    @product_id INT,
    @quantity INT,
    @unit_price FLOAT,
    @success BIT OUTPUT,
    @msg TEXT OUTPUT
    
AS
BEGIN
    DECLARE @current_stock INT;
    DECLARE @original_quantity INT;

    BEGIN TRY
        DECLARE @item_status NVARCHAR(22);

        SELECT @item_status = status FROM invoices WHERE id = @invoice_id;

        IF (@item_status = 'PENDING')
        BEGIN
            SELECT @original_quantity = quantity FROM invoice_items WHERE id = @id;
            
            SELECT @current_stock = stock_quantity FROM products WHERE id = @product_id;

            DECLARE @new_stock INT = @current_stock + @original_quantity - @quantity;

            IF @new_stock >= 0
            BEGIN
                UPDATE invoice_items 
                SET
                    invoice_id = @invoice_id, 
                    product_id = @product_id, 
                    quantity = @quantity, 
                    unit_price = @unit_price
                WHERE id = @id;

                UPDATE products SET stock_quantity = @new_stock WHERE id = @product_id;

                SET @success = 1;
                SET @msg = '';
            END
            ELSE
            BEGIN
                SET @success = 0;
                SET @msg = ERROR_MESSAGE();
            END
        END
        ELSE
        BEGIN
            SET @success = 0;
            SET @msg = ERROR_MESSAGE();
        END
    END TRY
    BEGIN CATCH
        SET @success = 0;
        SET @msg = ERROR_MESSAGE();
    END CATCH
END;
GO


CREATE PROCEDURE delete_invoice_item
    @id INT,
    @success BIT OUTPUT,
    @msg TEXT OUTPUT
AS
BEGIN
    BEGIN TRY
        DECLARE @item_status NVARCHAR(22);
        DECLARE @invoice_id INT;

        SELECT @invoice_id = invoice_id FROM invoice_items WHERE id = @id;
        SELECT @item_status = status FROM invoices WHERE id = @invoice_id;

        IF (@item_status = 'PENDING')
            BEGIN
                DELETE FROM invoice_items WHERE id = @id;
                SET @success = 1;
                SET @msg = '';
            END
        ELSE
            BEGIN
                SET @success = 0;
                SET @msg = ERROR_MESSAGE();
            END
    END TRY
    BEGIN CATCH
        SET @success = 0;
        SET @msg = ERROR_MESSAGE();
    END CATCH
END;
GO



INSERT INTO customers (name, address, phone, email) VALUES 
('Ali Ahmadi', 'Tehran, Iran', '09121234567', 'ali.ahmadi@example.com'),
('Sara Moradi', 'Mashhad, Iran', '09123456789', 'sara.moradi@example.com'),
('Reza Hosseini', 'Shiraz, Iran', '09129876543', 'reza.hosseini@example.com');


INSERT INTO products (name, description, price, stock_quantity) VALUES 
('Laptop', 'High-end gaming laptop', 1500.00, 10),
('Smartphone', 'Latest model smartphone', 800.00, 25),
('Headphones', 'Noise-cancelling headphones', 200.00, 50);


INSERT INTO invoices (customer_id, date, total_amount, status) VALUES 
(1, '2025-01-01 14:30:00', 1500.00, 'PENDING'),
(2, '2025-01-02 10:15:00', 800.00, 'PAID'),
(3, '2025-01-03 09:00:00', 200.00, 'CANCELLED');


INSERT INTO invoice_items (invoice_id, product_id, quantity, unit_price) VALUES 
(1, 1, 1, 1500.00),
(2, 2, 1, 800.00),
(3, 3, 1, 200.00);

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM invoices;
SELECT * FROM invoice_items;
