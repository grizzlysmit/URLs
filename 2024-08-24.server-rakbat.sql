--
-- PostgreSQL database cluster dump
--

-- Started on 2024-08-24 17:53:15 AEST

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE grizzlysmit;
ALTER ROLE grizzlysmit WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:13I6zT8PJU82fR46ywTyKQ==$8txqdPdZ0hzaO7Stw3RWVr40HklIN/E0uDio0LxQ6d0=:SMg1SHYax+d5ciCeVtsPggyML9SbXob64Eg0P/Nttxo=';
CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:7+sA1hywz7kCm6d2qDtpMQ==$RMK+DlY0VC+dCiSWpjHkAd8oGDmx93ZPnIRMRcp7lrM=:FTstKcD2yl08TmJnMOXx17LTH846C1SZ8wXwu/Kiegs=';
CREATE ROLE urluser;
ALTER ROLE urluser WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:sBaK10NdoF9pnBH0bdtroA==$dowVi3fMjwwVsWat7BYlo1XZ4Yf9LMBTnSjfc3tDqC4=:UHzwrDou9nqV2zb60ZABQGq1UEUfAOKQGuLHkSg2OJA=';

--
-- User Configurations
--






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Ubuntu 14.9-1.pgdg23.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.1)

-- Started on 2024-08-24 17:53:15 AEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3344 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2024-08-24 17:53:16 AEST

--
-- PostgreSQL database dump complete
--

--
-- Database "grizzlysmit" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Ubuntu 14.9-1.pgdg23.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.1)

-- Started on 2024-08-24 17:53:16 AEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3344 (class 1262 OID 16385)
-- Name: grizzlysmit; Type: DATABASE; Schema: -; Owner: grizzlysmit
--

CREATE DATABASE grizzlysmit WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_AU.UTF-8';


ALTER DATABASE grizzlysmit OWNER TO grizzlysmit;

\connect grizzlysmit

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3345 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2024-08-24 17:53:16 AEST

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Ubuntu 14.9-1.pgdg23.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.1)

-- Started on 2024-08-24 17:53:16 AEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3344 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2024-08-24 17:53:16 AEST

--
-- PostgreSQL database dump complete
--

--
-- Database "urls" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Ubuntu 14.9-1.pgdg23.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-0ubuntu0.24.04.1)

-- Started on 2024-08-24 17:53:16 AEST

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3704 (class 1262 OID 16850)
-- Name: urls; Type: DATABASE; Schema: -; Owner: grizzlysmit
--

CREATE DATABASE urls WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_AU.UTF-8';


ALTER DATABASE urls OWNER TO grizzlysmit;

\connect urls

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3706 (class 0 OID 0)
-- Name: urls; Type: DATABASE PROPERTIES; Schema: -; Owner: grizzlysmit
--

ALTER ROLE urluser IN DATABASE urls SET client_encoding TO 'UTF-8';


\connect urls

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 966 (class 1247 OID 16853)
-- Name: perm_set; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE public.perm_set AS (
	_read boolean,
	_write boolean,
	_del boolean
);


ALTER TYPE public.perm_set OWNER TO grizzlysmit;

--
-- TOC entry 968 (class 1247 OID 16856)
-- Name: perms; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE public.perms AS (
	_user public.perm_set,
	_group public.perm_set,
	_other public.perm_set
);


ALTER TYPE public.perms OWNER TO grizzlysmit;

--
-- TOC entry 879 (class 1247 OID 16858)
-- Name: status; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE public.status AS ENUM (
    'invalid',
    'unassigned',
    'assigned',
    'both'
);


ALTER TYPE public.status OWNER TO grizzlysmit;

--
-- TOC entry 211 (class 1259 OID 16867)
-- Name: _group_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public._group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public._group_id_seq OWNER TO grizzlysmit;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 212 (class 1259 OID 16868)
-- Name: _group; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public._group (
    id bigint DEFAULT nextval('public._group_id_seq'::regclass) NOT NULL,
    _name character varying(256) NOT NULL
);


ALTER TABLE public._group OWNER TO grizzlysmit;

--
-- TOC entry 213 (class 1259 OID 16872)
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.address_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 214 (class 1259 OID 16873)
-- Name: address; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.address (
    id bigint DEFAULT nextval('public.address_id_seq'::regclass) NOT NULL,
    unit character varying(32),
    street character varying(256) NOT NULL,
    city_suburb character varying(64),
    postcode character varying(16),
    region character varying(128),
    country character varying(128) NOT NULL
);


ALTER TABLE public.address OWNER TO grizzlysmit;

--
-- TOC entry 215 (class 1259 OID 16879)
-- Name: addresses; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.addresses (
    id bigint NOT NULL,
    passwd_id bigint NOT NULL,
    address_id bigint NOT NULL
);


ALTER TABLE public.addresses OWNER TO grizzlysmit;

--
-- TOC entry 216 (class 1259 OID 16882)
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.addresses_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 3715 (class 0 OID 0)
-- Dependencies: 216
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- TOC entry 217 (class 1259 OID 16883)
-- Name: secure; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.secure (
    userid bigint DEFAULT 1 NOT NULL,
    groupid bigint DEFAULT 1 NOT NULL,
    _perms public.perms DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)) NOT NULL
);


ALTER TABLE public.secure OWNER TO grizzlysmit;

--
-- TOC entry 218 (class 1259 OID 16891)
-- Name: alias; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.alias (
    userid bigint DEFAULT 1,
    groupid bigint DEFAULT 1,
    _perms public.perms DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    target bigint NOT NULL
)
INHERITS (public.secure);


ALTER TABLE public.alias OWNER TO grizzlysmit;

--
-- TOC entry 219 (class 1259 OID 16899)
-- Name: alias_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alias_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 219
-- Name: alias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.alias_id_seq OWNED BY public.alias.id;


--
-- TOC entry 220 (class 1259 OID 16900)
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.links_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 221 (class 1259 OID 16901)
-- Name: links_sections; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.links_sections (
    userid bigint DEFAULT 1,
    groupid bigint DEFAULT 1,
    _perms public.perms DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    id bigint DEFAULT nextval('public.links_id_seq'::regclass) NOT NULL,
    section character varying(50) NOT NULL
)
INHERITS (public.secure);


ALTER TABLE public.links_sections OWNER TO grizzlysmit;

--
-- TOC entry 222 (class 1259 OID 16910)
-- Name: alias_links; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.alias_links AS
 SELECT 'alias'::text AS type,
    a.id,
    a.name AS section,
    a.userid,
    a.groupid,
    a._perms
   FROM public.alias a
UNION
 SELECT 'links'::text AS type,
    ls.id,
    ls.section,
    ls.userid,
    ls.groupid,
    ls._perms
   FROM public.links_sections ls;


ALTER VIEW public.alias_links OWNER TO grizzlysmit;

--
-- TOC entry 223 (class 1259 OID 16914)
-- Name: links; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.links (
    userid bigint DEFAULT 1,
    groupid bigint DEFAULT 1,
    _perms public.perms DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    id bigint NOT NULL,
    section_id bigint NOT NULL,
    link character varying(4096),
    name character varying(50) NOT NULL
)
INHERITS (public.secure);


ALTER TABLE public.links OWNER TO grizzlysmit;

--
-- TOC entry 224 (class 1259 OID 16922)
-- Name: alias_union_links; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.alias_union_links AS
 SELECT 'alias'::text AS type,
    a.id,
    a.name AS alias_name,
    ls.section,
    l.name,
    l.link,
    a.userid,
    a.groupid,
    a._perms
   FROM ((public.alias a
     JOIN public.links_sections ls ON ((a.target = ls.id)))
     JOIN public.links l ON ((ls.id = l.section_id)))
UNION
 SELECT 'links'::text AS type,
    ls.id,
    ls.section AS alias_name,
    ls.section,
    l.name,
    l.link,
    ls.userid,
    ls.groupid,
    ls._perms
   FROM (public.links_sections ls
     JOIN public.links l ON ((ls.id = l.section_id)));


ALTER VIEW public.alias_union_links OWNER TO grizzlysmit;

--
-- TOC entry 225 (class 1259 OID 16927)
-- Name: alias_union_links_sections; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.alias_union_links_sections AS
 SELECT 'alias'::text AS type,
    a.id,
    a.name,
    ls.section,
    a.userid,
    a.groupid,
    a._perms
   FROM (public.alias a
     JOIN public.links_sections ls ON ((a.target = ls.id)))
UNION
 SELECT 'links'::text AS type,
    ls.id,
    ls.section AS name,
    ls.section,
    ls.userid,
    ls.groupid,
    ls._perms
   FROM public.links_sections ls;


ALTER VIEW public.alias_union_links_sections OWNER TO grizzlysmit;

--
-- TOC entry 226 (class 1259 OID 16932)
-- Name: aliases; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.aliases AS
 SELECT a.id,
    a.name,
    a.target,
    ls.section,
    a.userid,
    a.groupid,
    a._perms
   FROM (public.alias a
     JOIN public.links_sections ls ON ((a.target = ls.id)));


ALTER VIEW public.aliases OWNER TO grizzlysmit;

--
-- TOC entry 256 (class 1259 OID 17299)
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.country_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 257 (class 1259 OID 17300)
-- Name: country; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.country (
    id bigint DEFAULT nextval('public.country_id_seq'::regclass) NOT NULL,
    cc character(2) NOT NULL,
    _name character varying(256),
    _flag character varying(256),
    _escape character(1) DEFAULT '0'::bpchar NOT NULL,
    prefix character varying(64) DEFAULT '+1'::character varying NOT NULL,
    punct character varying(32) DEFAULT '- '::character varying NOT NULL
);


ALTER TABLE public.country OWNER TO grizzlysmit;

--
-- TOC entry 258 (class 1259 OID 17315)
-- Name: country_regions_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.country_regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.country_regions_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 259 (class 1259 OID 17316)
-- Name: country_regions; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.country_regions (
    id bigint DEFAULT nextval('public.country_regions_id_seq'::regclass) NOT NULL,
    country_id bigint NOT NULL,
    distinguishing character varying(64),
    landline_pattern character varying(256),
    mobile_pattern character varying(256),
    landline_title character varying(256),
    mobile_title character varying(256),
    landline_placeholder character varying(128),
    mobile_placeholder character varying(128),
    region character varying(128)
);


ALTER TABLE public.country_regions OWNER TO grizzlysmit;

--
-- TOC entry 260 (class 1259 OID 17388)
-- Name: countries; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.countries AS
 SELECT c.id,
    c.cc,
    c._name,
    c._flag,
    c._escape,
    c.prefix,
    c.punct,
    cr.id AS cr_id,
    cr.region,
    cr.distinguishing,
    cr.landline_pattern,
    cr.mobile_pattern,
    cr.landline_title,
    cr.mobile_title,
    cr.landline_placeholder,
    cr.mobile_placeholder
   FROM (public.country c
     LEFT JOIN public.country_regions cr ON ((c.id = cr.country_id)));


ALTER VIEW public.countries OWNER TO grizzlysmit;

--
-- TOC entry 227 (class 1259 OID 16944)
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.countries_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 228 (class 1259 OID 16945)
-- Name: email_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.email_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 229 (class 1259 OID 16946)
-- Name: email; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.email (
    id bigint DEFAULT nextval('public.email_id_seq'::regclass) NOT NULL,
    _email character varying(256) NOT NULL,
    verified boolean DEFAULT false NOT NULL
);


ALTER TABLE public.email OWNER TO grizzlysmit;

--
-- TOC entry 230 (class 1259 OID 16951)
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.emails_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 231 (class 1259 OID 16952)
-- Name: emails; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.emails (
    id bigint DEFAULT nextval('public.emails_id_seq'::regclass) NOT NULL,
    email_id bigint NOT NULL,
    passwd_id bigint NOT NULL
);


ALTER TABLE public.emails OWNER TO grizzlysmit;

--
-- TOC entry 232 (class 1259 OID 16956)
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.groups_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 233 (class 1259 OID 16957)
-- Name: groups; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.groups (
    id bigint DEFAULT nextval('public.groups_id_seq'::regclass) NOT NULL,
    group_id bigint NOT NULL,
    passwd_id bigint NOT NULL
);


ALTER TABLE public.groups OWNER TO grizzlysmit;

--
-- TOC entry 234 (class 1259 OID 16961)
-- Name: links_id_seq1; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.links_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.links_id_seq1 OWNER TO grizzlysmit;

--
-- TOC entry 3739 (class 0 OID 0)
-- Dependencies: 234
-- Name: links_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.links_id_seq1 OWNED BY public.links.id;


--
-- TOC entry 235 (class 1259 OID 16962)
-- Name: links_sections_join_links; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.links_sections_join_links AS
 SELECT ls.section,
    l.name,
    l.link,
    ls.userid,
    ls.groupid,
    ls._perms
   FROM (public.links_sections ls
     JOIN public.links l ON ((ls.id = l.section_id)))
  ORDER BY ls.section, l.name;


ALTER VIEW public.links_sections_join_links OWNER TO grizzlysmit;

--
-- TOC entry 236 (class 1259 OID 16966)
-- Name: page_section; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.page_section (
    userid bigint DEFAULT 1,
    groupid bigint DEFAULT 1,
    _perms public.perms DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    id bigint NOT NULL,
    pages_id bigint NOT NULL,
    links_section_id bigint NOT NULL
)
INHERITS (public.secure);


ALTER TABLE public.page_section OWNER TO grizzlysmit;

--
-- TOC entry 237 (class 1259 OID 16974)
-- Name: pages; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.pages (
    userid bigint DEFAULT 1,
    groupid bigint DEFAULT 1,
    _perms public.perms DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    id bigint NOT NULL,
    name character varying(256),
    full_name character varying(50) NOT NULL
)
INHERITS (public.secure);


ALTER TABLE public.pages OWNER TO grizzlysmit;

--
-- TOC entry 238 (class 1259 OID 16982)
-- Name: page_link_view; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.page_link_view AS
 SELECT p.id,
    p.name AS page_name,
    p.full_name,
    ls.section,
    l.name,
    l.link,
    p.userid,
    p.groupid,
    p._perms
   FROM (((public.pages p
     JOIN public.page_section ps ON ((p.id = ps.pages_id)))
     JOIN public.links_sections ls ON ((ls.id = ps.links_section_id)))
     JOIN public.links l ON ((l.section_id = ls.id)));


ALTER VIEW public.page_link_view OWNER TO grizzlysmit;

--
-- TOC entry 241 (class 1259 OID 16992)
-- Name: pseudo_pages; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.pseudo_pages (
    userid bigint DEFAULT 1,
    groupid bigint DEFAULT 1,
    _perms public.perms DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    id bigint NOT NULL,
    pattern character varying(256),
    status public.status DEFAULT 'invalid'::public.status NOT NULL,
    name character varying(50),
    full_name character varying(256)
)
INHERITS (public.secure);


ALTER TABLE public.pseudo_pages OWNER TO grizzlysmit;

--
-- TOC entry 262 (class 1259 OID 17408)
-- Name: page_pseudo_link_view; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.page_pseudo_link_view AS
 SELECT p.name AS page_name,
    p.full_name,
    ls.section,
    l.name,
    l.link,
    'invalid'::public.status AS status,
    p.userid,
    p.groupid,
    p._perms
   FROM (((public.pages p
     JOIN public.page_section ps ON ((p.id = ps.pages_id)))
     JOIN public.links_sections ls ON ((ls.id = ps.links_section_id)))
     JOIN public.links l ON ((l.section_id = ls.id)))
UNION
 SELECT pp.name AS page_name,
    pp.full_name,
    ls1.section,
    l1.name,
    l1.link,
    pp.status,
    pp.userid,
    pp.groupid,
    pp._perms
   FROM ((public.pseudo_pages pp
     JOIN public.links_sections ls1 ON (((ls1.section)::text ~* (pp.pattern)::text)))
     JOIN public.links l1 ON ((l1.section_id = ls1.id)));


ALTER VIEW public.page_pseudo_link_view OWNER TO grizzlysmit;

--
-- TOC entry 239 (class 1259 OID 16987)
-- Name: page_section_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.page_section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.page_section_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 239
-- Name: page_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.page_section_id_seq OWNED BY public.page_section.id;


--
-- TOC entry 240 (class 1259 OID 16988)
-- Name: page_view; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.page_view AS
 SELECT p.id,
    p.name,
    p.full_name,
    ls.section,
    p.userid,
    p.groupid,
    p._perms
   FROM ((public.pages p
     JOIN public.page_section ps ON ((p.id = ps.pages_id)))
     JOIN public.links_sections ls ON ((ls.id = ps.links_section_id)));


ALTER VIEW public.page_view OWNER TO grizzlysmit;

--
-- TOC entry 242 (class 1259 OID 17001)
-- Name: pagelike; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.pagelike AS
 SELECT 'page'::text AS type,
    p.name,
    p.full_name,
    p.userid,
    p.groupid,
    p._perms
   FROM public.pages p
UNION
 SELECT 'pseudo-page'::text AS type,
    pp.name,
    pp.full_name,
    pp.userid,
    pp.groupid,
    pp._perms
   FROM public.pseudo_pages pp;


ALTER VIEW public.pagelike OWNER TO grizzlysmit;

--
-- TOC entry 243 (class 1259 OID 17005)
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pages_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 243
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- TOC entry 244 (class 1259 OID 17006)
-- Name: passwd_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.passwd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passwd_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 245 (class 1259 OID 17007)
-- Name: passwd; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.passwd (
    id bigint DEFAULT nextval('public.passwd_id_seq'::regclass) NOT NULL,
    username character varying(100) NOT NULL,
    _password character varying(256),
    passwd_details_id bigint NOT NULL,
    primary_group_id bigint NOT NULL,
    _admin boolean DEFAULT false NOT NULL,
    email_id bigint NOT NULL
);


ALTER TABLE public.passwd OWNER TO grizzlysmit;

--
-- TOC entry 246 (class 1259 OID 17012)
-- Name: passwd_details_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.passwd_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.passwd_details_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 247 (class 1259 OID 17013)
-- Name: passwd_details; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.passwd_details (
    id bigint DEFAULT nextval('public.passwd_details_id_seq'::regclass) NOT NULL,
    display_name character varying(256),
    given character varying(256),
    _family character varying(128),
    residential_address_id bigint NOT NULL,
    postal_address_id bigint NOT NULL,
    primary_phone_id bigint,
    secondary_phone_id bigint,
    country_id bigint,
    country_region_id bigint
);


ALTER TABLE public.passwd_details OWNER TO grizzlysmit;

--
-- TOC entry 248 (class 1259 OID 17019)
-- Name: phone_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.phone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.phone_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 249 (class 1259 OID 17020)
-- Name: phone; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.phone (
    id bigint DEFAULT nextval('public.phone_id_seq'::regclass) NOT NULL,
    _number character varying(128) NOT NULL,
    verified boolean DEFAULT false NOT NULL
);


ALTER TABLE public.phone OWNER TO grizzlysmit;

--
-- TOC entry 250 (class 1259 OID 17025)
-- Name: phones_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.phones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.phones_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 251 (class 1259 OID 17026)
-- Name: phones; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.phones (
    id bigint DEFAULT nextval('public.phones_id_seq'::regclass) NOT NULL,
    phone_id bigint NOT NULL,
    address_id bigint NOT NULL
);


ALTER TABLE public.phones OWNER TO grizzlysmit;

--
-- TOC entry 261 (class 1259 OID 17403)
-- Name: pseudo_page_link_view; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.pseudo_page_link_view AS
 SELECT pp.name AS page_name,
    pp.full_name,
    ls.section,
    l.name,
    l.link,
    pp.status,
    pp.userid,
    pp.groupid,
    pp._perms
   FROM ((public.pseudo_pages pp
     JOIN public.links_sections ls ON (((ls.section)::text ~* (pp.pattern)::text)))
     JOIN public.links l ON ((l.section_id = ls.id)));


ALTER VIEW public.pseudo_page_link_view OWNER TO grizzlysmit;

--
-- TOC entry 252 (class 1259 OID 17030)
-- Name: psudo_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.psudo_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.psudo_pages_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 252
-- Name: psudo_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.psudo_pages_id_seq OWNED BY public.pseudo_pages.id;


--
-- TOC entry 253 (class 1259 OID 17031)
-- Name: sections; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.sections AS
 SELECT 'alias'::text AS type,
    a.id,
    a.name AS section,
    a.userid,
    a.groupid,
    a._perms
   FROM public.alias a
UNION
 SELECT 'links'::text AS type,
    ls.id,
    ls.section,
    ls.userid,
    ls.groupid,
    ls._perms
   FROM public.links_sections ls
UNION
 SELECT 'page'::text AS type,
    p.id,
    p.name AS section,
    p.userid,
    p.groupid,
    p._perms
   FROM public.pages p
UNION
 SELECT 'pseudo-page'::text AS type,
    pp.id,
    pp.name AS section,
    pp.userid,
    pp.groupid,
    pp._perms
   FROM public.pseudo_pages pp;


ALTER VIEW public.sections OWNER TO grizzlysmit;

--
-- TOC entry 254 (class 1259 OID 17036)
-- Name: sessions; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.sessions (
    id character(32) NOT NULL,
    a_session text
);


ALTER TABLE public.sessions OWNER TO grizzlysmit;

--
-- TOC entry 255 (class 1259 OID 17041)
-- Name: vlinks; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.vlinks AS
 SELECT ls.section,
    l.name,
    l.link,
    ls.userid,
    ls.groupid,
    ls._perms
   FROM (public.links_sections ls
     JOIN public.links l ON ((l.section_id = ls.id)));


ALTER VIEW public.vlinks OWNER TO grizzlysmit;

--
-- TOC entry 3365 (class 2604 OID 17045)
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- TOC entry 3372 (class 2604 OID 17046)
-- Name: alias id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias ALTER COLUMN id SET DEFAULT nextval('public.alias_id_seq'::regclass);


--
-- TOC entry 3380 (class 2604 OID 17048)
-- Name: links id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links ALTER COLUMN id SET DEFAULT nextval('public.links_id_seq1'::regclass);


--
-- TOC entry 3388 (class 2604 OID 17049)
-- Name: page_section id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section ALTER COLUMN id SET DEFAULT nextval('public.page_section_id_seq'::regclass);


--
-- TOC entry 3392 (class 2604 OID 17050)
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- TOC entry 3396 (class 2604 OID 17051)
-- Name: pseudo_pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages ALTER COLUMN id SET DEFAULT nextval('public.psudo_pages_id_seq'::regclass);


--
-- TOC entry 3661 (class 0 OID 16868)
-- Dependencies: 212
-- Data for Name: _group; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public._group (id, _name) FROM stdin;
3	grizzlysmit
10	fredie
12	romanna
9	doctor
14	bilbo
15	root
21	ludo
22	fbloggs
34	jo
1	admin
5	grizz
38	leanne
8	frodo
11	fred
4	grizzly
39	wibble
\.


--
-- TOC entry 3663 (class 0 OID 16873)
-- Dependencies: 214
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.address (id, unit, street, city_suburb, postcode, region, country) FROM stdin;
1	2	76-84 Karne Street north	Riverwood	2210	NSW	Australia
2	2	76-84 Karne Street north	Riverwood	2210	NSW	Australia
7	2	76-84 Karne Street north	Riverwood	2209	NSW	Australia
6	2	76-84 Karne Street north	Narwee	2210	NSW	Australia
4	2	76-84 Karne Street north	Riverwood	2210	NSW	Australia
15		The Tardis	Tardis	345667	universe	Cayman Islands
12	unit 2	Tardis 	The universe	9999	Galefray	Australia
17		1 Bagshot row	Hobitton	22222	The Shire	American Samoa
18	unit 2	76-84 Karne Street north	Riverwood	2210	NSW	Australia
21		2 Bagshot row	Hobbitton	7777	Christmas Island	Christmas Island
22		1 Bagshot Row	Hobbitton	7777	The Shire	Christmas Island
23		2 wibble street	Wobblesville	33333	wobbles	British Virgin Islands
26	Malabar medical centre	1234 Anzac Pde	Malabar	2345	New South Wales	Australia
27	Po Box 3455	Post Office Maroobra Junction	Maroobra	4566	New South Wales	Australia
10		Baggsend	hobbiton		the shire	Barbados
3	2	76-84 Karne Street north	Riverwood	2210	NSW	Australia
14		2 bedrock lane	Bedrock	45567	stone age	United States Virgin Islands
5	2	76-84 Karnee Street north	Riverwood	2210	NSW	Australia
11	2	76-84 Karnee Street north	Riveerwood	2210	NSW	Australia
28	unit 2	76-84 Karne Street north	Riverwood	2210	New South Wales	Australia
\.


--
-- TOC entry 3664 (class 0 OID 16879)
-- Dependencies: 215
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.addresses (id, passwd_id, address_id) FROM stdin;
\.


--
-- TOC entry 3667 (class 0 OID 16891)
-- Dependencies: 218
-- Data for Name: alias; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.alias (userid, groupid, _perms, id, name, target) FROM stdin;
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	1	stor	15
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	2	bronze	9
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	3	store	15
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	4	knck-dev	23
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	5	knck	16
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	6	knock-dev	23
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	7	cpp	24
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	8	CPP	24
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	9	c++	24
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	10	proc	21
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	11	dir	18
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	12	out	7
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	13	api.q	19
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	14	api_u	13
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	15	API_U	13
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	16	in	5
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	19	tool	12
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	21	fred	22
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	22	pk	16
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	23	add	4
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	25	perl6	27
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	26	pg	34
3	4	("(t,t,t)","(t,t,t)","(t,f,f)")	35	linux	38
2	3	("(t,t,t)","(t,t,t)","(t,f,f)")	37	Perl6	27
\.


--
-- TOC entry 3696 (class 0 OID 17300)
-- Dependencies: 257
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.country (id, cc, _name, _flag, _escape, prefix, punct) FROM stdin;
10	US	United States	/flags/US.png	0	+1	- 
7	CA	Canada	/flags/CA.png	0	+1	- 
19	DM	Dominica	/flags/DM.png	0	+1	- 
16	DO	Dominican Republic	/flags/DO.png	0	+1	- 
24	GD	Grenada	/flags/GD.png	0	+1	- 
12	GU	Guam	/flags/GU.png	0	+1	- 
17	JM	Jamaica	/flags/JM.png	0	+1	- 
22	MS	Montserrat	/flags/MS.png	0	+1	- 
6	MP	Northern Mariana Islands	/flags/MP.png	0	+1	- 
15	PR	Puerto Rico	/flags/PR.png	0	+1	- 
14	KN	Saint Kitts and Nevis	/flags/KN.png	0	+1	- 
9	LC	Saint Lucia	/flags/LC.png	0	+1	- 
3	VC	Saint Vincent and the Grenadines	/flags/VC.png	0	+1	- 
23	SX	Sint Maarten	/flags/SX.png	0	+1	- 
56	PN	Pitcairn Islands	/flags/PN.png	0	+64	- 
11	BS	The Bahamas	/flags/BS.png	0	+1	- 
8	TC	Turks and Caicos Islands	/flags/TC.png	0	+1	- 
5	AS	American Samoa	/flags/AS.png	0	+1	- 
18	AI	Anguilla	/flags/AI.png	0	+1	- 
26	VI	United States Virgin Islands	/flags/VI.png	0	+1	- 
13	TT	Trinidad and Tobago	/flags/TT.png	0	+1	- 
63	EG	Egypt	/flags/EG.png	0	+20	- 
25	AG	Antigua and Barbuda	/flags/AG.png	0	+1	- 
21	BB	Barbados	/flags/BB.png	0	+1	- 
2	BM	Bermuda	/flags/BM.png	0	+1	- 
20	VG	British Virgin Islands	/flags/VG.png	0	+1	- 
4	KY	Cayman Islands	/flags/KY.png	0	+1	- 
43	CC	Cocos (Keeling) Islands	/flags/CC.png	0	+61	- 
42	CX	Christmas Island	/flags/CX.png	0	+61	- 
27	AU	Australia	/flags/AU.png	0	+61	- 
44	NZ	New Zealand	/flags/NZ.png	0	+64	- 
\.


--
-- TOC entry 3698 (class 0 OID 17316)
-- Dependencies: 259
-- Data for Name: country_regions; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.country_regions (id, country_id, distinguishing, landline_pattern, mobile_pattern, landline_title, mobile_title, landline_placeholder, mobile_placeholder, region) FROM stdin;
6	7	368	(?:\\+?1[ -]?)?368[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?368[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1368-234-1234 or 1368 234 1234 or 368-234-1234.	Only +digits or local formats allowed i.e. +1368-234-1234 or 1368 234 1234 or 368-234-1234.	+1-368-234-1234|1 368 234 1234|368 234 1234	+1-368-234-1234|1 368 234 1234|368 234 1234	Alberta
7	7	403	(?:\\+?1[ -]?)?403[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?403[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1403-234-1234 or 1403 234 1234 or 403-234-1234.	Only +digits or local formats allowed i.e. +1403-234-1234 or 1403 234 1234 or 403-234-1234.	+1-403-234-1234|1 403 234 1234|403 234 1234	+1-403-234-1234|1 403 234 1234|403 234 1234	Alberta
8	7	587	(?:\\+?1[ -]?)?587[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?587[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1587-234-1234 or 1587 234 1234 or 587-234-1234.	Only +digits or local formats allowed i.e. +1587-234-1234 or 1587 234 1234 or 587-234-1234.	+1-587-234-1234|1 587 234 1234|587 234 1234	+1-587-234-1234|1 587 234 1234|587 234 1234	Alberta
9	7	780	(?:\\+?1[ -]?)?780[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?780[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1780-234-1234 or 1780 234 1234 or 780-234-1234.	Only +digits or local formats allowed i.e. +1780-234-1234 or 1780 234 1234 or 780-234-1234.	+1-780-234-1234|1 780 234 1234|780 234 1234	+1-780-234-1234|1 780 234 1234|780 234 1234	Alberta
10	7	825	(?:\\+?1[ -]?)?825[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?825[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1825-234-1234 or 1825 234 1234 or 825-234-1234.	Only +digits or local formats allowed i.e. +1825-234-1234 or 1825 234 1234 or 825-234-1234.	+1-825-234-1234|1 825 234 1234|825 234 1234	+1-825-234-1234|1 825 234 1234|825 234 1234	Alberta
11	7	236	(?:\\+?1[ -]?)?236[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?236[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1236-234-1234 or 1236 234 1234 or 236-234-1234.	Only +digits or local formats allowed i.e. +1236-234-1234 or 1236 234 1234 or 236-234-1234.	+1-236-234-1234|1 236 234 1234|236 234 1234	+1-236-234-1234|1 236 234 1234|236 234 1234	British Columbia
12	7	250	(?:\\+?1[ -]?)?250[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?250[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1250-234-1234 or 1250 234 1234 or 250-234-1234.	Only +digits or local formats allowed i.e. +1250-234-1234 or 1250 234 1234 or 250-234-1234.	+1-250-234-1234|1 250 234 1234|250 234 1234	+1-250-234-1234|1 250 234 1234|250 234 1234	British Columbia
13	7	604	(?:\\+?1[ -]?)?604[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?604[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1604-234-1234 or 1604 234 1234 or 604-234-1234.	Only +digits or local formats allowed i.e. +1604-234-1234 or 1604 234 1234 or 604-234-1234.	+1-604-234-1234|1 604 234 1234|604 234 1234	+1-604-234-1234|1 604 234 1234|604 234 1234	British Columbia
14	7	672	(?:\\+?1[ -]?)?672[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?672[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1672-234-1234 or 1672 234 1234 or 672-234-1234.	Only +digits or local formats allowed i.e. +1672-234-1234 or 1672 234 1234 or 672-234-1234.	+1-672-234-1234|1 672 234 1234|672 234 1234	+1-672-234-1234|1 672 234 1234|672 234 1234	British Columbia
15	7	778	(?:\\+?1[ -]?)?778[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?778[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1778-234-1234 or 1778 234 1234 or 778-234-1234.	Only +digits or local formats allowed i.e. +1778-234-1234 or 1778 234 1234 or 778-234-1234.	+1-778-234-1234|1 778 234 1234|778 234 1234	+1-778-234-1234|1 778 234 1234|778 234 1234	British Columbia
16	7	204	(?:\\+?1[ -]?)?204[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?204[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1204-234-1234 or 1204 234 1234 or 204-234-1234.	Only +digits or local formats allowed i.e. +1204-234-1234 or 1204 234 1234 or 204-234-1234.	+1-204-234-1234|1 204 234 1234|204 234 1234	+1-204-234-1234|1 204 234 1234|204 234 1234	Manitoba
17	7	431	(?:\\+?1[ -]?)?431[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?431[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1431-234-1234 or 1431 234 1234 or 431-234-1234.	Only +digits or local formats allowed i.e. +1431-234-1234 or 1431 234 1234 or 431-234-1234.	+1-431-234-1234|1 431 234 1234|431 234 1234	+1-431-234-1234|1 431 234 1234|431 234 1234	Manitoba
18	7	584	(?:\\+?1[ -]?)?584[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?584[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1584-234-1234 or 1584 234 1234 or 584-234-1234.	Only +digits or local formats allowed i.e. +1584-234-1234 or 1584 234 1234 or 584-234-1234.	+1-584-234-1234|1 584 234 1234|584 234 1234	+1-584-234-1234|1 584 234 1234|584 234 1234	Manitoba
19	7	428	(?:\\+?1[ -]?)?428[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?428[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1428-234-1234 or 1428 234 1234 or 428-234-1234.	Only +digits or local formats allowed i.e. +1428-234-1234 or 1428 234 1234 or 428-234-1234.	+1-428-234-1234|1 428 234 1234|428 234 1234	+1-428-234-1234|1 428 234 1234|428 234 1234	New Brunswick
1	2	441	(?:\\+?1[ -]?)?441[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?441[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1441-234-1234 or 1441 234 1234 or 441-234-1234.	Only +digits or local formats allowed i.e. +1441-234-1234 or 1441 234 1234 or 441-234-1234.	+1-441-234-1234|1 441 234 1234|441 234 1234	+1-441-234-1234|1 441 234 1234|441 234 1234	Bermuda
3	4	345	(?:\\+?1[ -]?)?345[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?345[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1345-234-1234 or 1345 234 1234 or 345-234-1234.	Only +digits or local formats allowed i.e. +1345-234-1234 or 1345 234 1234 or 245-234-1234.	+1-345-234-1234|1 345 234 1234|345 234 1234	+1-345-234-1234|1 345 234 1234|345 234 1234	Cayman Islands
5	6	670	(?:\\+?1[ -]?)?670[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?670[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1670-234-1234 or 1670 234 1234 or 670-234-1234.	Only +digits or local formats allowed i.e. +1670-234-1234 or 1670 234 1234 or 670-234-1234.	+1-670-234-1234|1 670 234 1234|670 234 1234	+1-670-234-1234|1 670 234 1234|670 234 1234	Northern Mariana Islands
2	3	784	(?:\\+?1[ -]?)?784[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?784[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1784-234-1234 or 1784 234 1234 or 784-234-1234.	Only +digits or local formats allowed i.e. +1784-234-1234 or 1784 234 1234 or 784-234-1234.	+1-784-234-1234|1 784 234 1234|784 234 1234	+1-784-234-1234|1 784 234 1234|784 234 1234	Saint Vincent and the Grenadines
20	7	506	(?:\\+?1[ -]?)?506[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?506[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1506-234-1234 or 1506 234 1234 or 506-234-1234.	Only +digits or local formats allowed i.e. +1506-234-1234 or 1506 234 1234 or 506-234-1234.	+1-506-234-1234|1 506 234 1234|506 234 1234	+1-506-234-1234|1 506 234 1234|506 234 1234	New Brunswick
21	7	709	(?:\\+?1[ -]?)?709[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?709[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1709-234-1234 or 1709 234 1234 or 709-234-1234.	Only +digits or local formats allowed i.e. +1709-234-1234 or 1709 234 1234 or 709-234-1234.	+1-709-234-1234|1 709 234 1234|709 234 1234	+1-709-234-1234|1 709 234 1234|709 234 1234	Newfoundland and Labrador
22	7	879	(?:\\+?1[ -]?)?879[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?879[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1879-234-1234 or 1879 234 1234 or 879-234-1234.	Only +digits or local formats allowed i.e. +1879-234-1234 or 1879 234 1234 or 879-234-1234.	+1-879-234-1234|1 879 234 1234|879 234 1234	+1-879-234-1234|1 879 234 1234|879 234 1234	Newfoundland and Labrador
23	7	867	(?:\\+?1[ -]?)?867[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?867[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1867-234-1234 or 1867 234 1234 or 867-234-1234.	Only +digits or local formats allowed i.e. +1867-234-1234 or 1867 234 1234 or 867-234-1234.	+1-867-234-1234|1 867 234 1234|867 234 1234	+1-867-234-1234|1 867 234 1234|867 234 1234	Northwest Territories
24	7	782	(?:\\+?1[ -]?)?782[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?782[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1782-234-1234 or 1782 234 1234 or 782-234-1234.	Only +digits or local formats allowed i.e. +1782-234-1234 or 1782 234 1234 or 782-234-1234.	+1-782-234-1234|1 782 234 1234|782 234 1234	+1-782-234-1234|1 782 234 1234|782 234 1234	Nova Scotia
25	7	902	(?:\\+?1[ -]?)?902[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?902[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1902-234-1234 or 1902 234 1234 or 902-234-1234.	Only +digits or local formats allowed i.e. +1902-234-1234 or 1902 234 1234 or 902-234-1234.	+1-902-234-1234|1 902 234 1234|902 234 1234	+1-902-234-1234|1 902 234 1234|902 234 1234	Nova Scotia
26	7	226	(?:\\+?1[ -]?)?226[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?226[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1226-234-1234 or 1226 234 1234 or 226-234-1234.	Only +digits or local formats allowed i.e. +1226-234-1234 or 1226 234 1234 or 226-234-1234.	+1-226-234-1234|1 226 234 1234|226 234 1234	+1-226-234-1234|1 226 234 1234|226 234 1234	Ontario
27	7	249	(?:\\+?1[ -]?)?249[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?249[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1249-234-1234 or 1249 234 1234 or 249-234-1234.	Only +digits or local formats allowed i.e. +1249-234-1234 or 1249 234 1234 or 249-234-1234.	+1-249-234-1234|1 249 234 1234|249 234 1234	+1-249-234-1234|1 249 234 1234|249 234 1234	Ontario
28	7	289	(?:\\+?1[ -]?)?289[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?289[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1289-234-1234 or 1289 234 1234 or 289-234-1234.	Only +digits or local formats allowed i.e. +1289-234-1234 or 1289 234 1234 or 289-234-1234.	+1-289-234-1234|1 289 234 1234|289 234 1234	+1-289-234-1234|1 289 234 1234|289 234 1234	Ontario
29	7	343	(?:\\+?1[ -]?)?343[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?343[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1343-234-1234 or 1343 234 1234 or 343-234-1234.	Only +digits or local formats allowed i.e. +1343-234-1234 or 1343 234 1234 or 343-234-1234.	+1-343-234-1234|1 343 234 1234|343 234 1234	+1-343-234-1234|1 343 234 1234|343 234 1234	Ontario
30	7	365	(?:\\+?1[ -]?)?365[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?365[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1365-234-1234 or 1365 234 1234 or 365-234-1234.	Only +digits or local formats allowed i.e. +1365-234-1234 or 1365 234 1234 or 365-234-1234.	+1-365-234-1234|1 365 234 1234|365 234 1234	+1-365-234-1234|1 365 234 1234|365 234 1234	Ontario
31	7	382	(?:\\+?1[ -]?)?382[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?382[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1382-234-1234 or 1382 234 1234 or 382-234-1234.	Only +digits or local formats allowed i.e. +1382-234-1234 or 1382 234 1234 or 382-234-1234.	+1-382-234-1234|1 382 234 1234|382 234 1234	+1-382-234-1234|1 382 234 1234|382 234 1234	Ontario
32	7	387	(?:\\+?1[ -]?)?387[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?387[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1387-234-1234 or 1387 234 1234 or 387-234-1234.	Only +digits or local formats allowed i.e. +1387-234-1234 or 1387 234 1234 or 387-234-1234.	+1-387-234-1234|1 387 234 1234|387 234 1234	+1-387-234-1234|1 387 234 1234|387 234 1234	Ontario
33	7	416	(?:\\+?1[ -]?)?416[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?416[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1416-234-1234 or 1416 234 1234 or 416-234-1234.	Only +digits or local formats allowed i.e. +1416-234-1234 or 1416 234 1234 or 416-234-1234.	+1-416-234-1234|1 416 234 1234|416 234 1234	+1-416-234-1234|1 416 234 1234|416 234 1234	Ontario
34	7	437	(?:\\+?1[ -]?)?437[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?437[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1437-234-1234 or 1437 234 1234 or 437-234-1234.	Only +digits or local formats allowed i.e. +1437-234-1234 or 1437 234 1234 or 437-234-1234.	+1-437-234-1234|1 437 234 1234|437 234 1234	+1-437-234-1234|1 437 234 1234|437 234 1234	Ontario
35	7	519	(?:\\+?1[ -]?)?519[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?519[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1519-234-1234 or 1519 234 1234 or 519-234-1234.	Only +digits or local formats allowed i.e. +1519-234-1234 or 1519 234 1234 or 519-234-1234.	+1-519-234-1234|1 519 234 1234|519 234 1234	+1-519-234-1234|1 519 234 1234|519 234 1234	Ontario
36	7	548	(?:\\+?1[ -]?)?548[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?548[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1548-234-1234 or 1548 234 1234 or 548-234-1234.	Only +digits or local formats allowed i.e. +1548-234-1234 or 1548 234 1234 or 548-234-1234.	+1-548-234-1234|1 548 234 1234|548 234 1234	+1-548-234-1234|1 548 234 1234|548 234 1234	Ontario
37	7	613	(?:\\+?1[ -]?)?613[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?613[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1613-234-1234 or 1613 234 1234 or 613-234-1234.	Only +digits or local formats allowed i.e. +1613-234-1234 or 1613 234 1234 or 613-234-1234.	+1-613-234-1234|1 613 234 1234|613 234 1234	+1-613-234-1234|1 613 234 1234|613 234 1234	Ontario
38	7	647	(?:\\+?1[ -]?)?647[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?647[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1647-234-1234 or 1647 234 1234 or 647-234-1234.	Only +digits or local formats allowed i.e. +1647-234-1234 or 1647 234 1234 or 647-234-1234.	+1-647-234-1234|1 647 234 1234|647 234 1234	+1-647-234-1234|1 647 234 1234|647 234 1234	Ontario
39	7	683	(?:\\+?1[ -]?)?683[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?683[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1683-234-1234 or 1683 234 1234 or 683-234-1234.	Only +digits or local formats allowed i.e. +1683-234-1234 or 1683 234 1234 or 683-234-1234.	+1-683-234-1234|1 683 234 1234|683 234 1234	+1-683-234-1234|1 683 234 1234|683 234 1234	Ontario
40	7	705	(?:\\+?1[ -]?)?705[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?705[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1705-234-1234 or 1705 234 1234 or 705-234-1234.	Only +digits or local formats allowed i.e. +1705-234-1234 or 1705 234 1234 or 705-234-1234.	+1-705-234-1234|1 705 234 1234|705 234 1234	+1-705-234-1234|1 705 234 1234|705 234 1234	Ontario
41	7	742	(?:\\+?1[ -]?)?742[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?742[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1742-234-1234 or 1742 234 1234 or 742-234-1234.	Only +digits or local formats allowed i.e. +1742-234-1234 or 1742 234 1234 or 742-234-1234.	+1-742-234-1234|1 742 234 1234|742 234 1234	+1-742-234-1234|1 742 234 1234|742 234 1234	Ontario
42	7	753	(?:\\+?1[ -]?)?753[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?753[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1753-234-1234 or 1753 234 1234 or 753-234-1234.	Only +digits or local formats allowed i.e. +1753-234-1234 or 1753 234 1234 or 753-234-1234.	+1-753-234-1234|1 753 234 1234|753 234 1234	+1-753-234-1234|1 753 234 1234|753 234 1234	Ontario
43	7	807	(?:\\+?1[ -]?)?807[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?807[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1807-234-1234 or 1807 234 1234 or 807-234-1234.	Only +digits or local formats allowed i.e. +1807-234-1234 or 1807 234 1234 or 807-234-1234.	+1-807-234-1234|1 807 234 1234|807 234 1234	+1-807-234-1234|1 807 234 1234|807 234 1234	Ontario
44	7	905	(?:\\+?1[ -]?)?905[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?905[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1905-234-1234 or 1905 234 1234 or 905-234-1234.	Only +digits or local formats allowed i.e. +1905-234-1234 or 1905 234 1234 or 905-234-1234.	+1-905-234-1234|1 905 234 1234|905 234 1234	+1-905-234-1234|1 905 234 1234|905 234 1234	Ontario
45	7	942	(?:\\+?1[ -]?)?942[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?942[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1942-234-1234 or 1942 234 1234 or 942-234-1234.	Only +digits or local formats allowed i.e. +1942-234-1234 or 1942 234 1234 or 942-234-1234.	+1-942-234-1234|1 942 234 1234|942 234 1234	+1-942-234-1234|1 942 234 1234|942 234 1234	Ontario
46	7	263	(?:\\+?1[ -]?)?263[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?263[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1263-234-1234 or 1263 234 1234 or 263-234-1234.	Only +digits or local formats allowed i.e. +1263-234-1234 or 1263 234 1234 or 263-234-1234.	+1-263-234-1234|1 263 234 1234|263 234 1234	+1-263-234-1234|1 263 234 1234|263 234 1234	Quebec
47	7	354	(?:\\+?1[ -]?)?354[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?354[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1354-234-1234 or 1354 234 1234 or 354-234-1234.	Only +digits or local formats allowed i.e. +1354-234-1234 or 1354 234 1234 or 354-234-1234.	+1-354-234-1234|1 354 234 1234|354 234 1234	+1-354-234-1234|1 354 234 1234|354 234 1234	Quebec
48	7	367	(?:\\+?1[ -]?)?367[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?367[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1367-234-1234 or 1367 234 1234 or 367-234-1234.	Only +digits or local formats allowed i.e. +1367-234-1234 or 1367 234 1234 or 367-234-1234.	+1-367-234-1234|1 367 234 1234|367 234 1234	+1-367-234-1234|1 367 234 1234|367 234 1234	Quebec
49	7	418	(?:\\+?1[ -]?)?418[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?418[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1418-234-1234 or 1418 234 1234 or 418-234-1234.	Only +digits or local formats allowed i.e. +1418-234-1234 or 1418 234 1234 or 418-234-1234.	+1-418-234-1234|1 418 234 1234|418 234 1234	+1-418-234-1234|1 418 234 1234|418 234 1234	Quebec
50	7	438	(?:\\+?1[ -]?)?438[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?438[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1438-234-1234 or 1438 234 1234 or 438-234-1234.	Only +digits or local formats allowed i.e. +1438-234-1234 or 1438 234 1234 or 438-234-1234.	+1-438-234-1234|1 438 234 1234|438 234 1234	+1-438-234-1234|1 438 234 1234|438 234 1234	Quebec
51	7	450	(?:\\+?1[ -]?)?450[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?450[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1450-234-1234 or 1450 234 1234 or 450-234-1234.	Only +digits or local formats allowed i.e. +1450-234-1234 or 1450 234 1234 or 450-234-1234.	+1-450-234-1234|1 450 234 1234|450 234 1234	+1-450-234-1234|1 450 234 1234|450 234 1234	Quebec
52	7	468	(?:\\+?1[ -]?)?468[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?468[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1468-234-1234 or 1468 234 1234 or 468-234-1234.	Only +digits or local formats allowed i.e. +1468-234-1234 or 1468 234 1234 or 468-234-1234.	+1-468-234-1234|1 468 234 1234|468 234 1234	+1-468-234-1234|1 468 234 1234|468 234 1234	Quebec
53	7	514	(?:\\+?1[ -]?)?514[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?514[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1514-234-1234 or 1514 234 1234 or 514-234-1234.	Only +digits or local formats allowed i.e. +1514-234-1234 or 1514 234 1234 or 514-234-1234.	+1-514-234-1234|1 514 234 1234|514 234 1234	+1-514-234-1234|1 514 234 1234|514 234 1234	Quebec
54	7	579	(?:\\+?1[ -]?)?579[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?579[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1579-234-1234 or 1579 234 1234 or 579-234-1234.	Only +digits or local formats allowed i.e. +1579-234-1234 or 1579 234 1234 or 579-234-1234.	+1-579-234-1234|1 579 234 1234|579 234 1234	+1-579-234-1234|1 579 234 1234|579 234 1234	Quebec
55	7	581	(?:\\+?1[ -]?)?581[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?581[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1581-234-1234 or 1581 234 1234 or 581-234-1234.	Only +digits or local formats allowed i.e. +1581-234-1234 or 1581 234 1234 or 581-234-1234.	+1-581-234-1234|1 581 234 1234|581 234 1234	+1-581-234-1234|1 581 234 1234|581 234 1234	Quebec
56	7	819	(?:\\+?1[ -]?)?819[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?819[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1819-234-1234 or 1819 234 1234 or 819-234-1234.	Only +digits or local formats allowed i.e. +1819-234-1234 or 1819 234 1234 or 819-234-1234.	+1-819-234-1234|1 819 234 1234|819 234 1234	+1-819-234-1234|1 819 234 1234|819 234 1234	Quebec
57	7	873	(?:\\+?1[ -]?)?873[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?873[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1873-234-1234 or 1873 234 1234 or 873-234-1234.	Only +digits or local formats allowed i.e. +1873-234-1234 or 1873 234 1234 or 873-234-1234.	+1-873-234-1234|1 873 234 1234|873 234 1234	+1-873-234-1234|1 873 234 1234|873 234 1234	Quebec
58	7	306	(?:\\+?1[ -]?)?306[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?306[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1306-234-1234 or 1306 234 1234 or 306-234-1234.	Only +digits or local formats allowed i.e. +1306-234-1234 or 1306 234 1234 or 306-234-1234.	+1-306-234-1234|1 306 234 1234|306 234 1234	+1-306-234-1234|1 306 234 1234|306 234 1234	Saskatchewan
59	7	474	(?:\\+?1[ -]?)?474[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?474[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1474-234-1234 or 1474 234 1234 or 474-234-1234.	Only +digits or local formats allowed i.e. +1474-234-1234 or 1474 234 1234 or 474-234-1234.	+1-474-234-1234|1 474 234 1234|474 234 1234	+1-474-234-1234|1 474 234 1234|474 234 1234	Saskatchewan
60	7	639	(?:\\+?1[ -]?)?639[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?639[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1639-234-1234 or 1639 234 1234 or 639-234-1234.	Only +digits or local formats allowed i.e. +1639-234-1234 or 1639 234 1234 or 639-234-1234.	+1-639-234-1234|1 639 234 1234|639 234 1234	+1-639-234-1234|1 639 234 1234|639 234 1234	Saskatchewan
61	7	600	(?:\\+?1[ -]?)?600[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?600[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1600-234-1234 or 1600 234 1234 or 600-234-1234.	Only +digits or local formats allowed i.e. +1600-234-1234 or 1600 234 1234 or 600-234-1234.	+1-600-234-1234|1 600 234 1234|600 234 1234	+1-600-234-1234|1 600 234 1234|600 234 1234	special services
62	7	622	(?:\\+?1[ -]?)?622[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?622[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1622-234-1234 or 1622 234 1234 or 622-234-1234.	Only +digits or local formats allowed i.e. +1622-234-1234 or 1622 234 1234 or 622-234-1234.	+1-622-234-1234|1 622 234 1234|622 234 1234	+1-622-234-1234|1 622 234 1234|622 234 1234	special services
63	7	633	(?:\\+?1[ -]?)?633[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?633[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1633-234-1234 or 1633 234 1234 or 633-234-1234.	Only +digits or local formats allowed i.e. +1633-234-1234 or 1633 234 1234 or 633-234-1234.	+1-633-234-1234|1 633 234 1234|633 234 1234	+1-633-234-1234|1 633 234 1234|633 234 1234	special services
64	7	644	(?:\\+?1[ -]?)?644[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?644[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1644-234-1234 or 1644 234 1234 or 644-234-1234.	Only +digits or local formats allowed i.e. +1644-234-1234 or 1644 234 1234 or 644-234-1234.	+1-644-234-1234|1 644 234 1234|644 234 1234	+1-644-234-1234|1 644 234 1234|644 234 1234	special services
65	7	655	(?:\\+?1[ -]?)?655[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?655[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1655-234-1234 or 1655 234 1234 or 655-234-1234.	Only +digits or local formats allowed i.e. +1655-234-1234 or 1655 234 1234 or 655-234-1234.	+1-655-234-1234|1 655 234 1234|655 234 1234	+1-655-234-1234|1 655 234 1234|655 234 1234	special services
66	7	677	(?:\\+?1[ -]?)?677[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?677[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1677-234-1234 or 1677 234 1234 or 677-234-1234.	Only +digits or local formats allowed i.e. +1677-234-1234 or 1677 234 1234 or 677-234-1234.	+1-677-234-1234|1 677 234 1234|677 234 1234	+1-677-234-1234|1 677 234 1234|677 234 1234	special services
67	7	688	(?:\\+?1[ -]?)?688[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?688[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1688-234-1234 or 1688 234 1234 or 688-234-1234.	Only +digits or local formats allowed i.e. +1688-234-1234 or 1688 234 1234 or 688-234-1234.	+1-688-234-1234|1 688 234 1234|688 234 1234	+1-688-234-1234|1 688 234 1234|688 234 1234	special services
70	10	251	(?:\\+?1[ -]?)?251[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?251[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1251-234-1234 or 1251 234 1234 or 251-234-1234.	Only +digits or local formats allowed i.e. +1251-234-1234 or 1251 234 1234 or 251-234-1234.	+1-251-234-1234|1 251 234 1234|251 234 1234	+1-251-234-1234|1 251 234 1234|251 234 1234	Alabama
71	10	256	(?:\\+?1[ -]?)?256[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?256[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1256-234-1234 or 1256 234 1234 or 256-234-1234.	Only +digits or local formats allowed i.e. +1256-234-1234 or 1256 234 1234 or 256-234-1234.	+1-256-234-1234|1 256 234 1234|256 234 1234	+1-256-234-1234|1 256 234 1234|256 234 1234	Alabama
72	10	205	(?:\\+?1[ -]?)?205[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?205[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1205-234-1234 or 1205 234 1234 or 205-234-1234.	Only +digits or local formats allowed i.e. +1205-234-1234 or 1205 234 1234 or 205-234-1234.	+1-205-234-1234|1 205 234 1234|205 234 1234	+1-205-234-1234|1 205 234 1234|205 234 1234	Alabama
73	10	907	(?:\\+?1[ -]?)?907[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?907[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1907-234-1234 or 1907 234 1234 or 907-234-1234.	Only +digits or local formats allowed i.e. +1907-234-1234 or 1907 234 1234 or 907-234-1234.	+1-907-234-1234|1 907 234 1234|907 234 1234	+1-907-234-1234|1 907 234 1234|907 234 1234	Alaska
74	10	480	(?:\\+?1[ -]?)?480[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?480[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1480-234-1234 or 1480 234 1234 or 480-234-1234.	Only +digits or local formats allowed i.e. +1480-234-1234 or 1480 234 1234 or 480-234-1234.	+1-480-234-1234|1 480 234 1234|480 234 1234	+1-480-234-1234|1 480 234 1234|480 234 1234	Arizona
75	10	520	(?:\\+?1[ -]?)?520[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?520[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1520-234-1234 or 1520 234 1234 or 520-234-1234.	Only +digits or local formats allowed i.e. +1520-234-1234 or 1520 234 1234 or 520-234-1234.	+1-520-234-1234|1 520 234 1234|520 234 1234	+1-520-234-1234|1 520 234 1234|520 234 1234	Arizona
76	10	602	(?:\\+?1[ -]?)?602[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?602[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1602-234-1234 or 1602 234 1234 or 602-234-1234.	Only +digits or local formats allowed i.e. +1602-234-1234 or 1602 234 1234 or 602-234-1234.	+1-602-234-1234|1 602 234 1234|602 234 1234	+1-602-234-1234|1 602 234 1234|602 234 1234	Arizona
68	8	649	(?:\\+?1[ -]?)?649[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?649[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +16439-234-1234 or 1649 234 1234 or 649-234-1234.	Only +digits or local formats allowed i.e. +1649-234-1234 or 1649 234 1234 or 649-234-1234.	+1-649-234-1234|1 649 234 1234|649 234 1234	+1-649-234-1234|1 649 234 1234|649 234 1234	Turks and Caicos Islands
77	10	623	(?:\\+?1[ -]?)?623[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?623[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1623-234-1234 or 1623 234 1234 or 623-234-1234.	Only +digits or local formats allowed i.e. +1623-234-1234 or 1623 234 1234 or 623-234-1234.	+1-623-234-1234|1 623 234 1234|623 234 1234	+1-623-234-1234|1 623 234 1234|623 234 1234	Arizona
78	10	928	(?:\\+?1[ -]?)?928[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?928[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1928-234-1234 or 1928 234 1234 or 928-234-1234.	Only +digits or local formats allowed i.e. +1928-234-1234 or 1928 234 1234 or 928-234-1234.	+1-928-234-1234|1 928 234 1234|928 234 1234	+1-928-234-1234|1 928 234 1234|928 234 1234	Arizona
79	10	327	(?:\\+?1[ -]?)?327[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?327[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1327-234-1234 or 1327 234 1234 or 327-234-1234.	Only +digits or local formats allowed i.e. +1327-234-1234 or 1327 234 1234 or 327-234-1234.	+1-327-234-1234|1 327 234 1234|327 234 1234	+1-327-234-1234|1 327 234 1234|327 234 1234	Arkansas
80	10	501	(?:\\+?1[ -]?)?501[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?501[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1501-234-1234 or 1501 234 1234 or 501-234-1234.	Only +digits or local formats allowed i.e. +1501-234-1234 or 1501 234 1234 or 501-234-1234.	+1-501-234-1234|1 501 234 1234|501 234 1234	+1-501-234-1234|1 501 234 1234|501 234 1234	Arkansas
81	10	870	(?:\\+?1[ -]?)?870[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?870[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1870-234-1234 or 1870 234 1234 or 870-234-1234.	Only +digits or local formats allowed i.e. +1870-234-1234 or 1870 234 1234 or 870-234-1234.	+1-870-234-1234|1 870 234 1234|870 234 1234	+1-870-234-1234|1 870 234 1234|870 234 1234	Arkansas
82	10	213	(?:\\+?1[ -]?)?213[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?213[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1213-234-1234 or 1213 234 1234 or 213-234-1234.	Only +digits or local formats allowed i.e. +1213-234-1234 or 1213 234 1234 or 213-234-1234.	+1-213-234-1234|1 213 234 1234|213 234 1234	+1-213-234-1234|1 213 234 1234|213 234 1234	California
83	10	279	(?:\\+?1[ -]?)?279[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?279[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1279-234-1234 or 1279 234 1234 or 279-234-1234.	Only +digits or local formats allowed i.e. +1279-234-1234 or 1279 234 1234 or 279-234-1234.	+1-279-234-1234|1 279 234 1234|279 234 1234	+1-279-234-1234|1 279 234 1234|279 234 1234	California
84	10	310	(?:\\+?1[ -]?)?310[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?310[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1310-234-1234 or 1310 234 1234 or 310-234-1234.	Only +digits or local formats allowed i.e. +1310-234-1234 or 1310 234 1234 or 310-234-1234.	+1-310-234-1234|1 310 234 1234|310 234 1234	+1-310-234-1234|1 310 234 1234|310 234 1234	California
85	10	659	(?:\\+?1[ -]?)?659[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?659[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1659-234-1234 or 1659 234 1234 or 659-234-1234.	Only +digits or local formats allowed i.e. +1659-234-1234 or 1659 234 1234 or 659-234-1234.	+1-659-234-1234|1 659 234 1234|659 234 1234	+1-659-234-1234|1 659 234 1234|659 234 1234	Alabama
86	10	938	(?:\\+?1[ -]?)?938[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?938[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1938-234-1234 or 1938 234 1234 or 938-234-1234.	Only +digits or local formats allowed i.e. +1938-234-1234 or 1938 234 1234 or 938-234-1234.	+1-938-234-1234|1 938 234 1234|938 234 1234	+1-938-234-1234|1 938 234 1234|938 234 1234	Alabama
87	10	209	(?:\\+?1[ -]?)?209[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?209[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1-209-234-1234 or 1 209 234 1234 or  209-234-1234.	Only +digits or local formats allowed i.e. +1 209-234-1234 or 1 209 234 1234 or 209-234-1234.	+1-209-234-1234|1 209 234 1234|209 234 1234	+1-209-234-1234|1 209 234 1234|209 234 1234	California
88	10	415	(?:\\+?1[ -]?)?415[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?415[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1415-234-1234 or 1415 234 1234 or 415-234-1234.	Only +digits or local formats allowed i.e. +1415-234-1234 or 1415 234 1234 or 415-234-1234.	+1-415-234-1234|1 415 234 1234|415 234 1234	+1-415-234-1234|1 415 234 1234|415 234 1234	California
89	10	424	(?:\\+?1[ -]?)?424[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?424[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1424-234-1234 or 1424 234 1234 or 424-234-1234.	Only +digits or local formats allowed i.e. +1424-234-1234 or 1424 234 1234 or 424-234-1234.	+1-424-234-1234|1 424 234 1234|424 234 1234	+1-424-234-1234|1 424 234 1234|424 234 1234	California
90	10	442	(?:\\+?1[ -]?)?442[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?442[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1442-234-1234 or 1442 234 1234 or 442-234-1234.	Only +digits or local formats allowed i.e. +1442-234-1234 or 1442 234 1234 or 442-234-1234.	+1-442-234-1234|1 442 234 1234|442 234 1234	+1-442-234-1234|1 442 234 1234|442 234 1234	California
91	10	510	(?:\\+?1[ -]?)?510[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?510[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1510-234-1234 or 1510 234 1234 or 510-234-1234.	Only +digits or local formats allowed i.e. +1510-234-1234 or 1510 234 1234 or 510-234-1234.	+1-510-234-1234|1 510 234 1234|510 234 1234	+1-510-234-1234|1 510 234 1234|510 234 1234	California
92	10	530	(?:\\+?1[ -]?)?530[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?530[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1530-234-1234 or 1530 234 1234 or 530-234-1234.	Only +digits or local formats allowed i.e. +1530-234-1234 or 1530 234 1234 or 530-234-1234.	+1-530-234-1234|1 530 234 1234|530 234 1234	+1-530-234-1234|1 530 234 1234|530 234 1234	California
93	10	559	(?:\\+?1[ -]?)?559[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?559[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1559-234-1234 or 1559 234 1234 or 559-234-1234.	Only +digits or local formats allowed i.e. +1559-234-1234 or 1559 234 1234 or 559-234-1234.	+1-559-234-1234|1 559 234 1234|559 234 1234	+1-559-234-1234|1 559 234 1234|559 234 1234	California
94	10	562	(?:\\+?1[ -]?)?562[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?562[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1562-234-1234 or 1562 234 1234 or 562-234-1234.	Only +digits or local formats allowed i.e. +1562-234-1234 or 1562 234 1234 or 562-234-1234.	+1-562-234-1234|1 562 234 1234|562 234 1234	+1-562-234-1234|1 562 234 1234|562 234 1234	California
95	10	619	(?:\\+?1[ -]?)?619[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?619[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1619-234-1234 or 1619 234 1234 or 619-234-1234.	Only +digits or local formats allowed i.e. +1619-234-1234 or 1619 234 1234 or 619-234-1234.	+1-619-234-1234|1 619 234 1234|619 234 1234	+1-619-234-1234|1 619 234 1234|619 234 1234	California
96	10	626	(?:\\+?1[ -]?)?626[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?626[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1626-234-1234 or 1626 234 1234 or 626-234-1234.	Only +digits or local formats allowed i.e. +1626-234-1234 or 1626 234 1234 or 626-234-1234.	+1-626-234-1234|1 626 234 1234|626 234 1234	+1-626-234-1234|1 626 234 1234|626 234 1234	California
97	10	628	(?:\\+?1[ -]?)?628[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?628[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1628-234-1234 or 1628 234 1234 or 628-234-1234.	Only +digits or local formats allowed i.e. +1628-234-1234 or 1628 234 1234 or 628-234-1234.	+1-628-234-1234|1 628 234 1234|628 234 1234	+1-628-234-1234|1 628 234 1234|628 234 1234	California
98	10	650	(?:\\+?1[ -]?)?650[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?650[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1650-234-1234 or 1650 234 1234 or 650-234-1234.	Only +digits or local formats allowed i.e. +1650-234-1234 or 1650 234 1234 or 650-234-1234.	+1-650-234-1234|1 650 234 1234|650 234 1234	+1-650-234-1234|1 650 234 1234|650 234 1234	California
99	10	657	(?:\\+?1[ -]?)?657[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?657[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1657-234-1234 or 1657 234 1234 or 657-234-1234.	Only +digits or local formats allowed i.e. +1657-234-1234 or 1657 234 1234 or 657-234-1234.	+1-657-234-1234|1 657 234 1234|657 234 1234	+1-657-234-1234|1 657 234 1234|657 234 1234	California
100	10	661	(?:\\+?1[ -]?)?661[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?661[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1661-234-1234 or 1661 234 1234 or 661-234-1234.	Only +digits or local formats allowed i.e. +1661-234-1234 or 1661 234 1234 or 661-234-1234.	+1-661-234-1234|1 661 234 1234|661 234 1234	+1-661-234-1234|1 661 234 1234|661 234 1234	California
101	10	341	(?:\\+?1[ -]?)?341[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?341[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1341-234-1234 or 1341 234 1234 or 341-234-1234.	Only +digits or local formats allowed i.e. +1341-234-1234 or 1341 234 1234 or 341-234-1234.	+1-341-234-1234|1 341 234 1234|341 234 1234	+1-341-234-1234|1 341 234 1234|341 234 1234	California
102	10	408	(?:\\+?1[ -]?)?408[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?408[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1408-234-1234 or 1408 234 1234 or 408-234-1234.	Only +digits or local formats allowed i.e. +1408-234-1234 or 1408 234 1234 or 408-234-1234.	+1-408-234-1234|1 408 234 1234|408 234 1234	+1-408-234-1234|1 408 234 1234|408 234 1234	California
103	10	747	(?:\\+?1[ -]?)?747[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?747[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1747-234-1234 or 1747 234 1234 or 747-234-1234.	Only +digits or local formats allowed i.e. +1747-234-1234 or 1747 234 1234 or 747-234-1234.	+1-747-234-1234|1 747 234 1234|747 234 1234	+1-747-234-1234|1 747 234 1234|747 234 1234	California
104	10	760	(?:\\+?1[ -]?)?760[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?760[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1760-234-1234 or 1760 234 1234 or 760-234-1234.	Only +digits or local formats allowed i.e. +1760-234-1234 or 1760 234 1234 or 760-234-1234.	+1-760-234-1234|1 760 234 1234|760 234 1234	+1-760-234-1234|1 760 234 1234|760 234 1234	California
105	10	805	(?:\\+?1[ -]?)?805[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?805[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1805-234-1234 or 1805 234 1234 or 805-234-1234.	Only +digits or local formats allowed i.e. +1805-234-1234 or 1805 234 1234 or 805-234-1234.	+1-805-234-1234|1 805 234 1234|805 234 1234	+1-805-234-1234|1 805 234 1234|805 234 1234	California
106	10	818	(?:\\+?1[ -]?)?818[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?818[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1818-234-1234 or 1818 234 1234 or 818-234-1234.	Only +digits or local formats allowed i.e. +1818-234-1234 or 1818 234 1234 or 818-234-1234.	+1-818-234-1234|1 818 234 1234|818 234 1234	+1-818-234-1234|1 818 234 1234|818 234 1234	California
107	10	820	(?:\\+?1[ -]?)?820[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?820[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1820-234-1234 or 1820 234 1234 or 820-234-1234.	Only +digits or local formats allowed i.e. +1820-234-1234 or 1820 234 1234 or 820-234-1234.	+1-820-234-1234|1 820 234 1234|820 234 1234	+1-820-234-1234|1 820 234 1234|820 234 1234	California
108	10	831	(?:\\+?1[ -]?)?831[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?831[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1831-234-1234 or 1831 234 1234 or 831-234-1234.	Only +digits or local formats allowed i.e. +1831-234-1234 or 1831 234 1234 or 831-234-1234.	+1-831-234-1234|1 831 234 1234|831 234 1234	+1-831-234-1234|1 831 234 1234|831 234 1234	California
109	10	840	(?:\\+?1[ -]?)?840[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?840[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1840-234-1234 or 1840 234 1234 or 840-234-1234.	Only +digits or local formats allowed i.e. +1840-234-1234 or 1840 234 1234 or 840-234-1234.	+1-840-234-1234|1 840 234 1234|840 234 1234	+1-840-234-1234|1 840 234 1234|840 234 1234	California
110	10	858	(?:\\+?1[ -]?)?858[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?858[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1858-234-1234 or 1858 234 1234 or 858-234-1234.	Only +digits or local formats allowed i.e. +1858-234-1234 or 1858 234 1234 or 858-234-1234.	+1-858-234-1234|1 858 234 1234|858 234 1234	+1-858-234-1234|1 858 234 1234|858 234 1234	California
111	10	909	(?:\\+?1[ -]?)?909[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?909[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1909-234-1234 or 1909 234 1234 or 909-234-1234.	Only +digits or local formats allowed i.e. +1909-234-1234 or 1909 234 1234 or 909-234-1234.	+1-909-234-1234|1 909 234 1234|909 234 1234	+1-909-234-1234|1 909 234 1234|909 234 1234	California
112	10	916	(?:\\+?1[ -]?)?916[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?916[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1916-234-1234 or 1916 234 1234 or 916-234-1234.	Only +digits or local formats allowed i.e. +1916-234-1234 or 1916 234 1234 or 916-234-1234.	+1-916-234-1234|1 916 234 1234|916 234 1234	+1-916-234-1234|1 916 234 1234|916 234 1234	California
113	10	925	(?:\\+?1[ -]?)?925[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?925[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1925-234-1234 or 1925 234 1234 or 925-234-1234.	Only +digits or local formats allowed i.e. +1925-234-1234 or 1925 234 1234 or 925-234-1234.	+1-925-234-1234|1 925 234 1234|925 234 1234	+1-925-234-1234|1 925 234 1234|925 234 1234	California
114	10	949	(?:\\+?1[ -]?)?949[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?949[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1949-234-1234 or 1949 234 1234 or 949-234-1234.	Only +digits or local formats allowed i.e. +1949-234-1234 or 1949 234 1234 or 949-234-1234.	+1-949-234-1234|1 949 234 1234|949 234 1234	+1-949-234-1234|1 949 234 1234|949 234 1234	California
115	10	951	(?:\\+?1[ -]?)?951[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?951[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1951-234-1234 or 1951 234 1234 or 951-234-1234.	Only +digits or local formats allowed i.e. +1951-234-1234 or 1951 234 1234 or 951-234-1234.	+1-951-234-1234|1 951 234 1234|951 234 1234	+1-951-234-1234|1 951 234 1234|951 234 1234	California
116	10	707	(?:\\+?1[ -]?)?707[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?707[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1707-234-1234 or 1707 234 1234 or 707-234-1234.	Only +digits or local formats allowed i.e. +1707-234-1234 or 1707 234 1234 or 707-234-1234.	+1-707-234-1234|1 707 234 1234|707 234 1234	+1-707-234-1234|1 707 234 1234|707 234 1234	California
117	10	714	(?:\\+?1[ -]?)?714[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?714[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1714-234-1234 or 1714 234 1234 or 714-234-1234.	Only +digits or local formats allowed i.e. +1714-234-1234 or 1714 234 1234 or 714-234-1234.	+1-714-234-1234|1 714 234 1234|714 234 1234	+1-714-234-1234|1 714 234 1234|714 234 1234	California
118	10	970	(?:\\+?1[ -]?)?970[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?970[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1970-234-1234 or 1970 234 1234 or 970-234-1234.	Only +digits or local formats allowed i.e. +1970-234-1234 or 1970 234 1234 or 970-234-1234.	+1-970-234-1234|1 970 234 1234|970 234 1234	+1-970-234-1234|1 970 234 1234|970 234 1234	Colorado
119	10	983	(?:\\+?1[ -]?)?983[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?983[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1983-234-1234 or 1983 234 1234 or 983-234-1234.	Only +digits or local formats allowed i.e. +1983-234-1234 or 1983 234 1234 or 983-234-1234.	+1-983-234-1234|1 983 234 1234|983 234 1234	+1-983-234-1234|1 983 234 1234|983 234 1234	Colorado
120	10	203	(?:\\+?1[ -]?)?203[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?203[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1203-234-1234 or 1203 234 1234 or 203-234-1234.	Only +digits or local formats allowed i.e. +1203-234-1234 or 1203 234 1234 or 203-234-1234.	+1-203-234-1234|1 203 234 1234|203 234 1234	+1-203-234-1234|1 203 234 1234|203 234 1234	Connecticut
121	10	475	(?:\\+?1[ -]?)?475[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?475[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1475-234-1234 or 1475 234 1234 or 475-234-1234.	Only +digits or local formats allowed i.e. +1475-234-1234 or 1475 234 1234 or 475-234-1234.	+1-475-234-1234|1 475 234 1234|475 234 1234	+1-475-234-1234|1 475 234 1234|475 234 1234	Connecticut
122	10	860	(?:\\+?1[ -]?)?860[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?860[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1860-234-1234 or 1860 234 1234 or 860-234-1234.	Only +digits or local formats allowed i.e. +1860-234-1234 or 1860 234 1234 or 860-234-1234.	+1-860-234-1234|1 860 234 1234|860 234 1234	+1-860-234-1234|1 860 234 1234|860 234 1234	Connecticut
123	10	959	(?:\\+?1[ -]?)?959[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?959[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1959-234-1234 or 1959 234 1234 or 959-234-1234.	Only +digits or local formats allowed i.e. +1959-234-1234 or 1959 234 1234 or 959-234-1234.	+1-959-234-1234|1 959 234 1234|959 234 1234	+1-959-234-1234|1 959 234 1234|959 234 1234	Connecticut
124	10	302	(?:\\+?1[ -]?)?302[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?302[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1302-234-1234 or 1302 234 1234 or 302-234-1234.	Only +digits or local formats allowed i.e. +1302-234-1234 or 1302 234 1234 or 302-234-1234.	+1-302-234-1234|1 302 234 1234|302 234 1234	+1-302-234-1234|1 302 234 1234|302 234 1234	Delaware
125	10	202	(?:\\+?1[ -]?)?202[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?202[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1202-234-1234 or 1202 234 1234 or 202-234-1234.	Only +digits or local formats allowed i.e. +1202-234-1234 or 1202 234 1234 or 202-234-1234.	+1-202-234-1234|1 202 234 1234|202 234 1234	+1-202-234-1234|1 202 234 1234|202 234 1234	District of Columbia
126	10	771	(?:\\+?1[ -]?)?771[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?771[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1771-234-1234 or 1771 234 1234 or 771-234-1234.	Only +digits or local formats allowed i.e. +1771-234-1234 or 1771 234 1234 or 771-234-1234.	+1-771-234-1234|1 771 234 1234|771 234 1234	+1-771-234-1234|1 771 234 1234|771 234 1234	District of Columbia
127	10	239	(?:\\+?1[ -]?)?239[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?239[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1239-234-1234 or 1239 234 1234 or 239-234-1234.	Only +digits or local formats allowed i.e. +1239-234-1234 or 1239 234 1234 or 239-234-1234.	+1-239-234-1234|1 239 234 1234|239 234 1234	+1-239-234-1234|1 239 234 1234|239 234 1234	Florida
128	10	305	(?:\\+?1[ -]?)?305[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?305[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1305-234-1234 or 1305 234 1234 or 305-234-1234.	Only +digits or local formats allowed i.e. +1305-234-1234 or 1305 234 1234 or 305-234-1234.	+1-305-234-1234|1 305 234 1234|305 234 1234	+1-305-234-1234|1 305 234 1234|305 234 1234	Florida
129	10	352	(?:\\+?1[ -]?)?352[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?352[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1352-234-1234 or 1352 234 1234 or 352-234-1234.	Only +digits or local formats allowed i.e. +1352-234-1234 or 1352 234 1234 or 352-234-1234.	+1-352-234-1234|1 352 234 1234|352 234 1234	+1-352-234-1234|1 352 234 1234|352 234 1234	Florida
130	10	386	(?:\\+?1[ -]?)?386[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?386[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1386-234-1234 or 1386 234 1234 or 386-234-1234.	Only +digits or local formats allowed i.e. +1386-234-1234 or 1386 234 1234 or 386-234-1234.	+1-386-234-1234|1 386 234 1234|386 234 1234	+1-386-234-1234|1 386 234 1234|386 234 1234	Florida
131	10	719	(?:\\+?1[ -]?)?719[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?719[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1719-234-1234 or 1719 234 1234 or 719-234-1234.	Only +digits or local formats allowed i.e. +1719-234-1234 or 1719 234 1234 or 719-234-1234.	+1-719-234-1234|1 719 234 1234|719 234 1234	+1-719-234-1234|1 719 234 1234|719 234 1234	Colorado
132	10	720	(?:\\+?1[ -]?)?720[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?720[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1720-234-1234 or 1720 234 1234 or 720-234-1234.	Only +digits or local formats allowed i.e. +1720-234-1234 or 1720 234 1234 or 720-234-1234.	+1-720-234-1234|1 720 234 1234|720 234 1234	+1-720-234-1234|1 720 234 1234|720 234 1234	Colorado
133	10	689	(?:\\+?1[ -]?)?689[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?689[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1689-234-1234 or 1689 234 1234 or 689-234-1234.	Only +digits or local formats allowed i.e. +1689-234-1234 or 1689 234 1234 or 689-234-1234.	+1-689-234-1234|1 689 234 1234|689 234 1234	+1-689-234-1234|1 689 234 1234|689 234 1234	Florida
134	10	727	(?:\\+?1[ -]?)?727[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?727[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1727-234-1234 or 1727 234 1234 or 727-234-1234.	Only +digits or local formats allowed i.e. +1727-234-1234 or 1727 234 1234 or 727-234-1234.	+1-727-234-1234|1 727 234 1234|727 234 1234	+1-727-234-1234|1 727 234 1234|727 234 1234	Florida
135	10	754	(?:\\+?1[ -]?)?754[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?754[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1754-234-1234 or 1754 234 1234 or 754-234-1234.	Only +digits or local formats allowed i.e. +1754-234-1234 or 1754 234 1234 or 754-234-1234.	+1-754-234-1234|1 754 234 1234|754 234 1234	+1-754-234-1234|1 754 234 1234|754 234 1234	Florida
136	10	772	(?:\\+?1[ -]?)?772[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?772[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1772-234-1234 or 1772 234 1234 or 772-234-1234.	Only +digits or local formats allowed i.e. +1772-234-1234 or 1772 234 1234 or 772-234-1234.	+1-772-234-1234|1 772 234 1234|772 234 1234	+1-772-234-1234|1 772 234 1234|772 234 1234	Florida
137	10	786	(?:\\+?1[ -]?)?786[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?786[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1786-234-1234 or 1786 234 1234 or 786-234-1234.	Only +digits or local formats allowed i.e. +1786-234-1234 or 1786 234 1234 or 786-234-1234.	+1-786-234-1234|1 786 234 1234|786 234 1234	+1-786-234-1234|1 786 234 1234|786 234 1234	Florida
138	10	813	(?:\\+?1[ -]?)?813[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?813[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1813-234-1234 or 1813 234 1234 or 813-234-1234.	Only +digits or local formats allowed i.e. +1813-234-1234 or 1813 234 1234 or 813-234-1234.	+1-813-234-1234|1 813 234 1234|813 234 1234	+1-813-234-1234|1 813 234 1234|813 234 1234	Florida
139	10	850	(?:\\+?1[ -]?)?850[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?850[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1850-234-1234 or 1850 234 1234 or 850-234-1234.	Only +digits or local formats allowed i.e. +1850-234-1234 or 1850 234 1234 or 850-234-1234.	+1-850-234-1234|1 850 234 1234|850 234 1234	+1-850-234-1234|1 850 234 1234|850 234 1234	Florida
140	10	863	(?:\\+?1[ -]?)?863[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?863[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1863-234-1234 or 1863 234 1234 or 863-234-1234.	Only +digits or local formats allowed i.e. +1863-234-1234 or 1863 234 1234 or 863-234-1234.	+1-863-234-1234|1 863 234 1234|863 234 1234	+1-863-234-1234|1 863 234 1234|863 234 1234	Florida
141	10	904	(?:\\+?1[ -]?)?904[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?904[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1904-234-1234 or 1904 234 1234 or 904-234-1234.	Only +digits or local formats allowed i.e. +1904-234-1234 or 1904 234 1234 or 904-234-1234.	+1-904-234-1234|1 904 234 1234|904 234 1234	+1-904-234-1234|1 904 234 1234|904 234 1234	Florida
142	10	941	(?:\\+?1[ -]?)?941[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?941[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1941-234-1234 or 1941 234 1234 or 941-234-1234.	Only +digits or local formats allowed i.e. +1941-234-1234 or 1941 234 1234 or 941-234-1234.	+1-941-234-1234|1 941 234 1234|941 234 1234	+1-941-234-1234|1 941 234 1234|941 234 1234	Florida
143	10	954	(?:\\+?1[ -]?)?954[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?954[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1954-234-1234 or 1954 234 1234 or 954-234-1234.	Only +digits or local formats allowed i.e. +1954-234-1234 or 1954 234 1234 or 954-234-1234.	+1-954-234-1234|1 954 234 1234|954 234 1234	+1-954-234-1234|1 954 234 1234|954 234 1234	Florida
144	10	404	(?:\\+?1[ -]?)?404[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?404[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1404-234-1234 or 1404 234 1234 or 404-234-1234.	Only +digits or local formats allowed i.e. +1404-234-1234 or 1404 234 1234 or 404-234-1234.	+1-404-234-1234|1 404 234 1234|404 234 1234	+1-404-234-1234|1 404 234 1234|404 234 1234	Georgia
145	10	470	(?:\\+?1[ -]?)?470[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?470[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1470-234-1234 or 1470 234 1234 or 470-234-1234.	Only +digits or local formats allowed i.e. +1470-234-1234 or 1470 234 1234 or 470-234-1234.	+1-470-234-1234|1 470 234 1234|470 234 1234	+1-470-234-1234|1 470 234 1234|470 234 1234	Georgia
146	10	561	(?:\\+?1[ -]?)?561[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?561[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1561-234-1234 or 1561 234 1234 or 561-234-1234.	Only +digits or local formats allowed i.e. +1561-234-1234 or 1561 234 1234 or 561-234-1234.	+1-561-234-1234|1 561 234 1234|561 234 1234	+1-561-234-1234|1 561 234 1234|561 234 1234	Florida
147	10	656	(?:\\+?1[ -]?)?656[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?656[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1656-234-1234 or 1656 234 1234 or 656-234-1234.	Only +digits or local formats allowed i.e. +1656-234-1234 or 1656 234 1234 or 656-234-1234.	+1-656-234-1234|1 656 234 1234|656 234 1234	+1-656-234-1234|1 656 234 1234|656 234 1234	Florida
148	10	770	(?:\\+?1[ -]?)?770[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?770[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1770-234-1234 or 1770 234 1234 or 770-234-1234.	Only +digits or local formats allowed i.e. +1770-234-1234 or 1770 234 1234 or 770-234-1234.	+1-770-234-1234|1 770 234 1234|770 234 1234	+1-770-234-1234|1 770 234 1234|770 234 1234	Georgia
149	10	912	(?:\\+?1[ -]?)?912[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?912[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1912-234-1234 or 1912 234 1234 or 912-234-1234.	Only +digits or local formats allowed i.e. +1912-234-1234 or 1912 234 1234 or 912-234-1234.	+1-912-234-1234|1 912 234 1234|912 234 1234	+1-912-234-1234|1 912 234 1234|912 234 1234	Georgia
150	10	943	(?:\\+?1[ -]?)?943[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?943[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1943-234-1234 or 1943 234 1234 or 943-234-1234.	Only +digits or local formats allowed i.e. +1943-234-1234 or 1943 234 1234 or 943-234-1234.	+1-943-234-1234|1 943 234 1234|943 234 1234	+1-943-234-1234|1 943 234 1234|943 234 1234	Georgia
151	10	808	(?:\\+?1[ -]?)?808[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?808[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1808-234-1234 or 1808 234 1234 or 808-234-1234.	Only +digits or local formats allowed i.e. +1808-234-1234 or 1808 234 1234 or 808-234-1234.	+1-808-234-1234|1 808 234 1234|808 234 1234	+1-808-234-1234|1 808 234 1234|808 234 1234	Hawaii
152	10	208	(?:\\+?1[ -]?)?208[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?208[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1208-234-1234 or 1208 234 1234 or 208-234-1234.	Only +digits or local formats allowed i.e. +1208-234-1234 or 1208 234 1234 or 208-234-1234.	+1-208-234-1234|1 208 234 1234|208 234 1234	+1-208-234-1234|1 208 234 1234|208 234 1234	Idaho
153	10	986	(?:\\+?1[ -]?)?986[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?986[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1986-234-1234 or 1986 234 1234 or 986-234-1234.	Only +digits or local formats allowed i.e. +1986-234-1234 or 1986 234 1234 or 986-234-1234.	+1-986-234-1234|1 986 234 1234|986 234 1234	+1-986-234-1234|1 986 234 1234|986 234 1234	Idaho
154	10	217	(?:\\+?1[ -]?)?217[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?217[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1217-234-1234 or 1217 234 1234 or 217-234-1234.	Only +digits or local formats allowed i.e. +1217-234-1234 or 1217 234 1234 or 217-234-1234.	+1-217-234-1234|1 217 234 1234|217 234 1234	+1-217-234-1234|1 217 234 1234|217 234 1234	Illinois
155	10	224	(?:\\+?1[ -]?)?224[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?224[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1224-234-1234 or 1224 234 1234 or 224-234-1234.	Only +digits or local formats allowed i.e. +1224-234-1234 or 1224 234 1234 or 224-234-1234.	+1-224-234-1234|1 224 234 1234|224 234 1234	+1-224-234-1234|1 224 234 1234|224 234 1234	Illinois
156	10	309	(?:\\+?1[ -]?)?309[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?309[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1309-234-1234 or 1309 234 1234 or 309-234-1234.	Only +digits or local formats allowed i.e. +1309-234-1234 or 1309 234 1234 or 309-234-1234.	+1-309-234-1234|1 309 234 1234|309 234 1234	+1-309-234-1234|1 309 234 1234|309 234 1234	Illinois
157	10	312	(?:\\+?1[ -]?)?312[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?312[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1312-234-1234 or 1312 234 1234 or 312-234-1234.	Only +digits or local formats allowed i.e. +1312-234-1234 or 1312 234 1234 or 312-234-1234.	+1-312-234-1234|1 312 234 1234|312 234 1234	+1-312-234-1234|1 312 234 1234|312 234 1234	Illinois
158	10	331	(?:\\+?1[ -]?)?331[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?331[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1331-234-1234 or 1331 234 1234 or 331-234-1234.	Only +digits or local formats allowed i.e. +1331-234-1234 or 1331 234 1234 or 331-234-1234.	+1-331-234-1234|1 331 234 1234|331 234 1234	+1-331-234-1234|1 331 234 1234|331 234 1234	Illinois
159	10	464	(?:\\+?1[ -]?)?464[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?464[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1464-234-1234 or 1464 234 1234 or 464-234-1234.	Only +digits or local formats allowed i.e. +1464-234-1234 or 1464 234 1234 or 464-234-1234.	+1-464-234-1234|1 464 234 1234|464 234 1234	+1-464-234-1234|1 464 234 1234|464 234 1234	Illinois
160	10	618	(?:\\+?1[ -]?)?618[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?618[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1618-234-1234 or 1618 234 1234 or 618-234-1234.	Only +digits or local formats allowed i.e. +1618-234-1234 or 1618 234 1234 or 618-234-1234.	+1-618-234-1234|1 618 234 1234|618 234 1234	+1-618-234-1234|1 618 234 1234|618 234 1234	Illinois
161	10	706	(?:\\+?1[ -]?)?706[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?706[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1706-234-1234 or 1706 234 1234 or 706-234-1234.	Only +digits or local formats allowed i.e. +1706-234-1234 or 1706 234 1234 or 706-234-1234.	+1-706-234-1234|1 706 234 1234|706 234 1234	+1-706-234-1234|1 706 234 1234|706 234 1234	Georgia
162	10	762	(?:\\+?1[ -]?)?762[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?762[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1762-234-1234 or 1762 234 1234 or 762-234-1234.	Only +digits or local formats allowed i.e. +1762-234-1234 or 1762 234 1234 or 762-234-1234.	+1-762-234-1234|1 762 234 1234|762 234 1234	+1-762-234-1234|1 762 234 1234|762 234 1234	Georgia
163	10	779	(?:\\+?1[ -]?)?779[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?779[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1779-234-1234 or 1779 234 1234 or 779-234-1234.	Only +digits or local formats allowed i.e. +1779-234-1234 or 1779 234 1234 or 779-234-1234.	+1-779-234-1234|1 779 234 1234|779 234 1234	+1-779-234-1234|1 779 234 1234|779 234 1234	Illinois
164	10	815	(?:\\+?1[ -]?)?815[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?815[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1815-234-1234 or 1815 234 1234 or 815-234-1234.	Only +digits or local formats allowed i.e. +1815-234-1234 or 1815 234 1234 or 815-234-1234.	+1-815-234-1234|1 815 234 1234|815 234 1234	+1-815-234-1234|1 815 234 1234|815 234 1234	Illinois
165	10	847	(?:\\+?1[ -]?)?847[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?847[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1847-234-1234 or 1847 234 1234 or 847-234-1234.	Only +digits or local formats allowed i.e. +1847-234-1234 or 1847 234 1234 or 847-234-1234.	+1-847-234-1234|1 847 234 1234|847 234 1234	+1-847-234-1234|1 847 234 1234|847 234 1234	Illinois
166	10	872	(?:\\+?1[ -]?)?872[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?872[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1872-234-1234 or 1872 234 1234 or 872-234-1234.	Only +digits or local formats allowed i.e. +1872-234-1234 or 1872 234 1234 or 872-234-1234.	+1-872-234-1234|1 872 234 1234|872 234 1234	+1-872-234-1234|1 872 234 1234|872 234 1234	Illinois
167	10	219	(?:\\+?1[ -]?)?219[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?219[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1219-234-1234 or 1219 234 1234 or 219-234-1234.	Only +digits or local formats allowed i.e. +1219-234-1234 or 1219 234 1234 or 219-234-1234.	+1-219-234-1234|1 219 234 1234|219 234 1234	+1-219-234-1234|1 219 234 1234|219 234 1234	Indiana
168	10	260	(?:\\+?1[ -]?)?260[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?260[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1260-234-1234 or 1260 234 1234 or 260-234-1234.	Only +digits or local formats allowed i.e. +1260-234-1234 or 1260 234 1234 or 260-234-1234.	+1-260-234-1234|1 260 234 1234|260 234 1234	+1-260-234-1234|1 260 234 1234|260 234 1234	Indiana
169	10	317	(?:\\+?1[ -]?)?317[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?317[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1317-234-1234 or 1317 234 1234 or 317-234-1234.	Only +digits or local formats allowed i.e. +1317-234-1234 or 1317 234 1234 or 317-234-1234.	+1-317-234-1234|1 317 234 1234|317 234 1234	+1-317-234-1234|1 317 234 1234|317 234 1234	Indiana
170	10	463	(?:\\+?1[ -]?)?463[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?463[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1463-234-1234 or 1463 234 1234 or 463-234-1234.	Only +digits or local formats allowed i.e. +1463-234-1234 or 1463 234 1234 or 463-234-1234.	+1-463-234-1234|1 463 234 1234|463 234 1234	+1-463-234-1234|1 463 234 1234|463 234 1234	Indiana
171	10	574	(?:\\+?1[ -]?)?574[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?574[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1574-234-1234 or 1574 234 1234 or 574-234-1234.	Only +digits or local formats allowed i.e. +1574-234-1234 or 1574 234 1234 or 574-234-1234.	+1-574-234-1234|1 574 234 1234|574 234 1234	+1-574-234-1234|1 574 234 1234|574 234 1234	Indiana
172	10	765	(?:\\+?1[ -]?)?765[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?765[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1765-234-1234 or 1765 234 1234 or 765-234-1234.	Only +digits or local formats allowed i.e. +1765-234-1234 or 1765 234 1234 or 765-234-1234.	+1-765-234-1234|1 765 234 1234|765 234 1234	+1-765-234-1234|1 765 234 1234|765 234 1234	Indiana
173	10	812	(?:\\+?1[ -]?)?812[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?812[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1812-234-1234 or 1812 234 1234 or 812-234-1234.	Only +digits or local formats allowed i.e. +1812-234-1234 or 1812 234 1234 or 812-234-1234.	+1-812-234-1234|1 812 234 1234|812 234 1234	+1-812-234-1234|1 812 234 1234|812 234 1234	Indiana
174	10	319	(?:\\+?1[ -]?)?319[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?319[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1319-234-1234 or 1319 234 1234 or 319-234-1234.	Only +digits or local formats allowed i.e. +1319-234-1234 or 1319 234 1234 or 319-234-1234.	+1-319-234-1234|1 319 234 1234|319 234 1234	+1-319-234-1234|1 319 234 1234|319 234 1234	Iowa
175	10	515	(?:\\+?1[ -]?)?515[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?515[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1515-234-1234 or 1515 234 1234 or 515-234-1234.	Only +digits or local formats allowed i.e. +1515-234-1234 or 1515 234 1234 or 515-234-1234.	+1-515-234-1234|1 515 234 1234|515 234 1234	+1-515-234-1234|1 515 234 1234|515 234 1234	Iowa
176	10	730	(?:\\+?1[ -]?)?730[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?730[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1730-234-1234 or 1730 234 1234 or 730-234-1234.	Only +digits or local formats allowed i.e. +1730-234-1234 or 1730 234 1234 or 730-234-1234.	+1-730-234-1234|1 730 234 1234|730 234 1234	+1-730-234-1234|1 730 234 1234|730 234 1234	Illinois
177	10	773	(?:\\+?1[ -]?)?773[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?773[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1773-234-1234 or 1773 234 1234 or 773-234-1234.	Only +digits or local formats allowed i.e. +1773-234-1234 or 1773 234 1234 or 773-234-1234.	+1-773-234-1234|1 773 234 1234|773 234 1234	+1-773-234-1234|1 773 234 1234|773 234 1234	Illinois
178	10	712	(?:\\+?1[ -]?)?712[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?712[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1712-234-1234 or 1712 234 1234 or 712-234-1234.	Only +digits or local formats allowed i.e. +1712-234-1234 or 1712 234 1234 or 712-234-1234.	+1-712-234-1234|1 712 234 1234|712 234 1234	+1-712-234-1234|1 712 234 1234|712 234 1234	Iowa
179	10	316	(?:\\+?1[ -]?)?316[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?316[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1316-234-1234 or 1316 234 1234 or 316-234-1234.	Only +digits or local formats allowed i.e. +1316-234-1234 or 1316 234 1234 or 316-234-1234.	+1-316-234-1234|1 316 234 1234|316 234 1234	+1-316-234-1234|1 316 234 1234|316 234 1234	Kansas
180	10	620	(?:\\+?1[ -]?)?620[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?620[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1620-234-1234 or 1620 234 1234 or 620-234-1234.	Only +digits or local formats allowed i.e. +1620-234-1234 or 1620 234 1234 or 620-234-1234.	+1-620-234-1234|1 620 234 1234|620 234 1234	+1-620-234-1234|1 620 234 1234|620 234 1234	Kansas
181	10	785	(?:\\+?1[ -]?)?785[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?785[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1785-234-1234 or 1785 234 1234 or 785-234-1234.	Only +digits or local formats allowed i.e. +1785-234-1234 or 1785 234 1234 or 785-234-1234.	+1-785-234-1234|1 785 234 1234|785 234 1234	+1-785-234-1234|1 785 234 1234|785 234 1234	Kansas
182	10	913	(?:\\+?1[ -]?)?913[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?913[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1913-234-1234 or 1913 234 1234 or 913-234-1234.	Only +digits or local formats allowed i.e. +1913-234-1234 or 1913 234 1234 or 913-234-1234.	+1-913-234-1234|1 913 234 1234|913 234 1234	+1-913-234-1234|1 913 234 1234|913 234 1234	Kansas
183	10	270	(?:\\+?1[ -]?)?270[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?270[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1270-234-1234 or 1270 234 1234 or 270-234-1234.	Only +digits or local formats allowed i.e. +1270-234-1234 or 1270 234 1234 or 270-234-1234.	+1-270-234-1234|1 270 234 1234|270 234 1234	+1-270-234-1234|1 270 234 1234|270 234 1234	Kentucky
184	10	364	(?:\\+?1[ -]?)?364[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?364[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1364-234-1234 or 1364 234 1234 or 364-234-1234.	Only +digits or local formats allowed i.e. +1364-234-1234 or 1364 234 1234 or 364-234-1234.	+1-364-234-1234|1 364 234 1234|364 234 1234	+1-364-234-1234|1 364 234 1234|364 234 1234	Kentucky
185	10	502	(?:\\+?1[ -]?)?502[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?502[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1502-234-1234 or 1502 234 1234 or 502-234-1234.	Only +digits or local formats allowed i.e. +1502-234-1234 or 1502 234 1234 or 502-234-1234.	+1-502-234-1234|1 502 234 1234|502 234 1234	+1-502-234-1234|1 502 234 1234|502 234 1234	Kentucky
186	10	859	(?:\\+?1[ -]?)?859[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?859[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1859-234-1234 or 1859 234 1234 or 859-234-1234.	Only +digits or local formats allowed i.e. +1859-234-1234 or 1859 234 1234 or 859-234-1234.	+1-859-234-1234|1 859 234 1234|859 234 1234	+1-859-234-1234|1 859 234 1234|859 234 1234	Kentucky
187	10	318	(?:\\+?1[ -]?)?318[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?318[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1318-234-1234 or 1318 234 1234 or 318-234-1234.	Only +digits or local formats allowed i.e. +1318-234-1234 or 1318 234 1234 or 318-234-1234.	+1-318-234-1234|1 318 234 1234|318 234 1234	+1-318-234-1234|1 318 234 1234|318 234 1234	Louisiana
188	10	337	(?:\\+?1[ -]?)?337[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?337[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1337-234-1234 or 1337 234 1234 or 337-234-1234.	Only +digits or local formats allowed i.e. +1337-234-1234 or 1337 234 1234 or 337-234-1234.	+1-337-234-1234|1 337 234 1234|337 234 1234	+1-337-234-1234|1 337 234 1234|337 234 1234	Louisiana
189	10	504	(?:\\+?1[ -]?)?504[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?504[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1504-234-1234 or 1504 234 1234 or 504-234-1234.	Only +digits or local formats allowed i.e. +1504-234-1234 or 1504 234 1234 or 504-234-1234.	+1-504-234-1234|1 504 234 1234|504 234 1234	+1-504-234-1234|1 504 234 1234|504 234 1234	Louisiana
190	10	985	(?:\\+?1[ -]?)?985[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?985[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1985-234-1234 or 1985 234 1234 or 985-234-1234.	Only +digits or local formats allowed i.e. +1985-234-1234 or 1985 234 1234 or 985-234-1234.	+1-985-234-1234|1 985 234 1234|985 234 1234	+1-985-234-1234|1 985 234 1234|985 234 1234	Louisiana
191	10	563	(?:\\+?1[ -]?)?563[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?563[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1563-234-1234 or 1563 234 1234 or 563-234-1234.	Only +digits or local formats allowed i.e. +1563-234-1234 or 1563 234 1234 or 563-234-1234.	+1-563-234-1234|1 563 234 1234|563 234 1234	+1-563-234-1234|1 563 234 1234|563 234 1234	Iowa
192	10	641	(?:\\+?1[ -]?)?641[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?641[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1641-234-1234 or 1641 234 1234 or 641-234-1234.	Only +digits or local formats allowed i.e. +1641-234-1234 or 1641 234 1234 or 641-234-1234.	+1-641-234-1234|1 641 234 1234|641 234 1234	+1-641-234-1234|1 641 234 1234|641 234 1234	Iowa
193	10	240	(?:\\+?1[ -]?)?240[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?240[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1240-234-1234 or 1240 234 1234 or 240-234-1234.	Only +digits or local formats allowed i.e. +1240-234-1234 or 1240 234 1234 or 240-234-1234.	+1-240-234-1234|1 240 234 1234|240 234 1234	+1-240-234-1234|1 240 234 1234|240 234 1234	Maryland
194	10	301	(?:\\+?1[ -]?)?301[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?301[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1301-234-1234 or 1301 234 1234 or 301-234-1234.	Only +digits or local formats allowed i.e. +1301-234-1234 or 1301 234 1234 or 301-234-1234.	+1-301-234-1234|1 301 234 1234|301 234 1234	+1-301-234-1234|1 301 234 1234|301 234 1234	Maryland
195	10	410	(?:\\+?1[ -]?)?410[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?410[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1410-234-1234 or 1410 234 1234 or 410-234-1234.	Only +digits or local formats allowed i.e. +1410-234-1234 or 1410 234 1234 or 410-234-1234.	+1-410-234-1234|1 410 234 1234|410 234 1234	+1-410-234-1234|1 410 234 1234|410 234 1234	Maryland
196	10	443	(?:\\+?1[ -]?)?443[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?443[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1443-234-1234 or 1443 234 1234 or 443-234-1234.	Only +digits or local formats allowed i.e. +1443-234-1234 or 1443 234 1234 or 443-234-1234.	+1-443-234-1234|1 443 234 1234|443 234 1234	+1-443-234-1234|1 443 234 1234|443 234 1234	Maryland
197	10	667	(?:\\+?1[ -]?)?667[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?667[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1667-234-1234 or 1667 234 1234 or 667-234-1234.	Only +digits or local formats allowed i.e. +1667-234-1234 or 1667 234 1234 or 667-234-1234.	+1-667-234-1234|1 667 234 1234|667 234 1234	+1-667-234-1234|1 667 234 1234|667 234 1234	Maryland
198	10	339	(?:\\+?1[ -]?)?339[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?339[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1339-234-1234 or 1339 234 1234 or 339-234-1234.	Only +digits or local formats allowed i.e. +1339-234-1234 or 1339 234 1234 or 339-234-1234.	+1-339-234-1234|1 339 234 1234|339 234 1234	+1-339-234-1234|1 339 234 1234|339 234 1234	Massachusetts
199	10	351	(?:\\+?1[ -]?)?351[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?351[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1351-234-1234 or 1351 234 1234 or 351-234-1234.	Only +digits or local formats allowed i.e. +1351-234-1234 or 1351 234 1234 or 351-234-1234.	+1-351-234-1234|1 351 234 1234|351 234 1234	+1-351-234-1234|1 351 234 1234|351 234 1234	Massachusetts
200	10	413	(?:\\+?1[ -]?)?413[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?413[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1413-234-1234 or 1413 234 1234 or 413-234-1234.	Only +digits or local formats allowed i.e. +1413-234-1234 or 1413 234 1234 or 413-234-1234.	+1-413-234-1234|1 413 234 1234|413 234 1234	+1-413-234-1234|1 413 234 1234|413 234 1234	Massachusetts
201	10	508	(?:\\+?1[ -]?)?508[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?508[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1508-234-1234 or 1508 234 1234 or 508-234-1234.	Only +digits or local formats allowed i.e. +1508-234-1234 or 1508 234 1234 or 508-234-1234.	+1-508-234-1234|1 508 234 1234|508 234 1234	+1-508-234-1234|1 508 234 1234|508 234 1234	Massachusetts
202	10	774	(?:\\+?1[ -]?)?774[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?774[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1774-234-1234 or 1774 234 1234 or 774-234-1234.	Only +digits or local formats allowed i.e. +1774-234-1234 or 1774 234 1234 or 774-234-1234.	+1-774-234-1234|1 774 234 1234|774 234 1234	+1-774-234-1234|1 774 234 1234|774 234 1234	Massachusetts
203	10	781	(?:\\+?1[ -]?)?781[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?781[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1781-234-1234 or 1781 234 1234 or 781-234-1234.	Only +digits or local formats allowed i.e. +1781-234-1234 or 1781 234 1234 or 781-234-1234.	+1-781-234-1234|1 781 234 1234|781 234 1234	+1-781-234-1234|1 781 234 1234|781 234 1234	Massachusetts
204	10	857	(?:\\+?1[ -]?)?857[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?857[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1857-234-1234 or 1857 234 1234 or 857-234-1234.	Only +digits or local formats allowed i.e. +1857-234-1234 or 1857 234 1234 or 857-234-1234.	+1-857-234-1234|1 857 234 1234|857 234 1234	+1-857-234-1234|1 857 234 1234|857 234 1234	Massachusetts
205	10	978	(?:\\+?1[ -]?)?978[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?978[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1978-234-1234 or 1978 234 1234 or 978-234-1234.	Only +digits or local formats allowed i.e. +1978-234-1234 or 1978 234 1234 or 978-234-1234.	+1-978-234-1234|1 978 234 1234|978 234 1234	+1-978-234-1234|1 978 234 1234|978 234 1234	Massachusetts
206	10	207	(?:\\+?1[ -]?)?207[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?207[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1207-234-1234 or 1207 234 1234 or 207-234-1234.	Only +digits or local formats allowed i.e. +1207-234-1234 or 1207 234 1234 or 207-234-1234.	+1-207-234-1234|1 207 234 1234|207 234 1234	+1-207-234-1234|1 207 234 1234|207 234 1234	Maine
207	10	227	(?:\\+?1[ -]?)?227[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?227[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1227-234-1234 or 1227 234 1234 or 227-234-1234.	Only +digits or local formats allowed i.e. +1227-234-1234 or 1227 234 1234 or 227-234-1234.	+1-227-234-1234|1 227 234 1234|227 234 1234	+1-227-234-1234|1 227 234 1234|227 234 1234	Maryland
208	10	517	(?:\\+?1[ -]?)?517[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?517[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1517-234-1234 or 1517 234 1234 or 517-234-1234.	Only +digits or local formats allowed i.e. +1517-234-1234 or 1517 234 1234 or 517-234-1234.	+1-517-234-1234|1 517 234 1234|517 234 1234	+1-517-234-1234|1 517 234 1234|517 234 1234	Michigan
209	10	586	(?:\\+?1[ -]?)?586[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?586[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1586-234-1234 or 1586 234 1234 or 586-234-1234.	Only +digits or local formats allowed i.e. +1586-234-1234 or 1586 234 1234 or 586-234-1234.	+1-586-234-1234|1 586 234 1234|586 234 1234	+1-586-234-1234|1 586 234 1234|586 234 1234	Michigan
210	10	616	(?:\\+?1[ -]?)?616[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?616[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1616-234-1234 or 1616 234 1234 or 616-234-1234.	Only +digits or local formats allowed i.e. +1616-234-1234 or 1616 234 1234 or 616-234-1234.	+1-616-234-1234|1 616 234 1234|616 234 1234	+1-616-234-1234|1 616 234 1234|616 234 1234	Michigan
211	10	679	(?:\\+?1[ -]?)?679[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?679[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1679-234-1234 or 1679 234 1234 or 679-234-1234.	Only +digits or local formats allowed i.e. +1679-234-1234 or 1679 234 1234 or 679-234-1234.	+1-679-234-1234|1 679 234 1234|679 234 1234	+1-679-234-1234|1 679 234 1234|679 234 1234	Michigan
212	10	734	(?:\\+?1[ -]?)?734[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?734[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1734-234-1234 or 1734 234 1234 or 734-234-1234.	Only +digits or local formats allowed i.e. +1734-234-1234 or 1734 234 1234 or 734-234-1234.	+1-734-234-1234|1 734 234 1234|734 234 1234	+1-734-234-1234|1 734 234 1234|734 234 1234	Michigan
213	10	810	(?:\\+?1[ -]?)?810[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?810[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1810-234-1234 or 1810 234 1234 or 810-234-1234.	Only +digits or local formats allowed i.e. +1810-234-1234 or 1810 234 1234 or 810-234-1234.	+1-810-234-1234|1 810 234 1234|810 234 1234	+1-810-234-1234|1 810 234 1234|810 234 1234	Michigan
214	10	906	(?:\\+?1[ -]?)?906[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?906[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1906-234-1234 or 1906 234 1234 or 906-234-1234.	Only +digits or local formats allowed i.e. +1906-234-1234 or 1906 234 1234 or 906-234-1234.	+1-906-234-1234|1 906 234 1234|906 234 1234	+1-906-234-1234|1 906 234 1234|906 234 1234	Michigan
215	10	947	(?:\\+?1[ -]?)?947[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?947[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1947-234-1234 or 1947 234 1234 or 947-234-1234.	Only +digits or local formats allowed i.e. +1947-234-1234 or 1947 234 1234 or 947-234-1234.	+1-947-234-1234|1 947 234 1234|947 234 1234	+1-947-234-1234|1 947 234 1234|947 234 1234	Michigan
216	10	989	(?:\\+?1[ -]?)?989[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?989[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1989-234-1234 or 1989 234 1234 or 989-234-1234.	Only +digits or local formats allowed i.e. +1989-234-1234 or 1989 234 1234 or 989-234-1234.	+1-989-234-1234|1 989 234 1234|989 234 1234	+1-989-234-1234|1 989 234 1234|989 234 1234	Michigan
217	10	218	(?:\\+?1[ -]?)?218[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?218[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1218-234-1234 or 1218 234 1234 or 218-234-1234.	Only +digits or local formats allowed i.e. +1218-234-1234 or 1218 234 1234 or 218-234-1234.	+1-218-234-1234|1 218 234 1234|218 234 1234	+1-218-234-1234|1 218 234 1234|218 234 1234	Minnesota
218	10	507	(?:\\+?1[ -]?)?507[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?507[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1507-234-1234 or 1507 234 1234 or 507-234-1234.	Only +digits or local formats allowed i.e. +1507-234-1234 or 1507 234 1234 or 507-234-1234.	+1-507-234-1234|1 507 234 1234|507 234 1234	+1-507-234-1234|1 507 234 1234|507 234 1234	Minnesota
219	10	612	(?:\\+?1[ -]?)?612[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?612[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1612-234-1234 or 1612 234 1234 or 612-234-1234.	Only +digits or local formats allowed i.e. +1612-234-1234 or 1612 234 1234 or 612-234-1234.	+1-612-234-1234|1 612 234 1234|612 234 1234	+1-612-234-1234|1 612 234 1234|612 234 1234	Minnesota
220	10	402	(?:\\+?1[ -]?)?402[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?402[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1402-234-1234 or 1402 234 1234 or 402-234-1234.	Only +digits or local formats allowed i.e. +1402-234-1234 or 1402 234 1234 or 402-234-1234.	+1-402-234-1234|1 402 234 1234|402 234 1234	+1-402-234-1234|1 402 234 1234|402 234 1234	Nebraska
221	10	269	(?:\\+?1[ -]?)?269[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?269[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1269-234-1234 or 1269 234 1234 or 269-234-1234.	Only +digits or local formats allowed i.e. +1269-234-1234 or 1269 234 1234 or 269-234-1234.	+1-269-234-1234|1 269 234 1234|269 234 1234	+1-269-234-1234|1 269 234 1234|269 234 1234	Michigan
222	10	313	(?:\\+?1[ -]?)?313[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?313[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1313-234-1234 or 1313 234 1234 or 313-234-1234.	Only +digits or local formats allowed i.e. +1313-234-1234 or 1313 234 1234 or 313-234-1234.	+1-313-234-1234|1 313 234 1234|313 234 1234	+1-313-234-1234|1 313 234 1234|313 234 1234	Michigan
223	10	228	(?:\\+?1[ -]?)?228[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?228[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1228-234-1234 or 1228 234 1234 or 228-234-1234.	Only +digits or local formats allowed i.e. +1228-234-1234 or 1228 234 1234 or 228-234-1234.	+1-228-234-1234|1 228 234 1234|228 234 1234	+1-228-234-1234|1 228 234 1234|228 234 1234	Mississippi
224	10	601	(?:\\+?1[ -]?)?601[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?601[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1601-234-1234 or 1601 234 1234 or 601-234-1234.	Only +digits or local formats allowed i.e. +1601-234-1234 or 1601 234 1234 or 601-234-1234.	+1-601-234-1234|1 601 234 1234|601 234 1234	+1-601-234-1234|1 601 234 1234|601 234 1234	Mississippi
225	10	662	(?:\\+?1[ -]?)?662[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?662[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1662-234-1234 or 1662 234 1234 or 662-234-1234.	Only +digits or local formats allowed i.e. +1662-234-1234 or 1662 234 1234 or 662-234-1234.	+1-662-234-1234|1 662 234 1234|662 234 1234	+1-662-234-1234|1 662 234 1234|662 234 1234	Mississippi
226	10	769	(?:\\+?1[ -]?)?769[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?769[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1769-234-1234 or 1769 234 1234 or 769-234-1234.	Only +digits or local formats allowed i.e. +1769-234-1234 or 1769 234 1234 or 769-234-1234.	+1-769-234-1234|1 769 234 1234|769 234 1234	+1-769-234-1234|1 769 234 1234|769 234 1234	Mississippi
227	10	314	(?:\\+?1[ -]?)?314[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?314[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1314-234-1234 or 1314 234 1234 or 314-234-1234.	Only +digits or local formats allowed i.e. +1314-234-1234 or 1314 234 1234 or 314-234-1234.	+1-314-234-1234|1 314 234 1234|314 234 1234	+1-314-234-1234|1 314 234 1234|314 234 1234	Missouri
228	10	417	(?:\\+?1[ -]?)?417[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?417[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1417-234-1234 or 1417 234 1234 or 417-234-1234.	Only +digits or local formats allowed i.e. +1417-234-1234 or 1417 234 1234 or 417-234-1234.	+1-417-234-1234|1 417 234 1234|417 234 1234	+1-417-234-1234|1 417 234 1234|417 234 1234	Missouri
229	10	557	(?:\\+?1[ -]?)?557[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?557[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1557-234-1234 or 1557 234 1234 or 557-234-1234.	Only +digits or local formats allowed i.e. +1557-234-1234 or 1557 234 1234 or 557-234-1234.	+1-557-234-1234|1 557 234 1234|557 234 1234	+1-557-234-1234|1 557 234 1234|557 234 1234	Missouri
230	10	573	(?:\\+?1[ -]?)?573[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?573[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1573-234-1234 or 1573 234 1234 or 573-234-1234.	Only +digits or local formats allowed i.e. +1573-234-1234 or 1573 234 1234 or 573-234-1234.	+1-573-234-1234|1 573 234 1234|573 234 1234	+1-573-234-1234|1 573 234 1234|573 234 1234	Missouri
231	10	636	(?:\\+?1[ -]?)?636[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?636[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1636-234-1234 or 1636 234 1234 or 636-234-1234.	Only +digits or local formats allowed i.e. +1636-234-1234 or 1636 234 1234 or 636-234-1234.	+1-636-234-1234|1 636 234 1234|636 234 1234	+1-636-234-1234|1 636 234 1234|636 234 1234	Missouri
232	10	660	(?:\\+?1[ -]?)?660[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?660[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1660-234-1234 or 1660 234 1234 or 660-234-1234.	Only +digits or local formats allowed i.e. +1660-234-1234 or 1660 234 1234 or 660-234-1234.	+1-660-234-1234|1 660 234 1234|660 234 1234	+1-660-234-1234|1 660 234 1234|660 234 1234	Missouri
233	10	816	(?:\\+?1[ -]?)?816[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?816[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1816-234-1234 or 1816 234 1234 or 816-234-1234.	Only +digits or local formats allowed i.e. +1816-234-1234 or 1816 234 1234 or 816-234-1234.	+1-816-234-1234|1 816 234 1234|816 234 1234	+1-816-234-1234|1 816 234 1234|816 234 1234	Missouri
234	10	406	(?:\\+?1[ -]?)?406[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?406[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1406-234-1234 or 1406 234 1234 or 406-234-1234.	Only +digits or local formats allowed i.e. +1406-234-1234 or 1406 234 1234 or 406-234-1234.	+1-406-234-1234|1 406 234 1234|406 234 1234	+1-406-234-1234|1 406 234 1234|406 234 1234	Montana
235	10	308	(?:\\+?1[ -]?)?308[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?308[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1308-234-1234 or 1308 234 1234 or 308-234-1234.	Only +digits or local formats allowed i.e. +1308-234-1234 or 1308 234 1234 or 308-234-1234.	+1-308-234-1234|1 308 234 1234|308 234 1234	+1-308-234-1234|1 308 234 1234|308 234 1234	Nebraska
236	10	763	(?:\\+?1[ -]?)?763[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?763[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1763-234-1234 or 1763 234 1234 or 763-234-1234.	Only +digits or local formats allowed i.e. +1763-234-1234 or 1763 234 1234 or 763-234-1234.	+1-763-234-1234|1 763 234 1234|763 234 1234	+1-763-234-1234|1 763 234 1234|763 234 1234	Minnesota
237	10	952	(?:\\+?1[ -]?)?952[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?952[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1952-234-1234 or 1952 234 1234 or 952-234-1234.	Only +digits or local formats allowed i.e. +1952-234-1234 or 1952 234 1234 or 952-234-1234.	+1-952-234-1234|1 952 234 1234|952 234 1234	+1-952-234-1234|1 952 234 1234|952 234 1234	Minnesota
238	10	775	(?:\\+?1[ -]?)?775[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?775[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1775-234-1234 or 1775 234 1234 or 775-234-1234.	Only +digits or local formats allowed i.e. +1775-234-1234 or 1775 234 1234 or 775-234-1234.	+1-775-234-1234|1 775 234 1234|775 234 1234	+1-775-234-1234|1 775 234 1234|775 234 1234	Nevada
239	10	603	(?:\\+?1[ -]?)?603[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?603[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1603-234-1234 or 1603 234 1234 or 603-234-1234.	Only +digits or local formats allowed i.e. +1603-234-1234 or 1603 234 1234 or 603-234-1234.	+1-603-234-1234|1 603 234 1234|603 234 1234	+1-603-234-1234|1 603 234 1234|603 234 1234	New Hampshire
240	10	201	(?:\\+?1[ -]?)?201[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?201[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1201-234-1234 or 1201 234 1234 or 201-234-1234.	Only +digits or local formats allowed i.e. +1201-234-1234 or 1201 234 1234 or 201-234-1234.	+1-201-234-1234|1 201 234 1234|201 234 1234	+1-201-234-1234|1 201 234 1234|201 234 1234	New Jersey
241	10	551	(?:\\+?1[ -]?)?551[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?551[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1551-234-1234 or 1551 234 1234 or 551-234-1234.	Only +digits or local formats allowed i.e. +1551-234-1234 or 1551 234 1234 or 551-234-1234.	+1-551-234-1234|1 551 234 1234|551 234 1234	+1-551-234-1234|1 551 234 1234|551 234 1234	New Jersey
242	10	609	(?:\\+?1[ -]?)?609[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?609[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1609-234-1234 or 1609 234 1234 or 609-234-1234.	Only +digits or local formats allowed i.e. +1609-234-1234 or 1609 234 1234 or 609-234-1234.	+1-609-234-1234|1 609 234 1234|609 234 1234	+1-609-234-1234|1 609 234 1234|609 234 1234	New Jersey
243	10	640	(?:\\+?1[ -]?)?640[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?640[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1640-234-1234 or 1640 234 1234 or 640-234-1234.	Only +digits or local formats allowed i.e. +1640-234-1234 or 1640 234 1234 or 640-234-1234.	+1-640-234-1234|1 640 234 1234|640 234 1234	+1-640-234-1234|1 640 234 1234|640 234 1234	New Jersey
244	10	732	(?:\\+?1[ -]?)?732[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?732[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1732-234-1234 or 1732 234 1234 or 732-234-1234.	Only +digits or local formats allowed i.e. +1732-234-1234 or 1732 234 1234 or 732-234-1234.	+1-732-234-1234|1 732 234 1234|732 234 1234	+1-732-234-1234|1 732 234 1234|732 234 1234	New Jersey
245	10	848	(?:\\+?1[ -]?)?848[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?848[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1848-234-1234 or 1848 234 1234 or 848-234-1234.	Only +digits or local formats allowed i.e. +1848-234-1234 or 1848 234 1234 or 848-234-1234.	+1-848-234-1234|1 848 234 1234|848 234 1234	+1-848-234-1234|1 848 234 1234|848 234 1234	New Jersey
246	10	856	(?:\\+?1[ -]?)?856[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?856[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1856-234-1234 or 1856 234 1234 or 856-234-1234.	Only +digits or local formats allowed i.e. +1856-234-1234 or 1856 234 1234 or 856-234-1234.	+1-856-234-1234|1 856 234 1234|856 234 1234	+1-856-234-1234|1 856 234 1234|856 234 1234	New Jersey
247	10	862	(?:\\+?1[ -]?)?862[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?862[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1862-234-1234 or 1862 234 1234 or 862-234-1234.	Only +digits or local formats allowed i.e. +1862-234-1234 or 1862 234 1234 or 862-234-1234.	+1-862-234-1234|1 862 234 1234|862 234 1234	+1-862-234-1234|1 862 234 1234|862 234 1234	New Jersey
248	10	973	(?:\\+?1[ -]?)?973[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?973[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1973-234-1234 or 1973 234 1234 or 973-234-1234.	Only +digits or local formats allowed i.e. +1973-234-1234 or 1973 234 1234 or 973-234-1234.	+1-973-234-1234|1 973 234 1234|973 234 1234	+1-973-234-1234|1 973 234 1234|973 234 1234	New Jersey
249	10	505	(?:\\+?1[ -]?)?505[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?505[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1505-234-1234 or 1505 234 1234 or 505-234-1234.	Only +digits or local formats allowed i.e. +1505-234-1234 or 1505 234 1234 or 505-234-1234.	+1-505-234-1234|1 505 234 1234|505 234 1234	+1-505-234-1234|1 505 234 1234|505 234 1234	New Mexico
250	10	575	(?:\\+?1[ -]?)?575[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?575[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1575-234-1234 or 1575 234 1234 or 575-234-1234.	Only +digits or local formats allowed i.e. +1575-234-1234 or 1575 234 1234 or 575-234-1234.	+1-575-234-1234|1 575 234 1234|575 234 1234	+1-575-234-1234|1 575 234 1234|575 234 1234	New Mexico
251	10	702	(?:\\+?1[ -]?)?702[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?702[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1702-234-1234 or 1702 234 1234 or 702-234-1234.	Only +digits or local formats allowed i.e. +1702-234-1234 or 1702 234 1234 or 702-234-1234.	+1-702-234-1234|1 702 234 1234|702 234 1234	+1-702-234-1234|1 702 234 1234|702 234 1234	Nevada
252	10	725	(?:\\+?1[ -]?)?725[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?725[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1725-234-1234 or 1725 234 1234 or 725-234-1234.	Only +digits or local formats allowed i.e. +1725-234-1234 or 1725 234 1234 or 725-234-1234.	+1-725-234-1234|1 725 234 1234|725 234 1234	+1-725-234-1234|1 725 234 1234|725 234 1234	Nevada
253	10	363	(?:\\+?1[ -]?)?363[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?363[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1363-234-1234 or 1363 234 1234 or 363-234-1234.	Only +digits or local formats allowed i.e. +1363-234-1234 or 1363 234 1234 or 363-234-1234.	+1-363-234-1234|1 363 234 1234|363 234 1234	+1-363-234-1234|1 363 234 1234|363 234 1234	New York
254	10	516	(?:\\+?1[ -]?)?516[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?516[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1516-234-1234 or 1516 234 1234 or 516-234-1234.	Only +digits or local formats allowed i.e. +1516-234-1234 or 1516 234 1234 or 516-234-1234.	+1-516-234-1234|1 516 234 1234|516 234 1234	+1-516-234-1234|1 516 234 1234|516 234 1234	New York
255	10	518	(?:\\+?1[ -]?)?518[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?518[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1518-234-1234 or 1518 234 1234 or 518-234-1234.	Only +digits or local formats allowed i.e. +1518-234-1234 or 1518 234 1234 or 518-234-1234.	+1-518-234-1234|1 518 234 1234|518 234 1234	+1-518-234-1234|1 518 234 1234|518 234 1234	New York
256	10	585	(?:\\+?1[ -]?)?585[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?585[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1585-234-1234 or 1585 234 1234 or 585-234-1234.	Only +digits or local formats allowed i.e. +1585-234-1234 or 1585 234 1234 or 585-234-1234.	+1-585-234-1234|1 585 234 1234|585 234 1234	+1-585-234-1234|1 585 234 1234|585 234 1234	New York
257	10	607	(?:\\+?1[ -]?)?607[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?607[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1607-234-1234 or 1607 234 1234 or 607-234-1234.	Only +digits or local formats allowed i.e. +1607-234-1234 or 1607 234 1234 or 607-234-1234.	+1-607-234-1234|1 607 234 1234|607 234 1234	+1-607-234-1234|1 607 234 1234|607 234 1234	New York
258	10	631	(?:\\+?1[ -]?)?631[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?631[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1631-234-1234 or 1631 234 1234 or 631-234-1234.	Only +digits or local formats allowed i.e. +1631-234-1234 or 1631 234 1234 or 631-234-1234.	+1-631-234-1234|1 631 234 1234|631 234 1234	+1-631-234-1234|1 631 234 1234|631 234 1234	New York
259	10	646	(?:\\+?1[ -]?)?646[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?646[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1646-234-1234 or 1646 234 1234 or 646-234-1234.	Only +digits or local formats allowed i.e. +1646-234-1234 or 1646 234 1234 or 646-234-1234.	+1-646-234-1234|1 646 234 1234|646 234 1234	+1-646-234-1234|1 646 234 1234|646 234 1234	New York
260	10	680	(?:\\+?1[ -]?)?680[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?680[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1680-234-1234 or 1680 234 1234 or 680-234-1234.	Only +digits or local formats allowed i.e. +1680-234-1234 or 1680 234 1234 or 680-234-1234.	+1-680-234-1234|1 680 234 1234|680 234 1234	+1-680-234-1234|1 680 234 1234|680 234 1234	New York
261	10	716	(?:\\+?1[ -]?)?716[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?716[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1716-234-1234 or 1716 234 1234 or 716-234-1234.	Only +digits or local formats allowed i.e. +1716-234-1234 or 1716 234 1234 or 716-234-1234.	+1-716-234-1234|1 716 234 1234|716 234 1234	+1-716-234-1234|1 716 234 1234|716 234 1234	New York
262	10	718	(?:\\+?1[ -]?)?718[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?718[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1718-234-1234 or 1718 234 1234 or 718-234-1234.	Only +digits or local formats allowed i.e. +1718-234-1234 or 1718 234 1234 or 718-234-1234.	+1-718-234-1234|1 718 234 1234|718 234 1234	+1-718-234-1234|1 718 234 1234|718 234 1234	New York
263	10	838	(?:\\+?1[ -]?)?838[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?838[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1838-234-1234 or 1838 234 1234 or 838-234-1234.	Only +digits or local formats allowed i.e. +1838-234-1234 or 1838 234 1234 or 838-234-1234.	+1-838-234-1234|1 838 234 1234|838 234 1234	+1-838-234-1234|1 838 234 1234|838 234 1234	New York
264	10	914	(?:\\+?1[ -]?)?914[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?914[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1914-234-1234 or 1914 234 1234 or 914-234-1234.	Only +digits or local formats allowed i.e. +1914-234-1234 or 1914 234 1234 or 914-234-1234.	+1-914-234-1234|1 914 234 1234|914 234 1234	+1-914-234-1234|1 914 234 1234|914 234 1234	New York
265	10	917	(?:\\+?1[ -]?)?917[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?917[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1917-234-1234 or 1917 234 1234 or 917-234-1234.	Only +digits or local formats allowed i.e. +1917-234-1234 or 1917 234 1234 or 917-234-1234.	+1-917-234-1234|1 917 234 1234|917 234 1234	+1-917-234-1234|1 917 234 1234|917 234 1234	New York
266	10	332	(?:\\+?1[ -]?)?332[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?332[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1332-234-1234 or 1332 234 1234 or 332-234-1234.	Only +digits or local formats allowed i.e. +1332-234-1234 or 1332 234 1234 or 332-234-1234.	+1-332-234-1234|1 332 234 1234|332 234 1234	+1-332-234-1234|1 332 234 1234|332 234 1234	New York
267	10	347	(?:\\+?1[ -]?)?347[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?347[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1347-234-1234 or 1347 234 1234 or 347-234-1234.	Only +digits or local formats allowed i.e. +1347-234-1234 or 1347 234 1234 or 347-234-1234.	+1-347-234-1234|1 347 234 1234|347 234 1234	+1-347-234-1234|1 347 234 1234|347 234 1234	New York
268	10	336	(?:\\+?1[ -]?)?336[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?336[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1336-234-1234 or 1336 234 1234 or 336-234-1234.	Only +digits or local formats allowed i.e. +1336-234-1234 or 1336 234 1234 or 336-234-1234.	+1-336-234-1234|1 336 234 1234|336 234 1234	+1-336-234-1234|1 336 234 1234|336 234 1234	North Carolina
269	10	704	(?:\\+?1[ -]?)?704[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?704[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1704-234-1234 or 1704 234 1234 or 704-234-1234.	Only +digits or local formats allowed i.e. +1704-234-1234 or 1704 234 1234 or 704-234-1234.	+1-704-234-1234|1 704 234 1234|704 234 1234	+1-704-234-1234|1 704 234 1234|704 234 1234	North Carolina
270	10	743	(?:\\+?1[ -]?)?743[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?743[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1743-234-1234 or 1743 234 1234 or 743-234-1234.	Only +digits or local formats allowed i.e. +1743-234-1234 or 1743 234 1234 or 743-234-1234.	+1-743-234-1234|1 743 234 1234|743 234 1234	+1-743-234-1234|1 743 234 1234|743 234 1234	North Carolina
271	10	828	(?:\\+?1[ -]?)?828[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?828[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1828-234-1234 or 1828 234 1234 or 828-234-1234.	Only +digits or local formats allowed i.e. +1828-234-1234 or 1828 234 1234 or 828-234-1234.	+1-828-234-1234|1 828 234 1234|828 234 1234	+1-828-234-1234|1 828 234 1234|828 234 1234	North Carolina
272	10	910	(?:\\+?1[ -]?)?910[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?910[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1910-234-1234 or 1910 234 1234 or 910-234-1234.	Only +digits or local formats allowed i.e. +1910-234-1234 or 1910 234 1234 or 910-234-1234.	+1-910-234-1234|1 910 234 1234|910 234 1234	+1-910-234-1234|1 910 234 1234|910 234 1234	North Carolina
273	10	919	(?:\\+?1[ -]?)?919[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?919[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1919-234-1234 or 1919 234 1234 or 919-234-1234.	Only +digits or local formats allowed i.e. +1919-234-1234 or 1919 234 1234 or 919-234-1234.	+1-919-234-1234|1 919 234 1234|919 234 1234	+1-919-234-1234|1 919 234 1234|919 234 1234	North Carolina
274	10	980	(?:\\+?1[ -]?)?980[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?980[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1980-234-1234 or 1980 234 1234 or 980-234-1234.	Only +digits or local formats allowed i.e. +1980-234-1234 or 1980 234 1234 or 980-234-1234.	+1-980-234-1234|1 980 234 1234|980 234 1234	+1-980-234-1234|1 980 234 1234|980 234 1234	North Carolina
275	10	984	(?:\\+?1[ -]?)?984[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?984[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1984-234-1234 or 1984 234 1234 or 984-234-1234.	Only +digits or local formats allowed i.e. +1984-234-1234 or 1984 234 1234 or 984-234-1234.	+1-984-234-1234|1 984 234 1234|984 234 1234	+1-984-234-1234|1 984 234 1234|984 234 1234	North Carolina
276	10	701	(?:\\+?1[ -]?)?701[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?701[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1701-234-1234 or 1701 234 1234 or 701-234-1234.	Only +digits or local formats allowed i.e. +1701-234-1234 or 1701 234 1234 or 701-234-1234.	+1-701-234-1234|1 701 234 1234|701 234 1234	+1-701-234-1234|1 701 234 1234|701 234 1234	North Dakota
277	10	220	(?:\\+?1[ -]?)?220[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?220[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1220-234-1234 or 1220 234 1234 or 220-234-1234.	Only +digits or local formats allowed i.e. +1220-234-1234 or 1220 234 1234 or 220-234-1234.	+1-220-234-1234|1 220 234 1234|220 234 1234	+1-220-234-1234|1 220 234 1234|220 234 1234	Ohio
278	10	234	(?:\\+?1[ -]?)?234[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?234[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1234-234-1234 or 1234 234 1234 or 234-234-1234.	Only +digits or local formats allowed i.e. +1234-234-1234 or 1234 234 1234 or 234-234-1234.	+1-234-234-1234|1 234 234 1234|234 234 1234	+1-234-234-1234|1 234 234 1234|234 234 1234	Ohio
279	10	283	(?:\\+?1[ -]?)?283[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?283[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1283-234-1234 or 1283 234 1234 or 283-234-1234.	Only +digits or local formats allowed i.e. +1283-234-1234 or 1283 234 1234 or 283-234-1234.	+1-283-234-1234|1 283 234 1234|283 234 1234	+1-283-234-1234|1 283 234 1234|283 234 1234	Ohio
280	10	326	(?:\\+?1[ -]?)?326[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?326[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1326-234-1234 or 1326 234 1234 or 326-234-1234.	Only +digits or local formats allowed i.e. +1326-234-1234 or 1326 234 1234 or 326-234-1234.	+1-326-234-1234|1 326 234 1234|326 234 1234	+1-326-234-1234|1 326 234 1234|326 234 1234	Ohio
281	10	934	(?:\\+?1[ -]?)?934[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?934[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1934-234-1234 or 1934 234 1234 or 934-234-1234.	Only +digits or local formats allowed i.e. +1934-234-1234 or 1934 234 1234 or 934-234-1234.	+1-934-234-1234|1 934 234 1234|934 234 1234	+1-934-234-1234|1 934 234 1234|934 234 1234	New York
282	10	252	(?:\\+?1[ -]?)?252[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?252[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1252-234-1234 or 1252 234 1234 or 252-234-1234.	Only +digits or local formats allowed i.e. +1252-234-1234 or 1252 234 1234 or 252-234-1234.	+1-252-234-1234|1 252 234 1234|252 234 1234	+1-252-234-1234|1 252 234 1234|252 234 1234	North Carolina
283	10	513	(?:\\+?1[ -]?)?513[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?513[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1513-234-1234 or 1513 234 1234 or 513-234-1234.	Only +digits or local formats allowed i.e. +1513-234-1234 or 1513 234 1234 or 513-234-1234.	+1-513-234-1234|1 513 234 1234|513 234 1234	+1-513-234-1234|1 513 234 1234|513 234 1234	Ohio
284	10	567	(?:\\+?1[ -]?)?567[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?567[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1567-234-1234 or 1567 234 1234 or 567-234-1234.	Only +digits or local formats allowed i.e. +1567-234-1234 or 1567 234 1234 or 567-234-1234.	+1-567-234-1234|1 567 234 1234|567 234 1234	+1-567-234-1234|1 567 234 1234|567 234 1234	Ohio
285	10	614	(?:\\+?1[ -]?)?614[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?614[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1614-234-1234 or 1614 234 1234 or 614-234-1234.	Only +digits or local formats allowed i.e. +1614-234-1234 or 1614 234 1234 or 614-234-1234.	+1-614-234-1234|1 614 234 1234|614 234 1234	+1-614-234-1234|1 614 234 1234|614 234 1234	Ohio
286	10	740	(?:\\+?1[ -]?)?740[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?740[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1740-234-1234 or 1740 234 1234 or 740-234-1234.	Only +digits or local formats allowed i.e. +1740-234-1234 or 1740 234 1234 or 740-234-1234.	+1-740-234-1234|1 740 234 1234|740 234 1234	+1-740-234-1234|1 740 234 1234|740 234 1234	Ohio
287	10	937	(?:\\+?1[ -]?)?937[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?937[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1937-234-1234 or 1937 234 1234 or 937-234-1234.	Only +digits or local formats allowed i.e. +1937-234-1234 or 1937 234 1234 or 937-234-1234.	+1-937-234-1234|1 937 234 1234|937 234 1234	+1-937-234-1234|1 937 234 1234|937 234 1234	Ohio
288	10	405	(?:\\+?1[ -]?)?405[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?405[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1405-234-1234 or 1405 234 1234 or 405-234-1234.	Only +digits or local formats allowed i.e. +1405-234-1234 or 1405 234 1234 or 405-234-1234.	+1-405-234-1234|1 405 234 1234|405 234 1234	+1-405-234-1234|1 405 234 1234|405 234 1234	Oklahoma
289	10	539	(?:\\+?1[ -]?)?539[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?539[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1539-234-1234 or 1539 234 1234 or 539-234-1234.	Only +digits or local formats allowed i.e. +1539-234-1234 or 1539 234 1234 or 539-234-1234.	+1-539-234-1234|1 539 234 1234|539 234 1234	+1-539-234-1234|1 539 234 1234|539 234 1234	Oklahoma
290	10	572	(?:\\+?1[ -]?)?572[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?572[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1572-234-1234 or 1572 234 1234 or 572-234-1234.	Only +digits or local formats allowed i.e. +1572-234-1234 or 1572 234 1234 or 572-234-1234.	+1-572-234-1234|1 572 234 1234|572 234 1234	+1-572-234-1234|1 572 234 1234|572 234 1234	Oklahoma
291	10	580	(?:\\+?1[ -]?)?580[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?580[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1580-234-1234 or 1580 234 1234 or 580-234-1234.	Only +digits or local formats allowed i.e. +1580-234-1234 or 1580 234 1234 or 580-234-1234.	+1-580-234-1234|1 580 234 1234|580 234 1234	+1-580-234-1234|1 580 234 1234|580 234 1234	Oklahoma
292	10	918	(?:\\+?1[ -]?)?918[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?918[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1918-234-1234 or 1918 234 1234 or 918-234-1234.	Only +digits or local formats allowed i.e. +1918-234-1234 or 1918 234 1234 or 918-234-1234.	+1-918-234-1234|1 918 234 1234|918 234 1234	+1-918-234-1234|1 918 234 1234|918 234 1234	Oklahoma
293	10	458	(?:\\+?1[ -]?)?458[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?458[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1458-234-1234 or 1458 234 1234 or 458-234-1234.	Only +digits or local formats allowed i.e. +1458-234-1234 or 1458 234 1234 or 458-234-1234.	+1-458-234-1234|1 458 234 1234|458 234 1234	+1-458-234-1234|1 458 234 1234|458 234 1234	Oregon
294	10	503	(?:\\+?1[ -]?)?503[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?503[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1503-234-1234 or 1503 234 1234 or 503-234-1234.	Only +digits or local formats allowed i.e. +1503-234-1234 or 1503 234 1234 or 503-234-1234.	+1-503-234-1234|1 503 234 1234|503 234 1234	+1-503-234-1234|1 503 234 1234|503 234 1234	Oregon
295	10	971	(?:\\+?1[ -]?)?971[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?971[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1971-234-1234 or 1971 234 1234 or 971-234-1234.	Only +digits or local formats allowed i.e. +1971-234-1234 or 1971 234 1234 or 971-234-1234.	+1-971-234-1234|1 971 234 1234|971 234 1234	+1-971-234-1234|1 971 234 1234|971 234 1234	Oregon
296	10	380	(?:\\+?1[ -]?)?380[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?380[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1380-234-1234 or 1380 234 1234 or 380-234-1234.	Only +digits or local formats allowed i.e. +1380-234-1234 or 1380 234 1234 or 380-234-1234.	+1-380-234-1234|1 380 234 1234|380 234 1234	+1-380-234-1234|1 380 234 1234|380 234 1234	Ohio
297	10	440	(?:\\+?1[ -]?)?440[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?440[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1440-234-1234 or 1440 234 1234 or 440-234-1234.	Only +digits or local formats allowed i.e. +1440-234-1234 or 1440 234 1234 or 440-234-1234.	+1-440-234-1234|1 440 234 1234|440 234 1234	+1-440-234-1234|1 440 234 1234|440 234 1234	Ohio
298	10	272	(?:\\+?1[ -]?)?272[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?272[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1272-234-1234 or 1272 234 1234 or 272-234-1234.	Only +digits or local formats allowed i.e. +1272-234-1234 or 1272 234 1234 or 272-234-1234.	+1-272-234-1234|1 272 234 1234|272 234 1234	+1-272-234-1234|1 272 234 1234|272 234 1234	Pennsylvania
299	10	412	(?:\\+?1[ -]?)?412[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?412[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1412-234-1234 or 1412 234 1234 or 412-234-1234.	Only +digits or local formats allowed i.e. +1412-234-1234 or 1412 234 1234 or 412-234-1234.	+1-412-234-1234|1 412 234 1234|412 234 1234	+1-412-234-1234|1 412 234 1234|412 234 1234	Pennsylvania
300	10	445	(?:\\+?1[ -]?)?445[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?445[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1445-234-1234 or 1445 234 1234 or 445-234-1234.	Only +digits or local formats allowed i.e. +1445-234-1234 or 1445 234 1234 or 445-234-1234.	+1-445-234-1234|1 445 234 1234|445 234 1234	+1-445-234-1234|1 445 234 1234|445 234 1234	Pennsylvania
301	10	484	(?:\\+?1[ -]?)?484[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?484[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1484-234-1234 or 1484 234 1234 or 484-234-1234.	Only +digits or local formats allowed i.e. +1484-234-1234 or 1484 234 1234 or 484-234-1234.	+1-484-234-1234|1 484 234 1234|484 234 1234	+1-484-234-1234|1 484 234 1234|484 234 1234	Pennsylvania
302	10	570	(?:\\+?1[ -]?)?570[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?570[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1570-234-1234 or 1570 234 1234 or 570-234-1234.	Only +digits or local formats allowed i.e. +1570-234-1234 or 1570 234 1234 or 570-234-1234.	+1-570-234-1234|1 570 234 1234|570 234 1234	+1-570-234-1234|1 570 234 1234|570 234 1234	Pennsylvania
303	10	582	(?:\\+?1[ -]?)?582[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?582[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1582-234-1234 or 1582 234 1234 or 582-234-1234.	Only +digits or local formats allowed i.e. +1582-234-1234 or 1582 234 1234 or 582-234-1234.	+1-582-234-1234|1 582 234 1234|582 234 1234	+1-582-234-1234|1 582 234 1234|582 234 1234	Pennsylvania
304	10	610	(?:\\+?1[ -]?)?610[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?610[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1610-234-1234 or 1610 234 1234 or 610-234-1234.	Only +digits or local formats allowed i.e. +1610-234-1234 or 1610 234 1234 or 610-234-1234.	+1-610-234-1234|1 610 234 1234|610 234 1234	+1-610-234-1234|1 610 234 1234|610 234 1234	Pennsylvania
305	10	717	(?:\\+?1[ -]?)?717[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?717[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1717-234-1234 or 1717 234 1234 or 717-234-1234.	Only +digits or local formats allowed i.e. +1717-234-1234 or 1717 234 1234 or 717-234-1234.	+1-717-234-1234|1 717 234 1234|717 234 1234	+1-717-234-1234|1 717 234 1234|717 234 1234	Pennsylvania
306	10	724	(?:\\+?1[ -]?)?724[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?724[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1724-234-1234 or 1724 234 1234 or 724-234-1234.	Only +digits or local formats allowed i.e. +1724-234-1234 or 1724 234 1234 or 724-234-1234.	+1-724-234-1234|1 724 234 1234|724 234 1234	+1-724-234-1234|1 724 234 1234|724 234 1234	Pennsylvania
307	10	814	(?:\\+?1[ -]?)?814[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?814[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1814-234-1234 or 1814 234 1234 or 814-234-1234.	Only +digits or local formats allowed i.e. +1814-234-1234 or 1814 234 1234 or 814-234-1234.	+1-814-234-1234|1 814 234 1234|814 234 1234	+1-814-234-1234|1 814 234 1234|814 234 1234	Pennsylvania
308	10	401	(?:\\+?1[ -]?)?401[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?401[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1401-234-1234 or 1401 234 1234 or 401-234-1234.	Only +digits or local formats allowed i.e. +1401-234-1234 or 1401 234 1234 or 401-234-1234.	+1-401-234-1234|1 401 234 1234|401 234 1234	+1-401-234-1234|1 401 234 1234|401 234 1234	Rhode Island
309	10	803	(?:\\+?1[ -]?)?803[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?803[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1803-234-1234 or 1803 234 1234 or 803-234-1234.	Only +digits or local formats allowed i.e. +1803-234-1234 or 1803 234 1234 or 803-234-1234.	+1-803-234-1234|1 803 234 1234|803 234 1234	+1-803-234-1234|1 803 234 1234|803 234 1234	South Carolina
310	10	839	(?:\\+?1[ -]?)?839[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?839[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1839-234-1234 or 1839 234 1234 or 839-234-1234.	Only +digits or local formats allowed i.e. +1839-234-1234 or 1839 234 1234 or 839-234-1234.	+1-839-234-1234|1 839 234 1234|839 234 1234	+1-839-234-1234|1 839 234 1234|839 234 1234	South Carolina
311	10	223	(?:\\+?1[ -]?)?223[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?223[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1223-234-1234 or 1223 234 1234 or 223-234-1234.	Only +digits or local formats allowed i.e. +1223-234-1234 or 1223 234 1234 or 223-234-1234.	+1-223-234-1234|1 223 234 1234|223 234 1234	+1-223-234-1234|1 223 234 1234|223 234 1234	Pennsylvania
312	10	267	(?:\\+?1[ -]?)?267[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?267[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1267-234-1234 or 1267 234 1234 or 267-234-1234.	Only +digits or local formats allowed i.e. +1267-234-1234 or 1267 234 1234 or 267-234-1234.	+1-267-234-1234|1 267 234 1234|267 234 1234	+1-267-234-1234|1 267 234 1234|267 234 1234	Pennsylvania
313	10	605	(?:\\+?1[ -]?)?605[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?605[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1605-234-1234 or 1605 234 1234 or 605-234-1234.	Only +digits or local formats allowed i.e. +1605-234-1234 or 1605 234 1234 or 605-234-1234.	+1-605-234-1234|1 605 234 1234|605 234 1234	+1-605-234-1234|1 605 234 1234|605 234 1234	South Dakota
314	10	423	(?:\\+?1[ -]?)?423[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?423[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1423-234-1234 or 1423 234 1234 or 423-234-1234.	Only +digits or local formats allowed i.e. +1423-234-1234 or 1423 234 1234 or 423-234-1234.	+1-423-234-1234|1 423 234 1234|423 234 1234	+1-423-234-1234|1 423 234 1234|423 234 1234	Tennessee
315	10	615	(?:\\+?1[ -]?)?615[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?615[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1615-234-1234 or 1615 234 1234 or 615-234-1234.	Only +digits or local formats allowed i.e. +1615-234-1234 or 1615 234 1234 or 615-234-1234.	+1-615-234-1234|1 615 234 1234|615 234 1234	+1-615-234-1234|1 615 234 1234|615 234 1234	Tennessee
316	10	629	(?:\\+?1[ -]?)?629[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?629[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1629-234-1234 or 1629 234 1234 or 629-234-1234.	Only +digits or local formats allowed i.e. +1629-234-1234 or 1629 234 1234 or 629-234-1234.	+1-629-234-1234|1 629 234 1234|629 234 1234	+1-629-234-1234|1 629 234 1234|629 234 1234	Tennessee
317	10	731	(?:\\+?1[ -]?)?731[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?731[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1731-234-1234 or 1731 234 1234 or 731-234-1234.	Only +digits or local formats allowed i.e. +1731-234-1234 or 1731 234 1234 or 731-234-1234.	+1-731-234-1234|1 731 234 1234|731 234 1234	+1-731-234-1234|1 731 234 1234|731 234 1234	Tennessee
318	10	865	(?:\\+?1[ -]?)?865[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?865[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1865-234-1234 or 1865 234 1234 or 865-234-1234.	Only +digits or local formats allowed i.e. +1865-234-1234 or 1865 234 1234 or 865-234-1234.	+1-865-234-1234|1 865 234 1234|865 234 1234	+1-865-234-1234|1 865 234 1234|865 234 1234	Tennessee
319	10	901	(?:\\+?1[ -]?)?901[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?901[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1901-234-1234 or 1901 234 1234 or 901-234-1234.	Only +digits or local formats allowed i.e. +1901-234-1234 or 1901 234 1234 or 901-234-1234.	+1-901-234-1234|1 901 234 1234|901 234 1234	+1-901-234-1234|1 901 234 1234|901 234 1234	Tennessee
320	10	931	(?:\\+?1[ -]?)?931[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?931[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1931-234-1234 or 1931 234 1234 or 931-234-1234.	Only +digits or local formats allowed i.e. +1931-234-1234 or 1931 234 1234 or 931-234-1234.	+1-931-234-1234|1 931 234 1234|931 234 1234	+1-931-234-1234|1 931 234 1234|931 234 1234	Tennessee
321	10	210	(?:\\+?1[ -]?)?210[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?210[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1210-234-1234 or 1210 234 1234 or 210-234-1234.	Only +digits or local formats allowed i.e. +1210-234-1234 or 1210 234 1234 or 210-234-1234.	+1-210-234-1234|1 210 234 1234|210 234 1234	+1-210-234-1234|1 210 234 1234|210 234 1234	Texas
322	10	214	(?:\\+?1[ -]?)?214[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?214[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1214-234-1234 or 1214 234 1234 or 214-234-1234.	Only +digits or local formats allowed i.e. +1214-234-1234 or 1214 234 1234 or 214-234-1234.	+1-214-234-1234|1 214 234 1234|214 234 1234	+1-214-234-1234|1 214 234 1234|214 234 1234	Texas
323	10	254	(?:\\+?1[ -]?)?254[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?254[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1254-234-1234 or 1254 234 1234 or 254-234-1234.	Only +digits or local formats allowed i.e. +1254-234-1234 or 1254 234 1234 or 254-234-1234.	+1-254-234-1234|1 254 234 1234|254 234 1234	+1-254-234-1234|1 254 234 1234|254 234 1234	Texas
324	10	325	(?:\\+?1[ -]?)?325[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?325[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1325-234-1234 or 1325 234 1234 or 325-234-1234.	Only +digits or local formats allowed i.e. +1325-234-1234 or 1325 234 1234 or 325-234-1234.	+1-325-234-1234|1 325 234 1234|325 234 1234	+1-325-234-1234|1 325 234 1234|325 234 1234	Texas
325	10	346	(?:\\+?1[ -]?)?346[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?346[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1346-234-1234 or 1346 234 1234 or 346-234-1234.	Only +digits or local formats allowed i.e. +1346-234-1234 or 1346 234 1234 or 346-234-1234.	+1-346-234-1234|1 346 234 1234|346 234 1234	+1-346-234-1234|1 346 234 1234|346 234 1234	Texas
326	10	854	(?:\\+?1[ -]?)?854[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?854[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1854-234-1234 or 1854 234 1234 or 854-234-1234.	Only +digits or local formats allowed i.e. +1854-234-1234 or 1854 234 1234 or 854-234-1234.	+1-854-234-1234|1 854 234 1234|854 234 1234	+1-854-234-1234|1 854 234 1234|854 234 1234	South Carolina
327	10	864	(?:\\+?1[ -]?)?864[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?864[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1864-234-1234 or 1864 234 1234 or 864-234-1234.	Only +digits or local formats allowed i.e. +1864-234-1234 or 1864 234 1234 or 864-234-1234.	+1-864-234-1234|1 864 234 1234|864 234 1234	+1-864-234-1234|1 864 234 1234|864 234 1234	South Carolina
328	10	469	(?:\\+?1[ -]?)?469[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?469[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1469-234-1234 or 1469 234 1234 or 469-234-1234.	Only +digits or local formats allowed i.e. +1469-234-1234 or 1469 234 1234 or 469-234-1234.	+1-469-234-1234|1 469 234 1234|469 234 1234	+1-469-234-1234|1 469 234 1234|469 234 1234	Texas
329	10	512	(?:\\+?1[ -]?)?512[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?512[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1512-234-1234 or 1512 234 1234 or 512-234-1234.	Only +digits or local formats allowed i.e. +1512-234-1234 or 1512 234 1234 or 512-234-1234.	+1-512-234-1234|1 512 234 1234|512 234 1234	+1-512-234-1234|1 512 234 1234|512 234 1234	Texas
330	10	682	(?:\\+?1[ -]?)?682[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?682[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1682-234-1234 or 1682 234 1234 or 682-234-1234.	Only +digits or local formats allowed i.e. +1682-234-1234 or 1682 234 1234 or 682-234-1234.	+1-682-234-1234|1 682 234 1234|682 234 1234	+1-682-234-1234|1 682 234 1234|682 234 1234	Texas
331	10	713	(?:\\+?1[ -]?)?713[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?713[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1713-234-1234 or 1713 234 1234 or 713-234-1234.	Only +digits or local formats allowed i.e. +1713-234-1234 or 1713 234 1234 or 713-234-1234.	+1-713-234-1234|1 713 234 1234|713 234 1234	+1-713-234-1234|1 713 234 1234|713 234 1234	Texas
332	10	726	(?:\\+?1[ -]?)?726[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?726[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1726-234-1234 or 1726 234 1234 or 726-234-1234.	Only +digits or local formats allowed i.e. +1726-234-1234 or 1726 234 1234 or 726-234-1234.	+1-726-234-1234|1 726 234 1234|726 234 1234	+1-726-234-1234|1 726 234 1234|726 234 1234	Texas
333	10	737	(?:\\+?1[ -]?)?737[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?737[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1737-234-1234 or 1737 234 1234 or 737-234-1234.	Only +digits or local formats allowed i.e. +1737-234-1234 or 1737 234 1234 or 737-234-1234.	+1-737-234-1234|1 737 234 1234|737 234 1234	+1-737-234-1234|1 737 234 1234|737 234 1234	Texas
334	10	806	(?:\\+?1[ -]?)?806[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?806[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1806-234-1234 or 1806 234 1234 or 806-234-1234.	Only +digits or local formats allowed i.e. +1806-234-1234 or 1806 234 1234 or 806-234-1234.	+1-806-234-1234|1 806 234 1234|806 234 1234	+1-806-234-1234|1 806 234 1234|806 234 1234	Texas
335	10	817	(?:\\+?1[ -]?)?817[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?817[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1817-234-1234 or 1817 234 1234 or 817-234-1234.	Only +digits or local formats allowed i.e. +1817-234-1234 or 1817 234 1234 or 817-234-1234.	+1-817-234-1234|1 817 234 1234|817 234 1234	+1-817-234-1234|1 817 234 1234|817 234 1234	Texas
336	10	830	(?:\\+?1[ -]?)?830[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?830[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1830-234-1234 or 1830 234 1234 or 830-234-1234.	Only +digits or local formats allowed i.e. +1830-234-1234 or 1830 234 1234 or 830-234-1234.	+1-830-234-1234|1 830 234 1234|830 234 1234	+1-830-234-1234|1 830 234 1234|830 234 1234	Texas
337	10	832	(?:\\+?1[ -]?)?832[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?832[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1832-234-1234 or 1832 234 1234 or 832-234-1234.	Only +digits or local formats allowed i.e. +1832-234-1234 or 1832 234 1234 or 832-234-1234.	+1-832-234-1234|1 832 234 1234|832 234 1234	+1-832-234-1234|1 832 234 1234|832 234 1234	Texas
338	10	903	(?:\\+?1[ -]?)?903[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?903[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1903-234-1234 or 1903 234 1234 or 903-234-1234.	Only +digits or local formats allowed i.e. +1903-234-1234 or 1903 234 1234 or 903-234-1234.	+1-903-234-1234|1 903 234 1234|903 234 1234	+1-903-234-1234|1 903 234 1234|903 234 1234	Texas
339	10	936	(?:\\+?1[ -]?)?936[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?936[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1936-234-1234 or 1936 234 1234 or 936-234-1234.	Only +digits or local formats allowed i.e. +1936-234-1234 or 1936 234 1234 or 936-234-1234.	+1-936-234-1234|1 936 234 1234|936 234 1234	+1-936-234-1234|1 936 234 1234|936 234 1234	Texas
340	10	940	(?:\\+?1[ -]?)?940[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?940[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1940-234-1234 or 1940 234 1234 or 940-234-1234.	Only +digits or local formats allowed i.e. +1940-234-1234 or 1940 234 1234 or 940-234-1234.	+1-940-234-1234|1 940 234 1234|940 234 1234	+1-940-234-1234|1 940 234 1234|940 234 1234	Texas
341	10	430	(?:\\+?1[ -]?)?430[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?430[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1430-234-1234 or 1430 234 1234 or 430-234-1234.	Only +digits or local formats allowed i.e. +1430-234-1234 or 1430 234 1234 or 430-234-1234.	+1-430-234-1234|1 430 234 1234|430 234 1234	+1-430-234-1234|1 430 234 1234|430 234 1234	Texas
342	10	432	(?:\\+?1[ -]?)?432[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?432[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1432-234-1234 or 1432 234 1234 or 432-234-1234.	Only +digits or local formats allowed i.e. +1432-234-1234 or 1432 234 1234 or 432-234-1234.	+1-432-234-1234|1 432 234 1234|432 234 1234	+1-432-234-1234|1 432 234 1234|432 234 1234	Texas
343	10	979	(?:\\+?1[ -]?)?979[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?979[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1979-234-1234 or 1979 234 1234 or 979-234-1234.	Only +digits or local formats allowed i.e. +1979-234-1234 or 1979 234 1234 or 979-234-1234.	+1-979-234-1234|1 979 234 1234|979 234 1234	+1-979-234-1234|1 979 234 1234|979 234 1234	Texas
344	10	385	(?:\\+?1[ -]?)?385[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?385[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1385-234-1234 or 1385 234 1234 or 385-234-1234.	Only +digits or local formats allowed i.e. +1385-234-1234 or 1385 234 1234 or 385-234-1234.	+1-385-234-1234|1 385 234 1234|385 234 1234	+1-385-234-1234|1 385 234 1234|385 234 1234	Utah
345	10	435	(?:\\+?1[ -]?)?435[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?435[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1435-234-1234 or 1435 234 1234 or 435-234-1234.	Only +digits or local formats allowed i.e. +1435-234-1234 or 1435 234 1234 or 435-234-1234.	+1-435-234-1234|1 435 234 1234|435 234 1234	+1-435-234-1234|1 435 234 1234|435 234 1234	Utah
346	10	801	(?:\\+?1[ -]?)?801[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?801[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1801-234-1234 or 1801 234 1234 or 801-234-1234.	Only +digits or local formats allowed i.e. +1801-234-1234 or 1801 234 1234 or 801-234-1234.	+1-801-234-1234|1 801 234 1234|801 234 1234	+1-801-234-1234|1 801 234 1234|801 234 1234	Utah
347	10	802	(?:\\+?1[ -]?)?802[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?802[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1802-234-1234 or 1802 234 1234 or 802-234-1234.	Only +digits or local formats allowed i.e. +1802-234-1234 or 1802 234 1234 or 802-234-1234.	+1-802-234-1234|1 802 234 1234|802 234 1234	+1-802-234-1234|1 802 234 1234|802 234 1234	Vermont
348	10	276	(?:\\+?1[ -]?)?276[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?276[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1276-234-1234 or 1276 234 1234 or 276-234-1234.	Only +digits or local formats allowed i.e. +1276-234-1234 or 1276 234 1234 or 276-234-1234.	+1-276-234-1234|1 276 234 1234|276 234 1234	+1-276-234-1234|1 276 234 1234|276 234 1234	Virginia
349	10	434	(?:\\+?1[ -]?)?434[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?434[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1434-234-1234 or 1434 234 1234 or 434-234-1234.	Only +digits or local formats allowed i.e. +1434-234-1234 or 1434 234 1234 or 434-234-1234.	+1-434-234-1234|1 434 234 1234|434 234 1234	+1-434-234-1234|1 434 234 1234|434 234 1234	Virginia
350	10	540	(?:\\+?1[ -]?)?540[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?540[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1540-234-1234 or 1540 234 1234 or 540-234-1234.	Only +digits or local formats allowed i.e. +1540-234-1234 or 1540 234 1234 or 540-234-1234.	+1-540-234-1234|1 540 234 1234|540 234 1234	+1-540-234-1234|1 540 234 1234|540 234 1234	Virginia
351	10	571	(?:\\+?1[ -]?)?571[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?571[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1571-234-1234 or 1571 234 1234 or 571-234-1234.	Only +digits or local formats allowed i.e. +1571-234-1234 or 1571 234 1234 or 571-234-1234.	+1-571-234-1234|1 571 234 1234|571 234 1234	+1-571-234-1234|1 571 234 1234|571 234 1234	Virginia
352	10	703	(?:\\+?1[ -]?)?703[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?703[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1703-234-1234 or 1703 234 1234 or 703-234-1234.	Only +digits or local formats allowed i.e. +1703-234-1234 or 1703 234 1234 or 703-234-1234.	+1-703-234-1234|1 703 234 1234|703 234 1234	+1-703-234-1234|1 703 234 1234|703 234 1234	Virginia
353	10	757	(?:\\+?1[ -]?)?757[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?757[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1757-234-1234 or 1757 234 1234 or 757-234-1234.	Only +digits or local formats allowed i.e. +1757-234-1234 or 1757 234 1234 or 757-234-1234.	+1-757-234-1234|1 757 234 1234|757 234 1234	+1-757-234-1234|1 757 234 1234|757 234 1234	Virginia
354	10	804	(?:\\+?1[ -]?)?804[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?804[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1804-234-1234 or 1804 234 1234 or 804-234-1234.	Only +digits or local formats allowed i.e. +1804-234-1234 or 1804 234 1234 or 804-234-1234.	+1-804-234-1234|1 804 234 1234|804 234 1234	+1-804-234-1234|1 804 234 1234|804 234 1234	Virginia
355	10	948	(?:\\+?1[ -]?)?948[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?948[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1948-234-1234 or 1948 234 1234 or 948-234-1234.	Only +digits or local formats allowed i.e. +1948-234-1234 or 1948 234 1234 or 948-234-1234.	+1-948-234-1234|1 948 234 1234|948 234 1234	+1-948-234-1234|1 948 234 1234|948 234 1234	Virginia
356	10	956	(?:\\+?1[ -]?)?956[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?956[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1956-234-1234 or 1956 234 1234 or 956-234-1234.	Only +digits or local formats allowed i.e. +1956-234-1234 or 1956 234 1234 or 956-234-1234.	+1-956-234-1234|1 956 234 1234|956 234 1234	+1-956-234-1234|1 956 234 1234|956 234 1234	Texas
357	10	972	(?:\\+?1[ -]?)?972[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?972[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1972-234-1234 or 1972 234 1234 or 972-234-1234.	Only +digits or local formats allowed i.e. +1972-234-1234 or 1972 234 1234 or 972-234-1234.	+1-972-234-1234|1 972 234 1234|972 234 1234	+1-972-234-1234|1 972 234 1234|972 234 1234	Texas
358	10	425	(?:\\+?1[ -]?)?425[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?425[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1425-234-1234 or 1425 234 1234 or 425-234-1234.	Only +digits or local formats allowed i.e. +1425-234-1234 or 1425 234 1234 or 425-234-1234.	+1-425-234-1234|1 425 234 1234|425 234 1234	+1-425-234-1234|1 425 234 1234|425 234 1234	Washington
359	10	509	(?:\\+?1[ -]?)?509[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?509[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1509-234-1234 or 1509 234 1234 or 509-234-1234.	Only +digits or local formats allowed i.e. +1509-234-1234 or 1509 234 1234 or 509-234-1234.	+1-509-234-1234|1 509 234 1234|509 234 1234	+1-509-234-1234|1 509 234 1234|509 234 1234	Washington
360	10	564	(?:\\+?1[ -]?)?564[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?564[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1564-234-1234 or 1564 234 1234 or 564-234-1234.	Only +digits or local formats allowed i.e. +1564-234-1234 or 1564 234 1234 or 564-234-1234.	+1-564-234-1234|1 564 234 1234|564 234 1234	+1-564-234-1234|1 564 234 1234|564 234 1234	Washington
361	10	304	(?:\\+?1[ -]?)?304[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?304[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1304-234-1234 or 1304 234 1234 or 304-234-1234.	Only +digits or local formats allowed i.e. +1304-234-1234 or 1304 234 1234 or 304-234-1234.	+1-304-234-1234|1 304 234 1234|304 234 1234	+1-304-234-1234|1 304 234 1234|304 234 1234	West Virginia
362	10	681	(?:\\+?1[ -]?)?681[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?681[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1681-234-1234 or 1681 234 1234 or 681-234-1234.	Only +digits or local formats allowed i.e. +1681-234-1234 or 1681 234 1234 or 681-234-1234.	+1-681-234-1234|1 681 234 1234|681 234 1234	+1-681-234-1234|1 681 234 1234|681 234 1234	West Virginia
363	10	262	(?:\\+?1[ -]?)?262[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?262[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1262-234-1234 or 1262 234 1234 or 262-234-1234.	Only +digits or local formats allowed i.e. +1262-234-1234 or 1262 234 1234 or 262-234-1234.	+1-262-234-1234|1 262 234 1234|262 234 1234	+1-262-234-1234|1 262 234 1234|262 234 1234	Wisconsin
364	10	274	(?:\\+?1[ -]?)?274[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?274[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1274-234-1234 or 1274 234 1234 or 274-234-1234.	Only +digits or local formats allowed i.e. +1274-234-1234 or 1274 234 1234 or 274-234-1234.	+1-274-234-1234|1 274 234 1234|274 234 1234	+1-274-234-1234|1 274 234 1234|274 234 1234	Wisconsin
365	10	414	(?:\\+?1[ -]?)?414[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?414[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1414-234-1234 or 1414 234 1234 or 414-234-1234.	Only +digits or local formats allowed i.e. +1414-234-1234 or 1414 234 1234 or 414-234-1234.	+1-414-234-1234|1 414 234 1234|414 234 1234	+1-414-234-1234|1 414 234 1234|414 234 1234	Wisconsin
366	10	534	(?:\\+?1[ -]?)?534[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?534[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1534-234-1234 or 1534 234 1234 or 534-234-1234.	Only +digits or local formats allowed i.e. +1534-234-1234 or 1534 234 1234 or 534-234-1234.	+1-534-234-1234|1 534 234 1234|534 234 1234	+1-534-234-1234|1 534 234 1234|534 234 1234	Wisconsin
367	10	715	(?:\\+?1[ -]?)?715[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?715[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1715-234-1234 or 1715 234 1234 or 715-234-1234.	Only +digits or local formats allowed i.e. +1715-234-1234 or 1715 234 1234 or 715-234-1234.	+1-715-234-1234|1 715 234 1234|715 234 1234	+1-715-234-1234|1 715 234 1234|715 234 1234	Wisconsin
368	10	920	(?:\\+?1[ -]?)?920[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?920[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1920-234-1234 or 1920 234 1234 or 920-234-1234.	Only +digits or local formats allowed i.e. +1920-234-1234 or 1920 234 1234 or 920-234-1234.	+1-920-234-1234|1 920 234 1234|920 234 1234	+1-920-234-1234|1 920 234 1234|920 234 1234	Wisconsin
369	10	307	(?:\\+?1[ -]?)?307[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?307[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1307-234-1234 or 1307 234 1234 or 307-234-1234.	Only +digits or local formats allowed i.e. +1307-234-1234 or 1307 234 1234 or 307-234-1234.	+1-307-234-1234|1 307 234 1234|307 234 1234	+1-307-234-1234|1 307 234 1234|307 234 1234	Wyoming
370	10	334	(?:\\+?1[ -]?)?334[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?334[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1334-234-1234 or 1334 234 1234 or 334-234-1234.	Only +digits or local formats allowed i.e. +1334-234-1234 or 1334 234 1234 or 334-234-1234.	+1-334-234-1234|1 334 234 1234|334 234 1234	+1-334-234-1234|1 334 234 1234|334 234 1234	Alabama
371	10	360	(?:\\+?1[ -]?)?360[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?360[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1360-234-1234 or 1360 234 1234 or 360-234-1234.	Only +digits or local formats allowed i.e. +1360-234-1234 or 1360 234 1234 or 360-234-1234.	+1-360-234-1234|1 360 234 1234|360 234 1234	+1-360-234-1234|1 360 234 1234|360 234 1234	Washington
372	10	253	(?:\\+?1[ -]?)?253[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?253[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1253-234-1234 or 1253 234 1234 or 253-234-1234.	Only +digits or local formats allowed i.e. +1253-234-1234 or 1253 234 1234 or 253-234-1234.	+1-253-234-1234|1 253 234 1234|253 234 1234	+1-253-234-1234|1 253 234 1234|253 234 1234	Washington
373	10	669	(?:\\+?1[ -]?)?669[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?669[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1669-234-1234 or 1669 234 1234 or 669-234-1234.	Only +digits or local formats allowed i.e. +1669-234-1234 or 1669 234 1234 or 669-234-1234.	+1-669-234-1234|1 669 234 1234|669 234 1234	+1-669-234-1234|1 669 234 1234|669 234 1234	California
374	10	303	(?:\\+?1[ -]?)?303[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?303[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1303-234-1234 or 1303 234 1234 or 303-234-1234.	Only +digits or local formats allowed i.e. +1303-234-1234 or 1303 234 1234 or 303-234-1234.	+1-303-234-1234|1 303 234 1234|303 234 1234	+1-303-234-1234|1 303 234 1234|303 234 1234	Colorado
375	10	321	(?:\\+?1[ -]?)?321[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?321[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1321-234-1234 or 1321 234 1234 or 321-234-1234.	Only +digits or local formats allowed i.e. +1321-234-1234 or 1321 234 1234 or 321-234-1234.	+1-321-234-1234|1 321 234 1234|321 234 1234	+1-321-234-1234|1 321 234 1234|321 234 1234	Florida
376	10	407	(?:\\+?1[ -]?)?407[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?407[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1407-234-1234 or 1407 234 1234 or 407-234-1234.	Only +digits or local formats allowed i.e. +1407-234-1234 or 1407 234 1234 or 407-234-1234.	+1-407-234-1234|1 407 234 1234|407 234 1234	+1-407-234-1234|1 407 234 1234|407 234 1234	Florida
377	10	448	(?:\\+?1[ -]?)?448[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?448[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1448-234-1234 or 1448 234 1234 or 448-234-1234.	Only +digits or local formats allowed i.e. +1448-234-1234 or 1448 234 1234 or 448-234-1234.	+1-448-234-1234|1 448 234 1234|448 234 1234	+1-448-234-1234|1 448 234 1234|448 234 1234	Florida
378	10	229	(?:\\+?1[ -]?)?229[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?229[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1229-234-1234 or 1229 234 1234 or 229-234-1234.	Only +digits or local formats allowed i.e. +1229-234-1234 or 1229 234 1234 or 229-234-1234.	+1-229-234-1234|1 229 234 1234|229 234 1234	+1-229-234-1234|1 229 234 1234|229 234 1234	Georgia
379	10	478	(?:\\+?1[ -]?)?478[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?478[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1478-234-1234 or 1478 234 1234 or 478-234-1234.	Only +digits or local formats allowed i.e. +1478-234-1234 or 1478 234 1234 or 478-234-1234.	+1-478-234-1234|1 478 234 1234|478 234 1234	+1-478-234-1234|1 478 234 1234|478 234 1234	Georgia
380	10	678	(?:\\+?1[ -]?)?678[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?678[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1678-234-1234 or 1678 234 1234 or 678-234-1234.	Only +digits or local formats allowed i.e. +1678-234-1234 or 1678 234 1234 or 678-234-1234.	+1-678-234-1234|1 678 234 1234|678 234 1234	+1-678-234-1234|1 678 234 1234|678 234 1234	Georgia
381	10	447	(?:\\+?1[ -]?)?447[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?447[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1447-234-1234 or 1447 234 1234 or 447-234-1234.	Only +digits or local formats allowed i.e. +1447-234-1234 or 1447 234 1234 or 447-234-1234.	+1-447-234-1234|1 447 234 1234|447 234 1234	+1-447-234-1234|1 447 234 1234|447 234 1234	Illinois
382	10	630	(?:\\+?1[ -]?)?630[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?630[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1630-234-1234 or 1630 234 1234 or 630-234-1234.	Only +digits or local formats allowed i.e. +1630-234-1234 or 1630 234 1234 or 630-234-1234.	+1-630-234-1234|1 630 234 1234|630 234 1234	+1-630-234-1234|1 630 234 1234|630 234 1234	Illinois
383	10	708	(?:\\+?1[ -]?)?708[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?708[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1708-234-1234 or 1708 234 1234 or 708-234-1234.	Only +digits or local formats allowed i.e. +1708-234-1234 or 1708 234 1234 or 708-234-1234.	+1-708-234-1234|1 708 234 1234|708 234 1234	+1-708-234-1234|1 708 234 1234|708 234 1234	Illinois
384	10	930	(?:\\+?1[ -]?)?930[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?930[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1930-234-1234 or 1930 234 1234 or 930-234-1234.	Only +digits or local formats allowed i.e. +1930-234-1234 or 1930 234 1234 or 930-234-1234.	+1-930-234-1234|1 930 234 1234|930 234 1234	+1-930-234-1234|1 930 234 1234|930 234 1234	Indiana
385	10	606	(?:\\+?1[ -]?)?606[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?606[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1606-234-1234 or 1606 234 1234 or 606-234-1234.	Only +digits or local formats allowed i.e. +1606-234-1234 or 1606 234 1234 or 606-234-1234.	+1-606-234-1234|1 606 234 1234|606 234 1234	+1-606-234-1234|1 606 234 1234|606 234 1234	Kentucky
386	10	225	(?:\\+?1[ -]?)?225[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?225[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1225-234-1234 or 1225 234 1234 or 225-234-1234.	Only +digits or local formats allowed i.e. +1225-234-1234 or 1225 234 1234 or 225-234-1234.	+1-225-234-1234|1 225 234 1234|225 234 1234	+1-225-234-1234|1 225 234 1234|225 234 1234	Louisiana
387	10	323	(?:\\+?1[ -]?)?323[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?323[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1323-234-1234 or 1323 234 1234 or 323-234-1234.	Only +digits or local formats allowed i.e. +1323-234-1234 or 1323 234 1234 or 323-234-1234.	+1-323-234-1234|1 323 234 1234|323 234 1234	+1-323-234-1234|1 323 234 1234|323 234 1234	California
388	10	248	(?:\\+?1[ -]?)?248[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?248[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1248-234-1234 or 1248 234 1234 or 248-234-1234.	Only +digits or local formats allowed i.e. +1248-234-1234 or 1248 234 1234 or 248-234-1234.	+1-248-234-1234|1 248 234 1234|248 234 1234	+1-248-234-1234|1 248 234 1234|248 234 1234	Michigan
389	10	320	(?:\\+?1[ -]?)?320[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?320[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1320-234-1234 or 1320 234 1234 or 320-234-1234.	Only +digits or local formats allowed i.e. +1320-234-1234 or 1320 234 1234 or 320-234-1234.	+1-320-234-1234|1 320 234 1234|320 234 1234	+1-320-234-1234|1 320 234 1234|320 234 1234	Minnesota
390	10	651	(?:\\+?1[ -]?)?651[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?651[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1651-234-1234 or 1651 234 1234 or 651-234-1234.	Only +digits or local formats allowed i.e. +1651-234-1234 or 1651 234 1234 or 651-234-1234.	+1-651-234-1234|1 651 234 1234|651 234 1234	+1-651-234-1234|1 651 234 1234|651 234 1234	Minnesota
391	10	975	(?:\\+?1[ -]?)?975[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?975[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1975-234-1234 or 1975 234 1234 or 975-234-1234.	Only +digits or local formats allowed i.e. +1975-234-1234 or 1975 234 1234 or 975-234-1234.	+1-975-234-1234|1 975 234 1234|975 234 1234	+1-975-234-1234|1 975 234 1234|975 234 1234	Missouri
392	10	531	(?:\\+?1[ -]?)?531[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?531[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1531-234-1234 or 1531 234 1234 or 531-234-1234.	Only +digits or local formats allowed i.e. +1531-234-1234 or 1531 234 1234 or 531-234-1234.	+1-531-234-1234|1 531 234 1234|531 234 1234	+1-531-234-1234|1 531 234 1234|531 234 1234	Nebraska
393	10	908	(?:\\+?1[ -]?)?908[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?908[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1908-234-1234 or 1908 234 1234 or 908-234-1234.	Only +digits or local formats allowed i.e. +1908-234-1234 or 1908 234 1234 or 908-234-1234.	+1-908-234-1234|1 908 234 1234|908 234 1234	+1-908-234-1234|1 908 234 1234|908 234 1234	New Jersey
394	10	212	(?:\\+?1[ -]?)?212[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?212[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1212-234-1234 or 1212 234 1234 or 212-234-1234.	Only +digits or local formats allowed i.e. +1212-234-1234 or 1212 234 1234 or 212-234-1234.	+1-212-234-1234|1 212 234 1234|212 234 1234	+1-212-234-1234|1 212 234 1234|212 234 1234	New York
395	10	315	(?:\\+?1[ -]?)?315[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?315[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1315-234-1234 or 1315 234 1234 or 315-234-1234.	Only +digits or local formats allowed i.e. +1315-234-1234 or 1315 234 1234 or 315-234-1234.	+1-315-234-1234|1 315 234 1234|315 234 1234	+1-315-234-1234|1 315 234 1234|315 234 1234	New York
396	10	845	(?:\\+?1[ -]?)?845[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?845[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1845-234-1234 or 1845 234 1234 or 845-234-1234.	Only +digits or local formats allowed i.e. +1845-234-1234 or 1845 234 1234 or 845-234-1234.	+1-845-234-1234|1 845 234 1234|845 234 1234	+1-845-234-1234|1 845 234 1234|845 234 1234	New York
397	10	929	(?:\\+?1[ -]?)?929[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?929[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1929-234-1234 or 1929 234 1234 or 929-234-1234.	Only +digits or local formats allowed i.e. +1929-234-1234 or 1929 234 1234 or 929-234-1234.	+1-929-234-1234|1 929 234 1234|929 234 1234	+1-929-234-1234|1 929 234 1234|929 234 1234	New York
398	10	216	(?:\\+?1[ -]?)?216[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?216[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1216-234-1234 or 1216 234 1234 or 216-234-1234.	Only +digits or local formats allowed i.e. +1216-234-1234 or 1216 234 1234 or 216-234-1234.	+1-216-234-1234|1 216 234 1234|216 234 1234	+1-216-234-1234|1 216 234 1234|216 234 1234	Ohio
399	10	330	(?:\\+?1[ -]?)?330[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?330[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1330-234-1234 or 1330 234 1234 or 330-234-1234.	Only +digits or local formats allowed i.e. +1330-234-1234 or 1330 234 1234 or 330-234-1234.	+1-330-234-1234|1 330 234 1234|330 234 1234	+1-330-234-1234|1 330 234 1234|330 234 1234	Ohio
400	10	419	(?:\\+?1[ -]?)?419[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?419[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1419-234-1234 or 1419 234 1234 or 419-234-1234.	Only +digits or local formats allowed i.e. +1419-234-1234 or 1419 234 1234 or 419-234-1234.	+1-419-234-1234|1 419 234 1234|419 234 1234	+1-419-234-1234|1 419 234 1234|419 234 1234	Ohio
401	10	541	(?:\\+?1[ -]?)?541[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?541[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1541-234-1234 or 1541 234 1234 or 541-234-1234.	Only +digits or local formats allowed i.e. +1541-234-1234 or 1541 234 1234 or 541-234-1234.	+1-541-234-1234|1 541 234 1234|541 234 1234	+1-541-234-1234|1 541 234 1234|541 234 1234	Oregon
402	10	231	(?:\\+?1[ -]?)?231[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?231[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1231-234-1234 or 1231 234 1234 or 231-234-1234.	Only +digits or local formats allowed i.e. +1231-234-1234 or 1231 234 1234 or 231-234-1234.	+1-231-234-1234|1 231 234 1234|231 234 1234	+1-231-234-1234|1 231 234 1234|231 234 1234	Michigan
403	10	843	(?:\\+?1[ -]?)?843[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?843[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1843-234-1234 or 1843 234 1234 or 843-234-1234.	Only +digits or local formats allowed i.e. +1843-234-1234 or 1843 234 1234 or 843-234-1234.	+1-843-234-1234|1 843 234 1234|843 234 1234	+1-843-234-1234|1 843 234 1234|843 234 1234	South Carolina
404	10	281	(?:\\+?1[ -]?)?281[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?281[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1281-234-1234 or 1281 234 1234 or 281-234-1234.	Only +digits or local formats allowed i.e. +1281-234-1234 or 1281 234 1234 or 281-234-1234.	+1-281-234-1234|1 281 234 1234|281 234 1234	+1-281-234-1234|1 281 234 1234|281 234 1234	Texas
405	10	409	(?:\\+?1[ -]?)?409[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?409[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1409-234-1234 or 1409 234 1234 or 409-234-1234.	Only +digits or local formats allowed i.e. +1409-234-1234 or 1409 234 1234 or 409-234-1234.	+1-409-234-1234|1 409 234 1234|409 234 1234	+1-409-234-1234|1 409 234 1234|409 234 1234	Texas
406	10	915	(?:\\+?1[ -]?)?915[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?915[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1915-234-1234 or 1915 234 1234 or 915-234-1234.	Only +digits or local formats allowed i.e. +1915-234-1234 or 1915 234 1234 or 915-234-1234.	+1-915-234-1234|1 915 234 1234|915 234 1234	+1-915-234-1234|1 915 234 1234|915 234 1234	Texas
407	10	945	(?:\\+?1[ -]?)?945[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?945[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1945-234-1234 or 1945 234 1234 or 945-234-1234.	Only +digits or local formats allowed i.e. +1945-234-1234 or 1945 234 1234 or 945-234-1234.	+1-945-234-1234|1 945 234 1234|945 234 1234	+1-945-234-1234|1 945 234 1234|945 234 1234	Texas
408	10	826	(?:\\+?1[ -]?)?826[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?826[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1826-234-1234 or 1826 234 1234 or 826-234-1234.	Only +digits or local formats allowed i.e. +1826-234-1234 or 1826 234 1234 or 826-234-1234.	+1-826-234-1234|1 826 234 1234|826 234 1234	+1-826-234-1234|1 826 234 1234|826 234 1234	Virginia
409	10	206	(?:\\+?1[ -]?)?206[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?206[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1206-234-1234 or 1206 234 1234 or 206-234-1234.	Only +digits or local formats allowed i.e. +1206-234-1234 or 1206 234 1234 or 206-234-1234.	+1-206-234-1234|1 206 234 1234|206 234 1234	+1-206-234-1234|1 206 234 1234|206 234 1234	Washington
410	10	608	(?:\\+?1[ -]?)?608[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?608[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1608-234-1234 or 1608 234 1234 or 608-234-1234.	Only +digits or local formats allowed i.e. +1608-234-1234 or 1608 234 1234 or 608-234-1234.	+1-608-234-1234|1 608 234 1234|608 234 1234	+1-608-234-1234|1 608 234 1234|608 234 1234	Wisconsin
411	10	479	(?:\\+?1[ -]?)?479[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?479[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1479-234-1234 or 1479 234 1234 or 479-234-1234.	Only +digits or local formats allowed i.e. +1479-234-1234 or 1479 234 1234 or 479-234-1234.	+1-479-234-1234|1 479 234 1234|479 234 1234	+1-479-234-1234|1 479 234 1234|479 234 1234	Arkansas
412	10	617	(?:\\+?1[ -]?)?617[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?617[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1617-234-1234 or 1617 234 1234 or 617-234-1234.	Only +digits or local formats allowed i.e. +1617-234-1234 or 1617 234 1234 or 617-234-1234.	+1-617-234-1234|1 617 234 1234|617 234 1234	+1-617-234-1234|1 617 234 1234|617 234 1234	Massachusetts
413	10	215	(?:\\+?1[ -]?)?215[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?215[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1215-234-1234 or 1215 234 1234 or 215-234-1234.	Only +digits or local formats allowed i.e. +1215-234-1234 or 1215 234 1234 or 215-234-1234.	+1-215-234-1234|1 215 234 1234|215 234 1234	+1-215-234-1234|1 215 234 1234|215 234 1234	Pennsylvania
414	10	878	(?:\\+?1[ -]?)?878[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?878[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1878-234-1234 or 1878 234 1234 or 878-234-1234.	Only +digits or local formats allowed i.e. +1878-234-1234 or 1878 234 1234 or 878-234-1234.	+1-878-234-1234|1 878 234 1234|878 234 1234	+1-878-234-1234|1 878 234 1234|878 234 1234	Pennsylvania
415	10	361	(?:\\+?1[ -]?)?361[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?361[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1361-234-1234 or 1361 234 1234 or 361-234-1234.	Only +digits or local formats allowed i.e. +1361-234-1234 or 1361 234 1234 or 361-234-1234.	+1-361-234-1234|1 361 234 1234|361 234 1234	+1-361-234-1234|1 361 234 1234|361 234 1234	Texas
416	10	700	(?:\\+?1[ -]?)?700[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?700[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1700-234-1234 or 1700 234 1234 or 700-234-1234.	Only +digits or local formats allowed i.e. +1700-234-1234 or 1700 234 1234 or 700-234-1234.	+1-700-234-1234|1 700 234 1234|700 234 1234	+1-700-234-1234|1 700 234 1234|700 234 1234	Interexchange carrier-specific services
417	10	500	(?:\\+?1[ -]?)?500[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?500[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1500-234-1234 or 1500 234 1234 or 500-234-1234.	Only +digits or local formats allowed i.e. +1500-234-1234 or 1500 234 1234 or 500-234-1234.	+1-500-234-1234|1 500 234 1234|500 234 1234	+1-500-234-1234|1 500 234 1234|500 234 1234	Personal communications services
418	10	521	(?:\\+?1[ -]?)?521[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?521[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1521-234-1234 or 1521 234 1234 or 521-234-1234.	Only +digits or local formats allowed i.e. +1521-234-1234 or 1521 234 1234 or 521-234-1234.	+1-521-234-1234|1 521 234 1234|521 234 1234	+1-521-234-1234|1 521 234 1234|521 234 1234	Personal communications services
419	10	522	(?:\\+?1[ -]?)?522[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?522[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1522-234-1234 or 1522 234 1234 or 522-234-1234.	Only +digits or local formats allowed i.e. +1522-234-1234 or 1522 234 1234 or 522-234-1234.	+1-522-234-1234|1 522 234 1234|522 234 1234	+1-522-234-1234|1 522 234 1234|522 234 1234	Personal communications services
420	10	523	(?:\\+?1[ -]?)?523[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?523[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1523-234-1234 or 1523 234 1234 or 523-234-1234.	Only +digits or local formats allowed i.e. +1523-234-1234 or 1523 234 1234 or 523-234-1234.	+1-523-234-1234|1 523 234 1234|523 234 1234	+1-523-234-1234|1 523 234 1234|523 234 1234	Personal communications services
421	10	524	(?:\\+?1[ -]?)?524[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?524[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1524-234-1234 or 1524 234 1234 or 524-234-1234.	Only +digits or local formats allowed i.e. +1524-234-1234 or 1524 234 1234 or 524-234-1234.	+1-524-234-1234|1 524 234 1234|524 234 1234	+1-524-234-1234|1 524 234 1234|524 234 1234	Personal communications services
422	10	525	(?:\\+?1[ -]?)?525[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?525[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1525-234-1234 or 1525 234 1234 or 525-234-1234.	Only +digits or local formats allowed i.e. +1525-234-1234 or 1525 234 1234 or 525-234-1234.	+1-525-234-1234|1 525 234 1234|525 234 1234	+1-525-234-1234|1 525 234 1234|525 234 1234	Personal communications services
423	10	526	(?:\\+?1[ -]?)?526[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?526[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1526-234-1234 or 1526 234 1234 or 526-234-1234.	Only +digits or local formats allowed i.e. +1526-234-1234 or 1526 234 1234 or 526-234-1234.	+1-526-234-1234|1 526 234 1234|526 234 1234	+1-526-234-1234|1 526 234 1234|526 234 1234	Personal communications services
424	10	527	(?:\\+?1[ -]?)?527[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?527[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1527-234-1234 or 1527 234 1234 or 527-234-1234.	Only +digits or local formats allowed i.e. +1527-234-1234 or 1527 234 1234 or 527-234-1234.	+1-527-234-1234|1 527 234 1234|527 234 1234	+1-527-234-1234|1 527 234 1234|527 234 1234	Personal communications services
425	10	528	(?:\\+?1[ -]?)?528[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?528[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1528-234-1234 or 1528 234 1234 or 528-234-1234.	Only +digits or local formats allowed i.e. +1528-234-1234 or 1528 234 1234 or 528-234-1234.	+1-528-234-1234|1 528 234 1234|528 234 1234	+1-528-234-1234|1 528 234 1234|528 234 1234	Personal communications services
426	10	529	(?:\\+?1[ -]?)?529[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?529[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1529-234-1234 or 1529 234 1234 or 529-234-1234.	Only +digits or local formats allowed i.e. +1529-234-1234 or 1529 234 1234 or 529-234-1234.	+1-529-234-1234|1 529 234 1234|529 234 1234	+1-529-234-1234|1 529 234 1234|529 234 1234	Personal communications services
427	10	532	(?:\\+?1[ -]?)?532[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?532[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1532-234-1234 or 1532 234 1234 or 532-234-1234.	Only +digits or local formats allowed i.e. +1532-234-1234 or 1532 234 1234 or 532-234-1234.	+1-532-234-1234|1 532 234 1234|532 234 1234	+1-532-234-1234|1 532 234 1234|532 234 1234	Personal communications services
428	10	533	(?:\\+?1[ -]?)?533[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?533[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1533-234-1234 or 1533 234 1234 or 533-234-1234.	Only +digits or local formats allowed i.e. +1533-234-1234 or 1533 234 1234 or 533-234-1234.	+1-533-234-1234|1 533 234 1234|533 234 1234	+1-533-234-1234|1 533 234 1234|533 234 1234	Personal communications services
429	10	535	(?:\\+?1[ -]?)?535[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?535[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1535-234-1234 or 1535 234 1234 or 535-234-1234.	Only +digits or local formats allowed i.e. +1535-234-1234 or 1535 234 1234 or 535-234-1234.	+1-535-234-1234|1 535 234 1234|535 234 1234	+1-535-234-1234|1 535 234 1234|535 234 1234	Personal communications services
430	10	538	(?:\\+?1[ -]?)?538[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?538[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1538-234-1234 or 1538 234 1234 or 538-234-1234.	Only +digits or local formats allowed i.e. +1538-234-1234 or 1538 234 1234 or 538-234-1234.	+1-538-234-1234|1 538 234 1234|538 234 1234	+1-538-234-1234|1 538 234 1234|538 234 1234	Personal communications services
431	10	542	(?:\\+?1[ -]?)?542[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?542[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1542-234-1234 or 1542 234 1234 or 542-234-1234.	Only +digits or local formats allowed i.e. +1542-234-1234 or 1542 234 1234 or 542-234-1234.	+1-542-234-1234|1 542 234 1234|542 234 1234	+1-542-234-1234|1 542 234 1234|542 234 1234	Personal communications services
432	10	543	(?:\\+?1[ -]?)?543[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?543[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1543-234-1234 or 1543 234 1234 or 543-234-1234.	Only +digits or local formats allowed i.e. +1543-234-1234 or 1543 234 1234 or 543-234-1234.	+1-543-234-1234|1 543 234 1234|543 234 1234	+1-543-234-1234|1 543 234 1234|543 234 1234	Personal communications services
433	10	544	(?:\\+?1[ -]?)?544[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?544[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1544-234-1234 or 1544 234 1234 or 544-234-1234.	Only +digits or local formats allowed i.e. +1544-234-1234 or 1544 234 1234 or 544-234-1234.	+1-544-234-1234|1 544 234 1234|544 234 1234	+1-544-234-1234|1 544 234 1234|544 234 1234	Personal communications services
434	10	545	(?:\\+?1[ -]?)?545[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?545[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1545-234-1234 or 1545 234 1234 or 545-234-1234.	Only +digits or local formats allowed i.e. +1545-234-1234 or 1545 234 1234 or 545-234-1234.	+1-545-234-1234|1 545 234 1234|545 234 1234	+1-545-234-1234|1 545 234 1234|545 234 1234	Personal communications services
435	10	546	(?:\\+?1[ -]?)?546[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?546[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1546-234-1234 or 1546 234 1234 or 546-234-1234.	Only +digits or local formats allowed i.e. +1546-234-1234 or 1546 234 1234 or 546-234-1234.	+1-546-234-1234|1 546 234 1234|546 234 1234	+1-546-234-1234|1 546 234 1234|546 234 1234	Personal communications services
436	10	547	(?:\\+?1[ -]?)?547[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?547[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1547-234-1234 or 1547 234 1234 or 547-234-1234.	Only +digits or local formats allowed i.e. +1547-234-1234 or 1547 234 1234 or 547-234-1234.	+1-547-234-1234|1 547 234 1234|547 234 1234	+1-547-234-1234|1 547 234 1234|547 234 1234	Personal communications services
437	10	549	(?:\\+?1[ -]?)?549[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?549[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1549-234-1234 or 1549 234 1234 or 549-234-1234.	Only +digits or local formats allowed i.e. +1549-234-1234 or 1549 234 1234 or 549-234-1234.	+1-549-234-1234|1 549 234 1234|549 234 1234	+1-549-234-1234|1 549 234 1234|549 234 1234	Personal communications services
438	10	550	(?:\\+?1[ -]?)?550[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?550[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1550-234-1234 or 1550 234 1234 or 550-234-1234.	Only +digits or local formats allowed i.e. +1550-234-1234 or 1550 234 1234 or 550-234-1234.	+1-550-234-1234|1 550 234 1234|550 234 1234	+1-550-234-1234|1 550 234 1234|550 234 1234	Personal communications services
439	10	552	(?:\\+?1[ -]?)?552[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?552[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1552-234-1234 or 1552 234 1234 or 552-234-1234.	Only +digits or local formats allowed i.e. +1552-234-1234 or 1552 234 1234 or 552-234-1234.	+1-552-234-1234|1 552 234 1234|552 234 1234	+1-552-234-1234|1 552 234 1234|552 234 1234	Personal communications services
440	10	553	(?:\\+?1[ -]?)?553[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?553[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1553-234-1234 or 1553 234 1234 or 553-234-1234.	Only +digits or local formats allowed i.e. +1553-234-1234 or 1553 234 1234 or 553-234-1234.	+1-553-234-1234|1 553 234 1234|553 234 1234	+1-553-234-1234|1 553 234 1234|553 234 1234	Personal communications services
441	10	554	(?:\\+?1[ -]?)?554[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?554[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1554-234-1234 or 1554 234 1234 or 554-234-1234.	Only +digits or local formats allowed i.e. +1554-234-1234 or 1554 234 1234 or 554-234-1234.	+1-554-234-1234|1 554 234 1234|554 234 1234	+1-554-234-1234|1 554 234 1234|554 234 1234	Personal communications services
442	10	556	(?:\\+?1[ -]?)?556[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?556[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1556-234-1234 or 1556 234 1234 or 556-234-1234.	Only +digits or local formats allowed i.e. +1556-234-1234 or 1556 234 1234 or 556-234-1234.	+1-556-234-1234|1 556 234 1234|556 234 1234	+1-556-234-1234|1 556 234 1234|556 234 1234	Personal communications services
443	10	566	(?:\\+?1[ -]?)?566[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?566[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1566-234-1234 or 1566 234 1234 or 566-234-1234.	Only +digits or local formats allowed i.e. +1566-234-1234 or 1566 234 1234 or 566-234-1234.	+1-566-234-1234|1 566 234 1234|566 234 1234	+1-566-234-1234|1 566 234 1234|566 234 1234	Personal communications services
444	10	558	(?:\\+?1[ -]?)?558[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?558[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1558-234-1234 or 1558 234 1234 or 558-234-1234.	Only +digits or local formats allowed i.e. +1558-234-1234 or 1558 234 1234 or 558-234-1234.	+1-558-234-1234|1 558 234 1234|558 234 1234	+1-558-234-1234|1 558 234 1234|558 234 1234	Personal communications services
445	10	569	(?:\\+?1[ -]?)?569[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?569[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1569-234-1234 or 1569 234 1234 or 569-234-1234.	Only +digits or local formats allowed i.e. +1569-234-1234 or 1569 234 1234 or 569-234-1234.	+1-569-234-1234|1 569 234 1234|569 234 1234	+1-569-234-1234|1 569 234 1234|569 234 1234	Personal communications services
446	10	577	(?:\\+?1[ -]?)?577[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?577[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1577-234-1234 or 1577 234 1234 or 577-234-1234.	Only +digits or local formats allowed i.e. +1577-234-1234 or 1577 234 1234 or 577-234-1234.	+1-577-234-1234|1 577 234 1234|577 234 1234	+1-577-234-1234|1 577 234 1234|577 234 1234	Personal communications services
447	10	578	(?:\\+?1[ -]?)?578[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?578[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1578-234-1234 or 1578 234 1234 or 578-234-1234.	Only +digits or local formats allowed i.e. +1578-234-1234 or 1578 234 1234 or 578-234-1234.	+1-578-234-1234|1 578 234 1234|578 234 1234	+1-578-234-1234|1 578 234 1234|578 234 1234	Personal communications services
448	10	588	(?:\\+?1[ -]?)?588[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?588[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1588-234-1234 or 1588 234 1234 or 588-234-1234.	Only +digits or local formats allowed i.e. +1588-234-1234 or 1588 234 1234 or 588-234-1234.	+1-588-234-1234|1 588 234 1234|588 234 1234	+1-588-234-1234|1 588 234 1234|588 234 1234	Personal communications services
449	10	589	(?:\\+?1[ -]?)?589[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?589[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1589-234-1234 or 1589 234 1234 or 589-234-1234.	Only +digits or local formats allowed i.e. +1589-234-1234 or 1589 234 1234 or 589-234-1234.	+1-589-234-1234|1 589 234 1234|589 234 1234	+1-589-234-1234|1 589 234 1234|589 234 1234	Personal communications services
450	10	900	(?:\\+?1[ -]?)?900[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?900[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1900-234-1234 or 1900 234 1234 or 900-234-1234.	Only +digits or local formats allowed i.e. +1900-234-1234 or 1900 234 1234 or 900-234-1234.	+1-900-234-1234|1 900 234 1234|900 234 1234	+1-900-234-1234|1 900 234 1234|900 234 1234	Premium call services
451	10	800	(?:\\+?1[ -]?)?800[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?800[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1800-234-1234 or 1800 234 1234 or 800-234-1234.	Only +digits or local formats allowed i.e. +1800-234-1234 or 1800 234 1234 or 800-234-1234.	+1-800-234-1234|1 800 234 1234|800 234 1234	+1-800-234-1234|1 800 234 1234|800 234 1234	Toll-free
452	10	822	(?:\\+?1[ -]?)?822[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?822[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1822-234-1234 or 1822 234 1234 or 822-234-1234.	Only +digits or local formats allowed i.e. +1822-234-1234 or 1822 234 1234 or 822-234-1234.	+1-822-234-1234|1 822 234 1234|822 234 1234	+1-822-234-1234|1 822 234 1234|822 234 1234	Toll-free
453	10	833	(?:\\+?1[ -]?)?833[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?833[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1833-234-1234 or 1833 234 1234 or 833-234-1234.	Only +digits or local formats allowed i.e. +1833-234-1234 or 1833 234 1234 or 833-234-1234.	+1-833-234-1234|1 833 234 1234|833 234 1234	+1-833-234-1234|1 833 234 1234|833 234 1234	Toll-free
454	10	844	(?:\\+?1[ -]?)?844[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?844[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1844-234-1234 or 1844 234 1234 or 844-234-1234.	Only +digits or local formats allowed i.e. +1844-234-1234 or 1844 234 1234 or 844-234-1234.	+1-844-234-1234|1 844 234 1234|844 234 1234	+1-844-234-1234|1 844 234 1234|844 234 1234	Toll-free
455	10	855	(?:\\+?1[ -]?)?855[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?855[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1855-234-1234 or 1855 234 1234 or 855-234-1234.	Only +digits or local formats allowed i.e. +1855-234-1234 or 1855 234 1234 or 855-234-1234.	+1-855-234-1234|1 855 234 1234|855 234 1234	+1-855-234-1234|1 855 234 1234|855 234 1234	Toll-free
456	10	866	(?:\\+?1[ -]?)?866[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?866[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1866-234-1234 or 1866 234 1234 or 866-234-1234.	Only +digits or local formats allowed i.e. +1866-234-1234 or 1866 234 1234 or 866-234-1234.	+1-866-234-1234|1 866 234 1234|866 234 1234	+1-866-234-1234|1 866 234 1234|866 234 1234	Toll-free
457	10	877	(?:\\+?1[ -]?)?877[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?877[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1877-234-1234 or 1877 234 1234 or 877-234-1234.	Only +digits or local formats allowed i.e. +1877-234-1234 or 1877 234 1234 or 877-234-1234.	+1-877-234-1234|1 877 234 1234|877 234 1234	+1-877-234-1234|1 877 234 1234|877 234 1234	Toll-free
458	10	880	(?:\\+?1[ -]?)?880[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?880[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1880-234-1234 or 1880 234 1234 or 880-234-1234.	Only +digits or local formats allowed i.e. +1880-234-1234 or 1880 234 1234 or 880-234-1234.	+1-880-234-1234|1 880 234 1234|880 234 1234	+1-880-234-1234|1 880 234 1234|880 234 1234	Toll-free
459	10	881	(?:\\+?1[ -]?)?881[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?881[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1881-234-1234 or 1881 234 1234 or 881-234-1234.	Only +digits or local formats allowed i.e. +1881-234-1234 or 1881 234 1234 or 881-234-1234.	+1-881-234-1234|1 881 234 1234|881 234 1234	+1-881-234-1234|1 881 234 1234|881 234 1234	Toll-free
460	10	882	(?:\\+?1[ -]?)?882[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?882[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1882-234-1234 or 1882 234 1234 or 882-234-1234.	Only +digits or local formats allowed i.e. +1882-234-1234 or 1882 234 1234 or 882-234-1234.	+1-882-234-1234|1 882 234 1234|882 234 1234	+1-882-234-1234|1 882 234 1234|882 234 1234	Toll-free
461	10	883	(?:\\+?1[ -]?)?883[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?883[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1883-234-1234 or 1883 234 1234 or 883-234-1234.	Only +digits or local formats allowed i.e. +1883-234-1234 or 1883 234 1234 or 883-234-1234.	+1-883-234-1234|1 883 234 1234|883 234 1234	+1-883-234-1234|1 883 234 1234|883 234 1234	Toll-free
462	10	884	(?:\\+?1[ -]?)?884[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?884[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1884-234-1234 or 1884 234 1234 or 884-234-1234.	Only +digits or local formats allowed i.e. +1884-234-1234 or 1884 234 1234 or 884-234-1234.	+1-884-234-1234|1 884 234 1234|884 234 1234	+1-884-234-1234|1 884 234 1234|884 234 1234	Toll-free
463	10	885	(?:\\+?1[ -]?)?885[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?885[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1885-234-1234 or 1885 234 1234 or 885-234-1234.	Only +digits or local formats allowed i.e. +1885-234-1234 or 1885 234 1234 or 885-234-1234.	+1-885-234-1234|1 885 234 1234|885 234 1234	+1-885-234-1234|1 885 234 1234|885 234 1234	Toll-free
464	10	886	(?:\\+?1[ -]?)?886[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?886[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1886-234-1234 or 1886 234 1234 or 886-234-1234.	Only +digits or local formats allowed i.e. +1886-234-1234 or 1886 234 1234 or 886-234-1234.	+1-886-234-1234|1 886 234 1234|886 234 1234	+1-886-234-1234|1 886 234 1234|886 234 1234	Toll-free
465	10	887	(?:\\+?1[ -]?)?887[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?887[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1887-234-1234 or 1887 234 1234 or 887-234-1234.	Only +digits or local formats allowed i.e. +1887-234-1234 or 1887 234 1234 or 887-234-1234.	+1-887-234-1234|1 887 234 1234|887 234 1234	+1-887-234-1234|1 887 234 1234|887 234 1234	Toll-free
466	10	888	(?:\\+?1[ -]?)?888[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?888[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1888-234-1234 or 1888 234 1234 or 888-234-1234.	Only +digits or local formats allowed i.e. +1888-234-1234 or 1888 234 1234 or 888-234-1234.	+1-888-234-1234|1 888 234 1234|888 234 1234	+1-888-234-1234|1 888 234 1234|888 234 1234	Toll-free
467	10	889	(?:\\+?1[ -]?)?889[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?889[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1889-234-1234 or 1889 234 1234 or 889-234-1234.	Only +digits or local formats allowed i.e. +1889-234-1234 or 1889 234 1234 or 889-234-1234.	+1-889-234-1234|1 889 234 1234|889 234 1234	+1-889-234-1234|1 889 234 1234|889 234 1234	Toll-free
468	10	710	(?:\\+?1[ -]?)?710[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?710[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1710-234-1234 or 1710 234 1234 or 710-234-1234.	Only +digits or local formats allowed i.e. +1710-234-1234 or 1710 234 1234 or 710-234-1234.	+1-710-234-1234|1 710 234 1234|710 234 1234	+1-710-234-1234|1 710 234 1234|710 234 1234	US government
473	15	787	(?:\\+?1[ -]?)?787[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?787[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1787-234-1234 or 1787 234 1234 or 787-234-1234.	Only +digits or local formats allowed i.e. +1787-234-1234 or 1787 234 1234 or 787-234-1234.	+1-787-234-1234|1 787 234 1234|787 234 1234	+1-787-234-1234|1 787 234 1234|787 234 1234	Puerto Rico
472	14	869	(?:\\+?1[ -]?)?869[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?869[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1869-234-1234 or 1869 234 1234 or 869-234-1234.	Only +digits or local formats allowed i.e. +1869-234-1234 or 1869 234 1234 or 869-234-1234.	+1-869-234-1234|1 869 234 1234|869 234 1234	+1-869-234-1234|1 869 234 1234|869 234 1234	Saint Kitts and Nevis
469	11	242	(?:\\+?1[ -]?)?242[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?242[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1242-234-1234 or 1242 234 1234 or 242-234-1234.	Only +digits or local formats allowed i.e. +1242-234-1234 or 1242 234 1234 or 242-234-1234.	+1-242-234-1234|1 242 234 1234|242 234 1234	+1-242-234-1234|1 242 234 1234|242 234 1234	The Bahamas
471	13	868	(?:\\+?1[ -]?)?868[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?868[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1868-234-1234 or 1868 234 1234 or 868-234-1234.	Only +digits or local formats allowed i.e. +1868-234-1234 or 1868 234 1234 or 868-234-1234.	+1-868-234-1234|1 868 234 1234|868 234 1234	+1-868-234-1234|1 868 234 1234|868 234 1234	Trinidad and Tobago
488	26	340	(?:\\+?1[ -]?)?340[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?340[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1340-234-1234 or 1340 234 1234 or 340-234-1234.	Only +digits or local formats allowed i.e. +1340-234-1234 or 1340 234 1234 or 240-234-1234.	+1-340-234-1234|1 340 234 1234|340 234 1234	+1-340-234-1234|1 340 234 1234|340 234 1234	Virgin Islands
491	27	3	(?:\\+?61[ -]?)?3[ -]?[2-9]\\d{3}[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +613-9567-2876 or (03) 9567 2876 or 0395672876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+613-9567-2876|(03) 9567 2876|0395672876	+61438-567-876|0438 567 876|0438567876	New South Wales => Buronga
492	27	2	(?:\\+?61[ -]?)?2[ -]?[2-9]\\d{3}[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +612-9567-2876 or (02) 9567 2876 or 0295672876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+612-9567-2876|(02) 9567 2876|0295672876	+61438-567-876|0438 567 876|0438567876	New South Wales
490	27	2	(?:\\+?61[ -]?)?2[ -]?[2-9]\\d{3}[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +612-9567-2876 or (02) 9567 2876 or 0295672876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+612-9567-2876|(02) 9567 2876|0295672876	+61438-567-876|0438 567 876|0438567876	Victoria => Wodonga
487	25	268	(?:\\+?1[ -]?)?268[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?268[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1268-234-1234 or 1268 234 1234 or 268-234-1234.	Only +digits or local formats allowed i.e. +1268-234-1234 or 1248 234 1234 or 248-234-1234.	+1-248-234-1234|1 248 234 1234|248 234 1234	+1-248-234-1234|1 248 234 1234|248 234 1234	Antigua and Barbuda
483	21	246	(?:\\+?1[ -]?)?246[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?246[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1246-234-1234 or 1246 234 1234 or 246-234-1234.	Only +digits or local formats allowed i.e. +1246-234-1234 or 1246 234 1234 or 246-234-1234.	+1-246-234-1234|1 242 234 1234|242 234 1234	+1-246-234-1234|1 246 234 1234|246 234 1234	Barbados
482	20	284	(?:\\+?1[ -]?)?284[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?284[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1284-234-1234 or 1284 234 1234 or 284-234-1234.	Only +digits or local formats allowed i.e. +1284-234-1234 or 1284 234 1234 or 284-234-1234.	+1-248-234-1234|1 248 234 1234|248 234 1234	+1-284-234-1234|1 284 234 1234|284 234 1234	Virgin Islands
481	19	767	(?:\\+?1[ -]?)?767[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?767[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1767-234-1234 or 1767 234 1234 or 767-234-1234.	Only +digits or local formats allowed i.e. +1767-234-1234 or 1767 234 1234 or 767-234-1234.	+1-767-234-1234|1 767 234 1234|767 234 1234	+1-767-234-1234|1 767 234 1234|767 234 1234	Dominica
475	16	809	(?:\\+?1[ -]?)?809[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?809[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1809-234-1234 or 1809 234 1234 or 809-234-1234.	Only +digits or local formats allowed i.e. +1809-234-1234 or 1809 234 1234 or 809-234-1234.	+1-809-234-1234|1 809 234 1234|809 234 1234	+1-809-234-1234|1 809 234 1234|809 234 1234	Dominican Republic
476	16	829	(?:\\+?1[ -]?)?829[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?829[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1829-234-1234 or 1829 234 1234 or 829-234-1234.	Only +digits or local formats allowed i.e. +1829-234-1234 or 1829 234 1234 or 829-234-1234.	+1-829-234-1234|1 829 234 1234|829 234 1234	+1-829-234-1234|1 829 234 1234|829 234 1234	Dominican Republic
486	24	473	(?:\\+?1[ -]?)?473[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?473[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1473-234-1234 or 1473 234 1234 or 473-234-1234.	Only +digits or local formats allowed i.e. +1473-234-1234 or 1473 234 1234 or 473-234-1234.	+1-473-234-1234|1 473 234 1234|473 234 1234	+1-473-234-1234|1 473 234 1234|473 234 1234	Grenada
477	16	849	(?:\\+?1[ -]?)?849[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?849[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1849-234-1234 or 1849 234 1234 or 829-234-1234.	Only +digits or local formats allowed i.e. +1849-234-1234 or 1829 234 1234 or 829-234-1234.	+1-849-234-1234|1 849 234 1234|849 234 1234	+1-849-234-1234|1 849 234 1234|849 234 1234	Dominican Republic
479	17	876	(?:\\+?1[ -]?)?876[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?876[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1876-234-1234 or 1876 234 1234 or 876-234-1234.	Only +digits or local formats allowed i.e. +1876-234-1234 or 1876 234 1234 or 876-234-1234.	+1-876-234-1234|1 876 234 1234|876 234 1234	+1-876-234-1234|1 876 234 1234|876 234 1234	Jamaica
478	17	658	(?:\\+?1[ -]?)?658[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?658[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1658-234-1234 or 1658 234 1234 or 658-234-1234.	Only +digits or local formats allowed i.e. +1658-234-1234 or 1658 234 1234 or 658-234-1234.	+1-658-234-1234|1 658 234 1234|658 234 1234	+1-658-234-1234|1 658 234 1234|658 234 1234	Jamaica
484	22	664	(?:\\+?1[ -]?)?664[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?664[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1664-234-1234 or 1664 234 1234 or 664-234-1234.	Only +digits or local formats allowed i.e. +1664-234-1234 or 1664 234 1234 or 664-234-1234.	+1-664-234-1234|1 664 234 1234|664 234 1234	+1-664-234-1234|1 664 234 1234|664 234 1234	Montserrat
474	15	939	(?:\\+?1[ -]?)?939[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?939[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1939-234-1234 or 1939 234 1234 or 939-234-1234.	Only +digits or local formats allowed i.e. +1939-234-1234 or 1939 234 1234 or 939-234-1234.	+1-939-234-1234|1 939 234 1234|939 234 1234	+1-939-234-1234|1 939 234 1234|939 234 1234	Puerto Rico
485	23	721	(?:\\+?1[ -]?)?721[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?721[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1721-234-1234 or 1721 234 1234 or 721-234-1234.	Only +digits or local formats allowed i.e. +1721-234-1234 or 1721 234 1234 or 721-234-1234.	+1-721-234-1234|1 721 234 1234|721 234 1234	+1-721-234-1234|1 721 234 1234|721 234 1234	Sint Maarten
493	27	8	(?:\\+?61[ -]?)?8[ -]?[2-9]\\d{3}[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +618-9567-2876 or (08) 9567 2876 or 0895672876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+618-9567-2876|(08) 9567 2876|0895672876	+61438-567-876|0438 567 876|0438567876	New South Wales => Broken Hill
4	5	684	(?:\\+?1[ -]?)?684[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?684[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1684-234-1234 or 1684 234 1234 or 684-234-1234.	Only +digits or local formats allowed i.e. +1684-234-1234 or 1684 234 1234 or 684-234-1234.	+1-684-234-1234|1 684 234 1234|684 234 1234	+1-684-234-1234|1 684 234 1234|684 234 1234	American Samoa
480	18	264	(?:\\+?1[ -]?)?264[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?264[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1264-234-1234 or 1264 234 1234 or 264-234-1234.	Only +digits or local formats allowed i.e. +1264-234-1234 or 1246 234 1234 or 246-234-1234.	+1-246-234-1234|1 242 234 1234|242 234 1234	+1-246-234-1234|1 246 234 1234|246 234 1234	Anguilla
494	27	3	(?:\\+?61[ -]?)?3[ -]?[2-9]\\d{3}[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +613-9567-2876 or (03) 9567 2876 or 0395672876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+613-9567-2876|(03) 9567 2876|0395672876	+61438-567-876|0438 567 876|0438567876	New South Wales  => Deniliquin
495	27	3	(?:\\+?61[ -]?)?3[ -]?[2-9]\\d{3}[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +613-9567-2876 or (03) 9567 2876 or 0395672876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+613-9567-2876|(03) 9567 2876|0395672876	+61438-567-876|0438 567 876|0438567876	Victoria
499	27	8	(?:\\+?61[ -]?)?8[ -]?[2-9]\\d{3}[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +618-9567-2876 or (08) 9567 2876 or 0895672876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+618-9567-2876|(08) 9567 2876|0895672876	+61438-567-876|0438 567 876|0438567876	South  Australia
497	27	8	(?:\\+?61[ -]?)?8[ -]?[2-9]\\d{3}[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +618-9567-2876 or (08) 9567 2876 or 0895672876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+618-9567-2876|(08) 9567 2876|0895672876	+61438-567-876|0438 567 876|0438567876	Northern Territory
498	27	8	(?:\\+?61[ -]?)?8[ -]?[2-9]\\d{3}[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +618-9567-2876 or (08) 9567 2876 or 0895672876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+618-9567-2876|(08) 9567 2876|0895672876	+61438-567-876|0438 567 876|0438567876	Western Australia
496	27	7	(?:\\+?61[ -]?)?7[ -]?[2-9]\\d{3}[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +617-9567-2876 or (07) 9567 2876 or 0795672876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+617-9567-2876|(07) 9567 2876|0795672876	+61438-567-876|0438 567 876|0438567876	Queensland
501	43	8	(?:\\+?61[ -]?)?8[ -]?9162[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +618-9162-2876 or (02) 9162 2876 or 0891622876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+618-9162-2876|(08) 9162 2876|0891622876	+61438-567-876|0438 567 876|0438567876	Cocos (Keeling) Islands
470	12	671	(?:\\+?1[ -]?)?671[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?671[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1671-234-1234 or 1671 234 1234 or 671-234-1234.	Only +digits or local formats allowed i.e. +1671-234-1234 or 1671 234 1234 or 671-234-1234.	+1-671-234-1234|1 671 234 1234|671 234 1234	+1-671-234-1234|1 671 234 1234|671 234 1234	Guam
69	9	758	(?:\\+?1[ -]?)?758[ -]?[2-9]\\d{2}[ -]?\\d{4}	(?:\\+?1[ -]?)?758[ -]?[2-9]\\d{2}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +1758-234-1234 or 1758 234 1234 or 758-234-1234.	Only +digits or local formats allowed i.e. +1758-234-1234 or 1758 234 1234 or 758-234-1234.	+1-758-234-1234|1 758 234 1234|758   234 1234	+1-758-234-1234|1 758 234 1234|758 234 1234	Saint Lucia
500	42	8	(?:\\+?61[ -]?)?8[ -]?[2-9]\\d{3}[ -]?\\d{4}	(?:\\+61|0)?4\\d{2}[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +618-9567-2876 or (08) 9567 2876 or 0895672876.	Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876	+618-9567-2876|(08) 9567 2876|0895672876	+61438-567-876|0438 567 876|0438567876	Christmas Island
503	44	6	(?:\\+?64[ -]?)6[ -]?75\\d[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +646-756-2876 or (06) 756 2876 or 067562876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+646-756-2876|(06) 756 2876|067562876	+64268-560-876|0260 567 876|0260567876	New Plymouth
504	44	4	(?:\\+?64[ -]?)4[ -]?52\\d[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +644-5267-2876 or (04) 526 2876 or 045262876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+644-526-2876|(04) 526 2876|045262876	+64268-560-876|0260 567 876|0260567876	Upper Hutt
505	44	4	(?:\\+?64[ -]?)4[ -]?23\\d[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +644-2367-2876 or (04) 236 2876 or 042362876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+644-236-2876|(04) 236 2876|042362876	+64268-560-876|0260 567 876|0260567876	Porirua
506	44	4	(?:\\+?64[ -]?)4[ -]?56\\d[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +644-5667-2876 or (04) 566 2876 or 045662876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+644-756-2876|(04) 566 2876|045662876	+64268-560-876|0260 567 876|0260567876	Lower Hutt
507	44	4	(?:\\+?64[ -]?)4[ -]?47\\d[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +644-476-2876 or (04) 756 477 or 047472876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+644-476-2876|(04) 476 2876|044762876	+64268-560-876|0260 567 876|0260567876	Wellington north
502	44	9	(?:\\+?64[ -]?)9[ -]?43\\d[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +649-436-2876 or (09) 436 2876 or 094362876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0226067876	+649-9567-2876|(09) 9567 2876|0995672876	+64438-567-876|0438 567 876|0438567876	Whangarei
508	44	4	(?:\\+?64[ -]?)4[ -]?38\\d[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +644-3867-2876 or (04) 386 2876 or 043862876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+644-756-2876|(04) 386 2876|043862876	+64268-560-876|0260 567 876|0260567876	Wellington south
509	44	3	(?:\\+?64[ -]?)3[ -]?54\\d[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +643-9567-2876 or (03) 756 2876 or 037562876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+643-546-2876|(03) 546 2876|035462876	+64268-560-876|0260 567 876|0260567876	Nelson
510	44	3	(?:\\+?64[ -]?)3[ -]?319[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +643-319-2876 or (03) 319 2876 or 033192876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+643-756-2876|(03) 756 2876|037562876	+64268-560-876|0260 567 876|0260567876	Kaikoura
511	44	3	(?:\\+?64[ -]?)3[ -]?4\\d{2}[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +643-456-2876 or (03) 456 2876 or 034562876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+643-456-2876|(03) 456 2876|034562876	+64268-560-876|0260 567 876|0260567876	Dunedin
512	44	3	(?:\\+?64[ -]?)3[ -]?21\\d[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +643-216-2876 or (03) 216 2876 or 032162876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+643-756-2876|(03) 216 2876|032162876	+64268-560-876|0260 567 876|0260567876	Invercargill
514	56	9	(?:\\+?64[ -]?)9[ -]?(?:44|47|41|2\\d|3\\d|48|5\\d|6\\d|8\\d|2\\d|9\\d)\\d[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +649-446-2876 or (09) 446 2876 or 094462876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+649-446-2876|(09) 446 2876|094462876	+64268-560-876|0260 567 876|0260567876	Pitcairn Islands
515	44	2	(?:\\+?64[ -]?)2[ -]?409[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +642-409-2876 or (02) 409 2876 or 024092876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+642-756-2876|(02) 409 2876|024092876	+64268-560-876|0260 567 876|0260567876	Scott Base
516	44	3	(?:\\+?64[ -]?)3[ -]?\\d{3}[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +643-756-2876 or (03) 756 2876 or 037562876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+643-756-2876|(03) 756 2876|037562876	+64268-560-876|0260 567 876|0260567876	South Islands & Chatham Islands
517	44	4	(?:\\+?64[ -]?)4[ -]?\\d{3}[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +644-756-2876 or (04) 756 2876 or 047562876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+644-756-2876|(04) 756 2876|047562876	+64268-560-876|0260 567 876|0260567876	Wellington metro area and Kapiti Coast district (excluding Otaki)
518	44	6	(?:\\+?64[ -]?)6[ -]?\\d{3}[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +646-756-2876 or (06) 756 2876 or 067562876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+646-756-2876|(06) 756 2876|067562876	+64268-560-876|0260 567 876|0260567876	Taranaki, ManawatÅ«-Whanganui (excluding Taumarunui and National Park), Hawke's Bay, Gisborne, the Wairarapa, and Otaki.
519	44	7	(?:\\+?64[ -]?)7[ -]?\\d{3}[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +647-756-2876 or (07) 756 2876 or 077562876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+647-756-2876|(07) 756 2876|077562876	+64268-560-876|0260 567 876|0260567876	Waikato (excluding Tuakau and Pokeno) and the Bay of Plenty
520	44	9	(?:\\+?64[ -]?)9[ -]?\\d{3}[ -]?\\d{4}	(?:\\+64|0)(?:(?:2\\d|85|86|96)\\d{2})[ -]?\\d{3}[ -]?\\d{3}	Only +digits or local formats allowed i.e. +649-756-2876 or (09) 756 2876 or 097562876.	Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876	+649-756-2876|(09) 756 2876|097562876	+64268-560-876|0260 567 876|0260567876	Auckland, Northland, Tuakau and Pokeno.
521	63	2	(?:\\+20[ -]?|0)2[ -]\\d{4}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-2-8756-2876 or (02) 8756 2876 or 0287562876.	Only +digits or local formats allowed. i.e. +20-12-5678-8765 or 02 10 4567 876 or 021560567876	+20-2-8756-2876|(02) 8756 2876|0287562876	+2011-5610-876|02 12 4567 8765|021560567876	Greater Cairo (Cairo, Giza, and part of Qalyubia)
522	63	3	(?:\\+?20[ -]?|0)3[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-3-756-2876 or (03) 756 2876 or 037562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+203-756-2876|(03) 756 2876|037562876	+2012-560-876|015 567 876|010657876	Alexandria
523	63	68	(?:\\+?20[ -]?|0)68[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-68-756-2876 or (068) 756 2876 or 0687562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2068-756-2876|(068) 756 2876|0687562876	+2012-560-876|015 567 876|010657876	Arish
524	63	97	(?:\\+?20[ -]?|0)97[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-97-756-2876 or (097) 756 2876 or 0977562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2097-756-2876|(097) 756 2876|0977562876	+2012-560-876|015 567 876|010657876	Aswan
525	63	82	(?:\\+?20[ -]?|0)82[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-82-756-2876 or (082) 756 2876 or 0827562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2082-756-2876|(082) 756 2876|0827562876	+2012-560-876|015 567 876|010657876	Beni Suef
526	63	57	(?:\\+?64[ -]?|0)57[ -]?\\d{3}[ -]?\\d{4}	(?:\\+64|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +64-57-756-2876 or (057) 756 2876 or 0577562876.	Only +digits or local formats allowed. i.e. +6410-567-8765 or 011 567 8765 or 01260567876	+6457-756-2876|(057) 756 2876|0577562876	+6412-560-876|015 567 876|010657876	Damietta
527	63	64	(?:\\+?20[ -]?|0)64[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-64-756-2876 or (064) 756 2876 or 0647562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2064-756-2876|(064) 756 2876|0647562876	+2012-560-876|015 567 876|010657876	Ismailia
528	63	95	(?:\\+?20[ -]?|0)95[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-95-756-2876 or (095) 756 2876 or 0957562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2095-756-2876|(095) 756 2876|0957562876	+2012-560-876|015 567 876|010657876	Luxor
529	63	50	(?:\\+?20[ -]?|0)50[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-50-756-2876 or (050) 756 2876 or 0507562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2050-756-2876|(050) 756 2876|0507562876	+2012-560-876|015 567 876|010657876	Mansoura
530	63	48	(?:\\+?20[ -]?|0)48[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-48-756-2876 or (048) 756 2876 or 0487562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2048-756-2876|(048) 756 2876|0487562876	+2012-560-876|015 567 876|010657876	Monufia
531	63	66	(?:\\+?20[ -]?|0)66[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-66-756-2876 or (066) 756 2876 or 0667562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2066-756-2876|(066) 756 2876|0667562876	+2012-560-876|015 567 876|010657876	Port Said
532	63	65	(?:\\+?20[ -]?|0)65[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-65-756-2876 or (065) 756 2876 or 0657562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2065-756-2876|(065) 756 2876|0657562876	+2012-560-876|015 567 876|010657876	Red Sea
533	63	62	(?:\\+?20[ -]?|0)62[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-62-756-2876 or (062) 756 2876 or 0627562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2062-756-2876|(062) 756 2876|0627562876	+2012-560-876|015 567 876|010657876	Suez
534	63	69	(?:\\+?20[ -]?|0)69[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-69-756-2876 or (069) 756 2876 or 0697562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2069-756-2876|(069) 756 2876|0697562876	+2012-560-876|015 567 876|010657876	El Tor
535	63	55	(?:\\+?20[ -]?|0)55[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-55-756-2876 or (055) 756 2876 or 0557562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2055-756-2876|(055) 756 2876|0557562876	+2012-560-876|015 567 876|010657876	10th of Ramadan
536	63	88	(?:\\+?20[ -]?|0)88[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-88-756-2876 or (088) 756 2876 or 0887562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2088-756-2876|(088) 756 2876|0887562876	+2012-560-876|015 567 876|010657876	Asyut
537	63	13	(?:\\+?20[ -]?|0)13[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-13-756-2876 or (013) 756 2876 or 0137562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2013-756-2876|(013) 756 2876|0137562876	+2012-560-876|015 567 876|010657876	Benha
538	63	45	(?:\\+?20[ -]?|0)45[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-45-756-2876 or (045) 756 2876 or 0457562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2045-756-2876|(045) 756 2876|0457562876	+2012-560-876|015 567 876|010657876	Damanhur
539	63	84	(?:\\+?20[ -]?|0)84[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-84-756-2876 or (084) 756 2876 or 0847562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2084-756-2876|(084) 756 2876|0847562876	+2012-560-876|015 567 876|010657876	Faiyum
540	63	47	(?:\\+?20[ -]?|0)47[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-47-756-2876 or (047) 756 2876 or 0477562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2047-756-2876|(047) 756 2876|0477562876	+2012-560-876|015 567 876|010657876	Kafr El Sheikh
541	63	46	(?:\\+?20[ -]?|0)46[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-46-756-2876 or (046) 756 2876 or 0467562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2046-756-2876|(046) 756 2876|0467562876	+2012-560-876|015 567 876|010657876	Marsa Matruh
542	63	86	(?:\\+?20[ -]?|0)86[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-86-756-2876 or (086) 756 2876 or 0867562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2086-756-2876|(086) 756 2876|0867562876	+2012-560-876|015 567 876|010657876	Minya
543	63	92	(?:\\+?20[ -]?|0)92[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-92-756-2876 or (092) 756 2876 or 0927562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2092-756-2876|(092) 756 2876|0927562876	+2012-560-876|015 567 876|010657876	New Valley
544	63	92	(?:\\+?20[ -]?|0)92[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-92-756-2876 or (092) 756 2876 or 0927562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2092-756-2876|(092) 756 2876|0927562876	+2012-560-876|015 567 876|010657876	New Valley
545	63	96	(?:\\+?20[ -]?|0)96[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-96-756-2876 or (096) 756 2876 or 0967562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2096-756-2876|(096) 756 2876|0967562876	+2012-560-876|015 567 876|010657876	Qena
546	63	93	(?:\\+?20[ -]?|0)93[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-93-756-2876 or (093) 756 2876 or 0937562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2093-756-2876|(093) 756 2876|0937562876	+2012-560-876|015 567 876|010657876	Sohag
547	63	40	(?:\\+?20[ -]?|0)40[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-40-756-2876 or (040) 756 2876 or 0407562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2040-756-2876|(040) 756 2876|0407562876	+2012-560-876|015 567 876|010657876	Tanta
548	63	55	(?:\\+?20[ -]?|0)55[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-55-756-2876 or (055) 756 2876 or 0557562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2055-756-2876|(055) 756 2876|0557562876	+2012-560-876|015 567 876|010657876	Zagazig
549	63	13	(?:\\+?20[ -]?|0)13[ -]?\\d{3}[ -]?\\d{4}	(?:\\+20|0)(?:(?:10|11|12|15)\\d{2})[ -]?\\d{4}[ -]?\\d{4}	Only +digits or local formats allowed i.e. +20-13-756-2876 or (013) 756 2876 or 0137562876.	Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876	+2013-756-2876|(013) 756 2876|0137562876	+2012-560-876|015 567 876|010657876	Qalyubia
\.


--
-- TOC entry 3674 (class 0 OID 16946)
-- Dependencies: 229
-- Data for Name: email; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.email (id, _email, verified) FROM stdin;
4	grizzly@smit.id.au	f
2	grizzly@smit.id.au	f
11	romanna@tardis.org	f
8	doctor@tardis.org	f
13	bilbo@baggins.com	f
14	grizzly@smit.id.au	f
17	ludo@baggins.org	f
18	ludo@baggins.org	f
19	fred@bloggs.com	f
21	grizzly@smit.id.au	f
7	frodo@tolkien.com	f
1	grizzly@smit.id.au	f
10	fred@bedrock.org	f
3	grizzly@smit.id.au	f
22	grizzly@smit.id.au	f
\.


--
-- TOC entry 3676 (class 0 OID 16952)
-- Dependencies: 231
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.emails (id, email_id, passwd_id) FROM stdin;
\.


--
-- TOC entry 3678 (class 0 OID 16957)
-- Dependencies: 233
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.groups (id, group_id, passwd_id) FROM stdin;
1	4	2
3	1	2
8	5	2
9	3	3
10	1	3
24	8	3
28	8	2
29	1	8
30	3	8
31	5	8
32	4	8
33	8	8
40	10	10
41	9	10
42	3	10
43	4	10
44	5	10
45	1	10
46	8	10
47	1	11
48	8	11
49	5	11
50	4	11
51	3	11
52	10	11
53	11	11
133	1	13
134	5	13
135	4	13
136	3	13
137	9	13
138	10	13
139	11	13
140	8	13
141	12	13
186	5	1
187	4	1
188	3	1
189	10	1
190	12	1
191	11	1
192	9	1
209	14	1
210	8	1
211	1	14
212	5	14
213	4	14
214	3	14
215	10	14
216	12	14
217	11	14
218	9	14
219	14	14
220	8	14
241	1	17
242	10	17
243	10	18
244	11	18
245	1	20
246	5	20
247	4	20
248	38	20
258	15	1
281	22	1
333	34	1
334	38	1
348	21	1
\.


--
-- TOC entry 3671 (class 0 OID 16914)
-- Dependencies: 223
-- Data for Name: links; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.links (userid, groupid, _perms, id, section_id, link, name) FROM stdin;
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	1	1	https://version.oztell.com.au/anycast/dl.88.io	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	2	1	https://version.oztell.com.au/anycast/dl.88.io/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	3	2	https://version.contacttrace.com.au/fiduciary-exchange/key/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	4	2	https://version.contacttrace.com.au/fiduciary-exchange/key/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	5	2	https://version.contacttrace.com.au/fiduciary-exchange/key/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	6	3	https://vault.net2maxlabs.net/net2max1/wp-admin/post.php?post=48209&action=edit	edit-docs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	7	3	https://vault.net2maxlabs.net/net2max1/location-grid/	view-docs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	8	4	https://version.contacttrace.com.au/fiduciary-exchange/address/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	9	4	https://version.contacttrace.com.au/fiduciary-exchange/address/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	10	4	https://version.contacttrace.com.au/fiduciary-exchange/address/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	11	5	https://version.contacttrace.com.au/contact0/input/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	12	5	https://version.contacttrace.com.au/contact0/input	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	13	5	https://version.contacttrace.com.au/contact0/input/-pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	14	6	https://version.contacttrace.com.au/contact0/app/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	15	6	https://version.contacttrace.com.au/contact0/app/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	16	6	https://version.contacttrace.com.au/contact0/app/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	17	7	https://version.contacttrace.com.au/contact0/output/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	18	7	https://version.contacttrace.com.au/contact0/output/-scripts/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	19	7	https://version.contacttrace.com.au/contact0/output/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	20	8	https://vault.net2maxlabs.net/net2max1/business-identity-check/	view-docs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	21	8	https://vault.net2maxlabs.net/net2max1/wp-admin/post.php?post=51576&action=edit	edit-docs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	164	82	https://ledger.contacttrace.com.au/	viewer
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	167	85	https://version.oztell.com.au/88io0/jeiheaxi2iu4phea.1.88.io/-/jobs	pipeline
2	3	("(t,t,t)","(t,t,t)","(t,f,f)")	171	88	https://version.oztell.com.au/oztralia0/portknocking.oztralia.com	main
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	174	91	https://ledger.contacttrace.com.au/	kbd-viewer
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	177	95	https://version.contacttrace.com.au/contact0/api	main
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	180	62	https://gjs.guide/guides/gjs/style-guide.html#prettier	style-guide
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	182	62	https://gjs.guide/extensions/topics/dialogs.html#shell	dialogs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	184	101	https://version.contacttrace.com.au/	contacttrace
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	188	104	https://version.5littlepigs.net/	5littlepigs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	22	9	https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/-/blob/prod/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	23	9	https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	24	9	https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	25	10	https://version.contacttrace.com.au/fiduciary-exchange/signature/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	26	10	https://version.contacttrace.com.au/fiduciary-exchange/signature/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	27	10	https://version.contacttrace.com.au/fiduciary-exchange/signature/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	28	11	https://chat.quuvoo4ohcequuox.0.88.io/home	chat
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	29	12	https://version.oztell.com.au/88io0/tools/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	31	12	https://version.oztell.com.au/88io0/tools/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	32	13	https://version.contacttrace.com.au/contact2/api_ugh8eika/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	33	13	https://version.contacttrace.com.au/contact2/api_ugh8eika/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	34	13	https://version.contacttrace.com.au/contact2/api_ugh8eika/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	35	14	https://vault.net2maxlabs.net/net2max1/business-identity-check/	namecheck
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	36	14	https://vault.net2maxlabs.net/net2max1/location-grid/	map
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	37	15	https://version.contacttrace.com.au/contact0/storage/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	38	15	https://version.contacttrace.com.au/contact0/storage/-/pipelines	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	39	15	https://version.contacttrace.com.au/contact0/storage/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	40	16	https://version.contacttrace.com.au/contact0/dops-portknocking/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	41	16	https://version.contacttrace.com.au/contact0/dops-portknocking/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	42	16	https://version.contacttrace.com.au/contact0/dops-portknocking/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	43	17	https://version.contacttrace.com.au/contact0/dops-scripts/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	44	17	https://version.contacttrace.com.au/contact0/dops-scripts/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	45	17	https://version.contacttrace.com.au/contact0/dops-scripts/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	46	18	https://version.contacttrace.com.au/contact0/directory/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	47	18	https://version.contacttrace.com.au/contact0/directory/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	48	18	https://version.contacttrace.com.au/contact0/directory/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	49	19	https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	50	19	https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io/-/blob/prod/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	51	19	https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	52	20	https://version.oztell.com.au/oztell8/api	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	53	21	https://version.contacttrace.com.au/contact0/processor/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	54	21	https://version.contacttrace.com.au/contact0/processor	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	55	21	https://version.contacttrace.com.au/contact0/processor/-/blob/dev/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	56	22	https://ledger.contacttrace.com.au/?chain=0-s1-dev	0-s1-dev
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	57	22	https://ledger.contacttrace.com.au/	launch-page
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	58	23	https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/-/blob/prod/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	59	23	https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	60	23	https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	165	83	https://version.oztell.com.au/anycast/app.88.io/-/pipelines	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	124	46	https://my.aussiebroadband.com.au/#/	my.aussie
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	128	46	https://speed.aussiebroadband.com.au/	aussie.speed-test
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	131	53	https://www.woolworths.com.au/	woolies
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	137	58	https://app.hireup.com.au/	home
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	136	58	https://app.hireup.com.au/dashboard	dashboard
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	69	27	https://raku.org/	main
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	166	83	https://version.oztell.com.au/anycast/app.88.io	home
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	168	85	https://version.oztell.com.au/88io0/jeiheaxi2iu4phea.1.88.io	home
2	3	("(t,t,t)","(t,t,t)","(t,f,f)")	172	88	https://version.oztell.com.au/oztralia0/portknocking.oztralia.com/-/blob/prod/README.md	readme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	178	95	https://version.contacttrace.com.au/contact0/api/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	185	101	https://version.quuvoo4ohcequuox.0.88.io/	quuvoo4ohcequuox
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	189	104	https://version.posei.net.au/	posie
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	194	108	https://gitlab.gnome.org/GNOME/gnome-shell/-/blob/main/js/ui/panel.js	Main.panel
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	196	108	https://gitlab.gnome.org/GNOME/gnome-shell	sources
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	133	55	https://wordpress.org/plugins/postie/	postie
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	134	56	https://github.com/rogerhub/postie/blob/master/filterPostie.php.sample	postie
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	135	55	https://postieplugin.com/extending/	postie-extending
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	138	60	https://vault.net2maxlabs.net/net2max1/filterpostie-php-sub-plugin-file/	docs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	139	61	https://postieplugin.com/add-ons/	plugins
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	129	45	https://www.tayaofficial.com/#/	taya
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	130	45	https://www.hillsongstore.com/music?sortBy=hillsongstorem2au_store_products	hillsong
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	123	45	https://music.youtube.com/watch?v=aA6cnb7hBwg&list=RDAMVM85bmsn-FnVo	nederland
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	126	47	http://192.168.188.1/	local
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	127	47	https://sso.myfritz.net/	account
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	125	47	https://h1i6f7rp40dqjwig.myfritz.net:42178/	main
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	152	74	http://www.bom.gov.au/nsw/forecasts/sydney.shtml	sydney
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	186	104	https://repository.88.io/	88.io
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	195	108	https://gitlab.gnome.org/GNOME/gnome-shell/-/tree/main/js/ui	ui
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	153	75	https://version.oztell.com.au/	main
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	197	115	https://fortran-lang.org/	lang
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	198	62	https://gjs.guide/extensions/upgrading/gnome-shell-40.html#custom-icon-theme	custom-icon-theme
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	150	71	https://www.bigw.com.au/	bigw
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	149	71	https://www.woolworths.com.au/	woolies-shopping
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	156	78	https://www.myequals.net/#/documents	deakin
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	158	79	https://metacpan.org/	site
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	157	79	https://metacpan.org/pod/Apache::Session::Store::Postgres	sesspg
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	61	24	https://isocpp.org/	iso
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	80	36	https://www.php.net/manual/en/security.php	security
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	79	36	https://www.php.net/manual/en/langref.php	lang
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	81	36	https://www.php.net/manual/en/funcref.php	funs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	82	36	https://www.php.net/manual/en/faq.php	faq
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	83	36	https://www.php.net/manual/en/appendices.php	apendices
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	84	36	https://www.php.net/manual/en/features.php	features
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	78	36	https://www.php.net/manual/en/	docs-en
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	77	36	https://php.net	main
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	99	34	https://www.postgresql.org/	main
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	76	34	https://www.postgresql.org/docs/	docs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	169	85	https://version.oztell.com.au/88io0/jeiheaxi2iu4phea.1.88.io/-/blob/prod/README.md	readme
2	3	("(t,t,t)","(t,t,t)","(t,f,f)")	170	88	https://version.oztell.com.au/oztralia0/portknocking.oztralia.com/-/pipelines/	pipeline
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	173	91	https://www.multichain.com/developers/json-rpc-api/	api-docs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	175	93	https://www.myequals.net/r/documents	documents
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	176	94	https://www.youtube.com/watch?v=B1J6Ou4q8vE	animator-vs-Maths
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	179	62	https://gjs-docs.gnome.org/	main
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	63	24	https://www.modernescpp.com/index.php	modernescpp
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	145	64	https://elv.sh/ref/	builtin
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	142	64	https://elv.sh/	home
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	143	64	https://github.com/elves/awesome-elvish	modules
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	122	38	https://getfedora.org/	fedora
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	146	38	https://canonical.com/	canonical
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	116	38	https://launchpad.net/ubuntu	ubuntu
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	144	64	https://github.com/elves/elvish	github
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	141	62	https://gjs.guide/	home
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	100	34	https://www.postgresql.org/account	account
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	73	27	https://docs.raku.org/type.html	types
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	181	62	https://gjs.guide/extensions/upgrading/gnome-shell-45.html#esm	port45
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	74	27	https://web.libera.chat/?channel=#raku	chat
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	154	27	https://rakubrew.org/	rakubrew
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	183	101	https://version.oztell.com.au/	oztell.com
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	187	104	https://version-au19.net2max.com/	net2max.com
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	155	62	https://rmnvgr.gitlab.io/gtk4-gjs-book/	gtk4-djs-book
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	140	62	https://gjs.guide/extensions/review-guidelines/review-guidelines.html#metadata-json-must-be-well-formed	guide
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	120	38	https://www.ubuntu.com/	ubuntu-home-page
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	190	108	https://gjs.guide/extensions/development/debugging.html#environment-variables	debugging
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	70	27	https://modules.raku.org/	modules
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	191	62	https://gjs-docs.gnome.org/adw1~1-spinrow/	Adw.spin
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	192	110	https://dbi.perl.org/	main
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	71	27	https://docs.raku.org/	docs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	147	24	https://github.com/hsutter/cppfront	cppfront
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	121	38	https://redhat.com	redhat
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	118	24	https://gcc.gnu.org/projects/cxx-status.html	g++std-status
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	62	24	https://en.cppreference.com/w/	cppref
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	117	24	https://en.cppreference.com/w/cpp/compiler_support	cpp-compiler-support
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	72	27	https://docs.raku.org/language.html	lang
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	151	24	https://github.com/hsutter/cppfront/tree/main/regression-tests	cpp2-examples
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	132	54	https://kotlinlang.org/	home
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	193	108	https://gitlab.gnome.org/GNOME/gnome-shell/blob/main/js/ui/main.js	main
\.


--
-- TOC entry 3670 (class 0 OID 16901)
-- Dependencies: 221
-- Data for Name: links_sections; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.links_sections (userid, groupid, _perms, id, section) FROM stdin;
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	1	dl.88.io
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	2	key
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	3	location-grid-old-docs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	4	address
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	5	input
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	6	app
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	7	output
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	8	business-identity-check
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	9	bronze-aus
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	10	signature
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	11	chat.q
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	12	tools
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	13	api_ugh8eika
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	14	oldocs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	15	storage
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	16	portknocking
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	17	scripts
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	18	directory
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	19	api.quuvoo4ohcequuox.0.88.io
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	20	api
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	21	processor
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	22	blockchains
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	23	portknocking-dev
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	55	wordpress-plugins
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	56	wordpress-github
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	60	n2m-wordpress-plugins
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	61	wordpress-plugins-postie
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	75	gitlab
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	36	php
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	34	postgres
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	45	music
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	47	Fritzbox
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	46	ISP
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	53	shops
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	74	weather
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	71	woolies
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	78	uni
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	58	hireup
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	91	multichain
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	93	dekin-uni
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	94	animator
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	95	a1-dev
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	101	main
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	104	minor
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	110	perl_dbi
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	115	fortran
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	108	gnome-shell
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	79	cpan
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	24	C++
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	64	elvish
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	62	gjs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	38	Linux
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	27	raku
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	54	kotlin
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	82	blockchain
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	83	app.88.io
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	85	jeiheaxi2iu4phea
2	3	("(t,t,t)","(t,t,t)","(t,f,f)")	88	portknocking.austarlia.com
\.


--
-- TOC entry 3680 (class 0 OID 16966)
-- Dependencies: 236
-- Data for Name: page_section; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.page_section (userid, groupid, _perms, id, pages_id, links_section_id) FROM stdin;
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	1	1	12
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	2	1	20
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	3	3	16
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	4	3	23
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	5	5	19
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	6	5	1
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	7	7	15
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	8	7	21
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	9	7	17
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	10	7	16
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	11	7	4
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	12	7	10
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	13	7	9
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	14	7	13
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	15	7	5
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	16	7	18
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	17	7	7
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	18	7	6
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	19	7	2
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	20	20	3
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	21	20	14
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	78	37	1
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	88	45	56
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	89	45	55
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	91	45	60
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	92	45	61
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	95	51	71
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	106	56	75
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	83	39	45
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	84	39	47
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	81	39	27
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	82	39	38
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	85	39	46
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	86	39	53
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	87	39	54
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	80	39	24
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	107	56	4
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	108	56	20
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	109	56	19
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	110	56	13
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	111	56	22
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	112	56	6
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	113	56	9
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	114	56	8
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	115	56	11
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	116	56	18
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	117	56	1
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	118	56	3
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	119	56	60
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	120	56	14
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	121	56	16
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	122	56	23
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	123	56	10
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	124	56	15
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	125	56	12
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	97	39	74
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	103	54	34
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	104	54	27
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	105	54	54
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	140	56	7
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	143	56	21
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	94	39	64
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	96	39	71
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	144	56	17
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	148	56	56
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	126	39	78
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	128	39	79
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	90	39	58
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	98	54	24
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	156	56	85
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	93	39	62
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	102	54	36
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	99	54	64
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	100	54	62
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	101	54	38
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	149	56	55
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	150	56	61
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	152	56	82
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	153	56	83
2	3	("(t,t,t)","(t,t,t)","(t,f,f)")	177	56	88
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	178	76	91
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	179	77	93
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	180	78	94
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	181	56	95
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	183	56	101
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	184	56	104
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	185	54	108
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	186	54	110
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	187	54	115
\.


--
-- TOC entry 3681 (class 0 OID 16974)
-- Dependencies: 237
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.pages (userid, groupid, _perms, id, name, full_name) FROM stdin;
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	3	knock	port knocking
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	7	contacttrace	contacttrace
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	20	docsold	The Old Docs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	37	apk	where the apks are
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	76	work-stuff	misc work stuff
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	77	Uni	University
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	78	Funny	funny
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	45	wp	wordpress
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	56	work	magic gitlabs
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	51	woolies	Wollworths
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	54	Programming	Programming
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	39	grizz-page	Grizzlys Page
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	5	88.io	88.io stuff
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	1	oztell.com.au	oztell.com.au stuff
\.


--
-- TOC entry 3686 (class 0 OID 17007)
-- Dependencies: 245
-- Data for Name: passwd; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.passwd (id, username, _password, passwd_details_id, primary_group_id, _admin, email_id) FROM stdin;
18	fbloggs	{X-PBKDF2}HMACSHA2+512:AACAAA:rtFJEL93SF7wo4Zyhp3Rnw==:59Z1xxppfZtnJrGuHgsls9ECbSkYCCMvFZW0ejPCiVOXseY5AggQ8upLXYiCy2yoD+aspbdMKXIc5oehJAFxSOo8YmR0nrdC6ujIuD/wZ1Uns+fO/WiyNHEj11CDQR69H4fnhZ0sAIeGAYSzYwi+qiDGvxCXtxrWon5fMC66SIo=	18	22	f	19
20	jo	{X-PBKDF2}HMACSHA2+512:AACAAA:ujhoa6UJN+wENHb+YKbtfA==:ltCL0YvTyWbxgpl8lxS2AHZlAAixBys6lyfDRUocbKX2GH19BJhxJj/zm+xHqW7u/X8W8S3jqfesC0wQ+kyrV8t0mC+3Vz6VdTqccaylmvpMblQHIq71li0K0IW/LaI4ocq6uYCaYVCXpVhETvK/8/racXS5XG4J5ddbKdtSEuM=	20	34	t	21
2	grizzlysmit	{X-PBKDF2}HMACSHA2+512:AACAAA:NjqO9dvDLAnOczNgQLsfjA==:JFmaefHCPpcE0VROWDfV535kIX/PGL53NgQbd6JVmciM29xLHSJiOe2cDAdY8sl/r4RjMkwULl2NlCUDTcH65oa0rSRsq+v22O+V9PWeNMOigdqtihl3gywSYPo7bptQxAlQjlDIGq2E8hj7jh64Ern6SjOFqINksG6k0AH1NYE=	2	3	t	2
4	grizz	{X-PBKDF2}HMACSHA2+512:AACAAA:t/ArvvNsg71FuQvNxlKbrg==:SpWhM4f2B/PllKvGRI4Wdt1BEGaWFP6cyvcnilw04vsXsf5yzR/0WUNpjv1ykGR4QV+dbm2SorpYzvTiCO7MsPRARdfoj3y0tC0vixCfQeALuorevLygKUdj130NgJaw4SaACR7htQY0BsAEp3hC2Ri4rhO14x/jRq2vpZz6hrY=	4	5	f	4
7	frodo	{X-PBKDF2}HMACSHA2+512:AACAAA:JA3CdPq+gRoHRQJBTRO3sg==:UCcN38FCFVpRvYLJmtj022g8BD9LB3K1BDMtW81mFw5XX7n9uY3oW9NBropO4T90+B9wRXY2ccHUgPFuhUU9ngr2ODNl8+jC7DcoWbrQuejJNRbncthqd3YZCGasFQ2shpwdRHgMm6cdRZlsoGf0ZwM2SNsO422VL6r54YivyXc=	7	8	f	7
8	doctor	{X-PBKDF2}HMACSHA2+512:AACAAA:k8jVM0hHKTauTfr6S9VcBA==:/bg1mE2OoGnddvli6zmx4M01Kyh5otk+4asFdCyjjjWQtBDTiByeNap0EiliaPPs36N2pu6H0yj9ESOTq6Z76KaLhpGApfQ5muJm2QnSb88ktCEi9AR/kP+jYEtbyGBeXB0y3Z3KHKFHlfysDCtfgxsuBAoKzq46mBZ1ORpmsPY=	8	9	t	8
11	romanna	{X-PBKDF2}HMACSHA2+512:AACAAA:ucuYJPKU7Ua7YIq5Qu5w7w==:EvWFQZV+9QEWDuljZ2HU+8tMj0FiouFh4axLmNrABIc4iKE5Yv4vACzKavzc8oxnIY0hOLVjVG7YF1ZEI7P1xAXP03iXxIJTl+Wqhmn6doN9p2a+DFzIk0DowxOVwmRcRL+HQSdKzjq0zpDv7SoDZG4DtCiccZE6HHh7807jJIM=	11	12	t	11
14	root	{X-PBKDF2}HMACSHA2+512:AACAAA:Td4nwnX2eXR0CGUJWFBL3w==:7/Cv6I0ieRU3aLk/OyHMQfYp/x1rWpPR8UystXNQTQ/YzA0QGxkYx6pYxRmw9cHU9HXcbFr5FJKq3Y5zzP9lb3MHjfcSIb3dWmYahJd61hmKpSWvOKwUUoscL3Nd9llCFeE3nISXO8aSAnZzTw+jEamHikTMYDRh6CtpjiiTt84=	14	15	t	14
17	ludo	{X-PBKDF2}HMACSHA2+512:AACAAA:LqAHPSBLz4+jg5wk/dFWPw==:OIwYvrD/Cuc0EK1hE3Ikbly9iY+ZQrsjM7lpRexaXiLwLP0WPJSHqK1m+kdYU+nybzq4CgCuisDp/TBIjl4Nb4vMQUhkAm3ufLt8Aon3tlAYthT35L0BbPL080Ce8p443HEO0j91my60pIZpL0KCBuF7Svu4sJOMA6Va1ikBjSg=	17	21	f	18
1	admin	{X-PBKDF2}HMACSHA2+512:AACAAA:EMohyYlVSRrueBKZZyAH0Q==:9iVYO0q44gEaoUgVbRrPEMub1q8n9UKf75v/Y3X/ZA98Al0LAfuA3jUwcXIuh0357+/5kW6iFlR1uuTdjISqId081k+8GcYI6zjU9t/gJaeTFUl691IUQZXm5HJ18EiMrwJU4kvv0LsUeFNin2ZtXHD4LmU6kqI8sYrkDqSFbu4=	1	1	t	1
13	bilbo	{X-PBKDF2}HMACSHA2+512:AACAAA:RfD7pOwjnMn9Mlfjv66biw==:QvQNf94ArZ8TtEjhxHVZOSF2nEt//mL+zQZXZk2uE9ditK47cIZ+ptKm0hObPuYT+6NUeAobGcCp9j6nq8O/Cc1lxrHK82eK80s3RBL2NVx1jg5VlEniEzht2czJrp2Dw9MTHYG0BOwP/gvVwcxPTdCiedawXRMSlT9EhkkHW+g=	13	14	f	13
10	fred	{X-PBKDF2}HMACSHA2+512:AACAAA:kL2pk9dK8Vc5TE9P+CqD9A==:Sm87fueBQT9r73l6HfukqoDtPvY+csR6juih63n6jT0bBlrcaZPGsbtLulU3iWYBKXWCTjlgf6AtlVlXJrdklp5Kg+rxStX/ExFZjdeOfwG+xR0uDSzSw3JqOduffO+E0z5xf1JUBA2FzTi3UKAcZDcdKRECM2ywxBlLD0UdPek=	10	11	t	10
3	grizzly	{X-PBKDF2}HMACSHA2+512:AACAAA:twS8QQ1OvZZMTESXR4upFA==:sa08eF7beBec6O0OOJWfLhhIIRUE42+AFLZHsmI021xhjQihezEj7zjj+S1YZAT5PHBdDHTkl8rrgSLh5r8QokouQoTsXgjqLXSXv1EAr3qb3477A+HAzUFKsQOTpdUHn+Y8exdo5YqB52NhMRQlHYuXU13FTYgNlatbu4EZsJI=	3	4	t	3
21	wibble	{X-PBKDF2}HMACSHA2+512:AACAAA:ih+n63nninxmgjl2OIm69A==:OJnsJweCaj+b+Nk6V+NKiZg0ICqc5JOuwPIf8sCUhubMOZybsraBn3BP1qci1A3xEiQap1rGBe3QzuaWF+mEdUNf2e0ZTIlhjdjCyrDyDJlIqky17uR1ySepQ8jA3sQclxj253IuoBwaZSWTcuyL60Z3Vo/gAXu2EQVyRDAuHaA=	21	39	t	22
\.


--
-- TOC entry 3688 (class 0 OID 17013)
-- Dependencies: 247
-- Data for Name: passwd_details; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.passwd_details (id, display_name, given, _family, residential_address_id, postal_address_id, primary_phone_id, secondary_phone_id, country_id, country_region_id) FROM stdin;
20	Jo VV Thomas	Jo VV	Thomas	26	27	35	36	27	492
2	Francis Grizzly Smit	Francis Grizzly	Smit	4	4	3	9	27	492
4	Francis Grizzly Smit	Francis Grizzly	Smit	7	6	7	10	27	492
8	The Doctor Whatever	The Doctor	Whatever	12	12	12	13	27	492
14	Francis Grizzly Smit	Francis Grizzly	Smit	18	18	27	28	27	492
11	Romanna Time Lady	Romanna	Time Lady	15	15	18	19	4	3
13	Bilbo Baggins	Bilbo	Baggins	17	17	22	23	5	4
18	Fred Bloggs	Fred	Bloggs	23	23	\N	\N	20	482
17	Ludo Baggins	Ludo	Baggins	22	22	\N	\N	42	500
7	Frodo Baggins	Frodo	Baggins	10	10	24	25	21	483
1	Francis Grizzly Smit	Francis Grizzly	Smit	3	3	1	26	27	492
10	Fred Flintstone	Fred	Flintstone	14	14	16	17	26	488
3	Francis Grizzly Smit	Francis Grizzly	Smit	5	11	5	11	27	492
21	Francis Grizzly Smit	Francis Grizzly	Smit	28	28	37	38	27	492
\.


--
-- TOC entry 3690 (class 0 OID 17020)
-- Dependencies: 249
-- Data for Name: phone; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.phone (id, _number, verified) FROM stdin;
2	+612 9217 6004	f
4	+612 9217 6004	f
6	(02) 9217 6004	f
8	+612-9217-6004	f
22	+16842341234	f
7	+61482176343	f
10	+61292176004	f
23	+16842344321	f
3	+61482176343	f
9	+61292176004	f
18	+13452341234	f
19	+13454324321	f
12	+61482176343	f
13	+61292176004	f
27	+61482176343	f
28	+61292176004	f
35	+61438176343	f
36	+61292176004	f
24	+12462341234	f
25	+12464324321	f
1	+61482176343	f
26	+61292176004	f
16	+13402341234	f
17	+13404324321	f
5	+61482176343	f
11	+61292176004	f
37	+61482176343	f
38	+61292176004	f
\.


--
-- TOC entry 3692 (class 0 OID 17026)
-- Dependencies: 251
-- Data for Name: phones; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.phones (id, phone_id, address_id) FROM stdin;
\.


--
-- TOC entry 3683 (class 0 OID 16992)
-- Dependencies: 241
-- Data for Name: pseudo_pages; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.pseudo_pages (userid, groupid, _perms, id, pattern, status, name, full_name) FROM stdin;
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	2	.*	both	all	all
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	5	.*	assigned	already	already in pages
1	1	("(t,t,t)","(t,t,t)","(t,f,f)")	1	.*	unassigned	misc	misc
\.


--
-- TOC entry 3666 (class 0 OID 16883)
-- Dependencies: 217
-- Data for Name: secure; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.secure (userid, groupid, _perms) FROM stdin;
\.


--
-- TOC entry 3694 (class 0 OID 17036)
-- Dependencies: 254
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

COPY public.sessions (id, a_session) FROM stdin;
ccaf15a07783d52542704b543d8dc2b9	BQsDAAAAEBcLZ3JpenpseXNtaXQAAAARbG9nZ2VkaW5fdXNlcm5hbWUXFEZyYW5jaXMgR3Jpenps\neSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQoCMjUAAAALcGFnZV9sZW5ndGgIgAAAAA5s\nb2dnZWRpbl9hZG1pbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXD0ZyYW5jaXMgR3JpenpseQAA\nAA5sb2dnZWRpbl9naXZlbgoJbGlua3NeQysrAAAAD2N1cnJlbnRfc2VjdGlvbhcOKzYxNDgyIDE3\nNiAzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9n\nZ2VkaW5fZW1haWwKATAAAAAFZGVidWcIggAAAAhsb2dnZWRpbgoPcHNldWRvLXBhZ2VeYWxsAAAA\nDGN1cnJlbnRfcGFnZQogY2NhZjE1YTA3NzgzZDUyNTQyNzA0YjU0M2Q4ZGMyYjkAAAALX3Nlc3Np\nb25faWQIggAAAAtsb2dnZWRpbl9pZBcLZ3JpenpseXNtaXQAAAASbG9nZ2VkaW5fZ3JvdXBuYW1l\nCIMAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZA==\n
068675cd502b8327e5dd27ef507aa3c0	BQsDAAAAEAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKCWxpbmtzXkMrKwAAAA9jdXJyZW50\nX3NlY3Rpb24KATEAAAAFZGVidWcXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lCIEAAAALbG9n\nZ2VkaW5faWQIgQAAAA5sb2dnZWRpbl9hZG1pbhcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9n\nZ2VkaW5fZGlzcGxheV9uYW1lCIEAAAAIbG9nZ2VkaW4XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5s\nb2dnZWRpbl9lbWFpbBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCgIyNQAAAAtw\nYWdlX2xlbmd0aAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZRcMKzYxNDgyMTc2MzQz\nAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFwRT\nbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQogMDY4Njc1Y2Q1MDJiODMyN2U1ZGQyN2VmNTA3YWEzYzAA\nAAALX3Nlc3Npb25faWQ=\n
dd658768b14194054d895bb6e64d5294	BQsDAAAAEAoObGlua3NecG9zdGdyZXMAAAAPY3VycmVudF9zZWN0aW9uFxRGcmFuY2lzIEdyaXp6\nbHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXC2dyaXp6bHlzbWl0AAAAEWxvZ2dlZGlu\nX3VzZXJuYW1lFwtncml6emx5c21pdAAAABJsb2dnZWRpbl9ncm91cG5hbWUXD0ZyYW5jaXMgR3Jp\nenpseQAAAA5sb2dnZWRpbl9naXZlbgogZGQ2NTg3NjhiMTQxOTQwNTRkODk1YmI2ZTY0ZDUyOTQA\nAAALX3Nlc3Npb25faWQKAjI4AAAAC3BhZ2VfbGVuZ3RoFxJncml6emx5QHNtaXQuaWQuYXUAAAAO\nbG9nZ2VkaW5fZW1haWwIgwAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkChBwc2V1ZG8tcGFnZV5t\naXNjAAAADGN1cnJlbnRfcGFnZQiBAAAADmxvZ2dlZGluX2FkbWluCIIAAAAIbG9nZ2VkaW4IggAA\nAAtsb2dnZWRpbl9pZAoBMAAAAAVkZWJ1ZxcOKzYxNDgyIDE3NiAzNDMAAAAVbG9nZ2VkaW5fcGhv\nbmVfbnVtYmVyFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQ==\n
498b2cd3b6da04091d39c89f9190ecbe	BQsDAAAABQogNDk4YjJjZDNiNmRhMDQwOTFkMzljODlmOTE5MGVjYmUAAAALX3Nlc3Npb25faWQK\nD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKAjIzAAAAC3BhZ2VfbGVuZ3RoCglsaW5r\nc15DKysAAAAPY3VycmVudF9zZWN0aW9uCgExAAAABWRlYnVn\n
d54a395a7e3d035b2eab35e3e1e3eddd	BQsDAAAAEAogZDU0YTM5NWE3ZTNkMDM1YjJlYWIzNWUzZTFlM2VkZGQAAAALX3Nlc3Npb25faWQX\nDis2MTQ4Mi0xNzYtMzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcFZ3JpenoAAAASbG9nZ2Vk\naW5fZ3JvdXBuYW1lFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25h\nbWUXBWdyaXp6AAAAEWxvZ2dlZGluX3VzZXJuYW1lFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2Vk\naW5fZ2l2ZW4KD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UKAjI1AAAAC3BhZ2VfbGVu\nZ3RoCIQAAAAIbG9nZ2VkaW4IhAAAAAtsb2dnZWRpbl9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1p\nbHkXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbAiFAAAAFmxvZ2dlZGluX2dy\nb3Vwbm5hbWVfaWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24IgAAAAA5sb2dnZWRp\nbl9hZG1pbgoBMAAAAAVkZWJ1Zw==\n
88aa7cad761ab4c62664ab011059f338	BQsDAAAABQoKbGlua3NecmFrdQAAAA9jdXJyZW50X3NlY3Rpb24KD3BzZXVkby1wYWdlXmFsbAAA\nAAxjdXJyZW50X3BhZ2UKAjQxAAAAC3BhZ2VfbGVuZ3RoCiA4OGFhN2NhZDc2MWFiNGM2MjY2NGFi\nMDExMDU5ZjMzOAAAAAtfc2Vzc2lvbl9pZAoBMAAAAAVkZWJ1Zw==\n
a5d41456a83643e9445ceb8e1f8fe4d2	BQsDAAAABQoCMjgAAAALcGFnZV9sZW5ndGgKC2FsaWFzXnBlcmw2AAAAD2N1cnJlbnRfc2VjdGlv\nbgoQcHNldWRvLXBhZ2VebWlzYwAAAAxjdXJyZW50X3BhZ2UKATAAAAAFZGVidWcKIGE1ZDQxNDU2\nYTgzNjQzZTk0NDVjZWI4ZTFmOGZlNGQyAAAAC19zZXNzaW9uX2lk\n
e1b7ae146ea967338bc75bd9ecc4b4ae	BQsDAAAABQogZTFiN2FlMTQ2ZWE5NjczMzhiYzc1YmQ5ZWNjNGI0YWUAAAALX3Nlc3Npb25faWQK\nATEAAAAFZGVidWcKD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDmxpbmtzXnBvc3Rn\ncmVzAAAAD2N1cnJlbnRfc2VjdGlvbgoCMzkAAAALcGFnZV9sZW5ndGg=\n
da64773d703775653f795947988a29cd	BQsDAAAAEAiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXC2dyaXp6bHlzbWl0AAAAEmxvZ2dl\nZGluX2dyb3VwbmFtZQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZRcPRnJhbmNpcyBH\ncml6emx5AAAADmxvZ2dlZGluX2dpdmVuCIIAAAALbG9nZ2VkaW5faWQIgQAAAA5sb2dnZWRpbl9h\nZG1pbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKAjI1AAAAC3BhZ2VfbGVuZ3RoFxJncml6emx5\nQHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXDis2MTQ4MiAxNzYgMzQzAAAAFWxvZ2dlZGlu\nX3Bob25lX251bWJlcgoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoBMAAAAAVkZWJ1\nZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABFsb2dnZWRpbl91c2VybmFtZQogZGE2NDc3\nM2Q3MDM3NzU2NTNmNzk1OTQ3OTg4YTI5Y2QAAAALX3Nlc3Npb25faWQXFEZyYW5jaXMgR3Jpenps\neSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQ==\n
c8ab85ca784010747adb0aad5dcb6306	BQsDAAAAEAoBMAAAAAVkZWJ1ZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABJsb2dnZWRp\nbl9ncm91cG5hbWUKAjI1AAAAC3BhZ2VfbGVuZ3RoFwtncml6emx5c21pdAAAABFsb2dnZWRpbl91\nc2VybmFtZQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXBFNtaXQAAAAPbG9n\nZ2VkaW5fZmFtaWx5CIIAAAALbG9nZ2VkaW5faWQKIGM4YWI4NWNhNzg0MDEwNzQ3YWRiMGFhZDVk\nY2I2MzA2AAAAC19zZXNzaW9uX2lkCIEAAAAObG9nZ2VkaW5fYWRtaW4XD0ZyYW5jaXMgR3Jpenps\neQAAAA5sb2dnZWRpbl9naXZlbhcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWls\nFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFxRGcmFuY2lzIEdyaXp6bHkg\nU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWU=\n
1c8659df2843a2096c728067be7b9e01	BQsDAAAAEAoBMQAAAAVkZWJ1ZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABJsb2dnZWRp\nbl9ncm91cG5hbWUXC2dyaXp6bHlzbWl0AAAAEWxvZ2dlZGluX3VzZXJuYW1lCg9wc2V1ZG8tcGFn\nZV5hbGwAAAAMY3VycmVudF9wYWdlCgIyNQAAAAtwYWdlX2xlbmd0aBcEU21pdAAAAA9sb2dnZWRp\nbl9mYW1pbHkKDWxpbmtzXnNjcmlwdHMAAAAPY3VycmVudF9zZWN0aW9uCIMAAAAWbG9nZ2VkaW5f\nZ3JvdXBubmFtZV9pZAiCAAAAC2xvZ2dlZGluX2lkCiAxYzg2NTlkZjI4NDNhMjA5NmM3MjgwNjdi\nZTdiOWUwMQAAAAtfc2Vzc2lvbl9pZAiBAAAADmxvZ2dlZGluX2FkbWluFw9GcmFuY2lzIEdyaXp6\nbHkAAAAObG9nZ2VkaW5fZ2l2ZW4XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFp\nbBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lFw4rNjE0ODIg\nMTc2IDM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXI=\n
12d1122cc4eba147d70ae2097bb6e221	BQsDAAAAEAoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZQogMTJkMTEyMmNjNGViYTE0\nN2Q3MGFlMjA5N2JiNmUyMjEAAAALX3Nlc3Npb25faWQXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5s\nb2dnZWRpbl9lbWFpbBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgoBMAAA\nAAVkZWJ1ZxcLZ3JpenpseXNtaXQAAAARbG9nZ2VkaW5fdXNlcm5hbWUIggAAAAhsb2dnZWRpbgiC\nAAAAC2xvZ2dlZGluX2lkCIMAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZAoMYWxsX3NlY3Rpb25z\nAAAAD2N1cnJlbnRfc2VjdGlvbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXC2dyaXp6bHlzbWl0\nAAAAEmxvZ2dlZGluX2dyb3VwbmFtZRcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5f\nZGlzcGxheV9uYW1lFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4IgQAAAA5sb2dn\nZWRpbl9hZG1pbgoCMjUAAAALcGFnZV9sZW5ndGg=\n
6e4cf1784ea7d34e34c250c0d2ce16c4	BQsDAAAABAogNmU0Y2YxNzg0ZWE3ZDM0ZTM0YzI1MGMwZDJjZTE2YzQAAAALX3Nlc3Npb25faWQK\nDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24KD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJy\nZW50X3BhZ2UImQAAAAtwYWdlX2xlbmd0aA==\n
19840f4f0f3d35c3ca52eec9b27e7a7b	BQsDAAAABQoJcGFnZV53b3JrAAAADGN1cnJlbnRfcGFnZQogMTk4NDBmNGYwZjNkMzVjM2NhNTJl\nZWM5YjI3ZTdhN2IAAAALX3Nlc3Npb25faWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rp\nb24KATAAAAAFZGVidWcKAjI1AAAAC3BhZ2VfbGVuZ3Ro\n
0664e4fc9be30e951495830b43eede41	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlCiAwNjY0ZTRmYzliZTMwZTk1MTQ5NTgz\nMGI0M2VlZGU0MQAAAAtfc2Vzc2lvbl9pZA==\n
b5560ef6e1858c5f6e969a53b41aa19b	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3RoCiBiNTU2MGVmNmUxODU4YzVmNmU5Njlh\nNTNiNDFhYTE5YgAAAAtfc2Vzc2lvbl9pZA==\n
12ea2abf022eff07a7aeb5e57cf4144c	BQsDAAAAAQogMTJlYTJhYmYwMjJlZmYwN2E3YWViNWU1N2NmNDE0NGMAAAALX3Nlc3Npb25faWQ=\n
9fba6285a95a8768255e5857569ebc26	BQsDAAAAEAoBMAAAAAVkZWJ1ZwoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZRcSZ3Jp\nenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2Vk\naW5fcGhvbmVfbnVtYmVyCIEAAAALbG9nZ2VkaW5faWQIgQAAAA5sb2dnZWRpbl9hZG1pbhcEU21p\ndAAAAA9sb2dnZWRpbl9mYW1pbHkXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQoCMjUAAAAL\ncGFnZV9sZW5ndGgKIDlmYmE2Mjg1YTk1YTg3NjgyNTVlNTg1NzU2OWViYzI2AAAAC19zZXNzaW9u\nX2lkFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4IgQAAAAhsb2dnZWRpbhcFYWRt\naW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24X\nFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQiBAAAAFmxvZ2dl\nZGluX2dyb3Vwbm5hbWVfaWQ=\n
af95ad363ff81223976aff5482b2e59c	BQsDAAAAEAogYWY5NWFkMzYzZmY4MTIyMzk3NmFmZjU0ODJiMmU1OWMAAAALX3Nlc3Npb25faWQK\nATAAAAAFZGVidWcKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XEmdyaXp6bHlAc21p\ndC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFwwr\nNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFwRTbWl0AAAAD2xvZ2dlZGluX2Zh\nbWlseRcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUIgQAAAA5sb2dnZWRpbl9hZG1pbhcURnJh\nbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCIEAAAAIbG9nZ2VkaW4K\nAjIzAAAAC3BhZ2VfbGVuZ3RoFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4IgQAA\nAAtsb2dnZWRpbl9pZAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKD3BhZ2VeZ3JpenotcGFn\nZQAAAAxjdXJyZW50X3BhZ2U=\n
9a075a2b3a3d0a15d9b2461d1011f0de	BQsDAAAAEAoBMAAAAAVkZWJ1ZwoCMjUAAAALcGFnZV9sZW5ndGgIhAAAABZsb2dnZWRpbl9ncm91\ncG5uYW1lX2lkCiA5YTA3NWEyYjNhM2QwYTE1ZDliMjQ2MWQxMDExZjBkZQAAAAtfc2Vzc2lvbl9p\nZAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiBAAAADmxvZ2dlZGluX2FkbWluFw9G\ncmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4XFEZyYW5jaXMgR3JpenpseSBTbWl0AAAA\nFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQiDAAAACGxvZ2dlZGluCg9wYWdlXmdyaXp6LXBhZ2UAAAAM\nY3VycmVudF9wYWdlCIMAAAALbG9nZ2VkaW5faWQXB2dyaXp6bHkAAAASbG9nZ2VkaW5fZ3JvdXBu\nYW1lFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXB2dyaXp6bHkAAAARbG9n\nZ2VkaW5fdXNlcm5hbWUXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5FwwrNjE0ODIxNzYzNDMAAAAV\nbG9nZ2VkaW5fcGhvbmVfbnVtYmVy\n
7d7e000b95cab44c7a3b82813f3a2a1a	BQsDAAAAEAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcPRnJhbmNpcyBHcml6emx5\nAAAADmxvZ2dlZGluX2dpdmVuCg9wYWdlXmdyaXp6LXBhZ2UAAAAMY3VycmVudF9wYWdlCIEAAAAW\nbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5f\nZGlzcGxheV9uYW1lCiA3ZDdlMDAwYjk1Y2FiNDRjN2EzYjgyODEzZjNhMmExYQAAAAtfc2Vzc2lv\nbl9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1l\nFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwKATAAAAAFZGVidWcXBWFkbWlu\nAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQiBAAAACGxvZ2dlZGluCIEAAAALbG9nZ2VkaW5faWQIgQAA\nAA5sb2dnZWRpbl9hZG1pbgoCMjUAAAALcGFnZV9sZW5ndGgXDCs2MTQ4MjE3NjM0MwAAABVsb2dn\nZWRpbl9waG9uZV9udW1iZXI=\n
61eb1c60e9c2b04d8711440ad166d59a	BQsDAAAAEAogNjFlYjFjNjBlOWMyYjA0ZDg3MTE0NDBhZDE2NmQ1OWEAAAALX3Nlc3Npb25faWQX\nD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbhcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dl\nZGluX3Bob25lX251bWJlcgiBAAAAC2xvZ2dlZGluX2lkFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91\ncG5hbWUKATEAAAAFZGVidWcIgQAAAA5sb2dnZWRpbl9hZG1pbhcEU21pdAAAAA9sb2dnZWRpbl9m\nYW1pbHkKD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UXBWFkbWluAAAAEWxvZ2dlZGlu\nX3VzZXJuYW1lFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUI\ngQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0\naW9uCIEAAAAIbG9nZ2VkaW4KAjI1AAAAC3BhZ2VfbGVuZ3RoFxJncml6emx5QHNtaXQuaWQuYXUA\nAAAObG9nZ2VkaW5fZW1haWw=\n
6066c112263af0046fa9d0b23ca1b0b9	BQsDAAAAEAoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbhcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsFwVh\nZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUIgQAAAA5sb2dnZWRpbl9hZG1pbhcMKzYxNDgyMTc2\nMzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGlu\nX2dpdmVuCIEAAAALbG9nZ2VkaW5faWQXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGlu\nX2Rpc3BsYXlfbmFtZQiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQIgQAAAAhsb2dnZWRpbhcE\nU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKATEAAAAFZGVidWcKAjI1AAAAC3BhZ2VfbGVuZ3RoCiA2\nMDY2YzExMjI2M2FmMDA0NmZhOWQwYjIzY2ExYjBiOQAAAAtfc2Vzc2lvbl9pZBcFYWRtaW4AAAAR\nbG9nZ2VkaW5fdXNlcm5hbWU=\n
281b65c1f653ac310f978d5dfcc2554f	BQsDAAAAAQogMjgxYjY1YzFmNjUzYWMzMTBmOTc4ZDVkZmNjMjU1NGYAAAALX3Nlc3Npb25faWQ=\n
5a5965dc25adf870510ea76a4ba34053	BQsDAAAAEAoBMAAAAAVkZWJ1ZwoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZRcURnJh\nbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCIEAAAAObG9nZ2VkaW5f\nYWRtaW4IgQAAAAtsb2dnZWRpbl9pZBcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lCIEAAAAI\nbG9nZ2VkaW4IgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkCiA1YTU5NjVkYzI1YWRmODcwNTEw\nZWE3NmE0YmEzNDA1MwAAAAtfc2Vzc2lvbl9pZAoCMjUAAAALcGFnZV9sZW5ndGgXD0ZyYW5jaXMg\nR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbgoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlv\nbhcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5FxJn\ncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXDCs2MTQ4MjE3NjM0MwAAABVsb2dn\nZWRpbl9waG9uZV9udW1iZXI=\n
0cb349dfc2c740682c3cd98e56055331	BQsDAAAAEAiCAAAAC2xvZ2dlZGluX2lkFwtncml6emx5c21pdAAAABFsb2dnZWRpbl91c2VybmFt\nZQoBMAAAAAVkZWJ1ZwiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXDCs2MTQ4MjE3NjM0MwAA\nABVsb2dnZWRpbl9waG9uZV9udW1iZXIKAjI1AAAAC3BhZ2VfbGVuZ3RoFw9GcmFuY2lzIEdyaXp6\nbHkAAAAObG9nZ2VkaW5fZ2l2ZW4XBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5CiAwY2IzNDlkZmMy\nYzc0MDY4MmMzY2Q5OGU1NjA1NTMzMQAAAAtfc2Vzc2lvbl9pZAoPcGFnZV5ncml6ei1wYWdlAAAA\nDGN1cnJlbnRfcGFnZRcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9u\nYW1lCIIAAAAIbG9nZ2VkaW4KDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XEmdyaXp6\nbHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcLZ3JpenpseXNtaXQAAAASbG9nZ2VkaW5f\nZ3JvdXBuYW1lCIEAAAAObG9nZ2VkaW5fYWRtaW4=\n
4a0feba8987207c61a2d147f14760b98	BQsDAAAAEBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgoBMQAAAAVkZWJ1\nZwiBAAAACGxvZ2dlZGluFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5\nX25hbWUXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lFxJncml6emx5QHNtaXQuaWQuYXUAAAAO\nbG9nZ2VkaW5fZW1haWwXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5Cg9wYWdlXmdyaXp6LXBhZ2UA\nAAAMY3VycmVudF9wYWdlCIEAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZAogNGEwZmViYTg5ODcy\nMDdjNjFhMmQxNDdmMTQ3NjBiOTgAAAALX3Nlc3Npb25faWQIgQAAAAtsb2dnZWRpbl9pZAiBAAAA\nDmxvZ2dlZGluX2FkbWluCgIyNQAAAAtwYWdlX2xlbmd0aAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJl\nbnRfc2VjdGlvbhcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFw9GcmFuY2lzIEdyaXp6bHkA\nAAAObG9nZ2VkaW5fZ2l2ZW4=\n
410a11f132d95fbca331007fd2200003	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCiA0MTBhMTFmMTMyZDk1ZmJjYTMzMTAwN2ZkMjIwMDAwMwAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
36a8c8bf8649681fa3268461dab56f1b	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3Ro\nCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlCiAzNmE4YzhiZjg2NDk2ODFmYTMyNjg0\nNjFkYWI1NmYxYgAAAAtfc2Vzc2lvbl9pZA==\n
94d0ffea0e9be90c28a58ccb6025df9f	BQsDAAAABAogOTRkMGZmZWEwZTliZTkwYzI4YTU4Y2NiNjAyNWRmOWYAAAALX3Nlc3Npb25faWQI\nmQAAAAtwYWdlX2xlbmd0aAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
e8cd43abf3610c961868b5b12b36848f	BQsDAAAABAogZThjZDQzYWJmMzYxMGM5NjE4NjhiNWIxMmIzNjg0OGYAAAALX3Nlc3Npb25faWQK\nD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UImQAAAAtwYWdlX2xlbmd0aAoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
a80e7c908368932b05e9e81ce15a80eb	BQsDAAAAEBcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsCIEAAAAIbG9nZ2Vk\naW4KATAAAAAFZGVidWcIgQAAAA5sb2dnZWRpbl9hZG1pbgoPcGFnZV5ncml6ei1wYWdlAAAADGN1\ncnJlbnRfcGFnZQiBAAAAC2xvZ2dlZGluX2lkFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUK\nAjI1AAAAC3BhZ2VfbGVuZ3RoFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseRcFYWRtaW4AAAARbG9n\nZ2VkaW5fdXNlcm5hbWUXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlf\nbmFtZQoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcMKzYxNDgyMTc2MzQzAAAAFWxv\nZ2dlZGluX3Bob25lX251bWJlcgogYTgwZTdjOTA4MzY4OTMyYjA1ZTllODFjZTE1YTgwZWIAAAAL\nX3Nlc3Npb25faWQIgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkFw9GcmFuY2lzIEdyaXp6bHkA\nAAAObG9nZ2VkaW5fZ2l2ZW4=\n
adc9e85cbf3d61006397c37df46a1ca5	BQsDAAAAEAiBAAAACGxvZ2dlZGluFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9k\naXNwbGF5X25hbWUIgQAAAAtsb2dnZWRpbl9pZBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGlu\nX2dpdmVuFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUIgQAAAA5sb2dnZWRpbl9hZG1pbgog\nYWRjOWU4NWNiZjNkNjEwMDYzOTdjMzdkZjQ2YTFjYTUAAAALX3Nlc3Npb25faWQKDGFsbF9zZWN0\naW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9l\nbWFpbBcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKB3BhZ2Ved3AAAAAMY3VycmVudF9wYWdlCIEA\nAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25l\nX251bWJlchcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUKAjI1AAAAC3BhZ2VfbGVuZ3RoCgEw\nAAAABWRlYnVn\n
1948849643bb4f5551af637515dfe428	BQsDAAAAEAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcEU21pdAAAAA9sb2dnZWRp\nbl9mYW1pbHkKIDE5NDg4NDk2NDNiYjRmNTU1MWFmNjM3NTE1ZGZlNDI4AAAAC19zZXNzaW9uX2lk\nCgEwAAAABWRlYnVnFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXBWFkbWlu\nAAAAEWxvZ2dlZGluX3VzZXJuYW1lCIEAAAALbG9nZ2VkaW5faWQIgQAAAA5sb2dnZWRpbl9hZG1p\nbhcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCIEAAAAIbG9nZ2VkaW4XDCs2MTQ4\nMjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIKAjI3AAAAC3BhZ2VfbGVuZ3RoFxRGcmFu\nY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXBWFkbWluAAAAEmxvZ2dl\nZGluX2dyb3VwbmFtZQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZQiBAAAAFmxvZ2dl\nZGluX2dyb3Vwbm5hbWVfaWQ=\n
fb8828697ad2300b169998303e86a2ee	BQsDAAAAEAiBAAAADmxvZ2dlZGluX2FkbWluFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dn\nZWRpbl9kaXNwbGF5X25hbWUIgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkFwwrNjE0ODIxNzYz\nNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyCIEAAAAIbG9nZ2VkaW4KIGZiODgyODY5N2FkMjMw\nMGIxNjk5OTgzMDNlODZhMmVlAAAAC19zZXNzaW9uX2lkFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91\ncG5hbWUKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24KAjI3AAAAC3BhZ2VfbGVuZ3Ro\nFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFn\nZRcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCIEAAAALbG9nZ2VkaW5faWQXEmdy\naXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbAoBMAAAAAVkZWJ1ZxcFYWRtaW4AAAAR\nbG9nZ2VkaW5fdXNlcm5hbWU=\n
465e8b0ae6a18c9d67f17dbe62b1caa9	JHt9
bf10977d4a85778e19fc7d7d3db04e98	JHt9
d888bfa0675f5fe3d0082cc845cd9367	BQsDAAAAEBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcURnJhbmNpcyBH\ncml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCgEwAAAABWRlYnVnCIEAAAAWbG9n\nZ2VkaW5fZ3JvdXBubmFtZV9pZAiBAAAACGxvZ2dlZGluFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9n\nZ2VkaW5fZ2l2ZW4KAjI3AAAAC3BhZ2VfbGVuZ3RoFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFt\nZRcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9n\nZ2VkaW5fZW1haWwKD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDGxpbmtzXm9sZG9j\ncwAAAA9jdXJyZW50X3NlY3Rpb24IgQAAAA5sb2dnZWRpbl9hZG1pbgiBAAAAC2xvZ2dlZGluX2lk\nCiBkODg4YmZhMDY3NWY1ZmUzZDAwODJjYzg0NWNkOTM2NwAAAAtfc2Vzc2lvbl9pZBcEU21pdAAA\nAA9sb2dnZWRpbl9mYW1pbHk=\n
7e4f3f0ac7235ffe5cd45d7a8c13ca7f	JHt9
c3cfc73004b65dfcae9f4ab5f7f79c1f	BQsDAAAAEBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgoCMjUAAAALcGFn\nZV9sZW5ndGgXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcFYWRtaW4AAAAS\nbG9nZ2VkaW5fZ3JvdXBuYW1lCIEAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZAiBAAAACGxvZ2dl\nZGluCIEAAAALbG9nZ2VkaW5faWQXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rp\nc3BsYXlfbmFtZRcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCg9wYWdlXmdyaXp6\nLXBhZ2UAAAAMY3VycmVudF9wYWdlCiBjM2NmYzczMDA0YjY1ZGZjYWU5ZjRhYjVmN2Y3OWMxZgAA\nAAtfc2Vzc2lvbl9pZAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcEU21pdAAAAA9s\nb2dnZWRpbl9mYW1pbHkXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lCIEAAAAObG9nZ2VkaW5f\nYWRtaW4KATAAAAAFZGVidWc=\n
830b2d737727b7c345f0a35b7cf406a4	JChteSBTZXNzaW9uOjpQb3N0Z3Jlczo6U3RyT3JBcnJheU9mU3RyICUgPSA6YmFtYmFtKCJwZWJi\r\nbGVzIiksIDpiYXJuZXkoImJldHR5IiksIDpmcmVkKCJ3aWxtYSIpKQ==
e580dad1d13d98d30399b62afa9bc541	JHt9
f1e2b529a515f6ae2f990caabbe971e8	JChteSBTZXNzaW9uOjpQb3N0Z3Jlczo6U3RyT3JBcnJheU9mU3RyICUgPSA6YmFtYmFtKCJwZWJi\r\nbGVzIiksIDpiYXJuZXkoImJldHR5IiksIDpmcmVkKCJ3aWxtYSIpKQ==
283f06f247b5b64b96091b781f93ff75	JHt9
402862d44033c50b49ed132c95e4b29c	BQsDAAAAEAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZRcURnJhbmNpcyBHcml6emx5\nIFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2Vk\naW5fZ2l2ZW4XBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lCIEAAAALbG9nZ2VkaW5faWQXDCs2\nMTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIXBWFkbWluAAAAEmxvZ2dlZGluX2dy\nb3VwbmFtZRcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsCiA0MDI4NjJkNDQw\nMzNjNTBiNDllZDEzMmM5NWU0YjI5YwAAAAtfc2Vzc2lvbl9pZAiBAAAADmxvZ2dlZGluX2FkbWlu\nCIEAAAAIbG9nZ2VkaW4KDGxpbmtzXm9sZG9jcwAAAA9jdXJyZW50X3NlY3Rpb24KAjI1AAAAC3Bh\nZ2VfbGVuZ3RoCIEAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZBcEU21pdAAAAA9sb2dnZWRpbl9m\nYW1pbHkKATAAAAAFZGVidWc=\n
edc60b8d3e6cc30488469a166ec5aa06	BQsDAAAAEAogZWRjNjBiOGQzZTZjYzMwNDg4NDY5YTE2NmVjNWFhMDYAAAALX3Nlc3Npb25faWQK\nDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJu\nYW1lCgIyNQAAAAtwYWdlX2xlbmd0aAiBAAAADmxvZ2dlZGluX2FkbWluFwVhZG1pbgAAABJsb2dn\nZWRpbl9ncm91cG5hbWUKD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UIgQAAABZsb2dn\nZWRpbl9ncm91cG5uYW1lX2lkCgEwAAAABWRlYnVnFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5f\ncGhvbmVfbnVtYmVyFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4XFEZyYW5jaXMg\nR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQiBAAAACGxvZ2dlZGluCIEAAAAL\nbG9nZ2VkaW5faWQXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcEU21pdAAA\nAA9sb2dnZWRpbl9mYW1pbHk=\n
559cdef8bfa30ee5b179110c7f728ea7	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogNTU5Y2RlZjhiZmEzMGVl\nNWIxNzkxMTBjN2Y3MjhlYTcAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
9a6adf6f07e4791cce2fa371e297b8e3	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3Ro\nCiA5YTZhZGY2ZjA3ZTQ3OTFjY2UyZmEzNzFlMjk3YjhlMwAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
b5ba7f0bed7a406d8f8cd616a1897387	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCiBiNWJhN2YwYmVkN2E0MDZkOGY4Y2Q2MTZhMTg5NzM4\nNwAAAAtfc2Vzc2lvbl9pZAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
e11f5bb29dfafb907a199519083164f5	BQsDAAAABAogZTExZjViYjI5ZGZhZmI5MDdhMTk5NTE5MDgzMTY0ZjUAAAALX3Nlc3Npb25faWQI\nmQAAAAtwYWdlX2xlbmd0aAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
3d452baeb6744727faa93fdadb34bf51	BQsDAAAABAogM2Q0NTJiYWViNjc0NDcyN2ZhYTkzZmRhZGIzNGJmNTEAAAALX3Nlc3Npb25faWQK\nD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UImQAAAAtwYWdlX2xlbmd0aAoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
8cf6046d07701fbdae0487080e37cff2	BQsDAAAABAogOGNmNjA0NmQwNzcwMWZiZGFlMDQ4NzA4MGUzN2NmZjIAAAALX3Nlc3Npb25faWQK\nDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
48af0172517b03da4ae64706c70371a2	BQsDAAAAEAoCMjUAAAALcGFnZV9sZW5ndGgIgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkFxJn\ncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwIgQAAAAhsb2dnZWRpbgoPcGFnZV5n\ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZRcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2Vk\naW5fZGlzcGxheV9uYW1lFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUIgQAAAA5sb2dnZWRp\nbl9hZG1pbhcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUXDCs2MTQ4MjE3NjM0MwAAABVsb2dn\nZWRpbl9waG9uZV9udW1iZXIKATAAAAAFZGVidWcIgQAAAAtsb2dnZWRpbl9pZBcPRnJhbmNpcyBH\ncml6emx5AAAADmxvZ2dlZGluX2dpdmVuFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQogNDhhZjAx\nNzI1MTdiMDNkYTRhZTY0NzA2YzcwMzcxYTIAAAALX3Nlc3Npb25faWQKDGFsbF9zZWN0aW9ucwAA\nAA9jdXJyZW50X3NlY3Rpb24=\n
61ed694834acf5769c9059a3a6d7b055	BQsDAAAAEBcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsChBwYWdlXlByb2dy\nYW1taW5nAAAADGN1cnJlbnRfcGFnZQiBAAAACGxvZ2dlZGluFw9GcmFuY2lzIEdyaXp6bHkAAAAO\nbG9nZ2VkaW5fZ2l2ZW4XBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQoCMjUAAAALcGFnZV9s\nZW5ndGgIgQAAAAtsb2dnZWRpbl9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKDGFsbF9zZWN0\naW9ucwAAAA9jdXJyZW50X3NlY3Rpb24KIDYxZWQ2OTQ4MzRhY2Y1NzY5YzkwNTlhM2E2ZDdiMDU1\nAAAAC19zZXNzaW9uX2lkCgEwAAAABWRlYnVnCIEAAAAObG9nZ2VkaW5fYWRtaW4XDCs2MTQ4MjE3\nNjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIIgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lk\nFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXBWFkbWluAAAA\nEWxvZ2dlZGluX3VzZXJuYW1l\n
f2c0094f2de43e68a640077929bea67f	BQsDAAAAEAoCMjUAAAALcGFnZV9sZW5ndGgXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9u\nZV9udW1iZXIKATAAAAAFZGVidWcKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XBFNt\naXQAAAAPbG9nZ2VkaW5fZmFtaWx5CiBmMmMwMDk0ZjJkZTQzZTY4YTY0MDA3NzkyOWJlYTY3ZgAA\nAAtfc2Vzc2lvbl9pZBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuFwtncml6emx5\nc21pdAAAABFsb2dnZWRpbl91c2VybmFtZQiCAAAACGxvZ2dlZGluFxRGcmFuY2lzIEdyaXp6bHkg\nU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXC2dyaXp6bHlzbWl0AAAAEmxvZ2dlZGluX2dy\nb3VwbmFtZQiCAAAAC2xvZ2dlZGluX2lkCg9wYWdlXmdyaXp6LXBhZ2UAAAAMY3VycmVudF9wYWdl\nFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwIgQAAAA5sb2dnZWRpbl9hZG1p\nbgiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQ=\n
b867ee8910964dd90f288a34ea8ae46d	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdl\nCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCiBiODY3ZWU4OTEwOTY0ZGQ5MGYyODhh\nMzRlYThhZTQ2ZAAAAAtfc2Vzc2lvbl9pZA==\n
73226fe505b8cdf185d61ea06171ec28	BQsDAAAAEBcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsFwwrNjE0ODIxNzYz\nNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZRcF\nYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lCgIyNQAAAAtwYWdlX2xlbmd0aAiBAAAACGxvZ2dl\nZGluCIEAAAALbG9nZ2VkaW5faWQIgQAAAA5sb2dnZWRpbl9hZG1pbgoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgoBMAAAAAVkZWJ1ZxcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGlu\nX2dpdmVuCg9wYWdlXmdyaXp6LXBhZ2UAAAAMY3VycmVudF9wYWdlCiA3MzIyNmZlNTA1YjhjZGYx\nODVkNjFlYTA2MTcxZWMyOAAAAAtfc2Vzc2lvbl9pZAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVf\naWQXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5FxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dn\nZWRpbl9kaXNwbGF5X25hbWU=\n
a20d6ddaadf6932f2d51c6cc23822339	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdl\nCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCiBhMjBkNmRkYWFkZjY5MzJmMmQ1MWM2\nY2MyMzgyMjMzOQAAAAtfc2Vzc2lvbl9pZA==\n
adf10a09628511e321144c2fe429e8d6	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQogYWRmMTBhMDk2Mjg1MTFl\nMzIxMTQ0YzJmZTQyOWU4ZDYAAAALX3Nlc3Npb25faWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aA==\n
e1cf420d31c725fae5ed30a02542b98a	BQsDAAAAEAiBAAAAC2xvZ2dlZGluX2lkFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRp\nbl9kaXNwbGF5X25hbWUKIGUxY2Y0MjBkMzFjNzI1ZmFlNWVkMzBhMDI1NDJiOThhAAAAC19zZXNz\naW9uX2lkFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUXBFNtaXQAAAAPbG9nZ2VkaW5fZmFt\naWx5CgEwAAAABWRlYnVnCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uFwwrNjE0ODIx\nNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyCIEAAAAIbG9nZ2VkaW4IgQAAABZsb2dnZWRp\nbl9ncm91cG5uYW1lX2lkFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4KD3BhZ2Ve\nZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lCgIy\nNQAAAAtwYWdlX2xlbmd0aBcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsCIEA\nAAAObG9nZ2VkaW5fYWRtaW4=\n
cd3362c65c78948ff60814d01b77bc26	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgogY2QzMzYyYzY1Yzc4OTQ4ZmY2MDgxNGQwMWI3N2JjMjYAAAALX3Nl\nc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aA==\n
0ce7a2cef1fb3a37a018f4c372c0c1ce	BQsDAAAAEAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiBAAAAFmxvZ2dlZGluX2dy\nb3Vwbm5hbWVfaWQXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbAogMGNlN2Ey\nY2VmMWZiM2EzN2EwMThmNGMzNzJjMGMxY2UAAAALX3Nlc3Npb25faWQXBWFkbWluAAAAEWxvZ2dl\nZGluX3VzZXJuYW1lCIEAAAAIbG9nZ2VkaW4XFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dl\nZGluX2Rpc3BsYXlfbmFtZQoBMAAAAAVkZWJ1ZxcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGlu\nX2dpdmVuFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseRcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBu\nYW1lFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyCgIyNQAAAAtwYWdlX2xl\nbmd0aAiBAAAAC2xvZ2dlZGluX2lkCg9wYWdlXmdyaXp6LXBhZ2UAAAAMY3VycmVudF9wYWdlCIEA\nAAAObG9nZ2VkaW5fYWRtaW4=\n
ed72ffa27c3bbf2fb0b5def99d39cadc	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRvLXBhZ2VeYWxs\nAAAADGN1cnJlbnRfcGFnZQiZAAAAC3BhZ2VfbGVuZ3RoCiBlZDcyZmZhMjdjM2JiZjJmYjBiNWRl\nZjk5ZDM5Y2FkYwAAAAtfc2Vzc2lvbl9pZA==\n
cde769d8fb50599fcd9d413ff830869a	BQsDAAAAEAogY2RlNzY5ZDhmYjUwNTk5ZmNkOWQ0MTNmZjgzMDg2OWEAAAALX3Nlc3Npb25faWQK\nAjI1AAAAC3BhZ2VfbGVuZ3RoCIEAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZBcMKzYxNDgyMTc2\nMzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2Vj\ndGlvbhcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lCIEAAAALbG9nZ2VkaW5faWQXBWFkbWlu\nAAAAEWxvZ2dlZGluX3VzZXJuYW1lCg9wYWdlXmdyaXp6LXBhZ2UAAAAMY3VycmVudF9wYWdlCIEA\nAAAIbG9nZ2VkaW4XD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbhcEU21pdAAAAA9s\nb2dnZWRpbl9mYW1pbHkXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcURnJh\nbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCIEAAAAObG9nZ2VkaW5f\nYWRtaW4KATAAAAAFZGVidWc=\n
ab60518af235989aa00bf835d7c28f94	BQsDAAAAEBcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsCgxhbGxfc2VjdGlv\nbnMAAAAPY3VycmVudF9zZWN0aW9uFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4X\nBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZRcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9n\nZ2VkaW5fZGlzcGxheV9uYW1lFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZRcEU21pdAAAAA9s\nb2dnZWRpbl9mYW1pbHkKAjI1AAAAC3BhZ2VfbGVuZ3RoCiBhYjYwNTE4YWYyMzU5ODlhYTAwYmY4\nMzVkN2MyOGY5NAAAAAtfc2Vzc2lvbl9pZAiBAAAADmxvZ2dlZGluX2FkbWluCIEAAAAIbG9nZ2Vk\naW4XDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIIgQAAAAtsb2dnZWRpbl9p\nZAoBMAAAAAVkZWJ1ZwoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZQiBAAAAFmxvZ2dl\nZGluX2dyb3Vwbm5hbWVfaWQ=\n
11026c0f052ba6d20fa5c692007e4fe8	BQsDAAAAEAogMTEwMjZjMGYwNTJiYTZkMjBmYTVjNjkyMDA3ZTRmZTgAAAALX3Nlc3Npb25faWQK\nATAAAAAFZGVidWcKAjI1AAAAC3BhZ2VfbGVuZ3RoFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseRcM\nKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgiBAAAAC2xvZ2dlZGluX2lkChBw\nYWdlXlByb2dyYW1taW5nAAAADGN1cnJlbnRfcGFnZRcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dl\nZGluX2dpdmVuFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUIgQAAABZsb2dnZWRpbl9ncm91\ncG5uYW1lX2lkCIEAAAAObG9nZ2VkaW5fYWRtaW4XBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1l\nFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwKDGFsbF9zZWN0aW9ucwAAAA9j\ndXJyZW50X3NlY3Rpb24IgQAAAAhsb2dnZWRpbhcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9n\nZ2VkaW5fZGlzcGxheV9uYW1l\n
d35b09c84040ed222b1fdfb1948a255d	BQsDAAAAAQogZDM1YjA5Yzg0MDQwZWQyMjJiMWZkZmIxOTQ4YTI1NWQAAAALX3Nlc3Npb25faWQ=\n
333cab635ba65743a3374745593c7ba4	BQsDAAAAEBcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUXBFNtaXQAAAAPbG9nZ2VkaW5fZmFt\naWx5CIEAAAAIbG9nZ2VkaW4KAjI1AAAAC3BhZ2VfbGVuZ3RoCIEAAAAWbG9nZ2VkaW5fZ3JvdXBu\nbmFtZV9pZBcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lCgEwAAAABWRlYnVnCgxhbGxfc2Vj\ndGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCIEAAAALbG9nZ2VkaW5faWQIgQAAAA5sb2dnZWRpbl9h\nZG1pbhcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCg9wYWdlXmdyaXp6LXBhZ2UA\nAAAMY3VycmVudF9wYWdlCiAzMzNjYWI2MzViYTY1NzQzYTMzNzQ3NDU1OTNjN2JhNAAAAAtfc2Vz\nc2lvbl9pZBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lFwwr\nNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFxJncml6emx5QHNtaXQuaWQuYXUA\nAAAObG9nZ2VkaW5fZW1haWw=\n
e15e14968a9b51e871525421058e3489	BQsDAAAAAQogZTE1ZTE0OTY4YTliNTFlODcxNTI1NDIxMDU4ZTM0ODkAAAALX3Nlc3Npb25faWQ=\n
1374636422d50f4c9320600a3bc5e431	BQsDAAAAEAiBAAAACGxvZ2dlZGluFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZRcSZ3Jpenps\neUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQiB\nAAAADmxvZ2dlZGluX2FkbWluFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4KIDEz\nNzQ2MzY0MjJkNTBmNGM5MzIwNjAwYTNiYzVlNDMxAAAAC19zZXNzaW9uX2lkCIEAAAALbG9nZ2Vk\naW5faWQKATAAAAAFZGVidWcKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XDCs2MTQ4\nMjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIKEHBhZ2VeUHJvZ3JhbW1pbmcAAAAMY3Vy\ncmVudF9wYWdlFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUKAjI1AAAAC3BhZ2VfbGVuZ3Ro\nFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUIgQAAABZsb2dn\nZWRpbl9ncm91cG5uYW1lX2lk\n
62fa907b3ec00fbad9629cfd49328cec	BQsDAAAAAQogNjJmYTkwN2IzZWMwMGZiYWQ5NjI5Y2ZkNDkzMjhjZWMAAAALX3Nlc3Npb25faWQ=\n
98e8656a0a92b6248b2ae8005c33de63	BQsDAAAAAQogOThlODY1NmEwYTkyYjYyNDhiMmFlODAwNWMzM2RlNjMAAAALX3Nlc3Npb25faWQ=\n
6f4d9be7bca3562cd33c1ef071158662	BQsDAAAAAQogNmY0ZDliZTdiY2EzNTYyY2QzM2MxZWYwNzExNTg2NjIAAAALX3Nlc3Npb25faWQ=\n
042c9658f09d57034957416be0d750dd	BQsDAAAAAQogMDQyYzk2NThmMDlkNTcwMzQ5NTc0MTZiZTBkNzUwZGQAAAALX3Nlc3Npb25faWQ=\n
5b87c2ea116eb7d044df9041f3a0814f	BQsDAAAAAQogNWI4N2MyZWExMTZlYjdkMDQ0ZGY5MDQxZjNhMDgxNGYAAAALX3Nlc3Npb25faWQ=\n
55cccca857169e43d16e429fa7ba8167	BQsDAAAAAQogNTVjY2NjYTg1NzE2OWU0M2QxNmU0MjlmYTdiYTgxNjcAAAALX3Nlc3Npb25faWQ=\n
ff8a4416f115ecabf8f5fd61dd8434dc	BQsDAAAAEBcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUXBWFkbWluAAAAEmxvZ2dlZGluX2dy\nb3VwbmFtZRcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5s\nb2dnZWRpbl9lbWFpbAoCMjUAAAALcGFnZV9sZW5ndGgKIGZmOGE0NDE2ZjExNWVjYWJmOGY1ZmQ2\nMWRkODQzNGRjAAAAC19zZXNzaW9uX2lkCIEAAAALbG9nZ2VkaW5faWQKATAAAAAFZGVidWcKDGFs\nbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxv\nZ2dlZGluX2Rpc3BsYXlfbmFtZRcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJl\ncgiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQIgQAAAA5sb2dnZWRpbl9hZG1pbhcPRnJhbmNp\ncyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCg9wYWdlXmdyaXp6LXBhZ2UAAAAMY3VycmVudF9w\nYWdlCIEAAAAIbG9nZ2VkaW4=\n
43fc07bce8667398224321e8bf73d1b9	BQsDAAAAAQogNDNmYzA3YmNlODY2NzM5ODIyNDMyMWU4YmY3M2QxYjkAAAALX3Nlc3Npb25faWQ=\n
13847c38f20f260a19bfccf031722dd3	BQsDAAAAAQogMTM4NDdjMzhmMjBmMjYwYTE5YmZjY2YwMzE3MjJkZDMAAAALX3Nlc3Npb25faWQ=\n
9e6fe8b0cd8db997d8f035b702d89392	BQsDAAAAAQogOWU2ZmU4YjBjZDhkYjk5N2Q4ZjAzNWI3MDJkODkzOTIAAAALX3Nlc3Npb25faWQ=\n
5f0600907a14e60b85880d6aad273c14	BQsDAAAAAQogNWYwNjAwOTA3YTE0ZTYwYjg1ODgwZDZhYWQyNzNjMTQAAAALX3Nlc3Npb25faWQ=\n
deb1d1772589ebd8b5ef73b60bdfa8b7	BQsDAAAAAQogZGViMWQxNzcyNTg5ZWJkOGI1ZWY3M2I2MGJkZmE4YjcAAAALX3Nlc3Npb25faWQ=\n
f8ea9801b8dc20bdcdeda9de4c883af1	BQsDAAAAAQogZjhlYTk4MDFiOGRjMjBiZGNkZWRhOWRlNGM4ODNhZjEAAAALX3Nlc3Npb25faWQ=\n
7ce7726e538e5ebcbaf437bb4b815f0d	BQsDAAAAAQogN2NlNzcyNmU1MzhlNWViY2JhZjQzN2JiNGI4MTVmMGQAAAALX3Nlc3Npb25faWQ=\n
cc32da69e23acffb70376985d9e21368	BQsDAAAAAQogY2MzMmRhNjllMjNhY2ZmYjcwMzc2OTg1ZDllMjEzNjgAAAALX3Nlc3Npb25faWQ=\n
344f85c7b36518668c01808b3da3b834	BQsDAAAAAQogMzQ0Zjg1YzdiMzY1MTg2NjhjMDE4MDhiM2RhM2I4MzQAAAALX3Nlc3Npb25faWQ=\n
b31b72ba7b1edecea97cc97b9dae98dc	BQsDAAAAAQogYjMxYjcyYmE3YjFlZGVjZWE5N2NjOTdiOWRhZTk4ZGMAAAALX3Nlc3Npb25faWQ=\n
310b8a2b015718f3905eab905149ceb8	BQsDAAAAAQogMzEwYjhhMmIwMTU3MThmMzkwNWVhYjkwNTE0OWNlYjgAAAALX3Nlc3Npb25faWQ=\n
27fcefa0c3efad7c5e3d59480dcb1396	BQsDAAAAAQogMjdmY2VmYTBjM2VmYWQ3YzVlM2Q1OTQ4MGRjYjEzOTYAAAALX3Nlc3Npb25faWQ=\n
fdcd2aab2f38165d1a54f4593d3892cb	BQsDAAAAAQogZmRjZDJhYWIyZjM4MTY1ZDFhNTRmNDU5M2QzODkyY2IAAAALX3Nlc3Npb25faWQ=\n
4574cb459ebfd34f0927e8ef3fcf5421	BQsDAAAAAQogNDU3NGNiNDU5ZWJmZDM0ZjA5MjdlOGVmM2ZjZjU0MjEAAAALX3Nlc3Npb25faWQ=\n
9d7c49bda508004de0e591122f0e6994	BQsDAAAAAQogOWQ3YzQ5YmRhNTA4MDA0ZGUwZTU5MTEyMmYwZTY5OTQAAAALX3Nlc3Npb25faWQ=\n
88d3de4c3375482cf2cc6fab338fd510	BQsDAAAAAQogODhkM2RlNGMzMzc1NDgyY2YyY2M2ZmFiMzM4ZmQ1MTAAAAALX3Nlc3Npb25faWQ=\n
680a63ad6f2a7534ad87daa184782770	BQsDAAAAAQogNjgwYTYzYWQ2ZjJhNzUzNGFkODdkYWExODQ3ODI3NzAAAAALX3Nlc3Npb25faWQ=\n
8f3d4b3b4f85bdb51b47541cdc6b8d4f	BQsDAAAAEAogOGYzZDRiM2I0Zjg1YmRiNTFiNDc1NDFjZGM2YjhkNGYAAAALX3Nlc3Npb25faWQK\nDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJu\nYW1lFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQiBAAAACGxvZ2dlZGluCIEAAAALbG9nZ2VkaW5f\naWQXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQiBAAAADmxv\nZ2dlZGluX2FkbWluCg9wYWdlXmdyaXp6LXBhZ2UAAAAMY3VycmVudF9wYWdlFwVhZG1pbgAAABJs\nb2dnZWRpbl9ncm91cG5hbWUXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcM\nKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcPRnJhbmNpcyBHcml6emx5AAAA\nDmxvZ2dlZGluX2dpdmVuCgEwAAAABWRlYnVnCgIyNQAAAAtwYWdlX2xlbmd0aAiBAAAAFmxvZ2dl\nZGluX2dyb3Vwbm5hbWVfaWQ=\n
0a8b74f4bfbec382f539e07eb43ae5d8	BQsDAAAAAQogMGE4Yjc0ZjRiZmJlYzM4MmY1MzllMDdlYjQzYWU1ZDgAAAALX3Nlc3Npb25faWQ=\n
f6d71f45d7ab661f2b52cefa16f1eefb	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQogZjZkNzFmNDVkN2FiNjYx\nZjJiNTJjZWZhMTZmMWVlZmIAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
5ea66d2977d58fcad14a2c630a3d91a8	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdl\nCiA1ZWE2NmQyOTc3ZDU4ZmNhZDE0YTJjNjMwYTNkOTFhOAAAAAtfc2Vzc2lvbl9pZAoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
4799e50876a4ed7605807f41ca4c7f45	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQogNDc5OWU1MDg3NmE0ZWQ3\nNjA1ODA3ZjQxY2E0YzdmNDUAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
94eed80d7fd951654e7810da41da6f5a	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3Ro\nCiA5NGVlZDgwZDdmZDk1MTY1NGU3ODEwZGE0MWRhNmY1YQAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
29ebc7981ce13d6eb72e9a6fcf38088e	BQsZAAAAABEIgQIAAAAObG9nZ2VkaW5fYWRtaW4XBFNtaXQCAAAAD2xvZ2dlZGluX2ZhbWlseRcB\nMAIAAAAPbG9nZ2VkaW5fZXNjYXBlCIMCAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQIggIAAAAL\nbG9nZ2VkaW5faWQXD0ZyYW5jaXMgR3JpenpseQIAAAAObG9nZ2VkaW5fZ2l2ZW4XDCs2MTQ4MjE3\nNjM0MwIAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyBBEGUmVnZXhwIAAbXEEoPyg/eyAkc3ViLT4o\nJF8pIH0pLip8KVx6AAIAAAAXbG9nZ2VkaW5fbW9iaWxlX3BhdHRlcm4KIDI5ZWJjNzk4MWNlMTNk\nNmViNzJlOWE2ZmNmMzgwODhlAAAAAAtfc2Vzc2lvbl9pZAiCAgAAAAhsb2dnZWRpbhcSZ3Jpenps\neUBzbWl0LmlkLmF1AgAAAA5sb2dnZWRpbl9lbWFpbAQSACAAG1xBKD8oP3sgJHN1Yi0+KCRfKSB9\nKS4qfClcegACAAAAGWxvZ2dlZGluX2xhbmRsaW5lX3BhdHRlcm4XFEZyYW5jaXMgR3JpenpseSBT\nbWl0AgAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXAi0gAgAAAA5sb2dnZWRpbl9wdW5jdBcLZ3Jp\nenpseXNtaXQCAAAAEmxvZ2dlZGluX2dyb3VwbmFtZRcDKzYxAgAAAA9sb2dnZWRpbl9wcmVmaXgX\nC2dyaXp6bHlzbWl0AgAAABFsb2dnZWRpbl91c2VybmFtZQ==\n
7ade030afe158212eb1039a03957abf7	BQsDAAAABAogN2FkZTAzMGFmZTE1ODIxMmViMTAzOWEwMzk1N2FiZjcAAAALX3Nlc3Npb25faWQI\nmQAAAAtwYWdlX2xlbmd0aAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
03be237a6e90d47fa58a44672a79f9a7	BQsDAAAAEBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCIEAAAALbG9nZ2VkaW5f\naWQKAjI1AAAAC3BhZ2VfbGVuZ3RoCIEAAAAIbG9nZ2VkaW4KD3BhZ2VeZ3JpenotcGFnZQAAAAxj\ndXJyZW50X3BhZ2UXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIXBWFkbWlu\nAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKDGFsbF9z\nZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24KIDAzYmUyMzdhNmU5MGQ0N2ZhNThhNDQ2NzJhNzlm\nOWE3AAAAC19zZXNzaW9uX2lkCgEwAAAABWRlYnVnFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVs\nb2dnZWRpbl9kaXNwbGF5X25hbWUXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lCIEAAAAObG9n\nZ2VkaW5fYWRtaW4XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcEU21pdAAA\nAA9sb2dnZWRpbl9mYW1pbHk=\n
c41cde5a2b40798cb9a6a0ae9c11913e	BQsDAAAAEBcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsCg9wYWdlXmdyaXp6\nLXBhZ2UAAAAMY3VycmVudF9wYWdlFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4K\nAjI1AAAAC3BhZ2VfbGVuZ3RoCIEAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZBcEU21pdAAAAA9s\nb2dnZWRpbl9mYW1pbHkXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIIgQAA\nAAhsb2dnZWRpbgogYzQxY2RlNWEyYjQwNzk4Y2I5YTZhMGFlOWMxMTkxM2UAAAALX3Nlc3Npb25f\naWQXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQiBAAAADmxv\nZ2dlZGluX2FkbWluCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCgEwAAAABWRlYnVn\nFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZRcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1l\nCIEAAAALbG9nZ2VkaW5faWQ=\n
b7f13277ee98ba22e919abf7bedac84a	BQsDAAAAEAoBMAAAAAVkZWJ1ZwiCAAAAC2xvZ2dlZGluX2lkCiBiN2YxMzI3N2VlOThiYTIyZTkx\nOWFiZjdiZWRhYzg0YQAAAAtfc2Vzc2lvbl9pZAiCAAAACGxvZ2dlZGluCIEAAAAObG9nZ2VkaW5f\nYWRtaW4IgwAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAA\nABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXC2dyaXp6bHlzbWl0AAAAEmxvZ2dlZGluX2dyb3VwbmFt\nZRcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuFxJncml6emx5QHNtaXQuaWQuYXUA\nAAAObG9nZ2VkaW5fZW1haWwKD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UXC2dyaXp6\nbHlzbWl0AAAAEWxvZ2dlZGluX3VzZXJuYW1lCgIyNQAAAAtwYWdlX2xlbmd0aBcEU21pdAAAAA9s\nb2dnZWRpbl9mYW1pbHkXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIKDGFs\nbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24=\n
f6d1e88a2cdd62cb1c57f14ee451a22f	BQsDAAAAAQogZjZkMWU4OGEyY2RkNjJjYjFjNTdmMTRlZTQ1MWEyMmYAAAALX3Nlc3Npb25faWQ=\n
d3a455066c727738dc3b8df0743d368f	BQsDAAAAAQogZDNhNDU1MDY2YzcyNzczOGRjM2I4ZGYwNzQzZDM2OGYAAAALX3Nlc3Npb25faWQ=\n
4e5a5151eedc089f19a3ef4ad8e8ac16	BQsDAAAAEBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCIEA\nAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlv\nbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9u\nZV9udW1iZXIXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQoCMjUAAAALcGFnZV9sZW5ndGgI\ngQAAAA5sb2dnZWRpbl9hZG1pbhcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWls\nFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRf\ncGFnZQiBAAAACGxvZ2dlZGluCIEAAAALbG9nZ2VkaW5faWQKATAAAAAFZGVidWcXD0ZyYW5jaXMg\nR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbgogNGU1YTUxNTFlZWRjMDg5ZjE5YTNlZjRhZDhlOGFj\nMTYAAAALX3Nlc3Npb25faWQ=\n
379e9a5f26a631c64ffedf9944ba7e02	BQsDAAAAEBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCg9wYWdlXmdyaXp6LXBh\nZ2UAAAAMY3VycmVudF9wYWdlFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwI\ngQAAAA5sb2dnZWRpbl9hZG1pbhcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJl\ncgiBAAAAC2xvZ2dlZGluX2lkCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uFwVhZG1p\nbgAAABFsb2dnZWRpbl91c2VybmFtZQogMzc5ZTlhNWYyNmE2MzFjNjRmZmVkZjk5NDRiYTdlMDIA\nAAALX3Nlc3Npb25faWQKATAAAAAFZGVidWcXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5FwVhZG1p\nbgAAABJsb2dnZWRpbl9ncm91cG5hbWUIgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkCIEAAAAI\nbG9nZ2VkaW4KAjI1AAAAC3BhZ2VfbGVuZ3RoFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dn\nZWRpbl9kaXNwbGF5X25hbWU=\n
0764862870fbfaaec867746c19d0d11a	BQsDAAAAEBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgoCMjUAAAALcGFn\nZV9sZW5ndGgIgQAAAAtsb2dnZWRpbl9pZBcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUKIDA3\nNjQ4NjI4NzBmYmZhYWVjODY3NzQ2YzE5ZDBkMTFhAAAAC19zZXNzaW9uX2lkFw9GcmFuY2lzIEdy\naXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4IgQAAAAhsb2dnZWRpbhcEU21pdAAAAA9sb2dnZWRpbl9m\nYW1pbHkXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQoBMAAAAAVkZWJ1ZwiBAAAADmxvZ2dl\nZGluX2FkbWluCIEAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZBcSZ3JpenpseUBzbWl0LmlkLmF1\nAAAADmxvZ2dlZGluX2VtYWlsFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNw\nbGF5X25hbWUKD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UKDGFsbF9zZWN0aW9ucwAA\nAA9jdXJyZW50X3NlY3Rpb24=\n
d31ffd4fc5dc27156192d2eb2f8627b1	BQsDAAAAEBcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkIgQAAAA5sb2dnZWRpbl9hZG1pbgoCMjUA\nAAALcGFnZV9sZW5ndGgIgQAAAAtsb2dnZWRpbl9pZAiBAAAACGxvZ2dlZGluCIEAAAAWbG9nZ2Vk\naW5fZ3JvdXBubmFtZV9pZAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcSZ3Jpenps\neUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5f\ncGhvbmVfbnVtYmVyFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4XBWFkbWluAAAA\nEmxvZ2dlZGluX2dyb3VwbmFtZQoBMAAAAAVkZWJ1ZwoQcGFnZV5Qcm9ncmFtbWluZwAAAAxjdXJy\nZW50X3BhZ2UXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQog\nZDMxZmZkNGZjNWRjMjcxNTYxOTJkMmViMmY4NjI3YjEAAAALX3Nlc3Npb25faWQXBWFkbWluAAAA\nEWxvZ2dlZGluX3VzZXJuYW1l\n
ad06df4cd73964c6c3e44d16fe712af7	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlCiBhZDA2ZGY0Y2Q3Mzk2NGM2YzNlNDRk\nMTZmZTcxMmFmNwAAAAtfc2Vzc2lvbl9pZA==\n
8f105391582431fe220169d97658b3fa	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3Ro\nCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlCiA4ZjEwNTM5MTU4MjQzMWZlMjIwMTY5\nZDk3NjU4YjNmYQAAAAtfc2Vzc2lvbl9pZA==\n
bfbefe1d6fabff284ae7b7f51758f04a	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgogYmZiZWZlMWQ2ZmFiZmYyODRhZTdiN2Y1MTc1OGYwNGEAAAALX3Nl\nc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aA==\n
6cf537bd0397de7343c88c0a23c5d572	BQsDAAAAEBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCglw\nYWdlXndvcmsAAAAMY3VycmVudF9wYWdlCIEAAAAIbG9nZ2VkaW4XD0ZyYW5jaXMgR3JpenpseQAA\nAA5sb2dnZWRpbl9naXZlbhcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsFwVh\nZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZQoBMQAAAAVkZWJ1ZxcEU21pdAAAAA9sb2dnZWRpbl9m\nYW1pbHkXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQiBAAAAC2xvZ2dlZGluX2lkCiA2Y2Y1\nMzdiZDAzOTdkZTczNDNjODhjMGEyM2M1ZDU3MgAAAAtfc2Vzc2lvbl9pZAoMYWxsX3NlY3Rpb25z\nAAAAD2N1cnJlbnRfc2VjdGlvbgoCMjUAAAALcGFnZV9sZW5ndGgIgQAAABZsb2dnZWRpbl9ncm91\ncG5uYW1lX2lkCIEAAAAObG9nZ2VkaW5fYWRtaW4XDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9w\naG9uZV9udW1iZXI=\n
743b6e5c2fd6ecc4ac99df34a877fb6c	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCiA3NDNiNmU1YzJmZDZlY2M0YWM5OWRmMzRhODc3ZmI2\nYwAAAAtfc2Vzc2lvbl9pZAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
561ffd88de34c92eaa0d8227a9ad156a	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdl\nCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCiA1NjFmZmQ4OGRlMzRjOTJlYWEwZDgy\nMjdhOWFkMTU2YQAAAAtfc2Vzc2lvbl9pZA==\n
31c6ed5387d82192d293dc2e14645e36	BQsDAAAAEAoBMAAAAAVkZWJ1ZwiBAAAADmxvZ2dlZGluX2FkbWluFxJncml6emx5QHNtaXQuaWQu\nYXUAAAAObG9nZ2VkaW5fZW1haWwXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZRcFYWRtaW4A\nAAARbG9nZ2VkaW5fdXNlcm5hbWUIgQAAAAtsb2dnZWRpbl9pZAoCMjUAAAALcGFnZV9sZW5ndGgI\ngQAAAAhsb2dnZWRpbgiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKDGFsbF9zZWN0aW9ucwAA\nAA9jdXJyZW50X3NlY3Rpb24XD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbgogMzFj\nNmVkNTM4N2Q4MjE5MmQyOTNkYzJlMTQ2NDVlMzYAAAALX3Nlc3Npb25faWQXFEZyYW5jaXMgR3Jp\nenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZRcEU21pdAAAAA9sb2dnZWRpbl9mYW1p\nbHkKD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UXDCs2MTQ4MjE3NjM0MwAAABVsb2dn\nZWRpbl9waG9uZV9udW1iZXI=\n
ad0a2e8bfe71d4c3f6fe32e3a2b03637	BQsDAAAAEAoCMjUAAAALcGFnZV9sZW5ndGgKD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3Bh\nZ2UIgQAAAAhsb2dnZWRpbgiBAAAADmxvZ2dlZGluX2FkbWluCIEAAAAWbG9nZ2VkaW5fZ3JvdXBu\nbmFtZV9pZBcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFwVhZG1pbgAAABFsb2dnZWRpbl91\nc2VybmFtZRcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lFwRT\nbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQogYWQwYTJlOGJmZTcxZDRjM2Y2ZmUzMmUzYTJiMDM2MzcA\nAAALX3Nlc3Npb25faWQXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIIgQAA\nAAtsb2dnZWRpbl9pZAoBMAAAAAVkZWJ1ZxcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dp\ndmVuFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwKDGFsbF9zZWN0aW9ucwAA\nAA9jdXJyZW50X3NlY3Rpb24=\n
3b4c5aea84fc0cf94fb5e019f9c66095	BQsDAAAAEBcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsFwVhZG1pbgAAABJs\nb2dnZWRpbl9ncm91cG5hbWUKAjI1AAAAC3BhZ2VfbGVuZ3RoFxRGcmFuY2lzIEdyaXp6bHkgU21p\ndAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9n\naXZlbgiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24KCXBhZ2Ved29yawAAAAxjdXJyZW50X3BhZ2UXDCs2MTQ4MjE3NjM0MwAAABVsb2dn\nZWRpbl9waG9uZV9udW1iZXIIgQAAAAtsb2dnZWRpbl9pZAiBAAAADmxvZ2dlZGluX2FkbWluCiAz\nYjRjNWFlYTg0ZmMwY2Y5NGZiNWUwMTlmOWM2NjA5NQAAAAtfc2Vzc2lvbl9pZAiBAAAACGxvZ2dl\nZGluFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZRcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkK\nATAAAAAFZGVidWc=\n
f5a859f00804aea00b6d5143f8176f09	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRvLXBhZ2VeYWxs\nAAAADGN1cnJlbnRfcGFnZQiZAAAAC3BhZ2VfbGVuZ3RoCiBmNWE4NTlmMDA4MDRhZWEwMGI2ZDUx\nNDNmODE3NmYwOQAAAAtfc2Vzc2lvbl9pZA==\n
b72bfcc419f479d1e44948d350fb2ee6	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgogYjcyYmZjYzQxOWY0NzlkMWU0NDk0OGQzNTBmYjJlZTYAAAALX3Nl\nc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aA==\n
3af03195d660b6354ec103cb4e334f80	BQsDAAAAEAiBAAAACGxvZ2dlZGluFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4X\nDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIXBFNtaXQAAAAPbG9nZ2VkaW5f\nZmFtaWx5CiAzYWYwMzE5NWQ2NjBiNjM1NGVjMTAzY2I0ZTMzNGY4MAAAAAtfc2Vzc2lvbl9pZAiB\nAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQoB\nMAAAAAVkZWJ1ZwoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcURnJhbmNpcyBHcml6\nemx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCIEAAAAObG9nZ2VkaW5fYWRtaW4KCXBh\nZ2Ved29yawAAAAxjdXJyZW50X3BhZ2UXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lFxJncml6\nemx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwIgQAAAAtsb2dnZWRpbl9pZAoCMjUAAAAL\ncGFnZV9sZW5ndGg=\n
099b0acd6d999be4e2424b4fc7b04502	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgogMDk5YjBhY2Q2ZDk5OWJlNGUyNDI0YjRmYzdiMDQ1MDIAAAALX3Nl\nc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aA==\n
1e61bb04906cd19186514a3977170ea2	BQsDAAAAEBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCIEA\nAAAIbG9nZ2VkaW4KCXBhZ2Ved29yawAAAAxjdXJyZW50X3BhZ2UIgQAAAA5sb2dnZWRpbl9hZG1p\nbgiBAAAAC2xvZ2dlZGluX2lkCgEwAAAABWRlYnVnFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseRcM\nKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgoMYWxsX3NlY3Rpb25zAAAAD2N1\ncnJlbnRfc2VjdGlvbhcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCiAxZTYxYmIw\nNDkwNmNkMTkxODY1MTRhMzk3NzE3MGVhMgAAAAtfc2Vzc2lvbl9pZBcFYWRtaW4AAAARbG9nZ2Vk\naW5fdXNlcm5hbWUXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcFYWRtaW4A\nAAASbG9nZ2VkaW5fZ3JvdXBuYW1lCgIyNQAAAAtwYWdlX2xlbmd0aAiBAAAAFmxvZ2dlZGluX2dy\nb3Vwbm5hbWVfaWQ=\n
f71cc33a368c1a06bb21a793aad11207	BQsDAAAAEAiBAAAAC2xvZ2dlZGluX2lkFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRp\nbl9kaXNwbGF5X25hbWUKIGY3MWNjMzNhMzY4YzFhMDZiYjIxYTc5M2FhZDExMjA3AAAAC19zZXNz\naW9uX2lkCIEAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1p\nbHkXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIXEmdyaXp6bHlAc21pdC5p\nZC5hdQAAAA5sb2dnZWRpbl9lbWFpbAiBAAAACGxvZ2dlZGluFw9GcmFuY2lzIEdyaXp6bHkAAAAO\nbG9nZ2VkaW5fZ2l2ZW4KAjI1AAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVu\ndF9zZWN0aW9uFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZQiBAAAADmxvZ2dlZGluX2FkbWlu\nCglwYWdlXndvcmsAAAAMY3VycmVudF9wYWdlFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUK\nATAAAAAFZGVidWc=\n
fb24b499fb1c74f6fa110624f68d83d2	BQsDAAAABAogZmIyNGI0OTlmYjFjNzRmNmZhMTEwNjI0ZjY4ZDgzZDIAAAALX3Nlc3Npb25faWQK\nDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24KD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJy\nZW50X3BhZ2UImQAAAAtwYWdlX2xlbmd0aA==\n
c56cb68ba8372c6851b4eedbe829d8a7	BQsDAAAAEAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKIGM1NmNiNjhiYTgzNzJjNjg1MWI0\nZWVkYmU4MjlkOGE3AAAAC19zZXNzaW9uX2lkFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dn\nZWRpbl9kaXNwbGF5X25hbWUIgQAAAAhsb2dnZWRpbhcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dl\nZGluX2dpdmVuFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQoMYWxsX3NlY3Rpb25zAAAAD2N1cnJl\nbnRfc2VjdGlvbhcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUXEmdyaXp6bHlAc21pdC5pZC5h\ndQAAAA5sb2dnZWRpbl9lbWFpbAiBAAAADmxvZ2dlZGluX2FkbWluCJkAAAALcGFnZV9sZW5ndGgK\nATAAAAAFZGVidWcIgQAAAAtsb2dnZWRpbl9pZBcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1l\nCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2Vk\naW5fcGhvbmVfbnVtYmVy\n
aacd96bf8f5179e24132f008d2e2ea22	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCiBhYWNkOTZiZjhmNTE3OWUyNDEzMmYwMDhkMmUyZWEyMgAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
c8c064b48da308a55de7e8ddda2b1448	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCiBjOGMwNjRiNDhkYTMwOGE1NWRlN2U4ZGRkYTJiMTQ0OAAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
824b53f28c3d61c9829006c793089aca	BQsDAAAAEAiZAAAAC3BhZ2VfbGVuZ3RoCIEAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZAogODI0\nYjUzZjI4YzNkNjFjOTgyOTAwNmM3OTMwODlhY2EAAAALX3Nlc3Npb25faWQXBFNtaXQAAAAPbG9n\nZ2VkaW5fZmFtaWx5CIEAAAAIbG9nZ2VkaW4XD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9n\naXZlbhcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcSZ3JpenpseUBzbWl0\nLmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsCgEwAAAABWRlYnVnFwVhZG1pbgAAABJsb2dnZWRpbl9n\ncm91cG5hbWUIgQAAAAtsb2dnZWRpbl9pZBcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUKD3Bz\nZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxv\nZ2dlZGluX2Rpc3BsYXlfbmFtZQoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiBAAAA\nDmxvZ2dlZGluX2FkbWlu\n
348fcc21de5355f3e163d13a36ee5237	BQsDAAAAEAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJy\nZW50X3NlY3Rpb24XFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFt\nZRcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUKIDM0OGZjYzIxZGU1MzU1ZjNlMTYzZDEzYTM2\nZWU1MjM3AAAAC19zZXNzaW9uX2lkFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVt\nYmVyCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlCIEAAAALbG9nZ2VkaW5faWQXEmdy\naXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbAiBAAAACGxvZ2dlZGluFw9GcmFuY2lz\nIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4XBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQoB\nMAAAAAVkZWJ1ZwiZAAAAC3BhZ2VfbGVuZ3RoCIEAAAAObG9nZ2VkaW5fYWRtaW4XBFNtaXQAAAAP\nbG9nZ2VkaW5fZmFtaWx5\n
e056ebbc93613ee6e3799f570483b2e5	BQsDAAAAEAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoCMjUAAAALcGFnZV9sZW5n\ndGgIgQAAAAhsb2dnZWRpbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXEmdyaXp6bHlAc21pdC5p\nZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVu\nCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlFwVhZG1pbgAAABFsb2dnZWRpbl91c2Vy\nbmFtZRcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgiBAAAAFmxvZ2dlZGlu\nX2dyb3Vwbm5hbWVfaWQXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlf\nbmFtZQiBAAAAC2xvZ2dlZGluX2lkFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUKIGUwNTZl\nYmJjOTM2MTNlZTZlMzc5OWY1NzA0ODNiMmU1AAAAC19zZXNzaW9uX2lkCgEwAAAABWRlYnVnCIEA\nAAAObG9nZ2VkaW5fYWRtaW4=\n
84fd4f4f194e1957995417860350db7c	BQsDAAAAEAiZAAAAC3BhZ2VfbGVuZ3RoFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2\nZW4XBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZRcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAV\nbG9nZ2VkaW5fZGlzcGxheV9uYW1lCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uFxJn\ncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwIgQAAAAtsb2dnZWRpbl9pZBcFYWRt\naW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5FwwrNjE0ODIx\nNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyCiA4NGZkNGY0ZjE5NGUxOTU3OTk1NDE3ODYw\nMzUwZGI3YwAAAAtfc2Vzc2lvbl9pZAiBAAAADmxvZ2dlZGluX2FkbWluCgEwAAAABWRlYnVnCIEA\nAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFn\nZQiBAAAACGxvZ2dlZGlu\n
6be6e07a119b24d65413dad98e81579c	BQsDAAAAEBcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lCglwYWdlXndvcmsAAAAMY3VycmVu\ndF9wYWdlCIEAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1p\nbHkKIDZiZTZlMDdhMTE5YjI0ZDY1NDEzZGFkOThlODE1NzljAAAAC19zZXNzaW9uX2lkFw9GcmFu\nY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4KATAAAAAFZGVidWcIgQAAAA5sb2dnZWRpbl9h\nZG1pbgiBAAAAC2xvZ2dlZGluX2lkCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uFxRG\ncmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUKAjI1AAAAC3BhZ2Vf\nbGVuZ3RoFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZQiBAAAACGxvZ2dlZGluFwwrNjE0ODIx\nNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9n\nZ2VkaW5fZW1haWw=\n
768e86d16a34690ddc5b93f4f41b928f	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCiA3NjhlODZkMTZhMzQ2OTBkZGM1YjkzZjRmNDFiOTI4\nZgAAAAtfc2Vzc2lvbl9pZAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
b197a95b45d03571c9f09f5f25d160c0	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdl\nCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCiBiMTk3YTk1YjQ1ZDAzNTcxYzlmMDlm\nNWYyNWQxNjBjMAAAAAtfc2Vzc2lvbl9pZA==\n
503a47b9f6b402a51aba084407060649	BQsDAAAAEAiBAAAAC2xvZ2dlZGluX2lkCgEwAAAABWRlYnVnCIEAAAAIbG9nZ2VkaW4KDGFsbF9z\nZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9u\nZV9udW1iZXIXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcURnJhbmNpcyBH\ncml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCIEAAAAObG9nZ2VkaW5fYWRtaW4X\nBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZRcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGlu\nX2dpdmVuCIEAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1p\nbHkKIDUwM2E0N2I5ZjZiNDAyYTUxYWJhMDg0NDA3MDYwNjQ5AAAAC19zZXNzaW9uX2lkFwVhZG1p\nbgAAABFsb2dnZWRpbl91c2VybmFtZQoJcGFnZV53b3JrAAAADGN1cnJlbnRfcGFnZQoCMjUAAAAL\ncGFnZV9sZW5ndGg=\n
7ffd629722fea49dc3d931ce722c94a0	BQsDAAAAEBcLZ3JpenpseXNtaXQAAAARbG9nZ2VkaW5fdXNlcm5hbWUXFEZyYW5jaXMgR3Jpenps\neSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZRcLZ3JpenpseXNtaXQAAAASbG9nZ2VkaW5f\nZ3JvdXBuYW1lCIEAAAAObG9nZ2VkaW5fYWRtaW4XDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9w\naG9uZV9udW1iZXIKIDdmZmQ2Mjk3MjJmZWE0OWRjM2Q5MzFjZTcyMmM5NGEwAAAAC19zZXNzaW9u\nX2lkCgEwAAAABWRlYnVnCgIyNQAAAAtwYWdlX2xlbmd0aAiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5h\nbWVfaWQXD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbhcSZ3JpenpseUBzbWl0Lmlk\nLmF1AAAADmxvZ2dlZGluX2VtYWlsCIIAAAAIbG9nZ2VkaW4KDGFsbF9zZWN0aW9ucwAAAA9jdXJy\nZW50X3NlY3Rpb24XBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5CIIAAAALbG9nZ2VkaW5faWQKCXBh\nZ2Ved29yawAAAAxjdXJyZW50X3BhZ2U=\n
c9425220f464e5c52cbf4c53c0ef3498	BQsDAAAAEAoCMjUAAAALcGFnZV9sZW5ndGgXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9u\nZV9udW1iZXIXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbAoBMAAAAAVkZWJ1\nZwiBAAAACGxvZ2dlZGluFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4KEHBhZ2Ve\nUHJvZ3JhbW1pbmcAAAAMY3VycmVudF9wYWdlCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0\naW9uFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQogYzk0MjUyMjBmNDY0ZTVjNTJjYmY0YzUzYzBl\nZjM0OTgAAAALX3Nlc3Npb25faWQIgQAAAAtsb2dnZWRpbl9pZAiBAAAAFmxvZ2dlZGluX2dyb3Vw\nbm5hbWVfaWQIgQAAAA5sb2dnZWRpbl9hZG1pbhcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9n\nZ2VkaW5fZGlzcGxheV9uYW1lFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZRcFYWRtaW4AAAAS\nbG9nZ2VkaW5fZ3JvdXBuYW1l\n
1835b4336bae6222197506cc10c7377c	BQsDAAAAEAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXDCs2MTQ4MjE3NjM0MwAAABVsb2dn\nZWRpbl9waG9uZV9udW1iZXIXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3Bs\nYXlfbmFtZQoBMAAAAAVkZWJ1ZwoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQiBAAAA\nC2xvZ2dlZGluX2lkFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUXBFNtaXQAAAAPbG9nZ2Vk\naW5fZmFtaWx5Fw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4KDGFsbF9zZWN0aW9u\ncwAAAA9jdXJyZW50X3NlY3Rpb24IgQAAAAhsb2dnZWRpbgogMTgzNWI0MzM2YmFlNjIyMjE5NzUw\nNmNjMTBjNzM3N2MAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAiBAAAADmxvZ2dlZGlu\nX2FkbWluFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZRcSZ3JpenpseUBzbWl0LmlkLmF1AAAA\nDmxvZ2dlZGluX2VtYWls\n
1d21dee319041898a8150b42c009020d	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogMWQyMWRlZTMxOTA0MTg5\nOGE4MTUwYjQyYzAwOTAyMGQAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
96c196b146bb71d044698728a5b0252d	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCiA5NmMxOTZiMTQ2YmI3MWQwNDQ2OTg3MjhhNWIwMjUyZAAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
8b540c6b0fc8f6620c9781882f10ae3f	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3Ro\nCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlCiA4YjU0MGM2YjBmYzhmNjYyMGM5Nzgx\nODgyZjEwYWUzZgAAAAtfc2Vzc2lvbl9pZA==\n
957004c3ba918ee63c11ca27c1515f78	BQsDAAAAEAiBAAAACGxvZ2dlZGluFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQiBAAAAFmxvZ2dl\nZGluX2dyb3Vwbm5hbWVfaWQXD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbgoJcGFn\nZV53b3JrAAAADGN1cnJlbnRfcGFnZRcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2Vt\nYWlsCgIyNQAAAAtwYWdlX2xlbmd0aAoBMAAAAAVkZWJ1ZxcFYWRtaW4AAAARbG9nZ2VkaW5fdXNl\ncm5hbWUIgQAAAAtsb2dnZWRpbl9pZAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcM\nKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgiBAAAADmxvZ2dlZGluX2FkbWlu\nFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxv\nZ2dlZGluX2Rpc3BsYXlfbmFtZQogOTU3MDA0YzNiYTkxOGVlNjNjMTFjYTI3YzE1MTVmNzgAAAAL\nX3Nlc3Npb25faWQ=\n
ba5d53dd9be86e465be3e39d0d3c8d34	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogYmE1ZDUzZGQ5YmU4NmU0\nNjViZTNlMzlkMGQzYzhkMzQAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
8588853070c4fb54596554629c0f65d4	BQsDAAAAEBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgiDAAAAFmxvZ2dl\nZGluX2dyb3Vwbm5hbWVfaWQKEHBhZ2VeUHJvZ3JhbW1pbmcAAAAMY3VycmVudF9wYWdlCIEAAAAO\nbG9nZ2VkaW5fYWRtaW4KDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24IggAAAAhsb2dn\nZWRpbhcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lFxJncml6\nemx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5\nFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4KIDg1ODg4NTMwNzBjNGZiNTQ1OTY1\nNTQ2MjljMGY2NWQ0AAAAC19zZXNzaW9uX2lkCgIyNQAAAAtwYWdlX2xlbmd0aAiCAAAAC2xvZ2dl\nZGluX2lkFwtncml6emx5c21pdAAAABJsb2dnZWRpbl9ncm91cG5hbWUXC2dyaXp6bHlzbWl0AAAA\nEWxvZ2dlZGluX3VzZXJuYW1lCgEwAAAABWRlYnVn\n
5b41cd9b83e54cca45b9c2200ca89d46	BQsDAAAAEBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgiBAAAACGxvZ2dl\nZGluFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXFEZyYW5jaXMgR3Jpenps\neSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZRcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5h\nbWUKAjI1AAAAC3BhZ2VfbGVuZ3RoCgEwAAAABWRlYnVnCIEAAAAObG9nZ2VkaW5fYWRtaW4KDGFs\nbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24IgQAAAAtsb2dnZWRpbl9pZAiBAAAAFmxvZ2dl\nZGluX2dyb3Vwbm5hbWVfaWQXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQoQcGFnZV5Qcm9n\ncmFtbWluZwAAAAxjdXJyZW50X3BhZ2UXD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9naXZl\nbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKIDViNDFjZDliODNlNTRjY2E0NWI5YzIyMDBjYTg5\nZDQ2AAAAC19zZXNzaW9uX2lk\n
323f0163266f8e7103d16d0bbaade6d9	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCiAzMjNmMDE2MzI2NmY4ZTcxMDNkMTZkMGJiYWFkZTZk\nOQAAAAtfc2Vzc2lvbl9pZAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
3686f504343600b6d909c07056519752	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogMzY4NmY1MDQzNDM2MDBi\nNmQ5MDljMDcwNTY1MTk3NTIAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
105979152be7af8e3c83df7847d964be	BQsDAAAAEAiBAAAACGxvZ2dlZGluFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9k\naXNwbGF5X25hbWUXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lFwVhZG1pbgAAABJsb2dnZWRp\nbl9ncm91cG5hbWUXD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbhcEU21pdAAAAA9s\nb2dnZWRpbl9mYW1pbHkKCnBhZ2VeRnVubnkAAAAMY3VycmVudF9wYWdlCIEAAAAWbG9nZ2VkaW5f\nZ3JvdXBubmFtZV9pZAogMTA1OTc5MTUyYmU3YWY4ZTNjODNkZjc4NDdkOTY0YmUAAAALX3Nlc3Np\nb25faWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XEmdyaXp6bHlAc21pdC5pZC5h\ndQAAAA5sb2dnZWRpbl9lbWFpbAoBMAAAAAVkZWJ1ZwoCMjUAAAALcGFnZV9sZW5ndGgXDCs2MTQ4\nMjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIIgQAAAAtsb2dnZWRpbl9pZAiBAAAADmxv\nZ2dlZGluX2FkbWlu\n
12c3f77b2f9867ec7258455afc78bc56	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCiAxMmMzZjc3YjJmOTg2N2VjNzI1ODQ1NWFmYzc4YmM1NgAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
da8cf3aaebcb144c51385e4fd19a8844	BQsDAAAAEBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCgEwAAAABWRlYnVnCIEA\nAAAIbG9nZ2VkaW4KAjI1AAAAC3BhZ2VfbGVuZ3RoCIEAAAAObG9nZ2VkaW5fYWRtaW4IgQAAAAts\nb2dnZWRpbl9pZBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcFYWRtaW4A\nAAASbG9nZ2VkaW5fZ3JvdXBuYW1lCglwYWdlXndvcmsAAAAMY3VycmVudF9wYWdlFxJncml6emx5\nQHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwKIGRhOGNmM2FhZWJjYjE0NGM1MTM4NWU0ZmQx\nOWE4ODQ0AAAAC19zZXNzaW9uX2lkFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9k\naXNwbGF5X25hbWUXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lFwRTbWl0AAAAD2xvZ2dlZGlu\nX2ZhbWlseQoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiBAAAAFmxvZ2dlZGluX2dy\nb3Vwbm5hbWVfaWQ=\n
8ac9be8a583d368a1ba62b1364738504	BQsDAAAABQoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogOGFjOWJlOGE1ODNkMzY4\nYTFiYTYyYjEzNjQ3Mzg1MDQAAAALX3Nlc3Npb25faWQKD3BhZ2Ved29yay1zdHVmZgAAAAxjdXJy\nZW50X3BhZ2UKAjI1AAAAC3BhZ2VfbGVuZ3RoCgEwAAAABWRlYnVn\n
4d570b1d0180071e8cb26b700339ded2	BQsDAAAABAogNGQ1NzBiMWQwMTgwMDcxZThjYjI2YjcwMDMzOWRlZDIAAAALX3Nlc3Npb25faWQK\nD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aA==\n
12469251480ec97c2c49418db002c9c8	BQsDAAAABAogMTI0NjkyNTE0ODBlYzk3YzJjNDk0MThkYjAwMmM5YzgAAAALX3Nlc3Npb25faWQK\nDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
e4998dca63a81458ca46e2b4375ce50c	BQsDAAAABAogZTQ5OThkY2E2M2E4MTQ1OGNhNDZlMmI0Mzc1Y2U1MGMAAAALX3Nlc3Npb25faWQK\nDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
aab25790805c0d90a384213c7aa642cb	BQsDAAAABAogYWFiMjU3OTA4MDVjMGQ5MGEzODQyMTNjN2FhNjQyY2IAAAALX3Nlc3Npb25faWQI\nmQAAAAtwYWdlX2xlbmd0aAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
83100a5a4a59df93e0c63d58f4fd9b75	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogODMxMDBhNWE0YTU5ZGY5\nM2UwYzYzZDU4ZjRmZDliNzUAAAALX3Nlc3Npb25faWQKD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJy\nZW50X3BhZ2UImQAAAAtwYWdlX2xlbmd0aA==\n
10c9e128705441d7872be0fd3c81cf8d	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogMTBjOWUxMjg3MDU0NDFk\nNzg3MmJlMGZkM2M4MWNmOGQAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
0432d704a35540056cc63f2e5e3399c9	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogMDQzMmQ3MDRhMzU1NDAw\nNTZjYzYzZjJlNWUzMzk5YzkAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
e41bd1c1cdb6a487839eb4aa3ce61ca1	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCiBlNDFiZDFjMWNkYjZhNDg3ODM5ZWI0YWEzY2U2MWNhMQAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
99e43d63d63d621262b3fb08b1b2af18	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3Ro\nCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlCiA5OWU0M2Q2M2Q2M2Q2MjEyNjJiM2Zi\nMDhiMWIyYWYxOAAAAAtfc2Vzc2lvbl9pZA==\n
0d7dcce423ed3f37e36de001ef9f5cd2	BQsDAAAABAogMGQ3ZGNjZTQyM2VkM2YzN2UzNmRlMDAxZWY5ZjVjZDIAAAALX3Nlc3Npb25faWQK\nD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UImQAAAAtwYWdlX2xlbmd0aAoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
95823d1d70704abbec5efec687b8b119	BQsDAAAABAogOTU4MjNkMWQ3MDcwNGFiYmVjNWVmZWM2ODdiOGIxMTkAAAALX3Nlc3Npb25faWQK\nD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aA==\n
e94ac5e6be0b3f602eacabc847f84168	BQsDAAAABAogZTk0YWM1ZTZiZTBiM2Y2MDJlYWNhYmM4NDdmODQxNjgAAAALX3Nlc3Npb25faWQK\nD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UImQAAAAtwYWdlX2xlbmd0aAoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
debbe4d14bfc81c2528e2e86355fe794	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRvLXBhZ2VeYWxs\nAAAADGN1cnJlbnRfcGFnZQogZGViYmU0ZDE0YmZjODFjMjUyOGUyZTg2MzU1ZmU3OTQAAAALX3Nl\nc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aA==\n
742ba7c299fc71d02214a2508d95daaf	BQsDAAAAEAiBAAAACGxvZ2dlZGluFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4X\nBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5CglwYWdlXndvcmsAAAAMY3VycmVudF9wYWdlCIEAAAAL\nbG9nZ2VkaW5faWQXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZRcSZ3JpenpseUBzbWl0Lmlk\nLmF1AAAADmxvZ2dlZGluX2VtYWlsFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVt\nYmVyCiA3NDJiYTdjMjk5ZmM3MWQwMjIxNGEyNTA4ZDk1ZGFhZgAAAAtfc2Vzc2lvbl9pZBcFYWRt\naW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24I\ngQAAAA5sb2dnZWRpbl9hZG1pbgoCMjUAAAALcGFnZV9sZW5ndGgXFEZyYW5jaXMgR3JpenpseSBT\nbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQoBMAAAAAVkZWJ1ZwiBAAAAFmxvZ2dlZGluX2dy\nb3Vwbm5hbWVfaWQ=\n
ec9a2b3736d19d02cb8d54257c2a6dba	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdl\nCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCiBlYzlhMmIzNzM2ZDE5ZDAyY2I4ZDU0\nMjU3YzJhNmRiYQAAAAtfc2Vzc2lvbl9pZA==\n
9888cb9a2f217391f61e603440aa29ea	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlCiA5ODg4Y2I5YTJmMjE3MzkxZjYxZTYw\nMzQ0MGFhMjllYQAAAAtfc2Vzc2lvbl9pZA==\n
3588abb2ab533d1a63f6b2d3853fa883	BQsDAAAABAogMzU4OGFiYjJhYjUzM2QxYTYzZjZiMmQzODUzZmE4ODMAAAALX3Nlc3Npb25faWQI\nmQAAAAtwYWdlX2xlbmd0aAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
be22dc5e90617a152c056299d9b3908e	BQsDAAAABAogYmUyMmRjNWU5MDYxN2ExNTJjMDU2Mjk5ZDliMzkwOGUAAAALX3Nlc3Npb25faWQI\nmQAAAAtwYWdlX2xlbmd0aAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
ecaf4c558ec8d09568ae0fc1747685e5	BQsDAAAABAogZWNhZjRjNTU4ZWM4ZDA5NTY4YWUwZmMxNzQ3Njg1ZTUAAAALX3Nlc3Npb25faWQK\nD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aA==\n
e6637cca97a124a23d69f1430fde689e	BQsDAAAAEAogZTY2MzdjY2E5N2ExMjRhMjNkNjlmMTQzMGZkZTY4OWUAAAALX3Nlc3Npb25faWQX\nEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcMKzYxNDgyMTc2MzQzAAAAFWxv\nZ2dlZGluX3Bob25lX251bWJlcgiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQIgQAAAAhsb2dn\nZWRpbgiBAAAAC2xvZ2dlZGluX2lkFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUKATAAAAAF\nZGVidWcKAjI1AAAAC3BhZ2VfbGVuZ3RoChBwYWdlXlByb2dyYW1taW5nAAAADGN1cnJlbnRfcGFn\nZRcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dl\nZGluX2Rpc3BsYXlfbmFtZQiBAAAADmxvZ2dlZGluX2FkbWluFwVhZG1pbgAAABFsb2dnZWRpbl91\nc2VybmFtZQoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcPRnJhbmNpcyBHcml6emx5\nAAAADmxvZ2dlZGluX2dpdmVu\n
61933b2e4b89db45a3f9c25ab495b74a	BQsDAAAABAogNjE5MzNiMmU0Yjg5ZGI0NWEzZjljMjVhYjQ5NWI3NGEAAAALX3Nlc3Npb25faWQI\nmQAAAAtwYWdlX2xlbmd0aAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
0cdf135bc69495f0516a6f175d8a819d	BQsDAAAAEBcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkIgQAAAA5sb2dnZWRpbl9hZG1pbhcURnJh\nbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCiAwY2RmMTM1YmM2OTQ5\nNWYwNTE2YTZmMTc1ZDhhODE5ZAAAAAtfc2Vzc2lvbl9pZBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dl\nZGluX3Bob25lX251bWJlcgiBAAAACGxvZ2dlZGluCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9z\nZWN0aW9uCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlFwVhZG1pbgAAABJsb2dnZWRp\nbl9ncm91cG5hbWUIgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkFxJncml6emx5QHNtaXQuaWQu\nYXUAAAAObG9nZ2VkaW5fZW1haWwXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lCIEAAAALbG9n\nZ2VkaW5faWQXD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbgiZAAAAC3BhZ2VfbGVu\nZ3RoCgEwAAAABWRlYnVn\n
298b43eb7f8161a87afeca5f8b970758	BQsDAAAAEAogMjk4YjQzZWI3ZjgxNjFhODdhZmVjYTVmOGI5NzA3NTgAAAALX3Nlc3Npb25faWQX\nBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2Vk\naW5fZW1haWwIgQAAAA5sb2dnZWRpbl9hZG1pbgoCMjUAAAALcGFnZV9sZW5ndGgXD0ZyYW5jaXMg\nR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbgiBAAAACGxvZ2dlZGluCgxhbGxfc2VjdGlvbnMAAAAP\nY3VycmVudF9zZWN0aW9uCIEAAAALbG9nZ2VkaW5faWQXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5\nFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUIgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lk\nFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXDCs2MTQ4MjE3\nNjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIKEHBhZ2VeUHJvZ3JhbW1pbmcAAAAMY3VycmVu\ndF9wYWdlCgEwAAAABWRlYnVn\n
317320688c9f83b46767307c7b4daab9	BQsDAAAABAogMzE3MzIwNjg4YzlmODNiNDY3NjczMDdjN2I0ZGFhYjkAAAALX3Nlc3Npb25faWQK\nDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24KD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJy\nZW50X3BhZ2UImQAAAAtwYWdlX2xlbmd0aA==\n
b00c1f16a69133d84b9b1ff0fee70aba	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgogYjAwYzFmMTZhNjkxMzNkODRiOWIxZmYwZmVlNzBhYmEAAAALX3Nl\nc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aA==\n
761b3e44e16bebbdabe3e7041416c1db	BQsDAAAAEBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgiBAAAAFmxvZ2dl\nZGluX2dyb3Vwbm5hbWVfaWQXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQiBAAAACGxvZ2dl\nZGluCiA3NjFiM2U0NGUxNmJlYmJkYWJlM2U3MDQxNDE2YzFkYgAAAAtfc2Vzc2lvbl9pZAoCMjUA\nAAALcGFnZV9sZW5ndGgIgQAAAAtsb2dnZWRpbl9pZBcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5h\nbWUKCXBhZ2Ved29yawAAAAxjdXJyZW50X3BhZ2UXD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRp\nbl9naXZlbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5s\nb2dnZWRpbl9lbWFpbBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9u\nYW1lCgEwAAAABWRlYnVnCIEAAAAObG9nZ2VkaW5fYWRtaW4KDGFsbF9zZWN0aW9ucwAAAA9jdXJy\nZW50X3NlY3Rpb24=\n
f4a619b1c5cda14ffd1b5f399d57e771	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQogZjRhNjE5YjFjNWNkYTE0\nZmZkMWI1ZjM5OWQ1N2U3NzEAAAALX3Nlc3Npb25faWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aA==\n
404dc4734c173554b3b921336f6928df	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3Ro\nCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlCiA0MDRkYzQ3MzRjMTczNTU0YjNiOTIx\nMzM2ZjY5MjhkZgAAAAtfc2Vzc2lvbl9pZA==\n
d8e4bdaf1101c68f1db157ae5ac120c6	BQsDAAAAEBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCIEAAAAObG9nZ2VkaW5f\nYWRtaW4KIGQ4ZTRiZGFmMTEwMWM2OGYxZGIxNTdhZTVhYzEyMGM2AAAAC19zZXNzaW9uX2lkFwwr\nNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyCgIyNQAAAAtwYWdlX2xlbmd0aAiB\nAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5CIEAAAAI\nbG9nZ2VkaW4IgQAAAAtsb2dnZWRpbl9pZBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2Vk\naW5fZGlzcGxheV9uYW1lFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZQoPcHNldWRvLXBhZ2Ve\nYWxsAAAADGN1cnJlbnRfcGFnZRcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWls\nCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91\ncG5hbWUKATAAAAAFZGVidWc=\n
847112b85649ec90bdd95f2d58a04209	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgogODQ3MTEyYjg1NjQ5ZWM5MGJkZDk1ZjJkNThhMDQyMDkAAAALX3Nl\nc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aA==\n
5d9f95d736c7f16eca6f4f8e388c272d	BQsDAAAAEAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiBAAAACGxvZ2dlZGluFwRT\nbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQiBAAAADmxvZ2dlZGluX2FkbWluFxRGcmFuY2lzIEdyaXp6\nbHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUIgQAAABZsb2dnZWRpbl9ncm91cG5uYW1l\nX2lkCglwYWdlXndvcmsAAAAMY3VycmVudF9wYWdlCgIyNQAAAAtwYWdlX2xlbmd0aAoBMAAAAAVk\nZWJ1ZxcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUXD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dn\nZWRpbl9naXZlbhcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsFwVhZG1pbgAA\nABJsb2dnZWRpbl9ncm91cG5hbWUXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1i\nZXIKIDVkOWY5NWQ3MzZjN2YxNmVjYTZmNGY4ZTM4OGMyNzJkAAAAC19zZXNzaW9uX2lkCIEAAAAL\nbG9nZ2VkaW5faWQ=\n
fb00a906cb28fe3c4bb857273098fbde	BQsDAAAAEAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXBWFkbWluAAAAEWxvZ2dlZGluX3Vz\nZXJuYW1lCIEAAAAObG9nZ2VkaW5fYWRtaW4KATAAAAAFZGVidWcKIGZiMDBhOTA2Y2IyOGZlM2M0\nYmI4NTcyNzMwOThmYmRlAAAAC19zZXNzaW9uX2lkCIEAAAAIbG9nZ2VkaW4XBFNtaXQAAAAPbG9n\nZ2VkaW5fZmFtaWx5CgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uChBwYWdlXlByb2dy\nYW1taW5nAAAADGN1cnJlbnRfcGFnZQoCMjUAAAALcGFnZV9sZW5ndGgXBWFkbWluAAAAEmxvZ2dl\nZGluX2dyb3VwbmFtZRcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9u\nYW1lFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXD0ZyYW5jaXMgR3Jpenps\neQAAAA5sb2dnZWRpbl9naXZlbhcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJl\ncgiBAAAAC2xvZ2dlZGluX2lk\n
d0ac2ab00f8d3994f772766adb890294	BQsDAAAAEBcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUIgQAAABZsb2dnZWRpbl9ncm91cG5u\nYW1lX2lkFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXBFNt\naXQAAAAPbG9nZ2VkaW5fZmFtaWx5CglwYWdlXndvcmsAAAAMY3VycmVudF9wYWdlCIEAAAALbG9n\nZ2VkaW5faWQXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcFYWRtaW4AAAAS\nbG9nZ2VkaW5fZ3JvdXBuYW1lCgIyNQAAAAtwYWdlX2xlbmd0aAogZDBhYzJhYjAwZjhkMzk5NGY3\nNzI3NjZhZGI4OTAyOTQAAAALX3Nlc3Npb25faWQIgQAAAAhsb2dnZWRpbgiBAAAADmxvZ2dlZGlu\nX2FkbWluCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCgEwAAAABWRlYnVnFwwrNjE0\nODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9n\nZ2VkaW5fZ2l2ZW4=\n
1e82e2ddf67900414c66486067e861a4	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3Ro\nCiAxZTgyZTJkZGY2NzkwMDQxNGM2NjQ4NjA2N2U4NjFhNAAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
d3fd688d6b882b9652532fc00650e434	BQsDAAAAEAogZDNmZDY4OGQ2Yjg4MmI5NjUyNTMyZmMwMDY1MGU0MzQAAAALX3Nlc3Npb25faWQI\ngQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dn\nZWRpbl9kaXNwbGF5X25hbWUXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcP\nRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCglwYWdlXndvcmsAAAAMY3VycmVudF9w\nYWdlCgEwAAAABWRlYnVnCIEAAAAObG9nZ2VkaW5fYWRtaW4XBWFkbWluAAAAEWxvZ2dlZGluX3Vz\nZXJuYW1lFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseRcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGlu\nX3Bob25lX251bWJlchcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lCgxhbGxfc2VjdGlvbnMA\nAAAPY3VycmVudF9zZWN0aW9uCgIyNQAAAAtwYWdlX2xlbmd0aAiBAAAAC2xvZ2dlZGluX2lkCIEA\nAAAIbG9nZ2VkaW4=\n
5e0758ecc5f5d8cea59fff78e32efb9c	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogNWUwNzU4ZWNjNWY1ZDhj\nZWE1OWZmZjc4ZTMyZWZiOWMAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
a5adbf2c6ad4d2c21d4d1b1780f7cbd6	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCiBhNWFkYmYyYzZhZDRkMmMyMWQ0ZDFiMTc4MGY3Y2Jk\nNgAAAAtfc2Vzc2lvbl9pZAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
a748b7f74c934b8f52e0f74ef9876185	BQsDAAAAEAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoBMAAAAAVkZWJ1ZwoQcGFn\nZV5Qcm9ncmFtbWluZwAAAAxjdXJyZW50X3BhZ2UXD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRp\nbl9naXZlbgiBAAAACGxvZ2dlZGluCiBhNzQ4YjdmNzRjOTM0YjhmNTJlMGY3NGVmOTg3NjE4NQAA\nAAtfc2Vzc2lvbl9pZBcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsFwVhZG1p\nbgAAABFsb2dnZWRpbl91c2VybmFtZRcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251\nbWJlcgiBAAAADmxvZ2dlZGluX2FkbWluFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUIgQAA\nAAtsb2dnZWRpbl9pZAoCMjUAAAALcGFnZV9sZW5ndGgXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAA\nFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZRcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkIgQAAABZsb2dn\nZWRpbl9ncm91cG5uYW1lX2lk\n
e323212d80fb6e432109d7530ebd6028	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdl\nCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCiBlMzIzMjEyZDgwZmI2ZTQzMjEwOWQ3\nNTMwZWJkNjAyOAAAAAtfc2Vzc2lvbl9pZA==\n
4df6a453a2445648a01e141a3b3a31e6	BQsDAAAAEAogNGRmNmE0NTNhMjQ0NTY0OGEwMWUxNDFhM2IzYTMxZTYAAAALX3Nlc3Npb25faWQI\nmQAAAAtwYWdlX2xlbmd0aAiBAAAADmxvZ2dlZGluX2FkbWluCIEAAAALbG9nZ2VkaW5faWQIgQAA\nABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVf\nbnVtYmVyFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseRcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxv\nZ2dlZGluX2VtYWlsFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25h\nbWUKD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDGFsbF9zZWN0aW9ucwAAAA9jdXJy\nZW50X3NlY3Rpb24IgQAAAAhsb2dnZWRpbhcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFwVh\nZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZQoBMAAAAAVkZWJ1ZxcPRnJhbmNpcyBHcml6emx5AAAA\nDmxvZ2dlZGluX2dpdmVu\n
f7528bc524a57e39a9de80943c2fbc22	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQiZAAAAC3BhZ2VfbGVuZ3Ro\nCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCiBmNzUyOGJjNTI0YTU3ZTM5YTlkZTgw\nOTQzYzJmYmMyMgAAAAtfc2Vzc2lvbl9pZA==\n
64330692b6502cde415825e8442c5d96	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQogNjQzMzA2OTJiNjUwMmNk\nZTQxNTgyNWU4NDQyYzVkOTYAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
856f6ce20a5ef17c91859686d65956d1	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogODU2ZjZjZTIwYTVlZjE3\nYzkxODU5Njg2ZDY1OTU2ZDEAAAALX3Nlc3Npb25faWQKD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJy\nZW50X3BhZ2UImQAAAAtwYWdlX2xlbmd0aA==\n
a8c5d9dca6861d159978aea878bd828e	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogYThjNWQ5ZGNhNjg2MWQx\nNTk5NzhhZWE4NzhiZDgyOGUAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
ec8f26572f562b162adab21b0d1a93cb	BQsDAAAABQoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogZWM4ZjI2NTcyZjU2MmIx\nNjJhZGFiMjFiMGQxYTkzY2IAAAALX3Nlc3Npb25faWQKCXBhZ2Ved29yawAAAAxjdXJyZW50X3Bh\nZ2UKAjI1AAAAC3BhZ2VfbGVuZ3RoCgEwAAAABWRlYnVn\n
fc3521933912b1b02a6037f0a1d42d9c	BQsDAAAABAogZmMzNTIxOTMzOTEyYjFiMDJhNjAzN2YwYTFkNDJkOWMAAAALX3Nlc3Npb25faWQK\nD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aA==\n
09b929317a77182b5e6857e7d190bfaf	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCiAwOWI5MjkzMTdhNzcxODJiNWU2ODU3ZTdkMTkwYmZh\nZgAAAAtfc2Vzc2lvbl9pZAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
bf8cbb70a2cc259d659aeb9dd9cda24d	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCiBiZjhjYmI3MGEyY2MyNTlkNjU5YWViOWRkOWNkYTI0ZAAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
a9281c2b84635cd90b7e080b5fdd426b	BQsDAAAABAogYTkyODFjMmI4NDYzNWNkOTBiN2UwODBiNWZkZDQyNmIAAAALX3Nlc3Npb25faWQK\nD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aA==\n
abcdda26ad1a0ee9706a67aeedbcf5bd	BQsDAAAAEAogYWJjZGRhMjZhZDFhMGVlOTcwNmE2N2FlZWRiY2Y1YmQAAAALX3Nlc3Npb25faWQI\ngQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2Vk\naW5fZW1haWwKAjI1AAAAC3BhZ2VfbGVuZ3RoFwVhZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZQiB\nAAAADmxvZ2dlZGluX2FkbWluCIEAAAALbG9nZ2VkaW5faWQXDCs2MTQ4MjE3NjM0MwAAABVsb2dn\nZWRpbl9waG9uZV9udW1iZXIXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZRcURnJhbmNpcyBH\ncml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCgEwAAAABWRlYnVnFw9GcmFuY2lz\nIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4KD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3Bh\nZ2UIgQAAAAhsb2dnZWRpbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKDGFsbF9zZWN0aW9ucwAA\nAA9jdXJyZW50X3NlY3Rpb24=\n
1bc109c3128465b01e47968c68553e3a	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogMWJjMTA5YzMxMjg0NjVi\nMDFlNDc5NjhjNjg1NTNlM2EAAAALX3Nlc3Npb25faWQKD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJy\nZW50X3BhZ2UImQAAAAtwYWdlX2xlbmd0aA==\n
6ea887a053e98be1d27959853ac6ca65	BQsZAAAAABEXQi9eW1wrXHgzNlx4MzEgfHwgXHgzMF0/XHgzNFxkICoqIDI8W1wgLV0+P1xkICoq\nIDM8W1wgLV0+P1xkICoqIDMkLwIAAAAXbG9nZ2VkaW5fbW9iaWxlX3BhdHRlcm4XATICAAAAC2xv\nZ2dlZGluX2lkFwpCb29sOjpUcnVlAgAAAA5sb2dnZWRpbl9hZG1pbhdEL15bXCs/XHgzNlx4MzE8\nW1wgLV0+P10/XHgzMzxbXCAtXT4/PFsyLi45XT5cZCAqKiAzPFtcIC1dPj9cZCAqKiA0JC8CAAAA\nGWxvZ2dlZGluX2xhbmRsaW5lX3BhdHRlcm4XDSJncml6emx5c21pdCICAAAAEmxvZ2dlZGluX2dy\nb3VwbmFtZRcDIjAiAgAAAA9sb2dnZWRpbl9lc2NhcGUXESJGcmFuY2lzIEdyaXp6bHkiAgAAAA5s\nb2dnZWRpbl9naXZlbhcWIkZyYW5jaXMgR3JpenpseSBTbWl0IgIAAAAVbG9nZ2VkaW5fZGlzcGxh\neV9uYW1lCiA2ZWE4ODdhMDUzZTk4YmUxZDI3OTU5ODUzYWM2Y2E2NQAAAAALX3Nlc3Npb25faWQX\nDiIrNjE0ODIxNzYzNDMiAgAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIXATMCAAAAFmxvZ2dlZGlu\nX2dyb3Vwbm5hbWVfaWQXBiJTbWl0IgIAAAAPbG9nZ2VkaW5fZmFtaWx5FwQiLSAiAgAAAA5sb2dn\nZWRpbl9wdW5jdBcBMgIAAAAIbG9nZ2VkaW4XBSIrNjEiAgAAAA9sb2dnZWRpbl9wcmVmaXgXDSJn\ncml6emx5c21pdCICAAAAEWxvZ2dlZGluX3VzZXJuYW1lFxUiZ3JpenpseVxAc21pdC5pZC5hdSIC\nAAAADmxvZ2dlZGluX2VtYWls\n
7b046986ad09d3831589c16d5e3ef958	BQsDAAAAEAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogN2IwNDY5ODZhZDA5ZDM4\nMzE1ODljMTZkNWUzZWY5NTgAAAALX3Nlc3Npb25faWQXD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dn\nZWRpbl9naXZlbgiBAAAAC2xvZ2dlZGluX2lkCIEAAAAIbG9nZ2VkaW4XBWFkbWluAAAAEmxvZ2dl\nZGluX2dyb3VwbmFtZQiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXDCs2MTQ4MjE3NjM0MwAA\nABVsb2dnZWRpbl9waG9uZV9udW1iZXIXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGlu\nX2Rpc3BsYXlfbmFtZRcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUIgQAAAA5sb2dnZWRpbl9h\nZG1pbgoBMAAAAAVkZWJ1ZxcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsCgIy\nNQAAAAtwYWdlX2xlbmd0aBcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKEHBhZ2VeUHJvZ3JhbW1p\nbmcAAAAMY3VycmVudF9wYWdl\n
6be69f24be3d4416846b5fd05e696ed9	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3RoCiA2YmU2OWYyNGJlM2Q0NDE2ODQ2YjVm\nZDA1ZTY5NmVkOQAAAAtfc2Vzc2lvbl9pZA==\n
1e8f0ea83a8c6cfca27e8fedce7a3fa0	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgogMWU4ZjBlYTgzYThjNmNmY2EyN2U4ZmVkY2U3YTNmYTAAAAALX3Nl\nc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aA==\n
b9e0367a8b45a6c0f05364c370ff5185	BQsDAAAABAogYjllMDM2N2E4YjQ1YTZjMGYwNTM2NGMzNzBmZjUxODUAAAALX3Nlc3Npb25faWQI\nmQAAAAtwYWdlX2xlbmd0aAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
5972304742270a430722c709e78a86ca	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3RoCiA1OTcyMzA0NzQyMjcwYTQzMDcyMmM3\nMDllNzhhODZjYQAAAAtfc2Vzc2lvbl9pZA==\n
85475eef58471f8a3ee13e3eb2dca40c	BQsDAAAABAogODU0NzVlZWY1ODQ3MWY4YTNlZTEzZTNlYjJkY2E0MGMAAAALX3Nlc3Npb25faWQI\nmQAAAAtwYWdlX2xlbmd0aAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
c5b0c2a5a48cecfcbf18260df39c2012	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgogYzViMGMyYTVhNDhjZWNmY2JmMTgyNjBkZjM5YzIwMTIAAAALX3Nl\nc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aA==\n
3fd1b1285012c14e96367cec52ac9bd1	BQsDAAAAEBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCgEwAAAABWRlYnVnFxRG\ncmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUKEHBhZ2VeUHJvZ3Jh\nbW1pbmcAAAAMY3VycmVudF9wYWdlFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1h\naWwIgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkCIEAAAAObG9nZ2VkaW5fYWRtaW4KAjI1AAAA\nC3BhZ2VfbGVuZ3RoFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyCIEAAAAI\nbG9nZ2VkaW4KDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XBWFkbWluAAAAEWxvZ2dl\nZGluX3VzZXJuYW1lCIEAAAALbG9nZ2VkaW5faWQKIDNmZDFiMTI4NTAxMmMxNGU5NjM2N2NlYzUy\nYWM5YmQxAAAAC19zZXNzaW9uX2lkFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUXBFNtaXQA\nAAAPbG9nZ2VkaW5fZmFtaWx5\n
531fb3152ff6b60849c47b616812cbfe	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQogNTMxZmIzMTUyZmY2YjYw\nODQ5YzQ3YjYxNjgxMmNiZmUAAAALX3Nlc3Npb25faWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aA==\n
628d979040dc17d2f7822f56be29ce47	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQiZAAAAC3BhZ2VfbGVuZ3Ro\nCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCiA2MjhkOTc5MDQwZGMxN2QyZjc4MjJm\nNTZiZTI5Y2U0NwAAAAtfc2Vzc2lvbl9pZA==\n
0015b6a526f637e1ea4eab04ea4576d3	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCiAwMDE1YjZhNTI2ZjYzN2UxZWE0ZWFiMDRlYTQ1NzZkMwAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
f1a5db80df3bdfef7c047fdb8ad04e24	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdl\nCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCiBmMWE1ZGI4MGRmM2JkZmVmN2MwNDdm\nZGI4YWQwNGUyNAAAAAtfc2Vzc2lvbl9pZA==\n
c602e640be0d42427c2616966993e1e0	BQsDAAAABAogYzYwMmU2NDBiZTBkNDI0MjdjMjYxNjk2Njk5M2UxZTAAAAALX3Nlc3Npb25faWQI\nmQAAAAtwYWdlX2xlbmd0aAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
a1d394806a918a0c82c556f38da27a04	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9u\nCiBhMWQzOTQ4MDZhOTE4YTBjODJjNTU2ZjM4ZGEyN2EwNAAAAAtfc2Vzc2lvbl9pZAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
d53020da7b1f4777d0b8a467c59a4d20	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQogZDUzMDIwZGE3YjFmNDc3\nN2QwYjhhNDY3YzU5YTRkMjAAAAALX3Nlc3Npb25faWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aA==\n
14e5897a53d724daf12fb8e01b28f2d9	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCiAxNGU1ODk3YTUzZDcyNGRhZjEyZmI4ZTAxYjI4ZjJk\nOQAAAAtfc2Vzc2lvbl9pZAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
fffa5dfc7af4baf1f1f728d9c4023d30	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgogZmZmYTVkZmM3YWY0YmFm\nMWYxZjcyOGQ5YzQwMjNkMzAAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
f116ca95ec67afb555584bacedb8164e	BQsDAAAABAogZjExNmNhOTVlYzY3YWZiNTU1NTg0YmFjZWRiODE2NGUAAAALX3Nlc3Npb25faWQK\nDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aAoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
f79966e60245c832693f4df04d0fe895	BQsDAAAAEAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQIgQAAAAtsb2dnZWRpbl9pZAoCMjUA\nAAALcGFnZV9sZW5ndGgXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlf\nbmFtZRcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1l\nFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUIgQAAAA5sb2dnZWRpbl9hZG1pbhcPRnJhbmNp\ncyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCglwYWdlXndvcmsAAAAMY3VycmVudF9wYWdlFxJn\ncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwKDGFsbF9zZWN0aW9ucwAAAA9jdXJy\nZW50X3NlY3Rpb24IgQAAAAhsb2dnZWRpbhcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25l\nX251bWJlcgoBMAAAAAVkZWJ1ZwogZjc5OTY2ZTYwMjQ1YzgzMjY5M2Y0ZGYwNGQwZmU4OTUAAAAL\nX3Nlc3Npb25faWQ=\n
21a0861eae20c35e5c8ce3cdeb0d938c	BQsDAAAAEBcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUIgQAAABZsb2dnZWRpbl9ncm91cG5u\nYW1lX2lkCIEAAAAIbG9nZ2VkaW4XFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rp\nc3BsYXlfbmFtZRcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lCiAyMWEwODYxZWFlMjBjMzVl\nNWM4Y2UzY2RlYjBkOTM4YwAAAAtfc2Vzc2lvbl9pZAoQcGFnZV5Qcm9ncmFtbWluZwAAAAxjdXJy\nZW50X3BhZ2UIgQAAAA5sb2dnZWRpbl9hZG1pbhcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dl\nZGluX2VtYWlsCIEAAAALbG9nZ2VkaW5faWQKAjI1AAAAC3BhZ2VfbGVuZ3RoFw9GcmFuY2lzIEdy\naXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4XBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5CgEwAAAABWRl\nYnVnCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uFwwrNjE0ODIxNzYzNDMAAAAVbG9n\nZ2VkaW5fcGhvbmVfbnVtYmVy\n
55d2bf9c3590ad0de23006ec1af9ad29	BQsDAAAAEBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuFwVhZG1pbgAAABJsb2dn\nZWRpbl9ncm91cG5hbWUIgQAAAAhsb2dnZWRpbhcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bo\nb25lX251bWJlcgoQcGFnZV5Qcm9ncmFtbWluZwAAAAxjdXJyZW50X3BhZ2UXFEZyYW5jaXMgR3Jp\nenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQoBMAAAAAVkZWJ1ZwoMYWxsX3NlY3Rp\nb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiBAAAAC2xvZ2dlZGluX2lkFwVhZG1pbgAAABFsb2dnZWRp\nbl91c2VybmFtZRcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsCIEAAAAWbG9n\nZ2VkaW5fZ3JvdXBubmFtZV9pZAoCMjUAAAALcGFnZV9sZW5ndGgKIDU1ZDJiZjljMzU5MGFkMGRl\nMjMwMDZlYzFhZjlhZDI5AAAAC19zZXNzaW9uX2lkCIEAAAAObG9nZ2VkaW5fYWRtaW4XBFNtaXQA\nAAAPbG9nZ2VkaW5fZmFtaWx5\n
8cbd946aa3f26f7f857c01a7247dd924	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQogOGNiZDk0NmFhM2YyNmY3\nZjg1N2MwMWE3MjQ3ZGQ5MjQAAAALX3Nlc3Npb25faWQImQAAAAtwYWdlX2xlbmd0aAoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbg==\n
849c0bb9a5a5426e3d93186f7b15f9e5	BQsDAAAAEAoJcGFnZV53b3JrAAAADGN1cnJlbnRfcGFnZQoCMjUAAAALcGFnZV9sZW5ndGgXBFNt\naXQAAAAPbG9nZ2VkaW5fZmFtaWx5CIEAAAAIbG9nZ2VkaW4IgQAAABZsb2dnZWRpbl9ncm91cG5u\nYW1lX2lkFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyCIEAAAAObG9nZ2Vk\naW5fYWRtaW4XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbAiBAAAAC2xvZ2dl\nZGluX2lkFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUXBWFkbWluAAAAEWxvZ2dlZGluX3Vz\nZXJuYW1lCiA4NDljMGJiOWE1YTU0MjZlM2Q5MzE4NmY3YjE1ZjllNQAAAAtfc2Vzc2lvbl9pZBcP\nRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVu\ndF9zZWN0aW9uCgEwAAAABWRlYnVnFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9k\naXNwbGF5X25hbWU=\n
1bd7bbfc1e76c22e7825d959ca057566	BQsDAAAAEBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgiBAAAADmxvZ2dl\nZGluX2FkbWluFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUK\nDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XD0ZyYW5jaXMgR3JpenpseQAAAA5sb2dn\nZWRpbl9naXZlbgiBAAAACGxvZ2dlZGluFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5f\nZW1haWwIgQAAAAtsb2dnZWRpbl9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKIDFiZDdiYmZj\nMWU3NmMyMmU3ODI1ZDk1OWNhMDU3NTY2AAAAC19zZXNzaW9uX2lkFwVhZG1pbgAAABFsb2dnZWRp\nbl91c2VybmFtZQoCMjUAAAALcGFnZV9sZW5ndGgXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFt\nZQiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKATAAAAAFZGVidWcKEHBhZ2VeUHJvZ3JhbW1p\nbmcAAAAMY3VycmVudF9wYWdl\n
649c5a434d7b00ad80897a407182f6a0	BQsDAAAABAiZAAAAC3BhZ2VfbGVuZ3RoCiA2NDljNWE0MzRkN2IwMGFkODA4OTdhNDA3MTgyZjZh\nMAAAAAtfc2Vzc2lvbl9pZAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRv\nLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQ==\n
ff53a95635c497b4e92f4710599b13be	BQsDAAAAEAiBAAAACGxvZ2dlZGluFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVt\nYmVyCglwYWdlXndvcmsAAAAMY3VycmVudF9wYWdlFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9n\nZ2VkaW5fZW1haWwXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lFw9GcmFuY2lzIEdyaXp6bHkA\nAAAObG9nZ2VkaW5fZ2l2ZW4XBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5CgEwAAAABWRlYnVnCiBm\nZjUzYTk1NjM1YzQ5N2I0ZTkyZjQ3MTA1OTliMTNiZQAAAAtfc2Vzc2lvbl9pZBcFYWRtaW4AAAAS\nbG9nZ2VkaW5fZ3JvdXBuYW1lCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uFxRGcmFu\nY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUKAjI1AAAAC3BhZ2VfbGVu\nZ3RoCIEAAAALbG9nZ2VkaW5faWQIgQAAAA5sb2dnZWRpbl9hZG1pbgiBAAAAFmxvZ2dlZGluX2dy\nb3Vwbm5hbWVfaWQ=\n
b99d049014419ad499031a7626455cb0	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQogYjk5ZDA0OTAxNDQxOWFk\nNDk5MDMxYTc2MjY0NTVjYjAAAAALX3Nlc3Npb25faWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aA==\n
e894556a498d1203c9734573c00df33c	BQsDAAAAEAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQIgQAAAAhsb2dnZWRpbgoMYWxsX3Nl\nY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiBAAAAC2xvZ2dlZGluX2lkCiBlODk0NTU2YTQ5OGQx\nMjAzYzk3MzQ1NzNjMDBkZjMzYwAAAAtfc2Vzc2lvbl9pZBcSZ3JpenpseUBzbWl0LmlkLmF1AAAA\nDmxvZ2dlZGluX2VtYWlsChBwYWdlXlByb2dyYW1taW5nAAAADGN1cnJlbnRfcGFnZRcPRnJhbmNp\ncyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCIEAAAAObG9nZ2VkaW5fYWRtaW4XFEZyYW5jaXMg\nR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZRcFYWRtaW4AAAASbG9nZ2VkaW5f\nZ3JvdXBuYW1lCgIyNQAAAAtwYWdlX2xlbmd0aAoBMAAAAAVkZWJ1ZxcEU21pdAAAAA9sb2dnZWRp\nbl9mYW1pbHkXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIXBWFkbWluAAAA\nEWxvZ2dlZGluX3VzZXJuYW1l\n
9348ed9686846493eced370a4f9e114d	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoPcHNldWRvLXBhZ2VeYWxs\nAAAADGN1cnJlbnRfcGFnZQiZAAAAC3BhZ2VfbGVuZ3RoCiA5MzQ4ZWQ5Njg2ODQ2NDkzZWNlZDM3\nMGE0ZjllMTE0ZAAAAAtfc2Vzc2lvbl9pZA==\n
690c7d7dbe30d290d1874ca43c7f1f4b	BQsDAAAABAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA\nD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3RoCiA2OTBjN2Q3ZGJlMzBkMjkwZDE4NzRj\nYTQzYzdmMWY0YgAAAAtfc2Vzc2lvbl9pZA==\n
29ba92e05c6be4f78f52cc1dd890d7ae	BQsDAAAABAogMjliYTkyZTA1YzZiZTRmNzhmNTJjYzFkZDg5MGQ3YWUAAAALX3Nlc3Npb25faWQK\nD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50\nX3NlY3Rpb24ImQAAAAtwYWdlX2xlbmd0aA==\n
cae509cebc4a4721486c724dcf823d73	BQsDAAAABAogY2FlNTA5Y2ViYzRhNDcyMTQ4NmM3MjRkY2Y4MjNkNzMAAAALX3Nlc3Npb25faWQK\nDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24KD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJy\nZW50X3BhZ2UImQAAAAtwYWdlX2xlbmd0aA==\n
ab1ded9b068167f5ea9553c6b0c85f8b	BQsDAAAABAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiZAAAAC3BhZ2VfbGVuZ3Ro\nCg9wc2V1ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlCiBhYjFkZWQ5YjA2ODE2N2Y1ZWE5NTUz\nYzZiMGM4NWY4YgAAAAtfc2Vzc2lvbl9pZA==\n
\.


--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 211
-- Name: _group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public._group_id_seq', 39, true);


--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 213
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.address_id_seq', 28, true);


--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 216
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.addresses_id_seq', 1, false);


--
-- TOC entry 3770 (class 0 OID 0)
-- Dependencies: 219
-- Name: alias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.alias_id_seq', 37, true);


--
-- TOC entry 3771 (class 0 OID 0)
-- Dependencies: 227
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.countries_id_seq', 524, true);


--
-- TOC entry 3772 (class 0 OID 0)
-- Dependencies: 256
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.country_id_seq', 91, true);


--
-- TOC entry 3773 (class 0 OID 0)
-- Dependencies: 258
-- Name: country_regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.country_regions_id_seq', 549, true);


--
-- TOC entry 3774 (class 0 OID 0)
-- Dependencies: 228
-- Name: email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.email_id_seq', 22, true);


--
-- TOC entry 3775 (class 0 OID 0)
-- Dependencies: 230
-- Name: emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.emails_id_seq', 1, false);


--
-- TOC entry 3776 (class 0 OID 0)
-- Dependencies: 232
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.groups_id_seq', 358, true);


--
-- TOC entry 3777 (class 0 OID 0)
-- Dependencies: 220
-- Name: links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.links_id_seq', 116, true);


--
-- TOC entry 3778 (class 0 OID 0)
-- Dependencies: 234
-- Name: links_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.links_id_seq1', 198, true);


--
-- TOC entry 3779 (class 0 OID 0)
-- Dependencies: 239
-- Name: page_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.page_section_id_seq', 187, true);


--
-- TOC entry 3780 (class 0 OID 0)
-- Dependencies: 243
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.pages_id_seq', 85, true);


--
-- TOC entry 3781 (class 0 OID 0)
-- Dependencies: 246
-- Name: passwd_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.passwd_details_id_seq', 21, true);


--
-- TOC entry 3782 (class 0 OID 0)
-- Dependencies: 244
-- Name: passwd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.passwd_id_seq', 21, true);


--
-- TOC entry 3783 (class 0 OID 0)
-- Dependencies: 248
-- Name: phone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.phone_id_seq', 38, true);


--
-- TOC entry 3784 (class 0 OID 0)
-- Dependencies: 250
-- Name: phones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.phones_id_seq', 1, false);


--
-- TOC entry 3785 (class 0 OID 0)
-- Dependencies: 252
-- Name: psudo_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.psudo_pages_id_seq', 8, true);


--
-- TOC entry 3410 (class 2606 OID 17053)
-- Name: _group _group_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public._group
    ADD CONSTRAINT _group_pkey PRIMARY KEY (id);


--
-- TOC entry 3414 (class 2606 OID 17055)
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- TOC entry 3416 (class 2606 OID 17057)
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- TOC entry 3418 (class 2606 OID 17059)
-- Name: alias alias_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_pkey PRIMARY KEY (id);


--
-- TOC entry 3420 (class 2606 OID 17061)
-- Name: alias alias_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_unique_contraint_name UNIQUE (name);


--
-- TOC entry 3465 (class 2606 OID 17311)
-- Name: country country_cc_ukey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_cc_ukey UNIQUE (cc);


--
-- TOC entry 3467 (class 2606 OID 17309)
-- Name: country country_name_ukey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_name_ukey UNIQUE (_name);


--
-- TOC entry 3469 (class 2606 OID 17307)
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.country
    ADD CONSTRAINT country_pkey PRIMARY KEY (id);


--
-- TOC entry 3471 (class 2606 OID 17323)
-- Name: country_regions country_regions_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.country_regions
    ADD CONSTRAINT country_regions_pkey PRIMARY KEY (id);


--
-- TOC entry 3433 (class 2606 OID 17069)
-- Name: email email_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_pkey PRIMARY KEY (id);


--
-- TOC entry 3435 (class 2606 OID 17071)
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- TOC entry 3412 (class 2606 OID 17073)
-- Name: _group group_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public._group
    ADD CONSTRAINT group_unique_key UNIQUE (_name);


--
-- TOC entry 3437 (class 2606 OID 17075)
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3439 (class 2606 OID 17077)
-- Name: groups groups_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_unique_key UNIQUE (group_id, passwd_id);


--
-- TOC entry 3422 (class 2606 OID 17079)
-- Name: links_sections links_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- TOC entry 3428 (class 2606 OID 17081)
-- Name: links links_pkey1; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_pkey1 PRIMARY KEY (id);


--
-- TOC entry 3425 (class 2606 OID 17083)
-- Name: links_sections links_sections_unnique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_sections_unnique_key UNIQUE (section);


--
-- TOC entry 3430 (class 2606 OID 17085)
-- Name: links links_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_unique_contraint_name UNIQUE (section_id, name);


--
-- TOC entry 3441 (class 2606 OID 17087)
-- Name: page_section page_section_unique; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT page_section_unique UNIQUE (pages_id, links_section_id);


--
-- TOC entry 3445 (class 2606 OID 17089)
-- Name: pages page_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT page_unique_key UNIQUE (name);


--
-- TOC entry 3457 (class 2606 OID 17091)
-- Name: passwd_details passwd_details_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_pkey PRIMARY KEY (id);


--
-- TOC entry 3453 (class 2606 OID 17093)
-- Name: passwd passwd_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_pkey PRIMARY KEY (id);


--
-- TOC entry 3455 (class 2606 OID 17095)
-- Name: passwd passwd_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_unique_key UNIQUE (username);


--
-- TOC entry 3459 (class 2606 OID 17097)
-- Name: phone phone_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phone
    ADD CONSTRAINT phone_pkey PRIMARY KEY (id);


--
-- TOC entry 3461 (class 2606 OID 17099)
-- Name: phones phones_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phones
    ADD CONSTRAINT phones_pkey PRIMARY KEY (id);


--
-- TOC entry 3447 (class 2606 OID 17101)
-- Name: pages pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pkey PRIMARY KEY (id);


--
-- TOC entry 3449 (class 2606 OID 17103)
-- Name: pseudo_pages pseudo_pages_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT pseudo_pages_unique_key UNIQUE (name);


--
-- TOC entry 3443 (class 2606 OID 17105)
-- Name: page_section psge_section_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT psge_section_pkey PRIMARY KEY (id);


--
-- TOC entry 3451 (class 2606 OID 17107)
-- Name: pseudo_pages psudo_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT psudo_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 3463 (class 2606 OID 17109)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 3426 (class 1259 OID 17110)
-- Name: fki_section_fkey; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE INDEX fki_section_fkey ON public.links USING btree (section_id);


--
-- TOC entry 3423 (class 1259 OID 17111)
-- Name: links_sections_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX links_sections_unique_key ON public.links_sections USING btree (section COLLATE "C" text_pattern_ops);


--
-- TOC entry 3431 (class 1259 OID 17112)
-- Name: links_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX links_unique_key ON public.links USING btree (name COLLATE "POSIX" bpchar_pattern_ops, section_id);

ALTER TABLE public.links CLUSTER ON links_unique_key;


--
-- TOC entry 3472 (class 2606 OID 17113)
-- Name: addresses addresses_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.address(id) NOT VALID;


--
-- TOC entry 3473 (class 2606 OID 17118)
-- Name: addresses addresses_passwd_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_passwd_id_fkey FOREIGN KEY (passwd_id) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3476 (class 2606 OID 17123)
-- Name: alias alias_foriegn_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_foriegn_key FOREIGN KEY (target) REFERENCES public.links_sections(id) NOT VALID;


--
-- TOC entry 3477 (class 2606 OID 17128)
-- Name: alias alias_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3478 (class 2606 OID 17133)
-- Name: alias alias_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3507 (class 2606 OID 17324)
-- Name: country_regions country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.country_regions
    ADD CONSTRAINT country_id_fkey FOREIGN KEY (country_id) REFERENCES public.country(id);


--
-- TOC entry 3484 (class 2606 OID 17138)
-- Name: emails emails_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_email_fkey FOREIGN KEY (email_id) REFERENCES public.email(id);


--
-- TOC entry 3485 (class 2606 OID 17143)
-- Name: emails emails_passwd_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_passwd_id_fkey FOREIGN KEY (passwd_id) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3486 (class 2606 OID 17148)
-- Name: groups groups_address_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_address_foreign_key FOREIGN KEY (passwd_id) REFERENCES public.passwd(id);


--
-- TOC entry 3487 (class 2606 OID 17153)
-- Name: groups groups_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_foreign_key FOREIGN KEY (group_id) REFERENCES public._group(id);


--
-- TOC entry 3481 (class 2606 OID 17158)
-- Name: links links_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3488 (class 2606 OID 17163)
-- Name: page_section links_section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT links_section_fkey FOREIGN KEY (links_section_id) REFERENCES public.links_sections(id);


--
-- TOC entry 3479 (class 2606 OID 17168)
-- Name: links_sections links_sections_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_sections_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3480 (class 2606 OID 17173)
-- Name: links_sections links_sections_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_sections_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3482 (class 2606 OID 17178)
-- Name: links links_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3489 (class 2606 OID 17183)
-- Name: page_section page_section_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT page_section_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3490 (class 2606 OID 17188)
-- Name: page_section page_section_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT page_section_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3491 (class 2606 OID 17193)
-- Name: page_section pages_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT pages_fkey FOREIGN KEY (pages_id) REFERENCES public.pages(id);


--
-- TOC entry 3492 (class 2606 OID 17198)
-- Name: pages pages_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3493 (class 2606 OID 17203)
-- Name: pages pages_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3499 (class 2606 OID 17341)
-- Name: passwd_details passwd_details_cc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_cc_fkey FOREIGN KEY (country_id) REFERENCES public.country(id) NOT VALID;


--
-- TOC entry 3496 (class 2606 OID 17213)
-- Name: passwd passwd_details_connection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_details_connection_fkey FOREIGN KEY (passwd_details_id) REFERENCES public.passwd_details(id) NOT VALID;


--
-- TOC entry 3500 (class 2606 OID 17351)
-- Name: passwd_details passwd_details_cr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_cr_fkey FOREIGN KEY (country_region_id) REFERENCES public.country_regions(id) NOT VALID;


--
-- TOC entry 3501 (class 2606 OID 17218)
-- Name: passwd_details passwd_details_p_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_p_phone_fkey FOREIGN KEY (primary_phone_id) REFERENCES public.phone(id) NOT VALID;


--
-- TOC entry 3502 (class 2606 OID 17223)
-- Name: passwd_details passwd_details_post_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_post_foreign_key FOREIGN KEY (postal_address_id) REFERENCES public.address(id);


--
-- TOC entry 3503 (class 2606 OID 17228)
-- Name: passwd_details passwd_details_res_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_res_foreign_key FOREIGN KEY (residential_address_id) REFERENCES public.address(id);


--
-- TOC entry 3504 (class 2606 OID 17233)
-- Name: passwd_details passwd_details_sec_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_sec_phone_fkey FOREIGN KEY (secondary_phone_id) REFERENCES public.phone(id) NOT VALID;


--
-- TOC entry 3497 (class 2606 OID 17238)
-- Name: passwd passwd_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_group_fkey FOREIGN KEY (primary_group_id) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3498 (class 2606 OID 17243)
-- Name: passwd passwd_primary_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_primary_email_fkey FOREIGN KEY (email_id) REFERENCES public.email(id) NOT VALID;


--
-- TOC entry 3505 (class 2606 OID 17248)
-- Name: phones phones_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phones
    ADD CONSTRAINT phones_address_fkey FOREIGN KEY (address_id) REFERENCES public.address(id);


--
-- TOC entry 3506 (class 2606 OID 17253)
-- Name: phones phones_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phones
    ADD CONSTRAINT phones_phone_fkey FOREIGN KEY (phone_id) REFERENCES public.phone(id);


--
-- TOC entry 3494 (class 2606 OID 17258)
-- Name: pseudo_pages pseudo_pages_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT pseudo_pages_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3495 (class 2606 OID 17263)
-- Name: pseudo_pages pseudo_pages_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT pseudo_pages_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3483 (class 2606 OID 17268)
-- Name: links section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT section_fkey FOREIGN KEY (section_id) REFERENCES public.links_sections(id) ON UPDATE RESTRICT;


--
-- TOC entry 3474 (class 2606 OID 17273)
-- Name: secure secure_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.secure
    ADD CONSTRAINT secure_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id);


--
-- TOC entry 3475 (class 2606 OID 17278)
-- Name: secure secure_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.secure
    ADD CONSTRAINT secure_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id);


--
-- TOC entry 3705 (class 0 OID 0)
-- Dependencies: 3704
-- Name: DATABASE urls; Type: ACL; Schema: -; Owner: grizzlysmit
--

GRANT CONNECT ON DATABASE urls TO urluser;


--
-- TOC entry 3707 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 3708 (class 0 OID 0)
-- Dependencies: 966
-- Name: TYPE perm_set; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON TYPE public.perm_set TO urluser WITH GRANT OPTION;


--
-- TOC entry 3709 (class 0 OID 0)
-- Dependencies: 968
-- Name: TYPE perms; Type: ACL; Schema: public; Owner: grizzlysmit
--

REVOKE ALL ON TYPE public.perms FROM grizzlysmit;
GRANT ALL ON TYPE public.perms TO grizzlysmit WITH GRANT OPTION;
GRANT ALL ON TYPE public.perms TO urluser WITH GRANT OPTION;


--
-- TOC entry 3710 (class 0 OID 0)
-- Dependencies: 211
-- Name: SEQUENCE _group_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public._group_id_seq TO urluser;


--
-- TOC entry 3711 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE _group; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON TABLE public._group TO urluser;


--
-- TOC entry 3712 (class 0 OID 0)
-- Dependencies: 213
-- Name: SEQUENCE address_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.address_id_seq TO urluser;


--
-- TOC entry 3713 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE address; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.address TO urluser;


--
-- TOC entry 3714 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE addresses; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.addresses TO urluser;


--
-- TOC entry 3716 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE secure; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.secure TO urluser;


--
-- TOC entry 3717 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE alias; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias TO urluser;


--
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE alias_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.alias_id_seq TO urluser;


--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE links_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.links_id_seq TO urluser;


--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE links_sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.links_sections TO urluser;


--
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE alias_links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias_links TO urluser;


--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.links TO urluser;


--
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE alias_union_links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias_union_links TO urluser;


--
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE alias_union_links_sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias_union_links_sections TO urluser;


--
-- TOC entry 3726 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE aliases; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.aliases TO urluser;


--
-- TOC entry 3727 (class 0 OID 0)
-- Dependencies: 256
-- Name: SEQUENCE country_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.country_id_seq TO urluser;


--
-- TOC entry 3728 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE country; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.country TO urluser;


--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 258
-- Name: SEQUENCE country_regions_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.country_regions_id_seq TO urluser;


--
-- TOC entry 3730 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE country_regions; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.country_regions TO urluser;


--
-- TOC entry 3731 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.countries TO urluser;


--
-- TOC entry 3732 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE countries_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.countries_id_seq TO urluser;


--
-- TOC entry 3733 (class 0 OID 0)
-- Dependencies: 228
-- Name: SEQUENCE email_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.email_id_seq TO urluser;


--
-- TOC entry 3734 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE email; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.email TO urluser;


--
-- TOC entry 3735 (class 0 OID 0)
-- Dependencies: 230
-- Name: SEQUENCE emails_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.emails_id_seq TO urluser;


--
-- TOC entry 3736 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE emails; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.emails TO urluser;


--
-- TOC entry 3737 (class 0 OID 0)
-- Dependencies: 232
-- Name: SEQUENCE groups_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.groups_id_seq TO urluser;


--
-- TOC entry 3738 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE groups; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.groups TO urluser;


--
-- TOC entry 3740 (class 0 OID 0)
-- Dependencies: 234
-- Name: SEQUENCE links_id_seq1; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.links_id_seq1 TO urluser;


--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE links_sections_join_links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.links_sections_join_links TO urluser;


--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE page_section; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_section TO urluser;


--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE pages; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pages TO urluser;


--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE page_link_view; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_link_view TO urluser;


--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE pseudo_pages; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pseudo_pages TO urluser;


--
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 262
-- Name: TABLE page_pseudo_link_view; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_pseudo_link_view TO urluser;


--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 239
-- Name: SEQUENCE page_section_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.page_section_id_seq TO urluser;


--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE page_view; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_view TO urluser;


--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE pagelike; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pagelike TO urluser;


--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 243
-- Name: SEQUENCE pages_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.pages_id_seq TO urluser;


--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 244
-- Name: SEQUENCE passwd_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.passwd_id_seq TO urluser;


--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE passwd; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.passwd TO urluser;


--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 246
-- Name: SEQUENCE passwd_details_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.passwd_details_id_seq TO urluser;


--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE passwd_details; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.passwd_details TO urluser;


--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 248
-- Name: SEQUENCE phone_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.phone_id_seq TO urluser;


--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE phone; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.phone TO urluser;


--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 250
-- Name: SEQUENCE phones_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.phones_id_seq TO urluser;


--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE phones; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.phones TO urluser;


--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 261
-- Name: TABLE pseudo_page_link_view; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pseudo_page_link_view TO urluser;


--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 252
-- Name: SEQUENCE psudo_pages_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.psudo_pages_id_seq TO urluser;


--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.sections TO urluser;


--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE sessions; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.sessions TO urluser;


--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE vlinks; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.vlinks TO urluser;


--
-- TOC entry 2182 (class 826 OID 17283)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: grizzlysmit
--

ALTER DEFAULT PRIVILEGES FOR ROLE grizzlysmit GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLES TO urluser;


-- Completed on 2024-08-24 17:53:16 AEST

--
-- PostgreSQL database dump complete
--

-- Completed on 2024-08-24 17:53:16 AEST

--
-- PostgreSQL database cluster dump complete
--

