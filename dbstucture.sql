--
-- PostgreSQL database dump
--

-- Dumped from database version 11.7 (Ubuntu 11.7-0ubuntu0.19.10.1)
-- Dumped by pg_dump version 13.5 (Ubuntu 13.5-0ubuntu0.21.10.1)

-- Started on 2022-03-01 18:48:53 AEDT

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

DROP DATABASE urls;
--
-- TOC entry 3652 (class 1262 OID 21160)
-- Name: urls; Type: DATABASE; Schema: -; Owner: grizzlysmit
--

CREATE DATABASE urls WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_AU.UTF-8';


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
-- TOC entry 3654 (class 0 OID 0)
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
-- TOC entry 625 (class 1247 OID 21235)
-- Name: status; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE public.status AS ENUM (
    'invalid',
    'unassigned',
    'assigned',
    'both'
);


ALTER TYPE public.status OWNER TO grizzlysmit;

SET default_tablespace = '';

--
-- TOC entry 208 (class 1259 OID 21263)
-- Name: alias; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.alias (
    id bigint NOT NULL,
    name character varying(50) NOT NULL,
    target bigint NOT NULL
);


ALTER TABLE public.alias OWNER TO grizzlysmit;

--
-- TOC entry 207 (class 1259 OID 21261)
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
-- TOC entry 3656 (class 0 OID 0)
-- Dependencies: 207
-- Name: alias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.alias_id_seq OWNED BY public.alias.id;


--
-- TOC entry 198 (class 1259 OID 21173)
-- Name: links; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.links (
    id bigint NOT NULL,
    section_id bigint,
    link character varying(4096),
    name character varying(50) NOT NULL
);


ALTER TABLE public.links OWNER TO grizzlysmit;

--
-- TOC entry 196 (class 1259 OID 21161)
-- Name: links_sections; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.links_sections (
    id bigint NOT NULL,
    section character varying(50) NOT NULL
);


ALTER TABLE public.links_sections OWNER TO grizzlysmit;

--
-- TOC entry 214 (class 1259 OID 21324)
-- Name: alias_union_links; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.alias_union_links AS
 SELECT 'alias'::text AS type,
    a.id,
    a.name AS alias_name,
    ls.section,
    l.name,
    l.link
   FROM ((public.alias a
     JOIN public.links_sections ls ON ((a.target = ls.id)))
     JOIN public.links l ON ((ls.id = l.section_id)))
UNION
 SELECT 'links'::text AS type,
    ls.id,
    ls.section AS alias_name,
    ls.section,
    l.name,
    l.link
   FROM (public.links_sections ls
     JOIN public.links l ON ((ls.id = l.section_id)));


ALTER TABLE public.alias_union_links OWNER TO grizzlysmit;

--
-- TOC entry 210 (class 1259 OID 21289)
-- Name: alias_union_links_sections; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.alias_union_links_sections AS
 SELECT 'alias'::text AS type,
    a.id,
    a.name,
    ls.section
   FROM (public.alias a
     JOIN public.links_sections ls ON ((a.target = ls.id)))
UNION
 SELECT 'links'::text AS type,
    ls.id,
    ls.section AS name,
    ls.section
   FROM public.links_sections ls;


ALTER TABLE public.alias_union_links_sections OWNER TO grizzlysmit;

--
-- TOC entry 209 (class 1259 OID 21285)
-- Name: aliases; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.aliases AS
 SELECT a.id,
    a.name,
    a.target,
    ls.section
   FROM (public.alias a
     JOIN public.links_sections ls ON ((a.target = ls.id)));


ALTER TABLE public.aliases OWNER TO grizzlysmit;

--
-- TOC entry 197 (class 1259 OID 21164)
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
-- TOC entry 3663 (class 0 OID 0)
-- Dependencies: 197
-- Name: links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.links_id_seq OWNED BY public.links_sections.id;


--
-- TOC entry 199 (class 1259 OID 21176)
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
-- TOC entry 3665 (class 0 OID 0)
-- Dependencies: 199
-- Name: links_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.links_id_seq1 OWNED BY public.links.id;


--
-- TOC entry 203 (class 1259 OID 21210)
-- Name: page_section; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.page_section (
    id bigint NOT NULL,
    pages_id bigint,
    links_section_id bigint
);


ALTER TABLE public.page_section OWNER TO grizzlysmit;

--
-- TOC entry 201 (class 1259 OID 21196)
-- Name: pages; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.pages (
    id bigint NOT NULL,
    name character varying(256),
    full_name character varying(50) NOT NULL
);


ALTER TABLE public.pages OWNER TO grizzlysmit;

--
-- TOC entry 213 (class 1259 OID 21307)
-- Name: page_link_view; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.page_link_view AS
 SELECT p.id,
    p.name AS page_name,
    p.full_name,
    ls.section,
    l.name,
    l.link
   FROM (((public.pages p
     JOIN public.page_section ps ON ((p.id = ps.pages_id)))
     JOIN public.links_sections ls ON ((ls.id = ps.links_section_id)))
     JOIN public.links l ON ((l.section_id = ls.id)));


ALTER TABLE public.page_link_view OWNER TO grizzlysmit;

--
-- TOC entry 202 (class 1259 OID 21208)
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
-- TOC entry 3670 (class 0 OID 0)
-- Dependencies: 202
-- Name: page_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.page_section_id_seq OWNED BY public.page_section.id;


--
-- TOC entry 212 (class 1259 OID 21303)
-- Name: page_view; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.page_view AS
 SELECT p.id,
    p.name,
    p.full_name,
    ls.section
   FROM ((public.pages p
     JOIN public.page_section ps ON ((p.id = ps.pages_id)))
     JOIN public.links_sections ls ON ((ls.id = ps.links_section_id)));


ALTER TABLE public.page_view OWNER TO grizzlysmit;

--
-- TOC entry 200 (class 1259 OID 21194)
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
-- TOC entry 3673 (class 0 OID 0)
-- Dependencies: 200
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.pages_id_seq OWNED BY public.pages.id;


--
-- TOC entry 205 (class 1259 OID 21228)
-- Name: pseudo_pages; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE public.pseudo_pages (
    id bigint NOT NULL,
    pattern character varying(256),
    status public.status DEFAULT 'invalid'::public.status NOT NULL,
    name character varying(50),
    full_name character varying(256)
);


ALTER TABLE public.pseudo_pages OWNER TO grizzlysmit;

--
-- TOC entry 204 (class 1259 OID 21226)
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
-- TOC entry 3676 (class 0 OID 0)
-- Dependencies: 204
-- Name: psudo_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE public.psudo_pages_id_seq OWNED BY public.pseudo_pages.id;


--
-- TOC entry 211 (class 1259 OID 21299)
-- Name: sections; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.sections AS
 SELECT 'alias'::text AS type,
    a.id,
    a.name AS section
   FROM public.alias a
UNION
 SELECT 'links'::text AS type,
    ls.id,
    ls.section
   FROM public.links_sections ls
UNION
 SELECT 'page'::text AS type,
    p.id,
    p.name AS section
   FROM public.pages p
UNION
 SELECT 'pseudo-page'::text AS type,
    pp.id,
    pp.name AS section
   FROM public.pseudo_pages pp;


ALTER TABLE public.sections OWNER TO grizzlysmit;

--
-- TOC entry 206 (class 1259 OID 21248)
-- Name: vlinks; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW public.vlinks AS
 SELECT ls.section,
    l.name,
    l.link
   FROM (public.links_sections ls
     JOIN public.links l ON ((l.section_id = ls.id)));


ALTER TABLE public.vlinks OWNER TO grizzlysmit;

--
-- TOC entry 3492 (class 2604 OID 21266)
-- Name: alias id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias ALTER COLUMN id SET DEFAULT nextval('public.alias_id_seq'::regclass);


--
-- TOC entry 3487 (class 2604 OID 21178)
-- Name: links id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links ALTER COLUMN id SET DEFAULT nextval('public.links_id_seq1'::regclass);


--
-- TOC entry 3486 (class 2604 OID 21166)
-- Name: links_sections id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections ALTER COLUMN id SET DEFAULT nextval('public.links_id_seq'::regclass);


--
-- TOC entry 3489 (class 2604 OID 21213)
-- Name: page_section id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section ALTER COLUMN id SET DEFAULT nextval('public.page_section_id_seq'::regclass);


--
-- TOC entry 3488 (class 2604 OID 21199)
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages ALTER COLUMN id SET DEFAULT nextval('public.pages_id_seq'::regclass);


--
-- TOC entry 3490 (class 2604 OID 21231)
-- Name: pseudo_pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages ALTER COLUMN id SET DEFAULT nextval('public.psudo_pages_id_seq'::regclass);


--
-- TOC entry 3511 (class 2606 OID 21268)
-- Name: alias alias_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_pkey PRIMARY KEY (id);


--
-- TOC entry 3513 (class 2606 OID 21282)
-- Name: alias alias_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_unique_contraint_name UNIQUE (name);


--
-- TOC entry 3494 (class 2606 OID 21168)
-- Name: links_sections links_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links_sections
    ADD CONSTRAINT links_pkey PRIMARY KEY (id);


--
-- TOC entry 3498 (class 2606 OID 21180)
-- Name: links links_pkey1; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_pkey1 PRIMARY KEY (id);


--
-- TOC entry 3500 (class 2606 OID 21284)
-- Name: links links_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT links_unique_contraint_name UNIQUE (section_id, name);


--
-- TOC entry 3505 (class 2606 OID 21294)
-- Name: page_section page_section_unique; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT page_section_unique UNIQUE (pages_id, links_section_id);


--
-- TOC entry 3503 (class 2606 OID 21201)
-- Name: pages pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pages
    ADD CONSTRAINT pkey PRIMARY KEY (id);


--
-- TOC entry 3507 (class 2606 OID 21215)
-- Name: page_section psge_section_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT psge_section_pkey PRIMARY KEY (id);


--
-- TOC entry 3509 (class 2606 OID 21233)
-- Name: pseudo_pages psudo_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.pseudo_pages
    ADD CONSTRAINT psudo_pages_pkey PRIMARY KEY (id);


--
-- TOC entry 3514 (class 1259 OID 21280)
-- Name: alias_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX alias_unique_key ON public.alias USING btree (name COLLATE "C.UTF-8" varchar_ops);


--
-- TOC entry 3496 (class 1259 OID 21190)
-- Name: fki_section_fkey; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE INDEX fki_section_fkey ON public.links USING btree (section_id);


--
-- TOC entry 3495 (class 1259 OID 21258)
-- Name: links_sections_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX links_sections_unique_key ON public.links_sections USING btree (section COLLATE "C" text_pattern_ops);


--
-- TOC entry 3501 (class 1259 OID 21259)
-- Name: links_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX links_unique_key ON public.links USING btree (name COLLATE "POSIX" bpchar_pattern_ops, section_id);

ALTER TABLE public.links CLUSTER ON links_unique_key;


--
-- TOC entry 3518 (class 2606 OID 21272)
-- Name: alias alias_foriegn_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.alias
    ADD CONSTRAINT alias_foriegn_key FOREIGN KEY (target) REFERENCES public.links_sections(id) MATCH FULL ON UPDATE RESTRICT ON DELETE RESTRICT NOT VALID;


--
-- TOC entry 3517 (class 2606 OID 21221)
-- Name: page_section links_section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT links_section_fkey FOREIGN KEY (links_section_id) REFERENCES public.links_sections(id);


--
-- TOC entry 3516 (class 2606 OID 21216)
-- Name: page_section pages_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.page_section
    ADD CONSTRAINT pages_fkey FOREIGN KEY (pages_id) REFERENCES public.pages(id);


--
-- TOC entry 3515 (class 2606 OID 21185)
-- Name: links section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY public.links
    ADD CONSTRAINT section_fkey FOREIGN KEY (section_id) REFERENCES public.links_sections(id) ON UPDATE RESTRICT;


--
-- TOC entry 3653 (class 0 OID 0)
-- Dependencies: 3652
-- Name: DATABASE urls; Type: ACL; Schema: -; Owner: grizzlysmit
--

GRANT CONNECT ON DATABASE urls TO urluser;


--
-- TOC entry 3655 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE alias; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias TO urluser;


--
-- TOC entry 3657 (class 0 OID 0)
-- Dependencies: 207
-- Name: SEQUENCE alias_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.alias_id_seq TO urluser;


--
-- TOC entry 3658 (class 0 OID 0)
-- Dependencies: 198
-- Name: TABLE links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.links TO urluser;


--
-- TOC entry 3659 (class 0 OID 0)
-- Dependencies: 196
-- Name: TABLE links_sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.links_sections TO urluser;


--
-- TOC entry 3660 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE alias_union_links; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias_union_links TO urluser;


--
-- TOC entry 3661 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE alias_union_links_sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.alias_union_links_sections TO urluser;


--
-- TOC entry 3662 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE aliases; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.aliases TO urluser;


--
-- TOC entry 3664 (class 0 OID 0)
-- Dependencies: 197
-- Name: SEQUENCE links_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.links_id_seq TO urluser;


--
-- TOC entry 3666 (class 0 OID 0)
-- Dependencies: 199
-- Name: SEQUENCE links_id_seq1; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.links_id_seq1 TO urluser;


--
-- TOC entry 3667 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE page_section; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_section TO urluser;


--
-- TOC entry 3668 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE pages; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pages TO urluser;


--
-- TOC entry 3669 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE page_link_view; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_link_view TO urluser;


--
-- TOC entry 3671 (class 0 OID 0)
-- Dependencies: 202
-- Name: SEQUENCE page_section_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.page_section_id_seq TO urluser;


--
-- TOC entry 3672 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE page_view; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.page_view TO urluser;


--
-- TOC entry 3674 (class 0 OID 0)
-- Dependencies: 200
-- Name: SEQUENCE pages_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.pages_id_seq TO urluser;


--
-- TOC entry 3675 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE pseudo_pages; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.pseudo_pages TO urluser;


--
-- TOC entry 3677 (class 0 OID 0)
-- Dependencies: 204
-- Name: SEQUENCE psudo_pages_id_seq; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE public.psudo_pages_id_seq TO urluser;


--
-- TOC entry 3678 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE sections; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.sections TO urluser;


--
-- TOC entry 3679 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE vlinks; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE public.vlinks TO urluser;


--
-- TOC entry 1740 (class 826 OID 21260)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: grizzlysmit
--

ALTER DEFAULT PRIVILEGES FOR ROLE grizzlysmit GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLES  TO urluser;


-- Completed on 2022-03-01 18:48:54 AEDT

--
-- PostgreSQL database dump complete
--

