This program requires a database at this moment, postgres or mysql.

At the bottom of this file is the create table sql.

The default is postgres, the database of winners. 

If you are going to use mysql change adapter in vhash.rb ( LINE 5 or so) to mysql

Update the user/host/password as needed.

this is the only important table at this time

database data in: fiostv_otherway2.sql

Run that after creating the database/tables. Should work in mysql/postgres

You need to install the active record gem! Its easy! 

gem install activerecord

for your user or sudo gem install activerecord.

if everything is working you should be able to do this: 

[oneman@blacktower::~/kode/fios]$ ruby search_vhashdb.rb e458c751afc21b7e981dadef677d297c33ce0918
FOUND input: 00000002 as decimal: 0-0:0.2 ouput: e458c751afc21b7e981dadef677d297c33ce0918
[oneman@blacktower::~/kode/fios]$

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