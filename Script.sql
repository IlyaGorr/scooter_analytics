with cohort as (
	select party_rk,
	gender_cd,
	SUBSTRING(first_value(book_start_dttm) over(partition by party_rk order by book_start_dttm), 6, 2) as first_month,
	(book_start_dttm::TIMESTAMP - (first_value(book_start_dttm) over(partition by party_rk order by book_start_dttm))::TIMESTAMP)  as diff,
	nominal_price_rub_amt,
	distance_km
	from kicksharing
	)
select first_month, 
SUM(case when DATE_PART('day', diff) < 30 then nominal_price_rub_amt END) as "0-30",
SUM(case when DATE_PART('day', diff) >= 30 and DATE_PART('day', diff) < 60 then nominal_price_rub_amt END) as "30-60",
SUM(case when DATE_PART('day', diff) >= 60 and DATE_PART('day', diff) < 90 then nominal_price_rub_amt END) as "60-90",
SUM(case when DATE_PART('day', diff) >= 90 and DATE_PART('day', diff) < 120 then nominal_price_rub_amt END) as "90-120",
SUM(case when DATE_PART('day', diff) >= 120 and DATE_PART('day', diff) < 150 then nominal_price_rub_amt END) as "120-150",
SUM(case when DATE_PART('day', diff) >= 150 and DATE_PART('day', diff) < 180 then nominal_price_rub_amt END) as "150-180",
SUM(case when DATE_PART('day', diff) >= 180 and DATE_PART('day', diff) < 210 then nominal_price_rub_amt END) as "180-210"
from cohort
group by 1
order by 1
