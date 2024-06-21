create table dim_date (
    date date primary key,
    year smallint not null,
    QUARTER smallint not null,
    month smallint not null,
    day smallint not null,
    WEEK smallint not null,
    is_weekend boolean
);

create table dim_rider (
    rider_id serial primary key,
    first_name varchar(50),
    last_name varchar(50),
    address varchar(100),
    birthday date,
    account_start_date date,
    account_end_date date,
    is_member bool,
    rider_age_at_signup smallint
);

create table dim_station (
    station_id VARCHAR(50) primary key,
    "name" VARCHAR(75),
    latitude FLOAT8,
    longitude FLOAT8
);

create table fact_trip (
    trip_id varchar(50) primary key,
    trip_date date references dim_date(date),
    rider_id int4 references dim_rider(rider_id),
    rideable_type varchar(75),
    start_at timestamp,
    ended_at timestamp,
    start_station_id varchar(50) references dim_station(station_id),
    end_station_id varchar(50) references dim_station(station_id),
    rider_age_at_trip smallint
);

create table fact_payment (
    payment_id serial primary key,
    payment_date date references dim_date(date),
    amount money,
    rider_id int4 references dim_rider(rider_id)
);

insert into dim_date (
        date,
        year,
        QUARTER,
        month,
        day,
        WEEK,
        is_weekend
    )
select distinct date,
    extract(
        year
        from date
    ) as year,
    extract(
        QUARTER
        from date
    ) as QUARTER,
    extract(
        month
        from date
    ) as month,
    extract(
        day
        from date
    ) as day,
    extract(
        WEEK
        from date
    ) as WEEK,
    case
        when extract(
            ISODOW
            from date
        ) in (6, 7) then true
        else false
    end as is_weekend
from payment
union
select distinct date(start_at),
    extract(
        year
        from start_at
    ) as year,
    extract(
        QUARTER
        from start_at
    ) as QUARTER,
    extract(
        month
        from start_at
    ) as month,
    extract(
        day
        from start_at
    ) as day,
    extract(
        WEEK
        from start_at
    ) as WEEK,
    case
        when extract(
            ISODOW
            from start_at
        ) in (6, 7) then true
        else false
    end as is_weekend
from trip;

insert into dim_rider (
        rider_id,
        first_name,
        last_name,
        address,
        birthday,
        account_start_date,
        account_end_date,
        is_member,
        rider_age_at_signup
    )
select rider_id,
    "first",
    "last",
    address,
    birthday,
    account_start_date,
    account_end_date,
    is_member,
    extract(
        year
        from age(account_start_date, birthday)
    ) as rider_age_at_signup
from rider;

insert into dim_station (station_id, "name", latitude, longitude)
select station_id,
    "name",
    latitude,
    longitude
from station;

insert into fact_trip (
        trip_id,
        trip_date,
        rider_id,
        rideable_type,
        start_at,
        ended_at,
        start_station_id,
        end_station_id,
        rider_age_at_trip
    )
select a.trip_id,
    DATE(a.start_at),
    a.rider_id,
    a.rideable_type,
    a.start_at,
    a.ended_at,
    a.start_station_id,
    a.end_station_id,
    extract(
        year
        from age(a.start_at, b.birthday)
    ) as rider_age_at_trip
from trip a,
    rider b
where a.rider_id = b.rider_id;

insert into fact_payment (payment_id, payment_date, amount, rider_id)
select payment_id,
    "date",
    amount,
    rider_id
from payment;