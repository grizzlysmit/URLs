--
-- PostgreSQL database dump
--

-- Dumped from database version 14.2 (Ubuntu 14.2-1ubuntu1)
-- Dumped by pg_dump version 14.3 (Ubuntu 14.3-1.pgdg21.10+1)

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

ALTER TABLE IF EXISTS ONLY public.secure DROP CONSTRAINT IF EXISTS secure_userid_fkey;
ALTER TABLE IF EXISTS ONLY public.secure DROP CONSTRAINT IF EXISTS secure_groupid_fkey;
ALTER TABLE IF EXISTS ONLY public.links DROP CONSTRAINT IF EXISTS section_fkey;
ALTER TABLE IF EXISTS ONLY public.pseudo_pages DROP CONSTRAINT IF EXISTS pseudo_pages_userid_fkey;
ALTER TABLE IF EXISTS ONLY public.pseudo_pages DROP CONSTRAINT IF EXISTS pseudo_pages_groupid_fkey;
ALTER TABLE IF EXISTS ONLY public.phones DROP CONSTRAINT IF EXISTS phones_phone_fkey;
ALTER TABLE IF EXISTS ONLY public.phones DROP CONSTRAINT IF EXISTS phones_address_fkey;
ALTER TABLE IF EXISTS ONLY public.passwd DROP CONSTRAINT IF EXISTS passwd_primary_email_fkey;
ALTER TABLE IF EXISTS ONLY public.passwd DROP CONSTRAINT IF EXISTS passwd_group_fkey;
ALTER TABLE IF EXISTS ONLY public.passwd_details DROP CONSTRAINT IF EXISTS passwd_details_sec_phone_fkey;
ALTER TABLE IF EXISTS ONLY public.passwd_details DROP CONSTRAINT IF EXISTS passwd_details_res_foreign_key;
ALTER TABLE IF EXISTS ONLY public.passwd_details DROP CONSTRAINT IF EXISTS passwd_details_post_foreign_key;
ALTER TABLE IF EXISTS ONLY public.passwd_details DROP CONSTRAINT IF EXISTS passwd_details_p_phone_fkey;
ALTER TABLE IF EXISTS ONLY public.passwd DROP CONSTRAINT IF EXISTS passwd_details_connection_fkey;
ALTER TABLE IF EXISTS ONLY public.passwd_details DROP CONSTRAINT IF EXISTS passwd_details_cc_fkey;
ALTER TABLE IF EXISTS ONLY public.pages DROP CONSTRAINT IF EXISTS pages_userid_fkey;
ALTER TABLE IF EXISTS ONLY public.pages DROP CONSTRAINT IF EXISTS pages_groupid_fkey;
ALTER TABLE IF EXISTS ONLY public.page_section DROP CONSTRAINT IF EXISTS pages_fkey;
ALTER TABLE IF EXISTS ONLY public.page_section DROP CONSTRAINT IF EXISTS page_section_userid_fkey;
ALTER TABLE IF EXISTS ONLY public.page_section DROP CONSTRAINT IF EXISTS page_section_groupid_fkey;
ALTER TABLE IF EXISTS ONLY public.links DROP CONSTRAINT IF EXISTS links_userid_fkey;
ALTER TABLE IF EXISTS ONLY public.links_sections DROP CONSTRAINT IF EXISTS links_sections_userid_fkey;
ALTER TABLE IF EXISTS ONLY public.links_sections DROP CONSTRAINT IF EXISTS links_sections_groupid_fkey;
ALTER TABLE IF EXISTS ONLY public.page_section DROP CONSTRAINT IF EXISTS links_section_fkey;
ALTER TABLE IF EXISTS ONLY public.links DROP CONSTRAINT IF EXISTS links_groupid_fkey;
ALTER TABLE IF EXISTS ONLY public.groups DROP CONSTRAINT IF EXISTS groups_foreign_key;
ALTER TABLE IF EXISTS ONLY public.groups DROP CONSTRAINT IF EXISTS groups_address_foreign_key;
ALTER TABLE IF EXISTS ONLY public.emails DROP CONSTRAINT IF EXISTS emails_email_fkey;
ALTER TABLE IF EXISTS ONLY public.emails DROP CONSTRAINT IF EXISTS emails_address_fkey;
ALTER TABLE IF EXISTS ONLY public.alias DROP CONSTRAINT IF EXISTS alias_userid_fkey;
ALTER TABLE IF EXISTS ONLY public.alias DROP CONSTRAINT IF EXISTS alias_groupid_fkey;
ALTER TABLE IF EXISTS ONLY public.alias DROP CONSTRAINT IF EXISTS alias_foriegn_key;
ALTER TABLE IF EXISTS ONLY public.addresses DROP CONSTRAINT IF EXISTS addresses_passwd_id_fkey;
ALTER TABLE IF EXISTS ONLY public.addresses DROP CONSTRAINT IF EXISTS addresses_address_id_fkey;
DROP INDEX IF EXISTS public.links_unique_key;
DROP INDEX IF EXISTS public.links_sections_unique_key;
DROP INDEX IF EXISTS public.fki_section_fkey;
ALTER TABLE IF EXISTS ONLY public.sessions DROP CONSTRAINT IF EXISTS sessions_pkey;
ALTER TABLE IF EXISTS ONLY public.pseudo_pages DROP CONSTRAINT IF EXISTS psudo_pages_pkey;
ALTER TABLE IF EXISTS ONLY public.page_section DROP CONSTRAINT IF EXISTS psge_section_pkey;
ALTER TABLE IF EXISTS ONLY public.pseudo_pages DROP CONSTRAINT IF EXISTS pseudo_pages_unique_key;
ALTER TABLE IF EXISTS ONLY public.pages DROP CONSTRAINT IF EXISTS pkey;
ALTER TABLE IF EXISTS ONLY public.phones DROP CONSTRAINT IF EXISTS phones_pkey;
ALTER TABLE IF EXISTS ONLY public.phone DROP CONSTRAINT IF EXISTS phone_pkey;
ALTER TABLE IF EXISTS ONLY public.passwd DROP CONSTRAINT IF EXISTS passwd_unique_key;
ALTER TABLE IF EXISTS ONLY public.passwd DROP CONSTRAINT IF EXISTS passwd_pkey;
ALTER TABLE IF EXISTS ONLY public.passwd_details DROP CONSTRAINT IF EXISTS passwd_details_pkey;
ALTER TABLE IF EXISTS ONLY public.pages DROP CONSTRAINT IF EXISTS page_unique_key;
ALTER TABLE IF EXISTS ONLY public.page_section DROP CONSTRAINT IF EXISTS page_section_unique;
ALTER TABLE IF EXISTS ONLY public.links DROP CONSTRAINT IF EXISTS links_unique_contraint_name;
ALTER TABLE IF EXISTS ONLY public.links_sections DROP CONSTRAINT IF EXISTS links_sections_unnique_key;
ALTER TABLE IF EXISTS ONLY public.links DROP CONSTRAINT IF EXISTS links_pkey1;
ALTER TABLE IF EXISTS ONLY public.links_sections DROP CONSTRAINT IF EXISTS links_pkey;
ALTER TABLE IF EXISTS ONLY public.groups DROP CONSTRAINT IF EXISTS groups_unique_key;
ALTER TABLE IF EXISTS ONLY public.groups DROP CONSTRAINT IF EXISTS groups_pkey;
ALTER TABLE IF EXISTS ONLY public._group DROP CONSTRAINT IF EXISTS group_unique_key;
ALTER TABLE IF EXISTS ONLY public.emails DROP CONSTRAINT IF EXISTS emails_pkey;
ALTER TABLE IF EXISTS ONLY public.email DROP CONSTRAINT IF EXISTS email_pkey;
ALTER TABLE IF EXISTS ONLY public.countries DROP CONSTRAINT IF EXISTS countries_prefix_ukey;
ALTER TABLE IF EXISTS ONLY public.countries DROP CONSTRAINT IF EXISTS countries_pk;
ALTER TABLE IF EXISTS ONLY public.codes_prefixes DROP CONSTRAINT IF EXISTS codes_prefixes_pk;
ALTER TABLE IF EXISTS ONLY public.alias DROP CONSTRAINT IF EXISTS alias_unique_contraint_name;
ALTER TABLE IF EXISTS ONLY public.alias DROP CONSTRAINT IF EXISTS alias_pkey;
ALTER TABLE IF EXISTS ONLY public.addresses DROP CONSTRAINT IF EXISTS addresses_pkey;
ALTER TABLE IF EXISTS ONLY public.address DROP CONSTRAINT IF EXISTS address_pkey;
ALTER TABLE IF EXISTS ONLY public._group DROP CONSTRAINT IF EXISTS _group_pkey;
ALTER TABLE IF EXISTS public.pseudo_pages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.pages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.page_section ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.links ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.countries ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.alias ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.addresses ALTER COLUMN id DROP DEFAULT;
DROP VIEW IF EXISTS public.vlinks;
DROP TABLE IF EXISTS public.sessions;
DROP VIEW IF EXISTS public.sections;
DROP SEQUENCE IF EXISTS public.psudo_pages_id_seq;
DROP TABLE IF EXISTS public.phones;
DROP SEQUENCE IF EXISTS public.phones_id_seq;
DROP TABLE IF EXISTS public.phone;
DROP SEQUENCE IF EXISTS public.phone_id_seq;
DROP TABLE IF EXISTS public.passwd_details;
DROP SEQUENCE IF EXISTS public.passwd_details_id_seq;
DROP TABLE IF EXISTS public.passwd;
DROP SEQUENCE IF EXISTS public.passwd_id_seq;
DROP SEQUENCE IF EXISTS public.pages_id_seq;
DROP VIEW IF EXISTS public.pagelike;
DROP TABLE IF EXISTS public.pseudo_pages;
DROP VIEW IF EXISTS public.page_view;
DROP SEQUENCE IF EXISTS public.page_section_id_seq;
DROP VIEW IF EXISTS public.page_link_view;
DROP TABLE IF EXISTS public.pages;
DROP TABLE IF EXISTS public.page_section;
DROP VIEW IF EXISTS public.links_sections_join_links;
DROP SEQUENCE IF EXISTS public.links_id_seq1;
DROP TABLE IF EXISTS public.groups;
DROP SEQUENCE IF EXISTS public.groups_id_seq;
DROP TABLE IF EXISTS public.emails;
DROP SEQUENCE IF EXISTS public.emails_id_seq;
DROP TABLE IF EXISTS public.email;
DROP SEQUENCE IF EXISTS public.email_id_seq;
DROP SEQUENCE IF EXISTS public.countries_id_seq;
DROP TABLE IF EXISTS public.countries;
DROP TABLE IF EXISTS public.codes_prefixes;
DROP VIEW IF EXISTS public.aliases;
DROP VIEW IF EXISTS public.alias_union_links_sections;
DROP VIEW IF EXISTS public.alias_union_links;
DROP TABLE IF EXISTS public.links;
DROP VIEW IF EXISTS public.alias_links;
DROP TABLE IF EXISTS public.links_sections;
DROP SEQUENCE IF EXISTS public.links_id_seq;
DROP SEQUENCE IF EXISTS public.alias_id_seq;
DROP TABLE IF EXISTS public.alias;
DROP TABLE IF EXISTS public.secure;
DROP SEQUENCE IF EXISTS public.addresses_id_seq;
DROP TABLE IF EXISTS public.addresses;
DROP TABLE IF EXISTS public.address;
DROP SEQUENCE IF EXISTS public.address_id_seq;
DROP TABLE IF EXISTS public._group;
DROP SEQUENCE IF EXISTS public._group_id_seq;
DROP TYPE IF EXISTS public.status;
DROP TYPE IF EXISTS public.perms;
DROP TYPE IF EXISTS public.perm_set;
--
-- Name: perm_set; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE public.perm_set AS (
	_read boolean,
	_write boolean,
	_del boolean
);


ALTER TYPE public.perm_set OWNER TO grizzlysmit;

--
-- Name: perms; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE public.perms AS (
	_user public.perm_set,
	_group public.perm_set,
	_other public.perm_set
);


ALTER TYPE public.perms OWNER TO grizzlysmit;

--
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
-- Name: _group; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public._group (
    id bigint DEFAULT nextval('public._group_id_seq'::regclass) NOT NULL,
    _name character varying(256) NOT NULL
);


ALTER TABLE public._group OWNER TO grizzlysmit;

--
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
-- Name: addresses; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.addresses (
    id bigint NOT NULL,
    passwd_id bigint NOT NULL,
    address_id bigint NOT NULL
);


ALTER TABLE public.addresses OWNER TO grizzlysmit;

--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addresses_id_seq OWNER TO grizzlysmit;

--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: secure; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.secure (
    userid bigint DEFAULT 1 NOT NULL,
    groupid bigint DEFAULT 1 NOT NULL,
    _perms public.perms DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)) NOT NULL
);


ALTER TABLE public.secure OWNER TO grizzlysmit;

--
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
-- Name: alias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.alias_id_seq OWNED BY public.alias.id;


--
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
-- Name: codes_prefixes; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.codes_prefixes (
    prefix character varying(64) NOT NULL,
    cc character(2),
    _flag character varying(256)
);


ALTER TABLE public.codes_prefixes OWNER TO grizzlysmit;

--
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
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
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
-- Name: email; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.email (
    id bigint DEFAULT nextval('public.email_id_seq'::regclass) NOT NULL,
    _email character varying(256) NOT NULL,
    verified boolean DEFAULT false NOT NULL
);


ALTER TABLE public.email OWNER TO grizzlysmit;

--
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
-- Name: emails; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.emails (
    id bigint DEFAULT nextval('public.emails_id_seq'::regclass) NOT NULL,
    email_id bigint NOT NULL,
    address_id bigint NOT NULL
);


ALTER TABLE public.emails OWNER TO grizzlysmit;

--
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
-- Name: groups; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.groups (
    id bigint DEFAULT nextval('public.groups_id_seq'::regclass) NOT NULL,
    group_id bigint NOT NULL,
    passwd_id bigint NOT NULL
);


ALTER TABLE public.groups OWNER TO grizzlysmit;

--
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
-- Name: links_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.links_id_seq1 OWNED BY public.links.id;


--
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
-- Name: page_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.page_section_id_seq OWNED BY public.page_section.id;


--
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
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
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
    countries_id bigint NOT NULL
);


ALTER TABLE public.passwd_details OWNER TO grizzlysmit;

--
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
-- Name: phone; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.phone (
    id bigint DEFAULT nextval('public.phone_id_seq'::regclass) NOT NULL,
    _number character varying(128) NOT NULL,
    verified boolean DEFAULT false NOT NULL
);


ALTER TABLE public.phone OWNER TO grizzlysmit;

--
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
-- Name: phones; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.phones (
    id bigint DEFAULT nextval('public.phones_id_seq'::regclass) NOT NULL,
    phone_id bigint NOT NULL,
    address_id bigint NOT NULL
);


ALTER TABLE public.phones OWNER TO grizzlysmit;

--
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
-- Name: psudo_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.psudo_pages_id_seq OWNED BY public.pseudo_pages.id;


--
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
-- Name: sessions; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.sessions (
    id character(32) NOT NULL,
    a_session text
);


ALTER TABLE public.sessions OWNER TO grizzlysmit;

--
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
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: alias id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias ALTER COLUMN id SET DEFAULT nextval('public.alias_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: links id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links ALTER COLUMN id SET DEFAULT nextval('public.links_id_seq1'::regclass);


--
-- Name: page_section id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section ALTER COLUMN id SET DEFAULT nextval('public.page_section_id_seq'::regclass);


--
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- Name: pseudo_pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages ALTER COLUMN id SET DEFAULT nextval('public.psudo_pages_id_seq'::regclass);


--
-- Data for Name: _group; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public._group VALUES (1, 'admin') ON CONFLICT DO NOTHING;
INSERT INTO public._group VALUES (5, 'grizz') ON CONFLICT DO NOTHING;
INSERT INTO public._group VALUES (4, 'grizzly') ON CONFLICT DO NOTHING;
INSERT INTO public._group VALUES (3, 'grizzlysmit') ON CONFLICT DO NOTHING;
INSERT INTO public._group VALUES (9, 'doctor') ON CONFLICT DO NOTHING;
INSERT INTO public._group VALUES (10, 'fredie') ON CONFLICT DO NOTHING;
INSERT INTO public._group VALUES (12, 'romanna') ON CONFLICT DO NOTHING;
INSERT INTO public._group VALUES (11, 'fred') ON CONFLICT DO NOTHING;
INSERT INTO public._group VALUES (8, 'frodo') ON CONFLICT DO NOTHING;


--
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.address VALUES (1, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia') ON CONFLICT DO NOTHING;
INSERT INTO public.address VALUES (2, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia') ON CONFLICT DO NOTHING;
INSERT INTO public.address VALUES (3, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia') ON CONFLICT DO NOTHING;
INSERT INTO public.address VALUES (7, '2', '76-84 Karne Street north', 'Riverwood', '2209', 'NSW', 'Australia') ON CONFLICT DO NOTHING;
INSERT INTO public.address VALUES (6, '2', '76-84 Karne Street north', 'Narwee', '2210', 'NSW', 'Australia') ON CONFLICT DO NOTHING;
INSERT INTO public.address VALUES (5, '2', '76-84 Karnee Street north', 'Riveerwood', '2210', 'NSW', 'Australia') ON CONFLICT DO NOTHING;
INSERT INTO public.address VALUES (11, '2', '76-84 Karnee Street north', 'Riveerwood', '2210', 'NSW', 'Australia') ON CONFLICT DO NOTHING;
INSERT INTO public.address VALUES (4, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia') ON CONFLICT DO NOTHING;
INSERT INTO public.address VALUES (12, 'unit 2', 'Tardis ', 'The universe', '9999', 'Galefray', 'Australia') ON CONFLICT DO NOTHING;
INSERT INTO public.address VALUES (15, '', 'The Tardis', 'Tardis', '345667', 'universe', 'Cayman Islands') ON CONFLICT DO NOTHING;
INSERT INTO public.address VALUES (14, '', '2 bedrock lane', 'Bedropck', '45567', 'stone age', 'United States Virgin Islands') ON CONFLICT DO NOTHING;
INSERT INTO public.address VALUES (10, '', 'Baggsend', 'hobbiton', '', 'the shire', 'Barbados') ON CONFLICT DO NOTHING;


--
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- Data for Name: alias; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 'stor', 15) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 'bronze', 9) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 'store', 15) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 'knck-dev', 23) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 'knck', 16) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 'knock-dev', 23) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 'cpp', 24) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 'CPP', 24) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 'c++', 24) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 'proc', 21) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 'dir', 18) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 'out', 7) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 'api.q', 19) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 'api_u', 13) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 'API_U', 13) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 'in', 5) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 'tool', 12) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 'fred', 22) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 22, 'pk', 16) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 23, 'add', 4) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 25, 'perl6', 27) ON CONFLICT DO NOTHING;
INSERT INTO public.alias VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 26, 'pg', 34) ON CONFLICT DO NOTHING;


--
-- Data for Name: codes_prefixes; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- Data for Name: countries; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.countries VALUES ('+61', 'AU', 2, 'Australia', '0', '(?:(?:\+61[ -]?\d|0\d|\(0\d\)|0\d)[ -]?)?\d{4}[ -]?\d{4}', '(?:\+61|0)?\d{3}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +612-9567-2876 or (02) 9567 2876 or 0295672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+612-9567-2876|(02) 9567 2876|0295672876', '+61438-567-876|0438 567 876|0438567876', '/flags/AU.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1340', 'VI', 8, 'United States Virgin Islands', NULL, '(?:\+?1[ -]?)?340[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?340[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1340-234-1234 or 1340 234 1234 or 340-234-1234.', 'Only +digits or local formats allowed i.e. +1340-234-1234 or 1340 234 1234 or 240-234-1234.', '+1-340-234-1234|1 340 234 1234|340 234 1234', '+1-340-234-1234|1 340 234 1234|340 234 1234', '/flags/VI.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1345', 'KY', 9, 'Cayman Islands', NULL, '(?:\+?1[ -]?)?345[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?345[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1345-234-1234 or 1345 234 1234 or 345-234-1234.', 'Only +digits or local formats allowed i.e. +1345-234-1234 or 1345 234 1234 or 245-234-1234.', '+1-345-234-1234|1 345 234 1234|345 234 1234', '+1-345-234-1234|1 345 234 1234|345 234 1234', '/flags/KY.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1242', 'BS', 1, 'The Bahamas', NULL, '(?:\+?1[ -]?)?242[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?242[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1242-234-1234 or 1242 234 1234 or 242-234-1234.', 'Only +digits or local formats allowed i.e. +1242-234-1234 or 1242 234 1234 or 242-234-1234.', '+1-242-234-1234|1 242 234 1234|242 234 1234', '+1-242-234-1234|1 242 234 1234|242 234 1234', '/flags/BS.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1246', 'BB', 3, 'Barbados', NULL, '(?:\+?1[ -]?)?246[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?246[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1246-234-1234 or 1246 234 1234 or 246-234-1234.', 'Only +digits or local formats allowed i.e. +1246-234-1234 or 1246 234 1234 or 246-234-1234.', '+1-246-234-1234|1 242 234 1234|242 234 1234', '+1-246-234-1234|1 246 234 1234|246 234 1234', '/flags/BB.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1284', 'VG', 6, 'British Virgin Islands', NULL, '(?:\+?1[ -]?)?284[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?284[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1284-234-1234 or 1284 234 1234 or 284-234-1234.', 'Only +digits or local formats allowed i.e. +1284-234-1234 or 1284 234 1234 or 284-234-1234.', '+1-248-234-1234|1 248 234 1234|248 234 1234', '+1-284-234-1234|1 284 234 1234|284 234 1234', '/flags/VG.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1268', 'AG', 5, 'Antigua and Barbuda', NULL, '(?:\+?1[ -]?)?268[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?268[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1268-234-1234 or 1268 234 1234 or 268-234-1234.', 'Only +digits or local formats allowed i.e. +1268-234-1234 or 1248 234 1234 or 248-234-1234.', '+1-248-234-1234|1 248 234 1234|248 234 1234', '+1-248-234-1234|1 248 234 1234|248 234 1234', '/flags/AG.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1264', 'AI', 4, 'Anguilla', NULL, '(?:\+?1[ -]?)?264[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?264[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1264-234-1234 or 1264 234 1234 or 264-234-1234.', 'Only +digits or local formats allowed i.e. +1264-234-1234 or 1246 234 1234 or 246-234-1234.', '+1-246-234-1234|1 242 234 1234|242 234 1234', '+1-246-234-1234|1 246 234 1234|246 234 1234', '/flags/AI.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1441', 'BM', 10, 'Bermuda', NULL, '(?:\+?1[ -]?)?441[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?441[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1441-234-1234 or 1441 234 1234 or 441-234-1234.', 'Only +digits or local formats allowed i.e. +1441-234-1234 or 1441 234 1234 or 441-234-1234.', '+1-441-234-1234|1 441 234 1234|441 234 1234', '+1-441-234-1234|1 441 234 1234|441 234 1234', '/flags/BM.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1473', 'GD', 11, 'Grenada', NULL, '(?:\+?1[ -]?)?473[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?473[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1473-234-1234 or 1473 234 1234 or 473-234-1234.', 'Only +digits or local formats allowed i.e. +1473-234-1234 or 1473 234 1234 or 473-234-1234.', '+1-473-234-1234|1 473 234 1234|473 234 1234', '+1-473-234-1234|1 473 234 1234|473 234 1234', '/flags/GD.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1649', 'TC', 12, 'Turks and Caicos Islands', NULL, '(?:\+?1[ -]?)?649[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?649[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +16439-234-1234 or 1649 234 1234 or 649-234-1234.', 'Only +digits or local formats allowed i.e. +1649-234-1234 or 1649 234 1234 or 649-234-1234.', '+1-649-234-1234|1 649 234 1234|649 234 1234', '+1-649-234-1234|1 649 234 1234|649 234 1234', '/flags/TC.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1658', 'JM', 13, 'Jamaica', NULL, '(?:\+?1[ -]?)?658[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?658[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1658-234-1234 or 1658 234 1234 or 658-234-1234.', 'Only +digits or local formats allowed i.e. +1658-234-1234 or 1658 234 1234 or 658-234-1234.', '+1-658-234-1234|1 658 234 1234|658 234 1234', '+1-658-234-1234|1 658 234 1234|658 234 1234', '/flags/JM.png') ON CONFLICT DO NOTHING;
INSERT INTO public.countries VALUES ('+1664', 'MS', 14, 'Montserrat', NULL, '(?:\+?1[ -]?)?664[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?664[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1664-234-1234 or 1664 234 1234 or 664-234-1234.', 'Only +digits or local formats allowed i.e. +1664-234-1234 or 1664 234 1234 or 664-234-1234.', '+1-664-234-1234|1 664 234 1234|664 234 1234', '+1-664-234-1234|1 664 234 1234|664 234 1234', '/flags/MS.png') ON CONFLICT DO NOTHING;


--
-- Data for Name: email; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.email VALUES (1, 'grizzly@smit.id.au', false) ON CONFLICT DO NOTHING;
INSERT INTO public.email VALUES (4, 'grizzly@smit.id.au', false) ON CONFLICT DO NOTHING;
INSERT INTO public.email VALUES (3, 'grizzly@smit.id.au', false) ON CONFLICT DO NOTHING;
INSERT INTO public.email VALUES (2, 'grizzly@smit.id.au', false) ON CONFLICT DO NOTHING;
INSERT INTO public.email VALUES (8, 'doctor@tardis.org', false) ON CONFLICT DO NOTHING;
INSERT INTO public.email VALUES (11, 'romanna@tardis.org', false) ON CONFLICT DO NOTHING;
INSERT INTO public.email VALUES (10, 'fred@bedrock.org', false) ON CONFLICT DO NOTHING;
INSERT INTO public.email VALUES (7, 'frodo@tolkien.com', false) ON CONFLICT DO NOTHING;


--
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.groups VALUES (1, 4, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (3, 1, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (8, 5, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (9, 3, 3) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (10, 1, 3) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (24, 8, 3) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (28, 8, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (29, 1, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (30, 3, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (31, 5, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (32, 4, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (33, 8, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (40, 10, 10) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (41, 9, 10) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (42, 3, 10) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (43, 4, 10) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (44, 5, 10) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (45, 1, 10) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (46, 8, 10) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (47, 1, 11) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (48, 8, 11) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (49, 5, 11) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (50, 4, 11) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (51, 3, 11) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (52, 10, 11) ON CONFLICT DO NOTHING;
INSERT INTO public.groups VALUES (53, 11, 11) ON CONFLICT DO NOTHING;


--
-- Data for Name: links; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 1, 'https://version.oztell.com.au/anycast/dl.88.io', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 1, 'https://version.oztell.com.au/anycast/dl.88.io/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 3, 'https://vault.net2maxlabs.net/net2max1/wp-admin/post.php?post=48209&action=edit', 'edit-docs') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 3, 'https://vault.net2maxlabs.net/net2max1/location-grid/', 'view-docs') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 5, 'https://version.contacttrace.com.au/contact0/input/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 5, 'https://version.contacttrace.com.au/contact0/input', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 5, 'https://version.contacttrace.com.au/contact0/input/-pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 6, 'https://version.contacttrace.com.au/contact0/app/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 6, 'https://version.contacttrace.com.au/contact0/app/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 6, 'https://version.contacttrace.com.au/contact0/app/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 17, 7, 'https://version.contacttrace.com.au/contact0/output/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 18, 7, 'https://version.contacttrace.com.au/contact0/output/-scripts/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 7, 'https://version.contacttrace.com.au/contact0/output/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 8, 'https://vault.net2maxlabs.net/net2max1/business-identity-check/', 'view-docs') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 8, 'https://vault.net2maxlabs.net/net2max1/wp-admin/post.php?post=51576&action=edit', 'edit-docs') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 76, 34, 'https://www.postgresql.org/docs/', 'docs') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 77, 36, 'https://php.net', 'main') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 78, 36, 'https://www.php.net/manual/en/', 'docs-en') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 79, 36, 'https://www.php.net/manual/en/langref.php', 'lang') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 80, 36, 'https://www.php.net/manual/en/security.php', 'security') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 81, 36, 'https://www.php.net/manual/en/funcref.php', 'funs') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 82, 36, 'https://www.php.net/manual/en/faq.php', 'faq') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 83, 36, 'https://www.php.net/manual/en/appendices.php', 'apendices') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 84, 36, 'https://www.php.net/manual/en/features.php', 'features') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 99, 34, 'https://www.postgresql.org/', 'main') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 22, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/-/blob/prod/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 23, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 24, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 25, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 26, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 27, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 28, 11, 'https://chat.quuvoo4ohcequuox.0.88.io/home', 'chat') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 29, 12, 'https://version.oztell.com.au/88io0/tools/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 31, 12, 'https://version.oztell.com.au/88io0/tools/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 32, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 33, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 34, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 35, 14, 'https://vault.net2maxlabs.net/net2max1/business-identity-check/', 'namecheck') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 36, 14, 'https://vault.net2maxlabs.net/net2max1/location-grid/', 'map') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 37, 15, 'https://version.contacttrace.com.au/contact0/storage/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 38, 15, 'https://version.contacttrace.com.au/contact0/storage/-/pipelines', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 39, 15, 'https://version.contacttrace.com.au/contact0/storage/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 40, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 41, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 42, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 43, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 44, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 45, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 46, 18, 'https://version.contacttrace.com.au/contact0/directory/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 47, 18, 'https://version.contacttrace.com.au/contact0/directory/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 48, 18, 'https://version.contacttrace.com.au/contact0/directory/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 49, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 50, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io/-/blob/prod/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 51, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 52, 20, 'https://version.oztell.com.au/oztell8/api', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 53, 21, 'https://version.contacttrace.com.au/contact0/processor/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 54, 21, 'https://version.contacttrace.com.au/contact0/processor', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 55, 21, 'https://version.contacttrace.com.au/contact0/processor/-/blob/dev/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 56, 22, 'https://ledger.contacttrace.com.au/?chain=0-s1-dev', '0-s1-dev') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 57, 22, 'https://ledger.contacttrace.com.au/', 'launch-page') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 58, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/-/blob/prod/README.md', 'readme') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 59, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/', 'gitlab') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 60, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/-/pipelines/', 'pipeline') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 61, 24, 'https://isocpp.org/', 'iso') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 62, 24, 'https://en.cppreference.com/w/', 'cppref') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 63, 24, 'https://www.modernescpp.com/index.php', 'modernescpp') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 69, 27, 'https://raku.org/', 'main') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 70, 27, 'https://modules.raku.org/', 'modules') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 71, 27, 'https://docs.raku.org/', 'docs') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 72, 27, 'https://docs.raku.org/language.html', 'lang') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 73, 27, 'https://docs.raku.org/type.html', 'types') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 74, 27, 'https://web.libera.chat/?channel=#raku', 'chat') ON CONFLICT DO NOTHING;
INSERT INTO public.links VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 100, 34, 'https://www.postgresql.org/account', 'account') ON CONFLICT DO NOTHING;


--
-- Data for Name: links_sections; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 'dl.88.io') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 'key') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 'location-grid-old-docs') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 'address') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 'input') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 'app') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 'output') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 'business-identity-check') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 'bronze-aus') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 'signature') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 'chat.q') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 'tools') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 'api_ugh8eika') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 'oldocs') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 'storage') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 'portknocking') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 17, 'scripts') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 18, 'directory') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 'api.quuvoo4ohcequuox.0.88.io') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 'api') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 'processor') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 22, 'blockchains') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 23, 'portknocking-dev') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 24, 'C++') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 27, 'raku') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 34, 'postgres') ON CONFLICT DO NOTHING;
INSERT INTO public.links_sections VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 36, 'php') ON CONFLICT DO NOTHING;


--
-- Data for Name: page_section; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.page_section VALUES (4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")', 80, 39, 24) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")', 81, 39, 27) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 1, 12) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 1, 20) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 3, 16) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 3, 23) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 5, 19) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 5, 1) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 7, 15) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 7, 21) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 7, 17) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 7, 16) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 7, 4) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 7, 10) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 7, 9) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 7, 13) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 7, 5) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 7, 18) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 17, 7, 7) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 18, 7, 6) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 7, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 20, 3) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 20, 14) ON CONFLICT DO NOTHING;
INSERT INTO public.page_section VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 78, 37, 1) ON CONFLICT DO NOTHING;


--
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 'oztell.com.au', 'oztell.com.au stuff') ON CONFLICT DO NOTHING;
INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 'knock', 'port knocking') ON CONFLICT DO NOTHING;
INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 'contacttrace', 'contacttrace') ON CONFLICT DO NOTHING;
INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 'docsold', 'The Old Docs') ON CONFLICT DO NOTHING;
INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, '88.io', '88.io stuff') ON CONFLICT DO NOTHING;
INSERT INTO public.pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 37, 'apk', 'where the apks are') ON CONFLICT DO NOTHING;
INSERT INTO public.pages VALUES (4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")', 39, 'grizz-page', 'Grizzs Page') ON CONFLICT DO NOTHING;


--
-- Data for Name: passwd; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.passwd VALUES (1, 'admin', '{X-PBKDF2}HMACSHA2+512:AAAIAA:1j44CmP4SfwiYFHyQSJ+NA==:N2xeXHLH5MLnAq3hAAFgPscGSbkZu9bvvN6pgnNPkUeX3c1pzzI+NnxtyITUf0sZ1fd23G3MDFgA/aoLmHf0aQ==', 1, 1, true, 1) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd VALUES (4, 'grizz', '{X-PBKDF2}HMACSHA2+512:AAAIAA:zWeWVTYpvU2EsxbD6fjNIw==:sdYmcRwOLxC55Q/cCigfExdtT32EFH3vzTvV8IaYVkjNo4Svo8A9FumS1Wu8Dpu7ca2W+uFcX7ZEA5zilPK3vg==', 4, 5, false, 4) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd VALUES (3, 'grizzly', '{X-PBKDF2}HMACSHA2+512:AAAIAA:Po+YOhfNSqvgJVkWfUJdoQ==:kA39+vz0F3/pIECA7Y2TuW1wLIPdal0WBv2LOWdkRCWci6GEcKdSu0NQ5wwsZuI4G0fsMBE83LIGvBiZJe0VcA==', 3, 4, true, 3) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd VALUES (2, 'grizzlysmit', '{X-PBKDF2}HMACSHA2+512:AAAIAA:205IxJhEjYkb5aOMExRFEA==:rk5nlRePO0bI4w1KOUPOyJADkCtBxpTd6goK9IGBc7fUu5otOvz+hXthcw41HH1DXSMB0qbicNJWpGC18wmUww==', 2, 3, true, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd VALUES (8, 'doctor', '{X-PBKDF2}HMACSHA2+512:AAAIAA:qI8dL7+iG0krRmP0j5UuBQ==:VZOV1L9FRFI+hH5Veiw66J6qdCe8hbyCeHnQ9cGkijk0UarrsYSSjxajlTtHYZ7qScd/uMSZBxT9w+5gEuj94w==', 8, 9, true, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd VALUES (11, 'romanna', '{X-PBKDF2}HMACSHA2+512:AAAIAA:Hfx25iKf16ALs9uLyAP0dg==:uZ3Yf8yYB3wNU3o+a5V++YfLR13j2n1UGn9PlNImGuDwhG2dvm8MbM3pNgRwe1k6H1KCXaNS34gsbE7SYkrZcg==', 11, 12, true, 11) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd VALUES (10, 'fred', '{X-PBKDF2}HMACSHA2+512:AAAIAA:MngWyewYRJDLVd4R0g90XA==:hNjmHMU/6Q/ygd0pR+TKw/Jp7B1zyuUvdRSZMqw1SoRdv47AytpnjvUWuhn+z3bRBcJrwTIZUEUKNVNRIpTZKQ==', 10, 11, true, 10) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd VALUES (7, 'frodo', '{X-PBKDF2}HMACSHA2+512:AAAIAA:L8niz4XzsghhSbcrOSDRHA==:MbAm1ydlPeqD2gIBVdvNOS9iLJwN55p59wXHZh28BdbMIl3Zu5zj0ysFmDzGiv4f/jA4zc/9FsUTQAQD64MjUQ==', 7, 8, false, 7) ON CONFLICT DO NOTHING;


--
-- Data for Name: passwd_details; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.passwd_details VALUES (1, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 3, 3, 1, NULL, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd_details VALUES (4, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 7, 6, 7, 10, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd_details VALUES (3, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 5, 11, 5, 11, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd_details VALUES (2, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 4, 4, 3, 9, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd_details VALUES (8, 'The Doctor Whatever', 'The Doctor', 'Whatever', 12, 12, 12, 13, 2) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd_details VALUES (11, 'Romanna Time Lady', 'Romanna', 'Time Lady', 15, 15, 18, 19, 9) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd_details VALUES (10, 'Fred Flintstone', 'Fred', 'Flintstone', 14, 14, 16, 17, 8) ON CONFLICT DO NOTHING;
INSERT INTO public.passwd_details VALUES (7, 'Frodo Baggins', 'Frodo', 'Baggins', 10, 10, NULL, NULL, 3) ON CONFLICT DO NOTHING;


--
-- Data for Name: phone; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.phone VALUES (1, '+61482176343', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (2, '+612 9217 6004', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (4, '+612 9217 6004', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (6, '(02) 9217 6004', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (8, '+612-9217-6004', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (7, '+61482176343', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (10, '+61292176004', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (5, '+61482176343', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (11, '+61292176004', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (3, '+61482176343', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (9, '+61292176004', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (12, '0482 176 343', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (13, '(02) 9217 6004', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (18, '+13452341234', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (19, '+1345+1-345-432-4321', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (16, '+13402341234', false) ON CONFLICT DO NOTHING;
INSERT INTO public.phone VALUES (17, '+1340+1-340-432-4321', false) ON CONFLICT DO NOTHING;


--
-- Data for Name: phones; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- Data for Name: pseudo_pages; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO public.pseudo_pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, '.*', 'unassigned', 'misc', 'misc') ON CONFLICT DO NOTHING;
INSERT INTO public.pseudo_pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, '.*', 'both', 'all', 'all') ON CONFLICT DO NOTHING;
INSERT INTO public.pseudo_pages VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, '.*', 'assigned', 'already', 'already in pages') ON CONFLICT DO NOTHING;


--
-- Data for Name: secure; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
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
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('068675cd502b8327e5dd27ef507aa3c0', 'BQsDAAAAEAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKCWxpbmtzXkMrKwAAAA9jdXJyZW50
X3NlY3Rpb24KATEAAAAFZGVidWcXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lCIEAAAALbG9n
Z2VkaW5faWQIgQAAAA5sb2dnZWRpbl9hZG1pbhcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9n
Z2VkaW5fZGlzcGxheV9uYW1lCIEAAAAIbG9nZ2VkaW4XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5s
b2dnZWRpbl9lbWFpbBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCgIyNQAAAAtw
YWdlX2xlbmd0aAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZRcMKzYxNDgyMTc2MzQz
AAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFwRT
bWl0AAAAD2xvZ2dlZGluX2ZhbWlseQogMDY4Njc1Y2Q1MDJiODMyN2U1ZGQyN2VmNTA3YWEzYzAA
AAALX3Nlc3Npb25faWQ=
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('dd658768b14194054d895bb6e64d5294', 'BQsDAAAAEAoObGlua3NecG9zdGdyZXMAAAAPY3VycmVudF9zZWN0aW9uFxRGcmFuY2lzIEdyaXp6
bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXC2dyaXp6bHlzbWl0AAAAEWxvZ2dlZGlu
X3VzZXJuYW1lFwtncml6emx5c21pdAAAABJsb2dnZWRpbl9ncm91cG5hbWUXD0ZyYW5jaXMgR3Jp
enpseQAAAA5sb2dnZWRpbl9naXZlbgogZGQ2NTg3NjhiMTQxOTQwNTRkODk1YmI2ZTY0ZDUyOTQA
AAALX3Nlc3Npb25faWQKAjI4AAAAC3BhZ2VfbGVuZ3RoFxJncml6emx5QHNtaXQuaWQuYXUAAAAO
bG9nZ2VkaW5fZW1haWwIgwAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkChBwc2V1ZG8tcGFnZV5t
aXNjAAAADGN1cnJlbnRfcGFnZQiBAAAADmxvZ2dlZGluX2FkbWluCIIAAAAIbG9nZ2VkaW4IggAA
AAtsb2dnZWRpbl9pZAoBMAAAAAVkZWJ1ZxcOKzYxNDgyIDE3NiAzNDMAAAAVbG9nZ2VkaW5fcGhv
bmVfbnVtYmVyFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQ==
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('498b2cd3b6da04091d39c89f9190ecbe', 'BQsDAAAABQogNDk4YjJjZDNiNmRhMDQwOTFkMzljODlmOTE5MGVjYmUAAAALX3Nlc3Npb25faWQK
D3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKAjIzAAAAC3BhZ2VfbGVuZ3RoCglsaW5r
c15DKysAAAAPY3VycmVudF9zZWN0aW9uCgExAAAABWRlYnVn
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('d54a395a7e3d035b2eab35e3e1e3eddd', 'BQsDAAAAEAogZDU0YTM5NWE3ZTNkMDM1YjJlYWIzNWUzZTFlM2VkZGQAAAALX3Nlc3Npb25faWQX
Dis2MTQ4Mi0xNzYtMzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcFZ3JpenoAAAASbG9nZ2Vk
aW5fZ3JvdXBuYW1lFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25h
bWUXBWdyaXp6AAAAEWxvZ2dlZGluX3VzZXJuYW1lFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2Vk
aW5fZ2l2ZW4KD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UKAjI1AAAAC3BhZ2VfbGVu
Z3RoCIQAAAAIbG9nZ2VkaW4IhAAAAAtsb2dnZWRpbl9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1p
bHkXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbAiFAAAAFmxvZ2dlZGluX2dy
b3Vwbm5hbWVfaWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24IgAAAAA5sb2dnZWRp
bl9hZG1pbgoBMAAAAAVkZWJ1Zw==
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('88aa7cad761ab4c62664ab011059f338', 'BQsDAAAABQoKbGlua3NecmFrdQAAAA9jdXJyZW50X3NlY3Rpb24KD3BzZXVkby1wYWdlXmFsbAAA
AAxjdXJyZW50X3BhZ2UKAjQxAAAAC3BhZ2VfbGVuZ3RoCiA4OGFhN2NhZDc2MWFiNGM2MjY2NGFi
MDExMDU5ZjMzOAAAAAtfc2Vzc2lvbl9pZAoBMAAAAAVkZWJ1Zw==
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('a5d41456a83643e9445ceb8e1f8fe4d2', 'BQsDAAAABQoCMjgAAAALcGFnZV9sZW5ndGgKC2FsaWFzXnBlcmw2AAAAD2N1cnJlbnRfc2VjdGlv
bgoQcHNldWRvLXBhZ2VebWlzYwAAAAxjdXJyZW50X3BhZ2UKATAAAAAFZGVidWcKIGE1ZDQxNDU2
YTgzNjQzZTk0NDVjZWI4ZTFmOGZlNGQyAAAAC19zZXNzaW9uX2lk
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('e1b7ae146ea967338bc75bd9ecc4b4ae', 'BQsDAAAABQogZTFiN2FlMTQ2ZWE5NjczMzhiYzc1YmQ5ZWNjNGI0YWUAAAALX3Nlc3Npb25faWQK
ATEAAAAFZGVidWcKD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDmxpbmtzXnBvc3Rn
cmVzAAAAD2N1cnJlbnRfc2VjdGlvbgoCMzkAAAALcGFnZV9sZW5ndGg=
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('da64773d703775653f795947988a29cd', 'BQsDAAAAEAiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXC2dyaXp6bHlzbWl0AAAAEmxvZ2dl
ZGluX2dyb3VwbmFtZQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZRcPRnJhbmNpcyBH
cml6emx5AAAADmxvZ2dlZGluX2dpdmVuCIIAAAALbG9nZ2VkaW5faWQIgQAAAA5sb2dnZWRpbl9h
ZG1pbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKAjI1AAAAC3BhZ2VfbGVuZ3RoFxJncml6emx5
QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXDis2MTQ4MiAxNzYgMzQzAAAAFWxvZ2dlZGlu
X3Bob25lX251bWJlcgoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoBMAAAAAVkZWJ1
ZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABFsb2dnZWRpbl91c2VybmFtZQogZGE2NDc3
M2Q3MDM3NzU2NTNmNzk1OTQ3OTg4YTI5Y2QAAAALX3Nlc3Npb25faWQXFEZyYW5jaXMgR3Jpenps
eSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQ==
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('c8ab85ca784010747adb0aad5dcb6306', 'BQsDAAAAEAoBMAAAAAVkZWJ1ZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABJsb2dnZWRp
bl9ncm91cG5hbWUKAjI1AAAAC3BhZ2VfbGVuZ3RoFwtncml6emx5c21pdAAAABFsb2dnZWRpbl91
c2VybmFtZQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA
D2N1cnJlbnRfc2VjdGlvbgiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXBFNtaXQAAAAPbG9n
Z2VkaW5fZmFtaWx5CIIAAAALbG9nZ2VkaW5faWQKIGM4YWI4NWNhNzg0MDEwNzQ3YWRiMGFhZDVk
Y2I2MzA2AAAAC19zZXNzaW9uX2lkCIEAAAAObG9nZ2VkaW5fYWRtaW4XD0ZyYW5jaXMgR3Jpenps
eQAAAA5sb2dnZWRpbl9naXZlbhcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWls
FwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFxRGcmFuY2lzIEdyaXp6bHkg
U21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWU=
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('1c8659df2843a2096c728067be7b9e01', 'BQsDAAAAEAoBMQAAAAVkZWJ1ZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABJsb2dnZWRp
bl9ncm91cG5hbWUXC2dyaXp6bHlzbWl0AAAAEWxvZ2dlZGluX3VzZXJuYW1lCg9wc2V1ZG8tcGFn
ZV5hbGwAAAAMY3VycmVudF9wYWdlCgIyNQAAAAtwYWdlX2xlbmd0aBcEU21pdAAAAA9sb2dnZWRp
bl9mYW1pbHkKDWxpbmtzXnNjcmlwdHMAAAAPY3VycmVudF9zZWN0aW9uCIMAAAAWbG9nZ2VkaW5f
Z3JvdXBubmFtZV9pZAiCAAAAC2xvZ2dlZGluX2lkCiAxYzg2NTlkZjI4NDNhMjA5NmM3MjgwNjdi
ZTdiOWUwMQAAAAtfc2Vzc2lvbl9pZAiBAAAADmxvZ2dlZGluX2FkbWluFw9GcmFuY2lzIEdyaXp6
bHkAAAAObG9nZ2VkaW5fZ2l2ZW4XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFp
bBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lFw4rNjE0ODIg
MTc2IDM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXI=
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('12d1122cc4eba147d70ae2097bb6e221', 'BQsDAAAAEAiBAAAADmxvZ2dlZGluX2FkbWluCIMAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZAoM
YWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcLZ3JpenpseXNtaXQAAAARbG9nZ2VkaW5f
dXNlcm5hbWUXC2dyaXp6bHlzbWl0AAAAEmxvZ2dlZGluX2dyb3VwbmFtZQogMTJkMTEyMmNjNGVi
YTE0N2Q3MGFlMjA5N2JiNmUyMjEAAAALX3Nlc3Npb25faWQKATAAAAAFZGVidWcXEmdyaXp6bHlA
c21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXFEZy
YW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZRcMKzYxNDgyMTc2MzQz
AAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgiCAAAAC2xvZ2dlZGluX2lkCg9wYWdlXmdyaXp6LXBh
Z2UAAAAMY3VycmVudF9wYWdlFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4IggAA
AAhsb2dnZWRpbgoCMjUAAAALcGFnZV9sZW5ndGg=
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('6066c112263af0046fa9d0b23ca1b0b9', 'BQsDAAAAEAiBAAAADmxvZ2dlZGluX2FkbWluCIIAAAALbG9nZ2VkaW5faWQIggAAAAhsb2dnZWRp
bhcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCg9wc2V1ZG8t
cGFnZV5hbGwAAAAMY3VycmVudF9wYWdlFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2
ZW4KATEAAAAFZGVidWcXC2dyaXp6bHlzbWl0AAAAEWxvZ2dlZGluX3VzZXJuYW1lCgIyNQAAAAtw
YWdlX2xlbmd0aAoWbGlua3NecG9ydGtub2NraW5nLWRldgAAAA9jdXJyZW50X3NlY3Rpb24XBFNt
aXQAAAAPbG9nZ2VkaW5fZmFtaWx5CiA2MDY2YzExMjI2M2FmMDA0NmZhOWQwYjIzY2ExYjBiOQAA
AAtfc2Vzc2lvbl9pZAiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXEmdyaXp6bHlAc21pdC5p
ZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcLZ3JpenpseXNtaXQAAAASbG9nZ2VkaW5fZ3JvdXBuYW1l
FwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVy
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('9a075a2b3a3d0a15d9b2461d1011f0de', 'BQsDAAAAEBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCg9w
YWdlXmdyaXp6LXBhZ2UAAAAMY3VycmVudF9wYWdlCIMAAAAIbG9nZ2VkaW4IgQAAAA5sb2dnZWRp
bl9hZG1pbgoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcMKzYxNDgyMTc2MzQzAAAA
FWxvZ2dlZGluX3Bob25lX251bWJlchcHZ3JpenpseQAAABJsb2dnZWRpbl9ncm91cG5hbWUXD0Zy
YW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbgogOWEwNzVhMmIzYTNkMGExNWQ5YjI0NjFk
MTAxMWYwZGUAAAALX3Nlc3Npb25faWQKAjI1AAAAC3BhZ2VfbGVuZ3RoCIMAAAALbG9nZ2VkaW5f
aWQXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5CIQAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZBcH
Z3JpenpseQAAABFsb2dnZWRpbl91c2VybmFtZQoBMAAAAAVkZWJ1ZxcSZ3JpenpseUBzbWl0Lmlk
LmF1AAAADmxvZ2dlZGluX2VtYWls
') ON CONFLICT DO NOTHING;
INSERT INTO public.sessions VALUES ('5a5965dc25adf870510ea76a4ba34053', 'BQsDAAAAEBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgoBMAAAAAVkZWJ1
ZxcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsCiA1YTU5NjVkYzI1YWRmODcw
NTEwZWE3NmE0YmEzNDA1MwAAAAtfc2Vzc2lvbl9pZBcHZ3JpenpseQAAABJsb2dnZWRpbl9ncm91
cG5hbWUKAjI1AAAAC3BhZ2VfbGVuZ3RoCIMAAAALbG9nZ2VkaW5faWQXD0ZyYW5jaXMgR3Jpenps
eQAAAA5sb2dnZWRpbl9naXZlbgiDAAAACGxvZ2dlZGluFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWls
eQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZRcHZ3JpenpseQAAABFsb2dnZWRpbl91
c2VybmFtZQiEAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQIgQAAAA5sb2dnZWRpbl9hZG1pbgoM
YWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAV
bG9nZ2VkaW5fZGlzcGxheV9uYW1l
') ON CONFLICT DO NOTHING;


--
-- Name: _group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public._group_id_seq', 13, true);


--
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.address_id_seq', 16, true);


--
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.addresses_id_seq', 1, false);


--
-- Name: alias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.alias_id_seq', 34, true);


--
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.countries_id_seq', 14, true);


--
-- Name: email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.email_id_seq', 12, true);


--
-- Name: emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.emails_id_seq', 1, false);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.groups_id_seq', 104, true);


--
-- Name: links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.links_id_seq', 37, true);


--
-- Name: links_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.links_id_seq1', 115, true);


--
-- Name: page_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.page_section_id_seq', 81, true);


--
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.pages_id_seq', 39, true);


--
-- Name: passwd_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.passwd_details_id_seq', 12, true);


--
-- Name: passwd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.passwd_id_seq', 12, true);


--
-- Name: phone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.phone_id_seq', 21, true);


--
-- Name: phones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.phones_id_seq', 1, false);


--
-- Name: psudo_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('public.psudo_pages_id_seq', 8, true);


--
-- Name: _group _group_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public._group
    ADD CONSTRAINT _group_pkey PRIMARY KEY (id);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: alias alias_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_pkey PRIMARY KEY (id);


--
-- Name: alias alias_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_unique_contraint_name UNIQUE (name);


--
-- Name: codes_prefixes codes_prefixes_pk; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.codes_prefixes
    ADD CONSTRAINT codes_prefixes_pk PRIMARY KEY (prefix);


--
-- Name: countries countries_pk; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pk PRIMARY KEY (id);


--
-- Name: countries countries_prefix_ukey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_prefix_ukey UNIQUE (prefix);


--
-- Name: email email_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_pkey PRIMARY KEY (id);


--
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_pkey PRIMARY KEY (id);


--
-- Name: _group group_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public._group
    ADD CONSTRAINT group_unique_key UNIQUE (_name);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: groups groups_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_unique_key UNIQUE (group_id, passwd_id);


--
-- Name: links_sections links_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- Name: links links_pkey1; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_pkey1 PRIMARY KEY (id);


--
-- Name: links_sections links_sections_unnique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_sections_unnique_key UNIQUE (section);


--
-- Name: links links_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_unique_contraint_name UNIQUE (section_id, name);


--
-- Name: page_section page_section_unique; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT page_section_unique UNIQUE (pages_id, links_section_id);


--
-- Name: pages page_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT page_unique_key UNIQUE (name);


--
-- Name: passwd_details passwd_details_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_pkey PRIMARY KEY (id);


--
-- Name: passwd passwd_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_pkey PRIMARY KEY (id);


--
-- Name: passwd passwd_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_unique_key UNIQUE (username);


--
-- Name: phone phone_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phone
    ADD CONSTRAINT phone_pkey PRIMARY KEY (id);


--
-- Name: phones phones_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phones
    ADD CONSTRAINT phones_pkey PRIMARY KEY (id);


--
-- Name: pages pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pkey PRIMARY KEY (id);


--
-- Name: pseudo_pages pseudo_pages_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT pseudo_pages_unique_key UNIQUE (name);


--
-- Name: page_section psge_section_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT psge_section_pkey PRIMARY KEY (id);


--
-- Name: pseudo_pages psudo_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT psudo_pages_pkey PRIMARY KEY (id);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: fki_section_fkey; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE INDEX fki_section_fkey ON public.links USING btree (section_id);


--
-- Name: links_sections_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX links_sections_unique_key ON public.links_sections USING btree (section COLLATE "C" text_pattern_ops);


--
-- Name: links_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX links_unique_key ON public.links USING btree (name COLLATE "POSIX" bpchar_pattern_ops, section_id);

ALTER TABLE public.links CLUSTER ON links_unique_key;


--
-- Name: addresses addresses_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_address_id_fkey FOREIGN KEY (address_id) REFERENCES public.address(id) NOT VALID;


--
-- Name: addresses addresses_passwd_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_passwd_id_fkey FOREIGN KEY (passwd_id) REFERENCES public.passwd(id) NOT VALID;


--
-- Name: alias alias_foriegn_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_foriegn_key FOREIGN KEY (target) REFERENCES public.links_sections(id) NOT VALID;


--
-- Name: alias alias_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- Name: alias alias_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- Name: emails emails_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_address_fkey FOREIGN KEY (address_id) REFERENCES public.address(id);


--
-- Name: emails emails_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.emails
    ADD CONSTRAINT emails_email_fkey FOREIGN KEY (email_id) REFERENCES public.email(id);


--
-- Name: groups groups_address_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_address_foreign_key FOREIGN KEY (passwd_id) REFERENCES public.passwd(id);


--
-- Name: groups groups_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_foreign_key FOREIGN KEY (group_id) REFERENCES public._group(id);


--
-- Name: links links_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- Name: page_section links_section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT links_section_fkey FOREIGN KEY (links_section_id) REFERENCES public.links_sections(id);


--
-- Name: links_sections links_sections_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_sections_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- Name: links_sections links_sections_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_sections_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- Name: links links_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- Name: page_section page_section_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT page_section_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- Name: page_section page_section_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT page_section_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- Name: page_section pages_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT pages_fkey FOREIGN KEY (pages_id) REFERENCES public.pages(id);


--
-- Name: pages pages_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- Name: pages pages_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pages_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- Name: passwd_details passwd_details_cc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_cc_fkey FOREIGN KEY (countries_id) REFERENCES public.countries(id) NOT VALID;


--
-- Name: passwd passwd_details_connection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_details_connection_fkey FOREIGN KEY (passwd_details_id) REFERENCES public.passwd_details(id) NOT VALID;


--
-- Name: passwd_details passwd_details_p_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_p_phone_fkey FOREIGN KEY (primary_phone_id) REFERENCES public.phone(id) NOT VALID;


--
-- Name: passwd_details passwd_details_post_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_post_foreign_key FOREIGN KEY (postal_address_id) REFERENCES public.address(id);


--
-- Name: passwd_details passwd_details_res_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_res_foreign_key FOREIGN KEY (residential_address_id) REFERENCES public.address(id);


--
-- Name: passwd_details passwd_details_sec_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd_details
    ADD CONSTRAINT passwd_details_sec_phone_fkey FOREIGN KEY (secondary_phone_id) REFERENCES public.phone(id) NOT VALID;


--
-- Name: passwd passwd_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_group_fkey FOREIGN KEY (primary_group_id) REFERENCES public._group(id) NOT VALID;


--
-- Name: passwd passwd_primary_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.passwd
    ADD CONSTRAINT passwd_primary_email_fkey FOREIGN KEY (email_id) REFERENCES public.email(id) NOT VALID;


--
-- Name: phones phones_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phones
    ADD CONSTRAINT phones_address_fkey FOREIGN KEY (address_id) REFERENCES public.address(id);


--
-- Name: phones phones_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.phones
    ADD CONSTRAINT phones_phone_fkey FOREIGN KEY (phone_id) REFERENCES public.phone(id);


--
-- Name: pseudo_pages pseudo_pages_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT pseudo_pages_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id) NOT VALID;


--
-- Name: pseudo_pages pseudo_pages_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT pseudo_pages_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id) NOT VALID;


--
-- Name: links section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT section_fkey FOREIGN KEY (section_id) REFERENCES public.links_sections(id) ON UPDATE RESTRICT;


--
-- Name: secure secure_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.secure
    ADD CONSTRAINT secure_groupid_fkey FOREIGN KEY (groupid) REFERENCES public._group(id);


--
-- Name: secure secure_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.secure
    ADD CONSTRAINT secure_userid_fkey FOREIGN KEY (userid) REFERENCES public.passwd(id);


--
-- Name: TYPE perm_set; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON TYPE public.perm_set TO urluser WITH GRANT OPTION;


--
-- Name: TYPE perms; Type: ACL; Schema: public; Owner: grizzlysmit
--

REVOKE ALL ON TYPE public.perms FROM grizzlysmit;
GRANT ALL ON TYPE public.perms TO urluser WITH GRANT OPTION;
GRANT ALL ON TYPE public.perms TO grizzlysmit WITH GRANT OPTION;


--
-- Name: SEQUENCE _group_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public._group_id_seq TO urluser;


--
-- Name: TABLE _group; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON TABLE public._group TO urluser;


--
-- Name: SEQUENCE address_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.address_id_seq TO urluser;


--
-- Name: TABLE address; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.address TO urluser;


--
-- Name: TABLE addresses; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.addresses TO urluser;


--
-- Name: TABLE secure; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.secure TO urluser;


--
-- Name: TABLE alias; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias TO urluser;


--
-- Name: SEQUENCE alias_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.alias_id_seq TO urluser;


--
-- Name: SEQUENCE links_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.links_id_seq TO urluser;


--
-- Name: TABLE links_sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.links_sections TO urluser;


--
-- Name: TABLE alias_links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias_links TO urluser;


--
-- Name: TABLE links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.links TO urluser;


--
-- Name: TABLE alias_union_links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias_union_links TO urluser;


--
-- Name: TABLE alias_union_links_sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias_union_links_sections TO urluser;


--
-- Name: TABLE aliases; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.aliases TO urluser;


--
-- Name: TABLE codes_prefixes; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.codes_prefixes TO urluser;


--
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.countries TO urluser;


--
-- Name: SEQUENCE email_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.email_id_seq TO urluser;


--
-- Name: TABLE email; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.email TO urluser;


--
-- Name: SEQUENCE emails_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.emails_id_seq TO urluser;


--
-- Name: TABLE emails; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.emails TO urluser;


--
-- Name: SEQUENCE groups_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.groups_id_seq TO urluser;


--
-- Name: TABLE groups; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.groups TO urluser;


--
-- Name: SEQUENCE links_id_seq1; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.links_id_seq1 TO urluser;


--
-- Name: TABLE links_sections_join_links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.links_sections_join_links TO urluser;


--
-- Name: TABLE page_section; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_section TO urluser;


--
-- Name: TABLE pages; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pages TO urluser;


--
-- Name: TABLE page_link_view; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_link_view TO urluser;


--
-- Name: SEQUENCE page_section_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.page_section_id_seq TO urluser;


--
-- Name: TABLE page_view; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_view TO urluser;


--
-- Name: TABLE pseudo_pages; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pseudo_pages TO urluser;


--
-- Name: TABLE pagelike; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pagelike TO urluser;


--
-- Name: SEQUENCE pages_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.pages_id_seq TO urluser;


--
-- Name: SEQUENCE passwd_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.passwd_id_seq TO urluser;


--
-- Name: TABLE passwd; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.passwd TO urluser;


--
-- Name: SEQUENCE passwd_details_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.passwd_details_id_seq TO urluser;


--
-- Name: TABLE passwd_details; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.passwd_details TO urluser;


--
-- Name: SEQUENCE phone_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.phone_id_seq TO urluser;


--
-- Name: TABLE phone; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.phone TO urluser;


--
-- Name: SEQUENCE phones_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.phones_id_seq TO urluser;


--
-- Name: TABLE phones; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.phones TO urluser;


--
-- Name: SEQUENCE psudo_pages_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.psudo_pages_id_seq TO urluser;


--
-- Name: TABLE sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.sections TO urluser;


--
-- Name: TABLE sessions; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.sessions TO urluser;


--
-- Name: TABLE vlinks; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.vlinks TO urluser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: grizzlysmit
--

ALTER DEFAULT PRIVILEGES FOR ROLE grizzlysmit GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLES  TO urluser;


--
-- PostgreSQL database dump complete
--

