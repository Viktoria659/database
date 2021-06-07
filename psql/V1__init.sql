CREATE USER ${bank_user} WITH PASSWORD '${bank_password}';

CREATE SCHEMA IF NOT EXISTS bank AUTHORIZATION ${bank_user};

CREATE TABLE IF NOT EXISTS bank.client
(
  id   BIGINT NOT NULL UNIQUE,
  name text   NOT NULL,
  age  SMALLINT,
  primary key (id)
);

Create sequence if not exists bank.client_id_seq START 1;
Alter table bank.client
  Alter column id set default nextval('bank.client_id_seq');

ALTER TABLE bank.client
  OWNER to ${auth_user};

CREATE TABLE IF NOT EXISTS bank.account
(
  id        BIGINT  NOT NULL UNIQUE,
  client_id INTEGER NOT NULL,
  balance   INTEGER NOT NULL,
  primary key (id),
  CONSTRAINT client_id FOREIGN KEY (client_id)
    REFERENCES bank.client (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

Create sequence if not exists bank.account_id_seq START 1;
Alter table bank.account
  Alter column id set default nextval('bank.account_id_seq');

ALTER TABLE bank.account
  OWNER to ${auth_user};

CREATE TABLE IF NOT EXISTS bank.transaction
(
  id              BIGINT  NOT NULL UNIQUE,
  account_from_id INTEGER NOT NULL,
  account_to_id   INTEGER NOT NULL,
  count           INTEGER NOT NULL,
  primary key (id),
  CONSTRAINT account_from_id FOREIGN KEY (account_from_id)
    REFERENCES bank.account (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION,
  CONSTRAINT account_to_id FOREIGN KEY (account_to_id)
    REFERENCES bank.account (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
);

Create sequence if not exists bank.transaction_id_seq START 1;
Alter table bank.transaction
  Alter column id set default nextval('bank.transaction_id_seq');

ALTER TABLE bank.transaction
  OWNER to ${auth_user};
