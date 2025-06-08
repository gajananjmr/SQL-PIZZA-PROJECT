

   -- Retrieve the total number of orders placed.
    SELECT * FROM orders;
    SELECT COUNT(order_id) AS total_orders FROM orders;


    -- Calculate the total revenue generated from pizza sales.

    SELECT 
       ROUND(SUM(order_details.quantity * pizzas.price), 2) AS total_sales
    FROM 
        order_details
    JOIN 
        pizzas ON pizzas.pizza_id = order_details.pizza_id;
        
        -- Identify the highest-priced pizza
SELECT 
    pizza_types.name, 
    pizzas.price
FROM 
    pizza_types 
JOIN 
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY 
    pizzas.price DESC 
LIMIT 1;

   -- Identify the most common pizza size ordered
SELECT 
    p.size,
    COUNT(od.order_details_id) AS total_orders
FROM 
    pizzas p
JOIN  
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY 
    p.size
ORDER BY 
    total_orders DESC;
    
    
    -- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types .name order by quantity desc limit 5;


    -- Total quantity of each pizza category ordered
SELECT 
    pt.category,
    SUM(od.quantity) AS total_quantity
FROM 
    pizza_types pt
JOIN 
    pizzas p ON pt.pizza_type_id = p.pizza_type_id
JOIN 
    order_details od ON p.pizza_id = od.pizza_id
GROUP BY 
    pt.category
ORDER BY 
    total_quantity DESC;
    
    -- Determine the distribution of orders by hour of the day
SELECT 
    HOUR(time) AS hour, 
    COUNT(order_id) AS order_count 
FROM 
    orders
GROUP BY 
    HOUR(time);
    -- Join relevant tables to find the category-wise distribution of pizzas.


select category,count(name) from pizza_types
group by category;

--  Group the orders by date and calculate the 
-- average number of pizzas ordered per day.
SELECT ROUND(AVG(daily_total), 0) AS avg_pizzas_per_day
FROM (
    SELECT o.date, SUM(od.quantity) AS daily_total
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY o.date
) AS daily_orders;

-- Determine the top 3 most ordered pizza types based on revenue.
SELECT 
    pt.name AS pizza_name,
    SUM(od.quantity * p.price) AS revenue
FROM 
    pizza_types pt
JOIN 
    pizzas p ON p.pizza_type_id = pt.pizza_type_id
JOIN 
    order_details od ON od.pizza_id = p.pizza_id
GROUP BY 
    pt.name
ORDER BY 
    revenue DESC
LIMIT 3;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category
SELECT NAME, REVENUE
FROM (
    SELECT CATEGORY, NAME, REVENUE,
           RANK() OVER (PARTITION BY CATEGORY ORDER BY REVENUE DESC) AS RN
    FROM (
        SELECT PT.CATEGORY, PT.NAME,
               SUM(OD.QUANTITY * P.PRICE) AS REVENUE
        FROM PIZZA_TYPES PT
        JOIN PIZZAS P ON PT.PIZZA_TYPE_ID = P.PIZZA_TYPE_ID
        JOIN ORDER_DETAILS OD ON OD.PIZZA_ID = P.PIZZA_ID
        GROUP BY PT.CATEGORY, PT.NAME
    ) AS A
) AS B
WHERE RN <= 3;


-- Analyze the cumulative revenue generated over time
select date,
sum(revenue) over (order by date)as cum_revenue
from
(select orders .date,
sum(order_details.quantity * pizzas.price)as revenue
from order_details join pizzas
on order_details .pizza_id= pizzas.pizza_id
join orders
on orders.order_id=order_details.order_id
group by orders.date)as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category
select name ,revenue from

(select category ,name,revenue,
rank() over (partition by category order by revenue desc) as rn
from
(select pizza_types.category,pizza_types.name,
sum((order_details.quantity)*pizzas.price )as revenue
from pizza_types join  pizzas
on pizza_types.pizza_type_id=pizzas .pizza_type_id
join order_details
on order_details.pizza_id=pizzas.pizza_id
group by  pizza_types.category,pizza_types.name)as a) as b
where rn <=3;


