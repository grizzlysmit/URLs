INSERT INTO countries(cc, prefix, _name, landline_pattern, mobile_pattern, landline_title, mobile_title, landline_placeholder, mobile_placeholder)
VALUES('AU', '+61', 'Australia', '(?:(?:\+61[ -]?\d|0\d|\(0\d\)|0\d)[ -]?)?\d{4}[ -]?\d{4}', '(?:\+61|0)?\d{3}[ -]?\d{3}[ -]?\d{3}',
	   'Only +digits or local formats allowed i.e. +612-9567-2876 or (02) 9567 2876 or 0295672876.',
	   'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+612-9567-2876|(02) 9567 2876|0295672876',
	   '+61438-567-876|0438 567 876|0438567876') RETURNING *;
-- SELECT * FROM countries