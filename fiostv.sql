--
-- PostgreSQL database dump
--

-- Started on 2010-06-18 16:35:20 EDT

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- TOC entry 1783 (class 1262 OID 38181)
-- Name: fiosv; Type: DATABASE; Schema: -; Owner: homeview
--

CREATE DATABASE fiosv WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';


ALTER DATABASE fiosv OWNER TO homeview;

\connect fiosv

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

SET search_path = public, pg_catalog;

--
-- TOC entry 1495 (class 1259 OID 38185)
-- Dependencies: 3
-- Name: vhahsh_id_seq; Type: SEQUENCE; Schema: public; Owner: homeview
--

CREATE SEQUENCE vhahsh_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.vhahsh_id_seq OWNER TO homeview;

--
-- TOC entry 1497 (class 1259 OID 40928)
-- Dependencies: 3
-- Name: vhash2_id_seq; Type: SEQUENCE; Schema: public; Owner: homeview
--

CREATE SEQUENCE vhash2_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE public.vhash2_id_seq OWNER TO homeview;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 1494 (class 1259 OID 38182)
-- Dependencies: 1775 3
-- Name: vhashes; Type: TABLE; Schema: public; Owner: homeview; Tablespace: 
--

CREATE TABLE vhashes (
    id integer DEFAULT nextval('vhahsh_id_seq'::regclass) NOT NULL,
    input character varying(8),
    output character varying(40)
);


ALTER TABLE public.vhashes OWNER TO homeview;

--
-- TOC entry 1496 (class 1259 OID 40924)
-- Dependencies: 1776 3
-- Name: vhashes2; Type: TABLE; Schema: public; Owner: oneman; Tablespace: 
--

CREATE TABLE vhashes2 (
    id integer DEFAULT nextval('vhash2_id_seq'::regclass) NOT NULL,
    input character varying(8),
    output character varying(40)
);


ALTER TABLE public.vhashes2 OWNER TO oneman;

--
-- TOC entry 1778 (class 2606 OID 38225)
-- Dependencies: 1494 1494
-- Name: pkeyyay; Type: CONSTRAINT; Schema: public; Owner: homeview; Tablespace: 
--

ALTER TABLE ONLY vhashes
    ADD CONSTRAINT pkeyyay PRIMARY KEY (id);


--
-- TOC entry 1780 (class 2606 OID 40932)
-- Dependencies: 1496 1496
-- Name: vhash2pkey; Type: CONSTRAINT; Schema: public; Owner: oneman; Tablespace: 
--

ALTER TABLE ONLY vhashes2
    ADD CONSTRAINT vhash2pkey PRIMARY KEY (id);


--
-- TOC entry 1785 (class 0 OID 0)
-- Dependencies: 3
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2010-06-18 16:35:20 EDT

--
-- PostgreSQL database dump complete
--

