-- UPDATE links SET _perms._other._read = true WHERE userid = 1;
SELECT * FROM links z WHERE  -- z.id = 1 AND 
                             (1 = 1 OR (z.userid = 1 AND (z)._perms._user._read = true) 
										   OR ((z.groupid = 1 OR z.groupid IN (SELECT gs.group_id FROM groups gs WHERE gs.passwd_id = 1)) AND (z)._perms._group._read = true) 
										   OR (z)._perms._other._read = true)