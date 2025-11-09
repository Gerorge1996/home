DROP TABLE IF EXISTS dim_customer;
CREATE TABLE dim_customer
(
 customer_id   int NOT NULL,
 customer_name varchar(50) NOT NULL,
 segment       varchar(50) NOT NULL,
 CONSTRAINT PK_4 PRIMARY KEY ( customer_id )
);

DROP TABLE IF EXISTS dim_date;
CREATE TABLE dim_date
(
 "date"     date NOT NULL,
 year       int NOT NULL,
 month      int NOT NULL,
 week       int NOT NULL,
 week_day   int NOT NULL,
 is_holiday boolean NOT NULL,
 CONSTRAINT PK_2 PRIMARY KEY ( "date" )
);

DROP TABLE IF EXISTS dim_geo;
CREATE TABLE dim_geo
(
 geo_id      int NOT NULL,
 country     varchar(50) NOT NULL,
 city        varchar(50) NOT NULL,
 "state"     varchar(50) NOT NULL,
 postal_code int NULL,
 region      varchar(50) NOT NULL,
 CONSTRAINT PK_5 PRIMARY KEY ( geo_id )
);

DROP TABLE IF EXISTS dim_product;
CREATE TABLE dim_product
(
 product_id   int NOT NULL,
 product_inner_id varchar(50) NOT NULL,
 category     varchar(50) NOT NULL,
 sub_category varchar(50) NOT NULL,
 product_name varchar(250) NOT NULL,
 CONSTRAINT PK_6 PRIMARY KEY ( product_id )
);

DROP TABLE IF EXISTS dim_shipping;
CREATE TABLE dim_shipping
(
 ship_id   int NOT NULL,
 ship_mode varchar(50) NOT NULL,
 CONSTRAINT PK_3 PRIMARY KEY ( ship_id )
);

DROP TABLE IF EXISTS sales_fact;
CREATE TABLE sales_fact
(
 row_id      int NOT NULL,
 order_id    varchar(50) NOT NULL,
 order_date  date NOT NULL,
 shiped_date date NOT NULL,
 ship_id     int NOT NULL,
 customer_id int NOT NULL,
 product_id  int NOT NULL,
 sales       float4 NOT NULL,
 quantity    float4 NOT NULL,
 discount    float4 NOT NULL,
 profit      float4 NOT NULL,
 geo_id      int NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( row_id ),
 CONSTRAINT FK_1 FOREIGN KEY ( order_date ) REFERENCES dim_date ( "date" ),
 CONSTRAINT FK_2 FOREIGN KEY ( shiped_date ) REFERENCES dim_date ( "date" ),
 CONSTRAINT FK_3 FOREIGN KEY ( ship_id ) REFERENCES dim_shipping ( ship_id ),
 CONSTRAINT FK_4 FOREIGN KEY ( customer_id ) REFERENCES dim_customer ( customer_id ),
 CONSTRAINT FK_5 FOREIGN KEY ( geo_id ) REFERENCES dim_geo ( geo_id ),
 CONSTRAINT FK_6 FOREIGN KEY ( product_id ) REFERENCES dim_product ( product_id )
);