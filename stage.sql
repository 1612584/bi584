create database toiphamstage;
go
use toiphamstage;
go
drop table hoso;
create table hoso(
	id int primary key,
	caseNumber varchar(9),
	datehs datetime,
	_block varchar(35),
	IUCR varchar(4),
	
	primaryType varchar(33),
	_description varchar(59),
	locationDescription varchar(47),
	arrest bit,
	domestic bit,
	beat int,
	district int,
	ward int,
	communityArea int,
	fbiCode varchar(4),
	xcoordinate float,
	ycoordinate float,
	yearhs int,
	updatedOn datetime,
	latitude float,
	longitude float,
	_location varchar(30)

);

go



use toiphamstage

go
drop table chicago_crime;
drop table community_area;
drop table detail_crime;
drop table crime_category;
create table DETAIL_CRIME
(
id int identity(1,1) primary key,
IUCR varchar(4),
--primaryDescription varchar(33), --primaryType: primary description in UICR
--FBICode varchar(4),--Bộ luật FBI 
categoryId int, -- một fbi code => có nhiều primary type
_description varchar(59),--Description Mô tả phụ của mã IUCR =  Secondary Decripsion
createdAt datetime,
Index_code varchar(1),-- I or N	
domestic bit,--true = 1 Trong nước
)
go
create table CHICAGO_CRIME
(
ID  int PRIMARY KEY,
CaseNumber varchar(9) ,--Số hồ sơ
DateHS datetime ,
_block varchar(35),-- Khối
detailCrimeId  int,--Mã báo cáo tội phạm Unifrom Illinois
locationDescription varchar(47),--Location Description Mô tả vị trí xảy ra sự cố
Arrest bit,--true = 1 Bắt giữ
Beat int,--Nơi xảy ra sự cố
District int,--Quận
Ward int,--Phường 
CommunityAreaId int,--Khu vực cộng đồng
YearHS int,--Năm xảy ra sự cố
UpdatedOn datetime,--Ngày và giờ bản ghi được cập nhật lần cuối
XCoordinate float,--Tọa độ x của vị trí xảy ra sự cố
YCoordinate float,--Tọa độ y của vị trí xảy ra sự cố
Latitude float,-- Vĩ độ của vị trí xảy ra sự cố
Longitude float,--Kinh độ của địa điểm xảy ra sự cố
_location varchar(30),--Vị trí xảy ra sự cố ở định dạng cho phép tạo bản đồ
CONSTRAINT CaseNumber_duynhat UNIQUE (CaseNumber)
)
go
/*
create table LOCATION_DESCRIPTION
(
--primeId int primary key, --Map bang Id se tot hon Map bang CaseNumber
--CaseNumber varchar(9) PRIMARY KEY,--Số hồ sơ
XCoordinate float,--Tọa độ x của vị trí xảy ra sự cố
YCoordinate float,--Tọa độ y của vị trí xảy ra sự cố
Latitude float,-- Vĩ độ của vị trí xảy ra sự cố
Longitude float,--Kinh độ của địa điểm xảy ra sự cố
_location varchar(30),--Vị trí xảy ra sự cố ở định dạng cho phép tạo bản đồ
)
*/
go
--ALTER TABLE LOCATION_DESCRIPTION
--ADD _Location nvarchar(30)

--ALTER TABLE LOCATION_DESCRIPTION
--DROP COLUMN _Location
go

create table CRIME_CATEGORY
(
id int IDENTITY(1,1) primary key,
FBICode varchar(4),--Bộ luật FBI 
PrimaryType varchar(33),--Mô tả chính về mã IUCR = Primary Decripsion
)
create table COMMUNITY_AREA
(
Number int primary key,--Community Area Number
_Name varchar(30),--COMMUNITY AREA NAME
PHC float,--percent_of_housing_crowded
PHBP float,--percent_households_below_poverty
PA16 float,--percent_aged_16_unemployed
PA25 float,--percent_aged_25_without_high_school_diploma
PA1864 float,--percent_aged_under_18_or_over_64
PCI float,
HardShip_Index int
)



alter table CHICAGO_CRIME
add constraint FK_CHICAGO_CRIME_DETAIL_CRIME
foreign key (detailCrimeId)
references DETAIL_CRIME (id)

alter table CHICAGO_CRIME
add constraint FK_CHICAGO_CRIME_COMMUNITY_AREA
foreign key (CommunityAreaId)
references COMMUNITY_AREA(Number)
/*
alter table CHICAGO_CRIME
add constraint FK_CHICAGO_CRIME_LOCATION_DESCRIPTION
foreign key (CaseNumber)
references LOCATION_DESCRIPTION (CaseNumber)
*/

alter table DETAIL_CRIME
add constraint FK_DETAIL_CRIME_CRIME_CATEGORY
foreign key (categoryId)
references CRIME_CATEGORY (id)

ALTER TABLE CRIME_CATEGORY
ADD CONSTRAINT uq_CRIME_CATEGORY UNIQUE(FBICODE, primaryType);

ALTER TABLE detail_crime
ADD CONSTRAINT uq_DETAIL_CRIME UNIQUE(IUCR, categoryId, _description,domestic);

  /*
select hs1.id, hs1._location as hs1_location, hs1.locationDescription as hs1Description,  hs2.id,
	hs2._location as hs2_location, hs2.locationDescription as hs2Description
from hoso hs1 join hoso hs2 on
										hs1._location like hs2._location
											
											where  hs1.id != hs2.id;
select hs.IUCR, hs.domestic, from hoso hs
*/
--select IUCR, FBIcode, primaryType, _description, domestic from hoso where IUCR like '0110'



/*
select uicr, count(id) as uicr_loop from hoso group by uicr;

select count(*) from hoso;

select count(caseNumber) from hoso group by caseNumber;
select _location, locationDescription, count(*) from hoso group by _location, locationDescription
select count(*) from hoso;

select count(caseNumber) from hoso group by caseNumber;
select _location, count(*) from hoso group by _location
select hs1.id, hs1._location as hs1_location, hs1.locationDescription as hs1Description, hs2.caseNumber, hs2.id
	hs2._location as hs2_location, hs2.locationDescription as hs2Description
from hoso hs1 join hoso hs2 on
										hs1._location like hs2._location
											
											where  hs1.id != hs2.id;

use toiphamstage;
select id, _description from hoso; 

select IUCR, FBIcode, primaryType, _description, domestic from hoso where IUCR like '0010'
/*
[detail crime nds [2]] Error: SSIS Error Code DTS_E_OLEDBERROR.  An OLE DB error has occurred. Error code: 0x80004005.
An OLE DB record is available.  Source: "Microsoft SQL Server Native Client 11.0"  Hresult: 0x80004005  Description: "Violation of PRIMARY KEY constraint 'PK__DETAIL_C__44F0838D19FE7AE7'. Cannot insert duplicate key in object 'dbo.DETAIL_CRIME'. The duplicate key value is (0110).".
[detail crime nds [2]] Error: SSIS Error Code DTS_E_INDUCEDTRANSFORMFAILUREONERROR.  The "detail crime nds.Inputs[OLE DB Destination Input]" failed because error code 0xC020907B occurred, and the error row disposition on "detail crime nds.Inputs[OLE DB Destination Input]" specifies failure on error. An error occurred on the specified object of the specified component.  There may be error messages posted before this with more information about the failure.
[SSIS.Pipeline] Error: SSIS Error Code DTS_E_PROCESSINPUTFAILED.  The ProcessInput method on component "detail crime nds" (2) failed with error code 0xC0209029 while processing input "OLE DB Destination Input" (15). The identified component returned an error from the ProcessInput method. The error is specific to the component, but the error is fatal and will cause the Data Flow task to stop running.  There may be error messages posted before this with more information about the failure.
Warning: 0x80019002 at Package: SSIS Warning Code DTS_W_MAXIMUMERRORCOUNTREACHED.  The Execution method succeeded, but the number of errors raised (3) reached the maximum allowed (1); resulting in failure. This occurs when the number of errors reaches the number specified in MaximumErrorCount. Change the MaximumErrorCount or fix the errors.
[detail crime nds [2]] Error: SSIS Error Code DTS_E_OLEDBERROR.  An OLE DB error has occurred. Error code: 0x80004005.
An OLE DB record is available.  Source: "Microsoft SQL Server Native Client 11.0"  Hresult: 0x80004005  Description: "Violation of UNIQUE KEY constraint 'uq_DETAIL_CRIME'. Cannot insert duplicate key in object 'dbo.DETAIL_CRIME'. The duplicate key value is (1030, 0).".
