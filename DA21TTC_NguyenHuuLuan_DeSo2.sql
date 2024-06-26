Create database DA21TTC_NguyenHuuLuan_DeSo2
go
use DA21TTC_NguyenHuuLuan_DeSo2
go

create table HANGHOA(
	Ma_HANG nvarchar(4) primary key,
	TEN_HANG nvarchar (50),
	DON_VI_TINH nvarchar (15)	
)

create table DAILY(
	MA_DL nchar(4) primary key,
	TEN_DL nvarchar (40),
	DCHI_DL nvarchar (50)
)

create table BAN(
	Ma_HANG nvarchar(4),
	MA_DL nchar(4),
	NGAY_BAN nvarchar(10), 
	SOLUONG_BAN int,
	TRIGIA_BAN float
	constraint banpk primary key(Ma_HANG,MA_DL,NGAY_BAN)
)


insert into HANGHOA(Ma_HANG,TEN_HANG,DON_VI_TINH)
values
('b001', N'Nước uống đóng chai Lavie', N'Thùng'),
('b002', N'Pesi', N'Thùng'),
('b003', N'Nước Mía', N'Thùng'),
('b004', N'Nước Ngọt', N'Thùng'),
('b005', N'Sâm', N'Thùng')

insert into DAILY(MA_DL,TEN_DL,DCHI_DL)
values
('a001', N'Trung Tính', N'Trà Vinh'),
('a002', N'Ngọc Diệp', N'Trà Vinh'),
('a003', N'Thành Hiệp', N'Trà Vinh'),
('a004', N'Phát Đạt', N'Trà Vinh'),
('a005', N'Đặng Toàn', N'Trà Vinh')

insert into BAN(Ma_HANG,MA_DL,NGAY_BAN,SOLUONG_BAN,TRIGIA_BAN)
values
('b001', 'a001', '12/12/2021', '3', '200'),
('b002', 'a002', '13/1/2021', '4', '300'),
('b003', 'a003', '14/3/2021', '5', '400'),
('b004', 'a004', '12/5/2021', '6', '500'),
('b005', 'a005', '12/6/2021', '7', '600')

--II.1	
CREATE VIEW HienThiNuoc AS
SELECT D.MA_DL, D.TEN_DL, D.DCHI_DL
FROM DAILY D
JOIN BAN B ON D.MA_DL = B.MA_DL
JOIN HANGHOA H ON B.Ma_HANG = H.Ma_HANG
WHERE H.TEN_HANG = N'Pesi';

	
select* 
from HienThiNuoc

--II.2
CREATE PROCEDURE TinhTongGiaTriBan
AS
BEGIN
    SELECT SUM(TRIGIA_BAN) AS TongGiaTriBan
    FROM BAN
    WHERE Ma_HANG = 'b001' AND MA_DL = 'a004'
END

EXEC TinhTongGiaTriBan

--II.3
CREATE TRIGGER KTSoluongBan
ON BAN
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT * FROM inserted WHERE SOLUONG_BAN <= 0)
    BEGIN
        Print N'Số lượng bán phải lớn hơn 0'
        ROLLBACK TRANSACTION
        Print N'Không thêm được'
    END
END

----
insert into BAN(Ma_HANG,MA_DL,NGAY_BAN,SOLUONG_BAN,TRIGIA_BAN)
values
('b007', 'a007', '12/12/2021', '0', '200')
----

--III.1
exec sp_addlogin 'QL_HANGHOA', '123', 'DA21TTC_NguyenHuuLuan_DeSo2' 
exec sp_addlogin 'NV_THUAHANH', '123', 'DA21TTC_NguyenHuuLuan_DeSo2'

create user QL_admin for login QL_HANGHOA
create user NV_user for login NV_THUAHANH

--III.2
GRANT SELECT ON HANGHOA
TO QL_admin
--cấp quyền view
grant select on HienThiNuoc to QL_admin

--III.3
GRANT SELECT ON DAILY
TO NV_user