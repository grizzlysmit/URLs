--
-- PostgreSQL database dump
--

-- Dumped from database version 11.7 (Ubuntu 11.7-0ubuntu0.19.10.1)
-- Dumped by pg_dump version 13.6 (Ubuntu 13.6-0ubuntu0.21.10.1)

-- Started on 2022-04-15 15:23:57 AEST

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

DROP DATABASE "urls";
--
-- TOC entry 3870 (class 1262 OID 21160)
-- Name: urls; Type: DATABASE; Schema: -; Owner: grizzlysmit
--

CREATE DATABASE "urls" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_AU.UTF-8';


ALTER DATABASE "urls" OWNER TO "grizzlysmit";

\connect "urls"

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
-- TOC entry 3872 (class 0 OID 0)
-- Name: urls; Type: DATABASE PROPERTIES; Schema: -; Owner: grizzlysmit
--

ALTER ROLE "urluser" IN DATABASE "urls" SET "client_encoding" TO 'UTF-8';


\connect "urls"

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
-- TOC entry 742 (class 1247 OID 21527)
-- Name: perm_set; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE "public"."perm_set" AS (
	"_read" boolean,
	"_write" boolean,
	"_del" boolean
);


ALTER TYPE "public"."perm_set" OWNER TO "grizzlysmit";

--
-- TOC entry 743 (class 1247 OID 21546)
-- Name: perms; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE "public"."perms" AS (
	"_user" "public"."perm_set",
	"_group" "public"."perm_set",
	"_other" "public"."perm_set"
);


ALTER TYPE "public"."perms" OWNER TO "grizzlysmit";

--
-- TOC entry 650 (class 1247 OID 21235)
-- Name: status; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE "public"."status" AS ENUM (
    'invalid',
    'unassigned',
    'assigned',
    'both'
);


ALTER TYPE "public"."status" OWNER TO "grizzlysmit";

--
-- TOC entry 227 (class 1259 OID 21426)
-- Name: _group_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."_group_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."_group_id_seq" OWNER TO "grizzlysmit";

SET default_tablespace = '';

--
-- TOC entry 228 (class 1259 OID 21428)
-- Name: _group; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."_group" (
    "id" bigint DEFAULT "nextval"('"public"."_group_id_seq"'::"regclass") NOT NULL,
    "_name" character varying(256) NOT NULL
);


ALTER TABLE "public"."_group" OWNER TO "grizzlysmit";

--
-- TOC entry 221 (class 1259 OID 21381)
-- Name: address_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."address_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."address_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 222 (class 1259 OID 21383)
-- Name: address; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."address" (
    "id" bigint DEFAULT "nextval"('"public"."address_id_seq"'::"regclass") NOT NULL,
    "unit" character varying(32),
    "street" character varying(256) NOT NULL,
    "city_suburb" character varying(64),
    "postcode" character varying(16),
    "region" character varying(128),
    "country" character varying(128) NOT NULL
);


ALTER TABLE "public"."address" OWNER TO "grizzlysmit";

--
-- TOC entry 239 (class 1259 OID 21563)
-- Name: secure; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."secure" (
    "userid" bigint DEFAULT 1 NOT NULL,
    "groupid" bigint DEFAULT 1 NOT NULL,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)) NOT NULL
);


ALTER TABLE "public"."secure" OWNER TO "grizzlysmit";

--
-- TOC entry 208 (class 1259 OID 21263)
-- Name: alias; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."alias" (
    "id" bigint NOT NULL,
    "name" character varying(50) NOT NULL,
    "target" bigint NOT NULL,
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false))
)
INHERITS ("public"."secure");


ALTER TABLE "public"."alias" OWNER TO "grizzlysmit";

--
-- TOC entry 207 (class 1259 OID 21261)
-- Name: alias_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."alias_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."alias_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 3881 (class 0 OID 0)
-- Dependencies: 207
-- Name: alias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE "public"."alias_id_seq" OWNED BY "public"."alias"."id";


--
-- TOC entry 197 (class 1259 OID 21164)
-- Name: links_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."links_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."links_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 196 (class 1259 OID 21161)
-- Name: links_sections; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."links_sections" (
    "id" bigint DEFAULT "nextval"('"public"."links_id_seq"'::"regclass") NOT NULL,
    "section" character varying(50) NOT NULL,
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false))
)
INHERITS ("public"."secure");


ALTER TABLE "public"."links_sections" OWNER TO "grizzlysmit";

--
-- TOC entry 216 (class 1259 OID 21337)
-- Name: alias_links; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW "public"."alias_links" AS
 SELECT 'alias'::"text" AS "type",
    "a"."id",
    "a"."name" AS "section",
    "a"."userid",
    "a"."groupid",
    "a"."_perms"
   FROM "public"."alias" "a"
UNION
 SELECT 'links'::"text" AS "type",
    "ls"."id",
    "ls"."section",
    "ls"."userid",
    "ls"."groupid",
    "ls"."_perms"
   FROM "public"."links_sections" "ls";


ALTER TABLE "public"."alias_links" OWNER TO "grizzlysmit";

--
-- TOC entry 198 (class 1259 OID 21173)
-- Name: links; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."links" (
    "id" bigint NOT NULL,
    "section_id" bigint NOT NULL,
    "link" character varying(4096),
    "name" character varying(50) NOT NULL,
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false))
)
INHERITS ("public"."secure");


ALTER TABLE "public"."links" OWNER TO "grizzlysmit";

--
-- TOC entry 214 (class 1259 OID 21324)
-- Name: alias_union_links; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW "public"."alias_union_links" AS
 SELECT 'alias'::"text" AS "type",
    "a"."id",
    "a"."name" AS "alias_name",
    "ls"."section",
    "l"."name",
    "l"."link",
    "a"."userid",
    "a"."groupid",
    "a"."_perms"
   FROM (("public"."alias" "a"
     JOIN "public"."links_sections" "ls" ON (("a"."target" = "ls"."id")))
     JOIN "public"."links" "l" ON (("ls"."id" = "l"."section_id")))
UNION
 SELECT 'links'::"text" AS "type",
    "ls"."id",
    "ls"."section" AS "alias_name",
    "ls"."section",
    "l"."name",
    "l"."link",
    "ls"."userid",
    "ls"."groupid",
    "ls"."_perms"
   FROM ("public"."links_sections" "ls"
     JOIN "public"."links" "l" ON (("ls"."id" = "l"."section_id")));


ALTER TABLE "public"."alias_union_links" OWNER TO "grizzlysmit";

--
-- TOC entry 210 (class 1259 OID 21289)
-- Name: alias_union_links_sections; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW "public"."alias_union_links_sections" AS
 SELECT 'alias'::"text" AS "type",
    "a"."id",
    "a"."name",
    "ls"."section",
    "a"."userid",
    "a"."groupid",
    "a"."_perms"
   FROM ("public"."alias" "a"
     JOIN "public"."links_sections" "ls" ON (("a"."target" = "ls"."id")))
UNION
 SELECT 'links'::"text" AS "type",
    "ls"."id",
    "ls"."section" AS "name",
    "ls"."section",
    "ls"."userid",
    "ls"."groupid",
    "ls"."_perms"
   FROM "public"."links_sections" "ls";


ALTER TABLE "public"."alias_union_links_sections" OWNER TO "grizzlysmit";

--
-- TOC entry 209 (class 1259 OID 21285)
-- Name: aliases; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW "public"."aliases" AS
 SELECT "a"."id",
    "a"."name",
    "a"."target",
    "ls"."section",
    "a"."userid",
    "a"."groupid",
    "a"."_perms"
   FROM ("public"."alias" "a"
     JOIN "public"."links_sections" "ls" ON (("a"."target" = "ls"."id")));


ALTER TABLE "public"."aliases" OWNER TO "grizzlysmit";

--
-- TOC entry 231 (class 1259 OID 21464)
-- Name: email_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."email_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."email_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 232 (class 1259 OID 21466)
-- Name: email; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."email" (
    "id" bigint DEFAULT "nextval"('"public"."email_id_seq"'::"regclass") NOT NULL,
    "_email" character varying(256) NOT NULL,
    "verified" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."email" OWNER TO "grizzlysmit";

--
-- TOC entry 235 (class 1259 OID 21505)
-- Name: emails_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."emails_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."emails_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 236 (class 1259 OID 21507)
-- Name: emails; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."emails" (
    "id" bigint DEFAULT "nextval"('"public"."emails_id_seq"'::"regclass") NOT NULL,
    "email_id" bigint NOT NULL,
    "address_id" bigint NOT NULL
);


ALTER TABLE "public"."emails" OWNER TO "grizzlysmit";

--
-- TOC entry 229 (class 1259 OID 21436)
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."groups_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."groups_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 230 (class 1259 OID 21438)
-- Name: groups; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."groups" (
    "id" bigint DEFAULT "nextval"('"public"."groups_id_seq"'::"regclass") NOT NULL,
    "group_id" bigint NOT NULL,
    "passwd_id" bigint NOT NULL
);


ALTER TABLE "public"."groups" OWNER TO "grizzlysmit";

--
-- TOC entry 199 (class 1259 OID 21176)
-- Name: links_id_seq1; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."links_id_seq1"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."links_id_seq1" OWNER TO "grizzlysmit";

--
-- TOC entry 3896 (class 0 OID 0)
-- Dependencies: 199
-- Name: links_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE "public"."links_id_seq1" OWNED BY "public"."links"."id";


--
-- TOC entry 218 (class 1259 OID 21349)
-- Name: links_sections_join_links; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW "public"."links_sections_join_links" AS
 SELECT "ls"."section",
    "l"."name",
    "l"."link",
    "ls"."userid",
    "ls"."groupid",
    "ls"."_perms"
   FROM ("public"."links_sections" "ls"
     JOIN "public"."links" "l" ON (("ls"."id" = "l"."section_id")))
  ORDER BY "ls"."section", "l"."name";


ALTER TABLE "public"."links_sections_join_links" OWNER TO "grizzlysmit";

--
-- TOC entry 203 (class 1259 OID 21210)
-- Name: page_section; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."page_section" (
    "id" bigint NOT NULL,
    "pages_id" bigint NOT NULL,
    "links_section_id" bigint NOT NULL,
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false))
)
INHERITS ("public"."secure");


ALTER TABLE "public"."page_section" OWNER TO "grizzlysmit";

--
-- TOC entry 201 (class 1259 OID 21196)
-- Name: pages; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."pages" (
    "id" bigint NOT NULL,
    "name" character varying(256),
    "full_name" character varying(50) NOT NULL,
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false))
)
INHERITS ("public"."secure");


ALTER TABLE "public"."pages" OWNER TO "grizzlysmit";

--
-- TOC entry 213 (class 1259 OID 21307)
-- Name: page_link_view; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW "public"."page_link_view" AS
 SELECT "p"."id",
    "p"."name" AS "page_name",
    "p"."full_name",
    "ls"."section",
    "l"."name",
    "l"."link",
    "p"."userid",
    "p"."groupid",
    "p"."_perms"
   FROM ((("public"."pages" "p"
     JOIN "public"."page_section" "ps" ON (("p"."id" = "ps"."pages_id")))
     JOIN "public"."links_sections" "ls" ON (("ls"."id" = "ps"."links_section_id")))
     JOIN "public"."links" "l" ON (("l"."section_id" = "ls"."id")));


ALTER TABLE "public"."page_link_view" OWNER TO "grizzlysmit";

--
-- TOC entry 202 (class 1259 OID 21208)
-- Name: page_section_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."page_section_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."page_section_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 3902 (class 0 OID 0)
-- Dependencies: 202
-- Name: page_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE "public"."page_section_id_seq" OWNED BY "public"."page_section"."id";


--
-- TOC entry 212 (class 1259 OID 21303)
-- Name: page_view; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW "public"."page_view" AS
 SELECT "p"."id",
    "p"."name",
    "p"."full_name",
    "ls"."section",
    "p"."userid",
    "p"."groupid",
    "p"."_perms"
   FROM (("public"."pages" "p"
     JOIN "public"."page_section" "ps" ON (("p"."id" = "ps"."pages_id")))
     JOIN "public"."links_sections" "ls" ON (("ls"."id" = "ps"."links_section_id")));


ALTER TABLE "public"."page_view" OWNER TO "grizzlysmit";

--
-- TOC entry 205 (class 1259 OID 21228)
-- Name: pseudo_pages; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."pseudo_pages" (
    "id" bigint NOT NULL,
    "pattern" character varying(256),
    "status" "public"."status" DEFAULT 'invalid'::"public"."status" NOT NULL,
    "name" character varying(50),
    "full_name" character varying(256),
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false))
)
INHERITS ("public"."secure");


ALTER TABLE "public"."pseudo_pages" OWNER TO "grizzlysmit";

--
-- TOC entry 215 (class 1259 OID 21333)
-- Name: pagelike; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW "public"."pagelike" AS
 SELECT 'page'::"text" AS "type",
    "p"."name",
    "p"."full_name",
    "p"."userid",
    "p"."groupid",
    "p"."_perms"
   FROM "public"."pages" "p"
UNION
 SELECT 'pseudo-page'::"text" AS "type",
    "pp"."name",
    "pp"."full_name",
    "pp"."userid",
    "pp"."groupid",
    "pp"."_perms"
   FROM "public"."pseudo_pages" "pp";


ALTER TABLE "public"."pagelike" OWNER TO "grizzlysmit";

--
-- TOC entry 200 (class 1259 OID 21194)
-- Name: pages_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."pages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."pages_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 3907 (class 0 OID 0)
-- Dependencies: 200
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE "public"."pages_id_seq" OWNED BY "public"."pages"."id";


--
-- TOC entry 219 (class 1259 OID 21366)
-- Name: passwd_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."passwd_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."passwd_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 220 (class 1259 OID 21368)
-- Name: passwd; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."passwd" (
    "id" bigint DEFAULT "nextval"('"public"."passwd_id_seq"'::"regclass") NOT NULL,
    "username" character varying(100) NOT NULL,
    "_password" character varying(144),
    "passwd_details_id" bigint NOT NULL,
    "primary_group_id" bigint NOT NULL,
    "_admin" boolean DEFAULT false NOT NULL,
    "email_id" bigint NOT NULL
);


ALTER TABLE "public"."passwd" OWNER TO "grizzlysmit";

--
-- TOC entry 225 (class 1259 OID 21405)
-- Name: passwd_details_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."passwd_details_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."passwd_details_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 226 (class 1259 OID 21407)
-- Name: passwd_details; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."passwd_details" (
    "id" bigint DEFAULT "nextval"('"public"."passwd_details_id_seq"'::"regclass") NOT NULL,
    "display_name" character varying(256),
    "given" character varying(256),
    "_family" character varying(128),
    "residential_address_id" bigint NOT NULL,
    "postal_address_id" bigint NOT NULL,
    "primary_phone_id" bigint,
    "primary_email_id" bigint NOT NULL
);


ALTER TABLE "public"."passwd_details" OWNER TO "grizzlysmit";

--
-- TOC entry 223 (class 1259 OID 21392)
-- Name: phone_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."phone_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."phone_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 224 (class 1259 OID 21394)
-- Name: phone; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."phone" (
    "id" bigint DEFAULT "nextval"('"public"."phone_id_seq"'::"regclass") NOT NULL,
    "_number" character varying(128) NOT NULL,
    "verified" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."phone" OWNER TO "grizzlysmit";

--
-- TOC entry 233 (class 1259 OID 21487)
-- Name: phones_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."phones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."phones_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 234 (class 1259 OID 21489)
-- Name: phones; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."phones" (
    "id" bigint DEFAULT "nextval"('"public"."phones_id_seq"'::"regclass") NOT NULL,
    "phone_id" bigint NOT NULL,
    "address_id" bigint NOT NULL
);


ALTER TABLE "public"."phones" OWNER TO "grizzlysmit";

--
-- TOC entry 204 (class 1259 OID 21226)
-- Name: psudo_pages_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."psudo_pages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."psudo_pages_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 3917 (class 0 OID 0)
-- Dependencies: 204
-- Name: psudo_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE "public"."psudo_pages_id_seq" OWNED BY "public"."pseudo_pages"."id";


--
-- TOC entry 211 (class 1259 OID 21299)
-- Name: sections; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW "public"."sections" AS
 SELECT 'alias'::"text" AS "type",
    "a"."id",
    "a"."name" AS "section",
    "a"."userid",
    "a"."groupid",
    "a"."_perms"
   FROM "public"."alias" "a"
UNION
 SELECT 'links'::"text" AS "type",
    "ls"."id",
    "ls"."section",
    "ls"."userid",
    "ls"."groupid",
    "ls"."_perms"
   FROM "public"."links_sections" "ls"
UNION
 SELECT 'page'::"text" AS "type",
    "p"."id",
    "p"."name" AS "section",
    "p"."userid",
    "p"."groupid",
    "p"."_perms"
   FROM "public"."pages" "p"
UNION
 SELECT 'pseudo-page'::"text" AS "type",
    "pp"."id",
    "pp"."name" AS "section",
    "pp"."userid",
    "pp"."groupid",
    "pp"."_perms"
   FROM "public"."pseudo_pages" "pp";


ALTER TABLE "public"."sections" OWNER TO "grizzlysmit";

--
-- TOC entry 217 (class 1259 OID 21341)
-- Name: sessions; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."sessions" (
    "id" character(32) NOT NULL,
    "a_session" "text"
);


ALTER TABLE "public"."sessions" OWNER TO "grizzlysmit";

--
-- TOC entry 206 (class 1259 OID 21248)
-- Name: vlinks; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW "public"."vlinks" AS
 SELECT "ls"."section",
    "l"."name",
    "l"."link",
    "ls"."userid",
    "ls"."groupid",
    "ls"."_perms"
   FROM ("public"."links_sections" "ls"
     JOIN "public"."links" "l" ON (("l"."section_id" = "ls"."id")));


ALTER TABLE "public"."vlinks" OWNER TO "grizzlysmit";

--
-- TOC entry 3598 (class 2604 OID 21266)
-- Name: alias id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."alias_id_seq"'::"regclass");


--
-- TOC entry 3581 (class 2604 OID 21178)
-- Name: links id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."links_id_seq1"'::"regclass");


--
-- TOC entry 3589 (class 2604 OID 21213)
-- Name: page_section id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."page_section_id_seq"'::"regclass");


--
-- TOC entry 3585 (class 2604 OID 21199)
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pages" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."pages_id_seq"'::"regclass");


--
-- TOC entry 3593 (class 2604 OID 21231)
-- Name: pseudo_pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pseudo_pages" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."psudo_pages_id_seq"'::"regclass");


--
-- TOC entry 3855 (class 0 OID 21428)
-- Dependencies: 228
-- Data for Name: _group; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."_group" ("id", "_name") VALUES (3, 'grizzlysmit');
INSERT INTO "public"."_group" ("id", "_name") VALUES (1, 'admin');
INSERT INTO "public"."_group" ("id", "_name") VALUES (4, 'grizzly');
INSERT INTO "public"."_group" ("id", "_name") VALUES (5, 'grizz');
INSERT INTO "public"."_group" ("id", "_name") VALUES (6, 'fred');
INSERT INTO "public"."_group" ("id", "_name") VALUES (7, 'fg');
INSERT INTO "public"."_group" ("id", "_name") VALUES (8, 'frodo');


--
-- TOC entry 3849 (class 0 OID 21383)
-- Dependencies: 222
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."address" ("id", "unit", "street", "city_suburb", "postcode", "region", "country") VALUES (1, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" ("id", "unit", "street", "city_suburb", "postcode", "region", "country") VALUES (2, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" ("id", "unit", "street", "city_suburb", "postcode", "region", "country") VALUES (3, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" ("id", "unit", "street", "city_suburb", "postcode", "region", "country") VALUES (4, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" ("id", "unit", "street", "city_suburb", "postcode", "region", "country") VALUES (5, '2', '76-84 Karnee Street north', 'Riveerwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" ("id", "unit", "street", "city_suburb", "postcode", "region", "country") VALUES (6, '2', '76-84 Karne Street north', 'Narwee', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" ("id", "unit", "street", "city_suburb", "postcode", "region", "country") VALUES (7, '2', '76-84 Karne Street north', 'Riverwood', '2209', 'NSW', 'Australia');
INSERT INTO "public"."address" ("id", "unit", "street", "city_suburb", "postcode", "region", "country") VALUES (8, '2', '34 wibble street', 'Wobble', '3456', 'qwerty', 'Potsilvania');
INSERT INTO "public"."address" ("id", "unit", "street", "city_suburb", "postcode", "region", "country") VALUES (9, '', '4 Fordyce crt', 'Golden Square', '3555', 'Vic', 'Australia');
INSERT INTO "public"."address" ("id", "unit", "street", "city_suburb", "postcode", "region", "country") VALUES (10, '', 'Baggsend', 'hobbiton', '', 'the shire', 'LOTR');


--
-- TOC entry 3844 (class 0 OID 21263)
-- Dependencies: 208
-- Data for Name: alias; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (1, 'stor', 15, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (2, 'bronze', 9, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (3, 'store', 15, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (4, 'knck-dev', 23, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (5, 'knck', 16, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (6, 'knock-dev', 23, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (7, 'cpp', 24, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (8, 'CPP', 24, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (9, 'c++', 24, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (10, 'proc', 21, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (11, 'dir', 18, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (12, 'out', 7, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (13, 'api.q', 19, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (14, 'api_u', 13, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (15, 'API_U', 13, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (16, 'in', 5, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (19, 'tool', 12, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (21, 'fred', 22, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (22, 'pk', 16, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (23, 'add', 4, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (25, 'perl6', 27, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."alias" ("id", "name", "target", "userid", "groupid", "_perms") VALUES (26, 'pg', 34, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');


--
-- TOC entry 3859 (class 0 OID 21466)
-- Dependencies: 232
-- Data for Name: email; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."email" ("id", "_email", "verified") VALUES (1, 'grizzly@smit.id.au', false);
INSERT INTO "public"."email" ("id", "_email", "verified") VALUES (2, 'grizzly@smit.id.au', false);
INSERT INTO "public"."email" ("id", "_email", "verified") VALUES (3, 'grizzly@smit.id.au', false);
INSERT INTO "public"."email" ("id", "_email", "verified") VALUES (4, 'grizzly@smit.id.au', false);
INSERT INTO "public"."email" ("id", "_email", "verified") VALUES (5, 'f@s.com', false);
INSERT INTO "public"."email" ("id", "_email", "verified") VALUES (6, 'fg@hs.com', false);
INSERT INTO "public"."email" ("id", "_email", "verified") VALUES (7, 'frodo@tolkien.com', false);


--
-- TOC entry 3863 (class 0 OID 21507)
-- Dependencies: 236
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3857 (class 0 OID 21438)
-- Dependencies: 230
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3835 (class 0 OID 21173)
-- Dependencies: 198
-- Data for Name: links; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (1, 1, 'https://version.oztell.com.au/anycast/dl.88.io', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (2, 1, 'https://version.oztell.com.au/anycast/dl.88.io/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (3, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (4, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (5, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (6, 3, 'https://vault.net2maxlabs.net/net2max1/wp-admin/post.php?post=48209&action=edit', 'edit-docs', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (7, 3, 'https://vault.net2maxlabs.net/net2max1/location-grid/', 'view-docs', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (8, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (9, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (10, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (11, 5, 'https://version.contacttrace.com.au/contact0/input/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (12, 5, 'https://version.contacttrace.com.au/contact0/input', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (13, 5, 'https://version.contacttrace.com.au/contact0/input/-pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (14, 6, 'https://version.contacttrace.com.au/contact0/app/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (15, 6, 'https://version.contacttrace.com.au/contact0/app/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (16, 6, 'https://version.contacttrace.com.au/contact0/app/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (17, 7, 'https://version.contacttrace.com.au/contact0/output/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (18, 7, 'https://version.contacttrace.com.au/contact0/output/-scripts/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (19, 7, 'https://version.contacttrace.com.au/contact0/output/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (20, 8, 'https://vault.net2maxlabs.net/net2max1/business-identity-check/', 'view-docs', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (21, 8, 'https://vault.net2maxlabs.net/net2max1/wp-admin/post.php?post=51576&action=edit', 'edit-docs', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (76, 34, 'https://www.postgresql.org/docs/', 'docs', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (77, 36, 'https://php.net', 'main', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (78, 36, 'https://www.php.net/manual/en/', 'docs-en', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (79, 36, 'https://www.php.net/manual/en/langref.php', 'lang', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (80, 36, 'https://www.php.net/manual/en/security.php', 'security', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (81, 36, 'https://www.php.net/manual/en/funcref.php', 'funs', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (82, 36, 'https://www.php.net/manual/en/faq.php', 'faq', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (83, 36, 'https://www.php.net/manual/en/appendices.php', 'apendices', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (84, 36, 'https://www.php.net/manual/en/features.php', 'features', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (99, 34, 'https://www.postgresql.org/', 'main', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (22, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/-/blob/prod/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (23, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (24, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (25, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (26, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (27, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (28, 11, 'https://chat.quuvoo4ohcequuox.0.88.io/home', 'chat', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (29, 12, 'https://version.oztell.com.au/88io0/tools/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (31, 12, 'https://version.oztell.com.au/88io0/tools/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (32, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (33, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (34, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (35, 14, 'https://vault.net2maxlabs.net/net2max1/business-identity-check/', 'namecheck', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (36, 14, 'https://vault.net2maxlabs.net/net2max1/location-grid/', 'map', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (37, 15, 'https://version.contacttrace.com.au/contact0/storage/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (38, 15, 'https://version.contacttrace.com.au/contact0/storage/-/pipelines', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (39, 15, 'https://version.contacttrace.com.au/contact0/storage/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (40, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (41, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (42, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (43, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (44, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (45, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (46, 18, 'https://version.contacttrace.com.au/contact0/directory/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (47, 18, 'https://version.contacttrace.com.au/contact0/directory/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (48, 18, 'https://version.contacttrace.com.au/contact0/directory/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (49, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (50, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io/-/blob/prod/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (51, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (52, 20, 'https://version.oztell.com.au/oztell8/api', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (53, 21, 'https://version.contacttrace.com.au/contact0/processor/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (54, 21, 'https://version.contacttrace.com.au/contact0/processor', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (55, 21, 'https://version.contacttrace.com.au/contact0/processor/-/blob/dev/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (56, 22, 'https://ledger.contacttrace.com.au/?chain=0-s1-dev', '0-s1-dev', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (57, 22, 'https://ledger.contacttrace.com.au/', 'launch-page', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (58, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/-/blob/prod/README.md', 'readme', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (59, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/', 'gitlab', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (60, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/-/pipelines/', 'pipeline', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (61, 24, 'https://isocpp.org/', 'iso', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (62, 24, 'https://en.cppreference.com/w/', 'cppref', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (63, 24, 'https://www.modernescpp.com/index.php', 'modernescpp', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (69, 27, 'https://raku.org/', 'main', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (70, 27, 'https://modules.raku.org/', 'modules', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (71, 27, 'https://docs.raku.org/', 'docs', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (72, 27, 'https://docs.raku.org/language.html', 'lang', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (73, 27, 'https://docs.raku.org/type.html', 'types', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (74, 27, 'https://web.libera.chat/?channel=#raku', 'chat', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links" ("id", "section_id", "link", "name", "userid", "groupid", "_perms") VALUES (100, 34, 'https://www.postgresql.org/account', 'account', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');


--
-- TOC entry 3833 (class 0 OID 21161)
-- Dependencies: 196
-- Data for Name: links_sections; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (1, 'dl.88.io', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (2, 'key', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (3, 'location-grid-old-docs', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (4, 'address', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (5, 'input', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (6, 'app', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (7, 'output', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (8, 'business-identity-check', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (9, 'bronze-aus', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (10, 'signature', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (11, 'chat.q', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (12, 'tools', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (13, 'api_ugh8eika', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (14, 'oldocs', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (15, 'storage', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (16, 'portknocking', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (17, 'scripts', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (18, 'directory', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (19, 'api.quuvoo4ohcequuox.0.88.io', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (20, 'api', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (21, 'processor', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (22, 'blockchains', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (23, 'portknocking-dev', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (24, 'C++', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (27, 'raku', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (34, 'postgres', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."links_sections" ("id", "section", "userid", "groupid", "_perms") VALUES (36, 'php', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');


--
-- TOC entry 3840 (class 0 OID 21210)
-- Dependencies: 203
-- Data for Name: page_section; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (80, 39, 24, 4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (81, 39, 27, 4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (1, 1, 12, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (2, 1, 20, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (3, 3, 16, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (4, 3, 23, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (5, 5, 19, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (6, 5, 1, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (7, 7, 15, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (8, 7, 21, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (9, 7, 17, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (10, 7, 16, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (11, 7, 4, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (12, 7, 10, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (13, 7, 9, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (14, 7, 13, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (15, 7, 5, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (16, 7, 18, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (17, 7, 7, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (18, 7, 6, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (19, 7, 2, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (20, 20, 3, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (21, 20, 14, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."page_section" ("id", "pages_id", "links_section_id", "userid", "groupid", "_perms") VALUES (78, 37, 1, 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');


--
-- TOC entry 3838 (class 0 OID 21196)
-- Dependencies: 201
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."pages" ("id", "name", "full_name", "userid", "groupid", "_perms") VALUES (1, 'oztell.com.au', 'oztell.com.au stuff', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."pages" ("id", "name", "full_name", "userid", "groupid", "_perms") VALUES (3, 'knock', 'port knocking', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."pages" ("id", "name", "full_name", "userid", "groupid", "_perms") VALUES (7, 'contacttrace', 'contacttrace', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."pages" ("id", "name", "full_name", "userid", "groupid", "_perms") VALUES (20, 'docsold', 'The Old Docs', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."pages" ("id", "name", "full_name", "userid", "groupid", "_perms") VALUES (5, '88.io', '88.io stuff', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."pages" ("id", "name", "full_name", "userid", "groupid", "_perms") VALUES (37, 'apk', 'where the apks are', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."pages" ("id", "name", "full_name", "userid", "groupid", "_perms") VALUES (39, 'grizz-page', 'Grizzs Page', 4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")');


--
-- TOC entry 3847 (class 0 OID 21368)
-- Dependencies: 220
-- Data for Name: passwd; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."passwd" ("id", "username", "_password", "passwd_details_id", "primary_group_id", "_admin", "email_id") VALUES (1, 'admin', '{X-PBKDF2}HMACSHA2+512:AAAIAA:1j44CmP4SfwiYFHyQSJ+NA==:N2xeXHLH5MLnAq3hAAFgPscGSbkZu9bvvN6pgnNPkUeX3c1pzzI+NnxtyITUf0sZ1fd23G3MDFgA/aoLmHf0aQ==', 1, 1, true, 1);
INSERT INTO "public"."passwd" ("id", "username", "_password", "passwd_details_id", "primary_group_id", "_admin", "email_id") VALUES (2, 'grizzlysmit', '{X-PBKDF2}HMACSHA2+512:AAAIAA:205IxJhEjYkb5aOMExRFEA==:rk5nlRePO0bI4w1KOUPOyJADkCtBxpTd6goK9IGBc7fUu5otOvz+hXthcw41HH1DXSMB0qbicNJWpGC18wmUww==', 2, 3, true, 2);
INSERT INTO "public"."passwd" ("id", "username", "_password", "passwd_details_id", "primary_group_id", "_admin", "email_id") VALUES (4, 'grizz', '{X-PBKDF2}HMACSHA2+512:AAAIAA:zWeWVTYpvU2EsxbD6fjNIw==:sdYmcRwOLxC55Q/cCigfExdtT32EFH3vzTvV8IaYVkjNo4Svo8A9FumS1Wu8Dpu7ca2W+uFcX7ZEA5zilPK3vg==', 4, 5, false, 4);
INSERT INTO "public"."passwd" ("id", "username", "_password", "passwd_details_id", "primary_group_id", "_admin", "email_id") VALUES (3, 'grizzly', '{X-PBKDF2}HMACSHA2+512:AAAIAA:Po+YOhfNSqvgJVkWfUJdoQ==:kA39+vz0F3/pIECA7Y2TuW1wLIPdal0WBv2LOWdkRCWci6GEcKdSu0NQ5wwsZuI4G0fsMBE83LIGvBiZJe0VcA==', 3, 4, true, 3);
INSERT INTO "public"."passwd" ("id", "username", "_password", "passwd_details_id", "primary_group_id", "_admin", "email_id") VALUES (5, 'fred', '{X-PBKDF2}HMACSHA2+512:AAAIAA:Ae1marIx6BPKU2DPKFKCWw==:zPHXVxB5O6kXhbnedKyxE9HkldEnniWY9e13HrnfMCnn0amqd+5vliUmQeFD9qPiMRWrTWHq6ovP0i9uR/nmdQ==', 5, 6, false, 5);
INSERT INTO "public"."passwd" ("id", "username", "_password", "passwd_details_id", "primary_group_id", "_admin", "email_id") VALUES (7, 'frodo', '{X-PBKDF2}HMACSHA2+512:AAAIAA:L8niz4XzsghhSbcrOSDRHA==:MbAm1ydlPeqD2gIBVdvNOS9iLJwN55p59wXHZh28BdbMIl3Zu5zj0ysFmDzGiv4f/jA4zc/9FsUTQAQD64MjUQ==', 7, 8, false, 7);
INSERT INTO "public"."passwd" ("id", "username", "_password", "passwd_details_id", "primary_group_id", "_admin", "email_id") VALUES (6, 'fg', '{X-PBKDF2}HMACSHA2+512:AAAIAA:9dLETVdFkjCbA9xm0WcrnA==:U3+eRhVmniz+rCO0xQc1e3H/EyoaICPPz9DRrDax5TDlxnpOZIMNr5UbVxGJEYEcTyk+yijzj/W8NAbqex81iA==', 6, 7, false, 6);


--
-- TOC entry 3853 (class 0 OID 21407)
-- Dependencies: 226
-- Data for Name: passwd_details; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."passwd_details" ("id", "display_name", "given", "_family", "residential_address_id", "postal_address_id", "primary_phone_id", "primary_email_id") VALUES (1, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 3, 3, 1, 1);
INSERT INTO "public"."passwd_details" ("id", "display_name", "given", "_family", "residential_address_id", "postal_address_id", "primary_phone_id", "primary_email_id") VALUES (2, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 4, 4, 3, 2);
INSERT INTO "public"."passwd_details" ("id", "display_name", "given", "_family", "residential_address_id", "postal_address_id", "primary_phone_id", "primary_email_id") VALUES (3, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 5, 5, 5, 3);
INSERT INTO "public"."passwd_details" ("id", "display_name", "given", "_family", "residential_address_id", "postal_address_id", "primary_phone_id", "primary_email_id") VALUES (4, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 7, 6, 7, 4);
INSERT INTO "public"."passwd_details" ("id", "display_name", "given", "_family", "residential_address_id", "postal_address_id", "primary_phone_id", "primary_email_id") VALUES (5, 'Fred Flintstone', 'Fred', 'Flintstone', 8, 8, NULL, 5);
INSERT INTO "public"."passwd_details" ("id", "display_name", "given", "_family", "residential_address_id", "postal_address_id", "primary_phone_id", "primary_email_id") VALUES (6, 'Justin O&#39;meara', 'Justin', 'O&#39;meara', 9, 9, NULL, 6);
INSERT INTO "public"."passwd_details" ("id", "display_name", "given", "_family", "residential_address_id", "postal_address_id", "primary_phone_id", "primary_email_id") VALUES (7, 'Frodo Baggins', 'Frodo', 'Baggins', 10, 10, NULL, 7);


--
-- TOC entry 3851 (class 0 OID 21394)
-- Dependencies: 224
-- Data for Name: phone; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."phone" ("id", "_number", "verified") VALUES (1, '+61482176343', false);
INSERT INTO "public"."phone" ("id", "_number", "verified") VALUES (2, '+612 9217 6004', false);
INSERT INTO "public"."phone" ("id", "_number", "verified") VALUES (3, '+61482 176 343', false);
INSERT INTO "public"."phone" ("id", "_number", "verified") VALUES (4, '+612 9217 6004', false);
INSERT INTO "public"."phone" ("id", "_number", "verified") VALUES (5, '0482 176 343', false);
INSERT INTO "public"."phone" ("id", "_number", "verified") VALUES (6, '(02) 9217 6004', false);
INSERT INTO "public"."phone" ("id", "_number", "verified") VALUES (7, '+61482-176-343', false);
INSERT INTO "public"."phone" ("id", "_number", "verified") VALUES (8, '+612-9217-6004', false);


--
-- TOC entry 3861 (class 0 OID 21489)
-- Dependencies: 234
-- Data for Name: phones; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3842 (class 0 OID 21228)
-- Dependencies: 205
-- Data for Name: pseudo_pages; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."pseudo_pages" ("id", "pattern", "status", "name", "full_name", "userid", "groupid", "_perms") VALUES (1, '.*', 'unassigned', 'misc', 'misc', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."pseudo_pages" ("id", "pattern", "status", "name", "full_name", "userid", "groupid", "_perms") VALUES (2, '.*', 'both', 'all', 'all', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');
INSERT INTO "public"."pseudo_pages" ("id", "pattern", "status", "name", "full_name", "userid", "groupid", "_perms") VALUES (5, '.*', 'assigned', 'already', 'already in pages', 1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")');


--
-- TOC entry 3864 (class 0 OID 21563)
-- Dependencies: 239
-- Data for Name: secure; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3845 (class 0 OID 21341)
-- Dependencies: 217
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."sessions" ("id", "a_session") VALUES ('ccaf15a07783d52542704b543d8dc2b9', 'BQsDAAAAEBcLZ3JpenpseXNtaXQAAAARbG9nZ2VkaW5fdXNlcm5hbWUXFEZyYW5jaXMgR3Jpenps
eSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQoCMjUAAAALcGFnZV9sZW5ndGgIgAAAAA5s
b2dnZWRpbl9hZG1pbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXD0ZyYW5jaXMgR3JpenpseQAA
AA5sb2dnZWRpbl9naXZlbgoJbGlua3NeQysrAAAAD2N1cnJlbnRfc2VjdGlvbhcOKzYxNDgyIDE3
NiAzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9n
Z2VkaW5fZW1haWwKATAAAAAFZGVidWcIggAAAAhsb2dnZWRpbgoPcHNldWRvLXBhZ2VeYWxsAAAA
DGN1cnJlbnRfcGFnZQogY2NhZjE1YTA3NzgzZDUyNTQyNzA0YjU0M2Q4ZGMyYjkAAAALX3Nlc3Np
b25faWQIggAAAAtsb2dnZWRpbl9pZBcLZ3JpenpseXNtaXQAAAASbG9nZ2VkaW5fZ3JvdXBuYW1l
CIMAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZA==
');
INSERT INTO "public"."sessions" ("id", "a_session") VALUES ('068675cd502b8327e5dd27ef507aa3c0', 'BQsDAAAAEAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKCWxpbmtzXkMrKwAAAA9jdXJyZW50
X3NlY3Rpb24KATEAAAAFZGVidWcXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lCIEAAAALbG9n
Z2VkaW5faWQIgQAAAA5sb2dnZWRpbl9hZG1pbhcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9n
Z2VkaW5fZGlzcGxheV9uYW1lCIEAAAAIbG9nZ2VkaW4XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5s
b2dnZWRpbl9lbWFpbBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCgIyNQAAAAtw
YWdlX2xlbmd0aAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZRcMKzYxNDgyMTc2MzQz
AAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFwRT
bWl0AAAAD2xvZ2dlZGluX2ZhbWlseQogMDY4Njc1Y2Q1MDJiODMyN2U1ZGQyN2VmNTA3YWEzYzAA
AAALX3Nlc3Npb25faWQ=
');
INSERT INTO "public"."sessions" ("id", "a_session") VALUES ('dd658768b14194054d895bb6e64d5294', 'BQsDAAAAEAoObGlua3NecG9zdGdyZXMAAAAPY3VycmVudF9zZWN0aW9uFxRGcmFuY2lzIEdyaXp6
bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXC2dyaXp6bHlzbWl0AAAAEWxvZ2dlZGlu
X3VzZXJuYW1lFwtncml6emx5c21pdAAAABJsb2dnZWRpbl9ncm91cG5hbWUXD0ZyYW5jaXMgR3Jp
enpseQAAAA5sb2dnZWRpbl9naXZlbgogZGQ2NTg3NjhiMTQxOTQwNTRkODk1YmI2ZTY0ZDUyOTQA
AAALX3Nlc3Npb25faWQKAjI4AAAAC3BhZ2VfbGVuZ3RoFxJncml6emx5QHNtaXQuaWQuYXUAAAAO
bG9nZ2VkaW5fZW1haWwIgwAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkChBwc2V1ZG8tcGFnZV5t
aXNjAAAADGN1cnJlbnRfcGFnZQiBAAAADmxvZ2dlZGluX2FkbWluCIIAAAAIbG9nZ2VkaW4IggAA
AAtsb2dnZWRpbl9pZAoBMAAAAAVkZWJ1ZxcOKzYxNDgyIDE3NiAzNDMAAAAVbG9nZ2VkaW5fcGhv
bmVfbnVtYmVyFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQ==
');
INSERT INTO "public"."sessions" ("id", "a_session") VALUES ('498b2cd3b6da04091d39c89f9190ecbe', 'BQsDAAAABQogNDk4YjJjZDNiNmRhMDQwOTFkMzljODlmOTE5MGVjYmUAAAALX3Nlc3Npb25faWQK
D3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKAjIzAAAAC3BhZ2VfbGVuZ3RoCglsaW5r
c15DKysAAAAPY3VycmVudF9zZWN0aW9uCgExAAAABWRlYnVn
');
INSERT INTO "public"."sessions" ("id", "a_session") VALUES ('d54a395a7e3d035b2eab35e3e1e3eddd', 'BQsDAAAAEAogZDU0YTM5NWE3ZTNkMDM1YjJlYWIzNWUzZTFlM2VkZGQAAAALX3Nlc3Npb25faWQX
Dis2MTQ4Mi0xNzYtMzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcFZ3JpenoAAAASbG9nZ2Vk
aW5fZ3JvdXBuYW1lFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25h
bWUXBWdyaXp6AAAAEWxvZ2dlZGluX3VzZXJuYW1lFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2Vk
aW5fZ2l2ZW4KD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UKAjI1AAAAC3BhZ2VfbGVu
Z3RoCIQAAAAIbG9nZ2VkaW4IhAAAAAtsb2dnZWRpbl9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1p
bHkXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbAiFAAAAFmxvZ2dlZGluX2dy
b3Vwbm5hbWVfaWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24IgAAAAA5sb2dnZWRp
bl9hZG1pbgoBMAAAAAVkZWJ1Zw==
');
INSERT INTO "public"."sessions" ("id", "a_session") VALUES ('88aa7cad761ab4c62664ab011059f338', 'BQsDAAAABQoKbGlua3NecmFrdQAAAA9jdXJyZW50X3NlY3Rpb24KD3BzZXVkby1wYWdlXmFsbAAA
AAxjdXJyZW50X3BhZ2UKAjQxAAAAC3BhZ2VfbGVuZ3RoCiA4OGFhN2NhZDc2MWFiNGM2MjY2NGFi
MDExMDU5ZjMzOAAAAAtfc2Vzc2lvbl9pZAoBMAAAAAVkZWJ1Zw==
');
INSERT INTO "public"."sessions" ("id", "a_session") VALUES ('a5d41456a83643e9445ceb8e1f8fe4d2', 'BQsDAAAABQoCMjgAAAALcGFnZV9sZW5ndGgKC2FsaWFzXnBlcmw2AAAAD2N1cnJlbnRfc2VjdGlv
bgoQcHNldWRvLXBhZ2VebWlzYwAAAAxjdXJyZW50X3BhZ2UKATAAAAAFZGVidWcKIGE1ZDQxNDU2
YTgzNjQzZTk0NDVjZWI4ZTFmOGZlNGQyAAAAC19zZXNzaW9uX2lk
');
INSERT INTO "public"."sessions" ("id", "a_session") VALUES ('e1b7ae146ea967338bc75bd9ecc4b4ae', 'BQsDAAAABQogZTFiN2FlMTQ2ZWE5NjczMzhiYzc1YmQ5ZWNjNGI0YWUAAAALX3Nlc3Npb25faWQK
ATEAAAAFZGVidWcKD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDmxpbmtzXnBvc3Rn
cmVzAAAAD2N1cnJlbnRfc2VjdGlvbgoCMzkAAAALcGFnZV9sZW5ndGg=
');


--
-- TOC entry 3922 (class 0 OID 0)
-- Dependencies: 227
-- Name: _group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."_group_id_seq"', 8, true);


--
-- TOC entry 3923 (class 0 OID 0)
-- Dependencies: 221
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."address_id_seq"', 10, true);


--
-- TOC entry 3924 (class 0 OID 0)
-- Dependencies: 207
-- Name: alias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."alias_id_seq"', 34, true);


--
-- TOC entry 3925 (class 0 OID 0)
-- Dependencies: 231
-- Name: email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."email_id_seq"', 7, true);


--
-- TOC entry 3926 (class 0 OID 0)
-- Dependencies: 235
-- Name: emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."emails_id_seq"', 1, false);


--
-- TOC entry 3927 (class 0 OID 0)
-- Dependencies: 229
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."groups_id_seq"', 1, false);


--
-- TOC entry 3928 (class 0 OID 0)
-- Dependencies: 197
-- Name: links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."links_id_seq"', 37, true);


--
-- TOC entry 3929 (class 0 OID 0)
-- Dependencies: 199
-- Name: links_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."links_id_seq1"', 115, true);


--
-- TOC entry 3930 (class 0 OID 0)
-- Dependencies: 202
-- Name: page_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."page_section_id_seq"', 81, true);


--
-- TOC entry 3931 (class 0 OID 0)
-- Dependencies: 200
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."pages_id_seq"', 39, true);


--
-- TOC entry 3932 (class 0 OID 0)
-- Dependencies: 225
-- Name: passwd_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."passwd_details_id_seq"', 7, true);


--
-- TOC entry 3933 (class 0 OID 0)
-- Dependencies: 219
-- Name: passwd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."passwd_id_seq"', 7, true);


--
-- TOC entry 3934 (class 0 OID 0)
-- Dependencies: 223
-- Name: phone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."phone_id_seq"', 8, true);


--
-- TOC entry 3935 (class 0 OID 0)
-- Dependencies: 233
-- Name: phones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."phones_id_seq"', 1, false);


--
-- TOC entry 3936 (class 0 OID 0)
-- Dependencies: 204
-- Name: psudo_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."psudo_pages_id_seq"', 8, true);


--
-- TOC entry 3658 (class 2606 OID 21433)
-- Name: _group _group_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."_group"
    ADD CONSTRAINT "_group_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3652 (class 2606 OID 21391)
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."address"
    ADD CONSTRAINT "address_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3641 (class 2606 OID 21268)
-- Name: alias alias_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3643 (class 2606 OID 21282)
-- Name: alias alias_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_unique_contraint_name" UNIQUE ("name");


--
-- TOC entry 3666 (class 2606 OID 21471)
-- Name: email email_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."email"
    ADD CONSTRAINT "email_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3670 (class 2606 OID 21512)
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."emails"
    ADD CONSTRAINT "emails_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3660 (class 2606 OID 21435)
-- Name: _group group_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."_group"
    ADD CONSTRAINT "group_unique_key" UNIQUE ("_name");


--
-- TOC entry 3662 (class 2606 OID 21443)
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3664 (class 2606 OID 21584)
-- Name: groups groups_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_unique_key" UNIQUE ("group_id", "passwd_id");


--
-- TOC entry 3618 (class 2606 OID 21168)
-- Name: links_sections links_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3624 (class 2606 OID 21180)
-- Name: links links_pkey1; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_pkey1" PRIMARY KEY ("id");


--
-- TOC entry 3621 (class 2606 OID 21358)
-- Name: links_sections links_sections_unnique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_sections_unnique_key" UNIQUE ("section");


--
-- TOC entry 3626 (class 2606 OID 21284)
-- Name: links links_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_unique_contraint_name" UNIQUE ("section_id", "name");


--
-- TOC entry 3633 (class 2606 OID 21294)
-- Name: page_section page_section_unique; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "page_section_unique" UNIQUE ("pages_id", "links_section_id");


--
-- TOC entry 3629 (class 2606 OID 21356)
-- Name: pages page_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "page_unique_key" UNIQUE ("name");


--
-- TOC entry 3656 (class 2606 OID 21415)
-- Name: passwd_details passwd_details_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3648 (class 2606 OID 21377)
-- Name: passwd passwd_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3650 (class 2606 OID 21379)
-- Name: passwd passwd_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_unique_key" UNIQUE ("username");


--
-- TOC entry 3654 (class 2606 OID 21399)
-- Name: phone phone_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."phone"
    ADD CONSTRAINT "phone_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3668 (class 2606 OID 21494)
-- Name: phones phones_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."phones"
    ADD CONSTRAINT "phones_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3631 (class 2606 OID 21201)
-- Name: pages pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "pkey" PRIMARY KEY ("id");


--
-- TOC entry 3637 (class 2606 OID 21360)
-- Name: pseudo_pages pseudo_pages_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "pseudo_pages_unique_key" UNIQUE ("name");


--
-- TOC entry 3635 (class 2606 OID 21215)
-- Name: page_section psge_section_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "psge_section_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3639 (class 2606 OID 21233)
-- Name: pseudo_pages psudo_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "psudo_pages_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3646 (class 2606 OID 21348)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."sessions"
    ADD CONSTRAINT "sessions_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3644 (class 1259 OID 21280)
-- Name: alias_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX "alias_unique_key" ON "public"."alias" USING "btree" ("name" COLLATE "C.UTF-8" "varchar_ops");


--
-- TOC entry 3622 (class 1259 OID 21190)
-- Name: fki_section_fkey; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE INDEX "fki_section_fkey" ON "public"."links" USING "btree" ("section_id");


--
-- TOC entry 3619 (class 1259 OID 21258)
-- Name: links_sections_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX "links_sections_unique_key" ON "public"."links_sections" USING "btree" ("section" COLLATE "C" "text_pattern_ops");


--
-- TOC entry 3627 (class 1259 OID 21259)
-- Name: links_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX "links_unique_key" ON "public"."links" USING "btree" ("name" COLLATE "POSIX" "bpchar_pattern_ops", "section_id");

ALTER TABLE "public"."links" CLUSTER ON "links_unique_key";


--
-- TOC entry 3684 (class 2606 OID 21612)
-- Name: alias alias_foriegn_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_foriegn_key" FOREIGN KEY ("target") REFERENCES "public"."links_sections"("id") NOT VALID;


--
-- TOC entry 3686 (class 2606 OID 21628)
-- Name: alias alias_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3685 (class 2606 OID 21623)
-- Name: alias alias_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3699 (class 2606 OID 21518)
-- Name: emails emails_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."emails"
    ADD CONSTRAINT "emails_address_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."address"("id");


--
-- TOC entry 3698 (class 2606 OID 21513)
-- Name: emails emails_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."emails"
    ADD CONSTRAINT "emails_email_fkey" FOREIGN KEY ("email_id") REFERENCES "public"."email"("id");


--
-- TOC entry 3695 (class 2606 OID 21449)
-- Name: groups groups_address_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_address_foreign_key" FOREIGN KEY ("passwd_id") REFERENCES "public"."passwd"("id");


--
-- TOC entry 3694 (class 2606 OID 21444)
-- Name: groups groups_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_foreign_key" FOREIGN KEY ("group_id") REFERENCES "public"."_group"("id");


--
-- TOC entry 3675 (class 2606 OID 21641)
-- Name: links links_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3679 (class 2606 OID 21221)
-- Name: page_section links_section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "links_section_fkey" FOREIGN KEY ("links_section_id") REFERENCES "public"."links_sections"("id");


--
-- TOC entry 3672 (class 2606 OID 21657)
-- Name: links_sections links_sections_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_sections_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3671 (class 2606 OID 21652)
-- Name: links_sections links_sections_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_sections_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3674 (class 2606 OID 21636)
-- Name: links links_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3681 (class 2606 OID 21673)
-- Name: page_section page_section_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "page_section_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3680 (class 2606 OID 21668)
-- Name: page_section page_section_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "page_section_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3678 (class 2606 OID 21216)
-- Name: page_section pages_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "pages_fkey" FOREIGN KEY ("pages_id") REFERENCES "public"."pages"("id");


--
-- TOC entry 3677 (class 2606 OID 21689)
-- Name: pages pages_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "pages_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3676 (class 2606 OID 21684)
-- Name: pages pages_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "pages_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3687 (class 2606 OID 21454)
-- Name: passwd passwd_details_connection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_details_connection_fkey" FOREIGN KEY ("passwd_details_id") REFERENCES "public"."passwd_details"("id") NOT VALID;


--
-- TOC entry 3693 (class 2606 OID 21482)
-- Name: passwd_details passwd_details_p_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_p_email_fkey" FOREIGN KEY ("primary_email_id") REFERENCES "public"."email"("id") NOT VALID;


--
-- TOC entry 3692 (class 2606 OID 21477)
-- Name: passwd_details passwd_details_p_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_p_phone_fkey" FOREIGN KEY ("primary_phone_id") REFERENCES "public"."phone"("id") NOT VALID;


--
-- TOC entry 3691 (class 2606 OID 21421)
-- Name: passwd_details passwd_details_post_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_post_foreign_key" FOREIGN KEY ("postal_address_id") REFERENCES "public"."address"("id");


--
-- TOC entry 3690 (class 2606 OID 21416)
-- Name: passwd_details passwd_details_res_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_res_foreign_key" FOREIGN KEY ("residential_address_id") REFERENCES "public"."address"("id");


--
-- TOC entry 3688 (class 2606 OID 21459)
-- Name: passwd passwd_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_group_fkey" FOREIGN KEY ("primary_group_id") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3689 (class 2606 OID 21585)
-- Name: passwd passwd_primary_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_primary_email_fkey" FOREIGN KEY ("email_id") REFERENCES "public"."email"("id") NOT VALID;


--
-- TOC entry 3697 (class 2606 OID 21500)
-- Name: phones phones_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."phones"
    ADD CONSTRAINT "phones_address_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."address"("id");


--
-- TOC entry 3696 (class 2606 OID 21495)
-- Name: phones phones_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."phones"
    ADD CONSTRAINT "phones_phone_fkey" FOREIGN KEY ("phone_id") REFERENCES "public"."phone"("id");


--
-- TOC entry 3683 (class 2606 OID 21702)
-- Name: pseudo_pages pseudo_pages_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "pseudo_pages_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3682 (class 2606 OID 21697)
-- Name: pseudo_pages pseudo_pages_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "pseudo_pages_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3673 (class 2606 OID 21185)
-- Name: links section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "section_fkey" FOREIGN KEY ("section_id") REFERENCES "public"."links_sections"("id") ON UPDATE RESTRICT;


--
-- TOC entry 3701 (class 2606 OID 21577)
-- Name: secure secure_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."secure"
    ADD CONSTRAINT "secure_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id");


--
-- TOC entry 3700 (class 2606 OID 21572)
-- Name: secure secure_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."secure"
    ADD CONSTRAINT "secure_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id");


--
-- TOC entry 3871 (class 0 OID 0)
-- Dependencies: 3870
-- Name: DATABASE "urls"; Type: ACL; Schema: -; Owner: grizzlysmit
--

GRANT CONNECT ON DATABASE "urls" TO "urluser";


--
-- TOC entry 3873 (class 0 OID 0)
-- Dependencies: 742
-- Name: TYPE "perm_set"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON TYPE "public"."perm_set" TO "urluser" WITH GRANT OPTION;


--
-- TOC entry 3874 (class 0 OID 0)
-- Dependencies: 743
-- Name: TYPE "perms"; Type: ACL; Schema: public; Owner: grizzlysmit
--

REVOKE ALL ON TYPE "public"."perms" FROM "grizzlysmit";
GRANT ALL ON TYPE "public"."perms" TO "grizzlysmit" WITH GRANT OPTION;
GRANT ALL ON TYPE "public"."perms" TO "urluser" WITH GRANT OPTION;


--
-- TOC entry 3875 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE "_group_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."_group_id_seq" TO "urluser";


--
-- TOC entry 3876 (class 0 OID 0)
-- Dependencies: 228
-- Name: TABLE "_group"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON TABLE "public"."_group" TO "urluser";


--
-- TOC entry 3877 (class 0 OID 0)
-- Dependencies: 221
-- Name: SEQUENCE "address_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."address_id_seq" TO "urluser";


--
-- TOC entry 3878 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE "address"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."address" TO "urluser";


--
-- TOC entry 3879 (class 0 OID 0)
-- Dependencies: 239
-- Name: TABLE "secure"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."secure" TO "urluser";


--
-- TOC entry 3880 (class 0 OID 0)
-- Dependencies: 208
-- Name: TABLE "alias"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias" TO "urluser";


--
-- TOC entry 3882 (class 0 OID 0)
-- Dependencies: 207
-- Name: SEQUENCE "alias_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."alias_id_seq" TO "urluser";


--
-- TOC entry 3883 (class 0 OID 0)
-- Dependencies: 197
-- Name: SEQUENCE "links_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."links_id_seq" TO "urluser";


--
-- TOC entry 3884 (class 0 OID 0)
-- Dependencies: 196
-- Name: TABLE "links_sections"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."links_sections" TO "urluser";


--
-- TOC entry 3885 (class 0 OID 0)
-- Dependencies: 216
-- Name: TABLE "alias_links"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias_links" TO "urluser";


--
-- TOC entry 3886 (class 0 OID 0)
-- Dependencies: 198
-- Name: TABLE "links"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."links" TO "urluser";


--
-- TOC entry 3887 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE "alias_union_links"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias_union_links" TO "urluser";


--
-- TOC entry 3888 (class 0 OID 0)
-- Dependencies: 210
-- Name: TABLE "alias_union_links_sections"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias_union_links_sections" TO "urluser";


--
-- TOC entry 3889 (class 0 OID 0)
-- Dependencies: 209
-- Name: TABLE "aliases"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."aliases" TO "urluser";


--
-- TOC entry 3890 (class 0 OID 0)
-- Dependencies: 231
-- Name: SEQUENCE "email_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."email_id_seq" TO "urluser";


--
-- TOC entry 3891 (class 0 OID 0)
-- Dependencies: 232
-- Name: TABLE "email"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."email" TO "urluser";


--
-- TOC entry 3892 (class 0 OID 0)
-- Dependencies: 235
-- Name: SEQUENCE "emails_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."emails_id_seq" TO "urluser";


--
-- TOC entry 3893 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE "emails"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."emails" TO "urluser";


--
-- TOC entry 3894 (class 0 OID 0)
-- Dependencies: 229
-- Name: SEQUENCE "groups_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."groups_id_seq" TO "urluser";


--
-- TOC entry 3895 (class 0 OID 0)
-- Dependencies: 230
-- Name: TABLE "groups"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."groups" TO "urluser";


--
-- TOC entry 3897 (class 0 OID 0)
-- Dependencies: 199
-- Name: SEQUENCE "links_id_seq1"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."links_id_seq1" TO "urluser";


--
-- TOC entry 3898 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE "links_sections_join_links"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."links_sections_join_links" TO "urluser";


--
-- TOC entry 3899 (class 0 OID 0)
-- Dependencies: 203
-- Name: TABLE "page_section"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."page_section" TO "urluser";


--
-- TOC entry 3900 (class 0 OID 0)
-- Dependencies: 201
-- Name: TABLE "pages"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."pages" TO "urluser";


--
-- TOC entry 3901 (class 0 OID 0)
-- Dependencies: 213
-- Name: TABLE "page_link_view"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."page_link_view" TO "urluser";


--
-- TOC entry 3903 (class 0 OID 0)
-- Dependencies: 202
-- Name: SEQUENCE "page_section_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."page_section_id_seq" TO "urluser";


--
-- TOC entry 3904 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE "page_view"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."page_view" TO "urluser";


--
-- TOC entry 3905 (class 0 OID 0)
-- Dependencies: 205
-- Name: TABLE "pseudo_pages"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."pseudo_pages" TO "urluser";


--
-- TOC entry 3906 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE "pagelike"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."pagelike" TO "urluser";


--
-- TOC entry 3908 (class 0 OID 0)
-- Dependencies: 200
-- Name: SEQUENCE "pages_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."pages_id_seq" TO "urluser";


--
-- TOC entry 3909 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE "passwd_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."passwd_id_seq" TO "urluser";


--
-- TOC entry 3910 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE "passwd"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."passwd" TO "urluser";


--
-- TOC entry 3911 (class 0 OID 0)
-- Dependencies: 225
-- Name: SEQUENCE "passwd_details_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."passwd_details_id_seq" TO "urluser";


--
-- TOC entry 3912 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE "passwd_details"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."passwd_details" TO "urluser";


--
-- TOC entry 3913 (class 0 OID 0)
-- Dependencies: 223
-- Name: SEQUENCE "phone_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."phone_id_seq" TO "urluser";


--
-- TOC entry 3914 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE "phone"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."phone" TO "urluser";


--
-- TOC entry 3915 (class 0 OID 0)
-- Dependencies: 233
-- Name: SEQUENCE "phones_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."phones_id_seq" TO "urluser";


--
-- TOC entry 3916 (class 0 OID 0)
-- Dependencies: 234
-- Name: TABLE "phones"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."phones" TO "urluser";


--
-- TOC entry 3918 (class 0 OID 0)
-- Dependencies: 204
-- Name: SEQUENCE "psudo_pages_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."psudo_pages_id_seq" TO "urluser";


--
-- TOC entry 3919 (class 0 OID 0)
-- Dependencies: 211
-- Name: TABLE "sections"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."sections" TO "urluser";


--
-- TOC entry 3920 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE "sessions"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."sessions" TO "urluser";


--
-- TOC entry 3921 (class 0 OID 0)
-- Dependencies: 206
-- Name: TABLE "vlinks"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."vlinks" TO "urluser";


--
-- TOC entry 1831 (class 826 OID 21260)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: grizzlysmit
--

ALTER DEFAULT PRIVILEGES FOR ROLE "grizzlysmit" GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLES  TO "urluser";


-- Completed on 2022-04-15 15:23:58 AEST

--
-- PostgreSQL database dump complete
--

