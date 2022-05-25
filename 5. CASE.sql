USE FlexPhone

--1
SELECT CONCAT('Customer ',RIGHT(ts.CustomerID,1))[ID],CustomerName,CustomerGender,SUM(SalesQuantity*PhonePrice)[Total Spending]
FROM TrSales ts JOIN MsCustomer mc ON mc.CustomerID = ts.CustomerID
JOIN TrSalesdetail tsd ON ts.SalesID = tsd.SalesID
JOIN MsPhone mp ON mp.PhoneID = tsd.PhoneID
GROUP BY ts.CustomerID, CustomerName, CustomerGender

--2
SELECT ts.StaffID[Staff ID], left(StaffName,charindex(' ',StaffName))[Name], COUNT(ts.CustomerID)[Customer Count]
FROM TrSales ts JOIN MsStaff ms ON ts.StaffID = ms.StaffID
WHERE StaffName LIKE '% %'
GROUP BY ts.StaffID, StaffName

--3
SELECT CONCAT('Customer ',RIGHT(ts.CustomerID,1))[Customer ID], CustomerName,BrandName[Phone Brand],SUM(PhonePrice*SalesQuantity)[Total Spending]
FROM MsBrand mb
JOIN MsPhone mp ON mb.BrandID = mp.BrandID
JOIN TrSalesdetail tsd ON mp.PhoneID = tsd.PhoneID
JOIN TrSales ts ON tsd.SalesID = ts.SalesID
JOIN MsCustomer mc ON mc.CustomerID = ts.CustomerID,(
	SELECT CustomerID, COUNT(tsd.SalesID)[coun]
	FROM TrSales ts
	JOIN TrSalesdetail tsd ON ts.SalesID = tsd.SalesID
	GROUP BY CustomerID
)c
WHERE CustomerName LIKE '% %' AND ts.CustomerID = c.CustomerID AND c.coun >3
GROUP BY ts.CustomerID, CustomerName,BrandName


--4
SELECT ts.StaffID[Staff ID], left(StaffEmail,charindex('@',StaffEmail))+'Ymail.com'[Email], BrandName[phone brand], SUM(PhonePrice*SalesQuantity)[total selling]
FROM TrSales ts 
JOIN TrSalesdetail tsd ON ts.SalesID = tsd.SalesID
JOIN MsStaff ms ON ms.StaffID = ts.StaffID
JOIN MsPhone mp ON mp.PhoneID = tsd.PhoneID
JOIN MsBrand mb ON mb.BrandID = mp.BrandID,(
	SELECT StaffID, COUNT(tsd.SalesID)[coun]
	FROM TrSales ts
	JOIN TrSalesdetail tsd ON ts.SalesID = tsd.SalesID
	GROUP BY StaffID
)c
WHERE c.StaffID = ts.StaffID AND c.coun > 2
GROUP BY ts.StaffID, StaffEmail,BrandName
ORDER BY (ts.StaffID) ASC

--5
SELECT StaffEmail[Staff Email],StaffGender[Staff Gender],CONVERT(VARCHAR,StaffDOB,106)[Date of Birth],CONCAT('Rp.',StaffSalary,',00.')[Salary]
FROM MsStaff,(
	SELECT 'avg' = AVG(StaffSalary)
	FROM MsStaff
)sub
WHERE StaffSalary > sub.avg AND 2022 - YEAR(StaffDOB) >= 30

--6 
SELECT ms.StaffID, StaffName,REPLACE(StaffPhoneNumber, LEFT(StaffPhoneNumber, 2), '+62')[StaffPhone],CONCAT('Rp.',[Total Selling],',00.')[Total Selling]
FROM MsStaff ms,(
	SELECT StaffID,SUM(PhonePrice*SalesQuantity) [Total Selling]
	FROM TrSales ts 
	JOIN TrSalesdetail tsd ON ts.SalesID = tsd.SalesID
	JOIN MsPhone mp ON mp.PhoneID = tsd.PhoneID
	GROUP BY StaffID
)sub
WHERE StaffGender = 'Male' AND sub.StaffID = ms.StaffID AND sub.[Total Selling] BETWEEN 10000000 AND 100000000 
GROUP BY ms.StaffID, StaffName, StaffPhoneNumber,[Total Selling]

--7
SELECT 'Staff No '+ RIGHT(ts.StaffID,1)[Staff No], StaffName,left(StaffEmail,charindex('@',StaffEmail))+'gmail.com'[Email],CONVERT(VARCHAR,StaffDOB,103)[Date of Birth],[Customer Count]
FROM MsStaff ms JOIN TrSales ts ON ms.StaffID = ts.StaffID,(
	SELECT StaffID, COUNT(CustomerID) [Customer Count]
	FROM TrSales
	GROUP BY StaffID
	)x,(
		SELECT 'maxcus'= MAX([Customer Count])
		FROM(
		SELECT COUNT(CustomerID) [Customer Count]
		FROM TrSales
		GROUP BY StaffID
		)ab
	)y
WHERE x.StaffID = ts.StaffID AND x.[Customer Count] = y.maxcus
Group by ts.StaffID, StaffName, StaffEmail,StaffDOB,[Customer Count]

--8
SELECT mb.BrandID[PhoneBrandID], BrandName[PhoneBrand], ts.CustomerID, CustomerName,CustomerEmail,[Qty]
FROM MsBrand mb
JOIN MsPhone mp ON mb.BrandID = mp.BrandID
JOIN TrSalesdetail tsd ON mp.PhoneID = tsd.PhoneID
JOIN TrSales ts ON tsd.SalesID = ts.SalesID
JOIN MsCustomer mc ON mc.CustomerID = ts.CustomerID,(
	SELECT mb.BrandID,ts.CustomerID,SUM(SalesQuantity)[Qty]
	FROM MsBrand mb
	JOIN MsPhone mp ON mb.BrandID = mp.BrandID
	JOIN TrSalesdetail tsd ON mp.PhoneID = tsd.PhoneID
	JOIN TrSales ts ON tsd.SalesID = ts.SalesID
	GROUP BY mb.BrandID, ts.CustomerID
)x,(
	SELECT BrandID,MAX(Qty)[maks]
	FROM(
		SELECT mb.BrandID,ts.CustomerID,SUM(SalesQuantity)[Qty]
		FROM MsBrand mb
		JOIN MsPhone mp ON mb.BrandID = mp.BrandID
		JOIN TrSalesdetail tsd ON mp.PhoneID = tsd.PhoneID
		JOIN TrSales ts ON tsd.SalesID = ts.SalesID
		GROUP BY mb.BrandID, ts.CustomerID
	)x
	GROUP BY BrandID
)y
WHERE x.BrandID = mb.BrandID AND ts.CustomerID = x.CustomerID AND y.BrandID = mb.BrandID AND y.maks = x.Qty AND CustomerEmail LIKE '%bluejack.com' AND RIGHT(ts.CustomerID,1) % 2 = 0
GROUP BY mb.BrandID, BrandName, ts.CustomerID, CustomerName,CustomerEmail,[Qty]
ORDER BY mb.BrandID ASC
 
 --9
CREATE VIEW Vendor_Brand_Transaction_View
AS
SELECT 'Vendor '+RIGHT(tp.VendorID,1)[VendorID], VendorName, REPLACE(VendorPhoneNumber, LEFT(VendorPhoneNumber, 2), '+62')[Phone Number], BrandName, COUNT(tpd.PurchaseID)[Transaction Count], SUM(mp.PhonePrice*tpd.PurchaseQuantity)[Total Transaction]
FROM TrPurchase tp JOIN TrPurchaseDetail tpd ON tp.PurchaseID = tpd.PurchaseID
JOIN MsVendor mv ON mv.VendorID = tp.VendorID
JOIN MsPhone mp ON mp.PhoneID = tpd.PhoneID
JOIN MsBrand mb ON  mb.BrandID = mp.BrandID
GROUP BY tp.VendorID, VendorName, VendorPhoneNumber, BrandName

SELECT * FROM Vendor_Brand_Transaction_View

--10 Staff_Selling_View
CREATE VIEW Staff_Selling_View
AS
SELECT ts.StaffID,StaffName,CONCAT(SUM(tsd.SalesQuantity),' pc(s)')[Sold Phone Count],CONCAT('Rp.',SUM(mp.PhonePrice*tsd.SalesQuantity),',00.')[Total Transaction],COUNT(mp.BrandID)[Count Brand]
FROM TrSales ts 
JOIN TrSalesdetail tsd ON ts.SalesID = tsd.SalesID
JOIN MsStaff ms ON ms.StaffID = ts.StaffID
JOIN MsPhone mp ON mp.PhoneID = tsd.PhoneID
WHERE StaffEmail LIKE '%@bluejack.com'
GROUP BY ts.StaffID,StaffName

SELECT * FROM Staff_Selling_View
