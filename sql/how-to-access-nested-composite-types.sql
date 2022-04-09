-- INSERT INTO _test(permissions, userid, groupid)VALUES(((true, true, true), (true, false, false), (true, false, false)), 2, 2);
-- UPDATE _test SET "_permissions"._other._read = false  WHERE id = 2;
SELECT * FROM _test ts
WHERE (ts.userid = 2 AND (ts)."_permissions"._user._read = true) OR (ts.groupid = 2 AND (ts)."_permissions"._group._read = true) OR (ts)."_permissions"._other._read = true
