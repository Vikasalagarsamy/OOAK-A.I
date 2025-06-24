--
-- PostgreSQL database dump
--

-- Dumped from database version 15.13 (Homebrew)
-- Dumped by pg_dump version 15.13 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA _realtime;


ALTER SCHEMA _realtime OWNER TO vikasalagarsamy;

--
-- Name: audit_security; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA audit_security;


ALTER SCHEMA audit_security OWNER TO vikasalagarsamy;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO vikasalagarsamy;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO vikasalagarsamy;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO vikasalagarsamy;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO vikasalagarsamy;

--
-- Name: master_data; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA master_data;


ALTER SCHEMA master_data OWNER TO vikasalagarsamy;

--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO vikasalagarsamy;

--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS '';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO vikasalagarsamy;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO vikasalagarsamy;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO vikasalagarsamy;

--
-- Name: supabase_migrations; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA supabase_migrations;


ALTER SCHEMA supabase_migrations OWNER TO vikasalagarsamy;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: vikasalagarsamy
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO vikasalagarsamy;

--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO vikasalagarsamy;

--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


ALTER TYPE auth.code_challenge_method OWNER TO vikasalagarsamy;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO vikasalagarsamy;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


ALTER TYPE auth.factor_type OWNER TO vikasalagarsamy;

--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


ALTER TYPE auth.one_time_token_type OWNER TO vikasalagarsamy;

--
-- Name: action; Type: TYPE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


ALTER TYPE realtime.action OWNER TO vikasalagarsamy;

--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


ALTER TYPE realtime.equality_op OWNER TO vikasalagarsamy;

--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


ALTER TYPE realtime.user_defined_filter OWNER TO vikasalagarsamy;

--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


ALTER TYPE realtime.wal_column OWNER TO vikasalagarsamy;

--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


ALTER TYPE realtime.wal_rls OWNER TO vikasalagarsamy;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: vikasalagarsamy
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO vikasalagarsamy;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: vikasalagarsamy
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO vikasalagarsamy;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: vikasalagarsamy
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO vikasalagarsamy;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: vikasalagarsamy
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO vikasalagarsamy;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: vikasalagarsamy
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO vikasalagarsamy;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: vikasalagarsamy
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: vikasalagarsamy
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO vikasalagarsamy;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: vikasalagarsamy
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: vikasalagarsamy
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

    ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
    ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

    REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
    REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

    GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
  END IF;
END;
$$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO vikasalagarsamy;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: vikasalagarsamy
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: vikasalagarsamy
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO vikasalagarsamy;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: vikasalagarsamy
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO vikasalagarsamy;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: vikasalagarsamy
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO vikasalagarsamy;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: vikasalagarsamy
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: vikasalagarsamy
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO vikasalagarsamy;

--
-- Name: add_employee(character varying, character varying, character varying, character varying, character varying, integer, integer, integer, date, character varying, text, character varying); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.add_employee(p_first_name character varying, p_last_name character varying, p_email character varying, p_phone character varying, p_job_title character varying, p_department_id integer, p_designation_id integer, p_branch_id integer, p_hire_date date, p_status character varying, p_notes text, p_employee_id character varying) RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    new_employee_id INTEGER;
    trigger_exists BOOLEAN;
BEGIN
    -- Check if the problematic trigger exists
    SELECT EXISTS (
        SELECT 1 FROM information_schema.triggers 
        WHERE event_object_table = 'employees'
        AND trigger_name = 'employee_audit_trigger'
    ) INTO trigger_exists;
    
    -- If the trigger exists, temporarily disable it
    IF trigger_exists THEN
        EXECUTE 'ALTER TABLE employees DISABLE TRIGGER employee_audit_trigger';
    END IF;
    
    -- Insert the new employee
    INSERT INTO employees (
        first_name,
        last_name,
        email,
        phone,
        job_title,
        department_id,
        designation_id,
        branch_id,
        hire_date,
        status,
        notes,
        employee_id
    ) VALUES (
        p_first_name,
        p_last_name,
        p_email,
        p_phone,
        p_job_title,
        p_department_id,
        p_designation_id,
        p_branch_id,
        p_hire_date,
        p_status,
        p_notes,
        p_employee_id
    ) RETURNING id INTO new_employee_id;
    
    -- Log the activity to public.activities instead
    INSERT INTO activities (
        action_type,
        entity_type,
        entity_id,
        entity_name,
        description
    ) VALUES (
        'create',
        'employee',
        new_employee_id::text,
        p_first_name || ' ' || p_last_name,
        'New employee created'
    );
    
    -- Re-enable the trigger if it was disabled
    IF trigger_exists THEN
        EXECUTE 'ALTER TABLE employees ENABLE TRIGGER employee_audit_trigger';
    END IF;
    
    RETURN new_employee_id;
END;
$$;


ALTER FUNCTION public.add_employee(p_first_name character varying, p_last_name character varying, p_email character varying, p_phone character varying, p_job_title character varying, p_department_id integer, p_designation_id integer, p_branch_id integer, p_hire_date date, p_status character varying, p_notes text, p_employee_id character varying) OWNER TO vikasalagarsamy;

--
-- Name: FUNCTION add_employee(p_first_name character varying, p_last_name character varying, p_email character varying, p_phone character varying, p_job_title character varying, p_department_id integer, p_designation_id integer, p_branch_id integer, p_hire_date date, p_status character varying, p_notes text, p_employee_id character varying); Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON FUNCTION public.add_employee(p_first_name character varying, p_last_name character varying, p_email character varying, p_phone character varying, p_job_title character varying, p_department_id integer, p_designation_id integer, p_branch_id integer, p_hire_date date, p_status character varying, p_notes text, p_employee_id character varying) IS 'Safely adds a new employee while bypassing audit_security schema permissions';


--
-- Name: add_to_communication_timeline(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.add_to_communication_timeline() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO client_communication_timeline (
    quotation_id,
    client_phone,
    communication_type,
    communication_direction,
    content,
    timestamp,
    reference_id,
    metadata
  ) VALUES (
    NEW.quotation_id,
    NEW.client_phone,
    'whatsapp',
    CASE WHEN NEW.message_type = 'incoming' THEN 'inbound' ELSE 'outbound' END,
    NEW.message_text,
    NEW.timestamp,
    NEW.id,
    jsonb_build_object('interakt_message_id', NEW.interakt_message_id, 'media_type', NEW.media_type)
  );
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.add_to_communication_timeline() OWNER TO vikasalagarsamy;

--
-- Name: analyze_view_performance(text, integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.analyze_view_performance(p_view_name text, p_hours integer DEFAULT 24) RETURNS TABLE(total_queries integer, avg_execution_time_ms double precision, max_execution_time_ms double precision, avg_rows_returned double precision, last_execution timestamp with time zone)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER as total_queries,
        ROUND(AVG(execution_time_ms)::numeric, 2) as avg_execution_time_ms,
        ROUND(MAX(execution_time_ms)::numeric, 2) as max_execution_time_ms,
        ROUND(AVG(rows_returned)::numeric, 2) as avg_rows_returned,
        MAX(created_at) as last_execution
    FROM query_performance_logs
    WHERE view_name = p_view_name
    AND created_at > (CURRENT_TIMESTAMP - (p_hours || ' hours')::interval);
END;
$$;


ALTER FUNCTION public.analyze_view_performance(p_view_name text, p_hours integer) OWNER TO vikasalagarsamy;

--
-- Name: api_get_users_by_role(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.api_get_users_by_role(p_role_id integer) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  result JSON;
BEGIN
  SELECT json_agg(row_to_json(users))
  INTO result
  FROM (
    SELECT 
      ua.id,
      ua.username,
      ua.email,
      CONCAT(e.first_name, ' ', e.last_name) AS name,
      r.title AS role_name
    FROM 
      public.user_accounts ua
    JOIN 
      public.employees e ON ua.employee_id = e.id
    JOIN 
      public.roles r ON ua.role_id = r.id
    WHERE 
      ua.role_id = p_role_id
      AND ua.is_active = true
  ) users;
  
  RETURN COALESCE(result, '[]'::JSON);
END;
$$;


ALTER FUNCTION public.api_get_users_by_role(p_role_id integer) OWNER TO vikasalagarsamy;

--
-- Name: archive_completed_tasks(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.archive_completed_tasks(days_old integer DEFAULT 90) RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
  archived_count INTEGER;
BEGIN
  UPDATE ai_tasks 
  SET 
    archived = TRUE,
    archived_at = NOW()
  WHERE 
    status = 'COMPLETED' 
    AND completed_at < NOW() - INTERVAL '1 day' * days_old
    AND archived = FALSE;
    
  GET DIAGNOSTICS archived_count = ROW_COUNT;
  
  RETURN archived_count;
END;
$$;


ALTER FUNCTION public.archive_completed_tasks(days_old integer) OWNER TO vikasalagarsamy;

--
-- Name: archive_old_notifications(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.archive_old_notifications() RETURNS integer
    LANGUAGE plpgsql
    AS $$
DECLARE
    archived_count INTEGER;
BEGIN
    -- Move notifications older than 90 days to archive table
    CREATE TABLE IF NOT EXISTS notifications_archive (LIKE notifications INCLUDING ALL);
    
    WITH moved_notifications AS (
        DELETE FROM notifications 
        WHERE created_at < NOW() - INTERVAL '90 days'
        AND is_read = true
        RETURNING *
    )
    INSERT INTO notifications_archive SELECT * FROM moved_notifications;
    
    GET DIAGNOSTICS archived_count = ROW_COUNT;
    
    -- Log the archival
    INSERT INTO system_logs (action, details, created_at) 
    VALUES ('notification_archive', 
            jsonb_build_object('archived_count', archived_count), 
            NOW());
    
    RETURN archived_count;
END;
$$;


ALTER FUNCTION public.archive_old_notifications() OWNER TO vikasalagarsamy;

--
-- Name: assign_all_unassigned_leads(uuid); Type: PROCEDURE; Schema: public; Owner: vikasalagarsamy
--

CREATE PROCEDURE public.assign_all_unassigned_leads(IN p_assigned_by uuid DEFAULT NULL::uuid)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_lead_id UUID;
    v_lead_cursor CURSOR FOR 
        SELECT id FROM leads 
        WHERE status = 'unassigned' 
        ORDER BY created_at;
BEGIN
    OPEN v_lead_cursor;
    
    LOOP
        FETCH v_lead_cursor INTO v_lead_id;
        EXIT WHEN NOT FOUND;
        
        BEGIN
            CALL auto_assign_lead(v_lead_id, p_assigned_by, 'Batch assignment of unassigned leads');
        EXCEPTION WHEN OTHERS THEN
            RAISE WARNING 'Failed to assign lead %: %', v_lead_id, SQLERRM;
        END;
    END LOOP;
    
    CLOSE v_lead_cursor;
END;
$$;


ALTER PROCEDURE public.assign_all_unassigned_leads(IN p_assigned_by uuid) OWNER TO vikasalagarsamy;

--
-- Name: assign_lead(uuid, uuid, uuid, text); Type: PROCEDURE; Schema: public; Owner: vikasalagarsamy
--

CREATE PROCEDURE public.assign_lead(IN p_lead_id uuid, IN p_assigned_to uuid, IN p_assigned_by uuid DEFAULT NULL::uuid, IN p_notes text DEFAULT NULL::text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_current_status VARCHAR(50);
    v_user_exists BOOLEAN;
    v_lead_exists BOOLEAN;
    v_lead_number VARCHAR;
    v_client_name VARCHAR;
    v_assigner_name VARCHAR;
BEGIN
    -- Check if lead exists
    SELECT EXISTS(SELECT 1 FROM leads WHERE id = p_lead_id) INTO v_lead_exists;
    IF NOT v_lead_exists THEN
        RAISE EXCEPTION 'Lead with ID % does not exist', p_lead_id;
    END IF;
    
    -- Check if user exists
    SELECT EXISTS(SELECT 1 FROM users WHERE id = p_assigned_to) INTO v_user_exists;
    IF NOT v_user_exists THEN
        RAISE EXCEPTION 'User with ID % does not exist', p_assigned_to;
    END IF;
    
    -- Get current lead status and details
    SELECT status, lead_number, client_name INTO v_current_status, v_lead_number, v_client_name 
    FROM leads WHERE id = p_lead_id;
    
    -- Get assigner name if provided
    IF p_assigned_by IS NOT NULL THEN
        SELECT first_name || ' ' || last_name INTO v_assigner_name 
        FROM users 
        WHERE id = p_assigned_by;
    ELSE
        v_assigner_name := 'System';
    END IF;
    
    -- Update the lead
    UPDATE leads
    SET 
        assigned_to = p_assigned_to,
        status = CASE 
                    WHEN v_current_status = 'unassigned' THEN 'assigned'
                    ELSE v_current_status
                 END,
        updated_at = NOW()
    WHERE id = p_lead_id;
    
    -- Record the assignment in history
    INSERT INTO lead_assignment_history (
        id,
        lead_id,
        assigned_to,
        assigned_by,
        assignment_date,
        notes
    ) VALUES (
        gen_random_uuid(),
        p_lead_id,
        p_assigned_to,
        p_assigned_by,
        NOW(),
        p_notes
    );
    
    -- Create notification for the assigned user
    INSERT INTO notifications (
        recipient_id,
        type,
        title,
        message,
        entity_type,
        entity_id
    ) VALUES (
        p_assigned_to,
        'lead_assigned',
        'New Lead Assigned',
        'You have been assigned lead #' || v_lead_number || ' (' || v_client_name || ') by ' || v_assigner_name,
        'lead',
        p_lead_id
    );
    
    RAISE NOTICE 'Lead % successfully assigned to user %', p_lead_id, p_assigned_to;
END;
$$;


ALTER PROCEDURE public.assign_lead(IN p_lead_id uuid, IN p_assigned_to uuid, IN p_assigned_by uuid, IN p_notes text) OWNER TO vikasalagarsamy;

--
-- Name: auto_assign_lead(uuid, uuid, text); Type: PROCEDURE; Schema: public; Owner: vikasalagarsamy
--

CREATE PROCEDURE public.auto_assign_lead(IN p_lead_id uuid, IN p_assigned_by uuid DEFAULT NULL::uuid, IN p_notes text DEFAULT 'Automatically assigned based on workload'::text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_assigned_to UUID;
BEGIN
    -- Get the best user for assignment
    SELECT get_best_sales_user_for_lead() INTO v_assigned_to;
    
    IF v_assigned_to IS NULL THEN
        RAISE EXCEPTION 'No suitable sales team member found for assignment';
    END IF;
    
    -- Call the assign_lead procedure
    CALL assign_lead(p_lead_id, v_assigned_to, p_assigned_by, p_notes);
END;
$$;


ALTER PROCEDURE public.auto_assign_lead(IN p_lead_id uuid, IN p_assigned_by uuid, IN p_notes text) OWNER TO vikasalagarsamy;

--
-- Name: auto_reassign_leads_on_employee_status_change(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.auto_reassign_leads_on_employee_status_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    affected_count INTEGER;
    employee_name TEXT;
BEGIN
    -- Set employee name for use in notifications
    employee_name := NEW.first_name || ' ' || NEW.last_name;
    
    -- Use LOWER() for case-insensitive comparison of status values
    IF (LOWER(NEW.status) IN ('inactive', 'on_leave', 'terminated')) AND
       (LOWER(OLD.status) != LOWER(NEW.status)) THEN
        
        BEGIN -- Inner block for error handling
            -- Insert a record into activities table to log this automatic reassignment
            INSERT INTO activities (
                action_type,
                entity_type,
                entity_id,
                entity_name,
                description,
                user_name
            ) VALUES (
                'auto_reassign',
                'employee',
                NEW.id::text,
                employee_name,
                'Automatically reassigned leads due to employee status change to ' || NEW.status,
                'System'
            );
            
            -- Get count of affected leads for notification
            SELECT COUNT(*) INTO affected_count
            FROM leads
            WHERE assigned_to = NEW.id 
            AND UPPER(status) NOT IN ('WON', 'REJECTED');
            
            -- Update all leads assigned to this employee, except those with 'WON' or 'REJECTED' status
            -- Now tracking previous assignee information
            UPDATE leads
            SET 
                previous_assigned_to = assigned_to,
                assigned_to = NULL,
                status = 'UNASSIGNED',
                updated_at = NOW(),
                reassignment_date = NOW(),
                reassignment_reason = 'EMPLOYEE_STATUS_' || UPPER(NEW.status)
            WHERE 
                assigned_to = NEW.id 
                AND UPPER(status) NOT IN ('WON', 'REJECTED');
                
            -- Log this action in the activities table for each affected lead
            INSERT INTO activities (
                action_type,
                entity_type,
                entity_id,
                entity_name,
                description,
                user_name
            )
            SELECT 
                'auto_reassign',
                'lead',
                id::text,
                lead_number,
                'Lead automatically moved to unassigned pool due to ' || employee_name || ' status change to ' || NEW.status,
                'System'
            FROM leads
            WHERE previous_assigned_to = NEW.id 
            AND reassignment_reason = 'EMPLOYEE_STATUS_' || UPPER(NEW.status)
            AND reassignment_date >= NOW() - INTERVAL '5 minutes';
            
            -- Notify administrators if any leads were affected
            IF affected_count > 0 THEN
                PERFORM notify_admins_of_lead_reassignment(
                    NEW.id,
                    employee_name,
                    NEW.status,
                    affected_count
                );
            END IF;
                
        EXCEPTION WHEN OTHERS THEN
            -- Log the error
            INSERT INTO activities (
                action_type,
                entity_type,
                entity_id,
                entity_name,
                description,
                user_name
            ) VALUES (
                'error',
                'employee',
                NEW.id::text,
                COALESCE(employee_name, 'Unknown'),
                'Error in auto_reassign_leads: ' || SQLERRM,
                'System'
            );
        END;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.auto_reassign_leads_on_employee_status_change() OWNER TO vikasalagarsamy;

--
-- Name: batch_remove_employees(integer[]); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.batch_remove_employees(emp_ids integer[]) RETURNS TABLE(employee_id integer, success boolean, message text)
    LANGUAGE plpgsql
    AS $$
DECLARE
    emp_id INTEGER;
    result_record RECORD;
BEGIN
    -- For each employee ID in the array
    FOREACH emp_id IN ARRAY emp_ids
    LOOP
        BEGIN
            -- First update any leads assigned to this employee
            UPDATE leads SET assigned_to = NULL WHERE assigned_to = emp_id;
            
            -- Remove from team_members if exists
            DELETE FROM team_members WHERE employee_id = emp_id;
            
            -- Update any teams where this employee is the lead
            UPDATE teams SET team_lead_id = NULL WHERE team_lead_id = emp_id;
            
            -- Update any departments where this employee is the manager
            UPDATE departments SET manager_id = NULL WHERE manager_id = emp_id;
            
            -- Update any branches where this employee is the manager
            UPDATE branches SET manager_id = NULL WHERE manager_id = emp_id;
            
            -- Delete from employee_companies to avoid foreign key constraints
            DELETE FROM employee_companies WHERE employee_id = emp_id;
            
            -- Delete any activities related to this employee if they exist
            -- This is a safe operation as it will only delete if records exist
            DELETE FROM activities 
            WHERE entity_type = 'employee' AND entity_id = emp_id::text;
            
            -- Finally delete the employee record
            DELETE FROM employees WHERE id = emp_id;
            
            -- Return success for this employee
            employee_id := emp_id;
            success := TRUE;
            message := 'Successfully deleted';
            RETURN NEXT;
            
        EXCEPTION WHEN OTHERS THEN
            -- Return failure for this employee
            employee_id := emp_id;
            success := FALSE;
            message := 'Error: ' || SQLERRM;
            RETURN NEXT;
            
            -- Continue with the next employee
            CONTINUE;
        END;
    END LOOP;
    
    RETURN;
END;
$$;


ALTER FUNCTION public.batch_remove_employees(emp_ids integer[]) OWNER TO vikasalagarsamy;

--
-- Name: check_admin_menu_permissions(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.check_admin_menu_permissions() RETURNS TABLE(menu_item_id integer, menu_name text, has_permission boolean, can_view boolean, can_add boolean, can_edit boolean, can_delete boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_admin_role_id INTEGER;
BEGIN
  -- Get the Administrator role ID - only using title or id
  SELECT id INTO v_admin_role_id 
  FROM roles 
  WHERE title = 'Administrator' OR id = 1
  LIMIT 1;
  
  -- If no admin role found, return empty result
  IF v_admin_role_id IS NULL THEN
    RAISE EXCEPTION 'Administrator role not found';
    RETURN;
  END IF;
  
  -- Return the permissions
  RETURN QUERY
  SELECT 
    mi.id AS menu_item_id,
    mi.name AS menu_name,
    (rmp.menu_item_id IS NOT NULL) AS has_permission,
    COALESCE(rmp.can_view, FALSE) AS can_view,
    COALESCE(rmp.can_add, FALSE) AS can_add,
    COALESCE(rmp.can_edit, FALSE) AS can_edit,
    COALESCE(rmp.can_delete, FALSE) AS can_delete
  FROM 
    menu_items mi
  LEFT JOIN 
    role_menu_permissions rmp ON mi.id = rmp.menu_item_id AND rmp.role_id = v_admin_role_id
  ORDER BY 
    mi.parent_id NULLS FIRST, mi.sort_order;
END;
$$;


ALTER FUNCTION public.check_admin_menu_permissions() OWNER TO vikasalagarsamy;

--
-- Name: check_completion_consistency(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.check_completion_consistency() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- If status is COMPLETED, ensure completed_at is set
  IF NEW.status = 'COMPLETED' AND NEW.completed_at IS NULL THEN
    NEW.completed_at = NOW();
  END IF;
  
  -- If status is not COMPLETED, clear completed_at
  IF NEW.status != 'COMPLETED' THEN
    NEW.completed_at = NULL;
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_completion_consistency() OWNER TO vikasalagarsamy;

--
-- Name: check_employee_primary_company(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.check_employee_primary_company() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Skip validation if the employee is being deleted
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;
    
    -- For other operations, perform the validation
    IF NOT EXISTS (
        SELECT 1 FROM employee_companies 
        WHERE employee_id = NEW.id AND is_primary = true
    ) THEN
        RAISE EXCEPTION 'Employee must have at least one primary company';
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_employee_primary_company() OWNER TO vikasalagarsamy;

--
-- Name: check_primary_company(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.check_primary_company() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- If setting is_primary to false, check if there's another primary
    IF (TG_OP = 'UPDATE' AND OLD.is_primary = TRUE AND NEW.is_primary = FALSE) THEN
        IF NOT EXISTS (
            SELECT 1 FROM employee_companies 
            WHERE employee_id = NEW.employee_id 
            AND is_primary = TRUE 
            AND id != NEW.id
        ) THEN
            RAISE EXCEPTION 'Employee must have at least one primary company';
        END IF;
    END IF;
    
    -- If deleting a primary company, check if there's another primary
    IF (TG_OP = 'DELETE' AND OLD.is_primary = TRUE) THEN
        IF NOT EXISTS (
            SELECT 1 FROM employee_companies 
            WHERE employee_id = OLD.employee_id 
            AND is_primary = TRUE 
            AND id != OLD.id
        ) THEN
            RAISE EXCEPTION 'Employee must have at least one primary company';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.check_primary_company() OWNER TO vikasalagarsamy;

--
-- Name: check_user_menu_permission(uuid, character varying, character varying); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.check_user_menu_permission(p_user_id uuid, p_menu_path character varying, p_permission character varying DEFAULT 'view'::character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_has_permission BOOLEAN;
  v_is_admin BOOLEAN;
BEGIN
  -- Check if user is an administrator (role_id = 1 or title = 'Administrator')
  SELECT EXISTS (
    SELECT 1 FROM user_accounts ua
    JOIN roles r ON ua.role_id = r.id
    WHERE ua.id = p_user_id AND (r.id = 1 OR r.title = 'Administrator')
  ) INTO v_is_admin;
  
  -- Administrators have all permissions
  IF v_is_admin THEN
    RETURN TRUE;
  END IF;
  
  -- Check specific permission
  CASE p_permission
    WHEN 'view' THEN
      SELECT EXISTS (
        SELECT 1 FROM user_menu_permissions
        WHERE user_id = p_user_id AND menu_path = p_menu_path AND can_view = TRUE
      ) INTO v_has_permission;
    WHEN 'add' THEN
      SELECT EXISTS (
        SELECT 1 FROM user_menu_permissions
        WHERE user_id = p_user_id AND menu_path = p_menu_path AND can_add = TRUE
      ) INTO v_has_permission;
    WHEN 'edit' THEN
      SELECT EXISTS (
        SELECT 1 FROM user_menu_permissions
        WHERE user_id = p_user_id AND menu_path = p_menu_path AND can_edit = TRUE
      ) INTO v_has_permission;
    WHEN 'delete' THEN
      SELECT EXISTS (
        SELECT 1 FROM user_menu_permissions
        WHERE user_id = p_user_id AND menu_path = p_menu_path AND can_delete = TRUE
      ) INTO v_has_permission;
    ELSE
      v_has_permission := FALSE;
  END CASE;
  
  RETURN v_has_permission;
END;
$$;


ALTER FUNCTION public.check_user_menu_permission(p_user_id uuid, p_menu_path character varying, p_permission character varying) OWNER TO vikasalagarsamy;

--
-- Name: create_bugs_tables(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.create_bugs_tables() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check and create bugs table
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'bugs') THEN
        EXECUTE 'CREATE TABLE bugs (
            id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            severity TEXT NOT NULL CHECK (severity IN (''critical'', ''high'', ''medium'', ''low'')),
            status TEXT NOT NULL DEFAULT ''open'' CHECK (status IN (''open'', ''in_progress'', ''resolved'', ''closed'')),
            assignee_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
            reporter_id UUID REFERENCES auth.users(id) NOT NULL,
            due_date TIMESTAMP WITH TIME ZONE,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );';

        -- Add indexes for performance
        EXECUTE 'CREATE INDEX idx_bugs_status ON bugs(status);';
        EXECUTE 'CREATE INDEX idx_bugs_severity ON bugs(severity);';
        EXECUTE 'CREATE INDEX idx_bugs_assignee ON bugs(assignee_id);';
    END IF;

    -- Check and create bug_comments table
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'bug_comments') THEN
        EXECUTE 'CREATE TABLE bug_comments (
            id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
            bug_id BIGINT REFERENCES bugs(id) ON DELETE CASCADE,
            user_id UUID REFERENCES auth.users(id) NOT NULL,
            content TEXT NOT NULL,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
            updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );';
        
        EXECUTE 'CREATE INDEX idx_bug_comments_bug_id ON bug_comments(bug_id);';
    END IF;

    -- Check and create bug_attachments table
    IF NOT EXISTS (SELECT 1 FROM pg_tables WHERE schemaname = 'public' AND tablename = 'bug_attachments') THEN
        EXECUTE 'CREATE TABLE bug_attachments (
            id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
            bug_id BIGINT REFERENCES bugs(id) ON DELETE CASCADE,
            file_name TEXT NOT NULL,
            file_path TEXT NOT NULL,
            file_type TEXT NOT NULL,
            file_size INTEGER NOT NULL,
            uploaded_by UUID REFERENCES auth.users(id) NOT NULL,
            created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
        );';
        
        EXECUTE 'CREATE INDEX idx_bug_attachments_bug_id ON bug_attachments(bug_id);';
    END IF;

    -- Create triggers for updated_at
    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trigger_bugs_updated_at') THEN
        EXECUTE 'CREATE TRIGGER trigger_bugs_updated_at
        BEFORE UPDATE ON bugs
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_trigger WHERE tgname = 'trigger_bug_comments_updated_at') THEN
        EXECUTE 'CREATE TRIGGER trigger_bug_comments_updated_at
        BEFORE UPDATE ON bug_comments
        FOR EACH ROW
        EXECUTE FUNCTION update_updated_at_column();';
    END IF;
END;
$$;


ALTER FUNCTION public.create_bugs_tables() OWNER TO vikasalagarsamy;

--
-- Name: create_clients_table(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.create_clients_table() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Create clients table if it doesn't exist
  CREATE TABLE IF NOT EXISTS clients (
    id SERIAL PRIMARY KEY,
    client_code VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    company_id INTEGER NOT NULL REFERENCES companies(id) ON DELETE CASCADE,
    contact_person VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    address TEXT,
    category VARCHAR(20) CHECK (category IN ('BUSINESS', 'INDIVIDUAL', 'CORPORATE', 'GOVERNMENT', 'NON-PROFIT')) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('ACTIVE', 'INACTIVE', 'PENDING')) NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
  );
  
  -- Create index on company_id for faster lookups
  CREATE INDEX IF NOT EXISTS idx_clients_company_id ON clients(company_id);
  
  -- Create index on client_code for faster lookups
  CREATE INDEX IF NOT EXISTS idx_clients_client_code ON clients(client_code);
  
  -- Drop the trigger if it exists
  DROP TRIGGER IF EXISTS update_clients_updated_at_trigger ON clients;
  
  -- Create the trigger
  CREATE TRIGGER update_clients_updated_at_trigger
  BEFORE UPDATE ON clients
  FOR EACH ROW
  EXECUTE FUNCTION update_clients_updated_at();
END;
$$;


ALTER FUNCTION public.create_clients_table() OWNER TO vikasalagarsamy;

--
-- Name: create_event(character varying, boolean); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.create_event(p_name character varying, p_is_active boolean DEFAULT true) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_event_id TEXT;
    result JSONB;
BEGIN
    -- Generate a unique event ID
    new_event_id := generate_event_id();
    
    -- Insert the new event
    INSERT INTO public.events (event_id, name, is_active)
    VALUES (new_event_id, p_name, p_is_active)
    RETURNING jsonb_build_object(
        'id', id,
        'event_id', event_id,
        'name', name,
        'is_active', is_active,
        'created_at', created_at,
        'updated_at', updated_at
    ) INTO result;
    
    RETURN result;
END;
$$;


ALTER FUNCTION public.create_event(p_name character varying, p_is_active boolean) OWNER TO vikasalagarsamy;

--
-- Name: create_hr_activities_table_if_not_exists(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.create_hr_activities_table_if_not_exists() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Check if the table already exists
  IF NOT EXISTS (
    SELECT FROM pg_tables 
    WHERE schemaname = 'public' 
    AND tablename = 'hr_activities'
  ) THEN
    -- Create the hr_activities table
    CREATE TABLE public.hr_activities (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      activity_type TEXT NOT NULL,
      description TEXT NOT NULL,
      performed_by TEXT NOT NULL,
      related_entity TEXT NOT NULL,
      entity_id INTEGER NOT NULL,
      timestamp TIMESTAMPTZ NOT NULL DEFAULT NOW(),
      metadata JSONB
    );
    
    -- Create indexes for better performance
    CREATE INDEX idx_hr_activities_activity_type ON public.hr_activities(activity_type);
    CREATE INDEX idx_hr_activities_related_entity ON public.hr_activities(related_entity);
    CREATE INDEX idx_hr_activities_entity_id ON public.hr_activities(entity_id);
    CREATE INDEX idx_hr_activities_timestamp ON public.hr_activities(timestamp);
  END IF;
END;
$$;


ALTER FUNCTION public.create_hr_activities_table_if_not_exists() OWNER TO vikasalagarsamy;

--
-- Name: create_menu_tracking_table(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.create_menu_tracking_table() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Check if the table already exists
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'menu_items_tracking'
  ) THEN
    -- Create the tracking table
    CREATE TABLE menu_items_tracking (
      id SERIAL PRIMARY KEY,
      menu_item_id INTEGER NOT NULL UNIQUE,
      last_known_state JSONB NOT NULL,
      last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );
    
    -- Create an index for faster lookups
    CREATE INDEX idx_menu_items_tracking_menu_item_id ON menu_items_tracking(menu_item_id);
    
    RETURN TRUE;
  END IF;
  
  RETURN TRUE;
END;
$$;


ALTER FUNCTION public.create_menu_tracking_table() OWNER TO vikasalagarsamy;

--
-- Name: create_system_logs_if_not_exists(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.create_system_logs_if_not_exists() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF NOT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'system_logs') THEN
    CREATE TABLE system_logs (
      id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
      type TEXT NOT NULL,
      message TEXT NOT NULL,
      severity TEXT NOT NULL,
      timestamp TIMESTAMPTZ NOT NULL,
      resolved BOOLEAN DEFAULT FALSE
    );
  END IF;
END;
$$;


ALTER FUNCTION public.create_system_logs_if_not_exists() OWNER TO vikasalagarsamy;

--
-- Name: current_user_id(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.current_user_id() RETURNS integer
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- This should return the current authenticated user's ID
    -- Implementation depends on your authentication system
    RETURN COALESCE(
        (current_setting('app.current_user_id', true))::INTEGER,
        1 -- Fallback to admin user for now
    );
END;
$$;


ALTER FUNCTION public.current_user_id() OWNER TO vikasalagarsamy;

--
-- Name: current_user_role(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.current_user_role() RETURNS text
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- This should return the current user's role
    -- Implementation depends on your authentication system
    RETURN COALESCE(
        current_setting('app.current_user_role', true),
        'Administrator' -- Fallback for now
    );
END;
$$;


ALTER FUNCTION public.current_user_role() OWNER TO vikasalagarsamy;

--
-- Name: delete_employee(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.delete_employee(emp_id integer) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    employee_exists BOOLEAN;
BEGIN
    -- Check if the employee exists
    SELECT EXISTS (
        SELECT 1 FROM employees 
        WHERE id = emp_id
    ) INTO employee_exists;
    
    -- If employee doesn't exist, return false
    IF NOT employee_exists THEN
        RAISE NOTICE 'Employee with ID % does not exist', emp_id;
        RETURN false;
    END IF;

    -- Begin by deleting related records in a specific order to maintain referential integrity
    
    -- 1. Delete employee company associations first
    -- This is where the primary company check was happening
    DELETE FROM employee_companies WHERE employee_id = emp_id;
    
    -- 2. Update any leads assigned to this employee (set to NULL)
    UPDATE leads SET assigned_to = NULL WHERE assigned_to = emp_id;
    
    -- 3. Delete from other related tables (if they exist)
    -- These are examples - adjust based on your actual schema
    BEGIN
        DELETE FROM employee_assignments WHERE employee_id = emp_id;
        EXCEPTION WHEN undefined_table THEN
            -- Table doesn't exist, continue
            NULL;
    END;
    
    BEGIN
        DELETE FROM team_members WHERE employee_id = emp_id;
        EXCEPTION WHEN undefined_table THEN
            -- Table doesn't exist, continue
            NULL;
    END;
    
    BEGIN
        DELETE FROM employee_schedule WHERE employee_id = emp_id;
        EXCEPTION WHEN undefined_table THEN
            -- Table doesn't exist, continue
            NULL;
    END;
    
    BEGIN
        DELETE FROM employee_documents WHERE employee_id = emp_id;
        EXCEPTION WHEN undefined_table THEN
            -- Table doesn't exist, continue
            NULL;
    END;
    
    -- 4. Finally delete the employee record
    DELETE FROM employees WHERE id = emp_id;
    
    -- Return success
    RETURN true;
END;
$$;


ALTER FUNCTION public.delete_employee(emp_id integer) OWNER TO vikasalagarsamy;

--
-- Name: FUNCTION delete_employee(emp_id integer); Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON FUNCTION public.delete_employee(emp_id integer) IS 'Safely deletes an employee and all associated records in related tables';


--
-- Name: delete_employee(uuid); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.delete_employee(employee_id_param uuid) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public', 'pg_temp'
    AS $$
DECLARE
    employee_exists boolean;
    employee_record record;
BEGIN
    -- Check if the employee exists
    SELECT EXISTS (
        SELECT 1 FROM employees 
        WHERE id = employee_id_param
    ) INTO employee_exists;
    
    -- If employee doesn't exist, return false
    IF NOT employee_exists THEN
        RAISE NOTICE 'Employee with ID % does not exist', employee_id_param;
        RETURN false;
    END IF;
    
    -- Get employee record for audit purposes
    SELECT * INTO employee_record FROM employees WHERE id = employee_id_param;

    -- Delete related records in other tables
    -- These are example tables that might reference employees
    -- You should adjust this based on your actual schema

    -- Delete employee assignments
    DELETE FROM employee_assignments WHERE employee_id = employee_id_param;
    
    -- Update leads assigned to this employee (reassign to null)
    UPDATE leads SET assigned_to = NULL WHERE assigned_to = employee_id_param;
    
    -- Remove employee from teams or projects
    DELETE FROM team_members WHERE employee_id = employee_id_param;
    DELETE FROM project_assignments WHERE employee_id = employee_id_param;
    
    -- Delete employee calendar/events
    DELETE FROM employee_schedule WHERE employee_id = employee_id_param;
    
    -- Delete employee performance records
    DELETE FROM performance_reviews WHERE employee_id = employee_id_param;
    
    -- Delete employee contact information
    DELETE FROM employee_contacts WHERE employee_id = employee_id_param;
    
    -- Delete employee documents
    DELETE FROM employee_documents WHERE employee_id = employee_id_param;
    
    -- Delete employee notes
    DELETE FROM notes WHERE related_entity = 'employee' AND entity_id = employee_id_param::text;

    -- Delete employee company associations
    DELETE FROM employee_companies WHERE employee_id = employee_id_param;

    -- Delete any authorization/authentication related records
    DELETE FROM user_roles WHERE user_id = (
        SELECT user_id FROM employees WHERE id = employee_id_param
    );
    
    -- Finally delete the employee record
    DELETE FROM employees WHERE id = employee_id_param;
    
    -- Instead of relying on the trigger for audit, manually insert audit record
    -- This is safer as we have explicit control over the audit process
    BEGIN
        -- Only attempt to insert into audit_trail if the schema exists and we have permission
        -- This makes the function more robust
        INSERT INTO public.activities (
            action_type,
            entity_type,
            entity_id,
            entity_name,
            description
        ) VALUES (
            'DELETE',
            'employee',
            employee_id_param::text,
            employee_record.first_name || ' ' || employee_record.last_name,
            'Employee deleted through delete_employee function'
        );
    EXCEPTION WHEN OTHERS THEN
        -- Log the error but continue with the deletion
        RAISE NOTICE 'Could not create audit record: %', SQLERRM;
    END;
    
    RAISE NOTICE 'Employee with ID % and all related records have been deleted', employee_id_param;
    RETURN true;
END;
$$;


ALTER FUNCTION public.delete_employee(employee_id_param uuid) OWNER TO vikasalagarsamy;

--
-- Name: FUNCTION delete_employee(employee_id_param uuid); Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON FUNCTION public.delete_employee(employee_id_param uuid) IS 'Safely deletes an employee and all associated records in related tables';


--
-- Name: delete_event(text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.delete_event(p_event_id text) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    rows_affected INTEGER;
BEGIN
    DELETE FROM public.events
    WHERE event_id = p_event_id
    RETURNING 1 INTO rows_affected;
    
    IF rows_affected IS NULL THEN
        RETURN FALSE;
    END IF;
    
    RETURN TRUE;
END;
$$;


ALTER FUNCTION public.delete_event(p_event_id text) OWNER TO vikasalagarsamy;

--
-- Name: delete_vendor_safely(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.delete_vendor_safely(vendor_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Start a transaction
  BEGIN
    -- Check if the vendor exists
    IF NOT EXISTS (SELECT 1 FROM vendors WHERE id = vendor_id) THEN
      RAISE EXCEPTION 'Vendor with ID % does not exist', vendor_id;
    END IF;
    
    -- Delete the vendor record
    DELETE FROM vendors WHERE id = vendor_id;
    
    -- If we get here, the deletion was successful
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      -- Rollback the transaction on error
      ROLLBACK;
      RAISE; -- Re-throw the error
  END;
END;
$$;


ALTER FUNCTION public.delete_vendor_safely(vendor_id integer) OWNER TO vikasalagarsamy;

--
-- Name: disable_audit_triggers(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.disable_audit_triggers() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Set a session variable to indicate audit triggers should be disabled
    PERFORM set_config('app.disable_audit_triggers', 'true', false);
END;
$$;


ALTER FUNCTION public.disable_audit_triggers() OWNER TO vikasalagarsamy;

--
-- Name: disable_employee_triggers(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.disable_employee_triggers() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Disable the audit trigger
  ALTER TABLE public.employees DISABLE TRIGGER employee_audit_trigger;
  
  -- Keep other triggers enabled for data validation
  -- We only need to disable the audit trigger that's causing permission issues
END;
$$;


ALTER FUNCTION public.disable_employee_triggers() OWNER TO vikasalagarsamy;

--
-- Name: enable_audit_triggers(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.enable_audit_triggers() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Reset the session variable
    PERFORM set_config('app.disable_audit_triggers', 'false', false);
END;
$$;


ALTER FUNCTION public.enable_audit_triggers() OWNER TO vikasalagarsamy;

--
-- Name: enable_employee_triggers(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.enable_employee_triggers() RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Re-enable the audit trigger
  ALTER TABLE public.employees ENABLE TRIGGER employee_audit_trigger;
END;
$$;


ALTER FUNCTION public.enable_employee_triggers() OWNER TO vikasalagarsamy;

--
-- Name: ensure_admin_menu_permissions(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.ensure_admin_menu_permissions() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_admin_role_id INTEGER;
  v_menu_item RECORD;
  v_count INTEGER;
  v_total_items INTEGER := 0;
  v_updated_items INTEGER := 0;
  v_inserted_items INTEGER := 0;
BEGIN
  -- Get the Administrator role ID - only using title or id
  SELECT id INTO v_admin_role_id 
  FROM roles 
  WHERE title = 'Administrator' OR id = 1
  LIMIT 1;
  
  -- If no admin role found, return false
  IF v_admin_role_id IS NULL THEN
    RAISE EXCEPTION 'Administrator role not found';
    RETURN FALSE;
  END IF;
  
  -- Make sure all menu items are visible
  UPDATE menu_items SET is_visible = TRUE;
  
  -- Count total menu items
  SELECT COUNT(*) INTO v_total_items FROM menu_items;
  
  -- Loop through all menu items
  FOR v_menu_item IN SELECT id FROM menu_items
  LOOP
    -- Check if permission already exists
    SELECT COUNT(*) INTO v_count
    FROM role_menu_permissions
    WHERE role_id = v_admin_role_id AND menu_item_id = v_menu_item.id;
    
    -- If permission doesn't exist, create it
    IF v_count = 0 THEN
      INSERT INTO role_menu_permissions (
        role_id,
        menu_item_id,
        can_view,
        can_add,
        can_edit,
        can_delete
      ) VALUES (
        v_admin_role_id,
        v_menu_item.id,
        TRUE,
        TRUE,
        TRUE,
        TRUE
      );
      v_inserted_items := v_inserted_items + 1;
    ELSE
      -- Update existing permission to ensure all are enabled
      UPDATE role_menu_permissions
      SET 
        can_view = TRUE,
        can_add = TRUE,
        can_edit = TRUE,
        can_delete = TRUE
      WHERE 
        role_id = v_admin_role_id AND 
        menu_item_id = v_menu_item.id;
      v_updated_items := v_updated_items + 1;
    END IF;
  END LOOP;
  
  -- Log the results
  RAISE NOTICE 'Admin menu permissions updated: Total items: %, Inserted: %, Updated: %', 
    v_total_items, v_inserted_items, v_updated_items;
  
  RETURN TRUE;
END;
$$;


ALTER FUNCTION public.ensure_admin_menu_permissions() OWNER TO vikasalagarsamy;

--
-- Name: ensure_menu_tracking_table(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.ensure_menu_tracking_table() RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Check if the table already exists
  IF NOT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_schema = 'public' 
    AND table_name = 'menu_items_tracking'
  ) THEN
    -- Create the tracking table
    CREATE TABLE menu_items_tracking (
      id SERIAL PRIMARY KEY,
      menu_item_id INTEGER NOT NULL UNIQUE,
      last_known_state JSONB NOT NULL,
      last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW()
    );
    
    -- Create an index for faster lookups
    CREATE INDEX idx_menu_items_tracking_menu_item_id ON menu_items_tracking(menu_item_id);
    
    RETURN TRUE;
  END IF;
  
  RETURN TRUE;
END;
$$;


ALTER FUNCTION public.ensure_menu_tracking_table() OWNER TO vikasalagarsamy;

--
-- Name: ensure_rejection_fields(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.ensure_rejection_fields() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Only run if status is REJECTED
    IF NEW.status = 'REJECTED' THEN
        -- Set rejection_reason if null
        IF NEW.rejection_reason IS NULL THEN
            NEW.rejection_reason := 'No reason provided (auto-filled by trigger)';
        END IF;
        
        -- Set rejected_at if null
        IF NEW.rejected_at IS NULL THEN
            NEW.rejected_at := NOW();
        END IF;
        
        -- Log a warning if rejected_by is null
        IF NEW.rejected_by IS NULL THEN
            RAISE WARNING 'Lead % marked as REJECTED but rejected_by is NULL', NEW.id;
        END IF;
        
        -- Log a warning if rejected_by_employee_id is null
        IF NEW.rejected_by_employee_id IS NULL THEN
            RAISE WARNING 'Lead % marked as REJECTED but rejected_by_employee_id is NULL', NEW.id;
        END IF;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.ensure_rejection_fields() OWNER TO vikasalagarsamy;

--
-- Name: execute_sql(text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.execute_sql(sql_statement text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  EXECUTE sql_statement;
  RETURN true;
EXCEPTION WHEN OTHERS THEN
  RAISE NOTICE 'Error executing SQL: %', SQLERRM;
  RETURN false;
END;
$$;


ALTER FUNCTION public.execute_sql(sql_statement text) OWNER TO vikasalagarsamy;

--
-- Name: expire_old_insights(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.expire_old_insights() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    UPDATE predictive_insights 
    SET 
        status = 'expired',
        updated_at = now()
    WHERE expires_at < now() 
    AND status != 'expired';
END;
$$;


ALTER FUNCTION public.expire_old_insights() OWNER TO vikasalagarsamy;

--
-- Name: generate_event_id(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.generate_event_id() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    new_id TEXT;
    existing_count INTEGER;
BEGIN
    LOOP
        -- Generate a random ID with EVT- prefix followed by 8 alphanumeric characters
        new_id := 'EVT-' || substr(md5(random()::text), 1, 8);
        
        -- Check if this ID already exists
        SELECT COUNT(*) INTO existing_count FROM public.events WHERE event_id = new_id;
        
        -- If the ID is unique, return it
        IF existing_count = 0 THEN
            RETURN new_id;
        END IF;
    END LOOP;
END;
$$;


ALTER FUNCTION public.generate_event_id() OWNER TO vikasalagarsamy;

--
-- Name: get_ai_system_configuration(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_ai_system_configuration() RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  config_result JSON;
BEGIN
  SELECT json_object_agg(config_key, config_value) INTO config_result
  FROM ai_configurations 
  WHERE is_active = true;
  
  RETURN config_result;
END;
$$;


ALTER FUNCTION public.get_ai_system_configuration() OWNER TO vikasalagarsamy;

--
-- Name: get_best_sales_user_for_lead(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_best_sales_user_for_lead() RETURNS uuid
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_user_id UUID;
BEGIN
    -- Select the user with the sales role who has the fewest active leads assigned
    SELECT u.id INTO v_user_id
    FROM users u
    LEFT JOIN (
        SELECT assigned_to, COUNT(*) as lead_count
        FROM leads
        WHERE status IN ('assigned', 'in_progress', 'contacted')
        GROUP BY assigned_to
    ) l ON u.id = l.assigned_to
    WHERE u.role = 'sales'
    ORDER BY COALESCE(l.lead_count, 0) ASC, u.last_sign_in_at DESC
    LIMIT 1;
    
    -- If no sales users found, return NULL
    IF v_user_id IS NULL THEN
        RAISE WARNING 'No sales users found for automatic assignment';
    END IF;
    
    RETURN v_user_id;
END;
$$;


ALTER FUNCTION public.get_best_sales_user_for_lead() OWNER TO vikasalagarsamy;

--
-- Name: get_complete_menu_hierarchy(text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_complete_menu_hierarchy(p_user_id text) RETURNS TABLE(id integer, parent_id integer, name text, path text, icon text, is_visible boolean, sort_order integer, can_view boolean, can_add boolean, can_edit boolean, can_delete boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_role_id INTEGER;
  v_is_admin BOOLEAN := FALSE;
  v_user_found BOOLEAN := FALSE;
BEGIN
  -- Log the input parameter for debugging
  RAISE NOTICE 'get_complete_menu_hierarchy called with p_user_id: %', p_user_id;
  
  -- First try to get the user directly
  BEGIN
    SELECT role_id INTO v_role_id 
    FROM user_accounts 
    WHERE id::TEXT = p_user_id;
    
    IF FOUND THEN
      v_user_found := TRUE;
      RAISE NOTICE 'User found with ID: %, role_id: %', p_user_id, v_role_id;
    END IF;
  EXCEPTION WHEN OTHERS THEN
    RAISE NOTICE 'Error finding user by ID: %', SQLERRM;
  END;
  
  -- If user not found, try other methods
  IF NOT v_user_found THEN
    BEGIN
      -- Try to find by employee_id
      SELECT ua.role_id INTO v_role_id 
      FROM user_accounts ua
      JOIN employees e ON ua.employee_id = e.id
      WHERE e.id::TEXT = p_user_id;
      
      IF FOUND THEN
        v_user_found := TRUE;
        RAISE NOTICE 'User found by employee_id: %, role_id: %', p_user_id, v_role_id;
      END IF;
    EXCEPTION WHEN OTHERS THEN
      RAISE NOTICE 'Error finding user by employee_id: %', SQLERRM;
    END;
  END IF;
  
  -- If still not found, check if p_user_id is '1' which indicates admin
  IF NOT v_user_found AND (p_user_id = '1' OR p_user_id = 1) THEN
    v_is_admin := TRUE;
    RAISE NOTICE 'Admin access granted based on p_user_id = 1';
  ELSIF v_role_id IS NOT NULL THEN
    -- Check if the role is Administrator
    SELECT EXISTS (
      SELECT 1 FROM roles 
      WHERE id = v_role_id AND (title = 'Administrator' OR id = 1)
    ) INTO v_is_admin;
    
    RAISE NOTICE 'Checked if role is admin: %, result: %', v_role_id, v_is_admin;
  END IF;
  
  -- If we still don't have a determination, default to showing admin view
  -- This ensures the menu is visible in case of errors
  IF NOT v_user_found AND NOT v_is_admin THEN
    RAISE WARNING 'User not found and not admin, defaulting to showing all menu items';
    v_is_admin := TRUE;
  END IF;
  
  -- Handle administrator role specially to ensure they see EVERYTHING
  IF v_is_admin THEN
    RAISE NOTICE 'Returning all menu items with full permissions for admin';
    
    -- Administrator role - show all menu items with full permissions
    RETURN QUERY
    SELECT 
      mi.id,
      mi.parent_id,
      mi.name,
      mi.path,
      mi.icon,
      COALESCE(mi.is_visible, TRUE), -- Default to visible if NULL
      COALESCE(mi.sort_order, 0),    -- Default to 0 if NULL
      TRUE as can_view,  -- Administrators always have all permissions
      TRUE as can_add,
      TRUE as can_edit,
      TRUE as can_delete
    FROM 
      menu_items mi
    ORDER BY 
      mi.parent_id NULLS FIRST, COALESCE(mi.sort_order, 0);
  ELSE
    RAISE NOTICE 'Returning menu items with permissions for role_id: %', v_role_id;
    
    -- For non-administrators, use regular permissions
    RETURN QUERY
    SELECT 
      mi.id,
      mi.parent_id,
      mi.name,
      mi.path,
      mi.icon,
      COALESCE(mi.is_visible, TRUE), -- Default to visible if NULL
      COALESCE(mi.sort_order, 0),    -- Default to 0 if NULL
      COALESCE(rmp.can_view, FALSE),
      COALESCE(rmp.can_add, FALSE),
      COALESCE(rmp.can_edit, FALSE),
      COALESCE(rmp.can_delete, FALSE)
    FROM 
      menu_items mi
    LEFT JOIN 
      role_menu_permissions rmp ON mi.id = rmp.menu_item_id AND rmp.role_id = v_role_id
    WHERE
      COALESCE(mi.is_visible, TRUE) = TRUE AND COALESCE(rmp.can_view, FALSE) = TRUE
    ORDER BY 
      mi.parent_id NULLS FIRST, COALESCE(mi.sort_order, 0);
  END IF;
END;
$$;


ALTER FUNCTION public.get_complete_menu_hierarchy(p_user_id text) OWNER TO vikasalagarsamy;

--
-- Name: get_complete_menu_hierarchy(uuid); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_complete_menu_hierarchy(p_user_id uuid) RETURNS TABLE(id integer, parent_id integer, name text, path text, icon text, is_visible boolean, sort_order integer, can_view boolean, can_add boolean, can_edit boolean, can_delete boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_role_id UUID;
BEGIN
  -- Get the user's role
  SELECT role_id INTO v_role_id FROM user_accounts WHERE id = p_user_id;
  
  -- Handle administrator role specially to ensure they see EVERYTHING
  IF v_role_id = 1 OR EXISTS (SELECT 1 FROM roles WHERE id = v_role_id AND title = 'Administrator') THEN
    -- Administrator role - show all menu items with full permissions
    RETURN QUERY
    SELECT 
      mi.id,
      mi.parent_id,
      mi.name,
      mi.path,
      mi.icon,
      mi.is_visible,
      mi.sort_order,
      TRUE as can_view,  -- Administrators always have all permissions
      TRUE as can_add,
      TRUE as can_edit,
      TRUE as can_delete
    FROM 
      menu_items mi
    ORDER BY 
      mi.parent_id NULLS FIRST, mi.sort_order;
  ELSE
    -- For non-administrators, use regular permissions
    RETURN QUERY
    SELECT 
      mi.id,
      mi.parent_id,
      mi.name,
      mi.path,
      mi.icon,
      mi.is_visible,
      mi.sort_order,
      COALESCE(rmp.can_view, FALSE),
      COALESCE(rmp.can_add, FALSE),
      COALESCE(rmp.can_edit, FALSE),
      COALESCE(rmp.can_delete, FALSE)
    FROM 
      menu_items mi
    LEFT JOIN 
      role_menu_permissions rmp ON mi.id = rmp.menu_item_id AND rmp.role_id = v_role_id
    WHERE
      mi.is_visible = TRUE AND COALESCE(rmp.can_view, FALSE) = TRUE
    ORDER BY 
      mi.parent_id NULLS FIRST, mi.sort_order;
  END IF;
END;
$$;


ALTER FUNCTION public.get_complete_menu_hierarchy(p_user_id uuid) OWNER TO vikasalagarsamy;

--
-- Name: get_comprehensive_employee_data(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_comprehensive_employee_data() RETURNS SETOF json
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    json_build_object(
      'id', e.id,
      'employee_id', e.employee_id,
      'first_name', e.first_name,
      'last_name', e.last_name,
      'email', e.email,
      'phone', e.phone,
      'job_title', e.job_title,
      'hire_date', e.hire_date,
      'status', e.status,
      'notes', e.notes,
      'created_at', e.created_at,
      'updated_at', e.updated_at,
      
      'department_id', d.id,
      'department_name', d.name,
      
      'designation_id', des.id,
      'designation_title', des.name,
      
      'branch_id', b.id,
      'branch_name', b.name,
      'branch_location', b.location,
      
      'primary_company_name', (
        SELECT c.name
        FROM employee_companies ec
        JOIN companies c ON ec.company_id = c.id
        WHERE ec.employee_id = e.id AND ec.is_primary = true
        LIMIT 1
      ),
      
      'company_associations', (
        SELECT 
          json_agg(
            json_build_object(
              'id', ec.id,
              'company_id', ec.company_id,
              'company_name', c.name,
              'is_primary', ec.is_primary,
              'role_title', ec.role_title,
              'responsibilities', ec.responsibilities,
              'start_date', ec.start_date,
              'end_date', ec.end_date,
              'percentage', ec.percentage
            )
          )
        FROM employee_companies ec
        JOIN companies c ON ec.company_id = c.id
        WHERE ec.employee_id = e.id
      )
    )
  FROM 
    employees e
  LEFT JOIN 
    departments d ON e.department_id = d.id
  LEFT JOIN 
    designations des ON e.designation_id = des.id
  LEFT JOIN 
    branches b ON e.branch_id = b.id
  ORDER BY 
    e.first_name, e.last_name;
END;
$$;


ALTER FUNCTION public.get_comprehensive_employee_data() OWNER TO vikasalagarsamy;

--
-- Name: get_conversion_rates_by_source(date, date, integer[]); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_conversion_rates_by_source(start_date date DEFAULT NULL::date, end_date date DEFAULT NULL::date, source_ids integer[] DEFAULT '{}'::integer[]) RETURNS TABLE(source_id integer, source_name text, total_leads bigint, won_leads bigint, lost_leads bigint, conversion_rate numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        ls.id AS source_id,
        ls.name AS source_name,
        COUNT(l.id) AS total_leads,
        COUNT(CASE WHEN l.status = 'WON' THEN 1 END) AS won_leads,
        COUNT(CASE WHEN l.status = 'LOST' THEN 1 END) AS lost_leads,
        CASE 
            WHEN COUNT(l.id) > 0 THEN 
                ROUND((COUNT(CASE WHEN l.status = 'WON' THEN 1 END)::NUMERIC / COUNT(l.id)) * 100, 2)
            ELSE 0
        END AS conversion_rate
    FROM 
        lead_sources ls
    LEFT JOIN 
        leads l ON ls.id = l.lead_source_id
    WHERE 
        (start_date IS NULL OR l.created_at >= start_date) AND
        (end_date IS NULL OR l.created_at <= end_date) AND
        (array_length(source_ids, 1) IS NULL OR ls.id = ANY(source_ids))
    GROUP BY 
        ls.id, ls.name
    ORDER BY 
        ls.name;
END;
$$;


ALTER FUNCTION public.get_conversion_rates_by_source(start_date date, end_date date, source_ids integer[]) OWNER TO vikasalagarsamy;

--
-- Name: get_employee_by_id(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_employee_by_id(employee_id integer) RETURNS json
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  employee_record json;
BEGIN
  SELECT row_to_json(e)
  INTO employee_record
  FROM employees e
  WHERE e.id = employee_id;
  
  RETURN employee_record;
END;
$$;


ALTER FUNCTION public.get_employee_by_id(employee_id integer) OWNER TO vikasalagarsamy;

--
-- Name: get_employee_department_counts(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_employee_department_counts() RETURNS TABLE(department_name text, employee_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Return counts for employees with departments
  RETURN QUERY
  SELECT 
    d.name AS department_name,
    COUNT(e.id)::BIGINT AS employee_count
  FROM 
    departments d
  LEFT JOIN 
    employees e ON e.department_id = d.id
  GROUP BY 
    d.name
  
  UNION ALL
  
  -- Return count for employees with no department
  SELECT 
    'No Department' AS department_name,
    COUNT(e.id)::BIGINT AS employee_count
  FROM 
    employees e
  WHERE 
    e.department_id IS NULL;
END;
$$;


ALTER FUNCTION public.get_employee_department_counts() OWNER TO vikasalagarsamy;

--
-- Name: get_event_by_id(text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_event_by_id(p_event_id text) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    result JSONB;
BEGIN
    SELECT jsonb_build_object(
        'id', id,
        'event_id', event_id,
        'name', name,
        'is_active', is_active,
        'created_at', created_at,
        'updated_at', updated_at
    )
    INTO result
    FROM public.events
    WHERE event_id = p_event_id;
    
    IF result IS NULL THEN
        RAISE EXCEPTION 'Event with ID % not found', p_event_id;
    END IF;
    
    RETURN result;
END;
$$;


ALTER FUNCTION public.get_event_by_id(p_event_id text) OWNER TO vikasalagarsamy;

--
-- Name: get_events(boolean, text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_events(p_is_active boolean DEFAULT NULL::boolean, p_search text DEFAULT NULL::text) RETURNS SETOF jsonb
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT jsonb_build_object(
        'id', e.id,
        'event_id', e.event_id,
        'name', e.name,
        'is_active', e.is_active,
        'created_at', e.created_at,
        'updated_at', e.updated_at
    )
    FROM public.events e
    WHERE (p_is_active IS NULL OR e.is_active = p_is_active)
    AND (p_search IS NULL OR 
         e.name ILIKE '%' || p_search || '%' OR 
         e.event_id ILIKE '%' || p_search || '%')
    ORDER BY e.created_at DESC;
END;
$$;


ALTER FUNCTION public.get_events(p_is_active boolean, p_search text) OWNER TO vikasalagarsamy;

--
-- Name: get_lead_trends_by_date(date, date, integer[], integer[], text[]); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_lead_trends_by_date(start_date date DEFAULT NULL::date, end_date date DEFAULT NULL::date, source_ids integer[] DEFAULT '{}'::integer[], employee_ids integer[] DEFAULT '{}'::integer[], status_list text[] DEFAULT '{}'::text[]) RETURNS TABLE(date_group date, total_leads bigint, new_leads bigint, contacted_leads bigint, qualified_leads bigint, proposal_leads bigint, won_leads bigint, lost_leads bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    WITH date_series AS (
        SELECT 
            generate_series(
                COALESCE(start_date, CURRENT_DATE - INTERVAL '30 days')::DATE,
                COALESCE(end_date, CURRENT_DATE)::DATE,
                '1 day'::INTERVAL
            )::DATE AS date_group
    ),
    filtered_leads AS (
        SELECT 
            DATE(created_at) AS lead_date,
            status
        FROM 
            leads
        WHERE 
            (start_date IS NULL OR created_at >= start_date) AND
            (end_date IS NULL OR created_at <= end_date) AND
            (array_length(source_ids, 1) IS NULL OR lead_source_id = ANY(source_ids)) AND
            (array_length(employee_ids, 1) IS NULL OR assigned_to = ANY(employee_ids)) AND
            (array_length(status_list, 1) IS NULL OR status = ANY(status_list))
    )
    SELECT 
        ds.date_group,
        COUNT(fl.lead_date) AS total_leads,
        COUNT(CASE WHEN fl.status = 'NEW' THEN 1 END) AS new_leads,
        COUNT(CASE WHEN fl.status = 'CONTACTED' THEN 1 END) AS contacted_leads,
        COUNT(CASE WHEN fl.status = 'QUALIFIED' THEN 1 END) AS qualified_leads,
        COUNT(CASE WHEN fl.status = 'PROPOSAL' THEN 1 END) AS proposal_leads,
        COUNT(CASE WHEN fl.status = 'WON' THEN 1 END) AS won_leads,
        COUNT(CASE WHEN fl.status = 'LOST' THEN 1 END) AS lost_leads
    FROM 
        date_series ds
    LEFT JOIN 
        filtered_leads fl ON ds.date_group = fl.lead_date
    GROUP BY 
        ds.date_group
    ORDER BY 
        ds.date_group;
END;
$$;


ALTER FUNCTION public.get_lead_trends_by_date(start_date date, end_date date, source_ids integer[], employee_ids integer[], status_list text[]) OWNER TO vikasalagarsamy;

--
-- Name: get_lowercase_anomalies(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_lowercase_anomalies() RETURNS TABLE(id integer, branch_name text, company_name text, anomaly_type text, field_value text, uppercase_value text, anomaly_type_count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  WITH field_checks AS (
    SELECT 'branches' AS table_name, 'name' AS field_name, 'Branch name' AS field_description UNION ALL
    SELECT 'branches', 'company_name', 'Company name' UNION ALL
    SELECT 'branches', 'code', 'Branch code' UNION ALL
    SELECT 'branches', 'manager', 'Manager name' UNION ALL
    SELECT 'branches', 'status', 'Status' UNION ALL
    SELECT 'branches', 'address', 'Address'
  ),
  lowercase_anomalies AS (
    SELECT
      b.id,
      b.name AS branch_name,
      b.company_name,
      fc.field_description || ' contains lowercase' AS anomaly_type,
      CASE
        WHEN fc.field_name = 'name' THEN b.name
        WHEN fc.field_name = 'company_name' THEN b.company_name
        WHEN fc.field_name = 'code' THEN b.code
        WHEN fc.field_name = 'manager' THEN b.manager
        WHEN fc.field_name = 'status' THEN b.status
        WHEN fc.field_name = 'address' THEN b.address
      END AS field_value,
      CASE
        WHEN fc.field_name = 'name' THEN UPPER(b.name)
        WHEN fc.field_name = 'company_name' THEN UPPER(b.company_name)
        WHEN fc.field_name = 'code' THEN UPPER(b.code)
        WHEN fc.field_name = 'manager' THEN UPPER(b.manager)
        WHEN fc.field_name = 'status' THEN UPPER(b.status)
        WHEN fc.field_name = 'address' THEN UPPER(b.address)
      END AS uppercase_value
    FROM
      branches b
    CROSS JOIN
      field_checks fc
    WHERE
      fc.table_name = 'branches'
      AND CASE
        WHEN fc.field_name = 'name' THEN b.name IS NOT NULL AND b.name <> UPPER(b.name)
        WHEN fc.field_name = 'company_name' THEN b.company_name IS NOT NULL AND b.company_name <> UPPER(b.company_name)
        WHEN fc.field_name = 'code' THEN b.code IS NOT NULL AND b.code <> UPPER(b.code)
        WHEN fc.field_name = 'manager' THEN b.manager IS NOT NULL AND b.manager <> UPPER(b.manager)
        WHEN fc.field_name = 'status' THEN b.status IS NOT NULL AND b.status <> UPPER(b.status)
        WHEN fc.field_name = 'address' THEN b.address IS NOT NULL AND b.address <> UPPER(b.address)
        ELSE FALSE
      END
  )
  SELECT
    id,
    branch_name,
    company_name,
    anomaly_type,
    field_value,
    uppercase_value,
    COUNT(*) OVER (PARTITION BY anomaly_type) AS anomaly_type_count
  FROM
    lowercase_anomalies
  ORDER BY
    anomaly_type_count DESC,
    anomaly_type,
    company_name,
    branch_name;
END;
$$;


ALTER FUNCTION public.get_lowercase_anomalies() OWNER TO vikasalagarsamy;

--
-- Name: get_rejected_leads_with_details(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_rejected_leads_with_details() RETURNS TABLE(id integer, lead_number text, client_name text, status text, company_name text, branch_name text, rejection_details text, rejection_timestamp timestamp with time zone, rejection_user text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        v.id,
        v.lead_number,
        v.client_name,
        v.status,
        v.company_name,
        v.branch_name,
        v.rejection_details,
        v.rejection_timestamp,
        v.rejection_user
    FROM rejected_leads_view v
    ORDER BY v.rejection_timestamp DESC;
END;
$$;


ALTER FUNCTION public.get_rejected_leads_with_details() OWNER TO vikasalagarsamy;

--
-- Name: get_sales_employees_for_lead(integer, character varying); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_sales_employees_for_lead(lead_company_id integer, lead_location character varying) RETURNS TABLE(id integer, employee_id character varying, first_name character varying, last_name character varying, status character varying, company_id integer, branch_id integer, department_id integer, role character varying, job_title character varying, department character varying, location character varying, match_score integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Return employees who match the company directly OR through the junction table
  RETURN QUERY
  WITH unique_employees AS (
    SELECT DISTINCT ON (e.id) 
      e.id,
      e.employee_id,
      e.first_name,
      e.last_name,
      e.status,
      e.company_id,
      e.branch_id,
      e.department_id,
      e.role,
      e.job_title,
      e.department,
      e.location,
      -- Calculate match score for sorting (lower is better)
      CASE 
        -- Exact location match (highest priority)
        WHEN LOWER(e.location) = LOWER(lead_location) THEN 1
        -- Branch location matches lead location
        WHEN LOWER(b.location) = LOWER(lead_location) THEN 2
        -- Location contains the lead location as substring
        WHEN LOWER(e.location) LIKE '%' || LOWER(lead_location) || '%' THEN 3
        -- Branch location contains lead location as substring
        WHEN LOWER(b.location) LIKE '%' || LOWER(lead_location) || '%' THEN 4
        -- No location match
        ELSE 5
      END AS match_score
    FROM employees e
    LEFT JOIN employee_companies ec ON e.id = ec.employee_id
    LEFT JOIN branches b ON e.branch_id = b.id
    WHERE 
      e.status = 'active'
      AND (
        -- Match by direct company_id
        e.company_id = lead_company_id
        OR
        -- Match by junction table
        (ec.company_id = lead_company_id AND ec.percentage > 0)
      )
      AND (
        -- Match sales-related roles
        e.job_title ILIKE '%sales%'
        OR e.role ILIKE '%sales%'
        OR e.department ILIKE '%sales%'
        OR e.job_title ILIKE '%account manager%'
        OR e.role ILIKE '%account manager%'
        OR e.job_title ILIKE '%business development%'
        OR e.role ILIKE '%business development%'
      )
      -- Exclude executive roles
      AND NOT (
        e.role ILIKE '%ceo%'
        OR e.role ILIKE '%cto%'
        OR e.role ILIKE '%cfo%'
        OR e.role ILIKE '%coo%'
        OR e.role ILIKE '%president%'
        OR e.role ILIKE '%vice president%'
        OR e.role ILIKE '%vp%'
        OR e.role ILIKE '%chief%'
        OR e.role ILIKE '%director%'
        OR e.role ILIKE '%head of%'
        OR e.role ILIKE '%founder%'
        OR e.role ILIKE '%owner%'
        OR e.job_title ILIKE '%ceo%'
        OR e.job_title ILIKE '%cto%'
        OR e.job_title ILIKE '%cfo%'
        OR e.job_title ILIKE '%coo%'
        OR e.job_title ILIKE '%president%'
        OR e.job_title ILIKE '%vice president%'
        OR e.job_title ILIKE '%vp%'
        OR e.job_title ILIKE '%chief%'
        OR e.job_title ILIKE '%director%'
        OR e.job_title ILIKE '%head of%'
        OR e.job_title ILIKE '%founder%'
        OR e.job_title ILIKE '%owner%'
      )
  )
  SELECT 
    ue.id,
    ue.employee_id,
    ue.first_name,
    ue.last_name,
    ue.status,
    ue.company_id,
    ue.branch_id,
    ue.department_id,
    ue.role,
    ue.job_title,
    ue.department,
    ue.location,
    ue.match_score
  FROM unique_employees ue
  ORDER BY ue.match_score, ue.first_name;
END;
$$;


ALTER FUNCTION public.get_sales_employees_for_lead(lead_company_id integer, lead_location character varying) OWNER TO vikasalagarsamy;

--
-- Name: get_table_columns(text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_table_columns(table_name text) RETURNS text[]
    LANGUAGE plpgsql SECURITY DEFINER
    AS $_$
DECLARE
  columns text[];
BEGIN
  SELECT array_agg(column_name::text)
  INTO columns
  FROM information_schema.columns
  WHERE table_schema = 'public'
    AND table_name = $1;
  
  RETURN columns;
END;
$_$;


ALTER FUNCTION public.get_table_columns(table_name text) OWNER TO vikasalagarsamy;

--
-- Name: get_team_performance_metrics(date, date, integer[]); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_team_performance_metrics(start_date date DEFAULT NULL::date, end_date date DEFAULT NULL::date, employee_ids integer[] DEFAULT '{}'::integer[]) RETURNS TABLE(employee_id integer, employee_name text, total_leads bigint, won_leads bigint, lost_leads bigint, conversion_rate numeric, avg_days_to_close numeric)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id AS employee_id,
        e.first_name || ' ' || e.last_name AS employee_name,
        COUNT(l.id) AS total_leads,
        COUNT(CASE WHEN l.status = 'WON' THEN 1 END) AS won_leads,
        COUNT(CASE WHEN l.status = 'LOST' THEN 1 END) AS lost_leads,
        CASE 
            WHEN COUNT(l.id) > 0 THEN 
                ROUND((COUNT(CASE WHEN l.status = 'WON' THEN 1 END)::NUMERIC / COUNT(l.id)) * 100, 2)
            ELSE 0
        END AS conversion_rate,
        ROUND(AVG(
            CASE 
                WHEN l.status IN ('WON', 'LOST') THEN 
                    EXTRACT(EPOCH FROM (l.updated_at - l.created_at)) / 86400
                ELSE NULL
            END
        ), 1) AS avg_days_to_close
    FROM 
        employees e
    LEFT JOIN 
        leads l ON e.id = l.assigned_to
    WHERE 
        (start_date IS NULL OR l.created_at >= start_date) AND
        (end_date IS NULL OR l.created_at <= end_date) AND
        (array_length(employee_ids, 1) IS NULL OR e.id = ANY(employee_ids))
    GROUP BY 
        e.id, e.first_name, e.last_name
    ORDER BY 
        e.first_name, e.last_name;
END;
$$;


ALTER FUNCTION public.get_team_performance_metrics(start_date date, end_date date, employee_ids integer[]) OWNER TO vikasalagarsamy;

--
-- Name: get_user_menu_permissions(uuid); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_user_menu_permissions(p_user_id uuid) RETURNS TABLE(menu_item_id integer, menu_name character varying, menu_path character varying, parent_id integer, icon character varying, is_visible boolean, can_view boolean, can_add boolean, can_edit boolean, can_delete boolean)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    ump.menu_item_id,
    ump.menu_name,
    ump.menu_path,
    ump.parent_id,
    ump.icon,
    ump.is_visible,
    ump.can_view,
    ump.can_add,
    ump.can_edit,
    ump.can_delete
  FROM 
    user_menu_permissions ump
  WHERE 
    ump.user_id = p_user_id
  ORDER BY 
    ump.parent_id NULLS FIRST, 
    ump.menu_name;
END;
$$;


ALTER FUNCTION public.get_user_menu_permissions(p_user_id uuid) OWNER TO vikasalagarsamy;

--
-- Name: get_user_menu_unified(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_user_menu_unified(p_user_id integer) RETURNS TABLE(string_id character varying, name character varying, path character varying, icon character varying, description text, section_name character varying, sort_order integer, category character varying, badge_text character varying, can_view boolean, can_add boolean, can_edit boolean, can_delete boolean)
    LANGUAGE plpgsql
    AS $$
DECLARE
    v_role_id INTEGER;
    v_is_admin BOOLEAN;
BEGIN
    -- Get user's role
    SELECT role_id INTO v_role_id FROM user_accounts WHERE id = p_user_id;
    
    -- Check if admin (role_id = 1 or title = 'Administrator')
    SELECT (v_role_id = 1) INTO v_is_admin;
    
    IF v_is_admin THEN
        -- Admin sees everything
        RETURN QUERY
        SELECT 
            mi.string_id,
            mi.name,
            mi.path,
            mi.icon,
            mi.description,
            mi.section_name,
            mi.sort_order,
            mi.category,
            mi.badge_text,
            true::boolean as can_view,
            true::boolean as can_add,
            true::boolean as can_edit,
            true::boolean as can_delete
        FROM menu_items mi
        WHERE mi.is_visible = true
        ORDER BY mi.sort_order;
    ELSE
        -- Non-admin users see limited items based on role
        IF v_role_id = 2 THEN
            -- Sales Executive: limited access
            RETURN QUERY
            SELECT 
                mi.string_id,
                mi.name,
                mi.path,
                mi.icon,
                mi.description,
                mi.section_name,
                mi.sort_order,
                mi.category,
                mi.badge_text,
                true::boolean as can_view,
                CASE WHEN mi.string_id = 'sales-create-lead' THEN true ELSE false END::boolean as can_add,
                CASE WHEN mi.string_id = 'sales-my-leads' THEN true ELSE false END::boolean as can_edit,
                false::boolean as can_delete
            FROM menu_items mi
            WHERE mi.string_id IN ('dashboard', 'sales-dashboard', 'sales-create-lead', 'sales-my-leads', 'sales-follow-up', 'sales-quotations', 'sales-order-confirmation')
            ORDER BY mi.sort_order;
        ELSE
            -- Other roles get basic access
            RETURN QUERY
            SELECT 
                mi.string_id,
                mi.name,
                mi.path,
                mi.icon,
                mi.description,
                mi.section_name,
                mi.sort_order,
                mi.category,
                mi.badge_text,
                true::boolean as can_view,
                false::boolean as can_add,
                false::boolean as can_edit,
                false::boolean as can_delete
            FROM menu_items mi
            WHERE mi.string_id IN ('dashboard')
            ORDER BY mi.sort_order;
        END IF;
    END IF;
END;
$$;


ALTER FUNCTION public.get_user_menu_unified(p_user_id integer) OWNER TO vikasalagarsamy;

--
-- Name: get_users_by_role(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.get_users_by_role(p_role_id integer) RETURNS TABLE(id integer, username text, email text, name text, role_name text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  RETURN QUERY
  SELECT 
    ua.id,
    ua.username,
    ua.email,
    CONCAT(e.first_name, ' ', e.last_name) AS name,
    r.title AS role_name
  FROM 
    public.user_accounts ua
  JOIN 
    public.employees e ON ua.employee_id = e.id
  JOIN 
    public.roles r ON ua.role_id = r.id
  WHERE 
    ua.role_id = p_role_id
    AND ua.is_active = true;
END;
$$;


ALTER FUNCTION public.get_users_by_role(p_role_id integer) OWNER TO vikasalagarsamy;

--
-- Name: handle_lead_reallocation(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.handle_lead_reallocation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  affected_rows INTEGER;
  valid_statuses TEXT[] := ARRAY['inactive', 'terminated', 'on leave'];
  normalized_old_status TEXT;
  normalized_new_status TEXT;
BEGIN
  -- Normalize status values by trimming spaces, converting to lowercase
  normalized_old_status := LOWER(TRIM(OLD.status));
  normalized_new_status := LOWER(TRIM(NEW.status));
  
  -- Log all status changes for debugging
  RAISE NOTICE 'Employee ID: %, Name: % %, Old Status: %, New Status: %', 
    NEW.id, 
    NEW.first_name, 
    NEW.last_name, 
    normalized_old_status, 
    normalized_new_status;

  -- Check if this is a status change we should handle
  IF (TG_OP = 'UPDATE' AND 
      normalized_old_status = 'active' AND 
      normalized_new_status = ANY(valid_statuses)) THEN
    
    RAISE NOTICE 'Processing lead reassignment for employee % (% %)', 
      NEW.id, NEW.first_name, NEW.last_name;

    -- First, check if employee has any assigned leads
    WITH lead_count AS (
      SELECT COUNT(*) as total
      FROM leads
      WHERE assigned_to = NEW.id
      AND status NOT IN ('WON', 'LOST', 'REJECTED')
    )
    SELECT total INTO affected_rows FROM lead_count;

    RAISE NOTICE 'Found % leads to reassign', affected_rows;

    -- Only proceed if there are leads to reassign
    IF affected_rows > 0 THEN
      -- Update all assigned leads to UNASSIGNED status
      WITH updated_leads AS (
        UPDATE leads
        SET 
          status = 'UNASSIGNED',
          assigned_to = NULL,
          updated_at = CURRENT_TIMESTAMP,
          reassigned_by = NEW.id,
          is_reassigned = true,
          reassigned_at = CURRENT_TIMESTAMP,
          reassigned_from_company_id = (
            SELECT company_id 
            FROM employee_companies 
            WHERE employee_id = NEW.id 
            AND is_primary = true
            LIMIT 1
          ),
          reassigned_from_branch_id = (
            SELECT branch_id 
            FROM employee_companies 
            WHERE employee_id = NEW.id 
            AND is_primary = true
            LIMIT 1
          )
        WHERE 
          assigned_to = NEW.id
          AND status NOT IN ('WON', 'LOST', 'REJECTED')
        RETURNING id, lead_number
      )
      SELECT COUNT(*) INTO affected_rows FROM updated_leads;

      RAISE NOTICE 'Successfully reassigned % leads', affected_rows;

      -- Log the reallocation in activity_log if it exists
      IF EXISTS (
        SELECT 1 
        FROM information_schema.tables 
        WHERE table_name = 'activity_log'
      ) THEN
        INSERT INTO activity_log (
          activity_type,
          entity_type,
          entity_id,
          description,
          created_at
        )
        SELECT 
          'lead_reallocation',
          'lead',
          id::text,
          format(
            'Lead %s automatically unassigned due to employee %s %s status change to %s',
            lead_number,
            NEW.first_name,
            NEW.last_name,
            NEW.status
          ),
          CURRENT_TIMESTAMP
        FROM leads
        WHERE assigned_to = NEW.id
        AND status NOT IN ('WON', 'LOST', 'REJECTED');

        RAISE NOTICE 'Activity log entries created';
      END IF;
    END IF;
  ELSE
    RAISE NOTICE 'Status change does not require lead reassignment (Old: %, New: %)',
      normalized_old_status, normalized_new_status;
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.handle_lead_reallocation() OWNER TO vikasalagarsamy;

--
-- Name: log_employee_changes(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.log_employee_changes() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Check if audit triggers should be skipped
  IF should_skip_audit_trigger() THEN
    RETURN NULL;
  END IF;

  -- Continue with normal audit logging
  IF TG_OP = 'INSERT' THEN
    INSERT INTO audit_security.audit_trail (
      entity_type, 
      entity_id, 
      action, 
      new_values, 
      old_values, 
      user_id, 
      timestamp
    ) VALUES (
      'employees',
      NEW.id::text,
      'INSERT',
      row_to_json(NEW),
      NULL,
      current_setting('app.current_user_id', true)::uuid,
      now()
    );
  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO audit_security.audit_trail (
      entity_type, 
      entity_id, 
      action, 
      new_values, 
      old_values, 
      user_id, 
      timestamp
    ) VALUES (
      'employees',
      NEW.id::text,
      'UPDATE',
      row_to_json(NEW),
      row_to_json(OLD),
      current_setting('app.current_user_id', true)::uuid,
      now()
    );
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO audit_security.audit_trail (
      entity_type, 
      entity_id, 
      action, 
      new_values, 
      old_values, 
      user_id, 
      timestamp
    ) VALUES (
      'employees',
      OLD.id::text,
      'DELETE',
      NULL,
      row_to_json(OLD),
      current_setting('app.current_user_id', true)::uuid,
      now()
    );
  END IF;
  RETURN NULL;
END;
$$;


ALTER FUNCTION public.log_employee_changes() OWNER TO vikasalagarsamy;

--
-- Name: log_performance_metric(text, numeric, text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.log_performance_metric(metric_name text, metric_value numeric, metric_unit text DEFAULT 'ms'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO system_logs (action, details) 
    VALUES ('performance_metric', 
            jsonb_build_object(
                'metric', metric_name,
                'value', metric_value,
                'unit', metric_unit
            ));
END;
$$;


ALTER FUNCTION public.log_performance_metric(metric_name text, metric_value numeric, metric_unit text) OWNER TO vikasalagarsamy;

--
-- Name: log_slow_queries(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.log_slow_queries() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF current_setting('statement_timeout')::integer > 1000 THEN
        INSERT INTO query_logs (query_text, execution_time)
        VALUES (current_query(), extract(epoch from now() - clock_timestamp()));
    END IF;
    RETURN NULL;
END;
$$;


ALTER FUNCTION public.log_slow_queries() OWNER TO vikasalagarsamy;

--
-- Name: log_task_status_change(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.log_task_status_change() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only log if status actually changed
  IF OLD.status IS DISTINCT FROM NEW.status THEN
    INSERT INTO task_status_history (
      task_id,
      from_status,
      to_status,
      changed_at,
      changed_by,
      notes,
      metadata
    ) VALUES (
      NEW.id,
      OLD.status,
      NEW.status,
      NOW(),
      COALESCE(NEW.metadata->>'last_updated_by', 'system'),
      NEW.metadata->>'completion_notes',
      jsonb_build_object(
        'task_number', NEW.task_number,
        'lead_id', NEW.lead_id,
        'estimated_hours', NEW.estimated_hours,
        'actual_hours', NEW.actual_hours,
        'due_date', NEW.due_date,
        'completed_at', NEW.completed_at
      )
    );
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.log_task_status_change() OWNER TO vikasalagarsamy;

--
-- Name: log_view_performance(text, integer, double precision); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.log_view_performance(p_view_name text, p_rows_returned integer, p_execution_time_ms double precision) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO query_performance_logs (view_name, rows_returned, execution_time_ms)
    VALUES (p_view_name, p_rows_returned, p_execution_time_ms);
END;
$$;


ALTER FUNCTION public.log_view_performance(p_view_name text, p_rows_returned integer, p_execution_time_ms double precision) OWNER TO vikasalagarsamy;

--
-- Name: normalize_location(text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.normalize_location(loc text) RETURNS text
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Convert to lowercase, trim whitespace, and capitalize first letter of each word
  RETURN INITCAP(TRIM(LOWER(loc)));
END;
$$;


ALTER FUNCTION public.normalize_location(loc text) OWNER TO vikasalagarsamy;

--
-- Name: normalize_location_trigger(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.normalize_location_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    IF NEW.location IS NOT NULL THEN
      NEW.location = normalize_location(NEW.location);
    END IF;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.normalize_location_trigger() OWNER TO vikasalagarsamy;

--
-- Name: notify_admins_of_lead_reassignment(integer, text, text, integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.notify_admins_of_lead_reassignment(employee_id integer, employee_name text, new_status text, affected_leads_count integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Insert notifications for all administrators and sales heads
    INSERT INTO notifications (
        user_id,
        message,
        type,
        is_read,
        created_at
    )
    SELECT 
        ua.id,
        affected_leads_count || ' leads automatically reassigned from ' || employee_name || 
        ' due to status change to ' || new_status,
        'lead_reassignment',
        FALSE,
        NOW()
    FROM user_accounts ua
    JOIN roles r ON ua.role_id = r.id
    WHERE r.title IN ('Administrator', 'Sales Head');
END;
$$;


ALTER FUNCTION public.notify_admins_of_lead_reassignment(employee_id integer, employee_name text, new_status text, affected_leads_count integer) OWNER TO vikasalagarsamy;

--
-- Name: prevent_duplicate_lead_tasks(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.prevent_duplicate_lead_tasks() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Check if a similar task already exists for this lead and employee
  IF EXISTS (
    SELECT 1 FROM ai_tasks 
    WHERE lead_id = NEW.lead_id 
      AND assigned_to_employee_id = NEW.assigned_to_employee_id
      AND task_title = NEW.task_title
      AND status != 'completed'
      AND id != COALESCE(NEW.id, 0)
  ) THEN
    RAISE NOTICE 'Duplicate task prevented: % for lead % assigned to employee %', 
      NEW.task_title, NEW.lead_id, NEW.assigned_to_employee_id;
    RETURN NULL; -- Prevent the insert
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.prevent_duplicate_lead_tasks() OWNER TO vikasalagarsamy;

--
-- Name: refresh_task_dashboard(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.refresh_task_dashboard() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    REFRESH MATERIALIZED VIEW task_dashboard_summary;
END;
$$;


ALTER FUNCTION public.refresh_task_dashboard() OWNER TO vikasalagarsamy;

--
-- Name: refresh_user_roles_fast(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.refresh_user_roles_fast() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    REFRESH MATERIALIZED VIEW CONCURRENTLY mv_user_roles_fast;
END;
$$;


ALTER FUNCTION public.refresh_user_roles_fast() OWNER TO vikasalagarsamy;

--
-- Name: remove_employee(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.remove_employee(emp_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Use a transaction to ensure all operations succeed or fail together
    BEGIN
        -- First delete from employee_companies to avoid foreign key constraints
        DELETE FROM employee_companies WHERE employee_id = emp_id;
        
        -- Delete any leads assigned to this employee
        UPDATE leads SET assigned_to = NULL WHERE assigned_to = emp_id;
        
        -- Delete any activities related to this employee
        DELETE FROM activities WHERE employee_id = emp_id;
        
        -- Finally delete the employee record
        DELETE FROM employees WHERE id = emp_id;
        
        -- If we get here, all operations succeeded
    EXCEPTION WHEN OTHERS THEN
        -- Log the error and re-raise it
        RAISE EXCEPTION 'Failed to remove employee: %', SQLERRM;
    END;
END;
$$;


ALTER FUNCTION public.remove_employee(emp_id integer) OWNER TO vikasalagarsamy;

--
-- Name: remove_employee_v2(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.remove_employee_v2(emp_id integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    trigger_setting TEXT;
BEGIN
    -- Save current trigger setting
    SELECT current_setting('session_replication_role') INTO trigger_setting;
    
    -- Disable triggers temporarily
    SET session_replication_role = 'replica';
    
    BEGIN
        -- Delete employee company associations first
        DELETE FROM employee_companies WHERE employee_id = emp_id;
        
        -- Then delete the employee
        DELETE FROM employees WHERE id = emp_id;
        
        -- Restore original trigger setting
        EXECUTE 'SET session_replication_role = ' || quote_literal(trigger_setting);
    EXCEPTION
        WHEN OTHERS THEN
            -- Ensure triggers are re-enabled even if an error occurs
            EXECUTE 'SET session_replication_role = ' || quote_literal(trigger_setting);
            RAISE;
    END;
END;
$$;


ALTER FUNCTION public.remove_employee_v2(emp_id integer) OWNER TO vikasalagarsamy;

--
-- Name: remove_employee_v3(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.remove_employee_v3(emp_id integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    company_count INTEGER;
BEGIN
    -- Use a transaction to ensure atomicity
    BEGIN
        -- Check if the employee has any company associations
        SELECT COUNT(*) INTO company_count FROM employee_companies WHERE employee_id = emp_id;
        
        -- If the employee has company associations, delete them first
        IF company_count > 0 THEN
            -- Disable triggers temporarily to bypass validation
            SET LOCAL session_replication_role = 'replica';
            
            -- Delete employee company associations
            DELETE FROM employee_companies WHERE employee_id = emp_id;
            
            -- Re-enable triggers
            SET LOCAL session_replication_role = 'origin';
        END IF;
        
        -- Then delete the employee
        DELETE FROM employees WHERE id = emp_id;
    EXCEPTION
        WHEN OTHERS THEN
            -- Re-enable triggers if an exception occurs
            SET LOCAL session_replication_role = 'origin';
            -- Re-raise the exception
            RAISE;
    END;
END;
$$;


ALTER FUNCTION public.remove_employee_v3(emp_id integer) OWNER TO vikasalagarsamy;

--
-- Name: remove_employee_v4(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.remove_employee_v4(emp_id integer) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Use a direct approach to delete records
    -- First, directly delete from employee_companies using a subquery approach
    DELETE FROM employee_companies 
    WHERE employee_id = emp_id;
    
    -- Then delete the employee record
    DELETE FROM employees 
    WHERE id = emp_id;
END;
$$;


ALTER FUNCTION public.remove_employee_v4(emp_id integer) OWNER TO vikasalagarsamy;

--
-- Name: remove_employee_v5(integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.remove_employee_v5(emp_id integer) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Delete employee company associations first
    DELETE FROM employee_companies WHERE employee_id = emp_id;
    
    -- Delete the employee
    DELETE FROM employees WHERE id = emp_id;
END;
$$;


ALTER FUNCTION public.remove_employee_v5(emp_id integer) OWNER TO vikasalagarsamy;

--
-- Name: run_maintenance(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.run_maintenance() RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
    result TEXT := '';
    archived_count INTEGER;
BEGIN
    -- Archive old notifications
    SELECT archive_old_notifications() INTO archived_count;
    result := result || format('Archived %s old notifications. ', archived_count);
    
    -- Update table statistics
    ANALYZE notifications;
    ANALYZE quotations;
    ANALYZE sales_performance_metrics;
    result := result || 'Updated table statistics. ';
    
    -- Clean up old system logs (keep last 30 days)
    DELETE FROM system_logs WHERE created_at < NOW() - INTERVAL '30 days';
    result := result || 'Cleaned up old system logs. ';
    
    -- Log maintenance completion
    INSERT INTO system_logs (action, details) 
    VALUES ('maintenance_completed', jsonb_build_object('summary', result));
    
    RETURN result;
END;
$$;


ALTER FUNCTION public.run_maintenance() OWNER TO vikasalagarsamy;

--
-- Name: set_lead_source_id(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.set_lead_source_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only run if lead_source has a value but lead_source_id is null
  IF NEW.lead_source IS NOT NULL AND NEW.lead_source_id IS NULL THEN
    -- Look up the lead_source_id from the lead_sources table
    SELECT id INTO NEW.lead_source_id 
    FROM lead_sources 
    WHERE LOWER(name) = LOWER(NEW.lead_source);
    
    -- Log if we couldn't find a matching source
    IF NEW.lead_source_id IS NULL THEN
      RAISE NOTICE 'No matching lead source found for: %', NEW.lead_source;
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_lead_source_id() OWNER TO vikasalagarsamy;

--
-- Name: set_session_variable(text, text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.set_session_variable(var_name text, var_value text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  EXECUTE format('SET LOCAL %I.%s = %L', 
                split_part(var_name, '.', 1), 
                split_part(var_name, '.', 2), 
                var_value);
END;
$$;


ALTER FUNCTION public.set_session_variable(var_name text, var_value text) OWNER TO vikasalagarsamy;

--
-- Name: setup_hr_activities_function(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.setup_hr_activities_function() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- The function is created above, so we don't need to do anything else here
END;
$$;


ALTER FUNCTION public.setup_hr_activities_function() OWNER TO vikasalagarsamy;

--
-- Name: should_batch_notification(integer, character varying, character varying, integer); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.should_batch_notification(p_user_id integer, p_type character varying, p_batch_key character varying, p_batch_window_minutes integer DEFAULT 15) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
DECLARE
    last_batch_time TIMESTAMP WITH TIME ZONE;
BEGIN
    -- Check if similar notification was sent recently
    SELECT last_sent INTO last_batch_time
    FROM notification_batches
    WHERE user_id = p_user_id 
    AND notification_type = p_type 
    AND batch_key = p_batch_key;
    
    -- If no previous batch or batch window has passed, don't batch
    IF last_batch_time IS NULL OR 
       last_batch_time < NOW() - INTERVAL '1 minute' * p_batch_window_minutes THEN
        
        -- Update or insert batch record
        INSERT INTO notification_batches (user_id, notification_type, batch_key, last_sent, count)
        VALUES (p_user_id, p_type, p_batch_key, NOW(), 1)
        ON CONFLICT (user_id, notification_type, batch_key)
        DO UPDATE SET last_sent = NOW(), count = notification_batches.count + 1;
        
        RETURN FALSE; -- Don't batch, send notification
    END IF;
    
    -- Update batch count
    UPDATE notification_batches 
    SET count = count + 1
    WHERE user_id = p_user_id 
    AND notification_type = p_type 
    AND batch_key = p_batch_key;
    
    RETURN TRUE; -- Batch this notification
END;
$$;


ALTER FUNCTION public.should_batch_notification(p_user_id integer, p_type character varying, p_batch_key character varying, p_batch_window_minutes integer) OWNER TO vikasalagarsamy;

--
-- Name: should_skip_audit_trigger(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.should_skip_audit_trigger() RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
  -- Check if the app.disable_audit_logging session variable is set to 'true'
  RETURN COALESCE(current_setting('app.disable_audit_logging', true), 'false') = 'true';
END;
$$;


ALTER FUNCTION public.should_skip_audit_trigger() OWNER TO vikasalagarsamy;

--
-- Name: sync_employee_location(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.sync_employee_location() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- If branch_id is NULL, set location to 'Remote'
    IF NEW.branch_id IS NULL THEN
        NEW.location = 'Remote';
    ELSE
        -- Update employee location with branch location
        SELECT b.location INTO NEW.location
        FROM branches b
        WHERE b.id = NEW.branch_id;
        
        -- If no branch found or branch has no location, set to 'Unknown'
        IF NEW.location IS NULL THEN
            NEW.location = 'Unknown';
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.sync_employee_location() OWNER TO vikasalagarsamy;

--
-- Name: sync_employee_primary_company(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.sync_employee_primary_company() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- When a primary company is set, update the employee's company_id
  IF NEW.is_primary = true THEN
    UPDATE employees
    SET company_id = NEW.company_id
    WHERE id = NEW.employee_id;
  END IF;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.sync_employee_primary_company() OWNER TO vikasalagarsamy;

--
-- Name: sync_task_quotation_value(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.sync_task_quotation_value() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- When a quotation is created or updated, update related task values
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        UPDATE ai_tasks 
        SET estimated_value = NEW.total_amount
        WHERE quotation_id = NEW.id 
          AND (estimated_value IS NULL OR estimated_value != NEW.total_amount);
    END IF;
    
    RETURN COALESCE(NEW, OLD);
END;
$$;


ALTER FUNCTION public.sync_task_quotation_value() OWNER TO vikasalagarsamy;

--
-- Name: table_exists(text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.table_exists(table_name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
  exists_val boolean;
BEGIN
  SELECT EXISTS (
    SELECT 1 FROM information_schema.tables t
    WHERE t.table_schema = 'public'
    AND t.table_name = table_name
  ) INTO exists_val;
  
  RETURN exists_val;
END;
$$;


ALTER FUNCTION public.table_exists(table_name text) OWNER TO vikasalagarsamy;

--
-- Name: test_lead_reallocation(integer, text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.test_lead_reallocation(p_employee_id integer, p_new_status text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  v_old_status TEXT;
  v_lead_count INTEGER;
  v_result TEXT;
BEGIN
  -- Get current status
  SELECT status INTO v_old_status
  FROM employees
  WHERE id = p_employee_id;

  -- Get current lead count
  SELECT COUNT(*) INTO v_lead_count
  FROM leads
  WHERE assigned_to = p_employee_id
  AND status NOT IN ('WON', 'LOST', 'REJECTED');

  -- Update employee status
  UPDATE employees
  SET status = p_new_status,
      updated_at = CURRENT_TIMESTAMP
  WHERE id = p_employee_id;

  -- Get new lead count
  SELECT COUNT(*) INTO v_lead_count
  FROM leads
  WHERE assigned_to = p_employee_id
  AND status NOT IN ('WON', 'LOST', 'REJECTED');

  v_result := format(
    'Status changed from %s to %s. Remaining assigned leads: %s',
    v_old_status,
    p_new_status,
    v_lead_count
  );

  RETURN v_result;
END;
$$;


ALTER FUNCTION public.test_lead_reallocation(p_employee_id integer, p_new_status text) OWNER TO vikasalagarsamy;

--
-- Name: track_user_activity(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.track_user_activity() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update most active hours based on activity time
    UPDATE user_behavior_analytics 
    SET 
        most_active_hours = array_append(
            most_active_hours, 
            EXTRACT(HOUR FROM NEW.created_at)::INTEGER
        ),
        last_activity = NEW.created_at,
        updated_at = now()
    WHERE user_id = NEW.user_id;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.track_user_activity() OWNER TO vikasalagarsamy;

--
-- Name: update_business_rules_updated_at(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_business_rules_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_business_rules_updated_at() OWNER TO vikasalagarsamy;

--
-- Name: update_clients_updated_at(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_clients_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_clients_updated_at() OWNER TO vikasalagarsamy;

--
-- Name: update_conversation_session(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_conversation_session() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Update message count and session end time
  UPDATE conversation_sessions 
  SET 
    message_count = message_count + 1,
    session_end = NEW.timestamp,
    updated_at = NOW()
  WHERE quotation_id = NEW.quotation_id 
    AND client_phone = NEW.client_phone
    AND session_end IS NULL;
    
  -- Create new session if none exists
  IF NOT FOUND THEN
    INSERT INTO conversation_sessions (quotation_id, client_phone, session_start, message_count)
    VALUES (NEW.quotation_id, NEW.client_phone, NEW.timestamp, 1);
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_conversation_session() OWNER TO vikasalagarsamy;

--
-- Name: update_event_name(text, character varying); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_event_name(p_event_id text, p_name character varying) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    result JSONB;
BEGIN
    UPDATE public.events
    SET name = p_name
    WHERE event_id = p_event_id
    RETURNING jsonb_build_object(
        'id', id,
        'event_id', event_id,
        'name', name,
        'is_active', is_active,
        'created_at', created_at,
        'updated_at', updated_at
    ) INTO result;
    
    IF result IS NULL THEN
        RAISE EXCEPTION 'Event with ID % not found', p_event_id;
    END IF;
    
    RETURN result;
END;
$$;


ALTER FUNCTION public.update_event_name(p_event_id text, p_name character varying) OWNER TO vikasalagarsamy;

--
-- Name: update_event_status(text, boolean); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_event_status(p_event_id text, p_is_active boolean) RETURNS jsonb
    LANGUAGE plpgsql
    AS $$
DECLARE
    result JSONB;
BEGIN
    UPDATE public.events
    SET is_active = p_is_active
    WHERE event_id = p_event_id
    RETURNING jsonb_build_object(
        'id', id,
        'event_id', event_id,
        'name', name,
        'is_active', is_active,
        'created_at', created_at,
        'updated_at', updated_at
    ) INTO result;
    
    IF result IS NULL THEN
        RAISE EXCEPTION 'Event with ID % not found', p_event_id;
    END IF;
    
    RETURN result;
END;
$$;


ALTER FUNCTION public.update_event_status(p_event_id text, p_is_active boolean) OWNER TO vikasalagarsamy;

--
-- Name: update_instagram_daily_analytics(date); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_instagram_daily_analytics(target_date date DEFAULT CURRENT_DATE) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    INSERT INTO instagram_analytics (
        date, total_messages, total_comments, total_mentions, 
        total_story_mentions, new_leads_created
    )
    SELECT 
        target_date,
        (SELECT COUNT(*) FROM instagram_messages WHERE DATE(created_at) = target_date),
        (SELECT COUNT(*) FROM instagram_comments WHERE DATE(created_at) = target_date),
        (SELECT COUNT(*) FROM instagram_mentions WHERE DATE(created_at) = target_date),
        (SELECT COUNT(*) FROM instagram_story_mentions WHERE DATE(created_at) = target_date),
        (SELECT COUNT(*) FROM leads WHERE DATE(created_at) = target_date AND source = 'Instagram')
    ON CONFLICT (date) DO UPDATE SET
        total_messages = EXCLUDED.total_messages,
        total_comments = EXCLUDED.total_comments,
        total_mentions = EXCLUDED.total_mentions,
        total_story_mentions = EXCLUDED.total_story_mentions,
        new_leads_created = EXCLUDED.new_leads_created,
        updated_at = NOW();
END;
$$;


ALTER FUNCTION public.update_instagram_daily_analytics(target_date date) OWNER TO vikasalagarsamy;

--
-- Name: update_menu_item_permissions(integer, integer, boolean, boolean, boolean, boolean); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_menu_item_permissions(p_role_id integer, p_menu_item_id integer, p_can_view boolean, p_can_add boolean, p_can_edit boolean, p_can_delete boolean) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Check if the permission record exists
  IF EXISTS (
    SELECT 1 FROM role_menu_permissions 
    WHERE role_id = p_role_id AND menu_item_id = p_menu_item_id
  ) THEN
    -- Update existing permission
    UPDATE role_menu_permissions
    SET 
      can_view = p_can_view,
      can_add = p_can_add,
      can_edit = p_can_edit,
      can_delete = p_can_delete,
      updated_at = NOW()
    WHERE role_id = p_role_id AND menu_item_id = p_menu_item_id;
  ELSE
    -- Insert new permission
    INSERT INTO role_menu_permissions (
      role_id, menu_item_id, can_view, can_add, can_edit, can_delete, created_at, updated_at
    ) VALUES (
      p_role_id, p_menu_item_id, p_can_view, p_can_add, p_can_edit, p_can_delete, NOW(), NOW()
    );
  END IF;
  
  RETURN TRUE;
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'Error updating menu permissions: %', SQLERRM;
    RETURN FALSE;
END;
$$;


ALTER FUNCTION public.update_menu_item_permissions(p_role_id integer, p_menu_item_id integer, p_can_view boolean, p_can_add boolean, p_can_edit boolean, p_can_delete boolean) OWNER TO vikasalagarsamy;

--
-- Name: update_modified_column(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.updated_at = now(); 
   RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_modified_column() OWNER TO vikasalagarsamy;

--
-- Name: update_quotation_approval_timestamp(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_quotation_approval_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_quotation_approval_timestamp() OWNER TO vikasalagarsamy;

--
-- Name: update_quotation_edit_approvals_updated_at(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_quotation_edit_approvals_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_quotation_edit_approvals_updated_at() OWNER TO vikasalagarsamy;

--
-- Name: update_quotation_workflow_on_approval(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_quotation_workflow_on_approval() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- When approval is granted, update quotation workflow status
    IF NEW.approval_status = 'approved' AND (OLD.approval_status IS NULL OR OLD.approval_status != 'approved') THEN
        UPDATE quotations 
        SET workflow_status = 'approved',
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.quotation_id;
    END IF;
    
    -- When approval is rejected, update quotation workflow status
    IF NEW.approval_status = 'rejected' AND (OLD.approval_status IS NULL OR OLD.approval_status != 'rejected') THEN
        UPDATE quotations 
        SET workflow_status = 'rejected',
            updated_at = CURRENT_TIMESTAMP
        WHERE id = NEW.quotation_id;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_quotation_workflow_on_approval() OWNER TO vikasalagarsamy;

--
-- Name: update_quotation_workflow_status(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_quotation_workflow_status() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- When approval is granted, update quotation status to 'approved'
  IF NEW.approval_status = 'approved' AND OLD.approval_status != 'approved' THEN
    UPDATE quotations 
    SET workflow_status = 'approved'
    WHERE id = NEW.quotation_id;
  END IF;
  
  -- When approval is rejected, update quotation status to 'rejected'
  IF NEW.approval_status = 'rejected' AND OLD.approval_status != 'rejected' THEN
    UPDATE quotations 
    SET workflow_status = 'rejected'
    WHERE id = NEW.quotation_id;
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_quotation_workflow_status() OWNER TO vikasalagarsamy;

--
-- Name: update_quotations_modified_column(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_quotations_modified_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_quotations_modified_column() OWNER TO vikasalagarsamy;

--
-- Name: update_supplier_timestamp(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_supplier_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_supplier_timestamp() OWNER TO vikasalagarsamy;

--
-- Name: update_task_performance_metrics(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_task_performance_metrics() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- Only process when task is completed
  IF NEW.status = 'COMPLETED' AND OLD.status != 'COMPLETED' THEN
    INSERT INTO task_performance_metrics (
      task_id,
      lead_id,
      quotation_id,
      assigned_to,
      created_date,
      due_date,
      completed_date,
      days_to_complete,
      hours_estimated,
      hours_actual,
      efficiency_ratio,
      priority_level,
      was_overdue,
      quality_rating,
      revenue_impact
    ) VALUES (
      NEW.id,
      NEW.lead_id,
      NEW.quotation_id,
      NEW.assigned_to,
      NEW.created_at::DATE,
      NEW.due_date::DATE,
      NEW.completed_at::DATE,
      CASE 
        WHEN NEW.completed_at IS NOT NULL THEN 
          EXTRACT(DAY FROM NEW.completed_at - NEW.created_at)
        ELSE NULL 
      END,
      NEW.estimated_hours,
      NEW.actual_hours,
      CASE 
        WHEN NEW.estimated_hours > 0 AND NEW.actual_hours IS NOT NULL THEN 
          NEW.actual_hours / NEW.estimated_hours
        ELSE NULL 
      END,
      NEW.priority,
      CASE 
        WHEN NEW.due_date IS NOT NULL AND NEW.completed_at IS NOT NULL THEN 
          NEW.completed_at > NEW.due_date
        ELSE FALSE 
      END,
      (NEW.metadata->>'quality_rating')::INTEGER,
      (NEW.metadata->>'estimated_value')::DECIMAL
    )
    ON CONFLICT (task_id) DO UPDATE SET
      completed_date = EXCLUDED.completed_date,
      days_to_complete = EXCLUDED.days_to_complete,
      hours_actual = EXCLUDED.hours_actual,
      efficiency_ratio = EXCLUDED.efficiency_ratio,
      was_overdue = EXCLUDED.was_overdue,
      quality_rating = EXCLUDED.quality_rating,
      updated_at = NOW();
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_task_performance_metrics() OWNER TO vikasalagarsamy;

--
-- Name: update_timestamp(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_timestamp() OWNER TO vikasalagarsamy;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO vikasalagarsamy;

--
-- Name: update_user_engagement_score(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_user_engagement_score() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Update engagement score based on notification interaction
    UPDATE user_behavior_analytics 
    SET 
        engagement_score = LEAST(1.0, GREATEST(0.0, 
            CASE 
                WHEN NEW.event_type = 'clicked' THEN engagement_score + 0.1
                WHEN NEW.event_type = 'viewed' THEN engagement_score + 0.05
                WHEN NEW.event_type = 'dismissed' THEN engagement_score - 0.02
                ELSE engagement_score
            END
        )),
        updated_at = now()
    WHERE user_id = NEW.user_id;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_user_engagement_score() OWNER TO vikasalagarsamy;

--
-- Name: update_vendor_timestamp(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.update_vendor_timestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at = CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_vendor_timestamp() OWNER TO vikasalagarsamy;

--
-- Name: validate_ai_response(text); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.validate_ai_response(response_text text) RETURNS json
    LANGUAGE plpgsql
    AS $$
DECLARE
  validation_result JSON;
  hallucination_score INTEGER := 0;
  warnings TEXT[] := ARRAY[]::TEXT[];
BEGIN
  -- Check for potential fake dates (dates before current business start)
  IF response_text ~* '\d{4}-\d{2}-\d{2}' AND response_text ~* '(2020|2021|2022|2023)' THEN
    hallucination_score := hallucination_score + 1;
    warnings := array_append(warnings, 'Potential fake historical dates detected');
  END IF;
  
  -- Check for made-up quotation references
  IF response_text ~* 'quotation.*sent.*\d{4}-\d{2}-\d{2}' THEN
    hallucination_score := hallucination_score + 1;
    warnings := array_append(warnings, 'Potential fake quotation timeline detected');
  END IF;
  
  -- Return validation result
  SELECT json_build_object(
    'is_valid', hallucination_score = 0,
    'hallucination_score', hallucination_score,
    'warnings', warnings,
    'validation_timestamp', NOW()
  ) INTO validation_result;
  
  RETURN validation_result;
END;
$$;


ALTER FUNCTION public.validate_ai_response(response_text text) OWNER TO vikasalagarsamy;

--
-- Name: validate_department_designation(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.validate_department_designation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- If both department_id and designation_id are set
  IF NEW.department_id IS NOT NULL AND NEW.designation_id IS NOT NULL THEN
    -- Check if the designation belongs to the department
    IF NOT EXISTS (
      SELECT 1 FROM designations 
      WHERE id = NEW.designation_id 
      AND department_id = NEW.department_id
    ) THEN
      RAISE EXCEPTION 'The selected designation does not belong to the selected department';
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_department_designation() OWNER TO vikasalagarsamy;

--
-- Name: validate_employee_allocation(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.validate_employee_allocation() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  total_allocation INTEGER;
  active_allocations INTEGER;
BEGIN
  -- Check if dates are valid
  IF NEW.start_date IS NOT NULL AND NEW.end_date IS NOT NULL AND NEW.start_date > NEW.end_date THEN
    RAISE EXCEPTION 'End date cannot be before start date';
  END IF;
  
  -- Set status based on dates
  IF NEW.start_date IS NOT NULL AND NEW.start_date > CURRENT_DATE THEN
    NEW.status := 'pending';
  ELSIF NEW.end_date IS NOT NULL AND NEW.end_date < CURRENT_DATE THEN
    NEW.status := 'expired';
  ELSE
    NEW.status := 'active';
  END IF;
  
  -- Check for overlapping allocations with the same company AND branch
  -- Modified to check for specific company-branch combination instead of just company
  IF EXISTS (
    SELECT 1 FROM employee_companies ec
    WHERE ec.employee_id = NEW.employee_id
      AND ec.company_id = NEW.company_id
      AND ec.branch_id = NEW.branch_id
      AND ec.id != NEW.id
      AND (
        (NEW.start_date IS NULL) OR
        (ec.end_date IS NULL) OR
        (NEW.start_date <= ec.end_date AND (NEW.end_date IS NULL OR NEW.end_date >= ec.start_date))
      )
  ) THEN
    RAISE EXCEPTION 'Employee already has an allocation for this company and branch during this period';
  END IF;
  
  -- Calculate total allocation for active allocations
  SELECT COALESCE(SUM(allocation_percentage), 0)
  INTO total_allocation
  FROM employee_companies
  WHERE employee_id = NEW.employee_id
    AND id != NEW.id
    AND (status = 'active' OR status = 'pending');
  
  -- Check if total allocation exceeds 100%
  IF (total_allocation + NEW.allocation_percentage) > 100 AND (NEW.status = 'active' OR NEW.status = 'pending') THEN
    RAISE EXCEPTION 'Total allocation percentage cannot exceed 100%%. Current total: %%%, Adding: %%%', 
      total_allocation, NEW.allocation_percentage;
  END IF;
  
  RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_employee_allocation() OWNER TO vikasalagarsamy;

--
-- Name: validate_employee_company_percentage(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.validate_employee_company_percentage() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    total_percentage INTEGER;
BEGIN
    -- Calculate the total percentage for this employee
    SELECT COALESCE(SUM(percentage), 0) INTO total_percentage
    FROM employee_companies
    WHERE employee_id = NEW.employee_id AND (id != NEW.id OR NEW.id IS NULL);
    
    -- Add the new percentage
    total_percentage := total_percentage + NEW.percentage;
    
    -- Check if the total is exactly 100%
    IF total_percentage != 100 THEN
        RAISE EXCEPTION 'Total percentage allocation must be exactly 100%%. Current total: %', total_percentage;
    END IF;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validate_employee_company_percentage() OWNER TO vikasalagarsamy;

--
-- Name: validate_phone_number(); Type: FUNCTION; Schema: public; Owner: vikasalagarsamy
--

CREATE FUNCTION public.validate_phone_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$
BEGIN
  -- Basic validation: phone should be at least 10 characters and contain only digits, +, -, and spaces
  IF NEW.phone IS NOT NULL AND NEW.phone != '' AND 
     (LENGTH(NEW.phone) < 10 OR NEW.phone !~ '^[0-9+\-\s]+$') THEN
    RAISE EXCEPTION 'Invalid phone number format. Phone must be at least 10 characters and contain only digits, +, -, and spaces.';
  END IF;
  RETURN NEW;
END;
$_$;


ALTER FUNCTION public.validate_phone_number() OWNER TO vikasalagarsamy;

--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_;

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


ALTER FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) OWNER TO vikasalagarsamy;

--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


ALTER FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) OWNER TO vikasalagarsamy;

--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


ALTER FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) OWNER TO vikasalagarsamy;

--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
    declare
      res jsonb;
    begin
      execute format('select to_jsonb(%L::'|| type_::text || ')', val)  into res;
      return res;
    end
    $$;


ALTER FUNCTION realtime."cast"(val text, type_ regtype) OWNER TO vikasalagarsamy;

--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


ALTER FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) OWNER TO vikasalagarsamy;

--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


ALTER FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) OWNER TO vikasalagarsamy;

--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


ALTER FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) OWNER TO vikasalagarsamy;

--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


ALTER FUNCTION realtime.quote_wal2json(entity regclass) OWNER TO vikasalagarsamy;

--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  BEGIN
    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (payload, event, topic, private, extension)
    VALUES (payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      PERFORM pg_notify(
          'realtime:system',
          jsonb_build_object(
              'error', SQLERRM,
              'function', 'realtime.send',
              'event', event,
              'topic', topic,
              'private', private
          )::text
      );
  END;
END;
$$;


ALTER FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) OWNER TO vikasalagarsamy;

--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


ALTER FUNCTION realtime.subscription_check_filters() OWNER TO vikasalagarsamy;

--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


ALTER FUNCTION realtime.to_regrole(role_name text) OWNER TO vikasalagarsamy;

--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: vikasalagarsamy
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


ALTER FUNCTION realtime.topic() OWNER TO vikasalagarsamy;

--
-- Name: add_prefixes(text, text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.add_prefixes(_bucket_id text, _name text) RETURNS void
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
DECLARE
    prefixes text[];
BEGIN
    prefixes := "storage"."get_prefixes"("_name");

    IF array_length(prefixes, 1) > 0 THEN
        INSERT INTO storage.prefixes (name, bucket_id)
        SELECT UNNEST(prefixes) as name, "_bucket_id" ON CONFLICT DO NOTHING;
    END IF;
END;
$$;


ALTER FUNCTION storage.add_prefixes(_bucket_id text, _name text) OWNER TO vikasalagarsamy;

--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


ALTER FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) OWNER TO vikasalagarsamy;

--
-- Name: delete_prefix(text, text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.delete_prefix(_bucket_id text, _name text) RETURNS boolean
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    -- Check if we can delete the prefix
    IF EXISTS(
        SELECT FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name") + 1
          AND "prefixes"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    )
    OR EXISTS(
        SELECT FROM "storage"."objects"
        WHERE "objects"."bucket_id" = "_bucket_id"
          AND "storage"."get_level"("objects"."name") = "storage"."get_level"("_name") + 1
          AND "objects"."name" COLLATE "C" LIKE "_name" || '/%'
        LIMIT 1
    ) THEN
    -- There are sub-objects, skip deletion
    RETURN false;
    ELSE
        DELETE FROM "storage"."prefixes"
        WHERE "prefixes"."bucket_id" = "_bucket_id"
          AND level = "storage"."get_level"("_name")
          AND "prefixes"."name" = "_name";
        RETURN true;
    END IF;
END;
$$;


ALTER FUNCTION storage.delete_prefix(_bucket_id text, _name text) OWNER TO vikasalagarsamy;

--
-- Name: delete_prefix_hierarchy_trigger(); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.delete_prefix_hierarchy_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    prefix text;
BEGIN
    prefix := "storage"."get_prefix"(OLD."name");

    IF coalesce(prefix, '') != '' THEN
        PERFORM "storage"."delete_prefix"(OLD."bucket_id", prefix);
    END IF;

    RETURN OLD;
END;
$$;


ALTER FUNCTION storage.delete_prefix_hierarchy_trigger() OWNER TO vikasalagarsamy;

--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


ALTER FUNCTION storage.enforce_bucket_name_length() OWNER TO vikasalagarsamy;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO vikasalagarsamy;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO vikasalagarsamy;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO vikasalagarsamy;

--
-- Name: get_level(text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.get_level(name text) RETURNS integer
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
SELECT array_length(string_to_array("name", '/'), 1);
$$;


ALTER FUNCTION storage.get_level(name text) OWNER TO vikasalagarsamy;

--
-- Name: get_prefix(text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.get_prefix(name text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$
SELECT
    CASE WHEN strpos("name", '/') > 0 THEN
             regexp_replace("name", '[\/]{1}[^\/]+\/?$', '')
         ELSE
             ''
        END;
$_$;


ALTER FUNCTION storage.get_prefix(name text) OWNER TO vikasalagarsamy;

--
-- Name: get_prefixes(text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.get_prefixes(name text) RETURNS text[]
    LANGUAGE plpgsql IMMUTABLE STRICT
    AS $$
DECLARE
    parts text[];
    prefixes text[];
    prefix text;
BEGIN
    -- Split the name into parts by '/'
    parts := string_to_array("name", '/');
    prefixes := '{}';

    -- Construct the prefixes, stopping one level below the last part
    FOR i IN 1..array_length(parts, 1) - 1 LOOP
            prefix := array_to_string(parts[1:i], '/');
            prefixes := array_append(prefixes, prefix);
    END LOOP;

    RETURN prefixes;
END;
$$;


ALTER FUNCTION storage.get_prefixes(name text) OWNER TO vikasalagarsamy;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO vikasalagarsamy;

--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


ALTER FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text) OWNER TO vikasalagarsamy;

--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(name COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                        substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1)))
                    ELSE
                        name
                END AS name, id, metadata, updated_at
            FROM
                storage.objects
            WHERE
                bucket_id = $5 AND
                name ILIKE $1 || ''%'' AND
                CASE
                    WHEN $6 != '''' THEN
                    name COLLATE "C" > $6
                ELSE true END
                AND CASE
                    WHEN $4 != '''' THEN
                        CASE
                            WHEN position($2 IN substring(name from length($1) + 1)) > 0 THEN
                                substring(name from 1 for length($1) + position($2 IN substring(name from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                name COLLATE "C" > $4
                            END
                    ELSE
                        true
                END
            ORDER BY
                name COLLATE "C" ASC) as e order by name COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_token, bucket_id, start_after;
END;
$_$;


ALTER FUNCTION storage.list_objects_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text) OWNER TO vikasalagarsamy;

--
-- Name: objects_insert_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.objects_insert_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    NEW.level := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_insert_prefix_trigger() OWNER TO vikasalagarsamy;

--
-- Name: objects_update_prefix_trigger(); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.objects_update_prefix_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    old_prefixes TEXT[];
BEGIN
    -- Ensure this is an update operation and the name has changed
    IF TG_OP = 'UPDATE' AND (NEW."name" <> OLD."name" OR NEW."bucket_id" <> OLD."bucket_id") THEN
        -- Retrieve old prefixes
        old_prefixes := "storage"."get_prefixes"(OLD."name");

        -- Remove old prefixes that are only used by this object
        WITH all_prefixes as (
            SELECT unnest(old_prefixes) as prefix
        ),
        can_delete_prefixes as (
             SELECT prefix
             FROM all_prefixes
             WHERE NOT EXISTS (
                 SELECT 1 FROM "storage"."objects"
                 WHERE "bucket_id" = OLD."bucket_id"
                   AND "name" <> OLD."name"
                   AND "name" LIKE (prefix || '%')
             )
         )
        DELETE FROM "storage"."prefixes" WHERE name IN (SELECT prefix FROM can_delete_prefixes);

        -- Add new prefixes
        PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    END IF;
    -- Set the new level
    NEW."level" := "storage"."get_level"(NEW."name");

    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.objects_update_prefix_trigger() OWNER TO vikasalagarsamy;

--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


ALTER FUNCTION storage.operation() OWNER TO vikasalagarsamy;

--
-- Name: prefixes_insert_trigger(); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.prefixes_insert_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    PERFORM "storage"."add_prefixes"(NEW."bucket_id", NEW."name");
    RETURN NEW;
END;
$$;


ALTER FUNCTION storage.prefixes_insert_trigger() OWNER TO vikasalagarsamy;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(objects.path_tokens, 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO vikasalagarsamy;

--
-- Name: search_legacy_v1(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select path_tokens[$1] as folder
           from storage.objects
             where objects.name ilike $2 || $3 || ''%''
               and bucket_id = $4
               and array_length(objects.path_tokens, 1) <> $1
           group by folder
           order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(objects.path_tokens, 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_legacy_v1(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO vikasalagarsamy;

--
-- Name: search_v1_optimised(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
    v_order_by text;
    v_sort_order text;
begin
    case
        when sortcolumn = 'name' then
            v_order_by = 'name';
        when sortcolumn = 'updated_at' then
            v_order_by = 'updated_at';
        when sortcolumn = 'created_at' then
            v_order_by = 'created_at';
        when sortcolumn = 'last_accessed_at' then
            v_order_by = 'last_accessed_at';
        else
            v_order_by = 'name';
        end case;

    case
        when sortorder = 'asc' then
            v_sort_order = 'asc';
        when sortorder = 'desc' then
            v_sort_order = 'desc';
        else
            v_sort_order = 'asc';
        end case;

    v_order_by = v_order_by || ' ' || v_sort_order;

    return query execute
        'with folders as (
           select (string_to_array(name, ''/''))[level] as name
           from storage.prefixes
             where lower(prefixes.name) like lower($2 || $3) || ''%''
               and bucket_id = $4
               and level = $1
           order by name ' || v_sort_order || '
     )
     (select name,
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[level] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where lower(objects.name) like lower($2 || $3) || ''%''
       and bucket_id = $4
       and level = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search_v1_optimised(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO vikasalagarsamy;

--
-- Name: search_v2(text, text, integer, integer, text); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
BEGIN
    RETURN query EXECUTE
        $sql$
        SELECT * FROM (
            (
                SELECT
                    split_part(name, '/', $4) AS key,
                    name || '/' AS name,
                    NULL::uuid AS id,
                    NULL::timestamptz AS updated_at,
                    NULL::timestamptz AS created_at,
                    NULL::jsonb AS metadata
                FROM storage.prefixes
                WHERE name COLLATE "C" LIKE $1 || '%'
                AND bucket_id = $2
                AND level = $4
                AND name COLLATE "C" > $5
                ORDER BY prefixes.name COLLATE "C" LIMIT $3
            )
            UNION ALL
            (SELECT split_part(name, '/', $4) AS key,
                name,
                id,
                updated_at,
                created_at,
                metadata
            FROM storage.objects
            WHERE name COLLATE "C" LIKE $1 || '%'
                AND bucket_id = $2
                AND level = $4
                AND name COLLATE "C" > $5
            ORDER BY name COLLATE "C" LIMIT $3)
        ) obj
        ORDER BY name COLLATE "C" LIMIT $3;
        $sql$
        USING prefix, bucket_name, limits, levels, start_after;
END;
$_$;


ALTER FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text) OWNER TO vikasalagarsamy;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: vikasalagarsamy
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO vikasalagarsamy;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: vikasalagarsamy
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
  DECLARE
    request_id bigint;
    payload jsonb;
    url text := TG_ARGV[0]::text;
    method text := TG_ARGV[1]::text;
    headers jsonb DEFAULT '{}'::jsonb;
    params jsonb DEFAULT '{}'::jsonb;
    timeout_ms integer DEFAULT 1000;
  BEGIN
    IF url IS NULL OR url = 'null' THEN
      RAISE EXCEPTION 'url argument is missing';
    END IF;

    IF method IS NULL OR method = 'null' THEN
      RAISE EXCEPTION 'method argument is missing';
    END IF;

    IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
      headers = '{"Content-Type": "application/json"}'::jsonb;
    ELSE
      headers = TG_ARGV[2]::jsonb;
    END IF;

    IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
      params = '{}'::jsonb;
    ELSE
      params = TG_ARGV[3]::jsonb;
    END IF;

    IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
      timeout_ms = 1000;
    ELSE
      timeout_ms = TG_ARGV[4]::integer;
    END IF;

    CASE
      WHEN method = 'GET' THEN
        SELECT http_get INTO request_id FROM net.http_get(
          url,
          params,
          headers,
          timeout_ms
        );
      WHEN method = 'POST' THEN
        payload = jsonb_build_object(
          'old_record', OLD,
          'record', NEW,
          'type', TG_OP,
          'table', TG_TABLE_NAME,
          'schema', TG_TABLE_SCHEMA
        );

        SELECT http_post INTO request_id FROM net.http_post(
          url,
          payload,
          params,
          headers,
          timeout_ms
        );
      ELSE
        RAISE EXCEPTION 'method argument % is invalid', method;
    END CASE;

    INSERT INTO supabase_functions.hooks
      (hook_table_id, hook_name, request_id)
    VALUES
      (TG_RELID, TG_NAME, request_id);

    RETURN NEW;
  END
$$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO vikasalagarsamy;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: vikasalagarsamy
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type text,
    settings jsonb,
    tenant_external_id text,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE _realtime.extensions OWNER TO vikasalagarsamy;

--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: vikasalagarsamy
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE _realtime.schema_migrations OWNER TO vikasalagarsamy;

--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: vikasalagarsamy
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name text,
    external_id text,
    jwt_secret text,
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default text DEFAULT 'postgres_cdc_rls'::text,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL,
    suspend boolean DEFAULT false,
    jwt_jwks jsonb,
    notify_private_alpha boolean DEFAULT false,
    private_only boolean DEFAULT false NOT NULL,
    migrations_ran integer DEFAULT 0
);


ALTER TABLE _realtime.tenants OWNER TO vikasalagarsamy;

--
-- Name: audit_trail; Type: TABLE; Schema: audit_security; Owner: vikasalagarsamy
--

CREATE TABLE audit_security.audit_trail (
    id integer NOT NULL,
    user_id uuid,
    action character varying(50) NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id character varying(100) NOT NULL,
    old_values jsonb,
    new_values jsonb,
    ip_address character varying(45),
    user_agent text,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE audit_security.audit_trail OWNER TO vikasalagarsamy;

--
-- Name: audit_trail_id_seq; Type: SEQUENCE; Schema: audit_security; Owner: vikasalagarsamy
--

CREATE SEQUENCE audit_security.audit_trail_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE audit_security.audit_trail_id_seq OWNER TO vikasalagarsamy;

--
-- Name: audit_trail_id_seq; Type: SEQUENCE OWNED BY; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER SEQUENCE audit_security.audit_trail_id_seq OWNED BY audit_security.audit_trail.id;


--
-- Name: permissions; Type: TABLE; Schema: audit_security; Owner: vikasalagarsamy
--

CREATE TABLE audit_security.permissions (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    resource character varying(100) NOT NULL,
    action character varying(50) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'active'::character varying
);


ALTER TABLE audit_security.permissions OWNER TO vikasalagarsamy;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: audit_security; Owner: vikasalagarsamy
--

CREATE SEQUENCE audit_security.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE audit_security.permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER SEQUENCE audit_security.permissions_id_seq OWNED BY audit_security.permissions.id;


--
-- Name: role_permissions; Type: TABLE; Schema: audit_security; Owner: vikasalagarsamy
--

CREATE TABLE audit_security.role_permissions (
    id integer NOT NULL,
    role_id integer,
    permission_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'active'::character varying
);


ALTER TABLE audit_security.role_permissions OWNER TO vikasalagarsamy;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: audit_security; Owner: vikasalagarsamy
--

CREATE SEQUENCE audit_security.role_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE audit_security.role_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER SEQUENCE audit_security.role_permissions_id_seq OWNED BY audit_security.role_permissions.id;


--
-- Name: roles; Type: TABLE; Schema: audit_security; Owner: vikasalagarsamy
--

CREATE TABLE audit_security.roles (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'active'::character varying
);


ALTER TABLE audit_security.roles OWNER TO vikasalagarsamy;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: audit_security; Owner: vikasalagarsamy
--

CREATE SEQUENCE audit_security.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE audit_security.roles_id_seq OWNER TO vikasalagarsamy;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER SEQUENCE audit_security.roles_id_seq OWNED BY audit_security.roles.id;


--
-- Name: user_roles; Type: TABLE; Schema: audit_security; Owner: vikasalagarsamy
--

CREATE TABLE audit_security.user_roles (
    id integer NOT NULL,
    user_id uuid,
    role_id integer,
    branch_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(20) DEFAULT 'active'::character varying
);


ALTER TABLE audit_security.user_roles OWNER TO vikasalagarsamy;

--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: audit_security; Owner: vikasalagarsamy
--

CREATE SEQUENCE audit_security.user_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE audit_security.user_roles_id_seq OWNER TO vikasalagarsamy;

--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER SEQUENCE audit_security.user_roles_id_seq OWNED BY audit_security.user_roles.id;


--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO vikasalagarsamy;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text NOT NULL,
    code_challenge_method auth.code_challenge_method NOT NULL,
    code_challenge text NOT NULL,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone
);


ALTER TABLE auth.flow_state OWNER TO vikasalagarsamy;

--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.flow_state IS 'stores metadata for pkce logins';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE auth.identities OWNER TO vikasalagarsamy;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO vikasalagarsamy;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO vikasalagarsamy;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


ALTER TABLE auth.mfa_challenges OWNER TO vikasalagarsamy;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid
);


ALTER TABLE auth.mfa_factors OWNER TO vikasalagarsamy;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


ALTER TABLE auth.one_time_tokens OWNER TO vikasalagarsamy;

--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO vikasalagarsamy;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: vikasalagarsamy
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO vikasalagarsamy;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: vikasalagarsamy
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO vikasalagarsamy;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO vikasalagarsamy;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO vikasalagarsamy;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text
);


ALTER TABLE auth.sessions OWNER TO vikasalagarsamy;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO vikasalagarsamy;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO vikasalagarsamy;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: vikasalagarsamy
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO vikasalagarsamy;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: account_heads; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.account_heads (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    category character varying(100),
    type character varying(50) NOT NULL,
    description text,
    status character varying(20) DEFAULT 'Active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.account_heads OWNER TO vikasalagarsamy;

--
-- Name: account_heads_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.account_heads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.account_heads_id_seq OWNER TO vikasalagarsamy;

--
-- Name: account_heads_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.account_heads_id_seq OWNED BY master_data.account_heads.id;


--
-- Name: audio_genres; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.audio_genres (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    status character varying(20) DEFAULT 'Active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.audio_genres OWNER TO vikasalagarsamy;

--
-- Name: audio_genres_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.audio_genres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.audio_genres_id_seq OWNER TO vikasalagarsamy;

--
-- Name: audio_genres_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.audio_genres_id_seq OWNED BY master_data.audio_genres.id;


--
-- Name: bank_accounts; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.bank_accounts (
    id integer NOT NULL,
    company_id integer NOT NULL,
    account_name character varying(255) NOT NULL,
    account_number character varying(50) NOT NULL,
    bank_name character varying(255) NOT NULL,
    branch_name character varying(255),
    ifsc_code character varying(20),
    account_type character varying(50),
    opening_balance numeric(15,2) DEFAULT 0.00,
    current_balance numeric(15,2) DEFAULT 0.00,
    status character varying(20) DEFAULT 'Active'::character varying,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.bank_accounts OWNER TO vikasalagarsamy;

--
-- Name: bank_accounts_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.bank_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.bank_accounts_id_seq OWNER TO vikasalagarsamy;

--
-- Name: bank_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.bank_accounts_id_seq OWNED BY master_data.bank_accounts.id;


--
-- Name: branches; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.branches (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    address text,
    manager character varying(255),
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.branches OWNER TO vikasalagarsamy;

--
-- Name: branches_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.branches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.branches_id_seq OWNER TO vikasalagarsamy;

--
-- Name: branches_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.branches_id_seq OWNED BY master_data.branches.id;


--
-- Name: checklist_items; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.checklist_items (
    id integer NOT NULL,
    checklist_id integer NOT NULL,
    item_text text NOT NULL,
    sequence integer,
    is_required boolean DEFAULT false,
    status character varying(20) DEFAULT 'Active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.checklist_items OWNER TO vikasalagarsamy;

--
-- Name: checklist_items_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.checklist_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.checklist_items_id_seq OWNER TO vikasalagarsamy;

--
-- Name: checklist_items_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.checklist_items_id_seq OWNED BY master_data.checklist_items.id;


--
-- Name: checklists; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.checklists (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    category character varying(100),
    description text,
    status character varying(20) DEFAULT 'Active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.checklists OWNER TO vikasalagarsamy;

--
-- Name: checklists_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.checklists_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.checklists_id_seq OWNER TO vikasalagarsamy;

--
-- Name: checklists_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.checklists_id_seq OWNED BY master_data.checklists.id;


--
-- Name: clients; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.clients (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    contact character varying(100),
    email character varying(255),
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.clients OWNER TO vikasalagarsamy;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.clients_id_seq OWNER TO vikasalagarsamy;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.clients_id_seq OWNED BY master_data.clients.id;


--
-- Name: companies; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.companies (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.companies OWNER TO vikasalagarsamy;

--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.companies_id_seq OWNER TO vikasalagarsamy;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.companies_id_seq OWNED BY master_data.companies.id;


--
-- Name: deliverables; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.deliverables (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    category character varying(100),
    type character varying(50),
    description text,
    status character varying(20) DEFAULT 'Active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.deliverables OWNER TO vikasalagarsamy;

--
-- Name: deliverables_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.deliverables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.deliverables_id_seq OWNER TO vikasalagarsamy;

--
-- Name: deliverables_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.deliverables_id_seq OWNED BY master_data.deliverables.id;


--
-- Name: departments; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.departments (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    head character varying(255),
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.departments OWNER TO vikasalagarsamy;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.departments_id_seq OWNER TO vikasalagarsamy;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.departments_id_seq OWNED BY master_data.departments.id;


--
-- Name: designations; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.designations (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    department character varying(255),
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.designations OWNER TO vikasalagarsamy;

--
-- Name: designations_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.designations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.designations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: designations_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.designations_id_seq OWNED BY master_data.designations.id;


--
-- Name: document_templates; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.document_templates (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    category character varying(100),
    file_path text,
    content_type character varying(100),
    description text,
    status character varying(20) DEFAULT 'Active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.document_templates OWNER TO vikasalagarsamy;

--
-- Name: document_templates_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.document_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.document_templates_id_seq OWNER TO vikasalagarsamy;

--
-- Name: document_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.document_templates_id_seq OWNED BY master_data.document_templates.id;


--
-- Name: muhurtham; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.muhurtham (
    id integer NOT NULL,
    date date NOT NULL,
    start_time time without time zone,
    end_time time without time zone,
    description text,
    status character varying(20) DEFAULT 'Active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.muhurtham OWNER TO vikasalagarsamy;

--
-- Name: muhurtham_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.muhurtham_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.muhurtham_id_seq OWNER TO vikasalagarsamy;

--
-- Name: muhurtham_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.muhurtham_id_seq OWNED BY master_data.muhurtham.id;


--
-- Name: payment_modes; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.payment_modes (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    description text,
    status character varying(20) DEFAULT 'Active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.payment_modes OWNER TO vikasalagarsamy;

--
-- Name: payment_modes_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.payment_modes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.payment_modes_id_seq OWNER TO vikasalagarsamy;

--
-- Name: payment_modes_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.payment_modes_id_seq OWNED BY master_data.payment_modes.id;


--
-- Name: service_deliverable_mapping; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.service_deliverable_mapping (
    id integer NOT NULL,
    service_id integer NOT NULL,
    deliverable_id integer NOT NULL,
    status character varying(20) DEFAULT 'Active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.service_deliverable_mapping OWNER TO vikasalagarsamy;

--
-- Name: service_deliverable_mapping_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.service_deliverable_mapping_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.service_deliverable_mapping_id_seq OWNER TO vikasalagarsamy;

--
-- Name: service_deliverable_mapping_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.service_deliverable_mapping_id_seq OWNED BY master_data.service_deliverable_mapping.id;


--
-- Name: services; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.services (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    code character varying(50) NOT NULL,
    category character varying(100),
    base_price numeric(15,2) DEFAULT 0.00,
    premium_price numeric(15,2) DEFAULT 0.00,
    elite_price numeric(15,2) DEFAULT 0.00,
    description text,
    status character varying(20) DEFAULT 'Active'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.services OWNER TO vikasalagarsamy;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.services_id_seq OWNER TO vikasalagarsamy;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.services_id_seq OWNED BY master_data.services.id;


--
-- Name: suppliers; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.suppliers (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    contact character varying(100),
    email character varying(255),
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.suppliers OWNER TO vikasalagarsamy;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.suppliers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.suppliers_id_seq OWNER TO vikasalagarsamy;

--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.suppliers_id_seq OWNED BY master_data.suppliers.id;


--
-- Name: vendors; Type: TABLE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE TABLE master_data.vendors (
    id integer NOT NULL,
    code character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    contact character varying(100),
    email character varying(255),
    status character varying(20) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE master_data.vendors OWNER TO vikasalagarsamy;

--
-- Name: vendors_id_seq; Type: SEQUENCE; Schema: master_data; Owner: vikasalagarsamy
--

CREATE SEQUENCE master_data.vendors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE master_data.vendors_id_seq OWNER TO vikasalagarsamy;

--
-- Name: vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: master_data; Owner: vikasalagarsamy
--

ALTER SEQUENCE master_data.vendors_id_seq OWNED BY master_data.vendors.id;


--
-- Name: accounting_workflows; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.accounting_workflows (
    id integer NOT NULL,
    quotation_id integer,
    payment_id integer,
    instruction_id integer,
    status character varying(30) DEFAULT 'pending_processing'::character varying,
    total_amount numeric(12,2) NOT NULL,
    payment_type character varying(20) NOT NULL,
    processed_by character varying(255),
    processed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.accounting_workflows OWNER TO vikasalagarsamy;

--
-- Name: accounting_workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.accounting_workflows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.accounting_workflows_id_seq OWNER TO vikasalagarsamy;

--
-- Name: accounting_workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.accounting_workflows_id_seq OWNED BY public.accounting_workflows.id;


--
-- Name: action_recommendations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.action_recommendations (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    recommendation_type text NOT NULL,
    priority text NOT NULL,
    confidence_score numeric(5,4) NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    suggested_action text NOT NULL,
    expected_impact jsonb DEFAULT '{}'::jsonb NOT NULL,
    reasoning text NOT NULL,
    is_completed boolean DEFAULT false NOT NULL,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    CONSTRAINT action_recommendations_priority_check CHECK ((priority = ANY (ARRAY['urgent'::text, 'high'::text, 'medium'::text, 'low'::text]))),
    CONSTRAINT action_recommendations_recommendation_type_check CHECK ((recommendation_type = ANY (ARRAY['follow_up'::text, 'price_adjustment'::text, 'add_services'::text, 'schedule_meeting'::text, 'send_samples'::text, 'create_urgency'::text, 'escalate_to_manager'::text, 'custom_proposal'::text])))
);


ALTER TABLE public.action_recommendations OWNER TO vikasalagarsamy;

--
-- Name: action_recommendations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.action_recommendations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.action_recommendations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: action_recommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.action_recommendations_id_seq OWNED BY public.action_recommendations.id;


--
-- Name: activities; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.activities (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    action_type character varying(50) NOT NULL,
    entity_type character varying(50) NOT NULL,
    entity_id text NOT NULL,
    entity_name character varying(255) NOT NULL,
    description text NOT NULL,
    user_id uuid,
    user_name character varying(255),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.activities OWNER TO vikasalagarsamy;

--
-- Name: TABLE activities; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.activities IS 'Stores activity logs for all entities in the system';


--
-- Name: ai_behavior_settings; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_behavior_settings (
    id integer NOT NULL,
    setting_key character varying(100) NOT NULL,
    setting_value jsonb NOT NULL,
    description text,
    category character varying(50) NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_behavior_settings OWNER TO vikasalagarsamy;

--
-- Name: ai_behavior_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_behavior_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_behavior_settings_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_behavior_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_behavior_settings_id_seq OWNED BY public.ai_behavior_settings.id;


--
-- Name: ai_communication_tasks; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_communication_tasks (
    id integer NOT NULL,
    quotation_id integer,
    conversation_session_id integer,
    task_type character varying(50) NOT NULL,
    title text NOT NULL,
    description text,
    priority character varying(20) DEFAULT 'medium'::character varying,
    assigned_to_employee_id integer,
    due_date timestamp without time zone,
    status character varying(20) DEFAULT 'pending'::character varying,
    ai_reasoning text,
    trigger_message_id integer,
    created_by_ai boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT ai_communication_tasks_priority_check CHECK (((priority)::text = ANY (ARRAY[('low'::character varying)::text, ('medium'::character varying)::text, ('high'::character varying)::text, ('critical'::character varying)::text]))),
    CONSTRAINT ai_communication_tasks_status_check CHECK (((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('in_progress'::character varying)::text, ('completed'::character varying)::text, ('cancelled'::character varying)::text])))
);


ALTER TABLE public.ai_communication_tasks OWNER TO vikasalagarsamy;

--
-- Name: ai_communication_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_communication_tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_communication_tasks_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_communication_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_communication_tasks_id_seq OWNED BY public.ai_communication_tasks.id;


--
-- Name: ai_configurations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_configurations (
    id integer NOT NULL,
    config_key character varying(100) NOT NULL,
    config_type character varying(50) NOT NULL,
    config_value text NOT NULL,
    version integer DEFAULT 1,
    is_active boolean DEFAULT true,
    created_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    description text
);


ALTER TABLE public.ai_configurations OWNER TO vikasalagarsamy;

--
-- Name: ai_configurations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_configurations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_configurations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_configurations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_configurations_id_seq OWNED BY public.ai_configurations.id;


--
-- Name: ai_contacts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_contacts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone text,
    country_code text,
    name text,
    source_id text,
    source_url text,
    internal_lead_source text,
    internal_closure_date timestamp without time zone,
    created_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.ai_contacts OWNER TO vikasalagarsamy;

--
-- Name: ai_decision_log; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_decision_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id text,
    decision_type text NOT NULL,
    decision_data jsonb NOT NULL,
    model_version text DEFAULT 'v1.0'::text,
    confidence_score numeric(3,2),
    execution_time integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_decision_log OWNER TO vikasalagarsamy;

--
-- Name: predictive_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.predictive_insights (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    insight_type text NOT NULL,
    probability numeric(3,2) NOT NULL,
    recommended_action text NOT NULL,
    trigger_conditions jsonb DEFAULT '{}'::jsonb,
    estimated_impact numeric(3,2) DEFAULT 0,
    status text DEFAULT 'pending'::text,
    expires_at timestamp with time zone DEFAULT (now() + '7 days'::interval),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT predictive_insights_probability_check CHECK (((probability >= (0)::numeric) AND (probability <= (1)::numeric))),
    CONSTRAINT predictive_insights_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'triggered'::text, 'completed'::text, 'expired'::text])))
);


ALTER TABLE public.predictive_insights OWNER TO vikasalagarsamy;

--
-- Name: ai_insights_summary; Type: VIEW; Schema: public; Owner: vikasalagarsamy
--

CREATE VIEW public.ai_insights_summary AS
 SELECT pi.user_id,
    pi.insight_type,
    pi.probability,
    pi.recommended_action,
    pi.status,
    pi.created_at,
    pi.expires_at,
        CASE
            WHEN (pi.expires_at < now()) THEN true
            ELSE false
        END AS is_expired
   FROM public.predictive_insights pi
  WHERE (pi.status <> 'expired'::text)
  ORDER BY pi.probability DESC, pi.created_at DESC;


ALTER TABLE public.ai_insights_summary OWNER TO vikasalagarsamy;

--
-- Name: ai_performance_tracking; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_performance_tracking (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    model_type text NOT NULL,
    prediction_data jsonb NOT NULL,
    actual_outcome jsonb,
    accuracy_score numeric(3,2),
    confidence_score numeric(3,2),
    model_version text DEFAULT 'v1.0'::text,
    feedback_loop_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT ai_performance_tracking_model_type_check CHECK ((model_type = ANY (ARRAY['timing'::text, 'personalization'::text, 'content'::text, 'channel'::text])))
);


ALTER TABLE public.ai_performance_tracking OWNER TO vikasalagarsamy;

--
-- Name: ai_prompt_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_prompt_templates (
    id integer NOT NULL,
    template_name character varying(100) NOT NULL,
    template_content text NOT NULL,
    variables jsonb DEFAULT '{}'::jsonb,
    category character varying(50) NOT NULL,
    is_default boolean DEFAULT false,
    version integer DEFAULT 1,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ai_prompt_templates OWNER TO vikasalagarsamy;

--
-- Name: ai_prompt_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_prompt_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_prompt_templates_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_prompt_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_prompt_templates_id_seq OWNED BY public.ai_prompt_templates.id;


--
-- Name: ai_recommendations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_recommendations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    recommendation_type text NOT NULL,
    recommendation_data jsonb NOT NULL,
    confidence_score numeric(3,2) NOT NULL,
    context_data jsonb DEFAULT '{}'::jsonb,
    applied boolean DEFAULT false,
    feedback_score integer,
    expires_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT ai_recommendations_feedback_score_check CHECK (((feedback_score >= 1) AND (feedback_score <= 5))),
    CONSTRAINT ai_recommendations_recommendation_type_check CHECK ((recommendation_type = ANY (ARRAY['content'::text, 'timing'::text, 'channel'::text, 'frequency'::text])))
);


ALTER TABLE public.ai_recommendations OWNER TO vikasalagarsamy;

--
-- Name: ai_tasks; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ai_tasks (
    id integer NOT NULL,
    task_title character varying(255) NOT NULL,
    task_description text,
    priority character varying(20) DEFAULT 'medium'::character varying,
    status character varying(20) DEFAULT 'pending'::character varying,
    due_date timestamp with time zone,
    category character varying(50),
    assigned_to character varying(255),
    assigned_by character varying(255),
    metadata jsonb,
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    client_name character varying(255),
    business_impact text,
    ai_reasoning text,
    estimated_value numeric(12,2),
    lead_id integer,
    quotation_id integer,
    actual_hours numeric(5,2),
    quality_rating integer,
    assigned_to_employee_id integer,
    task_type character varying(50),
    completion_notes text,
    employee_id integer,
    CONSTRAINT ai_tasks_priority_check CHECK (((priority)::text = ANY (ARRAY[('low'::character varying)::text, ('medium'::character varying)::text, ('high'::character varying)::text, ('urgent'::character varying)::text, ('LOW'::character varying)::text, ('MEDIUM'::character varying)::text, ('HIGH'::character varying)::text, ('URGENT'::character varying)::text]))),
    CONSTRAINT ai_tasks_quality_rating_check CHECK (((quality_rating >= 1) AND (quality_rating <= 5))),
    CONSTRAINT ai_tasks_status_check CHECK (((status)::text = ANY (ARRAY[('pending'::character varying)::text, ('in_progress'::character varying)::text, ('completed'::character varying)::text, ('cancelled'::character varying)::text, ('PENDING'::character varying)::text, ('IN_PROGRESS'::character varying)::text, ('COMPLETED'::character varying)::text, ('CANCELLED'::character varying)::text])))
);


ALTER TABLE public.ai_tasks OWNER TO vikasalagarsamy;

--
-- Name: COLUMN ai_tasks.assigned_to_employee_id; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.ai_tasks.assigned_to_employee_id IS 'Employee ID that the task is assigned to';


--
-- Name: COLUMN ai_tasks.completion_notes; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.ai_tasks.completion_notes IS 'Notes added when the task is completed, explaining the outcome or resolution';


--
-- Name: ai_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ai_tasks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ai_tasks_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ai_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ai_tasks_id_seq OWNED BY public.ai_tasks.id;


--
-- Name: analytics_cache; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.analytics_cache (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    cache_key text NOT NULL,
    cache_data jsonb NOT NULL,
    cache_type text NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.analytics_cache OWNER TO vikasalagarsamy;

--
-- Name: analytics_metrics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.analytics_metrics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    metric_name text NOT NULL,
    metric_type text NOT NULL,
    metric_value numeric(10,4) NOT NULL,
    metric_unit text DEFAULT 'count'::text,
    dimensions jsonb DEFAULT '{}'::jsonb,
    time_period text NOT NULL,
    recorded_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT analytics_metrics_metric_type_check CHECK ((metric_type = ANY (ARRAY['engagement'::text, 'performance'::text, 'user_behavior'::text, 'ai_accuracy'::text]))),
    CONSTRAINT analytics_metrics_time_period_check CHECK ((time_period = ANY (ARRAY['hourly'::text, 'daily'::text, 'weekly'::text, 'monthly'::text])))
);


ALTER TABLE public.analytics_metrics OWNER TO vikasalagarsamy;

--
-- Name: auditions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.auditions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    title text NOT NULL,
    description text,
    date date NOT NULL,
    location text,
    status text DEFAULT 'pending'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.auditions OWNER TO vikasalagarsamy;

--
-- Name: branches; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.branches (
    id integer NOT NULL,
    company_id integer NOT NULL,
    name character varying(255) NOT NULL,
    address text NOT NULL,
    phone character varying(50),
    email character varying(255),
    manager_id integer,
    is_remote boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    branch_code character varying(30),
    location character varying(255)
);


ALTER TABLE public.branches OWNER TO vikasalagarsamy;

--
-- Name: COLUMN branches.branch_code; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.branches.branch_code IS 'Unique identifier code for the branch, auto-generated from company code';


--
-- Name: branches_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.branches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.branches_id_seq OWNER TO vikasalagarsamy;

--
-- Name: branches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.branches_id_seq OWNED BY public.branches.id;


--
-- Name: bug_attachments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.bug_attachments (
    id bigint NOT NULL,
    bug_id bigint,
    file_name text NOT NULL,
    file_path text NOT NULL,
    file_type text NOT NULL,
    file_size integer NOT NULL,
    uploaded_by uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bug_attachments OWNER TO vikasalagarsamy;

--
-- Name: bug_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.bug_attachments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.bug_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: bug_comments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.bug_comments (
    id bigint NOT NULL,
    bug_id bigint,
    user_id uuid NOT NULL,
    content text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.bug_comments OWNER TO vikasalagarsamy;

--
-- Name: bug_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.bug_comments ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.bug_comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: bugs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.bugs (
    id bigint NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    severity text NOT NULL,
    status text DEFAULT 'open'::text NOT NULL,
    assignee_id uuid,
    reporter_id uuid NOT NULL,
    due_date timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT bugs_severity_check CHECK ((severity = ANY (ARRAY['critical'::text, 'high'::text, 'medium'::text, 'low'::text]))),
    CONSTRAINT bugs_status_check CHECK ((status = ANY (ARRAY['open'::text, 'in_progress'::text, 'resolved'::text, 'closed'::text])))
);


ALTER TABLE public.bugs OWNER TO vikasalagarsamy;

--
-- Name: bugs_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.bugs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.bugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: business_rules; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.business_rules (
    id text NOT NULL,
    name text NOT NULL,
    description text,
    department text NOT NULL,
    task_type text NOT NULL,
    priority text NOT NULL,
    due_after_hours integer DEFAULT 24 NOT NULL,
    due_after_days integer DEFAULT 1 NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    conditions jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    created_by uuid,
    updated_by uuid,
    CONSTRAINT business_rules_priority_check CHECK ((priority = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'urgent'::text])))
);


ALTER TABLE public.business_rules OWNER TO vikasalagarsamy;

--
-- Name: TABLE business_rules; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.business_rules IS 'Department-specific business rules for follow-up timing and automation';


--
-- Name: COLUMN business_rules.id; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.business_rules.id IS 'Unique identifier for the business rule';


--
-- Name: COLUMN business_rules.name; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.business_rules.name IS 'Human-readable name of the rule';


--
-- Name: COLUMN business_rules.description; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.business_rules.description IS 'Description of what this rule does';


--
-- Name: COLUMN business_rules.department; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.business_rules.department IS 'Department this rule belongs to (Sales, Operations, Accounts, etc.)';


--
-- Name: COLUMN business_rules.task_type; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.business_rules.task_type IS 'Type of task this rule generates';


--
-- Name: COLUMN business_rules.priority; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.business_rules.priority IS 'Priority level for tasks generated by this rule';


--
-- Name: COLUMN business_rules.due_after_hours; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.business_rules.due_after_hours IS 'Number of hours after trigger before task is due';


--
-- Name: COLUMN business_rules.due_after_days; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.business_rules.due_after_days IS 'Number of days after trigger before task is due';


--
-- Name: COLUMN business_rules.enabled; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.business_rules.enabled IS 'Whether this rule is currently active';


--
-- Name: COLUMN business_rules.conditions; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.business_rules.conditions IS 'JSON conditions for when this rule triggers (min_value, status_triggers, etc.)';


--
-- Name: business_trends; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.business_trends (
    id integer NOT NULL,
    trend_type text NOT NULL,
    trend_period text NOT NULL,
    trend_direction text NOT NULL,
    trend_strength numeric(5,4) NOT NULL,
    current_value numeric(15,4) NOT NULL,
    previous_value numeric(15,4) NOT NULL,
    percentage_change numeric(8,4) NOT NULL,
    statistical_significance numeric(5,4) NOT NULL,
    insights jsonb DEFAULT '{}'::jsonb NOT NULL,
    recommendations jsonb DEFAULT '{}'::jsonb NOT NULL,
    analyzed_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT business_trends_trend_direction_check CHECK ((trend_direction = ANY (ARRAY['increasing'::text, 'decreasing'::text, 'stable'::text]))),
    CONSTRAINT business_trends_trend_type_check CHECK ((trend_type = ANY (ARRAY['conversion_rate'::text, 'avg_deal_size'::text, 'sales_cycle_length'::text, 'seasonal_patterns'::text, 'service_demand'::text, 'pricing_trends'::text])))
);


ALTER TABLE public.business_trends OWNER TO vikasalagarsamy;

--
-- Name: business_trends_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.business_trends_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.business_trends_id_seq OWNER TO vikasalagarsamy;

--
-- Name: business_trends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.business_trends_id_seq OWNED BY public.business_trends.id;


--
-- Name: call_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    call_id character varying(255) NOT NULL,
    overall_sentiment character varying(20),
    sentiment_score numeric(3,2) DEFAULT 0,
    client_sentiment character varying(20),
    agent_sentiment character varying(20),
    call_intent character varying(255),
    key_topics jsonb DEFAULT '[]'::jsonb,
    business_outcomes jsonb DEFAULT '[]'::jsonb,
    action_items jsonb DEFAULT '[]'::jsonb,
    agent_professionalism_score integer,
    agent_responsiveness_score integer,
    agent_knowledge_score integer,
    agent_closing_effectiveness integer,
    client_engagement_level character varying(20),
    client_interest_level character varying(20),
    client_objection_handling jsonb DEFAULT '[]'::jsonb,
    client_buying_signals jsonb DEFAULT '[]'::jsonb,
    forbidden_words_detected jsonb DEFAULT '[]'::jsonb,
    compliance_issues jsonb DEFAULT '[]'::jsonb,
    risk_level character varying(20),
    talk_time_ratio numeric(4,2) DEFAULT 1.0,
    interruptions integer DEFAULT 0,
    silent_periods integer DEFAULT 0,
    call_quality_score numeric(3,1) DEFAULT 7.0,
    quote_discussed boolean DEFAULT false,
    budget_mentioned boolean DEFAULT false,
    timeline_discussed boolean DEFAULT false,
    next_steps_agreed boolean DEFAULT false,
    follow_up_required boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.call_analytics OWNER TO vikasalagarsamy;

--
-- Name: call_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_insights (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    call_id character varying(255) NOT NULL,
    conversion_indicators jsonb DEFAULT '[]'::jsonb,
    objection_patterns jsonb DEFAULT '[]'::jsonb,
    successful_techniques jsonb DEFAULT '[]'::jsonb,
    improvement_areas jsonb DEFAULT '[]'::jsonb,
    decision_factors jsonb DEFAULT '[]'::jsonb,
    pain_points jsonb DEFAULT '[]'::jsonb,
    preferences jsonb DEFAULT '[]'::jsonb,
    concerns jsonb DEFAULT '[]'::jsonb,
    market_trends jsonb DEFAULT '[]'::jsonb,
    competitive_mentions jsonb DEFAULT '[]'::jsonb,
    pricing_feedback jsonb DEFAULT '[]'::jsonb,
    service_feedback jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.call_insights OWNER TO vikasalagarsamy;

--
-- Name: call_transcriptions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_transcriptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    call_id character varying(255) NOT NULL,
    task_id uuid,
    lead_id integer,
    client_name character varying(255) NOT NULL,
    sales_agent character varying(255) NOT NULL,
    phone_number character varying(20) NOT NULL,
    duration integer NOT NULL,
    recording_url text,
    transcript text NOT NULL,
    confidence_score numeric(3,2) DEFAULT 0.8,
    language character varying(10) DEFAULT 'en'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    detected_language character varying(10),
    status character varying(20) DEFAULT 'processing'::character varying,
    notes text,
    call_direction character varying(20) DEFAULT 'outgoing'::character varying,
    call_status character varying(20) DEFAULT 'processing'::character varying,
    CONSTRAINT check_status_valid CHECK (((status)::text = ANY (ARRAY[('processing'::character varying)::text, ('transcribing'::character varying)::text, ('completed'::character varying)::text, ('error'::character varying)::text])))
);


ALTER TABLE public.call_transcriptions OWNER TO vikasalagarsamy;

--
-- Name: COLUMN call_transcriptions.task_id; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.call_transcriptions.task_id IS 'Related task ID from ai_tasks table';


--
-- Name: COLUMN call_transcriptions.status; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.call_transcriptions.status IS 'Processing status: processing, transcribing, completed, error';


--
-- Name: COLUMN call_transcriptions.notes; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.call_transcriptions.notes IS 'Employee notes about the call';


--
-- Name: COLUMN call_transcriptions.call_direction; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.call_transcriptions.call_direction IS 'Call direction: incoming, outgoing';


--
-- Name: COLUMN call_transcriptions.call_status; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.call_transcriptions.call_status IS 'Detailed call status: ringing, connected, completed, missed, unanswered, processing';


--
-- Name: call_triggers; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.call_triggers (
    id integer NOT NULL,
    employee_id character varying(20) NOT NULL,
    phone_number character varying(20) NOT NULL,
    client_name character varying(255),
    task_id integer,
    triggered_at timestamp with time zone DEFAULT now(),
    executed_at timestamp with time zone,
    status character varying(20) DEFAULT 'pending'::character varying,
    response_data jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.call_triggers OWNER TO vikasalagarsamy;

--
-- Name: call_triggers_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.call_triggers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.call_triggers_id_seq OWNER TO vikasalagarsamy;

--
-- Name: call_triggers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.call_triggers_id_seq OWNED BY public.call_triggers.id;


--
-- Name: chat_logs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.chat_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    phone text NOT NULL,
    name text,
    message text NOT NULL,
    reply text NOT NULL,
    channel text DEFAULT 'whatsapp'::text,
    "timestamp" timestamp with time zone DEFAULT now()
);


ALTER TABLE public.chat_logs OWNER TO vikasalagarsamy;

--
-- Name: client_communication_timeline; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.client_communication_timeline (
    id integer NOT NULL,
    quotation_id integer,
    client_phone character varying(20),
    communication_type character varying(20) NOT NULL,
    communication_direction character varying(10) NOT NULL,
    content text,
    "timestamp" timestamp without time zone NOT NULL,
    employee_id integer,
    reference_id integer,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT client_communication_timeline_communication_direction_check CHECK (((communication_direction)::text = ANY (ARRAY[('inbound'::character varying)::text, ('outbound'::character varying)::text])))
);


ALTER TABLE public.client_communication_timeline OWNER TO vikasalagarsamy;

--
-- Name: client_communication_timeline_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.client_communication_timeline_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_communication_timeline_id_seq OWNER TO vikasalagarsamy;

--
-- Name: client_communication_timeline_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.client_communication_timeline_id_seq OWNED BY public.client_communication_timeline.id;


--
-- Name: client_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.client_insights (
    id integer NOT NULL,
    client_name text NOT NULL,
    client_email text,
    client_phone text,
    sentiment_score numeric(5,4),
    engagement_level text,
    conversion_probability numeric(5,4),
    preferred_communication_method text,
    optimal_follow_up_time text,
    price_sensitivity text,
    decision_timeline_days integer,
    insights jsonb DEFAULT '{}'::jsonb NOT NULL,
    last_analyzed_at timestamp with time zone DEFAULT now() NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT client_insights_engagement_level_check CHECK ((engagement_level = ANY (ARRAY['high'::text, 'medium'::text, 'low'::text]))),
    CONSTRAINT client_insights_price_sensitivity_check CHECK ((price_sensitivity = ANY (ARRAY['high'::text, 'medium'::text, 'low'::text])))
);


ALTER TABLE public.client_insights OWNER TO vikasalagarsamy;

--
-- Name: client_insights_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.client_insights_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.client_insights_id_seq OWNER TO vikasalagarsamy;

--
-- Name: client_insights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.client_insights_id_seq OWNED BY public.client_insights.id;


--
-- Name: clients; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.clients (
    id integer NOT NULL,
    client_code character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    company_id integer NOT NULL,
    contact_person character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    phone character varying(50) NOT NULL,
    address text NOT NULL,
    city character varying(100) NOT NULL,
    state character varying(100) NOT NULL,
    postal_code character varying(20) NOT NULL,
    country character varying(100) NOT NULL,
    category character varying(20) NOT NULL,
    status character varying(20) NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    country_code character varying(10) DEFAULT '+91'::character varying,
    is_whatsapp boolean DEFAULT false,
    whatsapp_country_code character varying(10),
    whatsapp_number character varying(20),
    has_separate_whatsapp boolean DEFAULT false,
    CONSTRAINT clients_category_check CHECK (((category)::text = ANY (ARRAY[('BUSINESS'::character varying)::text, ('INDIVIDUAL'::character varying)::text, ('CORPORATE'::character varying)::text, ('GOVERNMENT'::character varying)::text, ('NON-PROFIT'::character varying)::text]))),
    CONSTRAINT clients_status_check CHECK (((status)::text = ANY (ARRAY[('ACTIVE'::character varying)::text, ('INACTIVE'::character varying)::text, ('PENDING'::character varying)::text])))
);


ALTER TABLE public.clients OWNER TO vikasalagarsamy;

--
-- Name: clients_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.clients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.clients_id_seq OWNER TO vikasalagarsamy;

--
-- Name: clients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.clients_id_seq OWNED BY public.clients.id;


--
-- Name: communications; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.communications (
    id integer NOT NULL,
    channel_type character varying(50) NOT NULL,
    message_id character varying(255) NOT NULL,
    sender_type character varying(50) NOT NULL,
    sender_id character varying(100),
    sender_name character varying(255),
    recipient_type character varying(50) NOT NULL,
    recipient_id character varying(100),
    recipient_name character varying(255),
    content_type character varying(50) NOT NULL,
    content_text text,
    content_metadata jsonb,
    business_context character varying(100),
    ai_processed boolean DEFAULT false,
    ai_priority_score numeric(3,2) DEFAULT 0.0,
    sent_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.communications OWNER TO vikasalagarsamy;

--
-- Name: communications_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.communications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.communications_id_seq OWNER TO vikasalagarsamy;

--
-- Name: communications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.communications_id_seq OWNED BY public.communications.id;


--
-- Name: companies; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.companies (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    registration_number character varying(100),
    tax_id character varying(100),
    address text,
    phone character varying(50),
    email character varying(255),
    website character varying(255),
    founded_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    company_code character varying(20)
);


ALTER TABLE public.companies OWNER TO vikasalagarsamy;

--
-- Name: COLUMN companies.company_code; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.companies.company_code IS 'Unique identifier code for the company';


--
-- Name: companies_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.companies_id_seq OWNER TO vikasalagarsamy;

--
-- Name: companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.companies_id_seq OWNED BY public.companies.id;


--
-- Name: company_partners; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.company_partners (
    company_id integer NOT NULL,
    partner_id integer NOT NULL,
    contract_details text,
    contract_start_date date,
    contract_end_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.company_partners OWNER TO vikasalagarsamy;

--
-- Name: conversation_sessions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.conversation_sessions (
    id integer NOT NULL,
    quotation_id integer,
    client_phone character varying(20) NOT NULL,
    session_start timestamp without time zone NOT NULL,
    session_end timestamp without time zone,
    message_count integer DEFAULT 0,
    overall_sentiment character varying(20),
    business_outcome character varying(30),
    ai_summary text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.conversation_sessions OWNER TO vikasalagarsamy;

--
-- Name: conversation_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.conversation_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.conversation_sessions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: conversation_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.conversation_sessions_id_seq OWNED BY public.conversation_sessions.id;


--
-- Name: deliverable_master; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.deliverable_master (
    id bigint NOT NULL,
    category text NOT NULL,
    type text NOT NULL,
    deliverable_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT deliverable_master_category_check CHECK ((category = ANY (ARRAY['Main'::text, 'Optional'::text]))),
    CONSTRAINT deliverable_master_type_check CHECK ((type = ANY (ARRAY['Photo'::text, 'Video'::text])))
);


ALTER TABLE public.deliverable_master OWNER TO vikasalagarsamy;

--
-- Name: deliverable_master_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.deliverable_master_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deliverable_master_id_seq OWNER TO vikasalagarsamy;

--
-- Name: deliverable_master_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.deliverable_master_id_seq OWNED BY public.deliverable_master.id;


--
-- Name: deliverables; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.deliverables (
    id integer NOT NULL,
    deliverable_cat character varying(50) NOT NULL,
    deliverable_type character varying(50) NOT NULL,
    deliverable_id integer,
    deliverable_name character varying(255) NOT NULL,
    process_name character varying(255) NOT NULL,
    has_customer boolean DEFAULT false,
    has_employee boolean DEFAULT false,
    has_qc boolean DEFAULT false,
    has_vendor boolean DEFAULT false,
    link character varying(255),
    sort_order integer DEFAULT 0,
    timing_type character varying(20) DEFAULT 'days'::character varying,
    tat integer,
    tat_value integer,
    buffer integer,
    skippable boolean DEFAULT false,
    employee jsonb,
    has_download_option boolean DEFAULT false,
    has_task_process boolean DEFAULT true,
    has_upload_folder_path boolean DEFAULT false,
    process_starts_from integer DEFAULT 0,
    status integer DEFAULT 1,
    on_start_template character varying(255),
    on_complete_template character varying(255),
    on_correction_template character varying(255),
    input_names jsonb,
    created_date timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by integer,
    stream character varying(10),
    stage character varying(10),
    package_included jsonb DEFAULT '{"basic": false, "elite": false, "premium": false}'::jsonb,
    basic_price numeric,
    elite_price numeric,
    premium_price numeric,
    CONSTRAINT check_deliverable_cat CHECK (((deliverable_cat)::text = ANY (ARRAY[('Main'::character varying)::text, ('Optional'::character varying)::text]))),
    CONSTRAINT check_deliverable_type CHECK (((deliverable_type)::text = ANY (ARRAY[('Photo'::character varying)::text, ('Video'::character varying)::text]))),
    CONSTRAINT check_stream CHECK ((((stream)::text = ANY (ARRAY[('UP'::character varying)::text, ('DOWN'::character varying)::text])) OR (stream IS NULL))),
    CONSTRAINT check_timing_type CHECK (((timing_type)::text = ANY (ARRAY[('days'::character varying)::text, ('hr'::character varying)::text, ('min'::character varying)::text])))
);


ALTER TABLE public.deliverables OWNER TO vikasalagarsamy;

--
-- Name: TABLE deliverables; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.deliverables IS 'Post-production deliverables workflow system';


--
-- Name: deliverables_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.deliverables_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.deliverables_id_seq OWNER TO vikasalagarsamy;

--
-- Name: deliverables_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.deliverables_id_seq OWNED BY public.deliverables.id;


--
-- Name: department_instructions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.department_instructions (
    id integer NOT NULL,
    quotation_id integer,
    payment_id integer,
    instructions jsonb NOT NULL,
    status character varying(20) DEFAULT 'pending_approval'::character varying,
    created_by character varying(255) NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.department_instructions OWNER TO vikasalagarsamy;

--
-- Name: department_instructions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.department_instructions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.department_instructions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: department_instructions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.department_instructions_id_seq OWNED BY public.department_instructions.id;


--
-- Name: departments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.departments (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    manager_id integer,
    parent_department_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.departments OWNER TO vikasalagarsamy;

--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.departments_id_seq OWNER TO vikasalagarsamy;

--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.departments_id_seq OWNED BY public.departments.id;


--
-- Name: designations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.designations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    department_id integer,
    description text,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.designations OWNER TO vikasalagarsamy;

--
-- Name: designations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.designations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.designations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: designations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.designations_id_seq OWNED BY public.designations.id;


--
-- Name: dynamic_menus; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.dynamic_menus (
    id integer NOT NULL,
    menu_id character varying(100) NOT NULL,
    label character varying(255) NOT NULL,
    href character varying(500) NOT NULL,
    icon character varying(100),
    description text,
    parent_id integer,
    sort_order integer DEFAULT 999,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.dynamic_menus OWNER TO vikasalagarsamy;

--
-- Name: dynamic_menus_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.dynamic_menus_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dynamic_menus_id_seq OWNER TO vikasalagarsamy;

--
-- Name: dynamic_menus_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.dynamic_menus_id_seq OWNED BY public.dynamic_menus.id;


--
-- Name: email_notification_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.email_notification_templates (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    name text NOT NULL,
    subject text NOT NULL,
    html_template text NOT NULL,
    text_template text NOT NULL,
    variables text[] DEFAULT '{}'::text[] NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.email_notification_templates OWNER TO vikasalagarsamy;

--
-- Name: employee_companies; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.employee_companies (
    id integer NOT NULL,
    employee_id integer,
    company_id integer,
    branch_id integer,
    allocation_percentage integer NOT NULL,
    is_primary boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    start_date date,
    end_date date,
    project_id uuid,
    status text DEFAULT 'active'::text,
    CONSTRAINT employee_companies_allocation_percentage_check CHECK (((allocation_percentage > 0) AND (allocation_percentage <= 100)))
);


ALTER TABLE public.employee_companies OWNER TO vikasalagarsamy;

--
-- Name: employee_companies_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.employee_companies_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_companies_id_seq OWNER TO vikasalagarsamy;

--
-- Name: employee_companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.employee_companies_id_seq OWNED BY public.employee_companies.id;


--
-- Name: employee_devices; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.employee_devices (
    id integer NOT NULL,
    employee_id character varying(20) NOT NULL,
    device_id character varying(255) NOT NULL,
    fcm_token text,
    device_name character varying(255),
    platform character varying(50) DEFAULT 'android'::character varying,
    app_version character varying(50),
    is_active boolean DEFAULT true,
    last_seen timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.employee_devices OWNER TO vikasalagarsamy;

--
-- Name: employee_devices_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.employee_devices_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employee_devices_id_seq OWNER TO vikasalagarsamy;

--
-- Name: employee_devices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.employee_devices_id_seq OWNED BY public.employee_devices.id;


--
-- Name: employees; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.employees (
    id integer NOT NULL,
    employee_id character varying(20) NOT NULL,
    first_name character varying(100) NOT NULL,
    last_name character varying(100) NOT NULL,
    email character varying(255),
    phone character varying(20),
    address text,
    city character varying(100),
    state character varying(100),
    zip_code character varying(20),
    country character varying(100),
    hire_date date,
    termination_date date,
    status character varying(20) DEFAULT 'active'::character varying,
    department_id integer,
    designation_id integer,
    job_title character varying(100),
    home_branch_id integer,
    primary_company_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    name character varying(255),
    username character varying(255),
    password_hash text,
    role_id integer,
    last_login timestamp without time zone,
    is_active boolean DEFAULT true
);


ALTER TABLE public.employees OWNER TO vikasalagarsamy;

--
-- Name: employees_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.employees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.employees_id_seq OWNER TO vikasalagarsamy;

--
-- Name: employees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.employees_id_seq OWNED BY public.employees.id;


--
-- Name: events; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.events (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    event_id character varying(20) NOT NULL,
    name character varying(255) NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.events OWNER TO vikasalagarsamy;

--
-- Name: TABLE events; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.events IS 'Stores event information for client quotations';


--
-- Name: follow_up_auditions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.follow_up_auditions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    audition_id uuid NOT NULL,
    title text NOT NULL,
    notes text,
    follow_up_date date NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.follow_up_auditions OWNER TO vikasalagarsamy;

--
-- Name: instagram_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_analytics (
    id integer NOT NULL,
    date date NOT NULL,
    total_messages integer DEFAULT 0,
    total_comments integer DEFAULT 0,
    total_mentions integer DEFAULT 0,
    total_story_mentions integer DEFAULT 0,
    new_leads_created integer DEFAULT 0,
    engagement_rate numeric(5,2) DEFAULT 0.00,
    response_time_minutes integer DEFAULT 0,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_analytics OWNER TO vikasalagarsamy;

--
-- Name: instagram_analytics_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_analytics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_analytics_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_analytics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_analytics_id_seq OWNED BY public.instagram_analytics.id;


--
-- Name: instagram_comments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_comments (
    id integer NOT NULL,
    comment_id character varying(255) NOT NULL,
    post_id character varying(255),
    from_user_id character varying(255) NOT NULL,
    from_username character varying(255),
    comment_text text,
    parent_comment_id character varying(255),
    is_from_client boolean DEFAULT true,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_comments OWNER TO vikasalagarsamy;

--
-- Name: instagram_comments_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_comments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_comments_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_comments_id_seq OWNED BY public.instagram_comments.id;


--
-- Name: instagram_interactions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_interactions (
    id integer NOT NULL,
    interaction_type character varying(50) NOT NULL,
    user_id character varying(255) NOT NULL,
    target_message_id character varying(255),
    content character varying(255),
    metadata jsonb DEFAULT '{}'::jsonb,
    "timestamp" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT instagram_interactions_interaction_type_check CHECK (((interaction_type)::text = ANY (ARRAY[('reaction'::character varying)::text, ('like'::character varying)::text, ('share'::character varying)::text, ('save'::character varying)::text, ('view'::character varying)::text])))
);


ALTER TABLE public.instagram_interactions OWNER TO vikasalagarsamy;

--
-- Name: instagram_interactions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_interactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_interactions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_interactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_interactions_id_seq OWNED BY public.instagram_interactions.id;


--
-- Name: instagram_mentions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_mentions (
    id integer NOT NULL,
    mention_id character varying(255) NOT NULL,
    from_user_id character varying(255) NOT NULL,
    from_username character varying(255),
    mention_text text,
    media_id character varying(255),
    permalink character varying(500),
    mention_type character varying(50) DEFAULT 'tag_mention'::character varying,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_time timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT instagram_mentions_mention_type_check CHECK (((mention_type)::text = ANY (ARRAY[('tag_mention'::character varying)::text, ('story_mention'::character varying)::text, ('comment_mention'::character varying)::text])))
);


ALTER TABLE public.instagram_mentions OWNER TO vikasalagarsamy;

--
-- Name: instagram_mentions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_mentions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_mentions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_mentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_mentions_id_seq OWNED BY public.instagram_mentions.id;


--
-- Name: instagram_messages; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_messages (
    id integer NOT NULL,
    message_id character varying(255) NOT NULL,
    from_user_id character varying(255) NOT NULL,
    to_user_id character varying(255) NOT NULL,
    content text,
    message_type character varying(50) DEFAULT 'text'::character varying,
    attachment_metadata jsonb DEFAULT '{}'::jsonb,
    is_from_client boolean DEFAULT true,
    "timestamp" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT instagram_messages_message_type_check CHECK (((message_type)::text = ANY (ARRAY[('text'::character varying)::text, ('image'::character varying)::text, ('video'::character varying)::text, ('audio'::character varying)::text, ('document'::character varying)::text, ('voice_note'::character varying)::text])))
);


ALTER TABLE public.instagram_messages OWNER TO vikasalagarsamy;

--
-- Name: instagram_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_messages_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_messages_id_seq OWNED BY public.instagram_messages.id;


--
-- Name: instagram_story_mentions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instagram_story_mentions (
    id integer NOT NULL,
    mention_id character varying(255) NOT NULL,
    from_user_id character varying(255) NOT NULL,
    from_username character varying(255),
    story_text text,
    media_id character varying(255),
    story_url character varying(500),
    metadata jsonb DEFAULT '{}'::jsonb,
    "timestamp" timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.instagram_story_mentions OWNER TO vikasalagarsamy;

--
-- Name: instagram_story_mentions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instagram_story_mentions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instagram_story_mentions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instagram_story_mentions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instagram_story_mentions_id_seq OWNED BY public.instagram_story_mentions.id;


--
-- Name: instruction_approvals; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.instruction_approvals (
    id integer NOT NULL,
    instruction_id integer,
    approval_status character varying(20) NOT NULL,
    approved_by character varying(255),
    approved_at timestamp with time zone,
    comments text,
    submitted_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT instruction_approvals_approval_status_check CHECK (((approval_status)::text = ANY (ARRAY[('submitted'::character varying)::text, ('approved'::character varying)::text, ('rejected'::character varying)::text])))
);


ALTER TABLE public.instruction_approvals OWNER TO vikasalagarsamy;

--
-- Name: instruction_approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.instruction_approvals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.instruction_approvals_id_seq OWNER TO vikasalagarsamy;

--
-- Name: instruction_approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.instruction_approvals_id_seq OWNED BY public.instruction_approvals.id;


--
-- Name: lead_drafts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_drafts (
    id bigint NOT NULL,
    phone text NOT NULL,
    data jsonb NOT NULL,
    status text DEFAULT 'draft'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.lead_drafts OWNER TO vikasalagarsamy;

--
-- Name: lead_drafts_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_drafts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_drafts_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_drafts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_drafts_id_seq OWNED BY public.lead_drafts.id;


--
-- Name: lead_followups; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_followups (
    id integer NOT NULL,
    lead_id integer NOT NULL,
    scheduled_at timestamp with time zone NOT NULL,
    completed_at timestamp with time zone,
    contact_method character varying(50) NOT NULL,
    interaction_summary text,
    status character varying(20) DEFAULT 'scheduled'::character varying NOT NULL,
    outcome text,
    notes text,
    priority character varying(10) DEFAULT 'medium'::character varying,
    created_by text,
    created_at timestamp with time zone DEFAULT now(),
    updated_by uuid,
    updated_at timestamp with time zone,
    completed_by uuid,
    duration_minutes integer,
    follow_up_required boolean DEFAULT false,
    next_follow_up_date timestamp with time zone,
    followup_type text,
    workflow_stage character varying(50),
    quotation_id integer,
    CONSTRAINT lead_followups_contact_method_check CHECK (((contact_method)::text = ANY (ARRAY[('email'::character varying)::text, ('phone'::character varying)::text, ('in_person'::character varying)::text, ('video_call'::character varying)::text, ('text_message'::character varying)::text, ('social_media'::character varying)::text, ('whatsapp_call'::character varying)::text, ('whatsapp_message'::character varying)::text, ('other'::character varying)::text]))),
    CONSTRAINT lead_followups_priority_check CHECK (((priority)::text = ANY (ARRAY[('low'::character varying)::text, ('medium'::character varying)::text, ('high'::character varying)::text, ('urgent'::character varying)::text]))),
    CONSTRAINT lead_followups_status_check CHECK (((status)::text = ANY (ARRAY[('scheduled'::character varying)::text, ('in_progress'::character varying)::text, ('completed'::character varying)::text, ('cancelled'::character varying)::text, ('missed'::character varying)::text, ('rescheduled'::character varying)::text]))),
    CONSTRAINT valid_completed_at CHECK (((((status)::text = 'completed'::text) AND (completed_at IS NOT NULL)) OR (((status)::text <> 'completed'::text) AND (completed_at IS NULL)))),
    CONSTRAINT valid_next_follow_up CHECK ((((follow_up_required = true) AND (next_follow_up_date IS NOT NULL)) OR (follow_up_required = false)))
);


ALTER TABLE public.lead_followups OWNER TO vikasalagarsamy;

--
-- Name: TABLE lead_followups; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.lead_followups IS 'Stores all follow-up interactions with leads, including scheduled, completed, and cancelled follow-ups';


--
-- Name: lead_followups_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_followups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_followups_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_followups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_followups_id_seq OWNED BY public.lead_followups.id;


--
-- Name: lead_sources; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_sources (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.lead_sources OWNER TO vikasalagarsamy;

--
-- Name: lead_sources_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_sources_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_sources_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_sources_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_sources_id_seq OWNED BY public.lead_sources.id;


--
-- Name: lead_task_performance; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.lead_task_performance (
    id integer NOT NULL,
    lead_id integer NOT NULL,
    task_id integer NOT NULL,
    response_time_hours numeric(10,2),
    completion_time_hours numeric(10,2),
    sla_met boolean,
    revenue_impact numeric(15,2),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.lead_task_performance OWNER TO vikasalagarsamy;

--
-- Name: lead_task_performance_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.lead_task_performance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.lead_task_performance_id_seq OWNER TO vikasalagarsamy;

--
-- Name: lead_task_performance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.lead_task_performance_id_seq OWNED BY public.lead_task_performance.id;


--
-- Name: leads; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.leads (
    id integer NOT NULL,
    lead_number character varying(20) NOT NULL,
    company_id integer NOT NULL,
    branch_id integer,
    client_name character varying(255) NOT NULL,
    email character varying(255),
    country_code character varying(10),
    phone character varying(20),
    is_whatsapp boolean DEFAULT false,
    has_separate_whatsapp boolean DEFAULT false,
    whatsapp_country_code character varying(10),
    whatsapp_number character varying(20),
    notes text,
    status character varying(50) DEFAULT 'UNASSIGNED'::character varying,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    assigned_to integer,
    lead_source character varying(100),
    location character varying(255),
    lead_source_id integer,
    rejection_reason text,
    rejected_at timestamp with time zone,
    rejected_by uuid,
    rejected_by_employee_id character varying(50),
    assigned_to_uuid uuid,
    previous_assigned_to integer,
    reassignment_date timestamp with time zone,
    reassignment_reason character varying(50),
    is_reassigned boolean DEFAULT false,
    reassigned_at timestamp with time zone,
    reassigned_by integer,
    reassigned_from_company_id integer,
    reassigned_from_branch_id integer,
    bride_name text,
    groom_name text,
    priority character varying(20) DEFAULT 'medium'::character varying,
    expected_value numeric(15,2) DEFAULT 0,
    last_contact_date timestamp without time zone,
    next_follow_up_date timestamp without time zone,
    conversion_stage character varying(50) DEFAULT 'new'::character varying,
    lead_score integer DEFAULT 50,
    tags text[],
    budget_range character varying(50),
    wedding_date date,
    venue_preference text,
    guest_count integer,
    description text,
    rejection_date timestamp without time zone,
    CONSTRAINT leads_conversion_stage_check CHECK (((conversion_stage)::text = ANY (ARRAY[('new'::character varying)::text, ('contacted'::character varying)::text, ('interested'::character varying)::text, ('quotation_sent'::character varying)::text, ('negotiation'::character varying)::text, ('won'::character varying)::text, ('lost'::character varying)::text]))),
    CONSTRAINT leads_lead_score_check CHECK (((lead_score >= 0) AND (lead_score <= 100))),
    CONSTRAINT leads_priority_check CHECK (((priority)::text = ANY (ARRAY[('low'::character varying)::text, ('medium'::character varying)::text, ('high'::character varying)::text, ('urgent'::character varying)::text])))
);


ALTER TABLE public.leads OWNER TO vikasalagarsamy;

--
-- Name: COLUMN leads.lead_source_id; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.lead_source_id IS 'Reference to lead_sources table';


--
-- Name: COLUMN leads.rejection_reason; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.rejection_reason IS 'Reason for lead rejection';


--
-- Name: COLUMN leads.rejected_by_employee_id; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.rejected_by_employee_id IS 'Employee ID of the user who rejected the lead';


--
-- Name: COLUMN leads.priority; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.priority IS 'Lead priority level: low, medium, high, urgent';


--
-- Name: COLUMN leads.expected_value; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.expected_value IS 'Expected monetary value of the lead';


--
-- Name: COLUMN leads.last_contact_date; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.last_contact_date IS 'Date of last contact with the lead';


--
-- Name: COLUMN leads.next_follow_up_date; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.next_follow_up_date IS 'Scheduled date for next follow-up';


--
-- Name: COLUMN leads.conversion_stage; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.conversion_stage IS 'Current stage in the conversion funnel';


--
-- Name: COLUMN leads.lead_score; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.lead_score IS 'AI-calculated lead score (0-100)';


--
-- Name: COLUMN leads.tags; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.tags IS 'Array of tags for lead categorization';


--
-- Name: COLUMN leads.budget_range; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.budget_range IS 'Client budget range (e.g., 50k-100k)';


--
-- Name: COLUMN leads.wedding_date; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.wedding_date IS 'Wedding date for wedding-related leads';


--
-- Name: COLUMN leads.venue_preference; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.venue_preference IS 'Preferred venue or location';


--
-- Name: COLUMN leads.guest_count; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.guest_count IS 'Expected number of guests';


--
-- Name: COLUMN leads.description; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.description IS 'Detailed description of lead requirements';


--
-- Name: COLUMN leads.rejection_date; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.leads.rejection_date IS 'Date when lead was rejected';


--
-- Name: leads_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.leads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.leads_id_seq OWNER TO vikasalagarsamy;

--
-- Name: leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.leads_id_seq OWNED BY public.leads.id;


--
-- Name: management_insights; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.management_insights (
    id integer NOT NULL,
    insight_type text NOT NULL,
    employee_id text,
    priority text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    key_metrics jsonb DEFAULT '{}'::jsonb NOT NULL,
    suggested_questions jsonb DEFAULT '[]'::jsonb NOT NULL,
    recommended_actions jsonb DEFAULT '[]'::jsonb NOT NULL,
    confidence_score numeric(5,4) NOT NULL,
    is_addressed boolean DEFAULT false NOT NULL,
    addressed_at timestamp with time zone,
    addressed_by text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    CONSTRAINT management_insights_insight_type_check CHECK ((insight_type = ANY (ARRAY['team_performance'::text, 'individual_performance'::text, 'process_improvement'::text, 'coaching_opportunity'::text, 'recognition_suggestion'::text, 'concern_alert'::text]))),
    CONSTRAINT management_insights_priority_check CHECK ((priority = ANY (ARRAY['urgent'::text, 'high'::text, 'medium'::text, 'low'::text])))
);


ALTER TABLE public.management_insights OWNER TO vikasalagarsamy;

--
-- Name: management_insights_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.management_insights_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.management_insights_id_seq OWNER TO vikasalagarsamy;

--
-- Name: management_insights_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.management_insights_id_seq OWNED BY public.management_insights.id;


--
-- Name: menu_items; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.menu_items (
    id integer NOT NULL,
    parent_id integer,
    name character varying(100) NOT NULL,
    description text,
    icon character varying(50),
    path character varying(255),
    sort_order integer DEFAULT 0,
    is_visible boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    string_id character varying(100),
    section_name character varying(100),
    is_admin_only boolean DEFAULT false,
    badge_text character varying(50),
    badge_variant character varying(20) DEFAULT 'secondary'::character varying,
    is_new boolean DEFAULT false,
    category character varying(20) DEFAULT 'primary'::character varying
);


ALTER TABLE public.menu_items OWNER TO vikasalagarsamy;

--
-- Name: menu_items_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.menu_items_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_items_id_seq OWNER TO vikasalagarsamy;

--
-- Name: menu_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.menu_items_id_seq OWNED BY public.menu_items.id;


--
-- Name: menu_items_tracking; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.menu_items_tracking (
    id integer NOT NULL,
    menu_item_id integer NOT NULL,
    last_known_state jsonb NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.menu_items_tracking OWNER TO vikasalagarsamy;

--
-- Name: menu_items_tracking_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.menu_items_tracking_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.menu_items_tracking_id_seq OWNER TO vikasalagarsamy;

--
-- Name: menu_items_tracking_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.menu_items_tracking_id_seq OWNED BY public.menu_items_tracking.id;


--
-- Name: message_analysis; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.message_analysis (
    id integer NOT NULL,
    message_id integer,
    sentiment character varying(20),
    sentiment_score numeric(3,2),
    intent character varying(50),
    urgency_level integer,
    key_topics text[],
    recommended_action text,
    confidence_score numeric(3,2),
    ai_model_version character varying(20) DEFAULT 'gpt-4'::character varying,
    created_at timestamp without time zone DEFAULT now(),
    CONSTRAINT message_analysis_confidence_score_check CHECK (((confidence_score >= (0)::numeric) AND (confidence_score <= (1)::numeric))),
    CONSTRAINT message_analysis_sentiment_check CHECK (((sentiment)::text = ANY (ARRAY[('positive'::character varying)::text, ('negative'::character varying)::text, ('neutral'::character varying)::text, ('urgent'::character varying)::text]))),
    CONSTRAINT message_analysis_sentiment_score_check CHECK (((sentiment_score >= ('-1'::integer)::numeric) AND (sentiment_score <= (1)::numeric))),
    CONSTRAINT message_analysis_urgency_level_check CHECK (((urgency_level >= 1) AND (urgency_level <= 5)))
);


ALTER TABLE public.message_analysis OWNER TO vikasalagarsamy;

--
-- Name: message_analysis_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.message_analysis_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.message_analysis_id_seq OWNER TO vikasalagarsamy;

--
-- Name: message_analysis_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.message_analysis_id_seq OWNED BY public.message_analysis.id;


--
-- Name: ml_model_performance; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.ml_model_performance (
    id integer NOT NULL,
    model_name text NOT NULL,
    model_version text NOT NULL,
    metric_type text NOT NULL,
    metric_value numeric(8,6) NOT NULL,
    dataset_size integer NOT NULL,
    training_date timestamp with time zone NOT NULL,
    evaluation_date timestamp with time zone DEFAULT now() NOT NULL,
    is_production_model boolean DEFAULT false NOT NULL,
    CONSTRAINT ml_model_performance_metric_type_check CHECK ((metric_type = ANY (ARRAY['accuracy'::text, 'precision'::text, 'recall'::text, 'f1_score'::text, 'auc_roc'::text, 'mae'::text, 'rmse'::text])))
);


ALTER TABLE public.ml_model_performance OWNER TO vikasalagarsamy;

--
-- Name: ml_model_performance_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.ml_model_performance_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ml_model_performance_id_seq OWNER TO vikasalagarsamy;

--
-- Name: ml_model_performance_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.ml_model_performance_id_seq OWNED BY public.ml_model_performance.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    title character varying(255),
    description text,
    department_id integer,
    responsibilities text[],
    required_skills text[],
    is_management boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    is_system_role boolean DEFAULT false,
    is_admin boolean DEFAULT false,
    name text DEFAULT 'Unnamed Role'::text NOT NULL,
    permissions jsonb DEFAULT '{}'::jsonb
);


ALTER TABLE public.roles OWNER TO vikasalagarsamy;

--
-- Name: user_accounts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_accounts (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    role_id integer NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    is_active boolean DEFAULT true,
    last_login timestamp without time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_accounts OWNER TO vikasalagarsamy;

--
-- Name: mv_user_roles_fast; Type: MATERIALIZED VIEW; Schema: public; Owner: vikasalagarsamy
--

CREATE MATERIALIZED VIEW public.mv_user_roles_fast AS
 SELECT ua.id AS user_id,
    ua.email,
    ua.username,
    ua.password_hash,
    ua.role_id,
    r.title AS role_name,
    r.permissions AS role_permissions,
        CASE
            WHEN ((r.title)::text = 'Administrator'::text) THEN true
            ELSE false
        END AS is_admin,
    ua.created_at,
    ua.updated_at
   FROM (public.user_accounts ua
     LEFT JOIN public.roles r ON ((ua.role_id = r.id)))
  WITH NO DATA;


ALTER TABLE public.mv_user_roles_fast OWNER TO vikasalagarsamy;

--
-- Name: notification_batches; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_batches (
    id integer NOT NULL,
    user_id integer NOT NULL,
    notification_type character varying(100) NOT NULL,
    batch_key character varying(200) NOT NULL,
    last_sent timestamp with time zone DEFAULT now(),
    count integer DEFAULT 1,
    metadata jsonb
);


ALTER TABLE public.notification_batches OWNER TO vikasalagarsamy;

--
-- Name: notification_batches_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.notification_batches_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notification_batches_id_seq OWNER TO vikasalagarsamy;

--
-- Name: notification_batches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.notification_batches_id_seq OWNED BY public.notification_batches.id;


--
-- Name: notification_engagement; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_engagement (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    notification_id text NOT NULL,
    user_id uuid NOT NULL,
    event_type text NOT NULL,
    engagement_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT notification_engagement_event_type_check CHECK ((event_type = ANY (ARRAY['delivered'::text, 'viewed'::text, 'clicked'::text, 'dismissed'::text])))
);


ALTER TABLE public.notification_engagement OWNER TO vikasalagarsamy;

--
-- Name: notification_patterns; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_patterns (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    type text NOT NULL,
    frequency integer DEFAULT 1,
    engagement_rate numeric(3,2) DEFAULT 0.5,
    optimal_timing integer[] DEFAULT ARRAY[9, 14, 16],
    user_segments text[] DEFAULT ARRAY['general'::text],
    success_metrics jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.notification_patterns OWNER TO vikasalagarsamy;

--
-- Name: notifications; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notifications (
    id text NOT NULL,
    type text NOT NULL,
    priority text DEFAULT 'medium'::text NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    quotation_id integer,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone,
    action_url text,
    action_label text,
    metadata jsonb,
    scheduled_for timestamp with time zone DEFAULT now(),
    ai_enhanced boolean DEFAULT false,
    recipient_role character varying(50),
    recipient_id integer,
    data jsonb,
    read_at timestamp with time zone,
    target_user uuid,
    employee_id integer,
    CONSTRAINT chk_notifications_priority CHECK ((priority = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'urgent'::text]))),
    CONSTRAINT notifications_priority_check CHECK ((priority = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text, 'urgent'::text]))),
    CONSTRAINT notifications_type_check CHECK ((type = ANY (ARRAY['overdue'::text, 'approval_needed'::text, 'payment_received'::text, 'client_followup'::text, 'automation'::text, 'system'::text])))
);


ALTER TABLE public.notifications OWNER TO vikasalagarsamy;

--
-- Name: notification_performance_metrics; Type: VIEW; Schema: public; Owner: vikasalagarsamy
--

CREATE VIEW public.notification_performance_metrics AS
 SELECT n.type,
    n.priority,
    count(*) AS total_sent,
    count(
        CASE
            WHEN (ne.event_type = 'viewed'::text) THEN 1
            ELSE NULL::integer
        END) AS total_viewed,
    count(
        CASE
            WHEN (ne.event_type = 'clicked'::text) THEN 1
            ELSE NULL::integer
        END) AS total_clicked,
    count(
        CASE
            WHEN (ne.event_type = 'dismissed'::text) THEN 1
            ELSE NULL::integer
        END) AS total_dismissed,
    round((((count(
        CASE
            WHEN (ne.event_type = 'viewed'::text) THEN 1
            ELSE NULL::integer
        END))::numeric / (count(*))::numeric) * (100)::numeric), 2) AS view_rate,
    round((((count(
        CASE
            WHEN (ne.event_type = 'clicked'::text) THEN 1
            ELSE NULL::integer
        END))::numeric / (count(*))::numeric) * (100)::numeric), 2) AS click_rate,
    avg(EXTRACT(epoch FROM (ne.created_at - n.created_at))) AS avg_response_time
   FROM (public.notifications n
     LEFT JOIN public.notification_engagement ne ON ((n.id = ne.notification_id)))
  WHERE (n.created_at >= (now() - '30 days'::interval))
  GROUP BY n.type, n.priority;


ALTER TABLE public.notification_performance_metrics OWNER TO vikasalagarsamy;

--
-- Name: notification_preferences; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_preferences (
    user_id uuid NOT NULL,
    email_notifications boolean DEFAULT true,
    push_notifications boolean DEFAULT true,
    permission_changes boolean DEFAULT true,
    role_assignments boolean DEFAULT true,
    admin_role_changes boolean DEFAULT true,
    security_permission_changes boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notification_preferences OWNER TO vikasalagarsamy;

--
-- Name: notification_recipients; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_recipients (
    notification_id integer NOT NULL,
    user_id uuid NOT NULL,
    is_read boolean DEFAULT false,
    is_dismissed boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.notification_recipients OWNER TO vikasalagarsamy;

--
-- Name: notification_rules; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_rules (
    id text DEFAULT (gen_random_uuid())::text NOT NULL,
    name text NOT NULL,
    trigger_type text NOT NULL,
    conditions jsonb DEFAULT '{}'::jsonb NOT NULL,
    recipients text[] DEFAULT '{}'::text[] NOT NULL,
    template_id text,
    enabled boolean DEFAULT true NOT NULL,
    created_by integer NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT notification_rules_trigger_type_check CHECK ((trigger_type = ANY (ARRAY['overdue'::text, 'approval_needed'::text, 'payment_received'::text, 'client_followup'::text, 'automation'::text, 'system'::text])))
);


ALTER TABLE public.notification_rules OWNER TO vikasalagarsamy;

--
-- Name: notification_settings; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.notification_settings (
    user_id integer NOT NULL,
    email_enabled boolean DEFAULT true NOT NULL,
    in_app_enabled boolean DEFAULT true NOT NULL,
    overdue_alerts boolean DEFAULT true NOT NULL,
    approval_alerts boolean DEFAULT true NOT NULL,
    payment_alerts boolean DEFAULT true NOT NULL,
    automation_alerts boolean DEFAULT true NOT NULL,
    email_frequency text DEFAULT 'immediate'::text NOT NULL,
    quiet_hours_start time without time zone,
    quiet_hours_end time without time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT notification_settings_email_frequency_check CHECK ((email_frequency = ANY (ARRAY['immediate'::text, 'daily'::text, 'weekly'::text])))
);


ALTER TABLE public.notification_settings OWNER TO vikasalagarsamy;

--
-- Name: partners; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.partners (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    contact_person character varying(200),
    email character varying(255),
    phone character varying(50),
    address text,
    partnership_type character varying(100),
    partnership_start_date date,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.partners OWNER TO vikasalagarsamy;

--
-- Name: partners_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.partners_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.partners_id_seq OWNER TO vikasalagarsamy;

--
-- Name: partners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.partners_id_seq OWNED BY public.partners.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    quotation_id integer,
    amount numeric(12,2) NOT NULL,
    payment_type character varying(20) NOT NULL,
    payment_method character varying(50) NOT NULL,
    payment_reference character varying(100) NOT NULL,
    paid_by character varying(255) NOT NULL,
    status character varying(20) DEFAULT 'received'::character varying,
    received_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT payments_payment_type_check CHECK (((payment_type)::text = ANY (ARRAY[('advance'::character varying)::text, ('partial'::character varying)::text, ('full'::character varying)::text])))
);


ALTER TABLE public.payments OWNER TO vikasalagarsamy;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.payments_id_seq OWNER TO vikasalagarsamy;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.permissions (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    category character varying(100) NOT NULL,
    resource character varying(100),
    action character varying(100),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(50) DEFAULT 'active'::character varying
);


ALTER TABLE public.permissions OWNER TO vikasalagarsamy;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: personalization_learning; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.personalization_learning (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    interaction_type text NOT NULL,
    interaction_data jsonb NOT NULL,
    outcome_positive boolean,
    learning_weight numeric(3,2) DEFAULT 1.0,
    context_tags text[] DEFAULT '{}'::text[],
    session_id text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.personalization_learning OWNER TO vikasalagarsamy;

--
-- Name: post_sale_confirmations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.post_sale_confirmations (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    confirmed_by_user_id uuid NOT NULL,
    confirmation_date timestamp without time zone DEFAULT now() NOT NULL,
    call_date date NOT NULL,
    call_time time without time zone NOT NULL,
    call_duration integer DEFAULT 30 NOT NULL,
    client_contact_person character varying(255) NOT NULL,
    confirmation_method character varying(50) DEFAULT 'phone'::character varying NOT NULL,
    services_confirmed jsonb DEFAULT '[]'::jsonb,
    deliverables_confirmed jsonb DEFAULT '[]'::jsonb,
    event_details_confirmed jsonb DEFAULT '{}'::jsonb,
    client_satisfaction_rating integer DEFAULT 5,
    client_expectations text NOT NULL,
    client_concerns text,
    additional_requests text,
    call_summary text NOT NULL,
    action_items text,
    follow_up_required boolean DEFAULT false,
    follow_up_date date,
    attachments jsonb DEFAULT '[]'::jsonb,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT post_sale_confirmations_client_satisfaction_rating_check CHECK (((client_satisfaction_rating >= 1) AND (client_satisfaction_rating <= 5)))
);


ALTER TABLE public.post_sale_confirmations OWNER TO vikasalagarsamy;

--
-- Name: post_sale_confirmations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.post_sale_confirmations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_sale_confirmations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: post_sale_confirmations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.post_sale_confirmations_id_seq OWNED BY public.post_sale_confirmations.id;


--
-- Name: post_sales_workflows; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.post_sales_workflows (
    id integer NOT NULL,
    quotation_id integer,
    payment_id integer,
    instruction_id integer,
    client_name character varying(255) NOT NULL,
    status character varying(30) DEFAULT 'pending_confirmation'::character varying,
    instructions jsonb,
    confirmed_by character varying(255),
    confirmed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.post_sales_workflows OWNER TO vikasalagarsamy;

--
-- Name: post_sales_workflows_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.post_sales_workflows_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.post_sales_workflows_id_seq OWNER TO vikasalagarsamy;

--
-- Name: post_sales_workflows_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.post_sales_workflows_id_seq OWNED BY public.post_sales_workflows.id;


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    full_name character varying(255),
    avatar_url text,
    job_title character varying(255),
    department character varying(255),
    location character varying(255),
    phone character varying(50),
    bio text,
    employee_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.profiles OWNER TO vikasalagarsamy;

--
-- Name: query_performance_logs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.query_performance_logs (
    id integer NOT NULL,
    view_name text,
    rows_returned integer,
    execution_time_ms double precision,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.query_performance_logs OWNER TO vikasalagarsamy;

--
-- Name: query_performance_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.query_performance_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.query_performance_logs_id_seq OWNER TO vikasalagarsamy;

--
-- Name: query_performance_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.query_performance_logs_id_seq OWNED BY public.query_performance_logs.id;


--
-- Name: quotation_approvals; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_approvals (
    id integer NOT NULL,
    quotation_id integer,
    approval_status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    approval_date timestamp without time zone,
    comments text,
    price_adjustments jsonb,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    approver_user_id integer NOT NULL,
    CONSTRAINT valid_approval_status CHECK (((approval_status)::text = ANY (ARRAY[('pending'::character varying)::text, ('approved'::character varying)::text, ('rejected'::character varying)::text])))
);


ALTER TABLE public.quotation_approvals OWNER TO vikasalagarsamy;

--
-- Name: TABLE quotation_approvals; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.quotation_approvals IS 'Tracks approval workflow for quotations including Sales Head approvals';


--
-- Name: quotation_approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_approvals_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_approvals_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_approvals_id_seq OWNED BY public.quotation_approvals.id;


--
-- Name: quotation_business_lifecycle; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_business_lifecycle (
    id integer NOT NULL,
    quotation_id integer,
    current_stage character varying(30) DEFAULT 'quotation_sent'::character varying NOT NULL,
    stage_history jsonb[],
    probability_score integer,
    last_client_interaction timestamp without time zone,
    next_follow_up_due timestamp without time zone,
    days_in_pipeline integer DEFAULT 0,
    revision_count integer DEFAULT 0,
    ai_insights text,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT quotation_business_lifecycle_probability_score_check CHECK (((probability_score >= 0) AND (probability_score <= 100)))
);


ALTER TABLE public.quotation_business_lifecycle OWNER TO vikasalagarsamy;

--
-- Name: quotation_business_lifecycle_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_business_lifecycle_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_business_lifecycle_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_business_lifecycle_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_business_lifecycle_id_seq OWNED BY public.quotation_business_lifecycle.id;


--
-- Name: quotation_edit_approvals; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_edit_approvals (
    id bigint NOT NULL,
    quotation_id bigint NOT NULL,
    requested_by integer NOT NULL,
    approved_by integer,
    original_data jsonb NOT NULL,
    modified_data jsonb NOT NULL,
    changes_summary text,
    edit_reason text,
    original_amount numeric(12,2) DEFAULT 0,
    modified_amount numeric(12,2) DEFAULT 0,
    amount_difference numeric(12,2) DEFAULT 0,
    percentage_change numeric(5,2) DEFAULT 0,
    approval_status character varying(20) DEFAULT 'pending'::character varying,
    approval_date timestamp with time zone,
    approval_comments text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT quotation_edit_approvals_approval_status_check CHECK (((approval_status)::text = ANY (ARRAY[('pending'::character varying)::text, ('approved'::character varying)::text, ('rejected'::character varying)::text])))
);


ALTER TABLE public.quotation_edit_approvals OWNER TO vikasalagarsamy;

--
-- Name: TABLE quotation_edit_approvals; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.quotation_edit_approvals IS 'Tracks quotation edit approval requests with integer employee IDs for compatibility';


--
-- Name: quotation_edit_approvals_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_edit_approvals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_edit_approvals_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_edit_approvals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_edit_approvals_id_seq OWNED BY public.quotation_edit_approvals.id;


--
-- Name: quotation_events; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_events (
    id integer NOT NULL,
    quotation_id integer,
    event_name character varying(255) NOT NULL,
    event_date timestamp with time zone NOT NULL,
    event_location character varying(255) NOT NULL,
    venue_name character varying(255) NOT NULL,
    start_time character varying(10) NOT NULL,
    end_time character varying(10) NOT NULL,
    expected_crowd character varying(100),
    selected_package character varying(20) NOT NULL,
    selected_services jsonb DEFAULT '[]'::jsonb,
    selected_deliverables jsonb DEFAULT '[]'::jsonb,
    service_overrides jsonb DEFAULT '{}'::jsonb,
    package_overrides jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.quotation_events OWNER TO vikasalagarsamy;

--
-- Name: quotation_events_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_events_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_events_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_events_id_seq OWNED BY public.quotation_events.id;


--
-- Name: quotation_predictions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_predictions (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    success_probability numeric(5,4) NOT NULL,
    confidence_score numeric(5,4) NOT NULL,
    prediction_factors jsonb DEFAULT '{}'::jsonb NOT NULL,
    model_version text DEFAULT 'v1.0'::text NOT NULL,
    predicted_at timestamp with time zone DEFAULT now() NOT NULL,
    actual_outcome text,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT quotation_predictions_actual_outcome_check CHECK ((actual_outcome = ANY (ARRAY['won'::text, 'lost'::text, 'pending'::text, NULL::text])))
);


ALTER TABLE public.quotation_predictions OWNER TO vikasalagarsamy;

--
-- Name: quotation_predictions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_predictions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_predictions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_predictions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_predictions_id_seq OWNED BY public.quotation_predictions.id;


--
-- Name: quotation_revisions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_revisions (
    id integer NOT NULL,
    original_quotation_id integer,
    revision_number integer NOT NULL,
    revised_quotation_data jsonb NOT NULL,
    revision_reason text NOT NULL,
    revised_by character varying(255) NOT NULL,
    status character varying(20) DEFAULT 'pending_approval'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.quotation_revisions OWNER TO vikasalagarsamy;

--
-- Name: quotation_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_revisions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_revisions_id_seq OWNED BY public.quotation_revisions.id;


--
-- Name: quotations; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotations (
    id integer NOT NULL,
    lead_id integer,
    follow_up_id integer,
    quotation_number character varying(50) NOT NULL,
    client_name character varying(255) NOT NULL,
    bride_name character varying(255) NOT NULL,
    groom_name character varying(255) NOT NULL,
    mobile character varying(50) NOT NULL,
    whatsapp character varying(50),
    alternate_mobile character varying(50),
    alternate_whatsapp character varying(50),
    email character varying(255) NOT NULL,
    default_package character varying(20) NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    status character varying(20) DEFAULT 'draft'::character varying,
    quotation_data jsonb NOT NULL,
    events_count integer DEFAULT 1,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    slug text,
    workflow_status character varying(50) DEFAULT 'draft'::character varying,
    client_verbal_confirmation_date timestamp without time zone,
    payment_received_date timestamp without time zone,
    payment_amount numeric(12,2),
    payment_reference character varying(100),
    confirmation_required boolean DEFAULT true,
    created_by integer NOT NULL,
    revision_notes text,
    client_feedback text,
    negotiation_history jsonb DEFAULT '[]'::jsonb,
    revision_count integer DEFAULT 0,
    CONSTRAINT quotations_status_check CHECK (((status)::text = ANY (ARRAY[('draft'::character varying)::text, ('sent'::character varying)::text, ('approved'::character varying)::text, ('rejected'::character varying)::text, ('expired'::character varying)::text]))),
    CONSTRAINT valid_workflow_status CHECK (((workflow_status)::text = ANY (ARRAY[('draft'::character varying)::text, ('pending_client_confirmation'::character varying)::text, ('pending_approval'::character varying)::text, ('approved'::character varying)::text, ('payment_received'::character varying)::text, ('confirmed'::character varying)::text, ('rejected'::character varying)::text, ('cancelled'::character varying)::text])))
);


ALTER TABLE public.quotations OWNER TO vikasalagarsamy;

--
-- Name: COLUMN quotations.workflow_status; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.quotations.workflow_status IS 'Current stage in the quotation workflow process';


--
-- Name: COLUMN quotations.revision_notes; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.quotations.revision_notes IS 'Notes about why the quotation was revised';


--
-- Name: COLUMN quotations.client_feedback; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.quotations.client_feedback IS 'Feedback received from client during negotiation';


--
-- Name: COLUMN quotations.negotiation_history; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.quotations.negotiation_history IS 'JSON array tracking all price negotiations and revisions';


--
-- Name: COLUMN quotations.revision_count; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.quotations.revision_count IS 'Number of times this quotation has been revised';


--
-- Name: quotation_workflow_analytics; Type: VIEW; Schema: public; Owner: vikasalagarsamy
--

CREATE VIEW public.quotation_workflow_analytics AS
 SELECT q.id,
    q.quotation_number,
    q.client_name,
    q.total_amount,
    q.status,
    q.workflow_status,
    q.revision_count,
    q.created_at AS quotation_created,
    q.updated_at AS last_updated,
    qa.approval_status,
    qa.approval_date,
    qa.comments AS approval_comments,
    count(
        CASE
            WHEN ((at.task_type)::text = 'quotation_approval'::text) THEN 1
            ELSE NULL::integer
        END) AS approval_tasks_count,
    count(
        CASE
            WHEN ((at.task_type)::text = 'client_followup'::text) THEN 1
            ELSE NULL::integer
        END) AS followup_tasks_count,
    count(
        CASE
            WHEN ((at.task_type)::text = 'quotation_revision'::text) THEN 1
            ELSE NULL::integer
        END) AS revision_tasks_count,
    (EXTRACT(epoch FROM ((qa.approval_date)::timestamp with time zone - q.created_at)) / (3600)::numeric) AS hours_to_approval,
    ((EXTRACT(epoch FROM (CURRENT_TIMESTAMP - q.created_at)) / (24)::numeric) / (3600)::numeric) AS days_in_pipeline,
        CASE
            WHEN (jsonb_array_length(q.negotiation_history) > 0) THEN (((q.negotiation_history -> 0) ->> 'discount_percent'::text))::numeric
            ELSE (0)::numeric
        END AS max_discount_percent
   FROM ((public.quotations q
     LEFT JOIN public.quotation_approvals qa ON ((q.id = qa.quotation_id)))
     LEFT JOIN public.ai_tasks at ON ((q.id = at.quotation_id)))
  GROUP BY q.id, q.quotation_number, q.client_name, q.total_amount, q.status, q.workflow_status, q.revision_count, q.created_at, q.updated_at, qa.approval_status, qa.approval_date, qa.comments, q.negotiation_history
  ORDER BY q.created_at DESC;


ALTER TABLE public.quotation_workflow_analytics OWNER TO vikasalagarsamy;

--
-- Name: VIEW quotation_workflow_analytics; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON VIEW public.quotation_workflow_analytics IS 'Analytics view for quotation workflow performance metrics';


--
-- Name: quotation_workflow_history; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotation_workflow_history (
    id integer NOT NULL,
    quotation_id integer NOT NULL,
    action character varying(50) NOT NULL,
    performed_at timestamp without time zone DEFAULT now() NOT NULL,
    comments text,
    performed_by integer NOT NULL
);


ALTER TABLE public.quotation_workflow_history OWNER TO vikasalagarsamy;

--
-- Name: quotation_workflow_history_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotation_workflow_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotation_workflow_history_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotation_workflow_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotation_workflow_history_id_seq OWNED BY public.quotation_workflow_history.id;


--
-- Name: quotations_backup_before_migration; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quotations_backup_before_migration (
    id integer,
    lead_id integer,
    follow_up_id integer,
    quotation_number character varying(50),
    client_name character varying(255),
    bride_name character varying(255),
    groom_name character varying(255),
    mobile character varying(50),
    whatsapp character varying(50),
    alternate_mobile character varying(50),
    alternate_whatsapp character varying(50),
    email character varying(255),
    default_package character varying(20),
    total_amount numeric(10,2),
    status character varying(20),
    created_by uuid,
    quotation_data jsonb,
    events_count integer,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    slug text,
    workflow_status character varying(50),
    client_verbal_confirmation_date timestamp without time zone,
    payment_received_date timestamp without time zone,
    payment_amount numeric(12,2),
    payment_reference character varying(100),
    confirmation_required boolean
);


ALTER TABLE public.quotations_backup_before_migration OWNER TO vikasalagarsamy;

--
-- Name: quotations_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quotations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quotations_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quotations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quotations_id_seq OWNED BY public.quotations.id;


--
-- Name: quote_components; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quote_components (
    id integer NOT NULL,
    quote_id integer NOT NULL,
    component_type character varying(50) NOT NULL,
    component_name character varying(255) NOT NULL,
    component_description text,
    unit_price numeric(10,2),
    quantity integer DEFAULT 1,
    subtotal numeric(10,2) NOT NULL,
    metadata jsonb,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_component_type CHECK (((component_type)::text = ANY (ARRAY[('service'::character varying)::text, ('deliverable'::character varying)::text, ('addon'::character varying)::text, ('discount'::character varying)::text, ('custom'::character varying)::text])))
);


ALTER TABLE public.quote_components OWNER TO vikasalagarsamy;

--
-- Name: TABLE quote_components; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.quote_components IS 'Flexible quote components for future extensions';


--
-- Name: quote_components_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quote_components_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_components_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quote_components_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quote_components_id_seq OWNED BY public.quote_components.id;


--
-- Name: quote_deliverables_snapshot; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quote_deliverables_snapshot (
    id integer NOT NULL,
    quote_id integer NOT NULL,
    deliverable_id integer NOT NULL,
    deliverable_name character varying(255) NOT NULL,
    deliverable_type character varying(50) NOT NULL,
    process_name character varying(255) NOT NULL,
    package_type character varying(20) NOT NULL,
    tat integer,
    timing_type character varying(20),
    sort_order integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_deliverable_package_type CHECK (((package_type)::text = ANY (ARRAY[('basic'::character varying)::text, ('premium'::character varying)::text, ('elite'::character varying)::text])))
);


ALTER TABLE public.quote_deliverables_snapshot OWNER TO vikasalagarsamy;

--
-- Name: TABLE quote_deliverables_snapshot; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.quote_deliverables_snapshot IS 'Deliverables snapshot for quotes';


--
-- Name: quote_deliverables_snapshot_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quote_deliverables_snapshot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_deliverables_snapshot_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quote_deliverables_snapshot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quote_deliverables_snapshot_id_seq OWNED BY public.quote_deliverables_snapshot.id;


--
-- Name: quote_services_snapshot; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.quote_services_snapshot (
    id integer NOT NULL,
    quote_id integer NOT NULL,
    service_id integer NOT NULL,
    service_name character varying(255) NOT NULL,
    package_type character varying(20) NOT NULL,
    locked_price numeric(10,2) NOT NULL,
    quantity integer DEFAULT 1,
    subtotal numeric(10,2) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_package_type CHECK (((package_type)::text = ANY (ARRAY[('basic'::character varying)::text, ('premium'::character varying)::text, ('elite'::character varying)::text])))
);


ALTER TABLE public.quote_services_snapshot OWNER TO vikasalagarsamy;

--
-- Name: TABLE quote_services_snapshot; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.quote_services_snapshot IS 'Price-locked services for quotes';


--
-- Name: quote_services_snapshot_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.quote_services_snapshot_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.quote_services_snapshot_id_seq OWNER TO vikasalagarsamy;

--
-- Name: quote_services_snapshot_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.quote_services_snapshot_id_seq OWNED BY public.quote_services_snapshot.id;


--
-- Name: recent_business_notifications; Type: VIEW; Schema: public; Owner: vikasalagarsamy
--

CREATE VIEW public.recent_business_notifications AS
 SELECT n.id,
    n.type,
    n.priority,
    n.title,
    n.message,
    n.quotation_id,
    n.is_read,
    n.created_at,
    n.expires_at,
    n.action_url,
    n.action_label,
    n.metadata,
    n.scheduled_for,
    n.ai_enhanced,
    n.recipient_role,
    n.recipient_id,
    n.data,
    n.read_at,
    n.target_user,
    n.employee_id
   FROM public.notifications n
  WHERE (n.created_at >= (now() - '30 days'::interval));


ALTER TABLE public.recent_business_notifications OWNER TO vikasalagarsamy;

--
-- Name: rejected_leads_view; Type: VIEW; Schema: public; Owner: vikasalagarsamy
--

CREATE VIEW public.rejected_leads_view AS
 SELECT l.id,
    l.lead_number,
    l.client_name,
    l.status,
    l.company_id,
    l.branch_id,
    l.created_at,
    l.updated_at,
    c.name AS company_name,
    b.name AS branch_name,
    COALESCE(l.rejection_reason, a.description, 'No reason provided'::text) AS rejection_details,
    COALESCE(l.rejected_at, a.created_at, l.updated_at) AS rejection_timestamp,
    COALESCE((l.rejected_by)::text, (a.user_name)::text) AS rejection_user
   FROM (((public.leads l
     LEFT JOIN public.companies c ON ((l.company_id = c.id)))
     LEFT JOIN public.branches b ON ((l.branch_id = b.id)))
     LEFT JOIN ( SELECT DISTINCT ON (activities.entity_id) activities.entity_id,
            activities.description,
            activities.created_at,
            activities.user_name
           FROM public.activities
          WHERE ((activities.action_type)::text = 'reject'::text)
          ORDER BY activities.entity_id, activities.created_at DESC) a ON (((l.id)::text = a.entity_id)))
  WHERE ((l.status)::text = 'REJECTED'::text);


ALTER TABLE public.rejected_leads_view OWNER TO vikasalagarsamy;

--
-- Name: revenue_forecasts; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.revenue_forecasts (
    id integer NOT NULL,
    forecast_period text NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    predicted_revenue numeric(15,2) NOT NULL,
    confidence_interval_low numeric(15,2) NOT NULL,
    confidence_interval_high numeric(15,2) NOT NULL,
    contributing_factors jsonb DEFAULT '{}'::jsonb NOT NULL,
    model_metrics jsonb DEFAULT '{}'::jsonb NOT NULL,
    actual_revenue numeric(15,2),
    forecast_accuracy numeric(5,4),
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.revenue_forecasts OWNER TO vikasalagarsamy;

--
-- Name: revenue_forecasts_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.revenue_forecasts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.revenue_forecasts_id_seq OWNER TO vikasalagarsamy;

--
-- Name: revenue_forecasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.revenue_forecasts_id_seq OWNED BY public.revenue_forecasts.id;


--
-- Name: role_menu_access; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.role_menu_access (
    id integer NOT NULL,
    role_name character varying(100) NOT NULL,
    menu_id character varying(100) NOT NULL,
    has_access boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.role_menu_access OWNER TO vikasalagarsamy;

--
-- Name: role_menu_access_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.role_menu_access_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_menu_access_id_seq OWNER TO vikasalagarsamy;

--
-- Name: role_menu_access_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.role_menu_access_id_seq OWNED BY public.role_menu_access.id;


--
-- Name: role_menu_permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.role_menu_permissions (
    id integer NOT NULL,
    role_id integer NOT NULL,
    can_view boolean DEFAULT false,
    can_add boolean DEFAULT false,
    can_edit boolean DEFAULT false,
    can_delete boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    created_by uuid,
    updated_by uuid,
    description text,
    menu_string_id character varying(100) NOT NULL
);


ALTER TABLE public.role_menu_permissions OWNER TO vikasalagarsamy;

--
-- Name: role_menu_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.role_menu_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_menu_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: role_menu_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.role_menu_permissions_id_seq OWNED BY public.role_menu_permissions.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.role_permissions (
    id integer NOT NULL,
    role_id integer,
    permission_id integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status character varying(50) DEFAULT 'active'::character varying
);


ALTER TABLE public.role_permissions OWNER TO vikasalagarsamy;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.role_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.role_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.roles_id_seq OWNER TO vikasalagarsamy;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: sales_activities; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sales_activities (
    id integer NOT NULL,
    employee_id text NOT NULL,
    quotation_id integer,
    activity_type text NOT NULL,
    activity_description text NOT NULL,
    activity_outcome text,
    time_spent_minutes integer DEFAULT 0,
    activity_date timestamp with time zone DEFAULT now() NOT NULL,
    notes text,
    client_name text,
    deal_value numeric(15,2),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT sales_activities_activity_type_check CHECK ((activity_type = ANY (ARRAY['quotation_created'::text, 'quotation_sent'::text, 'follow_up_call'::text, 'follow_up_email'::text, 'client_meeting'::text, 'site_visit'::text, 'proposal_revision'::text, 'negotiation'::text, 'contract_signed'::text, 'deal_lost'::text, 'client_referral'::text])))
);


ALTER TABLE public.sales_activities OWNER TO vikasalagarsamy;

--
-- Name: sales_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sales_activities_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_activities_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sales_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sales_activities_id_seq OWNED BY public.sales_activities.id;


--
-- Name: sales_performance_metrics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sales_performance_metrics (
    id integer NOT NULL,
    employee_id text NOT NULL,
    metric_period date NOT NULL,
    quotations_created integer DEFAULT 0 NOT NULL,
    quotations_converted integer DEFAULT 0 NOT NULL,
    total_revenue_generated numeric(15,2) DEFAULT 0 NOT NULL,
    avg_deal_size numeric(15,2) DEFAULT 0 NOT NULL,
    avg_conversion_time_days integer DEFAULT 0 NOT NULL,
    follow_ups_completed integer DEFAULT 0 NOT NULL,
    client_meetings_held integer DEFAULT 0 NOT NULL,
    calls_made integer DEFAULT 0 NOT NULL,
    emails_sent integer DEFAULT 0 NOT NULL,
    conversion_rate numeric(5,4) DEFAULT 0 NOT NULL,
    activity_score numeric(5,2) DEFAULT 0 NOT NULL,
    performance_score numeric(5,2) DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sales_performance_metrics OWNER TO vikasalagarsamy;

--
-- Name: sales_performance_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sales_performance_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_performance_metrics_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sales_performance_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sales_performance_metrics_id_seq OWNED BY public.sales_performance_metrics.id;


--
-- Name: sales_team_members; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sales_team_members (
    id integer NOT NULL,
    employee_id text NOT NULL,
    full_name text NOT NULL,
    email text NOT NULL,
    phone text,
    role text NOT NULL,
    hire_date date NOT NULL,
    territory text,
    target_monthly numeric(15,2) DEFAULT 0,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT sales_team_members_role_check CHECK ((role = ANY (ARRAY['sales_rep'::text, 'senior_sales_rep'::text, 'sales_manager'::text, 'sales_head'::text])))
);


ALTER TABLE public.sales_team_members OWNER TO vikasalagarsamy;

--
-- Name: sales_team_members_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sales_team_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sales_team_members_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sales_team_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sales_team_members_id_seq OWNED BY public.sales_team_members.id;


--
-- Name: sequence_rules; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sequence_rules (
    id integer NOT NULL,
    sequence_template_id integer,
    rule_type character varying(100) NOT NULL,
    condition_field character varying(100) NOT NULL,
    condition_operator character varying(20) NOT NULL,
    condition_value text NOT NULL,
    action_type character varying(100) NOT NULL,
    action_data jsonb DEFAULT '{}'::jsonb,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sequence_rules OWNER TO vikasalagarsamy;

--
-- Name: TABLE sequence_rules; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.sequence_rules IS 'Conditional rules that modify sequence behavior';


--
-- Name: sequence_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sequence_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sequence_rules_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sequence_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sequence_rules_id_seq OWNED BY public.sequence_rules.id;


--
-- Name: sequence_steps; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.sequence_steps (
    id integer NOT NULL,
    sequence_template_id integer,
    step_number integer NOT NULL,
    title character varying(255) NOT NULL,
    description text,
    icon character varying(50) DEFAULT 'target'::character varying,
    due_after_hours integer DEFAULT 24,
    priority character varying(20) DEFAULT 'medium'::character varying,
    is_conditional boolean DEFAULT false,
    condition_type character varying(100),
    condition_value text,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sequence_steps OWNER TO vikasalagarsamy;

--
-- Name: TABLE sequence_steps; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.sequence_steps IS 'Individual steps within task sequences';


--
-- Name: sequence_steps_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.sequence_steps_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sequence_steps_id_seq OWNER TO vikasalagarsamy;

--
-- Name: sequence_steps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.sequence_steps_id_seq OWNED BY public.sequence_steps.id;


--
-- Name: service_packages; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.service_packages (
    id integer NOT NULL,
    package_name character varying(50) NOT NULL,
    package_display_name character varying(100) NOT NULL,
    description text,
    is_active boolean DEFAULT true,
    sort_order integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_package_name CHECK (((package_name)::text = ANY (ARRAY[('basic'::character varying)::text, ('premium'::character varying)::text, ('elite'::character varying)::text])))
);


ALTER TABLE public.service_packages OWNER TO vikasalagarsamy;

--
-- Name: TABLE service_packages; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.service_packages IS 'Package definitions (Basic, Premium, Elite)';


--
-- Name: service_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.service_packages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.service_packages_id_seq OWNER TO vikasalagarsamy;

--
-- Name: service_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.service_packages_id_seq OWNED BY public.service_packages.id;


--
-- Name: services; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.services (
    id integer NOT NULL,
    servicename character varying(255) NOT NULL,
    status character varying(50) DEFAULT 'Active'::character varying NOT NULL,
    description text,
    category character varying(100),
    price numeric(10,2),
    unit character varying(50),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    basic_price numeric(10,2),
    premium_price numeric(10,2),
    elite_price numeric(10,2),
    package_included jsonb DEFAULT '{"basic": false, "elite": false, "premium": false}'::jsonb
);


ALTER TABLE public.services OWNER TO vikasalagarsamy;

--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.services_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.services_id_seq OWNER TO vikasalagarsamy;

--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: suppliers; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.suppliers (
    id integer NOT NULL,
    supplier_code character varying(20) NOT NULL,
    name character varying(100) NOT NULL,
    contact_person character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20) NOT NULL,
    address text NOT NULL,
    city character varying(50) NOT NULL,
    state character varying(50) NOT NULL,
    postal_code character varying(20) NOT NULL,
    country character varying(50) NOT NULL,
    category character varying(50) NOT NULL,
    tax_id character varying(50),
    payment_terms character varying(100),
    website character varying(255),
    notes text,
    status character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    lead_time character varying(100),
    CONSTRAINT suppliers_status_check CHECK (((status)::text = ANY (ARRAY[('active'::character varying)::text, ('inactive'::character varying)::text, ('blacklisted'::character varying)::text])))
);


ALTER TABLE public.suppliers OWNER TO vikasalagarsamy;

--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.suppliers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.suppliers_id_seq OWNER TO vikasalagarsamy;

--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.suppliers.id;


--
-- Name: system_logs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.system_logs (
    id integer NOT NULL,
    action character varying(100) NOT NULL,
    details jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.system_logs OWNER TO vikasalagarsamy;

--
-- Name: system_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.system_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.system_logs_id_seq OWNER TO vikasalagarsamy;

--
-- Name: system_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.system_logs_id_seq OWNED BY public.system_logs.id;


--
-- Name: task_dashboard_summary; Type: MATERIALIZED VIEW; Schema: public; Owner: vikasalagarsamy
--

CREATE MATERIALIZED VIEW public.task_dashboard_summary AS
 SELECT t.assigned_to_employee_id,
    count(*) AS total_tasks,
    count(
        CASE
            WHEN ((t.status)::text = 'completed'::text) THEN 1
            ELSE NULL::integer
        END) AS completed_tasks,
    count(
        CASE
            WHEN ((t.status)::text = 'pending'::text) THEN 1
            ELSE NULL::integer
        END) AS pending_tasks,
    count(
        CASE
            WHEN (t.quotation_id IS NOT NULL) THEN 1
            ELSE NULL::integer
        END) AS tasks_with_quotations,
    COALESCE(sum(t.estimated_value), (0)::numeric) AS total_value,
    COALESCE(sum(
        CASE
            WHEN ((t.status)::text = 'completed'::text) THEN t.estimated_value
            ELSE (0)::numeric
        END), (0)::numeric) AS completed_value,
    count(
        CASE
            WHEN (((t.task_type)::text = 'quotation_approval'::text) AND ((t.status)::text = 'pending'::text)) THEN 1
            ELSE NULL::integer
        END) AS pending_approvals
   FROM public.ai_tasks t
  WHERE (t.assigned_to_employee_id IS NOT NULL)
  GROUP BY t.assigned_to_employee_id
  WITH NO DATA;


ALTER TABLE public.task_dashboard_summary OWNER TO vikasalagarsamy;

--
-- Name: task_generation_log; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_generation_log (
    id integer NOT NULL,
    lead_id integer,
    quotation_id integer,
    rule_triggered character varying(100) NOT NULL,
    task_id integer,
    success boolean NOT NULL,
    error_message text,
    triggered_by character varying(100),
    triggered_at timestamp with time zone DEFAULT now(),
    metadata jsonb
);


ALTER TABLE public.task_generation_log OWNER TO vikasalagarsamy;

--
-- Name: task_generation_log_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_generation_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_generation_log_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_generation_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_generation_log_id_seq OWNED BY public.task_generation_log.id;


--
-- Name: task_performance_metrics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_performance_metrics (
    id integer NOT NULL,
    task_id integer NOT NULL,
    lead_id integer,
    quotation_id integer,
    assigned_to integer,
    created_date date NOT NULL,
    due_date date,
    completed_date date,
    days_to_complete integer,
    hours_estimated numeric(5,2),
    hours_actual numeric(5,2),
    efficiency_ratio numeric(5,2),
    priority_level character varying(20),
    was_overdue boolean DEFAULT false,
    quality_rating integer,
    revenue_impact numeric(15,2),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT task_performance_metrics_quality_rating_check CHECK (((quality_rating >= 1) AND (quality_rating <= 5)))
);


ALTER TABLE public.task_performance_metrics OWNER TO vikasalagarsamy;

--
-- Name: task_performance_metrics_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_performance_metrics_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_performance_metrics_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_performance_metrics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_performance_metrics_id_seq OWNED BY public.task_performance_metrics.id;


--
-- Name: task_sequence_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_sequence_templates (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    category character varying(100) DEFAULT 'sales_followup'::character varying,
    is_active boolean DEFAULT true,
    created_by character varying(100) DEFAULT 'Admin'::character varying,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.task_sequence_templates OWNER TO vikasalagarsamy;

--
-- Name: TABLE task_sequence_templates; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON TABLE public.task_sequence_templates IS 'Master templates for automated task sequences';


--
-- Name: task_sequence_templates_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_sequence_templates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_sequence_templates_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_sequence_templates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_sequence_templates_id_seq OWNED BY public.task_sequence_templates.id;


--
-- Name: task_status_history; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.task_status_history (
    id integer NOT NULL,
    task_id integer NOT NULL,
    from_status character varying(20),
    to_status character varying(20) NOT NULL,
    changed_at timestamp with time zone DEFAULT now(),
    changed_by character varying(100),
    notes text,
    metadata jsonb,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.task_status_history OWNER TO vikasalagarsamy;

--
-- Name: task_status_history_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.task_status_history_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.task_status_history_id_seq OWNER TO vikasalagarsamy;

--
-- Name: task_status_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.task_status_history_id_seq OWNED BY public.task_status_history.id;


--
-- Name: team_members; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.team_members (
    team_id integer NOT NULL,
    employee_id integer NOT NULL,
    joined_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.team_members OWNER TO vikasalagarsamy;

--
-- Name: team_performance_trends; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.team_performance_trends (
    id integer NOT NULL,
    period_start date NOT NULL,
    period_end date NOT NULL,
    total_quotations integer DEFAULT 0 NOT NULL,
    total_conversions integer DEFAULT 0 NOT NULL,
    total_revenue numeric(15,2) DEFAULT 0 NOT NULL,
    team_conversion_rate numeric(5,4) DEFAULT 0 NOT NULL,
    avg_deal_size numeric(15,2) DEFAULT 0 NOT NULL,
    avg_sales_cycle_days integer DEFAULT 0 NOT NULL,
    top_performer_id text,
    underperformer_id text,
    performance_variance numeric(8,4) DEFAULT 0 NOT NULL,
    team_activity_score numeric(5,2) DEFAULT 0 NOT NULL,
    coaching_opportunities integer DEFAULT 0 NOT NULL,
    process_improvements_needed integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.team_performance_trends OWNER TO vikasalagarsamy;

--
-- Name: team_performance_trends_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.team_performance_trends_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.team_performance_trends_id_seq OWNER TO vikasalagarsamy;

--
-- Name: team_performance_trends_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.team_performance_trends_id_seq OWNED BY public.team_performance_trends.id;


--
-- Name: teams; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.teams (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    department_id integer,
    team_lead_id integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.teams OWNER TO vikasalagarsamy;

--
-- Name: teams_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.teams_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.teams_id_seq OWNER TO vikasalagarsamy;

--
-- Name: teams_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.teams_id_seq OWNED BY public.teams.id;


--
-- Name: unified_role_permissions; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.unified_role_permissions (
    id integer NOT NULL,
    role_id integer NOT NULL,
    menu_string_id character varying(100) NOT NULL,
    can_view boolean DEFAULT false,
    can_add boolean DEFAULT false,
    can_edit boolean DEFAULT false,
    can_delete boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now()
);


ALTER TABLE public.unified_role_permissions OWNER TO vikasalagarsamy;

--
-- Name: unified_role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.unified_role_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.unified_role_permissions_id_seq OWNER TO vikasalagarsamy;

--
-- Name: unified_role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.unified_role_permissions_id_seq OWNED BY public.unified_role_permissions.id;


--
-- Name: user_accounts_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.user_accounts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_accounts_id_seq OWNER TO vikasalagarsamy;

--
-- Name: user_accounts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.user_accounts_id_seq OWNED BY public.user_accounts.id;


--
-- Name: user_activity_history; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_activity_history (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    activity_type text NOT NULL,
    activity_data jsonb DEFAULT '{}'::jsonb,
    session_id text,
    ip_address inet,
    user_agent text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_activity_history OWNER TO vikasalagarsamy;

--
-- Name: user_ai_profiles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_ai_profiles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    personality_type text DEFAULT 'balanced'::text,
    communication_style text DEFAULT 'formal'::text,
    preferred_content_length text DEFAULT 'medium'::text,
    engagement_patterns jsonb DEFAULT '{}'::jsonb,
    response_time_patterns jsonb DEFAULT '{}'::jsonb,
    content_preferences jsonb DEFAULT '{}'::jsonb,
    ai_learning_enabled boolean DEFAULT true,
    personalization_score numeric(3,2) DEFAULT 0.5,
    last_interaction timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_ai_profiles OWNER TO vikasalagarsamy;

--
-- Name: user_behavior_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_behavior_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    most_active_hours integer[] DEFAULT ARRAY[9, 10, 14, 15, 16],
    avg_response_time integer DEFAULT 1800,
    preferred_notification_types text[] DEFAULT ARRAY['system'::text],
    engagement_score numeric(3,2) DEFAULT 0.5,
    timezone text DEFAULT 'UTC'::text,
    device_types text[] DEFAULT ARRAY['web'::text],
    last_activity timestamp with time zone DEFAULT now(),
    total_notifications_received integer DEFAULT 0,
    total_notifications_read integer DEFAULT 0,
    average_read_time integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_behavior_analytics_engagement_score_check CHECK (((engagement_score >= (0)::numeric) AND (engagement_score <= (1)::numeric)))
);


ALTER TABLE public.user_behavior_analytics OWNER TO vikasalagarsamy;

--
-- Name: user_engagement_analytics; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_engagement_analytics (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    notification_id text,
    engagement_type text NOT NULL,
    engagement_value numeric(5,2) DEFAULT 1.0,
    channel text NOT NULL,
    device_type text,
    time_to_engage integer,
    context_data jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_engagement_analytics_engagement_type_check CHECK ((engagement_type = ANY (ARRAY['view'::text, 'click'::text, 'action'::text, 'dismiss'::text, 'share'::text])))
);


ALTER TABLE public.user_engagement_analytics OWNER TO vikasalagarsamy;

--
-- Name: user_engagement_summary; Type: VIEW; Schema: public; Owner: vikasalagarsamy
--

CREATE VIEW public.user_engagement_summary AS
 SELECT uba.user_id,
    uba.engagement_score,
    uba.total_notifications_received,
    uba.total_notifications_read,
    round(
        CASE
            WHEN (uba.total_notifications_received > 0) THEN (((uba.total_notifications_read)::numeric / (uba.total_notifications_received)::numeric) * (100)::numeric)
            ELSE (0)::numeric
        END, 2) AS read_rate,
    uba.avg_response_time,
    uba.most_active_hours,
    uba.last_activity
   FROM public.user_behavior_analytics uba;


ALTER TABLE public.user_engagement_summary OWNER TO vikasalagarsamy;

--
-- Name: user_id_mapping; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_id_mapping (
    numeric_id integer NOT NULL,
    uuid uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_id_mapping OWNER TO vikasalagarsamy;

--
-- Name: user_notification_summary; Type: VIEW; Schema: public; Owner: vikasalagarsamy
--

CREATE VIEW public.user_notification_summary AS
 SELECT n.employee_id,
    count(*) AS total_notifications,
    count(*) FILTER (WHERE (NOT n.is_read)) AS unread_notifications
   FROM public.notifications n
  GROUP BY n.employee_id;


ALTER TABLE public.user_notification_summary OWNER TO vikasalagarsamy;

--
-- Name: user_preferences; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_preferences (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    name text,
    include_name boolean DEFAULT false,
    channel_preferences text[] DEFAULT ARRAY['in_app'::text],
    quiet_hours_start integer DEFAULT 22,
    quiet_hours_end integer DEFAULT 8,
    frequency_limit integer DEFAULT 10,
    ai_optimization_enabled boolean DEFAULT true,
    personalization_level text DEFAULT 'medium'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT user_preferences_personalization_level_check CHECK ((personalization_level = ANY (ARRAY['low'::text, 'medium'::text, 'high'::text])))
);


ALTER TABLE public.user_preferences OWNER TO vikasalagarsamy;

--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.user_roles (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    permissions jsonb DEFAULT '{}'::jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.user_roles OWNER TO vikasalagarsamy;

--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.user_roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_roles_id_seq OWNER TO vikasalagarsamy;

--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying(255) NOT NULL,
    password character varying(255) NOT NULL,
    email character varying(255),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    employee_id character varying(50)
);


ALTER TABLE public.users OWNER TO vikasalagarsamy;

--
-- Name: COLUMN users.employee_id; Type: COMMENT; Schema: public; Owner: vikasalagarsamy
--

COMMENT ON COLUMN public.users.employee_id IS 'Employee ID for the user';


--
-- Name: v_package_deliverables; Type: VIEW; Schema: public; Owner: vikasalagarsamy
--

CREATE VIEW public.v_package_deliverables AS
 SELECT p.package_name,
    p.package_display_name,
    d.id AS deliverable_id,
    d.deliverable_name,
    d.deliverable_type,
    d.process_name,
    d.tat,
    d.timing_type,
    d.sort_order,
    ((d.package_included ->> (p.package_name)::text) = 'true'::text) AS is_included
   FROM (public.service_packages p
     CROSS JOIN public.deliverables d)
  WHERE (d.status = 1)
  ORDER BY p.sort_order, d.deliverable_type, d.sort_order;


ALTER TABLE public.v_package_deliverables OWNER TO vikasalagarsamy;

--
-- Name: v_package_services; Type: VIEW; Schema: public; Owner: vikasalagarsamy
--

CREATE VIEW public.v_package_services AS
 SELECT p.package_name,
    p.package_display_name,
    s.id AS service_id,
    s.servicename,
    s.category,
        CASE
            WHEN ((p.package_name)::text = 'basic'::text) THEN s.basic_price
            WHEN ((p.package_name)::text = 'premium'::text) THEN s.premium_price
            WHEN ((p.package_name)::text = 'elite'::text) THEN s.elite_price
            ELSE NULL::numeric
        END AS package_price,
    ((s.package_included ->> (p.package_name)::text) = 'true'::text) AS is_included
   FROM (public.service_packages p
     CROSS JOIN public.services s)
  WHERE ((s.status)::text = 'Active'::text)
  ORDER BY p.sort_order, s.servicename;


ALTER TABLE public.v_package_services OWNER TO vikasalagarsamy;

--
-- Name: vendors; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.vendors (
    id integer NOT NULL,
    vendor_code character varying(20) NOT NULL,
    name character varying(100) NOT NULL,
    contact_person character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    phone character varying(20) NOT NULL,
    address text NOT NULL,
    city character varying(50) NOT NULL,
    state character varying(50) NOT NULL,
    postal_code character varying(20) NOT NULL,
    country character varying(50) NOT NULL,
    category character varying(50) NOT NULL,
    tax_id character varying(50),
    payment_terms character varying(100),
    website character varying(255),
    notes text,
    status character varying(20) NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT vendors_status_check CHECK (((status)::text = ANY (ARRAY[('active'::character varying)::text, ('inactive'::character varying)::text, ('blacklisted'::character varying)::text])))
);


ALTER TABLE public.vendors OWNER TO vikasalagarsamy;

--
-- Name: vendors_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.vendors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vendors_id_seq OWNER TO vikasalagarsamy;

--
-- Name: vendors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.vendors_id_seq OWNED BY public.vendors.id;


--
-- Name: webhook_logs; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.webhook_logs (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    event_type text NOT NULL,
    payload jsonb NOT NULL,
    received_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.webhook_logs OWNER TO vikasalagarsamy;

--
-- Name: whatsapp_config; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.whatsapp_config (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    business_phone_number_id text NOT NULL,
    access_token text NOT NULL,
    webhook_verify_token text NOT NULL,
    webhook_url text NOT NULL,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.whatsapp_config OWNER TO vikasalagarsamy;

--
-- Name: whatsapp_messages; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.whatsapp_messages (
    id integer NOT NULL,
    quotation_id integer,
    client_phone character varying(20) NOT NULL,
    message_text text NOT NULL,
    message_type character varying(20) NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    interakt_message_id character varying(100),
    media_url text,
    media_type character varying(50),
    ai_analyzed boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT now(),
    updated_at timestamp without time zone DEFAULT now(),
    CONSTRAINT whatsapp_messages_message_type_check CHECK (((message_type)::text = ANY (ARRAY[('incoming'::character varying)::text, ('outgoing'::character varying)::text])))
);


ALTER TABLE public.whatsapp_messages OWNER TO vikasalagarsamy;

--
-- Name: whatsapp_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: vikasalagarsamy
--

CREATE SEQUENCE public.whatsapp_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.whatsapp_messages_id_seq OWNER TO vikasalagarsamy;

--
-- Name: whatsapp_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: vikasalagarsamy
--

ALTER SEQUENCE public.whatsapp_messages_id_seq OWNED BY public.whatsapp_messages.id;


--
-- Name: whatsapp_templates; Type: TABLE; Schema: public; Owner: vikasalagarsamy
--

CREATE TABLE public.whatsapp_templates (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    template_name text NOT NULL,
    template_type text NOT NULL,
    template_content text NOT NULL,
    variables jsonb DEFAULT '[]'::jsonb,
    language_code text DEFAULT 'en'::text,
    status text DEFAULT 'pending'::text,
    ai_optimized boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT whatsapp_templates_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'approved'::text, 'rejected'::text]))),
    CONSTRAINT whatsapp_templates_template_type_check CHECK ((template_type = ANY (ARRAY['notification'::text, 'marketing'::text, 'follow_up'::text, 'reminder'::text])))
);


ALTER TABLE public.whatsapp_templates OWNER TO vikasalagarsamy;

--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


ALTER TABLE realtime.messages OWNER TO vikasalagarsamy;

--
-- Name: messages_2025_06_15; Type: TABLE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TABLE realtime.messages_2025_06_15 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_06_15 OWNER TO vikasalagarsamy;

--
-- Name: messages_2025_06_16; Type: TABLE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TABLE realtime.messages_2025_06_16 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_06_16 OWNER TO vikasalagarsamy;

--
-- Name: messages_2025_06_17; Type: TABLE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TABLE realtime.messages_2025_06_17 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_06_17 OWNER TO vikasalagarsamy;

--
-- Name: messages_2025_06_18; Type: TABLE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TABLE realtime.messages_2025_06_18 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_06_18 OWNER TO vikasalagarsamy;

--
-- Name: messages_2025_06_19; Type: TABLE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TABLE realtime.messages_2025_06_19 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_06_19 OWNER TO vikasalagarsamy;

--
-- Name: messages_2025_06_20; Type: TABLE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TABLE realtime.messages_2025_06_20 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_06_20 OWNER TO vikasalagarsamy;

--
-- Name: messages_2025_06_21; Type: TABLE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TABLE realtime.messages_2025_06_21 (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


ALTER TABLE realtime.messages_2025_06_21 OWNER TO vikasalagarsamy;

--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE realtime.schema_migrations OWNER TO vikasalagarsamy;

--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);


ALTER TABLE realtime.subscription OWNER TO vikasalagarsamy;

--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: vikasalagarsamy
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text
);


ALTER TABLE storage.buckets OWNER TO vikasalagarsamy;

--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: vikasalagarsamy
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: vikasalagarsamy
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO vikasalagarsamy;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: vikasalagarsamy
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


ALTER TABLE storage.objects OWNER TO vikasalagarsamy;

--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: vikasalagarsamy
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: prefixes; Type: TABLE; Schema: storage; Owner: vikasalagarsamy
--

CREATE TABLE storage.prefixes (
    bucket_id text NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    level integer GENERATED ALWAYS AS (storage.get_level(name)) STORED NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE storage.prefixes OWNER TO vikasalagarsamy;

--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: vikasalagarsamy
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


ALTER TABLE storage.s3_multipart_uploads OWNER TO vikasalagarsamy;

--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: vikasalagarsamy
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE storage.s3_multipart_uploads_parts OWNER TO vikasalagarsamy;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: vikasalagarsamy
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO vikasalagarsamy;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: vikasalagarsamy
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: vikasalagarsamy
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE supabase_functions.hooks_id_seq OWNER TO vikasalagarsamy;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: vikasalagarsamy
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: vikasalagarsamy
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO vikasalagarsamy;

--
-- Name: schema_migrations; Type: TABLE; Schema: supabase_migrations; Owner: vikasalagarsamy
--

CREATE TABLE supabase_migrations.schema_migrations (
    version text NOT NULL,
    statements text[],
    name text
);


ALTER TABLE supabase_migrations.schema_migrations OWNER TO vikasalagarsamy;

--
-- Name: messages_2025_06_15; Type: TABLE ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_06_15 FOR VALUES FROM ('2025-06-15 00:00:00') TO ('2025-06-16 00:00:00');


--
-- Name: messages_2025_06_16; Type: TABLE ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_06_16 FOR VALUES FROM ('2025-06-16 00:00:00') TO ('2025-06-17 00:00:00');


--
-- Name: messages_2025_06_17; Type: TABLE ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_06_17 FOR VALUES FROM ('2025-06-17 00:00:00') TO ('2025-06-18 00:00:00');


--
-- Name: messages_2025_06_18; Type: TABLE ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_06_18 FOR VALUES FROM ('2025-06-18 00:00:00') TO ('2025-06-19 00:00:00');


--
-- Name: messages_2025_06_19; Type: TABLE ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_06_19 FOR VALUES FROM ('2025-06-19 00:00:00') TO ('2025-06-20 00:00:00');


--
-- Name: messages_2025_06_20; Type: TABLE ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_06_20 FOR VALUES FROM ('2025-06-20 00:00:00') TO ('2025-06-21 00:00:00');


--
-- Name: messages_2025_06_21; Type: TABLE ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages ATTACH PARTITION realtime.messages_2025_06_21 FOR VALUES FROM ('2025-06-21 00:00:00') TO ('2025-06-22 00:00:00');


--
-- Name: audit_trail id; Type: DEFAULT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.audit_trail ALTER COLUMN id SET DEFAULT nextval('audit_security.audit_trail_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.permissions ALTER COLUMN id SET DEFAULT nextval('audit_security.permissions_id_seq'::regclass);


--
-- Name: role_permissions id; Type: DEFAULT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.role_permissions ALTER COLUMN id SET DEFAULT nextval('audit_security.role_permissions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.roles ALTER COLUMN id SET DEFAULT nextval('audit_security.roles_id_seq'::regclass);


--
-- Name: user_roles id; Type: DEFAULT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.user_roles ALTER COLUMN id SET DEFAULT nextval('audit_security.user_roles_id_seq'::regclass);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: account_heads id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.account_heads ALTER COLUMN id SET DEFAULT nextval('master_data.account_heads_id_seq'::regclass);


--
-- Name: audio_genres id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.audio_genres ALTER COLUMN id SET DEFAULT nextval('master_data.audio_genres_id_seq'::regclass);


--
-- Name: bank_accounts id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.bank_accounts ALTER COLUMN id SET DEFAULT nextval('master_data.bank_accounts_id_seq'::regclass);


--
-- Name: branches id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.branches ALTER COLUMN id SET DEFAULT nextval('master_data.branches_id_seq'::regclass);


--
-- Name: checklist_items id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.checklist_items ALTER COLUMN id SET DEFAULT nextval('master_data.checklist_items_id_seq'::regclass);


--
-- Name: checklists id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.checklists ALTER COLUMN id SET DEFAULT nextval('master_data.checklists_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.clients ALTER COLUMN id SET DEFAULT nextval('master_data.clients_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.companies ALTER COLUMN id SET DEFAULT nextval('master_data.companies_id_seq'::regclass);


--
-- Name: deliverables id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.deliverables ALTER COLUMN id SET DEFAULT nextval('master_data.deliverables_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.departments ALTER COLUMN id SET DEFAULT nextval('master_data.departments_id_seq'::regclass);


--
-- Name: designations id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.designations ALTER COLUMN id SET DEFAULT nextval('master_data.designations_id_seq'::regclass);


--
-- Name: document_templates id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.document_templates ALTER COLUMN id SET DEFAULT nextval('master_data.document_templates_id_seq'::regclass);


--
-- Name: muhurtham id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.muhurtham ALTER COLUMN id SET DEFAULT nextval('master_data.muhurtham_id_seq'::regclass);


--
-- Name: payment_modes id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.payment_modes ALTER COLUMN id SET DEFAULT nextval('master_data.payment_modes_id_seq'::regclass);


--
-- Name: service_deliverable_mapping id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.service_deliverable_mapping ALTER COLUMN id SET DEFAULT nextval('master_data.service_deliverable_mapping_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.services ALTER COLUMN id SET DEFAULT nextval('master_data.services_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.suppliers ALTER COLUMN id SET DEFAULT nextval('master_data.suppliers_id_seq'::regclass);


--
-- Name: vendors id; Type: DEFAULT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.vendors ALTER COLUMN id SET DEFAULT nextval('master_data.vendors_id_seq'::regclass);


--
-- Name: accounting_workflows id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.accounting_workflows ALTER COLUMN id SET DEFAULT nextval('public.accounting_workflows_id_seq'::regclass);


--
-- Name: action_recommendations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.action_recommendations ALTER COLUMN id SET DEFAULT nextval('public.action_recommendations_id_seq'::regclass);


--
-- Name: ai_behavior_settings id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_behavior_settings ALTER COLUMN id SET DEFAULT nextval('public.ai_behavior_settings_id_seq'::regclass);


--
-- Name: ai_communication_tasks id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_communication_tasks ALTER COLUMN id SET DEFAULT nextval('public.ai_communication_tasks_id_seq'::regclass);


--
-- Name: ai_configurations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_configurations ALTER COLUMN id SET DEFAULT nextval('public.ai_configurations_id_seq'::regclass);


--
-- Name: ai_prompt_templates id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_prompt_templates ALTER COLUMN id SET DEFAULT nextval('public.ai_prompt_templates_id_seq'::regclass);


--
-- Name: ai_tasks id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_tasks ALTER COLUMN id SET DEFAULT nextval('public.ai_tasks_id_seq'::regclass);


--
-- Name: branches id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.branches ALTER COLUMN id SET DEFAULT nextval('public.branches_id_seq'::regclass);


--
-- Name: business_trends id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.business_trends ALTER COLUMN id SET DEFAULT nextval('public.business_trends_id_seq'::regclass);


--
-- Name: call_triggers id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.call_triggers ALTER COLUMN id SET DEFAULT nextval('public.call_triggers_id_seq'::regclass);


--
-- Name: client_communication_timeline id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.client_communication_timeline ALTER COLUMN id SET DEFAULT nextval('public.client_communication_timeline_id_seq'::regclass);


--
-- Name: client_insights id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.client_insights ALTER COLUMN id SET DEFAULT nextval('public.client_insights_id_seq'::regclass);


--
-- Name: clients id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.clients ALTER COLUMN id SET DEFAULT nextval('public.clients_id_seq'::regclass);


--
-- Name: communications id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.communications ALTER COLUMN id SET DEFAULT nextval('public.communications_id_seq'::regclass);


--
-- Name: companies id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.companies ALTER COLUMN id SET DEFAULT nextval('public.companies_id_seq'::regclass);


--
-- Name: conversation_sessions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.conversation_sessions ALTER COLUMN id SET DEFAULT nextval('public.conversation_sessions_id_seq'::regclass);


--
-- Name: deliverable_master id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.deliverable_master ALTER COLUMN id SET DEFAULT nextval('public.deliverable_master_id_seq'::regclass);


--
-- Name: deliverables id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.deliverables ALTER COLUMN id SET DEFAULT nextval('public.deliverables_id_seq'::regclass);


--
-- Name: department_instructions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.department_instructions ALTER COLUMN id SET DEFAULT nextval('public.department_instructions_id_seq'::regclass);


--
-- Name: departments id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.departments ALTER COLUMN id SET DEFAULT nextval('public.departments_id_seq'::regclass);


--
-- Name: designations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designations ALTER COLUMN id SET DEFAULT nextval('public.designations_id_seq'::regclass);


--
-- Name: dynamic_menus id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.dynamic_menus ALTER COLUMN id SET DEFAULT nextval('public.dynamic_menus_id_seq'::regclass);


--
-- Name: employee_companies id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_companies ALTER COLUMN id SET DEFAULT nextval('public.employee_companies_id_seq'::regclass);


--
-- Name: employee_devices id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_devices ALTER COLUMN id SET DEFAULT nextval('public.employee_devices_id_seq'::regclass);


--
-- Name: employees id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees ALTER COLUMN id SET DEFAULT nextval('public.employees_id_seq'::regclass);


--
-- Name: instagram_analytics id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_analytics ALTER COLUMN id SET DEFAULT nextval('public.instagram_analytics_id_seq'::regclass);


--
-- Name: instagram_comments id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_comments ALTER COLUMN id SET DEFAULT nextval('public.instagram_comments_id_seq'::regclass);


--
-- Name: instagram_interactions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_interactions ALTER COLUMN id SET DEFAULT nextval('public.instagram_interactions_id_seq'::regclass);


--
-- Name: instagram_mentions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_mentions ALTER COLUMN id SET DEFAULT nextval('public.instagram_mentions_id_seq'::regclass);


--
-- Name: instagram_messages id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_messages ALTER COLUMN id SET DEFAULT nextval('public.instagram_messages_id_seq'::regclass);


--
-- Name: instagram_story_mentions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_story_mentions ALTER COLUMN id SET DEFAULT nextval('public.instagram_story_mentions_id_seq'::regclass);


--
-- Name: instruction_approvals id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instruction_approvals ALTER COLUMN id SET DEFAULT nextval('public.instruction_approvals_id_seq'::regclass);


--
-- Name: lead_drafts id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_drafts ALTER COLUMN id SET DEFAULT nextval('public.lead_drafts_id_seq'::regclass);


--
-- Name: lead_followups id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_followups ALTER COLUMN id SET DEFAULT nextval('public.lead_followups_id_seq'::regclass);


--
-- Name: lead_sources id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_sources ALTER COLUMN id SET DEFAULT nextval('public.lead_sources_id_seq'::regclass);


--
-- Name: lead_task_performance id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_task_performance ALTER COLUMN id SET DEFAULT nextval('public.lead_task_performance_id_seq'::regclass);


--
-- Name: leads id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.leads ALTER COLUMN id SET DEFAULT nextval('public.leads_id_seq'::regclass);


--
-- Name: management_insights id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.management_insights ALTER COLUMN id SET DEFAULT nextval('public.management_insights_id_seq'::regclass);


--
-- Name: menu_items id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items ALTER COLUMN id SET DEFAULT nextval('public.menu_items_id_seq'::regclass);


--
-- Name: menu_items_tracking id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items_tracking ALTER COLUMN id SET DEFAULT nextval('public.menu_items_tracking_id_seq'::regclass);


--
-- Name: message_analysis id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.message_analysis ALTER COLUMN id SET DEFAULT nextval('public.message_analysis_id_seq'::regclass);


--
-- Name: ml_model_performance id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ml_model_performance ALTER COLUMN id SET DEFAULT nextval('public.ml_model_performance_id_seq'::regclass);


--
-- Name: notification_batches id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_batches ALTER COLUMN id SET DEFAULT nextval('public.notification_batches_id_seq'::regclass);


--
-- Name: partners id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.partners ALTER COLUMN id SET DEFAULT nextval('public.partners_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: post_sale_confirmations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sale_confirmations ALTER COLUMN id SET DEFAULT nextval('public.post_sale_confirmations_id_seq'::regclass);


--
-- Name: post_sales_workflows id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sales_workflows ALTER COLUMN id SET DEFAULT nextval('public.post_sales_workflows_id_seq'::regclass);


--
-- Name: query_performance_logs id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.query_performance_logs ALTER COLUMN id SET DEFAULT nextval('public.query_performance_logs_id_seq'::regclass);


--
-- Name: quotation_approvals id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_approvals ALTER COLUMN id SET DEFAULT nextval('public.quotation_approvals_id_seq'::regclass);


--
-- Name: quotation_business_lifecycle id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_business_lifecycle ALTER COLUMN id SET DEFAULT nextval('public.quotation_business_lifecycle_id_seq'::regclass);


--
-- Name: quotation_edit_approvals id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_edit_approvals ALTER COLUMN id SET DEFAULT nextval('public.quotation_edit_approvals_id_seq'::regclass);


--
-- Name: quotation_events id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_events ALTER COLUMN id SET DEFAULT nextval('public.quotation_events_id_seq'::regclass);


--
-- Name: quotation_predictions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_predictions ALTER COLUMN id SET DEFAULT nextval('public.quotation_predictions_id_seq'::regclass);


--
-- Name: quotation_revisions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_revisions ALTER COLUMN id SET DEFAULT nextval('public.quotation_revisions_id_seq'::regclass);


--
-- Name: quotation_workflow_history id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_workflow_history ALTER COLUMN id SET DEFAULT nextval('public.quotation_workflow_history_id_seq'::regclass);


--
-- Name: quotations id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotations ALTER COLUMN id SET DEFAULT nextval('public.quotations_id_seq'::regclass);


--
-- Name: quote_components id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_components ALTER COLUMN id SET DEFAULT nextval('public.quote_components_id_seq'::regclass);


--
-- Name: quote_deliverables_snapshot id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_deliverables_snapshot ALTER COLUMN id SET DEFAULT nextval('public.quote_deliverables_snapshot_id_seq'::regclass);


--
-- Name: quote_services_snapshot id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_services_snapshot ALTER COLUMN id SET DEFAULT nextval('public.quote_services_snapshot_id_seq'::regclass);


--
-- Name: revenue_forecasts id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.revenue_forecasts ALTER COLUMN id SET DEFAULT nextval('public.revenue_forecasts_id_seq'::regclass);


--
-- Name: role_menu_access id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_menu_access ALTER COLUMN id SET DEFAULT nextval('public.role_menu_access_id_seq'::regclass);


--
-- Name: role_menu_permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_menu_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_menu_permissions_id_seq'::regclass);


--
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: sales_activities id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_activities ALTER COLUMN id SET DEFAULT nextval('public.sales_activities_id_seq'::regclass);


--
-- Name: sales_performance_metrics id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_performance_metrics ALTER COLUMN id SET DEFAULT nextval('public.sales_performance_metrics_id_seq'::regclass);


--
-- Name: sales_team_members id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_team_members ALTER COLUMN id SET DEFAULT nextval('public.sales_team_members_id_seq'::regclass);


--
-- Name: sequence_rules id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sequence_rules ALTER COLUMN id SET DEFAULT nextval('public.sequence_rules_id_seq'::regclass);


--
-- Name: sequence_steps id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sequence_steps ALTER COLUMN id SET DEFAULT nextval('public.sequence_steps_id_seq'::regclass);


--
-- Name: service_packages id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.service_packages ALTER COLUMN id SET DEFAULT nextval('public.service_packages_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: suppliers id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- Name: system_logs id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.system_logs ALTER COLUMN id SET DEFAULT nextval('public.system_logs_id_seq'::regclass);


--
-- Name: task_generation_log id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_generation_log ALTER COLUMN id SET DEFAULT nextval('public.task_generation_log_id_seq'::regclass);


--
-- Name: task_performance_metrics id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_performance_metrics ALTER COLUMN id SET DEFAULT nextval('public.task_performance_metrics_id_seq'::regclass);


--
-- Name: task_sequence_templates id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_sequence_templates ALTER COLUMN id SET DEFAULT nextval('public.task_sequence_templates_id_seq'::regclass);


--
-- Name: task_status_history id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_status_history ALTER COLUMN id SET DEFAULT nextval('public.task_status_history_id_seq'::regclass);


--
-- Name: team_performance_trends id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.team_performance_trends ALTER COLUMN id SET DEFAULT nextval('public.team_performance_trends_id_seq'::regclass);


--
-- Name: teams id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.teams ALTER COLUMN id SET DEFAULT nextval('public.teams_id_seq'::regclass);


--
-- Name: unified_role_permissions id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.unified_role_permissions ALTER COLUMN id SET DEFAULT nextval('public.unified_role_permissions_id_seq'::regclass);


--
-- Name: user_accounts id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_accounts ALTER COLUMN id SET DEFAULT nextval('public.user_accounts_id_seq'::regclass);


--
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- Name: vendors id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.vendors ALTER COLUMN id SET DEFAULT nextval('public.vendors_id_seq'::regclass);


--
-- Name: whatsapp_messages id; Type: DEFAULT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.whatsapp_messages ALTER COLUMN id SET DEFAULT nextval('public.whatsapp_messages_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: vikasalagarsamy
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: audit_trail audit_trail_pkey; Type: CONSTRAINT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.audit_trail
    ADD CONSTRAINT audit_trail_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: account_heads account_heads_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.account_heads
    ADD CONSTRAINT account_heads_pkey PRIMARY KEY (id);


--
-- Name: audio_genres audio_genres_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.audio_genres
    ADD CONSTRAINT audio_genres_pkey PRIMARY KEY (id);


--
-- Name: bank_accounts bank_accounts_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.bank_accounts
    ADD CONSTRAINT bank_accounts_pkey PRIMARY KEY (id);


--
-- Name: branches branches_code_key; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.branches
    ADD CONSTRAINT branches_code_key UNIQUE (code);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (id);


--
-- Name: checklist_items checklist_items_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.checklist_items
    ADD CONSTRAINT checklist_items_pkey PRIMARY KEY (id);


--
-- Name: checklists checklists_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.checklists
    ADD CONSTRAINT checklists_pkey PRIMARY KEY (id);


--
-- Name: clients clients_code_key; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.clients
    ADD CONSTRAINT clients_code_key UNIQUE (code);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: companies companies_code_key; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.companies
    ADD CONSTRAINT companies_code_key UNIQUE (code);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: deliverables deliverables_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.deliverables
    ADD CONSTRAINT deliverables_pkey PRIMARY KEY (id);


--
-- Name: departments departments_code_key; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.departments
    ADD CONSTRAINT departments_code_key UNIQUE (code);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: designations designations_code_key; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.designations
    ADD CONSTRAINT designations_code_key UNIQUE (code);


--
-- Name: designations designations_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.designations
    ADD CONSTRAINT designations_pkey PRIMARY KEY (id);


--
-- Name: document_templates document_templates_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.document_templates
    ADD CONSTRAINT document_templates_pkey PRIMARY KEY (id);


--
-- Name: muhurtham muhurtham_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.muhurtham
    ADD CONSTRAINT muhurtham_pkey PRIMARY KEY (id);


--
-- Name: payment_modes payment_modes_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.payment_modes
    ADD CONSTRAINT payment_modes_pkey PRIMARY KEY (id);


--
-- Name: service_deliverable_mapping service_deliverable_mapping_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.service_deliverable_mapping
    ADD CONSTRAINT service_deliverable_mapping_pkey PRIMARY KEY (id);


--
-- Name: service_deliverable_mapping service_deliverable_mapping_service_id_deliverable_id_key; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.service_deliverable_mapping
    ADD CONSTRAINT service_deliverable_mapping_service_id_deliverable_id_key UNIQUE (service_id, deliverable_id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_code_key; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.suppliers
    ADD CONSTRAINT suppliers_code_key UNIQUE (code);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: vendors vendors_code_key; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.vendors
    ADD CONSTRAINT vendors_code_key UNIQUE (code);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: master_data; Owner: vikasalagarsamy
--

ALTER TABLE ONLY master_data.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: accounting_workflows accounting_workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.accounting_workflows
    ADD CONSTRAINT accounting_workflows_pkey PRIMARY KEY (id);


--
-- Name: action_recommendations action_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.action_recommendations
    ADD CONSTRAINT action_recommendations_pkey PRIMARY KEY (id);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (id);


--
-- Name: ai_behavior_settings ai_behavior_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_behavior_settings
    ADD CONSTRAINT ai_behavior_settings_pkey PRIMARY KEY (id);


--
-- Name: ai_behavior_settings ai_behavior_settings_setting_key_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_behavior_settings
    ADD CONSTRAINT ai_behavior_settings_setting_key_key UNIQUE (setting_key);


--
-- Name: ai_communication_tasks ai_communication_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_communication_tasks
    ADD CONSTRAINT ai_communication_tasks_pkey PRIMARY KEY (id);


--
-- Name: ai_configurations ai_configurations_config_key_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_configurations
    ADD CONSTRAINT ai_configurations_config_key_key UNIQUE (config_key);


--
-- Name: ai_configurations ai_configurations_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_configurations
    ADD CONSTRAINT ai_configurations_pkey PRIMARY KEY (id);


--
-- Name: ai_contacts ai_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_contacts
    ADD CONSTRAINT ai_contacts_pkey PRIMARY KEY (id);


--
-- Name: ai_decision_log ai_decision_log_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_decision_log
    ADD CONSTRAINT ai_decision_log_pkey PRIMARY KEY (id);


--
-- Name: ai_performance_tracking ai_performance_tracking_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_performance_tracking
    ADD CONSTRAINT ai_performance_tracking_pkey PRIMARY KEY (id);


--
-- Name: ai_prompt_templates ai_prompt_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_prompt_templates
    ADD CONSTRAINT ai_prompt_templates_pkey PRIMARY KEY (id);


--
-- Name: ai_prompt_templates ai_prompt_templates_template_name_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_prompt_templates
    ADD CONSTRAINT ai_prompt_templates_template_name_key UNIQUE (template_name);


--
-- Name: ai_recommendations ai_recommendations_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_recommendations
    ADD CONSTRAINT ai_recommendations_pkey PRIMARY KEY (id);


--
-- Name: ai_tasks ai_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_tasks
    ADD CONSTRAINT ai_tasks_pkey PRIMARY KEY (id);


--
-- Name: analytics_cache analytics_cache_cache_key_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.analytics_cache
    ADD CONSTRAINT analytics_cache_cache_key_key UNIQUE (cache_key);


--
-- Name: analytics_cache analytics_cache_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.analytics_cache
    ADD CONSTRAINT analytics_cache_pkey PRIMARY KEY (id);


--
-- Name: analytics_metrics analytics_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.analytics_metrics
    ADD CONSTRAINT analytics_metrics_pkey PRIMARY KEY (id);


--
-- Name: auditions auditions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.auditions
    ADD CONSTRAINT auditions_pkey PRIMARY KEY (id);


--
-- Name: branches branches_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_pkey PRIMARY KEY (id);


--
-- Name: bug_attachments bug_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.bug_attachments
    ADD CONSTRAINT bug_attachments_pkey PRIMARY KEY (id);


--
-- Name: bug_comments bug_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.bug_comments
    ADD CONSTRAINT bug_comments_pkey PRIMARY KEY (id);


--
-- Name: bugs bugs_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.bugs
    ADD CONSTRAINT bugs_pkey PRIMARY KEY (id);


--
-- Name: business_rules business_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.business_rules
    ADD CONSTRAINT business_rules_pkey PRIMARY KEY (id);


--
-- Name: business_trends business_trends_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.business_trends
    ADD CONSTRAINT business_trends_pkey PRIMARY KEY (id);


--
-- Name: call_analytics call_analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.call_analytics
    ADD CONSTRAINT call_analytics_pkey PRIMARY KEY (id);


--
-- Name: call_insights call_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.call_insights
    ADD CONSTRAINT call_insights_pkey PRIMARY KEY (id);


--
-- Name: call_transcriptions call_transcriptions_call_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.call_transcriptions
    ADD CONSTRAINT call_transcriptions_call_id_key UNIQUE (call_id);


--
-- Name: call_transcriptions call_transcriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.call_transcriptions
    ADD CONSTRAINT call_transcriptions_pkey PRIMARY KEY (id);


--
-- Name: call_triggers call_triggers_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.call_triggers
    ADD CONSTRAINT call_triggers_pkey PRIMARY KEY (id);


--
-- Name: chat_logs chat_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.chat_logs
    ADD CONSTRAINT chat_logs_pkey PRIMARY KEY (id);


--
-- Name: client_communication_timeline client_communication_timeline_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.client_communication_timeline
    ADD CONSTRAINT client_communication_timeline_pkey PRIMARY KEY (id);


--
-- Name: client_insights client_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.client_insights
    ADD CONSTRAINT client_insights_pkey PRIMARY KEY (id);


--
-- Name: clients clients_client_code_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_client_code_key UNIQUE (client_code);


--
-- Name: clients clients_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- Name: communications communications_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.communications
    ADD CONSTRAINT communications_pkey PRIMARY KEY (id);


--
-- Name: companies companies_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.companies
    ADD CONSTRAINT companies_pkey PRIMARY KEY (id);


--
-- Name: company_partners company_partners_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.company_partners
    ADD CONSTRAINT company_partners_pkey PRIMARY KEY (company_id, partner_id);


--
-- Name: conversation_sessions conversation_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.conversation_sessions
    ADD CONSTRAINT conversation_sessions_pkey PRIMARY KEY (id);


--
-- Name: deliverable_master deliverable_master_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.deliverable_master
    ADD CONSTRAINT deliverable_master_pkey PRIMARY KEY (id);


--
-- Name: deliverables deliverables_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.deliverables
    ADD CONSTRAINT deliverables_pkey PRIMARY KEY (id);


--
-- Name: department_instructions department_instructions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.department_instructions
    ADD CONSTRAINT department_instructions_pkey PRIMARY KEY (id);


--
-- Name: departments departments_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_pkey PRIMARY KEY (id);


--
-- Name: designations designations_name_department_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_name_department_id_key UNIQUE (name, department_id);


--
-- Name: designations designations_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_pkey PRIMARY KEY (id);


--
-- Name: dynamic_menus dynamic_menus_menu_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.dynamic_menus
    ADD CONSTRAINT dynamic_menus_menu_id_key UNIQUE (menu_id);


--
-- Name: dynamic_menus dynamic_menus_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.dynamic_menus
    ADD CONSTRAINT dynamic_menus_pkey PRIMARY KEY (id);


--
-- Name: email_notification_templates email_notification_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.email_notification_templates
    ADD CONSTRAINT email_notification_templates_pkey PRIMARY KEY (id);


--
-- Name: employee_companies employee_companies_employee_id_company_id_branch_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_companies
    ADD CONSTRAINT employee_companies_employee_id_company_id_branch_id_key UNIQUE (employee_id, company_id, branch_id);


--
-- Name: employee_companies employee_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_companies
    ADD CONSTRAINT employee_companies_pkey PRIMARY KEY (id);


--
-- Name: employee_devices employee_devices_device_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_devices
    ADD CONSTRAINT employee_devices_device_id_key UNIQUE (device_id);


--
-- Name: employee_devices employee_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_devices
    ADD CONSTRAINT employee_devices_pkey PRIMARY KEY (id);


--
-- Name: employees employees_email_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_email_key UNIQUE (email);


--
-- Name: employees employees_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_employee_id_key UNIQUE (employee_id);


--
-- Name: employees employees_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_pkey PRIMARY KEY (id);


--
-- Name: employees employees_username_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_username_key UNIQUE (username);


--
-- Name: events events_event_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_event_id_key UNIQUE (event_id);


--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: follow_up_auditions follow_up_auditions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.follow_up_auditions
    ADD CONSTRAINT follow_up_auditions_pkey PRIMARY KEY (id);


--
-- Name: instagram_analytics instagram_analytics_date_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_analytics
    ADD CONSTRAINT instagram_analytics_date_key UNIQUE (date);


--
-- Name: instagram_analytics instagram_analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_analytics
    ADD CONSTRAINT instagram_analytics_pkey PRIMARY KEY (id);


--
-- Name: instagram_comments instagram_comments_comment_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_comments
    ADD CONSTRAINT instagram_comments_comment_id_key UNIQUE (comment_id);


--
-- Name: instagram_comments instagram_comments_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_comments
    ADD CONSTRAINT instagram_comments_pkey PRIMARY KEY (id);


--
-- Name: instagram_interactions instagram_interactions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_interactions
    ADD CONSTRAINT instagram_interactions_pkey PRIMARY KEY (id);


--
-- Name: instagram_mentions instagram_mentions_mention_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_mentions
    ADD CONSTRAINT instagram_mentions_mention_id_key UNIQUE (mention_id);


--
-- Name: instagram_mentions instagram_mentions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_mentions
    ADD CONSTRAINT instagram_mentions_pkey PRIMARY KEY (id);


--
-- Name: instagram_messages instagram_messages_message_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_messages
    ADD CONSTRAINT instagram_messages_message_id_key UNIQUE (message_id);


--
-- Name: instagram_messages instagram_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_messages
    ADD CONSTRAINT instagram_messages_pkey PRIMARY KEY (id);


--
-- Name: instagram_story_mentions instagram_story_mentions_mention_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_story_mentions
    ADD CONSTRAINT instagram_story_mentions_mention_id_key UNIQUE (mention_id);


--
-- Name: instagram_story_mentions instagram_story_mentions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instagram_story_mentions
    ADD CONSTRAINT instagram_story_mentions_pkey PRIMARY KEY (id);


--
-- Name: instruction_approvals instruction_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instruction_approvals
    ADD CONSTRAINT instruction_approvals_pkey PRIMARY KEY (id);


--
-- Name: lead_drafts lead_drafts_phone_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_drafts
    ADD CONSTRAINT lead_drafts_phone_key UNIQUE (phone);


--
-- Name: lead_drafts lead_drafts_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_drafts
    ADD CONSTRAINT lead_drafts_pkey PRIMARY KEY (id);


--
-- Name: lead_followups lead_followups_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_followups
    ADD CONSTRAINT lead_followups_pkey PRIMARY KEY (id);


--
-- Name: lead_sources lead_sources_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_sources
    ADD CONSTRAINT lead_sources_pkey PRIMARY KEY (id);


--
-- Name: lead_task_performance lead_task_performance_lead_id_task_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_task_performance
    ADD CONSTRAINT lead_task_performance_lead_id_task_id_key UNIQUE (lead_id, task_id);


--
-- Name: lead_task_performance lead_task_performance_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_task_performance
    ADD CONSTRAINT lead_task_performance_pkey PRIMARY KEY (id);


--
-- Name: leads leads_lead_number_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_lead_number_key UNIQUE (lead_number);


--
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- Name: management_insights management_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.management_insights
    ADD CONSTRAINT management_insights_pkey PRIMARY KEY (id);


--
-- Name: menu_items menu_items_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_pkey PRIMARY KEY (id);


--
-- Name: menu_items menu_items_string_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_string_id_key UNIQUE (string_id);


--
-- Name: menu_items_tracking menu_items_tracking_menu_item_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items_tracking
    ADD CONSTRAINT menu_items_tracking_menu_item_id_key UNIQUE (menu_item_id);


--
-- Name: menu_items_tracking menu_items_tracking_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items_tracking
    ADD CONSTRAINT menu_items_tracking_pkey PRIMARY KEY (id);


--
-- Name: message_analysis message_analysis_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.message_analysis
    ADD CONSTRAINT message_analysis_pkey PRIMARY KEY (id);


--
-- Name: ml_model_performance ml_model_performance_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ml_model_performance
    ADD CONSTRAINT ml_model_performance_pkey PRIMARY KEY (id);


--
-- Name: notification_batches notification_batches_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_batches
    ADD CONSTRAINT notification_batches_pkey PRIMARY KEY (id);


--
-- Name: notification_batches notification_batches_user_id_notification_type_batch_key_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_batches
    ADD CONSTRAINT notification_batches_user_id_notification_type_batch_key_key UNIQUE (user_id, notification_type, batch_key);


--
-- Name: notification_engagement notification_engagement_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_engagement
    ADD CONSTRAINT notification_engagement_pkey PRIMARY KEY (id);


--
-- Name: notification_patterns notification_patterns_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_patterns
    ADD CONSTRAINT notification_patterns_pkey PRIMARY KEY (id);


--
-- Name: notification_patterns notification_patterns_type_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_patterns
    ADD CONSTRAINT notification_patterns_type_key UNIQUE (type);


--
-- Name: notification_preferences notification_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_preferences
    ADD CONSTRAINT notification_preferences_pkey PRIMARY KEY (user_id);


--
-- Name: notification_recipients notification_recipients_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT notification_recipients_pkey PRIMARY KEY (notification_id, user_id);


--
-- Name: notification_rules notification_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_rules
    ADD CONSTRAINT notification_rules_pkey PRIMARY KEY (id);


--
-- Name: notification_settings notification_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_settings
    ADD CONSTRAINT notification_settings_pkey PRIMARY KEY (user_id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: partners partners_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.partners
    ADD CONSTRAINT partners_pkey PRIMARY KEY (id);


--
-- Name: payments payments_payment_reference_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_payment_reference_key UNIQUE (payment_reference);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: personalization_learning personalization_learning_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.personalization_learning
    ADD CONSTRAINT personalization_learning_pkey PRIMARY KEY (id);


--
-- Name: post_sale_confirmations post_sale_confirmations_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sale_confirmations
    ADD CONSTRAINT post_sale_confirmations_pkey PRIMARY KEY (id);


--
-- Name: post_sales_workflows post_sales_workflows_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sales_workflows
    ADD CONSTRAINT post_sales_workflows_pkey PRIMARY KEY (id);


--
-- Name: predictive_insights predictive_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.predictive_insights
    ADD CONSTRAINT predictive_insights_pkey PRIMARY KEY (id);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: query_performance_logs query_performance_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.query_performance_logs
    ADD CONSTRAINT query_performance_logs_pkey PRIMARY KEY (id);


--
-- Name: quotation_approvals quotation_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_approvals
    ADD CONSTRAINT quotation_approvals_pkey PRIMARY KEY (id);


--
-- Name: quotation_business_lifecycle quotation_business_lifecycle_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_business_lifecycle
    ADD CONSTRAINT quotation_business_lifecycle_pkey PRIMARY KEY (id);


--
-- Name: quotation_business_lifecycle quotation_business_lifecycle_quotation_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_business_lifecycle
    ADD CONSTRAINT quotation_business_lifecycle_quotation_id_key UNIQUE (quotation_id);


--
-- Name: quotation_edit_approvals quotation_edit_approvals_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_edit_approvals
    ADD CONSTRAINT quotation_edit_approvals_pkey PRIMARY KEY (id);


--
-- Name: quotation_events quotation_events_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_events
    ADD CONSTRAINT quotation_events_pkey PRIMARY KEY (id);


--
-- Name: quotation_predictions quotation_predictions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_predictions
    ADD CONSTRAINT quotation_predictions_pkey PRIMARY KEY (id);


--
-- Name: quotation_revisions quotation_revisions_original_quotation_id_revision_number_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_revisions
    ADD CONSTRAINT quotation_revisions_original_quotation_id_revision_number_key UNIQUE (original_quotation_id, revision_number);


--
-- Name: quotation_revisions quotation_revisions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_revisions
    ADD CONSTRAINT quotation_revisions_pkey PRIMARY KEY (id);


--
-- Name: quotation_workflow_history quotation_workflow_history_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_workflow_history
    ADD CONSTRAINT quotation_workflow_history_pkey PRIMARY KEY (id);


--
-- Name: quotations quotations_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_pkey PRIMARY KEY (id);


--
-- Name: quotations quotations_quotation_number_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_quotation_number_key UNIQUE (quotation_number);


--
-- Name: quote_components quote_components_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_components
    ADD CONSTRAINT quote_components_pkey PRIMARY KEY (id);


--
-- Name: quote_deliverables_snapshot quote_deliverables_snapshot_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_deliverables_snapshot
    ADD CONSTRAINT quote_deliverables_snapshot_pkey PRIMARY KEY (id);


--
-- Name: quote_services_snapshot quote_services_snapshot_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quote_services_snapshot
    ADD CONSTRAINT quote_services_snapshot_pkey PRIMARY KEY (id);


--
-- Name: revenue_forecasts revenue_forecasts_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.revenue_forecasts
    ADD CONSTRAINT revenue_forecasts_pkey PRIMARY KEY (id);


--
-- Name: role_menu_access role_menu_access_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_menu_access
    ADD CONSTRAINT role_menu_access_pkey PRIMARY KEY (id);


--
-- Name: role_menu_access role_menu_access_role_name_menu_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_menu_access
    ADD CONSTRAINT role_menu_access_role_name_menu_id_key UNIQUE (role_name, menu_id);


--
-- Name: role_menu_permissions role_menu_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_menu_permissions
    ADD CONSTRAINT role_menu_permissions_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_role_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_permission_id_key UNIQUE (role_id, permission_id);


--
-- Name: roles roles_name_unique; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_unique UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: sales_activities sales_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_activities
    ADD CONSTRAINT sales_activities_pkey PRIMARY KEY (id);


--
-- Name: sales_performance_metrics sales_performance_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_performance_metrics
    ADD CONSTRAINT sales_performance_metrics_pkey PRIMARY KEY (id);


--
-- Name: sales_team_members sales_team_members_employee_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_team_members
    ADD CONSTRAINT sales_team_members_employee_id_key UNIQUE (employee_id);


--
-- Name: sales_team_members sales_team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_team_members
    ADD CONSTRAINT sales_team_members_pkey PRIMARY KEY (id);


--
-- Name: sequence_rules sequence_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sequence_rules
    ADD CONSTRAINT sequence_rules_pkey PRIMARY KEY (id);


--
-- Name: sequence_steps sequence_steps_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sequence_steps
    ADD CONSTRAINT sequence_steps_pkey PRIMARY KEY (id);


--
-- Name: service_packages service_packages_package_name_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.service_packages
    ADD CONSTRAINT service_packages_package_name_key UNIQUE (package_name);


--
-- Name: service_packages service_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.service_packages
    ADD CONSTRAINT service_packages_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: suppliers suppliers_supplier_code_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.suppliers
    ADD CONSTRAINT suppliers_supplier_code_key UNIQUE (supplier_code);


--
-- Name: system_logs system_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.system_logs
    ADD CONSTRAINT system_logs_pkey PRIMARY KEY (id);


--
-- Name: task_generation_log task_generation_log_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_generation_log
    ADD CONSTRAINT task_generation_log_pkey PRIMARY KEY (id);


--
-- Name: task_performance_metrics task_performance_metrics_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_performance_metrics
    ADD CONSTRAINT task_performance_metrics_pkey PRIMARY KEY (id);


--
-- Name: task_performance_metrics task_performance_metrics_task_id_unique; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_performance_metrics
    ADD CONSTRAINT task_performance_metrics_task_id_unique UNIQUE (task_id);


--
-- Name: task_sequence_templates task_sequence_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_sequence_templates
    ADD CONSTRAINT task_sequence_templates_pkey PRIMARY KEY (id);


--
-- Name: task_status_history task_status_history_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.task_status_history
    ADD CONSTRAINT task_status_history_pkey PRIMARY KEY (id);


--
-- Name: team_members team_members_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_pkey PRIMARY KEY (team_id, employee_id);


--
-- Name: team_performance_trends team_performance_trends_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.team_performance_trends
    ADD CONSTRAINT team_performance_trends_pkey PRIMARY KEY (id);


--
-- Name: teams teams_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_pkey PRIMARY KEY (id);


--
-- Name: unified_role_permissions unified_role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.unified_role_permissions
    ADD CONSTRAINT unified_role_permissions_pkey PRIMARY KEY (id);


--
-- Name: unified_role_permissions unified_role_permissions_role_id_menu_string_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.unified_role_permissions
    ADD CONSTRAINT unified_role_permissions_role_id_menu_string_id_key UNIQUE (role_id, menu_string_id);


--
-- Name: roles unique_role_name; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT unique_role_name UNIQUE (name);


--
-- Name: user_accounts user_accounts_email_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_accounts
    ADD CONSTRAINT user_accounts_email_key UNIQUE (email);


--
-- Name: user_accounts user_accounts_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_accounts
    ADD CONSTRAINT user_accounts_pkey PRIMARY KEY (id);


--
-- Name: user_accounts user_accounts_username_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_accounts
    ADD CONSTRAINT user_accounts_username_key UNIQUE (username);


--
-- Name: user_activity_history user_activity_history_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_activity_history
    ADD CONSTRAINT user_activity_history_pkey PRIMARY KEY (id);


--
-- Name: user_ai_profiles user_ai_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_ai_profiles
    ADD CONSTRAINT user_ai_profiles_pkey PRIMARY KEY (id);


--
-- Name: user_ai_profiles user_ai_profiles_user_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_ai_profiles
    ADD CONSTRAINT user_ai_profiles_user_id_key UNIQUE (user_id);


--
-- Name: user_behavior_analytics user_behavior_analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_behavior_analytics
    ADD CONSTRAINT user_behavior_analytics_pkey PRIMARY KEY (id);


--
-- Name: user_behavior_analytics user_behavior_analytics_user_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_behavior_analytics
    ADD CONSTRAINT user_behavior_analytics_user_id_key UNIQUE (user_id);


--
-- Name: user_engagement_analytics user_engagement_analytics_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_engagement_analytics
    ADD CONSTRAINT user_engagement_analytics_pkey PRIMARY KEY (id);


--
-- Name: user_id_mapping user_id_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_id_mapping
    ADD CONSTRAINT user_id_mapping_pkey PRIMARY KEY (numeric_id);


--
-- Name: user_preferences user_preferences_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_pkey PRIMARY KEY (id);


--
-- Name: user_preferences user_preferences_user_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_user_id_key UNIQUE (user_id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: vendors vendors_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_pkey PRIMARY KEY (id);


--
-- Name: vendors vendors_vendor_code_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.vendors
    ADD CONSTRAINT vendors_vendor_code_key UNIQUE (vendor_code);


--
-- Name: webhook_logs webhook_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.webhook_logs
    ADD CONSTRAINT webhook_logs_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_config whatsapp_config_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.whatsapp_config
    ADD CONSTRAINT whatsapp_config_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_messages whatsapp_messages_interakt_message_id_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.whatsapp_messages
    ADD CONSTRAINT whatsapp_messages_interakt_message_id_key UNIQUE (interakt_message_id);


--
-- Name: whatsapp_messages whatsapp_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.whatsapp_messages
    ADD CONSTRAINT whatsapp_messages_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_templates whatsapp_templates_pkey; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.whatsapp_templates
    ADD CONSTRAINT whatsapp_templates_pkey PRIMARY KEY (id);


--
-- Name: whatsapp_templates whatsapp_templates_template_name_key; Type: CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.whatsapp_templates
    ADD CONSTRAINT whatsapp_templates_template_name_key UNIQUE (template_name);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_06_15 messages_2025_06_15_pkey; Type: CONSTRAINT; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages_2025_06_15
    ADD CONSTRAINT messages_2025_06_15_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_06_16 messages_2025_06_16_pkey; Type: CONSTRAINT; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages_2025_06_16
    ADD CONSTRAINT messages_2025_06_16_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_06_17 messages_2025_06_17_pkey; Type: CONSTRAINT; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages_2025_06_17
    ADD CONSTRAINT messages_2025_06_17_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_06_18 messages_2025_06_18_pkey; Type: CONSTRAINT; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages_2025_06_18
    ADD CONSTRAINT messages_2025_06_18_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_06_19 messages_2025_06_19_pkey; Type: CONSTRAINT; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages_2025_06_19
    ADD CONSTRAINT messages_2025_06_19_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_06_20 messages_2025_06_20_pkey; Type: CONSTRAINT; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages_2025_06_20
    ADD CONSTRAINT messages_2025_06_20_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: messages_2025_06_21 messages_2025_06_21_pkey; Type: CONSTRAINT; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.messages_2025_06_21
    ADD CONSTRAINT messages_2025_06_21_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: prefixes prefixes_pkey; Type: CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT prefixes_pkey PRIMARY KEY (bucket_id, level, name);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: vikasalagarsamy
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: vikasalagarsamy
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: supabase_migrations; Owner: vikasalagarsamy
--

ALTER TABLE ONLY supabase_migrations.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: extensions_tenant_external_id_index; Type: INDEX; Schema: _realtime; Owner: vikasalagarsamy
--

CREATE INDEX extensions_tenant_external_id_index ON _realtime.extensions USING btree (tenant_external_id);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: vikasalagarsamy
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: vikasalagarsamy
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: branches_branch_code_idx; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX branches_branch_code_idx ON public.branches USING btree (branch_code);


--
-- Name: companies_company_code_idx; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX companies_company_code_idx ON public.companies USING btree (company_code);


--
-- Name: deliverable_master_category_idx; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX deliverable_master_category_idx ON public.deliverable_master USING btree (category);


--
-- Name: deliverable_master_category_type_idx; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX deliverable_master_category_type_idx ON public.deliverable_master USING btree (category, type);


--
-- Name: deliverable_master_deliverable_name_idx; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX deliverable_master_deliverable_name_idx ON public.deliverable_master USING btree (deliverable_name);


--
-- Name: deliverable_master_type_idx; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX deliverable_master_type_idx ON public.deliverable_master USING btree (type);


--
-- Name: follow_up_auditions_audition_id_idx; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX follow_up_auditions_audition_id_idx ON public.follow_up_auditions USING btree (audition_id);


--
-- Name: idx_accounting_workflows_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_accounting_workflows_quotation_id ON public.accounting_workflows USING btree (quotation_id);


--
-- Name: idx_action_recommendations_completed; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_action_recommendations_completed ON public.action_recommendations USING btree (is_completed);


--
-- Name: idx_action_recommendations_priority; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_action_recommendations_priority ON public.action_recommendations USING btree (priority);


--
-- Name: idx_action_recommendations_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_action_recommendations_quotation_id ON public.action_recommendations USING btree (quotation_id);


--
-- Name: idx_activities_action_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_activities_action_type ON public.activities USING btree (action_type);


--
-- Name: idx_activities_action_type_entity_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_activities_action_type_entity_id ON public.activities USING btree (action_type, entity_id, created_at DESC) WHERE ((action_type)::text = 'reject'::text);


--
-- Name: idx_activities_created_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_activities_created_at ON public.activities USING btree (created_at DESC);


--
-- Name: idx_activities_entity_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_activities_entity_id ON public.activities USING btree (entity_id);


--
-- Name: idx_activities_entity_id_action_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_activities_entity_id_action_type ON public.activities USING btree (entity_id, action_type);


--
-- Name: idx_activities_entity_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_activities_entity_type ON public.activities USING btree (entity_type);


--
-- Name: idx_ai_behavior_settings_active; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_behavior_settings_active ON public.ai_behavior_settings USING btree (is_active);


--
-- Name: idx_ai_configurations_active; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_configurations_active ON public.ai_configurations USING btree (is_active);


--
-- Name: idx_ai_configurations_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_configurations_type ON public.ai_configurations USING btree (config_type);


--
-- Name: idx_ai_contacts_phone; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_contacts_phone ON public.ai_contacts USING btree (phone);


--
-- Name: idx_ai_decision_log_notification_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_decision_log_notification_id ON public.ai_decision_log USING btree (notification_id);


--
-- Name: idx_ai_performance_model_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_performance_model_type ON public.ai_performance_tracking USING btree (model_type);


--
-- Name: idx_ai_prompt_templates_active; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_prompt_templates_active ON public.ai_prompt_templates USING btree (is_active);


--
-- Name: idx_ai_prompt_templates_default; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_prompt_templates_default ON public.ai_prompt_templates USING btree (is_default);


--
-- Name: idx_ai_recommendations_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_recommendations_type ON public.ai_recommendations USING btree (recommendation_type);


--
-- Name: idx_ai_recommendations_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_recommendations_user_id ON public.ai_recommendations USING btree (user_id);


--
-- Name: idx_ai_tasks_assigned_to; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_assigned_to ON public.ai_tasks USING btree (assigned_to);


--
-- Name: idx_ai_tasks_assigned_to_employee_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_assigned_to_employee_id ON public.ai_tasks USING btree (assigned_to_employee_id);


--
-- Name: idx_ai_tasks_category; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_category ON public.ai_tasks USING btree (category);


--
-- Name: idx_ai_tasks_client_name; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_client_name ON public.ai_tasks USING btree (client_name);


--
-- Name: idx_ai_tasks_created_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_created_at ON public.ai_tasks USING btree (created_at);


--
-- Name: idx_ai_tasks_employee_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_employee_status ON public.ai_tasks USING btree (assigned_to_employee_id, status);


--
-- Name: idx_ai_tasks_estimated_value; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_estimated_value ON public.ai_tasks USING btree (estimated_value);


--
-- Name: idx_ai_tasks_lead_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_lead_id ON public.ai_tasks USING btree (lead_id);


--
-- Name: idx_ai_tasks_priority; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_priority ON public.ai_tasks USING btree (priority);


--
-- Name: idx_ai_tasks_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_quotation_id ON public.ai_tasks USING btree (quotation_id);


--
-- Name: idx_ai_tasks_quotation_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_quotation_status ON public.ai_tasks USING btree (quotation_id, status);


--
-- Name: idx_ai_tasks_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_status ON public.ai_tasks USING btree (status);


--
-- Name: idx_ai_tasks_status_due; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_status_due ON public.ai_communication_tasks USING btree (status, due_date) WHERE ((status)::text <> 'completed'::text);


--
-- Name: idx_ai_tasks_status_quotation; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_status_quotation ON public.ai_tasks USING btree (status, quotation_id);


--
-- Name: idx_ai_tasks_task_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_task_type ON public.ai_tasks USING btree (task_type);


--
-- Name: idx_ai_tasks_unique_lead_assignment; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX idx_ai_tasks_unique_lead_assignment ON public.ai_tasks USING btree (lead_id, assigned_to_employee_id, task_title) WHERE ((lead_id IS NOT NULL) AND (assigned_to_employee_id IS NOT NULL) AND (task_title IS NOT NULL) AND ((status)::text <> 'completed'::text));


--
-- Name: idx_ai_tasks_workflow_lookup; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_ai_tasks_workflow_lookup ON public.ai_tasks USING btree (quotation_id, task_type, status);


--
-- Name: idx_analytics_cache_key; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_analytics_cache_key ON public.analytics_cache USING btree (cache_key);


--
-- Name: idx_analytics_metrics_name_time; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_analytics_metrics_name_time ON public.analytics_metrics USING btree (metric_name, recorded_at DESC);


--
-- Name: idx_branches_id_name; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_branches_id_name ON public.branches USING btree (id) INCLUDE (name);


--
-- Name: idx_bug_attachments_bug_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_bug_attachments_bug_id ON public.bug_attachments USING btree (bug_id);


--
-- Name: idx_bug_comments_bug_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_bug_comments_bug_id ON public.bug_comments USING btree (bug_id);


--
-- Name: idx_bugs_assignee; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_bugs_assignee ON public.bugs USING btree (assignee_id);


--
-- Name: idx_bugs_severity; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_bugs_severity ON public.bugs USING btree (severity);


--
-- Name: idx_bugs_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_bugs_status ON public.bugs USING btree (status);


--
-- Name: idx_business_lifecycle_stage; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_business_lifecycle_stage ON public.quotation_business_lifecycle USING btree (current_stage, next_follow_up_due);


--
-- Name: idx_business_rules_created_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_business_rules_created_at ON public.business_rules USING btree (created_at);


--
-- Name: idx_business_rules_department; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_business_rules_department ON public.business_rules USING btree (department);


--
-- Name: idx_business_rules_enabled; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_business_rules_enabled ON public.business_rules USING btree (enabled);


--
-- Name: idx_business_rules_priority; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_business_rules_priority ON public.business_rules USING btree (priority);


--
-- Name: idx_business_rules_task_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_business_rules_task_type ON public.business_rules USING btree (task_type);


--
-- Name: idx_business_trends_analyzed_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_business_trends_analyzed_at ON public.business_trends USING btree (analyzed_at DESC);


--
-- Name: idx_business_trends_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_business_trends_type ON public.business_trends USING btree (trend_type);


--
-- Name: idx_call_transcriptions_call_direction; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_call_transcriptions_call_direction ON public.call_transcriptions USING btree (call_direction);


--
-- Name: idx_call_transcriptions_call_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_call_transcriptions_call_status ON public.call_transcriptions USING btree (call_status);


--
-- Name: idx_call_transcriptions_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_call_transcriptions_status ON public.call_transcriptions USING btree (status);


--
-- Name: idx_call_transcriptions_task_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_call_transcriptions_task_id ON public.call_transcriptions USING btree (task_id);


--
-- Name: idx_call_triggers_employee_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_call_triggers_employee_id ON public.call_triggers USING btree (employee_id);


--
-- Name: idx_call_triggers_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_call_triggers_status ON public.call_triggers USING btree (status);


--
-- Name: idx_call_triggers_triggered_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_call_triggers_triggered_at ON public.call_triggers USING btree (triggered_at);


--
-- Name: idx_client_insights_client_name; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_client_insights_client_name ON public.client_insights USING btree (client_name);


--
-- Name: idx_client_insights_conversion_probability; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_client_insights_conversion_probability ON public.client_insights USING btree (conversion_probability DESC);


--
-- Name: idx_clients_client_code; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_clients_client_code ON public.clients USING btree (client_code);


--
-- Name: idx_clients_company_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_clients_company_id ON public.clients USING btree (company_id);


--
-- Name: idx_communication_timeline_quotation; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_communication_timeline_quotation ON public.client_communication_timeline USING btree (quotation_id, "timestamp" DESC);


--
-- Name: idx_communications_ai_processed; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_communications_ai_processed ON public.communications USING btree (ai_processed);


--
-- Name: idx_communications_channel_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_communications_channel_type ON public.communications USING btree (channel_type);


--
-- Name: idx_communications_sender_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_communications_sender_type ON public.communications USING btree (sender_type);


--
-- Name: idx_communications_sent_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_communications_sent_at ON public.communications USING btree (sent_at);


--
-- Name: idx_companies_id_name; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_companies_id_name ON public.companies USING btree (id) INCLUDE (name);


--
-- Name: idx_deliverables_cat; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_deliverables_cat ON public.deliverables USING btree (deliverable_cat);


--
-- Name: idx_deliverables_deliverable_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_deliverables_deliverable_id ON public.deliverables USING btree (deliverable_id);


--
-- Name: idx_deliverables_sort_order; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_deliverables_sort_order ON public.deliverables USING btree (sort_order);


--
-- Name: idx_deliverables_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_deliverables_status ON public.deliverables USING btree (status);


--
-- Name: idx_deliverables_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_deliverables_type ON public.deliverables USING btree (deliverable_type);


--
-- Name: idx_department_instructions_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_department_instructions_quotation_id ON public.department_instructions USING btree (quotation_id);


--
-- Name: idx_dynamic_menus_menu_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_dynamic_menus_menu_id ON public.dynamic_menus USING btree (menu_id);


--
-- Name: idx_dynamic_menus_parent; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_dynamic_menus_parent ON public.dynamic_menus USING btree (parent_id);


--
-- Name: idx_employee_devices_active; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_employee_devices_active ON public.employee_devices USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_employee_devices_employee_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_employee_devices_employee_id ON public.employee_devices USING btree (employee_id);


--
-- Name: idx_employees_active; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_employees_active ON public.employees USING btree (status) WHERE ((status)::text = 'active'::text);


--
-- Name: idx_employees_department_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_employees_department_id ON public.employees USING btree (department_id);


--
-- Name: idx_employees_job_title; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_employees_job_title ON public.employees USING btree (job_title);


--
-- Name: idx_employees_role_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_employees_role_id ON public.employees USING btree (role_id);


--
-- Name: idx_employees_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_employees_status ON public.employees USING btree (status);


--
-- Name: idx_employees_username; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_employees_username ON public.employees USING btree (username);


--
-- Name: idx_events_event_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_events_event_id ON public.events USING btree (event_id);


--
-- Name: idx_events_is_active; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_events_is_active ON public.events USING btree (is_active);


--
-- Name: idx_events_name; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_events_name ON public.events USING btree (name);


--
-- Name: idx_instagram_analytics_date; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_analytics_date ON public.instagram_analytics USING btree (date DESC);


--
-- Name: idx_instagram_comments_created_time; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_comments_created_time ON public.instagram_comments USING btree (created_time DESC);


--
-- Name: idx_instagram_comments_from_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_comments_from_user_id ON public.instagram_comments USING btree (from_user_id);


--
-- Name: idx_instagram_comments_post_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_comments_post_id ON public.instagram_comments USING btree (post_id);


--
-- Name: idx_instagram_interactions_timestamp; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_interactions_timestamp ON public.instagram_interactions USING btree ("timestamp" DESC);


--
-- Name: idx_instagram_interactions_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_interactions_type ON public.instagram_interactions USING btree (interaction_type);


--
-- Name: idx_instagram_interactions_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_interactions_user_id ON public.instagram_interactions USING btree (user_id);


--
-- Name: idx_instagram_mentions_created_time; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_mentions_created_time ON public.instagram_mentions USING btree (created_time DESC);


--
-- Name: idx_instagram_mentions_from_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_mentions_from_user_id ON public.instagram_mentions USING btree (from_user_id);


--
-- Name: idx_instagram_mentions_mention_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_mentions_mention_type ON public.instagram_mentions USING btree (mention_type);


--
-- Name: idx_instagram_messages_created_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_messages_created_at ON public.instagram_messages USING btree (created_at DESC);


--
-- Name: idx_instagram_messages_from_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_messages_from_user_id ON public.instagram_messages USING btree (from_user_id);


--
-- Name: idx_instagram_messages_is_from_client; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_messages_is_from_client ON public.instagram_messages USING btree (is_from_client);


--
-- Name: idx_instagram_messages_timestamp; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_messages_timestamp ON public.instagram_messages USING btree ("timestamp" DESC);


--
-- Name: idx_instagram_story_mentions_from_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_story_mentions_from_user_id ON public.instagram_story_mentions USING btree (from_user_id);


--
-- Name: idx_instagram_story_mentions_timestamp; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instagram_story_mentions_timestamp ON public.instagram_story_mentions USING btree ("timestamp" DESC);


--
-- Name: idx_instruction_approvals_instruction_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_instruction_approvals_instruction_id ON public.instruction_approvals USING btree (instruction_id);


--
-- Name: idx_lead_followups_completed_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_lead_followups_completed_at ON public.lead_followups USING btree (completed_at);


--
-- Name: idx_lead_followups_created_by; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_lead_followups_created_by ON public.lead_followups USING btree (created_by);


--
-- Name: idx_lead_followups_lead_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_lead_followups_lead_id ON public.lead_followups USING btree (lead_id);


--
-- Name: idx_lead_followups_priority; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_lead_followups_priority ON public.lead_followups USING btree (priority);


--
-- Name: idx_lead_followups_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_lead_followups_quotation_id ON public.lead_followups USING btree (quotation_id);


--
-- Name: idx_lead_followups_scheduled_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_lead_followups_scheduled_at ON public.lead_followups USING btree (scheduled_at);


--
-- Name: idx_lead_followups_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_lead_followups_status ON public.lead_followups USING btree (status);


--
-- Name: idx_lead_task_performance_lead_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_lead_task_performance_lead_id ON public.lead_task_performance USING btree (lead_id);


--
-- Name: idx_leads_assigned_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_assigned_status ON public.leads USING btree (assigned_to, status);


--
-- Name: idx_leads_assigned_to; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_assigned_to ON public.leads USING btree (assigned_to);


--
-- Name: idx_leads_assigned_to_uuid; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_assigned_to_uuid ON public.leads USING btree (assigned_to_uuid);


--
-- Name: idx_leads_branch_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_branch_id ON public.leads USING btree (branch_id);


--
-- Name: idx_leads_company_branch; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_company_branch ON public.leads USING btree (company_id, branch_id);


--
-- Name: idx_leads_company_branch_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_company_branch_status ON public.leads USING btree (company_id, branch_id) WHERE ((status)::text = 'REJECTED'::text);


--
-- Name: idx_leads_company_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_company_id ON public.leads USING btree (company_id);


--
-- Name: idx_leads_conversion_stage; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_conversion_stage ON public.leads USING btree (conversion_stage);


--
-- Name: idx_leads_created_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_created_at ON public.leads USING btree (created_at DESC);


--
-- Name: idx_leads_expected_value; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_expected_value ON public.leads USING btree (expected_value);


--
-- Name: idx_leads_last_contact_date; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_last_contact_date ON public.leads USING btree (last_contact_date);


--
-- Name: idx_leads_lead_number; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_lead_number ON public.leads USING btree (lead_number);


--
-- Name: idx_leads_lead_score; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_lead_score ON public.leads USING btree (lead_score);


--
-- Name: idx_leads_next_follow_up_date; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_next_follow_up_date ON public.leads USING btree (next_follow_up_date);


--
-- Name: idx_leads_prev_assigned; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_prev_assigned ON public.leads USING btree (previous_assigned_to);


--
-- Name: idx_leads_priority; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_priority ON public.leads USING btree (priority);


--
-- Name: idx_leads_reassigned_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_reassigned_at ON public.leads USING btree (reassigned_at);


--
-- Name: idx_leads_reassigned_by; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_reassigned_by ON public.leads USING btree (reassigned_by);


--
-- Name: idx_leads_reassigned_from_branch; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_reassigned_from_branch ON public.leads USING btree (reassigned_from_branch_id);


--
-- Name: idx_leads_reassigned_from_company; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_reassigned_from_company ON public.leads USING btree (reassigned_from_company_id);


--
-- Name: idx_leads_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_status ON public.leads USING btree (status);


--
-- Name: idx_leads_updated_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_updated_at ON public.leads USING btree (updated_at);


--
-- Name: idx_leads_wedding_date; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_leads_wedding_date ON public.leads USING btree (wedding_date);


--
-- Name: idx_management_insights_addressed; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_management_insights_addressed ON public.management_insights USING btree (is_addressed);


--
-- Name: idx_management_insights_priority; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_management_insights_priority ON public.management_insights USING btree (priority);


--
-- Name: idx_menu_items_section; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_menu_items_section ON public.menu_items USING btree (section_name);


--
-- Name: idx_menu_items_sort; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_menu_items_sort ON public.menu_items USING btree (sort_order);


--
-- Name: idx_menu_items_tracking_menu_item_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_menu_items_tracking_menu_item_id ON public.menu_items_tracking USING btree (menu_item_id);


--
-- Name: idx_message_analysis_sentiment; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_message_analysis_sentiment ON public.message_analysis USING btree (sentiment, urgency_level);


--
-- Name: idx_mv_user_roles_fast_email; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX idx_mv_user_roles_fast_email ON public.mv_user_roles_fast USING btree (lower((email)::text));


--
-- Name: idx_mv_user_roles_fast_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_mv_user_roles_fast_user_id ON public.mv_user_roles_fast USING btree (user_id);


--
-- Name: idx_notification_batches_last_sent; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notification_batches_last_sent ON public.notification_batches USING btree (last_sent);


--
-- Name: idx_notification_batches_user_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notification_batches_user_type ON public.notification_batches USING btree (user_id, notification_type);


--
-- Name: idx_notification_engagement_notification_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notification_engagement_notification_id ON public.notification_engagement USING btree (notification_id);


--
-- Name: idx_notification_engagement_user_event; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notification_engagement_user_event ON public.notification_engagement USING btree (user_id, event_type, created_at DESC);


--
-- Name: idx_notification_patterns_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notification_patterns_type ON public.notification_patterns USING btree (type);


--
-- Name: idx_notifications_created_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_created_at ON public.notifications USING btree (created_at DESC);


--
-- Name: idx_notifications_created_at_desc; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_created_at_desc ON public.notifications USING btree (created_at DESC);


--
-- Name: idx_notifications_employee_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_employee_id ON public.notifications USING btree (employee_id);


--
-- Name: idx_notifications_expires_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_expires_at ON public.notifications USING btree (expires_at);


--
-- Name: idx_notifications_is_read; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_is_read ON public.notifications USING btree (is_read);


--
-- Name: idx_notifications_metadata_business; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_metadata_business ON public.notifications USING gin (metadata) WHERE ((metadata ->> 'business_event'::text) = 'true'::text);


--
-- Name: idx_notifications_priority; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_priority ON public.notifications USING btree (priority);


--
-- Name: idx_notifications_priority_created; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_priority_created ON public.notifications USING btree (priority, created_at DESC);


--
-- Name: idx_notifications_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_quotation_id ON public.notifications USING btree (quotation_id);


--
-- Name: idx_notifications_recipient; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_recipient ON public.notifications USING btree (recipient_role, recipient_id) WHERE (recipient_role IS NOT NULL);


--
-- Name: idx_notifications_scheduled_for; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_scheduled_for ON public.notifications USING btree (scheduled_for) WHERE (scheduled_for IS NOT NULL);


--
-- Name: idx_notifications_target_user; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_target_user ON public.notifications USING btree (target_user);


--
-- Name: idx_notifications_type; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_notifications_type ON public.notifications USING btree (type);


--
-- Name: idx_payments_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_payments_quotation_id ON public.payments USING btree (quotation_id);


--
-- Name: idx_payments_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_payments_status ON public.payments USING btree (status);


--
-- Name: idx_personalization_learning_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_personalization_learning_user_id ON public.personalization_learning USING btree (user_id);


--
-- Name: idx_post_sale_confirmations_call_date; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_post_sale_confirmations_call_date ON public.post_sale_confirmations USING btree (call_date);


--
-- Name: idx_post_sale_confirmations_confirmed_by; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_post_sale_confirmations_confirmed_by ON public.post_sale_confirmations USING btree (confirmed_by_user_id);


--
-- Name: idx_post_sale_confirmations_follow_up; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_post_sale_confirmations_follow_up ON public.post_sale_confirmations USING btree (follow_up_required, follow_up_date);


--
-- Name: idx_post_sale_confirmations_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_post_sale_confirmations_quotation_id ON public.post_sale_confirmations USING btree (quotation_id);


--
-- Name: idx_post_sales_workflows_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_post_sales_workflows_quotation_id ON public.post_sales_workflows USING btree (quotation_id);


--
-- Name: idx_predictive_insights_probability; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_predictive_insights_probability ON public.predictive_insights USING btree (probability DESC);


--
-- Name: idx_predictive_insights_user_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_predictive_insights_user_status ON public.predictive_insights USING btree (user_id, status);


--
-- Name: idx_quotation_approvals_created_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_approvals_created_at ON public.quotation_approvals USING btree (created_at);


--
-- Name: idx_quotation_approvals_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_approvals_quotation_id ON public.quotation_approvals USING btree (quotation_id);


--
-- Name: idx_quotation_approvals_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_approvals_status ON public.quotation_approvals USING btree (approval_status);


--
-- Name: idx_quotation_approvals_workflow; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_approvals_workflow ON public.quotation_approvals USING btree (quotation_id, approval_status, approval_date);


--
-- Name: idx_quotation_edit_approvals_approval_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_edit_approvals_approval_status ON public.quotation_edit_approvals USING btree (approval_status);


--
-- Name: idx_quotation_edit_approvals_created_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_edit_approvals_created_at ON public.quotation_edit_approvals USING btree (created_at);


--
-- Name: idx_quotation_edit_approvals_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_edit_approvals_quotation_id ON public.quotation_edit_approvals USING btree (quotation_id);


--
-- Name: idx_quotation_edit_approvals_requested_by; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_edit_approvals_requested_by ON public.quotation_edit_approvals USING btree (requested_by);


--
-- Name: idx_quotation_events_date; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_events_date ON public.quotation_events USING btree (event_date);


--
-- Name: idx_quotation_events_event_date; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_events_event_date ON public.quotation_events USING btree (event_date);


--
-- Name: idx_quotation_events_quotation_date; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_events_quotation_date ON public.quotation_events USING btree (quotation_id, event_date);


--
-- Name: idx_quotation_events_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_events_quotation_id ON public.quotation_events USING btree (quotation_id);


--
-- Name: idx_quotation_predictions_predicted_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_predictions_predicted_at ON public.quotation_predictions USING btree (predicted_at DESC);


--
-- Name: idx_quotation_predictions_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_predictions_quotation_id ON public.quotation_predictions USING btree (quotation_id);


--
-- Name: idx_quotation_revisions_original_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotation_revisions_original_id ON public.quotation_revisions USING btree (original_quotation_id);


--
-- Name: idx_quotations_client_name; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_client_name ON public.quotations USING btree (client_name);


--
-- Name: idx_quotations_client_workflow; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_client_workflow ON public.quotations USING btree (client_name, workflow_status);


--
-- Name: idx_quotations_created_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_created_at ON public.quotations USING btree (created_at);


--
-- Name: idx_quotations_created_by; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_created_by ON public.quotations USING btree (created_by);


--
-- Name: idx_quotations_lead_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_lead_id ON public.quotations USING btree (lead_id);


--
-- Name: idx_quotations_phone_numbers; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_phone_numbers ON public.quotations USING btree (mobile, whatsapp, alternate_mobile, alternate_whatsapp);


--
-- Name: idx_quotations_quotation_number; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_quotation_number ON public.quotations USING btree (quotation_number);


--
-- Name: idx_quotations_revision_count; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_revision_count ON public.quotations USING btree (revision_count);


--
-- Name: idx_quotations_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_status ON public.quotations USING btree (status);


--
-- Name: idx_quotations_status_created; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_status_created ON public.quotations USING btree (status, created_at);


--
-- Name: idx_quotations_status_created_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_status_created_at ON public.quotations USING btree (status, created_at DESC);


--
-- Name: idx_quotations_total_amount; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_total_amount ON public.quotations USING btree (total_amount) WHERE (total_amount > (0)::numeric);


--
-- Name: idx_quotations_workflow_created; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_workflow_created ON public.quotations USING btree (workflow_status, created_at DESC);


--
-- Name: idx_quotations_workflow_status; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_quotations_workflow_status ON public.quotations USING btree (workflow_status);


--
-- Name: idx_revenue_forecasts_period; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_revenue_forecasts_period ON public.revenue_forecasts USING btree (period_start, period_end);


--
-- Name: idx_role_menu_access_menu; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_role_menu_access_menu ON public.role_menu_access USING btree (menu_id);


--
-- Name: idx_role_menu_access_role; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_role_menu_access_role ON public.role_menu_access USING btree (role_name);


--
-- Name: idx_roles_id_minimal; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_roles_id_minimal ON public.roles USING btree (id);


--
-- Name: idx_roles_title_minimal; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_roles_title_minimal ON public.roles USING btree (title);


--
-- Name: idx_roles_title_permissions; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_roles_title_permissions ON public.roles USING btree (title, permissions) WHERE (title IS NOT NULL);


--
-- Name: idx_sales_activities_date; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sales_activities_date ON public.sales_activities USING btree (activity_date DESC);


--
-- Name: idx_sales_activities_employee_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sales_activities_employee_id ON public.sales_activities USING btree (employee_id);


--
-- Name: idx_sales_activities_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sales_activities_quotation_id ON public.sales_activities USING btree (quotation_id);


--
-- Name: idx_sales_performance_metrics_employee_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sales_performance_metrics_employee_id ON public.sales_performance_metrics USING btree (employee_id);


--
-- Name: idx_sales_performance_metrics_period; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sales_performance_metrics_period ON public.sales_performance_metrics USING btree (metric_period DESC);


--
-- Name: idx_sales_performance_metrics_unique; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX idx_sales_performance_metrics_unique ON public.sales_performance_metrics USING btree (employee_id, metric_period);


--
-- Name: idx_sales_performance_period_employee; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sales_performance_period_employee ON public.sales_performance_metrics USING btree (metric_period DESC, employee_id);


--
-- Name: idx_sales_performance_score; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sales_performance_score ON public.sales_performance_metrics USING btree (performance_score DESC) WHERE (performance_score IS NOT NULL);


--
-- Name: idx_sales_team_members_employee_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sales_team_members_employee_id ON public.sales_team_members USING btree (employee_id);


--
-- Name: idx_sales_team_members_role; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sales_team_members_role ON public.sales_team_members USING btree (role);


--
-- Name: idx_sequence_rules_active; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sequence_rules_active ON public.sequence_rules USING btree (is_active);


--
-- Name: idx_sequence_rules_template; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sequence_rules_template ON public.sequence_rules USING btree (sequence_template_id);


--
-- Name: idx_sequence_rules_template_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sequence_rules_template_id ON public.sequence_rules USING btree (sequence_template_id);


--
-- Name: idx_sequence_steps_number; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sequence_steps_number ON public.sequence_steps USING btree (step_number);


--
-- Name: idx_sequence_steps_step_number; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sequence_steps_step_number ON public.sequence_steps USING btree (step_number);


--
-- Name: idx_sequence_steps_template; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sequence_steps_template ON public.sequence_steps USING btree (sequence_template_id);


--
-- Name: idx_sequence_steps_template_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sequence_steps_template_id ON public.sequence_steps USING btree (sequence_template_id);


--
-- Name: idx_sequence_templates_active; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sequence_templates_active ON public.task_sequence_templates USING btree (is_active);


--
-- Name: idx_sequence_templates_category; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_sequence_templates_category ON public.task_sequence_templates USING btree (category);


--
-- Name: idx_system_logs_action_time; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_system_logs_action_time ON public.system_logs USING btree (action, created_at DESC);


--
-- Name: idx_task_dashboard_summary_employee; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_task_dashboard_summary_employee ON public.task_dashboard_summary USING btree (assigned_to_employee_id);


--
-- Name: idx_task_generation_log_lead_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_task_generation_log_lead_id ON public.task_generation_log USING btree (lead_id);


--
-- Name: idx_task_performance_metrics_assigned_to; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_task_performance_metrics_assigned_to ON public.task_performance_metrics USING btree (assigned_to);


--
-- Name: idx_task_performance_metrics_created_date; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_task_performance_metrics_created_date ON public.task_performance_metrics USING btree (created_date);


--
-- Name: idx_task_status_history_changed_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_task_status_history_changed_at ON public.task_status_history USING btree (changed_at);


--
-- Name: idx_task_status_history_task_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_task_status_history_task_id ON public.task_status_history USING btree (task_id);


--
-- Name: idx_task_templates_active; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_task_templates_active ON public.task_sequence_templates USING btree (is_active);


--
-- Name: idx_task_templates_category; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_task_templates_category ON public.task_sequence_templates USING btree (category);


--
-- Name: idx_team_performance_trends_period; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_team_performance_trends_period ON public.team_performance_trends USING btree (period_start DESC);


--
-- Name: idx_unified_permissions_menu; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_unified_permissions_menu ON public.unified_role_permissions USING btree (menu_string_id);


--
-- Name: idx_unified_permissions_role; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_unified_permissions_role ON public.unified_role_permissions USING btree (role_id);


--
-- Name: idx_user_accounts_email_fast; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_accounts_email_fast ON public.user_accounts USING btree (lower((email)::text)) WHERE (email IS NOT NULL);


--
-- Name: idx_user_accounts_email_minimal; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_accounts_email_minimal ON public.user_accounts USING btree (email);


--
-- Name: idx_user_accounts_employee_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_accounts_employee_id ON public.user_accounts USING btree (employee_id);


--
-- Name: idx_user_accounts_id_role; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_accounts_id_role ON public.user_accounts USING btree (id, role_id) WHERE (id IS NOT NULL);


--
-- Name: idx_user_accounts_login_composite; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_accounts_login_composite ON public.user_accounts USING btree (lower((email)::text), password_hash, role_id) WHERE ((email IS NOT NULL) AND (password_hash IS NOT NULL));


--
-- Name: idx_user_accounts_role_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_accounts_role_id ON public.user_accounts USING btree (role_id);


--
-- Name: idx_user_activity_history_user_id_created; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_activity_history_user_id_created ON public.user_activity_history USING btree (user_id, created_at DESC);


--
-- Name: idx_user_ai_profiles_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_ai_profiles_user_id ON public.user_ai_profiles USING btree (user_id);


--
-- Name: idx_user_behavior_analytics_engagement; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_behavior_analytics_engagement ON public.user_behavior_analytics USING btree (engagement_score DESC);


--
-- Name: idx_user_behavior_analytics_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_behavior_analytics_user_id ON public.user_behavior_analytics USING btree (user_id);


--
-- Name: idx_user_engagement_created_at; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_engagement_created_at ON public.user_engagement_analytics USING btree (created_at DESC);


--
-- Name: idx_user_engagement_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_engagement_user_id ON public.user_engagement_analytics USING btree (user_id);


--
-- Name: idx_user_preferences_user_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_user_preferences_user_id ON public.user_preferences USING btree (user_id);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- Name: idx_whatsapp_messages_ai_analyzed; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_whatsapp_messages_ai_analyzed ON public.whatsapp_messages USING btree (ai_analyzed) WHERE (ai_analyzed = false);


--
-- Name: idx_whatsapp_messages_client_phone; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_whatsapp_messages_client_phone ON public.whatsapp_messages USING btree (client_phone);


--
-- Name: idx_whatsapp_messages_phone_timestamp; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_whatsapp_messages_phone_timestamp ON public.whatsapp_messages USING btree (client_phone, "timestamp" DESC);


--
-- Name: idx_whatsapp_messages_quotation_timestamp; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_whatsapp_messages_quotation_timestamp ON public.whatsapp_messages USING btree (quotation_id, "timestamp" DESC);


--
-- Name: idx_workflow_history_quotation_id; Type: INDEX; Schema: public; Owner: vikasalagarsamy
--

CREATE INDEX idx_workflow_history_quotation_id ON public.quotation_workflow_history USING btree (quotation_id);


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: vikasalagarsamy
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: subscription_subscription_id_entity_filters_key; Type: INDEX; Schema: realtime; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_key ON realtime.subscription USING btree (subscription_id, entity, filters);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: vikasalagarsamy
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: vikasalagarsamy
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: vikasalagarsamy
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_prefixes_lower_name; Type: INDEX; Schema: storage; Owner: vikasalagarsamy
--

CREATE INDEX idx_prefixes_lower_name ON storage.prefixes USING btree (bucket_id, level, ((string_to_array(name, '/'::text))[level]), lower(name) text_pattern_ops);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: vikasalagarsamy
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: vikasalagarsamy
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: vikasalagarsamy
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: messages_2025_06_15_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_06_15_pkey;


--
-- Name: messages_2025_06_16_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_06_16_pkey;


--
-- Name: messages_2025_06_17_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_06_17_pkey;


--
-- Name: messages_2025_06_18_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_06_18_pkey;


--
-- Name: messages_2025_06_19_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_06_19_pkey;


--
-- Name: messages_2025_06_20_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_06_20_pkey;


--
-- Name: messages_2025_06_21_pkey; Type: INDEX ATTACH; Schema: realtime; Owner: vikasalagarsamy
--

ALTER INDEX realtime.messages_pkey ATTACH PARTITION realtime.messages_2025_06_21_pkey;


--
-- Name: employees employee_status_change_trigger; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER employee_status_change_trigger AFTER UPDATE OF status ON public.employees FOR EACH ROW EXECUTE FUNCTION public.handle_lead_reallocation();


--
-- Name: leads ensure_lead_source_id; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER ensure_lead_source_id BEFORE INSERT OR UPDATE ON public.leads FOR EACH ROW EXECUTE FUNCTION public.set_lead_source_id();


--
-- Name: leads ensure_rejection_fields_trigger; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER ensure_rejection_fields_trigger BEFORE INSERT OR UPDATE ON public.leads FOR EACH ROW EXECUTE FUNCTION public.ensure_rejection_fields();


--
-- Name: branches normalize_branch_location; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER normalize_branch_location BEFORE INSERT OR UPDATE ON public.branches FOR EACH ROW EXECUTE FUNCTION public.normalize_location_trigger();


--
-- Name: leads normalize_lead_location; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER normalize_lead_location BEFORE INSERT OR UPDATE ON public.leads FOR EACH ROW EXECUTE FUNCTION public.normalize_location_trigger();


--
-- Name: events set_updated_at; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER set_updated_at BEFORE UPDATE ON public.events FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: whatsapp_messages trigger_add_to_communication_timeline; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_add_to_communication_timeline AFTER INSERT ON public.whatsapp_messages FOR EACH ROW EXECUTE FUNCTION public.add_to_communication_timeline();


--
-- Name: bug_comments trigger_bug_comments_updated_at; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_bug_comments_updated_at BEFORE UPDATE ON public.bug_comments FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: bugs trigger_bugs_updated_at; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_bugs_updated_at BEFORE UPDATE ON public.bugs FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: ai_tasks trigger_prevent_duplicate_lead_tasks; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_prevent_duplicate_lead_tasks BEFORE INSERT ON public.ai_tasks FOR EACH ROW EXECUTE FUNCTION public.prevent_duplicate_lead_tasks();


--
-- Name: quotations trigger_sync_task_quotation_value; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_sync_task_quotation_value AFTER INSERT OR UPDATE OF total_amount ON public.quotations FOR EACH ROW EXECUTE FUNCTION public.sync_task_quotation_value();


--
-- Name: user_activity_history trigger_track_user_activity; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_track_user_activity AFTER INSERT ON public.user_activity_history FOR EACH ROW EXECUTE FUNCTION public.track_user_activity();


--
-- Name: whatsapp_messages trigger_update_conversation_session; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_update_conversation_session AFTER INSERT ON public.whatsapp_messages FOR EACH ROW EXECUTE FUNCTION public.update_conversation_session();


--
-- Name: notification_engagement trigger_update_engagement_score; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_update_engagement_score AFTER INSERT ON public.notification_engagement FOR EACH ROW EXECUTE FUNCTION public.update_user_engagement_score();


--
-- Name: quotation_approvals trigger_update_quotation_approval_timestamp; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_update_quotation_approval_timestamp BEFORE UPDATE ON public.quotation_approvals FOR EACH ROW EXECUTE FUNCTION public.update_quotation_approval_timestamp();


--
-- Name: quotation_edit_approvals trigger_update_quotation_edit_approvals_updated_at; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_update_quotation_edit_approvals_updated_at BEFORE UPDATE ON public.quotation_edit_approvals FOR EACH ROW EXECUTE FUNCTION public.update_quotation_edit_approvals_updated_at();


--
-- Name: quotation_approvals trigger_update_quotation_workflow_on_approval; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_update_quotation_workflow_on_approval AFTER INSERT OR UPDATE ON public.quotation_approvals FOR EACH ROW EXECUTE FUNCTION public.update_quotation_workflow_on_approval();


--
-- Name: quotation_approvals trigger_update_quotation_workflow_status; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER trigger_update_quotation_workflow_status AFTER UPDATE ON public.quotation_approvals FOR EACH ROW EXECUTE FUNCTION public.update_quotation_workflow_status();


--
-- Name: ai_tasks update_ai_tasks_updated_at; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_ai_tasks_updated_at BEFORE UPDATE ON public.ai_tasks FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: business_rules update_business_rules_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_business_rules_updated_at_trigger BEFORE UPDATE ON public.business_rules FOR EACH ROW EXECUTE FUNCTION public.update_business_rules_updated_at();


--
-- Name: call_triggers update_call_triggers_updated_at; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_call_triggers_updated_at BEFORE UPDATE ON public.call_triggers FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: clients update_clients_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_clients_updated_at_trigger BEFORE UPDATE ON public.clients FOR EACH ROW EXECUTE FUNCTION public.update_clients_updated_at();


--
-- Name: departments update_departments_modtime; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_departments_modtime BEFORE UPDATE ON public.departments FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: designations update_designations_modtime; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_designations_modtime BEFORE UPDATE ON public.designations FOR EACH ROW EXECUTE FUNCTION public.update_modified_column();


--
-- Name: employee_companies update_employee_companies_timestamp; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_employee_companies_timestamp BEFORE UPDATE ON public.employee_companies FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: employee_devices update_employee_devices_updated_at; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_employee_devices_updated_at BEFORE UPDATE ON public.employee_devices FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: employees update_employees_timestamp; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_employees_timestamp BEFORE UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: menu_items update_menu_items_timestamp; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_menu_items_timestamp BEFORE UPDATE ON public.menu_items FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: role_menu_permissions update_role_menu_permissions_timestamp; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_role_menu_permissions_timestamp BEFORE UPDATE ON public.role_menu_permissions FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: roles update_roles_timestamp; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_roles_timestamp BEFORE UPDATE ON public.roles FOR EACH ROW EXECUTE FUNCTION public.update_timestamp();


--
-- Name: suppliers update_supplier_timestamp; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_supplier_timestamp BEFORE UPDATE ON public.suppliers FOR EACH ROW EXECUTE FUNCTION public.update_supplier_timestamp();


--
-- Name: user_roles update_user_roles_updated_at; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_user_roles_updated_at BEFORE UPDATE ON public.user_roles FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: vendors update_vendor_timestamp; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER update_vendor_timestamp BEFORE UPDATE ON public.vendors FOR EACH ROW EXECUTE FUNCTION public.update_vendor_timestamp();


--
-- Name: employees validate_department_designation_trigger; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER validate_department_designation_trigger BEFORE INSERT OR UPDATE ON public.employees FOR EACH ROW EXECUTE FUNCTION public.validate_department_designation();


--
-- Name: employee_companies validate_employee_allocation_trigger; Type: TRIGGER; Schema: public; Owner: vikasalagarsamy
--

CREATE TRIGGER validate_employee_allocation_trigger BEFORE INSERT OR UPDATE ON public.employee_companies FOR EACH ROW EXECUTE FUNCTION public.validate_employee_allocation();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: vikasalagarsamy
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: vikasalagarsamy
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: objects objects_delete_delete_prefix; Type: TRIGGER; Schema: storage; Owner: vikasalagarsamy
--

CREATE TRIGGER objects_delete_delete_prefix AFTER DELETE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects objects_insert_create_prefix; Type: TRIGGER; Schema: storage; Owner: vikasalagarsamy
--

CREATE TRIGGER objects_insert_create_prefix BEFORE INSERT ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.objects_insert_prefix_trigger();


--
-- Name: objects objects_update_create_prefix; Type: TRIGGER; Schema: storage; Owner: vikasalagarsamy
--

CREATE TRIGGER objects_update_create_prefix BEFORE UPDATE ON storage.objects FOR EACH ROW WHEN (((new.name <> old.name) OR (new.bucket_id <> old.bucket_id))) EXECUTE FUNCTION storage.objects_update_prefix_trigger();


--
-- Name: prefixes prefixes_create_hierarchy; Type: TRIGGER; Schema: storage; Owner: vikasalagarsamy
--

CREATE TRIGGER prefixes_create_hierarchy BEFORE INSERT ON storage.prefixes FOR EACH ROW WHEN ((pg_trigger_depth() < 1)) EXECUTE FUNCTION storage.prefixes_insert_trigger();


--
-- Name: prefixes prefixes_delete_hierarchy; Type: TRIGGER; Schema: storage; Owner: vikasalagarsamy
--

CREATE TRIGGER prefixes_delete_hierarchy AFTER DELETE ON storage.prefixes FOR EACH ROW EXECUTE FUNCTION storage.delete_prefix_hierarchy_trigger();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: vikasalagarsamy
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: vikasalagarsamy
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES audit_security.permissions(id);


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES audit_security.roles(id);


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: audit_security; Owner: vikasalagarsamy
--

ALTER TABLE ONLY audit_security.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES audit_security.roles(id);


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: accounting_workflows accounting_workflows_instruction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.accounting_workflows
    ADD CONSTRAINT accounting_workflows_instruction_id_fkey FOREIGN KEY (instruction_id) REFERENCES public.department_instructions(id) ON DELETE CASCADE;


--
-- Name: accounting_workflows accounting_workflows_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.accounting_workflows
    ADD CONSTRAINT accounting_workflows_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payments(id) ON DELETE CASCADE;


--
-- Name: accounting_workflows accounting_workflows_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.accounting_workflows
    ADD CONSTRAINT accounting_workflows_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id) ON DELETE CASCADE;


--
-- Name: ai_communication_tasks ai_communication_tasks_assigned_to_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_communication_tasks
    ADD CONSTRAINT ai_communication_tasks_assigned_to_employee_id_fkey FOREIGN KEY (assigned_to_employee_id) REFERENCES public.employees(id);


--
-- Name: ai_communication_tasks ai_communication_tasks_conversation_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_communication_tasks
    ADD CONSTRAINT ai_communication_tasks_conversation_session_id_fkey FOREIGN KEY (conversation_session_id) REFERENCES public.conversation_sessions(id);


--
-- Name: ai_communication_tasks ai_communication_tasks_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_communication_tasks
    ADD CONSTRAINT ai_communication_tasks_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: ai_communication_tasks ai_communication_tasks_trigger_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_communication_tasks
    ADD CONSTRAINT ai_communication_tasks_trigger_message_id_fkey FOREIGN KEY (trigger_message_id) REFERENCES public.whatsapp_messages(id);


--
-- Name: ai_decision_log ai_decision_log_notification_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_decision_log
    ADD CONSTRAINT ai_decision_log_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;


--
-- Name: ai_recommendations ai_recommendations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_recommendations
    ADD CONSTRAINT ai_recommendations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: ai_tasks ai_tasks_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_tasks
    ADD CONSTRAINT ai_tasks_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: branches branches_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.branches
    ADD CONSTRAINT branches_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: bug_attachments bug_attachments_bug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.bug_attachments
    ADD CONSTRAINT bug_attachments_bug_id_fkey FOREIGN KEY (bug_id) REFERENCES public.bugs(id) ON DELETE CASCADE;


--
-- Name: bug_attachments bug_attachments_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.bug_attachments
    ADD CONSTRAINT bug_attachments_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES auth.users(id);


--
-- Name: bug_comments bug_comments_bug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.bug_comments
    ADD CONSTRAINT bug_comments_bug_id_fkey FOREIGN KEY (bug_id) REFERENCES public.bugs(id) ON DELETE CASCADE;


--
-- Name: bug_comments bug_comments_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.bug_comments
    ADD CONSTRAINT bug_comments_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: bugs bugs_assignee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.bugs
    ADD CONSTRAINT bugs_assignee_id_fkey FOREIGN KEY (assignee_id) REFERENCES auth.users(id) ON DELETE SET NULL;


--
-- Name: bugs bugs_reporter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.bugs
    ADD CONSTRAINT bugs_reporter_id_fkey FOREIGN KEY (reporter_id) REFERENCES auth.users(id);


--
-- Name: business_rules business_rules_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.business_rules
    ADD CONSTRAINT business_rules_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: business_rules business_rules_updated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.business_rules
    ADD CONSTRAINT business_rules_updated_by_fkey FOREIGN KEY (updated_by) REFERENCES auth.users(id);


--
-- Name: call_triggers call_triggers_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.call_triggers
    ADD CONSTRAINT call_triggers_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- Name: client_communication_timeline client_communication_timeline_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.client_communication_timeline
    ADD CONSTRAINT client_communication_timeline_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: client_communication_timeline client_communication_timeline_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.client_communication_timeline
    ADD CONSTRAINT client_communication_timeline_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: clients clients_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.clients
    ADD CONSTRAINT clients_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_partners company_partners_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.company_partners
    ADD CONSTRAINT company_partners_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id) ON DELETE CASCADE;


--
-- Name: company_partners company_partners_partner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.company_partners
    ADD CONSTRAINT company_partners_partner_id_fkey FOREIGN KEY (partner_id) REFERENCES public.partners(id) ON DELETE CASCADE;


--
-- Name: conversation_sessions conversation_sessions_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.conversation_sessions
    ADD CONSTRAINT conversation_sessions_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: department_instructions department_instructions_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.department_instructions
    ADD CONSTRAINT department_instructions_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payments(id) ON DELETE CASCADE;


--
-- Name: department_instructions department_instructions_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.department_instructions
    ADD CONSTRAINT department_instructions_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id) ON DELETE CASCADE;


--
-- Name: departments departments_parent_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.departments
    ADD CONSTRAINT departments_parent_department_id_fkey FOREIGN KEY (parent_department_id) REFERENCES public.departments(id);


--
-- Name: designations designations_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.designations
    ADD CONSTRAINT designations_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id) ON DELETE SET NULL;


--
-- Name: dynamic_menus dynamic_menus_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.dynamic_menus
    ADD CONSTRAINT dynamic_menus_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.dynamic_menus(id) ON DELETE CASCADE;


--
-- Name: employee_companies employee_companies_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_companies
    ADD CONSTRAINT employee_companies_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: employee_companies employee_companies_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_companies
    ADD CONSTRAINT employee_companies_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: employee_companies employee_companies_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_companies
    ADD CONSTRAINT employee_companies_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: employee_devices employee_devices_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employee_devices
    ADD CONSTRAINT employee_devices_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(employee_id);


--
-- Name: employees employees_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: employees employees_designation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_designation_id_fkey FOREIGN KEY (designation_id) REFERENCES public.designations(id);


--
-- Name: employees employees_home_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_home_branch_id_fkey FOREIGN KEY (home_branch_id) REFERENCES public.branches(id);


--
-- Name: employees employees_primary_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_primary_company_id_fkey FOREIGN KEY (primary_company_id) REFERENCES public.companies(id);


--
-- Name: employees employees_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT employees_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: ai_tasks fk_ai_tasks_assigned_to_employee; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.ai_tasks
    ADD CONSTRAINT fk_ai_tasks_assigned_to_employee FOREIGN KEY (assigned_to_employee_id) REFERENCES public.employees(id) ON DELETE SET NULL;


--
-- Name: lead_followups fk_lead_followups_lead_id; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_followups
    ADD CONSTRAINT fk_lead_followups_lead_id FOREIGN KEY (lead_id) REFERENCES public.leads(id) ON DELETE CASCADE;


--
-- Name: leads fk_lead_source; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT fk_lead_source FOREIGN KEY (lead_source_id) REFERENCES public.lead_sources(id);


--
-- Name: role_menu_permissions fk_menu_string_id; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_menu_permissions
    ADD CONSTRAINT fk_menu_string_id FOREIGN KEY (menu_string_id) REFERENCES public.menu_items(string_id);


--
-- Name: user_accounts fk_user_accounts_employee_id; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_accounts
    ADD CONSTRAINT fk_user_accounts_employee_id FOREIGN KEY (employee_id) REFERENCES public.employees(id) ON DELETE CASCADE;


--
-- Name: user_accounts fk_user_accounts_role_id; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_accounts
    ADD CONSTRAINT fk_user_accounts_role_id FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: follow_up_auditions follow_up_auditions_audition_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.follow_up_auditions
    ADD CONSTRAINT follow_up_auditions_audition_id_fkey FOREIGN KEY (audition_id) REFERENCES public.auditions(id) ON DELETE CASCADE;


--
-- Name: instruction_approvals instruction_approvals_instruction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.instruction_approvals
    ADD CONSTRAINT instruction_approvals_instruction_id_fkey FOREIGN KEY (instruction_id) REFERENCES public.department_instructions(id) ON DELETE CASCADE;


--
-- Name: lead_followups lead_followups_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.lead_followups
    ADD CONSTRAINT lead_followups_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: leads leads_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_branch_id_fkey FOREIGN KEY (branch_id) REFERENCES public.branches(id);


--
-- Name: leads leads_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_company_id_fkey FOREIGN KEY (company_id) REFERENCES public.companies(id);


--
-- Name: leads leads_reassigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_reassigned_by_fkey FOREIGN KEY (reassigned_by) REFERENCES public.employees(id);


--
-- Name: leads leads_reassigned_from_branch_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_reassigned_from_branch_id_fkey FOREIGN KEY (reassigned_from_branch_id) REFERENCES public.branches(id);


--
-- Name: leads leads_reassigned_from_company_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_reassigned_from_company_id_fkey FOREIGN KEY (reassigned_from_company_id) REFERENCES public.companies(id);


--
-- Name: management_insights management_insights_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.management_insights
    ADD CONSTRAINT management_insights_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.sales_team_members(employee_id);


--
-- Name: menu_items menu_items_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.menu_items
    ADD CONSTRAINT menu_items_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.menu_items(id);


--
-- Name: message_analysis message_analysis_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.message_analysis
    ADD CONSTRAINT message_analysis_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.whatsapp_messages(id) ON DELETE CASCADE;


--
-- Name: notification_engagement notification_engagement_notification_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_engagement
    ADD CONSTRAINT notification_engagement_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id) ON DELETE CASCADE;


--
-- Name: notification_engagement notification_engagement_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_engagement
    ADD CONSTRAINT notification_engagement_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: notification_preferences notification_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_preferences
    ADD CONSTRAINT notification_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: notification_recipients notification_recipients_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notification_recipients
    ADD CONSTRAINT notification_recipients_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: notifications notifications_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.employees(id);


--
-- Name: payments payments_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id) ON DELETE CASCADE;


--
-- Name: personalization_learning personalization_learning_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.personalization_learning
    ADD CONSTRAINT personalization_learning_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: post_sale_confirmations post_sale_confirmations_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sale_confirmations
    ADD CONSTRAINT post_sale_confirmations_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id) ON DELETE CASCADE;


--
-- Name: post_sales_workflows post_sales_workflows_instruction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sales_workflows
    ADD CONSTRAINT post_sales_workflows_instruction_id_fkey FOREIGN KEY (instruction_id) REFERENCES public.department_instructions(id) ON DELETE CASCADE;


--
-- Name: post_sales_workflows post_sales_workflows_payment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sales_workflows
    ADD CONSTRAINT post_sales_workflows_payment_id_fkey FOREIGN KEY (payment_id) REFERENCES public.payments(id) ON DELETE CASCADE;


--
-- Name: post_sales_workflows post_sales_workflows_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.post_sales_workflows
    ADD CONSTRAINT post_sales_workflows_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id) ON DELETE CASCADE;


--
-- Name: predictive_insights predictive_insights_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.predictive_insights
    ADD CONSTRAINT predictive_insights_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id);


--
-- Name: quotation_approvals quotation_approvals_approver_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_approvals
    ADD CONSTRAINT quotation_approvals_approver_employee_id_fkey FOREIGN KEY (approver_user_id) REFERENCES public.employees(id);


--
-- Name: quotation_approvals quotation_approvals_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_approvals
    ADD CONSTRAINT quotation_approvals_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id) ON DELETE CASCADE;


--
-- Name: quotation_business_lifecycle quotation_business_lifecycle_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_business_lifecycle
    ADD CONSTRAINT quotation_business_lifecycle_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: quotation_edit_approvals quotation_edit_approvals_approved_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_edit_approvals
    ADD CONSTRAINT quotation_edit_approvals_approved_by_fkey FOREIGN KEY (approved_by) REFERENCES public.employees(id);


--
-- Name: quotation_edit_approvals quotation_edit_approvals_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_edit_approvals
    ADD CONSTRAINT quotation_edit_approvals_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id) ON DELETE CASCADE;


--
-- Name: quotation_edit_approvals quotation_edit_approvals_requested_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_edit_approvals
    ADD CONSTRAINT quotation_edit_approvals_requested_by_fkey FOREIGN KEY (requested_by) REFERENCES public.employees(id);


--
-- Name: quotation_events quotation_events_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_events
    ADD CONSTRAINT quotation_events_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id) ON DELETE CASCADE;


--
-- Name: quotation_revisions quotation_revisions_original_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_revisions
    ADD CONSTRAINT quotation_revisions_original_quotation_id_fkey FOREIGN KEY (original_quotation_id) REFERENCES public.quotations(id) ON DELETE CASCADE;


--
-- Name: quotation_workflow_history quotation_workflow_history_performed_by_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_workflow_history
    ADD CONSTRAINT quotation_workflow_history_performed_by_employee_id_fkey FOREIGN KEY (performed_by) REFERENCES public.employees(id);


--
-- Name: quotation_workflow_history quotation_workflow_history_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotation_workflow_history
    ADD CONSTRAINT quotation_workflow_history_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id) ON DELETE CASCADE;


--
-- Name: quotations quotations_created_by_employee_id_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_created_by_employee_id_fkey1 FOREIGN KEY (created_by) REFERENCES public.employees(id);


--
-- Name: quotations quotations_follow_up_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_follow_up_id_fkey FOREIGN KEY (follow_up_id) REFERENCES public.lead_followups(id);


--
-- Name: quotations quotations_lead_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.quotations
    ADD CONSTRAINT quotations_lead_id_fkey FOREIGN KEY (lead_id) REFERENCES public.leads(id);


--
-- Name: role_permissions role_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.permissions(id) ON DELETE CASCADE;


--
-- Name: role_permissions role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: roles roles_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: sales_activities sales_activities_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_activities
    ADD CONSTRAINT sales_activities_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.sales_team_members(employee_id);


--
-- Name: sales_performance_metrics sales_performance_metrics_employee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sales_performance_metrics
    ADD CONSTRAINT sales_performance_metrics_employee_id_fkey FOREIGN KEY (employee_id) REFERENCES public.sales_team_members(employee_id);


--
-- Name: sequence_rules sequence_rules_sequence_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sequence_rules
    ADD CONSTRAINT sequence_rules_sequence_template_id_fkey FOREIGN KEY (sequence_template_id) REFERENCES public.task_sequence_templates(id) ON DELETE CASCADE;


--
-- Name: sequence_steps sequence_steps_sequence_template_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.sequence_steps
    ADD CONSTRAINT sequence_steps_sequence_template_id_fkey FOREIGN KEY (sequence_template_id) REFERENCES public.task_sequence_templates(id) ON DELETE CASCADE;


--
-- Name: team_members team_members_team_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.team_members
    ADD CONSTRAINT team_members_team_id_fkey FOREIGN KEY (team_id) REFERENCES public.teams(id);


--
-- Name: team_performance_trends team_performance_trends_top_performer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.team_performance_trends
    ADD CONSTRAINT team_performance_trends_top_performer_id_fkey FOREIGN KEY (top_performer_id) REFERENCES public.sales_team_members(employee_id);


--
-- Name: team_performance_trends team_performance_trends_underperformer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.team_performance_trends
    ADD CONSTRAINT team_performance_trends_underperformer_id_fkey FOREIGN KEY (underperformer_id) REFERENCES public.sales_team_members(employee_id);


--
-- Name: teams teams_department_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.teams
    ADD CONSTRAINT teams_department_id_fkey FOREIGN KEY (department_id) REFERENCES public.departments(id);


--
-- Name: unified_role_permissions unified_role_permissions_menu_string_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.unified_role_permissions
    ADD CONSTRAINT unified_role_permissions_menu_string_id_fkey FOREIGN KEY (menu_string_id) REFERENCES public.menu_items(string_id) ON DELETE CASCADE;


--
-- Name: unified_role_permissions unified_role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.unified_role_permissions
    ADD CONSTRAINT unified_role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_activity_history user_activity_history_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_activity_history
    ADD CONSTRAINT user_activity_history_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: user_ai_profiles user_ai_profiles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_ai_profiles
    ADD CONSTRAINT user_ai_profiles_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: user_behavior_analytics user_behavior_analytics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_behavior_analytics
    ADD CONSTRAINT user_behavior_analytics_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: user_engagement_analytics user_engagement_analytics_notification_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_engagement_analytics
    ADD CONSTRAINT user_engagement_analytics_notification_id_fkey FOREIGN KEY (notification_id) REFERENCES public.notifications(id);


--
-- Name: user_engagement_analytics user_engagement_analytics_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_engagement_analytics
    ADD CONSTRAINT user_engagement_analytics_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: user_id_mapping user_id_mapping_uuid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_id_mapping
    ADD CONSTRAINT user_id_mapping_uuid_fkey FOREIGN KEY (uuid) REFERENCES public.users(id);


--
-- Name: user_preferences user_preferences_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.user_preferences
    ADD CONSTRAINT user_preferences_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: whatsapp_messages whatsapp_messages_quotation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE ONLY public.whatsapp_messages
    ADD CONSTRAINT whatsapp_messages_quotation_id_fkey FOREIGN KEY (quotation_id) REFERENCES public.quotations(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: prefixes prefixes_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.prefixes
    ADD CONSTRAINT "prefixes_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: vikasalagarsamy
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: user_behavior_analytics Admins can access all AI data; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Admins can access all AI data" ON public.user_behavior_analytics USING ((EXISTS ( SELECT 1
   FROM auth.users
  WHERE ((users.id = auth.uid()) AND ((users.raw_user_meta_data ->> 'role'::text) = 'admin'::text)))));


--
-- Name: email_notification_templates Admins can manage email templates; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Admins can manage email templates" ON public.email_notification_templates USING (true);


--
-- Name: notification_rules Admins can manage notification rules; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Admins can manage notification rules" ON public.notification_rules USING (true);


--
-- Name: ai_tasks Allow all access to ai_tasks; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all access to ai_tasks" ON public.ai_tasks USING (true);


--
-- Name: lead_task_performance Allow all access to lead_task_performance; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all access to lead_task_performance" ON public.lead_task_performance USING (true);


--
-- Name: task_generation_log Allow all access to task_generation_log; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all access to task_generation_log" ON public.task_generation_log USING (true);


--
-- Name: task_performance_metrics Allow all access to task_performance_metrics; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all access to task_performance_metrics" ON public.task_performance_metrics USING (true);


--
-- Name: task_status_history Allow all access to task_status_history; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all access to task_status_history" ON public.task_status_history USING (true);


--
-- Name: quotation_predictions Allow all operations on AI/ML tables; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all operations on AI/ML tables" ON public.quotation_predictions USING (true);


--
-- Name: ml_model_performance Allow all operations on ML performance; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all operations on ML performance" ON public.ml_model_performance USING (true);


--
-- Name: action_recommendations Allow all operations on action recommendations; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all operations on action recommendations" ON public.action_recommendations USING (true);


--
-- Name: business_trends Allow all operations on business trends; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all operations on business trends" ON public.business_trends USING (true);


--
-- Name: client_insights Allow all operations on client insights; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all operations on client insights" ON public.client_insights USING (true);


--
-- Name: management_insights Allow all operations on management insights; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all operations on management insights" ON public.management_insights USING (true);


--
-- Name: revenue_forecasts Allow all operations on revenue forecasts; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all operations on revenue forecasts" ON public.revenue_forecasts USING (true);


--
-- Name: sales_activities Allow all operations on sales activities; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all operations on sales activities" ON public.sales_activities USING (true);


--
-- Name: sales_performance_metrics Allow all operations on sales performance metrics; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all operations on sales performance metrics" ON public.sales_performance_metrics USING (true);


--
-- Name: sales_team_members Allow all operations on sales team members; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all operations on sales team members" ON public.sales_team_members USING (true);


--
-- Name: team_performance_trends Allow all operations on team performance trends; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow all operations on team performance trends" ON public.team_performance_trends USING (true);


--
-- Name: business_rules Allow authenticated users to read business rules; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Allow authenticated users to read business rules" ON public.business_rules FOR SELECT USING ((auth.role() = 'authenticated'::text));


--
-- Name: quotation_edit_approvals Approvers can update requests; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Approvers can update requests" ON public.quotation_edit_approvals FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM (public.employees e
     JOIN public.user_accounts ua ON ((e.id = ua.employee_id)))
  WHERE ((ua.id = ((auth.uid())::text)::integer) AND ((e.job_title)::text = ANY (ARRAY[('Sales Head'::character varying)::text, ('Administrator'::character varying)::text]))))));


--
-- Name: quotation_edit_approvals Authorized users can approve edit requests; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Authorized users can approve edit requests" ON public.quotation_edit_approvals FOR UPDATE USING ((EXISTS ( SELECT 1
   FROM ((public.user_accounts ua
     JOIN public.employees e ON ((ua.employee_id = e.id)))
     JOIN public.roles r ON ((ua.role_id = r.id)))
  WHERE ((ua.id = ((auth.uid())::text)::integer) AND ((r.title)::text = ANY (ARRAY[('Sales Head'::character varying)::text, ('Administrator'::character varying)::text]))))));


--
-- Name: notifications System can insert notifications; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "System can insert notifications" ON public.notifications FOR INSERT WITH CHECK (true);


--
-- Name: notifications System insert notifications; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "System insert notifications" ON public.notifications FOR INSERT WITH CHECK (true);


--
-- Name: quotation_edit_approvals Users can create edit requests; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Users can create edit requests" ON public.quotation_edit_approvals FOR INSERT WITH CHECK ((requested_by IN ( SELECT e.id
   FROM (public.employees e
     JOIN public.user_accounts ua ON ((e.id = ua.employee_id)))
  WHERE (ua.id = ((auth.uid())::text)::integer))));


--
-- Name: notification_settings Users can manage own notification settings; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Users can manage own notification settings" ON public.notification_settings USING (((user_id)::text = (auth.jwt() ->> 'sub'::text)));


--
-- Name: user_behavior_analytics Users can update their own behavior analytics; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Users can update their own behavior analytics" ON public.user_behavior_analytics FOR UPDATE USING ((auth.uid() = user_id));


--
-- Name: quotation_edit_approvals Users can view own edit requests; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Users can view own edit requests" ON public.quotation_edit_approvals FOR SELECT USING (((requested_by IN ( SELECT e.id
   FROM (public.employees e
     JOIN public.user_accounts ua ON ((e.id = ua.employee_id)))
  WHERE (ua.id = ((auth.uid())::text)::integer))) OR (EXISTS ( SELECT 1
   FROM (public.employees e
     JOIN public.user_accounts ua ON ((e.id = ua.employee_id)))
  WHERE ((ua.id = ((auth.uid())::text)::integer) AND ((e.job_title)::text = ANY (ARRAY[('Sales Head'::character varying)::text, ('Administrator'::character varying)::text])))))));


--
-- Name: user_activity_history Users can view their own activity history; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Users can view their own activity history" ON public.user_activity_history FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: user_behavior_analytics Users can view their own behavior analytics; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Users can view their own behavior analytics" ON public.user_behavior_analytics FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: notification_engagement Users can view their own engagement data; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Users can view their own engagement data" ON public.notification_engagement FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: predictive_insights Users can view their own predictive insights; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Users can view their own predictive insights" ON public.predictive_insights FOR SELECT USING ((auth.uid() = user_id));


--
-- Name: user_preferences Users can view their own preferences; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY "Users can view their own preferences" ON public.user_preferences USING ((auth.uid() = user_id));


--
-- Name: accounting_workflows; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.accounting_workflows ENABLE ROW LEVEL SECURITY;

--
-- Name: action_recommendations; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.action_recommendations ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_tasks; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.ai_tasks ENABLE ROW LEVEL SECURITY;

--
-- Name: business_rules; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.business_rules ENABLE ROW LEVEL SECURITY;

--
-- Name: business_trends; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.business_trends ENABLE ROW LEVEL SECURITY;

--
-- Name: client_insights; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.client_insights ENABLE ROW LEVEL SECURITY;

--
-- Name: department_instructions; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.department_instructions ENABLE ROW LEVEL SECURITY;

--
-- Name: email_notification_templates; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.email_notification_templates ENABLE ROW LEVEL SECURITY;

--
-- Name: instruction_approvals; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.instruction_approvals ENABLE ROW LEVEL SECURITY;

--
-- Name: lead_task_performance; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.lead_task_performance ENABLE ROW LEVEL SECURITY;

--
-- Name: management_insights; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.management_insights ENABLE ROW LEVEL SECURITY;

--
-- Name: ml_model_performance; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.ml_model_performance ENABLE ROW LEVEL SECURITY;

--
-- Name: notification_engagement; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.notification_engagement ENABLE ROW LEVEL SECURITY;

--
-- Name: notification_rules; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.notification_rules ENABLE ROW LEVEL SECURITY;

--
-- Name: notification_settings; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.notification_settings ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.notifications ENABLE ROW LEVEL SECURITY;

--
-- Name: notifications notifications_admin_access; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY notifications_admin_access ON public.notifications USING ((public.current_user_role() = ANY (ARRAY['Administrator'::text, 'Sales Head'::text])));


--
-- Name: payments; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.payments ENABLE ROW LEVEL SECURITY;

--
-- Name: post_sales_workflows; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.post_sales_workflows ENABLE ROW LEVEL SECURITY;

--
-- Name: predictive_insights; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.predictive_insights ENABLE ROW LEVEL SECURITY;

--
-- Name: quotation_edit_approvals; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.quotation_edit_approvals ENABLE ROW LEVEL SECURITY;

--
-- Name: quotation_predictions; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.quotation_predictions ENABLE ROW LEVEL SECURITY;

--
-- Name: quotation_revisions; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.quotation_revisions ENABLE ROW LEVEL SECURITY;

--
-- Name: revenue_forecasts; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.revenue_forecasts ENABLE ROW LEVEL SECURITY;

--
-- Name: sales_activities; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.sales_activities ENABLE ROW LEVEL SECURITY;

--
-- Name: sales_performance_metrics; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.sales_performance_metrics ENABLE ROW LEVEL SECURITY;

--
-- Name: sales_team_members; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.sales_team_members ENABLE ROW LEVEL SECURITY;

--
-- Name: task_generation_log; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.task_generation_log ENABLE ROW LEVEL SECURITY;

--
-- Name: task_performance_metrics; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.task_performance_metrics ENABLE ROW LEVEL SECURITY;

--
-- Name: task_status_history; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.task_status_history ENABLE ROW LEVEL SECURITY;

--
-- Name: team_performance_trends; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.team_performance_trends ENABLE ROW LEVEL SECURITY;

--
-- Name: user_activity_history; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.user_activity_history ENABLE ROW LEVEL SECURITY;

--
-- Name: user_behavior_analytics; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.user_behavior_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: user_preferences; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.user_preferences ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: public; Owner: vikasalagarsamy
--

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

--
-- Name: users users_select_own; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY users_select_own ON public.users FOR SELECT USING ((auth.uid() = id));


--
-- Name: users users_update_own; Type: POLICY; Schema: public; Owner: vikasalagarsamy
--

CREATE POLICY users_update_own ON public.users FOR UPDATE USING ((auth.uid() = id));


--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: vikasalagarsamy
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: prefixes; Type: ROW SECURITY; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE storage.prefixes ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: vikasalagarsamy
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: vikasalagarsamy
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO vikasalagarsamy;

--
-- Name: supabase_realtime_messages_publication; Type: PUBLICATION; Schema: -; Owner: vikasalagarsamy
--

CREATE PUBLICATION supabase_realtime_messages_publication WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime_messages_publication OWNER TO vikasalagarsamy;

--
-- Name: supabase_realtime_messages_publication messages; Type: PUBLICATION TABLE; Schema: realtime; Owner: vikasalagarsamy
--

ALTER PUBLICATION supabase_realtime_messages_publication ADD TABLE ONLY realtime.messages;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: vikasalagarsamy
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: vikasalagarsamy
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;


--
-- Name: TABLE recent_business_notifications; Type: ACL; Schema: public; Owner: vikasalagarsamy
--

GRANT SELECT ON TABLE public.recent_business_notifications TO PUBLIC;


--
-- Name: TABLE user_notification_summary; Type: ACL; Schema: public; Owner: vikasalagarsamy
--

GRANT SELECT ON TABLE public.user_notification_summary TO PUBLIC;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: vikasalagarsamy
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO vikasalagarsamy;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: vikasalagarsamy
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO vikasalagarsamy;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: vikasalagarsamy
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO vikasalagarsamy;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: vikasalagarsamy
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO vikasalagarsamy;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: vikasalagarsamy
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO vikasalagarsamy;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: vikasalagarsamy
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO vikasalagarsamy;

--
-- PostgreSQL database dump complete
--

