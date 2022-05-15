--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Ubuntu 14.2-1ubuntu1)
-- Dumped by pg_dump version 14.2 (Ubuntu 14.2-1.pgdg21.10+1)

-- Started on 2022-05-15 23:47:19 AEST

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

ALTER TABLE ONLY public.secure DROP CONSTRAINT secure_userid_fkey;
ALTER TABLE ONLY public.secure DROP CONSTRAINT secure_groupid_fkey;
ALTER TABLE ONLY public.links DROP CONSTRAINT section_fkey;
ALTER TABLE ONLY public.pseudo_pages DROP CONSTRAINT pseudo_pages_userid_fkey;
ALTER TABLE ONLY public.pseudo_pages DROP CONSTRAINT pseudo_pages_groupid_fkey;
ALTER TABLE ONLY public.phones DROP CONSTRAINT phones_phone_fkey;
ALTER TABLE ONLY public.phones DROP CONSTRAINT phones_address_fkey;
ALTER TABLE ONLY public.passwd DROP CONSTRAINT passwd_primary_email_fkey;
ALTER TABLE ONLY public.passwd DROP CONSTRAINT passwd_group_fkey;
ALTER TABLE ONLY public.passwd_details DROP CONSTRAINT passwd_details_sec_phone_fkey;
ALTER TABLE ONLY public.passwd_details DROP CONSTRAINT passwd_details_res_foreign_key;
ALTER TABLE ONLY public.passwd_details DROP CONSTRAINT passwd_details_post_foreign_key;
ALTER TABLE ONLY public.passwd_details DROP CONSTRAINT passwd_details_p_phone_fkey;
ALTER TABLE ONLY public.passwd DROP CONSTRAINT passwd_details_connection_fkey;
ALTER TABLE ONLY public.passwd_details DROP CONSTRAINT passwd_details_cc_fkey;
ALTER TABLE ONLY public.pages DROP CONSTRAINT pages_userid_fkey;
ALTER TABLE ONLY public.pages DROP CONSTRAINT pages_groupid_fkey;
ALTER TABLE ONLY public.page_section DROP CONSTRAINT pages_fkey;
ALTER TABLE ONLY public.page_section DROP CONSTRAINT page_section_userid_fkey;
ALTER TABLE ONLY public.page_section DROP CONSTRAINT page_section_groupid_fkey;
ALTER TABLE ONLY public.links DROP CONSTRAINT links_userid_fkey;
ALTER TABLE ONLY public.links_sections DROP CONSTRAINT links_sections_userid_fkey;
ALTER TABLE ONLY public.links_sections DROP CONSTRAINT links_sections_groupid_fkey;
ALTER TABLE ONLY public.page_section DROP CONSTRAINT links_section_fkey;
ALTER TABLE ONLY public.links DROP CONSTRAINT links_groupid_fkey;
ALTER TABLE ONLY public.groups DROP CONSTRAINT groups_foreign_key;
ALTER TABLE ONLY public.groups DROP CONSTRAINT groups_address_foreign_key;
ALTER TABLE ONLY public.emails DROP CONSTRAINT emails_email_fkey;
ALTER TABLE ONLY public.emails DROP CONSTRAINT emails_address_fkey;
ALTER TABLE ONLY public.alias DROP CONSTRAINT alias_userid_fkey;
ALTER TABLE ONLY public.alias DROP CONSTRAINT alias_groupid_fkey;
ALTER TABLE ONLY public.alias DROP CONSTRAINT alias_foriegn_key;
DROP INDEX public.links_unique_key;
DROP INDEX public.links_sections_unique_key;
DROP INDEX public.fki_section_fkey;
ALTER TABLE ONLY public.sessions DROP CONSTRAINT sessions_pkey;
ALTER TABLE ONLY public.pseudo_pages DROP CONSTRAINT psudo_pages_pkey;
ALTER TABLE ONLY public.page_section DROP CONSTRAINT psge_section_pkey;
ALTER TABLE ONLY public.pseudo_pages DROP CONSTRAINT pseudo_pages_unique_key;
ALTER TABLE ONLY public.pages DROP CONSTRAINT pkey;
ALTER TABLE ONLY public.phones DROP CONSTRAINT phones_pkey;
ALTER TABLE ONLY public.phone DROP CONSTRAINT phone_pkey;
ALTER TABLE ONLY public.passwd DROP CONSTRAINT passwd_unique_key;
ALTER TABLE ONLY public.passwd DROP CONSTRAINT passwd_pkey;
ALTER TABLE ONLY public.passwd_details DROP CONSTRAINT passwd_details_pkey;
ALTER TABLE ONLY public.pages DROP CONSTRAINT page_unique_key;
ALTER TABLE ONLY public.page_section DROP CONSTRAINT page_section_unique;
ALTER TABLE ONLY public.links DROP CONSTRAINT links_unique_contraint_name;
ALTER TABLE ONLY public.links_sections DROP CONSTRAINT links_sections_unnique_key;
ALTER TABLE ONLY public.links DROP CONSTRAINT links_pkey1;
ALTER TABLE ONLY public.links_sections DROP CONSTRAINT links_pkey;
ALTER TABLE ONLY public.groups DROP CONSTRAINT groups_unique_key;
ALTER TABLE ONLY public.groups DROP CONSTRAINT groups_pkey;
ALTER TABLE ONLY public._group DROP CONSTRAINT group_unique_key;
ALTER TABLE ONLY public.emails DROP CONSTRAINT emails_pkey;
ALTER TABLE ONLY public.email DROP CONSTRAINT email_pkey;
ALTER TABLE ONLY public.countries DROP CONSTRAINT countries_prefix_ukey;
ALTER TABLE ONLY public.countries DROP CONSTRAINT countries_pk;
ALTER TABLE ONLY public.codes_prefixes DROP CONSTRAINT codes_prefixes_pk;
ALTER TABLE ONLY public.alias DROP CONSTRAINT alias_unique_contraint_name;
ALTER TABLE ONLY public.alias DROP CONSTRAINT alias_pkey;
ALTER TABLE ONLY public.address DROP CONSTRAINT address_pkey;
ALTER TABLE ONLY public._group DROP CONSTRAINT _group_pkey;
ALTER TABLE public.pseudo_pages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.pages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.page_section ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.links ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.countries ALTER COLUMN id DROP DEFAULT;
ALTER TABLE public.alias ALTER COLUMN id DROP DEFAULT;
DROP VIEW public.vlinks;
DROP TABLE public.sessions;
DROP VIEW public.sections;
DROP SEQUENCE public.psudo_pages_id_seq;
DROP TABLE public.phones;
DROP SEQUENCE public.phones_id_seq;
DROP TABLE public.phone;
DROP SEQUENCE public.phone_id_seq;
DROP TABLE public.passwd_details;
DROP SEQUENCE public.passwd_details_id_seq;
DROP TABLE public.passwd;
DROP SEQUENCE public.passwd_id_seq;
DROP SEQUENCE public.pages_id_seq;
DROP VIEW public.pagelike;
DROP TABLE public.pseudo_pages;
DROP VIEW public.page_view;
DROP SEQUENCE public.page_section_id_seq;
DROP VIEW public.page_link_view;
DROP TABLE public.pages;
DROP TABLE public.page_section;
DROP VIEW public.links_sections_join_links;
DROP SEQUENCE public.links_id_seq1;
DROP TABLE public.groups;
DROP SEQUENCE public.groups_id_seq;
DROP TABLE public.emails;
DROP SEQUENCE public.emails_id_seq;
DROP TABLE public.email;
DROP SEQUENCE public.email_id_seq;
DROP SEQUENCE public.countries_id_seq;
DROP TABLE public.countries;
DROP TABLE public.codes_prefixes;
DROP VIEW public.aliases;
DROP VIEW public.alias_union_links_sections;
DROP VIEW public.alias_union_links;
DROP TABLE public.links;
DROP VIEW public.alias_links;
DROP TABLE public.links_sections;
DROP SEQUENCE public.links_id_seq;
DROP SEQUENCE public.alias_id_seq;
DROP TABLE public.alias;
DROP TABLE public.secure;
DROP TABLE public.address;
DROP SEQUENCE public.address_id_seq;
DROP TABLE public._group;
DROP SEQUENCE public._group_id_seq;
DROP TYPE public.status;
DROP TYPE public.perms;
DROP TYPE public.perm_set;
--
-- TOC entry 962 (class 1247 OID 16390)
-- Name: perm_set; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE public.perm_set AS (
	_read boolean,
	_write boolean,
	_del boolean
);


ALTER TYPE public.perm_set OWNER TO grizzlysmit;

--
-- TOC entry 963 (class 1247 OID 16393)
-- Name: perms; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE public.perms AS (
	_user public.perm_set,
	_group public.perm_set,
	_other public.perm_set
);


ALTER TYPE public.perms OWNER TO grizzlysmit;

--
-- TOC entry 872 (class 1247 OID 16395)
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
-- TOC entry 211 (class 1259 OID 16403)
-- Name: _group_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public._group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public._group_id_seq OWNER TO grizzlysmit;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 212 (class 1259 OID 16404)
-- Name: _group; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public._group (
    id bigint DEFAULT nextval('public._group_id_seq'::regclass) NOT NULL,
    _name character varying(256) NOT NULL
);


ALTER TABLE public._group OWNER TO grizzlysmit;

--
-- TOC entry 213 (class 1259 OID 16408)
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.address_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 214 (class 1259 OID 16409)
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
-- TOC entry 215 (class 1259 OID 16415)
-- Name: secure; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.secure (
    userid bigint DEFAULT 1 NOT NULL,
    groupid bigint DEFAULT 1 NOT NULL,
    _perms public.perms DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)) NOT NULL
);


ALTER TABLE public.secure OWNER TO grizzlysmit;

--
-- TOC entry 216 (class 1259 OID 16423)
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
-- TOC entry 217 (class 1259 OID 16431)
-- Name: alias_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.alias_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 3674 (class 0 OID 0)
-- Dependencies: 217
-- Name: alias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.alias_id_seq OWNED BY public.alias.id;


--
-- TOC entry 218 (class 1259 OID 16432)
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.links_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 219 (class 1259 OID 16433)
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
-- TOC entry 220 (class 1259 OID 16442)
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


ALTER TABLE public.alias_links OWNER TO grizzlysmit;

--
-- TOC entry 221 (class 1259 OID 16446)
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
-- TOC entry 222 (class 1259 OID 16454)
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


ALTER TABLE public.alias_union_links OWNER TO grizzlysmit;

--
-- TOC entry 223 (class 1259 OID 16459)
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


ALTER TABLE public.alias_union_links_sections OWNER TO grizzlysmit;

--
-- TOC entry 224 (class 1259 OID 16464)
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


ALTER TABLE public.aliases OWNER TO grizzlysmit;

--
-- TOC entry 225 (class 1259 OID 16468)
-- Name: codes_prefixes; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.codes_prefixes (
    prefix character varying(64) NOT NULL,
    cc character(2),
    _flag character varying(256)
);


ALTER TABLE public.codes_prefixes OWNER TO grizzlysmit;

--
-- TOC entry 226 (class 1259 OID 16471)
-- Name: countries; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    _name character varying(256) NOT NULL,
    _escape character(1),
    landline_pattern character varying(256),
    mobile_pattern character varying(256),
    landline_title character varying(256),
    mobile_title character varying(256),
    landline_placeholder character varying(128),
    mobile_placeholder character varying(128)
)
INHERITS (public.codes_prefixes);


ALTER TABLE public.countries OWNER TO grizzlysmit;

--
-- TOC entry 227 (class 1259 OID 16476)
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.countries_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 3685 (class 0 OID 0)
-- Dependencies: 227
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- TOC entry 228 (class 1259 OID 16477)
-- Name: email_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.email_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 229 (class 1259 OID 16478)
-- Name: email; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.email (
    id bigint DEFAULT nextval('public.email_id_seq'::regclass) NOT NULL,
    _email character varying(256) NOT NULL,
    verified boolean DEFAULT false NOT NULL
);


ALTER TABLE public.email OWNER TO grizzlysmit;

--
-- TOC entry 230 (class 1259 OID 16483)
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.emails_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.emails_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 231 (class 1259 OID 16484)
-- Name: emails; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.emails (
    id bigint DEFAULT nextval('public.emails_id_seq'::regclass) NOT NULL,
    email_id bigint NOT NULL,
    address_id bigint NOT NULL
);


ALTER TABLE public.emails OWNER TO grizzlysmit;

--
-- TOC entry 232 (class 1259 OID 16488)
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.groups_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 233 (class 1259 OID 16489)
-- Name: groups; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.groups (
    id bigint DEFAULT nextval('public.groups_id_seq'::regclass) NOT NULL,
    group_id bigint NOT NULL,
    passwd_id bigint NOT NULL
);


ALTER TABLE public.groups OWNER TO grizzlysmit;

--
-- TOC entry 234 (class 1259 OID 16493)
-- Name: links_id_seq1; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.links_id_seq1
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.links_id_seq1 OWNER TO grizzlysmit;

--
-- TOC entry 3692 (class 0 OID 0)
-- Dependencies: 234
-- Name: links_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.links_id_seq1 OWNED BY public.links.id;


--
-- TOC entry 235 (class 1259 OID 16494)
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


ALTER TABLE public.links_sections_join_links OWNER TO grizzlysmit;

--
-- TOC entry 236 (class 1259 OID 16498)
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
-- TOC entry 237 (class 1259 OID 16506)
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
-- TOC entry 238 (class 1259 OID 16514)
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


ALTER TABLE public.page_link_view OWNER TO grizzlysmit;

--
-- TOC entry 239 (class 1259 OID 16519)
-- Name: page_section_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.page_section_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.page_section_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 3698 (class 0 OID 0)
-- Dependencies: 239
-- Name: page_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.page_section_id_seq OWNED BY public.page_section.id;


--
-- TOC entry 240 (class 1259 OID 16520)
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


ALTER TABLE public.page_view OWNER TO grizzlysmit;

--
-- TOC entry 241 (class 1259 OID 16524)
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
-- TOC entry 242 (class 1259 OID 16533)
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


ALTER TABLE public.pagelike OWNER TO grizzlysmit;

--
-- TOC entry 243 (class 1259 OID 16537)
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.pages_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 3703 (class 0 OID 0)
-- Dependencies: 243
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- TOC entry 244 (class 1259 OID 16538)
-- Name: passwd_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.passwd_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.passwd_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 245 (class 1259 OID 16539)
-- Name: passwd; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.passwd (
    id bigint DEFAULT nextval('public.passwd_id_seq'::regclass) NOT NULL,
    username character varying(100) NOT NULL,
    _password character varying(144),
    passwd_details_id bigint NOT NULL,
    primary_group_id bigint NOT NULL,
    _admin boolean DEFAULT false NOT NULL,
    email_id bigint NOT NULL
);


ALTER TABLE public.passwd OWNER TO grizzlysmit;

--
-- TOC entry 246 (class 1259 OID 16544)
-- Name: passwd_details_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.passwd_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.passwd_details_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 247 (class 1259 OID 16545)
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
    countries_id bigint DEFAULT 2 NOT NULL
);


ALTER TABLE public.passwd_details OWNER TO grizzlysmit;

--
-- TOC entry 248 (class 1259 OID 16551)
-- Name: phone_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.phone_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phone_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 249 (class 1259 OID 16552)
-- Name: phone; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.phone (
    id bigint DEFAULT nextval('public.phone_id_seq'::regclass) NOT NULL,
    _number character varying(128) NOT NULL,
    verified boolean DEFAULT false NOT NULL
);


ALTER TABLE public.phone OWNER TO grizzlysmit;

--
-- TOC entry 250 (class 1259 OID 16557)
-- Name: phones_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.phones_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.phones_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 251 (class 1259 OID 16558)
-- Name: phones; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.phones (
    id bigint DEFAULT nextval('public.phones_id_seq'::regclass) NOT NULL,
    phone_id bigint NOT NULL,
    address_id bigint NOT NULL
);


ALTER TABLE public.phones OWNER TO grizzlysmit;

--
-- TOC entry 252 (class 1259 OID 16562)
-- Name: psudo_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.psudo_pages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.psudo_pages_id_seq OWNER TO grizzlysmit;

--
-- TOC entry 3713 (class 0 OID 0)
-- Dependencies: 252
-- Name: psudo_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.psudo_pages_id_seq OWNED BY public.pseudo_pages.id;


--
-- TOC entry 253 (class 1259 OID 16563)
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


ALTER TABLE public.sections OWNER TO grizzlysmit;

--
-- TOC entry 254 (class 1259 OID 16568)
-- Name: sessions; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.sessions (
    id character(32) NOT NULL,
    a_session text
);


ALTER TABLE public.sessions OWNER TO grizzlysmit;

--
-- TOC entry 255 (class 1259 OID 16573)
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


ALTER TABLE public.vlinks OWNER TO grizzlysmit;

--
-- TOC entry 3352 (class 2604 OID 16577)
-- Name: alias id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias ALTER COLUMN id SET DEFAULT nextval('public.alias_id_seq'::regclass);


--
-- TOC entry 3361 (class 2604 OID 16578)
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- TOC entry 3360 (class 2604 OID 16579)
-- Name: links id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links ALTER COLUMN id SET DEFAULT nextval('public.links_id_seq1'::regclass);


--
-- TOC entry 3369 (class 2604 OID 16580)
-- Name: page_section id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section ALTER COLUMN id SET DEFAULT nextval('public.page_section_id_seq'::regclass);


--
-- TOC entry 3373 (class 2604 OID 16581)
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- TOC entry 3378 (class 2604 OID 16582)
-- Name: pseudo_pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages ALTER COLUMN id SET DEFAULT nextval('public.psudo_pages_id_seq'::regclass);


--
-- TOC entry 3627 (class 0 OID 16404)
-- Dependencies: 212
-- Data for Name: _group; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public._group VALUES (1, 'admin');
INSERT INTO public._group VALUES (8, 'frodo');
INSERT INTO public._group VALUES (5, 'grizz');
INSERT INTO public._group VALUES (3, 'grizzlysmit');
INSERT INTO public._group VALUES (4, 'grizzly');


--
-- TOC entry 3629 (class 0 OID 16409)
-- Dependencies: 214
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.address VALUES (1, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO public.address VALUES (2, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO public.address VALUES (3, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO public.address VALUES (10, '', 'Baggsend', 'hobbiton', '', 'the shire', 'LOTR');
INSERT INTO public.address VALUES (7, '2', '76-84 Karne Street north', 'Riverwood', '2209', 'NSW', 'Australia');
INSERT INTO public.address VALUES (6, '2', '76-84 Karne Street north', 'Narwee', '2210', 'NSW', 'Australia');
INSERT INTO public.address VALUES (4, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO public.address VALUES (5, '2', '76-84 Karnee Street north', 'Riveerwood', '2210', 'NSW', 'Australia');


--
-- TOC entry 3631 (class 0 OID 16423)
-- Dependencies: 216
-- Data for Name: alias; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 'stor', 15);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 'bronze', 9);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 'store', 15);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 'knck-dev', 23);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 'knck', 16);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 'knock-dev', 23);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 'cpp', 24);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 'CPP', 24);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 'c++', 24);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 'proc', 21);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 'dir', 18);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 'out', 7);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 'api.q', 19);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 'api_u', 13);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 'API_U', 13);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 'in', 5);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 'tool', 12);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 'fred', 22);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 22, 'pk', 16);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 23, 'add', 4);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 25, 'perl6', 27);
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 26, 'pg', 34);


--
-- TOC entry 3636 (class 0 OID 16468)
-- Dependencies: 225
-- Data for Name: codes_prefixes; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3637 (class 0 OID 16471)
-- Dependencies: 226
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.countries VALUES ('+1340', 'VI', 8, 'United States Virgin Islands', NULL, '(?:\+?1[ -]?)?340[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?340[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1340-234-1234 or 1340 234 1234 or 340-234-1234.', 'Only +digits or local formats allowed i.e. +1340-234-1234 or 1340 234 1234 or 240-234-1234.', '+1-340-234-1234|1 340 234 1234|340 234 1234', '+1-340-234-1234|1 340 234 1234|340 234 1234', '/flags/VI.png');
INSERT INTO public.countries VALUES ('+1345', 'KY', 9, 'Cayman Islands', NULL, '(?:\+?1[ -]?)?345[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?345[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1345-234-1234 or 1345 234 1234 or 345-234-1234.', 'Only +digits or local formats allowed i.e. +1345-234-1234 or 1345 234 1234 or 245-234-1234.', '+1-345-234-1234|1 345 234 1234|345 234 1234', '+1-345-234-1234|1 345 234 1234|345 234 1234', '/flags/KY.png');
INSERT INTO public.countries VALUES ('+1242', 'BS', 1, 'The Bahamas', NULL, '(?:\+?1[ -]?)?242[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?242[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1242-234-1234 or 1242 234 1234 or 242-234-1234.', 'Only +digits or local formats allowed i.e. +1242-234-1234 or 1242 234 1234 or 242-234-1234.', '+1-242-234-1234|1 242 234 1234|242 234 1234', '+1-242-234-1234|1 242 234 1234|242 234 1234', '/flags/BS.png');
INSERT INTO public.countries VALUES ('+61', 'AU', 2, 'Australia', '0', '(?:(?:\+61[ -]?\d|0\d|\(0\d\)|0\d)[ -]?)?\d{4}[ -]?\d{4}', '(?:\+61|0)?\d{3}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +612-9567-2876 or (02) 9567 2876 or 0295672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+612-9567-2876|(02) 9567 2876|0295672876', '+61438-567-876|0438 567 876|0438567876', '/flags/AU.png');
INSERT INTO public.countries VALUES ('+1246', 'BB', 3, 'Barbados', NULL, '(?:\+?1[ -]?)?246[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?246[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1246-234-1234 or 1246 234 1234 or 246-234-1234.', 'Only +digits or local formats allowed i.e. +1246-234-1234 or 1246 234 1234 or 246-234-1234.', '+1-246-234-1234|1 242 234 1234|242 234 1234', '+1-246-234-1234|1 246 234 1234|246 234 1234', '/flags/BB.png');
INSERT INTO public.countries VALUES ('+1284', 'VG', 6, 'British Virgin Islands', NULL, '(?:\+?1[ -]?)?284[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?284[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1284-234-1234 or 1284 234 1234 or 284-234-1234.', 'Only +digits or local formats allowed i.e. +1284-234-1234 or 1284 234 1234 or 284-234-1234.', '+1-248-234-1234|1 248 234 1234|248 234 1234', '+1-284-234-1234|1 284 234 1234|284 234 1234', '/flags/VG.png');
INSERT INTO public.countries VALUES ('+1268', 'AG', 5, 'Antigua and Barbuda', NULL, '(?:\+?1[ -]?)?268[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?268[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1268-234-1234 or 1268 234 1234 or 268-234-1234.', 'Only +digits or local formats allowed i.e. +1268-234-1234 or 1248 234 1234 or 248-234-1234.', '+1-248-234-1234|1 248 234 1234|248 234 1234', '+1-248-234-1234|1 248 234 1234|248 234 1234', '/flags/AG.png');
INSERT INTO public.countries VALUES ('+1264', 'AI', 4, 'Anguilla', NULL, '(?:\+?1[ -]?)?264[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?264[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1264-234-1234 or 1264 234 1234 or 264-234-1234.', 'Only +digits or local formats allowed i.e. +1264-234-1234 or 1246 234 1234 or 246-234-1234.', '+1-246-234-1234|1 242 234 1234|242 234 1234', '+1-246-234-1234|1 246 234 1234|246 234 1234', '/flags/AI.png');
INSERT INTO public.countries VALUES ('+1441', 'BM', 10, 'Bermuda', NULL, '(?:\+?1[ -]?)?441[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?441[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1441-234-1234 or 1441 234 1234 or 441-234-1234.', 'Only +digits or local formats allowed i.e. +1441-234-1234 or 1441 234 1234 or 441-234-1234.', '+1-441-234-1234|1 441 234 1234|441 234 1234', '+1-441-234-1234|1 441 234 1234|441 234 1234', '/flags/BM.png');
INSERT INTO public.countries VALUES ('+1473', 'GD', 11, 'Grenada', NULL, '(?:\+?1[ -]?)?473[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?473[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1473-234-1234 or 1473 234 1234 or 473-234-1234.', 'Only +digits or local formats allowed i.e. +1473-234-1234 or 1473 234 1234 or 473-234-1234.', '+1-473-234-1234|1 473 234 1234|473 234 1234', '+1-473-234-1234|1 473 234 1234|473 234 1234', '/flags/GD.png');
INSERT INTO public.countries VALUES ('+1649', 'TC', 12, 'Turks and Caicos Islands', NULL, '(?:\+?1[ -]?)?649[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?649[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +16439-234-1234 or 1649 234 1234 or 649-234-1234.', 'Only +digits or local formats allowed i.e. +1649-234-1234 or 1649 234 1234 or 649-234-1234.', '+1-649-234-1234|1 649 234 1234|649 234 1234', '+1-649-234-1234|1 649 234 1234|649 234 1234', '/flags/TC.png');
INSERT INTO public.countries VALUES ('+1658', 'JM', 13, 'Jamaica', NULL, '(?:\+?1[ -]?)?658[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:1[ -]?)?658[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1658-234-1234 or 1658 234 1234 or 658-234-1234.', 'Only +digits or local formats allowed i.e. +1658-234-1234 or 1658 234 1234 or 658-234-1234.', '+1-658-234-1234|1 658 234 1234|658 234 1234', '+1-658-234-1234|1 658 234 1234|658 234 1234', '/flags/JM.png');


--
-- TOC entry 3640 (class 0 OID 16478)
-- Dependencies: 229
-- Data for Name: email; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.email VALUES (1, 'grizzly@smit.id.au', false);
INSERT INTO public.email VALUES (7, 'frodo@tolkien.com', false);
INSERT INTO public.email VALUES (4, 'grizzly@smit.id.au', false);
INSERT INTO public.email VALUES (2, 'grizzly@smit.id.au', false);
INSERT INTO public.email VALUES (3, 'grizzly@smit.id.au', false);


--
-- TOC entry 3642 (class 0 OID 16484)
-- Dependencies: 231
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3644 (class 0 OID 16489)
-- Dependencies: 233
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.groups VALUES (1, 4, 2);
INSERT INTO public.groups VALUES (3, 1, 2);
INSERT INTO public.groups VALUES (8, 5, 2);
INSERT INTO public.groups VALUES (9, 3, 3);
INSERT INTO public.groups VALUES (10, 1, 3);


--
-- TOC entry 3635 (class 0 OID 16446)
-- Dependencies: 221
-- Data for Name: links; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 1, 'https://version.oztell.com.au/anycast/dl.88.io', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 1, 'https://version.oztell.com.au/anycast/dl.88.io/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 3, 'https://vault.net2maxlabs.net/net2max1/wp-admin/post.php?post=48209&action=edit', 'edit-docs');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 3, 'https://vault.net2maxlabs.net/net2max1/location-grid/', 'view-docs');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 5, 'https://version.contacttrace.com.au/contact0/input/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 5, 'https://version.contacttrace.com.au/contact0/input', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 5, 'https://version.contacttrace.com.au/contact0/input/-pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 6, 'https://version.contacttrace.com.au/contact0/app/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 6, 'https://version.contacttrace.com.au/contact0/app/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 6, 'https://version.contacttrace.com.au/contact0/app/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 17, 7, 'https://version.contacttrace.com.au/contact0/output/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 18, 7, 'https://version.contacttrace.com.au/contact0/output/-scripts/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 7, 'https://version.contacttrace.com.au/contact0/output/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 8, 'https://vault.net2maxlabs.net/net2max1/business-identity-check/', 'view-docs');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 8, 'https://vault.net2maxlabs.net/net2max1/wp-admin/post.php?post=51576&action=edit', 'edit-docs');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 76, 34, 'https://www.postgresql.org/docs/', 'docs');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 77, 36, 'https://php.net', 'main');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 78, 36, 'https://www.php.net/manual/en/', 'docs-en');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 79, 36, 'https://www.php.net/manual/en/langref.php', 'lang');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 80, 36, 'https://www.php.net/manual/en/security.php', 'security');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 81, 36, 'https://www.php.net/manual/en/funcref.php', 'funs');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 82, 36, 'https://www.php.net/manual/en/faq.php', 'faq');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 83, 36, 'https://www.php.net/manual/en/appendices.php', 'apendices');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 84, 36, 'https://www.php.net/manual/en/features.php', 'features');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 99, 34, 'https://www.postgresql.org/', 'main');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 22, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/-/blob/prod/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 23, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 24, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 25, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 26, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 27, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 28, 11, 'https://chat.quuvoo4ohcequuox.0.88.io/home', 'chat');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 29, 12, 'https://version.oztell.com.au/88io0/tools/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 31, 12, 'https://version.oztell.com.au/88io0/tools/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 32, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 33, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 34, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 35, 14, 'https://vault.net2maxlabs.net/net2max1/business-identity-check/', 'namecheck');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 36, 14, 'https://vault.net2maxlabs.net/net2max1/location-grid/', 'map');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 37, 15, 'https://version.contacttrace.com.au/contact0/storage/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 38, 15, 'https://version.contacttrace.com.au/contact0/storage/-/pipelines', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 39, 15, 'https://version.contacttrace.com.au/contact0/storage/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 40, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 41, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 42, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 43, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 44, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 45, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 46, 18, 'https://version.contacttrace.com.au/contact0/directory/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 47, 18, 'https://version.contacttrace.com.au/contact0/directory/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 48, 18, 'https://version.contacttrace.com.au/contact0/directory/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 49, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 50, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io/-/blob/prod/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 51, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 52, 20, 'https://version.oztell.com.au/oztell8/api', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 53, 21, 'https://version.contacttrace.com.au/contact0/processor/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 54, 21, 'https://version.contacttrace.com.au/contact0/processor', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 55, 21, 'https://version.contacttrace.com.au/contact0/processor/-/blob/dev/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 56, 22, 'https://ledger.contacttrace.com.au/?chain=0-s1-dev', '0-s1-dev');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 57, 22, 'https://ledger.contacttrace.com.au/', 'launch-page');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 58, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/-/blob/prod/README.md', 'readme');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 59, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/', 'gitlab');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 60, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/-/pipelines/', 'pipeline');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 61, 24, 'https://isocpp.org/', 'iso');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 62, 24, 'https://en.cppreference.com/w/', 'cppref');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 63, 24, 'https://www.modernescpp.com/index.php', 'modernescpp');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 69, 27, 'https://raku.org/', 'main');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 70, 27, 'https://modules.raku.org/', 'modules');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 71, 27, 'https://docs.raku.org/', 'docs');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 72, 27, 'https://docs.raku.org/language.html', 'lang');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 73, 27, 'https://docs.raku.org/type.html', 'types');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 74, 27, 'https://web.libera.chat/?channel=#raku', 'chat');
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 100, 34, 'https://www.postgresql.org/account', 'account');


--
-- TOC entry 3634 (class 0 OID 16433)
-- Dependencies: 219
-- Data for Name: links_sections; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 'dl.88.io');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 'key');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 'location-grid-old-docs');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 'address');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 'input');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 'app');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 'output');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 'business-identity-check');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 'bronze-aus');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 'signature');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 'chat.q');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 'tools');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 'api_ugh8eika');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 'oldocs');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 'storage');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 'portknocking');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 17, 'scripts');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 18, 'directory');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 'api.quuvoo4ohcequuox.0.88.io');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 'api');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 'processor');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 22, 'blockchains');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 23, 'portknocking-dev');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 24, 'C++');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 27, 'raku');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 34, 'postgres');
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 36, 'php');


--
-- TOC entry 3646 (class 0 OID 16498)
-- Dependencies: 236
-- Data for Name: page_section; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.page_section VALUES (4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")', 80, 39, 24);
INSERT INTO public.page_section VALUES (4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")', 81, 39, 27);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 1, 12);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 1, 20);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 3, 16);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 3, 23);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 5, 19);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 5, 1);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 7, 15);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 7, 21);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 7, 17);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 7, 16);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 7, 4);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 7, 10);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 7, 9);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 7, 13);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 7, 5);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 7, 18);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 17, 7, 7);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 18, 7, 6);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 7, 2);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 20, 3);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 20, 14);
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 78, 37, 1);


--
-- TOC entry 3647 (class 0 OID 16506)
-- Dependencies: 237
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 'oztell.com.au', 'oztell.com.au stuff');
INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 'knock', 'port knocking');
INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 'contacttrace', 'contacttrace');
INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 'docsold', 'The Old Docs');
INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, '88.io', '88.io stuff');
INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 37, 'apk', 'where the apks are');
INSERT INTO public.pages VALUES (4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")', 39, 'grizz-page', 'Grizzs Page');


--
-- TOC entry 3652 (class 0 OID 16539)
-- Dependencies: 245
-- Data for Name: passwd; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.passwd VALUES (1, 'admin', '{X-PBKDF2}HMACSHA2+512:AAAIAA:1j44CmP4SfwiYFHyQSJ+NA==:N2xeXHLH5MLnAq3hAAFgPscGSbkZu9bvvN6pgnNPkUeX3c1pzzI+NnxtyITUf0sZ1fd23G3MDFgA/aoLmHf0aQ==', 1, 1, true, 1);
INSERT INTO public.passwd VALUES (7, 'frodo', '{X-PBKDF2}HMACSHA2+512:AAAIAA:L8niz4XzsghhSbcrOSDRHA==:MbAm1ydlPeqD2gIBVdvNOS9iLJwN55p59wXHZh28BdbMIl3Zu5zj0ysFmDzGiv4f/jA4zc/9FsUTQAQD64MjUQ==', 7, 8, false, 7);
INSERT INTO public.passwd VALUES (4, 'grizz', '{X-PBKDF2}HMACSHA2+512:AAAIAA:zWeWVTYpvU2EsxbD6fjNIw==:sdYmcRwOLxC55Q/cCigfExdtT32EFH3vzTvV8IaYVkjNo4Svo8A9FumS1Wu8Dpu7ca2W+uFcX7ZEA5zilPK3vg==', 4, 5, false, 4);
INSERT INTO public.passwd VALUES (2, 'grizzlysmit', '{X-PBKDF2}HMACSHA2+512:AAAIAA:205IxJhEjYkb5aOMExRFEA==:rk5nlRePO0bI4w1KOUPOyJADkCtBxpTd6goK9IGBc7fUu5otOvz+hXthcw41HH1DXSMB0qbicNJWpGC18wmUww==', 2, 3, true, 2);
INSERT INTO public.passwd VALUES (3, 'grizzly', '{X-PBKDF2}HMACSHA2+512:AAAIAA:Po+YOhfNSqvgJVkWfUJdoQ==:kA39+vz0F3/pIECA7Y2TuW1wLIPdal0WBv2LOWdkRCWci6GEcKdSu0NQ5wwsZuI4G0fsMBE83LIGvBiZJe0VcA==', 3, 4, true, 3);


--
-- TOC entry 3654 (class 0 OID 16545)
-- Dependencies: 247
-- Data for Name: passwd_details; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.passwd_details VALUES (1, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 3, 3, 1, NULL, 2);
INSERT INTO public.passwd_details VALUES (7, 'Frodo Baggins', 'Frodo', 'Baggins', 10, 10, NULL, NULL, 2);
INSERT INTO public.passwd_details VALUES (4, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 7, 6, 7, 10, 2);
INSERT INTO public.passwd_details VALUES (2, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 4, 4, 3, 9, 2);
INSERT INTO public.passwd_details VALUES (3, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 5, 5, 5, 11, 2);


--
-- TOC entry 3656 (class 0 OID 16552)
-- Dependencies: 249
-- Data for Name: phone; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.phone VALUES (1, '+61482176343', false);
INSERT INTO public.phone VALUES (2, '+612 9217 6004', false);
INSERT INTO public.phone VALUES (4, '+612 9217 6004', false);
INSERT INTO public.phone VALUES (6, '(02) 9217 6004', false);
INSERT INTO public.phone VALUES (8, '+612-9217-6004', false);
INSERT INTO public.phone VALUES (7, '+61482176343', false);
INSERT INTO public.phone VALUES (10, '+61292176004', false);
INSERT INTO public.phone VALUES (3, '+61482176343', false);
INSERT INTO public.phone VALUES (9, '+61292176004', false);
INSERT INTO public.phone VALUES (5, '+61482176343', false);
INSERT INTO public.phone VALUES (11, '+61292176004', false);


--
-- TOC entry 3658 (class 0 OID 16558)
-- Dependencies: 251
-- Data for Name: phones; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3649 (class 0 OID 16524)
-- Dependencies: 241
-- Data for Name: pseudo_pages; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.pseudo_pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, '.*', 'unassigned', 'misc', 'misc');
INSERT INTO public.pseudo_pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, '.*', 'both', 'all', 'all');
INSERT INTO public.pseudo_pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, '.*', 'assigned', 'already', 'already in pages');


--
-- TOC entry 3630 (class 0 OID 16415)
-- Dependencies: 215
-- Data for Name: secure; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3660 (class 0 OID 16568)
-- Dependencies: 254
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.sessions VALUES ('ccaf15a07783d52542704b543d8dc2b9', 'BQsDAAAAEBcLZ3JpenpseXNtaXQAAAARbG9nZ2VkaW5fdXNlcm5hbWUXFEZyYW5jaXMgR3Jpenps
eSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQoCMjUAAAALcGFnZV9sZW5ndGgIgAAAAA5s
b2dnZWRpbl9hZG1pbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXD0ZyYW5jaXMgR3JpenpseQAA
AA5sb2dnZWRpbl9naXZlbgoJbGlua3NeQysrAAAAD2N1cnJlbnRfc2VjdGlvbhcOKzYxNDgyIDE3
NiAzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9n
Z2VkaW5fZW1haWwKATAAAAAFZGVidWcIggAAAAhsb2dnZWRpbgoPcHNldWRvLXBhZ2VeYWxsAAAA
DGN1cnJlbnRfcGFnZQogY2NhZjE1YTA3NzgzZDUyNTQyNzA0YjU0M2Q4ZGMyYjkAAAALX3Nlc3Np
b25faWQIggAAAAtsb2dnZWRpbl9pZBcLZ3JpenpseXNtaXQAAAASbG9nZ2VkaW5fZ3JvdXBuYW1l
CIMAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZA==
');
INSERT INTO public.sessions VALUES ('068675cd502b8327e5dd27ef507aa3c0', 'BQsDAAAAEAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKCWxpbmtzXkMrKwAAAA9jdXJyZW50
X3NlY3Rpb24KATEAAAAFZGVidWcXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lCIEAAAALbG9n
Z2VkaW5faWQIgQAAAA5sb2dnZWRpbl9hZG1pbhcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9n
Z2VkaW5fZGlzcGxheV9uYW1lCIEAAAAIbG9nZ2VkaW4XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5s
b2dnZWRpbl9lbWFpbBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCgIyNQAAAAtw
YWdlX2xlbmd0aAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZRcMKzYxNDgyMTc2MzQz
AAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFwRT
bWl0AAAAD2xvZ2dlZGluX2ZhbWlseQogMDY4Njc1Y2Q1MDJiODMyN2U1ZGQyN2VmNTA3YWEzYzAA
AAALX3Nlc3Npb25faWQ=
');
INSERT INTO public.sessions VALUES ('dd658768b14194054d895bb6e64d5294', 'BQsDAAAAEAoObGlua3NecG9zdGdyZXMAAAAPY3VycmVudF9zZWN0aW9uFxRGcmFuY2lzIEdyaXp6
bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXC2dyaXp6bHlzbWl0AAAAEWxvZ2dlZGlu
X3VzZXJuYW1lFwtncml6emx5c21pdAAAABJsb2dnZWRpbl9ncm91cG5hbWUXD0ZyYW5jaXMgR3Jp
enpseQAAAA5sb2dnZWRpbl9naXZlbgogZGQ2NTg3NjhiMTQxOTQwNTRkODk1YmI2ZTY0ZDUyOTQA
AAALX3Nlc3Npb25faWQKAjI4AAAAC3BhZ2VfbGVuZ3RoFxJncml6emx5QHNtaXQuaWQuYXUAAAAO
bG9nZ2VkaW5fZW1haWwIgwAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkChBwc2V1ZG8tcGFnZV5t
aXNjAAAADGN1cnJlbnRfcGFnZQiBAAAADmxvZ2dlZGluX2FkbWluCIIAAAAIbG9nZ2VkaW4IggAA
AAtsb2dnZWRpbl9pZAoBMAAAAAVkZWJ1ZxcOKzYxNDgyIDE3NiAzNDMAAAAVbG9nZ2VkaW5fcGhv
bmVfbnVtYmVyFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQ==
');
INSERT INTO public.sessions VALUES ('498b2cd3b6da04091d39c89f9190ecbe', 'BQsDAAAABQogNDk4YjJjZDNiNmRhMDQwOTFkMzljODlmOTE5MGVjYmUAAAALX3Nlc3Npb25faWQK
D3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKAjIzAAAAC3BhZ2VfbGVuZ3RoCglsaW5r
c15DKysAAAAPY3VycmVudF9zZWN0aW9uCgExAAAABWRlYnVn
');
INSERT INTO public.sessions VALUES ('d54a395a7e3d035b2eab35e3e1e3eddd', 'BQsDAAAAEAogZDU0YTM5NWE3ZTNkMDM1YjJlYWIzNWUzZTFlM2VkZGQAAAALX3Nlc3Npb25faWQX
Dis2MTQ4Mi0xNzYtMzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcFZ3JpenoAAAASbG9nZ2Vk
aW5fZ3JvdXBuYW1lFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25h
bWUXBWdyaXp6AAAAEWxvZ2dlZGluX3VzZXJuYW1lFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2Vk
aW5fZ2l2ZW4KD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UKAjI1AAAAC3BhZ2VfbGVu
Z3RoCIQAAAAIbG9nZ2VkaW4IhAAAAAtsb2dnZWRpbl9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1p
bHkXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbAiFAAAAFmxvZ2dlZGluX2dy
b3Vwbm5hbWVfaWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24IgAAAAA5sb2dnZWRp
bl9hZG1pbgoBMAAAAAVkZWJ1Zw==
');
INSERT INTO public.sessions VALUES ('88aa7cad761ab4c62664ab011059f338', 'BQsDAAAABQoKbGlua3NecmFrdQAAAA9jdXJyZW50X3NlY3Rpb24KD3BzZXVkby1wYWdlXmFsbAAA
AAxjdXJyZW50X3BhZ2UKAjQxAAAAC3BhZ2VfbGVuZ3RoCiA4OGFhN2NhZDc2MWFiNGM2MjY2NGFi
MDExMDU5ZjMzOAAAAAtfc2Vzc2lvbl9pZAoBMAAAAAVkZWJ1Zw==
');
INSERT INTO public.sessions VALUES ('a5d41456a83643e9445ceb8e1f8fe4d2', 'BQsDAAAABQoCMjgAAAALcGFnZV9sZW5ndGgKC2FsaWFzXnBlcmw2AAAAD2N1cnJlbnRfc2VjdGlv
bgoQcHNldWRvLXBhZ2VebWlzYwAAAAxjdXJyZW50X3BhZ2UKATAAAAAFZGVidWcKIGE1ZDQxNDU2
YTgzNjQzZTk0NDVjZWI4ZTFmOGZlNGQyAAAAC19zZXNzaW9uX2lk
');
INSERT INTO public.sessions VALUES ('e1b7ae146ea967338bc75bd9ecc4b4ae', 'BQsDAAAABQogZTFiN2FlMTQ2ZWE5NjczMzhiYzc1YmQ5ZWNjNGI0YWUAAAALX3Nlc3Npb25faWQK
ATEAAAAFZGVidWcKD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDmxpbmtzXnBvc3Rn
cmVzAAAAD2N1cnJlbnRfc2VjdGlvbgoCMzkAAAALcGFnZV9sZW5ndGg=
');
INSERT INTO public.sessions VALUES ('da64773d703775653f795947988a29cd', 'BQsDAAAAEAiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXC2dyaXp6bHlzbWl0AAAAEmxvZ2dl
ZGluX2dyb3VwbmFtZQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZRcPRnJhbmNpcyBH
cml6emx5AAAADmxvZ2dlZGluX2dpdmVuCIIAAAALbG9nZ2VkaW5faWQIgQAAAA5sb2dnZWRpbl9h
ZG1pbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKAjI1AAAAC3BhZ2VfbGVuZ3RoFxJncml6emx5
QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXDis2MTQ4MiAxNzYgMzQzAAAAFWxvZ2dlZGlu
X3Bob25lX251bWJlcgoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoBMAAAAAVkZWJ1
ZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABFsb2dnZWRpbl91c2VybmFtZQogZGE2NDc3
M2Q3MDM3NzU2NTNmNzk1OTQ3OTg4YTI5Y2QAAAALX3Nlc3Npb25faWQXFEZyYW5jaXMgR3Jpenps
eSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQ==
');
INSERT INTO public.sessions VALUES ('12d1122cc4eba147d70ae2097bb6e221', 'BQsDAAAAEBcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkIgwAAABZsb2dnZWRpbl9ncm91cG5uYW1l
X2lkCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uCg9wYWdlXmdyaXp6LXBhZ2UAAAAM
Y3VycmVudF9wYWdlFwtncml6emx5c21pdAAAABFsb2dnZWRpbl91c2VybmFtZQoCMjUAAAALcGFn
ZV9sZW5ndGgXC2dyaXp6bHlzbWl0AAAAEmxvZ2dlZGluX2dyb3VwbmFtZQoBMAAAAAVkZWJ1ZwiC
AAAACGxvZ2dlZGluFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25h
bWUXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIXEmdyaXp6bHlAc21pdC5p
ZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVu
CIEAAAAObG9nZ2VkaW5fYWRtaW4KIDEyZDExMjJjYzRlYmExNDdkNzBhZTIwOTdiYjZlMjIxAAAA
C19zZXNzaW9uX2lkCIIAAAALbG9nZ2VkaW5faWQ=
');
INSERT INTO public.sessions VALUES ('c8ab85ca784010747adb0aad5dcb6306', 'BQsDAAAAEAoBMAAAAAVkZWJ1ZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABJsb2dnZWRp
bl9ncm91cG5hbWUKAjI1AAAAC3BhZ2VfbGVuZ3RoFwtncml6emx5c21pdAAAABFsb2dnZWRpbl91
c2VybmFtZQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA
D2N1cnJlbnRfc2VjdGlvbgiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXBFNtaXQAAAAPbG9n
Z2VkaW5fZmFtaWx5CIIAAAALbG9nZ2VkaW5faWQKIGM4YWI4NWNhNzg0MDEwNzQ3YWRiMGFhZDVk
Y2I2MzA2AAAAC19zZXNzaW9uX2lkCIEAAAAObG9nZ2VkaW5fYWRtaW4XD0ZyYW5jaXMgR3Jpenps
eQAAAA5sb2dnZWRpbl9naXZlbhcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWls
FwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFxRGcmFuY2lzIEdyaXp6bHkg
U21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWU=
');
INSERT INTO public.sessions VALUES ('1c8659df2843a2096c728067be7b9e01', 'BQsDAAAAEAoBMQAAAAVkZWJ1ZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABJsb2dnZWRp
bl9ncm91cG5hbWUXC2dyaXp6bHlzbWl0AAAAEWxvZ2dlZGluX3VzZXJuYW1lCg9wc2V1ZG8tcGFn
ZV5hbGwAAAAMY3VycmVudF9wYWdlCgIyNQAAAAtwYWdlX2xlbmd0aBcEU21pdAAAAA9sb2dnZWRp
bl9mYW1pbHkKDWxpbmtzXnNjcmlwdHMAAAAPY3VycmVudF9zZWN0aW9uCIMAAAAWbG9nZ2VkaW5f
Z3JvdXBubmFtZV9pZAiCAAAAC2xvZ2dlZGluX2lkCiAxYzg2NTlkZjI4NDNhMjA5NmM3MjgwNjdi
ZTdiOWUwMQAAAAtfc2Vzc2lvbl9pZAiBAAAADmxvZ2dlZGluX2FkbWluFw9GcmFuY2lzIEdyaXp6
bHkAAAAObG9nZ2VkaW5fZ2l2ZW4XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFp
bBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lFw4rNjE0ODIg
MTc2IDM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXI=
');
INSERT INTO public.sessions VALUES ('6066c112263af0046fa9d0b23ca1b0b9', 'BQsDAAAAEBcLZ3JpenpseXNtaXQAAAARbG9nZ2VkaW5fdXNlcm5hbWUKIDYwNjZjMTEyMjYzYWYw
MDQ2ZmE5ZDBiMjNjYTFiMGI5AAAAC19zZXNzaW9uX2lkFxJncml6emx5QHNtaXQuaWQuYXUAAAAO
bG9nZ2VkaW5fZW1haWwIgQAAAA5sb2dnZWRpbl9hZG1pbgiZAAAAC3BhZ2VfbGVuZ3RoCg9wc2V1
ZG8tcGFnZV5hbGwAAAAMY3VycmVudF9wYWdlCIIAAAALbG9nZ2VkaW5faWQXC2dyaXp6bHlzbWl0
AAAAEmxvZ2dlZGluX2dyb3VwbmFtZRcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251
bWJlchcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCgEwAAAA
BWRlYnVnCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uFw9GcmFuY2lzIEdyaXp6bHkA
AAAObG9nZ2VkaW5fZ2l2ZW4IggAAAAhsb2dnZWRpbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkI
gwAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lk
');
INSERT INTO public.sessions VALUES ('9a075a2b3a3d0a15d9b2461d1011f0de', 'BQsDAAAAEAogOWEwNzVhMmIzYTNkMGExNWQ5YjI0NjFkMTAxMWYwZGUAAAALX3Nlc3Npb25faWQX
EmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcHZ3JpenpseQAAABFsb2dnZWRp
bl91c2VybmFtZQoCMjUAAAALcGFnZV9sZW5ndGgKD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50
X3BhZ2UIgQAAAA5sb2dnZWRpbl9hZG1pbhcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2Vk
aW5fZGlzcGxheV9uYW1lCgEwAAAABWRlYnVnCIMAAAALbG9nZ2VkaW5faWQXB2dyaXp6bHkAAAAS
bG9nZ2VkaW5fZ3JvdXBuYW1lFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVy
CIMAAAAIbG9nZ2VkaW4XBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5CIQAAAAWbG9nZ2VkaW5fZ3Jv
dXBubmFtZV9pZBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCgxhbGxfc2VjdGlv
bnMAAAAPY3VycmVudF9zZWN0aW9u
');


--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 211
-- Name: _group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public._group_id_seq', 8, true);


--
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 213
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.address_id_seq', 10, true);


--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 217
-- Name: alias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.alias_id_seq', 34, true);


--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 227
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.countries_id_seq', 13, true);


--
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 228
-- Name: email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.email_id_seq', 7, true);


--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 230
-- Name: emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.emails_id_seq', 1, false);


--
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 232
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.groups_id_seq', 10, true);


--
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 218
-- Name: links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.links_id_seq', 37, true);


--
-- TOC entry 3726 (class 0 OID 0)
-- Dependencies: 234
-- Name: links_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.links_id_seq1', 115, true);


--
-- TOC entry 3727 (class 0 OID 0)
-- Dependencies: 239
-- Name: page_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.page_section_id_seq', 81, true);


--
-- TOC entry 3728 (class 0 OID 0)
-- Dependencies: 243
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.pages_id_seq', 39, true);


--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 246
-- Name: passwd_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.passwd_details_id_seq', 7, true);


--
-- TOC entry 3730 (class 0 OID 0)
-- Dependencies: 244
-- Name: passwd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.passwd_id_seq', 7, true);


--
-- TOC entry 3731 (class 0 OID 0)
-- Dependencies: 248
-- Name: phone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.phone_id_seq', 11, true);


--
-- TOC entry 3732 (class 0 OID 0)
-- Dependencies: 250
-- Name: phones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.phones_id_seq', 1, false);


--
-- TOC entry 3733 (class 0 OID 0)
-- Dependencies: 252
-- Name: psudo_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.psudo_pages_id_seq', 8, true);


--
-- TOC entry 3387 (class 2606 OID 16584)
-- Name: _group _group_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public._group
    ADD CONSTRAINT _group_pkey PRIMARY KEY (id);


--
-- TOC entry 3391 (class 2606 OID 16586)
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- TOC entry 3393 (class 2606 OID 16588)
-- Name: alias alias_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_pkey PRIMARY KEY (id);


--
-- TOC entry 3395 (class 2606 OID 16590)
-- Name: alias alias_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_unique_contraint_name UNIQUE (name);


--
-- TOC entry 3408 (class 2606 OID 16592)
-- Name: codes_prefixes codes_prefixes_pk; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.codes_prefixes
    ADD CONSTRAINT codes_prefixes_pk PRIMARY KEY (prefix);


--
-- TOC entry 3410 (class 2606 OID 16594)
-- Name: countries countries_pk; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pk PRIMARY KEY (id);


--
-- TOC entry 3412 (class 2606 OID 16596)
-- Name: countries countries_prefix_ukey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_prefix_ukey UNIQUE (prefix);


--
-- TOC entry 3414 (class 2606 OID 16598)
-- Name: email email_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_pkey PRIMARY KEY (id);


--
-- TOC entry 3416 (class 2606 OID 16600)
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- TOC entry 3389 (class 2606 OID 16602)
-- Name: _group group_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public._group
    ADD CONSTRAINT group_unique_key UNIQUE (_name);


--
-- TOC entry 3418 (class 2606 OID 16604)
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- TOC entry 3420 (class 2606 OID 16606)
-- Name: groups groups_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_unique_key UNIQUE (group_id, passwd_id);


--
-- TOC entry 3397 (class 2606 OID 16608)
-- Name: links_sections links_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- TOC entry 3403 (class 2606 OID 16610)
-- Name: links links_pkey1; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_pkey1 PRIMARY KEY (id);


--
-- TOC entry 3400 (class 2606 OID 16612)
-- Name: links_sections links_sections_unnique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_sections_unnique_key UNIQUE (section);


--
-- TOC entry 3405 (class 2606 OID 16614)
-- Name: links links_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_unique_contraint_name UNIQUE (section_id, name);


--
-- TOC entry 3422 (class 2606 OID 16616)
-- Name: page_section page_section_unique; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT page_section_unique UNIQUE (pages_id, links_section_id);


--
-- TOC entry 3426 (class 2606 OID 16618)
-- Name: pages page_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT page_unique_key UNIQUE (name);


--
-- TOC entry 3438 (class 2606 OID 16620)
-- Name: passwd_details passwd_details_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_pkey PRIMARY KEY (id);


--
-- TOC entry 3434 (class 2606 OID 16622)
-- Name: passwd passwd_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_pkey PRIMARY KEY (id);


--
-- TOC entry 3436 (class 2606 OID 16624)
-- Name: passwd passwd_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_unique_key UNIQUE (username);


--
-- TOC entry 3440 (class 2606 OID 16626)
-- Name: phone phone_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phone
    ADD CONSTRAINT phone_pkey PRIMARY KEY (id);


--
-- TOC entry 3442 (class 2606 OID 16628)
-- Name: phones phones_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phones
    ADD CONSTRAINT phones_pkey PRIMARY KEY (id);


--
-- TOC entry 3428 (class 2606 OID 16630)
-- Name: pages pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pkey PRIMARY KEY (id);


--
-- TOC entry 3430 (class 2606 OID 16632)
-- Name: pseudo_pages pseudo_pages_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT pseudo_pages_unique_key UNIQUE (name);


--
-- TOC entry 3424 (class 2606 OID 16634)
-- Name: page_section psge_section_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT psge_section_pkey PRIMARY KEY (id);


--
-- TOC entry 3432 (class 2606 OID 16636)
-- Name: pseudo_pages psudo_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT psudo_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 3444 (class 2606 OID 16638)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 3401 (class 1259 OID 16639)
-- Name: fki_section_fkey; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE INDEX fki_section_fkey ON public.links USING btree (section_id);


--
-- TOC entry 3398 (class 1259 OID 16640)
-- Name: links_sections_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX links_sections_unique_key ON public.links_sections USING btree (section COLLATE "C" text_pattern_ops);


--
-- TOC entry 3406 (class 1259 OID 16641)
-- Name: links_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX links_unique_key ON public.links USING btree (name COLLATE "POSIX" bpchar_pattern_ops, section_id);

ALTER TABLE public.links CLUSTER ON links_unique_key;


--
-- TOC entry 3447 (class 2606 OID 16642)
-- Name: alias alias_foriegn_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_foriegn_key FOREIGN KEY (target) REFERENCES public.links_sections(id) NOT VALID;


--
-- TOC entry 3448 (class 2606 OID 16647)
-- Name: alias alias_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3449 (class 2606 OID 16652)
-- Name: alias alias_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3455 (class 2606 OID 16657)
-- Name: emails emails_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_address_fkey FOREIGN KEY (address_id) REFERENCES public.address(id);


--
-- TOC entry 3456 (class 2606 OID 16662)
-- Name: emails emails_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_email_fkey FOREIGN KEY (email_id) REFERENCES public.email(id);


--
-- TOC entry 3457 (class 2606 OID 16667)
-- Name: groups groups_address_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_address_foreign_key FOREIGN KEY (passwd_id) REFERENCES public.passwd(id);


--
-- TOC entry 3458 (class 2606 OID 16672)
-- Name: groups groups_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_foreign_key FOREIGN KEY (group_id) REFERENCES public._group(id);


--
-- TOC entry 3452 (class 2606 OID 16677)
-- Name: links links_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3459 (class 2606 OID 16682)
-- Name: page_section links_section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT links_section_fkey FOREIGN KEY (links_section_id) REFERENCES public.links_sections(id);


--
-- TOC entry 3450 (class 2606 OID 16687)
-- Name: links_sections links_sections_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_sections_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3451 (class 2606 OID 16692)
-- Name: links_sections links_sections_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_sections_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3453 (class 2606 OID 16697)
-- Name: links links_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3460 (class 2606 OID 16702)
-- Name: page_section page_section_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT page_section_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3461 (class 2606 OID 16707)
-- Name: page_section page_section_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT page_section_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3462 (class 2606 OID 16712)
-- Name: page_section pages_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT pages_fkey FOREIGN KEY (pages_id) REFERENCES public.pages(id);


--
-- TOC entry 3463 (class 2606 OID 16717)
-- Name: pages pages_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3464 (class 2606 OID 16722)
-- Name: pages pages_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3474 (class 2606 OID 16806)
-- Name: passwd_details passwd_details_cc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_cc_fkey FOREIGN KEY (countries_id) REFERENCES public.countries(id) NOT VALID;


--
-- TOC entry 3467 (class 2606 OID 16727)
-- Name: passwd passwd_details_connection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_details_connection_fkey FOREIGN KEY (passwd_details_id) REFERENCES public.passwd_details(id) NOT VALID;


--
-- TOC entry 3470 (class 2606 OID 16737)
-- Name: passwd_details passwd_details_p_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_p_phone_fkey FOREIGN KEY (primary_phone_id) REFERENCES public.phone(id) NOT VALID;


--
-- TOC entry 3471 (class 2606 OID 16742)
-- Name: passwd_details passwd_details_post_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_post_foreign_key FOREIGN KEY (postal_address_id) REFERENCES public.address(id);


--
-- TOC entry 3472 (class 2606 OID 16747)
-- Name: passwd_details passwd_details_res_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_res_foreign_key FOREIGN KEY (residential_address_id) REFERENCES public.address(id);


--
-- TOC entry 3473 (class 2606 OID 16799)
-- Name: passwd_details passwd_details_sec_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_sec_phone_fkey FOREIGN KEY (secondary_phone_id) REFERENCES public.phone(id) NOT VALID;


--
-- TOC entry 3468 (class 2606 OID 16752)
-- Name: passwd passwd_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_group_fkey FOREIGN KEY (primary_group_id) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3469 (class 2606 OID 16757)
-- Name: passwd passwd_primary_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_primary_email_fkey FOREIGN KEY (email_id) REFERENCES public.email(id) NOT VALID;


--
-- TOC entry 3475 (class 2606 OID 16762)
-- Name: phones phones_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phones
    ADD CONSTRAINT phones_address_fkey FOREIGN KEY (address_id) REFERENCES public.address(id);


--
-- TOC entry 3476 (class 2606 OID 16767)
-- Name: phones phones_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phones
    ADD CONSTRAINT phones_phone_fkey FOREIGN KEY (phone_id) REFERENCES public.phone(id);


--
-- TOC entry 3465 (class 2606 OID 16772)
-- Name: pseudo_pages pseudo_pages_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT pseudo_pages_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- TOC entry 3466 (class 2606 OID 16777)
-- Name: pseudo_pages pseudo_pages_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT pseudo_pages_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- TOC entry 3454 (class 2606 OID 16782)
-- Name: links section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT section_fkey FOREIGN KEY (section_id) REFERENCES public.links_sections(id) ON UPDATE RESTRICT;


--
-- TOC entry 3445 (class 2606 OID 16787)
-- Name: secure secure_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.secure
    ADD CONSTRAINT secure_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id);


--
-- TOC entry 3446 (class 2606 OID 16792)
-- Name: secure secure_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.secure
    ADD CONSTRAINT secure_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id);


--
-- TOC entry 3666 (class 0 OID 0)
-- Dependencies: 962
-- Name: TYPE perm_set; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON TYPE public.perm_set TO urluser WITH GRANT OPTION;


--
-- TOC entry 3667 (class 0 OID 0)
-- Dependencies: 963
-- Name: TYPE perms; Type: ACL; Schema: public; Owner: grizzlysmit
--

REVOKE ALL ON TYPE public.perms FROM grizzlysmit;
GRANT ALL ON TYPE public.perms TO urluser WITH GRANT OPTION;
GRANT ALL ON TYPE public.perms TO grizzlysmit WITH GRANT OPTION;


--
-- TOC entry 3668 (class 0 OID 0)
-- Dependencies: 211
-- Name: SEQUENCE _group_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public._group_id_seq TO urluser;


--
-- TOC entry 3669 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE _group; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON TABLE public._group TO urluser;


--
-- TOC entry 3670 (class 0 OID 0)
-- Dependencies: 213
-- Name: SEQUENCE address_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.address_id_seq TO urluser;


--
-- TOC entry 3671 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE address; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.address TO urluser;


--
-- TOC entry 3672 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE secure; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.secure TO urluser;


--
-- TOC entry 3673 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE alias; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias TO urluser;


--
-- TOC entry 3675 (class 0 OID 0)
-- Dependencies: 217
-- Name: SEQUENCE alias_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.alias_id_seq TO urluser;


--
-- TOC entry 3676 (class 0 OID 0)
-- Dependencies: 218
-- Name: SEQUENCE links_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.links_id_seq TO urluser;


--
-- TOC entry 3677 (class 0 OID 0)
-- Dependencies: 219
-- Name: TABLE links_sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.links_sections TO urluser;


--
-- TOC entry 3678 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE alias_links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias_links TO urluser;


--
-- TOC entry 3679 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.links TO urluser;


--
-- TOC entry 3680 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE alias_union_links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias_union_links TO urluser;


--
-- TOC entry 3681 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE alias_union_links_sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias_union_links_sections TO urluser;


--
-- TOC entry 3682 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE aliases; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.aliases TO urluser;


--
-- TOC entry 3683 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE codes_prefixes; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.codes_prefixes TO urluser;


--
-- TOC entry 3684 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.countries TO urluser;


--
-- TOC entry 3686 (class 0 OID 0)
-- Dependencies: 228
-- Name: SEQUENCE email_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.email_id_seq TO urluser;


--
-- TOC entry 3687 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE email; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.email TO urluser;


--
-- TOC entry 3688 (class 0 OID 0)
-- Dependencies: 230
-- Name: SEQUENCE emails_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.emails_id_seq TO urluser;


--
-- TOC entry 3689 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE emails; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.emails TO urluser;


--
-- TOC entry 3690 (class 0 OID 0)
-- Dependencies: 232
-- Name: SEQUENCE groups_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.groups_id_seq TO urluser;


--
-- TOC entry 3691 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE groups; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.groups TO urluser;


--
-- TOC entry 3693 (class 0 OID 0)
-- Dependencies: 234
-- Name: SEQUENCE links_id_seq1; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.links_id_seq1 TO urluser;


--
-- TOC entry 3694 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE links_sections_join_links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.links_sections_join_links TO urluser;


--
-- TOC entry 3695 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE page_section; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_section TO urluser;


--
-- TOC entry 3696 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE pages; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pages TO urluser;


--
-- TOC entry 3697 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE page_link_view; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_link_view TO urluser;


--
-- TOC entry 3699 (class 0 OID 0)
-- Dependencies: 239
-- Name: SEQUENCE page_section_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.page_section_id_seq TO urluser;


--
-- TOC entry 3700 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE page_view; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_view TO urluser;


--
-- TOC entry 3701 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE pseudo_pages; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pseudo_pages TO urluser;


--
-- TOC entry 3702 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE pagelike; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pagelike TO urluser;


--
-- TOC entry 3704 (class 0 OID 0)
-- Dependencies: 243
-- Name: SEQUENCE pages_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.pages_id_seq TO urluser;


--
-- TOC entry 3705 (class 0 OID 0)
-- Dependencies: 244
-- Name: SEQUENCE passwd_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.passwd_id_seq TO urluser;


--
-- TOC entry 3706 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE passwd; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.passwd TO urluser;


--
-- TOC entry 3707 (class 0 OID 0)
-- Dependencies: 246
-- Name: SEQUENCE passwd_details_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.passwd_details_id_seq TO urluser;


--
-- TOC entry 3708 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE passwd_details; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.passwd_details TO urluser;


--
-- TOC entry 3709 (class 0 OID 0)
-- Dependencies: 248
-- Name: SEQUENCE phone_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.phone_id_seq TO urluser;


--
-- TOC entry 3710 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE phone; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.phone TO urluser;


--
-- TOC entry 3711 (class 0 OID 0)
-- Dependencies: 250
-- Name: SEQUENCE phones_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.phones_id_seq TO urluser;


--
-- TOC entry 3712 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE phones; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.phones TO urluser;


--
-- TOC entry 3714 (class 0 OID 0)
-- Dependencies: 252
-- Name: SEQUENCE psudo_pages_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.psudo_pages_id_seq TO urluser;


--
-- TOC entry 3715 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.sections TO urluser;


--
-- TOC entry 3716 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE sessions; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.sessions TO urluser;


--
-- TOC entry 3717 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE vlinks; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.vlinks TO urluser;


--
-- TOC entry 2163 (class 826 OID 16797)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: grizzlysmit
--

ALTER DEFAULT PRIVILEGES FOR ROLE grizzlysmit GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLES  TO urluser;


-- Completed on 2022-05-15 23:47:20 AEST

--
-- PostgreSQL database dump complete
--

