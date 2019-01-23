CREATE TABLE ip (
  ip_id BIGSERIAL PRIMARY KEY,
  ip INET
);

CREATE TABLE entity (
  entity_id BIGSERIAL PRIMARY KEY,
  name VARCHAR(255),
  ips CHAR(32)
);

CREATE UNIQUE INDEX ix_uq_entities_ips ON entity (ips);

CREATE TABLE entity2ip (
  id BIGSERIAL PRIMARY KEY,
  entity_id BIGINT NOT NULL REFERENCES entity(entity_id),
  ip_id BIGINT NOT NULL REFERENCES ip(ip_id)
);
