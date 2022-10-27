SELECT  
    p.id,
    (
        SELECT  price
        FROM product_discount pd2
        WHERE pd2.product_id = p.id
            AND pd2.customer_group_id = '1'
            AND pd2.quantity = '1'
            AND (
                (pd2.date_start = '0000-00-00' OR pd2.date_start < NOW()) 
                AND (pd2.date_end = '0000-00-00' OR pd2.date_end > NOW())
            )
        ORDER BY pd2.priority ASC, pd2.price ASC
        LIMIT 1
    ) AS discount, 
    (
        SELECT  price
        FROM product_special ps
        WHERE ps.product_id = p.id
            AND ps.customer_group_id = '1'
            AND (
                (ps.date_start = '0000-00-00' OR ps.date_start < NOW()) 
                AND (ps.date_end = '0000-00-00' OR ps.date_end > NOW())
            )
        ORDER BY ps.priority ASC, ps.price ASC
        LIMIT 1
    ) AS special
FROM category_path cp
LEFT JOIN product_to_category p2c
    ON (cp.category_id = p2c.category_id)
LEFT JOIN product p
    ON (p2c.product_id = p.id)
LEFT JOIN product_description pd
    ON (p.id = pd.product_id)
WHERE pd.language_id = '1'
    AND p.status = '1'
    AND p.sort_order > 0
    AND p.date_available <= NOW()
    AND cp.path_id = '246'
GROUP BY  p.id
ORDER BY 
    p.sort_order ASC,
    p.quantity DESC,
    LCASE(pd.name) ASC
LIMIT 0, 12