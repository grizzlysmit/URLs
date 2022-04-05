-- DELETE FROM pseudo_pages WHERE id = 3;
SELECT pp.id, pp.name, pp.full_name, pp.pattern, pp.status FROM pseudo_pages pp
ORDER BY pp.name, pp.full_name