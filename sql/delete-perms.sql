SELECT * FROM links WHERE id = 1 AND ((userid = 1 AND (_perms)._user._del = true) OR (groupid = 1 AND (_perms)._group._del = true) OR (_perms)._other._del = true)