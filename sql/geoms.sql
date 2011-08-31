-- Table: geoms

-- DROP TABLE geoms;

CREATE TABLE geoms
(
  geom geometry NOT NULL,
  id serial NOT NULL,
  map_id character(32) NOT NULL,
  CONSTRAINT pg PRIMARY KEY (id),
  CONSTRAINT map_id FOREIGN KEY (map_id)
      REFERENCES maps (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE geoms OWNER TO postgres;
