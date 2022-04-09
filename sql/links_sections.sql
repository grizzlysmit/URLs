SELECT ls.id, ls.section FROM links_sections ls
WHERE (SELECT COUNT(*) n FROM links l WHERE l.section_id = ls.id) = 0
ORDER BY ls.section