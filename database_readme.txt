
change adapter in vhash.rb to mysql maybe

this is the only important table at this time

data in fiostv_data.sql

----------


CREATE TABLE vhashes (
    id integer DEFAULT nextval('vhahsh_id_seq'::regclass) NOT NULL,
    input character varying(8),
    output character varying(40)
);

