SELECT * FROM alias a 
WHERE (SELECT COUNT(*) n FROM links_sections ls WHERE ls.id = a.target) = 0
ORDER BY a.name