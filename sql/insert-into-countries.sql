INSERT INTO countries(cc, prefix, _name, landline_pattern, mobile_pattern, landline_title, mobile_title, landline_placeholder, mobile_placeholder)
VALUES('BS', '+1242', 'The Bahamas', '(?:\+?1[ -]?)?242[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?242[ -]?[2-9]\d{2}[ -]?\d{4}',
	   'Only +digits or local formats allowed i.e. +1242-234-1234 or 1242 234 1234 or 242-234-1234.',
	   'Only +digits or local formats allowed i.e. +1242-234-1234 or 1242 234 1234 or 242-234-1234.', '+1-242-234-1234|1 242 234 1234|242 234 1234',
	   '+1-242-234-1234|1 242 234 1234|242 234 1234') RETURNING *;
-- SELECT * FROM countries 1-NPA-NXX-XXXX