-- Schema: auth
CREATE SCHEMA IF NOT EXISTS auth AUTHORIZATION ${auth_user};

-- Table: auth.role
CREATE TABLE IF NOT EXISTS auth.roles
(
    role_id BIGINT NOT NULL UNIQUE,
    role    TEXT   NOT NULL UNIQUE,
    primary key (role_id)
    );

INSERT INTO auth.roles
VALUES ('1', 'ROLE_USER');

Create sequence IF not exists auth.roles_id_seq START 2;
Alter table auth.roles
    Alter column role_id set default nextval('auth.roles_id_seq');

ALTER TABLE auth.roles
    OWNER to ${auth_user};

-- Table: auth.usr
CREATE TABLE IF NOT EXISTS auth.usr
(
    user_id  BIGINT NOT NULL UNIQUE,
    username TEXT   NOT NULL UNIQUE,
    password TEXT   NOT NULL,
    active   BOOLEAN         DEFAULT true,
    role     BIGINT NOT NULL DEFAULT 1 REFERENCES auth.roles (role_id),
    PRIMARY KEY (user_id)
);

Create sequence IF not exists auth.usr_id_seq START 1;
Alter table auth.usr
    Alter column user_id set default nextval('auth.usr_id_seq');

ALTER TABLE auth.usr
    OWNER to ${auth_user};

-- Schema: client
CREATE SCHEMA IF NOT EXISTS client AUTHORIZATION ${client_user};

-- Table: client.client
CREATE TABLE IF NOT EXISTS client.client
(
    client_id  BIGINT NOT NULL UNIQUE,
    user_id    BIGINT NOT NULL,
    firstname  TEXT   NOT NULL,
    surname    TEXT   NOT NULL,
    patronymic TEXT,
    birthday   DATE,
    PRIMARY KEY (client_id),
    CONSTRAINT user_id FOREIGN KEY (user_id)
    REFERENCES auth.usr (user_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    );

Create sequence IF not exists client.client_id_seq START 1;
Alter table client.client
    Alter column client_id set default nextval('client.client_id_seq');

ALTER TABLE client.client
    OWNER to ${bank_user};