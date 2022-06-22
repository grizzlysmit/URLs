--
-- PostgreSQL database dump
--

-- Dumped from database version 14.3 (Ubuntu 14.3-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.3 (Ubuntu 14.3-1.pgdg21.10+1)

-- Started on 2022-06-17 23:23:22 AEST

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
-- TOC entry 3691 (class 1262 OID 16850)
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
-- TOC entry 3693 (class 0 OID 0)
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
-- TOC entry 964 (class 1247 OID 16853)
-- Name: perm_set; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE "public"."perm_set" AS (
	"_read" boolean,
	"_write" boolean,
	"_del" boolean
);


ALTER TYPE "public"."perm_set" OWNER TO "grizzlysmit";

--
-- TOC entry 965 (class 1247 OID 16856)
-- Name: perms; Type: TYPE; Schema: public; Owner: grizzlysmit
--

CREATE TYPE "public"."perms" AS (
	"_user" "public"."perm_set",
	"_group" "public"."perm_set",
	"_other" "public"."perm_set"
);


ALTER TYPE "public"."perms" OWNER TO "grizzlysmit";

--
-- TOC entry 877 (class 1247 OID 16858)
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
-- TOC entry 211 (class 1259 OID 16867)
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

SET default_table_access_method = "heap";

--
-- TOC entry 212 (class 1259 OID 16868)
-- Name: _group; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."_group" (
    "id" bigint DEFAULT "nextval"('"public"."_group_id_seq"'::"regclass") NOT NULL,
    "_name" character varying(256) NOT NULL
);


ALTER TABLE "public"."_group" OWNER TO "grizzlysmit";

--
-- TOC entry 213 (class 1259 OID 16872)
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
-- TOC entry 214 (class 1259 OID 16873)
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
-- TOC entry 215 (class 1259 OID 16879)
-- Name: addresses; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."addresses" (
    "id" bigint NOT NULL,
    "passwd_id" bigint NOT NULL,
    "address_id" bigint NOT NULL
);


ALTER TABLE "public"."addresses" OWNER TO "grizzlysmit";

--
-- TOC entry 216 (class 1259 OID 16882)
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."addresses_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."addresses_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 3701 (class 0 OID 0)
-- Dependencies: 216
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE "public"."addresses_id_seq" OWNED BY "public"."addresses"."id";


--
-- TOC entry 217 (class 1259 OID 16883)
-- Name: secure; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."secure" (
    "userid" bigint DEFAULT 1 NOT NULL,
    "groupid" bigint DEFAULT 1 NOT NULL,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)) NOT NULL
);


ALTER TABLE "public"."secure" OWNER TO "grizzlysmit";

--
-- TOC entry 218 (class 1259 OID 16891)
-- Name: alias; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."alias" (
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    "id" bigint NOT NULL,
    "name" character varying(50) NOT NULL,
    "target" bigint NOT NULL
)
INHERITS ("public"."secure");


ALTER TABLE "public"."alias" OWNER TO "grizzlysmit";

--
-- TOC entry 219 (class 1259 OID 16899)
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
-- TOC entry 3704 (class 0 OID 0)
-- Dependencies: 219
-- Name: alias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE "public"."alias_id_seq" OWNED BY "public"."alias"."id";


--
-- TOC entry 220 (class 1259 OID 16900)
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
-- TOC entry 221 (class 1259 OID 16901)
-- Name: links_sections; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."links_sections" (
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    "id" bigint DEFAULT "nextval"('"public"."links_id_seq"'::"regclass") NOT NULL,
    "section" character varying(50) NOT NULL
)
INHERITS ("public"."secure");


ALTER TABLE "public"."links_sections" OWNER TO "grizzlysmit";

--
-- TOC entry 222 (class 1259 OID 16910)
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
-- TOC entry 223 (class 1259 OID 16914)
-- Name: links; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."links" (
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    "id" bigint NOT NULL,
    "section_id" bigint NOT NULL,
    "link" character varying(4096),
    "name" character varying(50) NOT NULL
)
INHERITS ("public"."secure");


ALTER TABLE "public"."links" OWNER TO "grizzlysmit";

--
-- TOC entry 224 (class 1259 OID 16922)
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
-- TOC entry 225 (class 1259 OID 16927)
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
-- TOC entry 226 (class 1259 OID 16932)
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
-- TOC entry 256 (class 1259 OID 17299)
-- Name: country_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."country_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."country_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 257 (class 1259 OID 17300)
-- Name: country; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."country" (
    "id" bigint DEFAULT "nextval"('"public"."country_id_seq"'::"regclass") NOT NULL,
    "cc" character(2) NOT NULL,
    "_name" character varying(256),
    "_flag" character varying(256),
    "_escape" character(1),
    "prefix" character varying(64)
);


ALTER TABLE "public"."country" OWNER TO "grizzlysmit";

--
-- TOC entry 258 (class 1259 OID 17315)
-- Name: country_regions_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."country_regions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."country_regions_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 259 (class 1259 OID 17316)
-- Name: country_regions; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."country_regions" (
    "id" bigint DEFAULT "nextval"('"public"."country_regions_id_seq"'::"regclass") NOT NULL,
    "country_id" bigint NOT NULL,
    "distinguishing" character varying(64),
    "landline_pattern" character varying(256),
    "mobile_pattern" character varying(256),
    "landline_title" character varying(256),
    "mobile_title" character varying(256),
    "landline_placeholder" character varying(128),
    "mobile_placeholder" character varying(128),
    "region" character varying(128)
);


ALTER TABLE "public"."country_regions" OWNER TO "grizzlysmit";

--
-- TOC entry 260 (class 1259 OID 17356)
-- Name: countries; Type: VIEW; Schema: public; Owner: grizzlysmit
--

CREATE VIEW "public"."countries" AS
 SELECT "c"."id",
    "c"."cc",
    "c"."_name",
    "c"."_flag",
    "c"."_escape",
    "c"."prefix",
    "cr"."id" AS "cr_id",
    "cr"."region",
    "cr"."distinguishing",
    "cr"."landline_pattern",
    "cr"."mobile_pattern",
    "cr"."landline_title",
    "cr"."mobile_title",
    "cr"."landline_placeholder",
    "cr"."mobile_placeholder"
   FROM ("public"."country" "c"
     LEFT JOIN "public"."country_regions" "cr" ON (("c"."id" = "cr"."country_id")));


ALTER TABLE "public"."countries" OWNER TO "grizzlysmit";

--
-- TOC entry 227 (class 1259 OID 16944)
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: grizzlysmit
--

CREATE SEQUENCE "public"."countries_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE "public"."countries_id_seq" OWNER TO "grizzlysmit";

--
-- TOC entry 228 (class 1259 OID 16945)
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
-- TOC entry 229 (class 1259 OID 16946)
-- Name: email; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."email" (
    "id" bigint DEFAULT "nextval"('"public"."email_id_seq"'::"regclass") NOT NULL,
    "_email" character varying(256) NOT NULL,
    "verified" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."email" OWNER TO "grizzlysmit";

--
-- TOC entry 230 (class 1259 OID 16951)
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
-- TOC entry 231 (class 1259 OID 16952)
-- Name: emails; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."emails" (
    "id" bigint DEFAULT "nextval"('"public"."emails_id_seq"'::"regclass") NOT NULL,
    "email_id" bigint NOT NULL,
    "passwd_id" bigint NOT NULL
);


ALTER TABLE "public"."emails" OWNER TO "grizzlysmit";

--
-- TOC entry 232 (class 1259 OID 16956)
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
-- TOC entry 233 (class 1259 OID 16957)
-- Name: groups; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."groups" (
    "id" bigint DEFAULT "nextval"('"public"."groups_id_seq"'::"regclass") NOT NULL,
    "group_id" bigint NOT NULL,
    "passwd_id" bigint NOT NULL
);


ALTER TABLE "public"."groups" OWNER TO "grizzlysmit";

--
-- TOC entry 234 (class 1259 OID 16961)
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
-- TOC entry 3725 (class 0 OID 0)
-- Dependencies: 234
-- Name: links_id_seq1; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE "public"."links_id_seq1" OWNED BY "public"."links"."id";


--
-- TOC entry 235 (class 1259 OID 16962)
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
-- TOC entry 236 (class 1259 OID 16966)
-- Name: page_section; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."page_section" (
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    "id" bigint NOT NULL,
    "pages_id" bigint NOT NULL,
    "links_section_id" bigint NOT NULL
)
INHERITS ("public"."secure");


ALTER TABLE "public"."page_section" OWNER TO "grizzlysmit";

--
-- TOC entry 237 (class 1259 OID 16974)
-- Name: pages; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."pages" (
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    "id" bigint NOT NULL,
    "name" character varying(256),
    "full_name" character varying(50) NOT NULL
)
INHERITS ("public"."secure");


ALTER TABLE "public"."pages" OWNER TO "grizzlysmit";

--
-- TOC entry 238 (class 1259 OID 16982)
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
-- TOC entry 239 (class 1259 OID 16987)
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
-- TOC entry 3731 (class 0 OID 0)
-- Dependencies: 239
-- Name: page_section_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE "public"."page_section_id_seq" OWNED BY "public"."page_section"."id";


--
-- TOC entry 240 (class 1259 OID 16988)
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
-- TOC entry 241 (class 1259 OID 16992)
-- Name: pseudo_pages; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."pseudo_pages" (
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    "id" bigint NOT NULL,
    "pattern" character varying(256),
    "status" "public"."status" DEFAULT 'invalid'::"public"."status" NOT NULL,
    "name" character varying(50),
    "full_name" character varying(256)
)
INHERITS ("public"."secure");


ALTER TABLE "public"."pseudo_pages" OWNER TO "grizzlysmit";

--
-- TOC entry 242 (class 1259 OID 17001)
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
-- TOC entry 243 (class 1259 OID 17005)
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
-- TOC entry 3736 (class 0 OID 0)
-- Dependencies: 243
-- Name: pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE "public"."pages_id_seq" OWNED BY "public"."pages"."id";


--
-- TOC entry 244 (class 1259 OID 17006)
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
-- TOC entry 245 (class 1259 OID 17007)
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
-- TOC entry 246 (class 1259 OID 17012)
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
-- TOC entry 247 (class 1259 OID 17013)
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
    "secondary_phone_id" bigint,
    "country_id" bigint,
    "country_region_id" bigint
);


ALTER TABLE "public"."passwd_details" OWNER TO "grizzlysmit";

--
-- TOC entry 248 (class 1259 OID 17019)
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
-- TOC entry 249 (class 1259 OID 17020)
-- Name: phone; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."phone" (
    "id" bigint DEFAULT "nextval"('"public"."phone_id_seq"'::"regclass") NOT NULL,
    "_number" character varying(128) NOT NULL,
    "verified" boolean DEFAULT false NOT NULL
);


ALTER TABLE "public"."phone" OWNER TO "grizzlysmit";

--
-- TOC entry 250 (class 1259 OID 17025)
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
-- TOC entry 251 (class 1259 OID 17026)
-- Name: phones; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."phones" (
    "id" bigint DEFAULT "nextval"('"public"."phones_id_seq"'::"regclass") NOT NULL,
    "phone_id" bigint NOT NULL,
    "address_id" bigint NOT NULL
);


ALTER TABLE "public"."phones" OWNER TO "grizzlysmit";

--
-- TOC entry 252 (class 1259 OID 17030)
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
-- TOC entry 3746 (class 0 OID 0)
-- Dependencies: 252
-- Name: psudo_pages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: grizzlysmit
--

ALTER SEQUENCE "public"."psudo_pages_id_seq" OWNED BY "public"."pseudo_pages"."id";


--
-- TOC entry 253 (class 1259 OID 17031)
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
-- TOC entry 254 (class 1259 OID 17036)
-- Name: sessions; Type: TABLE; Schema: public; Owner: grizzlysmit
--

CREATE TABLE "public"."sessions" (
    "id" character(32) NOT NULL,
    "a_session" "text"
);


ALTER TABLE "public"."sessions" OWNER TO "grizzlysmit";

--
-- TOC entry 255 (class 1259 OID 17041)
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
-- TOC entry 3357 (class 2604 OID 17045)
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."addresses" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."addresses_id_seq"'::"regclass");


--
-- TOC entry 3364 (class 2604 OID 17046)
-- Name: alias id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."alias_id_seq"'::"regclass");


--
-- TOC entry 3372 (class 2604 OID 17048)
-- Name: links id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."links_id_seq1"'::"regclass");


--
-- TOC entry 3380 (class 2604 OID 17049)
-- Name: page_section id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."page_section_id_seq"'::"regclass");


--
-- TOC entry 3384 (class 2604 OID 17050)
-- Name: pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pages" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."pages_id_seq"'::"regclass");


--
-- TOC entry 3385 (class 2604 OID 17051)
-- Name: pseudo_pages id; Type: DEFAULT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pseudo_pages" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."psudo_pages_id_seq"'::"regclass");


--
-- TOC entry 3648 (class 0 OID 16868)
-- Dependencies: 212
-- Data for Name: _group; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."_group" VALUES (1, 'admin');
INSERT INTO "public"."_group" VALUES (5, 'grizz');
INSERT INTO "public"."_group" VALUES (4, 'grizzly');
INSERT INTO "public"."_group" VALUES (3, 'grizzlysmit');
INSERT INTO "public"."_group" VALUES (10, 'fredie');
INSERT INTO "public"."_group" VALUES (12, 'romanna');
INSERT INTO "public"."_group" VALUES (11, 'fred');
INSERT INTO "public"."_group" VALUES (9, 'doctor');
INSERT INTO "public"."_group" VALUES (14, 'bilbo');
INSERT INTO "public"."_group" VALUES (8, 'frodo');
INSERT INTO "public"."_group" VALUES (15, 'root');
INSERT INTO "public"."_group" VALUES (21, 'ludo');
INSERT INTO "public"."_group" VALUES (22, 'fbloggs');


--
-- TOC entry 3650 (class 0 OID 16873)
-- Dependencies: 214
-- Data for Name: address; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."address" VALUES (1, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" VALUES (2, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" VALUES (7, '2', '76-84 Karne Street north', 'Riverwood', '2209', 'NSW', 'Australia');
INSERT INTO "public"."address" VALUES (6, '2', '76-84 Karne Street north', 'Narwee', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" VALUES (5, '2', '76-84 Karnee Street north', 'Riveerwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" VALUES (11, '2', '76-84 Karnee Street north', 'Riveerwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" VALUES (4, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" VALUES (15, '', 'The Tardis', 'Tardis', '345667', 'universe', 'Cayman Islands');
INSERT INTO "public"."address" VALUES (14, '', '2 bedrock lane', 'Bedropck', '45567', 'stone age', 'United States Virgin Islands');
INSERT INTO "public"."address" VALUES (12, 'unit 2', 'Tardis ', 'The universe', '9999', 'Galefray', 'Australia');
INSERT INTO "public"."address" VALUES (17, '', '1 Bagshot row', 'Hobitton', '22222', 'The Shire', 'American Samoa');
INSERT INTO "public"."address" VALUES (10, '', 'Baggsend', 'hobbiton', '', 'the shire', 'Barbados');
INSERT INTO "public"."address" VALUES (3, '2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" VALUES (18, 'unit 2', '76-84 Karne Street north', 'Riverwood', '2210', 'NSW', 'Australia');
INSERT INTO "public"."address" VALUES (21, '', '2 Bagshot row', 'Hobbitton', '7777', 'Christmas Island', 'Christmas Island');
INSERT INTO "public"."address" VALUES (22, '', '1 Bagshot Row', 'Hobbitton', '7777', 'The Shire', 'Christmas Island');
INSERT INTO "public"."address" VALUES (23, '', '2 wibble street', 'Wobblesville', '33333', 'wobbles', 'British Virgin Islands');


--
-- TOC entry 3651 (class 0 OID 16879)
-- Dependencies: 215
-- Data for Name: addresses; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3654 (class 0 OID 16891)
-- Dependencies: 218
-- Data for Name: alias; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 'stor', 15);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 'bronze', 9);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 'store', 15);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 'knck-dev', 23);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 'knck', 16);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 'knock-dev', 23);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 'cpp', 24);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 'CPP', 24);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 'c++', 24);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 'proc', 21);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 'dir', 18);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 'out', 7);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 'api.q', 19);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 'api_u', 13);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 'API_U', 13);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 'in', 5);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 'tool', 12);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 'fred', 22);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 22, 'pk', 16);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 23, 'add', 4);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 25, 'perl6', 27);
INSERT INTO "public"."alias" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 26, 'pg', 34);
INSERT INTO "public"."alias" VALUES (3, 4, '("(t,t,t)","(t,t,t)","(t,f,f)")', 35, 'linux', 38);


--
-- TOC entry 3683 (class 0 OID 17300)
-- Dependencies: 257
-- Data for Name: country; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."country" VALUES (19, 'DM', 'Dominica', '/flags/DM.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (7, 'CA', 'Candda', '/flags/CA.png', '0', '+1');
INSERT INTO "public"."country" VALUES (10, 'US', 'United States', '/flags/US.png', '0', '+1');
INSERT INTO "public"."country" VALUES (16, 'DO', 'Dominican Republic', '/flags/DO.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (24, 'GD', 'Grenada', '/flags/GD.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (12, 'GU', 'Guam', '/flags/GU.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (17, 'JM', 'Jamaica', '/flags/JM.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (22, 'MS', 'Montserrat', '/flags/MS.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (6, 'MP', 'Northern Mariana Islands', '/flags/MP.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (15, 'PR', 'Puerto Rico', '/flags/PR.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (14, 'KN', 'Saint Kitts and Nevis', '/flags/KN.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (9, 'LC', 'Saint Lucia', '/flags/LC.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (3, 'VC', 'Saint Vincent and the Grenadines', '/flags/VC.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (23, 'SX', 'Sint Maarten', '/flags/SX.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (11, 'BS', 'The Bahamas', '/flags/BS.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (8, 'TC', 'Turks and Caicos Islands', '/flags/TC.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (5, 'AS', 'American Samoa', '/flags/AS.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (18, 'AI', 'Anguilla', '/flags/AI.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (26, 'VI', 'United States Virgin Islands', '/flags/VI.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (13, 'TT', 'Trinidad and Tobago', '/flags/TT.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (63, 'EG', 'Egypt', '/flags/EG.png', NULL, '+20');
INSERT INTO "public"."country" VALUES (25, 'AG', 'Antigua and Barbuda', '/flags/AG.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (21, 'BB', 'Barbados', '/flags/BB.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (2, 'BM', 'Bermuda', '/flags/BM.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (20, 'VG', 'British Virgin Islands', '/flags/VG.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (4, 'KY', 'Cayman Islands', '/flags/KY.png', NULL, '+1');
INSERT INTO "public"."country" VALUES (43, 'CC', 'Cocos (Keeling) Islands', '/flags/CC.png', NULL, '+61');
INSERT INTO "public"."country" VALUES (56, 'PN', 'Pitcairn Islands', '/flags/PN.png', '0', '+64');
INSERT INTO "public"."country" VALUES (42, 'CX', 'Christmas Island', '/flags/CX.png', NULL, '+61');
INSERT INTO "public"."country" VALUES (27, 'AU', 'Australia', '/flags/AU.png', NULL, '+61');
INSERT INTO "public"."country" VALUES (44, 'NZ', 'New Zealand', '/flags/NZ.png', NULL, '+64');


--
-- TOC entry 3685 (class 0 OID 17316)
-- Dependencies: 259
-- Data for Name: country_regions; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."country_regions" VALUES (6, 7, '368', '(?:\+?1[ -]?)?368[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?368[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1368-234-1234 or 1368 234 1234 or 368-234-1234.', 'Only +digits or local formats allowed i.e. +1368-234-1234 or 1368 234 1234 or 368-234-1234.', '+1-368-234-1234|1 368 234 1234|368 234 1234', '+1-368-234-1234|1 368 234 1234|368 234 1234', 'Alberta');
INSERT INTO "public"."country_regions" VALUES (7, 7, '403', '(?:\+?1[ -]?)?403[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?403[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1403-234-1234 or 1403 234 1234 or 403-234-1234.', 'Only +digits or local formats allowed i.e. +1403-234-1234 or 1403 234 1234 or 403-234-1234.', '+1-403-234-1234|1 403 234 1234|403 234 1234', '+1-403-234-1234|1 403 234 1234|403 234 1234', 'Alberta');
INSERT INTO "public"."country_regions" VALUES (8, 7, '587', '(?:\+?1[ -]?)?587[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?587[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1587-234-1234 or 1587 234 1234 or 587-234-1234.', 'Only +digits or local formats allowed i.e. +1587-234-1234 or 1587 234 1234 or 587-234-1234.', '+1-587-234-1234|1 587 234 1234|587 234 1234', '+1-587-234-1234|1 587 234 1234|587 234 1234', 'Alberta');
INSERT INTO "public"."country_regions" VALUES (9, 7, '780', '(?:\+?1[ -]?)?780[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?780[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1780-234-1234 or 1780 234 1234 or 780-234-1234.', 'Only +digits or local formats allowed i.e. +1780-234-1234 or 1780 234 1234 or 780-234-1234.', '+1-780-234-1234|1 780 234 1234|780 234 1234', '+1-780-234-1234|1 780 234 1234|780 234 1234', 'Alberta');
INSERT INTO "public"."country_regions" VALUES (10, 7, '825', '(?:\+?1[ -]?)?825[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?825[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1825-234-1234 or 1825 234 1234 or 825-234-1234.', 'Only +digits or local formats allowed i.e. +1825-234-1234 or 1825 234 1234 or 825-234-1234.', '+1-825-234-1234|1 825 234 1234|825 234 1234', '+1-825-234-1234|1 825 234 1234|825 234 1234', 'Alberta');
INSERT INTO "public"."country_regions" VALUES (11, 7, '236', '(?:\+?1[ -]?)?236[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?236[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1236-234-1234 or 1236 234 1234 or 236-234-1234.', 'Only +digits or local formats allowed i.e. +1236-234-1234 or 1236 234 1234 or 236-234-1234.', '+1-236-234-1234|1 236 234 1234|236 234 1234', '+1-236-234-1234|1 236 234 1234|236 234 1234', 'British Columbia');
INSERT INTO "public"."country_regions" VALUES (12, 7, '250', '(?:\+?1[ -]?)?250[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?250[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1250-234-1234 or 1250 234 1234 or 250-234-1234.', 'Only +digits or local formats allowed i.e. +1250-234-1234 or 1250 234 1234 or 250-234-1234.', '+1-250-234-1234|1 250 234 1234|250 234 1234', '+1-250-234-1234|1 250 234 1234|250 234 1234', 'British Columbia');
INSERT INTO "public"."country_regions" VALUES (13, 7, '604', '(?:\+?1[ -]?)?604[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?604[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1604-234-1234 or 1604 234 1234 or 604-234-1234.', 'Only +digits or local formats allowed i.e. +1604-234-1234 or 1604 234 1234 or 604-234-1234.', '+1-604-234-1234|1 604 234 1234|604 234 1234', '+1-604-234-1234|1 604 234 1234|604 234 1234', 'British Columbia');
INSERT INTO "public"."country_regions" VALUES (14, 7, '672', '(?:\+?1[ -]?)?672[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?672[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1672-234-1234 or 1672 234 1234 or 672-234-1234.', 'Only +digits or local formats allowed i.e. +1672-234-1234 or 1672 234 1234 or 672-234-1234.', '+1-672-234-1234|1 672 234 1234|672 234 1234', '+1-672-234-1234|1 672 234 1234|672 234 1234', 'British Columbia');
INSERT INTO "public"."country_regions" VALUES (15, 7, '778', '(?:\+?1[ -]?)?778[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?778[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1778-234-1234 or 1778 234 1234 or 778-234-1234.', 'Only +digits or local formats allowed i.e. +1778-234-1234 or 1778 234 1234 or 778-234-1234.', '+1-778-234-1234|1 778 234 1234|778 234 1234', '+1-778-234-1234|1 778 234 1234|778 234 1234', 'British Columbia');
INSERT INTO "public"."country_regions" VALUES (16, 7, '204', '(?:\+?1[ -]?)?204[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?204[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1204-234-1234 or 1204 234 1234 or 204-234-1234.', 'Only +digits or local formats allowed i.e. +1204-234-1234 or 1204 234 1234 or 204-234-1234.', '+1-204-234-1234|1 204 234 1234|204 234 1234', '+1-204-234-1234|1 204 234 1234|204 234 1234', 'Manitoba');
INSERT INTO "public"."country_regions" VALUES (17, 7, '431', '(?:\+?1[ -]?)?431[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?431[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1431-234-1234 or 1431 234 1234 or 431-234-1234.', 'Only +digits or local formats allowed i.e. +1431-234-1234 or 1431 234 1234 or 431-234-1234.', '+1-431-234-1234|1 431 234 1234|431 234 1234', '+1-431-234-1234|1 431 234 1234|431 234 1234', 'Manitoba');
INSERT INTO "public"."country_regions" VALUES (18, 7, '584', '(?:\+?1[ -]?)?584[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?584[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1584-234-1234 or 1584 234 1234 or 584-234-1234.', 'Only +digits or local formats allowed i.e. +1584-234-1234 or 1584 234 1234 or 584-234-1234.', '+1-584-234-1234|1 584 234 1234|584 234 1234', '+1-584-234-1234|1 584 234 1234|584 234 1234', 'Manitoba');
INSERT INTO "public"."country_regions" VALUES (19, 7, '428', '(?:\+?1[ -]?)?428[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?428[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1428-234-1234 or 1428 234 1234 or 428-234-1234.', 'Only +digits or local formats allowed i.e. +1428-234-1234 or 1428 234 1234 or 428-234-1234.', '+1-428-234-1234|1 428 234 1234|428 234 1234', '+1-428-234-1234|1 428 234 1234|428 234 1234', 'New Brunswick');
INSERT INTO "public"."country_regions" VALUES (1, 2, '441', '(?:\+?1[ -]?)?441[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?441[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1441-234-1234 or 1441 234 1234 or 441-234-1234.', 'Only +digits or local formats allowed i.e. +1441-234-1234 or 1441 234 1234 or 441-234-1234.', '+1-441-234-1234|1 441 234 1234|441 234 1234', '+1-441-234-1234|1 441 234 1234|441 234 1234', 'Bermuda');
INSERT INTO "public"."country_regions" VALUES (3, 4, '345', '(?:\+?1[ -]?)?345[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?345[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1345-234-1234 or 1345 234 1234 or 345-234-1234.', 'Only +digits or local formats allowed i.e. +1345-234-1234 or 1345 234 1234 or 245-234-1234.', '+1-345-234-1234|1 345 234 1234|345 234 1234', '+1-345-234-1234|1 345 234 1234|345 234 1234', 'Cayman Islands');
INSERT INTO "public"."country_regions" VALUES (5, 6, '670', '(?:\+?1[ -]?)?670[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?670[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1670-234-1234 or 1670 234 1234 or 670-234-1234.', 'Only +digits or local formats allowed i.e. +1670-234-1234 or 1670 234 1234 or 670-234-1234.', '+1-670-234-1234|1 670 234 1234|670 234 1234', '+1-670-234-1234|1 670 234 1234|670 234 1234', 'Northern Mariana Islands');
INSERT INTO "public"."country_regions" VALUES (2, 3, '784', '(?:\+?1[ -]?)?784[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?784[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1784-234-1234 or 1784 234 1234 or 784-234-1234.', 'Only +digits or local formats allowed i.e. +1784-234-1234 or 1784 234 1234 or 784-234-1234.', '+1-784-234-1234|1 784 234 1234|784 234 1234', '+1-784-234-1234|1 784 234 1234|784 234 1234', 'Saint Vincent and the Grenadines');
INSERT INTO "public"."country_regions" VALUES (20, 7, '506', '(?:\+?1[ -]?)?506[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?506[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1506-234-1234 or 1506 234 1234 or 506-234-1234.', 'Only +digits or local formats allowed i.e. +1506-234-1234 or 1506 234 1234 or 506-234-1234.', '+1-506-234-1234|1 506 234 1234|506 234 1234', '+1-506-234-1234|1 506 234 1234|506 234 1234', 'New Brunswick');
INSERT INTO "public"."country_regions" VALUES (21, 7, '709', '(?:\+?1[ -]?)?709[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?709[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1709-234-1234 or 1709 234 1234 or 709-234-1234.', 'Only +digits or local formats allowed i.e. +1709-234-1234 or 1709 234 1234 or 709-234-1234.', '+1-709-234-1234|1 709 234 1234|709 234 1234', '+1-709-234-1234|1 709 234 1234|709 234 1234', 'Newfoundland and Labrador');
INSERT INTO "public"."country_regions" VALUES (22, 7, '879', '(?:\+?1[ -]?)?879[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?879[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1879-234-1234 or 1879 234 1234 or 879-234-1234.', 'Only +digits or local formats allowed i.e. +1879-234-1234 or 1879 234 1234 or 879-234-1234.', '+1-879-234-1234|1 879 234 1234|879 234 1234', '+1-879-234-1234|1 879 234 1234|879 234 1234', 'Newfoundland and Labrador');
INSERT INTO "public"."country_regions" VALUES (23, 7, '867', '(?:\+?1[ -]?)?867[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?867[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1867-234-1234 or 1867 234 1234 or 867-234-1234.', 'Only +digits or local formats allowed i.e. +1867-234-1234 or 1867 234 1234 or 867-234-1234.', '+1-867-234-1234|1 867 234 1234|867 234 1234', '+1-867-234-1234|1 867 234 1234|867 234 1234', 'Northwest Territories');
INSERT INTO "public"."country_regions" VALUES (24, 7, '782', '(?:\+?1[ -]?)?782[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?782[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1782-234-1234 or 1782 234 1234 or 782-234-1234.', 'Only +digits or local formats allowed i.e. +1782-234-1234 or 1782 234 1234 or 782-234-1234.', '+1-782-234-1234|1 782 234 1234|782 234 1234', '+1-782-234-1234|1 782 234 1234|782 234 1234', 'Nova Scotia');
INSERT INTO "public"."country_regions" VALUES (25, 7, '902', '(?:\+?1[ -]?)?902[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?902[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1902-234-1234 or 1902 234 1234 or 902-234-1234.', 'Only +digits or local formats allowed i.e. +1902-234-1234 or 1902 234 1234 or 902-234-1234.', '+1-902-234-1234|1 902 234 1234|902 234 1234', '+1-902-234-1234|1 902 234 1234|902 234 1234', 'Nova Scotia');
INSERT INTO "public"."country_regions" VALUES (26, 7, '226', '(?:\+?1[ -]?)?226[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?226[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1226-234-1234 or 1226 234 1234 or 226-234-1234.', 'Only +digits or local formats allowed i.e. +1226-234-1234 or 1226 234 1234 or 226-234-1234.', '+1-226-234-1234|1 226 234 1234|226 234 1234', '+1-226-234-1234|1 226 234 1234|226 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (27, 7, '249', '(?:\+?1[ -]?)?249[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?249[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1249-234-1234 or 1249 234 1234 or 249-234-1234.', 'Only +digits or local formats allowed i.e. +1249-234-1234 or 1249 234 1234 or 249-234-1234.', '+1-249-234-1234|1 249 234 1234|249 234 1234', '+1-249-234-1234|1 249 234 1234|249 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (28, 7, '289', '(?:\+?1[ -]?)?289[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?289[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1289-234-1234 or 1289 234 1234 or 289-234-1234.', 'Only +digits or local formats allowed i.e. +1289-234-1234 or 1289 234 1234 or 289-234-1234.', '+1-289-234-1234|1 289 234 1234|289 234 1234', '+1-289-234-1234|1 289 234 1234|289 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (29, 7, '343', '(?:\+?1[ -]?)?343[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?343[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1343-234-1234 or 1343 234 1234 or 343-234-1234.', 'Only +digits or local formats allowed i.e. +1343-234-1234 or 1343 234 1234 or 343-234-1234.', '+1-343-234-1234|1 343 234 1234|343 234 1234', '+1-343-234-1234|1 343 234 1234|343 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (30, 7, '365', '(?:\+?1[ -]?)?365[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?365[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1365-234-1234 or 1365 234 1234 or 365-234-1234.', 'Only +digits or local formats allowed i.e. +1365-234-1234 or 1365 234 1234 or 365-234-1234.', '+1-365-234-1234|1 365 234 1234|365 234 1234', '+1-365-234-1234|1 365 234 1234|365 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (31, 7, '382', '(?:\+?1[ -]?)?382[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?382[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1382-234-1234 or 1382 234 1234 or 382-234-1234.', 'Only +digits or local formats allowed i.e. +1382-234-1234 or 1382 234 1234 or 382-234-1234.', '+1-382-234-1234|1 382 234 1234|382 234 1234', '+1-382-234-1234|1 382 234 1234|382 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (32, 7, '387', '(?:\+?1[ -]?)?387[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?387[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1387-234-1234 or 1387 234 1234 or 387-234-1234.', 'Only +digits or local formats allowed i.e. +1387-234-1234 or 1387 234 1234 or 387-234-1234.', '+1-387-234-1234|1 387 234 1234|387 234 1234', '+1-387-234-1234|1 387 234 1234|387 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (33, 7, '416', '(?:\+?1[ -]?)?416[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?416[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1416-234-1234 or 1416 234 1234 or 416-234-1234.', 'Only +digits or local formats allowed i.e. +1416-234-1234 or 1416 234 1234 or 416-234-1234.', '+1-416-234-1234|1 416 234 1234|416 234 1234', '+1-416-234-1234|1 416 234 1234|416 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (34, 7, '437', '(?:\+?1[ -]?)?437[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?437[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1437-234-1234 or 1437 234 1234 or 437-234-1234.', 'Only +digits or local formats allowed i.e. +1437-234-1234 or 1437 234 1234 or 437-234-1234.', '+1-437-234-1234|1 437 234 1234|437 234 1234', '+1-437-234-1234|1 437 234 1234|437 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (35, 7, '519', '(?:\+?1[ -]?)?519[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?519[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1519-234-1234 or 1519 234 1234 or 519-234-1234.', 'Only +digits or local formats allowed i.e. +1519-234-1234 or 1519 234 1234 or 519-234-1234.', '+1-519-234-1234|1 519 234 1234|519 234 1234', '+1-519-234-1234|1 519 234 1234|519 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (36, 7, '548', '(?:\+?1[ -]?)?548[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?548[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1548-234-1234 or 1548 234 1234 or 548-234-1234.', 'Only +digits or local formats allowed i.e. +1548-234-1234 or 1548 234 1234 or 548-234-1234.', '+1-548-234-1234|1 548 234 1234|548 234 1234', '+1-548-234-1234|1 548 234 1234|548 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (37, 7, '613', '(?:\+?1[ -]?)?613[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?613[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1613-234-1234 or 1613 234 1234 or 613-234-1234.', 'Only +digits or local formats allowed i.e. +1613-234-1234 or 1613 234 1234 or 613-234-1234.', '+1-613-234-1234|1 613 234 1234|613 234 1234', '+1-613-234-1234|1 613 234 1234|613 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (38, 7, '647', '(?:\+?1[ -]?)?647[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?647[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1647-234-1234 or 1647 234 1234 or 647-234-1234.', 'Only +digits or local formats allowed i.e. +1647-234-1234 or 1647 234 1234 or 647-234-1234.', '+1-647-234-1234|1 647 234 1234|647 234 1234', '+1-647-234-1234|1 647 234 1234|647 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (39, 7, '683', '(?:\+?1[ -]?)?683[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?683[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1683-234-1234 or 1683 234 1234 or 683-234-1234.', 'Only +digits or local formats allowed i.e. +1683-234-1234 or 1683 234 1234 or 683-234-1234.', '+1-683-234-1234|1 683 234 1234|683 234 1234', '+1-683-234-1234|1 683 234 1234|683 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (40, 7, '705', '(?:\+?1[ -]?)?705[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?705[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1705-234-1234 or 1705 234 1234 or 705-234-1234.', 'Only +digits or local formats allowed i.e. +1705-234-1234 or 1705 234 1234 or 705-234-1234.', '+1-705-234-1234|1 705 234 1234|705 234 1234', '+1-705-234-1234|1 705 234 1234|705 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (41, 7, '742', '(?:\+?1[ -]?)?742[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?742[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1742-234-1234 or 1742 234 1234 or 742-234-1234.', 'Only +digits or local formats allowed i.e. +1742-234-1234 or 1742 234 1234 or 742-234-1234.', '+1-742-234-1234|1 742 234 1234|742 234 1234', '+1-742-234-1234|1 742 234 1234|742 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (42, 7, '753', '(?:\+?1[ -]?)?753[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?753[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1753-234-1234 or 1753 234 1234 or 753-234-1234.', 'Only +digits or local formats allowed i.e. +1753-234-1234 or 1753 234 1234 or 753-234-1234.', '+1-753-234-1234|1 753 234 1234|753 234 1234', '+1-753-234-1234|1 753 234 1234|753 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (43, 7, '807', '(?:\+?1[ -]?)?807[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?807[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1807-234-1234 or 1807 234 1234 or 807-234-1234.', 'Only +digits or local formats allowed i.e. +1807-234-1234 or 1807 234 1234 or 807-234-1234.', '+1-807-234-1234|1 807 234 1234|807 234 1234', '+1-807-234-1234|1 807 234 1234|807 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (44, 7, '905', '(?:\+?1[ -]?)?905[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?905[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1905-234-1234 or 1905 234 1234 or 905-234-1234.', 'Only +digits or local formats allowed i.e. +1905-234-1234 or 1905 234 1234 or 905-234-1234.', '+1-905-234-1234|1 905 234 1234|905 234 1234', '+1-905-234-1234|1 905 234 1234|905 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (45, 7, '942', '(?:\+?1[ -]?)?942[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?942[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1942-234-1234 or 1942 234 1234 or 942-234-1234.', 'Only +digits or local formats allowed i.e. +1942-234-1234 or 1942 234 1234 or 942-234-1234.', '+1-942-234-1234|1 942 234 1234|942 234 1234', '+1-942-234-1234|1 942 234 1234|942 234 1234', 'Ontario');
INSERT INTO "public"."country_regions" VALUES (46, 7, '263', '(?:\+?1[ -]?)?263[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?263[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1263-234-1234 or 1263 234 1234 or 263-234-1234.', 'Only +digits or local formats allowed i.e. +1263-234-1234 or 1263 234 1234 or 263-234-1234.', '+1-263-234-1234|1 263 234 1234|263 234 1234', '+1-263-234-1234|1 263 234 1234|263 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (47, 7, '354', '(?:\+?1[ -]?)?354[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?354[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1354-234-1234 or 1354 234 1234 or 354-234-1234.', 'Only +digits or local formats allowed i.e. +1354-234-1234 or 1354 234 1234 or 354-234-1234.', '+1-354-234-1234|1 354 234 1234|354 234 1234', '+1-354-234-1234|1 354 234 1234|354 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (48, 7, '367', '(?:\+?1[ -]?)?367[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?367[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1367-234-1234 or 1367 234 1234 or 367-234-1234.', 'Only +digits or local formats allowed i.e. +1367-234-1234 or 1367 234 1234 or 367-234-1234.', '+1-367-234-1234|1 367 234 1234|367 234 1234', '+1-367-234-1234|1 367 234 1234|367 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (49, 7, '418', '(?:\+?1[ -]?)?418[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?418[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1418-234-1234 or 1418 234 1234 or 418-234-1234.', 'Only +digits or local formats allowed i.e. +1418-234-1234 or 1418 234 1234 or 418-234-1234.', '+1-418-234-1234|1 418 234 1234|418 234 1234', '+1-418-234-1234|1 418 234 1234|418 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (50, 7, '438', '(?:\+?1[ -]?)?438[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?438[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1438-234-1234 or 1438 234 1234 or 438-234-1234.', 'Only +digits or local formats allowed i.e. +1438-234-1234 or 1438 234 1234 or 438-234-1234.', '+1-438-234-1234|1 438 234 1234|438 234 1234', '+1-438-234-1234|1 438 234 1234|438 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (51, 7, '450', '(?:\+?1[ -]?)?450[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?450[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1450-234-1234 or 1450 234 1234 or 450-234-1234.', 'Only +digits or local formats allowed i.e. +1450-234-1234 or 1450 234 1234 or 450-234-1234.', '+1-450-234-1234|1 450 234 1234|450 234 1234', '+1-450-234-1234|1 450 234 1234|450 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (52, 7, '468', '(?:\+?1[ -]?)?468[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?468[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1468-234-1234 or 1468 234 1234 or 468-234-1234.', 'Only +digits or local formats allowed i.e. +1468-234-1234 or 1468 234 1234 or 468-234-1234.', '+1-468-234-1234|1 468 234 1234|468 234 1234', '+1-468-234-1234|1 468 234 1234|468 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (53, 7, '514', '(?:\+?1[ -]?)?514[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?514[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1514-234-1234 or 1514 234 1234 or 514-234-1234.', 'Only +digits or local formats allowed i.e. +1514-234-1234 or 1514 234 1234 or 514-234-1234.', '+1-514-234-1234|1 514 234 1234|514 234 1234', '+1-514-234-1234|1 514 234 1234|514 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (54, 7, '579', '(?:\+?1[ -]?)?579[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?579[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1579-234-1234 or 1579 234 1234 or 579-234-1234.', 'Only +digits or local formats allowed i.e. +1579-234-1234 or 1579 234 1234 or 579-234-1234.', '+1-579-234-1234|1 579 234 1234|579 234 1234', '+1-579-234-1234|1 579 234 1234|579 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (55, 7, '581', '(?:\+?1[ -]?)?581[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?581[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1581-234-1234 or 1581 234 1234 or 581-234-1234.', 'Only +digits or local formats allowed i.e. +1581-234-1234 or 1581 234 1234 or 581-234-1234.', '+1-581-234-1234|1 581 234 1234|581 234 1234', '+1-581-234-1234|1 581 234 1234|581 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (56, 7, '819', '(?:\+?1[ -]?)?819[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?819[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1819-234-1234 or 1819 234 1234 or 819-234-1234.', 'Only +digits or local formats allowed i.e. +1819-234-1234 or 1819 234 1234 or 819-234-1234.', '+1-819-234-1234|1 819 234 1234|819 234 1234', '+1-819-234-1234|1 819 234 1234|819 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (57, 7, '873', '(?:\+?1[ -]?)?873[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?873[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1873-234-1234 or 1873 234 1234 or 873-234-1234.', 'Only +digits or local formats allowed i.e. +1873-234-1234 or 1873 234 1234 or 873-234-1234.', '+1-873-234-1234|1 873 234 1234|873 234 1234', '+1-873-234-1234|1 873 234 1234|873 234 1234', 'Quebec');
INSERT INTO "public"."country_regions" VALUES (58, 7, '306', '(?:\+?1[ -]?)?306[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?306[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1306-234-1234 or 1306 234 1234 or 306-234-1234.', 'Only +digits or local formats allowed i.e. +1306-234-1234 or 1306 234 1234 or 306-234-1234.', '+1-306-234-1234|1 306 234 1234|306 234 1234', '+1-306-234-1234|1 306 234 1234|306 234 1234', 'Saskatchewan');
INSERT INTO "public"."country_regions" VALUES (59, 7, '474', '(?:\+?1[ -]?)?474[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?474[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1474-234-1234 or 1474 234 1234 or 474-234-1234.', 'Only +digits or local formats allowed i.e. +1474-234-1234 or 1474 234 1234 or 474-234-1234.', '+1-474-234-1234|1 474 234 1234|474 234 1234', '+1-474-234-1234|1 474 234 1234|474 234 1234', 'Saskatchewan');
INSERT INTO "public"."country_regions" VALUES (60, 7, '639', '(?:\+?1[ -]?)?639[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?639[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1639-234-1234 or 1639 234 1234 or 639-234-1234.', 'Only +digits or local formats allowed i.e. +1639-234-1234 or 1639 234 1234 or 639-234-1234.', '+1-639-234-1234|1 639 234 1234|639 234 1234', '+1-639-234-1234|1 639 234 1234|639 234 1234', 'Saskatchewan');
INSERT INTO "public"."country_regions" VALUES (61, 7, '600', '(?:\+?1[ -]?)?600[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?600[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1600-234-1234 or 1600 234 1234 or 600-234-1234.', 'Only +digits or local formats allowed i.e. +1600-234-1234 or 1600 234 1234 or 600-234-1234.', '+1-600-234-1234|1 600 234 1234|600 234 1234', '+1-600-234-1234|1 600 234 1234|600 234 1234', 'special services');
INSERT INTO "public"."country_regions" VALUES (62, 7, '622', '(?:\+?1[ -]?)?622[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?622[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1622-234-1234 or 1622 234 1234 or 622-234-1234.', 'Only +digits or local formats allowed i.e. +1622-234-1234 or 1622 234 1234 or 622-234-1234.', '+1-622-234-1234|1 622 234 1234|622 234 1234', '+1-622-234-1234|1 622 234 1234|622 234 1234', 'special services');
INSERT INTO "public"."country_regions" VALUES (63, 7, '633', '(?:\+?1[ -]?)?633[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?633[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1633-234-1234 or 1633 234 1234 or 633-234-1234.', 'Only +digits or local formats allowed i.e. +1633-234-1234 or 1633 234 1234 or 633-234-1234.', '+1-633-234-1234|1 633 234 1234|633 234 1234', '+1-633-234-1234|1 633 234 1234|633 234 1234', 'special services');
INSERT INTO "public"."country_regions" VALUES (64, 7, '644', '(?:\+?1[ -]?)?644[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?644[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1644-234-1234 or 1644 234 1234 or 644-234-1234.', 'Only +digits or local formats allowed i.e. +1644-234-1234 or 1644 234 1234 or 644-234-1234.', '+1-644-234-1234|1 644 234 1234|644 234 1234', '+1-644-234-1234|1 644 234 1234|644 234 1234', 'special services');
INSERT INTO "public"."country_regions" VALUES (65, 7, '655', '(?:\+?1[ -]?)?655[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?655[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1655-234-1234 or 1655 234 1234 or 655-234-1234.', 'Only +digits or local formats allowed i.e. +1655-234-1234 or 1655 234 1234 or 655-234-1234.', '+1-655-234-1234|1 655 234 1234|655 234 1234', '+1-655-234-1234|1 655 234 1234|655 234 1234', 'special services');
INSERT INTO "public"."country_regions" VALUES (66, 7, '677', '(?:\+?1[ -]?)?677[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?677[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1677-234-1234 or 1677 234 1234 or 677-234-1234.', 'Only +digits or local formats allowed i.e. +1677-234-1234 or 1677 234 1234 or 677-234-1234.', '+1-677-234-1234|1 677 234 1234|677 234 1234', '+1-677-234-1234|1 677 234 1234|677 234 1234', 'special services');
INSERT INTO "public"."country_regions" VALUES (67, 7, '688', '(?:\+?1[ -]?)?688[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?688[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1688-234-1234 or 1688 234 1234 or 688-234-1234.', 'Only +digits or local formats allowed i.e. +1688-234-1234 or 1688 234 1234 or 688-234-1234.', '+1-688-234-1234|1 688 234 1234|688 234 1234', '+1-688-234-1234|1 688 234 1234|688 234 1234', 'special services');
INSERT INTO "public"."country_regions" VALUES (70, 10, '251', '(?:\+?1[ -]?)?251[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?251[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1251-234-1234 or 1251 234 1234 or 251-234-1234.', 'Only +digits or local formats allowed i.e. +1251-234-1234 or 1251 234 1234 or 251-234-1234.', '+1-251-234-1234|1 251 234 1234|251 234 1234', '+1-251-234-1234|1 251 234 1234|251 234 1234', 'Alabama');
INSERT INTO "public"."country_regions" VALUES (71, 10, '256', '(?:\+?1[ -]?)?256[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?256[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1256-234-1234 or 1256 234 1234 or 256-234-1234.', 'Only +digits or local formats allowed i.e. +1256-234-1234 or 1256 234 1234 or 256-234-1234.', '+1-256-234-1234|1 256 234 1234|256 234 1234', '+1-256-234-1234|1 256 234 1234|256 234 1234', 'Alabama');
INSERT INTO "public"."country_regions" VALUES (72, 10, '205', '(?:\+?1[ -]?)?205[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?205[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1205-234-1234 or 1205 234 1234 or 205-234-1234.', 'Only +digits or local formats allowed i.e. +1205-234-1234 or 1205 234 1234 or 205-234-1234.', '+1-205-234-1234|1 205 234 1234|205 234 1234', '+1-205-234-1234|1 205 234 1234|205 234 1234', 'Alabama');
INSERT INTO "public"."country_regions" VALUES (73, 10, '907', '(?:\+?1[ -]?)?907[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?907[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1907-234-1234 or 1907 234 1234 or 907-234-1234.', 'Only +digits or local formats allowed i.e. +1907-234-1234 or 1907 234 1234 or 907-234-1234.', '+1-907-234-1234|1 907 234 1234|907 234 1234', '+1-907-234-1234|1 907 234 1234|907 234 1234', 'Alaska');
INSERT INTO "public"."country_regions" VALUES (74, 10, '480', '(?:\+?1[ -]?)?480[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?480[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1480-234-1234 or 1480 234 1234 or 480-234-1234.', 'Only +digits or local formats allowed i.e. +1480-234-1234 or 1480 234 1234 or 480-234-1234.', '+1-480-234-1234|1 480 234 1234|480 234 1234', '+1-480-234-1234|1 480 234 1234|480 234 1234', 'Arizona');
INSERT INTO "public"."country_regions" VALUES (75, 10, '520', '(?:\+?1[ -]?)?520[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?520[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1520-234-1234 or 1520 234 1234 or 520-234-1234.', 'Only +digits or local formats allowed i.e. +1520-234-1234 or 1520 234 1234 or 520-234-1234.', '+1-520-234-1234|1 520 234 1234|520 234 1234', '+1-520-234-1234|1 520 234 1234|520 234 1234', 'Arizona');
INSERT INTO "public"."country_regions" VALUES (76, 10, '602', '(?:\+?1[ -]?)?602[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?602[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1602-234-1234 or 1602 234 1234 or 602-234-1234.', 'Only +digits or local formats allowed i.e. +1602-234-1234 or 1602 234 1234 or 602-234-1234.', '+1-602-234-1234|1 602 234 1234|602 234 1234', '+1-602-234-1234|1 602 234 1234|602 234 1234', 'Arizona');
INSERT INTO "public"."country_regions" VALUES (68, 8, '649', '(?:\+?1[ -]?)?649[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?649[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +16439-234-1234 or 1649 234 1234 or 649-234-1234.', 'Only +digits or local formats allowed i.e. +1649-234-1234 or 1649 234 1234 or 649-234-1234.', '+1-649-234-1234|1 649 234 1234|649 234 1234', '+1-649-234-1234|1 649 234 1234|649 234 1234', 'Turks and Caicos Islands');
INSERT INTO "public"."country_regions" VALUES (77, 10, '623', '(?:\+?1[ -]?)?623[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?623[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1623-234-1234 or 1623 234 1234 or 623-234-1234.', 'Only +digits or local formats allowed i.e. +1623-234-1234 or 1623 234 1234 or 623-234-1234.', '+1-623-234-1234|1 623 234 1234|623 234 1234', '+1-623-234-1234|1 623 234 1234|623 234 1234', 'Arizona');
INSERT INTO "public"."country_regions" VALUES (78, 10, '928', '(?:\+?1[ -]?)?928[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?928[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1928-234-1234 or 1928 234 1234 or 928-234-1234.', 'Only +digits or local formats allowed i.e. +1928-234-1234 or 1928 234 1234 or 928-234-1234.', '+1-928-234-1234|1 928 234 1234|928 234 1234', '+1-928-234-1234|1 928 234 1234|928 234 1234', 'Arizona');
INSERT INTO "public"."country_regions" VALUES (79, 10, '327', '(?:\+?1[ -]?)?327[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?327[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1327-234-1234 or 1327 234 1234 or 327-234-1234.', 'Only +digits or local formats allowed i.e. +1327-234-1234 or 1327 234 1234 or 327-234-1234.', '+1-327-234-1234|1 327 234 1234|327 234 1234', '+1-327-234-1234|1 327 234 1234|327 234 1234', 'Arkansas');
INSERT INTO "public"."country_regions" VALUES (80, 10, '501', '(?:\+?1[ -]?)?501[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?501[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1501-234-1234 or 1501 234 1234 or 501-234-1234.', 'Only +digits or local formats allowed i.e. +1501-234-1234 or 1501 234 1234 or 501-234-1234.', '+1-501-234-1234|1 501 234 1234|501 234 1234', '+1-501-234-1234|1 501 234 1234|501 234 1234', 'Arkansas');
INSERT INTO "public"."country_regions" VALUES (81, 10, '870', '(?:\+?1[ -]?)?870[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?870[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1870-234-1234 or 1870 234 1234 or 870-234-1234.', 'Only +digits or local formats allowed i.e. +1870-234-1234 or 1870 234 1234 or 870-234-1234.', '+1-870-234-1234|1 870 234 1234|870 234 1234', '+1-870-234-1234|1 870 234 1234|870 234 1234', 'Arkansas');
INSERT INTO "public"."country_regions" VALUES (82, 10, '213', '(?:\+?1[ -]?)?213[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?213[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1213-234-1234 or 1213 234 1234 or 213-234-1234.', 'Only +digits or local formats allowed i.e. +1213-234-1234 or 1213 234 1234 or 213-234-1234.', '+1-213-234-1234|1 213 234 1234|213 234 1234', '+1-213-234-1234|1 213 234 1234|213 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (83, 10, '279', '(?:\+?1[ -]?)?279[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?279[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1279-234-1234 or 1279 234 1234 or 279-234-1234.', 'Only +digits or local formats allowed i.e. +1279-234-1234 or 1279 234 1234 or 279-234-1234.', '+1-279-234-1234|1 279 234 1234|279 234 1234', '+1-279-234-1234|1 279 234 1234|279 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (84, 10, '310', '(?:\+?1[ -]?)?310[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?310[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1310-234-1234 or 1310 234 1234 or 310-234-1234.', 'Only +digits or local formats allowed i.e. +1310-234-1234 or 1310 234 1234 or 310-234-1234.', '+1-310-234-1234|1 310 234 1234|310 234 1234', '+1-310-234-1234|1 310 234 1234|310 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (85, 10, '659', '(?:\+?1[ -]?)?659[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?659[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1659-234-1234 or 1659 234 1234 or 659-234-1234.', 'Only +digits or local formats allowed i.e. +1659-234-1234 or 1659 234 1234 or 659-234-1234.', '+1-659-234-1234|1 659 234 1234|659 234 1234', '+1-659-234-1234|1 659 234 1234|659 234 1234', 'Alabama');
INSERT INTO "public"."country_regions" VALUES (86, 10, '938', '(?:\+?1[ -]?)?938[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?938[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1938-234-1234 or 1938 234 1234 or 938-234-1234.', 'Only +digits or local formats allowed i.e. +1938-234-1234 or 1938 234 1234 or 938-234-1234.', '+1-938-234-1234|1 938 234 1234|938 234 1234', '+1-938-234-1234|1 938 234 1234|938 234 1234', 'Alabama');
INSERT INTO "public"."country_regions" VALUES (87, 10, '209', '(?:\+?1[ -]?)?209[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?209[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1-209-234-1234 or 1 209 234 1234 or  209-234-1234.', 'Only +digits or local formats allowed i.e. +1 209-234-1234 or 1 209 234 1234 or 209-234-1234.', '+1-209-234-1234|1 209 234 1234|209 234 1234', '+1-209-234-1234|1 209 234 1234|209 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (88, 10, '415', '(?:\+?1[ -]?)?415[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?415[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1415-234-1234 or 1415 234 1234 or 415-234-1234.', 'Only +digits or local formats allowed i.e. +1415-234-1234 or 1415 234 1234 or 415-234-1234.', '+1-415-234-1234|1 415 234 1234|415 234 1234', '+1-415-234-1234|1 415 234 1234|415 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (89, 10, '424', '(?:\+?1[ -]?)?424[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?424[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1424-234-1234 or 1424 234 1234 or 424-234-1234.', 'Only +digits or local formats allowed i.e. +1424-234-1234 or 1424 234 1234 or 424-234-1234.', '+1-424-234-1234|1 424 234 1234|424 234 1234', '+1-424-234-1234|1 424 234 1234|424 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (90, 10, '442', '(?:\+?1[ -]?)?442[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?442[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1442-234-1234 or 1442 234 1234 or 442-234-1234.', 'Only +digits or local formats allowed i.e. +1442-234-1234 or 1442 234 1234 or 442-234-1234.', '+1-442-234-1234|1 442 234 1234|442 234 1234', '+1-442-234-1234|1 442 234 1234|442 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (91, 10, '510', '(?:\+?1[ -]?)?510[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?510[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1510-234-1234 or 1510 234 1234 or 510-234-1234.', 'Only +digits or local formats allowed i.e. +1510-234-1234 or 1510 234 1234 or 510-234-1234.', '+1-510-234-1234|1 510 234 1234|510 234 1234', '+1-510-234-1234|1 510 234 1234|510 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (92, 10, '530', '(?:\+?1[ -]?)?530[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?530[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1530-234-1234 or 1530 234 1234 or 530-234-1234.', 'Only +digits or local formats allowed i.e. +1530-234-1234 or 1530 234 1234 or 530-234-1234.', '+1-530-234-1234|1 530 234 1234|530 234 1234', '+1-530-234-1234|1 530 234 1234|530 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (93, 10, '559', '(?:\+?1[ -]?)?559[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?559[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1559-234-1234 or 1559 234 1234 or 559-234-1234.', 'Only +digits or local formats allowed i.e. +1559-234-1234 or 1559 234 1234 or 559-234-1234.', '+1-559-234-1234|1 559 234 1234|559 234 1234', '+1-559-234-1234|1 559 234 1234|559 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (94, 10, '562', '(?:\+?1[ -]?)?562[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?562[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1562-234-1234 or 1562 234 1234 or 562-234-1234.', 'Only +digits or local formats allowed i.e. +1562-234-1234 or 1562 234 1234 or 562-234-1234.', '+1-562-234-1234|1 562 234 1234|562 234 1234', '+1-562-234-1234|1 562 234 1234|562 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (95, 10, '619', '(?:\+?1[ -]?)?619[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?619[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1619-234-1234 or 1619 234 1234 or 619-234-1234.', 'Only +digits or local formats allowed i.e. +1619-234-1234 or 1619 234 1234 or 619-234-1234.', '+1-619-234-1234|1 619 234 1234|619 234 1234', '+1-619-234-1234|1 619 234 1234|619 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (96, 10, '626', '(?:\+?1[ -]?)?626[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?626[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1626-234-1234 or 1626 234 1234 or 626-234-1234.', 'Only +digits or local formats allowed i.e. +1626-234-1234 or 1626 234 1234 or 626-234-1234.', '+1-626-234-1234|1 626 234 1234|626 234 1234', '+1-626-234-1234|1 626 234 1234|626 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (97, 10, '628', '(?:\+?1[ -]?)?628[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?628[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1628-234-1234 or 1628 234 1234 or 628-234-1234.', 'Only +digits or local formats allowed i.e. +1628-234-1234 or 1628 234 1234 or 628-234-1234.', '+1-628-234-1234|1 628 234 1234|628 234 1234', '+1-628-234-1234|1 628 234 1234|628 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (98, 10, '650', '(?:\+?1[ -]?)?650[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?650[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1650-234-1234 or 1650 234 1234 or 650-234-1234.', 'Only +digits or local formats allowed i.e. +1650-234-1234 or 1650 234 1234 or 650-234-1234.', '+1-650-234-1234|1 650 234 1234|650 234 1234', '+1-650-234-1234|1 650 234 1234|650 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (99, 10, '657', '(?:\+?1[ -]?)?657[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?657[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1657-234-1234 or 1657 234 1234 or 657-234-1234.', 'Only +digits or local formats allowed i.e. +1657-234-1234 or 1657 234 1234 or 657-234-1234.', '+1-657-234-1234|1 657 234 1234|657 234 1234', '+1-657-234-1234|1 657 234 1234|657 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (100, 10, '661', '(?:\+?1[ -]?)?661[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?661[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1661-234-1234 or 1661 234 1234 or 661-234-1234.', 'Only +digits or local formats allowed i.e. +1661-234-1234 or 1661 234 1234 or 661-234-1234.', '+1-661-234-1234|1 661 234 1234|661 234 1234', '+1-661-234-1234|1 661 234 1234|661 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (101, 10, '341', '(?:\+?1[ -]?)?341[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?341[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1341-234-1234 or 1341 234 1234 or 341-234-1234.', 'Only +digits or local formats allowed i.e. +1341-234-1234 or 1341 234 1234 or 341-234-1234.', '+1-341-234-1234|1 341 234 1234|341 234 1234', '+1-341-234-1234|1 341 234 1234|341 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (102, 10, '408', '(?:\+?1[ -]?)?408[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?408[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1408-234-1234 or 1408 234 1234 or 408-234-1234.', 'Only +digits or local formats allowed i.e. +1408-234-1234 or 1408 234 1234 or 408-234-1234.', '+1-408-234-1234|1 408 234 1234|408 234 1234', '+1-408-234-1234|1 408 234 1234|408 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (103, 10, '747', '(?:\+?1[ -]?)?747[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?747[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1747-234-1234 or 1747 234 1234 or 747-234-1234.', 'Only +digits or local formats allowed i.e. +1747-234-1234 or 1747 234 1234 or 747-234-1234.', '+1-747-234-1234|1 747 234 1234|747 234 1234', '+1-747-234-1234|1 747 234 1234|747 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (104, 10, '760', '(?:\+?1[ -]?)?760[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?760[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1760-234-1234 or 1760 234 1234 or 760-234-1234.', 'Only +digits or local formats allowed i.e. +1760-234-1234 or 1760 234 1234 or 760-234-1234.', '+1-760-234-1234|1 760 234 1234|760 234 1234', '+1-760-234-1234|1 760 234 1234|760 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (105, 10, '805', '(?:\+?1[ -]?)?805[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?805[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1805-234-1234 or 1805 234 1234 or 805-234-1234.', 'Only +digits or local formats allowed i.e. +1805-234-1234 or 1805 234 1234 or 805-234-1234.', '+1-805-234-1234|1 805 234 1234|805 234 1234', '+1-805-234-1234|1 805 234 1234|805 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (106, 10, '818', '(?:\+?1[ -]?)?818[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?818[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1818-234-1234 or 1818 234 1234 or 818-234-1234.', 'Only +digits or local formats allowed i.e. +1818-234-1234 or 1818 234 1234 or 818-234-1234.', '+1-818-234-1234|1 818 234 1234|818 234 1234', '+1-818-234-1234|1 818 234 1234|818 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (107, 10, '820', '(?:\+?1[ -]?)?820[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?820[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1820-234-1234 or 1820 234 1234 or 820-234-1234.', 'Only +digits or local formats allowed i.e. +1820-234-1234 or 1820 234 1234 or 820-234-1234.', '+1-820-234-1234|1 820 234 1234|820 234 1234', '+1-820-234-1234|1 820 234 1234|820 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (108, 10, '831', '(?:\+?1[ -]?)?831[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?831[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1831-234-1234 or 1831 234 1234 or 831-234-1234.', 'Only +digits or local formats allowed i.e. +1831-234-1234 or 1831 234 1234 or 831-234-1234.', '+1-831-234-1234|1 831 234 1234|831 234 1234', '+1-831-234-1234|1 831 234 1234|831 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (109, 10, '840', '(?:\+?1[ -]?)?840[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?840[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1840-234-1234 or 1840 234 1234 or 840-234-1234.', 'Only +digits or local formats allowed i.e. +1840-234-1234 or 1840 234 1234 or 840-234-1234.', '+1-840-234-1234|1 840 234 1234|840 234 1234', '+1-840-234-1234|1 840 234 1234|840 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (110, 10, '858', '(?:\+?1[ -]?)?858[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?858[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1858-234-1234 or 1858 234 1234 or 858-234-1234.', 'Only +digits or local formats allowed i.e. +1858-234-1234 or 1858 234 1234 or 858-234-1234.', '+1-858-234-1234|1 858 234 1234|858 234 1234', '+1-858-234-1234|1 858 234 1234|858 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (111, 10, '909', '(?:\+?1[ -]?)?909[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?909[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1909-234-1234 or 1909 234 1234 or 909-234-1234.', 'Only +digits or local formats allowed i.e. +1909-234-1234 or 1909 234 1234 or 909-234-1234.', '+1-909-234-1234|1 909 234 1234|909 234 1234', '+1-909-234-1234|1 909 234 1234|909 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (112, 10, '916', '(?:\+?1[ -]?)?916[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?916[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1916-234-1234 or 1916 234 1234 or 916-234-1234.', 'Only +digits or local formats allowed i.e. +1916-234-1234 or 1916 234 1234 or 916-234-1234.', '+1-916-234-1234|1 916 234 1234|916 234 1234', '+1-916-234-1234|1 916 234 1234|916 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (113, 10, '925', '(?:\+?1[ -]?)?925[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?925[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1925-234-1234 or 1925 234 1234 or 925-234-1234.', 'Only +digits or local formats allowed i.e. +1925-234-1234 or 1925 234 1234 or 925-234-1234.', '+1-925-234-1234|1 925 234 1234|925 234 1234', '+1-925-234-1234|1 925 234 1234|925 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (114, 10, '949', '(?:\+?1[ -]?)?949[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?949[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1949-234-1234 or 1949 234 1234 or 949-234-1234.', 'Only +digits or local formats allowed i.e. +1949-234-1234 or 1949 234 1234 or 949-234-1234.', '+1-949-234-1234|1 949 234 1234|949 234 1234', '+1-949-234-1234|1 949 234 1234|949 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (115, 10, '951', '(?:\+?1[ -]?)?951[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?951[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1951-234-1234 or 1951 234 1234 or 951-234-1234.', 'Only +digits or local formats allowed i.e. +1951-234-1234 or 1951 234 1234 or 951-234-1234.', '+1-951-234-1234|1 951 234 1234|951 234 1234', '+1-951-234-1234|1 951 234 1234|951 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (116, 10, '707', '(?:\+?1[ -]?)?707[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?707[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1707-234-1234 or 1707 234 1234 or 707-234-1234.', 'Only +digits or local formats allowed i.e. +1707-234-1234 or 1707 234 1234 or 707-234-1234.', '+1-707-234-1234|1 707 234 1234|707 234 1234', '+1-707-234-1234|1 707 234 1234|707 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (117, 10, '714', '(?:\+?1[ -]?)?714[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?714[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1714-234-1234 or 1714 234 1234 or 714-234-1234.', 'Only +digits or local formats allowed i.e. +1714-234-1234 or 1714 234 1234 or 714-234-1234.', '+1-714-234-1234|1 714 234 1234|714 234 1234', '+1-714-234-1234|1 714 234 1234|714 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (118, 10, '970', '(?:\+?1[ -]?)?970[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?970[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1970-234-1234 or 1970 234 1234 or 970-234-1234.', 'Only +digits or local formats allowed i.e. +1970-234-1234 or 1970 234 1234 or 970-234-1234.', '+1-970-234-1234|1 970 234 1234|970 234 1234', '+1-970-234-1234|1 970 234 1234|970 234 1234', 'Colorado');
INSERT INTO "public"."country_regions" VALUES (119, 10, '983', '(?:\+?1[ -]?)?983[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?983[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1983-234-1234 or 1983 234 1234 or 983-234-1234.', 'Only +digits or local formats allowed i.e. +1983-234-1234 or 1983 234 1234 or 983-234-1234.', '+1-983-234-1234|1 983 234 1234|983 234 1234', '+1-983-234-1234|1 983 234 1234|983 234 1234', 'Colorado');
INSERT INTO "public"."country_regions" VALUES (120, 10, '203', '(?:\+?1[ -]?)?203[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?203[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1203-234-1234 or 1203 234 1234 or 203-234-1234.', 'Only +digits or local formats allowed i.e. +1203-234-1234 or 1203 234 1234 or 203-234-1234.', '+1-203-234-1234|1 203 234 1234|203 234 1234', '+1-203-234-1234|1 203 234 1234|203 234 1234', 'Connecticut');
INSERT INTO "public"."country_regions" VALUES (121, 10, '475', '(?:\+?1[ -]?)?475[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?475[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1475-234-1234 or 1475 234 1234 or 475-234-1234.', 'Only +digits or local formats allowed i.e. +1475-234-1234 or 1475 234 1234 or 475-234-1234.', '+1-475-234-1234|1 475 234 1234|475 234 1234', '+1-475-234-1234|1 475 234 1234|475 234 1234', 'Connecticut');
INSERT INTO "public"."country_regions" VALUES (122, 10, '860', '(?:\+?1[ -]?)?860[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?860[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1860-234-1234 or 1860 234 1234 or 860-234-1234.', 'Only +digits or local formats allowed i.e. +1860-234-1234 or 1860 234 1234 or 860-234-1234.', '+1-860-234-1234|1 860 234 1234|860 234 1234', '+1-860-234-1234|1 860 234 1234|860 234 1234', 'Connecticut');
INSERT INTO "public"."country_regions" VALUES (123, 10, '959', '(?:\+?1[ -]?)?959[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?959[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1959-234-1234 or 1959 234 1234 or 959-234-1234.', 'Only +digits or local formats allowed i.e. +1959-234-1234 or 1959 234 1234 or 959-234-1234.', '+1-959-234-1234|1 959 234 1234|959 234 1234', '+1-959-234-1234|1 959 234 1234|959 234 1234', 'Connecticut');
INSERT INTO "public"."country_regions" VALUES (124, 10, '302', '(?:\+?1[ -]?)?302[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?302[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1302-234-1234 or 1302 234 1234 or 302-234-1234.', 'Only +digits or local formats allowed i.e. +1302-234-1234 or 1302 234 1234 or 302-234-1234.', '+1-302-234-1234|1 302 234 1234|302 234 1234', '+1-302-234-1234|1 302 234 1234|302 234 1234', 'Delaware');
INSERT INTO "public"."country_regions" VALUES (125, 10, '202', '(?:\+?1[ -]?)?202[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?202[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1202-234-1234 or 1202 234 1234 or 202-234-1234.', 'Only +digits or local formats allowed i.e. +1202-234-1234 or 1202 234 1234 or 202-234-1234.', '+1-202-234-1234|1 202 234 1234|202 234 1234', '+1-202-234-1234|1 202 234 1234|202 234 1234', 'District of Columbia');
INSERT INTO "public"."country_regions" VALUES (126, 10, '771', '(?:\+?1[ -]?)?771[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?771[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1771-234-1234 or 1771 234 1234 or 771-234-1234.', 'Only +digits or local formats allowed i.e. +1771-234-1234 or 1771 234 1234 or 771-234-1234.', '+1-771-234-1234|1 771 234 1234|771 234 1234', '+1-771-234-1234|1 771 234 1234|771 234 1234', 'District of Columbia');
INSERT INTO "public"."country_regions" VALUES (127, 10, '239', '(?:\+?1[ -]?)?239[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?239[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1239-234-1234 or 1239 234 1234 or 239-234-1234.', 'Only +digits or local formats allowed i.e. +1239-234-1234 or 1239 234 1234 or 239-234-1234.', '+1-239-234-1234|1 239 234 1234|239 234 1234', '+1-239-234-1234|1 239 234 1234|239 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (128, 10, '305', '(?:\+?1[ -]?)?305[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?305[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1305-234-1234 or 1305 234 1234 or 305-234-1234.', 'Only +digits or local formats allowed i.e. +1305-234-1234 or 1305 234 1234 or 305-234-1234.', '+1-305-234-1234|1 305 234 1234|305 234 1234', '+1-305-234-1234|1 305 234 1234|305 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (129, 10, '352', '(?:\+?1[ -]?)?352[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?352[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1352-234-1234 or 1352 234 1234 or 352-234-1234.', 'Only +digits or local formats allowed i.e. +1352-234-1234 or 1352 234 1234 or 352-234-1234.', '+1-352-234-1234|1 352 234 1234|352 234 1234', '+1-352-234-1234|1 352 234 1234|352 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (130, 10, '386', '(?:\+?1[ -]?)?386[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?386[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1386-234-1234 or 1386 234 1234 or 386-234-1234.', 'Only +digits or local formats allowed i.e. +1386-234-1234 or 1386 234 1234 or 386-234-1234.', '+1-386-234-1234|1 386 234 1234|386 234 1234', '+1-386-234-1234|1 386 234 1234|386 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (131, 10, '719', '(?:\+?1[ -]?)?719[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?719[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1719-234-1234 or 1719 234 1234 or 719-234-1234.', 'Only +digits or local formats allowed i.e. +1719-234-1234 or 1719 234 1234 or 719-234-1234.', '+1-719-234-1234|1 719 234 1234|719 234 1234', '+1-719-234-1234|1 719 234 1234|719 234 1234', 'Colorado');
INSERT INTO "public"."country_regions" VALUES (132, 10, '720', '(?:\+?1[ -]?)?720[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?720[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1720-234-1234 or 1720 234 1234 or 720-234-1234.', 'Only +digits or local formats allowed i.e. +1720-234-1234 or 1720 234 1234 or 720-234-1234.', '+1-720-234-1234|1 720 234 1234|720 234 1234', '+1-720-234-1234|1 720 234 1234|720 234 1234', 'Colorado');
INSERT INTO "public"."country_regions" VALUES (133, 10, '689', '(?:\+?1[ -]?)?689[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?689[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1689-234-1234 or 1689 234 1234 or 689-234-1234.', 'Only +digits or local formats allowed i.e. +1689-234-1234 or 1689 234 1234 or 689-234-1234.', '+1-689-234-1234|1 689 234 1234|689 234 1234', '+1-689-234-1234|1 689 234 1234|689 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (134, 10, '727', '(?:\+?1[ -]?)?727[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?727[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1727-234-1234 or 1727 234 1234 or 727-234-1234.', 'Only +digits or local formats allowed i.e. +1727-234-1234 or 1727 234 1234 or 727-234-1234.', '+1-727-234-1234|1 727 234 1234|727 234 1234', '+1-727-234-1234|1 727 234 1234|727 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (135, 10, '754', '(?:\+?1[ -]?)?754[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?754[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1754-234-1234 or 1754 234 1234 or 754-234-1234.', 'Only +digits or local formats allowed i.e. +1754-234-1234 or 1754 234 1234 or 754-234-1234.', '+1-754-234-1234|1 754 234 1234|754 234 1234', '+1-754-234-1234|1 754 234 1234|754 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (136, 10, '772', '(?:\+?1[ -]?)?772[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?772[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1772-234-1234 or 1772 234 1234 or 772-234-1234.', 'Only +digits or local formats allowed i.e. +1772-234-1234 or 1772 234 1234 or 772-234-1234.', '+1-772-234-1234|1 772 234 1234|772 234 1234', '+1-772-234-1234|1 772 234 1234|772 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (137, 10, '786', '(?:\+?1[ -]?)?786[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?786[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1786-234-1234 or 1786 234 1234 or 786-234-1234.', 'Only +digits or local formats allowed i.e. +1786-234-1234 or 1786 234 1234 or 786-234-1234.', '+1-786-234-1234|1 786 234 1234|786 234 1234', '+1-786-234-1234|1 786 234 1234|786 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (138, 10, '813', '(?:\+?1[ -]?)?813[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?813[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1813-234-1234 or 1813 234 1234 or 813-234-1234.', 'Only +digits or local formats allowed i.e. +1813-234-1234 or 1813 234 1234 or 813-234-1234.', '+1-813-234-1234|1 813 234 1234|813 234 1234', '+1-813-234-1234|1 813 234 1234|813 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (139, 10, '850', '(?:\+?1[ -]?)?850[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?850[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1850-234-1234 or 1850 234 1234 or 850-234-1234.', 'Only +digits or local formats allowed i.e. +1850-234-1234 or 1850 234 1234 or 850-234-1234.', '+1-850-234-1234|1 850 234 1234|850 234 1234', '+1-850-234-1234|1 850 234 1234|850 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (140, 10, '863', '(?:\+?1[ -]?)?863[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?863[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1863-234-1234 or 1863 234 1234 or 863-234-1234.', 'Only +digits or local formats allowed i.e. +1863-234-1234 or 1863 234 1234 or 863-234-1234.', '+1-863-234-1234|1 863 234 1234|863 234 1234', '+1-863-234-1234|1 863 234 1234|863 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (141, 10, '904', '(?:\+?1[ -]?)?904[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?904[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1904-234-1234 or 1904 234 1234 or 904-234-1234.', 'Only +digits or local formats allowed i.e. +1904-234-1234 or 1904 234 1234 or 904-234-1234.', '+1-904-234-1234|1 904 234 1234|904 234 1234', '+1-904-234-1234|1 904 234 1234|904 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (142, 10, '941', '(?:\+?1[ -]?)?941[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?941[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1941-234-1234 or 1941 234 1234 or 941-234-1234.', 'Only +digits or local formats allowed i.e. +1941-234-1234 or 1941 234 1234 or 941-234-1234.', '+1-941-234-1234|1 941 234 1234|941 234 1234', '+1-941-234-1234|1 941 234 1234|941 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (143, 10, '954', '(?:\+?1[ -]?)?954[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?954[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1954-234-1234 or 1954 234 1234 or 954-234-1234.', 'Only +digits or local formats allowed i.e. +1954-234-1234 or 1954 234 1234 or 954-234-1234.', '+1-954-234-1234|1 954 234 1234|954 234 1234', '+1-954-234-1234|1 954 234 1234|954 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (144, 10, '404', '(?:\+?1[ -]?)?404[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?404[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1404-234-1234 or 1404 234 1234 or 404-234-1234.', 'Only +digits or local formats allowed i.e. +1404-234-1234 or 1404 234 1234 or 404-234-1234.', '+1-404-234-1234|1 404 234 1234|404 234 1234', '+1-404-234-1234|1 404 234 1234|404 234 1234', 'Georgia');
INSERT INTO "public"."country_regions" VALUES (145, 10, '470', '(?:\+?1[ -]?)?470[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?470[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1470-234-1234 or 1470 234 1234 or 470-234-1234.', 'Only +digits or local formats allowed i.e. +1470-234-1234 or 1470 234 1234 or 470-234-1234.', '+1-470-234-1234|1 470 234 1234|470 234 1234', '+1-470-234-1234|1 470 234 1234|470 234 1234', 'Georgia');
INSERT INTO "public"."country_regions" VALUES (146, 10, '561', '(?:\+?1[ -]?)?561[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?561[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1561-234-1234 or 1561 234 1234 or 561-234-1234.', 'Only +digits or local formats allowed i.e. +1561-234-1234 or 1561 234 1234 or 561-234-1234.', '+1-561-234-1234|1 561 234 1234|561 234 1234', '+1-561-234-1234|1 561 234 1234|561 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (147, 10, '656', '(?:\+?1[ -]?)?656[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?656[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1656-234-1234 or 1656 234 1234 or 656-234-1234.', 'Only +digits or local formats allowed i.e. +1656-234-1234 or 1656 234 1234 or 656-234-1234.', '+1-656-234-1234|1 656 234 1234|656 234 1234', '+1-656-234-1234|1 656 234 1234|656 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (148, 10, '770', '(?:\+?1[ -]?)?770[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?770[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1770-234-1234 or 1770 234 1234 or 770-234-1234.', 'Only +digits or local formats allowed i.e. +1770-234-1234 or 1770 234 1234 or 770-234-1234.', '+1-770-234-1234|1 770 234 1234|770 234 1234', '+1-770-234-1234|1 770 234 1234|770 234 1234', 'Georgia');
INSERT INTO "public"."country_regions" VALUES (149, 10, '912', '(?:\+?1[ -]?)?912[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?912[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1912-234-1234 or 1912 234 1234 or 912-234-1234.', 'Only +digits or local formats allowed i.e. +1912-234-1234 or 1912 234 1234 or 912-234-1234.', '+1-912-234-1234|1 912 234 1234|912 234 1234', '+1-912-234-1234|1 912 234 1234|912 234 1234', 'Georgia');
INSERT INTO "public"."country_regions" VALUES (150, 10, '943', '(?:\+?1[ -]?)?943[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?943[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1943-234-1234 or 1943 234 1234 or 943-234-1234.', 'Only +digits or local formats allowed i.e. +1943-234-1234 or 1943 234 1234 or 943-234-1234.', '+1-943-234-1234|1 943 234 1234|943 234 1234', '+1-943-234-1234|1 943 234 1234|943 234 1234', 'Georgia');
INSERT INTO "public"."country_regions" VALUES (151, 10, '808', '(?:\+?1[ -]?)?808[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?808[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1808-234-1234 or 1808 234 1234 or 808-234-1234.', 'Only +digits or local formats allowed i.e. +1808-234-1234 or 1808 234 1234 or 808-234-1234.', '+1-808-234-1234|1 808 234 1234|808 234 1234', '+1-808-234-1234|1 808 234 1234|808 234 1234', 'Hawaii');
INSERT INTO "public"."country_regions" VALUES (152, 10, '208', '(?:\+?1[ -]?)?208[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?208[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1208-234-1234 or 1208 234 1234 or 208-234-1234.', 'Only +digits or local formats allowed i.e. +1208-234-1234 or 1208 234 1234 or 208-234-1234.', '+1-208-234-1234|1 208 234 1234|208 234 1234', '+1-208-234-1234|1 208 234 1234|208 234 1234', 'Idaho');
INSERT INTO "public"."country_regions" VALUES (153, 10, '986', '(?:\+?1[ -]?)?986[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?986[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1986-234-1234 or 1986 234 1234 or 986-234-1234.', 'Only +digits or local formats allowed i.e. +1986-234-1234 or 1986 234 1234 or 986-234-1234.', '+1-986-234-1234|1 986 234 1234|986 234 1234', '+1-986-234-1234|1 986 234 1234|986 234 1234', 'Idaho');
INSERT INTO "public"."country_regions" VALUES (154, 10, '217', '(?:\+?1[ -]?)?217[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?217[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1217-234-1234 or 1217 234 1234 or 217-234-1234.', 'Only +digits or local formats allowed i.e. +1217-234-1234 or 1217 234 1234 or 217-234-1234.', '+1-217-234-1234|1 217 234 1234|217 234 1234', '+1-217-234-1234|1 217 234 1234|217 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (155, 10, '224', '(?:\+?1[ -]?)?224[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?224[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1224-234-1234 or 1224 234 1234 or 224-234-1234.', 'Only +digits or local formats allowed i.e. +1224-234-1234 or 1224 234 1234 or 224-234-1234.', '+1-224-234-1234|1 224 234 1234|224 234 1234', '+1-224-234-1234|1 224 234 1234|224 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (156, 10, '309', '(?:\+?1[ -]?)?309[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?309[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1309-234-1234 or 1309 234 1234 or 309-234-1234.', 'Only +digits or local formats allowed i.e. +1309-234-1234 or 1309 234 1234 or 309-234-1234.', '+1-309-234-1234|1 309 234 1234|309 234 1234', '+1-309-234-1234|1 309 234 1234|309 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (157, 10, '312', '(?:\+?1[ -]?)?312[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?312[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1312-234-1234 or 1312 234 1234 or 312-234-1234.', 'Only +digits or local formats allowed i.e. +1312-234-1234 or 1312 234 1234 or 312-234-1234.', '+1-312-234-1234|1 312 234 1234|312 234 1234', '+1-312-234-1234|1 312 234 1234|312 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (158, 10, '331', '(?:\+?1[ -]?)?331[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?331[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1331-234-1234 or 1331 234 1234 or 331-234-1234.', 'Only +digits or local formats allowed i.e. +1331-234-1234 or 1331 234 1234 or 331-234-1234.', '+1-331-234-1234|1 331 234 1234|331 234 1234', '+1-331-234-1234|1 331 234 1234|331 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (159, 10, '464', '(?:\+?1[ -]?)?464[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?464[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1464-234-1234 or 1464 234 1234 or 464-234-1234.', 'Only +digits or local formats allowed i.e. +1464-234-1234 or 1464 234 1234 or 464-234-1234.', '+1-464-234-1234|1 464 234 1234|464 234 1234', '+1-464-234-1234|1 464 234 1234|464 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (160, 10, '618', '(?:\+?1[ -]?)?618[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?618[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1618-234-1234 or 1618 234 1234 or 618-234-1234.', 'Only +digits or local formats allowed i.e. +1618-234-1234 or 1618 234 1234 or 618-234-1234.', '+1-618-234-1234|1 618 234 1234|618 234 1234', '+1-618-234-1234|1 618 234 1234|618 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (161, 10, '706', '(?:\+?1[ -]?)?706[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?706[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1706-234-1234 or 1706 234 1234 or 706-234-1234.', 'Only +digits or local formats allowed i.e. +1706-234-1234 or 1706 234 1234 or 706-234-1234.', '+1-706-234-1234|1 706 234 1234|706 234 1234', '+1-706-234-1234|1 706 234 1234|706 234 1234', 'Georgia');
INSERT INTO "public"."country_regions" VALUES (162, 10, '762', '(?:\+?1[ -]?)?762[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?762[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1762-234-1234 or 1762 234 1234 or 762-234-1234.', 'Only +digits or local formats allowed i.e. +1762-234-1234 or 1762 234 1234 or 762-234-1234.', '+1-762-234-1234|1 762 234 1234|762 234 1234', '+1-762-234-1234|1 762 234 1234|762 234 1234', 'Georgia');
INSERT INTO "public"."country_regions" VALUES (163, 10, '779', '(?:\+?1[ -]?)?779[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?779[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1779-234-1234 or 1779 234 1234 or 779-234-1234.', 'Only +digits or local formats allowed i.e. +1779-234-1234 or 1779 234 1234 or 779-234-1234.', '+1-779-234-1234|1 779 234 1234|779 234 1234', '+1-779-234-1234|1 779 234 1234|779 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (164, 10, '815', '(?:\+?1[ -]?)?815[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?815[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1815-234-1234 or 1815 234 1234 or 815-234-1234.', 'Only +digits or local formats allowed i.e. +1815-234-1234 or 1815 234 1234 or 815-234-1234.', '+1-815-234-1234|1 815 234 1234|815 234 1234', '+1-815-234-1234|1 815 234 1234|815 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (165, 10, '847', '(?:\+?1[ -]?)?847[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?847[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1847-234-1234 or 1847 234 1234 or 847-234-1234.', 'Only +digits or local formats allowed i.e. +1847-234-1234 or 1847 234 1234 or 847-234-1234.', '+1-847-234-1234|1 847 234 1234|847 234 1234', '+1-847-234-1234|1 847 234 1234|847 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (166, 10, '872', '(?:\+?1[ -]?)?872[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?872[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1872-234-1234 or 1872 234 1234 or 872-234-1234.', 'Only +digits or local formats allowed i.e. +1872-234-1234 or 1872 234 1234 or 872-234-1234.', '+1-872-234-1234|1 872 234 1234|872 234 1234', '+1-872-234-1234|1 872 234 1234|872 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (167, 10, '219', '(?:\+?1[ -]?)?219[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?219[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1219-234-1234 or 1219 234 1234 or 219-234-1234.', 'Only +digits or local formats allowed i.e. +1219-234-1234 or 1219 234 1234 or 219-234-1234.', '+1-219-234-1234|1 219 234 1234|219 234 1234', '+1-219-234-1234|1 219 234 1234|219 234 1234', 'Indiana');
INSERT INTO "public"."country_regions" VALUES (168, 10, '260', '(?:\+?1[ -]?)?260[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?260[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1260-234-1234 or 1260 234 1234 or 260-234-1234.', 'Only +digits or local formats allowed i.e. +1260-234-1234 or 1260 234 1234 or 260-234-1234.', '+1-260-234-1234|1 260 234 1234|260 234 1234', '+1-260-234-1234|1 260 234 1234|260 234 1234', 'Indiana');
INSERT INTO "public"."country_regions" VALUES (169, 10, '317', '(?:\+?1[ -]?)?317[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?317[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1317-234-1234 or 1317 234 1234 or 317-234-1234.', 'Only +digits or local formats allowed i.e. +1317-234-1234 or 1317 234 1234 or 317-234-1234.', '+1-317-234-1234|1 317 234 1234|317 234 1234', '+1-317-234-1234|1 317 234 1234|317 234 1234', 'Indiana');
INSERT INTO "public"."country_regions" VALUES (170, 10, '463', '(?:\+?1[ -]?)?463[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?463[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1463-234-1234 or 1463 234 1234 or 463-234-1234.', 'Only +digits or local formats allowed i.e. +1463-234-1234 or 1463 234 1234 or 463-234-1234.', '+1-463-234-1234|1 463 234 1234|463 234 1234', '+1-463-234-1234|1 463 234 1234|463 234 1234', 'Indiana');
INSERT INTO "public"."country_regions" VALUES (171, 10, '574', '(?:\+?1[ -]?)?574[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?574[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1574-234-1234 or 1574 234 1234 or 574-234-1234.', 'Only +digits or local formats allowed i.e. +1574-234-1234 or 1574 234 1234 or 574-234-1234.', '+1-574-234-1234|1 574 234 1234|574 234 1234', '+1-574-234-1234|1 574 234 1234|574 234 1234', 'Indiana');
INSERT INTO "public"."country_regions" VALUES (172, 10, '765', '(?:\+?1[ -]?)?765[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?765[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1765-234-1234 or 1765 234 1234 or 765-234-1234.', 'Only +digits or local formats allowed i.e. +1765-234-1234 or 1765 234 1234 or 765-234-1234.', '+1-765-234-1234|1 765 234 1234|765 234 1234', '+1-765-234-1234|1 765 234 1234|765 234 1234', 'Indiana');
INSERT INTO "public"."country_regions" VALUES (173, 10, '812', '(?:\+?1[ -]?)?812[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?812[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1812-234-1234 or 1812 234 1234 or 812-234-1234.', 'Only +digits or local formats allowed i.e. +1812-234-1234 or 1812 234 1234 or 812-234-1234.', '+1-812-234-1234|1 812 234 1234|812 234 1234', '+1-812-234-1234|1 812 234 1234|812 234 1234', 'Indiana');
INSERT INTO "public"."country_regions" VALUES (174, 10, '319', '(?:\+?1[ -]?)?319[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?319[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1319-234-1234 or 1319 234 1234 or 319-234-1234.', 'Only +digits or local formats allowed i.e. +1319-234-1234 or 1319 234 1234 or 319-234-1234.', '+1-319-234-1234|1 319 234 1234|319 234 1234', '+1-319-234-1234|1 319 234 1234|319 234 1234', 'Iowa');
INSERT INTO "public"."country_regions" VALUES (175, 10, '515', '(?:\+?1[ -]?)?515[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?515[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1515-234-1234 or 1515 234 1234 or 515-234-1234.', 'Only +digits or local formats allowed i.e. +1515-234-1234 or 1515 234 1234 or 515-234-1234.', '+1-515-234-1234|1 515 234 1234|515 234 1234', '+1-515-234-1234|1 515 234 1234|515 234 1234', 'Iowa');
INSERT INTO "public"."country_regions" VALUES (176, 10, '730', '(?:\+?1[ -]?)?730[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?730[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1730-234-1234 or 1730 234 1234 or 730-234-1234.', 'Only +digits or local formats allowed i.e. +1730-234-1234 or 1730 234 1234 or 730-234-1234.', '+1-730-234-1234|1 730 234 1234|730 234 1234', '+1-730-234-1234|1 730 234 1234|730 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (177, 10, '773', '(?:\+?1[ -]?)?773[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?773[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1773-234-1234 or 1773 234 1234 or 773-234-1234.', 'Only +digits or local formats allowed i.e. +1773-234-1234 or 1773 234 1234 or 773-234-1234.', '+1-773-234-1234|1 773 234 1234|773 234 1234', '+1-773-234-1234|1 773 234 1234|773 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (178, 10, '712', '(?:\+?1[ -]?)?712[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?712[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1712-234-1234 or 1712 234 1234 or 712-234-1234.', 'Only +digits or local formats allowed i.e. +1712-234-1234 or 1712 234 1234 or 712-234-1234.', '+1-712-234-1234|1 712 234 1234|712 234 1234', '+1-712-234-1234|1 712 234 1234|712 234 1234', 'Iowa');
INSERT INTO "public"."country_regions" VALUES (179, 10, '316', '(?:\+?1[ -]?)?316[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?316[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1316-234-1234 or 1316 234 1234 or 316-234-1234.', 'Only +digits or local formats allowed i.e. +1316-234-1234 or 1316 234 1234 or 316-234-1234.', '+1-316-234-1234|1 316 234 1234|316 234 1234', '+1-316-234-1234|1 316 234 1234|316 234 1234', 'Kansas');
INSERT INTO "public"."country_regions" VALUES (180, 10, '620', '(?:\+?1[ -]?)?620[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?620[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1620-234-1234 or 1620 234 1234 or 620-234-1234.', 'Only +digits or local formats allowed i.e. +1620-234-1234 or 1620 234 1234 or 620-234-1234.', '+1-620-234-1234|1 620 234 1234|620 234 1234', '+1-620-234-1234|1 620 234 1234|620 234 1234', 'Kansas');
INSERT INTO "public"."country_regions" VALUES (181, 10, '785', '(?:\+?1[ -]?)?785[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?785[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1785-234-1234 or 1785 234 1234 or 785-234-1234.', 'Only +digits or local formats allowed i.e. +1785-234-1234 or 1785 234 1234 or 785-234-1234.', '+1-785-234-1234|1 785 234 1234|785 234 1234', '+1-785-234-1234|1 785 234 1234|785 234 1234', 'Kansas');
INSERT INTO "public"."country_regions" VALUES (182, 10, '913', '(?:\+?1[ -]?)?913[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?913[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1913-234-1234 or 1913 234 1234 or 913-234-1234.', 'Only +digits or local formats allowed i.e. +1913-234-1234 or 1913 234 1234 or 913-234-1234.', '+1-913-234-1234|1 913 234 1234|913 234 1234', '+1-913-234-1234|1 913 234 1234|913 234 1234', 'Kansas');
INSERT INTO "public"."country_regions" VALUES (183, 10, '270', '(?:\+?1[ -]?)?270[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?270[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1270-234-1234 or 1270 234 1234 or 270-234-1234.', 'Only +digits or local formats allowed i.e. +1270-234-1234 or 1270 234 1234 or 270-234-1234.', '+1-270-234-1234|1 270 234 1234|270 234 1234', '+1-270-234-1234|1 270 234 1234|270 234 1234', 'Kentucky');
INSERT INTO "public"."country_regions" VALUES (184, 10, '364', '(?:\+?1[ -]?)?364[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?364[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1364-234-1234 or 1364 234 1234 or 364-234-1234.', 'Only +digits or local formats allowed i.e. +1364-234-1234 or 1364 234 1234 or 364-234-1234.', '+1-364-234-1234|1 364 234 1234|364 234 1234', '+1-364-234-1234|1 364 234 1234|364 234 1234', 'Kentucky');
INSERT INTO "public"."country_regions" VALUES (185, 10, '502', '(?:\+?1[ -]?)?502[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?502[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1502-234-1234 or 1502 234 1234 or 502-234-1234.', 'Only +digits or local formats allowed i.e. +1502-234-1234 or 1502 234 1234 or 502-234-1234.', '+1-502-234-1234|1 502 234 1234|502 234 1234', '+1-502-234-1234|1 502 234 1234|502 234 1234', 'Kentucky');
INSERT INTO "public"."country_regions" VALUES (186, 10, '859', '(?:\+?1[ -]?)?859[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?859[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1859-234-1234 or 1859 234 1234 or 859-234-1234.', 'Only +digits or local formats allowed i.e. +1859-234-1234 or 1859 234 1234 or 859-234-1234.', '+1-859-234-1234|1 859 234 1234|859 234 1234', '+1-859-234-1234|1 859 234 1234|859 234 1234', 'Kentucky');
INSERT INTO "public"."country_regions" VALUES (187, 10, '318', '(?:\+?1[ -]?)?318[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?318[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1318-234-1234 or 1318 234 1234 or 318-234-1234.', 'Only +digits or local formats allowed i.e. +1318-234-1234 or 1318 234 1234 or 318-234-1234.', '+1-318-234-1234|1 318 234 1234|318 234 1234', '+1-318-234-1234|1 318 234 1234|318 234 1234', 'Louisiana');
INSERT INTO "public"."country_regions" VALUES (188, 10, '337', '(?:\+?1[ -]?)?337[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?337[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1337-234-1234 or 1337 234 1234 or 337-234-1234.', 'Only +digits or local formats allowed i.e. +1337-234-1234 or 1337 234 1234 or 337-234-1234.', '+1-337-234-1234|1 337 234 1234|337 234 1234', '+1-337-234-1234|1 337 234 1234|337 234 1234', 'Louisiana');
INSERT INTO "public"."country_regions" VALUES (189, 10, '504', '(?:\+?1[ -]?)?504[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?504[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1504-234-1234 or 1504 234 1234 or 504-234-1234.', 'Only +digits or local formats allowed i.e. +1504-234-1234 or 1504 234 1234 or 504-234-1234.', '+1-504-234-1234|1 504 234 1234|504 234 1234', '+1-504-234-1234|1 504 234 1234|504 234 1234', 'Louisiana');
INSERT INTO "public"."country_regions" VALUES (190, 10, '985', '(?:\+?1[ -]?)?985[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?985[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1985-234-1234 or 1985 234 1234 or 985-234-1234.', 'Only +digits or local formats allowed i.e. +1985-234-1234 or 1985 234 1234 or 985-234-1234.', '+1-985-234-1234|1 985 234 1234|985 234 1234', '+1-985-234-1234|1 985 234 1234|985 234 1234', 'Louisiana');
INSERT INTO "public"."country_regions" VALUES (191, 10, '563', '(?:\+?1[ -]?)?563[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?563[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1563-234-1234 or 1563 234 1234 or 563-234-1234.', 'Only +digits or local formats allowed i.e. +1563-234-1234 or 1563 234 1234 or 563-234-1234.', '+1-563-234-1234|1 563 234 1234|563 234 1234', '+1-563-234-1234|1 563 234 1234|563 234 1234', 'Iowa');
INSERT INTO "public"."country_regions" VALUES (192, 10, '641', '(?:\+?1[ -]?)?641[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?641[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1641-234-1234 or 1641 234 1234 or 641-234-1234.', 'Only +digits or local formats allowed i.e. +1641-234-1234 or 1641 234 1234 or 641-234-1234.', '+1-641-234-1234|1 641 234 1234|641 234 1234', '+1-641-234-1234|1 641 234 1234|641 234 1234', 'Iowa');
INSERT INTO "public"."country_regions" VALUES (193, 10, '240', '(?:\+?1[ -]?)?240[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?240[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1240-234-1234 or 1240 234 1234 or 240-234-1234.', 'Only +digits or local formats allowed i.e. +1240-234-1234 or 1240 234 1234 or 240-234-1234.', '+1-240-234-1234|1 240 234 1234|240 234 1234', '+1-240-234-1234|1 240 234 1234|240 234 1234', 'Maryland');
INSERT INTO "public"."country_regions" VALUES (194, 10, '301', '(?:\+?1[ -]?)?301[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?301[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1301-234-1234 or 1301 234 1234 or 301-234-1234.', 'Only +digits or local formats allowed i.e. +1301-234-1234 or 1301 234 1234 or 301-234-1234.', '+1-301-234-1234|1 301 234 1234|301 234 1234', '+1-301-234-1234|1 301 234 1234|301 234 1234', 'Maryland');
INSERT INTO "public"."country_regions" VALUES (195, 10, '410', '(?:\+?1[ -]?)?410[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?410[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1410-234-1234 or 1410 234 1234 or 410-234-1234.', 'Only +digits or local formats allowed i.e. +1410-234-1234 or 1410 234 1234 or 410-234-1234.', '+1-410-234-1234|1 410 234 1234|410 234 1234', '+1-410-234-1234|1 410 234 1234|410 234 1234', 'Maryland');
INSERT INTO "public"."country_regions" VALUES (196, 10, '443', '(?:\+?1[ -]?)?443[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?443[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1443-234-1234 or 1443 234 1234 or 443-234-1234.', 'Only +digits or local formats allowed i.e. +1443-234-1234 or 1443 234 1234 or 443-234-1234.', '+1-443-234-1234|1 443 234 1234|443 234 1234', '+1-443-234-1234|1 443 234 1234|443 234 1234', 'Maryland');
INSERT INTO "public"."country_regions" VALUES (197, 10, '667', '(?:\+?1[ -]?)?667[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?667[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1667-234-1234 or 1667 234 1234 or 667-234-1234.', 'Only +digits or local formats allowed i.e. +1667-234-1234 or 1667 234 1234 or 667-234-1234.', '+1-667-234-1234|1 667 234 1234|667 234 1234', '+1-667-234-1234|1 667 234 1234|667 234 1234', 'Maryland');
INSERT INTO "public"."country_regions" VALUES (198, 10, '339', '(?:\+?1[ -]?)?339[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?339[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1339-234-1234 or 1339 234 1234 or 339-234-1234.', 'Only +digits or local formats allowed i.e. +1339-234-1234 or 1339 234 1234 or 339-234-1234.', '+1-339-234-1234|1 339 234 1234|339 234 1234', '+1-339-234-1234|1 339 234 1234|339 234 1234', 'Massachusetts');
INSERT INTO "public"."country_regions" VALUES (199, 10, '351', '(?:\+?1[ -]?)?351[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?351[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1351-234-1234 or 1351 234 1234 or 351-234-1234.', 'Only +digits or local formats allowed i.e. +1351-234-1234 or 1351 234 1234 or 351-234-1234.', '+1-351-234-1234|1 351 234 1234|351 234 1234', '+1-351-234-1234|1 351 234 1234|351 234 1234', 'Massachusetts');
INSERT INTO "public"."country_regions" VALUES (200, 10, '413', '(?:\+?1[ -]?)?413[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?413[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1413-234-1234 or 1413 234 1234 or 413-234-1234.', 'Only +digits or local formats allowed i.e. +1413-234-1234 or 1413 234 1234 or 413-234-1234.', '+1-413-234-1234|1 413 234 1234|413 234 1234', '+1-413-234-1234|1 413 234 1234|413 234 1234', 'Massachusetts');
INSERT INTO "public"."country_regions" VALUES (201, 10, '508', '(?:\+?1[ -]?)?508[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?508[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1508-234-1234 or 1508 234 1234 or 508-234-1234.', 'Only +digits or local formats allowed i.e. +1508-234-1234 or 1508 234 1234 or 508-234-1234.', '+1-508-234-1234|1 508 234 1234|508 234 1234', '+1-508-234-1234|1 508 234 1234|508 234 1234', 'Massachusetts');
INSERT INTO "public"."country_regions" VALUES (202, 10, '774', '(?:\+?1[ -]?)?774[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?774[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1774-234-1234 or 1774 234 1234 or 774-234-1234.', 'Only +digits or local formats allowed i.e. +1774-234-1234 or 1774 234 1234 or 774-234-1234.', '+1-774-234-1234|1 774 234 1234|774 234 1234', '+1-774-234-1234|1 774 234 1234|774 234 1234', 'Massachusetts');
INSERT INTO "public"."country_regions" VALUES (203, 10, '781', '(?:\+?1[ -]?)?781[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?781[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1781-234-1234 or 1781 234 1234 or 781-234-1234.', 'Only +digits or local formats allowed i.e. +1781-234-1234 or 1781 234 1234 or 781-234-1234.', '+1-781-234-1234|1 781 234 1234|781 234 1234', '+1-781-234-1234|1 781 234 1234|781 234 1234', 'Massachusetts');
INSERT INTO "public"."country_regions" VALUES (204, 10, '857', '(?:\+?1[ -]?)?857[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?857[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1857-234-1234 or 1857 234 1234 or 857-234-1234.', 'Only +digits or local formats allowed i.e. +1857-234-1234 or 1857 234 1234 or 857-234-1234.', '+1-857-234-1234|1 857 234 1234|857 234 1234', '+1-857-234-1234|1 857 234 1234|857 234 1234', 'Massachusetts');
INSERT INTO "public"."country_regions" VALUES (205, 10, '978', '(?:\+?1[ -]?)?978[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?978[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1978-234-1234 or 1978 234 1234 or 978-234-1234.', 'Only +digits or local formats allowed i.e. +1978-234-1234 or 1978 234 1234 or 978-234-1234.', '+1-978-234-1234|1 978 234 1234|978 234 1234', '+1-978-234-1234|1 978 234 1234|978 234 1234', 'Massachusetts');
INSERT INTO "public"."country_regions" VALUES (206, 10, '207', '(?:\+?1[ -]?)?207[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?207[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1207-234-1234 or 1207 234 1234 or 207-234-1234.', 'Only +digits or local formats allowed i.e. +1207-234-1234 or 1207 234 1234 or 207-234-1234.', '+1-207-234-1234|1 207 234 1234|207 234 1234', '+1-207-234-1234|1 207 234 1234|207 234 1234', 'Maine');
INSERT INTO "public"."country_regions" VALUES (207, 10, '227', '(?:\+?1[ -]?)?227[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?227[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1227-234-1234 or 1227 234 1234 or 227-234-1234.', 'Only +digits or local formats allowed i.e. +1227-234-1234 or 1227 234 1234 or 227-234-1234.', '+1-227-234-1234|1 227 234 1234|227 234 1234', '+1-227-234-1234|1 227 234 1234|227 234 1234', 'Maryland');
INSERT INTO "public"."country_regions" VALUES (208, 10, '517', '(?:\+?1[ -]?)?517[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?517[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1517-234-1234 or 1517 234 1234 or 517-234-1234.', 'Only +digits or local formats allowed i.e. +1517-234-1234 or 1517 234 1234 or 517-234-1234.', '+1-517-234-1234|1 517 234 1234|517 234 1234', '+1-517-234-1234|1 517 234 1234|517 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (209, 10, '586', '(?:\+?1[ -]?)?586[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?586[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1586-234-1234 or 1586 234 1234 or 586-234-1234.', 'Only +digits or local formats allowed i.e. +1586-234-1234 or 1586 234 1234 or 586-234-1234.', '+1-586-234-1234|1 586 234 1234|586 234 1234', '+1-586-234-1234|1 586 234 1234|586 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (210, 10, '616', '(?:\+?1[ -]?)?616[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?616[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1616-234-1234 or 1616 234 1234 or 616-234-1234.', 'Only +digits or local formats allowed i.e. +1616-234-1234 or 1616 234 1234 or 616-234-1234.', '+1-616-234-1234|1 616 234 1234|616 234 1234', '+1-616-234-1234|1 616 234 1234|616 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (211, 10, '679', '(?:\+?1[ -]?)?679[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?679[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1679-234-1234 or 1679 234 1234 or 679-234-1234.', 'Only +digits or local formats allowed i.e. +1679-234-1234 or 1679 234 1234 or 679-234-1234.', '+1-679-234-1234|1 679 234 1234|679 234 1234', '+1-679-234-1234|1 679 234 1234|679 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (212, 10, '734', '(?:\+?1[ -]?)?734[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?734[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1734-234-1234 or 1734 234 1234 or 734-234-1234.', 'Only +digits or local formats allowed i.e. +1734-234-1234 or 1734 234 1234 or 734-234-1234.', '+1-734-234-1234|1 734 234 1234|734 234 1234', '+1-734-234-1234|1 734 234 1234|734 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (213, 10, '810', '(?:\+?1[ -]?)?810[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?810[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1810-234-1234 or 1810 234 1234 or 810-234-1234.', 'Only +digits or local formats allowed i.e. +1810-234-1234 or 1810 234 1234 or 810-234-1234.', '+1-810-234-1234|1 810 234 1234|810 234 1234', '+1-810-234-1234|1 810 234 1234|810 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (214, 10, '906', '(?:\+?1[ -]?)?906[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?906[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1906-234-1234 or 1906 234 1234 or 906-234-1234.', 'Only +digits or local formats allowed i.e. +1906-234-1234 or 1906 234 1234 or 906-234-1234.', '+1-906-234-1234|1 906 234 1234|906 234 1234', '+1-906-234-1234|1 906 234 1234|906 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (215, 10, '947', '(?:\+?1[ -]?)?947[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?947[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1947-234-1234 or 1947 234 1234 or 947-234-1234.', 'Only +digits or local formats allowed i.e. +1947-234-1234 or 1947 234 1234 or 947-234-1234.', '+1-947-234-1234|1 947 234 1234|947 234 1234', '+1-947-234-1234|1 947 234 1234|947 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (216, 10, '989', '(?:\+?1[ -]?)?989[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?989[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1989-234-1234 or 1989 234 1234 or 989-234-1234.', 'Only +digits or local formats allowed i.e. +1989-234-1234 or 1989 234 1234 or 989-234-1234.', '+1-989-234-1234|1 989 234 1234|989 234 1234', '+1-989-234-1234|1 989 234 1234|989 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (217, 10, '218', '(?:\+?1[ -]?)?218[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?218[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1218-234-1234 or 1218 234 1234 or 218-234-1234.', 'Only +digits or local formats allowed i.e. +1218-234-1234 or 1218 234 1234 or 218-234-1234.', '+1-218-234-1234|1 218 234 1234|218 234 1234', '+1-218-234-1234|1 218 234 1234|218 234 1234', 'Minnesota');
INSERT INTO "public"."country_regions" VALUES (218, 10, '507', '(?:\+?1[ -]?)?507[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?507[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1507-234-1234 or 1507 234 1234 or 507-234-1234.', 'Only +digits or local formats allowed i.e. +1507-234-1234 or 1507 234 1234 or 507-234-1234.', '+1-507-234-1234|1 507 234 1234|507 234 1234', '+1-507-234-1234|1 507 234 1234|507 234 1234', 'Minnesota');
INSERT INTO "public"."country_regions" VALUES (219, 10, '612', '(?:\+?1[ -]?)?612[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?612[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1612-234-1234 or 1612 234 1234 or 612-234-1234.', 'Only +digits or local formats allowed i.e. +1612-234-1234 or 1612 234 1234 or 612-234-1234.', '+1-612-234-1234|1 612 234 1234|612 234 1234', '+1-612-234-1234|1 612 234 1234|612 234 1234', 'Minnesota');
INSERT INTO "public"."country_regions" VALUES (220, 10, '402', '(?:\+?1[ -]?)?402[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?402[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1402-234-1234 or 1402 234 1234 or 402-234-1234.', 'Only +digits or local formats allowed i.e. +1402-234-1234 or 1402 234 1234 or 402-234-1234.', '+1-402-234-1234|1 402 234 1234|402 234 1234', '+1-402-234-1234|1 402 234 1234|402 234 1234', 'Nebraska');
INSERT INTO "public"."country_regions" VALUES (221, 10, '269', '(?:\+?1[ -]?)?269[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?269[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1269-234-1234 or 1269 234 1234 or 269-234-1234.', 'Only +digits or local formats allowed i.e. +1269-234-1234 or 1269 234 1234 or 269-234-1234.', '+1-269-234-1234|1 269 234 1234|269 234 1234', '+1-269-234-1234|1 269 234 1234|269 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (222, 10, '313', '(?:\+?1[ -]?)?313[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?313[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1313-234-1234 or 1313 234 1234 or 313-234-1234.', 'Only +digits or local formats allowed i.e. +1313-234-1234 or 1313 234 1234 or 313-234-1234.', '+1-313-234-1234|1 313 234 1234|313 234 1234', '+1-313-234-1234|1 313 234 1234|313 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (223, 10, '228', '(?:\+?1[ -]?)?228[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?228[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1228-234-1234 or 1228 234 1234 or 228-234-1234.', 'Only +digits or local formats allowed i.e. +1228-234-1234 or 1228 234 1234 or 228-234-1234.', '+1-228-234-1234|1 228 234 1234|228 234 1234', '+1-228-234-1234|1 228 234 1234|228 234 1234', 'Mississippi');
INSERT INTO "public"."country_regions" VALUES (224, 10, '601', '(?:\+?1[ -]?)?601[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?601[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1601-234-1234 or 1601 234 1234 or 601-234-1234.', 'Only +digits or local formats allowed i.e. +1601-234-1234 or 1601 234 1234 or 601-234-1234.', '+1-601-234-1234|1 601 234 1234|601 234 1234', '+1-601-234-1234|1 601 234 1234|601 234 1234', 'Mississippi');
INSERT INTO "public"."country_regions" VALUES (225, 10, '662', '(?:\+?1[ -]?)?662[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?662[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1662-234-1234 or 1662 234 1234 or 662-234-1234.', 'Only +digits or local formats allowed i.e. +1662-234-1234 or 1662 234 1234 or 662-234-1234.', '+1-662-234-1234|1 662 234 1234|662 234 1234', '+1-662-234-1234|1 662 234 1234|662 234 1234', 'Mississippi');
INSERT INTO "public"."country_regions" VALUES (226, 10, '769', '(?:\+?1[ -]?)?769[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?769[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1769-234-1234 or 1769 234 1234 or 769-234-1234.', 'Only +digits or local formats allowed i.e. +1769-234-1234 or 1769 234 1234 or 769-234-1234.', '+1-769-234-1234|1 769 234 1234|769 234 1234', '+1-769-234-1234|1 769 234 1234|769 234 1234', 'Mississippi');
INSERT INTO "public"."country_regions" VALUES (227, 10, '314', '(?:\+?1[ -]?)?314[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?314[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1314-234-1234 or 1314 234 1234 or 314-234-1234.', 'Only +digits or local formats allowed i.e. +1314-234-1234 or 1314 234 1234 or 314-234-1234.', '+1-314-234-1234|1 314 234 1234|314 234 1234', '+1-314-234-1234|1 314 234 1234|314 234 1234', 'Missouri');
INSERT INTO "public"."country_regions" VALUES (228, 10, '417', '(?:\+?1[ -]?)?417[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?417[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1417-234-1234 or 1417 234 1234 or 417-234-1234.', 'Only +digits or local formats allowed i.e. +1417-234-1234 or 1417 234 1234 or 417-234-1234.', '+1-417-234-1234|1 417 234 1234|417 234 1234', '+1-417-234-1234|1 417 234 1234|417 234 1234', 'Missouri');
INSERT INTO "public"."country_regions" VALUES (229, 10, '557', '(?:\+?1[ -]?)?557[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?557[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1557-234-1234 or 1557 234 1234 or 557-234-1234.', 'Only +digits or local formats allowed i.e. +1557-234-1234 or 1557 234 1234 or 557-234-1234.', '+1-557-234-1234|1 557 234 1234|557 234 1234', '+1-557-234-1234|1 557 234 1234|557 234 1234', 'Missouri');
INSERT INTO "public"."country_regions" VALUES (230, 10, '573', '(?:\+?1[ -]?)?573[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?573[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1573-234-1234 or 1573 234 1234 or 573-234-1234.', 'Only +digits or local formats allowed i.e. +1573-234-1234 or 1573 234 1234 or 573-234-1234.', '+1-573-234-1234|1 573 234 1234|573 234 1234', '+1-573-234-1234|1 573 234 1234|573 234 1234', 'Missouri');
INSERT INTO "public"."country_regions" VALUES (231, 10, '636', '(?:\+?1[ -]?)?636[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?636[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1636-234-1234 or 1636 234 1234 or 636-234-1234.', 'Only +digits or local formats allowed i.e. +1636-234-1234 or 1636 234 1234 or 636-234-1234.', '+1-636-234-1234|1 636 234 1234|636 234 1234', '+1-636-234-1234|1 636 234 1234|636 234 1234', 'Missouri');
INSERT INTO "public"."country_regions" VALUES (232, 10, '660', '(?:\+?1[ -]?)?660[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?660[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1660-234-1234 or 1660 234 1234 or 660-234-1234.', 'Only +digits or local formats allowed i.e. +1660-234-1234 or 1660 234 1234 or 660-234-1234.', '+1-660-234-1234|1 660 234 1234|660 234 1234', '+1-660-234-1234|1 660 234 1234|660 234 1234', 'Missouri');
INSERT INTO "public"."country_regions" VALUES (233, 10, '816', '(?:\+?1[ -]?)?816[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?816[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1816-234-1234 or 1816 234 1234 or 816-234-1234.', 'Only +digits or local formats allowed i.e. +1816-234-1234 or 1816 234 1234 or 816-234-1234.', '+1-816-234-1234|1 816 234 1234|816 234 1234', '+1-816-234-1234|1 816 234 1234|816 234 1234', 'Missouri');
INSERT INTO "public"."country_regions" VALUES (234, 10, '406', '(?:\+?1[ -]?)?406[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?406[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1406-234-1234 or 1406 234 1234 or 406-234-1234.', 'Only +digits or local formats allowed i.e. +1406-234-1234 or 1406 234 1234 or 406-234-1234.', '+1-406-234-1234|1 406 234 1234|406 234 1234', '+1-406-234-1234|1 406 234 1234|406 234 1234', 'Montana');
INSERT INTO "public"."country_regions" VALUES (235, 10, '308', '(?:\+?1[ -]?)?308[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?308[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1308-234-1234 or 1308 234 1234 or 308-234-1234.', 'Only +digits or local formats allowed i.e. +1308-234-1234 or 1308 234 1234 or 308-234-1234.', '+1-308-234-1234|1 308 234 1234|308 234 1234', '+1-308-234-1234|1 308 234 1234|308 234 1234', 'Nebraska');
INSERT INTO "public"."country_regions" VALUES (236, 10, '763', '(?:\+?1[ -]?)?763[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?763[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1763-234-1234 or 1763 234 1234 or 763-234-1234.', 'Only +digits or local formats allowed i.e. +1763-234-1234 or 1763 234 1234 or 763-234-1234.', '+1-763-234-1234|1 763 234 1234|763 234 1234', '+1-763-234-1234|1 763 234 1234|763 234 1234', 'Minnesota');
INSERT INTO "public"."country_regions" VALUES (237, 10, '952', '(?:\+?1[ -]?)?952[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?952[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1952-234-1234 or 1952 234 1234 or 952-234-1234.', 'Only +digits or local formats allowed i.e. +1952-234-1234 or 1952 234 1234 or 952-234-1234.', '+1-952-234-1234|1 952 234 1234|952 234 1234', '+1-952-234-1234|1 952 234 1234|952 234 1234', 'Minnesota');
INSERT INTO "public"."country_regions" VALUES (238, 10, '775', '(?:\+?1[ -]?)?775[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?775[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1775-234-1234 or 1775 234 1234 or 775-234-1234.', 'Only +digits or local formats allowed i.e. +1775-234-1234 or 1775 234 1234 or 775-234-1234.', '+1-775-234-1234|1 775 234 1234|775 234 1234', '+1-775-234-1234|1 775 234 1234|775 234 1234', 'Nevada');
INSERT INTO "public"."country_regions" VALUES (239, 10, '603', '(?:\+?1[ -]?)?603[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?603[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1603-234-1234 or 1603 234 1234 or 603-234-1234.', 'Only +digits or local formats allowed i.e. +1603-234-1234 or 1603 234 1234 or 603-234-1234.', '+1-603-234-1234|1 603 234 1234|603 234 1234', '+1-603-234-1234|1 603 234 1234|603 234 1234', 'New Hampshire');
INSERT INTO "public"."country_regions" VALUES (240, 10, '201', '(?:\+?1[ -]?)?201[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?201[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1201-234-1234 or 1201 234 1234 or 201-234-1234.', 'Only +digits or local formats allowed i.e. +1201-234-1234 or 1201 234 1234 or 201-234-1234.', '+1-201-234-1234|1 201 234 1234|201 234 1234', '+1-201-234-1234|1 201 234 1234|201 234 1234', 'New Jersey');
INSERT INTO "public"."country_regions" VALUES (241, 10, '551', '(?:\+?1[ -]?)?551[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?551[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1551-234-1234 or 1551 234 1234 or 551-234-1234.', 'Only +digits or local formats allowed i.e. +1551-234-1234 or 1551 234 1234 or 551-234-1234.', '+1-551-234-1234|1 551 234 1234|551 234 1234', '+1-551-234-1234|1 551 234 1234|551 234 1234', 'New Jersey');
INSERT INTO "public"."country_regions" VALUES (242, 10, '609', '(?:\+?1[ -]?)?609[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?609[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1609-234-1234 or 1609 234 1234 or 609-234-1234.', 'Only +digits or local formats allowed i.e. +1609-234-1234 or 1609 234 1234 or 609-234-1234.', '+1-609-234-1234|1 609 234 1234|609 234 1234', '+1-609-234-1234|1 609 234 1234|609 234 1234', 'New Jersey');
INSERT INTO "public"."country_regions" VALUES (243, 10, '640', '(?:\+?1[ -]?)?640[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?640[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1640-234-1234 or 1640 234 1234 or 640-234-1234.', 'Only +digits or local formats allowed i.e. +1640-234-1234 or 1640 234 1234 or 640-234-1234.', '+1-640-234-1234|1 640 234 1234|640 234 1234', '+1-640-234-1234|1 640 234 1234|640 234 1234', 'New Jersey');
INSERT INTO "public"."country_regions" VALUES (244, 10, '732', '(?:\+?1[ -]?)?732[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?732[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1732-234-1234 or 1732 234 1234 or 732-234-1234.', 'Only +digits or local formats allowed i.e. +1732-234-1234 or 1732 234 1234 or 732-234-1234.', '+1-732-234-1234|1 732 234 1234|732 234 1234', '+1-732-234-1234|1 732 234 1234|732 234 1234', 'New Jersey');
INSERT INTO "public"."country_regions" VALUES (245, 10, '848', '(?:\+?1[ -]?)?848[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?848[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1848-234-1234 or 1848 234 1234 or 848-234-1234.', 'Only +digits or local formats allowed i.e. +1848-234-1234 or 1848 234 1234 or 848-234-1234.', '+1-848-234-1234|1 848 234 1234|848 234 1234', '+1-848-234-1234|1 848 234 1234|848 234 1234', 'New Jersey');
INSERT INTO "public"."country_regions" VALUES (246, 10, '856', '(?:\+?1[ -]?)?856[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?856[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1856-234-1234 or 1856 234 1234 or 856-234-1234.', 'Only +digits or local formats allowed i.e. +1856-234-1234 or 1856 234 1234 or 856-234-1234.', '+1-856-234-1234|1 856 234 1234|856 234 1234', '+1-856-234-1234|1 856 234 1234|856 234 1234', 'New Jersey');
INSERT INTO "public"."country_regions" VALUES (247, 10, '862', '(?:\+?1[ -]?)?862[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?862[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1862-234-1234 or 1862 234 1234 or 862-234-1234.', 'Only +digits or local formats allowed i.e. +1862-234-1234 or 1862 234 1234 or 862-234-1234.', '+1-862-234-1234|1 862 234 1234|862 234 1234', '+1-862-234-1234|1 862 234 1234|862 234 1234', 'New Jersey');
INSERT INTO "public"."country_regions" VALUES (248, 10, '973', '(?:\+?1[ -]?)?973[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?973[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1973-234-1234 or 1973 234 1234 or 973-234-1234.', 'Only +digits or local formats allowed i.e. +1973-234-1234 or 1973 234 1234 or 973-234-1234.', '+1-973-234-1234|1 973 234 1234|973 234 1234', '+1-973-234-1234|1 973 234 1234|973 234 1234', 'New Jersey');
INSERT INTO "public"."country_regions" VALUES (249, 10, '505', '(?:\+?1[ -]?)?505[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?505[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1505-234-1234 or 1505 234 1234 or 505-234-1234.', 'Only +digits or local formats allowed i.e. +1505-234-1234 or 1505 234 1234 or 505-234-1234.', '+1-505-234-1234|1 505 234 1234|505 234 1234', '+1-505-234-1234|1 505 234 1234|505 234 1234', 'New Mexico');
INSERT INTO "public"."country_regions" VALUES (250, 10, '575', '(?:\+?1[ -]?)?575[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?575[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1575-234-1234 or 1575 234 1234 or 575-234-1234.', 'Only +digits or local formats allowed i.e. +1575-234-1234 or 1575 234 1234 or 575-234-1234.', '+1-575-234-1234|1 575 234 1234|575 234 1234', '+1-575-234-1234|1 575 234 1234|575 234 1234', 'New Mexico');
INSERT INTO "public"."country_regions" VALUES (251, 10, '702', '(?:\+?1[ -]?)?702[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?702[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1702-234-1234 or 1702 234 1234 or 702-234-1234.', 'Only +digits or local formats allowed i.e. +1702-234-1234 or 1702 234 1234 or 702-234-1234.', '+1-702-234-1234|1 702 234 1234|702 234 1234', '+1-702-234-1234|1 702 234 1234|702 234 1234', 'Nevada');
INSERT INTO "public"."country_regions" VALUES (252, 10, '725', '(?:\+?1[ -]?)?725[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?725[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1725-234-1234 or 1725 234 1234 or 725-234-1234.', 'Only +digits or local formats allowed i.e. +1725-234-1234 or 1725 234 1234 or 725-234-1234.', '+1-725-234-1234|1 725 234 1234|725 234 1234', '+1-725-234-1234|1 725 234 1234|725 234 1234', 'Nevada');
INSERT INTO "public"."country_regions" VALUES (253, 10, '363', '(?:\+?1[ -]?)?363[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?363[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1363-234-1234 or 1363 234 1234 or 363-234-1234.', 'Only +digits or local formats allowed i.e. +1363-234-1234 or 1363 234 1234 or 363-234-1234.', '+1-363-234-1234|1 363 234 1234|363 234 1234', '+1-363-234-1234|1 363 234 1234|363 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (254, 10, '516', '(?:\+?1[ -]?)?516[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?516[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1516-234-1234 or 1516 234 1234 or 516-234-1234.', 'Only +digits or local formats allowed i.e. +1516-234-1234 or 1516 234 1234 or 516-234-1234.', '+1-516-234-1234|1 516 234 1234|516 234 1234', '+1-516-234-1234|1 516 234 1234|516 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (255, 10, '518', '(?:\+?1[ -]?)?518[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?518[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1518-234-1234 or 1518 234 1234 or 518-234-1234.', 'Only +digits or local formats allowed i.e. +1518-234-1234 or 1518 234 1234 or 518-234-1234.', '+1-518-234-1234|1 518 234 1234|518 234 1234', '+1-518-234-1234|1 518 234 1234|518 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (256, 10, '585', '(?:\+?1[ -]?)?585[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?585[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1585-234-1234 or 1585 234 1234 or 585-234-1234.', 'Only +digits or local formats allowed i.e. +1585-234-1234 or 1585 234 1234 or 585-234-1234.', '+1-585-234-1234|1 585 234 1234|585 234 1234', '+1-585-234-1234|1 585 234 1234|585 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (257, 10, '607', '(?:\+?1[ -]?)?607[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?607[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1607-234-1234 or 1607 234 1234 or 607-234-1234.', 'Only +digits or local formats allowed i.e. +1607-234-1234 or 1607 234 1234 or 607-234-1234.', '+1-607-234-1234|1 607 234 1234|607 234 1234', '+1-607-234-1234|1 607 234 1234|607 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (258, 10, '631', '(?:\+?1[ -]?)?631[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?631[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1631-234-1234 or 1631 234 1234 or 631-234-1234.', 'Only +digits or local formats allowed i.e. +1631-234-1234 or 1631 234 1234 or 631-234-1234.', '+1-631-234-1234|1 631 234 1234|631 234 1234', '+1-631-234-1234|1 631 234 1234|631 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (259, 10, '646', '(?:\+?1[ -]?)?646[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?646[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1646-234-1234 or 1646 234 1234 or 646-234-1234.', 'Only +digits or local formats allowed i.e. +1646-234-1234 or 1646 234 1234 or 646-234-1234.', '+1-646-234-1234|1 646 234 1234|646 234 1234', '+1-646-234-1234|1 646 234 1234|646 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (260, 10, '680', '(?:\+?1[ -]?)?680[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?680[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1680-234-1234 or 1680 234 1234 or 680-234-1234.', 'Only +digits or local formats allowed i.e. +1680-234-1234 or 1680 234 1234 or 680-234-1234.', '+1-680-234-1234|1 680 234 1234|680 234 1234', '+1-680-234-1234|1 680 234 1234|680 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (261, 10, '716', '(?:\+?1[ -]?)?716[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?716[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1716-234-1234 or 1716 234 1234 or 716-234-1234.', 'Only +digits or local formats allowed i.e. +1716-234-1234 or 1716 234 1234 or 716-234-1234.', '+1-716-234-1234|1 716 234 1234|716 234 1234', '+1-716-234-1234|1 716 234 1234|716 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (262, 10, '718', '(?:\+?1[ -]?)?718[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?718[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1718-234-1234 or 1718 234 1234 or 718-234-1234.', 'Only +digits or local formats allowed i.e. +1718-234-1234 or 1718 234 1234 or 718-234-1234.', '+1-718-234-1234|1 718 234 1234|718 234 1234', '+1-718-234-1234|1 718 234 1234|718 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (263, 10, '838', '(?:\+?1[ -]?)?838[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?838[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1838-234-1234 or 1838 234 1234 or 838-234-1234.', 'Only +digits or local formats allowed i.e. +1838-234-1234 or 1838 234 1234 or 838-234-1234.', '+1-838-234-1234|1 838 234 1234|838 234 1234', '+1-838-234-1234|1 838 234 1234|838 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (264, 10, '914', '(?:\+?1[ -]?)?914[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?914[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1914-234-1234 or 1914 234 1234 or 914-234-1234.', 'Only +digits or local formats allowed i.e. +1914-234-1234 or 1914 234 1234 or 914-234-1234.', '+1-914-234-1234|1 914 234 1234|914 234 1234', '+1-914-234-1234|1 914 234 1234|914 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (265, 10, '917', '(?:\+?1[ -]?)?917[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?917[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1917-234-1234 or 1917 234 1234 or 917-234-1234.', 'Only +digits or local formats allowed i.e. +1917-234-1234 or 1917 234 1234 or 917-234-1234.', '+1-917-234-1234|1 917 234 1234|917 234 1234', '+1-917-234-1234|1 917 234 1234|917 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (266, 10, '332', '(?:\+?1[ -]?)?332[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?332[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1332-234-1234 or 1332 234 1234 or 332-234-1234.', 'Only +digits or local formats allowed i.e. +1332-234-1234 or 1332 234 1234 or 332-234-1234.', '+1-332-234-1234|1 332 234 1234|332 234 1234', '+1-332-234-1234|1 332 234 1234|332 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (267, 10, '347', '(?:\+?1[ -]?)?347[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?347[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1347-234-1234 or 1347 234 1234 or 347-234-1234.', 'Only +digits or local formats allowed i.e. +1347-234-1234 or 1347 234 1234 or 347-234-1234.', '+1-347-234-1234|1 347 234 1234|347 234 1234', '+1-347-234-1234|1 347 234 1234|347 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (268, 10, '336', '(?:\+?1[ -]?)?336[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?336[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1336-234-1234 or 1336 234 1234 or 336-234-1234.', 'Only +digits or local formats allowed i.e. +1336-234-1234 or 1336 234 1234 or 336-234-1234.', '+1-336-234-1234|1 336 234 1234|336 234 1234', '+1-336-234-1234|1 336 234 1234|336 234 1234', 'North Carolina');
INSERT INTO "public"."country_regions" VALUES (269, 10, '704', '(?:\+?1[ -]?)?704[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?704[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1704-234-1234 or 1704 234 1234 or 704-234-1234.', 'Only +digits or local formats allowed i.e. +1704-234-1234 or 1704 234 1234 or 704-234-1234.', '+1-704-234-1234|1 704 234 1234|704 234 1234', '+1-704-234-1234|1 704 234 1234|704 234 1234', 'North Carolina');
INSERT INTO "public"."country_regions" VALUES (270, 10, '743', '(?:\+?1[ -]?)?743[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?743[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1743-234-1234 or 1743 234 1234 or 743-234-1234.', 'Only +digits or local formats allowed i.e. +1743-234-1234 or 1743 234 1234 or 743-234-1234.', '+1-743-234-1234|1 743 234 1234|743 234 1234', '+1-743-234-1234|1 743 234 1234|743 234 1234', 'North Carolina');
INSERT INTO "public"."country_regions" VALUES (271, 10, '828', '(?:\+?1[ -]?)?828[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?828[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1828-234-1234 or 1828 234 1234 or 828-234-1234.', 'Only +digits or local formats allowed i.e. +1828-234-1234 or 1828 234 1234 or 828-234-1234.', '+1-828-234-1234|1 828 234 1234|828 234 1234', '+1-828-234-1234|1 828 234 1234|828 234 1234', 'North Carolina');
INSERT INTO "public"."country_regions" VALUES (272, 10, '910', '(?:\+?1[ -]?)?910[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?910[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1910-234-1234 or 1910 234 1234 or 910-234-1234.', 'Only +digits or local formats allowed i.e. +1910-234-1234 or 1910 234 1234 or 910-234-1234.', '+1-910-234-1234|1 910 234 1234|910 234 1234', '+1-910-234-1234|1 910 234 1234|910 234 1234', 'North Carolina');
INSERT INTO "public"."country_regions" VALUES (273, 10, '919', '(?:\+?1[ -]?)?919[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?919[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1919-234-1234 or 1919 234 1234 or 919-234-1234.', 'Only +digits or local formats allowed i.e. +1919-234-1234 or 1919 234 1234 or 919-234-1234.', '+1-919-234-1234|1 919 234 1234|919 234 1234', '+1-919-234-1234|1 919 234 1234|919 234 1234', 'North Carolina');
INSERT INTO "public"."country_regions" VALUES (274, 10, '980', '(?:\+?1[ -]?)?980[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?980[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1980-234-1234 or 1980 234 1234 or 980-234-1234.', 'Only +digits or local formats allowed i.e. +1980-234-1234 or 1980 234 1234 or 980-234-1234.', '+1-980-234-1234|1 980 234 1234|980 234 1234', '+1-980-234-1234|1 980 234 1234|980 234 1234', 'North Carolina');
INSERT INTO "public"."country_regions" VALUES (275, 10, '984', '(?:\+?1[ -]?)?984[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?984[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1984-234-1234 or 1984 234 1234 or 984-234-1234.', 'Only +digits or local formats allowed i.e. +1984-234-1234 or 1984 234 1234 or 984-234-1234.', '+1-984-234-1234|1 984 234 1234|984 234 1234', '+1-984-234-1234|1 984 234 1234|984 234 1234', 'North Carolina');
INSERT INTO "public"."country_regions" VALUES (276, 10, '701', '(?:\+?1[ -]?)?701[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?701[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1701-234-1234 or 1701 234 1234 or 701-234-1234.', 'Only +digits or local formats allowed i.e. +1701-234-1234 or 1701 234 1234 or 701-234-1234.', '+1-701-234-1234|1 701 234 1234|701 234 1234', '+1-701-234-1234|1 701 234 1234|701 234 1234', 'North Dakota');
INSERT INTO "public"."country_regions" VALUES (277, 10, '220', '(?:\+?1[ -]?)?220[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?220[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1220-234-1234 or 1220 234 1234 or 220-234-1234.', 'Only +digits or local formats allowed i.e. +1220-234-1234 or 1220 234 1234 or 220-234-1234.', '+1-220-234-1234|1 220 234 1234|220 234 1234', '+1-220-234-1234|1 220 234 1234|220 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (278, 10, '234', '(?:\+?1[ -]?)?234[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?234[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1234-234-1234 or 1234 234 1234 or 234-234-1234.', 'Only +digits or local formats allowed i.e. +1234-234-1234 or 1234 234 1234 or 234-234-1234.', '+1-234-234-1234|1 234 234 1234|234 234 1234', '+1-234-234-1234|1 234 234 1234|234 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (279, 10, '283', '(?:\+?1[ -]?)?283[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?283[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1283-234-1234 or 1283 234 1234 or 283-234-1234.', 'Only +digits or local formats allowed i.e. +1283-234-1234 or 1283 234 1234 or 283-234-1234.', '+1-283-234-1234|1 283 234 1234|283 234 1234', '+1-283-234-1234|1 283 234 1234|283 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (280, 10, '326', '(?:\+?1[ -]?)?326[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?326[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1326-234-1234 or 1326 234 1234 or 326-234-1234.', 'Only +digits or local formats allowed i.e. +1326-234-1234 or 1326 234 1234 or 326-234-1234.', '+1-326-234-1234|1 326 234 1234|326 234 1234', '+1-326-234-1234|1 326 234 1234|326 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (281, 10, '934', '(?:\+?1[ -]?)?934[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?934[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1934-234-1234 or 1934 234 1234 or 934-234-1234.', 'Only +digits or local formats allowed i.e. +1934-234-1234 or 1934 234 1234 or 934-234-1234.', '+1-934-234-1234|1 934 234 1234|934 234 1234', '+1-934-234-1234|1 934 234 1234|934 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (282, 10, '252', '(?:\+?1[ -]?)?252[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?252[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1252-234-1234 or 1252 234 1234 or 252-234-1234.', 'Only +digits or local formats allowed i.e. +1252-234-1234 or 1252 234 1234 or 252-234-1234.', '+1-252-234-1234|1 252 234 1234|252 234 1234', '+1-252-234-1234|1 252 234 1234|252 234 1234', 'North Carolina');
INSERT INTO "public"."country_regions" VALUES (283, 10, '513', '(?:\+?1[ -]?)?513[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?513[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1513-234-1234 or 1513 234 1234 or 513-234-1234.', 'Only +digits or local formats allowed i.e. +1513-234-1234 or 1513 234 1234 or 513-234-1234.', '+1-513-234-1234|1 513 234 1234|513 234 1234', '+1-513-234-1234|1 513 234 1234|513 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (284, 10, '567', '(?:\+?1[ -]?)?567[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?567[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1567-234-1234 or 1567 234 1234 or 567-234-1234.', 'Only +digits or local formats allowed i.e. +1567-234-1234 or 1567 234 1234 or 567-234-1234.', '+1-567-234-1234|1 567 234 1234|567 234 1234', '+1-567-234-1234|1 567 234 1234|567 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (285, 10, '614', '(?:\+?1[ -]?)?614[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?614[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1614-234-1234 or 1614 234 1234 or 614-234-1234.', 'Only +digits or local formats allowed i.e. +1614-234-1234 or 1614 234 1234 or 614-234-1234.', '+1-614-234-1234|1 614 234 1234|614 234 1234', '+1-614-234-1234|1 614 234 1234|614 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (286, 10, '740', '(?:\+?1[ -]?)?740[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?740[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1740-234-1234 or 1740 234 1234 or 740-234-1234.', 'Only +digits or local formats allowed i.e. +1740-234-1234 or 1740 234 1234 or 740-234-1234.', '+1-740-234-1234|1 740 234 1234|740 234 1234', '+1-740-234-1234|1 740 234 1234|740 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (287, 10, '937', '(?:\+?1[ -]?)?937[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?937[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1937-234-1234 or 1937 234 1234 or 937-234-1234.', 'Only +digits or local formats allowed i.e. +1937-234-1234 or 1937 234 1234 or 937-234-1234.', '+1-937-234-1234|1 937 234 1234|937 234 1234', '+1-937-234-1234|1 937 234 1234|937 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (288, 10, '405', '(?:\+?1[ -]?)?405[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?405[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1405-234-1234 or 1405 234 1234 or 405-234-1234.', 'Only +digits or local formats allowed i.e. +1405-234-1234 or 1405 234 1234 or 405-234-1234.', '+1-405-234-1234|1 405 234 1234|405 234 1234', '+1-405-234-1234|1 405 234 1234|405 234 1234', 'Oklahoma');
INSERT INTO "public"."country_regions" VALUES (289, 10, '539', '(?:\+?1[ -]?)?539[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?539[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1539-234-1234 or 1539 234 1234 or 539-234-1234.', 'Only +digits or local formats allowed i.e. +1539-234-1234 or 1539 234 1234 or 539-234-1234.', '+1-539-234-1234|1 539 234 1234|539 234 1234', '+1-539-234-1234|1 539 234 1234|539 234 1234', 'Oklahoma');
INSERT INTO "public"."country_regions" VALUES (290, 10, '572', '(?:\+?1[ -]?)?572[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?572[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1572-234-1234 or 1572 234 1234 or 572-234-1234.', 'Only +digits or local formats allowed i.e. +1572-234-1234 or 1572 234 1234 or 572-234-1234.', '+1-572-234-1234|1 572 234 1234|572 234 1234', '+1-572-234-1234|1 572 234 1234|572 234 1234', 'Oklahoma');
INSERT INTO "public"."country_regions" VALUES (291, 10, '580', '(?:\+?1[ -]?)?580[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?580[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1580-234-1234 or 1580 234 1234 or 580-234-1234.', 'Only +digits or local formats allowed i.e. +1580-234-1234 or 1580 234 1234 or 580-234-1234.', '+1-580-234-1234|1 580 234 1234|580 234 1234', '+1-580-234-1234|1 580 234 1234|580 234 1234', 'Oklahoma');
INSERT INTO "public"."country_regions" VALUES (292, 10, '918', '(?:\+?1[ -]?)?918[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?918[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1918-234-1234 or 1918 234 1234 or 918-234-1234.', 'Only +digits or local formats allowed i.e. +1918-234-1234 or 1918 234 1234 or 918-234-1234.', '+1-918-234-1234|1 918 234 1234|918 234 1234', '+1-918-234-1234|1 918 234 1234|918 234 1234', 'Oklahoma');
INSERT INTO "public"."country_regions" VALUES (293, 10, '458', '(?:\+?1[ -]?)?458[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?458[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1458-234-1234 or 1458 234 1234 or 458-234-1234.', 'Only +digits or local formats allowed i.e. +1458-234-1234 or 1458 234 1234 or 458-234-1234.', '+1-458-234-1234|1 458 234 1234|458 234 1234', '+1-458-234-1234|1 458 234 1234|458 234 1234', 'Oregon');
INSERT INTO "public"."country_regions" VALUES (294, 10, '503', '(?:\+?1[ -]?)?503[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?503[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1503-234-1234 or 1503 234 1234 or 503-234-1234.', 'Only +digits or local formats allowed i.e. +1503-234-1234 or 1503 234 1234 or 503-234-1234.', '+1-503-234-1234|1 503 234 1234|503 234 1234', '+1-503-234-1234|1 503 234 1234|503 234 1234', 'Oregon');
INSERT INTO "public"."country_regions" VALUES (295, 10, '971', '(?:\+?1[ -]?)?971[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?971[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1971-234-1234 or 1971 234 1234 or 971-234-1234.', 'Only +digits or local formats allowed i.e. +1971-234-1234 or 1971 234 1234 or 971-234-1234.', '+1-971-234-1234|1 971 234 1234|971 234 1234', '+1-971-234-1234|1 971 234 1234|971 234 1234', 'Oregon');
INSERT INTO "public"."country_regions" VALUES (296, 10, '380', '(?:\+?1[ -]?)?380[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?380[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1380-234-1234 or 1380 234 1234 or 380-234-1234.', 'Only +digits or local formats allowed i.e. +1380-234-1234 or 1380 234 1234 or 380-234-1234.', '+1-380-234-1234|1 380 234 1234|380 234 1234', '+1-380-234-1234|1 380 234 1234|380 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (297, 10, '440', '(?:\+?1[ -]?)?440[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?440[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1440-234-1234 or 1440 234 1234 or 440-234-1234.', 'Only +digits or local formats allowed i.e. +1440-234-1234 or 1440 234 1234 or 440-234-1234.', '+1-440-234-1234|1 440 234 1234|440 234 1234', '+1-440-234-1234|1 440 234 1234|440 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (298, 10, '272', '(?:\+?1[ -]?)?272[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?272[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1272-234-1234 or 1272 234 1234 or 272-234-1234.', 'Only +digits or local formats allowed i.e. +1272-234-1234 or 1272 234 1234 or 272-234-1234.', '+1-272-234-1234|1 272 234 1234|272 234 1234', '+1-272-234-1234|1 272 234 1234|272 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (299, 10, '412', '(?:\+?1[ -]?)?412[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?412[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1412-234-1234 or 1412 234 1234 or 412-234-1234.', 'Only +digits or local formats allowed i.e. +1412-234-1234 or 1412 234 1234 or 412-234-1234.', '+1-412-234-1234|1 412 234 1234|412 234 1234', '+1-412-234-1234|1 412 234 1234|412 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (300, 10, '445', '(?:\+?1[ -]?)?445[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?445[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1445-234-1234 or 1445 234 1234 or 445-234-1234.', 'Only +digits or local formats allowed i.e. +1445-234-1234 or 1445 234 1234 or 445-234-1234.', '+1-445-234-1234|1 445 234 1234|445 234 1234', '+1-445-234-1234|1 445 234 1234|445 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (301, 10, '484', '(?:\+?1[ -]?)?484[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?484[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1484-234-1234 or 1484 234 1234 or 484-234-1234.', 'Only +digits or local formats allowed i.e. +1484-234-1234 or 1484 234 1234 or 484-234-1234.', '+1-484-234-1234|1 484 234 1234|484 234 1234', '+1-484-234-1234|1 484 234 1234|484 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (302, 10, '570', '(?:\+?1[ -]?)?570[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?570[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1570-234-1234 or 1570 234 1234 or 570-234-1234.', 'Only +digits or local formats allowed i.e. +1570-234-1234 or 1570 234 1234 or 570-234-1234.', '+1-570-234-1234|1 570 234 1234|570 234 1234', '+1-570-234-1234|1 570 234 1234|570 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (303, 10, '582', '(?:\+?1[ -]?)?582[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?582[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1582-234-1234 or 1582 234 1234 or 582-234-1234.', 'Only +digits or local formats allowed i.e. +1582-234-1234 or 1582 234 1234 or 582-234-1234.', '+1-582-234-1234|1 582 234 1234|582 234 1234', '+1-582-234-1234|1 582 234 1234|582 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (304, 10, '610', '(?:\+?1[ -]?)?610[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?610[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1610-234-1234 or 1610 234 1234 or 610-234-1234.', 'Only +digits or local formats allowed i.e. +1610-234-1234 or 1610 234 1234 or 610-234-1234.', '+1-610-234-1234|1 610 234 1234|610 234 1234', '+1-610-234-1234|1 610 234 1234|610 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (305, 10, '717', '(?:\+?1[ -]?)?717[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?717[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1717-234-1234 or 1717 234 1234 or 717-234-1234.', 'Only +digits or local formats allowed i.e. +1717-234-1234 or 1717 234 1234 or 717-234-1234.', '+1-717-234-1234|1 717 234 1234|717 234 1234', '+1-717-234-1234|1 717 234 1234|717 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (306, 10, '724', '(?:\+?1[ -]?)?724[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?724[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1724-234-1234 or 1724 234 1234 or 724-234-1234.', 'Only +digits or local formats allowed i.e. +1724-234-1234 or 1724 234 1234 or 724-234-1234.', '+1-724-234-1234|1 724 234 1234|724 234 1234', '+1-724-234-1234|1 724 234 1234|724 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (307, 10, '814', '(?:\+?1[ -]?)?814[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?814[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1814-234-1234 or 1814 234 1234 or 814-234-1234.', 'Only +digits or local formats allowed i.e. +1814-234-1234 or 1814 234 1234 or 814-234-1234.', '+1-814-234-1234|1 814 234 1234|814 234 1234', '+1-814-234-1234|1 814 234 1234|814 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (308, 10, '401', '(?:\+?1[ -]?)?401[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?401[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1401-234-1234 or 1401 234 1234 or 401-234-1234.', 'Only +digits or local formats allowed i.e. +1401-234-1234 or 1401 234 1234 or 401-234-1234.', '+1-401-234-1234|1 401 234 1234|401 234 1234', '+1-401-234-1234|1 401 234 1234|401 234 1234', 'Rhode Island');
INSERT INTO "public"."country_regions" VALUES (309, 10, '803', '(?:\+?1[ -]?)?803[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?803[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1803-234-1234 or 1803 234 1234 or 803-234-1234.', 'Only +digits or local formats allowed i.e. +1803-234-1234 or 1803 234 1234 or 803-234-1234.', '+1-803-234-1234|1 803 234 1234|803 234 1234', '+1-803-234-1234|1 803 234 1234|803 234 1234', 'South Carolina');
INSERT INTO "public"."country_regions" VALUES (310, 10, '839', '(?:\+?1[ -]?)?839[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?839[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1839-234-1234 or 1839 234 1234 or 839-234-1234.', 'Only +digits or local formats allowed i.e. +1839-234-1234 or 1839 234 1234 or 839-234-1234.', '+1-839-234-1234|1 839 234 1234|839 234 1234', '+1-839-234-1234|1 839 234 1234|839 234 1234', 'South Carolina');
INSERT INTO "public"."country_regions" VALUES (311, 10, '223', '(?:\+?1[ -]?)?223[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?223[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1223-234-1234 or 1223 234 1234 or 223-234-1234.', 'Only +digits or local formats allowed i.e. +1223-234-1234 or 1223 234 1234 or 223-234-1234.', '+1-223-234-1234|1 223 234 1234|223 234 1234', '+1-223-234-1234|1 223 234 1234|223 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (312, 10, '267', '(?:\+?1[ -]?)?267[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?267[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1267-234-1234 or 1267 234 1234 or 267-234-1234.', 'Only +digits or local formats allowed i.e. +1267-234-1234 or 1267 234 1234 or 267-234-1234.', '+1-267-234-1234|1 267 234 1234|267 234 1234', '+1-267-234-1234|1 267 234 1234|267 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (313, 10, '605', '(?:\+?1[ -]?)?605[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?605[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1605-234-1234 or 1605 234 1234 or 605-234-1234.', 'Only +digits or local formats allowed i.e. +1605-234-1234 or 1605 234 1234 or 605-234-1234.', '+1-605-234-1234|1 605 234 1234|605 234 1234', '+1-605-234-1234|1 605 234 1234|605 234 1234', 'South Dakota');
INSERT INTO "public"."country_regions" VALUES (314, 10, '423', '(?:\+?1[ -]?)?423[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?423[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1423-234-1234 or 1423 234 1234 or 423-234-1234.', 'Only +digits or local formats allowed i.e. +1423-234-1234 or 1423 234 1234 or 423-234-1234.', '+1-423-234-1234|1 423 234 1234|423 234 1234', '+1-423-234-1234|1 423 234 1234|423 234 1234', 'Tennessee');
INSERT INTO "public"."country_regions" VALUES (315, 10, '615', '(?:\+?1[ -]?)?615[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?615[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1615-234-1234 or 1615 234 1234 or 615-234-1234.', 'Only +digits or local formats allowed i.e. +1615-234-1234 or 1615 234 1234 or 615-234-1234.', '+1-615-234-1234|1 615 234 1234|615 234 1234', '+1-615-234-1234|1 615 234 1234|615 234 1234', 'Tennessee');
INSERT INTO "public"."country_regions" VALUES (316, 10, '629', '(?:\+?1[ -]?)?629[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?629[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1629-234-1234 or 1629 234 1234 or 629-234-1234.', 'Only +digits or local formats allowed i.e. +1629-234-1234 or 1629 234 1234 or 629-234-1234.', '+1-629-234-1234|1 629 234 1234|629 234 1234', '+1-629-234-1234|1 629 234 1234|629 234 1234', 'Tennessee');
INSERT INTO "public"."country_regions" VALUES (317, 10, '731', '(?:\+?1[ -]?)?731[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?731[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1731-234-1234 or 1731 234 1234 or 731-234-1234.', 'Only +digits or local formats allowed i.e. +1731-234-1234 or 1731 234 1234 or 731-234-1234.', '+1-731-234-1234|1 731 234 1234|731 234 1234', '+1-731-234-1234|1 731 234 1234|731 234 1234', 'Tennessee');
INSERT INTO "public"."country_regions" VALUES (318, 10, '865', '(?:\+?1[ -]?)?865[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?865[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1865-234-1234 or 1865 234 1234 or 865-234-1234.', 'Only +digits or local formats allowed i.e. +1865-234-1234 or 1865 234 1234 or 865-234-1234.', '+1-865-234-1234|1 865 234 1234|865 234 1234', '+1-865-234-1234|1 865 234 1234|865 234 1234', 'Tennessee');
INSERT INTO "public"."country_regions" VALUES (319, 10, '901', '(?:\+?1[ -]?)?901[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?901[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1901-234-1234 or 1901 234 1234 or 901-234-1234.', 'Only +digits or local formats allowed i.e. +1901-234-1234 or 1901 234 1234 or 901-234-1234.', '+1-901-234-1234|1 901 234 1234|901 234 1234', '+1-901-234-1234|1 901 234 1234|901 234 1234', 'Tennessee');
INSERT INTO "public"."country_regions" VALUES (320, 10, '931', '(?:\+?1[ -]?)?931[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?931[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1931-234-1234 or 1931 234 1234 or 931-234-1234.', 'Only +digits or local formats allowed i.e. +1931-234-1234 or 1931 234 1234 or 931-234-1234.', '+1-931-234-1234|1 931 234 1234|931 234 1234', '+1-931-234-1234|1 931 234 1234|931 234 1234', 'Tennessee');
INSERT INTO "public"."country_regions" VALUES (321, 10, '210', '(?:\+?1[ -]?)?210[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?210[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1210-234-1234 or 1210 234 1234 or 210-234-1234.', 'Only +digits or local formats allowed i.e. +1210-234-1234 or 1210 234 1234 or 210-234-1234.', '+1-210-234-1234|1 210 234 1234|210 234 1234', '+1-210-234-1234|1 210 234 1234|210 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (322, 10, '214', '(?:\+?1[ -]?)?214[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?214[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1214-234-1234 or 1214 234 1234 or 214-234-1234.', 'Only +digits or local formats allowed i.e. +1214-234-1234 or 1214 234 1234 or 214-234-1234.', '+1-214-234-1234|1 214 234 1234|214 234 1234', '+1-214-234-1234|1 214 234 1234|214 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (323, 10, '254', '(?:\+?1[ -]?)?254[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?254[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1254-234-1234 or 1254 234 1234 or 254-234-1234.', 'Only +digits or local formats allowed i.e. +1254-234-1234 or 1254 234 1234 or 254-234-1234.', '+1-254-234-1234|1 254 234 1234|254 234 1234', '+1-254-234-1234|1 254 234 1234|254 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (324, 10, '325', '(?:\+?1[ -]?)?325[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?325[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1325-234-1234 or 1325 234 1234 or 325-234-1234.', 'Only +digits or local formats allowed i.e. +1325-234-1234 or 1325 234 1234 or 325-234-1234.', '+1-325-234-1234|1 325 234 1234|325 234 1234', '+1-325-234-1234|1 325 234 1234|325 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (325, 10, '346', '(?:\+?1[ -]?)?346[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?346[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1346-234-1234 or 1346 234 1234 or 346-234-1234.', 'Only +digits or local formats allowed i.e. +1346-234-1234 or 1346 234 1234 or 346-234-1234.', '+1-346-234-1234|1 346 234 1234|346 234 1234', '+1-346-234-1234|1 346 234 1234|346 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (326, 10, '854', '(?:\+?1[ -]?)?854[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?854[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1854-234-1234 or 1854 234 1234 or 854-234-1234.', 'Only +digits or local formats allowed i.e. +1854-234-1234 or 1854 234 1234 or 854-234-1234.', '+1-854-234-1234|1 854 234 1234|854 234 1234', '+1-854-234-1234|1 854 234 1234|854 234 1234', 'South Carolina');
INSERT INTO "public"."country_regions" VALUES (327, 10, '864', '(?:\+?1[ -]?)?864[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?864[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1864-234-1234 or 1864 234 1234 or 864-234-1234.', 'Only +digits or local formats allowed i.e. +1864-234-1234 or 1864 234 1234 or 864-234-1234.', '+1-864-234-1234|1 864 234 1234|864 234 1234', '+1-864-234-1234|1 864 234 1234|864 234 1234', 'South Carolina');
INSERT INTO "public"."country_regions" VALUES (328, 10, '469', '(?:\+?1[ -]?)?469[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?469[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1469-234-1234 or 1469 234 1234 or 469-234-1234.', 'Only +digits or local formats allowed i.e. +1469-234-1234 or 1469 234 1234 or 469-234-1234.', '+1-469-234-1234|1 469 234 1234|469 234 1234', '+1-469-234-1234|1 469 234 1234|469 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (329, 10, '512', '(?:\+?1[ -]?)?512[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?512[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1512-234-1234 or 1512 234 1234 or 512-234-1234.', 'Only +digits or local formats allowed i.e. +1512-234-1234 or 1512 234 1234 or 512-234-1234.', '+1-512-234-1234|1 512 234 1234|512 234 1234', '+1-512-234-1234|1 512 234 1234|512 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (330, 10, '682', '(?:\+?1[ -]?)?682[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?682[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1682-234-1234 or 1682 234 1234 or 682-234-1234.', 'Only +digits or local formats allowed i.e. +1682-234-1234 or 1682 234 1234 or 682-234-1234.', '+1-682-234-1234|1 682 234 1234|682 234 1234', '+1-682-234-1234|1 682 234 1234|682 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (331, 10, '713', '(?:\+?1[ -]?)?713[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?713[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1713-234-1234 or 1713 234 1234 or 713-234-1234.', 'Only +digits or local formats allowed i.e. +1713-234-1234 or 1713 234 1234 or 713-234-1234.', '+1-713-234-1234|1 713 234 1234|713 234 1234', '+1-713-234-1234|1 713 234 1234|713 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (332, 10, '726', '(?:\+?1[ -]?)?726[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?726[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1726-234-1234 or 1726 234 1234 or 726-234-1234.', 'Only +digits or local formats allowed i.e. +1726-234-1234 or 1726 234 1234 or 726-234-1234.', '+1-726-234-1234|1 726 234 1234|726 234 1234', '+1-726-234-1234|1 726 234 1234|726 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (333, 10, '737', '(?:\+?1[ -]?)?737[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?737[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1737-234-1234 or 1737 234 1234 or 737-234-1234.', 'Only +digits or local formats allowed i.e. +1737-234-1234 or 1737 234 1234 or 737-234-1234.', '+1-737-234-1234|1 737 234 1234|737 234 1234', '+1-737-234-1234|1 737 234 1234|737 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (334, 10, '806', '(?:\+?1[ -]?)?806[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?806[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1806-234-1234 or 1806 234 1234 or 806-234-1234.', 'Only +digits or local formats allowed i.e. +1806-234-1234 or 1806 234 1234 or 806-234-1234.', '+1-806-234-1234|1 806 234 1234|806 234 1234', '+1-806-234-1234|1 806 234 1234|806 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (335, 10, '817', '(?:\+?1[ -]?)?817[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?817[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1817-234-1234 or 1817 234 1234 or 817-234-1234.', 'Only +digits or local formats allowed i.e. +1817-234-1234 or 1817 234 1234 or 817-234-1234.', '+1-817-234-1234|1 817 234 1234|817 234 1234', '+1-817-234-1234|1 817 234 1234|817 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (336, 10, '830', '(?:\+?1[ -]?)?830[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?830[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1830-234-1234 or 1830 234 1234 or 830-234-1234.', 'Only +digits or local formats allowed i.e. +1830-234-1234 or 1830 234 1234 or 830-234-1234.', '+1-830-234-1234|1 830 234 1234|830 234 1234', '+1-830-234-1234|1 830 234 1234|830 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (337, 10, '832', '(?:\+?1[ -]?)?832[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?832[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1832-234-1234 or 1832 234 1234 or 832-234-1234.', 'Only +digits or local formats allowed i.e. +1832-234-1234 or 1832 234 1234 or 832-234-1234.', '+1-832-234-1234|1 832 234 1234|832 234 1234', '+1-832-234-1234|1 832 234 1234|832 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (338, 10, '903', '(?:\+?1[ -]?)?903[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?903[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1903-234-1234 or 1903 234 1234 or 903-234-1234.', 'Only +digits or local formats allowed i.e. +1903-234-1234 or 1903 234 1234 or 903-234-1234.', '+1-903-234-1234|1 903 234 1234|903 234 1234', '+1-903-234-1234|1 903 234 1234|903 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (339, 10, '936', '(?:\+?1[ -]?)?936[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?936[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1936-234-1234 or 1936 234 1234 or 936-234-1234.', 'Only +digits or local formats allowed i.e. +1936-234-1234 or 1936 234 1234 or 936-234-1234.', '+1-936-234-1234|1 936 234 1234|936 234 1234', '+1-936-234-1234|1 936 234 1234|936 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (340, 10, '940', '(?:\+?1[ -]?)?940[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?940[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1940-234-1234 or 1940 234 1234 or 940-234-1234.', 'Only +digits or local formats allowed i.e. +1940-234-1234 or 1940 234 1234 or 940-234-1234.', '+1-940-234-1234|1 940 234 1234|940 234 1234', '+1-940-234-1234|1 940 234 1234|940 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (341, 10, '430', '(?:\+?1[ -]?)?430[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?430[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1430-234-1234 or 1430 234 1234 or 430-234-1234.', 'Only +digits or local formats allowed i.e. +1430-234-1234 or 1430 234 1234 or 430-234-1234.', '+1-430-234-1234|1 430 234 1234|430 234 1234', '+1-430-234-1234|1 430 234 1234|430 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (342, 10, '432', '(?:\+?1[ -]?)?432[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?432[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1432-234-1234 or 1432 234 1234 or 432-234-1234.', 'Only +digits or local formats allowed i.e. +1432-234-1234 or 1432 234 1234 or 432-234-1234.', '+1-432-234-1234|1 432 234 1234|432 234 1234', '+1-432-234-1234|1 432 234 1234|432 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (343, 10, '979', '(?:\+?1[ -]?)?979[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?979[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1979-234-1234 or 1979 234 1234 or 979-234-1234.', 'Only +digits or local formats allowed i.e. +1979-234-1234 or 1979 234 1234 or 979-234-1234.', '+1-979-234-1234|1 979 234 1234|979 234 1234', '+1-979-234-1234|1 979 234 1234|979 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (344, 10, '385', '(?:\+?1[ -]?)?385[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?385[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1385-234-1234 or 1385 234 1234 or 385-234-1234.', 'Only +digits or local formats allowed i.e. +1385-234-1234 or 1385 234 1234 or 385-234-1234.', '+1-385-234-1234|1 385 234 1234|385 234 1234', '+1-385-234-1234|1 385 234 1234|385 234 1234', 'Utah');
INSERT INTO "public"."country_regions" VALUES (345, 10, '435', '(?:\+?1[ -]?)?435[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?435[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1435-234-1234 or 1435 234 1234 or 435-234-1234.', 'Only +digits or local formats allowed i.e. +1435-234-1234 or 1435 234 1234 or 435-234-1234.', '+1-435-234-1234|1 435 234 1234|435 234 1234', '+1-435-234-1234|1 435 234 1234|435 234 1234', 'Utah');
INSERT INTO "public"."country_regions" VALUES (346, 10, '801', '(?:\+?1[ -]?)?801[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?801[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1801-234-1234 or 1801 234 1234 or 801-234-1234.', 'Only +digits or local formats allowed i.e. +1801-234-1234 or 1801 234 1234 or 801-234-1234.', '+1-801-234-1234|1 801 234 1234|801 234 1234', '+1-801-234-1234|1 801 234 1234|801 234 1234', 'Utah');
INSERT INTO "public"."country_regions" VALUES (347, 10, '802', '(?:\+?1[ -]?)?802[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?802[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1802-234-1234 or 1802 234 1234 or 802-234-1234.', 'Only +digits or local formats allowed i.e. +1802-234-1234 or 1802 234 1234 or 802-234-1234.', '+1-802-234-1234|1 802 234 1234|802 234 1234', '+1-802-234-1234|1 802 234 1234|802 234 1234', 'Vermont');
INSERT INTO "public"."country_regions" VALUES (348, 10, '276', '(?:\+?1[ -]?)?276[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?276[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1276-234-1234 or 1276 234 1234 or 276-234-1234.', 'Only +digits or local formats allowed i.e. +1276-234-1234 or 1276 234 1234 or 276-234-1234.', '+1-276-234-1234|1 276 234 1234|276 234 1234', '+1-276-234-1234|1 276 234 1234|276 234 1234', 'Virginia');
INSERT INTO "public"."country_regions" VALUES (349, 10, '434', '(?:\+?1[ -]?)?434[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?434[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1434-234-1234 or 1434 234 1234 or 434-234-1234.', 'Only +digits or local formats allowed i.e. +1434-234-1234 or 1434 234 1234 or 434-234-1234.', '+1-434-234-1234|1 434 234 1234|434 234 1234', '+1-434-234-1234|1 434 234 1234|434 234 1234', 'Virginia');
INSERT INTO "public"."country_regions" VALUES (350, 10, '540', '(?:\+?1[ -]?)?540[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?540[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1540-234-1234 or 1540 234 1234 or 540-234-1234.', 'Only +digits or local formats allowed i.e. +1540-234-1234 or 1540 234 1234 or 540-234-1234.', '+1-540-234-1234|1 540 234 1234|540 234 1234', '+1-540-234-1234|1 540 234 1234|540 234 1234', 'Virginia');
INSERT INTO "public"."country_regions" VALUES (351, 10, '571', '(?:\+?1[ -]?)?571[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?571[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1571-234-1234 or 1571 234 1234 or 571-234-1234.', 'Only +digits or local formats allowed i.e. +1571-234-1234 or 1571 234 1234 or 571-234-1234.', '+1-571-234-1234|1 571 234 1234|571 234 1234', '+1-571-234-1234|1 571 234 1234|571 234 1234', 'Virginia');
INSERT INTO "public"."country_regions" VALUES (352, 10, '703', '(?:\+?1[ -]?)?703[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?703[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1703-234-1234 or 1703 234 1234 or 703-234-1234.', 'Only +digits or local formats allowed i.e. +1703-234-1234 or 1703 234 1234 or 703-234-1234.', '+1-703-234-1234|1 703 234 1234|703 234 1234', '+1-703-234-1234|1 703 234 1234|703 234 1234', 'Virginia');
INSERT INTO "public"."country_regions" VALUES (353, 10, '757', '(?:\+?1[ -]?)?757[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?757[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1757-234-1234 or 1757 234 1234 or 757-234-1234.', 'Only +digits or local formats allowed i.e. +1757-234-1234 or 1757 234 1234 or 757-234-1234.', '+1-757-234-1234|1 757 234 1234|757 234 1234', '+1-757-234-1234|1 757 234 1234|757 234 1234', 'Virginia');
INSERT INTO "public"."country_regions" VALUES (354, 10, '804', '(?:\+?1[ -]?)?804[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?804[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1804-234-1234 or 1804 234 1234 or 804-234-1234.', 'Only +digits or local formats allowed i.e. +1804-234-1234 or 1804 234 1234 or 804-234-1234.', '+1-804-234-1234|1 804 234 1234|804 234 1234', '+1-804-234-1234|1 804 234 1234|804 234 1234', 'Virginia');
INSERT INTO "public"."country_regions" VALUES (355, 10, '948', '(?:\+?1[ -]?)?948[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?948[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1948-234-1234 or 1948 234 1234 or 948-234-1234.', 'Only +digits or local formats allowed i.e. +1948-234-1234 or 1948 234 1234 or 948-234-1234.', '+1-948-234-1234|1 948 234 1234|948 234 1234', '+1-948-234-1234|1 948 234 1234|948 234 1234', 'Virginia');
INSERT INTO "public"."country_regions" VALUES (356, 10, '956', '(?:\+?1[ -]?)?956[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?956[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1956-234-1234 or 1956 234 1234 or 956-234-1234.', 'Only +digits or local formats allowed i.e. +1956-234-1234 or 1956 234 1234 or 956-234-1234.', '+1-956-234-1234|1 956 234 1234|956 234 1234', '+1-956-234-1234|1 956 234 1234|956 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (357, 10, '972', '(?:\+?1[ -]?)?972[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?972[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1972-234-1234 or 1972 234 1234 or 972-234-1234.', 'Only +digits or local formats allowed i.e. +1972-234-1234 or 1972 234 1234 or 972-234-1234.', '+1-972-234-1234|1 972 234 1234|972 234 1234', '+1-972-234-1234|1 972 234 1234|972 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (358, 10, '425', '(?:\+?1[ -]?)?425[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?425[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1425-234-1234 or 1425 234 1234 or 425-234-1234.', 'Only +digits or local formats allowed i.e. +1425-234-1234 or 1425 234 1234 or 425-234-1234.', '+1-425-234-1234|1 425 234 1234|425 234 1234', '+1-425-234-1234|1 425 234 1234|425 234 1234', 'Washington');
INSERT INTO "public"."country_regions" VALUES (359, 10, '509', '(?:\+?1[ -]?)?509[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?509[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1509-234-1234 or 1509 234 1234 or 509-234-1234.', 'Only +digits or local formats allowed i.e. +1509-234-1234 or 1509 234 1234 or 509-234-1234.', '+1-509-234-1234|1 509 234 1234|509 234 1234', '+1-509-234-1234|1 509 234 1234|509 234 1234', 'Washington');
INSERT INTO "public"."country_regions" VALUES (360, 10, '564', '(?:\+?1[ -]?)?564[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?564[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1564-234-1234 or 1564 234 1234 or 564-234-1234.', 'Only +digits or local formats allowed i.e. +1564-234-1234 or 1564 234 1234 or 564-234-1234.', '+1-564-234-1234|1 564 234 1234|564 234 1234', '+1-564-234-1234|1 564 234 1234|564 234 1234', 'Washington');
INSERT INTO "public"."country_regions" VALUES (361, 10, '304', '(?:\+?1[ -]?)?304[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?304[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1304-234-1234 or 1304 234 1234 or 304-234-1234.', 'Only +digits or local formats allowed i.e. +1304-234-1234 or 1304 234 1234 or 304-234-1234.', '+1-304-234-1234|1 304 234 1234|304 234 1234', '+1-304-234-1234|1 304 234 1234|304 234 1234', 'West Virginia');
INSERT INTO "public"."country_regions" VALUES (362, 10, '681', '(?:\+?1[ -]?)?681[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?681[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1681-234-1234 or 1681 234 1234 or 681-234-1234.', 'Only +digits or local formats allowed i.e. +1681-234-1234 or 1681 234 1234 or 681-234-1234.', '+1-681-234-1234|1 681 234 1234|681 234 1234', '+1-681-234-1234|1 681 234 1234|681 234 1234', 'West Virginia');
INSERT INTO "public"."country_regions" VALUES (363, 10, '262', '(?:\+?1[ -]?)?262[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?262[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1262-234-1234 or 1262 234 1234 or 262-234-1234.', 'Only +digits or local formats allowed i.e. +1262-234-1234 or 1262 234 1234 or 262-234-1234.', '+1-262-234-1234|1 262 234 1234|262 234 1234', '+1-262-234-1234|1 262 234 1234|262 234 1234', 'Wisconsin');
INSERT INTO "public"."country_regions" VALUES (364, 10, '274', '(?:\+?1[ -]?)?274[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?274[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1274-234-1234 or 1274 234 1234 or 274-234-1234.', 'Only +digits or local formats allowed i.e. +1274-234-1234 or 1274 234 1234 or 274-234-1234.', '+1-274-234-1234|1 274 234 1234|274 234 1234', '+1-274-234-1234|1 274 234 1234|274 234 1234', 'Wisconsin');
INSERT INTO "public"."country_regions" VALUES (365, 10, '414', '(?:\+?1[ -]?)?414[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?414[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1414-234-1234 or 1414 234 1234 or 414-234-1234.', 'Only +digits or local formats allowed i.e. +1414-234-1234 or 1414 234 1234 or 414-234-1234.', '+1-414-234-1234|1 414 234 1234|414 234 1234', '+1-414-234-1234|1 414 234 1234|414 234 1234', 'Wisconsin');
INSERT INTO "public"."country_regions" VALUES (366, 10, '534', '(?:\+?1[ -]?)?534[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?534[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1534-234-1234 or 1534 234 1234 or 534-234-1234.', 'Only +digits or local formats allowed i.e. +1534-234-1234 or 1534 234 1234 or 534-234-1234.', '+1-534-234-1234|1 534 234 1234|534 234 1234', '+1-534-234-1234|1 534 234 1234|534 234 1234', 'Wisconsin');
INSERT INTO "public"."country_regions" VALUES (367, 10, '715', '(?:\+?1[ -]?)?715[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?715[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1715-234-1234 or 1715 234 1234 or 715-234-1234.', 'Only +digits or local formats allowed i.e. +1715-234-1234 or 1715 234 1234 or 715-234-1234.', '+1-715-234-1234|1 715 234 1234|715 234 1234', '+1-715-234-1234|1 715 234 1234|715 234 1234', 'Wisconsin');
INSERT INTO "public"."country_regions" VALUES (368, 10, '920', '(?:\+?1[ -]?)?920[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?920[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1920-234-1234 or 1920 234 1234 or 920-234-1234.', 'Only +digits or local formats allowed i.e. +1920-234-1234 or 1920 234 1234 or 920-234-1234.', '+1-920-234-1234|1 920 234 1234|920 234 1234', '+1-920-234-1234|1 920 234 1234|920 234 1234', 'Wisconsin');
INSERT INTO "public"."country_regions" VALUES (369, 10, '307', '(?:\+?1[ -]?)?307[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?307[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1307-234-1234 or 1307 234 1234 or 307-234-1234.', 'Only +digits or local formats allowed i.e. +1307-234-1234 or 1307 234 1234 or 307-234-1234.', '+1-307-234-1234|1 307 234 1234|307 234 1234', '+1-307-234-1234|1 307 234 1234|307 234 1234', 'Wyoming');
INSERT INTO "public"."country_regions" VALUES (370, 10, '334', '(?:\+?1[ -]?)?334[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?334[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1334-234-1234 or 1334 234 1234 or 334-234-1234.', 'Only +digits or local formats allowed i.e. +1334-234-1234 or 1334 234 1234 or 334-234-1234.', '+1-334-234-1234|1 334 234 1234|334 234 1234', '+1-334-234-1234|1 334 234 1234|334 234 1234', 'Alabama');
INSERT INTO "public"."country_regions" VALUES (371, 10, '360', '(?:\+?1[ -]?)?360[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?360[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1360-234-1234 or 1360 234 1234 or 360-234-1234.', 'Only +digits or local formats allowed i.e. +1360-234-1234 or 1360 234 1234 or 360-234-1234.', '+1-360-234-1234|1 360 234 1234|360 234 1234', '+1-360-234-1234|1 360 234 1234|360 234 1234', 'Washington');
INSERT INTO "public"."country_regions" VALUES (372, 10, '253', '(?:\+?1[ -]?)?253[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?253[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1253-234-1234 or 1253 234 1234 or 253-234-1234.', 'Only +digits or local formats allowed i.e. +1253-234-1234 or 1253 234 1234 or 253-234-1234.', '+1-253-234-1234|1 253 234 1234|253 234 1234', '+1-253-234-1234|1 253 234 1234|253 234 1234', 'Washington');
INSERT INTO "public"."country_regions" VALUES (373, 10, '669', '(?:\+?1[ -]?)?669[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?669[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1669-234-1234 or 1669 234 1234 or 669-234-1234.', 'Only +digits or local formats allowed i.e. +1669-234-1234 or 1669 234 1234 or 669-234-1234.', '+1-669-234-1234|1 669 234 1234|669 234 1234', '+1-669-234-1234|1 669 234 1234|669 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (374, 10, '303', '(?:\+?1[ -]?)?303[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?303[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1303-234-1234 or 1303 234 1234 or 303-234-1234.', 'Only +digits or local formats allowed i.e. +1303-234-1234 or 1303 234 1234 or 303-234-1234.', '+1-303-234-1234|1 303 234 1234|303 234 1234', '+1-303-234-1234|1 303 234 1234|303 234 1234', 'Colorado');
INSERT INTO "public"."country_regions" VALUES (375, 10, '321', '(?:\+?1[ -]?)?321[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?321[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1321-234-1234 or 1321 234 1234 or 321-234-1234.', 'Only +digits or local formats allowed i.e. +1321-234-1234 or 1321 234 1234 or 321-234-1234.', '+1-321-234-1234|1 321 234 1234|321 234 1234', '+1-321-234-1234|1 321 234 1234|321 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (376, 10, '407', '(?:\+?1[ -]?)?407[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?407[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1407-234-1234 or 1407 234 1234 or 407-234-1234.', 'Only +digits or local formats allowed i.e. +1407-234-1234 or 1407 234 1234 or 407-234-1234.', '+1-407-234-1234|1 407 234 1234|407 234 1234', '+1-407-234-1234|1 407 234 1234|407 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (377, 10, '448', '(?:\+?1[ -]?)?448[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?448[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1448-234-1234 or 1448 234 1234 or 448-234-1234.', 'Only +digits or local formats allowed i.e. +1448-234-1234 or 1448 234 1234 or 448-234-1234.', '+1-448-234-1234|1 448 234 1234|448 234 1234', '+1-448-234-1234|1 448 234 1234|448 234 1234', 'Florida');
INSERT INTO "public"."country_regions" VALUES (378, 10, '229', '(?:\+?1[ -]?)?229[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?229[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1229-234-1234 or 1229 234 1234 or 229-234-1234.', 'Only +digits or local formats allowed i.e. +1229-234-1234 or 1229 234 1234 or 229-234-1234.', '+1-229-234-1234|1 229 234 1234|229 234 1234', '+1-229-234-1234|1 229 234 1234|229 234 1234', 'Georgia');
INSERT INTO "public"."country_regions" VALUES (379, 10, '478', '(?:\+?1[ -]?)?478[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?478[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1478-234-1234 or 1478 234 1234 or 478-234-1234.', 'Only +digits or local formats allowed i.e. +1478-234-1234 or 1478 234 1234 or 478-234-1234.', '+1-478-234-1234|1 478 234 1234|478 234 1234', '+1-478-234-1234|1 478 234 1234|478 234 1234', 'Georgia');
INSERT INTO "public"."country_regions" VALUES (380, 10, '678', '(?:\+?1[ -]?)?678[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?678[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1678-234-1234 or 1678 234 1234 or 678-234-1234.', 'Only +digits or local formats allowed i.e. +1678-234-1234 or 1678 234 1234 or 678-234-1234.', '+1-678-234-1234|1 678 234 1234|678 234 1234', '+1-678-234-1234|1 678 234 1234|678 234 1234', 'Georgia');
INSERT INTO "public"."country_regions" VALUES (381, 10, '447', '(?:\+?1[ -]?)?447[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?447[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1447-234-1234 or 1447 234 1234 or 447-234-1234.', 'Only +digits or local formats allowed i.e. +1447-234-1234 or 1447 234 1234 or 447-234-1234.', '+1-447-234-1234|1 447 234 1234|447 234 1234', '+1-447-234-1234|1 447 234 1234|447 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (382, 10, '630', '(?:\+?1[ -]?)?630[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?630[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1630-234-1234 or 1630 234 1234 or 630-234-1234.', 'Only +digits or local formats allowed i.e. +1630-234-1234 or 1630 234 1234 or 630-234-1234.', '+1-630-234-1234|1 630 234 1234|630 234 1234', '+1-630-234-1234|1 630 234 1234|630 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (383, 10, '708', '(?:\+?1[ -]?)?708[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?708[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1708-234-1234 or 1708 234 1234 or 708-234-1234.', 'Only +digits or local formats allowed i.e. +1708-234-1234 or 1708 234 1234 or 708-234-1234.', '+1-708-234-1234|1 708 234 1234|708 234 1234', '+1-708-234-1234|1 708 234 1234|708 234 1234', 'Illinois');
INSERT INTO "public"."country_regions" VALUES (384, 10, '930', '(?:\+?1[ -]?)?930[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?930[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1930-234-1234 or 1930 234 1234 or 930-234-1234.', 'Only +digits or local formats allowed i.e. +1930-234-1234 or 1930 234 1234 or 930-234-1234.', '+1-930-234-1234|1 930 234 1234|930 234 1234', '+1-930-234-1234|1 930 234 1234|930 234 1234', 'Indiana');
INSERT INTO "public"."country_regions" VALUES (385, 10, '606', '(?:\+?1[ -]?)?606[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?606[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1606-234-1234 or 1606 234 1234 or 606-234-1234.', 'Only +digits or local formats allowed i.e. +1606-234-1234 or 1606 234 1234 or 606-234-1234.', '+1-606-234-1234|1 606 234 1234|606 234 1234', '+1-606-234-1234|1 606 234 1234|606 234 1234', 'Kentucky');
INSERT INTO "public"."country_regions" VALUES (386, 10, '225', '(?:\+?1[ -]?)?225[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?225[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1225-234-1234 or 1225 234 1234 or 225-234-1234.', 'Only +digits or local formats allowed i.e. +1225-234-1234 or 1225 234 1234 or 225-234-1234.', '+1-225-234-1234|1 225 234 1234|225 234 1234', '+1-225-234-1234|1 225 234 1234|225 234 1234', 'Louisiana');
INSERT INTO "public"."country_regions" VALUES (387, 10, '323', '(?:\+?1[ -]?)?323[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?323[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1323-234-1234 or 1323 234 1234 or 323-234-1234.', 'Only +digits or local formats allowed i.e. +1323-234-1234 or 1323 234 1234 or 323-234-1234.', '+1-323-234-1234|1 323 234 1234|323 234 1234', '+1-323-234-1234|1 323 234 1234|323 234 1234', 'California');
INSERT INTO "public"."country_regions" VALUES (388, 10, '248', '(?:\+?1[ -]?)?248[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?248[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1248-234-1234 or 1248 234 1234 or 248-234-1234.', 'Only +digits or local formats allowed i.e. +1248-234-1234 or 1248 234 1234 or 248-234-1234.', '+1-248-234-1234|1 248 234 1234|248 234 1234', '+1-248-234-1234|1 248 234 1234|248 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (389, 10, '320', '(?:\+?1[ -]?)?320[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?320[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1320-234-1234 or 1320 234 1234 or 320-234-1234.', 'Only +digits or local formats allowed i.e. +1320-234-1234 or 1320 234 1234 or 320-234-1234.', '+1-320-234-1234|1 320 234 1234|320 234 1234', '+1-320-234-1234|1 320 234 1234|320 234 1234', 'Minnesota');
INSERT INTO "public"."country_regions" VALUES (390, 10, '651', '(?:\+?1[ -]?)?651[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?651[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1651-234-1234 or 1651 234 1234 or 651-234-1234.', 'Only +digits or local formats allowed i.e. +1651-234-1234 or 1651 234 1234 or 651-234-1234.', '+1-651-234-1234|1 651 234 1234|651 234 1234', '+1-651-234-1234|1 651 234 1234|651 234 1234', 'Minnesota');
INSERT INTO "public"."country_regions" VALUES (391, 10, '975', '(?:\+?1[ -]?)?975[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?975[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1975-234-1234 or 1975 234 1234 or 975-234-1234.', 'Only +digits or local formats allowed i.e. +1975-234-1234 or 1975 234 1234 or 975-234-1234.', '+1-975-234-1234|1 975 234 1234|975 234 1234', '+1-975-234-1234|1 975 234 1234|975 234 1234', 'Missouri');
INSERT INTO "public"."country_regions" VALUES (392, 10, '531', '(?:\+?1[ -]?)?531[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?531[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1531-234-1234 or 1531 234 1234 or 531-234-1234.', 'Only +digits or local formats allowed i.e. +1531-234-1234 or 1531 234 1234 or 531-234-1234.', '+1-531-234-1234|1 531 234 1234|531 234 1234', '+1-531-234-1234|1 531 234 1234|531 234 1234', 'Nebraska');
INSERT INTO "public"."country_regions" VALUES (393, 10, '908', '(?:\+?1[ -]?)?908[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?908[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1908-234-1234 or 1908 234 1234 or 908-234-1234.', 'Only +digits or local formats allowed i.e. +1908-234-1234 or 1908 234 1234 or 908-234-1234.', '+1-908-234-1234|1 908 234 1234|908 234 1234', '+1-908-234-1234|1 908 234 1234|908 234 1234', 'New Jersey');
INSERT INTO "public"."country_regions" VALUES (394, 10, '212', '(?:\+?1[ -]?)?212[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?212[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1212-234-1234 or 1212 234 1234 or 212-234-1234.', 'Only +digits or local formats allowed i.e. +1212-234-1234 or 1212 234 1234 or 212-234-1234.', '+1-212-234-1234|1 212 234 1234|212 234 1234', '+1-212-234-1234|1 212 234 1234|212 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (395, 10, '315', '(?:\+?1[ -]?)?315[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?315[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1315-234-1234 or 1315 234 1234 or 315-234-1234.', 'Only +digits or local formats allowed i.e. +1315-234-1234 or 1315 234 1234 or 315-234-1234.', '+1-315-234-1234|1 315 234 1234|315 234 1234', '+1-315-234-1234|1 315 234 1234|315 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (396, 10, '845', '(?:\+?1[ -]?)?845[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?845[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1845-234-1234 or 1845 234 1234 or 845-234-1234.', 'Only +digits or local formats allowed i.e. +1845-234-1234 or 1845 234 1234 or 845-234-1234.', '+1-845-234-1234|1 845 234 1234|845 234 1234', '+1-845-234-1234|1 845 234 1234|845 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (397, 10, '929', '(?:\+?1[ -]?)?929[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?929[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1929-234-1234 or 1929 234 1234 or 929-234-1234.', 'Only +digits or local formats allowed i.e. +1929-234-1234 or 1929 234 1234 or 929-234-1234.', '+1-929-234-1234|1 929 234 1234|929 234 1234', '+1-929-234-1234|1 929 234 1234|929 234 1234', 'New York');
INSERT INTO "public"."country_regions" VALUES (398, 10, '216', '(?:\+?1[ -]?)?216[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?216[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1216-234-1234 or 1216 234 1234 or 216-234-1234.', 'Only +digits or local formats allowed i.e. +1216-234-1234 or 1216 234 1234 or 216-234-1234.', '+1-216-234-1234|1 216 234 1234|216 234 1234', '+1-216-234-1234|1 216 234 1234|216 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (399, 10, '330', '(?:\+?1[ -]?)?330[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?330[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1330-234-1234 or 1330 234 1234 or 330-234-1234.', 'Only +digits or local formats allowed i.e. +1330-234-1234 or 1330 234 1234 or 330-234-1234.', '+1-330-234-1234|1 330 234 1234|330 234 1234', '+1-330-234-1234|1 330 234 1234|330 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (400, 10, '419', '(?:\+?1[ -]?)?419[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?419[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1419-234-1234 or 1419 234 1234 or 419-234-1234.', 'Only +digits or local formats allowed i.e. +1419-234-1234 or 1419 234 1234 or 419-234-1234.', '+1-419-234-1234|1 419 234 1234|419 234 1234', '+1-419-234-1234|1 419 234 1234|419 234 1234', 'Ohio');
INSERT INTO "public"."country_regions" VALUES (401, 10, '541', '(?:\+?1[ -]?)?541[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?541[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1541-234-1234 or 1541 234 1234 or 541-234-1234.', 'Only +digits or local formats allowed i.e. +1541-234-1234 or 1541 234 1234 or 541-234-1234.', '+1-541-234-1234|1 541 234 1234|541 234 1234', '+1-541-234-1234|1 541 234 1234|541 234 1234', 'Oregon');
INSERT INTO "public"."country_regions" VALUES (402, 10, '231', '(?:\+?1[ -]?)?231[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?231[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1231-234-1234 or 1231 234 1234 or 231-234-1234.', 'Only +digits or local formats allowed i.e. +1231-234-1234 or 1231 234 1234 or 231-234-1234.', '+1-231-234-1234|1 231 234 1234|231 234 1234', '+1-231-234-1234|1 231 234 1234|231 234 1234', 'Michigan');
INSERT INTO "public"."country_regions" VALUES (403, 10, '843', '(?:\+?1[ -]?)?843[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?843[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1843-234-1234 or 1843 234 1234 or 843-234-1234.', 'Only +digits or local formats allowed i.e. +1843-234-1234 or 1843 234 1234 or 843-234-1234.', '+1-843-234-1234|1 843 234 1234|843 234 1234', '+1-843-234-1234|1 843 234 1234|843 234 1234', 'South Carolina');
INSERT INTO "public"."country_regions" VALUES (404, 10, '281', '(?:\+?1[ -]?)?281[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?281[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1281-234-1234 or 1281 234 1234 or 281-234-1234.', 'Only +digits or local formats allowed i.e. +1281-234-1234 or 1281 234 1234 or 281-234-1234.', '+1-281-234-1234|1 281 234 1234|281 234 1234', '+1-281-234-1234|1 281 234 1234|281 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (405, 10, '409', '(?:\+?1[ -]?)?409[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?409[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1409-234-1234 or 1409 234 1234 or 409-234-1234.', 'Only +digits or local formats allowed i.e. +1409-234-1234 or 1409 234 1234 or 409-234-1234.', '+1-409-234-1234|1 409 234 1234|409 234 1234', '+1-409-234-1234|1 409 234 1234|409 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (406, 10, '915', '(?:\+?1[ -]?)?915[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?915[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1915-234-1234 or 1915 234 1234 or 915-234-1234.', 'Only +digits or local formats allowed i.e. +1915-234-1234 or 1915 234 1234 or 915-234-1234.', '+1-915-234-1234|1 915 234 1234|915 234 1234', '+1-915-234-1234|1 915 234 1234|915 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (407, 10, '945', '(?:\+?1[ -]?)?945[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?945[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1945-234-1234 or 1945 234 1234 or 945-234-1234.', 'Only +digits or local formats allowed i.e. +1945-234-1234 or 1945 234 1234 or 945-234-1234.', '+1-945-234-1234|1 945 234 1234|945 234 1234', '+1-945-234-1234|1 945 234 1234|945 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (408, 10, '826', '(?:\+?1[ -]?)?826[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?826[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1826-234-1234 or 1826 234 1234 or 826-234-1234.', 'Only +digits or local formats allowed i.e. +1826-234-1234 or 1826 234 1234 or 826-234-1234.', '+1-826-234-1234|1 826 234 1234|826 234 1234', '+1-826-234-1234|1 826 234 1234|826 234 1234', 'Virginia');
INSERT INTO "public"."country_regions" VALUES (409, 10, '206', '(?:\+?1[ -]?)?206[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?206[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1206-234-1234 or 1206 234 1234 or 206-234-1234.', 'Only +digits or local formats allowed i.e. +1206-234-1234 or 1206 234 1234 or 206-234-1234.', '+1-206-234-1234|1 206 234 1234|206 234 1234', '+1-206-234-1234|1 206 234 1234|206 234 1234', 'Washington');
INSERT INTO "public"."country_regions" VALUES (410, 10, '608', '(?:\+?1[ -]?)?608[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?608[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1608-234-1234 or 1608 234 1234 or 608-234-1234.', 'Only +digits or local formats allowed i.e. +1608-234-1234 or 1608 234 1234 or 608-234-1234.', '+1-608-234-1234|1 608 234 1234|608 234 1234', '+1-608-234-1234|1 608 234 1234|608 234 1234', 'Wisconsin');
INSERT INTO "public"."country_regions" VALUES (411, 10, '479', '(?:\+?1[ -]?)?479[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?479[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1479-234-1234 or 1479 234 1234 or 479-234-1234.', 'Only +digits or local formats allowed i.e. +1479-234-1234 or 1479 234 1234 or 479-234-1234.', '+1-479-234-1234|1 479 234 1234|479 234 1234', '+1-479-234-1234|1 479 234 1234|479 234 1234', 'Arkansas');
INSERT INTO "public"."country_regions" VALUES (412, 10, '617', '(?:\+?1[ -]?)?617[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?617[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1617-234-1234 or 1617 234 1234 or 617-234-1234.', 'Only +digits or local formats allowed i.e. +1617-234-1234 or 1617 234 1234 or 617-234-1234.', '+1-617-234-1234|1 617 234 1234|617 234 1234', '+1-617-234-1234|1 617 234 1234|617 234 1234', 'Massachusetts');
INSERT INTO "public"."country_regions" VALUES (413, 10, '215', '(?:\+?1[ -]?)?215[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?215[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1215-234-1234 or 1215 234 1234 or 215-234-1234.', 'Only +digits or local formats allowed i.e. +1215-234-1234 or 1215 234 1234 or 215-234-1234.', '+1-215-234-1234|1 215 234 1234|215 234 1234', '+1-215-234-1234|1 215 234 1234|215 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (414, 10, '878', '(?:\+?1[ -]?)?878[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?878[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1878-234-1234 or 1878 234 1234 or 878-234-1234.', 'Only +digits or local formats allowed i.e. +1878-234-1234 or 1878 234 1234 or 878-234-1234.', '+1-878-234-1234|1 878 234 1234|878 234 1234', '+1-878-234-1234|1 878 234 1234|878 234 1234', 'Pennsylvania');
INSERT INTO "public"."country_regions" VALUES (415, 10, '361', '(?:\+?1[ -]?)?361[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?361[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1361-234-1234 or 1361 234 1234 or 361-234-1234.', 'Only +digits or local formats allowed i.e. +1361-234-1234 or 1361 234 1234 or 361-234-1234.', '+1-361-234-1234|1 361 234 1234|361 234 1234', '+1-361-234-1234|1 361 234 1234|361 234 1234', 'Texas');
INSERT INTO "public"."country_regions" VALUES (416, 10, '700', '(?:\+?1[ -]?)?700[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?700[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1700-234-1234 or 1700 234 1234 or 700-234-1234.', 'Only +digits or local formats allowed i.e. +1700-234-1234 or 1700 234 1234 or 700-234-1234.', '+1-700-234-1234|1 700 234 1234|700 234 1234', '+1-700-234-1234|1 700 234 1234|700 234 1234', 'Interexchange carrier-specific services');
INSERT INTO "public"."country_regions" VALUES (417, 10, '500', '(?:\+?1[ -]?)?500[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?500[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1500-234-1234 or 1500 234 1234 or 500-234-1234.', 'Only +digits or local formats allowed i.e. +1500-234-1234 or 1500 234 1234 or 500-234-1234.', '+1-500-234-1234|1 500 234 1234|500 234 1234', '+1-500-234-1234|1 500 234 1234|500 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (418, 10, '521', '(?:\+?1[ -]?)?521[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?521[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1521-234-1234 or 1521 234 1234 or 521-234-1234.', 'Only +digits or local formats allowed i.e. +1521-234-1234 or 1521 234 1234 or 521-234-1234.', '+1-521-234-1234|1 521 234 1234|521 234 1234', '+1-521-234-1234|1 521 234 1234|521 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (419, 10, '522', '(?:\+?1[ -]?)?522[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?522[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1522-234-1234 or 1522 234 1234 or 522-234-1234.', 'Only +digits or local formats allowed i.e. +1522-234-1234 or 1522 234 1234 or 522-234-1234.', '+1-522-234-1234|1 522 234 1234|522 234 1234', '+1-522-234-1234|1 522 234 1234|522 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (420, 10, '523', '(?:\+?1[ -]?)?523[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?523[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1523-234-1234 or 1523 234 1234 or 523-234-1234.', 'Only +digits or local formats allowed i.e. +1523-234-1234 or 1523 234 1234 or 523-234-1234.', '+1-523-234-1234|1 523 234 1234|523 234 1234', '+1-523-234-1234|1 523 234 1234|523 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (421, 10, '524', '(?:\+?1[ -]?)?524[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?524[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1524-234-1234 or 1524 234 1234 or 524-234-1234.', 'Only +digits or local formats allowed i.e. +1524-234-1234 or 1524 234 1234 or 524-234-1234.', '+1-524-234-1234|1 524 234 1234|524 234 1234', '+1-524-234-1234|1 524 234 1234|524 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (422, 10, '525', '(?:\+?1[ -]?)?525[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?525[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1525-234-1234 or 1525 234 1234 or 525-234-1234.', 'Only +digits or local formats allowed i.e. +1525-234-1234 or 1525 234 1234 or 525-234-1234.', '+1-525-234-1234|1 525 234 1234|525 234 1234', '+1-525-234-1234|1 525 234 1234|525 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (423, 10, '526', '(?:\+?1[ -]?)?526[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?526[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1526-234-1234 or 1526 234 1234 or 526-234-1234.', 'Only +digits or local formats allowed i.e. +1526-234-1234 or 1526 234 1234 or 526-234-1234.', '+1-526-234-1234|1 526 234 1234|526 234 1234', '+1-526-234-1234|1 526 234 1234|526 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (424, 10, '527', '(?:\+?1[ -]?)?527[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?527[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1527-234-1234 or 1527 234 1234 or 527-234-1234.', 'Only +digits or local formats allowed i.e. +1527-234-1234 or 1527 234 1234 or 527-234-1234.', '+1-527-234-1234|1 527 234 1234|527 234 1234', '+1-527-234-1234|1 527 234 1234|527 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (425, 10, '528', '(?:\+?1[ -]?)?528[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?528[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1528-234-1234 or 1528 234 1234 or 528-234-1234.', 'Only +digits or local formats allowed i.e. +1528-234-1234 or 1528 234 1234 or 528-234-1234.', '+1-528-234-1234|1 528 234 1234|528 234 1234', '+1-528-234-1234|1 528 234 1234|528 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (426, 10, '529', '(?:\+?1[ -]?)?529[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?529[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1529-234-1234 or 1529 234 1234 or 529-234-1234.', 'Only +digits or local formats allowed i.e. +1529-234-1234 or 1529 234 1234 or 529-234-1234.', '+1-529-234-1234|1 529 234 1234|529 234 1234', '+1-529-234-1234|1 529 234 1234|529 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (427, 10, '532', '(?:\+?1[ -]?)?532[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?532[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1532-234-1234 or 1532 234 1234 or 532-234-1234.', 'Only +digits or local formats allowed i.e. +1532-234-1234 or 1532 234 1234 or 532-234-1234.', '+1-532-234-1234|1 532 234 1234|532 234 1234', '+1-532-234-1234|1 532 234 1234|532 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (428, 10, '533', '(?:\+?1[ -]?)?533[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?533[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1533-234-1234 or 1533 234 1234 or 533-234-1234.', 'Only +digits or local formats allowed i.e. +1533-234-1234 or 1533 234 1234 or 533-234-1234.', '+1-533-234-1234|1 533 234 1234|533 234 1234', '+1-533-234-1234|1 533 234 1234|533 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (429, 10, '535', '(?:\+?1[ -]?)?535[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?535[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1535-234-1234 or 1535 234 1234 or 535-234-1234.', 'Only +digits or local formats allowed i.e. +1535-234-1234 or 1535 234 1234 or 535-234-1234.', '+1-535-234-1234|1 535 234 1234|535 234 1234', '+1-535-234-1234|1 535 234 1234|535 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (430, 10, '538', '(?:\+?1[ -]?)?538[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?538[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1538-234-1234 or 1538 234 1234 or 538-234-1234.', 'Only +digits or local formats allowed i.e. +1538-234-1234 or 1538 234 1234 or 538-234-1234.', '+1-538-234-1234|1 538 234 1234|538 234 1234', '+1-538-234-1234|1 538 234 1234|538 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (431, 10, '542', '(?:\+?1[ -]?)?542[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?542[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1542-234-1234 or 1542 234 1234 or 542-234-1234.', 'Only +digits or local formats allowed i.e. +1542-234-1234 or 1542 234 1234 or 542-234-1234.', '+1-542-234-1234|1 542 234 1234|542 234 1234', '+1-542-234-1234|1 542 234 1234|542 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (432, 10, '543', '(?:\+?1[ -]?)?543[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?543[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1543-234-1234 or 1543 234 1234 or 543-234-1234.', 'Only +digits or local formats allowed i.e. +1543-234-1234 or 1543 234 1234 or 543-234-1234.', '+1-543-234-1234|1 543 234 1234|543 234 1234', '+1-543-234-1234|1 543 234 1234|543 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (433, 10, '544', '(?:\+?1[ -]?)?544[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?544[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1544-234-1234 or 1544 234 1234 or 544-234-1234.', 'Only +digits or local formats allowed i.e. +1544-234-1234 or 1544 234 1234 or 544-234-1234.', '+1-544-234-1234|1 544 234 1234|544 234 1234', '+1-544-234-1234|1 544 234 1234|544 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (434, 10, '545', '(?:\+?1[ -]?)?545[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?545[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1545-234-1234 or 1545 234 1234 or 545-234-1234.', 'Only +digits or local formats allowed i.e. +1545-234-1234 or 1545 234 1234 or 545-234-1234.', '+1-545-234-1234|1 545 234 1234|545 234 1234', '+1-545-234-1234|1 545 234 1234|545 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (435, 10, '546', '(?:\+?1[ -]?)?546[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?546[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1546-234-1234 or 1546 234 1234 or 546-234-1234.', 'Only +digits or local formats allowed i.e. +1546-234-1234 or 1546 234 1234 or 546-234-1234.', '+1-546-234-1234|1 546 234 1234|546 234 1234', '+1-546-234-1234|1 546 234 1234|546 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (436, 10, '547', '(?:\+?1[ -]?)?547[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?547[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1547-234-1234 or 1547 234 1234 or 547-234-1234.', 'Only +digits or local formats allowed i.e. +1547-234-1234 or 1547 234 1234 or 547-234-1234.', '+1-547-234-1234|1 547 234 1234|547 234 1234', '+1-547-234-1234|1 547 234 1234|547 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (437, 10, '549', '(?:\+?1[ -]?)?549[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?549[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1549-234-1234 or 1549 234 1234 or 549-234-1234.', 'Only +digits or local formats allowed i.e. +1549-234-1234 or 1549 234 1234 or 549-234-1234.', '+1-549-234-1234|1 549 234 1234|549 234 1234', '+1-549-234-1234|1 549 234 1234|549 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (438, 10, '550', '(?:\+?1[ -]?)?550[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?550[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1550-234-1234 or 1550 234 1234 or 550-234-1234.', 'Only +digits or local formats allowed i.e. +1550-234-1234 or 1550 234 1234 or 550-234-1234.', '+1-550-234-1234|1 550 234 1234|550 234 1234', '+1-550-234-1234|1 550 234 1234|550 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (439, 10, '552', '(?:\+?1[ -]?)?552[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?552[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1552-234-1234 or 1552 234 1234 or 552-234-1234.', 'Only +digits or local formats allowed i.e. +1552-234-1234 or 1552 234 1234 or 552-234-1234.', '+1-552-234-1234|1 552 234 1234|552 234 1234', '+1-552-234-1234|1 552 234 1234|552 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (440, 10, '553', '(?:\+?1[ -]?)?553[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?553[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1553-234-1234 or 1553 234 1234 or 553-234-1234.', 'Only +digits or local formats allowed i.e. +1553-234-1234 or 1553 234 1234 or 553-234-1234.', '+1-553-234-1234|1 553 234 1234|553 234 1234', '+1-553-234-1234|1 553 234 1234|553 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (441, 10, '554', '(?:\+?1[ -]?)?554[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?554[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1554-234-1234 or 1554 234 1234 or 554-234-1234.', 'Only +digits or local formats allowed i.e. +1554-234-1234 or 1554 234 1234 or 554-234-1234.', '+1-554-234-1234|1 554 234 1234|554 234 1234', '+1-554-234-1234|1 554 234 1234|554 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (442, 10, '556', '(?:\+?1[ -]?)?556[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?556[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1556-234-1234 or 1556 234 1234 or 556-234-1234.', 'Only +digits or local formats allowed i.e. +1556-234-1234 or 1556 234 1234 or 556-234-1234.', '+1-556-234-1234|1 556 234 1234|556 234 1234', '+1-556-234-1234|1 556 234 1234|556 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (443, 10, '566', '(?:\+?1[ -]?)?566[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?566[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1566-234-1234 or 1566 234 1234 or 566-234-1234.', 'Only +digits or local formats allowed i.e. +1566-234-1234 or 1566 234 1234 or 566-234-1234.', '+1-566-234-1234|1 566 234 1234|566 234 1234', '+1-566-234-1234|1 566 234 1234|566 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (444, 10, '558', '(?:\+?1[ -]?)?558[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?558[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1558-234-1234 or 1558 234 1234 or 558-234-1234.', 'Only +digits or local formats allowed i.e. +1558-234-1234 or 1558 234 1234 or 558-234-1234.', '+1-558-234-1234|1 558 234 1234|558 234 1234', '+1-558-234-1234|1 558 234 1234|558 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (445, 10, '569', '(?:\+?1[ -]?)?569[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?569[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1569-234-1234 or 1569 234 1234 or 569-234-1234.', 'Only +digits or local formats allowed i.e. +1569-234-1234 or 1569 234 1234 or 569-234-1234.', '+1-569-234-1234|1 569 234 1234|569 234 1234', '+1-569-234-1234|1 569 234 1234|569 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (446, 10, '577', '(?:\+?1[ -]?)?577[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?577[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1577-234-1234 or 1577 234 1234 or 577-234-1234.', 'Only +digits or local formats allowed i.e. +1577-234-1234 or 1577 234 1234 or 577-234-1234.', '+1-577-234-1234|1 577 234 1234|577 234 1234', '+1-577-234-1234|1 577 234 1234|577 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (447, 10, '578', '(?:\+?1[ -]?)?578[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?578[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1578-234-1234 or 1578 234 1234 or 578-234-1234.', 'Only +digits or local formats allowed i.e. +1578-234-1234 or 1578 234 1234 or 578-234-1234.', '+1-578-234-1234|1 578 234 1234|578 234 1234', '+1-578-234-1234|1 578 234 1234|578 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (448, 10, '588', '(?:\+?1[ -]?)?588[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?588[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1588-234-1234 or 1588 234 1234 or 588-234-1234.', 'Only +digits or local formats allowed i.e. +1588-234-1234 or 1588 234 1234 or 588-234-1234.', '+1-588-234-1234|1 588 234 1234|588 234 1234', '+1-588-234-1234|1 588 234 1234|588 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (449, 10, '589', '(?:\+?1[ -]?)?589[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?589[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1589-234-1234 or 1589 234 1234 or 589-234-1234.', 'Only +digits or local formats allowed i.e. +1589-234-1234 or 1589 234 1234 or 589-234-1234.', '+1-589-234-1234|1 589 234 1234|589 234 1234', '+1-589-234-1234|1 589 234 1234|589 234 1234', 'Personal communications services');
INSERT INTO "public"."country_regions" VALUES (450, 10, '900', '(?:\+?1[ -]?)?900[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?900[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1900-234-1234 or 1900 234 1234 or 900-234-1234.', 'Only +digits or local formats allowed i.e. +1900-234-1234 or 1900 234 1234 or 900-234-1234.', '+1-900-234-1234|1 900 234 1234|900 234 1234', '+1-900-234-1234|1 900 234 1234|900 234 1234', 'Premium call services');
INSERT INTO "public"."country_regions" VALUES (451, 10, '800', '(?:\+?1[ -]?)?800[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?800[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1800-234-1234 or 1800 234 1234 or 800-234-1234.', 'Only +digits or local formats allowed i.e. +1800-234-1234 or 1800 234 1234 or 800-234-1234.', '+1-800-234-1234|1 800 234 1234|800 234 1234', '+1-800-234-1234|1 800 234 1234|800 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (452, 10, '822', '(?:\+?1[ -]?)?822[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?822[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1822-234-1234 or 1822 234 1234 or 822-234-1234.', 'Only +digits or local formats allowed i.e. +1822-234-1234 or 1822 234 1234 or 822-234-1234.', '+1-822-234-1234|1 822 234 1234|822 234 1234', '+1-822-234-1234|1 822 234 1234|822 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (453, 10, '833', '(?:\+?1[ -]?)?833[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?833[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1833-234-1234 or 1833 234 1234 or 833-234-1234.', 'Only +digits or local formats allowed i.e. +1833-234-1234 or 1833 234 1234 or 833-234-1234.', '+1-833-234-1234|1 833 234 1234|833 234 1234', '+1-833-234-1234|1 833 234 1234|833 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (454, 10, '844', '(?:\+?1[ -]?)?844[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?844[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1844-234-1234 or 1844 234 1234 or 844-234-1234.', 'Only +digits or local formats allowed i.e. +1844-234-1234 or 1844 234 1234 or 844-234-1234.', '+1-844-234-1234|1 844 234 1234|844 234 1234', '+1-844-234-1234|1 844 234 1234|844 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (455, 10, '855', '(?:\+?1[ -]?)?855[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?855[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1855-234-1234 or 1855 234 1234 or 855-234-1234.', 'Only +digits or local formats allowed i.e. +1855-234-1234 or 1855 234 1234 or 855-234-1234.', '+1-855-234-1234|1 855 234 1234|855 234 1234', '+1-855-234-1234|1 855 234 1234|855 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (456, 10, '866', '(?:\+?1[ -]?)?866[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?866[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1866-234-1234 or 1866 234 1234 or 866-234-1234.', 'Only +digits or local formats allowed i.e. +1866-234-1234 or 1866 234 1234 or 866-234-1234.', '+1-866-234-1234|1 866 234 1234|866 234 1234', '+1-866-234-1234|1 866 234 1234|866 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (457, 10, '877', '(?:\+?1[ -]?)?877[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?877[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1877-234-1234 or 1877 234 1234 or 877-234-1234.', 'Only +digits or local formats allowed i.e. +1877-234-1234 or 1877 234 1234 or 877-234-1234.', '+1-877-234-1234|1 877 234 1234|877 234 1234', '+1-877-234-1234|1 877 234 1234|877 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (458, 10, '880', '(?:\+?1[ -]?)?880[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?880[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1880-234-1234 or 1880 234 1234 or 880-234-1234.', 'Only +digits or local formats allowed i.e. +1880-234-1234 or 1880 234 1234 or 880-234-1234.', '+1-880-234-1234|1 880 234 1234|880 234 1234', '+1-880-234-1234|1 880 234 1234|880 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (459, 10, '881', '(?:\+?1[ -]?)?881[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?881[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1881-234-1234 or 1881 234 1234 or 881-234-1234.', 'Only +digits or local formats allowed i.e. +1881-234-1234 or 1881 234 1234 or 881-234-1234.', '+1-881-234-1234|1 881 234 1234|881 234 1234', '+1-881-234-1234|1 881 234 1234|881 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (460, 10, '882', '(?:\+?1[ -]?)?882[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?882[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1882-234-1234 or 1882 234 1234 or 882-234-1234.', 'Only +digits or local formats allowed i.e. +1882-234-1234 or 1882 234 1234 or 882-234-1234.', '+1-882-234-1234|1 882 234 1234|882 234 1234', '+1-882-234-1234|1 882 234 1234|882 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (461, 10, '883', '(?:\+?1[ -]?)?883[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?883[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1883-234-1234 or 1883 234 1234 or 883-234-1234.', 'Only +digits or local formats allowed i.e. +1883-234-1234 or 1883 234 1234 or 883-234-1234.', '+1-883-234-1234|1 883 234 1234|883 234 1234', '+1-883-234-1234|1 883 234 1234|883 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (462, 10, '884', '(?:\+?1[ -]?)?884[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?884[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1884-234-1234 or 1884 234 1234 or 884-234-1234.', 'Only +digits or local formats allowed i.e. +1884-234-1234 or 1884 234 1234 or 884-234-1234.', '+1-884-234-1234|1 884 234 1234|884 234 1234', '+1-884-234-1234|1 884 234 1234|884 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (463, 10, '885', '(?:\+?1[ -]?)?885[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?885[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1885-234-1234 or 1885 234 1234 or 885-234-1234.', 'Only +digits or local formats allowed i.e. +1885-234-1234 or 1885 234 1234 or 885-234-1234.', '+1-885-234-1234|1 885 234 1234|885 234 1234', '+1-885-234-1234|1 885 234 1234|885 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (464, 10, '886', '(?:\+?1[ -]?)?886[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?886[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1886-234-1234 or 1886 234 1234 or 886-234-1234.', 'Only +digits or local formats allowed i.e. +1886-234-1234 or 1886 234 1234 or 886-234-1234.', '+1-886-234-1234|1 886 234 1234|886 234 1234', '+1-886-234-1234|1 886 234 1234|886 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (465, 10, '887', '(?:\+?1[ -]?)?887[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?887[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1887-234-1234 or 1887 234 1234 or 887-234-1234.', 'Only +digits or local formats allowed i.e. +1887-234-1234 or 1887 234 1234 or 887-234-1234.', '+1-887-234-1234|1 887 234 1234|887 234 1234', '+1-887-234-1234|1 887 234 1234|887 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (466, 10, '888', '(?:\+?1[ -]?)?888[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?888[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1888-234-1234 or 1888 234 1234 or 888-234-1234.', 'Only +digits or local formats allowed i.e. +1888-234-1234 or 1888 234 1234 or 888-234-1234.', '+1-888-234-1234|1 888 234 1234|888 234 1234', '+1-888-234-1234|1 888 234 1234|888 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (467, 10, '889', '(?:\+?1[ -]?)?889[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?889[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1889-234-1234 or 1889 234 1234 or 889-234-1234.', 'Only +digits or local formats allowed i.e. +1889-234-1234 or 1889 234 1234 or 889-234-1234.', '+1-889-234-1234|1 889 234 1234|889 234 1234', '+1-889-234-1234|1 889 234 1234|889 234 1234', 'Toll-free');
INSERT INTO "public"."country_regions" VALUES (468, 10, '710', '(?:\+?1[ -]?)?710[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?710[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1710-234-1234 or 1710 234 1234 or 710-234-1234.', 'Only +digits or local formats allowed i.e. +1710-234-1234 or 1710 234 1234 or 710-234-1234.', '+1-710-234-1234|1 710 234 1234|710 234 1234', '+1-710-234-1234|1 710 234 1234|710 234 1234', 'US government');
INSERT INTO "public"."country_regions" VALUES (473, 15, '787', '(?:\+?1[ -]?)?787[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?787[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1787-234-1234 or 1787 234 1234 or 787-234-1234.', 'Only +digits or local formats allowed i.e. +1787-234-1234 or 1787 234 1234 or 787-234-1234.', '+1-787-234-1234|1 787 234 1234|787 234 1234', '+1-787-234-1234|1 787 234 1234|787 234 1234', 'Puerto Rico');
INSERT INTO "public"."country_regions" VALUES (472, 14, '869', '(?:\+?1[ -]?)?869[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?869[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1869-234-1234 or 1869 234 1234 or 869-234-1234.', 'Only +digits or local formats allowed i.e. +1869-234-1234 or 1869 234 1234 or 869-234-1234.', '+1-869-234-1234|1 869 234 1234|869 234 1234', '+1-869-234-1234|1 869 234 1234|869 234 1234', 'Saint Kitts and Nevis');
INSERT INTO "public"."country_regions" VALUES (469, 11, '242', '(?:\+?1[ -]?)?242[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?242[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1242-234-1234 or 1242 234 1234 or 242-234-1234.', 'Only +digits or local formats allowed i.e. +1242-234-1234 or 1242 234 1234 or 242-234-1234.', '+1-242-234-1234|1 242 234 1234|242 234 1234', '+1-242-234-1234|1 242 234 1234|242 234 1234', 'The Bahamas');
INSERT INTO "public"."country_regions" VALUES (471, 13, '868', '(?:\+?1[ -]?)?868[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?868[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1868-234-1234 or 1868 234 1234 or 868-234-1234.', 'Only +digits or local formats allowed i.e. +1868-234-1234 or 1868 234 1234 or 868-234-1234.', '+1-868-234-1234|1 868 234 1234|868 234 1234', '+1-868-234-1234|1 868 234 1234|868 234 1234', 'Trinidad and Tobago');
INSERT INTO "public"."country_regions" VALUES (488, 26, '340', '(?:\+?1[ -]?)?340[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?340[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1340-234-1234 or 1340 234 1234 or 340-234-1234.', 'Only +digits or local formats allowed i.e. +1340-234-1234 or 1340 234 1234 or 240-234-1234.', '+1-340-234-1234|1 340 234 1234|340 234 1234', '+1-340-234-1234|1 340 234 1234|340 234 1234', 'Virgin Islands');
INSERT INTO "public"."country_regions" VALUES (491, 27, '3', '(?:\+?61[ -]?)?3[ -]?[2-9]\d{3}[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +613-9567-2876 or (03) 9567 2876 or 0395672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+613-9567-2876|(03) 9567 2876|0395672876', '+61438-567-876|0438 567 876|0438567876', 'New South Wales => Buronga');
INSERT INTO "public"."country_regions" VALUES (492, 27, '2', '(?:\+?61[ -]?)?2[ -]?[2-9]\d{3}[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +612-9567-2876 or (02) 9567 2876 or 0295672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+612-9567-2876|(02) 9567 2876|0295672876', '+61438-567-876|0438 567 876|0438567876', 'New South Wales');
INSERT INTO "public"."country_regions" VALUES (490, 27, '2', '(?:\+?61[ -]?)?2[ -]?[2-9]\d{3}[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +612-9567-2876 or (02) 9567 2876 or 0295672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+612-9567-2876|(02) 9567 2876|0295672876', '+61438-567-876|0438 567 876|0438567876', 'Victoria => Wodonga');
INSERT INTO "public"."country_regions" VALUES (487, 25, '268', '(?:\+?1[ -]?)?268[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?268[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1268-234-1234 or 1268 234 1234 or 268-234-1234.', 'Only +digits or local formats allowed i.e. +1268-234-1234 or 1248 234 1234 or 248-234-1234.', '+1-248-234-1234|1 248 234 1234|248 234 1234', '+1-248-234-1234|1 248 234 1234|248 234 1234', 'Antigua and Barbuda');
INSERT INTO "public"."country_regions" VALUES (483, 21, '246', '(?:\+?1[ -]?)?246[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?246[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1246-234-1234 or 1246 234 1234 or 246-234-1234.', 'Only +digits or local formats allowed i.e. +1246-234-1234 or 1246 234 1234 or 246-234-1234.', '+1-246-234-1234|1 242 234 1234|242 234 1234', '+1-246-234-1234|1 246 234 1234|246 234 1234', 'Barbados');
INSERT INTO "public"."country_regions" VALUES (482, 20, '284', '(?:\+?1[ -]?)?284[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?284[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1284-234-1234 or 1284 234 1234 or 284-234-1234.', 'Only +digits or local formats allowed i.e. +1284-234-1234 or 1284 234 1234 or 284-234-1234.', '+1-248-234-1234|1 248 234 1234|248 234 1234', '+1-284-234-1234|1 284 234 1234|284 234 1234', 'Virgin Islands');
INSERT INTO "public"."country_regions" VALUES (481, 19, '767', '(?:\+?1[ -]?)?767[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?767[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1767-234-1234 or 1767 234 1234 or 767-234-1234.', 'Only +digits or local formats allowed i.e. +1767-234-1234 or 1767 234 1234 or 767-234-1234.', '+1-767-234-1234|1 767 234 1234|767 234 1234', '+1-767-234-1234|1 767 234 1234|767 234 1234', 'Dominica');
INSERT INTO "public"."country_regions" VALUES (475, 16, '809', '(?:\+?1[ -]?)?809[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?809[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1809-234-1234 or 1809 234 1234 or 809-234-1234.', 'Only +digits or local formats allowed i.e. +1809-234-1234 or 1809 234 1234 or 809-234-1234.', '+1-809-234-1234|1 809 234 1234|809 234 1234', '+1-809-234-1234|1 809 234 1234|809 234 1234', 'Dominican Republic');
INSERT INTO "public"."country_regions" VALUES (476, 16, '829', '(?:\+?1[ -]?)?829[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?829[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1829-234-1234 or 1829 234 1234 or 829-234-1234.', 'Only +digits or local formats allowed i.e. +1829-234-1234 or 1829 234 1234 or 829-234-1234.', '+1-829-234-1234|1 829 234 1234|829 234 1234', '+1-829-234-1234|1 829 234 1234|829 234 1234', 'Dominican Republic');
INSERT INTO "public"."country_regions" VALUES (486, 24, '473', '(?:\+?1[ -]?)?473[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?473[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1473-234-1234 or 1473 234 1234 or 473-234-1234.', 'Only +digits or local formats allowed i.e. +1473-234-1234 or 1473 234 1234 or 473-234-1234.', '+1-473-234-1234|1 473 234 1234|473 234 1234', '+1-473-234-1234|1 473 234 1234|473 234 1234', 'Grenada');
INSERT INTO "public"."country_regions" VALUES (477, 16, '849', '(?:\+?1[ -]?)?849[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?849[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1849-234-1234 or 1849 234 1234 or 829-234-1234.', 'Only +digits or local formats allowed i.e. +1849-234-1234 or 1829 234 1234 or 829-234-1234.', '+1-849-234-1234|1 849 234 1234|849 234 1234', '+1-849-234-1234|1 849 234 1234|849 234 1234', 'Dominican Republic');
INSERT INTO "public"."country_regions" VALUES (479, 17, '876', '(?:\+?1[ -]?)?876[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?876[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1876-234-1234 or 1876 234 1234 or 876-234-1234.', 'Only +digits or local formats allowed i.e. +1876-234-1234 or 1876 234 1234 or 876-234-1234.', '+1-876-234-1234|1 876 234 1234|876 234 1234', '+1-876-234-1234|1 876 234 1234|876 234 1234', 'Jamaica');
INSERT INTO "public"."country_regions" VALUES (478, 17, '658', '(?:\+?1[ -]?)?658[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?658[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1658-234-1234 or 1658 234 1234 or 658-234-1234.', 'Only +digits or local formats allowed i.e. +1658-234-1234 or 1658 234 1234 or 658-234-1234.', '+1-658-234-1234|1 658 234 1234|658 234 1234', '+1-658-234-1234|1 658 234 1234|658 234 1234', 'Jamaica');
INSERT INTO "public"."country_regions" VALUES (484, 22, '664', '(?:\+?1[ -]?)?664[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?664[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1664-234-1234 or 1664 234 1234 or 664-234-1234.', 'Only +digits or local formats allowed i.e. +1664-234-1234 or 1664 234 1234 or 664-234-1234.', '+1-664-234-1234|1 664 234 1234|664 234 1234', '+1-664-234-1234|1 664 234 1234|664 234 1234', 'Montserrat');
INSERT INTO "public"."country_regions" VALUES (474, 15, '939', '(?:\+?1[ -]?)?939[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?939[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1939-234-1234 or 1939 234 1234 or 939-234-1234.', 'Only +digits or local formats allowed i.e. +1939-234-1234 or 1939 234 1234 or 939-234-1234.', '+1-939-234-1234|1 939 234 1234|939 234 1234', '+1-939-234-1234|1 939 234 1234|939 234 1234', 'Puerto Rico');
INSERT INTO "public"."country_regions" VALUES (485, 23, '721', '(?:\+?1[ -]?)?721[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?721[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1721-234-1234 or 1721 234 1234 or 721-234-1234.', 'Only +digits or local formats allowed i.e. +1721-234-1234 or 1721 234 1234 or 721-234-1234.', '+1-721-234-1234|1 721 234 1234|721 234 1234', '+1-721-234-1234|1 721 234 1234|721 234 1234', 'Sint Maarten');
INSERT INTO "public"."country_regions" VALUES (493, 27, '8', '(?:\+?61[ -]?)?8[ -]?[2-9]\d{3}[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +618-9567-2876 or (08) 9567 2876 or 0895672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+618-9567-2876|(08) 9567 2876|0895672876', '+61438-567-876|0438 567 876|0438567876', 'New South Wales => Broken Hill');
INSERT INTO "public"."country_regions" VALUES (4, 5, '684', '(?:\+?1[ -]?)?684[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?684[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1684-234-1234 or 1684 234 1234 or 684-234-1234.', 'Only +digits or local formats allowed i.e. +1684-234-1234 or 1684 234 1234 or 684-234-1234.', '+1-684-234-1234|1 684 234 1234|684 234 1234', '+1-684-234-1234|1 684 234 1234|684 234 1234', 'American Samoa');
INSERT INTO "public"."country_regions" VALUES (480, 18, '264', '(?:\+?1[ -]?)?264[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?264[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1264-234-1234 or 1264 234 1234 or 264-234-1234.', 'Only +digits or local formats allowed i.e. +1264-234-1234 or 1246 234 1234 or 246-234-1234.', '+1-246-234-1234|1 242 234 1234|242 234 1234', '+1-246-234-1234|1 246 234 1234|246 234 1234', 'Anguilla');
INSERT INTO "public"."country_regions" VALUES (494, 27, '3', '(?:\+?61[ -]?)?3[ -]?[2-9]\d{3}[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +613-9567-2876 or (03) 9567 2876 or 0395672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+613-9567-2876|(03) 9567 2876|0395672876', '+61438-567-876|0438 567 876|0438567876', 'New South Wales  => Deniliquin');
INSERT INTO "public"."country_regions" VALUES (495, 27, '3', '(?:\+?61[ -]?)?3[ -]?[2-9]\d{3}[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +613-9567-2876 or (03) 9567 2876 or 0395672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+613-9567-2876|(03) 9567 2876|0395672876', '+61438-567-876|0438 567 876|0438567876', 'Victoria');
INSERT INTO "public"."country_regions" VALUES (499, 27, '8', '(?:\+?61[ -]?)?8[ -]?[2-9]\d{3}[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +618-9567-2876 or (08) 9567 2876 or 0895672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+618-9567-2876|(08) 9567 2876|0895672876', '+61438-567-876|0438 567 876|0438567876', 'South  Australia');
INSERT INTO "public"."country_regions" VALUES (497, 27, '8', '(?:\+?61[ -]?)?8[ -]?[2-9]\d{3}[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +618-9567-2876 or (08) 9567 2876 or 0895672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+618-9567-2876|(08) 9567 2876|0895672876', '+61438-567-876|0438 567 876|0438567876', 'Northern Territory');
INSERT INTO "public"."country_regions" VALUES (498, 27, '8', '(?:\+?61[ -]?)?8[ -]?[2-9]\d{3}[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +618-9567-2876 or (08) 9567 2876 or 0895672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+618-9567-2876|(08) 9567 2876|0895672876', '+61438-567-876|0438 567 876|0438567876', 'Western Australia');
INSERT INTO "public"."country_regions" VALUES (496, 27, '7', '(?:\+?61[ -]?)?7[ -]?[2-9]\d{3}[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +617-9567-2876 or (07) 9567 2876 or 0795672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+617-9567-2876|(07) 9567 2876|0795672876', '+61438-567-876|0438 567 876|0438567876', 'Queensland');
INSERT INTO "public"."country_regions" VALUES (501, 43, '8', '(?:\+?61[ -]?)?8[ -]?9162[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +618-9162-2876 or (02) 9162 2876 or 0891622876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+618-9162-2876|(08) 9162 2876|0891622876', '+61438-567-876|0438 567 876|0438567876', 'Cocos (Keeling) Islands');
INSERT INTO "public"."country_regions" VALUES (470, 12, '671', '(?:\+?1[ -]?)?671[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?671[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1671-234-1234 or 1671 234 1234 or 671-234-1234.', 'Only +digits or local formats allowed i.e. +1671-234-1234 or 1671 234 1234 or 671-234-1234.', '+1-671-234-1234|1 671 234 1234|671 234 1234', '+1-671-234-1234|1 671 234 1234|671 234 1234', 'Guam');
INSERT INTO "public"."country_regions" VALUES (69, 9, '758', '(?:\+?1[ -]?)?758[ -]?[2-9]\d{2}[ -]?\d{4}', '(?:\+?1[ -]?)?758[ -]?[2-9]\d{2}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +1758-234-1234 or 1758 234 1234 or 758-234-1234.', 'Only +digits or local formats allowed i.e. +1758-234-1234 or 1758 234 1234 or 758-234-1234.', '+1-758-234-1234|1 758 234 1234|758   234 1234', '+1-758-234-1234|1 758 234 1234|758 234 1234', 'Saint Lucia');
INSERT INTO "public"."country_regions" VALUES (500, 42, '8', '(?:\+?61[ -]?)?8[ -]?[2-9]\d{3}[ -]?\d{4}', '(?:\+61|0)?4\d{2}[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +618-9567-2876 or (08) 9567 2876 or 0895672876.', 'Only +digits or local formats allowed. i.e. +61438-567-876 or 0438 567 876 or 0438567876', '+618-9567-2876|(08) 9567 2876|0895672876', '+61438-567-876|0438 567 876|0438567876', 'Christmas Island');
INSERT INTO "public"."country_regions" VALUES (503, 44, '6', '(?:\+?64[ -]?)6[ -]?75\d[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +646-756-2876 or (06) 756 2876 or 067562876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+646-756-2876|(06) 756 2876|067562876', '+64268-560-876|0260 567 876|0260567876', 'New Plymouth');
INSERT INTO "public"."country_regions" VALUES (504, 44, '4', '(?:\+?64[ -]?)4[ -]?52\d[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +644-5267-2876 or (04) 526 2876 or 045262876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+644-526-2876|(04) 526 2876|045262876', '+64268-560-876|0260 567 876|0260567876', 'Upper Hutt');
INSERT INTO "public"."country_regions" VALUES (505, 44, '4', '(?:\+?64[ -]?)4[ -]?23\d[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +644-2367-2876 or (04) 236 2876 or 042362876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+644-236-2876|(04) 236 2876|042362876', '+64268-560-876|0260 567 876|0260567876', 'Porirua');
INSERT INTO "public"."country_regions" VALUES (506, 44, '4', '(?:\+?64[ -]?)4[ -]?56\d[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +644-5667-2876 or (04) 566 2876 or 045662876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+644-756-2876|(04) 566 2876|045662876', '+64268-560-876|0260 567 876|0260567876', 'Lower Hutt');
INSERT INTO "public"."country_regions" VALUES (507, 44, '4', '(?:\+?64[ -]?)4[ -]?47\d[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +644-476-2876 or (04) 756 477 or 047472876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+644-476-2876|(04) 476 2876|044762876', '+64268-560-876|0260 567 876|0260567876', 'Wellington north');
INSERT INTO "public"."country_regions" VALUES (502, 44, '9', '(?:\+?64[ -]?)9[ -]?43\d[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +649-436-2876 or (09) 436 2876 or 094362876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0226067876', '+649-9567-2876|(09) 9567 2876|0995672876', '+64438-567-876|0438 567 876|0438567876', 'Whangarei');
INSERT INTO "public"."country_regions" VALUES (508, 44, '4', '(?:\+?64[ -]?)4[ -]?38\d[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +644-3867-2876 or (04) 386 2876 or 043862876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+644-756-2876|(04) 386 2876|043862876', '+64268-560-876|0260 567 876|0260567876', 'Wellington south');
INSERT INTO "public"."country_regions" VALUES (509, 44, '3', '(?:\+?64[ -]?)3[ -]?54\d[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +643-9567-2876 or (03) 756 2876 or 037562876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+643-546-2876|(03) 546 2876|035462876', '+64268-560-876|0260 567 876|0260567876', 'Nelson');
INSERT INTO "public"."country_regions" VALUES (510, 44, '3', '(?:\+?64[ -]?)3[ -]?319[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +643-319-2876 or (03) 319 2876 or 033192876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+643-756-2876|(03) 756 2876|037562876', '+64268-560-876|0260 567 876|0260567876', 'Kaikoura');
INSERT INTO "public"."country_regions" VALUES (511, 44, '3', '(?:\+?64[ -]?)3[ -]?4\d{2}[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +643-456-2876 or (03) 456 2876 or 034562876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+643-456-2876|(03) 456 2876|034562876', '+64268-560-876|0260 567 876|0260567876', 'Dunedin');
INSERT INTO "public"."country_regions" VALUES (512, 44, '3', '(?:\+?64[ -]?)3[ -]?21\d[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +643-216-2876 or (03) 216 2876 or 032162876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+643-756-2876|(03) 216 2876|032162876', '+64268-560-876|0260 567 876|0260567876', 'Invercargill');
INSERT INTO "public"."country_regions" VALUES (514, 56, '9', '(?:\+?64[ -]?)9[ -]?(?:44|47|41|2\d|3\d|48|5\d|6\d|8\d|2\d|9\d)\d[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +649-446-2876 or (09) 446 2876 or 094462876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+649-446-2876|(09) 446 2876|094462876', '+64268-560-876|0260 567 876|0260567876', 'Pitcairn Islands');
INSERT INTO "public"."country_regions" VALUES (515, 44, '2', '(?:\+?64[ -]?)2[ -]?409[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +642-409-2876 or (02) 409 2876 or 024092876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+642-756-2876|(02) 409 2876|024092876', '+64268-560-876|0260 567 876|0260567876', 'Scott Base');
INSERT INTO "public"."country_regions" VALUES (516, 44, '3', '(?:\+?64[ -]?)3[ -]?\d{3}[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +643-756-2876 or (03) 756 2876 or 037562876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+643-756-2876|(03) 756 2876|037562876', '+64268-560-876|0260 567 876|0260567876', 'South Islands & Chatham Islands');
INSERT INTO "public"."country_regions" VALUES (517, 44, '4', '(?:\+?64[ -]?)4[ -]?\d{3}[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +644-756-2876 or (04) 756 2876 or 047562876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+644-756-2876|(04) 756 2876|047562876', '+64268-560-876|0260 567 876|0260567876', 'Wellington metro area and Kapiti Coast district (excluding Otaki)');
INSERT INTO "public"."country_regions" VALUES (518, 44, '6', '(?:\+?64[ -]?)6[ -]?\d{3}[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +646-756-2876 or (06) 756 2876 or 067562876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+646-756-2876|(06) 756 2876|067562876', '+64268-560-876|0260 567 876|0260567876', 'Taranaki, ManawatÅ«-Whanganui (excluding Taumarunui and National Park), Hawke''s Bay, Gisborne, the Wairarapa, and Otaki.');
INSERT INTO "public"."country_regions" VALUES (519, 44, '7', '(?:\+?64[ -]?)7[ -]?\d{3}[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +647-756-2876 or (07) 756 2876 or 077562876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+647-756-2876|(07) 756 2876|077562876', '+64268-560-876|0260 567 876|0260567876', 'Waikato (excluding Tuakau and Pokeno) and the Bay of Plenty');
INSERT INTO "public"."country_regions" VALUES (520, 44, '9', '(?:\+?64[ -]?)9[ -]?\d{3}[ -]?\d{4}', '(?:\+64|0)(?:(?:2\d|85|86|96)\d{2})[ -]?\d{3}[ -]?\d{3}', 'Only +digits or local formats allowed i.e. +649-756-2876 or (09) 756 2876 or 097562876.', 'Only +digits or local formats allowed. i.e. +64260-567-876 or 0260 567 876 or 0260567876', '+649-756-2876|(09) 756 2876|097562876', '+64268-560-876|0260 567 876|0260567876', 'Auckland, Northland, Tuakau and Pokeno.');
INSERT INTO "public"."country_regions" VALUES (521, 63, '2', '(?:\+20[ -]?|0)2[ -]\d{4}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-2-8756-2876 or (02) 8756 2876 or 0287562876.', 'Only +digits or local formats allowed. i.e. +20-12-5678-8765 or 02 10 4567 876 or 021560567876', '+20-2-8756-2876|(02) 8756 2876|0287562876', '+2011-5610-876|02 12 4567 8765|021560567876', 'Greater Cairo (Cairo, Giza, and part of Qalyubia)');
INSERT INTO "public"."country_regions" VALUES (522, 63, '3', '(?:\+?20[ -]?|0)3[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-3-756-2876 or (03) 756 2876 or 037562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+203-756-2876|(03) 756 2876|037562876', '+2012-560-876|015 567 876|010657876', 'Alexandria');
INSERT INTO "public"."country_regions" VALUES (523, 63, '68', '(?:\+?20[ -]?|0)68[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-68-756-2876 or (068) 756 2876 or 0687562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2068-756-2876|(068) 756 2876|0687562876', '+2012-560-876|015 567 876|010657876', 'Arish');
INSERT INTO "public"."country_regions" VALUES (524, 63, '97', '(?:\+?20[ -]?|0)97[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-97-756-2876 or (097) 756 2876 or 0977562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2097-756-2876|(097) 756 2876|0977562876', '+2012-560-876|015 567 876|010657876', 'Aswan');
INSERT INTO "public"."country_regions" VALUES (525, 63, '82', '(?:\+?20[ -]?|0)82[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-82-756-2876 or (082) 756 2876 or 0827562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2082-756-2876|(082) 756 2876|0827562876', '+2012-560-876|015 567 876|010657876', 'Beni Suef');
INSERT INTO "public"."country_regions" VALUES (526, 63, '57', '(?:\+?64[ -]?|0)57[ -]?\d{3}[ -]?\d{4}', '(?:\+64|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +64-57-756-2876 or (057) 756 2876 or 0577562876.', 'Only +digits or local formats allowed. i.e. +6410-567-8765 or 011 567 8765 or 01260567876', '+6457-756-2876|(057) 756 2876|0577562876', '+6412-560-876|015 567 876|010657876', 'Damietta');
INSERT INTO "public"."country_regions" VALUES (527, 63, '64', '(?:\+?20[ -]?|0)64[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-64-756-2876 or (064) 756 2876 or 0647562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2064-756-2876|(064) 756 2876|0647562876', '+2012-560-876|015 567 876|010657876', 'Ismailia');
INSERT INTO "public"."country_regions" VALUES (528, 63, '95', '(?:\+?20[ -]?|0)95[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-95-756-2876 or (095) 756 2876 or 0957562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2095-756-2876|(095) 756 2876|0957562876', '+2012-560-876|015 567 876|010657876', 'Luxor');
INSERT INTO "public"."country_regions" VALUES (529, 63, '50', '(?:\+?20[ -]?|0)50[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-50-756-2876 or (050) 756 2876 or 0507562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2050-756-2876|(050) 756 2876|0507562876', '+2012-560-876|015 567 876|010657876', 'Mansoura');
INSERT INTO "public"."country_regions" VALUES (530, 63, '48', '(?:\+?20[ -]?|0)48[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-48-756-2876 or (048) 756 2876 or 0487562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2048-756-2876|(048) 756 2876|0487562876', '+2012-560-876|015 567 876|010657876', 'Monufia');
INSERT INTO "public"."country_regions" VALUES (531, 63, '66', '(?:\+?20[ -]?|0)66[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-66-756-2876 or (066) 756 2876 or 0667562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2066-756-2876|(066) 756 2876|0667562876', '+2012-560-876|015 567 876|010657876', 'Port Said');
INSERT INTO "public"."country_regions" VALUES (532, 63, '65', '(?:\+?20[ -]?|0)65[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-65-756-2876 or (065) 756 2876 or 0657562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2065-756-2876|(065) 756 2876|0657562876', '+2012-560-876|015 567 876|010657876', 'Red Sea');
INSERT INTO "public"."country_regions" VALUES (533, 63, '62', '(?:\+?20[ -]?|0)62[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-62-756-2876 or (062) 756 2876 or 0627562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2062-756-2876|(062) 756 2876|0627562876', '+2012-560-876|015 567 876|010657876', 'Suez');
INSERT INTO "public"."country_regions" VALUES (534, 63, '69', '(?:\+?20[ -]?|0)69[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-69-756-2876 or (069) 756 2876 or 0697562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2069-756-2876|(069) 756 2876|0697562876', '+2012-560-876|015 567 876|010657876', 'El Tor');
INSERT INTO "public"."country_regions" VALUES (535, 63, '55', '(?:\+?20[ -]?|0)55[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-55-756-2876 or (055) 756 2876 or 0557562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2055-756-2876|(055) 756 2876|0557562876', '+2012-560-876|015 567 876|010657876', '10th of Ramadan');
INSERT INTO "public"."country_regions" VALUES (536, 63, '88', '(?:\+?20[ -]?|0)88[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-88-756-2876 or (088) 756 2876 or 0887562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2088-756-2876|(088) 756 2876|0887562876', '+2012-560-876|015 567 876|010657876', 'Asyut');
INSERT INTO "public"."country_regions" VALUES (537, 63, '13', '(?:\+?20[ -]?|0)13[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-13-756-2876 or (013) 756 2876 or 0137562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2013-756-2876|(013) 756 2876|0137562876', '+2012-560-876|015 567 876|010657876', 'Benha');
INSERT INTO "public"."country_regions" VALUES (538, 63, '45', '(?:\+?20[ -]?|0)45[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-45-756-2876 or (045) 756 2876 or 0457562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2045-756-2876|(045) 756 2876|0457562876', '+2012-560-876|015 567 876|010657876', 'Damanhur');
INSERT INTO "public"."country_regions" VALUES (539, 63, '84', '(?:\+?20[ -]?|0)84[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-84-756-2876 or (084) 756 2876 or 0847562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2084-756-2876|(084) 756 2876|0847562876', '+2012-560-876|015 567 876|010657876', 'Faiyum');
INSERT INTO "public"."country_regions" VALUES (540, 63, '47', '(?:\+?20[ -]?|0)47[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-47-756-2876 or (047) 756 2876 or 0477562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2047-756-2876|(047) 756 2876|0477562876', '+2012-560-876|015 567 876|010657876', 'Kafr El Sheikh');
INSERT INTO "public"."country_regions" VALUES (541, 63, '46', '(?:\+?20[ -]?|0)46[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-46-756-2876 or (046) 756 2876 or 0467562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2046-756-2876|(046) 756 2876|0467562876', '+2012-560-876|015 567 876|010657876', 'Marsa Matruh');
INSERT INTO "public"."country_regions" VALUES (542, 63, '86', '(?:\+?20[ -]?|0)86[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-86-756-2876 or (086) 756 2876 or 0867562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2086-756-2876|(086) 756 2876|0867562876', '+2012-560-876|015 567 876|010657876', 'Minya');
INSERT INTO "public"."country_regions" VALUES (543, 63, '92', '(?:\+?20[ -]?|0)92[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-92-756-2876 or (092) 756 2876 or 0927562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2092-756-2876|(092) 756 2876|0927562876', '+2012-560-876|015 567 876|010657876', 'New Valley');
INSERT INTO "public"."country_regions" VALUES (544, 63, '92', '(?:\+?20[ -]?|0)92[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-92-756-2876 or (092) 756 2876 or 0927562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2092-756-2876|(092) 756 2876|0927562876', '+2012-560-876|015 567 876|010657876', 'New Valley');
INSERT INTO "public"."country_regions" VALUES (545, 63, '96', '(?:\+?20[ -]?|0)96[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-96-756-2876 or (096) 756 2876 or 0967562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2096-756-2876|(096) 756 2876|0967562876', '+2012-560-876|015 567 876|010657876', 'Qena');
INSERT INTO "public"."country_regions" VALUES (546, 63, '93', '(?:\+?20[ -]?|0)93[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-93-756-2876 or (093) 756 2876 or 0937562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2093-756-2876|(093) 756 2876|0937562876', '+2012-560-876|015 567 876|010657876', 'Sohag');
INSERT INTO "public"."country_regions" VALUES (547, 63, '40', '(?:\+?20[ -]?|0)40[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-40-756-2876 or (040) 756 2876 or 0407562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2040-756-2876|(040) 756 2876|0407562876', '+2012-560-876|015 567 876|010657876', 'Tanta');
INSERT INTO "public"."country_regions" VALUES (548, 63, '55', '(?:\+?20[ -]?|0)55[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-55-756-2876 or (055) 756 2876 or 0557562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2055-756-2876|(055) 756 2876|0557562876', '+2012-560-876|015 567 876|010657876', 'Zagazig');
INSERT INTO "public"."country_regions" VALUES (549, 63, '13', '(?:\+?20[ -]?|0)13[ -]?\d{3}[ -]?\d{4}', '(?:\+20|0)(?:(?:10|11|12|15)\d{2})[ -]?\d{4}[ -]?\d{4}', 'Only +digits or local formats allowed i.e. +20-13-756-2876 or (013) 756 2876 or 0137562876.', 'Only +digits or local formats allowed. i.e. +2010-567-8765 or 011 567 8765 or 01260567876', '+2013-756-2876|(013) 756 2876|0137562876', '+2012-560-876|015 567 876|010657876', 'Qalyubia');


--
-- TOC entry 3661 (class 0 OID 16946)
-- Dependencies: 229
-- Data for Name: email; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."email" VALUES (4, 'grizzly@smit.id.au', false);
INSERT INTO "public"."email" VALUES (3, 'grizzly@smit.id.au', false);
INSERT INTO "public"."email" VALUES (2, 'grizzly@smit.id.au', false);
INSERT INTO "public"."email" VALUES (11, 'romanna@tardis.org', false);
INSERT INTO "public"."email" VALUES (10, 'fred@bedrock.org', false);
INSERT INTO "public"."email" VALUES (8, 'doctor@tardis.org', false);
INSERT INTO "public"."email" VALUES (13, 'bilbo@baggins.com', false);
INSERT INTO "public"."email" VALUES (7, 'frodo@tolkien.com', false);
INSERT INTO "public"."email" VALUES (1, 'grizzly@smit.id.au', false);
INSERT INTO "public"."email" VALUES (14, 'grizzly@smit.id.au', false);
INSERT INTO "public"."email" VALUES (17, 'ludo@baggins.org', false);
INSERT INTO "public"."email" VALUES (18, 'ludo@baggins.org', false);
INSERT INTO "public"."email" VALUES (19, 'fred@bloggs.com', false);


--
-- TOC entry 3663 (class 0 OID 16952)
-- Dependencies: 231
-- Data for Name: emails; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3665 (class 0 OID 16957)
-- Dependencies: 233
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."groups" VALUES (1, 4, 2);
INSERT INTO "public"."groups" VALUES (3, 1, 2);
INSERT INTO "public"."groups" VALUES (8, 5, 2);
INSERT INTO "public"."groups" VALUES (9, 3, 3);
INSERT INTO "public"."groups" VALUES (10, 1, 3);
INSERT INTO "public"."groups" VALUES (24, 8, 3);
INSERT INTO "public"."groups" VALUES (28, 8, 2);
INSERT INTO "public"."groups" VALUES (29, 1, 8);
INSERT INTO "public"."groups" VALUES (30, 3, 8);
INSERT INTO "public"."groups" VALUES (31, 5, 8);
INSERT INTO "public"."groups" VALUES (32, 4, 8);
INSERT INTO "public"."groups" VALUES (33, 8, 8);
INSERT INTO "public"."groups" VALUES (40, 10, 10);
INSERT INTO "public"."groups" VALUES (41, 9, 10);
INSERT INTO "public"."groups" VALUES (42, 3, 10);
INSERT INTO "public"."groups" VALUES (43, 4, 10);
INSERT INTO "public"."groups" VALUES (44, 5, 10);
INSERT INTO "public"."groups" VALUES (45, 1, 10);
INSERT INTO "public"."groups" VALUES (46, 8, 10);
INSERT INTO "public"."groups" VALUES (47, 1, 11);
INSERT INTO "public"."groups" VALUES (48, 8, 11);
INSERT INTO "public"."groups" VALUES (49, 5, 11);
INSERT INTO "public"."groups" VALUES (50, 4, 11);
INSERT INTO "public"."groups" VALUES (51, 3, 11);
INSERT INTO "public"."groups" VALUES (52, 10, 11);
INSERT INTO "public"."groups" VALUES (53, 11, 11);
INSERT INTO "public"."groups" VALUES (133, 1, 13);
INSERT INTO "public"."groups" VALUES (134, 5, 13);
INSERT INTO "public"."groups" VALUES (135, 4, 13);
INSERT INTO "public"."groups" VALUES (136, 3, 13);
INSERT INTO "public"."groups" VALUES (137, 9, 13);
INSERT INTO "public"."groups" VALUES (138, 10, 13);
INSERT INTO "public"."groups" VALUES (139, 11, 13);
INSERT INTO "public"."groups" VALUES (140, 8, 13);
INSERT INTO "public"."groups" VALUES (141, 12, 13);
INSERT INTO "public"."groups" VALUES (186, 5, 1);
INSERT INTO "public"."groups" VALUES (187, 4, 1);
INSERT INTO "public"."groups" VALUES (188, 3, 1);
INSERT INTO "public"."groups" VALUES (189, 10, 1);
INSERT INTO "public"."groups" VALUES (190, 12, 1);
INSERT INTO "public"."groups" VALUES (191, 11, 1);
INSERT INTO "public"."groups" VALUES (192, 9, 1);
INSERT INTO "public"."groups" VALUES (209, 14, 1);
INSERT INTO "public"."groups" VALUES (210, 8, 1);
INSERT INTO "public"."groups" VALUES (211, 1, 14);
INSERT INTO "public"."groups" VALUES (212, 5, 14);
INSERT INTO "public"."groups" VALUES (213, 4, 14);
INSERT INTO "public"."groups" VALUES (214, 3, 14);
INSERT INTO "public"."groups" VALUES (215, 10, 14);
INSERT INTO "public"."groups" VALUES (216, 12, 14);
INSERT INTO "public"."groups" VALUES (217, 11, 14);
INSERT INTO "public"."groups" VALUES (218, 9, 14);
INSERT INTO "public"."groups" VALUES (219, 14, 14);
INSERT INTO "public"."groups" VALUES (220, 8, 14);
INSERT INTO "public"."groups" VALUES (241, 1, 17);
INSERT INTO "public"."groups" VALUES (242, 10, 17);
INSERT INTO "public"."groups" VALUES (243, 10, 18);
INSERT INTO "public"."groups" VALUES (244, 11, 18);


--
-- TOC entry 3658 (class 0 OID 16914)
-- Dependencies: 223
-- Data for Name: links; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 1, 'https://version.oztell.com.au/anycast/dl.88.io', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 1, 'https://version.oztell.com.au/anycast/dl.88.io/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 2, 'https://version.contacttrace.com.au/fiduciary-exchange/key/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 3, 'https://vault.net2maxlabs.net/net2max1/wp-admin/post.php?post=48209&action=edit', 'edit-docs');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 3, 'https://vault.net2maxlabs.net/net2max1/location-grid/', 'view-docs');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 4, 'https://version.contacttrace.com.au/fiduciary-exchange/address/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 5, 'https://version.contacttrace.com.au/contact0/input/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 5, 'https://version.contacttrace.com.au/contact0/input', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 5, 'https://version.contacttrace.com.au/contact0/input/-pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 6, 'https://version.contacttrace.com.au/contact0/app/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 6, 'https://version.contacttrace.com.au/contact0/app/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 6, 'https://version.contacttrace.com.au/contact0/app/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 17, 7, 'https://version.contacttrace.com.au/contact0/output/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 18, 7, 'https://version.contacttrace.com.au/contact0/output/-scripts/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 7, 'https://version.contacttrace.com.au/contact0/output/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 8, 'https://vault.net2maxlabs.net/net2max1/business-identity-check/', 'view-docs');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 8, 'https://vault.net2maxlabs.net/net2max1/wp-admin/post.php?post=51576&action=edit', 'edit-docs');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 76, 34, 'https://www.postgresql.org/docs/', 'docs');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 77, 36, 'https://php.net', 'main');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 78, 36, 'https://www.php.net/manual/en/', 'docs-en');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 79, 36, 'https://www.php.net/manual/en/langref.php', 'lang');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 80, 36, 'https://www.php.net/manual/en/security.php', 'security');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 81, 36, 'https://www.php.net/manual/en/funcref.php', 'funs');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 82, 36, 'https://www.php.net/manual/en/faq.php', 'faq');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 83, 36, 'https://www.php.net/manual/en/appendices.php', 'apendices');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 84, 36, 'https://www.php.net/manual/en/features.php', 'features');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 99, 34, 'https://www.postgresql.org/', 'main');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 22, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/-/blob/prod/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 23, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 24, 9, 'https://version.contacttrace.com.au/fiduciary-exchange/bronze-aus/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 25, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 26, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 27, 10, 'https://version.contacttrace.com.au/fiduciary-exchange/signature/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 28, 11, 'https://chat.quuvoo4ohcequuox.0.88.io/home', 'chat');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 29, 12, 'https://version.oztell.com.au/88io0/tools/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 31, 12, 'https://version.oztell.com.au/88io0/tools/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 32, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 33, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 34, 13, 'https://version.contacttrace.com.au/contact2/api_ugh8eika/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 35, 14, 'https://vault.net2maxlabs.net/net2max1/business-identity-check/', 'namecheck');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 36, 14, 'https://vault.net2maxlabs.net/net2max1/location-grid/', 'map');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 37, 15, 'https://version.contacttrace.com.au/contact0/storage/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 38, 15, 'https://version.contacttrace.com.au/contact0/storage/-/pipelines', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 39, 15, 'https://version.contacttrace.com.au/contact0/storage/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 40, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 41, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 42, 16, 'https://version.contacttrace.com.au/contact0/dops-portknocking/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 43, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 44, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 45, 17, 'https://version.contacttrace.com.au/contact0/dops-scripts/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 46, 18, 'https://version.contacttrace.com.au/contact0/directory/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 47, 18, 'https://version.contacttrace.com.au/contact0/directory/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 48, 18, 'https://version.contacttrace.com.au/contact0/directory/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 49, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 50, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io/-/blob/prod/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 51, 19, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/api.quuvoo4ohcequuox.0.88.io/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 52, 20, 'https://version.oztell.com.au/oztell8/api', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 53, 21, 'https://version.contacttrace.com.au/contact0/processor/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 54, 21, 'https://version.contacttrace.com.au/contact0/processor', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 55, 21, 'https://version.contacttrace.com.au/contact0/processor/-/blob/dev/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 56, 22, 'https://ledger.contacttrace.com.au/?chain=0-s1-dev', '0-s1-dev');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 57, 22, 'https://ledger.contacttrace.com.au/', 'launch-page');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 58, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/-/blob/prod/README.md', 'readme');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 59, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/', 'gitlab');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 60, 23, 'https://version.quuvoo4ohcequuox.0.88.io/quuvoo4ohcequuox/portknocking.quuvoo4ohcequuox.0.88.io/-/pipelines/', 'pipeline');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 61, 24, 'https://isocpp.org/', 'iso');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 62, 24, 'https://en.cppreference.com/w/', 'cppref');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 63, 24, 'https://www.modernescpp.com/index.php', 'modernescpp');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 69, 27, 'https://raku.org/', 'main');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 70, 27, 'https://modules.raku.org/', 'modules');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 71, 27, 'https://docs.raku.org/', 'docs');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 72, 27, 'https://docs.raku.org/language.html', 'lang');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 73, 27, 'https://docs.raku.org/type.html', 'types');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 74, 27, 'https://web.libera.chat/?channel=#raku', 'chat');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 100, 34, 'https://www.postgresql.org/account', 'account');
INSERT INTO "public"."links" VALUES (3, 4, '("(t,t,t)","(t,t,t)","(t,f,f)")', 116, 38, 'https://launchpad.net/ubuntu', 'ubuntu');
INSERT INTO "public"."links" VALUES (3, 4, '("(t,t,t)","(t,t,t)","(t,f,f)")', 117, 24, 'https://en.cppreference.com/w/cpp/compiler_support', 'cpp-compiler-support');
INSERT INTO "public"."links" VALUES (3, 4, '("(t,t,t)","(t,t,t)","(t,f,f)")', 118, 24, 'https://gcc.gnu.org/projects/cxx-status.html', 'g++std-status');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 120, 38, 'https://www.ubuntu.com/', 'ubuntu-home-page');
INSERT INTO "public"."links" VALUES (3, 4, '("(t,t,t)","(t,t,t)","(t,f,f)")', 121, 38, 'https://redhat.com', 'redhat');
INSERT INTO "public"."links" VALUES (3, 4, '("(t,t,t)","(t,t,t)","(t,f,f)")', 122, 38, 'https://getfedora.org/', 'fedora');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 123, 45, 'https://music.youtube.com/watch?v=aA6cnb7hBwg&list=RDAMVM85bmsn-FnVo', 'nederland');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 124, 46, 'https://my.aussiebroadband.com.au/#/', 'my.aussie');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 125, 47, 'https://h1i6f7rp40dqjwig.myfritz.net:42178/', 'main');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 126, 47, 'http://192.168.188.1/', 'local');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 127, 47, 'https://sso.myfritz.net/', 'account');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 128, 46, 'https://speed.aussiebroadband.com.au/', 'aussie.speed-test');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 129, 45, 'https://www.tayaofficial.com/#/', 'taya');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 130, 45, 'https://www.hillsongstore.com/music?sortBy=hillsongstorem2au_store_products', 'hillsong');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 131, 53, 'https://www.woolworths.com.au/', 'woolies');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 132, 54, 'https://kotlinlang.org/', 'home');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 133, 55, 'https://wordpress.org/plugins/postie/', 'postie');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 134, 56, 'https://github.com/rogerhub/postie/blob/master/filterPostie.php.sample', 'postie');
INSERT INTO "public"."links" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 135, 55, 'https://postieplugin.com/extending/', 'postie-extending');


--
-- TOC entry 3657 (class 0 OID 16901)
-- Dependencies: 221
-- Data for Name: links_sections; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 'dl.88.io');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 'key');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 'location-grid-old-docs');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 'address');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 'input');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 'app');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 'output');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 'business-identity-check');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 'bronze-aus');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 'signature');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 'chat.q');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 'tools');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 'api_ugh8eika');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 'oldocs');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 'storage');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 'portknocking');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 17, 'scripts');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 18, 'directory');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 'api.quuvoo4ohcequuox.0.88.io');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 'api');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 'processor');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 22, 'blockchains');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 23, 'portknocking-dev');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 24, 'C++');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 27, 'raku');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 34, 'postgres');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 36, 'php');
INSERT INTO "public"."links_sections" VALUES (3, 4, '("(t,t,t)","(t,t,t)","(t,f,f)")', 38, 'Linux');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 45, 'music');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 46, 'ISP');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 47, 'Fritzbox');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 53, 'shops');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 54, 'kotlin');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 55, 'wordpress-plugins');
INSERT INTO "public"."links_sections" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 56, 'wordpress-github');


--
-- TOC entry 3667 (class 0 OID 16966)
-- Dependencies: 236
-- Data for Name: page_section; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."page_section" VALUES (4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")', 80, 39, 24);
INSERT INTO "public"."page_section" VALUES (4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")', 81, 39, 27);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 1, 12);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, 1, 20);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 3, 16);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 4, 3, 23);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, 5, 19);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 6, 5, 1);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 7, 15);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 8, 7, 21);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 9, 7, 17);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 10, 7, 16);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 11, 7, 4);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 12, 7, 10);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 13, 7, 9);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 14, 7, 13);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 15, 7, 5);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 16, 7, 18);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 17, 7, 7);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 18, 7, 6);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 19, 7, 2);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 20, 3);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 21, 20, 14);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 78, 37, 1);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 82, 39, 38);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 83, 39, 45);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 84, 39, 47);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 85, 39, 46);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 86, 39, 53);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 87, 39, 54);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 88, 45, 56);
INSERT INTO "public"."page_section" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 89, 45, 55);


--
-- TOC entry 3668 (class 0 OID 16974)
-- Dependencies: 237
-- Data for Name: pages; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."pages" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, 'oztell.com.au', 'oztell.com.au stuff');
INSERT INTO "public"."pages" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 3, 'knock', 'port knocking');
INSERT INTO "public"."pages" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 7, 'contacttrace', 'contacttrace');
INSERT INTO "public"."pages" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 20, 'docsold', 'The Old Docs');
INSERT INTO "public"."pages" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, '88.io', '88.io stuff');
INSERT INTO "public"."pages" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 37, 'apk', 'where the apks are');
INSERT INTO "public"."pages" VALUES (4, 5, '("(t,t,t)","(t,t,t)","(t,f,f)")', 39, 'grizz-page', 'Grizzs Page');
INSERT INTO "public"."pages" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 45, 'wp', 'wordpress');


--
-- TOC entry 3673 (class 0 OID 17007)
-- Dependencies: 245
-- Data for Name: passwd; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."passwd" VALUES (4, 'grizz', '{X-PBKDF2}HMACSHA2+512:AAAIAA:zWeWVTYpvU2EsxbD6fjNIw==:sdYmcRwOLxC55Q/cCigfExdtT32EFH3vzTvV8IaYVkjNo4Svo8A9FumS1Wu8Dpu7ca2W+uFcX7ZEA5zilPK3vg==', 4, 5, false, 4);
INSERT INTO "public"."passwd" VALUES (11, 'romanna', '{X-PBKDF2}HMACSHA2+512:AAAIAA:Hfx25iKf16ALs9uLyAP0dg==:uZ3Yf8yYB3wNU3o+a5V++YfLR13j2n1UGn9PlNImGuDwhG2dvm8MbM3pNgRwe1k6H1KCXaNS34gsbE7SYkrZcg==', 11, 12, true, 11);
INSERT INTO "public"."passwd" VALUES (10, 'fred', '{X-PBKDF2}HMACSHA2+512:AAAIAA:MngWyewYRJDLVd4R0g90XA==:hNjmHMU/6Q/ygd0pR+TKw/Jp7B1zyuUvdRSZMqw1SoRdv47AytpnjvUWuhn+z3bRBcJrwTIZUEUKNVNRIpTZKQ==', 10, 11, true, 10);
INSERT INTO "public"."passwd" VALUES (8, 'doctor', '{X-PBKDF2}HMACSHA2+512:AAAIAA:qI8dL7+iG0krRmP0j5UuBQ==:VZOV1L9FRFI+hH5Veiw66J6qdCe8hbyCeHnQ9cGkijk0UarrsYSSjxajlTtHYZ7qScd/uMSZBxT9w+5gEuj94w==', 8, 9, true, 8);
INSERT INTO "public"."passwd" VALUES (13, 'bilbo', '{X-PBKDF2}HMACSHA2+512:AAAIAA:seR82SYehhmenojqG4KzwQ==:9K5frKmDuX3px/xCgOMcCIoXuvKeq6Vvh5wZMvxiQbQMiYxZ0DRLBaXJkLZpBvysvIURE037Hi46JMYxqfYyAw==', 13, 14, true, 13);
INSERT INTO "public"."passwd" VALUES (7, 'frodo', '{X-PBKDF2}HMACSHA2+512:AAAIAA:L8niz4XzsghhSbcrOSDRHA==:MbAm1ydlPeqD2gIBVdvNOS9iLJwN55p59wXHZh28BdbMIl3Zu5zj0ysFmDzGiv4f/jA4zc/9FsUTQAQD64MjUQ==', 7, 8, false, 7);
INSERT INTO "public"."passwd" VALUES (3, 'grizzly', '{X-PBKDF2}HMACSHA2+512:AAAIAA:Po+YOhfNSqvgJVkWfUJdoQ==:kA39+vz0F3/pIECA7Y2TuW1wLIPdal0WBv2LOWdkRCWci6GEcKdSu0NQ5wwsZuI4G0fsMBE83LIGvBiZJe0VcA==', 3, 4, true, 3);
INSERT INTO "public"."passwd" VALUES (2, 'grizzlysmit', '{X-PBKDF2}HMACSHA2+512:AAAIAA:205IxJhEjYkb5aOMExRFEA==:rk5nlRePO0bI4w1KOUPOyJADkCtBxpTd6goK9IGBc7fUu5otOvz+hXthcw41HH1DXSMB0qbicNJWpGC18wmUww==', 2, 3, true, 2);
INSERT INTO "public"."passwd" VALUES (1, 'admin', '{X-PBKDF2}HMACSHA2+512:AAAIAA:1j44CmP4SfwiYFHyQSJ+NA==:N2xeXHLH5MLnAq3hAAFgPscGSbkZu9bvvN6pgnNPkUeX3c1pzzI+NnxtyITUf0sZ1fd23G3MDFgA/aoLmHf0aQ==', 1, 1, true, 1);
INSERT INTO "public"."passwd" VALUES (14, 'root', '{X-PBKDF2}HMACSHA2+512:AAAIAA:HLYuXYThOlsJ/bFFTbe4gw==:tGKVwYuOLGzwd7LBKNnJG9+w22BDyvAYh3jpV0/moOP4IQV/idvhaCUnSf6vc0mB8j/0/XrhCOORBPJM8imIIQ==', 14, 15, true, 14);
INSERT INTO "public"."passwd" VALUES (17, 'ludo', '{X-PBKDF2}HMACSHA2+512:AAAIAA:jue6TPvdt6Jr2RHltuSCFQ==:/OVAL+1UPSoBqzNZV5KWWvXTEtQJUFhJlWKUji5Dy1CDLhZ2FPSs7cpD8iUrcb8wImnFOjBz8MQc+oukJfyt0A==', 17, 21, false, 18);
INSERT INTO "public"."passwd" VALUES (18, 'fbloggs', '{X-PBKDF2}HMACSHA2+512:AAAIAA:gSSFAi0mPWA/YjbAV184wg==:y+IZR7Vw7wVw6GlJALpZkmCB4HQWLI63m856GzE7U8S35KAlhNdVDPu1tG/PCiroQ4ruZ/3fJEZD5MIDmrPAqA==', 18, 22, false, 19);


--
-- TOC entry 3675 (class 0 OID 17013)
-- Dependencies: 247
-- Data for Name: passwd_details; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."passwd_details" VALUES (14, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 18, 18, 27, 28, 27, NULL);
INSERT INTO "public"."passwd_details" VALUES (1, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 3, 3, 1, 26, 27, NULL);
INSERT INTO "public"."passwd_details" VALUES (8, 'The Doctor Whatever', 'The Doctor', 'Whatever', 12, 12, 12, 13, 27, NULL);
INSERT INTO "public"."passwd_details" VALUES (2, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 4, 4, 3, 9, 27, NULL);
INSERT INTO "public"."passwd_details" VALUES (3, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 5, 11, 5, 11, 27, NULL);
INSERT INTO "public"."passwd_details" VALUES (4, 'Francis Grizzly Smit', 'Francis Grizzly', 'Smit', 7, 6, 7, 10, 27, NULL);
INSERT INTO "public"."passwd_details" VALUES (10, 'Fred Flintstone', 'Fred', 'Flintstone', 14, 14, 16, 17, 26, NULL);
INSERT INTO "public"."passwd_details" VALUES (11, 'Romanna Time Lady', 'Romanna', 'Time Lady', 15, 15, 18, 19, 4, NULL);
INSERT INTO "public"."passwd_details" VALUES (7, 'Frodo Baggins', 'Frodo', 'Baggins', 10, 10, 24, 25, 21, NULL);
INSERT INTO "public"."passwd_details" VALUES (13, 'Bilbo Baggins', 'Bilbo', 'Baggins', 17, 17, 22, 23, 5, NULL);
INSERT INTO "public"."passwd_details" VALUES (17, 'Ludo Baggins', 'Ludo', 'Baggins', 22, 22, NULL, NULL, 42, NULL);
INSERT INTO "public"."passwd_details" VALUES (18, 'Fred Bloggs', 'Fred', 'Bloggs', 23, 23, NULL, NULL, 20, NULL);


--
-- TOC entry 3677 (class 0 OID 17020)
-- Dependencies: 249
-- Data for Name: phone; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."phone" VALUES (2, '+612 9217 6004', false);
INSERT INTO "public"."phone" VALUES (4, '+612 9217 6004', false);
INSERT INTO "public"."phone" VALUES (6, '(02) 9217 6004', false);
INSERT INTO "public"."phone" VALUES (8, '+612-9217-6004', false);
INSERT INTO "public"."phone" VALUES (22, '+16842341234', false);
INSERT INTO "public"."phone" VALUES (7, '+61482176343', false);
INSERT INTO "public"."phone" VALUES (10, '+61292176004', false);
INSERT INTO "public"."phone" VALUES (23, '+16842344321', false);
INSERT INTO "public"."phone" VALUES (24, '+12462341234', false);
INSERT INTO "public"."phone" VALUES (25, '+12464324321', false);
INSERT INTO "public"."phone" VALUES (1, '+61482176343', false);
INSERT INTO "public"."phone" VALUES (26, '+61292176004', false);
INSERT INTO "public"."phone" VALUES (5, '+61482176343', false);
INSERT INTO "public"."phone" VALUES (11, '+61292176004', false);
INSERT INTO "public"."phone" VALUES (3, '+61482176343', false);
INSERT INTO "public"."phone" VALUES (9, '+61292176004', false);
INSERT INTO "public"."phone" VALUES (18, '+13452341234', false);
INSERT INTO "public"."phone" VALUES (19, '+13454324321', false);
INSERT INTO "public"."phone" VALUES (16, '+13402341234', false);
INSERT INTO "public"."phone" VALUES (17, '+13404324321', false);
INSERT INTO "public"."phone" VALUES (12, '+61482176343', false);
INSERT INTO "public"."phone" VALUES (13, '+61292176004', false);
INSERT INTO "public"."phone" VALUES (27, '+61482176343', false);
INSERT INTO "public"."phone" VALUES (28, '+61292176004', false);


--
-- TOC entry 3679 (class 0 OID 17026)
-- Dependencies: 251
-- Data for Name: phones; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3670 (class 0 OID 16992)
-- Dependencies: 241
-- Data for Name: pseudo_pages; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."pseudo_pages" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 1, '.*', 'unassigned', 'misc', 'misc');
INSERT INTO "public"."pseudo_pages" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 2, '.*', 'both', 'all', 'all');
INSERT INTO "public"."pseudo_pages" VALUES (1, 1, '("(t,t,t)","(t,t,t)","(t,f,f)")', 5, '.*', 'assigned', 'already', 'already in pages');


--
-- TOC entry 3653 (class 0 OID 16883)
-- Dependencies: 217
-- Data for Name: secure; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--



--
-- TOC entry 3681 (class 0 OID 17036)
-- Dependencies: 254
-- Data for Name: sessions; Type: TABLE DATA; Schema: public; Owner: grizzlysmit
--

INSERT INTO "public"."sessions" VALUES ('ccaf15a07783d52542704b543d8dc2b9', 'BQsDAAAAEBcLZ3JpenpseXNtaXQAAAARbG9nZ2VkaW5fdXNlcm5hbWUXFEZyYW5jaXMgR3Jpenps
eSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQoCMjUAAAALcGFnZV9sZW5ndGgIgAAAAA5s
b2dnZWRpbl9hZG1pbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXD0ZyYW5jaXMgR3JpenpseQAA
AA5sb2dnZWRpbl9naXZlbgoJbGlua3NeQysrAAAAD2N1cnJlbnRfc2VjdGlvbhcOKzYxNDgyIDE3
NiAzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9n
Z2VkaW5fZW1haWwKATAAAAAFZGVidWcIggAAAAhsb2dnZWRpbgoPcHNldWRvLXBhZ2VeYWxsAAAA
DGN1cnJlbnRfcGFnZQogY2NhZjE1YTA3NzgzZDUyNTQyNzA0YjU0M2Q4ZGMyYjkAAAALX3Nlc3Np
b25faWQIggAAAAtsb2dnZWRpbl9pZBcLZ3JpenpseXNtaXQAAAASbG9nZ2VkaW5fZ3JvdXBuYW1l
CIMAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZA==
');
INSERT INTO "public"."sessions" VALUES ('068675cd502b8327e5dd27ef507aa3c0', 'BQsDAAAAEAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKCWxpbmtzXkMrKwAAAA9jdXJyZW50
X3NlY3Rpb24KATEAAAAFZGVidWcXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lCIEAAAALbG9n
Z2VkaW5faWQIgQAAAA5sb2dnZWRpbl9hZG1pbhcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9n
Z2VkaW5fZGlzcGxheV9uYW1lCIEAAAAIbG9nZ2VkaW4XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5s
b2dnZWRpbl9lbWFpbBcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGluX2dpdmVuCgIyNQAAAAtw
YWdlX2xlbmd0aAoPcHNldWRvLXBhZ2VeYWxsAAAADGN1cnJlbnRfcGFnZRcMKzYxNDgyMTc2MzQz
AAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFwRT
bWl0AAAAD2xvZ2dlZGluX2ZhbWlseQogMDY4Njc1Y2Q1MDJiODMyN2U1ZGQyN2VmNTA3YWEzYzAA
AAALX3Nlc3Npb25faWQ=
');
INSERT INTO "public"."sessions" VALUES ('dd658768b14194054d895bb6e64d5294', 'BQsDAAAAEAoObGlua3NecG9zdGdyZXMAAAAPY3VycmVudF9zZWN0aW9uFxRGcmFuY2lzIEdyaXp6
bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUXC2dyaXp6bHlzbWl0AAAAEWxvZ2dlZGlu
X3VzZXJuYW1lFwtncml6emx5c21pdAAAABJsb2dnZWRpbl9ncm91cG5hbWUXD0ZyYW5jaXMgR3Jp
enpseQAAAA5sb2dnZWRpbl9naXZlbgogZGQ2NTg3NjhiMTQxOTQwNTRkODk1YmI2ZTY0ZDUyOTQA
AAALX3Nlc3Npb25faWQKAjI4AAAAC3BhZ2VfbGVuZ3RoFxJncml6emx5QHNtaXQuaWQuYXUAAAAO
bG9nZ2VkaW5fZW1haWwIgwAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkChBwc2V1ZG8tcGFnZV5t
aXNjAAAADGN1cnJlbnRfcGFnZQiBAAAADmxvZ2dlZGluX2FkbWluCIIAAAAIbG9nZ2VkaW4IggAA
AAtsb2dnZWRpbl9pZAoBMAAAAAVkZWJ1ZxcOKzYxNDgyIDE3NiAzNDMAAAAVbG9nZ2VkaW5fcGhv
bmVfbnVtYmVyFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseQ==
');
INSERT INTO "public"."sessions" VALUES ('498b2cd3b6da04091d39c89f9190ecbe', 'BQsDAAAABQogNDk4YjJjZDNiNmRhMDQwOTFkMzljODlmOTE5MGVjYmUAAAALX3Nlc3Npb25faWQK
D3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKAjIzAAAAC3BhZ2VfbGVuZ3RoCglsaW5r
c15DKysAAAAPY3VycmVudF9zZWN0aW9uCgExAAAABWRlYnVn
');
INSERT INTO "public"."sessions" VALUES ('d54a395a7e3d035b2eab35e3e1e3eddd', 'BQsDAAAAEAogZDU0YTM5NWE3ZTNkMDM1YjJlYWIzNWUzZTFlM2VkZGQAAAALX3Nlc3Npb25faWQX
Dis2MTQ4Mi0xNzYtMzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcFZ3JpenoAAAASbG9nZ2Vk
aW5fZ3JvdXBuYW1lFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25h
bWUXBWdyaXp6AAAAEWxvZ2dlZGluX3VzZXJuYW1lFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2Vk
aW5fZ2l2ZW4KD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UKAjI1AAAAC3BhZ2VfbGVu
Z3RoCIQAAAAIbG9nZ2VkaW4IhAAAAAtsb2dnZWRpbl9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1p
bHkXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbAiFAAAAFmxvZ2dlZGluX2dy
b3Vwbm5hbWVfaWQKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24IgAAAAA5sb2dnZWRp
bl9hZG1pbgoBMAAAAAVkZWJ1Zw==
');
INSERT INTO "public"."sessions" VALUES ('88aa7cad761ab4c62664ab011059f338', 'BQsDAAAABQoKbGlua3NecmFrdQAAAA9jdXJyZW50X3NlY3Rpb24KD3BzZXVkby1wYWdlXmFsbAAA
AAxjdXJyZW50X3BhZ2UKAjQxAAAAC3BhZ2VfbGVuZ3RoCiA4OGFhN2NhZDc2MWFiNGM2MjY2NGFi
MDExMDU5ZjMzOAAAAAtfc2Vzc2lvbl9pZAoBMAAAAAVkZWJ1Zw==
');
INSERT INTO "public"."sessions" VALUES ('a5d41456a83643e9445ceb8e1f8fe4d2', 'BQsDAAAABQoCMjgAAAALcGFnZV9sZW5ndGgKC2FsaWFzXnBlcmw2AAAAD2N1cnJlbnRfc2VjdGlv
bgoQcHNldWRvLXBhZ2VebWlzYwAAAAxjdXJyZW50X3BhZ2UKATAAAAAFZGVidWcKIGE1ZDQxNDU2
YTgzNjQzZTk0NDVjZWI4ZTFmOGZlNGQyAAAAC19zZXNzaW9uX2lk
');
INSERT INTO "public"."sessions" VALUES ('e1b7ae146ea967338bc75bd9ecc4b4ae', 'BQsDAAAABQogZTFiN2FlMTQ2ZWE5NjczMzhiYzc1YmQ5ZWNjNGI0YWUAAAALX3Nlc3Npb25faWQK
ATEAAAAFZGVidWcKD3BzZXVkby1wYWdlXmFsbAAAAAxjdXJyZW50X3BhZ2UKDmxpbmtzXnBvc3Rn
cmVzAAAAD2N1cnJlbnRfc2VjdGlvbgoCMzkAAAALcGFnZV9sZW5ndGg=
');
INSERT INTO "public"."sessions" VALUES ('da64773d703775653f795947988a29cd', 'BQsDAAAAEAiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXC2dyaXp6bHlzbWl0AAAAEmxvZ2dl
ZGluX2dyb3VwbmFtZQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZRcPRnJhbmNpcyBH
cml6emx5AAAADmxvZ2dlZGluX2dpdmVuCIIAAAALbG9nZ2VkaW5faWQIgQAAAA5sb2dnZWRpbl9h
ZG1pbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKAjI1AAAAC3BhZ2VfbGVuZ3RoFxJncml6emx5
QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXDis2MTQ4MiAxNzYgMzQzAAAAFWxvZ2dlZGlu
X3Bob25lX251bWJlcgoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgoBMAAAAAVkZWJ1
ZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABFsb2dnZWRpbl91c2VybmFtZQogZGE2NDc3
M2Q3MDM3NzU2NTNmNzk1OTQ3OTg4YTI5Y2QAAAALX3Nlc3Npb25faWQXFEZyYW5jaXMgR3Jpenps
eSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQ==
');
INSERT INTO "public"."sessions" VALUES ('c8ab85ca784010747adb0aad5dcb6306', 'BQsDAAAAEAoBMAAAAAVkZWJ1ZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABJsb2dnZWRp
bl9ncm91cG5hbWUKAjI1AAAAC3BhZ2VfbGVuZ3RoFwtncml6emx5c21pdAAAABFsb2dnZWRpbl91
c2VybmFtZQoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA
D2N1cnJlbnRfc2VjdGlvbgiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXBFNtaXQAAAAPbG9n
Z2VkaW5fZmFtaWx5CIIAAAALbG9nZ2VkaW5faWQKIGM4YWI4NWNhNzg0MDEwNzQ3YWRiMGFhZDVk
Y2I2MzA2AAAAC19zZXNzaW9uX2lkCIEAAAAObG9nZ2VkaW5fYWRtaW4XD0ZyYW5jaXMgR3Jpenps
eQAAAA5sb2dnZWRpbl9naXZlbhcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWls
FwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFxRGcmFuY2lzIEdyaXp6bHkg
U21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWU=
');
INSERT INTO "public"."sessions" VALUES ('1c8659df2843a2096c728067be7b9e01', 'BQsDAAAAEAoBMQAAAAVkZWJ1ZwiCAAAACGxvZ2dlZGluFwtncml6emx5c21pdAAAABJsb2dnZWRp
bl9ncm91cG5hbWUXC2dyaXp6bHlzbWl0AAAAEWxvZ2dlZGluX3VzZXJuYW1lCg9wc2V1ZG8tcGFn
ZV5hbGwAAAAMY3VycmVudF9wYWdlCgIyNQAAAAtwYWdlX2xlbmd0aBcEU21pdAAAAA9sb2dnZWRp
bl9mYW1pbHkKDWxpbmtzXnNjcmlwdHMAAAAPY3VycmVudF9zZWN0aW9uCIMAAAAWbG9nZ2VkaW5f
Z3JvdXBubmFtZV9pZAiCAAAAC2xvZ2dlZGluX2lkCiAxYzg2NTlkZjI4NDNhMjA5NmM3MjgwNjdi
ZTdiOWUwMQAAAAtfc2Vzc2lvbl9pZAiBAAAADmxvZ2dlZGluX2FkbWluFw9GcmFuY2lzIEdyaXp6
bHkAAAAObG9nZ2VkaW5fZ2l2ZW4XEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFp
bBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lFw4rNjE0ODIg
MTc2IDM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXI=
');
INSERT INTO "public"."sessions" VALUES ('12d1122cc4eba147d70ae2097bb6e221', 'BQsDAAAAEAoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZQogMTJkMTEyMmNjNGViYTE0
N2Q3MGFlMjA5N2JiNmUyMjEAAAALX3Nlc3Npb25faWQXEmdyaXp6bHlAc21pdC5pZC5hdQAAAA5s
b2dnZWRpbl9lbWFpbBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgoBMAAA
AAVkZWJ1ZxcLZ3JpenpseXNtaXQAAAARbG9nZ2VkaW5fdXNlcm5hbWUIggAAAAhsb2dnZWRpbgiC
AAAAC2xvZ2dlZGluX2lkCIMAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZAoMYWxsX3NlY3Rpb25z
AAAAD2N1cnJlbnRfc2VjdGlvbhcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXC2dyaXp6bHlzbWl0
AAAAEmxvZ2dlZGluX2dyb3VwbmFtZRcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5f
ZGlzcGxheV9uYW1lFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4IgQAAAA5sb2dn
ZWRpbl9hZG1pbgoCMjUAAAALcGFnZV9sZW5ndGg=
');
INSERT INTO "public"."sessions" VALUES ('12ea2abf022eff07a7aeb5e57cf4144c', 'BQsDAAAAAQogMTJlYTJhYmYwMjJlZmYwN2E3YWViNWU1N2NmNDE0NGMAAAALX3Nlc3Npb25faWQ=
');
INSERT INTO "public"."sessions" VALUES ('9fba6285a95a8768255e5857569ebc26', 'BQsDAAAAEAoBMAAAAAVkZWJ1ZwoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZRcSZ3Jp
enpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsFwwrNjE0ODIxNzYzNDMAAAAVbG9nZ2Vk
aW5fcGhvbmVfbnVtYmVyCIEAAAALbG9nZ2VkaW5faWQIgQAAAA5sb2dnZWRpbl9hZG1pbhcEU21p
dAAAAA9sb2dnZWRpbl9mYW1pbHkXBWFkbWluAAAAEmxvZ2dlZGluX2dyb3VwbmFtZQoCMjUAAAAL
cGFnZV9sZW5ndGgKIDlmYmE2Mjg1YTk1YTg3NjgyNTVlNTg1NzU2OWViYzI2AAAAC19zZXNzaW9u
X2lkFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4IgQAAAAhsb2dnZWRpbhcFYWRt
aW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24X
FEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQiBAAAAFmxvZ2dl
ZGluX2dyb3Vwbm5hbWVfaWQ=
');
INSERT INTO "public"."sessions" VALUES ('af95ad363ff81223976aff5482b2e59c', 'BQsDAAAAEAogYWY5NWFkMzYzZmY4MTIyMzk3NmFmZjU0ODJiMmU1OWMAAAALX3Nlc3Npb25faWQK
ATAAAAAFZGVidWcKDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XEmdyaXp6bHlAc21p
dC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFwwr
NjE0ODIxNzYzNDMAAAAVbG9nZ2VkaW5fcGhvbmVfbnVtYmVyFwRTbWl0AAAAD2xvZ2dlZGluX2Zh
bWlseRcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUIgQAAAA5sb2dnZWRpbl9hZG1pbhcURnJh
bmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCIEAAAAIbG9nZ2VkaW4K
AjIzAAAAC3BhZ2VfbGVuZ3RoFw9GcmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4IgQAA
AAtsb2dnZWRpbl9pZAiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQKD3BhZ2VeZ3JpenotcGFn
ZQAAAAxjdXJyZW50X3BhZ2U=
');
INSERT INTO "public"."sessions" VALUES ('9a075a2b3a3d0a15d9b2461d1011f0de', 'BQsDAAAAEAoBMAAAAAVkZWJ1ZwoCMjUAAAALcGFnZV9sZW5ndGgIhAAAABZsb2dnZWRpbl9ncm91
cG5uYW1lX2lkCiA5YTA3NWEyYjNhM2QwYTE1ZDliMjQ2MWQxMDExZjBkZQAAAAtfc2Vzc2lvbl9p
ZAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbgiBAAAADmxvZ2dlZGluX2FkbWluFw9G
cmFuY2lzIEdyaXp6bHkAAAAObG9nZ2VkaW5fZ2l2ZW4XFEZyYW5jaXMgR3JpenpseSBTbWl0AAAA
FWxvZ2dlZGluX2Rpc3BsYXlfbmFtZQiDAAAACGxvZ2dlZGluCg9wYWdlXmdyaXp6LXBhZ2UAAAAM
Y3VycmVudF9wYWdlCIMAAAALbG9nZ2VkaW5faWQXB2dyaXp6bHkAAAASbG9nZ2VkaW5fZ3JvdXBu
YW1lFxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXB2dyaXp6bHkAAAARbG9n
Z2VkaW5fdXNlcm5hbWUXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5FwwrNjE0ODIxNzYzNDMAAAAV
bG9nZ2VkaW5fcGhvbmVfbnVtYmVy
');
INSERT INTO "public"."sessions" VALUES ('7d7e000b95cab44c7a3b82813f3a2a1a', 'BQsDAAAAEAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcPRnJhbmNpcyBHcml6emx5
AAAADmxvZ2dlZGluX2dpdmVuCg9wYWdlXmdyaXp6LXBhZ2UAAAAMY3VycmVudF9wYWdlCIEAAAAW
bG9nZ2VkaW5fZ3JvdXBubmFtZV9pZBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5f
ZGlzcGxheV9uYW1lCiA3ZDdlMDAwYjk1Y2FiNDRjN2EzYjgyODEzZjNhMmExYQAAAAtfc2Vzc2lv
bl9pZBcEU21pdAAAAA9sb2dnZWRpbl9mYW1pbHkXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1l
FxJncml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwKATAAAAAFZGVidWcXBWFkbWlu
AAAAEmxvZ2dlZGluX2dyb3VwbmFtZQiBAAAACGxvZ2dlZGluCIEAAAALbG9nZ2VkaW5faWQIgQAA
AA5sb2dnZWRpbl9hZG1pbgoCMjUAAAALcGFnZV9sZW5ndGgXDCs2MTQ4MjE3NjM0MwAAABVsb2dn
ZWRpbl9waG9uZV9udW1iZXI=
');
INSERT INTO "public"."sessions" VALUES ('61eb1c60e9c2b04d8711440ad166d59a', 'BQsDAAAAEAogNjFlYjFjNjBlOWMyYjA0ZDg3MTE0NDBhZDE2NmQ1OWEAAAALX3Nlc3Npb25faWQX
D0ZyYW5jaXMgR3JpenpseQAAAA5sb2dnZWRpbl9naXZlbhcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dl
ZGluX3Bob25lX251bWJlcgiBAAAAC2xvZ2dlZGluX2lkFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91
cG5hbWUKATEAAAAFZGVidWcIgQAAAA5sb2dnZWRpbl9hZG1pbhcEU21pdAAAAA9sb2dnZWRpbl9m
YW1pbHkKD3BhZ2VeZ3JpenotcGFnZQAAAAxjdXJyZW50X3BhZ2UXBWFkbWluAAAAEWxvZ2dlZGlu
X3VzZXJuYW1lFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5X25hbWUI
gQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0
aW9uCIEAAAAIbG9nZ2VkaW4KAjI1AAAAC3BhZ2VfbGVuZ3RoFxJncml6emx5QHNtaXQuaWQuYXUA
AAAObG9nZ2VkaW5fZW1haWw=
');
INSERT INTO "public"."sessions" VALUES ('6066c112263af0046fa9d0b23ca1b0b9', 'BQsDAAAAEAoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZQoMYWxsX3NlY3Rpb25zAAAA
D2N1cnJlbnRfc2VjdGlvbhcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsFwVh
ZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUIgQAAAA5sb2dnZWRpbl9hZG1pbhcMKzYxNDgyMTc2
MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlchcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dlZGlu
X2dpdmVuCIEAAAALbG9nZ2VkaW5faWQXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGlu
X2Rpc3BsYXlfbmFtZQiBAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQIgQAAAAhsb2dnZWRpbhcE
U21pdAAAAA9sb2dnZWRpbl9mYW1pbHkKATEAAAAFZGVidWcKAjI1AAAAC3BhZ2VfbGVuZ3RoCiA2
MDY2YzExMjI2M2FmMDA0NmZhOWQwYjIzY2ExYjBiOQAAAAtfc2Vzc2lvbl9pZBcFYWRtaW4AAAAR
bG9nZ2VkaW5fdXNlcm5hbWU=
');
INSERT INTO "public"."sessions" VALUES ('281b65c1f653ac310f978d5dfcc2554f', 'BQsDAAAAAQogMjgxYjY1YzFmNjUzYWMzMTBmOTc4ZDVkZmNjMjU1NGYAAAALX3Nlc3Npb25faWQ=
');
INSERT INTO "public"."sessions" VALUES ('5a5965dc25adf870510ea76a4ba34053', 'BQsDAAAAEAoBMAAAAAVkZWJ1ZwoPcGFnZV5ncml6ei1wYWdlAAAADGN1cnJlbnRfcGFnZRcURnJh
bmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCIEAAAAObG9nZ2VkaW5f
YWRtaW4IgQAAAAtsb2dnZWRpbl9pZBcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lCIEAAAAI
bG9nZ2VkaW4IgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkCiA1YTU5NjVkYzI1YWRmODcwNTEw
ZWE3NmE0YmEzNDA1MwAAAAtfc2Vzc2lvbl9pZAoCMjUAAAALcGFnZV9sZW5ndGgXD0ZyYW5jaXMg
R3JpenpseQAAAA5sb2dnZWRpbl9naXZlbgoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlv
bhcFYWRtaW4AAAARbG9nZ2VkaW5fdXNlcm5hbWUXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5FxJn
cml6emx5QHNtaXQuaWQuYXUAAAAObG9nZ2VkaW5fZW1haWwXDCs2MTQ4MjE3NjM0MwAAABVsb2dn
ZWRpbl9waG9uZV9udW1iZXI=
');
INSERT INTO "public"."sessions" VALUES ('0cb349dfc2c740682c3cd98e56055331', 'BQsDAAAAEAiCAAAAC2xvZ2dlZGluX2lkFwtncml6emx5c21pdAAAABFsb2dnZWRpbl91c2VybmFt
ZQoBMAAAAAVkZWJ1ZwiDAAAAFmxvZ2dlZGluX2dyb3Vwbm5hbWVfaWQXDCs2MTQ4MjE3NjM0MwAA
ABVsb2dnZWRpbl9waG9uZV9udW1iZXIKAjI1AAAAC3BhZ2VfbGVuZ3RoFw9GcmFuY2lzIEdyaXp6
bHkAAAAObG9nZ2VkaW5fZ2l2ZW4XBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5CiAwY2IzNDlkZmMy
Yzc0MDY4MmMzY2Q5OGU1NjA1NTMzMQAAAAtfc2Vzc2lvbl9pZAoPcGFnZV5ncml6ei1wYWdlAAAA
DGN1cnJlbnRfcGFnZRcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9u
YW1lCIIAAAAIbG9nZ2VkaW4KDGFsbF9zZWN0aW9ucwAAAA9jdXJyZW50X3NlY3Rpb24XEmdyaXp6
bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcLZ3JpenpseXNtaXQAAAASbG9nZ2VkaW5f
Z3JvdXBuYW1lCIEAAAAObG9nZ2VkaW5fYWRtaW4=
');
INSERT INTO "public"."sessions" VALUES ('4a0feba8987207c61a2d147f14760b98', 'BQsDAAAAEBcMKzYxNDgyMTc2MzQzAAAAFWxvZ2dlZGluX3Bob25lX251bWJlcgoBMQAAAAVkZWJ1
ZwiBAAAACGxvZ2dlZGluFxRGcmFuY2lzIEdyaXp6bHkgU21pdAAAABVsb2dnZWRpbl9kaXNwbGF5
X25hbWUXBWFkbWluAAAAEWxvZ2dlZGluX3VzZXJuYW1lFxJncml6emx5QHNtaXQuaWQuYXUAAAAO
bG9nZ2VkaW5fZW1haWwXBFNtaXQAAAAPbG9nZ2VkaW5fZmFtaWx5Cg9wYWdlXmdyaXp6LXBhZ2UA
AAAMY3VycmVudF9wYWdlCIEAAAAWbG9nZ2VkaW5fZ3JvdXBubmFtZV9pZAogNGEwZmViYTg5ODcy
MDdjNjFhMmQxNDdmMTQ3NjBiOTgAAAALX3Nlc3Npb25faWQIgQAAAAtsb2dnZWRpbl9pZAiBAAAA
DmxvZ2dlZGluX2FkbWluCgIyNQAAAAtwYWdlX2xlbmd0aAoMYWxsX3NlY3Rpb25zAAAAD2N1cnJl
bnRfc2VjdGlvbhcFYWRtaW4AAAASbG9nZ2VkaW5fZ3JvdXBuYW1lFw9GcmFuY2lzIEdyaXp6bHkA
AAAObG9nZ2VkaW5fZ2l2ZW4=
');
INSERT INTO "public"."sessions" VALUES ('a80e7c908368932b05e9e81ce15a80eb', 'BQsDAAAAEBcSZ3JpenpseUBzbWl0LmlkLmF1AAAADmxvZ2dlZGluX2VtYWlsCIEAAAAIbG9nZ2Vk
aW4KATAAAAAFZGVidWcIgQAAAA5sb2dnZWRpbl9hZG1pbgoPcGFnZV5ncml6ei1wYWdlAAAADGN1
cnJlbnRfcGFnZQiBAAAAC2xvZ2dlZGluX2lkFwVhZG1pbgAAABJsb2dnZWRpbl9ncm91cG5hbWUK
AjI1AAAAC3BhZ2VfbGVuZ3RoFwRTbWl0AAAAD2xvZ2dlZGluX2ZhbWlseRcFYWRtaW4AAAARbG9n
Z2VkaW5fdXNlcm5hbWUXFEZyYW5jaXMgR3JpenpseSBTbWl0AAAAFWxvZ2dlZGluX2Rpc3BsYXlf
bmFtZQoMYWxsX3NlY3Rpb25zAAAAD2N1cnJlbnRfc2VjdGlvbhcMKzYxNDgyMTc2MzQzAAAAFWxv
Z2dlZGluX3Bob25lX251bWJlcgogYTgwZTdjOTA4MzY4OTMyYjA1ZTllODFjZTE1YTgwZWIAAAAL
X3Nlc3Npb25faWQIgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkFw9GcmFuY2lzIEdyaXp6bHkA
AAAObG9nZ2VkaW5fZ2l2ZW4=
');
INSERT INTO "public"."sessions" VALUES ('d888bfa0675f5fe3d0082cc845cd9367', 'BQsDAAAAEBcURnJhbmNpcyBHcml6emx5IFNtaXQAAAAVbG9nZ2VkaW5fZGlzcGxheV9uYW1lCIEA
AAAObG9nZ2VkaW5fYWRtaW4IgQAAABZsb2dnZWRpbl9ncm91cG5uYW1lX2lkCIEAAAAIbG9nZ2Vk
aW4KAjI1AAAAC3BhZ2VfbGVuZ3RoCgxhbGxfc2VjdGlvbnMAAAAPY3VycmVudF9zZWN0aW9uFwVh
ZG1pbgAAABFsb2dnZWRpbl91c2VybmFtZQiBAAAAC2xvZ2dlZGluX2lkFwRTbWl0AAAAD2xvZ2dl
ZGluX2ZhbWlseQoBMAAAAAVkZWJ1ZwogZDg4OGJmYTA2NzVmNWZlM2QwMDgyY2M4NDVjZDkzNjcA
AAALX3Nlc3Npb25faWQXDCs2MTQ4MjE3NjM0MwAAABVsb2dnZWRpbl9waG9uZV9udW1iZXIXEmdy
aXp6bHlAc21pdC5pZC5hdQAAAA5sb2dnZWRpbl9lbWFpbBcFYWRtaW4AAAASbG9nZ2VkaW5fZ3Jv
dXBuYW1lCgdwYWdlXndwAAAADGN1cnJlbnRfcGFnZRcPRnJhbmNpcyBHcml6emx5AAAADmxvZ2dl
ZGluX2dpdmVu
');


--
-- TOC entry 3751 (class 0 OID 0)
-- Dependencies: 211
-- Name: _group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."_group_id_seq"', 22, true);


--
-- TOC entry 3752 (class 0 OID 0)
-- Dependencies: 213
-- Name: address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."address_id_seq"', 23, true);


--
-- TOC entry 3753 (class 0 OID 0)
-- Dependencies: 216
-- Name: addresses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."addresses_id_seq"', 1, false);


--
-- TOC entry 3754 (class 0 OID 0)
-- Dependencies: 219
-- Name: alias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."alias_id_seq"', 35, true);


--
-- TOC entry 3755 (class 0 OID 0)
-- Dependencies: 227
-- Name: countries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."countries_id_seq"', 524, true);


--
-- TOC entry 3756 (class 0 OID 0)
-- Dependencies: 256
-- Name: country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."country_id_seq"', 91, true);


--
-- TOC entry 3757 (class 0 OID 0)
-- Dependencies: 258
-- Name: country_regions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."country_regions_id_seq"', 549, true);


--
-- TOC entry 3758 (class 0 OID 0)
-- Dependencies: 228
-- Name: email_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."email_id_seq"', 19, true);


--
-- TOC entry 3759 (class 0 OID 0)
-- Dependencies: 230
-- Name: emails_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."emails_id_seq"', 1, false);


--
-- TOC entry 3760 (class 0 OID 0)
-- Dependencies: 232
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."groups_id_seq"', 244, true);


--
-- TOC entry 3761 (class 0 OID 0)
-- Dependencies: 220
-- Name: links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."links_id_seq"', 57, true);


--
-- TOC entry 3762 (class 0 OID 0)
-- Dependencies: 234
-- Name: links_id_seq1; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."links_id_seq1"', 135, true);


--
-- TOC entry 3763 (class 0 OID 0)
-- Dependencies: 239
-- Name: page_section_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."page_section_id_seq"', 89, true);


--
-- TOC entry 3764 (class 0 OID 0)
-- Dependencies: 243
-- Name: pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."pages_id_seq"', 45, true);


--
-- TOC entry 3765 (class 0 OID 0)
-- Dependencies: 246
-- Name: passwd_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."passwd_details_id_seq"', 18, true);


--
-- TOC entry 3766 (class 0 OID 0)
-- Dependencies: 244
-- Name: passwd_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."passwd_id_seq"', 18, true);


--
-- TOC entry 3767 (class 0 OID 0)
-- Dependencies: 248
-- Name: phone_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."phone_id_seq"', 32, true);


--
-- TOC entry 3768 (class 0 OID 0)
-- Dependencies: 250
-- Name: phones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."phones_id_seq"', 1, false);


--
-- TOC entry 3769 (class 0 OID 0)
-- Dependencies: 252
-- Name: psudo_pages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: grizzlysmit
--

SELECT pg_catalog.setval('"public"."psudo_pages_id_seq"', 8, true);


--
-- TOC entry 3399 (class 2606 OID 17053)
-- Name: _group _group_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."_group"
    ADD CONSTRAINT "_group_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3403 (class 2606 OID 17055)
-- Name: address address_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."address"
    ADD CONSTRAINT "address_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3405 (class 2606 OID 17057)
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."addresses"
    ADD CONSTRAINT "addresses_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3407 (class 2606 OID 17059)
-- Name: alias alias_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3409 (class 2606 OID 17061)
-- Name: alias alias_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_unique_contraint_name" UNIQUE ("name");


--
-- TOC entry 3454 (class 2606 OID 17311)
-- Name: country country_cc_ukey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."country"
    ADD CONSTRAINT "country_cc_ukey" UNIQUE ("cc");


--
-- TOC entry 3456 (class 2606 OID 17309)
-- Name: country country_name_ukey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."country"
    ADD CONSTRAINT "country_name_ukey" UNIQUE ("_name");


--
-- TOC entry 3458 (class 2606 OID 17307)
-- Name: country country_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."country"
    ADD CONSTRAINT "country_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3460 (class 2606 OID 17323)
-- Name: country_regions country_regions_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."country_regions"
    ADD CONSTRAINT "country_regions_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3422 (class 2606 OID 17069)
-- Name: email email_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."email"
    ADD CONSTRAINT "email_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3424 (class 2606 OID 17071)
-- Name: emails emails_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."emails"
    ADD CONSTRAINT "emails_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3401 (class 2606 OID 17073)
-- Name: _group group_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."_group"
    ADD CONSTRAINT "group_unique_key" UNIQUE ("_name");


--
-- TOC entry 3426 (class 2606 OID 17075)
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3428 (class 2606 OID 17077)
-- Name: groups groups_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_unique_key" UNIQUE ("group_id", "passwd_id");


--
-- TOC entry 3411 (class 2606 OID 17079)
-- Name: links_sections links_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3417 (class 2606 OID 17081)
-- Name: links links_pkey1; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_pkey1" PRIMARY KEY ("id");


--
-- TOC entry 3414 (class 2606 OID 17083)
-- Name: links_sections links_sections_unnique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_sections_unnique_key" UNIQUE ("section");


--
-- TOC entry 3419 (class 2606 OID 17085)
-- Name: links links_unique_contraint_name; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_unique_contraint_name" UNIQUE ("section_id", "name");


--
-- TOC entry 3430 (class 2606 OID 17087)
-- Name: page_section page_section_unique; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "page_section_unique" UNIQUE ("pages_id", "links_section_id");


--
-- TOC entry 3434 (class 2606 OID 17089)
-- Name: pages page_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "page_unique_key" UNIQUE ("name");


--
-- TOC entry 3446 (class 2606 OID 17091)
-- Name: passwd_details passwd_details_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3442 (class 2606 OID 17093)
-- Name: passwd passwd_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3444 (class 2606 OID 17095)
-- Name: passwd passwd_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_unique_key" UNIQUE ("username");


--
-- TOC entry 3448 (class 2606 OID 17097)
-- Name: phone phone_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."phone"
    ADD CONSTRAINT "phone_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3450 (class 2606 OID 17099)
-- Name: phones phones_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."phones"
    ADD CONSTRAINT "phones_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3436 (class 2606 OID 17101)
-- Name: pages pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "pkey" PRIMARY KEY ("id");


--
-- TOC entry 3438 (class 2606 OID 17103)
-- Name: pseudo_pages pseudo_pages_unique_key; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "pseudo_pages_unique_key" UNIQUE ("name");


--
-- TOC entry 3432 (class 2606 OID 17105)
-- Name: page_section psge_section_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "psge_section_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3440 (class 2606 OID 17107)
-- Name: pseudo_pages psudo_pages_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "psudo_pages_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3452 (class 2606 OID 17109)
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."sessions"
    ADD CONSTRAINT "sessions_pkey" PRIMARY KEY ("id");


--
-- TOC entry 3415 (class 1259 OID 17110)
-- Name: fki_section_fkey; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE INDEX "fki_section_fkey" ON "public"."links" USING "btree" ("section_id");


--
-- TOC entry 3412 (class 1259 OID 17111)
-- Name: links_sections_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX "links_sections_unique_key" ON "public"."links_sections" USING "btree" ("section" COLLATE "C" "text_pattern_ops");


--
-- TOC entry 3420 (class 1259 OID 17112)
-- Name: links_unique_key; Type: INDEX; Schema: public; Owner: grizzlysmit
--

CREATE UNIQUE INDEX "links_unique_key" ON "public"."links" USING "btree" ("name" COLLATE "POSIX" "bpchar_pattern_ops", "section_id");

ALTER TABLE "public"."links" CLUSTER ON "links_unique_key";


--
-- TOC entry 3461 (class 2606 OID 17113)
-- Name: addresses addresses_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."addresses"
    ADD CONSTRAINT "addresses_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."address"("id") NOT VALID;


--
-- TOC entry 3462 (class 2606 OID 17118)
-- Name: addresses addresses_passwd_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."addresses"
    ADD CONSTRAINT "addresses_passwd_id_fkey" FOREIGN KEY ("passwd_id") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3465 (class 2606 OID 17123)
-- Name: alias alias_foriegn_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_foriegn_key" FOREIGN KEY ("target") REFERENCES "public"."links_sections"("id") NOT VALID;


--
-- TOC entry 3466 (class 2606 OID 17128)
-- Name: alias alias_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3467 (class 2606 OID 17133)
-- Name: alias alias_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3496 (class 2606 OID 17324)
-- Name: country_regions country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."country_regions"
    ADD CONSTRAINT "country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "public"."country"("id");


--
-- TOC entry 3473 (class 2606 OID 17138)
-- Name: emails emails_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."emails"
    ADD CONSTRAINT "emails_email_fkey" FOREIGN KEY ("email_id") REFERENCES "public"."email"("id");


--
-- TOC entry 3474 (class 2606 OID 17143)
-- Name: emails emails_passwd_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."emails"
    ADD CONSTRAINT "emails_passwd_id_fkey" FOREIGN KEY ("passwd_id") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3475 (class 2606 OID 17148)
-- Name: groups groups_address_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_address_foreign_key" FOREIGN KEY ("passwd_id") REFERENCES "public"."passwd"("id");


--
-- TOC entry 3476 (class 2606 OID 17153)
-- Name: groups groups_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_foreign_key" FOREIGN KEY ("group_id") REFERENCES "public"."_group"("id");


--
-- TOC entry 3470 (class 2606 OID 17158)
-- Name: links links_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3477 (class 2606 OID 17163)
-- Name: page_section links_section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "links_section_fkey" FOREIGN KEY ("links_section_id") REFERENCES "public"."links_sections"("id");


--
-- TOC entry 3468 (class 2606 OID 17168)
-- Name: links_sections links_sections_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_sections_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3469 (class 2606 OID 17173)
-- Name: links_sections links_sections_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_sections_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3471 (class 2606 OID 17178)
-- Name: links links_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3478 (class 2606 OID 17183)
-- Name: page_section page_section_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "page_section_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3479 (class 2606 OID 17188)
-- Name: page_section page_section_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "page_section_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3480 (class 2606 OID 17193)
-- Name: page_section pages_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "pages_fkey" FOREIGN KEY ("pages_id") REFERENCES "public"."pages"("id");


--
-- TOC entry 3481 (class 2606 OID 17198)
-- Name: pages pages_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "pages_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3482 (class 2606 OID 17203)
-- Name: pages pages_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "pages_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3492 (class 2606 OID 17341)
-- Name: passwd_details passwd_details_cc_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_cc_fkey" FOREIGN KEY ("country_id") REFERENCES "public"."country"("id") NOT VALID;


--
-- TOC entry 3485 (class 2606 OID 17213)
-- Name: passwd passwd_details_connection_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_details_connection_fkey" FOREIGN KEY ("passwd_details_id") REFERENCES "public"."passwd_details"("id") NOT VALID;


--
-- TOC entry 3493 (class 2606 OID 17351)
-- Name: passwd_details passwd_details_cr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_cr_fkey" FOREIGN KEY ("country_region_id") REFERENCES "public"."country_regions"("id") NOT VALID;


--
-- TOC entry 3488 (class 2606 OID 17218)
-- Name: passwd_details passwd_details_p_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_p_phone_fkey" FOREIGN KEY ("primary_phone_id") REFERENCES "public"."phone"("id") NOT VALID;


--
-- TOC entry 3489 (class 2606 OID 17223)
-- Name: passwd_details passwd_details_post_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_post_foreign_key" FOREIGN KEY ("postal_address_id") REFERENCES "public"."address"("id");


--
-- TOC entry 3490 (class 2606 OID 17228)
-- Name: passwd_details passwd_details_res_foreign_key; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_res_foreign_key" FOREIGN KEY ("residential_address_id") REFERENCES "public"."address"("id");


--
-- TOC entry 3491 (class 2606 OID 17233)
-- Name: passwd_details passwd_details_sec_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_sec_phone_fkey" FOREIGN KEY ("secondary_phone_id") REFERENCES "public"."phone"("id") NOT VALID;


--
-- TOC entry 3486 (class 2606 OID 17238)
-- Name: passwd passwd_group_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_group_fkey" FOREIGN KEY ("primary_group_id") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3487 (class 2606 OID 17243)
-- Name: passwd passwd_primary_email_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_primary_email_fkey" FOREIGN KEY ("email_id") REFERENCES "public"."email"("id") NOT VALID;


--
-- TOC entry 3494 (class 2606 OID 17248)
-- Name: phones phones_address_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."phones"
    ADD CONSTRAINT "phones_address_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."address"("id");


--
-- TOC entry 3495 (class 2606 OID 17253)
-- Name: phones phones_phone_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."phones"
    ADD CONSTRAINT "phones_phone_fkey" FOREIGN KEY ("phone_id") REFERENCES "public"."phone"("id");


--
-- TOC entry 3483 (class 2606 OID 17258)
-- Name: pseudo_pages pseudo_pages_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "pseudo_pages_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;


--
-- TOC entry 3484 (class 2606 OID 17263)
-- Name: pseudo_pages pseudo_pages_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "pseudo_pages_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;


--
-- TOC entry 3472 (class 2606 OID 17268)
-- Name: links section_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "section_fkey" FOREIGN KEY ("section_id") REFERENCES "public"."links_sections"("id") ON UPDATE RESTRICT;


--
-- TOC entry 3463 (class 2606 OID 17273)
-- Name: secure secure_groupid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."secure"
    ADD CONSTRAINT "secure_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id");


--
-- TOC entry 3464 (class 2606 OID 17278)
-- Name: secure secure_userid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grizzlysmit
--

ALTER TABLE ONLY "public"."secure"
    ADD CONSTRAINT "secure_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id");


--
-- TOC entry 3692 (class 0 OID 0)
-- Dependencies: 3691
-- Name: DATABASE "urls"; Type: ACL; Schema: -; Owner: grizzlysmit
--

GRANT CONNECT ON DATABASE "urls" TO "urluser";


--
-- TOC entry 3694 (class 0 OID 0)
-- Dependencies: 964
-- Name: TYPE "perm_set"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON TYPE "public"."perm_set" TO "urluser" WITH GRANT OPTION;


--
-- TOC entry 3695 (class 0 OID 0)
-- Dependencies: 965
-- Name: TYPE "perms"; Type: ACL; Schema: public; Owner: grizzlysmit
--

REVOKE ALL ON TYPE "public"."perms" FROM "grizzlysmit";
GRANT ALL ON TYPE "public"."perms" TO "urluser" WITH GRANT OPTION;
GRANT ALL ON TYPE "public"."perms" TO "grizzlysmit" WITH GRANT OPTION;


--
-- TOC entry 3696 (class 0 OID 0)
-- Dependencies: 211
-- Name: SEQUENCE "_group_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."_group_id_seq" TO "urluser";


--
-- TOC entry 3697 (class 0 OID 0)
-- Dependencies: 212
-- Name: TABLE "_group"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON TABLE "public"."_group" TO "urluser";


--
-- TOC entry 3698 (class 0 OID 0)
-- Dependencies: 213
-- Name: SEQUENCE "address_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."address_id_seq" TO "urluser";


--
-- TOC entry 3699 (class 0 OID 0)
-- Dependencies: 214
-- Name: TABLE "address"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."address" TO "urluser";


--
-- TOC entry 3700 (class 0 OID 0)
-- Dependencies: 215
-- Name: TABLE "addresses"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."addresses" TO "urluser";


--
-- TOC entry 3702 (class 0 OID 0)
-- Dependencies: 217
-- Name: TABLE "secure"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."secure" TO "urluser";


--
-- TOC entry 3703 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE "alias"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias" TO "urluser";


--
-- TOC entry 3705 (class 0 OID 0)
-- Dependencies: 219
-- Name: SEQUENCE "alias_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."alias_id_seq" TO "urluser";


--
-- TOC entry 3706 (class 0 OID 0)
-- Dependencies: 220
-- Name: SEQUENCE "links_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."links_id_seq" TO "urluser";


--
-- TOC entry 3707 (class 0 OID 0)
-- Dependencies: 221
-- Name: TABLE "links_sections"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."links_sections" TO "urluser";


--
-- TOC entry 3708 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE "alias_links"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias_links" TO "urluser";


--
-- TOC entry 3709 (class 0 OID 0)
-- Dependencies: 223
-- Name: TABLE "links"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."links" TO "urluser";


--
-- TOC entry 3710 (class 0 OID 0)
-- Dependencies: 224
-- Name: TABLE "alias_union_links"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias_union_links" TO "urluser";


--
-- TOC entry 3711 (class 0 OID 0)
-- Dependencies: 225
-- Name: TABLE "alias_union_links_sections"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias_union_links_sections" TO "urluser";


--
-- TOC entry 3712 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE "aliases"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."aliases" TO "urluser";


--
-- TOC entry 3713 (class 0 OID 0)
-- Dependencies: 256
-- Name: SEQUENCE "country_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."country_id_seq" TO "urluser";


--
-- TOC entry 3714 (class 0 OID 0)
-- Dependencies: 257
-- Name: TABLE "country"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."country" TO "urluser";


--
-- TOC entry 3715 (class 0 OID 0)
-- Dependencies: 258
-- Name: SEQUENCE "country_regions_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."country_regions_id_seq" TO "urluser";


--
-- TOC entry 3716 (class 0 OID 0)
-- Dependencies: 259
-- Name: TABLE "country_regions"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."country_regions" TO "urluser";


--
-- TOC entry 3717 (class 0 OID 0)
-- Dependencies: 260
-- Name: TABLE "countries"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."countries" TO "urluser";


--
-- TOC entry 3718 (class 0 OID 0)
-- Dependencies: 227
-- Name: SEQUENCE "countries_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."countries_id_seq" TO "urluser";


--
-- TOC entry 3719 (class 0 OID 0)
-- Dependencies: 228
-- Name: SEQUENCE "email_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."email_id_seq" TO "urluser";


--
-- TOC entry 3720 (class 0 OID 0)
-- Dependencies: 229
-- Name: TABLE "email"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."email" TO "urluser";


--
-- TOC entry 3721 (class 0 OID 0)
-- Dependencies: 230
-- Name: SEQUENCE "emails_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."emails_id_seq" TO "urluser";


--
-- TOC entry 3722 (class 0 OID 0)
-- Dependencies: 231
-- Name: TABLE "emails"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."emails" TO "urluser";


--
-- TOC entry 3723 (class 0 OID 0)
-- Dependencies: 232
-- Name: SEQUENCE "groups_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."groups_id_seq" TO "urluser";


--
-- TOC entry 3724 (class 0 OID 0)
-- Dependencies: 233
-- Name: TABLE "groups"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."groups" TO "urluser";


--
-- TOC entry 3726 (class 0 OID 0)
-- Dependencies: 234
-- Name: SEQUENCE "links_id_seq1"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."links_id_seq1" TO "urluser";


--
-- TOC entry 3727 (class 0 OID 0)
-- Dependencies: 235
-- Name: TABLE "links_sections_join_links"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."links_sections_join_links" TO "urluser";


--
-- TOC entry 3728 (class 0 OID 0)
-- Dependencies: 236
-- Name: TABLE "page_section"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."page_section" TO "urluser";


--
-- TOC entry 3729 (class 0 OID 0)
-- Dependencies: 237
-- Name: TABLE "pages"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."pages" TO "urluser";


--
-- TOC entry 3730 (class 0 OID 0)
-- Dependencies: 238
-- Name: TABLE "page_link_view"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."page_link_view" TO "urluser";


--
-- TOC entry 3732 (class 0 OID 0)
-- Dependencies: 239
-- Name: SEQUENCE "page_section_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."page_section_id_seq" TO "urluser";


--
-- TOC entry 3733 (class 0 OID 0)
-- Dependencies: 240
-- Name: TABLE "page_view"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."page_view" TO "urluser";


--
-- TOC entry 3734 (class 0 OID 0)
-- Dependencies: 241
-- Name: TABLE "pseudo_pages"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."pseudo_pages" TO "urluser";


--
-- TOC entry 3735 (class 0 OID 0)
-- Dependencies: 242
-- Name: TABLE "pagelike"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."pagelike" TO "urluser";


--
-- TOC entry 3737 (class 0 OID 0)
-- Dependencies: 243
-- Name: SEQUENCE "pages_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."pages_id_seq" TO "urluser";


--
-- TOC entry 3738 (class 0 OID 0)
-- Dependencies: 244
-- Name: SEQUENCE "passwd_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."passwd_id_seq" TO "urluser";


--
-- TOC entry 3739 (class 0 OID 0)
-- Dependencies: 245
-- Name: TABLE "passwd"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."passwd" TO "urluser";


--
-- TOC entry 3740 (class 0 OID 0)
-- Dependencies: 246
-- Name: SEQUENCE "passwd_details_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."passwd_details_id_seq" TO "urluser";


--
-- TOC entry 3741 (class 0 OID 0)
-- Dependencies: 247
-- Name: TABLE "passwd_details"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."passwd_details" TO "urluser";


--
-- TOC entry 3742 (class 0 OID 0)
-- Dependencies: 248
-- Name: SEQUENCE "phone_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."phone_id_seq" TO "urluser";


--
-- TOC entry 3743 (class 0 OID 0)
-- Dependencies: 249
-- Name: TABLE "phone"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."phone" TO "urluser";


--
-- TOC entry 3744 (class 0 OID 0)
-- Dependencies: 250
-- Name: SEQUENCE "phones_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."phones_id_seq" TO "urluser";


--
-- TOC entry 3745 (class 0 OID 0)
-- Dependencies: 251
-- Name: TABLE "phones"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."phones" TO "urluser";


--
-- TOC entry 3747 (class 0 OID 0)
-- Dependencies: 252
-- Name: SEQUENCE "psudo_pages_id_seq"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT ALL ON SEQUENCE "public"."psudo_pages_id_seq" TO "urluser";


--
-- TOC entry 3748 (class 0 OID 0)
-- Dependencies: 253
-- Name: TABLE "sections"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."sections" TO "urluser";


--
-- TOC entry 3749 (class 0 OID 0)
-- Dependencies: 254
-- Name: TABLE "sessions"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."sessions" TO "urluser";


--
-- TOC entry 3750 (class 0 OID 0)
-- Dependencies: 255
-- Name: TABLE "vlinks"; Type: ACL; Schema: public; Owner: grizzlysmit
--

GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."vlinks" TO "urluser";


--
-- TOC entry 2174 (class 826 OID 17283)
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: -; Owner: grizzlysmit
--

ALTER DEFAULT PRIVILEGES FOR ROLE "grizzlysmit" GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLES  TO "urluser";


-- Completed on 2022-06-17 23:23:22 AEST

--
-- PostgreSQL database dump complete
--

