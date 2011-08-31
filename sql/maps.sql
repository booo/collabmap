-- Table: maps

-- DROP TABLE maps;

CREATE TABLE maps
(
  id character(32) NOT NULL,
  CONSTRAINT pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE maps OWNER TO postgres;
