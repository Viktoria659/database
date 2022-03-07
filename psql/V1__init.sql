CREATE SCHEMA IF NOT EXISTS bank AUTHORIZATION ${bank_user};

-- Table: bank.role
CREATE TABLE IF NOT EXISTS bank.role
(
    role_id BIGINT NOT NULL UNIQUE,
    role    TEXT   NOT NULL UNIQUE,
    primary key (role_id)
    );

INSERT INTO bank.role
VALUES ('1', 'ROLE_USER');
INSERT INTO bank.role
VALUES ('2', 'ROLE_ADMIN');

Create sequence if not exists bank.role_id_seq START 2;
Alter table bank.role
    Alter column role_id set default nextval('bank.role_id_seq');

ALTER TABLE bank.role
    OWNER to ${bank_user};

-- Table: bank.client
CREATE TABLE IF NOT EXISTS bank.client
(
    client_id  BIGINT NOT NULL UNIQUE,
    firstname  TEXT   NOT NULL,
    surname    TEXT   NOT NULL,
    patronymic TEXT,
    birthday   DATE,
    PRIMARY KEY (client_id)
);

CREATE SEQUENCE IF NOT EXISTS bank.client_id_seq START 1;
Alter table bank.client
    Alter column client_id set default nextval('bank.client_id_seq');

ALTER TABLE bank.client
    OWNER to ${bank_user};

-- Table: bank.usr
CREATE TABLE IF NOT EXISTS bank.usr
(
    user_id  BIGINT NOT NULL
        CONSTRAINT usr_pkey
            PRIMARY KEY
        CONSTRAINT fko1354jy5tci8vpw2gb4x3tbeo
            REFERENCES client,
    username TEXT   NOT NULL UNIQUE,
    password TEXT   NOT NULL,
    active   BOOLEAN         DEFAULT true,
    role     BIGINT NOT NULL DEFAULT 1 REFERENCES bank.role (role_id)
);

ALTER TABLE bank.usr
    OWNER to ${bank_user};

CREATE TABLE IF NOT EXISTS bank.account
(
    account_id    BIGINT NOT NULL UNIQUE,
    balance       BIGINT,
    version       BIGINT,
    created_date  TIMESTAMP,
    modified_date TIMESTAMP,
    comment       TEXT,
    client_id     BIGINT
        CONSTRAINT fkkm8yb63h4ownvnlrbwnadntyn
            REFERENCES client,
    PRIMARY KEY (account_id)
);

CREATE SEQUENCE IF NOT EXISTS bank.account_id_seq START 1;
ALTER TABLE bank.account
    ALTER COLUMN account_id SET DEFAULT nextval('bank.account_id_seq');

ALTER TABLE bank.account
    OWNER TO ${bank_user};

CREATE TABLE IF NOT EXISTS bank.revinfo
(
    rev      INTEGER NOT NULL
        CONSTRAINT revinfo_pkey
            PRIMARY KEY,
    revtstmp BIGINT
);

ALTER TABLE bank.revinfo
    OWNER TO ${bank_user};


CREATE TABLE IF NOT EXISTS bank.account_aud
(
    account_id    BIGINT  NOT NULL UNIQUE,
    rev           INTEGER NOT NULL
        CONSTRAINT fkaexie5n0kol2mjlvo03ii45d0
            REFERENCES revinfo,
    revtype       SMALLINT,
    balance       BIGINT,
    modified_date TIMESTAMP,
    created_date  TIMESTAMP,
    comment       TEXT,
        CONSTRAINT account_aud_pkey
            PRIMARY KEY (account_id, rev)
    );

ALTER TABLE bank.account_aud
    OWNER TO ${bank_user};