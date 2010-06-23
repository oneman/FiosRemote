This program requires a database at this moment, postgres or mysql.

The default is postgres, the database of winners. 

If you are going to use mysql change adapter in vhash.rb ( LINE 5 or so) to mysql

Update the user/host/password as needed.

this is the only important table at this time

database data in: fiostv_otherway2.sql

Run that after creating the database/tables. Should work in mysql/postgres

----------
POSTGRES::::

CREATE TABLE vhashes (
    id integer DEFAULT nextval('vhahsh_id_seq'::regclass) NOT NULL,
    input character varying(8),
    output character varying(40)
);


MYSQL:::

CREATE TABLE vhashes (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    input VARCHAR(8),
    output VARCHAR(40)
);