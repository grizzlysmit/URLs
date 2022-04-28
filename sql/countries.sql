create table countries
(
    id bigserial
        constraint countries_pk
            primary key
) INHERITS(public.codes_prefixes);