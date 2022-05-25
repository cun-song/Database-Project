USE FlexPhone
--Simulasi proses transaksi staff membeli hp dengan vendor (Purchase Transaction)
--Staff yang bernama Tika dengan StaffID ST002 membeli Hp dengan Vendor bernama PT Mega Phone dengan VendorID VE015
--Staff tersebut membeli hp oppo A37 (PO003) sebanyak 7 buah dan samsung Galaxy S21 (PO001) sebanyaK 3 buah pada tanggal 10 januari 2022

BEGIN TRAN
INSERT INTO TrPurchase VALUES
('PH016', 'ST002', 'VE015', '2022-01-10');

INSERT INTO TrPurchaseDetail VALUES
('PH016', 'PO003', 7),
('PH016', 'PO001', 3);

COMMIT --jika transaksi sukses

-- ROLLBACK jika transaksi di cancel

-------------------------------------------------------------------------------------------------------------------

--Simulasi proses transaksi Customer Membeli hp dengan Staff (Sales Transaction)
--Apabila customer baru maka wajib melengkapi data diri
INSERT INTO MsCustomer VALUES
('CU016', 'Ani Nurhayani', 'AniNurhayani@sunib.edu', '1998-10-11', 'Female', '087266257168', 'Jl. Pandugo no. 11');	

-- Selanjutnya customer dapat memilih hp apa yang ingin mereka beli
--pada contoh ini, Ani Nurhayani (CU016) ingin membeli HP Huawei P30 (PO008) 1 buah dan HP Realme Narzo 20 (PO009) 1 buah Pada tanggal 11 januari 2022
-- transaksi pembelian HP ani dilayani staff yang bernama Bayu (ST004)

BEGIN TRAN
INSERT INTO TrSales VALUES
('SH016', 'ST004', 'CU016', '2022-01-11');
INSERT INTO TrSalesdetail VALUES
('SH016', 'PO008', 1),
('SH016', 'PO009', 1);

COMMIT --jika transaksi sukses

-- ROLLBACK jika transaksi di cancel


