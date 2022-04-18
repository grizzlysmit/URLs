SELECT p.id, p.username, p._admin, (SELECT e._email FROM email e WHERE e.id = p.email_id) email_address, 
       ARRAY((SELECT g._name FROM _group g JOIN groups gs ON g.id = gs.group_id WHERE gs.passwd_id = p.id))  additional_groups 
FROM passwd p