PGDMP  +                    |            urls #   14.7 (Ubuntu 14.7-0ubuntu0.22.10.1) #   16.4 (Ubuntu 16.4-0ubuntu0.24.04.1) �    }           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            ~           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    20083    urls    DATABASE     r   CREATE DATABASE "urls" WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_AU.UTF-8';
    DROP DATABASE "urls";
                grizzlysmit    false            �           0    0    DATABASE "urls"    ACL     /   GRANT CONNECT ON DATABASE "urls" TO "urluser";
                   grizzlysmit    false    3712            �           0    0    urls    DATABASE PROPERTIES     J   ALTER ROLE "urluser" IN DATABASE "urls" SET "client_encoding" TO 'UTF-8';
                     grizzlysmit    false                        2615    2200    public    SCHEMA        CREATE SCHEMA "public";
    DROP SCHEMA "public";
                postgres    false            �           0    0    SCHEMA "public"    COMMENT     8   COMMENT ON SCHEMA "public" IS 'standard public schema';
                   postgres    false    4            �           0    0    SCHEMA "public"    ACL     U   REVOKE USAGE ON SCHEMA "public" FROM PUBLIC;
GRANT ALL ON SCHEMA "public" TO PUBLIC;
                   postgres    false    4            �           1247    20086    perm_set    TYPE     ]   CREATE TYPE "public"."perm_set" AS (
	"_read" boolean,
	"_write" boolean,
	"_del" boolean
);
    DROP TYPE "public"."perm_set";
       public          grizzlysmit    false    4            �           0    0    TYPE "perm_set"    ACL     F   GRANT ALL ON TYPE "public"."perm_set" TO "urluser" WITH GRANT OPTION;
          public          grizzlysmit    false    979            �           1247    20089    perms    TYPE     �   CREATE TYPE "public"."perms" AS (
	"_user" "public"."perm_set",
	"_group" "public"."perm_set",
	"_other" "public"."perm_set"
);
    DROP TYPE "public"."perms";
       public          grizzlysmit    false    4    979    979    979            �           0    0    TYPE "perms"    ACL     �   REVOKE ALL ON TYPE "public"."perms" FROM "grizzlysmit";
GRANT ALL ON TYPE "public"."perms" TO "grizzlysmit" WITH GRANT OPTION;
GRANT ALL ON TYPE "public"."perms" TO "urluser" WITH GRANT OPTION;
          public          grizzlysmit    false    980            p           1247    20091    status    TYPE     g   CREATE TYPE "public"."status" AS ENUM (
    'invalid',
    'unassigned',
    'assigned',
    'both'
);
    DROP TYPE "public"."status";
       public          grizzlysmit    false    4            �            1259    20099    _group_id_seq    SEQUENCE     z   CREATE SEQUENCE "public"."_group_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE "public"."_group_id_seq";
       public          grizzlysmit    false    4            �           0    0    SEQUENCE "_group_id_seq"    ACL     =   GRANT ALL ON SEQUENCE "public"."_group_id_seq" TO "urluser";
          public          grizzlysmit    false    211            �            1259    20100    _group    TABLE     �   CREATE TABLE "public"."_group" (
    "id" bigint DEFAULT "nextval"('"public"."_group_id_seq"'::"regclass") NOT NULL,
    "_name" character varying(256) NOT NULL
);
    DROP TABLE "public"."_group";
       public         heap    grizzlysmit    false    211    4            �           0    0    TABLE "_group"    ACL     3   GRANT ALL ON TABLE "public"."_group" TO "urluser";
          public          grizzlysmit    false    212            �            1259    20104    address_id_seq    SEQUENCE     {   CREATE SEQUENCE "public"."address_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE "public"."address_id_seq";
       public          grizzlysmit    false    4            �           0    0    SEQUENCE "address_id_seq"    ACL     >   GRANT ALL ON SEQUENCE "public"."address_id_seq" TO "urluser";
          public          grizzlysmit    false    213            �            1259    20105    address    TABLE     l  CREATE TABLE "public"."address" (
    "id" bigint DEFAULT "nextval"('"public"."address_id_seq"'::"regclass") NOT NULL,
    "unit" character varying(32),
    "street" character varying(256) NOT NULL,
    "city_suburb" character varying(64),
    "postcode" character varying(16),
    "region" character varying(128),
    "country" character varying(128) NOT NULL
);
    DROP TABLE "public"."address";
       public         heap    grizzlysmit    false    213    4            �           0    0    TABLE "address"    ACL     U   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."address" TO "urluser";
          public          grizzlysmit    false    214            �            1259    20111 	   addresses    TABLE     �   CREATE TABLE "public"."addresses" (
    "id" bigint NOT NULL,
    "passwd_id" bigint NOT NULL,
    "address_id" bigint NOT NULL
);
 !   DROP TABLE "public"."addresses";
       public         heap    grizzlysmit    false    4            �           0    0    TABLE "addresses"    ACL     W   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."addresses" TO "urluser";
          public          grizzlysmit    false    215            �            1259    20114    addresses_id_seq    SEQUENCE     }   CREATE SEQUENCE "public"."addresses_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE "public"."addresses_id_seq";
       public          grizzlysmit    false    215    4            �           0    0    addresses_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE "public"."addresses_id_seq" OWNED BY "public"."addresses"."id";
          public          grizzlysmit    false    216            �            1259    20115    secure    TABLE     �   CREATE TABLE "public"."secure" (
    "userid" bigint DEFAULT 1 NOT NULL,
    "groupid" bigint DEFAULT 1 NOT NULL,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)) NOT NULL
);
    DROP TABLE "public"."secure";
       public         heap    grizzlysmit    false    980    979    4    980            �           0    0    TABLE "secure"    ACL     T   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."secure" TO "urluser";
          public          grizzlysmit    false    217            �            1259    20123    alias    TABLE     S  CREATE TABLE "public"."alias" (
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    "id" bigint NOT NULL,
    "name" character varying(50) NOT NULL,
    "target" bigint NOT NULL
)
INHERITS ("public"."secure");
    DROP TABLE "public"."alias";
       public         heap    grizzlysmit    false    980    979    4    980    217            �           0    0    TABLE "alias"    ACL     S   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias" TO "urluser";
          public          grizzlysmit    false    218            �            1259    20131    alias_id_seq    SEQUENCE     y   CREATE SEQUENCE "public"."alias_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE "public"."alias_id_seq";
       public          grizzlysmit    false    218    4            �           0    0    alias_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE "public"."alias_id_seq" OWNED BY "public"."alias"."id";
          public          grizzlysmit    false    219            �           0    0    SEQUENCE "alias_id_seq"    ACL     <   GRANT ALL ON SEQUENCE "public"."alias_id_seq" TO "urluser";
          public          grizzlysmit    false    219            �            1259    20132    links_id_seq    SEQUENCE     y   CREATE SEQUENCE "public"."links_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE "public"."links_id_seq";
       public          grizzlysmit    false    4            �           0    0    SEQUENCE "links_id_seq"    ACL     <   GRANT ALL ON SEQUENCE "public"."links_id_seq" TO "urluser";
          public          grizzlysmit    false    220            �            1259    20133    links_sections    TABLE     z  CREATE TABLE "public"."links_sections" (
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    "id" bigint DEFAULT "nextval"('"public"."links_id_seq"'::"regclass") NOT NULL,
    "section" character varying(50) NOT NULL
)
INHERITS ("public"."secure");
 &   DROP TABLE "public"."links_sections";
       public         heap    grizzlysmit    false    979    980    220    4    980    217            �           0    0    TABLE "links_sections"    ACL     \   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."links_sections" TO "urluser";
          public          grizzlysmit    false    221            �            1259    20142    alias_links    VIEW     t  CREATE VIEW "public"."alias_links" AS
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
 "   DROP VIEW "public"."alias_links";
       public          grizzlysmit    false    218    221    221    221    221    221    218    218    218    218    4    980            �           0    0    TABLE "alias_links"    ACL     Y   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias_links" TO "urluser";
          public          grizzlysmit    false    222            �            1259    20146    links    TABLE     {  CREATE TABLE "public"."links" (
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    "id" bigint NOT NULL,
    "section_id" bigint NOT NULL,
    "link" character varying(4096),
    "name" character varying(50) NOT NULL
)
INHERITS ("public"."secure");
    DROP TABLE "public"."links";
       public         heap    grizzlysmit    false    980    979    4    980    217            �           0    0    TABLE "links"    ACL     S   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."links" TO "urluser";
          public          grizzlysmit    false    223            �            1259    20154    alias_union_links    VIEW     �  CREATE VIEW "public"."alias_union_links" AS
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
 (   DROP VIEW "public"."alias_union_links";
       public          grizzlysmit    false    221    221    221    223    223    221    221    218    218    218    218    218    218    223    4    980            �           0    0    TABLE "alias_union_links"    ACL     _   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias_union_links" TO "urluser";
          public          grizzlysmit    false    224            �            1259    20159    alias_union_links_sections    VIEW     �  CREATE VIEW "public"."alias_union_links_sections" AS
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
 1   DROP VIEW "public"."alias_union_links_sections";
       public          grizzlysmit    false    221    221    221    221    221    218    218    218    218    218    218    4    980            �           0    0 "   TABLE "alias_union_links_sections"    ACL     h   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."alias_union_links_sections" TO "urluser";
          public          grizzlysmit    false    225            �            1259    20164    aliases    VIEW     	  CREATE VIEW "public"."aliases" AS
 SELECT "a"."id",
    "a"."name",
    "a"."target",
    "ls"."section",
    "a"."userid",
    "a"."groupid",
    "a"."_perms"
   FROM ("public"."alias" "a"
     JOIN "public"."links_sections" "ls" ON (("a"."target" = "ls"."id")));
    DROP VIEW "public"."aliases";
       public          grizzlysmit    false    218    218    218    221    221    218    218    218    4    980            �           0    0    TABLE "aliases"    ACL     U   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."aliases" TO "urluser";
          public          grizzlysmit    false    226            �            1259    20168    codes_prefixes    TABLE     �   CREATE TABLE "public"."codes_prefixes" (
    "prefix" character varying(64) NOT NULL,
    "cc" character(2),
    "_flag" character varying(256)
);
 &   DROP TABLE "public"."codes_prefixes";
       public         heap    grizzlysmit    false    4            �           0    0    TABLE "codes_prefixes"    ACL     \   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."codes_prefixes" TO "urluser";
          public          grizzlysmit    false    227            �            1259    20171 	   countries    TABLE     �  CREATE TABLE "public"."countries" (
    "id" bigint NOT NULL,
    "_name" character varying(256) NOT NULL,
    "_escape" character(1),
    "landline_pattern" character varying(256),
    "mobile_pattern" character varying(256),
    "landline_title" character varying(256),
    "mobile_title" character varying(256),
    "landline_placeholder" character varying(128),
    "mobile_placeholder" character varying(128)
)
INHERITS ("public"."codes_prefixes");
 !   DROP TABLE "public"."countries";
       public         heap    grizzlysmit    false    227    4            �           0    0    TABLE "countries"    ACL     W   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."countries" TO "urluser";
          public          grizzlysmit    false    228            �            1259    20176    countries_id_seq    SEQUENCE     }   CREATE SEQUENCE "public"."countries_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE "public"."countries_id_seq";
       public          grizzlysmit    false    228    4            �           0    0    countries_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE "public"."countries_id_seq" OWNED BY "public"."countries"."id";
          public          grizzlysmit    false    229            �           0    0    SEQUENCE "countries_id_seq"    ACL     @   GRANT ALL ON SEQUENCE "public"."countries_id_seq" TO "urluser";
          public          grizzlysmit    false    229                       1259    20517    country_id_seq    SEQUENCE     {   CREATE SEQUENCE "public"."country_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE "public"."country_id_seq";
       public          grizzlysmit    false    4            �           0    0    SEQUENCE "country_id_seq"    ACL     >   GRANT ALL ON SEQUENCE "public"."country_id_seq" TO "urluser";
          public          grizzlysmit    false    258                       1259    20518    country    TABLE     !  CREATE TABLE "public"."country" (
    "id" bigint DEFAULT "nextval"('"public"."country_id_seq"'::"regclass") NOT NULL,
    "cc" character(2) NOT NULL,
    "_name" character varying(256),
    "_flag" character varying(256),
    "_escape" character(1),
    "prefix" character varying(64)
);
    DROP TABLE "public"."country";
       public         heap    grizzlysmit    false    258    4            �           0    0    TABLE "country"    ACL     U   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."country" TO "urluser";
          public          grizzlysmit    false    259                       1259    20524    country_regions_id_seq    SEQUENCE     �   CREATE SEQUENCE "public"."country_regions_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE "public"."country_regions_id_seq";
       public          grizzlysmit    false    4            �           0    0 !   SEQUENCE "country_regions_id_seq"    ACL     F   GRANT ALL ON SEQUENCE "public"."country_regions_id_seq" TO "urluser";
          public          grizzlysmit    false    260                       1259    20525    country_regions    TABLE       CREATE TABLE "public"."country_regions" (
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
 '   DROP TABLE "public"."country_regions";
       public         heap    grizzlysmit    false    260    4            �           0    0    TABLE "country_regions"    ACL     ]   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."country_regions" TO "urluser";
          public          grizzlysmit    false    261            �            1259    20177    email_id_seq    SEQUENCE     y   CREATE SEQUENCE "public"."email_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE "public"."email_id_seq";
       public          grizzlysmit    false    4            �           0    0    SEQUENCE "email_id_seq"    ACL     <   GRANT ALL ON SEQUENCE "public"."email_id_seq" TO "urluser";
          public          grizzlysmit    false    230            �            1259    20178    email    TABLE     �   CREATE TABLE "public"."email" (
    "id" bigint DEFAULT "nextval"('"public"."email_id_seq"'::"regclass") NOT NULL,
    "_email" character varying(256) NOT NULL,
    "verified" boolean DEFAULT false NOT NULL
);
    DROP TABLE "public"."email";
       public         heap    grizzlysmit    false    230    4            �           0    0    TABLE "email"    ACL     S   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."email" TO "urluser";
          public          grizzlysmit    false    231            �            1259    20183    emails_id_seq    SEQUENCE     z   CREATE SEQUENCE "public"."emails_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE "public"."emails_id_seq";
       public          grizzlysmit    false    4            �           0    0    SEQUENCE "emails_id_seq"    ACL     =   GRANT ALL ON SEQUENCE "public"."emails_id_seq" TO "urluser";
          public          grizzlysmit    false    232            �            1259    20184    emails    TABLE     �   CREATE TABLE "public"."emails" (
    "id" bigint DEFAULT "nextval"('"public"."emails_id_seq"'::"regclass") NOT NULL,
    "email_id" bigint NOT NULL,
    "passwd_id" bigint NOT NULL
);
    DROP TABLE "public"."emails";
       public         heap    grizzlysmit    false    232    4            �           0    0    TABLE "emails"    ACL     T   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."emails" TO "urluser";
          public          grizzlysmit    false    233            �            1259    20188    groups_id_seq    SEQUENCE     z   CREATE SEQUENCE "public"."groups_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE "public"."groups_id_seq";
       public          grizzlysmit    false    4            �           0    0    SEQUENCE "groups_id_seq"    ACL     =   GRANT ALL ON SEQUENCE "public"."groups_id_seq" TO "urluser";
          public          grizzlysmit    false    234            �            1259    20189    groups    TABLE     �   CREATE TABLE "public"."groups" (
    "id" bigint DEFAULT "nextval"('"public"."groups_id_seq"'::"regclass") NOT NULL,
    "group_id" bigint NOT NULL,
    "passwd_id" bigint NOT NULL
);
    DROP TABLE "public"."groups";
       public         heap    grizzlysmit    false    234    4            �           0    0    TABLE "groups"    ACL     T   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."groups" TO "urluser";
          public          grizzlysmit    false    235            �            1259    20193    links_id_seq1    SEQUENCE     z   CREATE SEQUENCE "public"."links_id_seq1"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE "public"."links_id_seq1";
       public          grizzlysmit    false    4    223            �           0    0    links_id_seq1    SEQUENCE OWNED BY     H   ALTER SEQUENCE "public"."links_id_seq1" OWNED BY "public"."links"."id";
          public          grizzlysmit    false    236            �           0    0    SEQUENCE "links_id_seq1"    ACL     =   GRANT ALL ON SEQUENCE "public"."links_id_seq1" TO "urluser";
          public          grizzlysmit    false    236            �            1259    20194    links_sections_join_links    VIEW     8  CREATE VIEW "public"."links_sections_join_links" AS
 SELECT "ls"."section",
    "l"."name",
    "l"."link",
    "ls"."userid",
    "ls"."groupid",
    "ls"."_perms"
   FROM ("public"."links_sections" "ls"
     JOIN "public"."links" "l" ON (("ls"."id" = "l"."section_id")))
  ORDER BY "ls"."section", "l"."name";
 0   DROP VIEW "public"."links_sections_join_links";
       public          grizzlysmit    false    221    221    221    221    221    223    223    223    980    4            �           0    0 !   TABLE "links_sections_join_links"    ACL     g   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."links_sections_join_links" TO "urluser";
          public          grizzlysmit    false    237            �            1259    20198    page_section    TABLE     Y  CREATE TABLE "public"."page_section" (
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    "id" bigint NOT NULL,
    "pages_id" bigint NOT NULL,
    "links_section_id" bigint NOT NULL
)
INHERITS ("public"."secure");
 $   DROP TABLE "public"."page_section";
       public         heap    grizzlysmit    false    980    979    4    217    980            �           0    0    TABLE "page_section"    ACL     Z   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."page_section" TO "urluser";
          public          grizzlysmit    false    238            �            1259    20206    pages    TABLE     ]  CREATE TABLE "public"."pages" (
    "userid" bigint DEFAULT 1,
    "groupid" bigint DEFAULT 1,
    "_perms" "public"."perms" DEFAULT ROW(ROW(true, true, true), ROW(true, true, true), ROW(true, false, false)),
    "id" bigint NOT NULL,
    "name" character varying(256),
    "full_name" character varying(50) NOT NULL
)
INHERITS ("public"."secure");
    DROP TABLE "public"."pages";
       public         heap    grizzlysmit    false    979    980    980    4    217            �           0    0    TABLE "pages"    ACL     S   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."pages" TO "urluser";
          public          grizzlysmit    false    239            �            1259    20214    page_link_view    VIEW     �  CREATE VIEW "public"."page_link_view" AS
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
 %   DROP VIEW "public"."page_link_view";
       public          grizzlysmit    false    239    239    239    239    239    239    238    221    221    223    238    223    223    980    4            �           0    0    TABLE "page_link_view"    ACL     \   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."page_link_view" TO "urluser";
          public          grizzlysmit    false    240            �            1259    20224    pseudo_pages    TABLE     �  CREATE TABLE "public"."pseudo_pages" (
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
 $   DROP TABLE "public"."pseudo_pages";
       public         heap    grizzlysmit    false    979    980    880    980    880    217    4            �           0    0    TABLE "pseudo_pages"    ACL     Z   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."pseudo_pages" TO "urluser";
          public          grizzlysmit    false    243                       1259    20551    page_pseudo_link_view    VIEW     �  CREATE VIEW "public"."page_pseudo_link_view" AS
 SELECT "p"."name" AS "page_name",
    "p"."full_name",
    "ls"."section",
    "l"."name",
    "l"."link",
    'invalid'::"public"."status" AS "status",
    "p"."userid",
    "p"."groupid",
    "p"."_perms"
   FROM ((("public"."pages" "p"
     JOIN "public"."page_section" "ps" ON (("p"."id" = "ps"."pages_id")))
     JOIN "public"."links_sections" "ls" ON (("ls"."id" = "ps"."links_section_id")))
     JOIN "public"."links" "l" ON (("l"."section_id" = "ls"."id")))
UNION
 SELECT "pp"."name" AS "page_name",
    "pp"."full_name",
    "ls1"."section",
    "l1"."name",
    "l1"."link",
    "pp"."status",
    "pp"."userid",
    "pp"."groupid",
    "pp"."_perms"
   FROM (("public"."pseudo_pages" "pp"
     JOIN "public"."links_sections" "ls1" ON ((("ls1"."section")::"text" ~* ("pp"."pattern")::"text")))
     JOIN "public"."links" "l1" ON (("l1"."section_id" = "ls1"."id")));
 ,   DROP VIEW "public"."page_pseudo_link_view";
       public          grizzlysmit    false    223    223    238    238    223    221    221    880    243    239    239    239    239    243    243    243    239    239    243    243    243    880    980    4            �           0    0    TABLE "page_pseudo_link_view"    ACL     c   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."page_pseudo_link_view" TO "urluser";
          public          grizzlysmit    false    262            �            1259    20219    page_section_id_seq    SEQUENCE     �   CREATE SEQUENCE "public"."page_section_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE "public"."page_section_id_seq";
       public          grizzlysmit    false    238    4            �           0    0    page_section_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE "public"."page_section_id_seq" OWNED BY "public"."page_section"."id";
          public          grizzlysmit    false    241            �           0    0    SEQUENCE "page_section_id_seq"    ACL     C   GRANT ALL ON SEQUENCE "public"."page_section_id_seq" TO "urluser";
          public          grizzlysmit    false    241            �            1259    20220 	   page_view    VIEW     d  CREATE VIEW "public"."page_view" AS
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
     DROP VIEW "public"."page_view";
       public          grizzlysmit    false    239    239    221    221    239    239    239    238    238    239    980    4            �           0    0    TABLE "page_view"    ACL     W   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."page_view" TO "urluser";
          public          grizzlysmit    false    242            �            1259    20233    pagelike    VIEW     r  CREATE VIEW "public"."pagelike" AS
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
    DROP VIEW "public"."pagelike";
       public          grizzlysmit    false    239    239    243    239    239    239    243    243    243    243    4    980            �           0    0    TABLE "pagelike"    ACL     V   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."pagelike" TO "urluser";
          public          grizzlysmit    false    244            �            1259    20237    pages_id_seq    SEQUENCE     y   CREATE SEQUENCE "public"."pages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE "public"."pages_id_seq";
       public          grizzlysmit    false    4    239            �           0    0    pages_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE "public"."pages_id_seq" OWNED BY "public"."pages"."id";
          public          grizzlysmit    false    245            �           0    0    SEQUENCE "pages_id_seq"    ACL     <   GRANT ALL ON SEQUENCE "public"."pages_id_seq" TO "urluser";
          public          grizzlysmit    false    245            �            1259    20238    passwd_id_seq    SEQUENCE     z   CREATE SEQUENCE "public"."passwd_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE "public"."passwd_id_seq";
       public          grizzlysmit    false    4            �           0    0    SEQUENCE "passwd_id_seq"    ACL     =   GRANT ALL ON SEQUENCE "public"."passwd_id_seq" TO "urluser";
          public          grizzlysmit    false    246            �            1259    20239    passwd    TABLE     m  CREATE TABLE "public"."passwd" (
    "id" bigint DEFAULT "nextval"('"public"."passwd_id_seq"'::"regclass") NOT NULL,
    "username" character varying(100) NOT NULL,
    "_password" character varying(144),
    "passwd_details_id" bigint NOT NULL,
    "primary_group_id" bigint NOT NULL,
    "_admin" boolean DEFAULT false NOT NULL,
    "email_id" bigint NOT NULL
);
    DROP TABLE "public"."passwd";
       public         heap    grizzlysmit    false    246    4            �           0    0    TABLE "passwd"    ACL     T   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."passwd" TO "urluser";
          public          grizzlysmit    false    247            �            1259    20244    passwd_details_id_seq    SEQUENCE     �   CREATE SEQUENCE "public"."passwd_details_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE "public"."passwd_details_id_seq";
       public          grizzlysmit    false    4            �           0    0     SEQUENCE "passwd_details_id_seq"    ACL     E   GRANT ALL ON SEQUENCE "public"."passwd_details_id_seq" TO "urluser";
          public          grizzlysmit    false    248            �            1259    20245    passwd_details    TABLE     �  CREATE TABLE "public"."passwd_details" (
    "id" bigint DEFAULT "nextval"('"public"."passwd_details_id_seq"'::"regclass") NOT NULL,
    "display_name" character varying(256),
    "given" character varying(256),
    "_family" character varying(128),
    "residential_address_id" bigint NOT NULL,
    "postal_address_id" bigint NOT NULL,
    "primary_phone_id" bigint,
    "secondary_phone_id" bigint,
    "countries_id" bigint NOT NULL
);
 &   DROP TABLE "public"."passwd_details";
       public         heap    grizzlysmit    false    248    4            �           0    0    TABLE "passwd_details"    ACL     \   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."passwd_details" TO "urluser";
          public          grizzlysmit    false    249            �            1259    20251    phone_id_seq    SEQUENCE     y   CREATE SEQUENCE "public"."phone_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE "public"."phone_id_seq";
       public          grizzlysmit    false    4            �           0    0    SEQUENCE "phone_id_seq"    ACL     <   GRANT ALL ON SEQUENCE "public"."phone_id_seq" TO "urluser";
          public          grizzlysmit    false    250            �            1259    20252    phone    TABLE     �   CREATE TABLE "public"."phone" (
    "id" bigint DEFAULT "nextval"('"public"."phone_id_seq"'::"regclass") NOT NULL,
    "_number" character varying(128) NOT NULL,
    "verified" boolean DEFAULT false NOT NULL
);
    DROP TABLE "public"."phone";
       public         heap    grizzlysmit    false    250    4            �           0    0    TABLE "phone"    ACL     S   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."phone" TO "urluser";
          public          grizzlysmit    false    251            �            1259    20257    phones_id_seq    SEQUENCE     z   CREATE SEQUENCE "public"."phones_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE "public"."phones_id_seq";
       public          grizzlysmit    false    4            �           0    0    SEQUENCE "phones_id_seq"    ACL     =   GRANT ALL ON SEQUENCE "public"."phones_id_seq" TO "urluser";
          public          grizzlysmit    false    252            �            1259    20258    phones    TABLE     �   CREATE TABLE "public"."phones" (
    "id" bigint DEFAULT "nextval"('"public"."phones_id_seq"'::"regclass") NOT NULL,
    "phone_id" bigint NOT NULL,
    "address_id" bigint NOT NULL
);
    DROP TABLE "public"."phones";
       public         heap    grizzlysmit    false    252    4            �           0    0    TABLE "phones"    ACL     T   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."phones" TO "urluser";
          public          grizzlysmit    false    253                       1259    20556    pseudo_page_link_view    VIEW     �  CREATE VIEW "public"."pseudo_page_link_view" AS
 SELECT "pp"."name" AS "page_name",
    "pp"."full_name",
    "ls"."section",
    "l"."name",
    "l"."link",
    "pp"."status",
    "pp"."userid",
    "pp"."groupid",
    "pp"."_perms"
   FROM (("public"."pseudo_pages" "pp"
     JOIN "public"."links_sections" "ls" ON ((("ls"."section")::"text" ~* ("pp"."pattern")::"text")))
     JOIN "public"."links" "l" ON (("l"."section_id" = "ls"."id")));
 ,   DROP VIEW "public"."pseudo_page_link_view";
       public          grizzlysmit    false    221    221    223    223    223    243    243    243    243    243    243    243    4    880    980            �           0    0    TABLE "pseudo_page_link_view"    ACL     c   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."pseudo_page_link_view" TO "urluser";
          public          grizzlysmit    false    263            �            1259    20262    psudo_pages_id_seq    SEQUENCE        CREATE SEQUENCE "public"."psudo_pages_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE "public"."psudo_pages_id_seq";
       public          grizzlysmit    false    4    243            �           0    0    psudo_pages_id_seq    SEQUENCE OWNED BY     T   ALTER SEQUENCE "public"."psudo_pages_id_seq" OWNED BY "public"."pseudo_pages"."id";
          public          grizzlysmit    false    254            �           0    0    SEQUENCE "psudo_pages_id_seq"    ACL     B   GRANT ALL ON SEQUENCE "public"."psudo_pages_id_seq" TO "urluser";
          public          grizzlysmit    false    254            �            1259    20263    sections    VIEW     �  CREATE VIEW "public"."sections" AS
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
    DROP VIEW "public"."sections";
       public          grizzlysmit    false    243    218    218    218    218    218    221    221    221    221    221    239    239    239    243    243    243    239    239    243    980    4            �           0    0    TABLE "sections"    ACL     V   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."sections" TO "urluser";
          public          grizzlysmit    false    255                        1259    20268    sessions    TABLE     ^   CREATE TABLE "public"."sessions" (
    "id" character(32) NOT NULL,
    "a_session" "text"
);
     DROP TABLE "public"."sessions";
       public         heap    grizzlysmit    false    4            �           0    0    TABLE "sessions"    ACL     V   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."sessions" TO "urluser";
          public          grizzlysmit    false    256                       1259    20273    vlinks    VIEW     �   CREATE VIEW "public"."vlinks" AS
 SELECT "ls"."section",
    "l"."name",
    "l"."link",
    "ls"."userid",
    "ls"."groupid",
    "ls"."_perms"
   FROM ("public"."links_sections" "ls"
     JOIN "public"."links" "l" ON (("l"."section_id" = "ls"."id")));
    DROP VIEW "public"."vlinks";
       public          grizzlysmit    false    223    221    221    221    221    221    223    223    980    4            �           0    0    TABLE "vlinks"    ACL     T   GRANT SELECT,INSERT,DELETE,TRUNCATE,UPDATE ON TABLE "public"."vlinks" TO "urluser";
          public          grizzlysmit    false    257            )           2604    20561    addresses id    DEFAULT     z   ALTER TABLE ONLY "public"."addresses" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."addresses_id_seq"'::"regclass");
 A   ALTER TABLE "public"."addresses" ALTER COLUMN "id" DROP DEFAULT;
       public          grizzlysmit    false    216    215            0           2604    20562    alias id    DEFAULT     r   ALTER TABLE ONLY "public"."alias" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."alias_id_seq"'::"regclass");
 =   ALTER TABLE "public"."alias" ALTER COLUMN "id" DROP DEFAULT;
       public          grizzlysmit    false    219    218            9           2604    20279    countries id    DEFAULT     z   ALTER TABLE ONLY "public"."countries" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."countries_id_seq"'::"regclass");
 A   ALTER TABLE "public"."countries" ALTER COLUMN "id" DROP DEFAULT;
       public          grizzlysmit    false    229    228            8           2604    20563    links id    DEFAULT     s   ALTER TABLE ONLY "public"."links" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."links_id_seq1"'::"regclass");
 =   ALTER TABLE "public"."links" ALTER COLUMN "id" DROP DEFAULT;
       public          grizzlysmit    false    236    223            A           2604    20564    page_section id    DEFAULT     �   ALTER TABLE ONLY "public"."page_section" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."page_section_id_seq"'::"regclass");
 D   ALTER TABLE "public"."page_section" ALTER COLUMN "id" DROP DEFAULT;
       public          grizzlysmit    false    241    238            E           2604    20565    pages id    DEFAULT     r   ALTER TABLE ONLY "public"."pages" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."pages_id_seq"'::"regclass");
 =   ALTER TABLE "public"."pages" ALTER COLUMN "id" DROP DEFAULT;
       public          grizzlysmit    false    245    239            I           2604    20566    pseudo_pages id    DEFAULT        ALTER TABLE ONLY "public"."pseudo_pages" ALTER COLUMN "id" SET DEFAULT "nextval"('"public"."psudo_pages_id_seq"'::"regclass");
 D   ALTER TABLE "public"."pseudo_pages" ALTER COLUMN "id" DROP DEFAULT;
       public          grizzlysmit    false    254    243            S          0    20100    _group 
   TABLE DATA                 public          grizzlysmit    false    212   �2      U          0    20105    address 
   TABLE DATA                 public          grizzlysmit    false    214   x3      V          0    20111 	   addresses 
   TABLE DATA                 public          grizzlysmit    false    215   �5      Y          0    20123    alias 
   TABLE DATA                 public          grizzlysmit    false    218   �5      ^          0    20168    codes_prefixes 
   TABLE DATA                 public          grizzlysmit    false    227   97      _          0    20171 	   countries 
   TABLE DATA                 public          grizzlysmit    false    228   S7      x          0    20518    country 
   TABLE DATA                 public          grizzlysmit    false    259   �;      z          0    20525    country_regions 
   TABLE DATA                 public          grizzlysmit    false    261   �>      b          0    20178    email 
   TABLE DATA                 public          grizzlysmit    false    231   ��      d          0    20184    emails 
   TABLE DATA                 public          grizzlysmit    false    233   ��      f          0    20189    groups 
   TABLE DATA                 public          grizzlysmit    false    235   ��      ]          0    20146    links 
   TABLE DATA                 public          grizzlysmit    false    223   P�      \          0    20133    links_sections 
   TABLE DATA                 public          grizzlysmit    false    221   7�      h          0    20198    page_section 
   TABLE DATA                 public          grizzlysmit    false    238   �      i          0    20206    pages 
   TABLE DATA                 public          grizzlysmit    false    239   ��      n          0    20239    passwd 
   TABLE DATA                 public          grizzlysmit    false    247   �      p          0    20245    passwd_details 
   TABLE DATA                 public          grizzlysmit    false    249   ��      r          0    20252    phone 
   TABLE DATA                 public          grizzlysmit    false    251   �      t          0    20258    phones 
   TABLE DATA                 public          grizzlysmit    false    253   �      k          0    20224    pseudo_pages 
   TABLE DATA                 public          grizzlysmit    false    243   0�      X          0    20115    secure 
   TABLE DATA                 public          grizzlysmit    false    217   �      v          0    20268    sessions 
   TABLE DATA                 public          grizzlysmit    false    256   �      �           0    0    _group_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('"public"."_group_id_seq"', 39, true);
          public          grizzlysmit    false    211            �           0    0    address_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('"public"."address_id_seq"', 28, true);
          public          grizzlysmit    false    213            �           0    0    addresses_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('"public"."addresses_id_seq"', 1, false);
          public          grizzlysmit    false    216            �           0    0    alias_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('"public"."alias_id_seq"', 37, true);
          public          grizzlysmit    false    219            �           0    0    countries_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('"public"."countries_id_seq"', 524, true);
          public          grizzlysmit    false    229            �           0    0    country_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('"public"."country_id_seq"', 91, true);
          public          grizzlysmit    false    258            �           0    0    country_regions_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('"public"."country_regions_id_seq"', 549, true);
          public          grizzlysmit    false    260            �           0    0    email_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('"public"."email_id_seq"', 22, true);
          public          grizzlysmit    false    230            �           0    0    emails_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('"public"."emails_id_seq"', 1, false);
          public          grizzlysmit    false    232            �           0    0    groups_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('"public"."groups_id_seq"', 358, true);
          public          grizzlysmit    false    234            �           0    0    links_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('"public"."links_id_seq"', 115, true);
          public          grizzlysmit    false    220            �           0    0    links_id_seq1    SEQUENCE SET     A   SELECT pg_catalog.setval('"public"."links_id_seq1"', 197, true);
          public          grizzlysmit    false    236            �           0    0    page_section_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('"public"."page_section_id_seq"', 187, true);
          public          grizzlysmit    false    241            �           0    0    pages_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('"public"."pages_id_seq"', 85, true);
          public          grizzlysmit    false    245            �           0    0    passwd_details_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('"public"."passwd_details_id_seq"', 21, true);
          public          grizzlysmit    false    248            �           0    0    passwd_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('"public"."passwd_id_seq"', 21, true);
          public          grizzlysmit    false    246            �           0    0    phone_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('"public"."phone_id_seq"', 38, true);
          public          grizzlysmit    false    250            �           0    0    phones_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('"public"."phones_id_seq"', 1, false);
          public          grizzlysmit    false    252            �           0    0    psudo_pages_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('"public"."psudo_pages_id_seq"', 8, true);
          public          grizzlysmit    false    254            T           2606    20285    _group _group_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY "public"."_group"
    ADD CONSTRAINT "_group_pkey" PRIMARY KEY ("id");
 B   ALTER TABLE ONLY "public"."_group" DROP CONSTRAINT "_group_pkey";
       public            grizzlysmit    false    212            X           2606    20287    address address_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY "public"."address"
    ADD CONSTRAINT "address_pkey" PRIMARY KEY ("id");
 D   ALTER TABLE ONLY "public"."address" DROP CONSTRAINT "address_pkey";
       public            grizzlysmit    false    214            Z           2606    20289    addresses addresses_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY "public"."addresses"
    ADD CONSTRAINT "addresses_pkey" PRIMARY KEY ("id");
 H   ALTER TABLE ONLY "public"."addresses" DROP CONSTRAINT "addresses_pkey";
       public            grizzlysmit    false    215            \           2606    20291    alias alias_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_pkey" PRIMARY KEY ("id");
 @   ALTER TABLE ONLY "public"."alias" DROP CONSTRAINT "alias_pkey";
       public            grizzlysmit    false    218            ^           2606    20293 !   alias alias_unique_contraint_name 
   CONSTRAINT     d   ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_unique_contraint_name" UNIQUE ("name");
 Q   ALTER TABLE ONLY "public"."alias" DROP CONSTRAINT "alias_unique_contraint_name";
       public            grizzlysmit    false    218            k           2606    20295     codes_prefixes codes_prefixes_pk 
   CONSTRAINT     j   ALTER TABLE ONLY "public"."codes_prefixes"
    ADD CONSTRAINT "codes_prefixes_pk" PRIMARY KEY ("prefix");
 P   ALTER TABLE ONLY "public"."codes_prefixes" DROP CONSTRAINT "codes_prefixes_pk";
       public            grizzlysmit    false    227            m           2606    20297    countries countries_pk 
   CONSTRAINT     \   ALTER TABLE ONLY "public"."countries"
    ADD CONSTRAINT "countries_pk" PRIMARY KEY ("id");
 F   ALTER TABLE ONLY "public"."countries" DROP CONSTRAINT "countries_pk";
       public            grizzlysmit    false    228            o           2606    20299    countries countries_prefix_ukey 
   CONSTRAINT     d   ALTER TABLE ONLY "public"."countries"
    ADD CONSTRAINT "countries_prefix_ukey" UNIQUE ("prefix");
 O   ALTER TABLE ONLY "public"."countries" DROP CONSTRAINT "countries_prefix_ukey";
       public            grizzlysmit    false    228            �           2606    20538    country country_cc_ukey 
   CONSTRAINT     X   ALTER TABLE ONLY "public"."country"
    ADD CONSTRAINT "country_cc_ukey" UNIQUE ("cc");
 G   ALTER TABLE ONLY "public"."country" DROP CONSTRAINT "country_cc_ukey";
       public            grizzlysmit    false    259            �           2606    20540    country country_name_ukey 
   CONSTRAINT     ]   ALTER TABLE ONLY "public"."country"
    ADD CONSTRAINT "country_name_ukey" UNIQUE ("_name");
 I   ALTER TABLE ONLY "public"."country" DROP CONSTRAINT "country_name_ukey";
       public            grizzlysmit    false    259            �           2606    20542    country country_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY "public"."country"
    ADD CONSTRAINT "country_pkey" PRIMARY KEY ("id");
 D   ALTER TABLE ONLY "public"."country" DROP CONSTRAINT "country_pkey";
       public            grizzlysmit    false    259            �           2606    20544 $   country_regions country_regions_pkey 
   CONSTRAINT     j   ALTER TABLE ONLY "public"."country_regions"
    ADD CONSTRAINT "country_regions_pkey" PRIMARY KEY ("id");
 T   ALTER TABLE ONLY "public"."country_regions" DROP CONSTRAINT "country_regions_pkey";
       public            grizzlysmit    false    261            q           2606    20301    email email_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY "public"."email"
    ADD CONSTRAINT "email_pkey" PRIMARY KEY ("id");
 @   ALTER TABLE ONLY "public"."email" DROP CONSTRAINT "email_pkey";
       public            grizzlysmit    false    231            s           2606    20303    emails emails_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY "public"."emails"
    ADD CONSTRAINT "emails_pkey" PRIMARY KEY ("id");
 B   ALTER TABLE ONLY "public"."emails" DROP CONSTRAINT "emails_pkey";
       public            grizzlysmit    false    233            V           2606    20305    _group group_unique_key 
   CONSTRAINT     [   ALTER TABLE ONLY "public"."_group"
    ADD CONSTRAINT "group_unique_key" UNIQUE ("_name");
 G   ALTER TABLE ONLY "public"."_group" DROP CONSTRAINT "group_unique_key";
       public            grizzlysmit    false    212            u           2606    20307    groups groups_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_pkey" PRIMARY KEY ("id");
 B   ALTER TABLE ONLY "public"."groups" DROP CONSTRAINT "groups_pkey";
       public            grizzlysmit    false    235            w           2606    20309    groups groups_unique_key 
   CONSTRAINT     l   ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_unique_key" UNIQUE ("group_id", "passwd_id");
 H   ALTER TABLE ONLY "public"."groups" DROP CONSTRAINT "groups_unique_key";
       public            grizzlysmit    false    235    235            `           2606    20311    links_sections links_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_pkey" PRIMARY KEY ("id");
 I   ALTER TABLE ONLY "public"."links_sections" DROP CONSTRAINT "links_pkey";
       public            grizzlysmit    false    221            f           2606    20313    links links_pkey1 
   CONSTRAINT     W   ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_pkey1" PRIMARY KEY ("id");
 A   ALTER TABLE ONLY "public"."links" DROP CONSTRAINT "links_pkey1";
       public            grizzlysmit    false    223            c           2606    20315 )   links_sections links_sections_unnique_key 
   CONSTRAINT     o   ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_sections_unnique_key" UNIQUE ("section");
 Y   ALTER TABLE ONLY "public"."links_sections" DROP CONSTRAINT "links_sections_unnique_key";
       public            grizzlysmit    false    221            h           2606    20317 !   links links_unique_contraint_name 
   CONSTRAINT     r   ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_unique_contraint_name" UNIQUE ("section_id", "name");
 Q   ALTER TABLE ONLY "public"."links" DROP CONSTRAINT "links_unique_contraint_name";
       public            grizzlysmit    false    223    223            y           2606    20319     page_section page_section_unique 
   CONSTRAINT     {   ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "page_section_unique" UNIQUE ("pages_id", "links_section_id");
 P   ALTER TABLE ONLY "public"."page_section" DROP CONSTRAINT "page_section_unique";
       public            grizzlysmit    false    238    238            }           2606    20321    pages page_unique_key 
   CONSTRAINT     X   ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "page_unique_key" UNIQUE ("name");
 E   ALTER TABLE ONLY "public"."pages" DROP CONSTRAINT "page_unique_key";
       public            grizzlysmit    false    239            �           2606    20323 "   passwd_details passwd_details_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_pkey" PRIMARY KEY ("id");
 R   ALTER TABLE ONLY "public"."passwd_details" DROP CONSTRAINT "passwd_details_pkey";
       public            grizzlysmit    false    249            �           2606    20325    passwd passwd_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_pkey" PRIMARY KEY ("id");
 B   ALTER TABLE ONLY "public"."passwd" DROP CONSTRAINT "passwd_pkey";
       public            grizzlysmit    false    247            �           2606    20327    passwd passwd_unique_key 
   CONSTRAINT     _   ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_unique_key" UNIQUE ("username");
 H   ALTER TABLE ONLY "public"."passwd" DROP CONSTRAINT "passwd_unique_key";
       public            grizzlysmit    false    247            �           2606    20329    phone phone_pkey 
   CONSTRAINT     V   ALTER TABLE ONLY "public"."phone"
    ADD CONSTRAINT "phone_pkey" PRIMARY KEY ("id");
 @   ALTER TABLE ONLY "public"."phone" DROP CONSTRAINT "phone_pkey";
       public            grizzlysmit    false    251            �           2606    20331    phones phones_pkey 
   CONSTRAINT     X   ALTER TABLE ONLY "public"."phones"
    ADD CONSTRAINT "phones_pkey" PRIMARY KEY ("id");
 B   ALTER TABLE ONLY "public"."phones" DROP CONSTRAINT "phones_pkey";
       public            grizzlysmit    false    253                       2606    20333 
   pages pkey 
   CONSTRAINT     P   ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "pkey" PRIMARY KEY ("id");
 :   ALTER TABLE ONLY "public"."pages" DROP CONSTRAINT "pkey";
       public            grizzlysmit    false    239            �           2606    20335 $   pseudo_pages pseudo_pages_unique_key 
   CONSTRAINT     g   ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "pseudo_pages_unique_key" UNIQUE ("name");
 T   ALTER TABLE ONLY "public"."pseudo_pages" DROP CONSTRAINT "pseudo_pages_unique_key";
       public            grizzlysmit    false    243            {           2606    20337    page_section psge_section_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "psge_section_pkey" PRIMARY KEY ("id");
 N   ALTER TABLE ONLY "public"."page_section" DROP CONSTRAINT "psge_section_pkey";
       public            grizzlysmit    false    238            �           2606    20339    pseudo_pages psudo_pages_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "psudo_pages_pkey" PRIMARY KEY ("id");
 M   ALTER TABLE ONLY "public"."pseudo_pages" DROP CONSTRAINT "psudo_pages_pkey";
       public            grizzlysmit    false    243            �           2606    20341    sessions sessions_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY "public"."sessions"
    ADD CONSTRAINT "sessions_pkey" PRIMARY KEY ("id");
 F   ALTER TABLE ONLY "public"."sessions" DROP CONSTRAINT "sessions_pkey";
       public            grizzlysmit    false    256            d           1259    20342    fki_section_fkey    INDEX     R   CREATE INDEX "fki_section_fkey" ON "public"."links" USING "btree" ("section_id");
 (   DROP INDEX "public"."fki_section_fkey";
       public            grizzlysmit    false    223            a           1259    20343    links_sections_unique_key    INDEX     �   CREATE UNIQUE INDEX "links_sections_unique_key" ON "public"."links_sections" USING "btree" ("section" COLLATE "C" "text_pattern_ops");
 1   DROP INDEX "public"."links_sections_unique_key";
       public            grizzlysmit    false    221            i           1259    20344    links_unique_key    INDEX     �   CREATE UNIQUE INDEX "links_unique_key" ON "public"."links" USING "btree" ("name" COLLATE "POSIX" "bpchar_pattern_ops", "section_id");

ALTER TABLE "public"."links" CLUSTER ON "links_unique_key";
 (   DROP INDEX "public"."links_unique_key";
       public            grizzlysmit    false    223    223            �           2606    20345 #   addresses addresses_address_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."addresses"
    ADD CONSTRAINT "addresses_address_id_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."address"("id") NOT VALID;
 S   ALTER TABLE ONLY "public"."addresses" DROP CONSTRAINT "addresses_address_id_fkey";
       public          grizzlysmit    false    3416    214    215            �           2606    20350 "   addresses addresses_passwd_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."addresses"
    ADD CONSTRAINT "addresses_passwd_id_fkey" FOREIGN KEY ("passwd_id") REFERENCES "public"."passwd"("id") NOT VALID;
 R   ALTER TABLE ONLY "public"."addresses" DROP CONSTRAINT "addresses_passwd_id_fkey";
       public          grizzlysmit    false    215    3461    247            �           2606    20355    alias alias_foriegn_key    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_foriegn_key" FOREIGN KEY ("target") REFERENCES "public"."links_sections"("id") NOT VALID;
 G   ALTER TABLE ONLY "public"."alias" DROP CONSTRAINT "alias_foriegn_key";
       public          grizzlysmit    false    218    3424    221            �           2606    20360    alias alias_groupid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;
 H   ALTER TABLE ONLY "public"."alias" DROP CONSTRAINT "alias_groupid_fkey";
       public          grizzlysmit    false    212    3412    218            �           2606    20365    alias alias_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."alias"
    ADD CONSTRAINT "alias_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;
 G   ALTER TABLE ONLY "public"."alias" DROP CONSTRAINT "alias_userid_fkey";
       public          grizzlysmit    false    247    218    3461            �           2606    20545    country_regions country_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."country_regions"
    ADD CONSTRAINT "country_id_fkey" FOREIGN KEY ("country_id") REFERENCES "public"."country"("id");
 O   ALTER TABLE ONLY "public"."country_regions" DROP CONSTRAINT "country_id_fkey";
       public          grizzlysmit    false    259    3477    261            �           2606    20370    emails emails_email_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."emails"
    ADD CONSTRAINT "emails_email_fkey" FOREIGN KEY ("email_id") REFERENCES "public"."email"("id");
 H   ALTER TABLE ONLY "public"."emails" DROP CONSTRAINT "emails_email_fkey";
       public          grizzlysmit    false    231    233    3441            �           2606    20375    emails emails_passwd_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."emails"
    ADD CONSTRAINT "emails_passwd_id_fkey" FOREIGN KEY ("passwd_id") REFERENCES "public"."passwd"("id") NOT VALID;
 L   ALTER TABLE ONLY "public"."emails" DROP CONSTRAINT "emails_passwd_id_fkey";
       public          grizzlysmit    false    3461    233    247            �           2606    20380 !   groups groups_address_foreign_key    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_address_foreign_key" FOREIGN KEY ("passwd_id") REFERENCES "public"."passwd"("id");
 Q   ALTER TABLE ONLY "public"."groups" DROP CONSTRAINT "groups_address_foreign_key";
       public          grizzlysmit    false    247    235    3461            �           2606    20385    groups groups_foreign_key    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."groups"
    ADD CONSTRAINT "groups_foreign_key" FOREIGN KEY ("group_id") REFERENCES "public"."_group"("id");
 I   ALTER TABLE ONLY "public"."groups" DROP CONSTRAINT "groups_foreign_key";
       public          grizzlysmit    false    3412    235    212            �           2606    20390    links links_groupid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;
 H   ALTER TABLE ONLY "public"."links" DROP CONSTRAINT "links_groupid_fkey";
       public          grizzlysmit    false    212    223    3412            �           2606    20395    page_section links_section_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "links_section_fkey" FOREIGN KEY ("links_section_id") REFERENCES "public"."links_sections"("id");
 O   ALTER TABLE ONLY "public"."page_section" DROP CONSTRAINT "links_section_fkey";
       public          grizzlysmit    false    238    221    3424            �           2606    20400 *   links_sections links_sections_groupid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_sections_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;
 Z   ALTER TABLE ONLY "public"."links_sections" DROP CONSTRAINT "links_sections_groupid_fkey";
       public          grizzlysmit    false    221    212    3412            �           2606    20405 )   links_sections links_sections_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."links_sections"
    ADD CONSTRAINT "links_sections_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;
 Y   ALTER TABLE ONLY "public"."links_sections" DROP CONSTRAINT "links_sections_userid_fkey";
       public          grizzlysmit    false    3461    247    221            �           2606    20410    links links_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "links_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;
 G   ALTER TABLE ONLY "public"."links" DROP CONSTRAINT "links_userid_fkey";
       public          grizzlysmit    false    3461    223    247            �           2606    20415 &   page_section page_section_groupid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "page_section_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;
 V   ALTER TABLE ONLY "public"."page_section" DROP CONSTRAINT "page_section_groupid_fkey";
       public          grizzlysmit    false    212    238    3412            �           2606    20420 %   page_section page_section_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "page_section_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;
 U   ALTER TABLE ONLY "public"."page_section" DROP CONSTRAINT "page_section_userid_fkey";
       public          grizzlysmit    false    3461    247    238            �           2606    20425    page_section pages_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."page_section"
    ADD CONSTRAINT "pages_fkey" FOREIGN KEY ("pages_id") REFERENCES "public"."pages"("id");
 G   ALTER TABLE ONLY "public"."page_section" DROP CONSTRAINT "pages_fkey";
       public          grizzlysmit    false    238    3455    239            �           2606    20430    pages pages_groupid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "pages_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;
 H   ALTER TABLE ONLY "public"."pages" DROP CONSTRAINT "pages_groupid_fkey";
       public          grizzlysmit    false    212    3412    239            �           2606    20435    pages pages_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."pages"
    ADD CONSTRAINT "pages_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;
 G   ALTER TABLE ONLY "public"."pages" DROP CONSTRAINT "pages_userid_fkey";
       public          grizzlysmit    false    3461    247    239            �           2606    20440 %   passwd_details passwd_details_cc_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_cc_fkey" FOREIGN KEY ("countries_id") REFERENCES "public"."countries"("id") NOT VALID;
 U   ALTER TABLE ONLY "public"."passwd_details" DROP CONSTRAINT "passwd_details_cc_fkey";
       public          grizzlysmit    false    249    228    3437            �           2606    20445 %   passwd passwd_details_connection_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_details_connection_fkey" FOREIGN KEY ("passwd_details_id") REFERENCES "public"."passwd_details"("id") NOT VALID;
 U   ALTER TABLE ONLY "public"."passwd" DROP CONSTRAINT "passwd_details_connection_fkey";
       public          grizzlysmit    false    3465    247    249            �           2606    20450 *   passwd_details passwd_details_p_phone_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_p_phone_fkey" FOREIGN KEY ("primary_phone_id") REFERENCES "public"."phone"("id") NOT VALID;
 Z   ALTER TABLE ONLY "public"."passwd_details" DROP CONSTRAINT "passwd_details_p_phone_fkey";
       public          grizzlysmit    false    251    249    3467            �           2606    20455 .   passwd_details passwd_details_post_foreign_key    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_post_foreign_key" FOREIGN KEY ("postal_address_id") REFERENCES "public"."address"("id");
 ^   ALTER TABLE ONLY "public"."passwd_details" DROP CONSTRAINT "passwd_details_post_foreign_key";
       public          grizzlysmit    false    249    3416    214            �           2606    20460 -   passwd_details passwd_details_res_foreign_key    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_res_foreign_key" FOREIGN KEY ("residential_address_id") REFERENCES "public"."address"("id");
 ]   ALTER TABLE ONLY "public"."passwd_details" DROP CONSTRAINT "passwd_details_res_foreign_key";
       public          grizzlysmit    false    3416    214    249            �           2606    20465 ,   passwd_details passwd_details_sec_phone_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."passwd_details"
    ADD CONSTRAINT "passwd_details_sec_phone_fkey" FOREIGN KEY ("secondary_phone_id") REFERENCES "public"."phone"("id") NOT VALID;
 \   ALTER TABLE ONLY "public"."passwd_details" DROP CONSTRAINT "passwd_details_sec_phone_fkey";
       public          grizzlysmit    false    249    251    3467            �           2606    20470    passwd passwd_group_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_group_fkey" FOREIGN KEY ("primary_group_id") REFERENCES "public"."_group"("id") NOT VALID;
 H   ALTER TABLE ONLY "public"."passwd" DROP CONSTRAINT "passwd_group_fkey";
       public          grizzlysmit    false    212    3412    247            �           2606    20475     passwd passwd_primary_email_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."passwd"
    ADD CONSTRAINT "passwd_primary_email_fkey" FOREIGN KEY ("email_id") REFERENCES "public"."email"("id") NOT VALID;
 P   ALTER TABLE ONLY "public"."passwd" DROP CONSTRAINT "passwd_primary_email_fkey";
       public          grizzlysmit    false    3441    247    231            �           2606    20480    phones phones_address_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."phones"
    ADD CONSTRAINT "phones_address_fkey" FOREIGN KEY ("address_id") REFERENCES "public"."address"("id");
 J   ALTER TABLE ONLY "public"."phones" DROP CONSTRAINT "phones_address_fkey";
       public          grizzlysmit    false    253    214    3416            �           2606    20485    phones phones_phone_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."phones"
    ADD CONSTRAINT "phones_phone_fkey" FOREIGN KEY ("phone_id") REFERENCES "public"."phone"("id");
 H   ALTER TABLE ONLY "public"."phones" DROP CONSTRAINT "phones_phone_fkey";
       public          grizzlysmit    false    253    3467    251            �           2606    20490 &   pseudo_pages pseudo_pages_groupid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "pseudo_pages_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id") NOT VALID;
 V   ALTER TABLE ONLY "public"."pseudo_pages" DROP CONSTRAINT "pseudo_pages_groupid_fkey";
       public          grizzlysmit    false    243    3412    212            �           2606    20495 %   pseudo_pages pseudo_pages_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."pseudo_pages"
    ADD CONSTRAINT "pseudo_pages_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id") NOT VALID;
 U   ALTER TABLE ONLY "public"."pseudo_pages" DROP CONSTRAINT "pseudo_pages_userid_fkey";
       public          grizzlysmit    false    3461    243    247            �           2606    20500    links section_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."links"
    ADD CONSTRAINT "section_fkey" FOREIGN KEY ("section_id") REFERENCES "public"."links_sections"("id") ON UPDATE RESTRICT;
 B   ALTER TABLE ONLY "public"."links" DROP CONSTRAINT "section_fkey";
       public          grizzlysmit    false    223    221    3424            �           2606    20505    secure secure_groupid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."secure"
    ADD CONSTRAINT "secure_groupid_fkey" FOREIGN KEY ("groupid") REFERENCES "public"."_group"("id");
 J   ALTER TABLE ONLY "public"."secure" DROP CONSTRAINT "secure_groupid_fkey";
       public          grizzlysmit    false    212    217    3412            �           2606    20510    secure secure_userid_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY "public"."secure"
    ADD CONSTRAINT "secure_userid_fkey" FOREIGN KEY ("userid") REFERENCES "public"."passwd"("id");
 I   ALTER TABLE ONLY "public"."secure" DROP CONSTRAINT "secure_userid_fkey";
       public          grizzlysmit    false    247    217    3461            S   �   x����
�@�OqqSADjA�*��(k��L���I��7#E�n/�q��j�!����;pϙVu��i�;����Љ�\�0
F�;�aɀ�pK�f搟���2-�-�ޒ|���cU���=oh��N��-�XZ�QQDx�{CKS%*�)�e_Ʌ�
MM��T���q[�������|;��*�*��m�W|��v.S3O������\~��	�Q�      U   4  x�͕�n�0���G��&mSpi��$�Z��@��8�*���uO?ېtU��jIK`������At6����w��`i�K�LP)�p3��>����	z��o#��?Q�"%(UPr�r�6g�TT�gfB��7}-L7�H%�`��a �0�~�Oc�B�~p��㿌���,��ðx/a	PT�V������G��}��8���1�2�s
1��I;ۍ���Ff�)��Ι��K�e�e&[�p	�OoA��n51��֌��f��k�pe��.���V�p�Ċ��F�oW@���d�r���ϱ�K�m�j�h��W2�
�L��'LiEj�趥�r&,�xMKu�"\�6X��&YIZZ��<�5���&�[�	�3�BB�T>'O�qD��U�s�<�d��-�\0��(���{;yf��?��X� 4��DK�B���ʄ��=+
���43��ke��y�'1��+,0Ak��- ����p���q�S�e6�<k?E���P���oTlp�4�9�f&���3.��%K)\��<?6e�X��m�>�=�0�Z����t� O38v      V   
   x���          Y   S  x�ŖOk�@��~�e/QbC��&�l�
A�1��"wk��~���\rR��a�|2�v�`�y���!�;Ve�g<������z���n�L��뭩��ק�,nLչ������y�{1{
YƯ~���
���؈�'WŊ��\��^�Ju���]���C^\�p�RA�*���R�R�9�b.�ʋ"R�
>�SR�u�d�)����iIE6��EG�1�L�,g�(��К�C�����Þ�h*k#��
Q�}Ev�BV4y�3s#i/���Fɢ�F�ʼ�\da�{���[�:�N2b_�ժ��o�&�=,`#��ɣX�~�Ş      ^   
   x���          _   �  x�ՙ�o�H���W��{��=D@zi���!UM��댩l�Su���s�����/'�3���B>�=����?gb8�M����g�{�l]>owAz��R,���Sq}u#��_�Uw��7_|���t筯�&��8T��P����ݯ��3?�槻�e҆��5�x�H��������~.NL��h�0J�P7	�o�f魽8�P��g�/�p� �|��j)�֪%��l���i��#Q|�63"˴M1j�vo쭎�D��b��$�"�ο�$�^���^K�j�׆��E2��q؟���Ofǃ�.��9+��ҋ឴�y���O��*^Eb�k/��W�2�x����3���4=����3��wi5�:~��ٱ�P�	��Y�
�c/mo��7F�NJA�$4����ظ������p����Q%��,���L(��֘ە�؛�}
��C�)D��yIy=�M�ą{S¼7�37 7{Y��zQu8x0��YD�,O�p�=�9 H�$4�����Zz=
����~V��ڒE����C�8��CV�͵O�ImM.�\�N�M^�M}��-�v��^�R�vv�j���V��=�>���a��{ĞX����Р.��MKwʾ���q$���N	 .p���$x�r��yd����n�������[ne�e�u�O��J��U�V
~��|�m�6/P3q��Pj�PV��G���K�e�O�����
��C�psfo��v�����8 ��A|�|{�Gs��NIh���D���{B{p��Ƃ}�u�����.P�p8���� �W�f�#>�C|dJB���ҺŅg}B{��hc�m����;x_y�ۨ��G�"5���:�y@`�q�tv9{ Js �NIh�����NK�zm8\��i�̽瓻8��<�VXA"�îR�����+�蔄\yM��m#ڋz1X���A��P�'��J�"5��^[I�t��J7�=��G.:%�W^p'm���S��3���6ކ��*�H��
T�����ۋ�<>���D��S��ηG�N��N�$4���V���� �m����`�6�Qs��"5����04U�v�}��ȳ3(������&�?�p]zi�.�mV!��1U����9�W��Q�;dR��J8�=R�w�蔄\�i�? �:�      x   �  x���]o�0���+�ܤզ�d]�iW@2F���s�G������?����]���r����q���(�y���Sê���.���nTl2t�|y���x	Ϯe�Uޯ~4�����3��\D����Y^�#?�ߢ���:A8ɿ�8�z��� �	��M����˙hε
Td��L�=�$��7�E6?��Y�hG�0�̟�Ս
����(��z~��T��iMZa���ӆ�#-��΂_W /��;.{*�3��g�}� ��@G1�p�¾Qec�7N-d��
�T��X��tg
��b�d�q��L�)��_�Լ���F�_z4T�4W�������d���4�{G�
f|԰JY�I�{}8HL������;*��k+Wj=rP%mJ�,�g����y���Iן(��B���\-�m�г!#mgz͵���n���Xӌ��SA+������?����)�v��j��^�y�=���iyn��| eS�<��cLp��R��/Y�z Z�G��0��)}������dߍjٳ@�^<*ڱB��2 �d���	&Yx��2�'��qy~i�)���\���w�(Ϸ�6��'�O[��=ZI�w��Ɋ0qJ{�ǫ�����c����A�^�	��6EO���W��z�v�^
Ҍw�^�����G�{��葒�R�8���䳳?)	      z      x����$Ǖ%���"�?�M�����w�۠�n�-��f��`U���Nd�(��������}�5�J�����L��=��[������__|��?����_~����x���������/���O������r�����?�����7�p���Ovi�?�����_��g����ݧ��?�Ǹ����է���7���o�2���7������ޜ�?=��.������n�����!.��.?��N??�|��.�Ti�i��<.��?O����Y�)]ݎn	�b����ׇ�G��r��W_��o�����/��}�շ����_�o�Fk��V��9Qq�����{4��{\`��pZq�'�y�[�X _�V��V������ZCC�=��=.��N8����]�<�-�^,��N������s��"@k��h������;���#Ot-�D�z� �:����^ٜ���ZCC7>�7>.�O8���H]�D�-�^,���k��W�]�T\x�����؍� �W�|$��E��@/�q==����>��=���&��`[x!�E��
c��7f\�ؖ2n~d̲7,���������)�� �54�@4���
�	��G��Zd�n	�b|C����*P�+��
c�W��^q`����1�62F�z� �!�����������+h�P�e!.�Cm�"\���Cpϔ�%Ћ�	~R�T���Wt�}$�;T�w�jzE��Ǐ*��-A�h��p>=\�[��I��]Am��MUИx�;!鎋G�@��͏bY�&�%Ћ���թ�!uj�'6���(`�:��Or{�@/�7 �I�2�𭍋�[Ac��ø�)���͏��bO�%Ћ�/�?�~q}<��xz�nEv?٩�\Sz�u\Acw�����K��:�͏l�~5��j��1 ������͊m�p��3�1."��
��!�y3-�cռ���H�ab"����營�λ/���7�����ۂ@!�vE�*��'W�(`�{��O�*S��@/���\���ݫ��t8��9��u��T=t����Ѝ8�����7�p�)���HtK��#��p:?�~:�>��F�w��ݯ������|\�類��Bq9CW��!w/��������n~<�Y��n	�b|���z
�������q����m?��m?�� <ΰ���$k��I�z� ��c�����NO�o�]o.��~� ���t\DB�4��q��f��q�c,�g��-�^,�߂�P�w�����0]AcT8�48�%'7?R�X����x:��x��}{�^O��i�ﲙRt
��V�'Ec��I�%���O'+�OV����x�����ח�5#�)�4���E�������q��|
����G��Z$�n	�b|n�(�*��((U����<J��(�K��Ru`�cXH��EsoT����:?D��"�OA$e
竸��ZAc7ވP\�S��
7?e؁�n	�b|}^�bHʗx��4v㽼�^�x��+l~$�s�<%����y}
!iS(H����bAB4&�b^1@K�h�|җY��������T?T
38(�PA�>2�D��5�`� ����<� ����I��%GC�N��x�h��&7?��%���A���&^j��*�jh�������Ʒ���DTω�)Q�Z�����I�2]�ω�H�����pD��w-~n~�w�q�[�X _�W3%��׸%˭��Fc2��?P�$Y5����H�z� �>�O���
~N\D�|4��#x �k�sp�c�c�������>�M�R��"�k��x#r����%U7?eX�������>�M�+��qI������N8�q�g�t-�+n~̠�CJ�z� �>�Oz�3��k\Dx���o�0.�oZ�����(�>�tK������79_z^=��V�؍�����M�+l~$�������+ _�W��2h
zS\�2hVԛ�1���!
X�A��O)1L@�[�X _��)3ʔ����W�؍72 nD �4��a�#Q����<�����Io�m�=^+h��[���ۖ�0n~$ʲ+������NYO�R���z������LKڋ��}S�l~Lc��4�=Mc��YO |}^͔S�������U�p������O�-�I��!��"��y�r�J������؍��A| ���+n~$�0�0��W�>�S~�+|_�"�/QAc	N| �Ohp-�W��� ���n	�b�_��_�H�ܤm��'."a�
��YQ�xͶ����Ǹ�e�<tK����l�R�����t�ܺ)W7��x8�&�<W��N�Tߕ��;�>��������]S}<l>ESy�{G޻�>��M��O���������kq�u���L�<iʓ�i���$5�Rs?5�����.���}�45��͏<�n}tK0ys?�:�OJ�)u27P'���ո��MS's���oMN��w2G�Ӫ�D�RS�j*TA����O'��tMM�`�)�w	�h��.o*�W��Ig���X�����}��V�ڦ�X���/x�[���c��NiM��L(."�V�`�.��'.���[�	��SO/��n	�b|uZ�T&_�V�P�Z���2�̋t2ߔ����{�~F��g�!��i��&�0."�V�`���~���7��05�n	�b|uZ'���CFC=djhL�M^�h�z���Gو7��[��{� �o����<�W$wҚ��y8."nN��!�8����-�a�����K�z� ���Iqr�𝍋H�Z���i�!�<�L�|gq�c�fN�%Ћ��������}{�g_�M����޾�gl>�M���	�>����8�>ş{����z�1�I�r�4s@A3*h�%�(1@���q�#c���@/�7$x��KI�J*��������"�W7%�����g	k�%��b �!���Sc��04��/�1�Ŵ�p�)���y![�X ߐ�'}��Bz[\D��1��?��ےކ��,_�n	�b|C��4��T��C�<4عX����o��ͧNǼ@��:}^��7$x*��0_\D����������ͧJ��[�X ߎ�>����̏�-��"�pN�"\`P���{��4M��@/�?�;|wx��H�n&�ԋ�B��*h���fyV4˳M��`�)�\���z6����'VMĖ�T4PC���ıG��~�T4��O���1�n	*/@�����JU>T�SC���3�2����7��;��n	C^��#������<�jJ�4p���T~9܈��i�8n~�
�	�tK0��q��������'b�*���
K�P���� �Z��͏	�1E�z� �>��XW�Q���54��K�W4�vM=�q�)��b�t��=����:���'ű���Р$���D�a�����F�U�IC�1<ڙ�卌����w�iB����������~z�U)z���A�o������������� E�*� ����~:%��c�x�;������_94���͏�^>�n	C>��O��D�V�r=��U�X����tJ�ө�r=����x����w*/���]������~��������+hp�L$ދD�}S�2l>�M��{�x�����N"�/M���d�L:.��+}�dL�|JRe.�|>�o��2�Z0*�c�ɀ�G�=USF��(�tKPyF�����y�)=~U�HA�@54v�e���:��7?���{薠�r �	��ب��9."��
;�t��1�ky#���cQ�^�tK���p;�Ζ��4��"�+�ۤ^��S��#,�#l�^ ��#?~��R��}PCcN�lN0��CS�����ftK��|}b�9V[��B#�kh������S�w�i
��7d��]�o	*�C��7y%Oj��
������*h�[����|�Z����]�E��@/�7�v��*)�����n���YJTg    ���/��H���\�Vs����o��0IR�ԡ�@kh����F�P4Mq�#Y��"�Lޡ�o��$Jْd!����ȸ��Ql���O]Ix���46w��&�N���%n5�m��|-o�7_7q��Ҝ,M��9� |n'Yʖ�[��54v��i��i��[��H�W�`s��o��$KYW���E��
��N|�����{���r�J�z� �	��,U�W�~5548NI�F���k�W��O㗸�Dи�_߄�9N��"�F�bA4&�\x�?,I�Aͧ�V@�z� �	��)R��.(���o����.�)�7����Z45��4|n�*(���ڮ�Р�/�S������*n>i�������|n���Rխ��n+h��˲X+�bmS�-l>���h--��y�- ߂�n?	S�r��"Bn��}'������%W
7?��X�����6�Nʔ6r�"�����w?.��i!7?F�c�n	�b|r'i��K-��PK�
�|��g�^���7�Ć͏��������%6 ߆�I��K�k{hrm�4�^���&����D��[B�O�E�ې;�S�+��"Bn��}'N�q��}�rX�͏l9v��[�X ߆�I��ry�����pCB����7�����0Dr�[�����6�N�/���,��e->�^��M��p��5���-�糀�6�N��/�W{���������7�W��G�x�4�|^^���!w��.�Bq!�����J\�w_��B���-�|�%Ћ�mȝ*oJO����
��F>ZF<Z��Ʌ͏l�(�(�������M
���o����4v���(Z�Q�M�\��Ȗ�QK?�6���mȝ����<@	�54�$H[�L<4e+��SS!��[�*#�mȝ��+s�"Bn���ND[���]K07?�ձ�,����6����Ti���f�W�`�9�]�a�i�<l>5:�����Y� |r'�j(5���554v�ec�A4������G�x#�%y����B5�Z�P����G� z�M-Xq�#[��*���+߆�I��KM{��c�����b/�.�MMq�X̻4�-�ϛ:"�mȝ��4.��ƥ���ݗ�L{1ϴo������O�@/��!wn4U�m2@�Mjh�)��������7?�gy��%yo����r=���I��O���$."�V�ؽ���H\��޷47�͏\y֭�n	�b|j���~_�[����T�`�j�Xf/������S�4oD���h�y� ���|>�~8�~|X��I�2}�ܺ�ʭ+hp`����E=t�Tn�Oy�tO�����o��O�R���0jhL���^$J��<��(��
�%�<�o��,P��������P)2������7��V.J�z�!/�C��;��*���P���=�=���i��Zf���\U��n	:o���y�;�x�פ��G��
����<J�y�8�P��Og$��H���2j�/O�����叻xr~|�ݪ������ C�ED̨�1��:a\�jC�"C��Gu�g�"�����4�-�JS�4����7�_��Ԫi�5n~|<�k�%�|�5�����ެʬ�?��HC��54����i�7��9�ͧo���TK���s��7`vn�nK�+�*h��[y����c�W���*�OK���l~���3�'�J�BJF\D����[�E�D\�޷�d��G�<˱�[�X ߀�n���=����7�C؋�}SW�|
��'���+�@c֓N՗�{(1������E�xߔ������tK���t���H�|����z�T�X}���f�h6�[�Z��XO��cH�z� ���x.�+����254�T�L	1��o/��OO!Ϭ��b�|�߀�I��m)�BY4v�L��"M�6ea��G�,O��4���Y |f�%���!IjE�'��wL(`�$��Osd�@/�7`vΜ*�==����ح��I/�����͏TqG�n	}�� ����J��<48��kfE���}|�� �|��etK��� ��sU_����z���`e�����_���n>Ur�x;m��b|}f�\��JϬ���
̌���kzfa�)��?��>�.f��>����qI�����;qx�<+b�r6�ͧ=vإ[�X ߀ٹ���Kl�z���`͎,�;��^b��T���@hs�!�%��7`�9Q���B�lf2ɇJ8�C�?��O�O�!����|f'ʔ��z��`79�E�.M��7�z��1��j�1���r�~լ
c������@�"54�9,�FTs��b�|�4f�]�%��X�o��A�RCV5d����r���j�����(>��vX�yCV���x�nK��-�۾����V4��M��a�12oVoi�z����0�gݸ����54(���x]�Moc�|�yĕ�^��m��7xϕ{]!"��q��}\��׮%"��O=I��O�z� �>�v?����L�dVР�)�&�(�4M5�����"KC�,M^�	�7`vҠ|�1��c��`�T��Kt��M��q�*� F;]��16������&�j.)� bkh�rC�y%�j"7�*=StKP9���7��k&A�Y�*g(8[C��벑���M�Y�|�w獿h�uȃ�|u^'�Iu����<�4�@u"G).��kI��͏`�r��@/����;�/��5��k�J��4�����&��0i�4�7?rŇO�-A峪�Ժ���������54Xw#rF�虩�Zr��S��1�[��[r"�-��(]�f5����ؽ���n�fq�#W�=�[�νY��s1^��������ؽ�ȵh@������G�x�r�%輿9߂�I�2��sP��Ƃ1N�ٜ���(l~�8�s4,��( ߀Z7O�+�q�<�����'~��y"��Q��B���y"|j�z�})�xeW�`�L��)����c�|��S��4�x�g���E7��f���l���%������i�<n>���i�tX|�ϖG�0;O��K5�=TC[A��6Y�ڋ"׾��6�s�(��E�}^C��x��L�4���ƲU�`���։�i]�X6�|���s�::g��ǲ�-��'�fezhVf��:��,}ӬL�|��tC�%�|V&߂�y�^� �Cy54v�eŜs�� 7?r�+����<��s_�R�
����A�^6n%TS�
�|R�y�'ڀB��*��7��y�S�$E�R[U�U���[/��*��T5�U�͏T�>�tKPy[U��s_�R@OC�xŧP���n
��� �>�tK�y@���l��5�B6��*�jhP�JF�̙��<�|Yz�����N:���q\������^Ȼq��z
X�O��{&�-�^,�o��Upi�"�C���FcR(�>',ѡP�IXb>*������Y�(�=P����闈@�o�������x�y��o��ܶ���h�멡�#��~n�n�zp��Hĳ%��s��q�qUZ'	ʖ�E��54����mRq��W�˅tK�����צu��Ku=�멠�O���7Z�覺����ԼPG�B��� ��~n����zVtx�1��	,	���S�y0tK��[P;W�NO=tz���V�2�*�7}��	7�Z��+=���	���2~�J���i�54x����Ÿo�4M7��B�5��i��7���a����IP���jo\CcYJ�����]S{c�������-�������)P�$PxH������RA�BA�Ml>uQ䊃����
 �>�s/�R���XC�e˲�U4E�z.��S�3/��M���"_��IxR�F
jdPCc�5�i@�N���n~����tKPy#���������֤vV�JY��"����L��"�[7e�����O�[�γ�����Si`����И<$'�Y1��6��͏r��G���C�[P;'@���zh�i6���SF}�S�|jj�`�%�|�)߂��b�B퇆j?jh���Zg���|rPY1�t^���{y<ݯ���    �x�D%�T�`���d�"�E7%���Sy�|�4�E�2 |n��k[J���j����Pf<������&n>}>y��i�|n��)TI� Ţ�[�Ia��ФX��Sk&A�-a��	�s"T)��B)n54��R�
V�٦7�|��T�%Ћ��äE�R_r�%��1yW6w�q�k�K���`�h�n	.�K��צuV�LI�2�UAcR��R�R�iR�`�d��d��dr%
��:\�;�߬I��D�K�*�P��
� #{I�E/�}S�
�|��{O�i�}ު�oA�ܖ�+�%�4���ɾ��޵<���1/�c�!�����NJ�)�K5P�������MMS�T���o�J���KE�[P;7&w�"."G�
;�8!'�~�q-jn~<9&?�-�^,�oA��U�7�P�q*E2!X��`ݔo�O�O �4�X��� ������������à�0'E��Y�Bg�
#��Î��t��͏�Y~8��pd� ߈_����J�ʴ�����,�TӔi��O'$���&ϴ@���;�R���ji]C�j���X�s�6����'u�Eu�`��|3~��R�eU_��`��-�#���K�|��ÿi9e�W_"����;F���7."�V�`��@�N�o����S�"���-�^,�o���6ʖzY��P&H��?V4��M��`�)��7��Y��{������/|�"𫠱�\/>�q�G����/n~����J�z� ���j���{hA���3�bF�����ͧ |� �������|\�׹{�*� ^+hp@���J�x��+l>�D)J��y��KVj?IV��d�BM�jh��Y�{+� ٦&C��T͸�[�͛!�W��oO��kR;�N��Xh�O��{9�ǊI<�i�n~�O�[��� ���;����Bՙ54�j\N哮�:7�Z��i�����ՙ|j'�ʕ�";�+r��{ٶ؉�Ů�+2n~䊷9�[�˻"#�-���)]��4$OU�`
�i��&y
6�:Vp�IS�I�� ߂��R�T�b��`�'�+�E��oJ��ͧ�P,��n	>O�@�[P;�RCi�� ����1UA�~�쇡i�n~T!���%�h	���U�e>@��kh���f�h6>4�2�͏\���tK�^�|j�\[P8F�E��
L�眸��o9F��S� ;�-�^,�oA�s/��`b�����������N5����Ssr>i��橼���:�����Ê���#�%9
R�kh0�.�"!��&7�B�\_����d�	��,Z
��)��UQ��D+/��)7�TV	O��w
C�[p��̩RS5E����&ٵ�����)n~L��]�`����w����U��)�J�C4:��'@��N��p-')�|��g��-�^,�op�R� �K���w����"!Q��DݔO]X#�t�����v��S�C���4S��X%N����O1X~�U�ԫ�C2 u����Nk�;iR�T�砢�;�Ȫ;'��\SQn~<�*=�%����oĮ�+�Jeh�i��ȓ��I�F���S�?���.y��7bwns^:O��y��'}ȹ����7��p�i2�cJH}~�B����g������U���Gv��Dg����l>��x'��v���� |d��x]�Z?W�)�J��`�����e2M�R��T���&�%�<U
�oA�*UJ<�P�y��23܊�p۔x��uD�IN��'�#��Փ2eK�',4z��G��NAb6�m=��O#�xg!:K��'��ΩR����,�
;�j���E��nʂ�͏_���4Mk�y ߂ڹ�Ti������Р�"�����i�-n>�4|� S��|j�S�
O��rWkh0�I<V^$����U�|�}b�!�|��������Q��J����0���F�2��T)�|
�0��`�T)��r~X���ғ$�K�������6_���(m�M������C���:��G�����U��uꬡA�HOsbxZS�N�|���5�%Ћ�-��zR�[P��"�WAcijVH�q����%7?��Y&�-�^,�o��<x�/�{�yO4؍Bd��@��i�l>u���z:����=�/�:�Y��9Oj_x!�E(���9��7�Ƥ�%�=�|�ֱ7,������w�>������f5��)U
�*(x[C�e�"��DtU5oq��Ec閠��-��������e�S�qjWC�R���V�p�M-�p�Ifl�-��-��6�ΪԾT���j3+h��)�'��xr�T�	�O�Z^l��Ŗ��6�oC�K�Rt�@�����RM�]St�|�U�5D����=��6䚹��4�ZCS�+h�6V���b��nq�p󩖖��&[�X ߆�I�� N�EDQ��1���(.p�״�S��Q"6Lm�[�X ߆��|�p���4شM��V���)\ �OM޸�o��o�p ߆�I��LGe:���ݗ��^�"��LG���O]�[��3�6�N�Pʼ�̋l�'K�Ԉ�)�7����A�4�b�3/�6�>��+��q�s+h��Rȃq�;���7�*/��H�z� >�������ˊ��眩���\C�IM����6I˸���٢Z�ͥe���B՗J5{�T���|YKًZʾ�T7?�6���n	}^���W�ع��*����;�d�F���j
��G���(�Qy@��O�L�R�^C�ˎ�!t-B�)B���)xȝn	�b||����ݚ�N��-%�Y(�����&�"[�6%���S?U�t�f��<�oA���-�����བྷ�@D�Ԧ7����Ch����A�[P;iR�4��B��kh���<���Ҷip5n>���^:��惫�����J�Ԁ��cpr|�����S̎�ۣ�\ހ�oA���EJE�*����zYծEU�n*��ͧ�^�i�΋����)S�T	d�J�
��R#JuLS%l>cyi���=&��P��V���PX���qs/��),���<��i���ay ���Ur~z����1EAz'��N�&�7?*ܛ�[B�;?|jg-������SC����{�Žoq~p�+Ϲ���A�[P;���R����-*h,��e:���)�6?a5O��4}B�� |j�V��%Լ���B���� ��M�Kp�c�w#�[�X ߂ڹ�y�y� 5/���{/{���"CS��|��.��H��y	߂�I�ҥ�F�6�И~/��H>�M����Q��ɊtK�yn#߂ڹ�Ti@����ؽ��� ����G����%�|@߂Z??��GC�Kjh�r�r�jq~p��1t�1t�1̜�����v���z�;�Z2�9Ϣ4�iM{���D9�i/�1훦=��S�ߴ�����' ����L��T8o���
c���v#*�MS�<l~d��JxC+�M^8��#xҧ|����z(�И+*�{���7�P�͏�+o�L���PF���f���-�Զ�Z��;��jC��6�|�r�XL��!�چ��#X���@u��
d@�i�Ę��i
l>1��:ut�S�O���<+V��� E�jhp�|�D�fh�����.�H�pϐG��vϺ�/I��$+h��z��&I6������%I ��s��R7��QC�~�H��E����n>�=,͂n	}�� ���w�v)��a}����� �548(D�A����d	j>ao\�%Ћ�ޞ�,"�'��ɼ 
e]Cc�]����_v�u�k7��� �l	�b|mZ'�J���Z+h�{�9�~�}����y�L��[�X _�V?)UZ��fi�4&+)+!�&�6?�Ǌ�Ǌ��*ך�ڴN��Pz	�K�����-9������͏�]�V�[ �1 � :�'eJ�w*�qg��)egM%:k��Ɲ�����;q�-A�;�fn��suPi,4z���w��1�6�^�ͧr>g��R���E��+y��s�A2$SAc���I/NLzqM�d`�#O�O�qt2��� �i�'���WCcY�2s͉�5ה����    y��\���צu֞J-�z��_�X�zЋ�|}S�?�|
�2��n	}����M���\�r5��XA�W���E2�n�u�ͧ�.O^�4yQ繎 |mZ��{��Cj9TC��?DY�=�LS�!�|��h�`�C��ww��������nR����ȱ����5ZR�?��8-n~<ix�[�X ߀�ṗT�����4��I��q����œ�ͧ�P�5�[�X ߂ڹ�y)�n��{�)�+��)���O}�y�n	6�#�-�}Ό*��P�^f��ܴA�M�{���	�r��0��{|j'����q9FU��9Ǌ{�9ǶP���E�qE�z� �U��r^��Y{*͍��ܘ�)5?1��6͍�ͧ�\#��`l>7��O��Rd�"�2���N�"�%.�eߒ"��O�qY�������Ε{���P548�'-N8�� ����DD�����B�0�O�$+HV���O������L����?�\'�[��eE�6�s�SɓU�'[CcAS�j*�j�&O7?Y�kJ��{�����|��ݟ�Ӫ��I�2]�޸�<�4�Xu����Xu-����ǰc|�-�^,�oC����rI=6�z\A�oM)�!�&�6�޲\6T6�z���wҢL�N�@u54v�e"�����N 7?����`�:��jV�KRcI�4(�J-�Z`�$5��,̵Þj�}.5�蝳�|)H� AJ�R��B��MA�|��������  ߊ^3�ϔz8Bu�54��"�,�BX�Tg��O�0�)#-�uy�-ߊ�I��K��z��Tv�	�h��7���ͧ�},��n	}�[
�oE�%�J�L�Ȥ��N#JtQ-G+�|�;��-�^,�oE�<�������kC!��H>�M�����mOV�[��s�V�>gM�������&��Q k��kq�)�E�`��Z����7���w��5�T+_
�y(�WCc����y��MA?���8�(�|�C��\7)�ݤ[�Rj��R�jh���]�"w�7����S�\��F����!����+�J5�
�����vY�DQ�j���ͧ�w^D�h��kn�F��n��+U)�"����,�Q�dG5U��G�x��T^����wR�\))�AI�548�G��Nd����t�| ��tKpyR:��z^�}��&�ʔ^�z9����V�=�x{���3n~<�-�L�rF��Ƨ�x<���sQ_����G��eC�lu���]�|�����g��] �	��f�T��n+h��+q���櫖S3n~$K�c0����&�N�U_���Cs�jhL0���z1h�o�㆛F>��n	}>��o���VyWx'�E�ۭ�1wԉ�f\��ky'��G�ձ�,����&�NR�PR"H����<c)B*��H����̥E�%�����VM*�Pz'�;��k���/͡靌�O5Ԝ,���w2߄�Y�*E����1�A�ו����=n~�$x8�n	*��#�o�>ܯ��L�

������MEdN5�p�(ޔ�F�T�C��:IRʖx��4��K�x+n�m�6���q�,%����y��(�
g��ZC�m��5.�OK�8��S[Fvإ[�X _��I�ҥ��^]C�S�d�L1]Z7��ͧ�]��&�F����|u^'ʗ��z�И�)_�^�(}�{7?:���J�����f�[5gN��"���ɀ�&�a�I}��9ʘ�	��<�N�����O��g��y�ϸ7?�s���@/�W3���J�~*����@��٦R?�|���h��K��ڼ�I�r�2����XXF�y8Q���Hp�c�ׅ�-��e$|u^����4ij�\C� r��f�75K�ͧ�>:�v?��f�|u^�\YP�|zh.A��פ������T*�\�%��\�:�z�Ж
���54B�;�Cj�Ԁ7�B��vT���|u^͜l^x^�"��T�`6�x���H�-�+n>e���n	�b|u^�\Tx^=T�WC�5:����7���SM{ ���>�:��������ZA���"����-�;�|*`�8�%Ћ��y��']�s�"��~N4&o�7�����'�'JQ�2?��Ϋ�3d
~� s��`
�pDQm54s��S�s\�0��\|u^��']87�E(;f�sS4&�W����dǠ�S�;�-�^,��ͫ���J����_��xىo����F���(޹�n	C�������L�tn2й��Ƅyy�1�`c��M��Q��!�%��܄�W�Uͼ�Z�A����8ؘ�sn>�{�у���M|u^'�i�q�����+h��������[�t������@/�W�u�x�'e<U�`c���EJ�o�x�ͧ��<���&�g<�{8�]�V;��K�85Ԋ��ߓ�W��2u����^�5ɖ@/�צuV�J��﨡A�V$�{Q���;p�I�eI�tK�y}_��YlڗĦ=$6U��}�j�^�A�&�	6�x��ў�G�\l�?^�_�k2��м K�E���8.t���n=,ih��Oʙ�@�z� �����Ӻm)���\��!C��kh�(�kѯX��&���7��7&[�X ߀Z;�+�N�jh,�L�BV�B�It�͏�h\E�[��E'���@�Ҡ����6��c�$�4�7��V�#�l>��oA��T
��Ph���rVd����)���s\x��n	}�A�[P;g;�R�����*h��[��dE:�m�v�͏\Y��di��ͳ� ��>'<�*<�P�G:'�c/J0�M�����=-��� |j�z�4��@N+h0�&G�1��4M8�ͧ`Yj��R�O8�[P;	Q�-��-n���{oe<܊x�m
���G�,��[?�y������)(Q4����0B*Ą��i n>�m��D��!���W�u.�+������ J�^T����v�|��~Z�n��v���������5g�j;����ٸ���4�t�E�4.p�s���͏N�[�@/�7!��ZT��B�54v�e��%ʶ�7?��K��`�
h����KΏ����K�D�D79?��1�ν�%���A�8�?�68&;5W��Ƹ�[C��B�� 
XR-��O�L>�[�X ߌ߹�+�+vм�
l/
;1Pص�q�<@L�z� �������i�w��C��_=�㫂c��	W/�p�-�f�|���]dK���p;�G����/_��+�q���LS_>�����F{tK���p;IS���P\���N�2p���).��O�<�N�z� �	�s_��<��'PC�m$��Ћ��}�<�|j;�t	�%��<�	�se�*U�(�ҧ�ƴA%Kq�(�QM�>��QKT�tG���W� �M�f?�������b�6��(�R�?5�W��[�X ��O�����+2�O�.}m5�����[/?�Z|u��7?R�?�tK�����;�_ӷ�gm���qa���n�/̸�o�ky��G�{��-�^,�o"<�scr[��h���4�aZ�,�bd�m���O���CKG�|"" ߆�y`^����zj�И,(�^:���5���͏2"o�I����D���N�+9�s�^)�QCY�54x����Y����ͧ���g#M�Fٓ��?��]��7�5�����B� ."�V�`{x!��~�UK� 7���3��n	�b��#��7�>��&eJ�������b��b����( r��n	&���N��)�8(Ǳ��n�LB4"	�4�8��G�x�"�L���7`v.�+ͷT�|�;���J�TM�-q�㙗��[���["�_/���=B͕{}���g����^>T�x���g6?>�={���3��g����K�:��sM�w�ֻ&fq�+é�[�˙E�0;��2���NP4�!�G#�8���ON~$2�Hd� ����t����M�s�T���Z����S%{u9ѫ�5��͏O!��E���C�[P;����㸈�k+h�fR�0���[�Ǹ�Tc�^�tK��[P;�PC    �����;b�x�x����7�:h��+}���E�_�ߜ��d��J-�Ԃ���^��G�=�]Sz�����=������7�����w?�I��}�B���ʀjh��	.J�騦2 �|rRYB�T^��{y<ݯ����z\
((0PA��T�P�US` 6��`��+���<0 �7���Y�*Ɍ
�kh�ɒ:�:�j�q���uC�%�\fD�N�ߞ�?���snT)�MCyo54�`�D������p��A�4�M�yo���|>�_�|l�Y������T��Y��+
tlS�l~<Y^�ciA��� �&�N����Rqq�*h��]v��P���n>վ������������zZ�Z5����i�IX���.^Zt��-�-n>��_dK��_���߭���}�K�� )R548�E6���ФH���@�d�JLC�H!�/�?���x�?���s�^i谂����1VNVb*�j:����|�0�T>t�������ݚ�ιQ��U����1V��hQ���*p�㱗���-A�?|j��@m\����mF�����=,� �[����������J94�CSC�EWr��Hr�rhp�H���I1C�C����vV��Rg��l^A�C�z��ǻ��������;ڪ��;��ޞ��Af5���PX����\$�n�)���OZ\^�q:��������$D���"��H�Lv$oʸ��[��1n>u0`oV�%Ћ�i�����Pa ���;�K%�%�4	���y�+�*&* �W��5K��~��+)P
R�jh��'%"%$"դ@����%��薠r
���1{=�;�8m\�ܝ�ј�Gx ���;��俰�+����7�Ǉ������i�@���*T�雂������%��)ѕM55}�͏#��F��7}C�+��5��iT�ͪ�ڬ��`��<�>����*n>Ue�C�j�6�|u^�^�%iq���S��7�oh�q����B�%����W�u�J�� �548@�x!�M�"n>��DQ�p�uE�:����UAy������N8JHCq��pT��OD�IItK����S�o���TJ=VP�q��mdn����)�7?��x.1�T�z���hKb�9�zwP轆�e�������;n>%��j;Kwy��o���tsy^i<������`ͫ<�����i<<n>����.��n��������~��m7��u��˸�<�4�\u�42.��k���͏�a�J)�@/�_����>�V�w�a^r����`�Mm�D5�?����EԟQ�����>���?������J�=T_Cc�YY��Eͺo*��͏�_^�N����#���\�g��zFU�`E��ɉ�N�El�ͧ���	�����Nn7�R����� �54X�,�q��x
XR9��O��,�N�z� ����x=�����������z=����p|}������x����qU�'�ʖ���548nKN��&�q�i<�&N��9������r������������adj�'E˖�Y��_�q";�Yљ�65��͏�N~tK�y�?~K��}���!�WLU��$'JpҒ���O*Ρ�f������y�_�@�B�54ȉ��h�IK�7�8ԜCM9�������Y�4�FA�h*h�9,F�a1�il>qȇ�(:\F�h �-)�kK-6,�b��9��+8i�Sp�C�9���LNA෤\ϔ�V
H�� 'Nr�'-Q+�|��q�0�Z!�[Rnf��x\�(_Q��$'��E��'{�aO9�Dq~K��LyAH���+
�ј��NZ�T�|��s=�0R�-)�G	���,T�VC����碾�6�����|R:�G�y��%���K~����
�� g-g����S/�hk�h��/෤|V�t�/א_^A��H�Y�Y7����!w�5u�u��[R>�o��i�I��AN������4�|�{]�z]:w� �)׳��K�7�*h�y���|���o���!?�iz����ߒ����ҷ�@��
,_�[#>���[�O���l�����r ~K�g��T\g���D~lE��m*���'�ǙV�ټ��ߒ�Y}3%��@{r"Ep#DpӤ����\47T47���oI����*{,T�SC����(��M�=���!?��R�W� �[R>�o���Hc��AN�n�n�4v�|␋憊�&���-)�շ������AN�.f�ئ�?���!�����A෤|V�LIp5��ZA��HE�E�4	����!WPUPM.��[R>�o���h�t�
���|D+�mS�#l~����EK�m���oI���ْ_n!���9�����m��a�C�h[�h��/�7����-����+h��8[�8�&�6�8䎶�����r ~K�g�͖�r��4ȉt��p�m�_�OrG�RG��~9 �%��fKN����
�DzQVxQ��I��'��e��es'�ߒ�Y}s%�Dy�q�$'Np�(�͏:Ρ���r ~K�g�͖"i��U��c(C]V��lS$6�[�44f�H �%���J~����
|������r�|zl������r��ߒ�Y}�K�[�o4�I/�^�c}���9친�S9���7 ~K�g���*�B�jh�������U n>q��Դ����-)��7_��C�W�'^r�'��r��ȡ�zʡ�)෤|V�|�[�oyr"?�^|l}ӷ6�8�gO?�>���Rn'�m(���548�LS5�CSK�|�bƇ��C�R �}=�?=��ş|�	ϓ��K<{��k�#�����3n~l�É�[��yF��^��>���x\��I[�jPC�mIETË�~��0 7�ژ�(�|�0 �o��<�T��
����D���T�����%tK�y߄۹�Z)=�C�548�A�)���M鉸�4���5����D�	��,�mir��&V��ͷr���mK"n~$˲�B�%Ћ�M���R�
l���͗�/"�)�����
�%�<���7�v�|I����YC�M+����蛴M�|jr��J�%�\�D��p;O�%�C>P��|/�/�����G�<wj<uj|��M�fn}�<4Y��o~'o~'n~K�<�|"��du���O߂[���-���o+h��K��7����DwX=uX}���M��u)_�o=��V��͗��o�oa�,�z��ܿ��p;�R���zȿ����/P/P�����Y�a��a���7�v֥|ɿ��[A�7_:�^8��ɿ��'������s��o���K���!���o�t@�p@}��Odq��S����- ߄�Y��%��C�m�|�z��&�6��������[ �	��.U���P�F�|9pC�T����|"��)>��@��p;�R���f��������oI���'�N�@��R3�&�N�Tߕzt�@�
���ɉ���ѵ�R��qBGǄ&�%Ћ��f���O�������"��xV�#��on}skh� �Q��G�o����G��G�n	}��E�_?����N�/k�;z�&E�Jof(���5��)2�}S<n>�w���f��<�s8�v�9=�?��f���O�53�ܨ0w�/R��a
jVCc��dO/%zz���a��q��F���C�߾=�~qx{x��P�~�!uz�Kgg��+h�1��['�����O�%?;zv���{=�Ooo�#�����k��}<i���?ҦpҊ� �546�Έ�P\`4P���x5�J�g�vt�[�X �0|���]�y��x���ا�#Lp3c�/]b�ua��?F�&B�����u��{7��a�?ލ+�ie��������y������X�ލ��u��W�%�s�-���<a��@n��㏻o.�ow8��w��������r�~�a��z"V�U/A���*I��%����jb�ds�76o���O�.��a|>�py����#����T�����S�_�G��j:?��0o��]K�]O����	�v~8}�xHǧ_��=�Y��xBV|�BdHA�kh�Iq �  �'hh���m��Q8����\�|%���f����

���ؽ��t%��)X��_� �`=����͎�~�p�Q�t%�A*d�ɄNʄNȄ�I��͏��㲢����UH �����Xҹ�x1uG���K�� +h��Nj�{��$H�|����j��\������h[�d7�\�8塉S54X�'Y#�|��)�|*���R>�8��7%�G�������kh��h��������ѵ���������aգs�O�o������`5�|�̪�of��y|yCb�����#�m��c�h�5�|nYe�U�`y�Lm�Ej[ߔ9�O�@<���p}�9��������?1�J���ٮ��n����h=�:���#U����[��;�!�����s;N��ȹ��f+h��;��~�]�㋛�r̓�[�X u9?���ê�7�)�fЅ�n\ȭ���3Z|������l~�W��g�n	�b|���'�ԫB�_\D$�
���ʋ\sP-E��Q�P���n	�b��1����p}8�׌�(���Q"�	�Q���(��Q"�(�gQ"ϢD~�`����x���tw�"����ײ+���kh�(�`'�`�$6��Ǐ(W�����0����5�B��_V=T�%�>�K��PUC��:)��S�j:T��_6P������ܮ��a��b��)6�k�������_O�~r��Ƚ5�Sbƚ4;9�������}�x�p=ܭKg�7:o~�\���ݷ���П�$����[�������&�{�/�ٿ��䳗|���g|���~���x<�S��zD�}�����`�S�z$�_%RR�
}$�����<=��o	�?��������~s<ޝ���A�S?��I��
a\D��
Sz!����-
!n~Tz&��-�^,�����~=Z�R���V���P,���tY,�E��o����G���0^�2ᷲ�	���򷏯����}|h�y�;��t�����������%�&��{:����D<IzHq����)�h"��O�Կ�	����>N�~�
�����>����3�.^-��(�g��kFk������	�x�E6O�;b5p��j���O�G�tM>��&����z1>ͧV�'�|��+τ�xu+Bӏ�%?$̿#��~��x����a�����J� �JK:�
�3^ݎ���:��_�����z�>���t�Gӽ��GӱG�ݐK�%?$̿�����h�5:M��t��q6����d�f�yh��O�@��g2�q2�p�҇�ywe�5)UO�9�ҋ�˽m�O����Vҗ�`6|�����θ;���k�Z������z<�ɧ�=�ڿ�#��|�jO߸��޸�	�X��ޯ}��H�9���ּ���(sY�]��5�DC��H��K\���ˊm;����T�nx1&��͉���xu;"�ө�����9��]�kn��[�J.�ܜMÔ�x{,�-K��4�l�%l���||�f���T�Lս�+Vu�ʸ@��W/�`N?$̿����ׇ����sZ�?ٍ=�?r�����!+�2+*�j?���CׅN��
NM�4���:%�>%�>��˩��L�Mƺn"�������c��/y�v���>3�흝�O����:f躿��53VNӅ�Q�~K0>��7>�����ÿ���%=#=�<s�'����C��+@�����p�n�+�v�&�r�?<�f�R�&���<*n��Ԥ�խ(e�0�!a��߼�<<�~q�_����\�S��H�ɷ��Ǧ�f�=H	|z<w���󷇇���[<�U��%96�c#867�X���E����z�����~s���p�}~9�?�ޜ�����8����c<L���������
|-����
�g�~{�Α�Ov��<<�������~Ϗ'��������㸚�T"������w�����wǏ>��_��>���t���z>~�{x{��!~��_��ᓴ5������~&ݫ����/���~z�刺῟����鿟~�[�pzwx��'��w��D��c����������叻���Ӓ��ׂ/�� ����(��X��g��ߍg�Ov)����k>�c��?���t�/��7s�U�a��x���m���O�C��gw]���(��;+<v���I���L.{��n"~שٺ������x�}�����3�����E����0>��z�����a�3���"�; ���?�����_�v����t�:�泻�#��V~Y5�p���Sg���<zyly�qγ��g�A�P�5�^O�k#�vp�ѡ/1:���-��l�G�a��l�;�=�</`���Ú���Ovb��r��Z��Z��Z���V���V�h�8�O�o�\�U�Īͽ�Ș���mXu�S+�S+�S��C��:c�sj�sj��װ�������a��i?}NM�s�����|N��椺��kK>�L`sLasT��8�Z�i������E�/N�`���/���ղ/�e_T�����?_�k2:L��}�Q�qF�^�{��ݻ�%����c��/}u8߯���O���+c^ޕ1ҕ1ҕ17uesese�W������U_�zR��+~O�r��&��,L��)�*�|Oy���*��ח����i�
?=iH��Au/�Au��������ձ�[�A�]�?���O�$;Щ��ӿ�	�2 �dD�-	,��
�����v߮zJғ�`���}�����������1��1��1��n��v�wxx����'��K��K^��<,���<;,yvX�Kt����,�ӓ��#3�ˇf:��dp��it�cᙎ�g��_�oW��N��)��˿�|���57}���5��k�߻総�~T'��B��
��
��
���B�B�B�(��|8���bw!kf�q3/q�r��T��M#n<�0%�,�������.��y{<�[3�j&������C�&i��`n�?�TI���@xu��v���U��$_$ֿ<�^�%����zF�g��%Ğ�?�yZ2S&�P��/%d�|�Q��Q�E�%D���Q��?�f��1��FZ'mi(������;���p����޿{�޿�z<������(?//?R~��0�T~��00�aX ?|sy{�~MF'A������Fɍ�����$7���Ϋf'�7A�e������?N�>���dߗ�}�*��@�������=      b   �   x����J�0��>š7Sa��o2���H�U�&��=�������[��>��'Bv��((?&�-Y�:������mw���%,|��9|�Ñ�ezZ,���AI�*���Hռ��P���79�:'^U���}����ŁQ���լ���8�=%��3m�)f��R��`��=�k�K��}gB��HᄮOhWY���U�\�d#O��:�}���@ާ\J�����KQ|77��      d   
   x���          f     x����J�0�{�b�I�H��O�'YW-,-��Ѓ����o3�"|ߡ��̗I:����*Ӽ.R��/��U���y>}��|sx���5�5�/e�e��w�i���"�>L��u5��	�8�	Ljd[P@��`�o�'���'�W���j�q�i�q�k�q'h�a������
%
�e(h�	P��'@��� �~4ڊ��'@ɊC}k��!g��!_.�z�v/:�*
���ZG��Am��Xb@�R�N� r�� O��`�¡��C��C�� �R[�K��	�����f��9�J�q����p�[�	Ry���N���p5����d�@E9A�M9N�s\�3Ø�>�oƄ
��� d%0�A�O_��Ԭ���      ]   �  x�՜[o�8���+����J�dٖg�ig7�4t:}-(��XK�BRq܇��ˋe;J��6�-Z�R����˫�>|�ܻ��|�;�� ��?+���ޗ�?���W�u���~�z}�Z�U?ޜ��5};}s��yJ?�KY�_��sA��w����A ��@� ~����?�*#� �7���o�W��q�����������\^��_/.����xAE*��M,݌�a�lȨPJ n�Ր �����p0Ë�E��sA�i�� ���Ӈ��?�%҂pP�N�#cCkA@]H�b��N)T��`9�y�):B��	�Wy�N_��Iԟ��W:8ǈH-���C
g��w��`h`/��%x�81濯�8�TLir$a:�Ga�(rt����8��ȗs��Ъ��bBa��]�{�������x���AU����M~>ړ��=u7VVKm�]�&��zrR�S�~&Hq6�Md�m ��B�[xa*�\x0�p�QH�;�?��xt��7���|�k�L�(7��xh �k�d:X�t�JuZ����IZ FE&(�A`�R���M�B+T���T�єz�.��o�(0��Z�c3v�n�9�)�P�:�����
ܸ�lE�"L�X4���p�o�Hd�נ��]�<y�9;w�Qd�}�ߔ3�{�^U%*�P����XuQ����::l�����+� 5+���0:������	Եa%���E!J���o�Y��dw~ٳəR�zZ?�qb�[�4����~ +N`��;X���V�vI�#���u�'����,����tm3��2taCC[=Fł���;��n�_%��юmw������dv�Ar��U��"�B������p�0b��*��28#4;����ś���&�>u2���=Y�
NÚ�%��G��64�M�e C�K;9��C>�O�kә�N�M[�7t����]������L9q��rvl���vp�I��(��tam۩��(�*mc��$@*���:�#��X�Q`�a�C)��z��D�)nM��v�;ޞ׶k
s�R��;�ĶY�������&0q$p�|�w�2;����6�V��`U��j�%j�`�X���)��%���vG6h��6u����iui2B�k:�7�QNlOkE���>�P�>��>��tG���i��Hn�EO��SL����\���cM���prQ���������~AŔ�;�&f��/5��Fg��?�@�jj��5���7�|#1���u<e�
 �%�SEcԶ�r6�jPS*�.+R`�Uԕ�k�����{ͼ;���A�g�.�}�P� ��yBY����~�YH��u��I�e�J�7z^���%��^�:ͺG�1�g�v���8Q'�r�S.��:������z�����ղN�KH���=#H�q��<�� B�z����d���z��/�ZF��Y�����Z��J� 8��T�4��K24�2m�xŘ�d4�*os���bʉ����/q��W�Og�(d8��p���J4B�3
�@�ڄ`��
����@��NT��l� �[�yΓX����V���, �N	$�"�CO;������`4�]r��Gz'�6������2�Ws�UW2j�5j)�g~�?��r����v35zMkRH�YN0�,ve߄�����*�D ����0q�K$II���n�t�=ʍ�$��~"�*E���̆@/E�-g�qh����x�X1W&��M7�g��$'ԇ����*��8��M.s����Y(D�2�MMr=p�8�u��;eU�{t�uF�!�t�ؓ<��!alK��Bd^��cr�a�����@H̃��D��in��9(�w"°�d`�k1k5Gt�mo5�4���mOZ%/y��U�zV.O���D�>�6
�R6@���ը����]M��2J�2<1�y3�������|x�Rr�2�)����؏���\��G���
3����y��P��zrgo9d�wܿ��q��૮2�O6k�3��m�Ei]5����fѮ��m��|�D�	�LÖ:yIo3��6�n�er{ڥ���C�f-g�����ƛ���/f�v�X#(�H�}Si���7�؛k;�2^b�9�,&?0�+h�7�DE(g�Gx��;|������E-u�j�m���ڝa�۽O�c��Q��\hS2���T@gBP��Pd�$�1��2�[9�g|���'�N      \   �  x��YMo�0��W��Ac#N���NC�n�dX�]EVl֊��_�~�}j1=t�|`�(�||d��۫�d�ڬ�Ԅ���պ�܃V.M~}��yu���$~O��3?��A:|����ഷ�d^�9��A�^%������r�|Y'����r�����ߠ��U+��<�VRs���jU�e�U����2�V���p��
�	���3<�1��G+<ɡ�h�T��*�<��7���wf��X�^D�A��h�V�+�ь7����H~^kI�IW{�uS
h�H{�tI(�@�s^[VS�2��ַJ�TM�r����?�`6�A[��_,����Cx�z�.�~�GdJhԻD��f�j;���ȃ�(���Ġ�q<yS�Y%�@F�<?'@F6��B|����:�_�������^Ͽ9�Tx"�8���
�����wd��k�e�	�~�,�m(�<��V��"p̶Gm+�#nfd�Ih�b�ʏ|vn`�7Q���w�2C��p��Oy�a3 U>CR�Q�S�p�2�3ւd�0Ǔ?
�A�<�}j	�c�<��_]��:�M� ��JD����[�*80O1�,��XA3e���I�a��(�^���j�"s���b߈��+�Վ �n﵏��e�?ǵ7���%����P�J��;�`O0�05��������Í�ͪ%g�yf%����_:9�`���      h   l  x���OK�@����^��"���?<I�(	�ԫhi� Z�~��z�"=�G&��%?f3��Lۭ���Г:|>��7�B�^����q�����j�^�h�hr��35;������]����Xk�I�i*�;���Ͳ�t�S�wmw{9i���?�'�e#0�䍦cm�`l��Ƃ�.'0�L9؁�1c:�$��ݢ.Z@̙{&W>k$]�M��\�p��t�>�.s��e/�F4W�
�]�*�tŪ�F-/����^��k�ލF:W��Q�n�W~S�hGW�hG/`�VS�VS*��CWu*U�ц�JU{�Q������U�
m ���}e2W��\�Ź:c6?dx{ib!�1?L&_x���      i   h  x���]k�0���+ޤ��u�֎]�~M(ZZ�]�1��h$�+��_��b��`#(x�Ëy<��D�v�I!�����sF�ЫqA�ﯫ�|�a �F}��s�^�=ʃ��|Թ�ES�C"�7�6J7y�|Hb�&�bMS�%'�[/_zѿ=ױ�hAj!5��U�3��qQiL���Pt�]���[&�<��B�3���3�G�LB&�5p=��n�t���6u0	X������ll�d������,�R���U5F��T��2�%U�fa��-{t#`T��r<c;�����I�b��n���-��:[�����k���(��x��0lgTY���!��f碵��ei���3G��B+�      n   �  x���G��f���
k6��I�6��.�l�;z�)6�F��q�3��d���G����[�i�$�6V_�><��?��A׍�וK�g�~þ��e�bY��^�>����G�5��D
py�(J���e��]�k�)d�i�K���[{Ud��:18�#��Rn��6�p���=��x����"����}O�m��d�|t���/�i��C��~�t��_���Kn��}�:�J��b��nآ�}�~	�7䥩��>�������kJ��^��-�b��>�����;h� ^��0Z"5�5�=�R%��H<T�jh�g��ǵ+�!�-˺��X���GO�=!�|_]/}r�zYݘ�%�?�ju����3eVuc̄2:P7n����9�z�Y�&`+#(�^��b���[�؆��m]ξ�k`AC����hK��9����ھ�{r�'����%nʸ����s�Y"but���*q��o��\�pa��M^rw�b\���9f"g&�	Ǣ<BNp�t�e�SP�������`�Y>=���ח$6>��|�-�r�������%&�X^��UR7�Y��e�cIO/J�������-b���Jr^�C���6L�.�i�7�k�tp��������cr�l-k�tN��zb��`�g����c����*QvX�,ϭ0�k��Y�B�����M�,�I��a��*�:��89D?G:5��=������ŀ�`IaK�|��;jǮ1�t���y����6�b�{�4��6�g�n��Lv��ԑ����BI`X [�c�����Ui'hO�j����b-p�[=���q��^�(�4�#PU���r#��E������"�i���~.F \��+�c���M&�����d&[
%l����L�G�JO���F!%��6����� ?\�h�`Q�ك���9,"]޷c��yF�y��ވA\��V��0��bV:/�;K��UG�� �"��5uFs��m	Vx�{2}�f��=:���vY$@���,�N
u>��*��g4j%�P����}ي=~��/�*�^���8u2�&Xv�c\���P�e�7*��,��� 4;���e�B`�[Lڹ`y�8�����h�!�p��0魬E%I�[<����[Ɨ/�ȳ�n      p   G  x���]k�0���o�Amk���a'H��ˑjh~�6�_�$�b7Ly��ͅ��9ǈ��]��Oo�����}�B|��(/����&�(li�sۖ���'���o_Y��|3�t�	�[H���*�u$�#�����x�X��½l�`�(_/��� ��횊�5��WbZ���
��;�HI��1Gg�
K^w�kj�zK�C��{�Vqe��(����ɻ���#��;kѕ��'.�3YյK^�X�Á�}:�x�
��$���M!�u��@?�~`eQ�l����O/5�3���Gӣ"�U��?y,��=��      r     x���MK�@E���l�b[�}d2�+�U���}��Bт��Mc.�[��p��΍i�yh!�6Cy�z:�=������~,a�}��`Js�\y$hk���d/���q9�:��m\�p�!��>��U�+���SG3up��BL}��vO�[�K�|=+a�A\rЌ�� L�����$^7^�Fn'��6g#os�ʨeh��6���-���,�nw������)��#Wٗ���Fi���~۸T}�h��(_��E��f��      t   
   x���          k   �   x���v
Q���WP*(M��LV�S*(N-Mɏ/HLO-VRs�	uV�0�Q "u%� �T�Ae��i*i�CT�i�y��ř�y�) ^nfq2��T��Sp��s��tQp�W�����s��򤅛��nJ�/� щ990��n1��9ts�RS*��
�y
`;�8�� ��x�      X   
   x���          v      x�ݽ]��Ȳ6z_�?��7��xO�]����,`�#1􈦥;�J���g�_�f��mH4m{����3m�-JY�Of>����s���c����Ǘ���Z����_��_ן?}��<�~�������RF)6M�)A�&��LYJ�������ٟ}uz�Ϡ/��K�������+z��/?�#�SH7�B�����\����i8�Bdѓ�|x�s(���ǋ-�r���+�j��?ч/���O�4·����l���r4�>�_Å��F��R�'����O���K��W�|�Wr0��*������`�������O��A�;��O�S����'1<]ļdv��O�m��i��?=��>fj����ӏE����a��ֽ�s\����G�V����4���W�?���'�o�$ߋ�o��-fO�G��?�^�p� �h������7G�k���ey ��O������۪�ÿ~���'�b�U�.䌎_���2��*�$�{�+�E���?;xE��t�Ñ{�M�B��e�}� Rxܗ'�����������q���K=�����E��y-�~Ci��M{����?��L�|�z����8�xS���7��Ѹ��c�2L!��4�5��*�EL���������1{�ť�?�S��a���O��w�	f�ir ��H�Y��h(�88~�O��p����/;���&��|����(�~�|j.����d��y���jf��w�xj^�m!G�U�h�����?ru����o۞�7��~+5;���x1���uOQޤ�����ǿ?,���f�P�P�'��ƹ�Q�٨�l�A�����%u�Y��<����@�x1�ʕ����c^�����G�.̡�!S؂7��t��{�$�י���{�蜄#�U�1���A���~�^n�}�\)CX�ań�c��e�86����������:9�5R�𩼑�� �娡]�G����a$�������U p��o��xl�����ţ���.���͔���<6~tl���_�����LN��m"G�߼��ѫ�o��Kx1����Vkן���l�����!A>��`���/�c/�v󁕶�ƣǿC�����G'v����K�=�a��+��n7V��0)��)�Bp�Y퍘=���+��u>���{^:tt��{���A�7�bB��iԻ��Iԃ+t����sۊ�T,6T�9��b����&6Nd�_�>\[��� �d�㭽�a�:���n�b�M�m>��=fA>��rXl�qȮ�^��k\��[(x*-d�-������W8�"I�����
~X��/����O���G���0���i�L$,!�C)U�K�8�]�-,�����p,ƅ���?ܺ`p���	9�nw�x��_�Y�������Fgκ�K�uRH;����]
�Ý]��|pߟ�ni����7��|���;k�R�T��xvvmW�Zvk�}5�����zX�P9#� G6++��}����e�ǳ����(2e�L�D1�5Ř,�1��>~����GS�I>6�T��g�Z?����h��4:w �,�ko�R7�>�����3a���7�3�BR�H�����-�.��bg�͹�Il%$�҄+Z96H��W[M�>~�C�t���S��}����U��"�5\����x4 �3�H5�(𗅗��3m��<f�b��K��Q�� ���>y�6Yl�rl	��(!�H"�0��bi�Xى�<��Y4��Z{ܧ?�1 (�X���e>p�2o4���!U�F��;B@
��̧��${�� �M/����Խ�;!���ɔ��i
C�Դ��Mn0�e%*��:�TqM� ��Ϡ�?T�#�xAY�pn�|��`��4�AW��g��1hjJ�P�BGm�R�Ts� ҧ�A�����.H��(������g�,��W�p��P>����P��?>�oxxya ��s$C.�1 &�+���+6�<��K�ciZ-8yc	�N�VZQl	���܌T��H	%c�a��*>��1NN��q6�lJ-�:z!�oЬ�rP�鴻��?N�t�b/�!D�����[y�C��y����:t �tLݢG��K%��f��j둨1S]�?������m��o7��Cr�\ قd
w�z� O����-�������c�DZ��UJ-�"�mC��'fl'���쾆�FqR�[�'�8C_ţ��G�[i��e��*WXGǞ�y�3~D�ow��2M]Q�WU_��$�oKp��M��p�������0������ZO����Whs١.kBմ�(kꜣ��߮�T ����Y"]G;.vwgƿ�F��p��Y�O�;?U�P
�0�#�M�>Q���<J���ŷ.]�q����5�|\� #O��M���d���j�-u೒�Y =�e,CG�.������5�V����L�NTչ�c z�?��2:7��E���v�=�I_a�ؙ���'��S��)6#H�b�S��uryl��gc��d����&�~�� ����[�	�Ϲ�0��u�|��6�aH}_�s#�l�c�dDb|�H}�_�u��X^��u$4�=���ޥ2{sq�M_��=;��}�=���18��[��؊�w}�Ι��v�����.����t��	����oW=_M�Ԯ�XW^CU��zlf�X68ƕ�1�3+b<��(��I&��êy<W��j�)��=����k�t�����p1�S����h&�Qp�:�r�1�j�J���)g�#l���,b��P6��(�	I�J.�l�܇��[�B'��uO������C���OBg�v�u��.�Y��6T�C��2�C]<S]�}�o��	�s"x���=�������ay�.:C��0�� >��ɓ׶��s���۫~��|̧�z�s�]��K��]�]D�6��TD*�L,N"ӈx�VG��B�.Y*z}�Ko���{$����7A1&���SG��"\��p��o�埗ӯ^
T�׊��t����y���=gl�rK��ec�[�G畠N�@�4��ſx���mԀ���թEbCH��E��ڦ��J%ؾ��4͖� HP!Ӛ��-\��O}�u�(����'�(x?hE��L[XH;b��I3�Ne|�?/���ĜM�w���-蠘:3 0���p�e�C@�u=Fy]a�}������{E�4�j���&��M�%La�I,�*k��@Y�C]�x׼#���ǔ������KY�	W�)Y="o�j�o�lsp�����Ь�������$�F?��|�Y1=G�[2٣���^�^M�.��'�&6;�!Z���`�,M-HX��:M�hLa�*�#X�[hLP@.�uv����<��`������tQ�_�6�wg_�!;�k5>��̄~[�sY�q	�̥�����2u���n��C xL�[nR+�e�ZCzA������c�BF1��XlAg)�hD�����xV��֚b�+��L}~�t�ٱ�tV0�BGm]���$�õ�<@l8�3(B�9�}P�QV�Y�h@�膔�J�`�Ơ��xg�"d}_+~>9^z���i� �k�� IL��[�se��p�#EC	�j�K/n�l�yY^�d=:K���9`�΀z�<z}�5Q4�,/ֿP}�)K����o��)��*橳c���֞��h��t�7�u�@�ǹFnY8C�}��цAR������ijCƌېnQir]2�l+��JO���مD��NъkP�Е���E�N�Jx�do y�����7�Ggb:��4�χ|���ۜ�Oul]�*�i��7aHԚ��bt	���;�#�&qdٖI�)QE��� �Ui/��j=bOh��Y���k�ב�6���y��� ��%v���F�]����RLy@�� �4i������ﯧ��.��w�^�4���5�F��WTA�-������?{�;1��8�4��f	�S�Jy����bU~�r�{���`]	G�@.����:sf��xE=���q}�N�*    ����k�e�[��*&-"SK��\��M�"t�����d�K]�.�|Z?���ɿ����཈�NLic��� ��N��"�/��ٙ[WEM(�Զ/B���!���
�_�0jWf�j*���[`�b�%�n�o�B�[��ޅ����v�_�>$��۩3�B_�@��Y<�Q�þ���ی�K�8e� j0۔�T)7""#Qہ{ChGՌ����j���IZ�����ݗf����x�`ض�w�	��a���!KԵ<y	Y�hy���I7+S-@AWJ�f�+�M���r�;a&�'��ܲ�mp�<B�(5�)�Pi©��:�u���8C�9�9�: ���s�.tK�e��U��!�e��:9����Hn��i�vm���:�y�{S9o/�&����u!�e������"�ͩ������L[�یe�İm�b�%��$��⵴���5՗��Ӗ$j�@�+3�G�z��s <�n��;��m�N��x�Cȫ�uW�uQ�CѠ�F�����慪�b-��CI�!�m��l������r�!+�Q�Ē�2̔�*NZ�J��䷿�S�m�T<��iZ	�Si*S1c�<�N��w)˲�4)R��	zlQ)-.���a��LS�tA7P�O��q�5;j ��!���f�߂ȫ�I���-rJ��bG/�7��5��8��S�s9�a�߀'�A��	��H�ϋ�����$�%X��ązu���"B�	OY�#iR&�4��B��%	�����RI&��B<䱡�VQb�<�Ej��-Iz���IO7�:#T��m�#�v��xz�Ѕ�e��U(te�N��2󲟁��A!!�kI�@C�,Xh킇U�=��t�������&P�j�@��<�^^m��s��'��5�iR3����aL�z�Q)�4���K��W�3;�b�a0��,>s�p�٤ǲJ�v��{�a���Ϟ���?>~�� ��/0��b��|;_�|��i�y�O������������?�_>���� ,�"Eaʶ�\ێ��K��=]HJjG�3�F��Զ1 �8Nl�$��Y'K-p�FJ����m`�ĦER���s�^'�1$,Tq����N��Ri����L�E­�i��ov��,�w�{u���Y�E&%:���^�^��댹�M6�3�d��2��=g��A��Z�i�x,�Z�{sn��R�*,��X}����Q��x�|����.�9Q��1��Đ�a]�2�F"E��0,ᩲ��7�J3�
w�\G
D�k~�c�-��&u.%֡�}�v�����K<�5��/t�ȜT��숽R)���A�|�n���
���#�����#��A�ގ�H�F���N$DˈA���[	���X?����B����Y���0�0���y�BϤoX���s9?��h$\�Ĵx���qI�XQ�C��T�������@���B�š�b=���]�]~!(j������Ԩ�-�S��)& ��Mi��L��<>�}��T�X�&���A�7�ϽQ���x�����'�"-\q�H���	��u@�,�{M{w�%68��p>	É-��N8K�p�n����,�2��ic^��>@.�]���BC ��_�h�]��o��icw��X'��KX }bC0��$��]i�i��P���i�s� �����3�AQ����
y�Pl� ��;'8"$<�l��2b�]c��R���[�F�~������C�lH�O�@�}�n�l�Ӵ�_Ǖ3#�����m���Q����Q,��T���ۥ+�| �Z�ْ�>���p�/[b�e�M�/��jM����GL�� l��&"a��K�M�#gY�i{X�Ŝx` pO4l�0�l���[lDP�J��z�#!l��T���'"&���fjR��[�	܊��6�� ���"o��f�y[���N
|��S,��Lq�(3��PVjIe��Mf��|����	��`p��$��f:
x@g�T��K�.G��_~*5�-��*����&�7���F�V��K���0{\��>����u�b� �}	�bxV�~i��b�?Å+.h%�arnR3�"��*R1�q*H��\:� ץFP&���'ɛ"� �h�{~�L'��K��ɒ�����ib��*J0�Llᄙ2Mi���#/������+��]��PK�93�=�慖W
�z��%i��|���
bƘ��G��MlH-?K"Z��4/�iC��O>��K%}����1P}i�6��w=�v4��&�跗��Wz[�>���ҊQ{���Wk��6���-�H��r�����s2H��[�G2�(;b����x3?z�����!�em0x��S���F3@u����W��َ��`��Ǳ��ŌN�q���+�nw��]�t@CG[М<Ve�y�
�G��lN�r]�c�'/5NߥH%�6O�J8K+2 �1M��qf�ң_�H�G�.x�N�kz�	]����n�BJ�P7ل��7 ��i6���0]h�Ā�7�;nh:��D�U�kTxߨ-|Q����6kж�0�ː��m;��;u�F�,bȯRb	H���$�������&h+��9Dm8_��Zm�3�&
��8���:ʙ1�����[�� [e�(أ�����{�$��P��n��M?ӝ{#��N0+C�H��lF��"))�(e�nW�|?]ʕ��7^��	 �Y �b�{F܅KQ@݃[,�^��s8�#lk�+BF�R��z��N,e��r�Ԋze��ٔ�N�?�"��=DL�ǅ�tУ9aC��Z`D��Ż�]d�����~�D$������mEuL��Ѽ��܋���|�k�q�a��
�t[o����yL<�\�_��A"jK����t����tnv�����
-ՐL� )�M�;
���[�=N� ��A����ҳ���
HŘA�!�iA"���W�ĦYU�{�N��A;+�"8��K�\�Fa~�Y��l�.�̣��;�t��}�އL̈�$%���5#L��KfB^!����vϽ�G�m�����zt Y7}�u�����s�U���+�<G.8��bp���N��TX[.2jX��6�q������S��(:��oHD��$ʤiQS�8Ni�X�$�m�93R�ݫZ߁�Gc�g:����Le.��!�̓L������Wt��'6�k%�JL�VVCfe۩T��D+*2l�[�i�<������<4�6����.��1�%mP�j�oI�<�@-�"Z�\�ES��?�n����r:��M����$���;����(6� V�R&lˎ"�c0r�LI���B��SA��2��F�D���-�!�{�[V3��S�T=d�A���`@�8Sg������{ߐ�����^{�pT-w�W
��|�:{M���)�}dCQ�FB6Ś�&U������B�O��Lց��M�<�3/�t�U��z�sU�7�����[Y�w�cs�a�bh���;4�.����x7�Ѧ
j��<�~����*U&blK�c�E)�I��X�lDT��(�a��{"(7�v�bvp���M���:Q�1����;�;����#C�R0fr�a3i�Q5��._�zt�ļ���k�.�[��Zc���2�7�~^�[�
=~,�zL-��;��B3B�Mϙ�i�T`�:]�=��%~��|�4�ӄ��hjdǂ$�I��9,��q�>��Z~ƇOW���k�n���{�F�'v����§��M�)v�e4��)U�\ڌb��R$�L�����
A}��}w�m�⊱n�ı3(�4ع��N6��g\�㝗V�uP<n���ׯ����=c��4�o���������
^N^RJ�����[��=+��Q��<�}�24�ll�,��q�l��2U,ޒ��jBO'��ΣcxY����`1�����s6��w���4�e%�!�G6�ʭ�F�������`Շ��+p!����� ���sVk7׮����]���s�bʕ���ʈ	��2�$I�MB�e��� k�N��6�eN?8�%e���@�b >qI�z���Tچ�Rl+ab�m�*Ĉ�L���8u    ���U�:[p� ��i$v�>L��]X/�y'�zlA.�D�Il*̹Jm�I�"�
8�i��Mؐl���rdjk5U�y_�(����H	�hEb�b<<�v�ȩ�N�А���r�̀Ns���^O��.��:�{/�����<�����d�b)3f�c0k;R��o�ь�#/�mS�K��y��zq��kf�Y�4�o�-I�ijE�M
W=ԟZ) w�(eq�OKЭ�~�Y��;-�/>nf�i�|:�;4��A-�J�����Q�.6SgVx���b�P[�Цy�]g�|[g�r��%�2������#=��4�N4s�J ³a2ۢ�3
�?NMph������cA����������{ps��NM��}G�oqS2+�8��Ӗ��)f����Є��s��*ĸ�?�]9������w��r�'J�T�Ie�ضM!Z�`�,��gh�s8Ѭ�u����0����L�^n�i=��N1.�IT9���=!,+#�5����i����0�ᤳ%�:�]�+ �Rq���UEL�
�Nbe�"k���UY�Y`�J���
y |&���hL ��-��;�����S+�l��R�J���V	��Ţ��=t9a��3\O�5�]�!Po�'��@�#�O�?���w'f�L���D0+I,�(�̌c[L�lz�ۖ���	\F�"�<����B'ko4�����	6�dTE �(�d��z�ư-��+�V�� n�����`	IS���(��@~�:�����~��#�%$�}� �-�����)�P��]D�y8���v���eޱ�\g &�}X�ms�^��N��&��D%ܔ�6c[E�m��T5�\��dC� ,p{^6tv�
����;�iF��E4����2�$���	�e��pq����w�?g�������
|������{�5S����_�R$L	����1a�q�Й�5#'�,���1]��Mʁ�(����*'G�fؔA�$�O���b�]Y
[���"����f.x
���p�����<|�i)� ��2��L�T1i65+IG��Hz���i���,y�������t�P��`龧���$��H`c_"lB(Mqb�������0�n�\�ۃ�z�}8epp� �=��㖥����z1�L��F����=4���&4]H��?�;�g���<�d����jF�)#��)��e�(" X-j�gA�hP�C���r�������2/��y�;>4x9�c��2"GN���^�LZBnX����s��t�l\��0�L�%n�/�+֦�^&�W/�[TL��tƇ�x�CՊ6j"N�@ ��W�?���j���̏!X`�!��i�@�HS���I�Y�u�G%�#X��d��� �� �����!
�clOe���6���ZET{]�J��-BC�E�O/��;z�j��!���^Z�"����6����:%;@i����YV*#ExD��pĔM"����1|��A�Xn)=L}���]��7�� ��\�n�L��~��g7m;`O�i`aa3gq	?W�<:Y�1���:K����@z��T���>�p4��h��&�'��l�� NybZ��HSU��>
��.ZY)Q���� �� v�h�]�<p?�m�?O����]�3cJ7ohb�I��ز^gʏ����Y�F�	S�l��1�A���+��)Y�	��S�a�~8�%�%���n�3	�Zr���r;k����|����F���S��ҿ;~>�qX�Wr�m${\����h2����_~_�>>����~:����^G��VwO�o[����Xg�Wl�z���y���+&�)8+pP��.w �K�cM�C�f'����e��������}��c}��}]N~�H����㇇��}}���O�a+�e�|s�d����>��GlDg��g%Z�<��[�e�S�|S��u�]-��s��`����kv-��i��Ά�/qL�u5��<�~iB�E	Mb���@"�j�-�ڛ���h�kF��*�`9�.`9;����*迫jfqB���7�H�ΟaB�f�vT]���M9��]f��Z_P5F���H��6�_��hA��D���A>?��ZieJw4�Z��W+ϙQpZ�os�����I���.e@� ��j*K��'"�1��e�E�q�ؒ���b�7LQtX�ѕ���٣�s4�����2(4�}�z���Ý�����[�zÈ�o�n���{�:�Tnj��ц[�8w���"��Z(4�L_$i"ˌ�l�L`Ο�[�6�Bkʝ7��R�1.�:j=i�ږv'�˯$/`�NF3�b��&��biA�81��1����Ϥ��K�`�d,�U���|���m�W&Plj�b�Lۊ#
��5|��aU�,+�F�?Z3�{����۩�Z�� G��X�1�Z�F��w�O��%�.�南�7��x9x�{h"���[o��w�������_PXhXx�PӉ=u��#I,+�R)�ʘHW�'	��'S�5h:��G6^6ɂl�y��]�a�Zg�����;Q?Xą��!M���R�ŖJ�əb�u�Ў����hiăWȢdS�1�T]1+Bb�{I9�2AI%�e��`X���QbE�d��Q�v{�;dm�i��-���&�$�����.P�:��v����U�$5ْKyR�BW�ȵh�hN�ף9z+��,E� �z[��.tV��h�!�=�̴;)5"�i�4MTjۜǑ�`��\����ӏ��.���t�s%�.�F��j~mr�R��v�-���h)�=�a8E�
��j�:��9�a���]�c;}��S�5C�ct\i�T�%��ipˠ���8��DZ�irC[aEHT1���mR�m�Q�]ɞq/s���zl�x̦zl1� 9��߸��D����ib��d�u�W���U0~"@�j���F� ����se�X����	�͊�4U<�BIja�*��4�7cR1�k@�fi�.��|͈g�%��b�ˍ�&��K�NU�[ߐϳ�2'�x���&�o�zc����އy��Fa�iX���`?�'���������ś�
f�
3�T��8��%qD��0���m}�}����%��N�I\5�ݠ���2�q��7o}�N��Go�L�����-�:tz��W�Зp�<\�̅�ԥ.	�9sk���y�x�ݗ-�i�(�Jm�N�B�b#���H�䑴m�2Y��ƆlE�Y���Z��K�U'���eC1�¬��j�H�c���~�]8� �Y���m�DV�fdG
�_t�Q'���!�����p���m��B�����j
7��紾�x�]8��%J0˄�)1�� !$�\$����"P;�ChH�Ѕ̭�o9j]��l\�B���uRۀ�n�rz�d�����h-�pK"�����'D=�L��p�Q��e���,:�noY�r/-k� z\21�⒥F�0�0=@�fV�q���Eߖט�m���]*���.��r^�<��E7�b���MGZ�[�CGm�hּp����u �����~���I*V�е�F�K�	���QY��a��<�E�����0���5=m��7U~P��m}(zv��{�~��/���!:J����.fȵNc�+P�=�����_�0ww �$jko1߹�6�.\�e=��7(�_�"RY�QY�-�S�KD��S�-���1�%g�EL#�oY-z���[���:z �ajR�hL!��#=�?u�$�`����@g
��|nڊ$���RL�4�I����AQ��u��.�v���?b����hVh� �lC�g���$���ò����	��]]��^��<��s\N%�qM�a �0����z�-Mv<��㎉EZ��
b��V�$�ɘ'���§��n�Z5ޛ���}�U����� ��x�o��i�l�����(��P��[�Ѥu�U�z]*�g��U�U��sK�r|k��|EL��.���U ��:A��H*C��o	O(�<eƘ\�[    z?w�:d���I¿�}l� �c��y)�̈{$���� IÉ�ؐ���2 �F�6Mb�$�oy�F�����M���[�'���r��F5��[W}��C ��xc��ro�٫Z�������|��qU[Zmh<��:��铂�ͻٮ�=��4���Ḛ$��ǔD�͢HB�Y���)`�"S���xPW��E����¥C=��w��	�U��:���;7�)�Y�����\�G5��eQS�rۤ9C�%t�#�V��ҧX�5�Nc"M�iD6(���,v.,�p-Gc<����	��w�����i]���βhl�!���]��ki�0dlXqd�M����DŉEmeE�~�Z�a<��{ 95�xY�T�����'{� �����LG�c4o%�ԑ8���_�m}âJ�k%��r�5�R[2�<OT���ֆ�sap�C��� �M��GO\�`)�$S�6�6֛�m�-;��ͅ��6�FOo ~EA6/�l��{G���<L��[wWn*��Jv�}��kvס�^_+�� (k����Vo6GtFû�2�}+j9��F]�+N�n����Qd�R	nC%BuXB��FxI"h����j1�E#��(QeT�!��ӑ�����H���I���r-4�;(<�B��ǖ�������n�i����ۺ��pu%^u��\��J�u
\_��}�İ0�8�63K#a&@<abn��&����RƬm���|�v��K�ȗ������2�G��ש��J��]"Z��0�#�]0��]�@,v!��!|Aѧ�}��[����9�3��w�9iqMc�)�yBlV.81-3�Ul�6��K1�v-���b���D�~��A���K��e��$�-���=�4�4�z����S_�86�sl�;�KƬ��v�7��5�ں���&��Cb���k-gb�P�8S���9��%U�������7׍ ����P���J�t�@�	(j��ro� ̶V���������[��{�@�ް��X������S�s��kChA/r'����(bD�6VJ��f��9�mz:�y�Ěi3
7��l(ft��7�H��@���f��?�(l�&���~��MLl3�E̅��fB��b@u)ptX�Lb��]�p�A6#����r����Q9Ŧ�ڳ~V�M�������1�4$�#lq�Ml`��mj�uѢWU�頙s�(��K�_A�ǒ��̥�F�n��b�;��G�"�µ��zt6XL�N!��\G�9����n*s�rkX�&�����ݜ6�T�6)M���J2e3"���y�+x��o��oV���ԁ \����T���n3`J�詛m�j�<\hw�1�	M�}yps����>�T{�ې��6���kF�qsx-]��Ǎ��UA���Φ���B��}�9��<RP�\
&q�2nW,7�������`�P߶*����'���a=�8��p�A���|���x$gzQ�?ɂ<�A1|�ߢtZ���"�������~����|
5%T���X�cF%� ����K��g�6�雘�7ա�Q��|s{k��K��"V�7C���nW��K��W3��X-��'�W_�p�eマ������J��+\����(���R��~��R�:�?��5�1r��/	#zU�e[�E�9�zc=�>ԑc�t���V-r�S���������;HKAQn�:4�*jR0�	ٞ-L��dqd+I&	�5%D��u�c�n��5	��Cj�e����U-=7I�������2؅s{��[���{k7VK'2�&(�u�Y��G�J��������+��9z�5S�P�)���2n�8a	�R+LZ���k��/ކ3�zY+��u�{[W��f [V��EZ��л�,�������6��zy4N���EiN3�&?pu�wMw����J(�@/�D��KW�mc�7�Я�H����r�"�|w�������x��@���Q@�Ŭ��筶Ƽ�D�}�O}���ou�f'S�
٨�q&;{���Z�؎-�.e�ElK���,[���M��a��S�o��\et�K����Q�.r����F�ВPq"\��kN�(; �6�p���+g��:���2���
��N_��(tf��އ�DY����a�Vb�w�+�Q�C�-���y��h��1���k������d,���p��'��3,#�3Όr���M,���*U�[�P\�hq��l=��א�̈́���Ҿ��0�~m�/��iA�Č�� L1�7�m�8��7t�>C���7A]TC˧WU|?~���>=��\B/�ں�1���{����� 0�}�z��	3�ŵ7�1�ډՠW:|��z7���0WK����¥��3)��8�,5͘��e�����Q*M+��h�m���;��n��FY�M�^��+� �f�[�<�]��w��P�%SEz�3�\
�,��T;�,^�:��֓iN�Wv?��o�NL�p�j=g�bD���Z���j:�����ZTp��%�V����L��8�P-��A���J�ڎpԱ��l�I]:��U��G$�fp,��:}
�*u��Q��HoT� �p��!(��Ϙ[,5`��߄���؁����ur>����G�\	�D�E��$�%cj�&ƌ�*9���F����]�v���ڇ�
�yL�}�[����_��{6�΄[8��)��6'��1�Җg{6\��ls(��;�mPlX�'��v��&�z;�y��=�"��L��W�����4�Hh̙)d"�<��gb���B�Bu]~F�K�<'ܺ�n�H�9q�w�����i��6��{��5�[�*�һf\m�{�#g[2��sn�:)�+'Z
=s��s���*�o2�&t��3A �0�~��ܩn�,;߬CzeGb��k�L0ј��PZ-���R�S6*����oW�`
�pi�h5��!��B�9��g�������*�i[V�����&�A3�qQ;iyL]r�.#Y��E��g�\��n�هY��$4�~�]�En�ݾ����(�i���p� ֱ�v|���Y6Y�R����u�µ�ϊ�n�j�w��M�`�	�J���1#"������J��T.m̵<�\�$Tt��<י��s:�5���tT������i���i)l��JbrӀ���;{	�gj=�Å.�'<?��b����i���~��ӿ+�M��RF6�ta��3��İ�J�PC� Rq��B[��=��B>/�� �
wn�����������: ��幺]������Yo��{AA/3(�Yު��B��|3@  ��Tw'P����-tm噌s+�.�v��D�^��qλ�S��1X[����XjK*���"6yuI���"�E9���l)��z�D�- �G�83�-����InK�&bi�p0)Ĉ���Biʖ�*�ۗ��t����`��.��t\�.�B���Mv������K:��T�^mp���ڴ��U%-���������~I��LoWc��b���mw
�9�E�V��s��fj�D�� DjŶ�MQ��/&q����,̖{/�Y�U�?f���OGc����3�+S4W�����<o����B���jӰɇ�V!���[V;��M�Q�=�m�S��n�����~ک�bn��ɰ)͘�(���+�Z�� �r=ç��=�M,�����⨐Y�z�K��cIR�l���c;&i��$1qT�c��N2�b��YV/���l���z���<�D�q��U�?N��4H��b�I�Hs7M�	'�$*�7�N<�����p��9�B^>��d��_c�މ� ~(������q�Ya����JN�E@EM���B,ǹ�I�n�a�:��5�Z�y�;u�-HT���4�l�3JD$	ŲJ>��=�����x4���ߚkQEwQ�1�Cұ�| >$�����ZF�.��.5�g�f��v
�Wgϗ�6ݒ�f�nꚝ;n��;N+�s2��mB7�ZQ�� ��MBhl	�ۉ�q�${T	+��Ox��7uf� 6�C����h�)[7�d���8��|?.�	e�� 9  P&3�	� r#�]���TU�Δ���ΕM:�Vm��[��^�/c�-ڇ-&vP������kA�d+7�I|���9��2z�M�L�^5�4�̣��ʴ1�����w�t���Y����Ў��0Ƒ�q���&L�|�I!G��4V���N{*�.�j�~��Ap׮�_M}�:r|��B k.FA>�/�����_�A���p�'��וD��+�\t��{,QM��-�i����2�Pw�N�������H��=��m��`��ز1����6���D��no+<h;E��t����"�߻4!,C�˺ﮓ�0��x��!��c����=^ss.,py��.���i�>3SPX}�����<�vâ	U*5L�\z�=6��2H��z>z�6�<�>�5=�Vlve�<қ��R����Z�W:�_��ReX�2bˢ�m*M%Ɔ�	??-۝���N !zF�r7/�<�=�=k�^�1�㦉RԮ4�6I�[�������Au̋��m@B�,�����]������8.�-9S����)eIt#�R�BY2�����i�E�ilW�����z��Whz��y�@w�2���.�\O���V,��t�E��g��H@�O�����\���NM�v�$���;��������w1á3\�Ir�Z@'tmD��ܠ�܊����f<�RA8 ���e�z��tuHi�� QN��c(]�a�W�x���+Wo�8�V��O���y�G=�xd���F5��S��rs���5��.���������&�߲W�y�%x����]hP�2J��� (��2�	8L���du�q�f�C�,wa>���Ze��t1��;�F�\�i-ֺ�?��/#.XD9�/#L�I�b1�TW�/��^4����l?x:���9��p�ұ�J�?��قDsu�v���b��pX":������~�9�7d��u��=Ȉ�>K���m�E���zn�nL��TϔR	3avd���6g����oXٔJu���J�I��c�s�K�v��A��;��DjAǝ|��ÆMcH��T	'¢"�8�R(�-˅��@nѣS��tk������{�q垣U���u�� �%�Ԑ	őHRbJ`�mX�2�-E�ȧΜ�����qjvJP荏sHS�T˭O���}�;�_��Y�h�L�eE�m���`oZ������.���|e&B=r� }1s#�b�7ss�y���D��u�DZ)5�IS��^�(�$ƊD6�'���%�=S]R�9us�#�M <B2�Y#=`��+�k�����Wl�6�1#�$�EbX��MEl�Q[�y@Yc�f���d���Ŝ�=����]���&��_<͋SKƱ�#*%�vMQ�J�R�S�PZ��a�ʂ|����P��A_/���z�x�L�&�W���9E�����&�2l�X�Jqj�g�7��P�p�}*�$|���_{t��:��"܄ȼ���!�(�
�ƈ�'�$�MlD��͙2q�k��,�1]C��`����r���p(qЀ��j��ٵ���톎����i�m���l&�$�5�m�Z�}���i�X�@��;�\bI�-����\�� ���X�V��vԴ�d��A���l���%r���s$@�U�4�Ӻ���2!hg ���Ù�V�EM[ؖ`�4 ���|�4[�ɂ����۲�{��e��n�����*�>�o�>���[�{��?���y�;���k��w��}:6�xa���~�OB����9���or��l?�}�S��4�2����2������D�O���ѧ����z�n���������������5O�����|\��?�������ׯ���|:4:��A����G:�(Ο�S����'Б�p�Yo���Nn�VRo%G���������8P`1�4��q�BG?4,�s��գ����|:c9����¥Zd�S3������c_�g����ܮ���'��aO�l�������|��
�H�e�]�mxx��Y>}����ʣ�e��Q�+o�;�������?�j��u��sö ,`[1�aْJ$,I��Q�n�*:������'B���!�j}??� ��p����nܳ��bu�V<���Z��Aw��G�ȗ~Wۮ]�vV���L�=WT�t�>�X;���t����N)��8'@�8`HIm#��}��1ǥ�K�T���Y��sSG�sׇ�>ܔ�qS/$z/��J1 ���־��$J&f���0f����0�oY����!�4�%�S�>|��j~39�� ���$�!q
�����8ME�1[���v�:.�S=�H?�J�;χ����+�y��u����N3ۤs�Sj�3��e��NL+����/��=�E{���fr趞S��b ��[]�������%�)�$z. �"�$�<�����X	<�#d�)������A����l���p��׿�5I��$�D�-��o�SbQ��ْb��P�1��qg{�Ǖ�2Hy�7MrWwG���V�޹G��?�7�TSi�%�H$�m���Tk7�v<ުA��-�U �.-8�J�F�F��T�.��_�P�
�M7������G\G�C�$��[�%�R3�4q����{#ݪґ	��b���`��l_�̆}�m�A������DF�2��Fl`�ے��؎�eu՞U��fE��B�L�p��,�!�p�g�c�eK8?o��zD�N=ؠ��Ms�$1MM���U�P[&�����u�զ�vf�p&IgMgԻ$���-�c������R^�D�F$���LH�$��~���;4az;�� W�?� 2
@�{�>3\�-u���Z6ܸ���g�DBŖ���J�Ԕ��R�J��(��L��]��`pG�K'Hr��;�Q�G�/���ޡ��<�'²�H0eR�g�i[	&zҋ�^/��3@<��y^� L���*�<�|�Cp�A?��7]/���m��)�b���U���ib��kQ�ze�p�M{u)��Q���馷R���ʡ{�".�qV�̈́���[�]��ϼ�"�~@����S�bY�Y \�P��#�6��O_�g�%�&	Œ��\&L�$��f����7I��?���V,�3��f�J�����M�ش&G.Az��t�;f���.t6Ŵ>C�Z��$~w6��n��~\N>����N��All!���&*�/ ud�X�܈"��2SK 2 ?S)����q��5X�rMY�m3�,�u���7�[��:s���$Vf��$�!)M �e[FX�¸�~5紫�,S�%Y�"/uc��d'R�l�
��ɛ�XJ6S� 3�.�����|� �'Zc��tۓyR�'��礠
����y�%�Z���f���oA�Ksڻ     