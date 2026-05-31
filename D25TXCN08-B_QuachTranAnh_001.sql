drop database if exists hackathon;
create database hackathon;
use hackathon;

	-- Tạo bảng creators
create table creators(
	creator_id varchar(5) primary key,
    creator_name varchar(100) not null,
    creator_email varchar(100) unique not null,
    creator_phone varchar(15) not null unique,
    creator_platform varchar(50)
);

-- Tạo bảng studios
create table studios(
	studio_id varchar(5) primary  key,
    studio_name varchar(100) not null,
    studio_location varchar(100) not null,
    hourly_price decimal(10,2) not null,
    studio_status varchar(20) not null
);

	-- Tạo bảng livesession
create table livesession(
	session_id int primary key auto_increment,
    creator_id varchar(5),
    studio_id varchar(5),
    foreign key(creator_id) references creators(creator_id),
    foreign key(studio_id) references studios(studio_id),
    session_date date not null,
    duration_hours int not null
);

	-- Tạo bảng payments 
create table payments(
	payment_id int primary key auto_increment,
    session_id int,
    foreign key(session_id) references livesession(session_id),
    payment_method varchar(50) not null,
    payment_amount decimal(10,2) not null,
    payment_date date not null
);

	-- Chèn dữ liệu bảng creators 

insert into creators(creator_id,creator_name,creator_email,creator_phone,creator_platform)
values
("CR01", "NguyenVanA","a@live.com","0901111111","Tiktok"),
("CR02", "TranThiB","b@live.com","0902222222","Youtube"),
("CR03", "LeMinhC","c@live.com","0903333333","Facebook"),
("CR04", "PhamThiD","d@live.com","0904444444","Tiktok"),
("CR05", "VuHoangE","e@live.com","0905555555","Shopeelive");

	-- Chèn dữ liệu bảng studios
insert into studios(studio_id,studio_name,studio_location,hourly_price,studio_status)
values
("ST01","StudioA","HaNoi",20.00,"Available"),
("ST02","StudioB","HCM",25.00,"Available"),
("ST03","StudioC","Danang",30.00,"Booked"),
("ST04","StudioD","HaNoi",22.00,"Available"),
("ST05","StudioE","CanTho",18.00,"Maintenance");

	-- Chèn dữ liệu bảng livesession
insert into livesession(creator_id,studio_id,session_date,duration_hours)
values
("CR01","ST01","2025-05-01",3),
("CR02","ST02","2025-05-02",4),
("CR03","ST03","2025-05-03",2),
("CR01","ST04","2025-05-04",5),
("CR05","ST02","2025-05-05",1);

	-- Chèn dữ liệu bảng payments
insert into payments(session_id,payment_method,payment_amount,payment_date)
values
(1,"Cash",60.00,"2025-05-01"),
(2,"CreditCard",100.00,"2025-05-02"),
(3,"BankTransfer",60.00,"2025-05-03"),
(4,"CreditCard",110.00,"2025-05-04"),
(5,"Cash",25.00,"2025-05-05");

	-- Cập nhật creator_platform của creator CR03 thành "YouTube"
update creators
set creator_platform = "YouTube"
where creator_id = "CR3";

	-- Do studio ST05 hoạt động trở lại, cập nhật studio_status = 'Available' và giảm hourly_price 10%.
update studios
set studio_status='Available',
	hourly_price  = hourly_price *0.9
where studio_id = "ST05";

	-- Xóa các payment có payment_method = 'Cash' và payment_date trước ngày 2025-05-03.
delete from payments
where payment_method='Cash' and payment_date < "2025-05-03";

	-- Liệt kê studio có studio_status = 'Available' và hourly_price > 20.
select * from studios
where studio_status='Available' and hourly_price>20;

	-- Lấy thông tin creator (creator_name, creator_phone) có nền tảng là TikTok.
select creator_name,creator_phone  from creators
where creator_platform = "TikTok";

	-- Hiển thị danh sách studio gồm studio_id, studio_name, hourly_price sắp xếp theo giá thuê giảm dần.
select studio_id,studio_name,hourly_price from studios
order by hourly_price desc;

	-- Lấy 3 payment đầu tiên có payment_method = 'CreditCard'.
select * from payments where payment_method='CreditCard' 
limit 3;

	-- Hiển thị danh sách creator gồm creator_id, creator_name, bỏ qua 2 bản ghi đầu và lấy 2 bản ghi tiếp theo.
select creator_id,creator_name
from creators
limit 2 offset 2;

	-- Hiển thị danh sách livestream gồm: session_id, creator_name, studio_name, duration_hours, payment_amount.
select l.session_id,c.creator_name,s.studio_name, l.duration_hours,p.payment_amount 
from livesession as l inner join creators as c inner join studios as s inner join payments as p
on l.creator_id = c.creator_id and l.studio_id = s.studio_id and l.session_id = p.session_id;

	-- Liệt kê tất cả studio và số lần được sử dụng (kể cả studio chưa từng được thuê).
select c.creator_id,s.studio_id 
from livesession as l 
right join creators as c on l.creator_id = c.creator_id
right join studios as s on l.studio_id = s.studio_id;

	-- Tính tổng doanh thu theo từng payment_method.
select payment_method, sum(payment_amount)
from payments
group by payment_method;

	-- Thống kê số session của mỗi creator, chỉ hiển thị creator có từ 2 session trở lên.
select c.creator_name, count(distinct session_id)
from livesession as l 
right join creators as c on l.creator_id = c.creator_id
right join studios as s on l.studio_id = s.studio_id
group by c.creator_name
having count(session_id) >=2;

	-- Thống kê số session của mỗi creator, chỉ hiển thị creator có từ 2 session trở lên.
select * from studios
where hourly_price > (
	select avg(hourly_price)
    from studios
);

	-- Hiển thị creator_name, creator_email của những creator đã từng livestream tại Studio B.
select c.creator_name,c.creator_email
from livesession as l inner join creators as c inner join studios as s
on l.creator_id = c.creator_id and l.studio_id = s.studio_id
where studio_name = "StudioB";

	-- Hiển thị báo cáo tổng hợp gồm: session_id, creator_name, studio_name, payment_method, payment_amount.
select l.session_id,c.creator_name,s.studio_name, p.payment_method,p.payment_amount 
from livesession as l inner join creators as c inner join studios as s inner join payments as p
on l.creator_id = c.creator_id and l.studio_id = s.studio_id and l.session_id = p.session_id;



