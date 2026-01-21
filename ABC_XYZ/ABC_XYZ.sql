ALTER TABLE pharmacy
ALTER COLUMN "Amount" TYPE text USING "Amount"::text,
ALTER COLUMN "DR_Qty" TYPE text USING "DR_Qty"::text;
--превращаем в текст

UPDATE pharmacy
SET
  "Amount" = REPLACE("Amount", ',', '.'),
  "DR_Qty" = REPLACE("DR_Qty", ',', '.');
-- зменяем запятые на точки

ALTER TABLE pharmacy
ALTER COLUMN "Amount" TYPE numeric USING "Amount"::numeric,
ALTER COLUMN "DR_Qty" TYPE numeric USING "DR_Qty"::numeric;
-- возвращаем числовой формат

SELECT * FROM pharmacy; -- посмотреть таблицу

--ABC  анализ

WITH pivot AS (
 SELECT 
"DR_DrugName" AS product 
,SUM("DR_Qty")  AS quantity
,SUM ("DR_Qty") / 30 AS av_sales
,SUM ("Amount"::numeric) AS amount
FROM pharmacy GROUP BY "DR_DrugName"
)
SELECT product,
	CASE 
		WHEN SUM(quantity) OVER (ORDER BY quantity DESC)/SUM(quantity) OVER () <=0.8 THEN 'A'
		WHEN SUM(quantity) OVER (ORDER BY quantity DESC)/SUM(quantity) OVER () <=0.95 THEN 'B'
		ELSE 'C'
	END AS quantity_abc,
	CASE 
		WHEN SUM(av_sales) OVER (ORDER BY av_sales desc)/ SUM(av_sales) over() <=0.8 THEN 'A'
		WHEN SUM(av_sales) OVER (ORDER BY av_sales desc)/ SUM(av_sales) over() <=0.95 THEN 'B'
		ELSE 'C'
	END AS av_sales_abc,
	CASE 
		WHEN SUM(amount) OVER (ORDER BY amount desc)/ SUM(amount) over() <=0.8 THEN 'A'
		WHEN SUM(amount) OVER (ORDER BY amount desc)/ SUM(amount) over() <=0.95 THEN 'B'
		ELSE 'C'
	END AS amount_abc
FROM pivot
ORDER BY product;


-- анализ XYZ

WITH xyz AS (
SELECT 
	p."DR_DrugName" AS product, 
	SUM(p."DR_Qty")   AS total_qnt, 
	"DR_Date" AS date
FROM pharmacy p 
GROUP BY 
	p."DR_Date", 
	"DR_DrugName"
	)
SELECT 
    product,
	CASE 
		WHEN STDDEV(total_qnt)/avg(total_qnt) > 0.25 THEN 'Z'
		WHEN STDDEV(total_qnt)/ avg(total_qnt) > 0.1 THEN 'Y'
		ELSE 'X'
	END AS xyz
FROM xyz
GROUP BY product
ORDER BY product;



-- ABC & XYZ

WITH pivot_abc AS (
    SELECT 
        "DR_DrugName" AS product,
        SUM("DR_Qty") AS quantity,
        SUM("DR_Qty") / 30 AS av_sales,
        SUM("Amount"::numeric) AS amount
    FROM pharmacy
    GROUP BY "DR_DrugName"
),
abc AS (
    SELECT 
        product,
        CASE 
            WHEN SUM(quantity) OVER (ORDER BY quantity DESC)
                 / SUM(quantity) OVER () <= 0.8 THEN 'A'
            WHEN SUM(quantity) OVER (ORDER BY quantity DESC)
                 / SUM(quantity) OVER () <= 0.95 THEN 'B'
            ELSE 'C'
        END AS quantity_abc,
        CASE 
            WHEN SUM(av_sales) OVER (ORDER BY av_sales DESC)
                 / SUM(av_sales) OVER () <= 0.8 THEN 'A'
            WHEN SUM(av_sales) OVER (ORDER BY av_sales DESC)
                 / SUM(av_sales) OVER () <= 0.95 THEN 'B'
            ELSE 'C'
        END AS av_sales_abc,
        CASE 
            WHEN SUM(amount) OVER (ORDER BY amount DESC)
                 / SUM(amount) OVER () <= 0.8 THEN 'A'
            WHEN SUM(amount) OVER (ORDER BY amount DESC)
                 / SUM(amount) OVER () <= 0.95 THEN 'B'
            ELSE 'C'
        END AS amount_abc
    FROM pivot_abc
),
xyz AS (
    SELECT 
        "DR_DrugName" AS product,
        "DR_Date",
        SUM("DR_Qty") AS total_qnt
    FROM pharmacy
    GROUP BY "DR_DrugName", "DR_Date"
)
SELECT 
    xyz.product,
    abc.quantity_abc,
    abc.av_sales_abc,
    abc.amount_abc,
    CASE 
        WHEN STDDEV_SAMP(total_qnt) / AVG(total_qnt) > 0.25 THEN 'Z'
        WHEN STDDEV_SAMP(total_qnt) / AVG(total_qnt) > 0.1 THEN 'Y'
        ELSE 'X'
    END AS xyz
FROM xyz
JOIN abc ON abc.product = xyz.product
GROUP BY 
    xyz.product,
    abc.quantity_abc,
    abc.av_sales_abc,
    abc.amount_abc
ORDER BY xyz.product;


