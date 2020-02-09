CREATE EXTENSION pgcrypto;

CREATE TABLE job_descriptions (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  description TEXT NOT NULL DEFAULT '',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE jobs (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  job_description UUID NOT NULL REFERENCES job_descriptions(id),
  payload JSON NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE statuses (
  id SERIAL NOT NULL PRIMARY KEY,
  name VARCHAR(10) NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE job_attempts (
  id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
  status INT NOT NULL REFERENCES statuses(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

INSERT INTO statuses (id, name) VALUES (1, 'pending');
INSERT INTO statuses (id, name) VALUES (2, 'started');
INSERT INTO statuses (id, name) VALUES (3, 'timeout');
INSERT INTO statuses (id, name) VALUES (4, 'failed');
INSERT INTO statuses (id, name) VALUES (5, 'success');