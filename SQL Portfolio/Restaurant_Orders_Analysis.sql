/*
				Exploring Items Table
    
														*/





SELECT 
    *
FROM
    menu_items;






SELECT 
    COUNT(menu_item_id)
FROM
    menu_items;







SELECT 
    *
FROM
    menu_items
ORDER BY price ASC;						-- Most expenive item is "Shrimp Scampi" and the least expensive item is "Edamame"







SELECT 
    *
FROM
    menu_items
WHERE
    category = 'Italian'
ORDER BY price DESC	;					-- Least expensive Italian item on list is Spaghetti and Fettuccine Alfredo = 14.50 and most expensive item is Shrimp Scampi = 19.95








SELECT 
    COUNT(menu_item_id), category
FROM
    menu_items
GROUP BY category;						-- How many items each category has





/*
				Exploring Orders Table
    
														*/
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
                                                        
SELECT 
    *
FROM
    order_details;						-- The date range of the tables is from 1st jan 2023 to 31 march 2023
    
    
    
    
    
    


SELECT 
    COUNT(DISTINCT (order_id))
FROM
    order_details;						-- There were total of 5370 orders placed in this date range






SELECT 
    COUNT(order_details_id)
FROM
    order_details	;					-- There were 12234 items ordered in this date range





SELECT 
    COUNT(order_details_id) items, order_id
FROM
    order_details
GROUP BY order_id	
ORDER BY items DESC		;							-- There were max of 14 items in 1 single order






with cte1 as (
SELECT 
    COUNT(order_details_id) items, order_id
FROM
    order_details
GROUP BY order_id	
Having items > 12)									-- There were total of 23 order having more than 12 items

select count(*)
from cte1;









/*
				Analyzing Customer Behavior
    
														*/
                                                        
                                                        
                                                        
                                                        




SELECT 
    *
FROM
    order_details o
        LEFT JOIN
    menu_items m ON m.menu_item_id = o.item_id;
    
    
    
    
    
    
    
SELECT 
    COUNT(o.item_id) order_num,
    menu_item_id,
    m.item_name,
    m.category
FROM
    order_details o
        LEFT JOIN
    menu_items m ON m.menu_item_id = o.item_id
GROUP BY menu_item_id
ORDER BY order_num DESC		;										-- most ordered item was Hamburger and it was in American category and least ordered item was Chicken tacos and it was in Mexican Category
    
    
    
    
    
    
    
SELECT 
    SUM(m.price) expensive_orders, o.order_id
FROM
    order_details o
        LEFT JOIN
    menu_items m ON m.menu_item_id = o.item_id
GROUP BY o.order_id
ORDER BY expensive_orders DESC
LIMIT 5;															-- orders that spent most money





	SELECT 
    *
FROM
    order_details o
        LEFT JOIN
    menu_items m ON m.menu_item_id = o.item_id
WHERE
    o.order_id = 440;										-- Order id 440 has most spending and these are the details of it.
        
        
        
 
 

	SELECT 
    o.order_id, m.category,count(o.order_id)
FROM
    order_details o
        LEFT JOIN
    menu_items m ON m.menu_item_id = o.item_id
WHERE o.order_id IN (440 , 2075, 1957, 330, 2675)
    GROUP BY o.order_id,m.category							-- Top 5 most spending orders details
        ;